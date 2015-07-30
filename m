Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64261 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbbG3Kyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:46 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 12/19] wil6210: unify wmi_set_ie() error handling
Date: Thu, 30 Jul 2015 13:52:00 +0300
Message-Id: <1438253527-3372-13-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_130716_291042_3029AABE)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When printing error message, provide string describing IE kind.
Derive it from IE type
This allows removing of error messages printing
in callers

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 29 ++++++++---------------------
 drivers/net/wireless/ath/wil6210/wmi.c      | 19 +++++++++++++++++--
 2 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 8811174..20d07ef 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -336,12 +336,9 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	else
 		wil_dbg_misc(wil, "Scan has no IE's\n");
 
-	rc = wmi_set_ie(wil, WMI_FRAME_PROBE_REQ, request->ie_len,
-			request->ie);
-	if (rc) {
-		wil_err(wil, "Aborting scan, set_ie failed: %d\n", rc);
+	rc = wmi_set_ie(wil, WMI_FRAME_PROBE_REQ, request->ie_len, request->ie);
+	if (rc)
 		goto out;
-	}
 
 	rc = wmi_send(wil, WMI_START_SCAN_CMDID, &cmd, sizeof(cmd.cmd) +
 			cmd.cmd.num_channels * sizeof(cmd.cmd.channel_list[0]));
@@ -462,10 +459,8 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	 * ies in FW.
 	 */
 	rc = wmi_set_ie(wil, WMI_FRAME_ASSOC_REQ, sme->ie_len, sme->ie);
-	if (rc) {
-		wil_err(wil, "WMI_SET_APPIE_CMD failed\n");
+	if (rc)
 		goto out;
-	}
 
 	/* WMI_CONNECT_CMD */
 	memset(&conn, 0, sizeof(conn));
@@ -748,27 +743,19 @@ static int _wil_cfg80211_set_ies(struct wiphy *wiphy,
 
 	rc = wmi_set_ie(wil, WMI_FRAME_PROBE_RESP, bcon->proberesp_ies_len,
 			bcon->proberesp_ies);
-	if (rc) {
-		wil_err(wil, "set_ie(PROBE_RESP) failed\n");
+	if (rc)
 		return rc;
-	}
 
 	rc = wmi_set_ie(wil, WMI_FRAME_ASSOC_RESP, bcon->assocresp_ies_len,
 			bcon->assocresp_ies);
-	if (rc) {
-		wil_err(wil, "set_ie(ASSOC_RESP) failed\n");
-		return rc;
-	}
 #if 0 /* to use beacon IE's, remove this #if 0 */
-	rc = wmi_set_ie(wil, WMI_FRAME_BEACON, bcon->tail_len,
-			bcon->tail);
-	if (rc) {
-		wil_err(wil, "set_ie(BEACON) failed\n");
+	if (rc)
 		return rc;
-	}
+
+	rc = wmi_set_ie(wil, WMI_FRAME_BEACON, bcon->tail_len, bcon->tail);
 #endif
 
-	return 0;
+	return rc;
 }
 
 static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index fbcea83..b9cf9a6 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1022,12 +1022,21 @@ int wmi_add_cipher_key(struct wil6210_priv *wil, u8 key_index,
 
 int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie)
 {
+	static const char *const names[] = {
+		[WMI_FRAME_BEACON]	= "BEACON",
+		[WMI_FRAME_PROBE_REQ]	= "PROBE_REQ",
+		[WMI_FRAME_PROBE_RESP]	= "WMI_FRAME_PROBE_RESP",
+		[WMI_FRAME_ASSOC_REQ]	= "WMI_FRAME_ASSOC_REQ",
+		[WMI_FRAME_ASSOC_RESP]	= "WMI_FRAME_ASSOC_RESP",
+	};
 	int rc;
 	u16 len = sizeof(struct wmi_set_appie_cmd) + ie_len;
 	struct wmi_set_appie_cmd *cmd = kzalloc(len, GFP_KERNEL);
 
-	if (!cmd)
-		return -ENOMEM;
+	if (!cmd) {
+		rc = -ENOMEM;
+		goto out;
+	}
 	if (!ie)
 		ie_len = 0;
 
@@ -1037,6 +1046,12 @@ int wmi_set_ie(struct wil6210_priv *wil, u8 type, u16 ie_len, const void *ie)
 	memcpy(cmd->ie_info, ie, ie_len);
 	rc = wmi_send(wil, WMI_SET_APPIE_CMDID, cmd, len);
 	kfree(cmd);
+out:
+	if (rc) {
+		const char *name = type < ARRAY_SIZE(names) ?
+				   names[type] : "??";
+		wil_err(wil, "set_ie(%d %s) failed : %d\n", type, name, rc);
+	}
 
 	return rc;
 }
-- 
2.1.4

