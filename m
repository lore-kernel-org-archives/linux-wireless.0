Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45050 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbeB1HNh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 02:13:37 -0500
From: Ramon Fried <rfried@codeaurora.org>
To: k.eugene.e@gmail.com, kvalo@codeaurora.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: Eyal Ilsar <eilsar@codeaurora.org>,
        Ramon Fried <rfried@codeaurora.org>
Subject: [PATCH] wcn36xx: Add support for FTM WLAN
Date: Wed, 28 Feb 2018 09:13:28 +0200
Message-Id: <20180228071328.5605-1-rfried@codeaurora.org> (sfid-20180228_081342_538686_D7193434)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Ilsar <eilsar@codeaurora.org>

Introduced infrastructure for supporting FTM WLAN in user space exposing
the netlink channel from the kernel WLAN driver. This included:
1) Registered wcn36xx driver to testmode callback from netlink
2) Added testmode callback implementation to handle incoming FTM commands
3) Added FTM command packet structure
4) Added handling for GET_BUILD_RELEASE_NUMBER (msgid=0x32A2)
5) Added generic handling for all PTT_MSG packets

Signed-off-by: Eyal Ilsar <eilsar@codeaurora.org>
Signed-off-by: Ramon Fried <rfried@codeaurora.org>
---
 drivers/net/wireless/ath/wcn36xx/Makefile     |   2 +
 drivers/net/wireless/ath/wcn36xx/hal.h        |  16 +++
 drivers/net/wireless/ath/wcn36xx/main.c       |   3 +
 drivers/net/wireless/ath/wcn36xx/smd.c        |  72 ++++++++++++
 drivers/net/wireless/ath/wcn36xx/smd.h        |   4 +
 drivers/net/wireless/ath/wcn36xx/testmode.c   | 161 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/testmode.h   |  42 +++++++
 drivers/net/wireless/ath/wcn36xx/testmode_i.h |  41 +++++++
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h    |   2 +
 9 files changed, 343 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/testmode.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/testmode.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/testmode_i.h

diff --git a/drivers/net/wireless/ath/wcn36xx/Makefile b/drivers/net/wireless/ath/wcn36xx/Makefile
index 3b09435104eb..582049f65735 100644
--- a/drivers/net/wireless/ath/wcn36xx/Makefile
+++ b/drivers/net/wireless/ath/wcn36xx/Makefile
@@ -6,3 +6,5 @@ wcn36xx-y +=   main.o \
                smd.o \
                pmc.o \
                debug.o
+
+wcn36xx-$(CONFIG_NL80211_TESTMODE) += testmode.o
diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 182963522941..d2df6750e5f6 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -2230,6 +2230,22 @@ struct wcn36xx_hal_switch_channel_rsp_msg {
 
 } __packed;
 
+struct wcn36xx_hal_process_ptt_msg_req_msg {
+	struct wcn36xx_hal_msg_header header;
+
+	/* Actual FTM Command body */
+	u8 ptt_msg[0];
+} __packed;
+
+struct wcn36xx_hal_process_ptt_msg_rsp_msg {
+	struct wcn36xx_hal_msg_header header;
+
+	/* FTM Command response status */
+	u32   ptt_msg_resp_status;
+	/* Actual FTM Command body */
+	u8 ptt_msg[0];
+} __packed;
+
 struct update_edca_params_req_msg {
 	struct wcn36xx_hal_msg_header header;
 
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 8c2654075eb8..6b73da6f7fde 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -26,6 +26,7 @@
 #include <linux/soc/qcom/smem_state.h>
 #include <linux/soc/qcom/wcnss_ctrl.h>
 #include "wcn36xx.h"
+#include "testmode.h"
 
 unsigned int wcn36xx_dbg_mask;
 module_param_named(debug_mask, wcn36xx_dbg_mask, uint, 0644);
@@ -1119,6 +1120,8 @@ static const struct ieee80211_ops wcn36xx_ops = {
 	.sta_add		= wcn36xx_sta_add,
 	.sta_remove		= wcn36xx_sta_remove,
 	.ampdu_action		= wcn36xx_ampdu_action,
+
+	CFG80211_TESTMODE_CMD(wcn36xx_tm_cmd)
 };
 
 static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 3048722f0484..b6f1e98395d0 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -292,12 +292,26 @@ static void init_hal_msg(struct wcn36xx_hal_msg_header *hdr,
 		msg_body.header.len = sizeof(msg_body);			\
 	} while (0)							\
 
+#define INIT_HAL_PTT_MSG(p_msg_body, ppt_msg_len) \
+	do { \
+		memset(p_msg_body, 0, sizeof(*p_msg_body) + ppt_msg_len); \
+		p_msg_body->header.msg_type = WCN36XX_HAL_PROCESS_PTT_REQ; \
+		p_msg_body->header.msg_version = WCN36XX_HAL_MSG_VERSION0; \
+		p_msg_body->header.len = sizeof(*p_msg_body) + ppt_msg_len; \
+	} while (0)
+
 #define PREPARE_HAL_BUF(send_buf, msg_body) \
 	do {							\
 		memset(send_buf, 0, msg_body.header.len);	\
 		memcpy(send_buf, &msg_body, sizeof(msg_body));	\
 	} while (0)						\
 
+#define PREPARE_HAL_PTT_MSG_BUF(send_buf, p_msg_body) \
+	do {							\
+		memset(send_buf, 0, p_msg_body->header.len); \
+		memcpy(send_buf, p_msg_body, p_msg_body->header.len); \
+	} while (0)
+
 static int wcn36xx_smd_rsp_status_check(void *buf, size_t len)
 {
 	struct wcn36xx_fw_msg_status_rsp *rsp;
@@ -742,6 +756,61 @@ int wcn36xx_smd_switch_channel(struct wcn36xx *wcn,
 	return ret;
 }
 
+static int wcn36xx_smd_process_ptt_msg_rsp(void *buf, size_t len,
+			void **p_ptt_rsp_msg)
+{
+	struct wcn36xx_hal_process_ptt_msg_rsp_msg *rsp;
+	int ret = 0;
+
+	ret = wcn36xx_smd_rsp_status_check(buf, len);
+	if (ret)
+		return ret;
+	rsp = (struct wcn36xx_hal_process_ptt_msg_rsp_msg *)buf;
+	wcn36xx_dbg(WCN36XX_DBG_HAL, "process ptt msg responded with length %d\n",
+			rsp->header.len);
+	wcn36xx_dbg_dump(WCN36XX_DBG_HAL_DUMP, "HAL_PTT_MSG_RSP:", rsp->ptt_msg,
+			rsp->header.len - sizeof(rsp->ptt_msg_resp_status));
+	if (rsp->header.len > 0) {
+		*p_ptt_rsp_msg = kmalloc(rsp->header.len, GFP_ATOMIC);
+		memcpy(*p_ptt_rsp_msg, rsp->ptt_msg, rsp->header.len);
+	}
+	return ret;
+}
+
+int wcn36xx_smd_process_ptt_msg(struct wcn36xx *wcn,
+		struct ieee80211_vif *vif, void *ptt_msg, size_t len,
+		void **ptt_rsp_msg)
+{
+	struct wcn36xx_hal_process_ptt_msg_req_msg *p_msg_body;
+	int ret = 0;
+
+	mutex_lock(&wcn->hal_mutex);
+	p_msg_body = kmalloc(
+		sizeof(struct wcn36xx_hal_process_ptt_msg_req_msg) + len,
+		GFP_ATOMIC);
+	INIT_HAL_PTT_MSG(p_msg_body, len);
+
+	memcpy(&p_msg_body->ptt_msg, ptt_msg, len);
+
+	PREPARE_HAL_PTT_MSG_BUF(wcn->hal_buf, p_msg_body);
+
+	ret = wcn36xx_smd_send_and_wait(wcn, p_msg_body->header.len);
+	if (ret) {
+		wcn36xx_err("Sending hal_process_ptt_msg failed\n");
+		goto out;
+	}
+	ret = wcn36xx_smd_process_ptt_msg_rsp(wcn->hal_buf, wcn->hal_rsp_len,
+			ptt_rsp_msg);
+	if (ret) {
+		wcn36xx_err("process_ptt_msg response failed err=%d\n", ret);
+		goto out;
+	}
+out:
+	kfree(p_msg_body);
+	mutex_unlock(&wcn->hal_mutex);
+	return ret;
+}
+
 static int wcn36xx_smd_update_scan_params_rsp(void *buf, size_t len)
 {
 	struct wcn36xx_hal_update_scan_params_resp *rsp;
@@ -2330,6 +2399,7 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
 	struct ieee80211_hw *hw = priv;
 	struct wcn36xx *wcn = hw->priv;
 	struct wcn36xx_hal_ind_msg *msg_ind;
+
 	wcn36xx_dbg_dump(WCN36XX_DBG_SMD_DUMP, "SMD <<< ", buf, len);
 
 	switch (msg_header->msg_type) {
@@ -2366,6 +2436,7 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
 	case WCN36XX_HAL_JOIN_RSP:
 	case WCN36XX_HAL_UPDATE_SCAN_PARAM_RSP:
 	case WCN36XX_HAL_CH_SWITCH_RSP:
+	case WCN36XX_HAL_PROCESS_PTT_RSP:
 	case WCN36XX_HAL_FEATURE_CAPS_EXCHANGE_RSP:
 	case WCN36XX_HAL_8023_MULTICAST_LIST_RSP:
 	case WCN36XX_HAL_START_SCAN_OFFLOAD_RSP:
@@ -2406,6 +2477,7 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
 
 	return 0;
 }
+
 static void wcn36xx_ind_smd_work(struct work_struct *work)
 {
 	struct wcn36xx *wcn =
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
index 8076edf40ac8..6d83cc99dc25 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.h
+++ b/drivers/net/wireless/ath/wcn36xx/smd.h
@@ -86,6 +86,10 @@ int wcn36xx_smd_send_beacon(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 			    u16 p2p_off);
 int wcn36xx_smd_switch_channel(struct wcn36xx *wcn,
 			       struct ieee80211_vif *vif, int ch);
+int wcn36xx_smd_process_ptt_msg(struct wcn36xx *wcn,
+			    struct ieee80211_vif *vif,
+				void *ptt_msg, size_t len,
+				void **ptt_rsp_msg);
 int wcn36xx_smd_update_proberesp_tmpl(struct wcn36xx *wcn,
 				      struct ieee80211_vif *vif,
 				      struct sk_buff *skb);
diff --git a/drivers/net/wireless/ath/wcn36xx/testmode.c b/drivers/net/wireless/ath/wcn36xx/testmode.c
new file mode 100644
index 000000000000..75807de09dfa
--- /dev/null
+++ b/drivers/net/wireless/ath/wcn36xx/testmode.c
@@ -0,0 +1,161 @@
+﻿/*
+ * Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <net/netlink.h>
+#include <linux/firmware.h>
+#include <net/cfg80211.h>
+#include "wcn36xx.h"
+
+#include "testmode.h"
+#include "testmode_i.h"
+#include "hal.h"
+#include "smd.h"
+
+static const struct nla_policy wcn36xx_tm_policy[WCN36XX_TM_ATTR_MAX + 1] = {
+	[WCN36XX_TM_ATTR_CMD] = { .type = NLA_U16 },
+	[WCN36XX_TM_ATTR_DATA] = { .type = NLA_BINARY,
+	.len = WCN36XX_TM_DATA_MAX_LEN },
+};
+
+struct build_release_number {
+	u16 drv_major;
+	u16 drv_minor;
+	u16 drv_patch;
+	u16 drv_build;
+	u16 ptt_max;
+	u16 ptt_min;
+	u16 fw_ver;
+} __packed;
+
+static int wcn36xx_tm_cmd_ptt(struct wcn36xx *wcn, struct ieee80211_vif *vif,
+				struct nlattr *tb[])
+{
+	int ret = 0, buf_len;
+	void *buf;
+	struct ftm_rsp_msg *msg, *rsp = NULL;
+	struct sk_buff *skb;
+
+	if (!tb[WCN36XX_TM_ATTR_DATA]) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	buf = nla_data(tb[WCN36XX_TM_ATTR_DATA]);
+	buf_len = nla_len(tb[WCN36XX_TM_ATTR_DATA]);
+	msg = (struct ftm_rsp_msg *)buf;
+
+	wcn36xx_dbg(WCN36XX_DBG_TESTMODE,
+		   "testmode cmd wmi msg_id 0x%04X msg_len %d buf %pK buf_len %d\n",
+		   msg->msg_id, msg->msg_body_length,
+		   buf, buf_len);
+
+	wcn36xx_dbg_dump(WCN36XX_DBG_TESTMODE_DUMP, "REQ ", buf, buf_len);
+
+	switch (msg->msg_id) {
+	case MSG_GET_BUILD_RELEASE_NUMBER: {
+		struct build_release_number *body =
+				(struct build_release_number *)
+				msg->msg_response;
+
+		body->drv_major = wcn->fw_major;
+		body->drv_minor = wcn->fw_minor;
+		body->drv_patch = wcn->fw_version;
+		body->drv_build = wcn->fw_revision;
+		body->ptt_max = 10;
+		body->ptt_min = 0;
+
+		rsp = msg;
+		rsp->resp_status = 0;
+		break;
+	}
+	default:
+		wcn36xx_dbg(WCN36XX_DBG_TESTMODE,
+				"PPT Request >> HAL size %d\n",
+				msg->msg_body_length);
+
+		msg->resp_status = wcn36xx_smd_process_ptt_msg(wcn, vif, msg,
+				msg->msg_body_length, (void *)(&rsp));
+
+		wcn36xx_dbg(WCN36XX_DBG_TESTMODE,
+				"Response status = %d\n",
+				msg->resp_status);
+		if (rsp)
+			wcn36xx_dbg(WCN36XX_DBG_TESTMODE,
+					"PPT Response << HAL size %d\n",
+					rsp->msg_body_length);
+		break;
+	}
+
+	if (!rsp) {
+		rsp = msg;
+		wcn36xx_warn("No response! Echoing request with response status %d\n",
+				rsp->resp_status);
+	}
+	wcn36xx_dbg_dump(WCN36XX_DBG_TESTMODE_DUMP, "RSP ",
+			rsp, rsp->msg_body_length);
+
+	skb = cfg80211_testmode_alloc_reply_skb(wcn->hw->wiphy,
+				nla_total_size(msg->msg_body_length));
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = nla_put(skb, WCN36XX_TM_ATTR_DATA, rsp->msg_body_length, rsp);
+	if (ret) {
+		kfree_skb(skb);
+		goto out;
+	}
+
+	ret = cfg80211_testmode_reply(skb);
+
+out:
+	if (rsp != msg)
+		kfree(rsp);
+
+	return ret;
+}
+
+int wcn36xx_tm_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  void *data, int len)
+{
+	struct wcn36xx *wcn = hw->priv;
+	struct nlattr *tb[WCN36XX_TM_ATTR_MAX + 1];
+	int ret = 0;
+	unsigned short attr;
+
+	wcn36xx_dbg_dump(WCN36XX_DBG_TESTMODE_DUMP, "Data:", data, len);
+	ret = nla_parse(tb, WCN36XX_TM_ATTR_MAX, data, len,
+			wcn36xx_tm_policy, NULL);
+	if (ret)
+		return ret;
+
+	if (!tb[WCN36XX_TM_ATTR_CMD])
+		return -EINVAL;
+
+	attr = nla_get_u16(tb[WCN36XX_TM_ATTR_CMD]);
+
+	switch (attr) {
+	case WCN36XX_TM_CMD_START:
+	case WCN36XX_TM_CMD_STOP:
+		// N/A to this driver as it does not need to switch state
+		break;
+	case WCN36XX_TM_CMD_PTT:
+		ret = wcn36xx_tm_cmd_ptt(wcn, vif, tb);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
diff --git a/drivers/net/wireless/ath/wcn36xx/testmode.h b/drivers/net/wireless/ath/wcn36xx/testmode.h
new file mode 100644
index 000000000000..4b571b82b47f
--- /dev/null
+++ b/drivers/net/wireless/ath/wcn36xx/testmode.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "wcn36xx.h"
+
+struct ftm_rsp_msg {
+	u16 msg_id;
+	u16 msg_body_length;
+	u32 resp_status;
+	u8 msg_response[0];
+} __packed;
+
+/* The request buffer of FTM which contains a byte of command and the request */
+struct ftm_payload {
+	u16 ftm_cmd_type;
+	struct ftm_rsp_msg ftm_cmd_msg;
+} __packed;
+
+#define MSG_GET_BUILD_RELEASE_NUMBER 0x32A2
+
+#ifdef CONFIG_NL80211_TESTMODE
+int wcn36xx_tm_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+					void *data, int len);
+
+#else
+static inline int wcn36xx_tm_cmd(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				void *data, int len)
+{
+	return 0;
+}
+
+#endif
diff --git a/drivers/net/wireless/ath/wcn36xx/testmode_i.h b/drivers/net/wireless/ath/wcn36xx/testmode_i.h
new file mode 100644
index 000000000000..bbfc3366c82d
--- /dev/null
+++ b/drivers/net/wireless/ath/wcn36xx/testmode_i.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define WCN36XX_TM_DATA_MAX_LEN		5000
+
+enum wcn36xx_tm_attr {
+	__WCN36XX_TM_ATTR_INVALID	= 0,
+	WCN36XX_TM_ATTR_CMD		= 1,
+	WCN36XX_TM_ATTR_DATA		= 2,
+
+	/* keep last */
+	__WCN36XX_TM_ATTR_AFTER_LAST,
+	WCN36XX_TM_ATTR_MAX		= __WCN36XX_TM_ATTR_AFTER_LAST - 1,
+};
+
+/* All wcn36xx testmode interface commands specified in
+ * WCN36XX_TM_ATTR_CMD
+ */
+enum wcn36xx_tm_cmd {
+	/* For backwards compatibility
+	 */
+	WCN36XX_TM_CMD_START = 1,
+
+	/* For backwards compatibility
+	 */
+	WCN36XX_TM_CMD_STOP = 2,
+
+	/* The command used to transmit a PTT command to the firmware.
+	 * Command payload is provided in WCN36XX_TM_ATTR_DATA.
+	 */
+	WCN36XX_TM_CMD_PTT = 3,
+};
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 81017e6703b4..6a6c49835a13 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -56,6 +56,8 @@ enum wcn36xx_debug_mask {
 	WCN36XX_DBG_BEACON_DUMP	= 0x00001000,
 	WCN36XX_DBG_PMC		= 0x00002000,
 	WCN36XX_DBG_PMC_DUMP	= 0x00004000,
+	WCN36XX_DBG_TESTMODE		= 0x00008000,
+	WCN36XX_DBG_TESTMODE_DUMP	= 0x00010000,
 	WCN36XX_DBG_ANY		= 0xffffffff,
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
