Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:48896 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661Ab2APJll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 04:41:41 -0500
Received: by mail-yx0-f176.google.com with SMTP id q7so1318052yen.7
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2012 01:41:40 -0800 (PST)
From: Yoni Divinsky <yoni.divinsky@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>, Yoni Divinsky <yoni.divinsky@ti.com>
Subject: [PATCH] mac80211: fix tx->skb NULL pointer dereference
Date: Mon, 16 Jan 2012 11:43:24 +0200
Message-Id: <1326707004-3352-1-git-send-email-yoni.divinsky@ti.com> (sfid-20120116_104144_714044_0D0D9702)
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
index edcd1c7..0a5558a 100644
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
+		return ieee80211_crypto_default_encrypt(tx);
 	}
 
 	return TX_DROP;
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 93aab07..3fd65ec 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -643,3 +643,22 @@ ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx)
 
 	return RX_CONTINUE;
 }
+
+ieee80211_tx_result
+ieee80211_crypto_default_encrypt(struct ieee80211_tx_data *tx)
+{
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *info = NULL;
+
+	skb_queue_walk(&tx->skbs, skb) {
+		info  = IEEE80211_SKB_CB(skb);
+
+		/* handle hw-only algorithm */
+		if (info == NULL || !info->control.hw_key)
+			return TX_DROP;
+	}
+
+	ieee80211_tx_set_protected(tx);
+
+	return TX_CONTINUE;
+}
diff --git a/net/mac80211/wpa.h b/net/mac80211/wpa.h
index baba060..9d6001a 100644
--- a/net/mac80211/wpa.h
+++ b/net/mac80211/wpa.h
@@ -32,5 +32,7 @@ ieee80211_tx_result
 ieee80211_crypto_aes_cmac_encrypt(struct ieee80211_tx_data *tx);
 ieee80211_rx_result
 ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx);
+ieee80211_tx_result
+ieee80211_crypto_default_encrypt(struct ieee80211_tx_data *tx);
 
 #endif /* WPA_H */
-- 
1.7.0.4

