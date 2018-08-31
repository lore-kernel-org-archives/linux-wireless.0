Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:17043 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbeHaFQP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 01:16:15 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH 3/3] ath10k: Add support to configure ftm responder role
Date: Thu, 30 Aug 2018 18:11:19 -0700
Message-Id: <1535677879-314-1-git-send-email-pradeepc@codeaurora.org> (sfid-20180831_031123_824191_82E6622F)
In-Reply-To: <1534293018-4930-4-git-send-email-pradeepc@codeaurora.org>
References: <1534293018-4930-4-git-send-email-pradeepc@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure fine timing measurement (FTM) responder role from the
ftm_responder bss param sent by mac80211. With FTM functionality
offloaded to firmware, adding the interface allows userspace
to enable FTM responder functionality. ath10k disables it at the
time of interface creation.

Supported FW: 10.4

Tested on QCA9984 with firmware: 10.4-3.6-00144

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 29 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  |  4 ++++
 drivers/net/wireless/ath/ath10k/wmi.h  | 10 ++++++++++
 4 files changed, 44 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 9feea02e7d37..db190230b292 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -544,6 +544,7 @@ struct ath10k_vif {
 	bool nohwcrypt;
 	int num_legacy_stations;
 	int txpower;
+	bool ftm_responder;
 	struct wmi_wmm_params_all_arg wmm_params;
 	struct work_struct ap_csa_work;
 	struct delayed_work connection_loss_work;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 90f9372dec25..24a747f8ec07 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5259,6 +5259,17 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		goto err_peer_delete;
 	}
 
+	if (test_bit(WMI_SERVICE_RTT, ar->wmi.svc_map)) {
+		vdev_param = ar->wmi.vdev_param->rtt_responder_role;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
+						arvif->ftm_responder);
+
+		/* It is harmless to not set FTM role. Do not warn */
+		if (ret && ret != -EOPNOTSUPP)
+			ath10k_warn(ar, "failed to set vdev %i FTM Responder: %d\n",
+				    arvif->vdev_id, ret);
+	}
+
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
 		ar->monitor_arvif = arvif;
 		ret = ath10k_monitor_recalc(ar);
@@ -5532,6 +5543,20 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BSSID && !is_zero_ether_addr(info->bssid))
 		ether_addr_copy(arvif->bssid, info->bssid);
 
+	if (changed & BSS_CHANGED_FTM_RESPONDER &&
+	    arvif->ftm_responder != info->ftm_responder &&
+	    test_bit(WMI_SERVICE_RTT, ar->wmi.svc_map)) {
+		arvif->ftm_responder = info->ftm_responder;
+
+		vdev_param = ar->wmi.vdev_param->rtt_responder_role;
+		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
+						arvif->ftm_responder);
+
+		ath10k_dbg(ar, ATH10K_DBG_MAC,
+			   "mac vdev %d ftm_responder %d:ret %d\n",
+			   arvif->vdev_id, arvif->ftm_responder, ret);
+	}
+
 	if (changed & BSS_CHANGED_BEACON_ENABLED)
 		ath10k_control_beaconing(arvif, info);
 
@@ -8463,6 +8488,10 @@ int ath10k_mac_register(struct ath10k *ar)
 	wiphy_ext_feature_set(ar->hw->wiphy,
 			      NL80211_EXT_FEATURE_SET_SCAN_DWELL);
 
+	if (test_bit(WMI_SERVICE_RTT, ar->wmi.svc_map))
+		wiphy_ext_feature_set(ar->hw->wiphy,
+				      NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER);
+
 	/*
 	 * on LL hardware queues are managed entirely by the FW
 	 * so we only advertise to mac we can do the queues thing
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index fd612d2905b0..00c67d53eab8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -825,6 +825,7 @@
 	.meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
 	.rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
 	.bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.rtt_responder_role = WMI_VDEV_PARAM_UNSUPPORTED,
 };
 
 /* 10.X WMI VDEV param map */
@@ -900,6 +901,7 @@
 	.meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
 	.rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
 	.bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.rtt_responder_role = WMI_VDEV_PARAM_UNSUPPORTED,
 };
 
 static struct wmi_vdev_param_map wmi_10_2_4_vdev_param_map = {
@@ -974,6 +976,7 @@
 	.meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
 	.rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
 	.bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
+	.rtt_responder_role = WMI_VDEV_PARAM_UNSUPPORTED,
 };
 
 static struct wmi_vdev_param_map wmi_10_4_vdev_param_map = {
@@ -1051,6 +1054,7 @@
 	.bw_nss_ratemask = WMI_10_4_VDEV_PARAM_BW_NSS_RATEMASK,
 	.inc_tsf = WMI_10_4_VDEV_PARAM_TSF_INCREMENT,
 	.dec_tsf = WMI_10_4_VDEV_PARAM_TSF_DECREMENT,
+	.rtt_responder_role = WMI_10_4_VDEV_PARAM_ENABLE_DISABLE_RTT_RESPONDER_ROLE,
 };
 
 static struct wmi_pdev_param_map wmi_pdev_param_map = {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 36220258e3c7..fa94873fe46f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5035,6 +5035,7 @@ struct wmi_vdev_param_map {
 	u32 bw_nss_ratemask;
 	u32 inc_tsf;
 	u32 dec_tsf;
+	u32 rtt_responder_role;
 };
 
 #define WMI_VDEV_PARAM_UNSUPPORTED 0
@@ -5374,6 +5375,15 @@ enum wmi_10_4_vdev_param {
 	WMI_10_4_VDEV_PARAM_ATF_SSID_SCHED_POLICY,
 	WMI_10_4_VDEV_PARAM_DISABLE_DYN_BW_RTS,
 	WMI_10_4_VDEV_PARAM_TSF_DECREMENT,
+	WMI_10_4_VDEV_PARAM_SELFGEN_FIXED_RATE,
+	WMI_10_4_VDEV_PARAM_AMPDU_SUBFRAME_SIZE_PER_AC,
+	WMI_10_4_VDEV_PARAM_NSS_VHT160,
+	WMI_10_4_VDEV_PARAM_NSS_VHT80_80,
+	WMI_10_4_VDEV_PARAM_AMSDU_SUBFRAME_SIZE_PER_AC,
+	WMI_10_4_VDEV_PARAM_DISABLE_CABQ,
+	WMI_10_4_VDEV_PARAM_SIFS_TRIGGER_RATE,
+	WMI_10_4_VDEV_PARAM_TX_POWER,
+	WMI_10_4_VDEV_PARAM_ENABLE_DISABLE_RTT_RESPONDER_ROLE,
 };
 
 #define WMI_VDEV_PARAM_TXBF_SU_TX_BFEE BIT(0)
-- 
1.9.1
