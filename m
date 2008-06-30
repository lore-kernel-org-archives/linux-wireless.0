Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56866 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790AbYF3NPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 09:15:30 -0400
Message-Id: <20080630131200.046317000@sipsolutions.net> (sfid-20080630_151538_269111_3BCB6928)
References: <20080630131043.136595000@sipsolutions.net>
Date: Mon, 30 Jun 2008 15:10:44 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mac80211: get rid of function pointers in TX path
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes the TX path to no longer use function pointers for
TX handlers but rather invoke them directly. If debugging is
enabled, mark the TX handlers noinline because otherwise they
all get inlined into invoke_tx_handlers() which makes it harder
to see where a bug is.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    6 ++++
 net/mac80211/tx.c          |   63 ++++++++++++++++++++-------------------------
 2 files changed, 35 insertions(+), 34 deletions(-)

--- everything.orig/net/mac80211/tx.c	2008-06-27 21:42:23.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-06-27 21:43:14.000000000 +0200
@@ -220,7 +220,7 @@ static int inline is_ieee80211_device(st
 
 /* tx handlers */
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -274,7 +274,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
@@ -432,7 +432,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 {
 	if (unlikely(tx->flags & IEEE80211_TX_PS_BUFFERED))
@@ -444,7 +444,7 @@ ieee80211_tx_h_ps_buf(struct ieee80211_t
 		return ieee80211_tx_h_multicast_ps_buf(tx);
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_key *key;
@@ -493,7 +493,7 @@ ieee80211_tx_h_select_key(struct ieee802
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 {
 	struct rate_selection rsel;
@@ -537,7 +537,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
@@ -632,7 +632,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
@@ -724,7 +724,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 	return TX_DROP;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 {
 	if (!tx->key)
@@ -744,7 +744,7 @@ ieee80211_tx_h_encrypt(struct ieee80211_
 	return TX_DROP;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_calculate_duration(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
@@ -774,7 +774,7 @@ ieee80211_tx_h_calculate_duration(struct
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
 {
 	int i;
@@ -795,24 +795,6 @@ ieee80211_tx_h_stats(struct ieee80211_tx
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
@@ -1112,16 +1094,29 @@ static int invoke_tx_handlers(struct iee
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
+#define CALL_TXH(txh)		\
+	res = txh(tx);		\
+	if (res != TX_CONTINUE)	\
+		goto txh_done;
+
+	CALL_TXH(ieee80211_tx_h_check_assoc)
+	CALL_TXH(ieee80211_tx_h_sequence)
+	CALL_TXH(ieee80211_tx_h_ps_buf)
+	CALL_TXH(ieee80211_tx_h_select_key)
+	CALL_TXH(ieee80211_tx_h_michael_mic_add)
+	CALL_TXH(ieee80211_tx_h_rate_ctrl)
+	CALL_TXH(ieee80211_tx_h_misc)
+	CALL_TXH(ieee80211_tx_h_fragment)
+	/* handlers after fragment must be aware of tx info fragmentation! */
+	CALL_TXH(ieee80211_tx_h_encrypt)
+	CALL_TXH(ieee80211_tx_h_calculate_duration)
+	CALL_TXH(ieee80211_tx_h_stats)
+#undef CALL_TXH
 
+ txh_done:
 	if (unlikely(res == TX_DROP)) {
 		I802_DEBUG_INC(local->tx_handlers_drop);
 		dev_kfree_skb(skb);
--- everything.orig/net/mac80211/ieee80211_i.h	2008-06-27 21:43:12.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-06-27 21:43:14.000000000 +0200
@@ -954,4 +954,10 @@ int ieee80211_frame_duration(struct ieee
 void mac80211_ev_michael_mic_failure(struct net_device *dev, int keyidx,
 				     struct ieee80211_hdr *hdr);
 
+#ifdef CONFIG_MAC80211_DEBUG
+#define debug_noinline noinline
+#else
+#define debug_noinline
+#endif
+
 #endif /* IEEE80211_I_H */

-- 

