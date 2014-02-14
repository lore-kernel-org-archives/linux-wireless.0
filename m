Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:44232 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaBNNu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 08:50:59 -0500
Received: by mail-ea0-f170.google.com with SMTP id g15so4023716eak.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Feb 2014 05:50:57 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] ath10k: fix SMPS support
Date: Fri, 14 Feb 2014 14:45:51 +0100
Message-Id: <1392385551-3590-1-git-send-email-michal.kazior@tieto.com> (sfid-20140214_145103_005933_FD842BF0)
In-Reply-To: <1391673591-8907-1-git-send-email-michal.kazior@tieto.com>
References: <1391673591-8907-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware ignores SMPS flags in peer assoc command.

For SMPS to work it is necessary to set peer
parameter after peer assoc command so that tx
chainmask is setup properly.

This should fix packet loss and improve throughput
with stations that have SMPS enabled upon
association.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * add comment why ap_sta->ht_cap needs to be copied


 drivers/net/wireless/ath/ath10k/mac.c | 56 +++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 144b4d6..0f9e59c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1082,7 +1082,6 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 				   struct wmi_peer_assoc_complete_arg *arg)
 {
 	const struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
-	int smps;
 	int i, n;
 
 	lockdep_assert_held(&ar->conf_mutex);
@@ -1128,17 +1127,6 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 		arg->peer_flags |= WMI_PEER_STBC;
 	}
 
-	smps = ht_cap->cap & IEEE80211_HT_CAP_SM_PS;
-	smps >>= IEEE80211_HT_CAP_SM_PS_SHIFT;
-
-	if (smps == WLAN_HT_CAP_SM_PS_STATIC) {
-		arg->peer_flags |= WMI_PEER_SPATIAL_MUX;
-		arg->peer_flags |= WMI_PEER_STATIC_MIMOPS;
-	} else if (smps == WLAN_HT_CAP_SM_PS_DYNAMIC) {
-		arg->peer_flags |= WMI_PEER_SPATIAL_MUX;
-		arg->peer_flags |= WMI_PEER_DYN_MIMOPS;
-	}
-
 	if (ht_cap->mcs.rx_mask[1] && ht_cap->mcs.rx_mask[2])
 		arg->peer_rate_caps |= WMI_RC_TS_FLAG;
 	else if (ht_cap->mcs.rx_mask[1])
@@ -1363,6 +1351,33 @@ static int ath10k_peer_assoc_prepare(struct ath10k *ar,
 	return 0;
 }
 
+static const u32 ath10k_smps_map[] = {
+	[WLAN_HT_CAP_SM_PS_STATIC] = WMI_PEER_SMPS_STATIC,
+	[WLAN_HT_CAP_SM_PS_DYNAMIC] = WMI_PEER_SMPS_DYNAMIC,
+	[WLAN_HT_CAP_SM_PS_INVALID] = WMI_PEER_SMPS_PS_NONE,
+	[WLAN_HT_CAP_SM_PS_DISABLED] = WMI_PEER_SMPS_PS_NONE,
+};
+
+static int ath10k_setup_peer_smps(struct ath10k *ar, struct ath10k_vif *arvif,
+				  const u8 *addr,
+				  const struct ieee80211_sta_ht_cap *ht_cap)
+{
+	int smps;
+
+	if (!ht_cap->ht_supported)
+		return 0;
+
+	smps = ht_cap->cap & IEEE80211_HT_CAP_SM_PS;
+	smps >>= IEEE80211_HT_CAP_SM_PS_SHIFT;
+
+	if (smps >= ARRAY_SIZE(ath10k_smps_map))
+		return -EINVAL;
+
+	return ath10k_wmi_peer_set_param(ar, arvif->vdev_id, addr,
+					 WMI_PEER_SMPS_STATE,
+					 ath10k_smps_map[smps]);
+}
+
 /* can be called only in mac80211 callbacks due to `key_count` usage */
 static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
@@ -1370,6 +1385,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ieee80211_sta_ht_cap ht_cap;
 	struct wmi_peer_assoc_complete_arg peer_arg;
 	struct ieee80211_sta *ap_sta;
 	int ret;
@@ -1386,6 +1402,10 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 		return;
 	}
 
+	/* ap_sta must be accessed only within rcu section which must be left
+	 * before calling ath10k_setup_peer_smps() which might sleep. */
+	ht_cap = ap_sta->ht_cap;
+
 	ret = ath10k_peer_assoc_prepare(ar, arvif, ap_sta,
 					bss_conf, &peer_arg);
 	if (ret) {
@@ -1404,6 +1424,12 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 		return;
 	}
 
+	ret = ath10k_setup_peer_smps(ar, arvif, bss_conf->bssid, &ht_cap);
+	if (ret) {
+		ath10k_warn("failed to setup peer SMPS: %d\n", ret);
+		return;
+	}
+
 	ath10k_dbg(ATH10K_DBG_MAC,
 		   "mac vdev %d up (associated) bssid %pM aid %d\n",
 		   arvif->vdev_id, bss_conf->bssid, bss_conf->aid);
@@ -1485,6 +1511,12 @@ static int ath10k_station_assoc(struct ath10k *ar, struct ath10k_vif *arvif,
 		return ret;
 	}
 
+	ret = ath10k_setup_peer_smps(ar, arvif, sta->addr, &sta->ht_cap);
+	if (ret) {
+		ath10k_warn("failed to setup peer SMPS: %d\n", ret);
+		return ret;
+	}
+
 	ret = ath10k_install_peer_wep_keys(arvif, sta->addr);
 	if (ret) {
 		ath10k_warn("could not install peer wep keys (%d)\n", ret);
-- 
1.8.5.3

