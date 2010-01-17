Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55800 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab0AQAtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2010 19:49:08 -0500
Message-Id: <20100117004824.714892919@sipsolutions.net>
Date: Sun, 17 Jan 2010 01:47:55 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] mac80211: move and rename misc tx handler
References: <20100117004754.624627000@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This TX handler is used only for assigning the
station pointer in the control information, so
give it a better name. Also move it before rate
control.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2010-01-16 20:18:22.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2010-01-16 20:18:50.000000000 +0100
@@ -560,6 +560,17 @@ ieee80211_tx_h_select_key(struct ieee802
 }
 
 static ieee80211_tx_result debug_noinline
+ieee80211_tx_h_sta(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+
+	if (tx->sta)
+		info->control.sta = &tx->sta->sta;
+
+	return TX_CONTINUE;
+}
+
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
@@ -734,17 +745,6 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 }
 
 static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-
-	if (tx->sta)
-		info->control.sta = &tx->sta->sta;
-
-	return TX_CONTINUE;
-}
-
-static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
@@ -1292,10 +1292,10 @@ static int invoke_tx_handlers(struct iee
 	CALL_TXH(ieee80211_tx_h_check_assoc);
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_select_key);
+	CALL_TXH(ieee80211_tx_h_sta);
 	CALL_TXH(ieee80211_tx_h_michael_mic_add);
 	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
-	CALL_TXH(ieee80211_tx_h_misc);
 	CALL_TXH(ieee80211_tx_h_sequence);
 	CALL_TXH(ieee80211_tx_h_fragment);
 	/* handlers after fragment must be aware of tx info fragmentation! */


