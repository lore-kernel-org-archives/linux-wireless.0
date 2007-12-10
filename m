Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55287 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbXLJPqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:46:04 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 30/48] libertas: use lbs_host_to_card_done() in lbs_tx_timeout()
Message-Id: <E1J1kpZ-0006mX-N8@shinybook.infradead.org> (sfid-20071210_154607_839781_A7EC0D14)
Date: Mon, 10 Dec 2007 10:46:05 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 8 Dec 2007 20:56:44 +0000

Also attempt some locking in lbs_host_to_card_done()

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/main.c |   40 ++++++++++++++-------------------
 1 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 243cdea..2ff5f1b 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -601,31 +601,24 @@ static void lbs_tx_timeout(struct net_device *dev)
 
 	lbs_pr_err("tx watch dog timeout\n");
 
-	priv->dnld_sent = DNLD_RES_RECEIVED;
 	dev->trans_start = jiffies;
 
 	if (priv->currenttxskb) {
-		if (priv->monitormode != LBS_MONITOR_OFF) {
-			/* If we are here, we have not received feedback from
-			   the previous packet.  Assume TX_FAIL and move on. */
-			priv->eventcause = 0x01000000;
-			lbs_send_tx_feedback(priv);
-		} else
-			wake_up_interruptible(&priv->waitq);
-	} else if (dev == priv->dev) {
-		if (priv->connect_status == LBS_CONNECTED)
-			netif_wake_queue(priv->dev);
-
-	} else if (dev == priv->mesh_dev) {
-		if (priv->mesh_connect_status == LBS_CONNECTED)
-			netif_wake_queue(priv->mesh_dev);
+		priv->eventcause = 0x01000000;
+		lbs_send_tx_feedback(priv);
 	}
+	/* XX: Shouldn't we also call into the hw-specific driver
+	   to kick it somehow? */
+	lbs_host_to_card_done(priv);
 
 	lbs_deb_leave(LBS_DEB_TX);
 }
 
 void lbs_host_to_card_done(struct lbs_private *priv)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->driver_lock, flags);
 
 	priv->dnld_sent = DNLD_RES_RECEIVED;
 
@@ -634,15 +627,16 @@ void lbs_host_to_card_done(struct lbs_private *priv)
 		wake_up_interruptible(&priv->waitq);
 
 	/* Don't wake netif queues if we're in monitor mode and
-	   a TX packet is already pending. */
-	if (priv->currenttxskb)
-		return;
-
-	if (priv->dev && priv->connect_status == LBS_CONNECTED)
-		netif_wake_queue(priv->dev);
+	   a TX packet is already pending, or if there are commands
+	   queued to be sent. */
+	if (!priv->currenttxskb && list_empty(&priv->cmdpendingq)) {
+		if (priv->dev && priv->connect_status == LBS_CONNECTED)
+			netif_wake_queue(priv->dev);
 
-	if (priv->mesh_dev && priv->mesh_connect_status == LBS_CONNECTED)
-		netif_wake_queue(priv->mesh_dev);
+		if (priv->mesh_dev && priv->mesh_connect_status == LBS_CONNECTED)
+			netif_wake_queue(priv->mesh_dev);
+	}
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 }
 EXPORT_SYMBOL_GPL(lbs_host_to_card_done);
 
-- 
1.5.3.4

