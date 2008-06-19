Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58289 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbYFSX1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 19:27:40 -0400
Message-Id: <20080619232434.586735000@sipsolutions.net> (sfid-20080620_012743_628397_C9C3CEA2)
References: <20080619232229.202159000@sipsolutions.net>
Date: Fri, 20 Jun 2008 01:22:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mac80211: get rid of function pointers in TX path
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

--- everything.orig/net/mac80211/tx.c	2008-06-20 01:05:02.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-06-20 01:05:05.000000000 +0200
@@ -222,7 +222,7 @@ static int inline is_ieee80211_device(st
 
 /* tx handlers */
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -276,7 +276,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
@@ -434,7 +434,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 {
 	if (unlikely(tx->flags & IEEE80211_TX_PS_BUFFERED))
@@ -446,7 +446,7 @@ ieee80211_tx_h_ps_buf(struct ieee80211_t
 		return ieee80211_tx_h_multicast_ps_buf(tx);
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_key *key;
@@ -495,7 +495,7 @@ ieee80211_tx_h_select_key(struct ieee802
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 {
 	struct rate_selection rsel;
@@ -539,7 +539,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
@@ -635,7 +635,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
@@ -726,7 +726,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 	return TX_DROP;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 {
 	if (!tx->key)
@@ -746,7 +746,7 @@ ieee80211_tx_h_encrypt(struct ieee80211_
 	return TX_DROP;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_calculate_duration(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
@@ -776,7 +776,7 @@ ieee80211_tx_h_calculate_duration(struct
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
 {
 	int i;
@@ -797,24 +797,6 @@ ieee80211_tx_h_stats(struct ieee80211_tx
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
@@ -1114,16 +1096,29 @@ static int invoke_tx_handlers(struct iee
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
 		dev_kfree_skb(skb);
--- everything.orig/net/mac80211/ieee80211_i.h	2008-06-20 01:05:00.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-06-20 01:05:05.000000000 +0200
@@ -942,4 +942,10 @@ int ieee80211_frame_duration(struct ieee
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

