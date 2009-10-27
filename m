Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:42559 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbZJ0XvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 19:51:24 -0400
Received: by ey-out-2122.google.com with SMTP id 9so89932eyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2009 16:51:27 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org, sebatian@breakpoint.cc,
	dcbw@redhat.com, Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] libertas: remove internal buffers from GSPI driver
Date: Tue, 27 Oct 2009 16:51:40 -0700
Message-Id: <1256687501-8636-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the internal command and data buffers that the GSPI driver
maintained and instead relies on the Libertas core to synchronize access
to the command and data ports as with the other interface drivers.  This
cleanup reduces the GSPI driver's memory footprint and should improve
performance by removing the need to copy to these internal buffers.
This also simplifies the bottom half of the interrupt handler.

This is an incremental cleanup: after removing the redundant buffers, we
can further improve the driver to use a threaded IRQ handler instead of
maintaining its own thread.  However I would like a few folks to test
the buffer removal first and make sure that I'm not introducing
regressions.

Tested on Blackfin BF527 with DMA disabled due to an issue with the SPI
host controller driver in the current bleeding-edge Blackfin kernel.  I
would appreciate it if someone with working DMA could test this patch
and provide feedback.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 drivers/net/wireless/libertas/if_spi.c |  136 ++------------------------------
 1 files changed, 6 insertions(+), 130 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 06df2e1..9e0096d 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -32,12 +32,6 @@
 #include "dev.h"
 #include "if_spi.h"
 
-struct if_spi_packet {
-	struct list_head		list;
-	u16				blen;
-	u8				buffer[0] __attribute__((aligned(4)));
-};
-
 struct if_spi_card {
 	struct spi_device		*spi;
 	struct lbs_private		*priv;
@@ -66,33 +60,10 @@ struct if_spi_card {
 	struct semaphore		spi_thread_terminated;
 
 	u8				cmd_buffer[IF_SPI_CMD_BUF_SIZE];
-
-	/* A buffer of incoming packets from libertas core.
-	 * Since we can't sleep in hw_host_to_card, we have to buffer
-	 * them. */
-	struct list_head		cmd_packet_list;
-	struct list_head		data_packet_list;
-
-	/* Protects cmd_packet_list and data_packet_list */
-	spinlock_t			buffer_lock;
 };
 
 static void free_if_spi_card(struct if_spi_card *card)
 {
-	struct list_head *cursor, *next;
-	struct if_spi_packet *packet;
-
-	BUG_ON(card->run_thread);
-	list_for_each_safe(cursor, next, &card->cmd_packet_list) {
-		packet = container_of(cursor, struct if_spi_packet, list);
-		list_del(&packet->list);
-		kfree(packet);
-	}
-	list_for_each_safe(cursor, next, &card->data_packet_list) {
-		packet = container_of(cursor, struct if_spi_packet, list);
-		list_del(&packet->list);
-		kfree(packet);
-	}
 	spi_set_drvdata(card->spi, NULL);
 	kfree(card);
 }
@@ -774,40 +745,6 @@ out:
 	return err;
 }
 
-/* Move data or a command from the host to the card. */
-static void if_spi_h2c(struct if_spi_card *card,
-			struct if_spi_packet *packet, int type)
-{
-	int err = 0;
-	u16 int_type, port_reg;
-
-	switch (type) {
-	case MVMS_DAT:
-		int_type = IF_SPI_CIC_TX_DOWNLOAD_OVER;
-		port_reg = IF_SPI_DATA_RDWRPORT_REG;
-		break;
-	case MVMS_CMD:
-		int_type = IF_SPI_CIC_CMD_DOWNLOAD_OVER;
-		port_reg = IF_SPI_CMD_RDWRPORT_REG;
-		break;
-	default:
-		lbs_pr_err("can't transfer buffer of type %d\n", type);
-		err = -EINVAL;
-		goto out;
-	}
-
-	/* Write the data to the card */
-	err = spu_write(card, port_reg, packet->buffer, packet->blen);
-	if (err)
-		goto out;
-
-out:
-	kfree(packet);
-
-	if (err)
-		lbs_pr_err("%s: error %d\n", __func__, err);
-}
-
 /* Inform the host about a card event */
 static void if_spi_e2h(struct if_spi_card *card)
 {
@@ -837,8 +774,6 @@ static int lbs_spi_thread(void *data)
 	int err;
 	struct if_spi_card *card = data;
 	u16 hiStatus;
-	unsigned long flags;
-	struct if_spi_packet *packet;
 
 	while (1) {
 		/* Wait to be woken up by one of two things.  First, our ISR
@@ -877,43 +812,9 @@ static int lbs_spi_thread(void *data)
 		if (hiStatus & IF_SPI_HIST_CMD_DOWNLOAD_RDY ||
 		   (card->priv->psstate != PS_STATE_FULL_POWER &&
 		    (hiStatus & IF_SPI_HIST_TX_DOWNLOAD_RDY))) {
-			/* This means two things. First of all,
-			 * if there was a previous command sent, the card has
-			 * successfully received it.
-			 * Secondly, it is now ready to download another
-			 * command.
-			 */
 			lbs_host_to_card_done(card->priv);
-
-			/* Do we have any command packets from the host to
-			 * send? */
-			packet = NULL;
-			spin_lock_irqsave(&card->buffer_lock, flags);
-			if (!list_empty(&card->cmd_packet_list)) {
-				packet = (struct if_spi_packet *)(card->
-						cmd_packet_list.next);
-				list_del(&packet->list);
-			}
-			spin_unlock_irqrestore(&card->buffer_lock, flags);
-
-			if (packet)
-				if_spi_h2c(card, packet, MVMS_CMD);
 		}
-		if (hiStatus & IF_SPI_HIST_TX_DOWNLOAD_RDY) {
-			/* Do we have any data packets from the host to
-			 * send? */
-			packet = NULL;
-			spin_lock_irqsave(&card->buffer_lock, flags);
-			if (!list_empty(&card->data_packet_list)) {
-				packet = (struct if_spi_packet *)(card->
-						data_packet_list.next);
-				list_del(&packet->list);
-			}
-			spin_unlock_irqrestore(&card->buffer_lock, flags);
 
-			if (packet)
-				if_spi_h2c(card, packet, MVMS_DAT);
-		}
 		if (hiStatus & IF_SPI_HIST_CARD_EVENT)
 			if_spi_e2h(card);
 
@@ -942,40 +843,18 @@ static int if_spi_host_to_card(struct lbs_private *priv,
 				u8 type, u8 *buf, u16 nb)
 {
 	int err = 0;
-	unsigned long flags;
 	struct if_spi_card *card = priv->card;
-	struct if_spi_packet *packet;
-	u16 blen;
 
 	lbs_deb_enter_args(LBS_DEB_SPI, "type %d, bytes %d", type, nb);
 
-	if (nb == 0) {
-		lbs_pr_err("%s: invalid size requested: %d\n", __func__, nb);
-		err = -EINVAL;
-		goto out;
-	}
-	blen = ALIGN(nb, 4);
-	packet = kzalloc(sizeof(struct if_spi_packet) + blen, GFP_ATOMIC);
-	if (!packet) {
-		err = -ENOMEM;
-		goto out;
-	}
-	packet->blen = blen;
-	memcpy(packet->buffer, buf, nb);
-	memset(packet->buffer + nb, 0, blen - nb);
+	nb = ALIGN(nb, 4);
 
 	switch (type) {
 	case MVMS_CMD:
-		priv->dnld_sent = DNLD_CMD_SENT;
-		spin_lock_irqsave(&card->buffer_lock, flags);
-		list_add_tail(&packet->list, &card->cmd_packet_list);
-		spin_unlock_irqrestore(&card->buffer_lock, flags);
+		err = spu_write(card, IF_SPI_CMD_RDWRPORT_REG, buf, nb);
 		break;
 	case MVMS_DAT:
-		priv->dnld_sent = DNLD_DATA_SENT;
-		spin_lock_irqsave(&card->buffer_lock, flags);
-		list_add_tail(&packet->list, &card->data_packet_list);
-		spin_unlock_irqrestore(&card->buffer_lock, flags);
+		err = spu_write(card, IF_SPI_DATA_RDWRPORT_REG, buf, nb);
 		break;
 	default:
 		lbs_pr_err("can't transfer buffer of type %d", type);
@@ -983,9 +862,6 @@ static int if_spi_host_to_card(struct lbs_private *priv,
 		break;
 	}
 
-	/* Wake up the spi thread */
-	up(&card->spi_ready);
-out:
 	lbs_deb_leave_args(LBS_DEB_SPI, "err=%d", err);
 	return err;
 }
@@ -1062,9 +938,6 @@ static int __devinit if_spi_probe(struct spi_device *spi)
 
 	sema_init(&card->spi_ready, 0);
 	sema_init(&card->spi_thread_terminated, 0);
-	INIT_LIST_HEAD(&card->cmd_packet_list);
-	INIT_LIST_HEAD(&card->data_packet_list);
-	spin_lock_init(&card->buffer_lock);
 
 	/* Initialize the SPI Interface Unit */
 	err = spu_init(card, pdata->use_dummy_writes);
@@ -1141,6 +1014,9 @@ static int __devinit if_spi_probe(struct spi_device *spi)
 		goto terminate_thread;
 	}
 
+	/* poke the IRQ handler so that we don't miss the first interrupt */
+	up(&card->spi_ready);
+
 	/* Start the card.
 	 * This will call register_netdev, and we'll start
 	 * getting interrupts... */
-- 
1.5.6.3

