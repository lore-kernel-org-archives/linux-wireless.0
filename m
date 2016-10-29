Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12629 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbcJ2Fvp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Oct 2016 01:51:45 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 2/7] wil6210: add support for power save enable / disable
Date: Sat, 29 Oct 2016 08:51:22 +0300
Message-Id: <1477720287-17606-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20161029_075151_823034_7DDEE1C4)
In-Reply-To: <1477720287-17606-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1477720287-17606-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New power management wmi commands provide the ability to change
the device power save profile (enable / disable power save).

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 32 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h  |  2 ++
 drivers/net/wireless/ath/wil6210/wmi.c      | 34 +++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index d117240..c6dd7a3 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1424,6 +1424,34 @@ static void wil_cfg80211_stop_p2p_device(struct wiphy *wiphy,
 	mutex_unlock(&wil->mutex);
 }
 
+static int wil_cfg80211_set_power_mgmt(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       bool enabled, int timeout)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	enum wmi_ps_profile_type ps_profile;
+	int rc;
+
+	if (!test_bit(WMI_FW_CAPABILITY_PS_CONFIG, wil->fw_capabilities)) {
+		wil_err(wil, "set_power_mgmt not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	wil_dbg_misc(wil, "enabled=%d, timeout=%d\n",
+		     enabled, timeout);
+
+	if (enabled)
+		ps_profile = WMI_PS_PROFILE_TYPE_DEFAULT;
+	else
+		ps_profile = WMI_PS_PROFILE_TYPE_PS_DISABLED;
+
+	rc  = wmi_ps_dev_profile_cfg(wil, ps_profile);
+	if (rc)
+		wil_err(wil, "wmi_ps_dev_profile_cfg failed (%d)\n", rc);
+
+	return rc;
+}
+
 static struct cfg80211_ops wil_cfg80211_ops = {
 	.add_virtual_intf = wil_cfg80211_add_iface,
 	.del_virtual_intf = wil_cfg80211_del_iface,
@@ -1450,6 +1478,7 @@ static struct cfg80211_ops wil_cfg80211_ops = {
 	/* P2P device */
 	.start_p2p_device = wil_cfg80211_start_p2p_device,
 	.stop_p2p_device = wil_cfg80211_stop_p2p_device,
+	.set_power_mgmt = wil_cfg80211_set_power_mgmt,
 };
 
 static void wil_wiphy_init(struct wiphy *wiphy)
@@ -1466,7 +1495,8 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 				 BIT(NL80211_IFTYPE_MONITOR);
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
+			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
+			WIPHY_FLAG_PS_ON_BY_DEFAULT;
 	dev_dbg(wiphy_dev(wiphy), "%s : flags = 0x%08x\n",
 		__func__, wiphy->flags);
 	wiphy->probe_resp_offload =
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 12cd81b..4b22ea4 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -819,6 +819,8 @@ int wmi_delba_tx(struct wil6210_priv *wil, u8 ringid, u16 reason);
 int wmi_delba_rx(struct wil6210_priv *wil, u8 cidxtid, u16 reason);
 int wmi_addba_rx_resp(struct wil6210_priv *wil, u8 cid, u8 tid, u8 token,
 		      u16 status, bool amsdu, u16 agg_wsize, u16 timeout);
+int wmi_ps_dev_profile_cfg(struct wil6210_priv *wil,
+			   enum wmi_ps_profile_type ps_profile);
 int wil_addba_rx_request(struct wil6210_priv *wil, u8 cidxtid,
 			 u8 dialog_token, __le16 ba_param_set,
 			 __le16 ba_timeout, __le16 ba_seq_ctrl);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 890960e..8c60437 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1563,6 +1563,40 @@ int wmi_addba_rx_resp(struct wil6210_priv *wil, u8 cid, u8 tid, u8 token,
 	return rc;
 }
 
+int wmi_ps_dev_profile_cfg(struct wil6210_priv *wil,
+			   enum wmi_ps_profile_type ps_profile)
+{
+	int rc;
+	struct wmi_ps_dev_profile_cfg_cmd cmd = {
+		.ps_profile = ps_profile,
+	};
+	struct {
+		struct wmi_cmd_hdr wmi;
+		struct wmi_ps_dev_profile_cfg_event evt;
+	} __packed reply;
+	u32 status;
+
+	wil_dbg_wmi(wil, "Setting ps dev profile %d\n", ps_profile);
+
+	reply.evt.status = cpu_to_le32(WMI_PS_CFG_CMD_STATUS_ERROR);
+
+	rc = wmi_call(wil, WMI_PS_DEV_PROFILE_CFG_CMDID, &cmd, sizeof(cmd),
+		      WMI_PS_DEV_PROFILE_CFG_EVENTID, &reply, sizeof(reply),
+		      100);
+	if (rc)
+		return rc;
+
+	status = le32_to_cpu(reply.evt.status);
+
+	if (status != WMI_PS_CFG_CMD_STATUS_SUCCESS) {
+		wil_err(wil, "ps dev profile cfg failed with status %d\n",
+			status);
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
 void wmi_event_flush(struct wil6210_priv *wil)
 {
 	struct pending_wmi_event *evt, *t;
-- 
1.9.1
