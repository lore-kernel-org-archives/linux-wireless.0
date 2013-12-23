Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:54484 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424Ab3LWPn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 10:43:26 -0500
Received: by mail-ee0-f41.google.com with SMTP id t10so2441588eei.0
        for <linux-wireless@vger.kernel.org>; Mon, 23 Dec 2013 07:43:25 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2] ath10k: add set_bitrate_mask callback
Date: Mon, 23 Dec 2013 16:42:56 +0100
Message-Id: <1387813376-9579-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131223_164330_748734_A7D0915B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add set_bitrate_mask callback. Currently
ath10k HW is limited to handle only single
fixed rate setting or limit number of used
spatial streams.

Example:
iw wlanX set bitrates legacy-5 ht-mcs-5 vht-mcs-5 2:9
will setup VHT, nss=2, mcs=9

iw wlanX set bitrates legacy-5 18 ht-mcs-5 vht-mcs-5
will setup legacy, 18Mbps

iw wlanX set bitrates legacy-5 ht-mcs-5 3 vht-mcs-5
will setup HT, nss=1, mcs=3

iw wlanX set bitrate legacy-5 ht-mcs-5 vht-mcs-5 1:0-9
will setup nss=1

iw wlanX set bitrate legacy-5 ht-mcs-5 vht-mcs-5 1:0-9 2:0-9
will setup nss=2

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
Depends on, nl80211: add VHT support for set_bitrate_mask
iw setup example base on, iw: add VHT MCS/NSS set support to set bitrates

*V2 - fix sparse error, fix documentation

 drivers/net/wireless/ath/ath10k/core.h |    3 +
 drivers/net/wireless/ath/ath10k/mac.c  |  294 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h  |   12 ++
 3 files changed, 309 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 79726e0..3817e32 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -253,6 +253,9 @@ struct ath10k_vif {
 			u8 bssid[ETH_ALEN];
 		} ibss;
 	} u;
+
+	u8 fixed_rate;
+	u8 fixed_nss;
 };
 
 struct ath10k_vif_iter {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ce9ef349..d909ab2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3310,6 +3310,299 @@ exit:
 	return ret;
 }
 
+/* Helper table for legacy fixed_rate/bitrate_mask */
+static const u8 cck_ofdm_rate[] = {
+	/* CCK */
+	3, /* 1Mbps */
+	2, /* 2Mbps */
+	1, /* 5.5Mbps */
+	0, /* 11Mbps */
+	/* OFDM */
+	3, /* 6Mbps */
+	7, /* 9Mbps */
+	2, /* 12Mbps */
+	6, /* 18Mbps */
+	1, /* 24Mbps */
+	5, /* 36Mbps */
+	0, /* 48Mbps */
+	4, /* 54Mbps */
+};
+
+/* Check if only one bit set */
+static int ath10k_check_single_mask(u32 mask)
+{
+	int bit;
+
+	bit = ffs(mask);
+	if (!bit)
+		return 0;
+
+	mask &= ~BIT(bit - 1);
+	if (mask)
+		return 2;
+
+	return 1;
+}
+
+static bool
+ath10k_default_bitrate_mask(struct ath10k *ar,
+			    enum ieee80211_band band,
+			    const struct cfg80211_bitrate_mask *mask)
+{
+	u32 legacy = 0x00ff;
+	u8 ht = 0xff, i;
+	u16 vht = 0x3ff;
+
+	switch (band) {
+	case IEEE80211_BAND_2GHZ:
+		legacy = 0x00fff;
+		vht = 0;
+		break;
+	case IEEE80211_BAND_5GHZ:
+		break;
+	default:
+		return false;
+	}
+
+	if (mask->control[band].legacy != legacy)
+		return false;
+
+	for (i = 0; i < ar->num_rf_chains; i++)
+		if (mask->control[band].ht_mcs[i] != ht)
+			return false;
+
+	for (i = 0; i < ar->num_rf_chains; i++)
+		if (mask->control[band].vht_mcs[i] != vht)
+			return false;
+
+	return true;
+}
+
+static bool
+ath10k_bitrate_mask_nss(const struct cfg80211_bitrate_mask *mask,
+			enum ieee80211_band band,
+			u8 *fixed_nss)
+{
+	int ht_nss = 0, vht_nss = 0, i;
+
+	/* check legacy */
+	if (ath10k_check_single_mask(mask->control[band].legacy))
+		return false;
+
+	/* check HT */
+	for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
+		if (mask->control[band].ht_mcs[i] == 0xff)
+			continue;
+		else if (mask->control[band].ht_mcs[i] == 0x00)
+			break;
+		else
+			return false;
+	}
+
+	ht_nss = i;
+
+	/* check VHT */
+	for (i = 0; i < NL80211_VHT_NSS_MAX; i++) {
+		if (mask->control[band].vht_mcs[i] == 0x03ff)
+			continue;
+		else if (mask->control[band].vht_mcs[i] == 0x0000)
+			break;
+		else
+			return false;
+	}
+
+	vht_nss = i;
+
+	if (ht_nss > 0 && vht_nss > 0)
+		return false;
+
+	if (ht_nss)
+		*fixed_nss = ht_nss;
+	else if (vht_nss)
+		*fixed_nss = vht_nss;
+	else
+		return false;
+
+	return true;
+}
+
+static bool
+ath10k_bitrate_mask_correct(const struct cfg80211_bitrate_mask *mask,
+			    enum ieee80211_band band,
+			    enum wmi_rate_preamble *preamble)
+{
+	int legacy = 0, ht = 0, vht = 0, i;
+
+	*preamble = WMI_RATE_PREAMBLE_OFDM;
+
+	/* check legacy */
+	legacy = ath10k_check_single_mask(mask->control[band].legacy);
+	if (legacy > 1)
+		return false;
+
+	/* check HT */
+	for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
+		ht += ath10k_check_single_mask(mask->control[band].ht_mcs[i]);
+	if (ht > 1)
+		return false;
+
+	/* check VHT */
+	for (i = 0; i < NL80211_VHT_NSS_MAX; i++)
+		vht += ath10k_check_single_mask(mask->control[band].vht_mcs[i]);
+	if (vht > 1)
+		return false;
+
+	/* Currently we support only one fixed_rate */
+	if ((legacy + ht + vht) != 1)
+		return false;
+
+	if (ht)
+		*preamble = WMI_RATE_PREAMBLE_HT;
+	else if (vht)
+		*preamble = WMI_RATE_PREAMBLE_VHT;
+
+	return true;
+}
+
+static bool
+ath10k_bitrate_mask_rate(const struct cfg80211_bitrate_mask *mask,
+			 enum ieee80211_band band,
+			 u8 *fixed_rate,
+			 u8 *fixed_nss)
+{
+	u8 rate = 0, pream = 0, nss = 0, i;
+	enum wmi_rate_preamble preamble;
+
+	/* Check if single rate correct */
+	if (!ath10k_bitrate_mask_correct(mask, band, &preamble))
+		return false;
+
+	pream = preamble;
+
+	switch (preamble) {
+	case WMI_RATE_PREAMBLE_CCK:
+	case WMI_RATE_PREAMBLE_OFDM:
+		i = ffs(mask->control[band].legacy) - 1;
+
+		if (band == IEEE80211_BAND_2GHZ && i < 4)
+			pream = WMI_RATE_PREAMBLE_CCK;
+
+		if (band == IEEE80211_BAND_5GHZ)
+			i += 4;
+
+		WARN_ON(i >= ARRAY_SIZE(cck_ofdm_rate));
+		rate = cck_ofdm_rate[i];
+		break;
+	case WMI_RATE_PREAMBLE_HT:
+		for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
+			if (mask->control[band].ht_mcs[i])
+				break;
+
+		rate = ffs(mask->control[band].ht_mcs[i]) - 1;
+		nss = i;
+		break;
+	case WMI_RATE_PREAMBLE_VHT:
+		for (i = 0; i < NL80211_VHT_NSS_MAX; i++)
+			if (mask->control[band].vht_mcs[i])
+				break;
+
+		rate = ffs(mask->control[band].vht_mcs[i]) - 1;
+		nss = i;
+		break;
+	}
+
+	*fixed_nss = nss + 1;
+	nss <<= 4;
+	pream <<= 6;
+
+	ath10k_dbg(ATH10K_DBG_MAC, "mac fixed rate pream 0x%02x nss 0x%02x rate 0x%02x\n",
+		   pream, nss, rate);
+
+	*fixed_rate = pream | nss | rate;
+
+	return true;
+}
+
+static bool ath10k_get_fixed_rate_nss(const struct cfg80211_bitrate_mask *mask,
+				      enum ieee80211_band band,
+				      u8 *fixed_rate,
+				      u8 *fixed_nss)
+{
+	/* First check full NSS mask, if we can simply limit NSS */
+	if (ath10k_bitrate_mask_nss(mask, band, fixed_nss))
+		return true;
+
+	/* Next Check single rate is set */
+	return ath10k_bitrate_mask_rate(mask, band, fixed_rate, fixed_nss);
+}
+
+static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
+				       u8 fixed_rate,
+				       u8 fixed_nss)
+{
+	struct ath10k *ar = arvif->ar;
+	u32 vdev_param;
+	int ret = 0;
+
+	mutex_lock(&ar->conf_mutex);
+
+	if (arvif->fixed_rate == fixed_rate &&
+	    arvif->fixed_nss == fixed_nss)
+		goto exit;
+
+	if (fixed_rate == WMI_FIXED_RATE_NONE)
+		ath10k_dbg(ATH10K_DBG_MAC, "mac disable fixed bitrate mask\n");
+
+	vdev_param = ar->wmi.vdev_param->fixed_rate;
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
+					vdev_param, fixed_rate);
+	if (ret) {
+		ath10k_warn("Could not set fixed_rate param 0x%02x: %d\n",
+			    fixed_rate, ret);
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	arvif->fixed_rate = fixed_rate;
+
+	vdev_param = ar->wmi.vdev_param->nss;
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
+					vdev_param, fixed_nss);
+
+	if (ret) {
+		ath10k_warn("Could not set fixed_nss param %d: %d\n",
+			    fixed_nss, ret);
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	arvif->fixed_nss = fixed_nss;
+
+exit:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
+}
+
+static int ath10k_set_bitrate_mask(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   const struct cfg80211_bitrate_mask *mask)
+{
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ath10k *ar = arvif->ar;
+	enum ieee80211_band band = ar->hw->conf.chandef.chan->band;
+	u8 fixed_rate = WMI_FIXED_RATE_NONE;
+	u8 fixed_nss = ar->num_rf_chains;
+
+	if (!ath10k_default_bitrate_mask(ar, band, mask)) {
+		if (!ath10k_get_fixed_rate_nss(mask, band,
+					       &fixed_rate,
+					       &fixed_nss))
+			return -EINVAL;
+	}
+
+	return ath10k_set_fixed_rate_param(arvif, fixed_rate, fixed_nss);
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_tx,
 	.start				= ath10k_start,
@@ -3332,6 +3625,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.tx_last_beacon			= ath10k_tx_last_beacon,
 	.restart_complete		= ath10k_restart_complete,
 	.get_survey			= ath10k_get_survey,
+	.set_bitrate_mask		= ath10k_set_bitrate_mask,
 #ifdef CONFIG_PM
 	.suspend			= ath10k_suspend,
 	.resume				= ath10k_resume,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 0087d69..af36009 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3003,6 +3003,18 @@ struct wmi_vdev_install_key_arg {
 	const void *key_data;
 };
 
+/*
+ * vdev fixed rate format:
+ * - preamble - b7:b6 - see WMI_RATE_PREMABLE_
+ * - nss      - b5:b4 - ss number (0 mean 1ss)
+ * - rate_mcs - b3:b0 - as below
+ *    CCK:  0 - 11Mbps, 1 - 5,5Mbps, 2 - 2Mbps, 3 - 1Mbps,
+ *          4 - 11Mbps (s), 5 - 5,5Mbps (s), 6 - 2Mbps (s)
+ *    OFDM: 0 - 48Mbps, 1 - 24Mbps, 2 - 12Mbps, 3 - 6Mbps,
+ *          4 - 54Mbps, 5 - 36Mbps, 6 - 18Mbps, 7 - 9Mbps
+ *    HT/VHT: MCS index
+ */
+
 /* Preamble types to be used with VDEV fixed rate configuration */
 enum wmi_rate_preamble {
 	WMI_RATE_PREAMBLE_OFDM,
-- 
1.7.9.5

