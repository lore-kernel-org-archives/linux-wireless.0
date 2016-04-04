Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56503 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbcDDXUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2016 19:20:21 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath10k: add a support of set_tsf on vdev interface
Date: Mon, 4 Apr 2016 16:19:14 -0700
Message-ID: <1459811956-26186-2-git-send-email-poh@qca.qualcomm.com> (sfid-20160405_012029_892623_7399F395)
In-Reply-To: <1459811956-26186-1-git-send-email-poh@qca.qualcomm.com>
References: <1459811956-26186-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.2.4.70.24 firmware introduces new feature to set TSF
via vdev parameter, hence implement relevant function.
set_tsf function can be used to shift TBTT that will
help avoid its clockdrift which happens when beacons
are collided.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c     | 27 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  1 +
 drivers/net/wireless/ath/ath10k/wmi.c     |  4 ++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  2 ++
 4 files changed, 34 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 20d72e2..595cd96 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6796,6 +6796,32 @@ static u64 ath10k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	return 0;
 }
 
+static void ath10k_set_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		    u64 tsf)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	u32 tsf_offset, vdev_param = ar->wmi.vdev_param->set_tsf;
+	int ret;
+
+	/* Workaround:
+	 *
+	 * Given tsf argument is entire TSF value, but firmware accepts
+	 * only TSF offset to current TSF.
+	 *
+	 * get_tsf function is used to get offset value, however since
+	 * ath10k_get_tsf is not implemented properly, it will return 0 always.
+	 * Luckily all the caller functions to set_tsf, as of now, also rely on
+	 * get_tsf function to get entire tsf value such get_tsf() + tsf_delta,
+	 * final tsf offset value to firmware will be arithmetically correct.
+	 */
+	tsf_offset = tsf - ath10k_get_tsf(hw, vif);
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
+					vdev_param, tsf_offset);
+	if (ret && ret != -EOPNOTSUPP)
+		ath10k_warn(ar, "failed to set tsf offset: %d\n", ret);
+}
+
 static int ath10k_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_ampdu_params *params)
@@ -7252,6 +7278,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.set_bitrate_mask		= ath10k_mac_op_set_bitrate_mask,
 	.sta_rc_update			= ath10k_sta_rc_update,
 	.get_tsf			= ath10k_get_tsf,
+	.set_tsf			= ath10k_set_tsf,
 	.ampdu_action			= ath10k_ampdu_action,
 	.get_et_sset_count		= ath10k_debug_get_et_sset_count,
 	.get_et_stats			= ath10k_debug_get_et_stats,
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 1085932..e09337e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3409,6 +3409,7 @@ static struct wmi_vdev_param_map wmi_tlv_vdev_param_map = {
 	.meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
 	.rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
 	.bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.set_tsf = WMI_VDEV_PARAM_UNSUPPORTED,
 };
 
 static const struct wmi_ops wmi_tlv_ops = {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f7ec65f..db3e9a4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -781,6 +781,7 @@ static struct wmi_vdev_param_map wmi_vdev_param_map = {
 	.meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
 	.rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
 	.bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.set_tsf = WMI_VDEV_PARAM_UNSUPPORTED,
 };
 
 /* 10.X WMI VDEV param map */
@@ -856,6 +857,7 @@ static struct wmi_vdev_param_map wmi_10x_vdev_param_map = {
 	.meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
 	.rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
 	.bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.set_tsf = WMI_VDEV_PARAM_UNSUPPORTED,
 };
 
 static struct wmi_vdev_param_map wmi_10_2_4_vdev_param_map = {
@@ -930,6 +932,7 @@ static struct wmi_vdev_param_map wmi_10_2_4_vdev_param_map = {
 	.meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
 	.rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
 	.bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.set_tsf = WMI_10X_VDEV_PARAM_TSF_INCREMENT,
 };
 
 static struct wmi_vdev_param_map wmi_10_4_vdev_param_map = {
@@ -1005,6 +1008,7 @@ static struct wmi_vdev_param_map wmi_10_4_vdev_param_map = {
 	.meru_vc = WMI_10_4_VDEV_PARAM_MERU_VC,
 	.rx_decap_type = WMI_10_4_VDEV_PARAM_RX_DECAP_TYPE,
 	.bw_nss_ratemask = WMI_10_4_VDEV_PARAM_BW_NSS_RATEMASK,
+	.set_tsf = WMI_VDEV_PARAM_UNSUPPORTED,
 };
 
 static struct wmi_pdev_param_map wmi_pdev_param_map = {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index feebd19..8225d90 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4630,6 +4630,7 @@ struct wmi_vdev_param_map {
 	u32 meru_vc;
 	u32 rx_decap_type;
 	u32 bw_nss_ratemask;
+	u32 set_tsf;
 };
 
 #define WMI_VDEV_PARAM_UNSUPPORTED 0
@@ -4886,6 +4887,7 @@ enum wmi_10x_vdev_param {
 	WMI_10X_VDEV_PARAM_RTS_FIXED_RATE,
 	WMI_10X_VDEV_PARAM_VHT_SGIMASK,
 	WMI_10X_VDEV_PARAM_VHT80_RATEMASK,
+	WMI_10X_VDEV_PARAM_TSF_INCREMENT,
 };
 
 enum wmi_10_4_vdev_param {
-- 
1.9.1

