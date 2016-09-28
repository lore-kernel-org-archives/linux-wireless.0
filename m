Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58064 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754582AbcI1X6S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 19:58:18 -0400
From: Thomas Pedersen <twp@qca.qualcomm.com>
To: ath10k <ath10k@lists.infradead.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        Thomas Pedersen <twp@qca.qualcomm.com>
Subject: [PATCH 2/4] ath10k: implement offset_tsf ieee80211_op
Date: Wed, 28 Sep 2016 16:56:29 -0700
Message-ID: <20160928235631.9197-3-twp@qca.qualcomm.com> (sfid-20160929_015839_975513_CBF141C1)
In-Reply-To: <20160928235631.9197-1-twp@qca.qualcomm.com>
References: <20160928235631.9197-1-twp@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current set_tsf is implemented in terms of TSF_INCREMENT
only. Instead support new WMI command TSF_DECREMENT and
export these through offset_tsf. Advantage is we get
more accurate TSF adjustments, and don't calculate wrong
offset in case absolute TSF was calculated from rx_mactime
(actual TSF).

The new WMI command is available in firmware
10.4-3.2.1-00033 for QCA4019 chips. Old drivers on new
firmware or vice versa shouldn't  be a problem since
get/set tsf logic was already broken.

Signed-off-by: Thomas Pedersen <twp@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 25 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c |  2 ++
 drivers/net/wireless/ath/ath10k/wmi.h |  7 +++++++
 3 files changed, 34 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 76297d6..06bd027 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6992,6 +6992,30 @@ static void ath10k_set_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		ath10k_warn(ar, "failed to set tsf offset: %d\n", ret);
 }
 
+static void ath10k_offset_tsf(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, s64 tsf_offset)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	u32 offset, vdev_param;
+	int ret;
+
+	if (tsf_offset < 0) {
+		vdev_param = ar->wmi.vdev_param->dec_tsf;
+		offset = -tsf_offset;
+	} else {
+		vdev_param = ar->wmi.vdev_param->inc_tsf;
+		offset = tsf_offset;
+	}
+
+	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
+					vdev_param, offset);
+
+	if (ret && ret != -EOPNOTSUPP)
+		ath10k_warn(ar, "failed to set tsf offset %d cmd %d: %d\n",
+			    offset, vdev_param, ret);
+}
+
 static int ath10k_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_ampdu_params *params)
@@ -7455,6 +7479,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.sta_rc_update			= ath10k_sta_rc_update,
 	.get_tsf			= ath10k_get_tsf,
 	.set_tsf			= ath10k_set_tsf,
+	.offset_tsf			= ath10k_offset_tsf,
 	.ampdu_action			= ath10k_ampdu_action,
 	.get_et_sset_count		= ath10k_debug_get_et_sset_count,
 	.get_et_stats			= ath10k_debug_get_et_stats,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 38993d7..430074b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1013,6 +1013,8 @@ static struct wmi_vdev_param_map wmi_10_4_vdev_param_map = {
 	.rx_decap_type = WMI_10_4_VDEV_PARAM_RX_DECAP_TYPE,
 	.bw_nss_ratemask = WMI_10_4_VDEV_PARAM_BW_NSS_RATEMASK,
 	.set_tsf = WMI_10_4_VDEV_PARAM_TSF_INCREMENT,
+	.inc_tsf = WMI_10_4_VDEV_PARAM_TSF_INCREMENT,
+	.dec_tsf = WMI_10_4_VDEV_PARAM_TSF_DECREMENT,
 };
 
 static struct wmi_pdev_param_map wmi_pdev_param_map = {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1b243c8..9d13c6f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4677,6 +4677,8 @@ struct wmi_vdev_param_map {
 	u32 rx_decap_type;
 	u32 bw_nss_ratemask;
 	u32 set_tsf;
+	u32 inc_tsf;
+	u32 dec_tsf;
 };
 
 #define WMI_VDEV_PARAM_UNSUPPORTED 0
@@ -5009,6 +5011,11 @@ enum wmi_10_4_vdev_param {
 	WMI_10_4_VDEV_PARAM_STA_KICKOUT,
 	WMI_10_4_VDEV_PARAM_CAPABILITIES,
 	WMI_10_4_VDEV_PARAM_TSF_INCREMENT,
+	WMI_10_4_VDEV_PARAM_RX_FILTER,
+	WMI_10_4_VDEV_PARAM_MGMT_TX_POWER,
+	WMI_10_4_VDEV_PARAM_ATF_SSID_SCHED_POLICY,
+	WMI_10_4_VDEV_PARAM_DISABLE_DYN_BW_RTS,
+	WMI_10_4_VDEV_PARAM_TSF_DECREMENT,
 };
 
 #define WMI_VDEV_PARAM_TXBF_SU_TX_BFEE BIT(0)
-- 
2.10.0.297.gf6727b0
