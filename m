Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12629 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbcJ2Fvx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Oct 2016 01:51:53 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 6/7] wil6210: support NL80211_ATTR_WIPHY_RETRY_SHORT
Date: Sat, 29 Oct 2016 08:51:26 +0300
Message-Id: <1477720287-17606-7-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20161029_075158_045842_37B6C791)
In-Reply-To: <1477720287-17606-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1477720287-17606-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Add support for setting retry limit for short frames,
using NL80211_CMD_SET_WIPHY with the attribute
NL80211_ATTR_WIPHY_RETRY_SHORT.
Update wiphy->retry_short from the FW default when interface
is brought up.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 21 ++++++++++
 drivers/net/wireless/ath/wil6210/main.c     | 15 ++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  2 +
 drivers/net/wireless/ath/wil6210/wmi.c      | 59 +++++++++++++++++++++++++++++
 4 files changed, 97 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 533872a..22078b0 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -702,6 +702,26 @@ static int wil_cfg80211_disconnect(struct wiphy *wiphy,
 	return rc;
 }
 
+static int wil_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	int rc;
+
+	/* these parameters are explicitly not supported */
+	if (changed & (WIPHY_PARAM_RETRY_LONG |
+		       WIPHY_PARAM_FRAG_THRESHOLD |
+		       WIPHY_PARAM_RTS_THRESHOLD))
+		return -ENOTSUPP;
+
+	if (changed & WIPHY_PARAM_RETRY_SHORT) {
+		rc = wmi_set_mgmt_retry(wil, wiphy->retry_short);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct cfg80211_mgmt_tx_params *params,
 			 u64 *cookie)
@@ -1489,6 +1509,7 @@ static struct cfg80211_ops wil_cfg80211_ops = {
 	.abort_scan = wil_cfg80211_abort_scan,
 	.connect = wil_cfg80211_connect,
 	.disconnect = wil_cfg80211_disconnect,
+	.set_wiphy_params = wil_cfg80211_set_wiphy_params,
 	.change_virtual_intf = wil_cfg80211_change_iface,
 	.get_station = wil_cfg80211_get_station,
 	.dump_station = wil_cfg80211_dump_station,
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 65a487c..70f9c07 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -693,6 +693,19 @@ static int wil_target_reset(struct wil6210_priv *wil)
 	return 0;
 }
 
+static void wil_collect_fw_info(struct wil6210_priv *wil)
+{
+	struct wiphy *wiphy = wil_to_wiphy(wil);
+	u8 retry_short;
+	int rc;
+
+	rc = wmi_get_mgmt_retry(wil, &retry_short);
+	if (!rc) {
+		wiphy->retry_short = retry_short;
+		wil_dbg_misc(wil, "FW retry_short: %d\n", retry_short);
+	}
+}
+
 void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
 {
 	le32_to_cpus(&r->base);
@@ -966,6 +979,8 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 			return rc;
 		}
 
+		wil_collect_fw_info(wil);
+
 		if (wil->platform_ops.notify) {
 			rc = wil->platform_ops.notify(wil->platform_handle,
 						      WIL_PLATFORM_EVT_FW_RDY);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index d65a5e6..b449f84 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -821,6 +821,8 @@ int wmi_addba_rx_resp(struct wil6210_priv *wil, u8 cid, u8 tid, u8 token,
 		      u16 status, bool amsdu, u16 agg_wsize, u16 timeout);
 int wmi_ps_dev_profile_cfg(struct wil6210_priv *wil,
 			   enum wmi_ps_profile_type ps_profile);
+int wmi_set_mgmt_retry(struct wil6210_priv *wil, u8 retry_short);
+int wmi_get_mgmt_retry(struct wil6210_priv *wil, u8 *retry_short);
 int wil_addba_rx_request(struct wil6210_priv *wil, u8 cidxtid,
 			 u8 dialog_token, __le16 ba_param_set,
 			 __le16 ba_timeout, __le16 ba_seq_ctrl);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index e726548..2971ddf 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1599,6 +1599,65 @@ int wmi_ps_dev_profile_cfg(struct wil6210_priv *wil,
 	return rc;
 }
 
+int wmi_set_mgmt_retry(struct wil6210_priv *wil, u8 retry_short)
+{
+	int rc;
+	struct wmi_set_mgmt_retry_limit_cmd cmd = {
+		.mgmt_retry_limit = retry_short,
+	};
+	struct {
+		struct wmi_cmd_hdr wmi;
+		struct wmi_set_mgmt_retry_limit_event evt;
+	} __packed reply;
+
+	wil_dbg_wmi(wil, "Setting mgmt retry short %d\n", retry_short);
+
+	if (!test_bit(WMI_FW_CAPABILITY_MGMT_RETRY_LIMIT, wil->fw_capabilities))
+		return -ENOTSUPP;
+
+	reply.evt.status = WMI_FW_STATUS_FAILURE;
+
+	rc = wmi_call(wil, WMI_SET_MGMT_RETRY_LIMIT_CMDID, &cmd, sizeof(cmd),
+		      WMI_SET_MGMT_RETRY_LIMIT_EVENTID, &reply, sizeof(reply),
+		      100);
+	if (rc)
+		return rc;
+
+	if (reply.evt.status != WMI_FW_STATUS_SUCCESS) {
+		wil_err(wil, "set mgmt retry limit failed with status %d\n",
+			reply.evt.status);
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
+int wmi_get_mgmt_retry(struct wil6210_priv *wil, u8 *retry_short)
+{
+	int rc;
+	struct {
+		struct wmi_cmd_hdr wmi;
+		struct wmi_get_mgmt_retry_limit_event evt;
+	} __packed reply;
+
+	wil_dbg_wmi(wil, "getting mgmt retry short\n");
+
+	if (!test_bit(WMI_FW_CAPABILITY_MGMT_RETRY_LIMIT, wil->fw_capabilities))
+		return -ENOTSUPP;
+
+	reply.evt.mgmt_retry_limit = 0;
+	rc = wmi_call(wil, WMI_GET_MGMT_RETRY_LIMIT_CMDID, NULL, 0,
+		      WMI_GET_MGMT_RETRY_LIMIT_EVENTID, &reply, sizeof(reply),
+		      100);
+	if (rc)
+		return rc;
+
+	if (retry_short)
+		*retry_short = reply.evt.mgmt_retry_limit;
+
+	return 0;
+}
+
 int wmi_abort_scan(struct wil6210_priv *wil)
 {
 	int rc;
-- 
1.9.1
