Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36009 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbbBRNOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2015 08:14:22 -0500
Received: by mail-wg0-f47.google.com with SMTP id x12so1065810wgg.6
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2015 05:14:21 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: fix broken traffic for 802.1x in client mode
Date: Wed, 18 Feb 2015 14:02:26 +0100
Message-Id: <1424264547-2932-1-git-send-email-michal.kazior@tieto.com> (sfid-20150218_141426_949080_DE3B373D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When running 802.1x WEP keys must be installed
without pairwise-groupwise swap (which is
necessary for static WEP).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 122 ++++++++++++++++++++++++++--------
 1 file changed, 93 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0f39af7..733c79d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -37,7 +37,7 @@
 static int ath10k_send_key(struct ath10k_vif *arvif,
 			   struct ieee80211_key_conf *key,
 			   enum set_key_cmd cmd,
-			   const u8 *macaddr, bool def_idx)
+			   const u8 *macaddr, u32 flags)
 {
 	struct ath10k *ar = arvif->ar;
 	struct wmi_vdev_install_key_arg arg = {
@@ -45,16 +45,12 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 		.key_idx = key->keyidx,
 		.key_len = key->keylen,
 		.key_data = key->key,
+		.key_flags = flags,
 		.macaddr = macaddr,
 	};
 
 	lockdep_assert_held(&arvif->ar->conf_mutex);
 
-	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
-		arg.key_flags = WMI_KEY_PAIRWISE;
-	else
-		arg.key_flags = WMI_KEY_GROUP;
-
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
 		arg.key_cipher = WMI_CIPHER_AES_CCM;
@@ -68,13 +64,6 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
 		arg.key_cipher = WMI_CIPHER_WEP;
-		/* AP/IBSS mode requires self-key to be groupwise
-		 * Otherwise pairwise key must be set */
-		if (memcmp(macaddr, arvif->vif->addr, ETH_ALEN))
-			arg.key_flags = WMI_KEY_PAIRWISE;
-
-		if (def_idx)
-			arg.key_flags |= WMI_KEY_TX_USAGE;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 		/* this one needs to be done in software */
@@ -95,7 +84,7 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
 static int ath10k_install_key(struct ath10k_vif *arvif,
 			      struct ieee80211_key_conf *key,
 			      enum set_key_cmd cmd,
-			      const u8 *macaddr, bool def_idx)
+			      const u8 *macaddr, u32 flags)
 {
 	struct ath10k *ar = arvif->ar;
 	int ret;
@@ -104,7 +93,7 @@ static int ath10k_install_key(struct ath10k_vif *arvif,
 
 	reinit_completion(&ar->install_key_done);
 
-	ret = ath10k_send_key(arvif, key, cmd, macaddr, def_idx);
+	ret = ath10k_send_key(arvif, key, cmd, macaddr, flags);
 	if (ret)
 		return ret;
 
@@ -122,7 +111,7 @@ static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,
 	struct ath10k_peer *peer;
 	int ret;
 	int i;
-	bool def_idx;
+	u32 flags;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -136,14 +125,16 @@ static int ath10k_install_peer_wep_keys(struct ath10k_vif *arvif,
 	for (i = 0; i < ARRAY_SIZE(arvif->wep_keys); i++) {
 		if (arvif->wep_keys[i] == NULL)
 			continue;
+
+		flags = 0;
+		flags |= WMI_KEY_PAIRWISE;
+
 		/* set TX_USAGE flag for default key id */
 		if (arvif->def_wep_key_idx == i)
-			def_idx = true;
-		else
-			def_idx = false;
+			flags |= WMI_KEY_TX_USAGE;
 
 		ret = ath10k_install_key(arvif, arvif->wep_keys[i], SET_KEY,
-					 addr, def_idx);
+					 addr, flags);
 		if (ret)
 			return ret;
 
@@ -163,6 +154,7 @@ static int ath10k_clear_peer_keys(struct ath10k_vif *arvif,
 	int first_errno = 0;
 	int ret;
 	int i;
+	u32 flags = 0;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -179,7 +171,7 @@ static int ath10k_clear_peer_keys(struct ath10k_vif *arvif,
 
 		/* key flags are not required to delete the key */
 		ret = ath10k_install_key(arvif, peer->keys[i],
-					 DISABLE_KEY, addr, false);
+					 DISABLE_KEY, addr, flags);
 		if (ret && first_errno == 0)
 			first_errno = ret;
 
@@ -229,6 +221,7 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
 	int first_errno = 0;
 	int ret;
 	int i;
+	u32 flags = 0;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -254,7 +247,7 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
 		if (i == ARRAY_SIZE(peer->keys))
 			break;
 		/* key flags are not required to delete the key */
-		ret = ath10k_install_key(arvif, key, DISABLE_KEY, addr, false);
+		ret = ath10k_install_key(arvif, key, DISABLE_KEY, addr, flags);
 		if (ret && first_errno == 0)
 			first_errno = ret;
 
@@ -266,6 +259,44 @@ static int ath10k_clear_vdev_key(struct ath10k_vif *arvif,
 	return first_errno;
 }
 
+static int ath10k_mac_vif_sta_fix_wep_key(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	enum nl80211_iftype iftype = arvif->vif->type;
+	struct ieee80211_key_conf *key;
+	u32 flags = 0;
+	int num = 0;
+	int i;
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (iftype != NL80211_IFTYPE_STATION)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(arvif->wep_keys); i++) {
+		if (arvif->wep_keys[i]) {
+			key = arvif->wep_keys[i];
+			++num;
+		}
+	}
+
+	if (num != 1)
+		return 0;
+
+	flags |= WMI_KEY_PAIRWISE;
+	flags |= WMI_KEY_TX_USAGE;
+
+	ret = ath10k_install_key(arvif, key, SET_KEY, arvif->bssid, flags);
+	if (ret) {
+		ath10k_warn(ar, "failed to install key %i on vdev %i: %d\n",
+			    key->keyidx, arvif->vdev_id, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 /*********************/
 /* General utilities */
 /*********************/
@@ -3786,8 +3817,8 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	const u8 *peer_addr;
 	bool is_wep = key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
 		      key->cipher == WLAN_CIPHER_SUITE_WEP104;
-	bool def_idx = false;
 	int ret = 0;
+	u32 flags = 0;
 
 	if (key->keyidx > WMI_MAX_KEY_INDEX)
 		return -ENOSPC;
@@ -3830,16 +3861,41 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 		if (cmd == DISABLE_KEY)
 			ath10k_clear_vdev_key(arvif, key);
+
+		/* 802.1x never sets the def_wep_key_idx so each set_key()
+		 * call changes default tx key.
+		 *
+		 * Static WEP sets def_wep_key_idx via .set_default_unicast_key
+		 * after first set_key().
+		 */
+		if (cmd == SET_KEY && arvif->def_wep_key_idx == -1)
+			flags |= WMI_KEY_TX_USAGE;
 	}
 
-	/* set TX_USAGE flag for all the keys incase of dot1x-WEP. For
-	 * static WEP, do not set this flag for the keys whose key id
-	 * is  greater than default key id.
+	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
+		flags |= WMI_KEY_PAIRWISE;
+	else
+		flags |= WMI_KEY_GROUP;
+
+	/* mac80211 uploads static WEP keys as groupwise while fw/hw requires
+	 * pairwise keys for non-self peers, i.e. BSSID in STA mode and
+	 * associated stations in AP/IBSS.
+	 *
+	 * Static WEP keys for peer_addr=vif->addr and 802.1X WEP keys work
+	 * fine when mapped directly from mac80211.
+	 *
+	 * Note: When installing first static WEP groupwise key (which should
+	 * be pairwise) def_wep_key_idx isn't known yet (it's equal to -1).
+	 * Since .set_default_unicast_key is called only for static WEP it's
+	 * used to re-upload the key as pairwise.
 	 */
-	if (arvif->def_wep_key_idx == -1)
-		def_idx = true;
+	if (arvif->def_wep_key_idx >= 0 &&
+	    memcmp(peer_addr, arvif->vif->addr, ETH_ALEN)) {
+		flags &= ~WMI_KEY_GROUP;
+		flags |= WMI_KEY_PAIRWISE;
+	}
 
-	ret = ath10k_install_key(arvif, key, cmd, peer_addr, def_idx);
+	ret = ath10k_install_key(arvif, key, cmd, peer_addr, flags);
 	if (ret) {
 		ath10k_warn(ar, "failed to install key for vdev %i peer %pM: %d\n",
 			    arvif->vdev_id, peer_addr, ret);
@@ -3893,6 +3949,14 @@ static void ath10k_set_default_unicast_key(struct ieee80211_hw *hw,
 	}
 
 	arvif->def_wep_key_idx = keyidx;
+
+	ret = ath10k_mac_vif_sta_fix_wep_key(arvif);
+	if (ret) {
+		ath10k_warn(ar, "failed to fix sta wep key on vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+		goto unlock;
+	}
+
 unlock:
 	mutex_unlock(&arvif->ar->conf_mutex);
 }
-- 
1.8.5.3

