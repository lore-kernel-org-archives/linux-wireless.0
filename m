Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:48146 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516Ab2APNRK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 08:17:10 -0500
Received: by mail-yw0-f49.google.com with SMTP id j72so1455546yhj.8
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2012 05:17:09 -0800 (PST)
From: Yoni Divinsky <yoni.divinsky@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>, Yoni Divinsky <yoni.divinsky@ti.com>
Subject: [PATCH v2] mac80211: fix tx->skb NULL pointer dereference
Date: Mon, 16 Jan 2012 15:18:59 +0200
Message-Id: <1326719939-5234-1-git-send-email-yoni.divinsky@ti.com> (sfid-20120116_141717_531200_5C531512)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In function ieee80211_tx_h_encrypt the var info was
initialized from tx->skb, since the fucntion
is called after the function ieee80211_tx_h_fragment
tx->skb is not valid anymore.

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
---
 net/mac80211/tx.c  |   10 +---------
 net/mac80211/wpa.c |   19 +++++++++++++++++++
 net/mac80211/wpa.h |    2 ++
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index edcd1c7..e05667c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1001,8 +1001,6 @@ ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-
 	if (!tx->key)
 		return TX_CONTINUE;
 
@@ -1017,13 +1015,7 @@ ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		return ieee80211_crypto_aes_cmac_encrypt(tx);
 	default:
-		/* handle hw-only algorithm */
-		if (info->control.hw_key) {
-			ieee80211_tx_set_protected(tx);
-			return TX_CONTINUE;
-		}
-		break;
-
+		return ieee80211_crypto_hw_encrypt(tx);
 	}
 
 	return TX_DROP;
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 93aab07..89be1ee 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -643,3 +643,22 @@ ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx)
 
 	return RX_CONTINUE;
 }
+
+ieee80211_tx_result
+ieee80211_crypto_hw_encrypt(struct ieee80211_tx_data *tx)
+{
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *info = NULL;
+
+	skb_queue_walk(&tx->skbs, skb) {
+		info  = IEEE80211_SKB_CB(skb);
+
+		/* handle hw-only algorithm */
+		if (!info->control.hw_key)
+			return TX_DROP;
+	}
+
+	ieee80211_tx_set_protected(tx);
+
+	return TX_CONTINUE;
+}
diff --git a/net/mac80211/wpa.h b/net/mac80211/wpa.h
index baba060..07e33f8 100644
--- a/net/mac80211/wpa.h
+++ b/net/mac80211/wpa.h
@@ -32,5 +32,7 @@ ieee80211_tx_result
 ieee80211_crypto_aes_cmac_encrypt(struct ieee80211_tx_data *tx);
 ieee80211_rx_result
 ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx);
+ieee80211_tx_result
+ieee80211_crypto_hw_encrypt(struct ieee80211_tx_data *tx);
 
 #endif /* WPA_H */
-- 
1.7.0.4

