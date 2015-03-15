Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:57392 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbbCOOA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:00:57 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 5/7] wil6210: add bcast structures to WMI
Date: Sun, 15 Mar 2015 16:00:22 +0200
Message-Id: <1426428024-4538-9-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150315_150106_547075_45BA0814)
In-Reply-To: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sync with the wmi definitions from the firmware team

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.h | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 0979650..b290553 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -70,7 +70,6 @@ enum wmi_command_id {
 	WMI_SET_UCODE_IDLE_CMDID	= 0x0813,
 	WMI_SET_WORK_MODE_CMDID		= 0x0815,
 	WMI_LO_LEAKAGE_CALIB_CMDID	= 0x0816,
-	WMI_MARLON_R_ACTIVATE_CMDID	= 0x0817,
 	WMI_MARLON_R_READ_CMDID		= 0x0818,
 	WMI_MARLON_R_WRITE_CMDID	= 0x0819,
 	WMI_MARLON_R_TXRX_SEL_CMDID	= 0x081a,
@@ -80,6 +79,7 @@ enum wmi_command_id {
 	WMI_RF_RX_TEST_CMDID		= 0x081e,
 	WMI_CFG_RX_CHAIN_CMDID		= 0x0820,
 	WMI_VRING_CFG_CMDID		= 0x0821,
+	WMI_BCAST_VRING_CFG_CMDID	= 0x0822,
 	WMI_VRING_BA_EN_CMDID		= 0x0823,
 	WMI_VRING_BA_DIS_CMDID		= 0x0824,
 	WMI_RCP_ADDBA_RESP_CMDID	= 0x0825,
@@ -99,6 +99,7 @@ enum wmi_command_id {
 	WMI_BF_TXSS_MGMT_CMDID		= 0x0837,
 	WMI_BF_SM_MGMT_CMDID		= 0x0838,
 	WMI_BF_RXSS_MGMT_CMDID		= 0x0839,
+	WMI_BF_TRIG_CMDID		= 0x083A,
 	WMI_SET_SECTORS_CMDID		= 0x0849,
 	WMI_MAINTAIN_PAUSE_CMDID	= 0x0850,
 	WMI_MAINTAIN_RESUME_CMDID	= 0x0851,
@@ -596,6 +597,22 @@ struct wmi_vring_cfg_cmd {
 } __packed;
 
 /*
+ * WMI_BCAST_VRING_CFG_CMDID
+ */
+struct wmi_bcast_vring_cfg {
+	struct wmi_sw_ring_cfg tx_sw_ring;
+	u8 ringid;				/* 0-23 vrings */
+	u8 encap_trans_type;
+	u8 ds_cfg;				/* 802.3 DS cfg */
+	u8 nwifi_ds_trans_type;
+} __packed;
+
+struct wmi_bcast_vring_cfg_cmd {
+	__le32 action;
+	struct wmi_bcast_vring_cfg vring_cfg;
+} __packed;
+
+/*
  * WMI_VRING_BA_EN_CMDID
  */
 struct wmi_vring_ba_en_cmd {
@@ -844,7 +861,6 @@ enum wmi_event_id {
 	WMI_IQ_RX_CALIB_DONE_EVENTID		= 0x1812,
 	WMI_SET_WORK_MODE_DONE_EVENTID		= 0x1815,
 	WMI_LO_LEAKAGE_CALIB_DONE_EVENTID	= 0x1816,
-	WMI_MARLON_R_ACTIVATE_DONE_EVENTID	= 0x1817,
 	WMI_MARLON_R_READ_DONE_EVENTID		= 0x1818,
 	WMI_MARLON_R_WRITE_DONE_EVENTID		= 0x1819,
 	WMI_MARLON_R_TXRX_SEL_DONE_EVENTID	= 0x181a,
-- 
2.1.0

