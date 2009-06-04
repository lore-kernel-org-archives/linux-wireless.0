Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42444 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbZFDULi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 16:11:38 -0400
Subject: Re: [PATCH v3] net/libertas: remove GPIO-CS handling in SPI
 interface code
From: Dan Williams <dcbw@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Andrey Yurovsky <andrey@cozybit.com>
In-Reply-To: <20090604195703.GA27495@www.tglx.de>
References: <20090604195703.GA27495@www.tglx.de>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 16:11:00 -0400
Message-Id: <1244146260.2487.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-06-04 at 21:57 +0200, Sebastian Andrzej Siewior wrote:
> This removes the dependency on GPIO framework and lets the SPI host
> driver handle the chip select. The SPI host driver is required to keep
> the CS active for the entire message unless cs_change says otherwise.
> This patch collects the two/three single SPI transfers into a message.
> Also the delay in read path in case use_dummy_writes are not used is
> moved into the SPI host driver.
> 
> Tested-by: Mike Rapoport <mike@compulab.co.il>
> Tested-by: Andrey Yurovsky <andrey@cozybit.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Yay!  Fewer hardware deps == better :)

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> v2..v3:
>  removed unused gpio_cs from libertas_spi_platform_data 
> 
> v1..v2:
> +   reg_trans.delay_usecs = (100 + (delay * 10)) / 1000;
>  with
> +   reg_trans.delay_usecs =
> +       DIV_ROUND_UP((100 + (delay * 10)), 1000);
> The latter should not end up with delay_usecs = 0 if delay is < 90
> 
>  drivers/net/wireless/Kconfig           |    2 +-
>  drivers/net/wireless/libertas/if_spi.c |   92 +++++++++++++++-----------------
>  include/linux/spi/libertas_spi.h       |    3 -
>  3 files changed, 45 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index daf4c80..fb7541c 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -153,7 +153,7 @@ config LIBERTAS_SDIO
>  
>  config LIBERTAS_SPI
>  	tristate "Marvell Libertas 8686 SPI 802.11b/g cards"
> -	depends on LIBERTAS && SPI && GENERIC_GPIO
> +	depends on LIBERTAS && SPI
>  	---help---
>  	  A driver for Marvell Libertas 8686 SPI devices.
>  
> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> index ea23c5d..f8c2898 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -19,7 +19,6 @@
>  
>  #include <linux/moduleparam.h>
>  #include <linux/firmware.h>
> -#include <linux/gpio.h>
>  #include <linux/jiffies.h>
>  #include <linux/kthread.h>
>  #include <linux/list.h>
> @@ -51,13 +50,6 @@ struct if_spi_card {
>  	u16				card_id;
>  	u8				card_rev;
>  
> -	/* Pin number for our GPIO chip-select. */
> -	/* TODO: Once the generic SPI layer has some additional features, we
> -	 * should take this out and use the normal chip select here.
> -	 * We need support for chip select delays, and not dropping chipselect
> -	 * after each word. */
> -	int				gpio_cs;
> -
>  	/* The last time that we initiated an SPU operation */
>  	unsigned long			prev_xfer_time;
>  
> @@ -130,12 +122,10 @@ static void spu_transaction_init(struct if_spi_card *card)
>  		 * If not, we have to busy-wait to be on the safe side. */
>  		ndelay(400);
>  	}
> -	gpio_set_value(card->gpio_cs, 0); /* assert CS */
>  }
>  
>  static void spu_transaction_finish(struct if_spi_card *card)
>  {
> -	gpio_set_value(card->gpio_cs, 1); /* drop CS */
>  	card->prev_xfer_time = jiffies;
>  }
>  
> @@ -145,6 +135,13 @@ static int spu_write(struct if_spi_card *card, u16 reg, const u8 *buf, int len)
>  {
>  	int err = 0;
>  	u16 reg_out = cpu_to_le16(reg | IF_SPI_WRITE_OPERATION_MASK);
> +	struct spi_message m;
> +	struct spi_transfer reg_trans;
> +	struct spi_transfer data_trans;
> +
> +	spi_message_init(&m);
> +	memset(&reg_trans, 0, sizeof(reg_trans));
> +	memset(&data_trans, 0, sizeof(data_trans));
>  
>  	/* You must give an even number of bytes to the SPU, even if it
>  	 * doesn't care about the last one.  */
> @@ -153,13 +150,16 @@ static int spu_write(struct if_spi_card *card, u16 reg, const u8 *buf, int len)
>  	spu_transaction_init(card);
>  
>  	/* write SPU register index */
> -	err = spi_write(card->spi, (u8 *)&reg_out, sizeof(u16));
> -	if (err)
> -		goto out;
> +	reg_trans.tx_buf = &reg_out;
> +	reg_trans.len = sizeof(reg_out);
>  
> -	err = spi_write(card->spi, buf, len);
> +	data_trans.tx_buf = buf;
> +	data_trans.len = len;
>  
> -out:
> +	spi_message_add_tail(&reg_trans, &m);
> +	spi_message_add_tail(&data_trans, &m);
> +
> +	err = spi_sync(card->spi, &m);
>  	spu_transaction_finish(card);
>  	return err;
>  }
> @@ -186,10 +186,13 @@ static inline int spu_reg_is_port_reg(u16 reg)
>  
>  static int spu_read(struct if_spi_card *card, u16 reg, u8 *buf, int len)
>  {
> -	unsigned int i, delay;
> +	unsigned int delay;
>  	int err = 0;
> -	u16 zero = 0;
>  	u16 reg_out = cpu_to_le16(reg | IF_SPI_READ_OPERATION_MASK);
> +	struct spi_message m;
> +	struct spi_transfer reg_trans;
> +	struct spi_transfer dummy_trans;
> +	struct spi_transfer data_trans;
>  
>  	/* You must take an even number of bytes from the SPU, even if you
>  	 * don't care about the last one.  */
> @@ -197,29 +200,34 @@ static int spu_read(struct if_spi_card *card, u16 reg, u8 *buf, int len)
>  
>  	spu_transaction_init(card);
>  
> +	spi_message_init(&m);
> +	memset(&reg_trans, 0, sizeof(reg_trans));
> +	memset(&dummy_trans, 0, sizeof(dummy_trans));
> +	memset(&data_trans, 0, sizeof(data_trans));
> +
>  	/* write SPU register index */
> -	err = spi_write(card->spi, (u8 *)&reg_out, sizeof(u16));
> -	if (err)
> -		goto out;
> +	reg_trans.tx_buf = &reg_out;
> +	reg_trans.len = sizeof(reg_out);
> +	spi_message_add_tail(&reg_trans, &m);
>  
>  	delay = spu_reg_is_port_reg(reg) ? card->spu_port_delay :
>  						card->spu_reg_delay;
>  	if (card->use_dummy_writes) {
>  		/* Clock in dummy cycles while the SPU fills the FIFO */
> -		for (i = 0; i < delay / 16; ++i) {
> -			err = spi_write(card->spi, (u8 *)&zero, sizeof(u16));
> -			if (err)
> -				return err;
> -		}
> +		dummy_trans.len = delay / 8;
> +		spi_message_add_tail(&dummy_trans, &m);
>  	} else {
>  		/* Busy-wait while the SPU fills the FIFO */
> -		ndelay(100 + (delay * 10));
> +		reg_trans.delay_usecs =
> +			DIV_ROUND_UP((100 + (delay * 10)), 1000);
>  	}
>  
>  	/* read in data */
> -	err = spi_read(card->spi, buf, len);
> +	data_trans.rx_buf = buf;
> +	data_trans.len = len;
> +	spi_message_add_tail(&data_trans, &m);
>  
> -out:
> +	err = spi_sync(card->spi, &m);
>  	spu_transaction_finish(card);
>  	return err;
>  }
> @@ -1049,7 +1057,6 @@ static int __devinit if_spi_probe(struct spi_device *spi)
>  	spi_set_drvdata(spi, card);
>  	card->pdata = pdata;
>  	card->spi = spi;
> -	card->gpio_cs = pdata->gpio_cs;
>  	card->prev_xfer_time = jiffies;
>  
>  	sema_init(&card->spi_ready, 0);
> @@ -1058,26 +1065,18 @@ static int __devinit if_spi_probe(struct spi_device *spi)
>  	INIT_LIST_HEAD(&card->data_packet_list);
>  	spin_lock_init(&card->buffer_lock);
>  
> -	/* set up GPIO CS line. TODO: use  regular CS line */
> -	err = gpio_request(card->gpio_cs, "if_spi_gpio_chip_select");
> -	if (err)
> -		goto free_card;
> -	err = gpio_direction_output(card->gpio_cs, 1);
> -	if (err)
> -		goto free_gpio;
> -
>  	/* Initialize the SPI Interface Unit */
>  	err = spu_init(card, pdata->use_dummy_writes);
>  	if (err)
> -		goto free_gpio;
> +		goto free_card;
>  	err = spu_get_chip_revision(card, &card->card_id, &card->card_rev);
>  	if (err)
> -		goto free_gpio;
> +		goto free_card;
>  
>  	/* Firmware load */
>  	err = spu_read_u32(card, IF_SPI_SCRATCH_4_REG, &scratch);
>  	if (err)
> -		goto free_gpio;
> +		goto free_card;
>  	if (scratch == SUCCESSFUL_FW_DOWNLOAD_MAGIC)
>  		lbs_deb_spi("Firmware is already loaded for "
>  			    "Marvell WLAN 802.11 adapter\n");
> @@ -1085,7 +1084,7 @@ static int __devinit if_spi_probe(struct spi_device *spi)
>  		err = if_spi_calculate_fw_names(card->card_id,
>  				card->helper_fw_name, card->main_fw_name);
>  		if (err)
> -			goto free_gpio;
> +			goto free_card;
>  
>  		lbs_deb_spi("Initializing FW for Marvell WLAN 802.11 adapter "
>  				"(chip_id = 0x%04x, chip_rev = 0x%02x) "
> @@ -1096,23 +1095,23 @@ static int __devinit if_spi_probe(struct spi_device *spi)
>  				spi->max_speed_hz);
>  		err = if_spi_prog_helper_firmware(card);
>  		if (err)
> -			goto free_gpio;
> +			goto free_card;
>  		err = if_spi_prog_main_firmware(card);
>  		if (err)
> -			goto free_gpio;
> +			goto free_card;
>  		lbs_deb_spi("loaded FW for Marvell WLAN 802.11 adapter\n");
>  	}
>  
>  	err = spu_set_interrupt_mode(card, 0, 1);
>  	if (err)
> -		goto free_gpio;
> +		goto free_card;
>  
>  	/* Register our card with libertas.
>  	 * This will call alloc_etherdev */
>  	priv = lbs_add_card(card, &spi->dev);
>  	if (!priv) {
>  		err = -ENOMEM;
> -		goto free_gpio;
> +		goto free_card;
>  	}
>  	card->priv = priv;
>  	priv->card = card;
> @@ -1157,8 +1156,6 @@ terminate_thread:
>  	if_spi_terminate_spi_thread(card);
>  remove_card:
>  	lbs_remove_card(priv); /* will call free_netdev */
> -free_gpio:
> -	gpio_free(card->gpio_cs);
>  free_card:
>  	free_if_spi_card(card);
>  out:
> @@ -1179,7 +1176,6 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
>  	free_irq(spi->irq, card);
>  	if_spi_terminate_spi_thread(card);
>  	lbs_remove_card(priv); /* will call free_netdev */
> -	gpio_free(card->gpio_cs);
>  	if (card->pdata->teardown)
>  		card->pdata->teardown(spi);
>  	free_if_spi_card(card);
> diff --git a/include/linux/spi/libertas_spi.h b/include/linux/spi/libertas_spi.h
> index 79506f5..1b5d538 100644
> --- a/include/linux/spi/libertas_spi.h
> +++ b/include/linux/spi/libertas_spi.h
> @@ -22,9 +22,6 @@ struct libertas_spi_platform_data {
>  	 * speed, you may want to use 0 here. */
>  	u16 use_dummy_writes;
>  
> -	/* GPIO number to use as chip select */
> -	u16 gpio_cs;
> -
>  	/* Board specific setup/teardown */
>  	int (*setup)(struct spi_device *spi);
>  	int (*teardown)(struct spi_device *spi);

