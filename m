Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55983 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762827AbXLMG7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:53 -0500
Subject: [PATCH 86/48] libertas: slight cleanup of netif queue stop/wake
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i39-0005ty-PL@shinybook.infradead.org> (sfid-20071213_070638_394330_4C4E3399)
Date: Thu, 13 Dec 2007 02:00:03 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Wed, 12 Dec 2007 00:41:51 -0500

In particular, we shouldn't be waking the queues in lbs_host_to_card_done()
any more.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmdresp.c |   14 ++++++++------
 drivers/net/wireless/libertas/join.c    |    7 ++++---
 drivers/net/wireless/libertas/main.c    |   12 +-----------
 drivers/net/wireless/libertas/scan.c    |   12 +++++++-----
 4 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 53f73c4..a809f8f 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -43,14 +43,15 @@ void lbs_mac_event_disconnected(struct lbs_private *priv)
 	msleep_interruptible(1000);
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
 
-	/* Free Tx and Rx packets */
-	kfree_skb(priv->currenttxskb);
-	priv->currenttxskb = NULL;
-
 	/* report disconnect to upper layer */
 	netif_stop_queue(priv->dev);
 	netif_carrier_off(priv->dev);
 
+	/* Free Tx and Rx packets */
+	kfree_skb(priv->currenttxskb);
+	priv->currenttxskb = NULL;
+	priv->tx_pending_len = 0;
+
 	/* reset SNR/NF/RSSI values */
 	memset(priv->SNR, 0x00, sizeof(priv->SNR));
 	memset(priv->NF, 0x00, sizeof(priv->NF));
@@ -883,9 +884,10 @@ int lbs_process_event(struct lbs_private *priv)
 		}
 		lbs_pr_info("EVENT: MESH_AUTO_STARTED\n");
 		priv->mesh_connect_status = LBS_CONNECTED;
-		if (priv->mesh_open == 1) {
-			netif_wake_queue(priv->mesh_dev);
+		if (priv->mesh_open) {
 			netif_carrier_on(priv->mesh_dev);
+			if (!priv->tx_pending_len)
+				netif_wake_queue(priv->mesh_dev);
 		}
 		priv->mode = IW_MODE_ADHOC;
 		schedule_work(&priv->sync_channel);
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireless/libertas/join.c
index 14425d9..2d45080 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -781,8 +781,8 @@ int lbs_ret_80211_associate(struct lbs_private *priv,
 	priv->numSNRNF = 0;
 
 	netif_carrier_on(priv->dev);
-	netif_wake_queue(priv->dev);
-
+	if (!priv->tx_pending_len)
+		netif_wake_queue(priv->dev);
 
 	memcpy(wrqu.ap_addr.sa_data, priv->curbssparams.bssid, ETH_ALEN);
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
@@ -865,7 +865,8 @@ int lbs_ret_80211_ad_hoc_start(struct lbs_private *priv,
 	priv->curbssparams.ssid_len = bss->ssid_len;
 
 	netif_carrier_on(priv->dev);
-	netif_wake_queue(priv->dev);
+	if (!priv->tx_pending_len)
+		netif_wake_queue(priv->dev);
 
 	memset(&wrqu, 0, sizeof(wrqu));
 	memcpy(wrqu.ap_addr.sa_data, priv->curbssparams.bssid, ETH_ALEN);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index cdf5934..f9bdd12 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -489,19 +489,9 @@ void lbs_host_to_card_done(struct lbs_private *priv)
 	priv->dnld_sent = DNLD_RES_RECEIVED;
 
 	/* Wake main thread if commands are pending */
-	if (!priv->cur_cmd)
+	if (!priv->cur_cmd || priv->tx_pending_len > 0)
 		wake_up_interruptible(&priv->waitq);
 
-	/* Don't wake netif queues if we're in monitor mode and
-	   a TX packet is already pending, or if there are commands
-	   queued to be sent. */
-	if (!priv->currenttxskb && list_empty(&priv->cmdpendingq)) {
-		if (priv->dev && priv->connect_status == LBS_CONNECTED)
-			netif_wake_queue(priv->dev);
-
-		if (priv->mesh_dev && priv->mesh_connect_status == LBS_CONNECTED)
-			netif_wake_queue(priv->mesh_dev);
-	}
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 }
 EXPORT_SYMBOL_GPL(lbs_host_to_card_done);
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 92d84c7..9a61188 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -590,13 +590,13 @@ int lbs_scan_networks(struct lbs_private *priv,
 	netif_stop_queue(priv->dev);
 	netif_carrier_off(priv->dev);
 	if (priv->mesh_dev) {
-			netif_stop_queue(priv->mesh_dev);
-			netif_carrier_off(priv->mesh_dev);
+		netif_stop_queue(priv->mesh_dev);
+		netif_carrier_off(priv->mesh_dev);
 	}
 
 	/* Prepare to continue an interrupted scan */
 	lbs_deb_scan("chan_count %d, last_scanned_channel %d\n",
-		chan_count, priv->last_scanned_channel);
+		     chan_count, priv->last_scanned_channel);
 	curr_chans = chan_list;
 	/* advance channel list by already-scanned-channels */
 	if (priv->last_scanned_channel > 0) {
@@ -659,11 +659,13 @@ out2:
 out:
 	if (priv->connect_status == LBS_CONNECTED) {
 		netif_carrier_on(priv->dev);
-		netif_wake_queue(priv->dev);
+		if (!priv->tx_pending_len)
+			netif_wake_queue(priv->dev);
 	}
 	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED)) {
 		netif_carrier_on(priv->mesh_dev);
-		netif_wake_queue(priv->mesh_dev);
+		if (!priv->tx_pending_len)
+			netif_wake_queue(priv->mesh_dev);
 	}
 	kfree(chan_list);
 
-- 
1.5.3.4

