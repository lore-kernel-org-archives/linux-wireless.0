Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:35152 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932947AbbDJNfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 09:35:43 -0400
Received: by labbd9 with SMTP id bd9so13387971lab.2
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2015 06:35:41 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: implement more versatile set_bitrate_mask
Date: Fri, 10 Apr 2015 13:32:52 +0000
Message-Id: <1428672772-9275-1-git-send-email-michal.kazior@tieto.com> (sfid-20150410_153609_805008_6E89A11B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Until now only a single fixed tx rate or nss was
allowed to be set.

The patch attempts to improve this by allowing
most bitrate masks. The limitation is VHT MCS
rates cannot be expressed separately using
existing firmware interfaces and only the
following VHT MCS ranges are supported: none, 0-7,
0-8, and 0-9.

This keeps the old behaviour when requesting
single tx rate or single nss. The new bitrate mask
logic is only applied to other cases that would
return -EINVAL until now.

Depending on firmware revisions some combinations
may crash firmware so use with care, please.

This depends on "ath10k: don't use reassoc flag".
Without it key cache would effectively be
invalidated upon bitrate change leading to
communication being no longer possible.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v3:
     * fix rebase derp (use s/arvif->bitrate_mask/mask/
                        in op_set_bitrate_mask)
     * get rid of 2 `WARNING: line over 80 characters`
     * update commit message
    
    v2:
     * fix out-of-bounds array access [Kalle]
       (the vht_mcs_mask shouldn't have been used in peer_h_ht
        helper to begin with)

 drivers/net/wireless/ath/ath10k/core.h |   1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 270 ++++++++++++++++++++++++++++++---
 2 files changed, 251 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index b0e8905ca325..0a36f3b7fd87 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -354,6 +354,7 @@ struct ath10k_vif {
 	struct wmi_wmm_params_all_arg wmm_params;
 	struct work_struct ap_csa_work;
 	struct delayed_work connection_loss_work;
+	struct cfg80211_bitrate_mask bitrate_mask;
 };
 
 struct ath10k_vif_iter {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a7a84f52b8b4..256848587653 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -130,6 +130,30 @@ static int ath10k_mac_get_max_vht_mcs_map(u16 mcs_map, int nss)
 	return 0;
 }
 
+static u32
+ath10k_mac_max_ht_nss(const u8 ht_mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
+{
+	int nss;
+
+	for (nss = IEEE80211_HT_MCS_MASK_LEN - 1; nss >= 0; nss--)
+		if (ht_mcs_mask[nss])
+			return nss + 1;
+
+	return 1;
+}
+
+static u32
+ath10k_mac_max_vht_nss(const u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
+{
+	int nss;
+
+	for (nss = NL80211_VHT_NSS_MAX - 1; nss >= 0; nss--)
+		if (vht_mcs_mask[nss])
+			return nss + 1;
+
+	return 1;
+}
+
 /**********/
 /* Crypto */
 /**********/
@@ -2009,10 +2033,12 @@ static void ath10k_peer_assoc_h_rates(struct ath10k *ar,
 				      struct ieee80211_sta *sta,
 				      struct wmi_peer_assoc_complete_arg *arg)
 {
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct wmi_rate_set_arg *rateset = &arg->peer_legacy_rates;
 	struct cfg80211_chan_def def;
 	const struct ieee80211_supported_band *sband;
 	const struct ieee80211_rate *rates;
+	enum ieee80211_band band;
 	u32 ratemask;
 	u8 rate;
 	int i;
@@ -2022,8 +2048,10 @@ static void ath10k_peer_assoc_h_rates(struct ath10k *ar,
 	if (WARN_ON(ath10k_mac_vif_chan(vif, &def)))
 		return;
 
-	sband = ar->hw->wiphy->bands[def.chan->band];
-	ratemask = sta->supp_rates[def.chan->band];
+	band = def.chan->band;
+	sband = ar->hw->wiphy->bands[band];
+	ratemask = sta->supp_rates[band];
+	ratemask &= arvif->bitrate_mask.control[band].legacy;
 	rates = sband->bitrates;
 
 	rateset->num_rates = 0;
@@ -2038,19 +2066,60 @@ static void ath10k_peer_assoc_h_rates(struct ath10k *ar,
 	}
 }
 
+static bool
+ath10k_peer_assoc_h_ht_masked(const u8 ht_mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
+{
+	int nss;
+
+	for (nss = 0; nss < IEEE80211_HT_MCS_MASK_LEN; nss++)
+		if (ht_mcs_mask[nss])
+			return false;
+
+	return true;
+}
+
+static bool
+ath10k_peer_assoc_h_vht_masked(const u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
+{
+	int nss;
+
+	for (nss = 0; nss < NL80211_VHT_NSS_MAX; nss++)
+		if (vht_mcs_mask[nss])
+			return false;
+
+	return true;
+}
+
 static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
+				   struct ieee80211_vif *vif,
 				   struct ieee80211_sta *sta,
 				   struct wmi_peer_assoc_complete_arg *arg)
 {
 	const struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
-	int i, n;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct cfg80211_chan_def def;
+	enum ieee80211_band band;
+	const u8 *ht_mcs_mask;
+	const u16 *vht_mcs_mask;
+	int i, n, max_nss;
 	u32 stbc;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
+	if (WARN_ON(ath10k_mac_vif_chan(vif, &def)))
+		return;
+
 	if (!ht_cap->ht_supported)
 		return;
 
+	band = def.chan->band;
+	ht_mcs_mask = arvif->bitrate_mask.control[band].ht_mcs;
+	vht_mcs_mask = arvif->bitrate_mask.control[band].vht_mcs;
+
+	if (ath10k_peer_assoc_h_ht_masked(ht_mcs_mask) &&
+	    ath10k_peer_assoc_h_vht_masked(vht_mcs_mask))
+		return;
+
 	arg->peer_flags |= WMI_PEER_HT;
 	arg->peer_max_mpdu = (1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
 				    ht_cap->ampdu_factor)) - 1;
@@ -2069,11 +2138,13 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 		arg->peer_rate_caps |= WMI_RC_CW40_FLAG;
 	}
 
-	if (ht_cap->cap & IEEE80211_HT_CAP_SGI_20)
-		arg->peer_rate_caps |= WMI_RC_SGI_FLAG;
+	if (arvif->bitrate_mask.control[band].gi != NL80211_TXRATE_FORCE_LGI) {
+		if (ht_cap->cap & IEEE80211_HT_CAP_SGI_20)
+			arg->peer_rate_caps |= WMI_RC_SGI_FLAG;
 
-	if (ht_cap->cap & IEEE80211_HT_CAP_SGI_40)
-		arg->peer_rate_caps |= WMI_RC_SGI_FLAG;
+		if (ht_cap->cap & IEEE80211_HT_CAP_SGI_40)
+			arg->peer_rate_caps |= WMI_RC_SGI_FLAG;
+	}
 
 	if (ht_cap->cap & IEEE80211_HT_CAP_TX_STBC) {
 		arg->peer_rate_caps |= WMI_RC_TX_STBC_FLAG;
@@ -2093,9 +2164,12 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 	else if (ht_cap->mcs.rx_mask[1])
 		arg->peer_rate_caps |= WMI_RC_DS_FLAG;
 
-	for (i = 0, n = 0; i < IEEE80211_HT_MCS_MASK_LEN*8; i++)
-		if (ht_cap->mcs.rx_mask[i/8] & (1 << i%8))
+	for (i = 0, n = 0, max_nss = 0; i < IEEE80211_HT_MCS_MASK_LEN * 8; i++)
+		if ((ht_cap->mcs.rx_mask[i / 8] & BIT(i % 8)) &&
+		    (ht_mcs_mask[i / 8] & BIT(i % 8))) {
+			max_nss = (i / 8) + 1;
 			arg->peer_ht_rates.rates[n++] = i;
+		}
 
 	/*
 	 * This is a workaround for HT-enabled STAs which break the spec
@@ -2112,7 +2186,7 @@ static void ath10k_peer_assoc_h_ht(struct ath10k *ar,
 			arg->peer_ht_rates.rates[i] = i;
 	} else {
 		arg->peer_ht_rates.num_rates = n;
-		arg->peer_num_spatial_streams = sta->rx_nss;
+		arg->peer_num_spatial_streams = max_nss;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac ht peer %pM mcs cnt %d nss %d\n",
@@ -2188,13 +2262,63 @@ static int ath10k_peer_assoc_qos_ap(struct ath10k *ar,
 	return 0;
 }
 
+static u16
+ath10k_peer_assoc_h_vht_limit(u16 tx_mcs_set,
+			      const u16 vht_mcs_limit[NL80211_VHT_NSS_MAX])
+{
+	int idx_limit;
+	int nss;
+	u16 mcs_map;
+	u16 mcs;
+
+	for (nss = 0; nss < NL80211_VHT_NSS_MAX; nss++) {
+		mcs_map = ath10k_mac_get_max_vht_mcs_map(tx_mcs_set, nss) &
+			  vht_mcs_limit[nss];
+
+		if (mcs_map)
+			idx_limit = fls(mcs_map) - 1;
+		else
+			idx_limit = -1;
+
+		switch (idx_limit) {
+		case 0: /* fall through */
+		case 1: /* fall through */
+		case 2: /* fall through */
+		case 3: /* fall through */
+		case 4: /* fall through */
+		case 5: /* fall through */
+		case 6: /* fall through */
+		default:
+			/* see ath10k_mac_can_set_bitrate_mask() */
+			WARN_ON(1);
+			/* fall through */
+		case -1:
+			mcs = IEEE80211_VHT_MCS_NOT_SUPPORTED; break;
+		case 7:
+			mcs = IEEE80211_VHT_MCS_SUPPORT_0_7; break;
+		case 8:
+			mcs = IEEE80211_VHT_MCS_SUPPORT_0_8; break;
+		case 9:
+			mcs = IEEE80211_VHT_MCS_SUPPORT_0_9; break;
+		}
+
+		tx_mcs_set &= ~(0x3 << (nss * 2));
+		tx_mcs_set |= mcs << (nss * 2);
+	}
+
+	return tx_mcs_set;
+}
+
 static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_sta *sta,
 				    struct wmi_peer_assoc_complete_arg *arg)
 {
 	const struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct cfg80211_chan_def def;
+	enum ieee80211_band band;
+	const u16 *vht_mcs_mask;
 	u8 ampdu_factor;
 
 	if (WARN_ON(ath10k_mac_vif_chan(vif, &def)))
@@ -2203,6 +2327,12 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 	if (!vht_cap->vht_supported)
 		return;
 
+	band = def.chan->band;
+	vht_mcs_mask = arvif->bitrate_mask.control[band].vht_mcs;
+
+	if (ath10k_peer_assoc_h_vht_masked(vht_mcs_mask))
+		return;
+
 	arg->peer_flags |= WMI_PEER_VHT;
 
 	if (def.chan->band == IEEE80211_BAND_2GHZ)
@@ -2231,8 +2361,8 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 		__le16_to_cpu(vht_cap->vht_mcs.rx_mcs_map);
 	arg->peer_vht_rates.tx_max_rate =
 		__le16_to_cpu(vht_cap->vht_mcs.tx_highest);
-	arg->peer_vht_rates.tx_mcs_set =
-		__le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map);
+	arg->peer_vht_rates.tx_mcs_set = ath10k_peer_assoc_h_vht_limit(
+		__le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map), vht_mcs_mask);
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x\n",
 		   sta->addr, arg->peer_max_mpdu, arg->peer_flags);
@@ -2282,20 +2412,30 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 					struct ieee80211_sta *sta,
 					struct wmi_peer_assoc_complete_arg *arg)
 {
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 	struct cfg80211_chan_def def;
+	enum ieee80211_band band;
+	const u8 *ht_mcs_mask;
+	const u16 *vht_mcs_mask;
 	enum wmi_phy_mode phymode = MODE_UNKNOWN;
 
 	if (WARN_ON(ath10k_mac_vif_chan(vif, &def)))
 		return;
 
-	switch (def.chan->band) {
+	band = def.chan->band;
+	ht_mcs_mask = arvif->bitrate_mask.control[band].ht_mcs;
+	vht_mcs_mask = arvif->bitrate_mask.control[band].vht_mcs;
+
+	switch (band) {
 	case IEEE80211_BAND_2GHZ:
-		if (sta->vht_cap.vht_supported) {
+		if (sta->vht_cap.vht_supported &&
+		    !ath10k_peer_assoc_h_vht_masked(vht_mcs_mask)) {
 			if (sta->bandwidth == IEEE80211_STA_RX_BW_40)
 				phymode = MODE_11AC_VHT40;
 			else
 				phymode = MODE_11AC_VHT20;
-		} else if (sta->ht_cap.ht_supported) {
+		} else if (sta->ht_cap.ht_supported &&
+			   !ath10k_peer_assoc_h_ht_masked(ht_mcs_mask)) {
 			if (sta->bandwidth == IEEE80211_STA_RX_BW_40)
 				phymode = MODE_11NG_HT40;
 			else
@@ -2311,15 +2451,17 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 		/*
 		 * Check VHT first.
 		 */
-		if (sta->vht_cap.vht_supported) {
+		if (sta->vht_cap.vht_supported &&
+		    !ath10k_peer_assoc_h_vht_masked(vht_mcs_mask)) {
 			if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
 				phymode = MODE_11AC_VHT80;
 			else if (sta->bandwidth == IEEE80211_STA_RX_BW_40)
 				phymode = MODE_11AC_VHT40;
 			else if (sta->bandwidth == IEEE80211_STA_RX_BW_20)
 				phymode = MODE_11AC_VHT20;
-		} else if (sta->ht_cap.ht_supported) {
-			if (sta->bandwidth == IEEE80211_STA_RX_BW_40)
+		} else if (sta->ht_cap.ht_supported &&
+			   !ath10k_peer_assoc_h_ht_masked(ht_mcs_mask)) {
+			if (sta->bandwidth >= IEEE80211_STA_RX_BW_40)
 				phymode = MODE_11NA_HT40;
 			else
 				phymode = MODE_11NA_HT20;
@@ -2351,7 +2493,7 @@ static int ath10k_peer_assoc_prepare(struct ath10k *ar,
 	ath10k_peer_assoc_h_basic(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_crypto(ar, vif, arg);
 	ath10k_peer_assoc_h_rates(ar, vif, sta, arg);
-	ath10k_peer_assoc_h_ht(ar, sta, arg);
+	ath10k_peer_assoc_h_ht(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_vht(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_qos(ar, vif, sta, arg);
 	ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
@@ -4043,6 +4185,14 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	INIT_DELAYED_WORK(&arvif->connection_loss_work,
 			  ath10k_mac_vif_sta_connection_loss_work);
 
+	for (i = 0; i < ARRAY_SIZE(arvif->bitrate_mask.control); i++) {
+		arvif->bitrate_mask.control[i].legacy = 0xffffffff;
+		memset(arvif->bitrate_mask.control[i].ht_mcs, 0xff,
+		       sizeof(arvif->bitrate_mask.control[i].ht_mcs));
+		memset(arvif->bitrate_mask.control[i].vht_mcs, 0xff,
+		       sizeof(arvif->bitrate_mask.control[i].vht_mcs));
+	}
+
 	if (ar->free_vdev_map == 0) {
 		ath10k_warn(ar, "Free vdev map is empty, no more interfaces allowed.\n");
 		ret = -EBUSY;
@@ -4866,6 +5016,10 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 	struct ath10k_vif *arvif;
 	struct ath10k_sta *arsta;
 	struct ieee80211_sta *sta;
+	struct cfg80211_chan_def def;
+	enum ieee80211_band band;
+	const u8 *ht_mcs_mask;
+	const u16 *vht_mcs_mask;
 	u32 changed, bw, nss, smps;
 	int err;
 
@@ -4874,6 +5028,13 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 	arvif = arsta->arvif;
 	ar = arvif->ar;
 
+	if (WARN_ON(ath10k_mac_vif_chan(arvif->vif, &def)))
+		return;
+
+	band = def.chan->band;
+	ht_mcs_mask = arvif->bitrate_mask.control[band].ht_mcs;
+	vht_mcs_mask = arvif->bitrate_mask.control[band].vht_mcs;
+
 	spin_lock_bh(&ar->data_lock);
 
 	changed = arsta->changed;
@@ -4887,6 +5048,10 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 
 	mutex_lock(&ar->conf_mutex);
 
+	nss = max_t(u32, 1, nss);
+	nss = min(nss, max(ath10k_mac_max_ht_nss(ht_mcs_mask),
+			   ath10k_mac_max_vht_nss(vht_mcs_mask)));
+
 	if (changed & IEEE80211_RC_BW_CHANGED) {
 		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac update sta %pM peer bw %d\n",
 			   sta->addr, bw);
@@ -5772,6 +5937,53 @@ static int ath10k_mac_set_fixed_rate_params(struct ath10k_vif *arvif,
 	return 0;
 }
 
+static bool
+ath10k_mac_can_set_bitrate_mask(struct ath10k *ar,
+				enum ieee80211_band band,
+				const struct cfg80211_bitrate_mask *mask)
+{
+	int i;
+	u16 vht_mcs;
+
+	/* Due to firmware limitation in WMI_PEER_ASSOC_CMDID it is impossible
+	 * to express all VHT MCS rate masks. Effectively only the following
+	 * ranges can be used: none, 0-7, 0-8 and 0-9.
+	 */
+	for (i = 0; i < NL80211_VHT_NSS_MAX; i++) {
+		vht_mcs = mask->control[band].vht_mcs[i];
+
+		switch (vht_mcs) {
+		case 0:
+		case BIT(8) - 1:
+		case BIT(9) - 1:
+		case BIT(10) - 1:
+			break;
+		default:
+			ath10k_warn(ar, "refusing bitrate mask with missing 0-7 VHT MCS rates\n");
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static void ath10k_mac_set_bitrate_mask_iter(void *data,
+					     struct ieee80211_sta *sta)
+{
+	struct ath10k_vif *arvif = data;
+	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
+	struct ath10k *ar = arvif->ar;
+
+	if (arsta->arvif != arvif)
+		return;
+
+	spin_lock_bh(&ar->data_lock);
+	arsta->changed |= IEEE80211_RC_SUPP_RATES_CHANGED;
+	spin_unlock_bh(&ar->data_lock);
+
+	ieee80211_queue_work(ar->hw, &arsta->update_wk);
+}
+
 static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 					  struct ieee80211_vif *vif,
 					  const struct cfg80211_bitrate_mask *mask)
@@ -5780,6 +5992,8 @@ static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 	struct cfg80211_chan_def def;
 	struct ath10k *ar = arvif->ar;
 	enum ieee80211_band band;
+	const u8 *ht_mcs_mask;
+	const u16 *vht_mcs_mask;
 	u8 rate;
 	u8 nss;
 	u8 sgi;
@@ -5790,6 +6004,8 @@ static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 		return -EPERM;
 
 	band = def.chan->band;
+	ht_mcs_mask = mask->control[band].ht_mcs;
+	vht_mcs_mask = mask->control[band].vht_mcs;
 
 	sgi = mask->control[band].gi;
 	if (sgi == NL80211_TXRATE_FORCE_LGI)
@@ -5809,7 +6025,21 @@ static int ath10k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 		nss = single_nss;
 	} else {
 		rate = WMI_FIXED_RATE_NONE;
-		nss = ar->num_rf_chains;
+		nss = min(ar->num_rf_chains,
+			  max(ath10k_mac_max_ht_nss(ht_mcs_mask),
+			      ath10k_mac_max_vht_nss(vht_mcs_mask)));
+
+		if (!ath10k_mac_can_set_bitrate_mask(ar, band, mask))
+			return -EINVAL;
+
+		mutex_lock(&ar->conf_mutex);
+
+		arvif->bitrate_mask = *mask;
+		ieee80211_iterate_stations_atomic(ar->hw,
+						  ath10k_mac_set_bitrate_mask_iter,
+						  arvif);
+
+		mutex_unlock(&ar->conf_mutex);
 	}
 
 	mutex_lock(&ar->conf_mutex);
-- 
2.1.4

