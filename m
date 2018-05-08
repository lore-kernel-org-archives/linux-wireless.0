Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53870 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753392AbeEHBe7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 21:34:59 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH v2] ath10k: support for multicast rate control
Date: Mon,  7 May 2018 18:34:51 -0700
Message-Id: <1525743291-4306-1-git-send-email-pradeepc@codeaurora.org> (sfid-20180508_033505_642832_A8189C04)
In-Reply-To: <cebad8674a69761e32a1a882de9a1259657c65d4>
References: <cebad8674a69761e32a1a882de9a1259657c65d4>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Issues wmi command to firmwre when multicast rate change is received
with the new BSS_CHANGED_MCAST_RATE flag.
Also fixes the incorrect fixed_rate setting for CCK rates which got
introduced with addition of ath10k_rates_rev2 enum.

Tested on QCA9984 with firmware ver 10.4-3.6-00104

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
v2:
 - fixed the CCK rates setting for mcast_rate and fixed_rate paths.
 - set broadcast rate along with multicast rate setting.

 drivers/net/wireless/ath/ath10k/mac.c | 54 ++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 3d7119a..70a0563 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -101,6 +101,8 @@
 #define ath10k_g_rates_rev2 (ath10k_rates_rev2 + 0)
 #define ath10k_g_rates_rev2_size (ARRAY_SIZE(ath10k_rates_rev2))
 
+#define ath10k_wmi_legacy_rates ath10k_rates
+
 static bool ath10k_mac_bitrate_is_cck(int bitrate)
 {
 	switch (bitrate) {
@@ -5426,8 +5428,12 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = (void *)vif->drv_priv;
-	int ret = 0;
+	struct cfg80211_chan_def def;
 	u32 vdev_param, pdev_param, slottime, preamble;
+	u16 bitrate, hw_value;
+	u8 rate;
+	int rateidx, ret = 0;
+	enum nl80211_band band;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -5595,6 +5601,44 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 				    arvif->vdev_id, ret);
 	}
 
+	if (changed & BSS_CHANGED_MCAST_RATE &&
+	    !WARN_ON(ath10k_mac_vif_chan(arvif->vif, &def))) {
+		band = def.chan->band;
+		rateidx = vif->bss_conf.mcast_rate[band] - 1;
+
+		if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY)
+			rateidx += ATH10K_MAC_FIRST_OFDM_RATE_IDX;
+
+		bitrate = ath10k_wmi_legacy_rates[rateidx].bitrate;
+		hw_value = ath10k_wmi_legacy_rates[rateidx].hw_value;
+		if (ath10k_mac_bitrate_is_cck(bitrate))
+			preamble = WMI_RATE_PREAMBLE_CCK;
+		else
+			preamble = WMI_RATE_PREAMBLE_OFDM;
+
+		rate = ATH10K_HW_RATECODE(hw_value, 0, preamble);
+
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
+			   "mac vdev %d mcast_rate %x\n",
+			   arvif->vdev_id, rate);
+
+		vdev_param = ar->wmi.vdev_param->mcast_data_rate;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
+						vdev_param, rate);
+		if (ret)
+			ath10k_warn(ar,
+				    "failed to set mcast rate on vdev %i: %d\n",
+				    arvif->vdev_id,  ret);
+
+		vdev_param = ar->wmi.vdev_param->bcast_data_rate;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
+						vdev_param, rate);
+		if (ret)
+			ath10k_warn(ar,
+				    "failed to set bcast rate on vdev %i: %d\n",
+				    arvif->vdev_id,  ret);
+	}
+
 	mutex_unlock(&ar->conf_mutex);
 }
 
@@ -6895,7 +6939,6 @@ ath10k_mac_bitrate_mask_get_single_rate(
 					const struct cfg80211_bitrate_mask *mask,
 					u8 *rate, u8 *nss)
 {
-	struct ieee80211_supported_band *sband = &ar->mac.sbands[band];
 	int rate_idx;
 	int i;
 	u16 bitrate;
@@ -6905,8 +6948,11 @@ ath10k_mac_bitrate_mask_get_single_rate(
 	if (hweight32(mask->control[band].legacy) == 1) {
 		rate_idx = ffs(mask->control[band].legacy) - 1;
 
-		hw_rate = sband->bitrates[rate_idx].hw_value;
-		bitrate = sband->bitrates[rate_idx].bitrate;
+		if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY)
+			rate_idx += ATH10K_MAC_FIRST_OFDM_RATE_IDX;
+
+		hw_rate = ath10k_wmi_legacy_rates[rate_idx].hw_value;
+		bitrate = ath10k_wmi_legacy_rates[rate_idx].bitrate;
 
 		if (ath10k_mac_bitrate_is_cck(bitrate))
 			preamble = WMI_RATE_PREAMBLE_CCK;
-- 
1.9.1
