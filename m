Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56409 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1AUVTg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 16:19:36 -0500
Received: by fxm20 with SMTP id 20so2228402fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 13:19:35 -0800 (PST)
From: Marek Vasut <marek.vasut@gmail.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Subject: Re: [PATCH 1/3] libertas_spi: Use workqueue in hw_host_to_card
Date: Fri, 21 Jan 2011 22:22:37 +0100
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>
References: <1295642690-16646-1-git-send-email-anarsoul@gmail.com> <1295642690-16646-2-git-send-email-anarsoul@gmail.com>
In-Reply-To: <1295642690-16646-2-git-send-email-anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Message-Id: <201101212222.37667.marek.vasut@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 21 January 2011 21:44:48 Vasily Khoruzhick wrote:
> Use workqueue to perform SPI xfers, it's necessary to fix
> nasty "BUG: scheduling while atomic", because
> spu_write() calls spi_sync() and spi_sync() may sleep, but
> hw_host_to_card() callback can be called from atomic context.
> Remove kthread completely, workqueue now does its job.
> Restore intermediate buffers which were removed in commit
> 86c34fe89e9cad9e1ba4d1a8bbf98259035f4caf that introduced
> mentioned bug.

I have two questions:

1) Why not leave kthread there? ie. why switch to workqueue
2) This should be split into two patches I guess -- a) revert the change b) 
convert to workqueue -- so they can be (N)ACKed separatedly

Cheers
> 
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> ---
>  drivers/net/wireless/libertas/if_spi.c |  368
> +++++++++++++++++++++----------- 1 files changed, 239 insertions(+), 129
> deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_spi.c
> b/drivers/net/wireless/libertas/if_spi.c index 0060023..f6c2cd6 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -20,10 +20,8 @@
>  #include <linux/moduleparam.h>
>  #include <linux/firmware.h>
>  #include <linux/jiffies.h>
> -#include <linux/kthread.h>
>  #include <linux/list.h>
>  #include <linux/netdevice.h>
> -#include <linux/semaphore.h>
>  #include <linux/slab.h>
>  #include <linux/spi/libertas_spi.h>
>  #include <linux/spi/spi.h>
> @@ -34,6 +32,12 @@
>  #include "dev.h"
>  #include "if_spi.h"
> 
> +struct if_spi_packet {
> +	struct list_head		list;
> +	u16				blen;
> +	u8				buffer[0] __attribute__((aligned(4)));
> +};
> +
>  struct if_spi_card {
>  	struct spi_device		*spi;
>  	struct lbs_private		*priv;
> @@ -51,18 +55,36 @@ struct if_spi_card {
>  	unsigned long			spu_reg_delay;
> 
>  	/* Handles all SPI communication (except for FW load) */
> -	struct task_struct		*spi_thread;
> -	int				run_thread;
> -
> -	/* Used to wake up the spi_thread */
> -	struct semaphore		spi_ready;
> -	struct semaphore		spi_thread_terminated;
> +	struct workqueue_struct		*workqueue;
> +	struct work_struct		packet_work;
> 
>  	u8				cmd_buffer[IF_SPI_CMD_BUF_SIZE];
> +
> +	/* A buffer of incoming packets from libertas core.
> +	 * Since we can't sleep in hw_host_to_card, we have to buffer
> +	 * them. */
> +	struct list_head		cmd_packet_list;
> +	struct list_head		data_packet_list;
> +
> +	/* Protects cmd_packet_list and data_packet_list */
> +	spinlock_t			buffer_lock;
>  };
> 
>  static void free_if_spi_card(struct if_spi_card *card)
>  {
> +	struct list_head *cursor, *next;
> +	struct if_spi_packet *packet;
> +
> +	list_for_each_safe(cursor, next, &card->cmd_packet_list) {
> +		packet = container_of(cursor, struct if_spi_packet, list);
> +		list_del(&packet->list);
> +		kfree(packet);
> +	}
> +	list_for_each_safe(cursor, next, &card->data_packet_list) {
> +		packet = container_of(cursor, struct if_spi_packet, list);
> +		list_del(&packet->list);
> +		kfree(packet);
> +	}
>  	spi_set_drvdata(card->spi, NULL);
>  	kfree(card);
>  }
> @@ -622,7 +644,7 @@ out:
>  /*
>   * SPI Transfer Thread
>   *
> - * The SPI thread handles all SPI transfers, so there is no need for a
> lock. + * The SPI worker handles all SPI transfers, so there is no need
> for a lock. */
> 
>  /* Move a command from the card to the host */
> @@ -742,6 +764,40 @@ out:
>  	return err;
>  }
> 
> +/* Move data or a command from the host to the card. */
> +static void if_spi_h2c(struct if_spi_card *card,
> +			struct if_spi_packet *packet, int type)
> +{
> +	int err = 0;
> +	u16 int_type, port_reg;
> +
> +	switch (type) {
> +	case MVMS_DAT:
> +		int_type = IF_SPI_CIC_TX_DOWNLOAD_OVER;
> +		port_reg = IF_SPI_DATA_RDWRPORT_REG;
> +		break;
> +	case MVMS_CMD:
> +		int_type = IF_SPI_CIC_CMD_DOWNLOAD_OVER;
> +		port_reg = IF_SPI_CMD_RDWRPORT_REG;
> +		break;
> +	default:
> +		lbs_pr_err("can't transfer buffer of type %d\n", type);
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* Write the data to the card */
> +	err = spu_write(card, port_reg, packet->buffer, packet->blen);
> +	if (err)
> +		goto out;
> +
> +out:
> +	kfree(packet);
> +
> +	if (err)
> +		lbs_pr_err("%s: error %d\n", __func__, err);
> +}
> +
>  /* Inform the host about a card event */
>  static void if_spi_e2h(struct if_spi_card *card)
>  {
> @@ -766,71 +822,88 @@ out:
>  		lbs_pr_err("%s: error %d\n", __func__, err);
>  }
> 
> -static int lbs_spi_thread(void *data)
> +static void if_spi_host_to_card_worker(struct work_struct *work)
>  {
>  	int err;
> -	struct if_spi_card *card = data;
> +	struct if_spi_card *card;
>  	u16 hiStatus;
> +	unsigned long flags;
> +	struct if_spi_packet *packet;
> 
> -	while (1) {
> -		/* Wait to be woken up by one of two things.  First, our ISR
> -		 * could tell us that something happened on the WLAN.
> -		 * Secondly, libertas could call hw_host_to_card with more
> -		 * data, which we might be able to send.
> -		 */
> -		do {
> -			err = down_interruptible(&card->spi_ready);
> -			if (!card->run_thread) {
> -				up(&card->spi_thread_terminated);
> -				do_exit(0);
> -			}
> -		} while (err == -EINTR);
> +	card = container_of(work, struct if_spi_card, packet_work);
> 
> -		/* Read the host interrupt status register to see what we
> -		 * can do. */
> -		err = spu_read_u16(card, IF_SPI_HOST_INT_STATUS_REG,
> -					&hiStatus);
> -		if (err) {
> -			lbs_pr_err("I/O error\n");
> +	lbs_deb_enter(LBS_DEB_SPI);
> +
> +	/* Read the host interrupt status register to see what we
> +	 * can do. */
> +	err = spu_read_u16(card, IF_SPI_HOST_INT_STATUS_REG,
> +				&hiStatus);
> +	if (err) {
> +		lbs_pr_err("I/O error\n");
> +		goto err;
> +	}
> +
> +	if (hiStatus & IF_SPI_HIST_CMD_UPLOAD_RDY) {
> +		err = if_spi_c2h_cmd(card);
> +		if (err)
>  			goto err;
> -		}
> +	}
> +	if (hiStatus & IF_SPI_HIST_RX_UPLOAD_RDY) {
> +		err = if_spi_c2h_data(card);
> +		if (err)
> +			goto err;
> +	}
> 
> -		if (hiStatus & IF_SPI_HIST_CMD_UPLOAD_RDY) {
> -			err = if_spi_c2h_cmd(card);
> -			if (err)
> -				goto err;
> -		}
> -		if (hiStatus & IF_SPI_HIST_RX_UPLOAD_RDY) {
> -			err = if_spi_c2h_data(card);
> -			if (err)
> -				goto err;
> +	/* workaround: in PS mode, the card does not set the Command
> +	 * Download Ready bit, but it sets TX Download Ready. */
> +	if (hiStatus & IF_SPI_HIST_CMD_DOWNLOAD_RDY ||
> +	   (card->priv->psstate != PS_STATE_FULL_POWER &&
> +	    (hiStatus & IF_SPI_HIST_TX_DOWNLOAD_RDY))) {
> +		/* This means two things. First of all,
> +		 * if there was a previous command sent, the card has
> +		 * successfully received it.
> +		 * Secondly, it is now ready to download another
> +		 * command.
> +		 */
> +		lbs_host_to_card_done(card->priv);
> +
> +		/* Do we have any command packets from the host to
> +		 * send? */
> +		packet = NULL;
> +		spin_lock_irqsave(&card->buffer_lock, flags);
> +		if (!list_empty(&card->cmd_packet_list)) {
> +			packet = (struct if_spi_packet *)(card->
> +					cmd_packet_list.next);
> +			list_del(&packet->list);
>  		}
> +		spin_unlock_irqrestore(&card->buffer_lock, flags);
> 
> -		/* workaround: in PS mode, the card does not set the Command
> -		 * Download Ready bit, but it sets TX Download Ready. */
> -		if (hiStatus & IF_SPI_HIST_CMD_DOWNLOAD_RDY ||
> -		   (card->priv->psstate != PS_STATE_FULL_POWER &&
> -		    (hiStatus & IF_SPI_HIST_TX_DOWNLOAD_RDY))) {
> -			lbs_host_to_card_done(card->priv);
> +		if (packet)
> +			if_spi_h2c(card, packet, MVMS_CMD);
> +	}
> +	if (hiStatus & IF_SPI_HIST_TX_DOWNLOAD_RDY) {
> +		/* Do we have any data packets from the host to
> +		 * send? */
> +		packet = NULL;
> +		spin_lock_irqsave(&card->buffer_lock, flags);
> +		if (!list_empty(&card->data_packet_list)) {
> +			packet = (struct if_spi_packet *)(card->
> +					data_packet_list.next);
> +			list_del(&packet->list);
>  		}
> +		spin_unlock_irqrestore(&card->buffer_lock, flags);
> 
> -		if (hiStatus & IF_SPI_HIST_CARD_EVENT)
> -			if_spi_e2h(card);
> +		if (packet)
> +			if_spi_h2c(card, packet, MVMS_DAT);
> +	}
> +	if (hiStatus & IF_SPI_HIST_CARD_EVENT)
> +		if_spi_e2h(card);
> 
>  err:
> -		if (err)
> -			lbs_pr_err("%s: got error %d\n", __func__, err);
> -	}
> -}
> +	if (err)
> +		lbs_pr_err("%s: got error %d\n", __func__, err);
> 
> -/* Block until lbs_spi_thread thread has terminated */
> -static void if_spi_terminate_spi_thread(struct if_spi_card *card)
> -{
> -	/* It would be nice to use kthread_stop here, but that function
> -	 * can't wake threads waiting for a semaphore. */
> -	card->run_thread = 0;
> -	up(&card->spi_ready);
> -	down(&card->spi_thread_terminated);
> +	lbs_deb_leave(LBS_DEB_SPI);
>  }
> 
>  /*
> @@ -842,18 +915,40 @@ static int if_spi_host_to_card(struct lbs_private
> *priv, u8 type, u8 *buf, u16 nb)
>  {
>  	int err = 0;
> +	unsigned long flags;
>  	struct if_spi_card *card = priv->card;
> +	struct if_spi_packet *packet;
> +	u16 blen;
> 
>  	lbs_deb_enter_args(LBS_DEB_SPI, "type %d, bytes %d", type, nb);
> 
> -	nb = ALIGN(nb, 4);
> +	if (nb == 0) {
> +		lbs_pr_err("%s: invalid size requested: %d\n", __func__, nb);
> +		err = -EINVAL;
> +		goto out;
> +	}
> +	blen = ALIGN(nb, 4);
> +	packet = kzalloc(sizeof(struct if_spi_packet) + blen, GFP_ATOMIC);
> +	if (!packet) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +	packet->blen = blen;
> +	memcpy(packet->buffer, buf, nb);
> +	memset(packet->buffer + nb, 0, blen - nb);
> 
>  	switch (type) {
>  	case MVMS_CMD:
> -		err = spu_write(card, IF_SPI_CMD_RDWRPORT_REG, buf, nb);
> +		priv->dnld_sent = DNLD_CMD_SENT;
> +		spin_lock_irqsave(&card->buffer_lock, flags);
> +		list_add_tail(&packet->list, &card->cmd_packet_list);
> +		spin_unlock_irqrestore(&card->buffer_lock, flags);
>  		break;
>  	case MVMS_DAT:
> -		err = spu_write(card, IF_SPI_DATA_RDWRPORT_REG, buf, nb);
> +		priv->dnld_sent = DNLD_DATA_SENT;
> +		spin_lock_irqsave(&card->buffer_lock, flags);
> +		list_add_tail(&packet->list, &card->data_packet_list);
> +		spin_unlock_irqrestore(&card->buffer_lock, flags);
>  		break;
>  	default:
>  		lbs_pr_err("can't transfer buffer of type %d", type);
> @@ -861,6 +956,9 @@ static int if_spi_host_to_card(struct lbs_private
> *priv, break;
>  	}
> 
> +	/* Queue spi xfer work */
> +	queue_work(card->workqueue, &card->packet_work);
> +out:
>  	lbs_deb_leave_args(LBS_DEB_SPI, "err=%d", err);
>  	return err;
>  }
> @@ -869,13 +967,14 @@ static int if_spi_host_to_card(struct lbs_private
> *priv, * Host Interrupts
>   *
>   * Service incoming interrupts from the WLAN device. We can't sleep here,
> so - * don't try to talk on the SPI bus, just wake up the SPI thread. + *
> don't try to talk on the SPI bus, just queue the SPI xfer work. */
>  static irqreturn_t if_spi_host_interrupt(int irq, void *dev_id)
>  {
>  	struct if_spi_card *card = dev_id;
> 
> -	up(&card->spi_ready);
> +	queue_work(card->workqueue, &card->packet_work);
> +
>  	return IRQ_HANDLED;
>  }
> 
> @@ -883,56 +982,26 @@ static irqreturn_t if_spi_host_interrupt(int irq,
> void *dev_id) * SPI callbacks
>   */
> 
> -static int __devinit if_spi_probe(struct spi_device *spi)
> +static int if_spi_init_card(struct if_spi_card *card)
>  {
> -	struct if_spi_card *card;
> -	struct lbs_private *priv = NULL;
> -	struct libertas_spi_platform_data *pdata = spi->dev.platform_data;
> -	int err = 0, i;
> +	struct spi_device *spi = card->spi;
> +	int err, i;
>  	u32 scratch;
> -	struct sched_param param = { .sched_priority = 1 };
>  	const struct firmware *helper = NULL;
>  	const struct firmware *mainfw = NULL;
> 
>  	lbs_deb_enter(LBS_DEB_SPI);
> 
> -	if (!pdata) {
> -		err = -EINVAL;
> -		goto out;
> -	}
> -
> -	if (pdata->setup) {
> -		err = pdata->setup(spi);
> -		if (err)
> -			goto out;
> -	}
> -
> -	/* Allocate card structure to represent this specific device */
> -	card = kzalloc(sizeof(struct if_spi_card), GFP_KERNEL);
> -	if (!card) {
> -		err = -ENOMEM;
> -		goto out;
> -	}
> -	spi_set_drvdata(spi, card);
> -	card->pdata = pdata;
> -	card->spi = spi;
> -	card->prev_xfer_time = jiffies;
> -
> -	sema_init(&card->spi_ready, 0);
> -	sema_init(&card->spi_thread_terminated, 0);
> -
> -	/* Initialize the SPI Interface Unit */
> -	err = spu_init(card, pdata->use_dummy_writes);
> +	err = spu_init(card, card->pdata->use_dummy_writes);
>  	if (err)
> -		goto free_card;
> +		goto out;
>  	err = spu_get_chip_revision(card, &card->card_id, &card->card_rev);
>  	if (err)
> -		goto free_card;
> +		goto out;
> 
> -	/* Firmware load */
>  	err = spu_read_u32(card, IF_SPI_SCRATCH_4_REG, &scratch);
>  	if (err)
> -		goto free_card;
> +		goto out;
>  	if (scratch == SUCCESSFUL_FW_DOWNLOAD_MAGIC)
>  		lbs_deb_spi("Firmware is already loaded for "
>  			    "Marvell WLAN 802.11 adapter\n");
> @@ -946,7 +1015,7 @@ static int __devinit if_spi_probe(struct spi_device
> *spi) lbs_pr_err("Unsupported chip_id: 0x%02x\n",
>  					card->card_id);
>  			err = -ENODEV;
> -			goto free_card;
> +			goto out;
>  		}
> 
>  		err = lbs_get_firmware(&card->spi->dev, NULL, NULL,
> @@ -954,7 +1023,7 @@ static int __devinit if_spi_probe(struct spi_device
> *spi) &mainfw);
>  		if (err) {
>  			lbs_pr_err("failed to find firmware (%d)\n", err);
> -			goto free_card;
> +			goto out;
>  		}
> 
>  		lbs_deb_spi("Initializing FW for Marvell WLAN 802.11 adapter "
> @@ -966,15 +1035,68 @@ static int __devinit if_spi_probe(struct spi_device
> *spi) spi->max_speed_hz);
>  		err = if_spi_prog_helper_firmware(card, helper);
>  		if (err)
> -			goto free_card;
> +			goto out;
>  		err = if_spi_prog_main_firmware(card, mainfw);
>  		if (err)
> -			goto free_card;
> +			goto out;
>  		lbs_deb_spi("loaded FW for Marvell WLAN 802.11 adapter\n");
>  	}
> 
>  	err = spu_set_interrupt_mode(card, 0, 1);
>  	if (err)
> +		goto out;
> +
> +out:
> +	if (helper)
> +		release_firmware(helper);
> +	if (mainfw)
> +		release_firmware(mainfw);
> +
> +	lbs_deb_leave_args(LBS_DEB_SPI, "err %d\n", err);
> +
> +	return err;
> +}
> +
> +static int __devinit if_spi_probe(struct spi_device *spi)
> +{
> +	struct if_spi_card *card;
> +	struct lbs_private *priv = NULL;
> +	struct libertas_spi_platform_data *pdata = spi->dev.platform_data;
> +	int err = 0;
> +
> +	lbs_deb_enter(LBS_DEB_SPI);
> +
> +	if (!pdata) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (pdata->setup) {
> +		err = pdata->setup(spi);
> +		if (err)
> +			goto out;
> +	}
> +
> +	/* Allocate card structure to represent this specific device */
> +	card = kzalloc(sizeof(struct if_spi_card), GFP_KERNEL);
> +	if (!card) {
> +		err = -ENOMEM;
> +		goto teardown;
> +	}
> +	spi_set_drvdata(spi, card);
> +	card->pdata = pdata;
> +	card->spi = spi;
> +	card->prev_xfer_time = jiffies;
> +
> +	INIT_LIST_HEAD(&card->cmd_packet_list);
> +	INIT_LIST_HEAD(&card->data_packet_list);
> +	spin_lock_init(&card->buffer_lock);
> +
> +	/* Initialize the SPI Interface Unit */
> +
> +	/* Firmware load */
> +	err = if_spi_init_card(card);
> +	if (err)
>  		goto free_card;
> 
>  	/* Register our card with libertas.
> @@ -993,27 +1115,16 @@ static int __devinit if_spi_probe(struct spi_device
> *spi) priv->fw_ready = 1;
> 
>  	/* Initialize interrupt handling stuff. */
> -	card->run_thread = 1;
> -	card->spi_thread = kthread_run(lbs_spi_thread, card, "lbs_spi_thread");
> -	if (IS_ERR(card->spi_thread)) {
> -		card->run_thread = 0;
> -		err = PTR_ERR(card->spi_thread);
> -		lbs_pr_err("error creating SPI thread: err=%d\n", err);
> -		goto remove_card;
> -	}
> -	if (sched_setscheduler(card->spi_thread, SCHED_FIFO, &param))
> -		lbs_pr_err("Error setting scheduler, using default.\n");
> +	card->workqueue = create_workqueue("libertas_spi");
> +	INIT_WORK(&card->packet_work, if_spi_host_to_card_worker);
> 
>  	err = request_irq(spi->irq, if_spi_host_interrupt,
>  			IRQF_TRIGGER_FALLING, "libertas_spi", card);
>  	if (err) {
>  		lbs_pr_err("can't get host irq line-- request_irq failed\n");
> -		goto terminate_thread;
> +		goto terminate_workqueue;
>  	}
> 
> -	/* poke the IRQ handler so that we don't miss the first interrupt */
> -	up(&card->spi_ready);
> -
>  	/* Start the card.
>  	 * This will call register_netdev, and we'll start
>  	 * getting interrupts... */
> @@ -1028,18 +1139,16 @@ static int __devinit if_spi_probe(struct spi_device
> *spi)
> 
>  release_irq:
>  	free_irq(spi->irq, card);
> -terminate_thread:
> -	if_spi_terminate_spi_thread(card);
> -remove_card:
> +terminate_workqueue:
> +	flush_workqueue(card->workqueue);
> +	destroy_workqueue(card->workqueue);
>  	lbs_remove_card(priv); /* will call free_netdev */
>  free_card:
>  	free_if_spi_card(card);
> +teardown:
> +	if (pdata->teardown)
> +		pdata->teardown(spi);
>  out:
> -	if (helper)
> -		release_firmware(helper);
> -	if (mainfw)
> -		release_firmware(mainfw);
> -
>  	lbs_deb_leave_args(LBS_DEB_SPI, "err %d\n", err);
>  	return err;
>  }
> @@ -1056,7 +1165,8 @@ static int __devexit libertas_spi_remove(struct
> spi_device *spi) lbs_remove_card(priv); /* will call free_netdev */
> 
>  	free_irq(spi->irq, card);
> -	if_spi_terminate_spi_thread(card);
> +	flush_workqueue(card->workqueue);
> +	destroy_workqueue(card->workqueue);
>  	if (card->pdata->teardown)
>  		card->pdata->teardown(spi);
>  	free_if_spi_card(card);
