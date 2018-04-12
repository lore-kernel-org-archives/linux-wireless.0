Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:23196 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752474AbeDLII6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 04:08:58 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 07/10] wil6210: move WMI functionality out of wil_cfg80211_mgmt_tx
Date: Thu, 12 Apr 2018 11:08:43 +0300
Message-Id: <1523520526-24997-8-git-send-email-merez@codeaurora.org> (sfid-20180412_100901_832173_556B1224)
In-Reply-To: <1523520526-24997-1-git-send-email-merez@codeaurora.org>
References: <1523520526-24997-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <dlansky@codeaurora.org>

Rearrange the code by having new function wmi_mgmt_tx() to take care
of the WMI part of wil_cfg80211_mgmt_tx().

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 39 +++---------------------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 drivers/net/wireless/ath/wil6210/wmi.c      | 47 +++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index ba9a81c..568d414 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1175,17 +1175,11 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 u64 *cookie)
 {
 	const u8 *buf = params->buf;
-	size_t len = params->len, total;
+	size_t len = params->len;
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	struct wil6210_vif *vif = wdev_to_vif(wil, wdev);
 	int rc;
-	bool tx_status = false;
-	struct ieee80211_mgmt *mgmt_frame = (void *)buf;
-	struct wmi_sw_tx_req_cmd *cmd;
-	struct {
-		struct wmi_cmd_hdr wmi;
-		struct wmi_sw_tx_complete_event evt;
-	} __packed evt;
+	bool tx_status;
 
 	/* Note, currently we do not support the "wait" parameter, user-space
 	 * must call remain_on_channel before mgmt_tx or listen on a channel
@@ -1194,34 +1188,9 @@ int wil_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	 * different from currently "listened" channel and fail if it is.
 	 */
 
-	wil_dbg_misc(wil, "mgmt_tx mid %d\n", vif->mid);
-	wil_hex_dump_misc("mgmt tx frame ", DUMP_PREFIX_OFFSET, 16, 1, buf,
-			  len, true);
-
-	if (len < sizeof(struct ieee80211_hdr_3addr))
-		return -EINVAL;
-
-	total = sizeof(*cmd) + len;
-	if (total < len)
-		return -EINVAL;
-
-	cmd = kmalloc(total, GFP_KERNEL);
-	if (!cmd) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	memcpy(cmd->dst_mac, mgmt_frame->da, WMI_MAC_LEN);
-	cmd->len = cpu_to_le16(len);
-	memcpy(cmd->payload, buf, len);
-
-	rc = wmi_call(wil, WMI_SW_TX_REQ_CMDID, vif->mid, cmd, total,
-		      WMI_SW_TX_COMPLETE_EVENTID, &evt, sizeof(evt), 2000);
-	if (rc == 0)
-		tx_status = !evt.evt.status;
+	rc = wmi_mgmt_tx(vif, buf, len);
+	tx_status = (rc == 0);
 
-	kfree(cmd);
- out:
 	cfg80211_mgmt_tx_status(wdev, cookie ? *cookie : 0, buf, len,
 				tx_status, GFP_KERNEL);
 	return rc;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 633eb71..2f77319 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1157,6 +1157,7 @@ int wil_request_firmware(struct wil6210_priv *wil, const char *name,
 int wmi_start_sched_scan(struct wil6210_priv *wil,
 			 struct cfg80211_sched_scan_request *request);
 int wmi_stop_sched_scan(struct wil6210_priv *wil);
+int wmi_mgmt_tx(struct wil6210_vif *vif, const u8 *buf, size_t len);
 
 int wil_wmi2spec_ch(u8 wmi_ch, u8 *spec_ch);
 int wil_spec2wmi_ch(u8 spec_ch, u8 *wmi_ch);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index cdaf80d..27ba42d 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -2792,3 +2792,50 @@ int wmi_stop_sched_scan(struct wil6210_priv *wil)
 
 	return 0;
 }
+
+int wmi_mgmt_tx(struct wil6210_vif *vif, const u8 *buf, size_t len)
+{
+	size_t total;
+	struct wil6210_priv *wil = vif_to_wil(vif);
+	struct ieee80211_mgmt *mgmt_frame = (void *)buf;
+	struct wmi_sw_tx_req_cmd *cmd;
+	struct {
+		struct wmi_cmd_hdr wmi;
+		struct wmi_sw_tx_complete_event evt;
+	} __packed evt = {
+		.evt = {.status = WMI_FW_STATUS_FAILURE},
+	};
+	int rc;
+
+	wil_dbg_misc(wil, "mgmt_tx mid %d\n", vif->mid);
+	wil_hex_dump_misc("mgmt tx frame ", DUMP_PREFIX_OFFSET, 16, 1, buf,
+			  len, true);
+
+	if (len < sizeof(struct ieee80211_hdr_3addr))
+		return -EINVAL;
+
+	total = sizeof(*cmd) + len;
+	if (total < len) {
+		wil_err(wil, "mgmt_tx invalid len %zu\n", len);
+		return -EINVAL;
+	}
+
+	cmd = kmalloc(total, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	memcpy(cmd->dst_mac, mgmt_frame->da, WMI_MAC_LEN);
+	cmd->len = cpu_to_le16(len);
+	memcpy(cmd->payload, buf, len);
+
+	rc = wmi_call(wil, WMI_SW_TX_REQ_CMDID, vif->mid, cmd, total,
+		      WMI_SW_TX_COMPLETE_EVENTID, &evt, sizeof(evt), 2000);
+	if (!rc && evt.evt.status != WMI_FW_STATUS_SUCCESS) {
+		wil_err(wil, "mgmt_tx failed with status %d\n", evt.evt.status);
+		rc = -EINVAL;
+	}
+
+	kfree(cmd);
+
+	return rc;
+}
-- 
1.9.1
