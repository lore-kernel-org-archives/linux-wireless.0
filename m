Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51213 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095Ab3LCHSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 02:18:41 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 01/12] mwifiex: use little-endian variables in firmware structures
Date: Mon, 2 Dec 2013 23:17:48 -0800
Message-ID: <1386055079-6623-2-git-send-email-bzhao@marvell.com> (sfid-20131203_081900_169764_720FEFAA)
In-Reply-To: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
References: <1386055079-6623-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ujjal Roy <royujjal@gmail.com>

The firmware expects the command structure members in little
endianness.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c  |  4 ++--
 drivers/net/wireless/mwifiex/fw.h      | 28 ++++++++++++++--------------
 drivers/net/wireless/mwifiex/sta_cmd.c |  2 +-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index e47f4e3..1ddc8b2 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -312,14 +312,14 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 	}
 	if (GET_BSS_ROLE(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY))
 	    == MWIFIEX_BSS_ROLE_STA) {
-		if (!sleep_cfm_buf->resp_ctrl)
+		if (!le16_to_cpu(sleep_cfm_buf->resp_ctrl))
 			/* Response is not needed for sleep
 			   confirm command */
 			adapter->ps_state = PS_STATE_SLEEP;
 		else
 			adapter->ps_state = PS_STATE_SLEEP_CFM;
 
-		if (!sleep_cfm_buf->resp_ctrl &&
+		if (!le16_to_cpu(sleep_cfm_buf->resp_ctrl) &&
 		    (adapter->is_hs_configured &&
 		     !adapter->sleep_period.period)) {
 			adapter->pm_wakeup_card_req = true;
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index c8385ec..6998413 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -610,12 +610,12 @@ struct mwifiex_ie_types_tsf_timestamp {
 struct mwifiex_cf_param_set {
 	u8 cfp_cnt;
 	u8 cfp_period;
-	u16 cfp_max_duration;
-	u16 cfp_duration_remaining;
+	__le16 cfp_max_duration;
+	__le16 cfp_duration_remaining;
 } __packed;
 
 struct mwifiex_ibss_param_set {
-	u16 atim_window;
+	__le16 atim_window;
 } __packed;
 
 struct mwifiex_ie_types_ss_param_set {
@@ -627,7 +627,7 @@ struct mwifiex_ie_types_ss_param_set {
 } __packed;
 
 struct mwifiex_fh_param_set {
-	u16 dwell_time;
+	__le16 dwell_time;
 	u8 hop_set;
 	u8 hop_pattern;
 	u8 hop_index;
@@ -684,10 +684,10 @@ struct host_cmd_ds_802_11_key_material {
 } __packed;
 
 struct host_cmd_ds_gen {
-	u16 command;
-	u16 size;
-	u16 seq_num;
-	u16 result;
+	__le16 command;
+	__le16 size;
+	__le16 seq_num;
+	__le16 result;
 };
 
 #define S_DS_GEN        sizeof(struct host_cmd_ds_gen)
@@ -820,8 +820,8 @@ struct ieee_types_cf_param_set {
 	u8 len;
 	u8 cfp_cnt;
 	u8 cfp_period;
-	u16 cfp_max_duration;
-	u16 cfp_duration_remaining;
+	__le16 cfp_max_duration;
+	__le16 cfp_duration_remaining;
 } __packed;
 
 struct ieee_types_ibss_param_set {
@@ -957,7 +957,7 @@ struct mwifiex_hs_config_param {
 } __packed;
 
 struct hs_activate_param {
-	u16 resp_ctrl;
+	__le16 resp_ctrl;
 } __packed;
 
 struct host_cmd_ds_802_11_hs_cfg_enh {
@@ -1131,7 +1131,7 @@ struct host_cmd_ds_802_11_bg_scan_query {
 } __packed;
 
 struct host_cmd_ds_802_11_bg_scan_query_rsp {
-	u32 report_condition;
+	__le32 report_condition;
 	struct host_cmd_ds_802_11_scan_rsp scan_resp;
 } __packed;
 
@@ -1230,7 +1230,7 @@ struct mwifiex_ie_types_wmm_queue_status {
 	struct mwifiex_ie_types_header header;
 	u8 queue_index;
 	u8 disabled;
-	u16 medium_time;
+	__le16 medium_time;
 	u8 flow_required;
 	u8 flow_created;
 	u32 reserved;
@@ -1310,7 +1310,7 @@ struct mwifiex_ie_types_vht_oper {
 	u8 chan_center_freq_1;
 	u8 chan_center_freq_2;
 	/* Basic MCS set map, each 2 bits stands for a NSS */
-	u16 basic_mcs_map;
+	__le16 basic_mcs_map;
 } __packed;
 
 struct mwifiex_ie_types_wmmcap {
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 2181ee2..1efa43e 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -354,7 +354,7 @@ mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 	}
 	if (hs_activate) {
 		hs_cfg->action = cpu_to_le16(HS_ACTIVATE);
-		hs_cfg->params.hs_activate.resp_ctrl = RESP_NEEDED;
+		hs_cfg->params.hs_activate.resp_ctrl = cpu_to_le16(RESP_NEEDED);
 	} else {
 		hs_cfg->action = cpu_to_le16(HS_CONFIGURE);
 		hs_cfg->params.hs_config.conditions = hscfg_param->conditions;
-- 
1.8.2.3

