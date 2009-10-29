Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZJ2HoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 03:44:15 -0400
Subject: [PATCH] mac80211: make CALL_TXH a statement
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Oct 2009 08:43:48 +0100
Message-ID: <1256802228.3865.55.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The multi-line code in this macro wasn't wrapped
in do {} while (0) so we cannot use it in an if()
branch safely in the future -- fix that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-10-06 14:57:11.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-10-06 14:57:39.000000000 +0200
@@ -1201,23 +1201,25 @@ static int invoke_tx_handlers(struct iee
 	struct sk_buff *skb = tx->skb;
 	ieee80211_tx_result res = TX_DROP;
 
-#define CALL_TXH(txh)		\
-	res = txh(tx);		\
-	if (res != TX_CONTINUE)	\
-		goto txh_done;
-
-	CALL_TXH(ieee80211_tx_h_check_assoc)
-	CALL_TXH(ieee80211_tx_h_ps_buf)
-	CALL_TXH(ieee80211_tx_h_select_key)
-	CALL_TXH(ieee80211_tx_h_michael_mic_add)
-	CALL_TXH(ieee80211_tx_h_rate_ctrl)
-	CALL_TXH(ieee80211_tx_h_misc)
-	CALL_TXH(ieee80211_tx_h_sequence)
-	CALL_TXH(ieee80211_tx_h_fragment)
+#define CALL_TXH(txh) \
+	do {				\
+		res = txh(tx);		\
+		if (res != TX_CONTINUE)	\
+			goto txh_done;	\
+	} while (0)
+
+	CALL_TXH(ieee80211_tx_h_check_assoc);
+	CALL_TXH(ieee80211_tx_h_ps_buf);
+	CALL_TXH(ieee80211_tx_h_select_key);
+	CALL_TXH(ieee80211_tx_h_michael_mic_add);
+	CALL_TXH(ieee80211_tx_h_rate_ctrl);
+	CALL_TXH(ieee80211_tx_h_misc);
+	CALL_TXH(ieee80211_tx_h_sequence);
+	CALL_TXH(ieee80211_tx_h_fragment);
 	/* handlers after fragment must be aware of tx info fragmentation! */
-	CALL_TXH(ieee80211_tx_h_stats)
-	CALL_TXH(ieee80211_tx_h_encrypt)
-	CALL_TXH(ieee80211_tx_h_calculate_duration)
+	CALL_TXH(ieee80211_tx_h_stats);
+	CALL_TXH(ieee80211_tx_h_encrypt);
+	CALL_TXH(ieee80211_tx_h_calculate_duration);
 #undef CALL_TXH
 
  txh_done:


