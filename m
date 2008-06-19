Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44527 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760318AbYFSMjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 08:39:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1K9JQ5-0004rK-TY
	for linux-wireless@vger.kernel.org; Thu, 19 Jun 2008 14:39:18 +0200
Subject: [RFC 3/2] get rid of rx handler function pointers
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 14:38:41 +0200
Message-Id: <1213879121.8967.9.camel@johannes.berg> (sfid-20080619_143942_738972_2DF87103)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even better :)

add/remove: 0/12 grow/shrink: 1/0 up/down: 5532/-6296 (-764)
function                                     old     new   delta
ieee80211_invoke_rx_handlers                 724    6256   +5532
ieee80211_rx_handlers                         52       -     -52
ieee80211_rx_h_mgmt                          116       -    -116
ieee80211_rx_h_remove_qos_control            148       -    -148
ieee80211_rx_h_passive_scan                  168       -    -168
ieee80211_rx_h_data                          192       -    -192
ieee80211_rx_h_ctrl                          288       -    -288
ieee80211_rx_h_ps_poll                       440       -    -440
ieee80211_rx_h_decrypt                       508       -    -508
ieee80211_rx_h_check                         588       -    -588
ieee80211_rx_h_amsdu                         872       -    -872
ieee80211_rx_h_sta_process                   920       -    -920
ieee80211_rx_h_defragment                   2004       -   -2004


All three patches together give:

add/remove: 1/23 grow/shrink: 1/2 up/down: 8924/-10404 (-1480)
function                                     old     new   delta
ieee80211_invoke_rx_handlers                 724    6256   +5532
invoke_tx_handlers                             -    3392   +3392
ieee80211_tx_handlers                         48       -     -48
ieee80211_rx_handlers                         52       -     -52
ieee80211_tx_h_sequence                      116       -    -116
ieee80211_rx_h_mgmt                          116       -    -116
ieee80211_get_buffered_bc                    620     484    -136
ieee80211_master_start_xmit                 1152    1008    -144
ieee80211_rx_h_remove_qos_control            148       -    -148
ieee80211_tx_h_stats                         168       -    -168
ieee80211_tx_h_encrypt                       168       -    -168
ieee80211_rx_h_passive_scan                  168       -    -168
ieee80211_rx_h_data                          192       -    -192
ieee80211_tx_h_select_key                    256       -    -256
ieee80211_tx_h_calculate_duration            276       -    -276
ieee80211_rx_h_ctrl                          288       -    -288
ieee80211_tx_h_rate_ctrl                     344       -    -344
ieee80211_tx_h_check_assoc                   344       -    -344
ieee80211_rx_h_ps_poll                       440       -    -440
ieee80211_rx_h_decrypt                       508       -    -508
ieee80211_rx_h_check                         588       -    -588
ieee80211_tx_h_fragment                      640       -    -640
ieee80211_tx_h_misc                          724       -    -724
ieee80211_tx_h_ps_buf                        744       -    -744
ieee80211_rx_h_amsdu                         872       -    -872
ieee80211_rx_h_sta_process                   920       -    -920
ieee80211_rx_h_defragment                   2004       -   -2004


---
 net/mac80211/rx.c |   71 +++++++++++++++++++++++-------------------------------
 1 file changed, 31 insertions(+), 40 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-06-19 14:30:13.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-06-19 14:36:38.000000000 +0200
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
+#define CALL_RXH(rxh) if ((res = rxh(rx)) != RX_CONTINUE) goto rxh_done;
+	CALL_RXH(ieee80211_rx_h_passive_scan);
+	CALL_RXH(ieee80211_rx_h_check);
+	CALL_RXH(ieee80211_rx_h_decrypt);
+	CALL_RXH(ieee80211_rx_h_sta_process);
+	CALL_RXH(ieee80211_rx_h_defragment);
+	CALL_RXH(ieee80211_rx_h_ps_poll);
+	CALL_RXH(ieee80211_rx_h_michael_mic_verify);
+	/*
+	 * this must be after decryption - so header is counted in MPDU mic
+	 * must be before pae and data); so QOS_DATA format frames
+	 * are not passed to user space by these functions
+	 */
+	CALL_RXH(ieee80211_rx_h_remove_qos_control);
+	CALL_RXH(ieee80211_rx_h_amsdu);
+	CALL_RXH(ieee80211_rx_h_data);
+	CALL_RXH(ieee80211_rx_h_ctrl);
+	CALL_RXH(ieee80211_rx_h_mgmt);
 
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
 


