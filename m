Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55244 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXLJPpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:45:36 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 03/48] libertas: Consolidate lbs_host_to_card_done() function.
Message-Id: <E1J1kp7-0006kM-8a@shinybook.infradead.org> (sfid-20071210_154541_579804_3EAC8BF4)
Date: Mon, 10 Dec 2007 10:45:37 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Thu, 6 Dec 2007 14:36:11 +0000

As we move towards having this done by a state machine, start by having
a single 'stuff sent' function, which is called by if_usb/if_sdio/if_cs
after sending both data and commands.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/decl.h    |    1 +
 drivers/net/wireless/libertas/if_cs.c   |   12 +++---------
 drivers/net/wireless/libertas/if_sdio.c |    9 +++------
 drivers/net/wireless/libertas/if_usb.c  |   18 ++----------------
 drivers/net/wireless/libertas/main.c    |   18 ++++++++++++++++++
 5 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 447297a..201ec60 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -86,5 +86,6 @@ int lbs_stop_card(struct lbs_private *priv);
 int lbs_add_mesh(struct lbs_private *priv, struct device *dev);
 void lbs_remove_mesh(struct lbs_private *priv);
 int lbs_reset_device(struct lbs_private *priv);
+void lbs_host_to_card_done(struct lbs_private *priv);
 
 #endif
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 5fadcc0..54b1ba3 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -253,19 +253,13 @@ static irqreturn_t if_cs_interrupt(int irq, void *data)
 		/* Not for us */
 		return IRQ_NONE;
 
-	} else if(int_cause == 0xffff) {
+	} else if (int_cause == 0xffff) {
 		/* Read in junk, the card has probably been removed */
 		card->priv->adapter->surpriseremoved = 1;
 
 	} else {
-		if(int_cause & IF_CS_H_IC_TX_OVER) {
-			card->priv->dnld_sent = DNLD_RES_RECEIVED;
-			if (!card->priv->adapter->cur_cmd)
-				wake_up_interruptible(&card->priv->waitq);
-
-			if (card->priv->adapter->connect_status == LBS_CONNECTED)
-				netif_wake_queue(card->priv->dev);
-		}
+		if (int_cause & IF_CS_H_IC_TX_OVER)
+			lbs_host_to_card_done(card->priv);
 
 		/* clear interrupt */
 		if_cs_write16(card, IF_CS_C_INT_CAUSE, int_cause & IF_CS_C_IC_MASK);
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 437f3dd..0f0296b 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -835,12 +835,9 @@ static void if_sdio_interrupt(struct sdio_func *func)
 	 * Ignore the define name, this really means the card has
 	 * successfully received the command.
 	 */
-	if (cause & IF_SDIO_H_INT_DNLD) {
-		if ((card->priv->dnld_sent == DNLD_DATA_SENT) &&
-			(card->priv->adapter->connect_status == LBS_CONNECTED))
-			netif_wake_queue(card->priv->dev);
-		card->priv->dnld_sent = DNLD_RES_RECEIVED;
-	}
+	if (cause & IF_SDIO_H_INT_DNLD)
+		lbs_host_to_card_done(card->priv);
+
 
 	if (cause & IF_SDIO_H_INT_UPLD) {
 		ret = if_sdio_card_to_host(card);
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index c27ffcf..418dcab 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -66,22 +66,8 @@ static void if_usb_write_bulk_callback(struct urb *urb)
 		/* Used for both firmware TX and regular TX.  priv isn't
 		 * valid at firmware load time.
 		 */
-		if (priv) {
-			struct lbs_adapter *adapter = priv->adapter;
-			struct net_device *dev = priv->dev;
-
-			priv->dnld_sent = DNLD_RES_RECEIVED;
-
-			/* Wake main thread if commands are pending */
-			if (!adapter->cur_cmd)
-				wake_up_interruptible(&priv->waitq);
-
-			if (adapter->connect_status == LBS_CONNECTED)
-				netif_wake_queue(dev);
-
-			if (priv->mesh_dev && (adapter->mesh_connect_status == LBS_CONNECTED))
-				netif_wake_queue(priv->mesh_dev);
-		}
+		if (priv)
+			lbs_host_to_card_done(priv);
 	} else {
 		/* print the failure status number for debug */
 		lbs_pr_info("URB in failure status: %d\n", urb->status);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 67b6d79..ed02c02 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -616,6 +616,24 @@ static void lbs_tx_timeout(struct net_device *dev)
 	lbs_deb_leave(LBS_DEB_TX);
 }
 
+void lbs_host_to_card_done(struct lbs_private *priv)
+{
+	struct lbs_adapter *adapter = priv->adapter;
+
+	priv->dnld_sent = DNLD_RES_RECEIVED;
+
+	/* Wake main thread if commands are pending */
+	if (!adapter->cur_cmd)
+		wake_up_interruptible(&priv->waitq);
+
+	if (priv->dev && adapter->connect_status == LBS_CONNECTED)
+		netif_wake_queue(priv->dev);
+
+	if (priv->mesh_dev && adapter->mesh_connect_status == LBS_CONNECTED)
+		netif_wake_queue(priv->mesh_dev);
+}
+EXPORT_SYMBOL_GPL(lbs_host_to_card_done);
+
 /**
  *  @brief This function returns the network statistics
  *
-- 
1.5.3.4

