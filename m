Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63860 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab2CUP2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 11:28:07 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Configure inactivity timeout in fw
Date: Wed, 21 Mar 2012 20:58:39 +0530
Message-ID: <1332343719-3773-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120321_162826_742052_A14B1491)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure the inactivity timeout passed in start_ap() to
firmware. This capability is advertised only when fw supports
it, there is a new bit (ATH6KL_FW_CAPABILITY_INACTIVITY_TIMEOUT)
in firmware capability ie for driver to learn fw's capability.
After the fw finds out the station is inactive, it will probe
the station with null func frames. By default, the timeout is
10 secs.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   11 +++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    6 ++++++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   17 +++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |    7 +++++++
 4 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d24bc66..92bcce9 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2558,6 +2558,13 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		p.nw_subtype = SUBTYPE_NONE;
 	}
 
+	if (info->inactivity_timeout) {
+		res = ath6kl_wmi_set_inact_period(ar->wmi, vif->fw_vif_idx,
+						  info->inactivity_timeout);
+		if (res < 0)
+			return res;
+	}
+
 	res = ath6kl_wmi_ap_profile_commit(ar->wmi, vif->fw_vif_idx, &p);
 	if (res < 0)
 		return res;
@@ -3222,6 +3229,10 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	if (test_bit(ATH6KL_FW_CAPABILITY_SCHED_SCAN, ar->fw_capabilities))
 		ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 
+	if (test_bit(ATH6KL_FW_CAPABILITY_INACTIVITY_TIMEOUT,
+		     ar->fw_capabilities))
+		ar->wiphy->features = NL80211_FEATURE_INACTIVITY_TIMER;
+
 	ar->wiphy->probe_resp_offload =
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 17697eb..a29a349 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -91,6 +91,12 @@ enum ath6kl_fw_capability {
 	 */
 	ATH6KL_FW_CAPABILITY_STA_P2PDEV_DUPLEX,
 
+	/*
+	 * Firmware has support to cleanup inactive stations
+	 * in AP mode.
+	 */
+	ATH6KL_FW_CAPABILITY_INACTIVITY_TIMEOUT,
+
 	/* this needs to be last */
 	ATH6KL_FW_CAPABILITY_MAX,
 };
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 7654e8e..b1b1f34 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3395,6 +3395,23 @@ int ath6kl_wmi_cancel_remain_on_chnl_cmd(struct wmi *wmi, u8 if_idx)
 				     WMI_CANCEL_REMAIN_ON_CHNL_CMDID);
 }
 
+int ath6kl_wmi_set_inact_period(struct wmi *wmi, u8 if_idx, int inact_timeout)
+{
+	struct sk_buff *skb;
+	struct wmi_set_inact_period_cmd *cmd;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
+	if (!skb)
+		return -ENOMEM;
+
+	cmd = (struct wmi_set_inact_period_cmd *) skb->data;
+	cmd->inact_period = cpu_to_le32(inact_timeout);
+	cmd->num_null_func = 0;
+
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_AP_CONN_INACT_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 static int ath6kl_wmi_control_rx_xtnd(struct wmi *wmi, struct sk_buff *skb)
 {
 	struct wmix_cmd_hdr *cmd;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 4092e3e..8c8a922 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -2141,6 +2141,11 @@ struct wmi_ap_hidden_ssid_cmd {
 	u8 hidden_ssid;
 } __packed;
 
+struct wmi_set_inact_period_cmd {
+	__le32 inact_period;
+	u8 num_null_func;
+} __packed;
+
 /* AP mode events */
 struct wmi_ap_set_apsd_cmd {
 	u8 enable;
@@ -2538,6 +2543,8 @@ int ath6kl_wmi_cancel_remain_on_chnl_cmd(struct wmi *wmi, u8 if_idx);
 int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 if_idx, u8 mgmt_frm_type,
 			     const u8 *ie, u8 ie_len);
 
+int ath6kl_wmi_set_inact_period(struct wmi *wmi, u8 if_idx, int inact_timeout);
+
 void ath6kl_wmi_sscan_timer(unsigned long ptr);
 
 struct ath6kl_vif *ath6kl_get_vif_by_index(struct ath6kl *ar, u8 if_idx);
-- 
1.7.0.4

