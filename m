Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab0HEV4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 17:56:55 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: remove duplicate get_hw_crypto_keytype()
Date: Thu,  5 Aug 2010 17:56:54 -0400
Message-Id: <1281045414-28041-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ath9k_cmn_get_hw_crypto_keytype() instead which is
already exported and shared, and does exactly the same thing.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 4dda14e..457f076 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1407,22 +1407,6 @@ static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
 	return htype;
 }
 
-static int get_hw_crypto_keytype(struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-
-	if (tx_info->control.hw_key) {
-		if (tx_info->control.hw_key->alg == ALG_WEP)
-			return ATH9K_KEY_TYPE_WEP;
-		else if (tx_info->control.hw_key->alg == ALG_TKIP)
-			return ATH9K_KEY_TYPE_TKIP;
-		else if (tx_info->control.hw_key->alg == ALG_CCMP)
-			return ATH9K_KEY_TYPE_AES;
-	}
-
-	return ATH9K_KEY_TYPE_CLEAR;
-}
-
 static void assign_aggr_tid_seqno(struct sk_buff *skb,
 				  struct ath_buf *bf)
 {
@@ -1661,7 +1645,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 		bf->bf_state.bfs_paprd_timestamp = jiffies;
 	bf->bf_flags = setup_tx_flags(skb, use_ldpc);
 
-	bf->bf_keytype = get_hw_crypto_keytype(skb);
+	bf->bf_keytype = ath9k_cmn_get_hw_crypto_keytype(skb);
 	if (bf->bf_keytype != ATH9K_KEY_TYPE_CLEAR) {
 		bf->bf_frmlen += tx_info->control.hw_key->icv_len;
 		bf->bf_keyix = tx_info->control.hw_key->hw_key_idx;
-- 
1.7.0.4

