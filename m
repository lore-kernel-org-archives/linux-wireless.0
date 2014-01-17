Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:46083 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaAQTEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 14:04:50 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so1923803eaj.15
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 11:04:49 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: bitrate_mask add force_sgi support
Date: Fri, 17 Jan 2014 20:04:14 +0100
Message-Id: <1389985454-3997-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140117_200454_802109_3152EEA2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add force SGI support.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
depends on, nl80211: add Guard Interval support for set_bitrate_mask

 drivers/net/wireless/ath/ath10k/core.h |    1 +
 drivers/net/wireless/ath/ath10k/mac.c  |   35 +++++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ade1781..f0e22c7 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -256,6 +256,7 @@ struct ath10k_vif {
 
 	u8 fixed_rate;
 	u8 fixed_nss;
+	u8 force_sgi;
 };
 
 struct ath10k_vif_iter {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 70fe386..d1dd59b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3575,7 +3575,8 @@ static bool ath10k_get_fixed_rate_nss(const struct cfg80211_bitrate_mask *mask,
 
 static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
 				       u8 fixed_rate,
-				       u8 fixed_nss)
+				       u8 fixed_nss,
+				       u8 force_sgi)
 {
 	struct ath10k *ar = arvif->ar;
 	u32 vdev_param;
@@ -3584,12 +3585,16 @@ static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
 	mutex_lock(&ar->conf_mutex);
 
 	if (arvif->fixed_rate == fixed_rate &&
-	    arvif->fixed_nss == fixed_nss)
+	    arvif->fixed_nss == fixed_nss &&
+	    arvif->force_sgi == force_sgi)
 		goto exit;
 
 	if (fixed_rate == WMI_FIXED_RATE_NONE)
 		ath10k_dbg(ATH10K_DBG_MAC, "mac disable fixed bitrate mask\n");
 
+	if (force_sgi)
+		ath10k_dbg(ATH10K_DBG_MAC, "mac force sgi\n");
+
 	vdev_param = ar->wmi.vdev_param->fixed_rate;
 	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
 					vdev_param, fixed_rate);
@@ -3615,6 +3620,19 @@ static int ath10k_set_fixed_rate_param(struct ath10k_vif *arvif,
 
 	arvif->fixed_nss = fixed_nss;
 
+	vdev_param = ar->wmi.vdev_param->sgi;
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
+					force_sgi);
+
+	if (ret) {
+		ath10k_warn("Could not set sgi param %d: %d\n",
+			    force_sgi, ret);
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	arvif->force_sgi = force_sgi;
+
 exit:
 	mutex_unlock(&ar->conf_mutex);
 	return ret;
@@ -3629,6 +3647,11 @@ static int ath10k_set_bitrate_mask(struct ieee80211_hw *hw,
 	enum ieee80211_band band = ar->hw->conf.chandef.chan->band;
 	u8 fixed_rate = WMI_FIXED_RATE_NONE;
 	u8 fixed_nss = ar->num_rf_chains;
+	u8 force_sgi;
+
+	force_sgi = mask->control[band].gi;
+	if (force_sgi == NL80211_TXRATE_FORCE_LGI)
+		return -EINVAL;
 
 	if (!ath10k_default_bitrate_mask(ar, band, mask)) {
 		if (!ath10k_get_fixed_rate_nss(mask, band,
@@ -3637,7 +3660,13 @@ static int ath10k_set_bitrate_mask(struct ieee80211_hw *hw,
 			return -EINVAL;
 	}
 
-	return ath10k_set_fixed_rate_param(arvif, fixed_rate, fixed_nss);
+	if (fixed_rate == WMI_FIXED_RATE_NONE && force_sgi) {
+		ath10k_warn("Could not force SGI usage for default rate settings\n");
+		return -EINVAL;
+	}
+
+	return ath10k_set_fixed_rate_param(arvif, fixed_rate,
+					   fixed_nss, force_sgi);
 }
 
 static const struct ieee80211_ops ath10k_ops = {
-- 
1.7.9.5

