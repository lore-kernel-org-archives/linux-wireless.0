Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49944 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbXLJRPC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:15:02 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 28/48] libertas: kill TxLockFlag
Message-Id: <E1J1kpX-0006mN-GP@shinybook.infradead.org> (sfid-20071210_171508_259787_002F0D54)
Date: Mon, 10 Dec 2007 10:46:03 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 8 Dec 2007 19:46:19 +0000

We don't need this. We can use adapter->currenttxskb instead.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/dev.h  |    1 -
 drivers/net/wireless/libertas/main.c |   25 ++++++++++++++++++++++---
 drivers/net/wireless/libertas/tx.c   |    9 +++------
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 5cb2923..eaa45d4 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -285,7 +285,6 @@ struct lbs_adapter {
 
 	/** Tx-related variables (for single packet tx) */
 	struct sk_buff *currenttxskb;
-	u16 TxLockFlag;
 
 	/** NIC Operation characteristics */
 	u16 currentpacketfilter;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index d03a2f8..7155f48 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -290,8 +290,14 @@ static ssize_t lbs_rtap_set(struct device *dev,
 			return strlen(buf);
 		adapter->monitormode = LBS_MONITOR_OFF;
 		lbs_remove_rtap(priv);
-		netif_wake_queue(priv->dev);
-		netif_wake_queue(priv->mesh_dev);
+
+		if (adapter->currenttxskb) {
+			dev_kfree_skb_any(adapter->currenttxskb);
+			adapter->currenttxskb = NULL;
+		}
+
+		/* Wake queues, command thread, etc. */
+		lbs_host_to_card_done(priv);
 	}
 
 	lbs_prepare_and_send_command(priv,
@@ -521,7 +527,15 @@ static int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	lbs_deb_enter(LBS_DEB_TX);
 
-	if (priv->dnld_sent || priv->adapter->TxLockFlag) {
+	/* We could return NETDEV_TX_BUSY here, but I'd actually 
+	   like to get the point where we can BUG() */
+	if (priv->dnld_sent) {
+		lbs_pr_err("%s while dnld_sent\n", __func__);
+		priv->stats.tx_dropped++;
+		goto done;
+	}
+	if (priv->adapter->currenttxskb) {
+		lbs_pr_err("%s while TX skb pending\n", __func__);
 		priv->stats.tx_dropped++;
 		goto done;
 	}
@@ -624,6 +638,11 @@ void lbs_host_to_card_done(struct lbs_private *priv)
 	if (!adapter->cur_cmd)
 		wake_up_interruptible(&priv->waitq);
 
+	/* Don't wake netif queues if we're in monitor mode and
+	   a TX packet is already pending. */
+	if (priv->adapter->currenttxskb)
+		return;
+
 	if (priv->dev && adapter->connect_status == LBS_CONNECTED)
 		netif_wake_queue(priv->dev);
 
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index b423ce1..131ef3f 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -152,11 +152,11 @@ done:
 		netif_stop_queue(priv->dev);
 		if (priv->mesh_dev)
 			netif_stop_queue(priv->mesh_dev);
-		/* freeze any packets already in our queues */
-		priv->adapter->TxLockFlag = 1;
+
+		/* Keep the skb around for when we get feedback */
+		priv->adapter->currenttxskb = skb;
 	} else {
 		dev_kfree_skb_any(skb);
-		priv->adapter->currenttxskb = NULL;
 	}
 
 	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
@@ -227,8 +227,6 @@ int lbs_process_tx(struct lbs_private *priv, struct sk_buff *skb)
 		return ret;
 	}
 
-	priv->adapter->currenttxskb = skb;
-
 	ret = SendSinglePacket(priv, skb);
 done:
 	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
@@ -272,7 +270,6 @@ void lbs_send_tx_feedback(struct lbs_private *priv)
 	    (1 + adapter->txretrycount - try_count) : 0;
 	lbs_upload_rx_packet(priv, adapter->currenttxskb);
 	adapter->currenttxskb = NULL;
-	priv->adapter->TxLockFlag = 0;
 
 	if (adapter->connect_status == LBS_CONNECTED)
 		netif_wake_queue(priv->dev);
-- 
1.5.3.4

