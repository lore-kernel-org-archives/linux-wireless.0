Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbYFSMVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 08:21:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1K9J8y-0004jf-A5
	for linux-wireless@vger.kernel.org; Thu, 19 Jun 2008 14:21:37 +0200
Subject: [RFC 2/2] get rid of tx handler function pointers
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 14:21:00 +0200
Message-Id: <1213878060.8967.4.camel@johannes.berg> (sfid-20080619_142147_173177_F13033D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just call the functions directly.

Together with the previous patch yields this:

add/remove: 1/11 grow/shrink: 0/2 up/down: 3392/-4108 (-716)
function                                     old     new   delta
invoke_tx_handlers                             -    3392   +3392
ieee80211_tx_handlers                         48       -     -48
ieee80211_tx_h_sequence                      116       -    -116
ieee80211_get_buffered_bc                    620     484    -136
ieee80211_master_start_xmit                 1152    1008    -144
ieee80211_tx_h_stats                         168       -    -168
ieee80211_tx_h_encrypt                       168       -    -168
ieee80211_tx_h_select_key                    256       -    -256
ieee80211_tx_h_calculate_duration            276       -    -276
ieee80211_tx_h_rate_ctrl                     344       -    -344
ieee80211_tx_h_check_assoc                   344       -    -344
ieee80211_tx_h_fragment                      640       -    -640
ieee80211_tx_h_misc                          724       -    -724
ieee80211_tx_h_ps_buf                        744       -    -744

Yeah, I need to clean up things, but hey, I think this is a pretty neat
optimisation. Makes compiling noticably slower though!
---
 net/mac80211/tx.c |   47 +++++++++++++++++------------------------------
 1 file changed, 17 insertions(+), 30 deletions(-)

--- everything.orig/net/mac80211/tx.c	2008-06-19 14:14:48.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-06-19 14:15:06.000000000 +0200
@@ -796,24 +796,6 @@ ieee80211_tx_h_stats(struct ieee80211_tx
 }
 
 
-typedef ieee80211_tx_result (*ieee80211_tx_handler)(struct ieee80211_tx_data *);
-static ieee80211_tx_handler ieee80211_tx_handlers[] =
-{
-	ieee80211_tx_h_check_assoc,
-	ieee80211_tx_h_sequence,
-	ieee80211_tx_h_ps_buf,
-	ieee80211_tx_h_select_key,
-	ieee80211_tx_h_michael_mic_add,
-	ieee80211_tx_h_rate_ctrl,
-	ieee80211_tx_h_misc,
-	ieee80211_tx_h_fragment,
-	/* handlers after fragment must be aware of tx info fragmentation! */
-	ieee80211_tx_h_encrypt,
-	ieee80211_tx_h_calculate_duration,
-	ieee80211_tx_h_stats,
-	NULL
-};
-
 /* actual transmit path */
 
 /*
@@ -1113,29 +1095,34 @@ static int invoke_tx_handlers(struct iee
 {
 	struct ieee80211_local *local = tx->local;
 	struct sk_buff *skb = tx->skb;
-	ieee80211_tx_handler *handler;
 	ieee80211_tx_result res = TX_DROP;
 	int i;
 
-	for (handler = ieee80211_tx_handlers; *handler != NULL; handler++) {
-		res = (*handler)(tx);
-		if (res != TX_CONTINUE)
-			break;
-	}
-
-	if (WARN_ON(tx->skb != skb))
-		res = TX_DROP;
+#define CALL_TXH(txh) if ((res = txh(tx)) != TX_CONTINUE) goto txh_done;
+	CALL_TXH(ieee80211_tx_h_check_assoc)
+	CALL_TXH(ieee80211_tx_h_sequence);
+	CALL_TXH(ieee80211_tx_h_ps_buf);
+	CALL_TXH(ieee80211_tx_h_select_key);
+	CALL_TXH(ieee80211_tx_h_michael_mic_add);
+	CALL_TXH(ieee80211_tx_h_rate_ctrl);
+	CALL_TXH(ieee80211_tx_h_misc);
+	CALL_TXH(ieee80211_tx_h_fragment);
+	/* handlers after fragment must be aware of tx info fragmentation! */
+	CALL_TXH(ieee80211_tx_h_encrypt);
+	CALL_TXH(ieee80211_tx_h_calculate_duration);
+	CALL_TXH(ieee80211_tx_h_stats);
+#undef CALL_TXH
 
+ txh_done:
 	if (unlikely(res == TX_DROP)) {
 		I802_DEBUG_INC(local->tx_handlers_drop);
-		if (skb)
-			dev_kfree_skb(skb);
+		dev_kfree_skb(skb);
 		for (i = 0; i < tx->num_extra_frag; i++)
 			if (tx->extra_frag[i])
 				dev_kfree_skb(tx->extra_frag[i]);
 		kfree(tx->extra_frag);
 		return -1;
-	} else if (unlikely(res == TX_QUEUED)) {
+	} else if (res == TX_QUEUED) {
 		I802_DEBUG_INC(local->tx_handlers_queued);
 		return -1;
 	}


