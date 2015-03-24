Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:36062 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbbCXM74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 08:59:56 -0400
Received: by labe2 with SMTP id e2so83311106lab.3
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2015 05:59:54 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: clean up set_bitrate_mask handling
Date: Tue, 24 Mar 2015 12:57:15 +0000
Message-Id: <1427201836-7741-2-git-send-email-michal.kazior@tieto.com> (sfid-20150324_140011_484266_48FC0E32)
In-Reply-To: <1427201836-7741-1-git-send-email-michal.kazior@tieto.com>
References: <1427201836-7741-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code was a bit convoluted. Clean it up and
prepare for future changes.

While at it this fixes incorrect verification of
'single nss' case when ss2 rates were missing
while ss1 and ss3 were requested resulting in
nss=3 being set:

  iw wlan1 set bitrates legacy-5 ht-mcs-5 0 1 2 3 4 5 6 7 16 17 18 19 20 21 22 23 vht-mcs-5 1:0-9 3:0-9

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |   3 -
 drivers/net/wireless/ath/ath10k/mac.c  | 446 +++++++++++++--------------------
 2 files changed, 175 insertions(+), 274 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index cbb58ff8fc25..7ab88fc611a9 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -348,9 +348,6 @@ struct ath10k_vif {
 		} ap;
 	} u;
 
-	u8 fixed_rate;
-	u8 fixed_nss;
-	u8 force_sgi;
 	bool use_cts_prot;
 	int num_legacy_stations;
 	int txpower;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 47f0c77b9271..c8cb7aa6856b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -120,6 +120,16 @@ u8 ath10k_mac_bitrate_to_idx(const struct ieee80211_supported_band *sband,
 	return 0;
 }
 
+static int ath10k_mac_get_max_vht_mcs_map(u16 mcs_map, int nss)
+{
+	switch ((mcs_map >> (2 * nss)) & 0x3) {
+	case IEEE80211_VHT_MCS_SUPPORT_0_7: return BIT(8) - 1;
+	case IEEE80211_VHT_MCS_SUPPORT_0_8: return BIT(9) - 1;
+	case IEEE80211_VHT_MCS_SUPPORT_0_9: return BIT(10) - 1;
+	}
+	return 0;
+}
+
 /**********/
 /* Crypto */
 /**********/
@@ -5579,327 +5589,221 @@ exit:
 	return ret;
 }
 
-/* Check if only one bit set */
-static int ath10k_check_single_mask(u32 mask)
+static bool
+ath10k_mac_bitrate_mask_has_single_rate(struct ath10k *ar,
+					enum ieee80211_band band,
+					const struct cfg80211_bitrate_mask *mask)
 {
-	int bit;
+	int num_rates = 0;
+	int i;
+
+	num_rates += hweight32(mask->control[band].legacy);
+
+	for (i = 0; i < ARRAY_SIZE(mask->control[band].ht_mcs); i++)
+		num_rates += hweight8(mask->control[band].ht_mcs[i]);
+
+	for (i = 0; i < ARRAY_SIZE(mask->control[band].vht_mcs); i++)
+		num_rates += hweight16(mask->control[band].vht_mcs[i]);
+
+	return num_rates == 1;
+}
+
+static bool
+ath10k_mac_bitrate_mask_get_single_nss(struct ath10k *ar,
+				       enum ieee80211_band band,
+				       const struct cfg80211_bitrate_mask *mask,
+				       int *nss)
+{
+	struct ieee80211_supported_band *sband = &ar->mac.sbands[band];
+	u16 vht_mcs_map = le16_to_cpu(sband->vht_cap.vht_mcs.tx_mcs_map);
+	u8 ht_nss_mask = 0;
+	u8 vht_nss_mask = 0;
+	int i;
+
+	if (mask->control[band].legacy)
+		return false;
+
+	for (i = 0; i < ARRAY_SIZE(mask->control[band].ht_mcs); i++) {
+		if (mask->control[band].ht_mcs[i] == 0)
+			continue;
+		else if (mask->control[band].ht_mcs[i] ==
+			 sband->ht_cap.mcs.rx_mask[i])
+			ht_nss_mask |= BIT(i);
+		else
+			return false;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(mask->control[band].vht_mcs); i++) {
+		if (mask->control[band].vht_mcs[i] == 0)
+			continue;
+		else if (mask->control[band].vht_mcs[i] ==
+			 ath10k_mac_get_max_vht_mcs_map(vht_mcs_map, i))
+			vht_nss_mask |= BIT(i);
+		else
+			return false;
+	}
+
+	if (ht_nss_mask != vht_nss_mask)
+		return false;
+
+	if (ht_nss_mask == 0)
+		return false;
+
+	if (BIT(fls(ht_nss_mask)) - 1 != ht_nss_mask)
+		return false;
+
+	*nss = fls(ht_nss_mask);
+
+	return true;
+}
+
+static int
+ath10k_mac_bitrate_mask_get_single_rate(struct ath10k *ar,
+					enum ieee80211_band band,
+					const struct cfg80211_bitrate_mask *mask,
+					u8 *rate, u8 *nss)
+{
+	struct ieee80211_supported_band *sband = &ar->mac.sbands[band];
+	int rate_idx;
+	int i;
+	u16 bitrate;
+	u8 preamble;
+	u8 hw_rate;
+
+	if (hweight32(mask->control[band].legacy) == 1) {
+		rate_idx = ffs(mask->control[band].legacy) - 1;
+
+		hw_rate = sband->bitrates[rate_idx].hw_value;
+		bitrate = sband->bitrates[rate_idx].bitrate;
+
+		if (ath10k_mac_bitrate_is_cck(bitrate))
+			preamble = WMI_RATE_PREAMBLE_CCK;
+		else
+			preamble = WMI_RATE_PREAMBLE_OFDM;
+
+		*nss = 1;
+		*rate = preamble << 6 |
+			(*nss - 1) << 4 |
+			hw_rate << 0;
 
-	bit = ffs(mask);
-	if (!bit)
 		return 0;
-
-	mask &= ~BIT(bit - 1);
-	if (mask)
-		return 2;
-
-	return 1;
-}
-
-static bool
-ath10k_default_bitrate_mask(struct ath10k *ar,
-			    enum ieee80211_band band,
-			    const struct cfg80211_bitrate_mask *mask)
-{
-	u32 legacy = 0x00ff;
-	u8 ht = 0xff, i;
-	u16 vht = 0x3ff;
-	u16 nrf = ar->num_rf_chains;
-
-	if (ar->cfg_tx_chainmask)
-		nrf = get_nss_from_chainmask(ar->cfg_tx_chainmask);
-
-	switch (band) {
-	case IEEE80211_BAND_2GHZ:
-		legacy = 0x00fff;
-		vht = 0;
-		break;
-	case IEEE80211_BAND_5GHZ:
-		break;
-	default:
-		return false;
 	}
 
-	if (mask->control[band].legacy != legacy)
-		return false;
-
-	for (i = 0; i < nrf; i++)
-		if (mask->control[band].ht_mcs[i] != ht)
-			return false;
-
-	for (i = 0; i < nrf; i++)
-		if (mask->control[band].vht_mcs[i] != vht)
-			return false;
-
-	return true;
-}
-
-static bool
-ath10k_bitrate_mask_nss(const struct cfg80211_bitrate_mask *mask,
-			enum ieee80211_band band,
-			u8 *fixed_nss)
-{
-	int ht_nss = 0, vht_nss = 0, i;
-
-	/* check legacy */
-	if (ath10k_check_single_mask(mask->control[band].legacy))
-		return false;
+	for (i = 0; i < ARRAY_SIZE(mask->control[band].ht_mcs); i++) {
+		if (hweight8(mask->control[band].ht_mcs[i]) == 1) {
+			*nss = i + 1;
+			*rate = WMI_RATE_PREAMBLE_HT << 6 |
+				(*nss - 1) << 4 |
+				(ffs(mask->control[band].ht_mcs[i]) - 1);
 
-	/* check HT */
-	for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
-		if (mask->control[band].ht_mcs[i] == 0xff)
-			continue;
-		else if (mask->control[band].ht_mcs[i] == 0x00)
-			break;
-
-		return false;
+			return 0;
+		}
 	}
 
-	ht_nss = i;
-
-	/* check VHT */
-	for (i = 0; i < NL80211_VHT_NSS_MAX; i++) {
-		if (mask->control[band].vht_mcs[i] == 0x03ff)
-			continue;
-		else if (mask->control[band].vht_mcs[i] == 0x0000)
-			break;
+	for (i = 0; i < ARRAY_SIZE(mask->control[band].vht_mcs); i++) {
+		if (hweight16(mask->control[band].vht_mcs[i]) == 1) {
+			*nss = i + 1;
+			*rate = WMI_RATE_PREAMBLE_VHT << 6 |
+				(*nss - 1) << 4 |
+				(ffs(mask->control[band].vht_mcs[i]) - 1);
 
-		return false;
+			return 0;
+		}
 	}
 
-	vht_nss = i;
-
-	if (ht_nss > 0 && vht_nss > 0)
-		return false;
-
-	if (ht_nss)
-		*fixed_nss = ht_nss;
-	else if (vht_nss)
-		*fixed_nss = vht_nss;
-	else
-		return false;
-
-	return true;
-}
-
-static bool
-ath10k_bitrate_mask_correct(const struct cfg80211_bitrate_mask *mask,
-			    enum ieee80211_band band,
-			    enum wmi_rate_preamble *preamble)
-{
-	int legacy = 0, ht = 0, vht = 0, i;
-
-	*preamble = WMI_RATE_PREAMBLE_OFDM;
-
-	/* check legacy */
-	legacy = ath10k_check_single_mask(mask->control[band].legacy);
-	if (legacy > 1)
-		return false;
-
-	/* check HT */
-	for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
-		ht += ath10k_check_single_mask(mask->control[band].ht_mcs[i]);
-	if (ht > 1)
-		return false;
-
-	/* check VHT */
-	for (i = 0; i < NL80211_VHT_NSS_MAX; i++)
-		vht += ath10k_check_single_mask(mask->control[band].vht_mcs[i]);
-	if (vht > 1)
-		return false;
-
-	/* Currently we support only one fixed_rate */
-	if ((legacy + ht + vht) != 1)
-		return false;
-
-	if (ht)
-		*preamble = WMI_RATE_PREAMBLE_HT;
-	else if (vht)
-		*preamble = WMI_RATE_PREAMBLE_VHT;
-
-	return true;
-}
-
-static bool
-ath10k_bitrate_mask_rate(struct ath10k *ar,
-			 const struct cfg80211_bitrate_mask *mask,
-			 enum ieee80211_band band,
-			 u8 *fixed_rate,
-			 u8 *fixed_nss)
-{
-	struct ieee80211_supported_band *sband;
-	u8 rate = 0, pream = 0, nss = 0, i;
-	enum wmi_rate_preamble preamble;
-
-	/* Check if single rate correct */
-	if (!ath10k_bitrate_mask_correct(mask, band, &preamble))
-		return false;
-
-	pream = preamble;
-
-	switch (preamble) {
-	case WMI_RATE_PREAMBLE_CCK:
-	case WMI_RATE_PREAMBLE_OFDM:
-		i = ffs(mask->control[band].legacy) - 1;
-		sband = &ar->mac.sbands[band];
-
-		if (WARN_ON(i >= sband->n_bitrates))
-			return false;
-
-		rate = sband->bitrates[i].hw_value;
-		break;
-	case WMI_RATE_PREAMBLE_HT:
-		for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
-			if (mask->control[band].ht_mcs[i])
-				break;
-
-		if (i == IEEE80211_HT_MCS_MASK_LEN)
-			return false;
-
-		rate = ffs(mask->control[band].ht_mcs[i]) - 1;
-		nss = i;
-		break;
-	case WMI_RATE_PREAMBLE_VHT:
-		for (i = 0; i < NL80211_VHT_NSS_MAX; i++)
-			if (mask->control[band].vht_mcs[i])
-				break;
-
-		if (i == NL80211_VHT_NSS_MAX)
-			return false;
-
-		rate = ffs(mask->control[band].vht_mcs[i]) - 1;
-		nss = i;
-		break;
-	}
-
-	*fixed_nss = nss + 1;
-	nss <<= 4;
-	pream <<= 6;
-
-	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac fixed rate pream 0x%02x nss 0x%02x rate 0x%02x\n",
-		   pream, nss, rate);
-
-	*fixed_rate = pream | nss | rate;
-
-	return true;
-}
-
-static bool ath10k_get_fixed_rate_nss(struct ath10k *ar,
-				      const struct cfg80211_bitrate_mask *mask,
-				      enum ieee80211_band band,
-				      u8 *fixed_rate,
-				      u8 *fixed_nss)
-{
-	/* First check full NSS mask, if we can simply limit NSS */
-	if (ath10k_bitrate_mask_nss(mask, band, fixed_nss))
-		return true;
-
-	/* Next Check single rate is set */
-	return ath10k_bitrate_mask_rate(ar, mask, band, fixed_rate, fixed_nss);
+	return -EINVAL;
 }
 
-static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
-				       u8 fixed_rate,
-				       u8 fixed_nss,
-				       u8 force_sgi)
+static int ath10k_mac_set_fixed_rate_params(struct ath10k_vif *arvif,
+					    u8 rate, u8 nss, u8 sgi)
 {
 	struct ath10k *ar = arvif->ar;
 	u32 vdev_param;
-	int ret = 0;
+	int ret;
 
-	mutex_lock(&ar->conf_mutex);
+	lockdep_assert_held(&ar->conf_mutex);
 
-	if (arvif->fixed_rate == fixed_rate &&
-	    arvif->fixed_nss == fixed_nss &&
-	    arvif->force_sgi == force_sgi)
-		goto exit;
-
-	if (fixed_rate == WMI_FIXED_RATE_NONE)
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac disable fixed bitrate mask\n");
-
-	if (force_sgi)
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac force sgi\n");
+	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac set fixed rate params vdev %i rate 0x%02hhx nss %hhu sgi %hhu\n",
+		   arvif->vdev_id, rate, nss, sgi);
 
 	vdev_param = ar->wmi.vdev_param->fixed_rate;
-	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
-					vdev_param, fixed_rate);
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param, rate);
 	if (ret) {
 		ath10k_warn(ar, "failed to set fixed rate param 0x%02x: %d\n",
-			    fixed_rate, ret);
-		ret = -EINVAL;
-		goto exit;
+			    rate, ret);
+		return ret;
 	}
 
-	arvif->fixed_rate = fixed_rate;
-
 	vdev_param = ar->wmi.vdev_param->nss;
-	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
-					vdev_param, fixed_nss);
-
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param, nss);
 	if (ret) {
-		ath10k_warn(ar, "failed to set fixed nss param %d: %d\n",
-			    fixed_nss, ret);
-		ret = -EINVAL;
-		goto exit;
+		ath10k_warn(ar, "failed to set nss param %d: %d\n", nss, ret);
+		return ret;
 	}
 
-	arvif->fixed_nss = fixed_nss;
-
 	vdev_param = ar->wmi.vdev_param->sgi;
-	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
-					force_sgi);
-
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param, sgi);
 	if (ret) {
-		ath10k_warn(ar, "failed to set sgi param %d: %d\n",
-			    force_sgi, ret);
-		ret = -EINVAL;
-		goto exit;
+		ath10k_warn(ar, "failed to set sgi param %d: %d\n", sgi, ret);
+		return ret;
 	}
 
-	arvif->force_sgi = force_sgi;
-
-exit:
-	mutex_unlock(&ar->conf_mutex);
-	return ret;
+	return 0;
 }
 
-static int ath10k_set_bitrate_mask(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif,
-				   const struct cfg80211_bitrate_mask *mask)
+static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  const struct cfg80211_bitrate_mask *mask)
 {
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct ath10k_chanctx *arctx = ath10k_mac_vif_ctx(arvif);
 	struct ath10k *ar = arvif->ar;
 	enum ieee80211_band band;
-	u8 fixed_rate = WMI_FIXED_RATE_NONE;
-	u8 fixed_nss = ar->num_rf_chains;
-	u8 force_sgi;
+	u8 rate;
+	u8 nss;
+	u8 sgi;
+	int single_nss;
+	int ret;
 
 	if (!arctx)
 		return -EPERM;
 
-	if (ar->cfg_tx_chainmask)
-		fixed_nss = get_nss_from_chainmask(ar->cfg_tx_chainmask);
-
 	band = arctx->conf.def.chan->band;
 
-	force_sgi = mask->control[band].gi;
-	if (force_sgi == NL80211_TXRATE_FORCE_LGI)
+	sgi = mask->control[band].gi;
+	if (sgi == NL80211_TXRATE_FORCE_LGI)
 		return -EINVAL;
 
-	if (!ath10k_default_bitrate_mask(ar, band, mask)) {
-		if (!ath10k_get_fixed_rate_nss(ar, mask, band,
-					       &fixed_rate,
-					       &fixed_nss))
-			return -EINVAL;
+	if (ath10k_mac_bitrate_mask_has_single_rate(ar, band, mask)) {
+		ret = ath10k_mac_bitrate_mask_get_single_rate(ar, band, mask,
+							      &rate, &nss);
+		if (ret) {
+			ath10k_warn(ar, "failed to get single rate for vdev %i: %d\n",
+				    arvif->vdev_id, ret);
+			return ret;
+		}
+	} else if (ath10k_mac_bitrate_mask_get_single_nss(ar, band, mask,
+							  &single_nss)) {
+		rate = WMI_FIXED_RATE_NONE;
+		nss = single_nss;
+	} else {
+		rate = WMI_FIXED_RATE_NONE;
+		nss = ar->num_rf_chains;
 	}
 
-	if (fixed_rate == WMI_FIXED_RATE_NONE && force_sgi) {
-		ath10k_warn(ar, "failed to force SGI usage for default rate settings\n");
-		return -EINVAL;
+	mutex_lock(&ar->conf_mutex);
+
+	ret = ath10k_mac_set_fixed_rate_params(arvif, rate, nss, sgi);
+	if (ret) {
+		ath10k_warn(ar, "failed to set fixed rate params on vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+		goto exit;
 	}
 
-	return ath10k_set_fixed_rate_param(arvif, fixed_rate,
-					   fixed_nss, force_sgi);
+exit:
+	mutex_unlock(&ar->conf_mutex);
+
+	return ret;
 }
 
 static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
@@ -6322,7 +6226,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.get_antenna			= ath10k_get_antenna,
 	.reconfig_complete		= ath10k_reconfig_complete,
 	.get_survey			= ath10k_get_survey,
-	.set_bitrate_mask		= ath10k_set_bitrate_mask,
+	.set_bitrate_mask		= ath10k_mac_op_set_bitrate_mask,
 	.sta_rc_update			= ath10k_sta_rc_update,
 	.get_tsf			= ath10k_get_tsf,
 	.ampdu_action			= ath10k_ampdu_action,
-- 
2.1.4

