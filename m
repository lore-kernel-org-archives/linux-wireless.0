Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24410 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751737AbdALNPW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 08:15:22 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH v2 09/13] wil6210: align to latest auto generated wmi.h
Date: Thu, 12 Jan 2017 15:06:01 +0200
Message-Id: <1484226365-10433-10-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170112_141538_530016_B295BD7E)
In-Reply-To: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Align to latest version of the auto generated wmi file
describing the interface with FW.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.h | 45 ++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 906aa72..7c9fee5 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -187,6 +187,7 @@ enum wmi_command_id {
 	WMI_RS_CFG_CMDID				= 0x921,
 	WMI_GET_DETAILED_RS_RES_CMDID			= 0x922,
 	WMI_AOA_MEAS_CMDID				= 0x923,
+	WMI_BRP_SET_ANT_LIMIT_CMDID			= 0x924,
 	WMI_SET_MGMT_RETRY_LIMIT_CMDID			= 0x930,
 	WMI_GET_MGMT_RETRY_LIMIT_CMDID			= 0x931,
 	WMI_NEW_STA_CMDID				= 0x935,
@@ -547,7 +548,9 @@ struct wmi_pcp_start_cmd {
 	u8 pcp_max_assoc_sta;
 	u8 hidden_ssid;
 	u8 is_go;
-	u8 reserved0[6];
+	u8 reserved0[5];
+	/* abft_len override if non-0 */
+	u8 abft_len;
 	u8 disable_ap_sme;
 	u8 network_type;
 	u8 channel;
@@ -1084,6 +1087,7 @@ enum wmi_event_id {
 	WMI_RS_CFG_DONE_EVENTID				= 0x1921,
 	WMI_GET_DETAILED_RS_RES_EVENTID			= 0x1922,
 	WMI_AOA_MEAS_EVENTID				= 0x1923,
+	WMI_BRP_SET_ANT_LIMIT_EVENTID			= 0x1924,
 	WMI_SET_MGMT_RETRY_LIMIT_EVENTID		= 0x1930,
 	WMI_GET_MGMT_RETRY_LIMIT_EVENTID		= 0x1931,
 	WMI_TOF_SESSION_END_EVENTID			= 0x1991,
@@ -1304,7 +1308,8 @@ struct wmi_connect_event {
 	u8 assoc_req_len;
 	u8 assoc_resp_len;
 	u8 cid;
-	u8 reserved2[3];
+	u8 aid;
+	u8 reserved2[2];
 	/* not in use */
 	u8 assoc_info[0];
 } __packed;
@@ -1777,6 +1782,42 @@ struct wmi_get_detailed_rs_res_event {
 	u8 reserved[3];
 } __packed;
 
+/* BRP antenna limit mode */
+enum wmi_brp_ant_limit_mode {
+	/* Disable BRP force antenna limit */
+	WMI_BRP_ANT_LIMIT_MODE_DISABLE		= 0x00,
+	/* Define maximal antennas limit. Only effective antennas will be
+	 * actually used
+	 */
+	WMI_BRP_ANT_LIMIT_MODE_EFFECTIVE	= 0x01,
+	/* Force a specific number of antennas */
+	WMI_BRP_ANT_LIMIT_MODE_FORCE		= 0x02,
+	/* number of BRP antenna limit modes */
+	WMI_BRP_ANT_LIMIT_MODES_NUM		= 0x03,
+};
+
+/* WMI_BRP_SET_ANT_LIMIT_CMDID */
+struct wmi_brp_set_ant_limit_cmd {
+	/* connection id */
+	u8 cid;
+	/* enum wmi_brp_ant_limit_mode */
+	u8 limit_mode;
+	/* antenna limit count, 1-27
+	 * disable_mode - ignored
+	 * effective_mode - upper limit to number of antennas to be used
+	 * force_mode - exact number of antennas to be used
+	 */
+	u8 ant_limit;
+	u8 reserved;
+} __packed;
+
+/* WMI_BRP_SET_ANT_LIMIT_EVENTID */
+struct wmi_brp_set_ant_limit_event {
+	/* wmi_fw_status */
+	u8 status;
+	u8 reserved[3];
+} __packed;
+
 /* broadcast connection ID */
 #define WMI_LINK_MAINTAIN_CFG_CID_BROADCAST	(0xFFFFFFFF)
 
-- 
1.9.1
