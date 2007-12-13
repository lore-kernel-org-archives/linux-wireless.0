Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762762AbXLMG7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:17 -0500
Subject: [PATCH 51/48] libertas: clean up lbs_interrupt()
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2S-0005qx-DD@shinybook.infradead.org> (sfid-20071213_065938_731230_BD76DD3D)
Date: Thu, 13 Dec 2007 01:59:20 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 10 Dec 2007 14:58:37 -0500

Make it take struct lbs_private as argument; that's all it wants anyway,
and all callers were starting off from that. Don't wake the netif
queues, because those should be handled elsewhere. And sort out the
locking, with a big nasty warning for those who don't have the
driver_lock locked when they call it.

Oh, and fix if_cs.c to lock the driver_lock before calling it.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/decl.h    |    2 +-
 drivers/net/wireless/libertas/if_cs.c   |    5 +++--
 drivers/net/wireless/libertas/if_sdio.c |    4 ++--
 drivers/net/wireless/libertas/if_usb.c  |    4 ++--
 drivers/net/wireless/libertas/main.c    |   19 +++++++++----------
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index a086d0c..82727a8 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -39,7 +39,7 @@ void lbs_queue_cmd(struct lbs_private *priv,
 int lbs_allocate_cmd_buffer(struct lbs_private *priv);
 int lbs_execute_next_command(struct lbs_private *priv);
 int lbs_process_event(struct lbs_private *priv);
-void lbs_interrupt(struct net_device *);
+void lbs_interrupt(struct lbs_private *priv);
 int lbs_set_radio_control(struct lbs_private *priv);
 u32 lbs_fw_index_to_data_rate(u8 index);
 u8 lbs_data_rate_to_fw_index(u32 rate);
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 49a0178..2acbe5d 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -264,8 +264,9 @@ static irqreturn_t if_cs_interrupt(int irq, void *data)
 		/* clear interrupt */
 		if_cs_write16(card, IF_CS_C_INT_CAUSE, int_cause & IF_CS_C_IC_MASK);
 	}
-
-	lbs_interrupt(card->priv->dev);
+	spin_lock(&card->priv->driver_lock);
+	lbs_interrupt(card->priv);
+	spin_unlock(&card->priv->driver_lock);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 6456613..94060da 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -154,7 +154,7 @@ static int if_sdio_handle_cmd(struct if_sdio_card *card,
 
 	card->int_cause |= MRVDRV_CMD_UPLD_RDY;
 
-	lbs_interrupt(card->priv->dev);
+	lbs_interrupt(card->priv);
 
 	ret = 0;
 
@@ -236,7 +236,7 @@ static int if_sdio_handle_event(struct if_sdio_card *card,
 	card->event = event;
 	card->int_cause |= MRVDRV_CARDEVENT;
 
-	lbs_interrupt(card->priv->dev);
+	lbs_interrupt(card->priv);
 
 	spin_unlock_irqrestore(&card->priv->driver_lock, flags);
 
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index f59fd73..1c23166 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -632,7 +632,7 @@ static inline void process_cmdrequest(int recvlength, u8 *recvbuff,
 	       priv->upld_len);
 
 	kfree_skb(skb);
-	lbs_interrupt(priv->dev);
+	lbs_interrupt(priv);
 	spin_unlock(&priv->driver_lock);
 
 	lbs_deb_usbd(&cardp->udev->dev,
@@ -705,7 +705,7 @@ static void if_usb_receive(struct urb *urb)
 		cardp->usb_event_cause <<= 3;
 		cardp->usb_int_cause |= MRVDRV_CARDEVENT;
 		kfree_skb(skb);
-		lbs_interrupt(priv->dev);
+		lbs_interrupt(priv);
 		spin_unlock(&priv->driver_lock);
 		goto rx_exit;
 	default:
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index f16c93b..2797149 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1408,23 +1408,22 @@ out:
  *  @param dev     A pointer to net_device structure
  *  @return 	   n/a
  */
-void lbs_interrupt(struct net_device *dev)
+void lbs_interrupt(struct lbs_private *priv)
 {
-	struct lbs_private *priv = dev->priv;
-
 	lbs_deb_enter(LBS_DEB_THREAD);
 
-	lbs_deb_thread("lbs_interrupt: intcounter=%d\n",
-	       priv->intcounter);
+	lbs_deb_thread("lbs_interrupt: intcounter=%d\n", priv->intcounter);
+
+	if (spin_trylock(&priv->driver_lock)) {
+		spin_unlock(&priv->driver_lock);
+		printk(KERN_CRIT "%s called without driver_lock held\n", __func__);
+		WARN_ON(1);
+	}
 
 	priv->intcounter++;
 
-	if (priv->psstate == PS_STATE_SLEEP) {
+	if (priv->psstate == PS_STATE_SLEEP)
 		priv->psstate = PS_STATE_AWAKE;
-		netif_wake_queue(dev);
-		if (priv->mesh_dev)
-			netif_wake_queue(priv->mesh_dev);
-	}
 
 	wake_up_interruptible(&priv->waitq);
 
-- 
1.5.3.4

