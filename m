Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:54981 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbeDYCIr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 22:08:47 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 18/19] rtlwifi: halmac: add to support BB and RF functions
Date: Wed, 25 Apr 2018 10:08:19 +0800
Message-ID: <20180425020820.6141-19-pkshih@realtek.com> (sfid-20180425_040907_572317_A7AD7C55)
In-Reply-To: <20180425020820.6141-1-pkshih@realtek.com>
References: <20180425020820.6141-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Some BB and RF functions collaborate with firmware or MAC. For instances,
the IQK and PSD functions are implemented in firmware, so use a H2C command
to trigger. For MIMO function, use the helper functions to control related
MAC registers.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.c | 397 ++++++++++
 .../rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.h |  53 ++
 .../rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.c  | 869 +++++++++++++++++++++
 .../rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.h  |  79 ++
 4 files changed, 1398 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.c
new file mode 100644
index 000000000000..06990ee78ebd
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.c
@@ -0,0 +1,397 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#include "halmac_bb_rf_88xx.h"
+#include "halmac_88xx_cfg.h"
+#include "halmac_common_88xx.h"
+#include "halmac_init_88xx.h"
+
+/**
+ * start_iqk_88xx() -trigger FW IQK
+ * @adapter : the adapter of halmac
+ * @param : IQK parameter
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+start_iqk_88xx(struct halmac_adapter *adapter, struct halmac_iqk_para *param)
+{
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = { 0 };
+	u16 seq_num = 0;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	struct halmac_h2c_header_info hdr_info;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.iqk_state.proc_status;
+
+	if (halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "Wait event(iqk)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	*proc_status = HALMAC_CMD_PROCESS_SENDING;
+
+	IQK_SET_CLEAR(h2c_buf, param->clear);
+	IQK_SET_SEGMENT_IQK(h2c_buf, param->segment_iqk);
+
+	hdr_info.sub_cmd_id = SUB_CMD_ID_IQK;
+	hdr_info.content_size = 1;
+	hdr_info.ack = 1;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+
+	adapter->halmac_state.iqk_state.seq_num = seq_num;
+
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("send h2c pkt fail!!\n");
+		reset_ofld_feature_88xx(adapter, HALMAC_FEATURE_IQK);
+		return status;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * ctrl_pwr_tracking_88xx() -trigger FW power tracking
+ * @adapter : the adapter of halmac
+ * @opt : power tracking option
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+ctrl_pwr_tracking_88xx(struct halmac_adapter *adapter,
+		       struct halmac_pwr_tracking_option *opt)
+{
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = { 0 };
+	u16 seq_num = 0;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	struct halmac_h2c_header_info hdr_info;
+	struct halmac_pwr_tracking_para *param;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.pwr_trk_state.proc_status;
+
+	if (halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "Wait event(pwr tracking)...\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	*proc_status = HALMAC_CMD_PROCESS_SENDING;
+
+	PWR_TRK_SET_TYPE(h2c_buf, opt->type);
+	PWR_TRK_SET_BBSWING_INDEX(h2c_buf, opt->bbswing_index);
+
+	param = &opt->pwr_tracking_para[HALMAC_RF_PATH_A];
+	PWR_TRK_SET_ENABLE_A(h2c_buf, param->enable);
+	PWR_TRK_SET_TX_PWR_INDEX_A(h2c_buf, param->tx_pwr_index);
+	PWR_TRK_SET_TSSI_VALUE_A(h2c_buf, param->tssi_value);
+	PWR_TRK_SET_OFFSET_VALUE_A(h2c_buf, param->pwr_tracking_offset_value);
+
+	param = &opt->pwr_tracking_para[HALMAC_RF_PATH_B];
+	PWR_TRK_SET_ENABLE_B(h2c_buf, param->enable);
+	PWR_TRK_SET_TX_PWR_INDEX_B(h2c_buf, param->tx_pwr_index);
+	PWR_TRK_SET_TSSI_VALUE_B(h2c_buf, param->tssi_value);
+	PWR_TRK_SET_OFFSET_VALUE_B(h2c_buf, param->pwr_tracking_offset_value);
+
+	param = &opt->pwr_tracking_para[HALMAC_RF_PATH_C];
+	PWR_TRK_SET_ENABLE_C(h2c_buf, param->enable);
+	PWR_TRK_SET_TX_PWR_INDEX_C(h2c_buf, param->tx_pwr_index);
+	PWR_TRK_SET_TSSI_VALUE_C(h2c_buf, param->tssi_value);
+	PWR_TRK_SET_OFFSET_VALUE_C(h2c_buf, param->pwr_tracking_offset_value);
+
+	param = &opt->pwr_tracking_para[HALMAC_RF_PATH_D];
+	PWR_TRK_SET_ENABLE_D(h2c_buf, param->enable);
+	PWR_TRK_SET_TX_PWR_INDEX_D(h2c_buf, param->tx_pwr_index);
+	PWR_TRK_SET_TSSI_VALUE_D(h2c_buf, param->tssi_value);
+	PWR_TRK_SET_OFFSET_VALUE_D(h2c_buf, param->pwr_tracking_offset_value);
+
+	hdr_info.sub_cmd_id = SUB_CMD_ID_PWR_TRK;
+	hdr_info.content_size = 20;
+	hdr_info.ack = 1;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+
+	adapter->halmac_state.pwr_trk_state.seq_num = seq_num;
+
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("send h2c pkt fail!!\n");
+		reset_ofld_feature_88xx(adapter, HALMAC_FEATURE_POWER_TRACKING);
+		return status;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+get_iqk_status_88xx(struct halmac_adapter *adapter,
+		    enum halmac_cmd_process_status *proc_status)
+{
+	*proc_status = adapter->halmac_state.iqk_state.proc_status;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+get_pwr_trk_status_88xx(struct halmac_adapter *adapter,
+			enum halmac_cmd_process_status *proc_status)
+{
+	*proc_status = adapter->halmac_state.pwr_trk_state.proc_status;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+get_psd_status_88xx(struct halmac_adapter *adapter,
+		    enum halmac_cmd_process_status *proc_status, u8 *data,
+		    u32 *size)
+{
+	struct halmac_psd_state *state = &adapter->halmac_state.psd_state;
+
+	*proc_status = state->proc_status;
+
+	if (!data)
+		return HALMAC_RET_NULL_POINTER;
+
+	if (!size)
+		return HALMAC_RET_NULL_POINTER;
+
+	if (*proc_status == HALMAC_CMD_PROCESS_DONE) {
+		if (*size < state->data_size) {
+			*size = state->data_size;
+			return HALMAC_RET_BUFFER_TOO_SMALL;
+		}
+
+		*size = state->data_size;
+		memcpy(data, state->data, *size);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * psd_88xx() - trigger fw psd
+ * @adapter : the adapter of halmac
+ * @start_psd : start PSD
+ * @end_psd : end PSD
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+psd_88xx(struct halmac_adapter *adapter, u16 start_psd, u16 end_psd)
+{
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = { 0 };
+	u16 seq_num = 0;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	struct halmac_h2c_header_info hdr_info;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.psd_state.proc_status;
+
+	if (halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "Wait event(psd)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	kfree(adapter->halmac_state.psd_state.data);
+	adapter->halmac_state.psd_state.data = (u8 *)NULL;
+
+	adapter->halmac_state.psd_state.data_size = 0;
+	adapter->halmac_state.psd_state.seg_size = 0;
+
+	*proc_status = HALMAC_CMD_PROCESS_SENDING;
+
+	PSD_SET_START_PSD(h2c_buf, start_psd);
+	PSD_SET_END_PSD(h2c_buf, end_psd);
+
+	hdr_info.sub_cmd_id = SUB_CMD_ID_PSD;
+	hdr_info.content_size = 4;
+	hdr_info.ack = 1;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("send h2c pkt fail!!\n");
+		reset_ofld_feature_88xx(adapter, HALMAC_FEATURE_PSD);
+		return status;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+get_h2c_ack_iqk_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u8 seq_num;
+	u8 fw_rc;
+	struct halmac_iqk_state *state = &adapter->halmac_state.iqk_state;
+	enum halmac_cmd_process_status proc_status;
+
+	seq_num = (u8)H2C_ACK_HDR_GET_H2C_SEQ(buf);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "Seq num : h2c->%d c2h->%d\n", state->seq_num, seq_num);
+	if (seq_num != state->seq_num) {
+		pr_err("Seq num mismatch : h2c->%d c2h->%d\n", state->seq_num,
+		       seq_num);
+		return HALMAC_RET_SUCCESS;
+	}
+
+	if (state->proc_status != HALMAC_CMD_PROCESS_SENDING) {
+		pr_err("not cmd sending\n");
+		return HALMAC_RET_SUCCESS;
+	}
+
+	fw_rc = (u8)H2C_ACK_HDR_GET_H2C_RETURN_CODE(buf);
+	state->fw_rc = fw_rc;
+
+	if ((enum halmac_h2c_return_code)fw_rc == HALMAC_H2C_RETURN_SUCCESS) {
+		proc_status = HALMAC_CMD_PROCESS_DONE;
+		state->proc_status = proc_status;
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_IQK, proc_status, NULL, 0);
+	} else {
+		proc_status = HALMAC_CMD_PROCESS_ERROR;
+		state->proc_status = proc_status;
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_IQK, proc_status, &fw_rc, 1);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+get_h2c_ack_pwr_trk_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u8 seq_num;
+	u8 fw_rc;
+	struct halmac_pwr_tracking_state *state;
+	enum halmac_cmd_process_status proc_status;
+
+	state = &adapter->halmac_state.pwr_trk_state;
+
+	seq_num = (u8)H2C_ACK_HDR_GET_H2C_SEQ(buf);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "Seq num : h2c->%d c2h->%d\n", state->seq_num, seq_num);
+	if (seq_num != state->seq_num) {
+		pr_err("Seq num mismatch : h2c->%d c2h->%d\n", state->seq_num,
+		       seq_num);
+		return HALMAC_RET_SUCCESS;
+	}
+
+	if (state->proc_status != HALMAC_CMD_PROCESS_SENDING) {
+		pr_err("not cmd sending\n");
+		return HALMAC_RET_SUCCESS;
+	}
+
+	fw_rc = (u8)H2C_ACK_HDR_GET_H2C_RETURN_CODE(buf);
+	state->fw_rc = fw_rc;
+
+	if ((enum halmac_h2c_return_code)fw_rc == HALMAC_H2C_RETURN_SUCCESS) {
+		proc_status = HALMAC_CMD_PROCESS_DONE;
+		state->proc_status = proc_status;
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_POWER_TRACKING, proc_status,
+				NULL, 0);
+	} else {
+		proc_status = HALMAC_CMD_PROCESS_ERROR;
+		state->proc_status = proc_status;
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_POWER_TRACKING, proc_status,
+				&fw_rc, 1);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+get_psd_data_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u8 seg_id;
+	u8 seg_size;
+	u8 seq_num;
+	u16 total_size;
+	enum halmac_cmd_process_status proc_status;
+	struct halmac_psd_state *state = &adapter->halmac_state.psd_state;
+
+	seq_num = (u8)PSD_DATA_GET_H2C_SEQ(buf);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "seq num : h2c->%d c2h->%d\n", state->seq_num, seq_num);
+	if (seq_num != state->seq_num) {
+		pr_err("seq num mismatch : h2c->%d c2h->%d\n", state->seq_num,
+		       seq_num);
+		return HALMAC_RET_SUCCESS;
+	}
+
+	if (state->proc_status != HALMAC_CMD_PROCESS_SENDING) {
+		pr_err("not cmd sending\n");
+		return HALMAC_RET_SUCCESS;
+	}
+
+	total_size = (u16)PSD_DATA_GET_TOTAL_SIZE(buf);
+	seg_id = (u8)PSD_DATA_GET_SEGMENT_ID(buf);
+	seg_size = (u8)PSD_DATA_GET_SEGMENT_SIZE(buf);
+	state->data_size = total_size;
+
+	if (!state->data)
+		state->data = kzalloc(state->data_size, GFP_KERNEL);
+
+	if (seg_id == 0)
+		state->seg_size = seg_size;
+
+	memcpy(state->data + seg_id * state->seg_size,
+	       buf + C2H_DATA_OFFSET_88XX, seg_size);
+
+	if (PSD_DATA_GET_END_SEGMENT(buf) == 0)
+		return HALMAC_RET_SUCCESS;
+
+	proc_status = HALMAC_CMD_PROCESS_DONE;
+	state->proc_status = proc_status;
+
+	PLTFM_EVENT_SIG(HALMAC_FEATURE_PSD, proc_status, state->data,
+			state->data_size);
+
+	return HALMAC_RET_SUCCESS;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.h
new file mode 100644
index 000000000000..4c9dbada56d7
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_bb_rf_88xx.h
@@ -0,0 +1,53 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef _HALMAC_BB_RF_88XX_H_
+#define _HALMAC_BB_RF_88XX_H_
+
+#include "../halmac_api.h"
+
+enum halmac_ret_status
+start_iqk_88xx(struct halmac_adapter *adapter, struct halmac_iqk_para *param);
+
+enum halmac_ret_status
+ctrl_pwr_tracking_88xx(struct halmac_adapter *adapter,
+		       struct halmac_pwr_tracking_option *opt);
+
+enum halmac_ret_status
+get_iqk_status_88xx(struct halmac_adapter *adapter,
+		    enum halmac_cmd_process_status *proc_status);
+
+enum halmac_ret_status
+get_pwr_trk_status_88xx(struct halmac_adapter *adapter,
+			enum halmac_cmd_process_status *proc_status);
+
+enum halmac_ret_status
+get_psd_status_88xx(struct halmac_adapter *adapter,
+		    enum halmac_cmd_process_status *proc_status, u8 *data,
+		    u32 *size);
+
+enum halmac_ret_status
+psd_88xx(struct halmac_adapter *adapter, u16 start_psd, u16 end_psd);
+
+enum halmac_ret_status
+get_h2c_ack_iqk_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+enum halmac_ret_status
+get_h2c_ack_pwr_trk_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+enum halmac_ret_status
+get_psd_data_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+#endif/* _HALMAC_BB_RF_88XX_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.c
new file mode 100644
index 000000000000..4482be6b45f1
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.c
@@ -0,0 +1,869 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#include "halmac_mimo_88xx.h"
+#include "halmac_88xx_cfg.h"
+#include "halmac_common_88xx.h"
+#include "halmac_init_88xx.h"
+
+#define TXBF_CTRL_CFG	(BIT_R_ENABLE_NDPA | BIT_USE_NDPA_PARAMETER | \
+			 BIT_R_EN_NDPA_INT | BIT_DIS_NDP_BFEN)
+
+static void
+cfg_mu_bfee_88xx(struct halmac_adapter *adapter,
+		 struct halmac_cfg_mumimo_para *param);
+
+static void
+cfg_mu_bfer_88xx(struct halmac_adapter *adapter,
+		 struct halmac_cfg_mumimo_para *param);
+
+static enum halmac_cmd_construct_state
+fw_snding_cmd_cnstr_state_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+cnv_fw_snding_state_88xx(struct halmac_adapter *adapter,
+			 enum halmac_cmd_construct_state dest_state);
+
+static u8
+snding_pkt_chk_88xx(struct halmac_adapter *adapter, u8 *pkt);
+
+/**
+ * cfg_txbf_88xx() - enable/disable specific user's txbf
+ * @adapter : the adapter of halmac
+ * @userid : su bfee userid = 0 or 1 to apply TXBF
+ * @bw : the sounding bandwidth
+ * @txbf_en : 0: disable TXBF, 1: enable TXBF
+ * Author : chunchu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_txbf_88xx(struct halmac_adapter *adapter, u8 userid, enum halmac_bw bw,
+	      u8 txbf_en)
+{
+	u16 tmp42c = 0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (txbf_en) {
+		switch (bw) {
+		case HALMAC_BW_80:
+			tmp42c |= BIT_R_TXBF0_80M;
+		case HALMAC_BW_40:
+			tmp42c |= BIT_R_TXBF0_40M;
+		case HALMAC_BW_20:
+			tmp42c |= BIT_R_TXBF0_20M;
+			break;
+		default:
+			return HALMAC_RET_INVALID_SOUNDING_SETTING;
+		}
+	}
+
+	switch (userid) {
+	case 0:
+		tmp42c |= HALMAC_REG_R16(REG_TXBF_CTRL) &
+			~(BIT_R_TXBF0_20M | BIT_R_TXBF0_40M | BIT_R_TXBF0_80M);
+		HALMAC_REG_W16(REG_TXBF_CTRL, tmp42c);
+		break;
+	case 1:
+		tmp42c |= HALMAC_REG_R16(REG_TXBF_CTRL + 2) &
+			~(BIT_R_TXBF0_20M | BIT_R_TXBF0_40M | BIT_R_TXBF0_80M);
+		HALMAC_REG_W16(REG_TXBF_CTRL + 2, tmp42c);
+		break;
+	default:
+		return HALMAC_RET_INVALID_SOUNDING_SETTING;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_mumimo_88xx() -config mumimo
+ * @adapter : the adapter of halmac
+ * @param : parameters to configure MU PPDU Tx/Rx
+ * Author : chunchu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_mumimo_88xx(struct halmac_adapter *adapter,
+		struct halmac_cfg_mumimo_para *param)
+{
+	if (param->role == HAL_BFEE)
+		cfg_mu_bfee_88xx(adapter, param);
+	else
+		cfg_mu_bfer_88xx(adapter, param);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static void
+cfg_mu_bfee_88xx(struct halmac_adapter *adapter,
+		 struct halmac_cfg_mumimo_para *param)
+{
+	u8 mu_tbl_sel;
+	u8 tmp14c0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	tmp14c0 = HALMAC_REG_R8(REG_MU_TX_CTL) & ~BIT_MASK_R_MU_TABLE_VALID;
+	HALMAC_REG_W8(REG_MU_TX_CTL, (tmp14c0 | BIT(0) | BIT(1)) & ~(BIT(7)));
+
+	/*config GID valid table and user position table*/
+	mu_tbl_sel = HALMAC_REG_R8(REG_MU_TX_CTL + 1) & 0xF8;
+
+	HALMAC_REG_W8(REG_MU_TX_CTL + 1, mu_tbl_sel);
+	HALMAC_REG_W32(REG_MU_STA_GID_VLD, param->given_gid_tab[0]);
+	HALMAC_REG_W32(REG_MU_STA_USER_POS_INFO, param->given_user_pos[0]);
+	HALMAC_REG_W32(REG_MU_STA_USER_POS_INFO + 4, param->given_user_pos[1]);
+
+	HALMAC_REG_W8(REG_MU_TX_CTL + 1, mu_tbl_sel | 1);
+	HALMAC_REG_W32(REG_MU_STA_GID_VLD, param->given_gid_tab[1]);
+	HALMAC_REG_W32(REG_MU_STA_USER_POS_INFO, param->given_user_pos[2]);
+	HALMAC_REG_W32(REG_MU_STA_USER_POS_INFO + 4, param->given_user_pos[3]);
+}
+
+static void
+cfg_mu_bfer_88xx(struct halmac_adapter *adapter,
+		 struct halmac_cfg_mumimo_para *param)
+{
+	u8 i;
+	u8 idx;
+	u8 id0;
+	u8 id1;
+	u8 gid;
+	u8 mu_tbl_sel;
+	u8 mu_tbl_valid = 0;
+	u32 gid_valid[6] = {0};
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (param->mu_tx_en == 0) {
+		HALMAC_REG_W8(REG_MU_TX_CTL,
+			      HALMAC_REG_R8(REG_MU_TX_CTL) & ~(BIT(7)));
+		return;
+	}
+
+	for (idx = 0; idx < 15; idx++) {
+		if (idx < 5) {
+			/*grouping_bitmap bit0~4, MU_STA0 with MUSTA1~5*/
+			id0 = 0;
+			id1 = (u8)(idx + 1);
+		} else if (idx < 9) {
+			/*grouping_bitmap bit5~8, MU_STA1 with MUSTA2~5*/
+			id0 = 1;
+			id1 = (u8)(idx - 3);
+		} else if (idx < 12) {
+			/*grouping_bitmap bit9~11, MU_STA2 with MUSTA3~5*/
+			id0 = 2;
+			id1 = (u8)(idx - 6);
+		} else if (idx < 14) {
+			/*grouping_bitmap bit12~13, MU_STA3 with MUSTA4~5*/
+			id0 = 3;
+			id1 = (u8)(idx - 8);
+		} else {
+			/*grouping_bitmap bit14, MU_STA4 with MUSTA5*/
+			id0 = 4;
+			id1 = (u8)(idx - 9);
+		}
+		if (param->grouping_bitmap & BIT(idx)) {
+			/*Pair 1*/
+			gid = (idx << 1) + 1;
+			gid_valid[id0] |= (BIT(gid));
+			gid_valid[id1] |= (BIT(gid));
+			/*Pair 2*/
+			gid += 1;
+			gid_valid[id0] |= (BIT(gid));
+			gid_valid[id1] |= (BIT(gid));
+		} else {
+			/*Pair 1*/
+			gid = (idx << 1) + 1;
+			gid_valid[id0] &= ~(BIT(gid));
+			gid_valid[id1] &= ~(BIT(gid));
+			/*Pair 2*/
+			gid += 1;
+			gid_valid[id0] &= ~(BIT(gid));
+			gid_valid[id1] &= ~(BIT(gid));
+		}
+	}
+
+	/*set MU STA GID valid TABLE*/
+	mu_tbl_sel = HALMAC_REG_R8(REG_MU_TX_CTL + 1) & 0xF8;
+	for (idx = 0; idx < 6; idx++) {
+		HALMAC_REG_W8(REG_MU_TX_CTL + 1, idx | mu_tbl_sel);
+		HALMAC_REG_W32(REG_MU_STA_GID_VLD, gid_valid[idx]);
+	}
+
+	/*To validate the sounding successful MU STA and enable MU TX*/
+	for (i = 0; i < 6; i++) {
+		if (param->sounding_sts[i] == 1)
+			mu_tbl_valid |= BIT(i);
+	}
+	HALMAC_REG_W8(REG_MU_TX_CTL, mu_tbl_valid | BIT(7));
+}
+
+/**
+ * cfg_sounding_88xx() - configure general sounding
+ * @adapter : the adapter of halmac
+ * @role : driver's role, BFer or BFee
+ * @rate : set ndpa tx rate if driver is BFer,
+ * or set csi response rate if driver is BFee
+ * Author : chunchu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_sounding_88xx(struct halmac_adapter *adapter, enum halmac_snd_role role,
+		  enum halmac_data_rate rate)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	u32 tmp6dc = 0;
+	u8 csi_rsc = 0x1;
+
+	/*use ndpa rx rate to decide csi rate*/
+	tmp6dc = HALMAC_REG_R32(REG_BBPSF_CTRL) | BIT_WMAC_USE_NDPARATE
+							| (csi_rsc << 13);
+
+	switch (role) {
+	case HAL_BFER:
+		HALMAC_REG_W32_SET(REG_TXBF_CTRL, TXBF_CTRL_CFG);
+		HALMAC_REG_W8(REG_NDPA_RATE, rate);
+		HALMAC_REG_W8_CLR(REG_NDPA_OPT_CTRL, BIT(0) | BIT(1));
+		HALMAC_REG_W8(REG_SND_PTCL_CTRL + 1, 0x2 | BIT(7));
+		HALMAC_REG_W8(REG_SND_PTCL_CTRL + 2, 0x2);
+		break;
+	case HAL_BFEE:
+		HALMAC_REG_W8(REG_SND_PTCL_CTRL, 0xDB);
+		HALMAC_REG_W8(REG_SND_PTCL_CTRL + 3, 0x26);
+		HALMAC_REG_W8_CLR(REG_RXFLTMAP1, BIT(4));
+		HALMAC_REG_W8_CLR(REG_RXFLTMAP4, BIT(4));
+		break;
+	default:
+		return HALMAC_RET_INVALID_SOUNDING_SETTING;
+	}
+
+	/*AP mode set tx gid to 63*/
+	/*STA mode set tx gid to 0*/
+	if (BIT_GET_NETYPE0(HALMAC_REG_R32(REG_CR)) == 0x3)
+		HALMAC_REG_W32(REG_BBPSF_CTRL, tmp6dc | BIT(12));
+	else
+		HALMAC_REG_W32(REG_BBPSF_CTRL, tmp6dc & ~(BIT(12)));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * del_sounding_88xx() - reset general sounding
+ * @adapter : the adapter of halmac
+ * @role : driver's role, BFer or BFee
+ * Author : chunchu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+del_sounding_88xx(struct halmac_adapter *adapter, enum halmac_snd_role role)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	switch (role) {
+	case HAL_BFER:
+		HALMAC_REG_W8(REG_TXBF_CTRL + 3, 0);
+		break;
+	case HAL_BFEE:
+		HALMAC_REG_W8(REG_SND_PTCL_CTRL, 0);
+		break;
+	default:
+		return HALMAC_RET_INVALID_SOUNDING_SETTING;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * su_bfee_entry_init_88xx() - config SU beamformee's registers
+ * @adapter : the adapter of halmac
+ * @userid : SU bfee userid = 0 or 1 to be added
+ * @paid : partial AID of this bfee
+ * Author : chunchu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+su_bfee_entry_init_88xx(struct halmac_adapter *adapter, u8 userid, u16 paid)
+{
+	u16 tmp42c = 0;
+	u16 tmp168x = 0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	switch (userid) {
+	case 0:
+		tmp42c = HALMAC_REG_R16(REG_TXBF_CTRL) &
+				~(BIT_MASK_R_TXBF0_AID | BIT_R_TXBF0_20M |
+				BIT_R_TXBF0_40M | BIT_R_TXBF0_80M);
+		HALMAC_REG_W16(REG_TXBF_CTRL, tmp42c | paid);
+		HALMAC_REG_W16(REG_ASSOCIATED_BFMEE_SEL, paid);
+		break;
+	case 1:
+		tmp42c = HALMAC_REG_R16(REG_TXBF_CTRL + 2) &
+				~(BIT_MASK_R_TXBF1_AID | BIT_R_TXBF0_20M |
+				BIT_R_TXBF0_40M | BIT_R_TXBF0_80M);
+		HALMAC_REG_W16(REG_TXBF_CTRL + 2, tmp42c | paid);
+		HALMAC_REG_W16(REG_ASSOCIATED_BFMEE_SEL + 2, paid | BIT(9));
+		break;
+	case 2:
+		tmp168x = HALMAC_REG_R16(REG_WMAC_ASSOCIATED_MU_BFMEE2);
+		tmp168x = BIT_CLEAR_WMAC_MU_BFEE2_AID(tmp168x);
+		tmp168x |= (paid | BIT(9));
+		HALMAC_REG_W16(REG_WMAC_ASSOCIATED_MU_BFMEE2, tmp168x);
+		break;
+	case 3:
+		tmp168x = HALMAC_REG_R16(REG_WMAC_ASSOCIATED_MU_BFMEE3);
+		tmp168x = BIT_CLEAR_WMAC_MU_BFEE3_AID(tmp168x);
+		tmp168x |= (paid | BIT(9));
+		HALMAC_REG_W16(REG_WMAC_ASSOCIATED_MU_BFMEE3, tmp168x);
+		break;
+	case 4:
+		tmp168x = HALMAC_REG_R16(REG_WMAC_ASSOCIATED_MU_BFMEE4);
+		tmp168x = BIT_CLEAR_WMAC_MU_BFEE4_AID(tmp168x);
+		tmp168x |= (paid | BIT(9));
+		HALMAC_REG_W16(REG_WMAC_ASSOCIATED_MU_BFMEE4, tmp168x);
+		break;
+	case 5:
+		tmp168x = HALMAC_REG_R16(REG_WMAC_ASSOCIATED_MU_BFMEE5);
+		tmp168x = BIT_CLEAR_WMAC_MU_BFEE5_AID(tmp168x);
+		tmp168x |= (paid | BIT(9));
+		HALMAC_REG_W16(REG_WMAC_ASSOCIATED_MU_BFMEE5, tmp168x);
+		break;
+	default:
+		return HALMAC_RET_INVALID_SOUNDING_SETTING;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * su_bfee_entry_init_88xx() - config SU beamformer's registers
+ * @adapter : the adapter of halmac
+ * @param : parameters to configure SU BFER entry
+ * Author : chunchu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+su_bfer_entry_init_88xx(struct halmac_adapter *adapter,
+			struct halmac_su_bfer_init_para *param)
+{
+	u16 mac_addr_h;
+	u32 mac_addr_l;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	mac_addr_l = le32_to_cpu(param->bfer_address.addr_l_h.low);
+	mac_addr_h = le16_to_cpu(param->bfer_address.addr_l_h.high);
+
+	switch (param->userid) {
+	case 0:
+		HALMAC_REG_W32(REG_ASSOCIATED_BFMER0_INFO, mac_addr_l);
+		HALMAC_REG_W16(REG_ASSOCIATED_BFMER0_INFO + 4, mac_addr_h);
+		HALMAC_REG_W16(REG_ASSOCIATED_BFMER0_INFO + 6, param->paid);
+		HALMAC_REG_W16(REG_TX_CSI_RPT_PARAM_BW20, param->csi_para);
+		break;
+	case 1:
+		HALMAC_REG_W32(REG_ASSOCIATED_BFMER1_INFO, mac_addr_l);
+		HALMAC_REG_W16(REG_ASSOCIATED_BFMER1_INFO + 4, mac_addr_h);
+		HALMAC_REG_W16(REG_ASSOCIATED_BFMER1_INFO + 6, param->paid);
+		HALMAC_REG_W16(REG_TX_CSI_RPT_PARAM_BW20 + 2, param->csi_para);
+		break;
+	default:
+		return HALMAC_RET_INVALID_SOUNDING_SETTING;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * mu_bfee_entry_init_88xx() - config MU beamformee's registers
+ * @adapter : the adapter of halmac
+ * @param : parameters to configure MU BFEE entry
+ * Author : chunchu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+mu_bfee_entry_init_88xx(struct halmac_adapter *adapter,
+			struct halmac_mu_bfee_init_para *param)
+{
+	u16 tmp168x = 0;
+	u16 tmp14c0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	tmp168x |= param->paid | BIT(9);
+	HALMAC_REG_W16((0x1680 + param->userid * 2), tmp168x);
+
+	tmp14c0 = HALMAC_REG_R16(REG_MU_TX_CTL) & ~(BIT(8) | BIT(9) | BIT(10));
+	HALMAC_REG_W16(REG_MU_TX_CTL, tmp14c0 | ((param->userid - 2) << 8));
+	HALMAC_REG_W32(REG_MU_STA_GID_VLD, 0);
+	HALMAC_REG_W32(REG_MU_STA_USER_POS_INFO, param->user_position_l);
+	HALMAC_REG_W32(REG_MU_STA_USER_POS_INFO + 4, param->user_position_h);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * mu_bfer_entry_init_88xx() - config MU beamformer's registers
+ * @adapter : the adapter of halmac
+ * @param : parameters to configure MU BFER entry
+ * Author : chunchu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+mu_bfer_entry_init_88xx(struct halmac_adapter *adapter,
+			struct halmac_mu_bfer_init_para *param)
+{
+	u16 tmp1680 = 0;
+	u16 mac_addr_h;
+	u32 mac_addr_l;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	mac_addr_l = le32_to_cpu(param->bfer_address.addr_l_h.low);
+	mac_addr_h = le16_to_cpu(param->bfer_address.addr_l_h.high);
+
+	HALMAC_REG_W32(REG_ASSOCIATED_BFMER0_INFO, mac_addr_l);
+	HALMAC_REG_W16(REG_ASSOCIATED_BFMER0_INFO + 4, mac_addr_h);
+	HALMAC_REG_W16(REG_ASSOCIATED_BFMER0_INFO + 6, param->paid);
+	HALMAC_REG_W16(REG_TX_CSI_RPT_PARAM_BW20, param->csi_para);
+
+	tmp1680 = HALMAC_REG_R16(0x1680) & 0xC000;
+	tmp1680 |= param->my_aid | (param->csi_length_sel << 12);
+	HALMAC_REG_W16(0x1680, tmp1680);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * su_bfee_entry_del_88xx() - reset SU beamformee's registers
+ * @adapter : the adapter of halmac
+ * @userid : the SU BFee userid to be deleted
+ * Author : chunchu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+su_bfee_entry_del_88xx(struct halmac_adapter *adapter, u8 userid)
+{
+	u16 value16;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	switch (userid) {
+	case 0:
+		value16 = HALMAC_REG_R16(REG_TXBF_CTRL);
+		value16 &= ~(BIT_MASK_R_TXBF0_AID | BIT_R_TXBF0_20M |
+					BIT_R_TXBF0_40M | BIT_R_TXBF0_80M);
+		HALMAC_REG_W16(REG_TXBF_CTRL, value16);
+		HALMAC_REG_W16(REG_ASSOCIATED_BFMEE_SEL, 0);
+		break;
+	case 1:
+		value16 = HALMAC_REG_R16(REG_TXBF_CTRL + 2);
+		value16 &= ~(BIT_MASK_R_TXBF1_AID | BIT_R_TXBF0_20M |
+					BIT_R_TXBF0_40M | BIT_R_TXBF0_80M);
+		HALMAC_REG_W16(REG_TXBF_CTRL + 2, value16);
+		HALMAC_REG_W16(REG_ASSOCIATED_BFMEE_SEL + 2, 0);
+		break;
+	case 2:
+		HALMAC_REG_W16(REG_WMAC_ASSOCIATED_MU_BFMEE2, 0);
+		break;
+	case 3:
+		HALMAC_REG_W16(REG_WMAC_ASSOCIATED_MU_BFMEE3, 0);
+		break;
+	case 4:
+		HALMAC_REG_W16(REG_WMAC_ASSOCIATED_MU_BFMEE4, 0);
+		break;
+	case 5:
+		HALMAC_REG_W16(REG_WMAC_ASSOCIATED_MU_BFMEE5, 0);
+		break;
+	default:
+		return HALMAC_RET_INVALID_SOUNDING_SETTING;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * su_bfee_entry_del_88xx() - reset SU beamformer's registers
+ * @adapter : the adapter of halmac
+ * @userid : the SU BFer userid to be deleted
+ * Author : chunchu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+su_bfer_entry_del_88xx(struct halmac_adapter *adapter, u8 userid)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	switch (userid) {
+	case 0:
+		HALMAC_REG_W32(REG_ASSOCIATED_BFMER0_INFO, 0);
+		HALMAC_REG_W32(REG_ASSOCIATED_BFMER0_INFO + 4, 0);
+		break;
+	case 1:
+		HALMAC_REG_W32(REG_ASSOCIATED_BFMER1_INFO, 0);
+		HALMAC_REG_W32(REG_ASSOCIATED_BFMER1_INFO + 4, 0);
+		break;
+	default:
+		return HALMAC_RET_INVALID_SOUNDING_SETTING;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * mu_bfee_entry_del_88xx() - reset MU beamformee's registers
+ * @adapter : the adapter of halmac
+ * @userid : the MU STA userid to be deleted
+ * Author : chunchu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+mu_bfee_entry_del_88xx(struct halmac_adapter *adapter, u8 userid)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	HALMAC_REG_W16(0x1680 + userid * 2, 0);
+	HALMAC_REG_W8_CLR(REG_MU_TX_CTL, BIT(userid - 2));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * mu_bfer_entry_del_88xx() -reset MU beamformer's registers
+ * @adapter : the adapter of halmac
+ * Author : chunchu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+mu_bfer_entry_del_88xx(struct halmac_adapter *adapter)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	HALMAC_REG_W32(REG_ASSOCIATED_BFMER0_INFO, 0);
+	HALMAC_REG_W32(REG_ASSOCIATED_BFMER0_INFO + 4, 0);
+	HALMAC_REG_W16(0x1680, 0);
+	HALMAC_REG_W8(REG_MU_TX_CTL, 0);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_csi_rate_88xx() - config CSI frame Tx rate
+ * @adapter : the adapter of halmac
+ * @rssi : rssi in decimal value
+ * @cur_rate : current CSI frame rate
+ * @fixrate_en : enable to fix CSI frame in VHT rate, otherwise legacy OFDM rate
+ * @new_rate : API returns the final CSI frame rate
+ * Author : chunchu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_csi_rate_88xx(struct halmac_adapter *adapter, u8 rssi, u8 cur_rate,
+		  u8 fixrate_en, u8 *new_rate)
+{
+	u32 csi_cfg;
+	u16 cur_rrsr;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	csi_cfg = HALMAC_REG_R32(REG_BBPSF_CTRL) & ~BITS_WMAC_CSI_RATE;
+
+	cur_rrsr = HALMAC_REG_R16(REG_RRSR);
+
+	if (rssi >= 40) {
+		if (cur_rate != HALMAC_OFDM54) {
+			cur_rrsr |= BIT(HALMAC_OFDM54);
+			csi_cfg |= BIT_WMAC_CSI_RATE(HALMAC_OFDM54);
+			HALMAC_REG_W16(REG_RRSR, cur_rrsr);
+			HALMAC_REG_W32(REG_BBPSF_CTRL, csi_cfg);
+		}
+		*new_rate = HALMAC_OFDM54;
+	} else {
+		if (cur_rate != HALMAC_OFDM24) {
+			cur_rrsr &= ~(BIT(HALMAC_OFDM54));
+			csi_cfg |= BIT_WMAC_CSI_RATE(HALMAC_OFDM24);
+			HALMAC_REG_W16(REG_RRSR, cur_rrsr);
+			HALMAC_REG_W32(REG_BBPSF_CTRL, csi_cfg);
+		}
+		*new_rate = HALMAC_OFDM24;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * fw_snding_88xx() - fw sounding control
+ * @adapter : the adapter of halmac
+ * @su_info :
+ *	su0_en : enable/disable fw sounding
+ *	su0_ndpa_pkt : ndpa pkt, shall include txdesc
+ *	su0_pkt_sz : ndpa pkt size, shall include txdesc
+ * @mu_info : currently not in use, input NULL is acceptable
+ * @period : sounding period, unit is 5ms
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+fw_snding_88xx(struct halmac_adapter *adapter,
+	       struct halmac_su_snding_info *su_info,
+	       struct halmac_mu_snding_info *mu_info, u8 period)
+{
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = { 0 };
+	u16 seq_num;
+	u16 snding_info_addr;
+	struct halmac_h2c_header_info hdr_info;
+	enum halmac_cmd_process_status *proc_status;
+	enum halmac_ret_status status;
+
+	proc_status = &adapter->halmac_state.fw_snding_state.proc_status;
+
+	if (adapter->chip_id == HALMAC_CHIP_ID_8821C)
+		return HALMAC_RET_NOT_SUPPORT;
+
+	if (halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	if (adapter->fw_ver.h2c_version < 9)
+		return HALMAC_RET_FW_NO_SUPPORT;
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "Wait event(snd)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	if (su_info->su0_en == 1) {
+		if (!su_info->su0_ndpa_pkt)
+			return HALMAC_RET_NULL_POINTER;
+
+		if (su_info->su0_pkt_sz > (u32)SU0_SNDING_PKT_RSVDPG_SIZE -
+		    adapter->hw_cfg_info.txdesc_size)
+			return HALMAC_RET_DATA_SIZE_INCORRECT;
+
+		if (!snding_pkt_chk_88xx(adapter, su_info->su0_ndpa_pkt))
+			return HALMAC_RET_TXDESC_SET_FAIL;
+
+		if (fw_snding_cmd_cnstr_state_88xx(adapter) !=
+		    HALMAC_CMD_CNSTR_IDLE) {
+			pr_err("Not idle(snd)\n");
+			return HALMAC_RET_ERROR_STATE;
+		}
+
+		snding_info_addr = adapter->txff_alloc.rsvd_h2c_sta_info_addr +
+				   SU0_SNDING_PKT_OFFSET;
+		status = dl_rsvd_page_88xx(adapter, snding_info_addr,
+					   su_info->su0_ndpa_pkt,
+					   su_info->su0_pkt_sz);
+		if (status != HALMAC_RET_SUCCESS) {
+			pr_err("dl rsvd page\n");
+			return status;
+		}
+
+		FW_SNDING_SET_SU0(h2c_buf, 1);
+		FW_SNDING_SET_PERIOD(h2c_buf, period);
+		FW_SNDING_SET_NDPA0_HEAD_PG(h2c_buf, snding_info_addr -
+					    adapter->txff_alloc.rsvd_boundary);
+	} else {
+		if (fw_snding_cmd_cnstr_state_88xx(adapter) !=
+		    HALMAC_CMD_CNSTR_BUSY) {
+			pr_err("Not snd(snd)\n");
+			return HALMAC_RET_ERROR_STATE;
+		}
+		FW_SNDING_SET_SU0(h2c_buf, 0);
+	}
+
+	*proc_status = HALMAC_CMD_PROCESS_SENDING;
+
+	hdr_info.sub_cmd_id = SUB_CMD_ID_FW_SNDING;
+	hdr_info.content_size = 8;
+	hdr_info.ack = 1;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+	adapter->halmac_state.fw_snding_state.seq_num = seq_num;
+
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("send h2c\n");
+		reset_ofld_feature_88xx(adapter, HALMAC_FEATURE_FW_SNDING);
+		return status;
+	}
+
+	if (cnv_fw_snding_state_88xx(adapter, su_info->su0_en == 1 ?
+				     HALMAC_CMD_CNSTR_BUSY :
+				     HALMAC_CMD_CNSTR_IDLE)
+				     != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static u8
+snding_pkt_chk_88xx(struct halmac_adapter *adapter, u8 *pkt)
+{
+	u8 data_rate;
+
+	if (GET_TX_DESC_NDPA(pkt) == 0) {
+		pr_err("txdesc ndpa = 0\n");
+		return 0;
+	}
+
+	data_rate = (u8)GET_TX_DESC_DATARATE(pkt);
+	if (!(data_rate >= HALMAC_VHT_NSS2_MCS0 &&
+	      data_rate <= HALMAC_VHT_NSS2_MCS9)) {
+		if (!(data_rate >= HALMAC_MCS8 && data_rate <= HALMAC_MCS15)) {
+			pr_err("txdesc rate\n");
+			return 0;
+		}
+	}
+
+	if (GET_TX_DESC_NAVUSEHDR(pkt) == 0) {
+		pr_err("txdesc navusehdr = 0\n");
+		return 0;
+	}
+
+	if (GET_TX_DESC_USE_RATE(pkt) == 0) {
+		pr_err("txdesc userate = 0\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static enum halmac_cmd_construct_state
+fw_snding_cmd_cnstr_state_88xx(struct halmac_adapter *adapter)
+{
+	return adapter->halmac_state.fw_snding_state.cmd_cnstr_state;
+}
+
+enum halmac_ret_status
+get_h2c_ack_fw_snding_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u8 seq_num = 0;
+	u8 fw_rc;
+	struct halmac_fw_snding_state *state;
+	enum halmac_cmd_process_status proc_status;
+
+	state = &adapter->halmac_state.fw_snding_state;
+
+	seq_num = (u8)H2C_ACK_HDR_GET_H2C_SEQ(buf);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "Seq num:h2c->%d c2h->%d\n", state->seq_num, seq_num);
+	if (seq_num != state->seq_num) {
+		pr_err("Seq num mismatch:h2c->%d c2h->%d\n", state->seq_num,
+		       seq_num);
+		return HALMAC_RET_SUCCESS;
+	}
+
+	if (state->proc_status != HALMAC_CMD_PROCESS_SENDING) {
+		pr_err("not sending(snd)\n");
+		return HALMAC_RET_SUCCESS;
+	}
+
+	fw_rc = (u8)H2C_ACK_HDR_GET_H2C_RETURN_CODE(buf);
+	state->fw_rc = fw_rc;
+
+	if ((enum halmac_h2c_return_code)fw_rc == HALMAC_H2C_RETURN_SUCCESS) {
+		proc_status = HALMAC_CMD_PROCESS_DONE;
+		state->proc_status = proc_status;
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_FW_SNDING, proc_status,
+				NULL, 0);
+	} else {
+		proc_status = HALMAC_CMD_PROCESS_ERROR;
+		state->proc_status = proc_status;
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_FW_SNDING, proc_status,
+				&fw_rc, 1);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+get_fw_snding_status_88xx(struct halmac_adapter *adapter,
+			  enum halmac_cmd_process_status *proc_status)
+{
+	*proc_status = adapter->halmac_state.fw_snding_state.proc_status;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+cnv_fw_snding_state_88xx(struct halmac_adapter *adapter,
+			 enum halmac_cmd_construct_state dest_state)
+{
+	struct halmac_fw_snding_state *state;
+
+	state = &adapter->halmac_state.fw_snding_state;
+
+	if (state->cmd_cnstr_state != HALMAC_CMD_CNSTR_IDLE &&
+	    state->cmd_cnstr_state != HALMAC_CMD_CNSTR_BUSY)
+		return HALMAC_RET_ERROR_STATE;
+
+	if (dest_state == HALMAC_CMD_CNSTR_IDLE) {
+		if (state->cmd_cnstr_state == HALMAC_CMD_CNSTR_IDLE)
+			return HALMAC_RET_ERROR_STATE;
+	} else if (dest_state == HALMAC_CMD_CNSTR_BUSY) {
+		if (state->cmd_cnstr_state == HALMAC_CMD_CNSTR_BUSY)
+			return HALMAC_RET_ERROR_STATE;
+	}
+
+	state->cmd_cnstr_state = dest_state;
+
+	return HALMAC_RET_SUCCESS;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.h
new file mode 100644
index 000000000000..7fb8e2547186
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_mimo_88xx.h
@@ -0,0 +1,79 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2016 - 2018 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ ******************************************************************************/
+
+#ifndef _HALMAC_MIMO_88XX_H_
+#define _HALMAC_MIMO_88XX_H_
+
+#include "../halmac_api.h"
+
+enum halmac_ret_status
+cfg_txbf_88xx(struct halmac_adapter *adapter, u8 userid, enum halmac_bw bw,
+	      u8 txbf_en);
+
+enum halmac_ret_status
+cfg_mumimo_88xx(struct halmac_adapter *adapter,
+		struct halmac_cfg_mumimo_para *param);
+
+enum halmac_ret_status
+cfg_sounding_88xx(struct halmac_adapter *adapter, enum halmac_snd_role role,
+		  enum halmac_data_rate rate);
+
+enum halmac_ret_status
+del_sounding_88xx(struct halmac_adapter *adapter, enum halmac_snd_role role);
+
+enum halmac_ret_status
+su_bfee_entry_init_88xx(struct halmac_adapter *adapter, u8 userid, u16 paid);
+
+enum halmac_ret_status
+su_bfer_entry_init_88xx(struct halmac_adapter *adapter,
+			struct halmac_su_bfer_init_para *param);
+
+enum halmac_ret_status
+mu_bfee_entry_init_88xx(struct halmac_adapter *adapter,
+			struct halmac_mu_bfee_init_para *param);
+
+enum halmac_ret_status
+mu_bfer_entry_init_88xx(struct halmac_adapter *adapter,
+			struct halmac_mu_bfer_init_para *param);
+
+enum halmac_ret_status
+su_bfee_entry_del_88xx(struct halmac_adapter *adapter, u8 userid);
+
+enum halmac_ret_status
+su_bfer_entry_del_88xx(struct halmac_adapter *adapter, u8 userid);
+
+enum halmac_ret_status
+mu_bfee_entry_del_88xx(struct halmac_adapter *adapter, u8 userid);
+
+enum halmac_ret_status
+mu_bfer_entry_del_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+cfg_csi_rate_88xx(struct halmac_adapter *adapter, u8 rssi, u8 cur_rate,
+		  u8 fixrate_en, u8 *new_rate);
+
+enum halmac_ret_status
+fw_snding_88xx(struct halmac_adapter *adapter,
+	       struct halmac_su_snding_info *su_info,
+	       struct halmac_mu_snding_info *mu_info, u8 period);
+
+enum halmac_ret_status
+get_h2c_ack_fw_snding_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+enum halmac_ret_status
+get_fw_snding_status_88xx(struct halmac_adapter *adapter,
+			  enum halmac_cmd_process_status *proc_status);
+
+#endif/* _HALMAC_MIMO_88XX_H_ */
-- 
2.15.1
