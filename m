Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60013 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1HHTUO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 15:20:14 -0400
Received: by qyk38 with SMTP id 38so1799327qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 12:20:13 -0700 (PDT)
From: Bill Jordan <bjordan@rajant.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Cc: Bill Jordan <bjordan@rajant.com>
Subject: [PATCH] ath: Fix hardware decryption of WEP
Date: Mon,  8 Aug 2011 15:19:53 -0400
Message-Id: <1312831193-8691-1-git-send-email-bjordan@rajant.com> (sfid-20110808_212018_791510_A30EEDE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first 4 hardware key indexes are reserved for WEP, but
never programmed. The result was that WEP always used
software decryption.

Signed-off-by: Bill Jordan <bjordan@rajant.com>
---
 drivers/net/wireless/ath/key.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 17b0efd..73177f1 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -501,7 +501,11 @@ int ath_key_config(struct ath_common *common,
 	if (key->keylen)
 		memcpy(hk.kv_val, key->key, key->keylen);
 
-	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+	if (hk.kv_type == ATH_CIPHER_WEP) {
+		if (key->keyidx >= IEEE80211_WEP_NKID)
+			return -EOPNOTSUPP;
+		idx = key->keyidx;
+	} else if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
 		switch (vif->type) {
 		case NL80211_IFTYPE_AP:
 			memcpy(gmac, vif->addr, ETH_ALEN);
@@ -577,8 +581,6 @@ EXPORT_SYMBOL(ath_key_config);
 void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key)
 {
 	ath_hw_keyreset(common, key->hw_key_idx);
-	if (key->hw_key_idx < IEEE80211_WEP_NKID)
-		return;
 
 	clear_bit(key->hw_key_idx, common->keymap);
 	if (key->cipher != WLAN_CIPHER_SUITE_TKIP)
-- 
1.7.4.4

