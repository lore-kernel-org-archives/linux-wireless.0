Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:63698 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760133AbbA3Jvp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 04:51:45 -0500
Received: by mail-we0-f171.google.com with SMTP id k11so23728548wes.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 01:51:44 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: add TxBF support
Date: Fri, 30 Jan 2015 10:50:52 +0100
Message-Id: <1422611452-21105-1-git-send-email-michal.kazior@tieto.com> (sfid-20150130_105214_314165_250D516E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If firmware advertises support for TxBF then the
driver has to instruct the firmware accordingly
during runtime. Without this patch connecting to
an AP with beamformer support would yield abysmal
Rx performance.

This has been tested with wmi-tlv and qca6174
while acting as a STA beamformee only.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 79 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h |  5 +++
 2 files changed, 84 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 15e47f4..81455dc 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1764,6 +1764,68 @@ static int ath10k_setup_peer_smps(struct ath10k *ar, struct ath10k_vif *arvif,
 					 ath10k_smps_map[smps]);
 }
 
+static int ath10k_mac_vif_recalc_txbf(struct ath10k *ar,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_sta_vht_cap vht_cap)
+{
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	int ret;
+	u32 param;
+	u32 value;
+
+	if (!(ar->vht_cap_info &
+	      (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
+	       IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE |
+	       IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
+	       IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)))
+		return 0;
+
+	param = ar->wmi.vdev_param->txbf;
+	value = 0;
+
+	if (WARN_ON(param == WMI_VDEV_PARAM_UNSUPPORTED))
+		return 0;
+
+	/* The following logic is correct. If a remote STA advertises support
+	 * for being a beamformer then we should enable us being a beamformee.
+	 */
+
+	if (ar->vht_cap_info &
+	    (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
+	     IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE)) {
+		if (vht_cap.cap & IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)
+			value |= WMI_VDEV_PARAM_TXBF_SU_TX_BFEE;
+
+		if (vht_cap.cap & IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)
+			value |= WMI_VDEV_PARAM_TXBF_MU_TX_BFEE;
+	}
+
+	if (ar->vht_cap_info &
+	    (IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
+	     IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)) {
+		if (vht_cap.cap & IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE)
+			value |= WMI_VDEV_PARAM_TXBF_SU_TX_BFER;
+
+		if (vht_cap.cap & IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE)
+			value |= WMI_VDEV_PARAM_TXBF_MU_TX_BFER;
+	}
+
+	if (value & WMI_VDEV_PARAM_TXBF_MU_TX_BFEE)
+		value |= WMI_VDEV_PARAM_TXBF_SU_TX_BFEE;
+
+	if (value & WMI_VDEV_PARAM_TXBF_MU_TX_BFER)
+		value |= WMI_VDEV_PARAM_TXBF_SU_TX_BFER;
+
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, param, value);
+	if (ret) {
+		ath10k_warn(ar, "failed to submit vdev param txbf 0x%x: %d\n",
+			    value, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 /* can be called only in mac80211 callbacks due to `key_count` usage */
 static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
@@ -1772,6 +1834,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct ieee80211_sta_ht_cap ht_cap;
+	struct ieee80211_sta_vht_cap vht_cap;
 	struct wmi_peer_assoc_complete_arg peer_arg;
 	struct ieee80211_sta *ap_sta;
 	int ret;
@@ -1794,6 +1857,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 	/* ap_sta must be accessed only within rcu section which must be left
 	 * before calling ath10k_setup_peer_smps() which might sleep. */
 	ht_cap = ap_sta->ht_cap;
+	vht_cap = ap_sta->vht_cap;
 
 	ret = ath10k_peer_assoc_prepare(ar, vif, ap_sta, &peer_arg);
 	if (ret) {
@@ -1819,6 +1883,13 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
 		return;
 	}
 
+	ret = ath10k_mac_vif_recalc_txbf(ar, vif, vht_cap);
+	if (ret) {
+		ath10k_warn(ar, "failed to recalc txbf for vdev %i on bss %pM: %d\n",
+			    arvif->vdev_id, bss_conf->bssid, ret);
+		return;
+	}
+
 	ath10k_dbg(ar, ATH10K_DBG_MAC,
 		   "mac vdev %d up (associated) bssid %pM aid %d\n",
 		   arvif->vdev_id, bss_conf->bssid, bss_conf->aid);
@@ -1843,6 +1914,7 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ieee80211_sta_vht_cap vht_cap = {};
 	int ret;
 
 	lockdep_assert_held(&ar->conf_mutex);
@@ -1855,6 +1927,13 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 		ath10k_warn(ar, "faield to down vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 
+	ret = ath10k_mac_vif_recalc_txbf(ar, vif, vht_cap);
+	if (ret) {
+		ath10k_warn(ar, "failed to recalc txbf for vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+		return;
+	}
+
 	arvif->def_wep_key_idx = 0;
 	arvif->is_up = false;
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 20ce360..8073fba 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3745,6 +3745,11 @@ enum wmi_10x_vdev_param {
 	WMI_10X_VDEV_PARAM_VHT80_RATEMASK,
 };
 
+#define WMI_VDEV_PARAM_TXBF_SU_TX_BFEE BIT(0)
+#define WMI_VDEV_PARAM_TXBF_MU_TX_BFEE BIT(1)
+#define WMI_VDEV_PARAM_TXBF_SU_TX_BFER BIT(2)
+#define WMI_VDEV_PARAM_TXBF_MU_TX_BFER BIT(3)
+
 /* slot time long */
 #define WMI_VDEV_SLOT_TIME_LONG		0x1
 /* slot time short */
-- 
1.8.5.3

