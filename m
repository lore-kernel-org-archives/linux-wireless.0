Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:54984 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbeDYCIr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 22:08:47 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 12/19] rtlwifi: halmac: access efuse through halmac helper functions
Date: Wed, 25 Apr 2018 10:08:13 +0800
Message-ID: <20180425020820.6141-13-pkshih@realtek.com> (sfid-20180425_040906_638826_5E9FFFCC)
In-Reply-To: <20180425020820.6141-1-pkshih@realtek.com>
References: <20180425020820.6141-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

This file provides interfaces to read and write efuse contents.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.c | 1918 ++++++++++++++++++++
 .../rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.h |  101 ++
 2 files changed, 2019 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.c
new file mode 100644
index 000000000000..3d51acb5857e
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.c
@@ -0,0 +1,1918 @@
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
+#include "halmac_efuse_88xx.h"
+#include "halmac_88xx_cfg.h"
+#include "halmac_common_88xx.h"
+#include "halmac_init_88xx.h"
+
+#define RSVD_EFUSE_SIZE		16
+#define RSVD_CS_EFUSE_SIZE	24
+#define PROTECT_EFUSE_SIZE	96
+#define FEATURE_DUMP_PHY_EFUSE	HALMAC_FEATURE_DUMP_PHYSICAL_EFUSE
+#define FEATURE_DUMP_LOG_EFUSE	HALMAC_FEATURE_DUMP_LOGICAL_EFUSE
+
+static enum halmac_cmd_construct_state
+efuse_cmd_cnstr_state_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+proc_dump_efuse_88xx(struct halmac_adapter *adapter,
+		     enum halmac_efuse_read_cfg cfg);
+
+static enum halmac_ret_status
+read_hw_efuse_88xx(struct halmac_adapter *adapter, u32 offset, u32 size,
+		   u8 *map);
+
+static enum halmac_ret_status
+eeprom_parser_88xx(struct halmac_adapter *adapter, u8 *phy_map, u8 *log_map);
+
+static enum halmac_ret_status
+read_log_efuse_map_88xx(struct halmac_adapter *adapter, u8 *map);
+
+static enum halmac_ret_status
+proc_pg_efuse_by_map_88xx(struct halmac_adapter *adapter,
+			  struct halmac_pg_efuse_info *info,
+			  enum halmac_efuse_read_cfg cfg);
+
+static enum halmac_ret_status
+dump_efuse_fw_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+dump_efuse_drv_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+proc_write_log_efuse_88xx(struct halmac_adapter *adapter, u32 offset, u8 value);
+
+static enum halmac_ret_status
+update_eeprom_mask_88xx(struct halmac_adapter *adapter,
+			struct halmac_pg_efuse_info *info, u8 *updated_mask);
+
+static enum halmac_ret_status
+check_efuse_enough_88xx(struct halmac_adapter *adapter,
+			struct halmac_pg_efuse_info *info, u8 *updated_mask);
+
+static enum halmac_ret_status
+pg_extend_efuse_88xx(struct halmac_adapter *adapter,
+		     struct halmac_pg_efuse_info *info, u8 word_en,
+		     u8 pre_word_en, u32 eeprom_offset);
+
+static enum halmac_ret_status
+proc_pg_efuse_88xx(struct halmac_adapter *adapter,
+		   struct halmac_pg_efuse_info *info, u8 word_en,
+		   u8 pre_word_en, u32 eeprom_offset);
+
+static enum halmac_ret_status
+program_efuse_88xx(struct halmac_adapter *adapter,
+		   struct halmac_pg_efuse_info *info, u8 *updated_mask);
+
+static void
+mask_eeprom_88xx(struct halmac_adapter *adapter,
+		 struct halmac_pg_efuse_info *info);
+
+/**
+ * dump_efuse_map_88xx() - dump "physical" efuse map
+ * @adapter : the adapter of halmac
+ * @cfg : dump efuse method
+ * Author : Ivan Lin/KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+dump_efuse_map_88xx(struct halmac_adapter *adapter,
+		    enum halmac_efuse_read_cfg cfg)
+{
+	u8 *map = NULL;
+	u8 *efuse_map;
+	u32 efuse_size = adapter->hw_cfg_info.efuse_size;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.efuse_state.proc_status;
+
+	if (cfg == HALMAC_EFUSE_R_FW &&
+	    halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "cfg = %d\n",
+		 cfg);
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Wait event(efuse)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	if (efuse_cmd_cnstr_state_88xx(adapter) != HALMAC_CMD_CNSTR_IDLE) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Not idle(efuse)\n");
+		return HALMAC_RET_ERROR_STATE;
+	}
+
+	if (adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF)
+		pr_err("Dump efuse in suspend\n");
+
+	*proc_status = HALMAC_CMD_PROCESS_IDLE;
+	adapter->evnt.phy_efuse_map = 1;
+
+	status = switch_efuse_bank_88xx(adapter, HALMAC_EFUSE_BANK_WIFI);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("switch efuse bank!!\n");
+		return status;
+	}
+
+	status = proc_dump_efuse_88xx(adapter, cfg);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("dump efuse!!\n");
+		return status;
+	}
+
+	if (adapter->efuse_map_valid == 1) {
+		*proc_status = HALMAC_CMD_PROCESS_DONE;
+		efuse_map = adapter->efuse_map;
+
+		map = kzalloc(efuse_size, GFP_KERNEL);
+		if (!map)
+			return HALMAC_RET_MALLOC_FAIL;
+		memset(map, 0xFF, efuse_size);
+		mutex_lock(&adapter->efuse_mutex);
+		memcpy(map, efuse_map, efuse_size - PROTECT_EFUSE_SIZE);
+		memcpy(map + efuse_size - PROTECT_EFUSE_SIZE +
+		       RSVD_CS_EFUSE_SIZE,
+		       efuse_map + efuse_size - PROTECT_EFUSE_SIZE +
+		       RSVD_CS_EFUSE_SIZE,
+		       PROTECT_EFUSE_SIZE - RSVD_EFUSE_SIZE -
+		       RSVD_CS_EFUSE_SIZE);
+		mutex_unlock(&adapter->efuse_mutex);
+
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_DUMP_PHYSICAL_EFUSE,
+				*proc_status, map, efuse_size);
+		adapter->evnt.phy_efuse_map = 0;
+
+		kfree(map);
+	}
+
+	if (cnv_efuse_state_88xx(adapter, HALMAC_CMD_CNSTR_IDLE) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * dump_efuse_map_bt_88xx() - dump "BT physical" efuse map
+ * @adapter : the adapter of halmac
+ * @bank : bt efuse bank
+ * @size : bt efuse map size. get from halmac_get_efuse_size API
+ * @map : bt efuse map
+ * Author : Soar / Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+dump_efuse_map_bt_88xx(struct halmac_adapter *adapter,
+		       enum halmac_efuse_bank bank, u32 size, u8 *map)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.efuse_state.proc_status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (adapter->hw_cfg_info.bt_efuse_size != size)
+		return HALMAC_RET_EFUSE_SIZE_INCORRECT;
+
+	if (bank >= HALMAC_EFUSE_BANK_MAX || bank == HALMAC_EFUSE_BANK_WIFI) {
+		pr_err("Undefined BT bank\n");
+		return HALMAC_RET_EFUSE_BANK_INCORRECT;
+	}
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Wait event(efuse)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	if (efuse_cmd_cnstr_state_88xx(adapter) != HALMAC_CMD_CNSTR_IDLE) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Not idle(efuse)\n");
+		return HALMAC_RET_ERROR_STATE;
+	}
+
+	status = switch_efuse_bank_88xx(adapter, bank);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("switch efuse bank!!\n");
+		return status;
+	}
+
+	status = read_hw_efuse_88xx(adapter, 0, size, map);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("read hw efuse\n");
+		return status;
+	}
+
+	if (cnv_efuse_state_88xx(adapter, HALMAC_CMD_CNSTR_IDLE) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * write_efuse_bt_88xx() - write "BT physical" efuse offset
+ * @adapter : the adapter of halmac
+ * @offset : offset
+ * @value : Write value
+ * @map : bt efuse map
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+write_efuse_bt_88xx(struct halmac_adapter *adapter, u32 offset, u8 value,
+		    enum halmac_efuse_bank bank)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.efuse_state.proc_status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Wait event(efuse)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	if (efuse_cmd_cnstr_state_88xx(adapter) != HALMAC_CMD_CNSTR_IDLE) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Not idle(efuse)\n");
+		return HALMAC_RET_ERROR_STATE;
+	}
+
+	if (offset >= adapter->hw_cfg_info.efuse_size) {
+		pr_err("Offset is too large\n");
+		return HALMAC_RET_EFUSE_SIZE_INCORRECT;
+	}
+
+	if (bank > HALMAC_EFUSE_BANK_MAX || bank == HALMAC_EFUSE_BANK_WIFI) {
+		pr_err("Undefined BT bank\n");
+		return HALMAC_RET_EFUSE_BANK_INCORRECT;
+	}
+
+	status = switch_efuse_bank_88xx(adapter, bank);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("switch efuse bank!!\n");
+		return status;
+	}
+
+	status = write_hw_efuse_88xx(adapter, offset, value);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("write efuse\n");
+		return status;
+	}
+
+	if (cnv_efuse_state_88xx(adapter, HALMAC_CMD_CNSTR_IDLE) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * read_efuse_bt_88xx() - read "BT physical" efuse offset
+ * @adapter : the adapter of halmac
+ * @offset : offset
+ * @value : 1 byte efuse value
+ * @bank : efuse bank
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+read_efuse_bt_88xx(struct halmac_adapter *adapter, u32 offset, u8 *value,
+		   enum halmac_efuse_bank bank)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.efuse_state.proc_status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Wait event(efuse)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	if (efuse_cmd_cnstr_state_88xx(adapter) != HALMAC_CMD_CNSTR_IDLE) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Not idle(efuse)\n");
+		return HALMAC_RET_ERROR_STATE;
+	}
+
+	if (offset >= adapter->hw_cfg_info.efuse_size) {
+		pr_err("Offset is too large\n");
+		return HALMAC_RET_EFUSE_SIZE_INCORRECT;
+	}
+
+	if (bank > HALMAC_EFUSE_BANK_MAX || bank == HALMAC_EFUSE_BANK_WIFI) {
+		pr_err("Undefined BT bank\n");
+		return HALMAC_RET_EFUSE_BANK_INCORRECT;
+	}
+
+	status = switch_efuse_bank_88xx(adapter, bank);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("switch efuse bank\n");
+		return status;
+	}
+
+	status = read_efuse_88xx(adapter, offset, 1, value);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("read efuse\n");
+		return status;
+	}
+
+	if (cnv_efuse_state_88xx(adapter, HALMAC_CMD_CNSTR_IDLE) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_efuse_auto_check_88xx() - check efuse after writing it
+ * @adapter : the adapter of halmac
+ * @enable : 1, enable efuse auto check. others, disable
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_efuse_auto_check_88xx(struct halmac_adapter *adapter, u8 enable)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	adapter->efuse_auto_check_en = enable;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * get_efuse_available_size_88xx() - get efuse available size
+ * @adapter : the adapter of halmac
+ * @size : physical efuse available size
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_efuse_available_size_88xx(struct halmac_adapter *adapter, u32 *size)
+{
+	enum halmac_ret_status status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	status = dump_log_efuse_map_88xx(adapter, HALMAC_EFUSE_R_DRV);
+
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	*size = adapter->hw_cfg_info.efuse_size - PROTECT_EFUSE_SIZE -
+		adapter->efuse_end;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * get_efuse_size_88xx() - get "physical" efuse size
+ * @adapter : the adapter of halmac
+ * @size : physical efuse size
+ * Author : Ivan Lin/KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_efuse_size_88xx(struct halmac_adapter *adapter, u32 *size)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	*size = adapter->hw_cfg_info.efuse_size;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * get_log_efuse_size_88xx() - get "logical" efuse size
+ * @adapter : the adapter of halmac
+ * @size : logical efuse size
+ * Author : Ivan Lin/KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_log_efuse_size_88xx(struct halmac_adapter *adapter, u32 *size)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	*size = adapter->hw_cfg_info.eeprom_size;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * dump_log_efuse_map_88xx() - dump "logical" efuse map
+ * @adapter : the adapter of halmac
+ * @cfg : dump efuse method
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+dump_log_efuse_map_88xx(struct halmac_adapter *adapter,
+			enum halmac_efuse_read_cfg cfg)
+{
+	u8 *map = NULL;
+	u32 size = adapter->hw_cfg_info.eeprom_size;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.efuse_state.proc_status;
+
+	if (cfg == HALMAC_EFUSE_R_FW &&
+	    halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "cfg = %d\n",
+		 cfg);
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Wait event(efuse)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	if (efuse_cmd_cnstr_state_88xx(adapter) != HALMAC_CMD_CNSTR_IDLE) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Not idle(efuse)\n");
+		return HALMAC_RET_ERROR_STATE;
+	}
+
+	if (adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF)
+		pr_err("Dump efuse in suspend\n");
+
+	*proc_status = HALMAC_CMD_PROCESS_IDLE;
+	adapter->evnt.log_efuse_map = 1;
+
+	status = switch_efuse_bank_88xx(adapter, HALMAC_EFUSE_BANK_WIFI);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("switch efuse bank\n");
+		return status;
+	}
+
+	status = proc_dump_efuse_88xx(adapter, cfg);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("dump efuse\n");
+		return status;
+	}
+
+	if (adapter->efuse_map_valid == 1) {
+		*proc_status = HALMAC_CMD_PROCESS_DONE;
+
+		map = kzalloc(size, GFP_KERNEL);
+		if (!map)
+			return HALMAC_RET_MALLOC_FAIL;
+		memset(map, 0xFF, size);
+
+		if (eeprom_parser_88xx(adapter, adapter->efuse_map, map) !=
+		    HALMAC_RET_SUCCESS) {
+			kfree(map);
+			return HALMAC_RET_EEPROM_PARSING_FAIL;
+		}
+
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_DUMP_LOGICAL_EFUSE,
+				*proc_status, map, size);
+		adapter->evnt.log_efuse_map = 0;
+
+		kfree(map);
+	}
+
+	if (cnv_efuse_state_88xx(adapter, HALMAC_CMD_CNSTR_IDLE) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * read_logical_efuse_88xx() - read logical efuse map 1 byte
+ * @adapter : the adapter of halmac
+ * @offset : offset
+ * @value : 1 byte efuse value
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+read_logical_efuse_88xx(struct halmac_adapter *adapter, u32 offset, u8 *value)
+{
+	u8 *map = NULL;
+	u32 size = adapter->hw_cfg_info.eeprom_size;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.efuse_state.proc_status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (offset >= size) {
+		pr_err("Offset is too large\n");
+		return HALMAC_RET_EFUSE_SIZE_INCORRECT;
+	}
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Wait event(efuse)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+	if (efuse_cmd_cnstr_state_88xx(adapter) != HALMAC_CMD_CNSTR_IDLE) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Not idle(efuse)\n");
+		return HALMAC_RET_ERROR_STATE;
+	}
+
+	status = switch_efuse_bank_88xx(adapter, HALMAC_EFUSE_BANK_WIFI);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("switch efuse bank\n");
+		return status;
+	}
+
+	map = kzalloc(size, GFP_KERNEL);
+	if (!map)
+		return HALMAC_RET_MALLOC_FAIL;
+	memset(map, 0xFF, size);
+
+	status = read_log_efuse_map_88xx(adapter, map);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("read logical efuse\n");
+		kfree(map);
+		return status;
+	}
+
+	*value = *(map + offset);
+
+	if (cnv_efuse_state_88xx(adapter, HALMAC_CMD_CNSTR_IDLE) !=
+	    HALMAC_RET_SUCCESS) {
+		kfree(map);
+		return HALMAC_RET_ERROR_STATE;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	kfree(map);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * write_log_efuse_88xx() - write "logical" efuse offset
+ * @adapter : the adapter of halmac
+ * @offset : offset
+ * @value : value
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+write_log_efuse_88xx(struct halmac_adapter *adapter, u32 offset, u8 value)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.efuse_state.proc_status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (offset >= adapter->hw_cfg_info.eeprom_size) {
+		pr_err("Offset is too large\n");
+		return HALMAC_RET_EFUSE_SIZE_INCORRECT;
+	}
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Wait event(efuse)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	if (efuse_cmd_cnstr_state_88xx(adapter) != HALMAC_CMD_CNSTR_IDLE) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Not idle(efuse)\n");
+		return HALMAC_RET_ERROR_STATE;
+	}
+
+	status = switch_efuse_bank_88xx(adapter, HALMAC_EFUSE_BANK_WIFI);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("switch efuse bank\n");
+		return status;
+	}
+
+	status = proc_write_log_efuse_88xx(adapter, offset, value);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("write logical efuse\n");
+		return status;
+	}
+
+	if (cnv_efuse_state_88xx(adapter, HALMAC_CMD_CNSTR_IDLE) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * pg_efuse_by_map_88xx() - pg logical efuse by map
+ * @adapter : the adapter of halmac
+ * @info : efuse map information
+ * @cfg : dump efuse method
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+pg_efuse_by_map_88xx(struct halmac_adapter *adapter,
+		     struct halmac_pg_efuse_info *info,
+		     enum halmac_efuse_read_cfg cfg)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.efuse_state.proc_status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (info->efuse_map_size != adapter->hw_cfg_info.eeprom_size) {
+		pr_err("map size error\n");
+		return HALMAC_RET_EFUSE_SIZE_INCORRECT;
+	}
+
+	if ((info->efuse_map_size & 0xF) > 0) {
+		pr_err("not multiple of 16\n");
+		return HALMAC_RET_EFUSE_SIZE_INCORRECT;
+	}
+
+	if (info->efuse_mask_size != info->efuse_map_size >> 4) {
+		pr_err("mask size error\n");
+		return HALMAC_RET_EFUSE_SIZE_INCORRECT;
+	}
+
+	if (!info->efuse_map) {
+		pr_err("map is NULL\n");
+		return HALMAC_RET_NULL_POINTER;
+	}
+
+	if (!info->efuse_mask) {
+		pr_err("mask is NULL\n");
+		return HALMAC_RET_NULL_POINTER;
+	}
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Wait event(efuse)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	if (efuse_cmd_cnstr_state_88xx(adapter) != HALMAC_CMD_CNSTR_IDLE) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Not idle(efuse)\n");
+		return HALMAC_RET_ERROR_STATE;
+	}
+
+	status = switch_efuse_bank_88xx(adapter, HALMAC_EFUSE_BANK_WIFI);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("switch efuse bank\n");
+		return status;
+	}
+
+	status = proc_pg_efuse_by_map_88xx(adapter, info, cfg);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("pg efuse\n");
+		return status;
+	}
+
+	if (cnv_efuse_state_88xx(adapter, HALMAC_CMD_CNSTR_IDLE) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * mask_log_efuse_88xx() - mask logical efuse
+ * @adapter : the adapter of halmac
+ * @info : efuse map information
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+mask_log_efuse_88xx(struct halmac_adapter *adapter,
+		    struct halmac_pg_efuse_info *info)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (info->efuse_map_size != adapter->hw_cfg_info.eeprom_size) {
+		pr_err("map size error\n");
+		return HALMAC_RET_EFUSE_SIZE_INCORRECT;
+	}
+
+	if ((info->efuse_map_size & 0xF) > 0) {
+		pr_err("not multiple of 16\n");
+		return HALMAC_RET_EFUSE_SIZE_INCORRECT;
+	}
+
+	if (info->efuse_mask_size != info->efuse_map_size >> 4) {
+		pr_err("mask size error\n");
+		return HALMAC_RET_EFUSE_SIZE_INCORRECT;
+	}
+
+	if (!info->efuse_map) {
+		pr_err("map is NULL\n");
+		return HALMAC_RET_NULL_POINTER;
+	}
+
+	if (!info->efuse_mask) {
+		pr_err("mask is NULL\n");
+		return HALMAC_RET_NULL_POINTER;
+	}
+
+	mask_eeprom_88xx(adapter, info);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_cmd_construct_state
+efuse_cmd_cnstr_state_88xx(struct halmac_adapter *adapter)
+{
+	return adapter->halmac_state.efuse_state.cmd_cnstr_state;
+}
+
+enum halmac_ret_status
+switch_efuse_bank_88xx(struct halmac_adapter *adapter,
+		       enum halmac_efuse_bank bank)
+{
+	u8 reg_value;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (cnv_efuse_state_88xx(adapter, HALMAC_CMD_CNSTR_BUSY) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	reg_value = HALMAC_REG_R8(REG_LDO_EFUSE_CTRL + 1);
+
+	if (bank == (reg_value & (BIT(0) | BIT(1))))
+		return HALMAC_RET_SUCCESS;
+
+	reg_value &= ~(BIT(0) | BIT(1));
+	reg_value |= bank;
+	HALMAC_REG_W8(REG_LDO_EFUSE_CTRL + 1, reg_value);
+
+	reg_value = HALMAC_REG_R8(REG_LDO_EFUSE_CTRL + 1);
+	if ((reg_value & (BIT(0) | BIT(1))) != bank)
+		return HALMAC_RET_SWITCH_EFUSE_BANK_FAIL;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+proc_dump_efuse_88xx(struct halmac_adapter *adapter,
+		     enum halmac_efuse_read_cfg cfg)
+{
+	u32 h2c_init;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.efuse_state.proc_status;
+
+	*proc_status = HALMAC_CMD_PROCESS_SENDING;
+
+	if (cnv_efuse_state_88xx(adapter, HALMAC_CMD_CNSTR_H2C_SENT) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	if (cfg == HALMAC_EFUSE_R_AUTO) {
+		h2c_init = HALMAC_REG_R32(REG_H2C_PKT_READADDR);
+		if (adapter->halmac_state.dlfw_state == HALMAC_DLFW_NONE ||
+		    h2c_init == 0)
+			status = dump_efuse_drv_88xx(adapter);
+		else
+			status = dump_efuse_fw_88xx(adapter);
+	} else if (cfg == HALMAC_EFUSE_R_FW) {
+		status = dump_efuse_fw_88xx(adapter);
+	} else {
+		status = dump_efuse_drv_88xx(adapter);
+	}
+
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("dump efsue drv/fw\n");
+		return status;
+	}
+
+	return status;
+}
+
+enum halmac_ret_status
+cnv_efuse_state_88xx(struct halmac_adapter *adapter,
+		     enum halmac_cmd_construct_state dest_state)
+{
+	struct halmac_efuse_state *state = &adapter->halmac_state.efuse_state;
+
+	if (state->cmd_cnstr_state != HALMAC_CMD_CNSTR_IDLE &&
+	    state->cmd_cnstr_state != HALMAC_CMD_CNSTR_BUSY &&
+	    state->cmd_cnstr_state != HALMAC_CMD_CNSTR_H2C_SENT)
+		return HALMAC_RET_ERROR_STATE;
+
+	if (state->cmd_cnstr_state == dest_state)
+		return HALMAC_RET_ERROR_STATE;
+
+	if (dest_state == HALMAC_CMD_CNSTR_BUSY) {
+		if (state->cmd_cnstr_state == HALMAC_CMD_CNSTR_H2C_SENT)
+			return HALMAC_RET_ERROR_STATE;
+	} else if (dest_state == HALMAC_CMD_CNSTR_H2C_SENT) {
+		if (state->cmd_cnstr_state == HALMAC_CMD_CNSTR_IDLE)
+			return HALMAC_RET_ERROR_STATE;
+	}
+
+	state->cmd_cnstr_state = dest_state;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+read_hw_efuse_88xx(struct halmac_adapter *adapter, u32 offset, u32 size,
+		   u8 *map)
+{
+	u8 enable;
+	u32 value32;
+	u32 addr;
+	u32 tmp32;
+	u32 cnt;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	/* Read efuse no need 2.5V LDO */
+	enable = 0;
+	status = api->halmac_set_hw_value(adapter, HALMAC_HW_LDO25_EN, &enable);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("dis ldo25\n");
+		return status;
+	}
+	value32 = HALMAC_REG_R32(REG_EFUSE_CTRL);
+
+	for (addr = offset; addr < offset + size; addr++) {
+		value32 &= ~(BIT_MASK_EF_DATA | BITS_EF_ADDR);
+		value32 |= ((addr & BIT_MASK_EF_ADDR) << BIT_SHIFT_EF_ADDR);
+		HALMAC_REG_W32(REG_EFUSE_CTRL, value32 & (~BIT_EF_FLAG));
+
+		cnt = 1000000;
+		do {
+			udelay(1);
+			tmp32 = HALMAC_REG_R32(REG_EFUSE_CTRL);
+			cnt--;
+			if (cnt == 0) {
+				pr_err("read\n");
+				return HALMAC_RET_EFUSE_R_FAIL;
+			}
+		} while ((tmp32 & BIT_EF_FLAG) == 0);
+
+		*(map + addr - offset) = (u8)(tmp32 & BIT_MASK_EF_DATA);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+write_hw_efuse_88xx(struct halmac_adapter *adapter, u32 offset, u8 value)
+{
+	const u8 unlock_code = 0x69;
+	u8 value_read = 0;
+	u8 enable;
+	u32 value32;
+	u32 tmp32;
+	u32 cnt;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	mutex_lock(&adapter->efuse_mutex);
+	adapter->efuse_map_valid = 0;
+	mutex_unlock(&adapter->efuse_mutex);
+
+	HALMAC_REG_W8(REG_PMC_DBG_CTRL2 + 3, unlock_code);
+
+	/* Enable 2.5V LDO */
+	enable = 1;
+	status = api->halmac_set_hw_value(adapter, HALMAC_HW_LDO25_EN, &enable);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("en ldo25\n");
+		return status;
+	}
+
+	value32 = HALMAC_REG_R32(REG_EFUSE_CTRL);
+	value32 &= ~(BIT_MASK_EF_DATA | BITS_EF_ADDR);
+	value32 = value32 | ((offset & BIT_MASK_EF_ADDR) << BIT_SHIFT_EF_ADDR) |
+			(value & BIT_MASK_EF_DATA);
+	HALMAC_REG_W32(REG_EFUSE_CTRL, value32 | BIT_EF_FLAG);
+
+	cnt = 1000000;
+	do {
+		udelay(1);
+		tmp32 = HALMAC_REG_R32(REG_EFUSE_CTRL);
+		cnt--;
+		if (cnt == 0) {
+			pr_err("write!!\n");
+			return HALMAC_RET_EFUSE_W_FAIL;
+		}
+	} while (BIT_EF_FLAG == (tmp32 & BIT_EF_FLAG));
+
+	HALMAC_REG_W8(REG_PMC_DBG_CTRL2 + 3, 0x00);
+
+	/* Disable 2.5V LDO */
+	enable = 0;
+	status = api->halmac_set_hw_value(adapter, HALMAC_HW_LDO25_EN, &enable);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("dis ldo25\n");
+		return status;
+	}
+
+	if (adapter->efuse_auto_check_en == 1) {
+		if (read_hw_efuse_88xx(adapter, offset, 1, &value_read) !=
+		    HALMAC_RET_SUCCESS)
+			return HALMAC_RET_EFUSE_R_FAIL;
+		if (value_read != value) {
+			pr_err("efuse compare\n");
+			return HALMAC_RET_EFUSE_W_FAIL;
+		}
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+eeprom_parser_88xx(struct halmac_adapter *adapter, u8 *phy_map, u8 *log_map)
+{
+	u8 i;
+	u8 value8;
+	u8 blk_idx;
+	u8 word_en;
+	u8 valid;
+	u8 hdr;
+	u8 hdr2 = 0;
+	u32 eeprom_idx;
+	u32 efuse_idx = 0;
+	struct halmac_hw_cfg_info *hw_info = &adapter->hw_cfg_info;
+
+	memset(log_map, 0xFF, hw_info->eeprom_size);
+
+	do {
+		value8 = *(phy_map + efuse_idx);
+		hdr = value8;
+
+		if ((hdr & 0x1f) == 0x0f) {
+			efuse_idx++;
+			value8 = *(phy_map + efuse_idx);
+			hdr2 = value8;
+			if (hdr2 == 0xff)
+				break;
+			blk_idx = ((hdr2 & 0xF0) >> 1) | ((hdr >> 5) & 0x07);
+			word_en = hdr2 & 0x0F;
+		} else {
+			blk_idx = (hdr & 0xF0) >> 4;
+			word_en = hdr & 0x0F;
+		}
+
+		if (hdr == 0xff)
+			break;
+
+		efuse_idx++;
+
+		if (efuse_idx >= hw_info->efuse_size - PROTECT_EFUSE_SIZE - 1)
+			return HALMAC_RET_EEPROM_PARSING_FAIL;
+
+		for (i = 0; i < 4; i++) {
+			valid = (u8)((~(word_en >> i)) & BIT(0));
+			if (valid == 1) {
+				eeprom_idx = (blk_idx << 3) + (i << 1);
+
+				if ((eeprom_idx + 1) > hw_info->eeprom_size) {
+					pr_err("efuse idx:0x%X\n",
+					       efuse_idx - 1);
+
+					pr_err("read hdr:0x%X\n", hdr);
+
+					pr_err("rad hdr2:0x%X\n", hdr2);
+
+					return HALMAC_RET_EEPROM_PARSING_FAIL;
+				}
+
+				value8 = *(phy_map + efuse_idx);
+				*(log_map + eeprom_idx) = value8;
+
+				eeprom_idx++;
+				efuse_idx++;
+
+				if (efuse_idx > hw_info->efuse_size -
+				    PROTECT_EFUSE_SIZE - 1)
+					return HALMAC_RET_EEPROM_PARSING_FAIL;
+
+				value8 = *(phy_map + efuse_idx);
+				*(log_map + eeprom_idx) = value8;
+
+				efuse_idx++;
+
+				if (efuse_idx > hw_info->efuse_size -
+				    PROTECT_EFUSE_SIZE)
+					return HALMAC_RET_EEPROM_PARSING_FAIL;
+			}
+		}
+	} while (1);
+
+	adapter->efuse_end = efuse_idx;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+read_log_efuse_map_88xx(struct halmac_adapter *adapter, u8 *map)
+{
+	u8 *local_map = NULL;
+	u32 efuse_size;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (adapter->efuse_map_valid == 0) {
+		efuse_size = adapter->hw_cfg_info.efuse_size;
+
+		local_map = kzalloc(efuse_size, GFP_KERNEL);
+		if (!local_map)
+			return HALMAC_RET_MALLOC_FAIL;
+
+		status = read_efuse_88xx(adapter, 0, efuse_size, local_map);
+		if (status != HALMAC_RET_SUCCESS) {
+			pr_err("read efuse\n");
+			kfree(local_map);
+			return status;
+		}
+
+		if (!adapter->efuse_map) {
+			adapter->efuse_map = kzalloc(efuse_size, GFP_KERNEL);
+			if (!adapter->efuse_map) {
+				kfree(local_map);
+				return HALMAC_RET_MALLOC_FAIL;
+			}
+		}
+
+		mutex_lock(&adapter->efuse_mutex);
+		memcpy(adapter->efuse_map, local_map, efuse_size);
+		adapter->efuse_map_valid = 1;
+		mutex_unlock(&adapter->efuse_mutex);
+
+		kfree(local_map);
+	}
+
+	if (eeprom_parser_88xx(adapter, adapter->efuse_map, map) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_EEPROM_PARSING_FAIL;
+
+	return status;
+}
+
+static enum halmac_ret_status
+proc_pg_efuse_by_map_88xx(struct halmac_adapter *adapter,
+			  struct halmac_pg_efuse_info *info,
+			  enum halmac_efuse_read_cfg cfg)
+{
+	u8 *updated_mask = NULL;
+	u32 mask_size = adapter->hw_cfg_info.eeprom_size >> 4;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	updated_mask = kzalloc(mask_size, GFP_KERNEL);
+	if (!updated_mask)
+		return HALMAC_RET_MALLOC_FAIL;
+	memset(updated_mask, 0x00, mask_size);
+
+	status = update_eeprom_mask_88xx(adapter, info, updated_mask);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("update eeprom mask\n");
+		kfree(updated_mask);
+		return status;
+	}
+
+	status = check_efuse_enough_88xx(adapter, info, updated_mask);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("chk efuse enough\n");
+		kfree(updated_mask);
+		return status;
+	}
+
+	status = program_efuse_88xx(adapter, info, updated_mask);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("pg efuse\n");
+		kfree(updated_mask);
+		return status;
+	}
+
+	kfree(updated_mask);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+dump_efuse_drv_88xx(struct halmac_adapter *adapter)
+{
+	u8 *map = NULL;
+	u32 efuse_size = adapter->hw_cfg_info.efuse_size;
+
+	if (!adapter->efuse_map) {
+		adapter->efuse_map = kzalloc(efuse_size, GFP_KERNEL);
+		if (!adapter->efuse_map) {
+			reset_ofld_feature_88xx(adapter,
+						FEATURE_DUMP_PHY_EFUSE);
+			return HALMAC_RET_MALLOC_FAIL;
+		}
+	}
+
+	if (adapter->efuse_map_valid == 0) {
+		map = kzalloc(efuse_size, GFP_KERNEL);
+		if (!map)
+			return HALMAC_RET_MALLOC_FAIL;
+
+		if (read_hw_efuse_88xx(adapter, 0, efuse_size, map) !=
+		    HALMAC_RET_SUCCESS) {
+			kfree(map);
+			return HALMAC_RET_EFUSE_R_FAIL;
+		}
+
+		mutex_lock(&adapter->efuse_mutex);
+		memcpy(adapter->efuse_map, map, efuse_size);
+		adapter->efuse_map_valid = 1;
+		mutex_unlock(&adapter->efuse_mutex);
+
+		kfree(map);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+dump_efuse_fw_88xx(struct halmac_adapter *adapter)
+{
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = { 0 };
+	u16 seq_num = 0;
+	u32 efuse_size = adapter->hw_cfg_info.efuse_size;
+	struct halmac_h2c_header_info hdr_info;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	hdr_info.sub_cmd_id = SUB_CMD_ID_DUMP_PHYSICAL_EFUSE;
+	hdr_info.content_size = 0;
+	hdr_info.ack = 1;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+
+	adapter->halmac_state.efuse_state.seq_num = seq_num;
+
+	if (!adapter->efuse_map) {
+		adapter->efuse_map = kzalloc(efuse_size, GFP_KERNEL);
+		if (!adapter->efuse_map) {
+			reset_ofld_feature_88xx(adapter,
+						FEATURE_DUMP_PHY_EFUSE);
+			return HALMAC_RET_MALLOC_FAIL;
+		}
+	}
+
+	if (adapter->efuse_map_valid == 0) {
+		status = send_h2c_pkt_88xx(adapter, h2c_buf);
+		if (status != HALMAC_RET_SUCCESS) {
+			pr_err("send h2c pkt\n");
+			reset_ofld_feature_88xx(adapter,
+						FEATURE_DUMP_PHY_EFUSE);
+			return status;
+		}
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+proc_write_log_efuse_88xx(struct halmac_adapter *adapter, u32 offset, u8 value)
+{
+	u8 byte1;
+	u8 byte2;
+	u8 blk;
+	u8 blk_idx;
+	u8 hdr;
+	u8 hdr2;
+	u8 *map = NULL;
+	u32 eeprom_size = adapter->hw_cfg_info.eeprom_size;
+	u32 end;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	map = kzalloc(eeprom_size, GFP_KERNEL);
+	if (!map)
+		return HALMAC_RET_MALLOC_FAIL;
+	memset(map, 0xFF, eeprom_size);
+
+	status = read_log_efuse_map_88xx(adapter, map);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("read logical efuse\n");
+		kfree(map);
+		return status;
+	}
+
+	if (*(map + offset) != value) {
+		end = adapter->efuse_end;
+		blk = (u8)(offset >> 3);
+		blk_idx = (u8)((offset & (8 - 1)) >> 1);
+
+		if (offset > 0x7f) {
+			hdr = (((blk & 0x07) << 5) & 0xE0) | 0x0F;
+			hdr2 = (u8)(((blk & 0x78) << 1) +
+						((0x1 << blk_idx) ^ 0x0F));
+		} else {
+			hdr = (u8)((blk << 4) + ((0x01 << blk_idx) ^ 0x0F));
+		}
+
+		if ((offset & 1) == 0) {
+			byte1 = value;
+			byte2 = *(map + offset + 1);
+		} else {
+			byte1 = *(map + offset - 1);
+			byte2 = value;
+		}
+
+		if (offset > 0x7f) {
+			if (adapter->hw_cfg_info.efuse_size <=
+			    4 + PROTECT_EFUSE_SIZE + end) {
+				kfree(map);
+				return HALMAC_RET_EFUSE_NOT_ENOUGH;
+			}
+
+			status = write_hw_efuse_88xx(adapter, end, hdr);
+			if (status != HALMAC_RET_SUCCESS) {
+				kfree(map);
+				return status;
+			}
+
+			status = write_hw_efuse_88xx(adapter, end + 1, hdr2);
+			if (status != HALMAC_RET_SUCCESS) {
+				kfree(map);
+				return status;
+			}
+
+			status = write_hw_efuse_88xx(adapter, end + 2, byte1);
+			if (status != HALMAC_RET_SUCCESS) {
+				kfree(map);
+				return status;
+			}
+
+			status = write_hw_efuse_88xx(adapter, end + 3, byte2);
+			if (status != HALMAC_RET_SUCCESS) {
+				kfree(map);
+				return status;
+			}
+		} else {
+			if (adapter->hw_cfg_info.efuse_size <=
+			    3 + PROTECT_EFUSE_SIZE + end) {
+				kfree(map);
+				return HALMAC_RET_EFUSE_NOT_ENOUGH;
+			}
+
+			status = write_hw_efuse_88xx(adapter, end, hdr);
+			if (status != HALMAC_RET_SUCCESS) {
+				kfree(map);
+				return status;
+			}
+
+			status = write_hw_efuse_88xx(adapter, end + 1, byte1);
+			if (status != HALMAC_RET_SUCCESS) {
+				kfree(map);
+				return status;
+			}
+
+			status = write_hw_efuse_88xx(adapter, end + 2, byte2);
+			if (status != HALMAC_RET_SUCCESS) {
+				kfree(map);
+				return status;
+			}
+		}
+	}
+
+	kfree(map);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+read_efuse_88xx(struct halmac_adapter *adapter, u32 offset, u32 size, u8 *map)
+{
+	if (!map) {
+		pr_err("malloc map\n");
+		return HALMAC_RET_NULL_POINTER;
+	}
+
+	if (adapter->efuse_map_valid == 1) {
+		memcpy(map, adapter->efuse_map + offset, size);
+	} else {
+		if (read_hw_efuse_88xx(adapter, offset, size, map) !=
+		    HALMAC_RET_SUCCESS)
+			return HALMAC_RET_EFUSE_R_FAIL;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+update_eeprom_mask_88xx(struct halmac_adapter *adapter,
+			struct halmac_pg_efuse_info *info, u8 *updated_mask)
+{
+	u8 *map = NULL;
+	u8 clr_bit = 0;
+	u32 eeprom_size = adapter->hw_cfg_info.eeprom_size;
+	u8 *map_pg;
+	u8 *efuse_mask;
+	u16 i;
+	u16 j;
+	u16 map_offset;
+	u16 mask_offset;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	map = kzalloc(eeprom_size, GFP_KERNEL);
+	if (!map)
+		return HALMAC_RET_MALLOC_FAIL;
+	memset(map, 0xFF, eeprom_size);
+
+	memset(updated_mask, 0x00, info->efuse_mask_size);
+
+	status = read_log_efuse_map_88xx(adapter, map);
+
+	if (status != HALMAC_RET_SUCCESS) {
+		kfree(map);
+		return status;
+	}
+
+	map_pg = info->efuse_map;
+	efuse_mask = info->efuse_mask;
+
+	for (i = 0; i < info->efuse_mask_size; i++)
+		*(updated_mask + i) = *(efuse_mask + i);
+
+	for (i = 0; i < info->efuse_map_size; i += 16) {
+		for (j = 0; j < 16; j += 2) {
+			map_offset = i + j;
+			mask_offset = i >> 4;
+			if (*(u16 *)(map_pg + map_offset) ==
+			    *(u16 *)(map + map_offset)) {
+				switch (j) {
+				case 0:
+					clr_bit = BIT(4);
+					break;
+				case 2:
+					clr_bit = BIT(5);
+					break;
+				case 4:
+					clr_bit = BIT(6);
+					break;
+				case 6:
+					clr_bit = BIT(7);
+					break;
+				case 8:
+					clr_bit = BIT(0);
+					break;
+				case 10:
+					clr_bit = BIT(1);
+					break;
+				case 12:
+					clr_bit = BIT(2);
+					break;
+				case 14:
+					clr_bit = BIT(3);
+					break;
+				default:
+					break;
+				}
+				*(updated_mask + mask_offset) &= ~clr_bit;
+			}
+		}
+	}
+
+	kfree(map);
+
+	return status;
+}
+
+static enum halmac_ret_status
+check_efuse_enough_88xx(struct halmac_adapter *adapter,
+			struct halmac_pg_efuse_info *info, u8 *updated_mask)
+{
+	u8 pre_word_en;
+	u16 i;
+	u16 j;
+	u32 eeprom_offset;
+	u32 pg_num = 0;
+
+	for (i = 0; i < info->efuse_map_size; i = i + 8) {
+		eeprom_offset = i;
+
+		if ((eeprom_offset & 7) > 0)
+			pre_word_en = (*(updated_mask + (i >> 4)) & 0x0F);
+		else
+			pre_word_en = (*(updated_mask + (i >> 4)) >> 4);
+
+		if (pre_word_en > 0) {
+			if (eeprom_offset > 0x7f) {
+				pg_num += 2;
+				for (j = 0; j < 4; j++) {
+					if (((pre_word_en >> j) & 0x1) > 0)
+						pg_num += 2;
+				}
+			} else {
+				pg_num++;
+				for (j = 0; j < 4; j++) {
+					if (((pre_word_en >> j) & 0x1) > 0)
+						pg_num += 2;
+				}
+			}
+		}
+	}
+
+	if (adapter->hw_cfg_info.efuse_size <=
+	    (pg_num + PROTECT_EFUSE_SIZE + adapter->efuse_end))
+		return HALMAC_RET_EFUSE_NOT_ENOUGH;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+pg_extend_efuse_88xx(struct halmac_adapter *adapter,
+		     struct halmac_pg_efuse_info *info, u8 word_en,
+		     u8 pre_word_en, u32 eeprom_offset)
+{
+	u8 blk;
+	u8 hdr;
+	u8 hdr2;
+	u16 i;
+	u32 efuse_end;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	efuse_end = adapter->efuse_end;
+
+	blk = (u8)(eeprom_offset >> 3);
+	hdr = (((blk & 0x07) << 5) & 0xE0) | 0x0F;
+	hdr2 = (u8)(((blk & 0x78) << 1) + word_en);
+
+	status = write_hw_efuse_88xx(adapter, efuse_end, hdr);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("write efuse\n");
+		return status;
+	}
+
+	status = write_hw_efuse_88xx(adapter, efuse_end + 1, hdr2);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("write efuse(+1)\n");
+		return status;
+	}
+
+	efuse_end = efuse_end + 2;
+	for (i = 0; i < 4; i++) {
+		if (((pre_word_en >> i) & 0x1) > 0) {
+			status = write_hw_efuse_88xx(adapter, efuse_end,
+						     *(info->efuse_map +
+						     eeprom_offset +
+						     (i << 1)));
+			if (status != HALMAC_RET_SUCCESS) {
+				pr_err("write efuse(<<1)\n");
+				return status;
+			}
+
+			status = write_hw_efuse_88xx(adapter, efuse_end + 1,
+						     *(info->efuse_map +
+						     eeprom_offset + (i << 1)
+						     + 1));
+			if (status != HALMAC_RET_SUCCESS) {
+				pr_err("write efuse(<<1)+1\n");
+				return status;
+			}
+			efuse_end = efuse_end + 2;
+		}
+	}
+	adapter->efuse_end = efuse_end;
+	return status;
+}
+
+static enum halmac_ret_status
+proc_pg_efuse_88xx(struct halmac_adapter *adapter,
+		   struct halmac_pg_efuse_info *info, u8 word_en,
+		   u8 pre_word_en, u32 eeprom_offset)
+{
+	u8 blk;
+	u8 hdr;
+	u16 i;
+	u32 efuse_end;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	efuse_end = adapter->efuse_end;
+
+	blk = (u8)(eeprom_offset >> 3);
+	hdr = (u8)((blk << 4) + word_en);
+
+	status = write_hw_efuse_88xx(adapter, efuse_end, hdr);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("write efuse\n");
+		return status;
+	}
+	efuse_end = efuse_end + 1;
+	for (i = 0; i < 4; i++) {
+		if (((pre_word_en >> i) & 0x1) > 0) {
+			status = write_hw_efuse_88xx(adapter, efuse_end,
+						     *(info->efuse_map +
+						     eeprom_offset +
+						     (i << 1)));
+			if (status != HALMAC_RET_SUCCESS) {
+				pr_err("write efuse(<<1)\n");
+				return status;
+			}
+			status = write_hw_efuse_88xx(adapter, efuse_end + 1,
+						     *(info->efuse_map +
+						     eeprom_offset + (i << 1)
+						     + 1));
+			if (status != HALMAC_RET_SUCCESS) {
+				pr_err("write efuse(<<1)+1\n");
+				return status;
+			}
+			efuse_end = efuse_end + 2;
+		}
+	}
+	adapter->efuse_end = efuse_end;
+	return status;
+}
+
+static enum halmac_ret_status
+program_efuse_88xx(struct halmac_adapter *adapter,
+		   struct halmac_pg_efuse_info *info, u8 *updated_mask)
+{
+	u8 pre_word_en;
+	u8 word_en;
+	u16 i;
+	u32 eeprom_offset;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	for (i = 0; i < info->efuse_map_size; i = i + 8) {
+		eeprom_offset = i;
+
+		if (((eeprom_offset >> 3) & 1) > 0) {
+			pre_word_en = (*(updated_mask + (i >> 4)) & 0x0F);
+			word_en = pre_word_en ^ 0x0F;
+		} else {
+			pre_word_en = (*(updated_mask + (i >> 4)) >> 4);
+			word_en = pre_word_en ^ 0x0F;
+		}
+
+		if (pre_word_en > 0) {
+			if (eeprom_offset > 0x7f) {
+				status = pg_extend_efuse_88xx(adapter, info,
+							      word_en,
+							      pre_word_en,
+							      eeprom_offset);
+				if (status != HALMAC_RET_SUCCESS) {
+					pr_err("extend efuse\n");
+					return status;
+				}
+			} else {
+				status = proc_pg_efuse_88xx(adapter, info,
+							    word_en,
+							    pre_word_en,
+							    eeprom_offset);
+				if (status != HALMAC_RET_SUCCESS) {
+					pr_err("extend efuse");
+					return status;
+				}
+			}
+		}
+	}
+
+	return status;
+}
+
+static void
+mask_eeprom_88xx(struct halmac_adapter *adapter,
+		 struct halmac_pg_efuse_info *info)
+{
+	u8 pre_word_en;
+	u8 *updated_mask;
+	u8 *efuse_map;
+	u16 i;
+	u16 j;
+	u32 offset;
+
+	updated_mask = info->efuse_mask;
+	efuse_map = info->efuse_map;
+
+	for (i = 0; i < info->efuse_map_size; i = i + 8) {
+		offset = i;
+
+		if (((offset >> 3) & 1) > 0)
+			pre_word_en = (*(updated_mask + (i >> 4)) & 0x0F);
+		else
+			pre_word_en = (*(updated_mask + (i >> 4)) >> 4);
+
+		for (j = 0; j < 4; j++) {
+			if (((pre_word_en >> j) & 0x1) == 0) {
+				*(efuse_map + offset + (j << 1)) = 0xFF;
+				*(efuse_map + offset + (j << 1) + 1) = 0xFF;
+			}
+		}
+	}
+}
+
+enum halmac_ret_status
+get_efuse_data_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u8 seg_id;
+	u8 seg_size;
+	u8 seq_num;
+	u8 fw_rc;
+	u8 *map = NULL;
+	u32 eeprom_size = adapter->hw_cfg_info.eeprom_size;
+	struct halmac_efuse_state *state = &adapter->halmac_state.efuse_state;
+	enum halmac_cmd_process_status proc_status;
+
+	seq_num = (u8)EFUSE_DATA_GET_H2C_SEQ(buf);
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
+	seg_id = (u8)EFUSE_DATA_GET_SEGMENT_ID(buf);
+	seg_size = (u8)EFUSE_DATA_GET_SEGMENT_SIZE(buf);
+	if (seg_id == 0)
+		adapter->efuse_seg_size = seg_size;
+
+	map = kzalloc(eeprom_size, GFP_KERNEL);
+	if (!map)
+		return HALMAC_RET_MALLOC_FAIL;
+	memset(map, 0xFF, eeprom_size);
+
+	mutex_lock(&adapter->efuse_mutex);
+	memcpy(adapter->efuse_map + seg_id * adapter->efuse_seg_size,
+	       buf + C2H_DATA_OFFSET_88XX, seg_size);
+	mutex_unlock(&adapter->efuse_mutex);
+
+	if (EFUSE_DATA_GET_END_SEGMENT(buf) == 0) {
+		kfree(map);
+		return HALMAC_RET_SUCCESS;
+	}
+
+	fw_rc = state->fw_rc;
+
+	if ((enum halmac_h2c_return_code)fw_rc == HALMAC_H2C_RETURN_SUCCESS) {
+		proc_status = HALMAC_CMD_PROCESS_DONE;
+		state->proc_status = proc_status;
+
+		mutex_lock(&adapter->efuse_mutex);
+		adapter->efuse_map_valid = 1;
+		mutex_unlock(&adapter->efuse_mutex);
+
+		if (adapter->evnt.phy_efuse_map == 1) {
+			PLTFM_EVENT_SIG(FEATURE_DUMP_PHY_EFUSE,
+					proc_status, adapter->efuse_map,
+					adapter->hw_cfg_info.efuse_size);
+			adapter->evnt.phy_efuse_map = 0;
+		}
+
+		if (adapter->evnt.log_efuse_map == 1) {
+			if (eeprom_parser_88xx(adapter, adapter->efuse_map,
+					       map) != HALMAC_RET_SUCCESS) {
+				kfree(map);
+				return HALMAC_RET_EEPROM_PARSING_FAIL;
+			}
+			PLTFM_EVENT_SIG(FEATURE_DUMP_LOG_EFUSE, proc_status,
+					map, eeprom_size);
+			adapter->evnt.log_efuse_map = 0;
+		}
+	} else {
+		proc_status = HALMAC_CMD_PROCESS_ERROR;
+		state->proc_status = proc_status;
+
+		if (adapter->evnt.phy_efuse_map == 1) {
+			PLTFM_EVENT_SIG(FEATURE_DUMP_PHY_EFUSE, proc_status,
+					&state->fw_rc, 1);
+			adapter->evnt.phy_efuse_map = 0;
+		}
+
+		if (adapter->evnt.log_efuse_map == 1) {
+			PLTFM_EVENT_SIG(FEATURE_DUMP_LOG_EFUSE, proc_status,
+					&state->fw_rc, 1);
+			adapter->evnt.log_efuse_map = 0;
+		}
+	}
+
+	kfree(map);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+get_dump_phy_efuse_status_88xx(struct halmac_adapter *adapter,
+			       enum halmac_cmd_process_status *proc_status,
+			       u8 *data, u32 *size)
+{
+	u8 *map = NULL;
+	u32 efuse_size = adapter->hw_cfg_info.efuse_size;
+	struct halmac_efuse_state *state = &adapter->halmac_state.efuse_state;
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
+		if (*size < efuse_size) {
+			*size = efuse_size;
+			return HALMAC_RET_BUFFER_TOO_SMALL;
+		}
+
+		*size = efuse_size;
+
+		map = kzalloc(efuse_size, GFP_KERNEL);
+		if (!map)
+			return HALMAC_RET_MALLOC_FAIL;
+		memset(map, 0xFF, efuse_size);
+		mutex_lock(&adapter->efuse_mutex);
+		memcpy(map, adapter->efuse_map,
+		       efuse_size - PROTECT_EFUSE_SIZE);
+		memcpy(map + efuse_size - PROTECT_EFUSE_SIZE +
+		       RSVD_CS_EFUSE_SIZE,
+		       adapter->efuse_map + efuse_size - PROTECT_EFUSE_SIZE +
+		       RSVD_CS_EFUSE_SIZE,
+		       PROTECT_EFUSE_SIZE - RSVD_EFUSE_SIZE -
+		       RSVD_CS_EFUSE_SIZE);
+		mutex_unlock(&adapter->efuse_mutex);
+
+		memcpy(data, map, *size);
+
+		kfree(map);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+get_dump_log_efuse_status_88xx(struct halmac_adapter *adapter,
+			       enum halmac_cmd_process_status *proc_status,
+			       u8 *data, u32 *size)
+{
+	u8 *map = NULL;
+	u32 eeprom_size = adapter->hw_cfg_info.eeprom_size;
+	struct halmac_efuse_state *state = &adapter->halmac_state.efuse_state;
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
+		if (*size < eeprom_size) {
+			*size = eeprom_size;
+			return HALMAC_RET_BUFFER_TOO_SMALL;
+		}
+
+		*size = eeprom_size;
+
+		map = kzalloc(eeprom_size, GFP_KERNEL);
+		if (!map)
+			return HALMAC_RET_MALLOC_FAIL;
+		memset(map, 0xFF, eeprom_size);
+
+		if (eeprom_parser_88xx(adapter, adapter->efuse_map, map) !=
+		    HALMAC_RET_SUCCESS) {
+			kfree(map);
+			return HALMAC_RET_EEPROM_PARSING_FAIL;
+		}
+
+		memcpy(data, map, *size);
+
+		kfree(map);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+get_h2c_ack_phy_efuse_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u8 seq_num = 0;
+	u8 fw_rc;
+	struct halmac_efuse_state *state = &adapter->halmac_state.efuse_state;
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
+	return HALMAC_RET_SUCCESS;
+}
+
+u32
+get_rsvd_efuse_size_88xx(struct halmac_adapter *adapter)
+{
+	return PROTECT_EFUSE_SIZE;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.h
new file mode 100644
index 000000000000..2b1f0b199b76
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_efuse_88xx.h
@@ -0,0 +1,101 @@
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
+#ifndef _HALMAC_EFUSE_88XX_H_
+#define _HALMAC_EFUSE_88XX_H_
+
+#include "../halmac_api.h"
+
+enum halmac_ret_status
+dump_efuse_map_88xx(struct halmac_adapter *adapter,
+		    enum halmac_efuse_read_cfg cfg);
+
+enum halmac_ret_status
+dump_efuse_map_bt_88xx(struct halmac_adapter *adapter,
+		       enum halmac_efuse_bank bank, u32 size, u8 *map);
+
+enum halmac_ret_status
+write_efuse_bt_88xx(struct halmac_adapter *adapter, u32 offset, u8 value,
+		    enum halmac_efuse_bank bank);
+
+enum halmac_ret_status
+read_efuse_bt_88xx(struct halmac_adapter *adapter, u32 offset, u8 *value,
+		   enum halmac_efuse_bank bank);
+
+enum halmac_ret_status
+cfg_efuse_auto_check_88xx(struct halmac_adapter *adapter, u8 enable);
+
+enum halmac_ret_status
+get_efuse_available_size_88xx(struct halmac_adapter *adapter, u32 *size);
+
+enum halmac_ret_status
+get_efuse_size_88xx(struct halmac_adapter *adapter, u32 *size);
+
+enum halmac_ret_status
+get_log_efuse_size_88xx(struct halmac_adapter *adapter, u32 *size);
+
+enum halmac_ret_status
+dump_log_efuse_map_88xx(struct halmac_adapter *adapter,
+			enum halmac_efuse_read_cfg cfg);
+
+enum halmac_ret_status
+read_logical_efuse_88xx(struct halmac_adapter *adapter, u32 offset, u8 *value);
+
+enum halmac_ret_status
+write_log_efuse_88xx(struct halmac_adapter *adapter, u32 offset, u8 value);
+
+enum halmac_ret_status
+pg_efuse_by_map_88xx(struct halmac_adapter *adapter,
+		     struct halmac_pg_efuse_info *info,
+		     enum halmac_efuse_read_cfg cfg);
+
+enum halmac_ret_status
+mask_log_efuse_88xx(struct halmac_adapter *adapter,
+		    struct halmac_pg_efuse_info *info);
+
+enum halmac_ret_status
+read_efuse_88xx(struct halmac_adapter *adapter, u32 offset, u32 size, u8 *map);
+
+enum halmac_ret_status
+write_hw_efuse_88xx(struct halmac_adapter *adapter, u32 offset, u8 value);
+
+enum halmac_ret_status
+switch_efuse_bank_88xx(struct halmac_adapter *adapter,
+		       enum halmac_efuse_bank bank);
+
+enum halmac_ret_status
+get_efuse_data_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+enum halmac_ret_status
+cnv_efuse_state_88xx(struct halmac_adapter *adapter,
+		     enum halmac_cmd_construct_state dest_state);
+
+enum halmac_ret_status
+get_dump_phy_efuse_status_88xx(struct halmac_adapter *adapter,
+			       enum halmac_cmd_process_status *proc_status,
+			       u8 *data, u32 *size);
+
+enum halmac_ret_status
+get_dump_log_efuse_status_88xx(struct halmac_adapter *adapter,
+			       enum halmac_cmd_process_status *proc_status,
+			       u8 *data, u32 *size);
+
+enum halmac_ret_status
+get_h2c_ack_phy_efuse_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+u32
+get_rsvd_efuse_size_88xx(struct halmac_adapter *adapter);
+
+#endif/* _HALMAC_EFUSE_88XX_H_ */
-- 
2.15.1
