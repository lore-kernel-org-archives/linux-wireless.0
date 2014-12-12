Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45986 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967057AbaLLLyc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 06:54:32 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so4269552wiv.4
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2014 03:54:31 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/5] ath10k: fix STA u-APSD
Date: Fri, 12 Dec 2014 12:41:36 +0100
Message-Id: <1418384499-31660-3-git-send-email-michal.kazior@tieto.com> (sfid-20141212_125457_353559_3AEADEA0)
In-Reply-To: <1418384499-31660-1-git-send-email-michal.kazior@tieto.com>
References: <1418214714-29689-1-git-send-email-michal.kazior@tieto.com>
 <1418384499-31660-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To comply with WMM-PS the device shouldn't wake up
with a NullFunc frame pair when tx-ing. Instead PM
bit on each tx frame should be used.

To make this work correctly firmware needs to be
told to use a different STA PS wake threshold when
u-APSD is enabled.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * fix Rx performance
     * fix error handling (use goto instead of return)

 drivers/net/wireless/ath/ath10k/mac.c | 79 ++++++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/wmi.h |  7 ++++
 2 files changed, 76 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 950322d..13c2bad 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1048,6 +1048,57 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 			    arvif->vdev_id, ret);
 }
 
+static int ath10k_mac_vif_recalc_ps_wake_threshold(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	u32 param;
+	u32 value;
+	int ret;
+
+	lockdep_assert_held(&arvif->ar->conf_mutex);
+
+	if (arvif->u.sta.uapsd)
+		value = WMI_STA_PS_TX_WAKE_THRESHOLD_NEVER;
+	else
+		value = WMI_STA_PS_TX_WAKE_THRESHOLD_ALWAYS;
+
+	param = WMI_STA_PS_PARAM_TX_WAKE_THRESHOLD;
+	ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id, param, value);
+	if (ret) {
+		ath10k_warn(ar, "failed to submit ps wake threshold %u on vdev %i: %d\n",
+			    value, arvif->vdev_id, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ath10k_mac_vif_recalc_ps_poll_count(struct ath10k_vif *arvif)
+{
+	struct ath10k *ar = arvif->ar;
+	u32 param;
+	u32 value;
+	int ret;
+
+	lockdep_assert_held(&arvif->ar->conf_mutex);
+
+	if (arvif->u.sta.uapsd)
+		value = WMI_STA_PS_PSPOLL_COUNT_UAPSD;
+	else
+		value = WMI_STA_PS_PSPOLL_COUNT_NO_MAX;
+
+	param = WMI_STA_PS_PARAM_PSPOLL_COUNT;
+	ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
+					  param, value);
+	if (ret) {
+		ath10k_warn(ar, "failed to submit ps poll count %u on vdev %i: %d\n",
+			    value, arvif->vdev_id, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 /*
  * Review this when mac80211 gains per-interface powersave support.
  */
@@ -3036,22 +3087,16 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 			goto err_peer_delete;
 		}
 
-		param = WMI_STA_PS_PARAM_TX_WAKE_THRESHOLD;
-		value = WMI_STA_PS_TX_WAKE_THRESHOLD_ALWAYS;
-		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
-						  param, value);
+		ret = ath10k_mac_vif_recalc_ps_wake_threshold(arvif);
 		if (ret) {
-			ath10k_warn(ar, "failed to set vdev %i TX wake thresh: %d\n",
+			ath10k_warn(ar, "failed to recalc ps wake threshold on vdev %i: %d\n",
 				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
 
-		param = WMI_STA_PS_PARAM_PSPOLL_COUNT;
-		value = WMI_STA_PS_PSPOLL_COUNT_NO_MAX;
-		ret = ath10k_wmi_set_sta_ps_param(ar, arvif->vdev_id,
-						  param, value);
+		ret = ath10k_mac_vif_recalc_ps_poll_count(arvif);
 		if (ret) {
-			ath10k_warn(ar, "failed to set vdev %i PSPOLL count: %d\n",
+			ath10k_warn(ar, "failed to recalc ps poll count on vdev %i: %d\n",
 				    arvif->vdev_id, ret);
 			goto err_peer_delete;
 		}
@@ -3818,6 +3863,20 @@ static int ath10k_conf_tx_uapsd(struct ath10k *ar, struct ieee80211_vif *vif,
 	if (ret)
 		ath10k_warn(ar, "failed to set rx wake param: %d\n", ret);
 
+	ret = ath10k_mac_vif_recalc_ps_wake_threshold(arvif);
+	if (ret) {
+		ath10k_warn(ar, "failed to recalc ps wake threshold on vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+		return ret;
+	}
+
+	ret = ath10k_mac_vif_recalc_ps_poll_count(arvif);
+	if (ret) {
+		ath10k_warn(ar, "failed to recalc ps poll count on vdev %i: %d\n",
+			    arvif->vdev_id, ret);
+		return ret;
+	}
+
 exit:
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 97f902f..ff2d076 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4015,6 +4015,13 @@ enum wmi_sta_ps_param_pspoll_count {
 	 * Values greater than 0 indicate the maximum numer of PS-Poll frames
 	 * FW will send before waking up.
 	 */
+
+	/* When u-APSD is enabled the firmware will be very reluctant to exit
+	 * STA PS. This could result in very poor Rx performance with STA doing
+	 * PS-Poll for each and every buffered frame. This value is a bit
+	 * arbitrary.
+	 */
+	WMI_STA_PS_PSPOLL_COUNT_UAPSD = 3,
 };
 
 /*
-- 
1.8.5.3

