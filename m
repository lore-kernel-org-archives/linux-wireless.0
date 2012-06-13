Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32082 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2FMBE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 21:04:58 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH v2] ath6kl: support rssi threshold for sched scan
Date: Tue, 12 Jun 2012 18:04:52 -0700
Message-ID: <1339549492-626-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120613_030501_444343_56B16505)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath6kl firmware can filter scan results based on rssi. This is
useful to limit hosts wakeups on scheduled scans.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

---
v2:
	formatting (Joe)

 drivers/net/wireless/ath/ath6kl/cfg80211.c |   10 ++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    3 +++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   18 ++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |   10 ++++++++++
 4 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6f20998..65a42ad 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3267,6 +3267,16 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 			return ret;
 	}
 
+	if (test_bit(ATH6KL_FW_CAPABILITY_RSSI_SCAN_THOLD,
+		     ar->fw_capabilities)) {
+		ret = ath6kl_wmi_set_rssi_filter_cmd(ar->wmi, vif->fw_vif_idx,
+						     request->rssi_thold);
+		if (ret) {
+			ath6kl_err("failed to set RSSI threshold for scan\n");
+			return ret;
+		}
+	}
+
 	/* fw uses seconds, also make sure that it's >0 */
 	interval = max_t(u16, 1, request->interval / 1000);
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 17a44fa..69b194c 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -115,6 +115,9 @@ enum ath6kl_fw_capability {
 	 */
 	ATH6KL_FW_CAPABILITY_SCHED_SCAN_MATCH_LIST,
 
+	/* Firmware supports filtering BSS results by RSSI */
+	ATH6KL_FW_CAPABILITY_RSSI_SCAN_THOLD,
+
 	/* this needs to be last */
 	ATH6KL_FW_CAPABILITY_MAX,
 };
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 43bce9c..6966a29 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1515,6 +1515,24 @@ static int ath6kl_wmi_cac_event_rx(struct wmi *wmi, u8 *datap, int len,
 	return 0;
 }
 
+int ath6kl_wmi_set_rssi_filter_cmd(struct wmi *wmi, u8 if_idx, s8 rssi)
+{
+	struct sk_buff *skb;
+	struct wmi_set_rssi_filter_cmd *cmd;
+	int ret;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_set_rssi_filter_cmd *) skb->data;
+	cmd->rssi = rssi;
+
+	ret = ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_RSSI_FILTER_CMDID,
+				  NO_SYNC_WMIFLAG);
+	return ret;
+}
+
 static int ath6kl_wmi_send_snr_threshold_params(struct wmi *wmi,
 			struct wmi_snr_threshold_params_cmd *snr_cmd)
 {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 7c94fe3..128f8fe 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -628,6 +628,10 @@ enum wmi_cmd_id {
 	WMI_SET_MCASTRATE,
 
 	WMI_STA_BMISS_ENHANCE_CMDID,
+
+	WMI_SET_REGDOMAIN_CMDID,
+
+	WMI_SET_RSSI_FILTER_CMDID,
 };
 
 enum wmi_mgmt_frame_type {
@@ -1276,6 +1280,11 @@ struct wmi_snr_threshold_params_cmd {
 	u8 reserved[3];
 } __packed;
 
+/* Don't report BSSs with signal (RSSI) below this threshold */
+struct wmi_set_rssi_filter_cmd {
+	s8 rssi;
+} __packed;
+
 enum wmi_preamble_policy {
 	WMI_IGNORE_BARKER_IN_ERP = 0,
 	WMI_FOLLOW_BARKER_IN_ERP,
@@ -2588,6 +2597,7 @@ int ath6kl_wmi_add_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
 				   const u8 *mask);
 int ath6kl_wmi_del_wow_pattern_cmd(struct wmi *wmi, u8 if_idx,
 				   u16 list_id, u16 filter_id);
+int ath6kl_wmi_set_rssi_filter_cmd(struct wmi *wmi, u8 if_idx, s8 rssi);
 int ath6kl_wmi_set_roam_lrssi_cmd(struct wmi *wmi, u8 lrssi);
 int ath6kl_wmi_force_roam_cmd(struct wmi *wmi, const u8 *bssid);
 int ath6kl_wmi_set_roam_mode_cmd(struct wmi *wmi, enum wmi_roam_mode mode);
-- 
1.7.4.1

