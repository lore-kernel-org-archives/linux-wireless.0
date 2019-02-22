Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DA3C10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F40322075C
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 14:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfBVOVf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:21:35 -0500
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:54040 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726881AbfBVOVd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 09:21:33 -0500
X-IronPort-AV: E=Sophos;i="5.58,400,1544482800"; 
   d="scan'208";a="2017374"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 22 Feb 2019 15:21:27 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9174"; a="7285581"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 22 Feb 2019 15:21:26 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 08/21] wil6210: align to latest auto generated wmi.h
Date:   Fri, 22 Feb 2019 16:21:06 +0200
Message-Id: <1550845279-16103-9-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
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
 drivers/net/wireless/ath/wil6210/wmi.c |  7 +++
 drivers/net/wireless/ath/wil6210/wmi.h | 91 ++++++++++++++++++++++++++++++++--
 2 files changed, 94 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index bda4a97..c737a79e 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -2957,6 +2957,10 @@ static const char *suspend_status2name(u8 status)
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
@@ -3046,6 +3050,9 @@ static void resume_triggers2string(u32 triggers, char *string, int str_size)
 
 	if (triggers & WMI_RESUME_TRIGGER_WMI_EVT)
 		strlcat(string, " WMI_EVT", str_size);
+
+	if (triggers & WMI_RESUME_TRIGGER_DISCONNECT)
+		strlcat(string, " DISCONNECT", str_size);
 }
 
 int wmi_resume(struct wil6210_priv *wil)
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index b668758..da46fc8 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2018, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
  * Copyright (c) 2006-2012 Wilocity
  *
@@ -104,6 +104,7 @@ enum wmi_fw_capability {
 	WMI_FW_CAPABILITY_RAW_MODE			= 24,
 	WMI_FW_CAPABILITY_TX_REQ_EXT			= 25,
 	WMI_FW_CAPABILITY_CHANNEL_4			= 26,
+	WMI_FW_CAPABILITY_IPA				= 27,
 	WMI_FW_CAPABILITY_MAX,
 };
 
@@ -294,6 +295,7 @@ enum wmi_command_id {
 	WMI_SET_AP_SLOT_SIZE_CMDID			= 0xA0F,
 	WMI_SET_VRING_PRIORITY_WEIGHT_CMDID		= 0xA10,
 	WMI_SET_VRING_PRIORITY_CMDID			= 0xA11,
+	WMI_RBUFCAP_CFG_CMDID				= 0xA12,
 	WMI_SET_MAC_ADDRESS_CMDID			= 0xF003,
 	WMI_ABORT_SCAN_CMDID				= 0xF007,
 	WMI_SET_PROMISCUOUS_MODE_CMDID			= 0xF041,
@@ -979,10 +981,22 @@ enum wmi_rx_msg_type {
 	WMI_RX_MSG_TYPE_EXTENDED	= 0x01,
 };
 
+enum wmi_ring_add_irq_mode {
+	/* Backwards compatibility
+	 *  for DESC ring - interrupt disabled
+	 *  for STATUS ring - interrupt enabled
+	 */
+	WMI_RING_ADD_IRQ_MODE_BWC	= 0x00,
+	WMI_RING_ADD_IRQ_MODE_DISABLE	= 0x01,
+	WMI_RING_ADD_IRQ_MODE_ENABLE	= 0x02,
+};
+
 struct wmi_tx_status_ring_add_cmd {
 	struct wmi_edma_ring_cfg ring_cfg;
 	u8 irq_index;
-	u8 reserved[3];
+	/* wmi_ring_add_irq_mode */
+	u8 irq_mode;
+	u8 reserved[2];
 } __packed;
 
 struct wmi_rx_status_ring_add_cmd {
@@ -1016,7 +1030,10 @@ struct wmi_tx_desc_ring_add_cmd {
 	u8 mac_ctrl;
 	u8 to_resolution;
 	u8 agg_max_wsize;
-	u8 reserved[3];
+	u8 irq_index;
+	/* wmi_ring_add_irq_mode */
+	u8 irq_mode;
+	u8 reserved;
 	struct wmi_vring_cfg_schd schd_params;
 } __packed;
 
@@ -1982,6 +1999,7 @@ enum wmi_event_id {
 	WMI_BEAMFORMING_MGMT_DONE_EVENTID		= 0x1836,
 	WMI_BF_TXSS_MGMT_DONE_EVENTID			= 0x1837,
 	WMI_BF_RXSS_MGMT_DONE_EVENTID			= 0x1839,
+	WMI_BF_TRIG_EVENTID				= 0x183A,
 	WMI_RS_MGMT_DONE_EVENTID			= 0x1852,
 	WMI_RF_MGMT_STATUS_EVENTID			= 0x1853,
 	WMI_BF_SM_MGMT_DONE_EVENTID			= 0x1838,
@@ -2082,6 +2100,7 @@ enum wmi_event_id {
 	WMI_SET_AP_SLOT_SIZE_EVENTID			= 0x1A0F,
 	WMI_SET_VRING_PRIORITY_WEIGHT_EVENTID		= 0x1A10,
 	WMI_SET_VRING_PRIORITY_EVENTID			= 0x1A11,
+	WMI_RBUFCAP_CFG_EVENTID				= 0x1A12,
 	WMI_SET_CHANNEL_EVENTID				= 0x9000,
 	WMI_ASSOC_REQ_EVENTID				= 0x9001,
 	WMI_EAPOL_RX_EVENTID				= 0x9002,
@@ -2267,7 +2286,9 @@ struct wmi_notify_req_done_event {
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
@@ -2316,6 +2337,7 @@ enum wmi_disconnect_reason {
 	WMI_DIS_REASON_PROFILE_MISMATCH		= 0x0C,
 	WMI_DIS_REASON_CONNECTION_EVICTED	= 0x0D,
 	WMI_DIS_REASON_IBSS_MERGE		= 0x0E,
+	WMI_DIS_REASON_HIGH_TEMPERATURE		= 0x0F,
 };
 
 /* WMI_DISCONNECT_EVENTID */
@@ -3168,6 +3190,30 @@ struct wmi_brp_set_ant_limit_event {
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
 
@@ -3263,6 +3309,8 @@ struct wmi_link_maintain_cfg_read_done_event {
 enum wmi_traffic_suspend_status {
 	WMI_TRAFFIC_SUSPEND_APPROVED			= 0x0,
 	WMI_TRAFFIC_SUSPEND_REJECTED_LINK_NOT_IDLE	= 0x1,
+	WMI_TRAFFIC_SUSPEND_REJECTED_DISCONNECT		= 0x2,
+	WMI_TRAFFIC_SUSPEND_REJECTED_OTHER		= 0x3,
 };
 
 /* WMI_TRAFFIC_SUSPEND_EVENTID */
@@ -3282,6 +3330,7 @@ enum wmi_resume_trigger {
 	WMI_RESUME_TRIGGER_UCAST_RX	= 0x2,
 	WMI_RESUME_TRIGGER_BCAST_RX	= 0x4,
 	WMI_RESUME_TRIGGER_WMI_EVT	= 0x8,
+	WMI_RESUME_TRIGGER_DISCONNECT	= 0x10,
 };
 
 /* WMI_TRAFFIC_RESUME_EVENTID */
@@ -4057,4 +4106,38 @@ struct wmi_set_vring_priority_event {
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
+/* WMI_RBUFCAP_CFG_CMD */
+struct wmi_rbufcap_cfg_cmd {
+	u8 enable;
+	u8 reserved;
+	/* RBUFCAP indicates rx space unavailable when number of rx
+	 * descriptors drops below this threshold. Set 0 to use system
+	 * default
+	 */
+	__le16 rx_desc_threshold;
+} __packed;
+
+/* WMI_RBUFCAP_CFG_EVENTID */
+struct wmi_rbufcap_cfg_event {
+	/* enum wmi_fw_status */
+	u8 status;
+	u8 reserved[3];
+} __packed;
+
 #endif /* __WILOCITY_WMI_H__ */
-- 
1.9.1

