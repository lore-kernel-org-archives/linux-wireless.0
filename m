Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:50487 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758875Ab0EYRm6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 13:42:58 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/3] ath9k_common: use allocated key cache entries for multi BSS crypto support
Date: Tue, 25 May 2010 19:42:45 +0200
Message-Id: <1274809366-73422-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1274809366-73422-1-git-send-email-nbd@openwrt.org>
References: <1274809366-73422-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces the buggy 'ath9k: Group Key fix for VAPs' change.

For AP mode group keys, use the BSSID as lookup mac address, with
the multicast keysearch bit set.
For IBSS mode, use the peer's MAC address with multicast keysearch.
For STA mode, keep using the group key slots.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/common.c |   37 ++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 7707341..6407a7f 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -475,10 +475,14 @@ static int ath_reserve_key_cache_slot_tkip(struct ath_common *common)
 	return -1;
 }
 
-static int ath_reserve_key_cache_slot(struct ath_common *common)
+static int ath_reserve_key_cache_slot(struct ath_common *common,
+				      enum ieee80211_key_alg alg)
 {
 	int i;
 
+	if (alg == ALG_TKIP)
+		return ath_reserve_key_cache_slot_tkip(common);
+
 	/* First, try to find slots that would not be available for TKIP. */
 	if (common->splitmic) {
 		for (i = IEEE80211_WEP_NKID; i < common->keymax / 4; i++) {
@@ -547,6 +551,7 @@ int ath9k_cmn_key_config(struct ath_common *common,
 	struct ath_hw *ah = common->ah;
 	struct ath9k_keyval hk;
 	const u8 *mac = NULL;
+	u8 gmac[ETH_ALEN];
 	int ret = 0;
 	int idx;
 
@@ -570,9 +575,23 @@ int ath9k_cmn_key_config(struct ath_common *common,
 	memcpy(hk.kv_val, key->key, key->keylen);
 
 	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
-		/* For now, use the default keys for broadcast keys. This may
-		 * need to change with virtual interfaces. */
-		idx = key->keyidx;
+		switch (vif->type) {
+		case NL80211_IFTYPE_AP:
+			memcpy(gmac, vif->addr, ETH_ALEN);
+			gmac[0] |= 0x01;
+			mac = gmac;
+			idx = ath_reserve_key_cache_slot(common, key->alg);
+			break;
+		case NL80211_IFTYPE_ADHOC:
+			memcpy(gmac, sta->addr, ETH_ALEN);
+			gmac[0] |= 0x01;
+			mac = gmac;
+			idx = ath_reserve_key_cache_slot(common, key->alg);
+			break;
+		default:
+			idx = key->keyidx;
+			break;
+		}
 	} else if (key->keyidx) {
 		if (WARN_ON(!sta))
 			return -EOPNOTSUPP;
@@ -589,14 +608,12 @@ int ath9k_cmn_key_config(struct ath_common *common,
 			return -EOPNOTSUPP;
 		mac = sta->addr;
 
-		if (key->alg == ALG_TKIP)
-			idx = ath_reserve_key_cache_slot_tkip(common);
-		else
-			idx = ath_reserve_key_cache_slot(common);
-		if (idx < 0)
-			return -ENOSPC; /* no free key cache entries */
+		idx = ath_reserve_key_cache_slot(common, key->alg);
 	}
 
+	if (idx < 0)
+		return -ENOSPC; /* no free key cache entries */
+
 	if (key->alg == ALG_TKIP)
 		ret = ath_setkey_tkip(common, idx, key->key, &hk, mac,
 				      vif->type == NL80211_IFTYPE_AP);
-- 
1.6.4.2

