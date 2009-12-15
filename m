Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33638 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136AbZLOUK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 15:10:26 -0500
Message-Id: <20091215200738.473174942@sipsolutions.net>
Date: Tue, 15 Dec 2009 21:06:19 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Subject: [RFC/RFT 1/5] mac80211: move and rename misc tx handler
References: <20091215200618.253970634@sipsolutions.net>
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

--- wireless-testing.orig/net/mac80211/tx.c	2009-12-15 20:03:24.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-12-15 20:04:48.000000000 +0100
@@ -494,6 +494,17 @@ ieee80211_tx_h_select_key(struct ieee802
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
@@ -663,17 +674,6 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
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
@@ -1217,10 +1217,10 @@ static int invoke_tx_handlers(struct iee
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


