Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51116 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbBRNOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2015 08:14:23 -0500
Received: by mail-wi0-f170.google.com with SMTP id hi2so38866164wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2015 05:14:22 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: fix broken traffic for static WEP in IBSS
Date: Wed, 18 Feb 2015 14:02:27 +0100
Message-Id: <1424264547-2932-2-git-send-email-michal.kazior@tieto.com> (sfid-20150218_141427_868572_A580BD53)
In-Reply-To: <1424264547-2932-1-git-send-email-michal.kazior@tieto.com>
References: <1424264547-2932-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When WEP keys are uploaded it's possible that
there are stations associated already (e.g. when
merging) without any keys. Static WEP needs an
explicit per-peer key upload.

Make sure to re-upload wep keys if necessary.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 41 +++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 733c79d..e7e7d92 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -297,6 +297,39 @@ static int ath10k_mac_vif_sta_fix_wep_key(struct ath10k_vif *arvif)
 	return 0;
 }
 
+static int ath10k_mac_vif_update_wep_key(struct ath10k_vif *arvif,
+					 struct ieee80211_key_conf *key)
+{
+	struct ath10k *ar = arvif->ar;
+	struct ath10k_peer *peer;
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	list_for_each_entry(peer, &ar->peers, list) {
+		if (!memcmp(peer->addr, arvif->vif->addr, ETH_ALEN))
+			continue;
+
+		if (!memcmp(peer->addr, arvif->bssid, ETH_ALEN))
+			continue;
+
+		if (peer->keys[key->keyidx] == key)
+			continue;
+
+		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vif vdev %i update key %i needs update\n",
+			   arvif->vdev_id, key->keyidx);
+
+		ret = ath10k_install_peer_wep_keys(arvif, peer->addr);
+		if (ret) {
+			ath10k_warn(ar, "failed to update wep keys on vdev %i for peer %pM: %d\n",
+				    arvif->vdev_id, peer->addr, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 /*********************/
 /* General utilities */
 /*********************/
@@ -3862,6 +3895,14 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		if (cmd == DISABLE_KEY)
 			ath10k_clear_vdev_key(arvif, key);
 
+		/* When WEP keys are uploaded it's possible that there are
+		 * stations associated already (e.g. when merging) without any
+		 * keys. Static WEP needs an explicit per-peer key upload.
+		 */
+		if (vif->type == NL80211_IFTYPE_ADHOC &&
+		    cmd == SET_KEY)
+			ath10k_mac_vif_update_wep_key(arvif, key);
+
 		/* 802.1x never sets the def_wep_key_idx so each set_key()
 		 * call changes default tx key.
 		 *
-- 
1.8.5.3

