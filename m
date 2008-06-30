Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56811 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761720AbYF3NO0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 09:14:26 -0400
Message-Id: <20080630131200.750498000@sipsolutions.net> (sfid-20080630_151439_068850_19DE54B1)
References: <20080630131043.136595000@sipsolutions.net>
Date: Mon, 30 Jun 2008 15:10:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mac80211: get rid of function pointers in RX path
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes the RX path to no longer use function pointers for  
RX handlers but rather invoke them directly. If debugging is  
enabled, mark the RX handlers noinline because otherwise they
all get inlined into ieee80211_invoke_rx_handlers() which makes
it harder to see where a bug is.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |   93 ++++++++++++++++++++++++------------------------------
 1 file changed, 42 insertions(+), 51 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-06-27 21:42:22.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-06-27 21:43:15.000000000 +0200
@@ -386,7 +386,7 @@ static void ieee80211_verify_ip_alignmen
 
 /* rx handlers */
 
-static ieee80211_rx_result
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
@@ -463,7 +463,7 @@ ieee80211_rx_mesh_check(struct ieee80211
 }
 
 
-static ieee80211_rx_result
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
@@ -522,7 +522,7 @@ ieee80211_rx_h_check(struct ieee80211_rx
 }
 
 
-static ieee80211_rx_result
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
@@ -710,7 +710,7 @@ static int ap_sta_ps_end(struct net_devi
 	return sent;
 }
 
-static ieee80211_rx_result
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 {
 	struct sta_info *sta = rx->sta;
@@ -858,7 +858,7 @@ ieee80211_reassemble_find(struct ieee802
 	return NULL;
 }
 
-static ieee80211_rx_result
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr;
@@ -974,7 +974,7 @@ ieee80211_rx_h_defragment(struct ieee802
 	return RX_CONTINUE;
 }
 
-static ieee80211_rx_result
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_ps_poll(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
@@ -1049,7 +1049,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 	return RX_QUEUED;
 }
 
-static ieee80211_rx_result
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_remove_qos_control(struct ieee80211_rx_data *rx)
 {
 	u16 fc = rx->fc;
@@ -1367,7 +1367,7 @@ ieee80211_deliver_skb(struct ieee80211_r
 	}
 }
 
-static ieee80211_rx_result
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
@@ -1484,7 +1484,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx
 	return RX_QUEUED;
 }
 
-static ieee80211_rx_result
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
@@ -1515,7 +1515,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_
 	return RX_QUEUED;
 }
 
-static ieee80211_rx_result
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
@@ -1559,7 +1559,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 	return RX_CONTINUE;
 }
 
-static ieee80211_rx_result
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -1732,66 +1732,57 @@ static void ieee80211_rx_cooked_monitor(
 	dev_kfree_skb(skb);
 }
 
-typedef ieee80211_rx_result (*ieee80211_rx_handler)(struct ieee80211_rx_data *);
-static ieee80211_rx_handler ieee80211_rx_handlers[] =
-{
-	ieee80211_rx_h_passive_scan,
-	ieee80211_rx_h_check,
-	ieee80211_rx_h_decrypt,
-	ieee80211_rx_h_sta_process,
-	ieee80211_rx_h_defragment,
-	ieee80211_rx_h_ps_poll,
-	ieee80211_rx_h_michael_mic_verify,
-	/* this must be after decryption - so header is counted in MPDU mic
-	 * must be before pae and data, so QOS_DATA format frames
-	 * are not passed to user space by these functions
-	 */
-	ieee80211_rx_h_remove_qos_control,
-	ieee80211_rx_h_amsdu,
-	ieee80211_rx_h_data,
-	ieee80211_rx_h_ctrl,
-	ieee80211_rx_h_mgmt,
-	NULL
-};
 
 static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_rx_data *rx,
 					 struct sk_buff *skb)
 {
-	ieee80211_rx_handler *handler;
 	ieee80211_rx_result res = RX_DROP_MONITOR;
 
 	rx->skb = skb;
 	rx->sdata = sdata;
 	rx->dev = sdata->dev;
 
-	for (handler = ieee80211_rx_handlers; *handler != NULL; handler++) {
-		res = (*handler)(rx);
+#define CALL_RXH(rxh)		\
+	res = rxh(rx);		\
+	if (res != RX_CONTINUE)	\
+		goto rxh_done;
+
+	CALL_RXH(ieee80211_rx_h_passive_scan)
+	CALL_RXH(ieee80211_rx_h_check)
+	CALL_RXH(ieee80211_rx_h_decrypt)
+	CALL_RXH(ieee80211_rx_h_sta_process)
+	CALL_RXH(ieee80211_rx_h_defragment)
+	CALL_RXH(ieee80211_rx_h_ps_poll)
+	CALL_RXH(ieee80211_rx_h_michael_mic_verify)
+	/* must be after MMIC verify so header is counted in MPDU mic */
+	CALL_RXH(ieee80211_rx_h_remove_qos_control)
+	CALL_RXH(ieee80211_rx_h_amsdu)
+	CALL_RXH(ieee80211_rx_h_data)
+	CALL_RXH(ieee80211_rx_h_ctrl)
+	CALL_RXH(ieee80211_rx_h_mgmt)
 
-		switch (res) {
-		case RX_CONTINUE:
-			continue;
-		case RX_DROP_UNUSABLE:
-		case RX_DROP_MONITOR:
-			I802_DEBUG_INC(sdata->local->rx_handlers_drop);
-			if (rx->sta)
-				rx->sta->rx_dropped++;
-			break;
-		case RX_QUEUED:
-			I802_DEBUG_INC(sdata->local->rx_handlers_queued);
-			break;
-		}
-		break;
-	}
+#undef CALL_RXH
 
+ rxh_done:
 	switch (res) {
-	case RX_CONTINUE:
 	case RX_DROP_MONITOR:
+		I802_DEBUG_INC(sdata->local->rx_handlers_drop);
+		if (rx->sta)
+			rx->sta->rx_dropped++;
+		/* fall through */
+	case RX_CONTINUE:
 		ieee80211_rx_cooked_monitor(rx);
 		break;
 	case RX_DROP_UNUSABLE:
+		I802_DEBUG_INC(sdata->local->rx_handlers_drop);
+		if (rx->sta)
+			rx->sta->rx_dropped++;
 		dev_kfree_skb(rx->skb);
 		break;
+	case RX_QUEUED:
+		I802_DEBUG_INC(sdata->local->rx_handlers_queued);
+		break;
 	}
 }
 

-- 

