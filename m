Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35224 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434AbbDJNI7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 09:08:59 -0400
Received: by lbbuc2 with SMTP id uc2so13224986lbb.2
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2015 06:08:57 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: change static wep key handling for client mode
Date: Fri, 10 Apr 2015 13:05:58 +0000
Message-Id: <1428671158-8159-1-git-send-email-michal.kazior@tieto.com> (sfid-20150410_150903_062947_26DE8359)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 sets static WEP keys as groupwise while
firmware requires them to be installed twice as
both pairwise and groupwise.

Until now these keys were installed once as
pairwise only and, due to that special handling,
needed additional tricks to support 802.1x as
well.

Without this patch in some cases (when AP and
ath10k client use different default tx keys)
multicast communication was broken.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 89 +++++++++--------------------------
 1 file changed, 23 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a7a84f52b8b4..79ce278ddb32 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -360,47 +360,6 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
 	return first_errno;
 }
 
-static int ath10k_mac_vif_sta_fix_wep_key(struct ath10k_vif *arvif, int keyidx)
-{
-	struct ath10k *ar = arvif->ar;
-	enum nl80211_iftype iftype = arvif->vif->type;
-	struct ieee80211_key_conf *key;
-	u32 flags;
-	int ret;
-	int i;
-
-	lockdep_assert_held(&ar->conf_mutex);
-
-	if (iftype != NL80211_IFTYPE_STATION)
-		return 0;
-
-	if (keyidx < 0)
-		return 0;
-
-	for (i = 0; i < ARRAY_SIZE(arvif->wep_keys); i++) {
-		if (!arvif->wep_keys[i])
-			continue;
-
-		key = arvif->wep_keys[i];
-
-		flags = 0;
-		flags |= WMI_KEY_PAIRWISE;
-
-		if (key->keyidx == keyidx)
-			flags |= WMI_KEY_TX_USAGE;
-
-		ret = ath10k_install_key(arvif, key, SET_KEY, arvif->bssid,
-					 flags);
-		if (ret) {
-			ath10k_warn(ar, "failed to install key %i on vdev %i: %d\n",
-				    key->keyidx, arvif->vdev_id, ret);
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
 static int ath10k_mac_vif_update_wep_key(struct ath10k_vif *arvif,
 					 struct ieee80211_key_conf *key)
 {
@@ -4703,7 +4662,9 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	bool is_wep = key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
 		      key->cipher == WLAN_CIPHER_SUITE_WEP104;
 	int ret = 0;
+	int ret2;
 	u32 flags = 0;
+	u32 flags2;
 
 	/* this one needs to be done in software */
 	if (key->cipher == WLAN_CIPHER_SUITE_AES_CMAC)
@@ -4774,24 +4735,6 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		 */
 		if (cmd == SET_KEY && arvif->def_wep_key_idx == -1)
 			flags |= WMI_KEY_TX_USAGE;
-
-		/* mac80211 uploads static WEP keys as groupwise while fw/hw
-		 * requires pairwise keys for non-self peers, i.e. BSSID in STA
-		 * mode and associated stations in AP/IBSS.
-		 *
-		 * Static WEP keys for peer_addr=vif->addr and 802.1X WEP keys
-		 * work fine when mapped directly from mac80211.
-		 *
-		 * Note: When installing first static WEP groupwise key (which
-		 * should be pairwise) def_wep_key_idx isn't known yet (it's
-		 * equal to -1).  Since .set_default_unicast_key is called only
-		 * for static WEP it's used to re-upload the key as pairwise.
-		 */
-		if (arvif->def_wep_key_idx >= 0 &&
-		    memcmp(peer_addr, arvif->vif->addr, ETH_ALEN)) {
-			flags &= ~WMI_KEY_GROUP;
-			flags |= WMI_KEY_PAIRWISE;
-		}
 	}
 
 	ret = ath10k_install_key(arvif, key, cmd, peer_addr, flags);
@@ -4801,6 +4744,27 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		goto exit;
 	}
 
+	/* mac80211 sets static WEP keys as groupwise while firmware requires
+	 * them to be installed twice as both pairwise and groupwise.
+	 */
+	if (is_wep && !sta && vif->type == NL80211_IFTYPE_STATION) {
+		flags2 = flags;
+		flags2 &= ~WMI_KEY_GROUP;
+		flags2 |= WMI_KEY_PAIRWISE;
+
+		ret = ath10k_install_key(arvif, key, cmd, peer_addr, flags2);
+		if (ret) {
+			ath10k_warn(ar, "failed to install (ucast) key for vdev %i peer %pM: %d\n",
+				    arvif->vdev_id, peer_addr, ret);
+			ret2 = ath10k_install_key(arvif, key, DISABLE_KEY,
+						  peer_addr, flags);
+			if (ret2)
+				ath10k_warn(ar, "failed to disable (mcast) key for vdev %i peer %pM: %d\n",
+					    arvif->vdev_id, peer_addr, ret2);
+			goto exit;
+		}
+	}
+
 	ath10k_set_key_h_def_keyidx(ar, arvif, cmd, key);
 
 	spin_lock_bh(&ar->data_lock);
@@ -4849,13 +4813,6 @@ static void ath10k_set_default_unicast_key(struct ieee80211_hw *hw,
 
 	arvif->def_wep_key_idx = keyidx;
 
-	ret = ath10k_mac_vif_sta_fix_wep_key(arvif, keyidx);
-	if (ret) {
-		ath10k_warn(ar, "failed to fix sta wep key on vdev %i: %d\n",
-			    arvif->vdev_id, ret);
-		goto unlock;
-	}
-
 unlock:
 	mutex_unlock(&arvif->ar->conf_mutex);
 }
-- 
2.1.4

