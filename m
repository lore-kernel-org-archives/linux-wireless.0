Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF1EC282D0
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B69520880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfA1Pmx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:42:53 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:19718 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726792AbfA1Pmw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:42:52 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2019 10:42:40 EST
X-IronPort-AV: E=Sophos;i="5.56,534,1539640800"; 
   d="scan'208";a="1881359"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 28 Jan 2019 16:36:35 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9150"; a="7037509"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 28 Jan 2019 16:36:34 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 11/12] wil6210: align to latest auto generated wmi.h
Date:   Mon, 28 Jan 2019 17:36:25 +0200
Message-Id: <1548689786-23288-12-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
References: <1548689786-23288-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

Align to latest version of the auto generated wmi file
describing the interface with FW.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/wmi.c |  7 +++++
 drivers/net/wireless/ath/wil6210/wmi.h | 48 +++++++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index d86fc31..e959521 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -2954,6 +2954,10 @@ static const char *suspend_status2name(u8 status)
 	switch (status) {
 	case WMI_TRAFFIC_SUSPEND_REJECTED_LINK_NOT_IDLE:
 		return "LINK_NOT_IDLE";
+	case WMI_TRAFFIC_SUSPEND_REJECTED_DISCONNECT:
+		return "DISCONNECT";
+	case WMI_TRAFFIC_SUSPEND_REJECTED_OTHER:
+		return "OTHER";
 	default:
 		return "Untracked status";
 	}
@@ -3043,6 +3047,9 @@ static void resume_triggers2string(u32 triggers, char *string, int str_size)
 
 	if (triggers & WMI_RESUME_TRIGGER_WMI_EVT)
 		strlcat(string, " WMI_EVT", str_size);
+
+	if (triggers & WMI_RESUME_TRIGGER_DISCONNECT)
+		strlcat(string, " DISCONNECT", str_size);
 }
 
 int wmi_resume(struct wil6210_priv *wil)
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index b668758..cce5270 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -1982,6 +1982,7 @@ enum wmi_event_id {
 	WMI_BEAMFORMING_MGMT_DONE_EVENTID		= 0x1836,
 	WMI_BF_TXSS_MGMT_DONE_EVENTID			= 0x1837,
 	WMI_BF_RXSS_MGMT_DONE_EVENTID			= 0x1839,
+	WMI_BF_TRIG_EVENTID				= 0x183A,
 	WMI_RS_MGMT_DONE_EVENTID			= 0x1852,
 	WMI_RF_MGMT_STATUS_EVENTID			= 0x1853,
 	WMI_BF_SM_MGMT_DONE_EVENTID			= 0x1838,
@@ -2267,7 +2268,9 @@ struct wmi_notify_req_done_event {
 	__le32 status;
 	__le64 tsf;
 	s8 rssi;
-	u8 reserved0[3];
+	/* enum wmi_edmg_tx_mode */
+	u8 tx_mode;
+	u8 reserved0[2];
 	__le32 tx_tpt;
 	__le32 tx_goodput;
 	__le32 rx_goodput;
@@ -3168,6 +3171,30 @@ struct wmi_brp_set_ant_limit_event {
 	u8 reserved[3];
 } __packed;
 
+enum wmi_bf_type {
+	WMI_BF_TYPE_SLS		= 0x00,
+	WMI_BF_TYPE_BRP_RX	= 0x01,
+};
+
+/* WMI_BF_TRIG_CMDID */
+struct wmi_bf_trig_cmd {
+	/* enum wmi_bf_type - type of requested beamforming */
+	u8 bf_type;
+	/* used only for WMI_BF_TYPE_BRP_RX */
+	u8 cid;
+	/* used only for WMI_BF_TYPE_SLS */
+	u8 dst_mac[WMI_MAC_LEN];
+	u8 reserved[4];
+} __packed;
+
+/* WMI_BF_TRIG_EVENTID */
+struct wmi_bf_trig_event {
+	/* enum wmi_fw_status */
+	u8 status;
+	u8 cid;
+	u8 reserved[2];
+} __packed;
+
 /* broadcast connection ID */
 #define WMI_LINK_MAINTAIN_CFG_CID_BROADCAST	(0xFFFFFFFF)
 
@@ -3263,6 +3290,8 @@ struct wmi_link_maintain_cfg_read_done_event {
 enum wmi_traffic_suspend_status {
 	WMI_TRAFFIC_SUSPEND_APPROVED			= 0x0,
 	WMI_TRAFFIC_SUSPEND_REJECTED_LINK_NOT_IDLE	= 0x1,
+	WMI_TRAFFIC_SUSPEND_REJECTED_DISCONNECT		= 0x2,
+	WMI_TRAFFIC_SUSPEND_REJECTED_OTHER		= 0x3,
 };
 
 /* WMI_TRAFFIC_SUSPEND_EVENTID */
@@ -3282,6 +3311,7 @@ enum wmi_resume_trigger {
 	WMI_RESUME_TRIGGER_UCAST_RX	= 0x2,
 	WMI_RESUME_TRIGGER_BCAST_RX	= 0x4,
 	WMI_RESUME_TRIGGER_WMI_EVT	= 0x8,
+	WMI_RESUME_TRIGGER_DISCONNECT	= 0x10,
 };
 
 /* WMI_TRAFFIC_RESUME_EVENTID */
@@ -4057,4 +4087,20 @@ struct wmi_set_vring_priority_event {
 	u8 reserved[3];
 } __packed;
 
+/* WMI_RADAR_PCI_CTRL_BLOCK struct */
+struct wmi_radar_pci_ctrl_block {
+	/* last fw tail address index */
+	__le32 fw_tail_index;
+	/* last SW head address index known to FW */
+	__le32 sw_head_index;
+	__le32 last_wr_pulse_tsf_low;
+	__le32 last_wr_pulse_count;
+	__le32 last_wr_in_bytes;
+	__le32 last_wr_pulse_id;
+	__le32 last_wr_burst_id;
+	/* When pre overflow detected, advance sw head in unit of pulses */
+	__le32 sw_head_inc;
+	__le32 reserved[8];
+} __packed;
+
 #endif /* __WILOCITY_WMI_H__ */
-- 
1.9.1

