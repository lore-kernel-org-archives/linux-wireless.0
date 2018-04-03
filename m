Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:36877 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754945AbeDCHy0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 03:54:26 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 15/17] rtlwifi: halmac: add to control WiFi mac functions and registers
Date: Tue, 3 Apr 2018 15:53:30 +0800
Message-ID: <20180403075332.3344-16-pkshih@realtek.com> (sfid-20180403_095437_550517_46B865E3)
In-Reply-To: <20180403075332.3344-1-pkshih@realtek.com>
References: <20180403075332.3344-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

This commit provides WiFi mac functions to control wifi easier, and also
provides generic access entries for driver and other modules.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../halmac_8822b/halmac_cfg_wmac_8822b.c           |  144 +
 .../halmac_8822b/halmac_cfg_wmac_8822b.h           |   36 +
 .../halmac_88xx/halmac_8822b/halmac_common_8822b.c |  173 ++
 .../halmac_88xx/halmac_8822b/halmac_common_8822b.h |   32 +
 .../halmac/halmac_88xx/halmac_cfg_wmac_88xx.c      | 1158 ++++++++
 .../halmac/halmac_88xx/halmac_cfg_wmac_88xx.h      |  122 +
 .../halmac/halmac_88xx/halmac_common_88xx.c        | 2931 ++++++++++++++++++++
 .../halmac/halmac_88xx/halmac_common_88xx.h        |  151 +
 8 files changed, 4747 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_cfg_wmac_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_cfg_wmac_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_common_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_common_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_cfg_wmac_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_cfg_wmac_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_common_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_common_88xx.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_cfg_wmac_8822b.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_cfg_wmac_8822b.c
new file mode 100644
index 000000000000..7de83d7bf922
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_cfg_wmac_8822b.c
@@ -0,0 +1,144 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2017 - 2018 Realtek Corporation. All rights reserved.
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
+#include "halmac_cfg_wmac_8822b.h"
+#include "halmac_8822b_cfg.h"
+
+/**
+ * cfg_drv_info_8822b() - config driver info
+ * @adapter : the adapter of halmac
+ * @drv_info : driver information selection
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_drv_info_8822b(struct halmac_adapter *adapter,
+		   enum halmac_drv_info drv_info)
+{
+	u8 drv_info_size = 0;
+	u8 phy_status_en = 0;
+	u8 sniffer_en = 0;
+	u8 plcp_hdr_en = 0;
+	u8 value8;
+	u32 value32;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "drv info = %d\n", drv_info);
+
+	switch (drv_info) {
+	case HALMAC_DRV_INFO_NONE:
+		drv_info_size = 0;
+		phy_status_en = 0;
+		sniffer_en = 0;
+		plcp_hdr_en = 0;
+		break;
+	case HALMAC_DRV_INFO_PHY_STATUS:
+		drv_info_size = 4;
+		phy_status_en = 1;
+		sniffer_en = 0;
+		plcp_hdr_en = 0;
+		break;
+	case HALMAC_DRV_INFO_PHY_SNIFFER:
+		drv_info_size = 5; /* phy status 4byte, sniffer info 1byte */
+		phy_status_en = 1;
+		sniffer_en = 1;
+		plcp_hdr_en = 0;
+		break;
+	case HALMAC_DRV_INFO_PHY_PLCP:
+		drv_info_size = 6; /* phy status 4byte, plcp header 2byte */
+		phy_status_en = 1;
+		sniffer_en = 0;
+		plcp_hdr_en = 1;
+		break;
+	default:
+		return HALMAC_RET_SW_CASE_NOT_SUPPORT;
+	}
+
+	if (adapter->txff_alloc.rx_fifo_exp_mode !=
+	    HALMAC_RX_FIFO_EXPANDING_MODE_DISABLE)
+		drv_info_size = RX_DESC_DUMMY_SIZE_8822B >> 3;
+
+	HALMAC_REG_W8(REG_RX_DRVINFO_SZ, drv_info_size);
+
+	value8 = HALMAC_REG_R8(REG_TRXFF_BNDY + 1);
+	value8 &= 0xF0;
+	/* For rxdesc len = 0 issue */
+	value8 |= 0xF;
+	HALMAC_REG_W8(REG_TRXFF_BNDY + 1, value8);
+
+	adapter->drv_info_size = drv_info_size;
+
+	value32 = HALMAC_REG_R32(REG_RCR);
+	value32 = (value32 & (~BIT_APP_PHYSTS));
+	if (phy_status_en == 1)
+		value32 = value32 | BIT_APP_PHYSTS;
+	HALMAC_REG_W32(REG_RCR, value32);
+
+	value32 = HALMAC_REG_R32(REG_WMAC_OPTION_FUNCTION + 4);
+	value32 = (value32 & (~(BIT(8) | BIT(9))));
+	if (sniffer_en == 1)
+		value32 = value32 | BIT(9);
+	if (plcp_hdr_en == 1)
+		value32 = value32 | BIT(8);
+	HALMAC_REG_W32(REG_WMAC_OPTION_FUNCTION + 4, value32);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * init_low_pwr_8822b() - config WMAC register
+ * @adapter
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+init_low_pwr_8822b(struct halmac_adapter *adapter)
+{
+	return HALMAC_RET_SUCCESS;
+}
+
+void
+cfg_rx_ignore_8822b(struct halmac_adapter *adapter,
+		    struct halmac_mac_rx_ignore_cfg *cfg)
+{
+}
+
+enum halmac_ret_status
+cfg_ampdu_8822b(struct halmac_adapter *adapter,
+		struct halmac_ampdu_config *cfg)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (cfg->ht_max_len != cfg->vht_max_len) {
+		pr_err("max len ht != vht!!\n");
+		return HALMAC_RET_PARA_NOT_SUPPORT;
+	}
+
+	HALMAC_REG_W8(REG_PROT_MODE_CTRL + 2, cfg->max_agg_num);
+	HALMAC_REG_W8(REG_PROT_MODE_CTRL + 3, cfg->max_agg_num);
+
+	if (cfg->max_len_en == 1)
+		HALMAC_REG_W32(REG_AMPDU_MAX_LENGTH, cfg->ht_max_len);
+
+	return HALMAC_RET_SUCCESS;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_cfg_wmac_8822b.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_cfg_wmac_8822b.h
new file mode 100644
index 000000000000..36f54e74abff
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_cfg_wmac_8822b.h
@@ -0,0 +1,36 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2017 - 2018 Realtek Corporation. All rights reserved.
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
+#ifndef _HALMAC_CFG_WMAC_8822B_H_
+#define _HALMAC_CFG_WMAC_8822B_H_
+
+#include "../../halmac_api.h"
+
+enum halmac_ret_status
+cfg_drv_info_8822b(struct halmac_adapter *adapter,
+		   enum halmac_drv_info drv_info);
+
+enum halmac_ret_status
+init_low_pwr_8822b(struct halmac_adapter *adapter);
+
+void
+cfg_rx_ignore_8822b(struct halmac_adapter *adapter,
+		    struct halmac_mac_rx_ignore_cfg *cfg);
+
+enum halmac_ret_status
+cfg_ampdu_8822b(struct halmac_adapter *adapter,
+		struct halmac_ampdu_config *cfg);
+
+#endif/* _HALMAC_CFG_WMAC_8822B_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_common_8822b.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_common_8822b.c
new file mode 100644
index 000000000000..bc51d941cb0c
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_common_8822b.c
@@ -0,0 +1,173 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2017 - 2018 Realtek Corporation. All rights reserved.
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
+#include "halmac_8822b_cfg.h"
+#include "halmac_common_8822b.h"
+#include "../halmac_common_88xx.h"
+#include "halmac_cfg_wmac_8822b.h"
+
+static void
+cfg_ldo25_8822b(struct halmac_adapter *adapter, u8 enable);
+
+/**
+ * get_hw_value_8822b() -get hw config value
+ * @adapter : the adapter of halmac
+ * @hw_id : hw id for driver to query
+ * @pvalue : hw value, reference table to get data type
+ * Author : KaiYuan Chang / Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_hw_value_8822b(struct halmac_adapter *adapter, enum halmac_hw_id hw_id,
+		   void *value)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (!value) {
+		pr_err("%s (NULL ==pvalue)\n", __func__);
+		return HALMAC_RET_NULL_POINTER;
+	}
+
+	if (get_hw_value_88xx(adapter, hw_id, value) == HALMAC_RET_SUCCESS)
+		return HALMAC_RET_SUCCESS;
+
+	switch (hw_id) {
+	case HALMAC_HW_FW_MAX_SIZE:
+		*(u32 *)value = WLAN_FW_MAX_SIZE_8822B;
+		break;
+	case HALMAC_HW_SDIO_INT_LAT:
+		break;
+	case HALMAC_HW_SDIO_CLK_CNT:
+		break;
+	default:
+		return HALMAC_RET_PARA_NOT_SUPPORT;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * set_hw_value_8822b() -set hw config value
+ * @adapter : the adapter of halmac
+ * @hw_id : hw id for driver to config
+ * @pvalue : hw value, reference table to get data type
+ * Author : KaiYuan Chang / Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+set_hw_value_8822b(struct halmac_adapter *adapter, enum halmac_hw_id hw_id,
+		   void *value)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (!value) {
+		pr_err("null pointer\n");
+		return HALMAC_RET_NULL_POINTER;
+	}
+
+	if (set_hw_value_88xx(adapter, hw_id, value) == HALMAC_RET_SUCCESS)
+		return HALMAC_RET_SUCCESS;
+
+	switch (hw_id) {
+	case HALMAC_HW_AMPDU_CONFIG:
+		status = cfg_ampdu_8822b(adapter,
+					 (struct halmac_ampdu_config *)value);
+		break;
+	case HALMAC_HW_SDIO_TX_FORMAT:
+		break;
+	case HALMAC_HW_RXGCK_FIFO:
+		break;
+	case HALMAC_HW_RX_IGNORE:
+		break;
+	case HALMAC_HW_LDO25_EN:
+		cfg_ldo25_8822b(adapter, *(u8 *)value);
+		break;
+	case HALMAC_HW_PCIE_REF_AUTOK:
+		break;
+	case HALMAC_HW_SDIO_WT_EN:
+		break;
+	case HALMAC_HW_SDIO_CLK_MONITOR:
+		break;
+	default:
+		return HALMAC_RET_PARA_NOT_SUPPORT;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return status;
+}
+
+/**
+ * halmac_fill_txdesc_check_sum_88xx() -  fill in tx desc check sum
+ * @adapter : the adapter of halmac
+ * @txdesc : tx desc packet
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+fill_txdesc_check_sum_8822b(struct halmac_adapter *adapter, u8 *txdesc)
+{
+	__le16 chksum = 0;
+	__le16 *data;
+	u32 i;
+
+	if (!txdesc) {
+		pr_err("null pointer");
+		return HALMAC_RET_NULL_POINTER;
+	}
+
+	if (adapter->tx_desc_checksum != 1)
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "chksum disable");
+
+	SET_TX_DESC_TXDESC_CHECKSUM(txdesc, 0x0000);
+
+	data = (__le16 *)(txdesc);
+
+	/* HW clculates only 32byte */
+	for (i = 0; i < 8; i++)
+		chksum ^= (*(data + 2 * i) ^ *(data + (2 * i + 1)));
+
+	/* *(data + 2 * i) & *(data + (2 * i + 1) have endain issue*/
+	/* Process eniadn issue after checksum calculation */
+	SET_TX_DESC_TXDESC_CHECKSUM(txdesc, le16_to_cpu(chksum));
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static void
+cfg_ldo25_8822b(struct halmac_adapter *adapter, u8 enable)
+{
+	u8 value8;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	value8 = HALMAC_REG_R8(REG_LDO_EFUSE_CTRL + 3);
+
+	if (enable == 1)
+		HALMAC_REG_W8(REG_LDO_EFUSE_CTRL + 3, (u8)(value8 | BIT(7)));
+	else
+		HALMAC_REG_W8(REG_LDO_EFUSE_CTRL + 3, (u8)(value8 & ~BIT(7)));
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_common_8822b.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_common_8822b.h
new file mode 100644
index 000000000000..5484d1e73202
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_common_8822b.h
@@ -0,0 +1,32 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2017 - 2018 Realtek Corporation. All rights reserved.
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
+#ifndef _HALMAC_COMMON_8822B_H_
+#define _HALMAC_COMMON_8822B_H_
+
+#include "../../halmac_api.h"
+
+enum halmac_ret_status
+get_hw_value_8822b(struct halmac_adapter *adapter,
+		   enum halmac_hw_id hw_id, void *value);
+
+enum halmac_ret_status
+set_hw_value_8822b(struct halmac_adapter *adapter,
+		   enum halmac_hw_id hw_id, void *value);
+
+enum halmac_ret_status
+fill_txdesc_check_sum_8822b(struct halmac_adapter *adapter, u8 *txdesc);
+
+#endif/* _HALMAC_COMMON_8822B_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_cfg_wmac_88xx.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_cfg_wmac_88xx.c
new file mode 100644
index 000000000000..f2214cdf30a5
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_cfg_wmac_88xx.c
@@ -0,0 +1,1158 @@
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
+#include "halmac_cfg_wmac_88xx.h"
+#include "halmac_88xx_cfg.h"
+
+#define MAC_CLK_SPEED	80 /* 80M */
+
+enum mac_clock_hw_def {
+	MAC_CLK_HW_DEF_80M = 0,
+	MAC_CLK_HW_DEF_40M = 1,
+	MAC_CLK_HW_DEF_20M = 2,
+};
+
+/**
+ * cfg_mac_addr_88xx() - config mac address
+ * @adapter : the adapter of halmac
+ * @port : 0 for port0, 1 for port1, 2 for port2, 3 for port3, 4 for port4
+ * @addr : mac address
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_mac_addr_88xx(struct halmac_adapter *adapter, u8 port,
+		  union halmac_wlan_addr *addr)
+{
+	u32 offset;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (port >= HALMAC_PORTID_NUM) {
+		pr_err("port index >= 5\n");
+		return HALMAC_RET_PORT_NOT_SUPPORT;
+	}
+
+	switch (port) {
+	case HALMAC_PORTID0:
+		offset = REG_MACID;
+		break;
+	case HALMAC_PORTID1:
+		offset = REG_MACID1;
+		break;
+	case HALMAC_PORTID2:
+		offset = REG_MACID2;
+		break;
+	case HALMAC_PORTID3:
+		offset = REG_MACID3;
+		break;
+	case HALMAC_PORTID4:
+		offset = REG_MACID4;
+		break;
+	default:
+		break;
+	}
+
+	HALMAC_REG_W32(offset, le32_to_cpu(addr->addr_l_h.low));
+	HALMAC_REG_W16(offset + 4, le16_to_cpu(addr->addr_l_h.high));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_bssid_88xx() - config BSSID
+ * @adapter : the adapter of halmac
+ * @port : 0 for port0, 1 for port1, 2 for port2, 3 for port3, 4 for port4
+ * @addr : bssid
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_bssid_88xx(struct halmac_adapter *adapter, u8 port,
+	       union halmac_wlan_addr *addr)
+{
+	u32 offset;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (port >= HALMAC_PORTID_NUM) {
+		pr_err("port index > 5\n");
+		return HALMAC_RET_PORT_NOT_SUPPORT;
+	}
+
+	switch (port) {
+	case HALMAC_PORTID0:
+		offset = REG_BSSID;
+		break;
+	case HALMAC_PORTID1:
+		offset = REG_BSSID1;
+		break;
+	case HALMAC_PORTID2:
+		offset = REG_BSSID2;
+		break;
+	case HALMAC_PORTID3:
+		offset = REG_BSSID3;
+		break;
+	case HALMAC_PORTID4:
+		offset = REG_BSSID4;
+		break;
+	default:
+		break;
+	}
+
+	HALMAC_REG_W32(offset, le32_to_cpu(addr->addr_l_h.low));
+	HALMAC_REG_W16(offset + 4, le16_to_cpu(addr->addr_l_h.high));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_transmitter_addr_88xx() - config transmitter address
+ * @adapter : the adapter of halmac
+ * @port :  0 for port0, 1 for port1, 2 for port2, 3 for port3, 4 for port4
+ * @addr :
+ * Author : Alan
+ * Return : enum halmac_ret_status
+ */
+enum halmac_ret_status
+cfg_transmitter_addr_88xx(struct halmac_adapter *adapter, u8 port,
+			  union halmac_wlan_addr *addr)
+{
+	u32 offset;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (port >= HALMAC_PORTID_NUM) {
+		pr_err("port index > 5\n");
+		return HALMAC_RET_PORT_NOT_SUPPORT;
+	}
+
+	switch (port) {
+	case HALMAC_PORTID0:
+		offset = REG_TRANSMIT_ADDRSS_0;
+		break;
+	case HALMAC_PORTID1:
+		offset = REG_TRANSMIT_ADDRSS_1;
+		break;
+	case HALMAC_PORTID2:
+		offset = REG_TRANSMIT_ADDRSS_2;
+		break;
+	case HALMAC_PORTID3:
+		offset = REG_TRANSMIT_ADDRSS_3;
+		break;
+	case HALMAC_PORTID4:
+		offset = REG_TRANSMIT_ADDRSS_4;
+		break;
+	default:
+		break;
+	}
+
+	HALMAC_REG_W32(offset, le32_to_cpu(addr->addr_l_h.low));
+	HALMAC_REG_W16(offset + 4, le16_to_cpu(addr->addr_l_h.high));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_net_type_88xx() - config network type
+ * @adapter : the adapter of halmac
+ * @port :  0 for port0, 1 for port1, 2 for port2, 3 for port3, 4 for port4
+ * @addr : mac address
+ * Author : Alan
+ * Return : enum halmac_ret_status
+ */
+enum halmac_ret_status
+cfg_net_type_88xx(struct halmac_adapter *adapter, u8 port,
+		  enum halmac_network_type_select net_type)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	u8 value8 = 0;
+	u8 net_type_tmp = 0;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (net_type == HALMAC_NETWORK_AP) {
+		if (port >= HALMAC_PORTID1) {
+			pr_err("AP port > 1\n");
+			return HALMAC_RET_PORT_NOT_SUPPORT;
+		}
+	}
+
+	switch (port) {
+	case HALMAC_PORTID0:
+		net_type_tmp = net_type;
+		value8 = ((HALMAC_REG_R8(REG_CR + 2) & 0xFC) | net_type_tmp);
+		HALMAC_REG_W8(REG_CR + 2, value8);
+		break;
+	case HALMAC_PORTID1:
+		net_type_tmp = (net_type << 2);
+		value8 = ((HALMAC_REG_R8(REG_CR + 2) & 0xF3) | net_type_tmp);
+		HALMAC_REG_W8(REG_CR + 2, value8);
+		break;
+	case HALMAC_PORTID2:
+		net_type_tmp = net_type;
+		value8 = ((HALMAC_REG_R8(REG_CR_EXT) & 0xFC) | net_type_tmp);
+		HALMAC_REG_W8(REG_CR_EXT, value8);
+		break;
+	case HALMAC_PORTID3:
+		net_type_tmp = (net_type << 2);
+		value8 = ((HALMAC_REG_R8(REG_CR_EXT) & 0xF3) | net_type_tmp);
+		HALMAC_REG_W8(REG_CR_EXT, value8);
+		break;
+	case HALMAC_PORTID4:
+		net_type_tmp = (net_type << 4);
+		value8 = ((HALMAC_REG_R8(REG_CR_EXT) & 0xCF) | net_type_tmp);
+		HALMAC_REG_W8(REG_CR_EXT, value8);
+		break;
+	default:
+		break;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_tsf_rst_88xx() - tsf reset
+ * @adapter : the adapter of halmac
+ * @port :  0 for port0, 1 for port1, 2 for port2, 3 for port3, 4 for port4
+ * Author : Alan
+ * Return : enum halmac_ret_status
+ */
+enum halmac_ret_status
+cfg_tsf_rst_88xx(struct halmac_adapter *adapter, u8 port)
+{
+	u8 tsf_rst = 0;
+	u8 value8;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	switch (port) {
+	case HALMAC_PORTID0:
+		tsf_rst = BIT_TSFTR_RST;
+		break;
+	case HALMAC_PORTID1:
+		tsf_rst = BIT_TSFTR_CLI0_RST;
+		break;
+	case HALMAC_PORTID2:
+		tsf_rst = BIT_TSFTR_CLI1_RST;
+		break;
+	case HALMAC_PORTID3:
+		tsf_rst = BIT_TSFTR_CLI2_RST;
+		break;
+	case HALMAC_PORTID4:
+		tsf_rst = BIT_TSFTR_CLI3_RST;
+		break;
+	default:
+		break;
+	}
+
+	value8 = HALMAC_REG_R8(REG_DUAL_TSF_RST);
+	HALMAC_REG_W8(REG_DUAL_TSF_RST, value8 | tsf_rst);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_bcn_space_88xx() - config beacon space
+ * @adapter : the adapter of halmac
+ * @port :  0 for port0, 1 for port1, 2 for port2, 3 for port3, 4 for port4
+ * @bcn_space : beacon space
+ * Author : Alan
+ * Return : enum halmac_ret_status
+ */
+enum halmac_ret_status
+cfg_bcn_space_88xx(struct halmac_adapter *adapter, u8 port, u32 bcn_space)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	u16 bcn_space_real = 0;
+	u16 value16 = 0;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	bcn_space_real = ((u16)bcn_space);
+
+	switch (port) {
+	case HALMAC_PORTID0:
+		HALMAC_REG_W16(REG_MBSSID_BCN_SPACE, bcn_space_real);
+		break;
+	case HALMAC_PORTID1:
+		value16 = HALMAC_REG_R16(REG_MBSSID_BCN_SPACE + 2) & 0xF000;
+		value16 |= bcn_space_real;
+		HALMAC_REG_W16(REG_MBSSID_BCN_SPACE + 2, value16);
+		break;
+	case HALMAC_PORTID2:
+		value16 = HALMAC_REG_R16(REG_MBSSID_BCN_SPACE2) & 0xF000;
+		value16 |= bcn_space_real;
+		HALMAC_REG_W16(REG_MBSSID_BCN_SPACE2, value16);
+		break;
+	case HALMAC_PORTID3:
+		value16 = HALMAC_REG_R16(REG_MBSSID_BCN_SPACE2 + 2) & 0xF000;
+		value16 |= bcn_space_real;
+		HALMAC_REG_W16(REG_MBSSID_BCN_SPACE2 + 2, value16);
+		break;
+	case HALMAC_PORTID4:
+		value16 = HALMAC_REG_R16(REG_MBSSID_BCN_SPACE3) & 0xF000;
+		value16 |= bcn_space_real;
+		HALMAC_REG_W16(REG_MBSSID_BCN_SPACE3, value16);
+		break;
+	default:
+		break;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * rw_bcn_ctrl_88xx() - r/w beacon control
+ * @adapter : the adapter of halmac
+ * @port :  0 for port0, 1 for port1, 2 for port2, 3 for port3, 4 for port4
+ * @write_en : 1->write beacon function 0->read beacon function
+ * @pBcn_ctrl : beacon control info
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ */
+enum halmac_ret_status
+rw_bcn_ctrl_88xx(struct halmac_adapter *adapter, u8 port, u8 write_en,
+		 struct halmac_bcn_ctrl *ctrl)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	u8 ctrl_value = 0;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (write_en) {
+		if (ctrl->dis_rx_bssid_fit == 1)
+			ctrl_value |= BIT_DIS_RX_BSSID_FIT;
+
+		if (ctrl->en_txbcn_rpt == 1)
+			ctrl_value |= BIT_P0_EN_TXBCN_RPT;
+
+		if (ctrl->dis_tsf_udt == 1)
+			ctrl_value |= BIT_DIS_TSF_UDT;
+
+		if (ctrl->en_bcn == 1)
+			ctrl_value |= BIT_EN_BCN_FUNCTION;
+
+		if (ctrl->en_rxbcn_rpt == 1)
+			ctrl_value |= BIT_P0_EN_RXBCN_RPT;
+
+		if (ctrl->en_p2p_ctwin == 1)
+			ctrl_value |= BIT_EN_P2P_CTWINDOW;
+
+		if (ctrl->en_p2p_bcn_area == 1)
+			ctrl_value |= BIT_EN_P2P_BCNQ_AREA;
+
+		switch (port) {
+		case HALMAC_PORTID0:
+			HALMAC_REG_W8(REG_BCN_CTRL, ctrl_value);
+			break;
+		case HALMAC_PORTID1:
+			HALMAC_REG_W8(REG_BCN_CTRL_CLINT0, ctrl_value);
+			break;
+		case HALMAC_PORTID2:
+			HALMAC_REG_W8(REG_BCN_CTRL_CLINT1, ctrl_value);
+			break;
+		case HALMAC_PORTID3:
+			HALMAC_REG_W8(REG_BCN_CTRL_CLINT2, ctrl_value);
+			break;
+		case HALMAC_PORTID4:
+			HALMAC_REG_W8(REG_BCN_CTRL_CLINT3, ctrl_value);
+			break;
+		default:
+			break;
+		}
+
+	} else {
+		switch (port) {
+		case HALMAC_PORTID0:
+			ctrl_value = HALMAC_REG_R8(REG_BCN_CTRL);
+			break;
+		case HALMAC_PORTID1:
+			ctrl_value = HALMAC_REG_R8(REG_BCN_CTRL_CLINT0);
+			break;
+		case HALMAC_PORTID2:
+			ctrl_value = HALMAC_REG_R8(REG_BCN_CTRL_CLINT1);
+			break;
+		case HALMAC_PORTID3:
+			ctrl_value = HALMAC_REG_R8(REG_BCN_CTRL_CLINT2);
+			break;
+		case HALMAC_PORTID4:
+			ctrl_value = HALMAC_REG_R8(REG_BCN_CTRL_CLINT3);
+			break;
+		default:
+			break;
+		}
+
+		if (ctrl_value & BIT_EN_P2P_BCNQ_AREA)
+			ctrl->en_p2p_bcn_area = 1;
+		else
+			ctrl->en_p2p_bcn_area = 0;
+
+		if (ctrl_value & BIT_EN_P2P_CTWINDOW)
+			ctrl->en_p2p_ctwin = 1;
+		else
+			ctrl->en_p2p_ctwin = 0;
+
+		if (ctrl_value & BIT_P0_EN_RXBCN_RPT)
+			ctrl->en_rxbcn_rpt = 1;
+		else
+			ctrl->en_rxbcn_rpt = 0;
+
+		if (ctrl_value & BIT_EN_BCN_FUNCTION)
+			ctrl->en_bcn = 1;
+		else
+			ctrl->en_bcn = 0;
+
+		if (ctrl_value & BIT_DIS_TSF_UDT)
+			ctrl->dis_tsf_udt = 1;
+		else
+			ctrl->dis_tsf_udt = 0;
+
+		if (ctrl_value & BIT_P0_EN_TXBCN_RPT)
+			ctrl->en_txbcn_rpt = 1;
+		else
+			ctrl->en_txbcn_rpt = 0;
+
+		if (ctrl_value & BIT_DIS_RX_BSSID_FIT)
+			ctrl->dis_rx_bssid_fit = 1;
+		else
+			ctrl->dis_rx_bssid_fit = 0;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_multicast_addr_88xx() - config multicast address
+ * @adapter : the adapter of halmac
+ * @addr : multicast address
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_multicast_addr_88xx(struct halmac_adapter *adapter,
+			union halmac_wlan_addr *addr)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	HALMAC_REG_W32(REG_MAR, le32_to_cpu(addr->addr_l_h.low));
+	HALMAC_REG_W16(REG_MAR + 4, le16_to_cpu(addr->addr_l_h.high));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_operation_mode_88xx() - config operation mode
+ * @adapter : the adapter of halmac
+ * @mode : 802.11 standard(b/g/n/ac)
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_operation_mode_88xx(struct halmac_adapter *adapter,
+			enum halmac_wireless_mode mode)
+{
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_ch_bw_88xx() - config channel & bandwidth
+ * @adapter : the adapter of halmac
+ * @ch : WLAN channel, support 2.4G & 5G
+ * @idx : primary channel index, idx1, idx2, idx3, idx4
+ * @bw : band width, 20, 40, 80, 160, 5 ,10
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_ch_bw_88xx(struct halmac_adapter *adapter, u8 ch,
+	       enum halmac_pri_ch_idx idx, enum halmac_bw bw)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	cfg_pri_ch_idx_88xx(adapter, idx);
+	cfg_bw_88xx(adapter, bw);
+	cfg_ch_88xx(adapter, ch);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+cfg_ch_88xx(struct halmac_adapter *adapter, u8 ch)
+{
+	u8 value8;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	value8 = HALMAC_REG_R8(REG_CCK_CHECK);
+	value8 = value8 & (~(BIT(7)));
+
+	if (ch > 35)
+		value8 = value8 | BIT(7);
+
+	HALMAC_REG_W8(REG_CCK_CHECK, value8);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+cfg_pri_ch_idx_88xx(struct halmac_adapter *adapter, enum halmac_pri_ch_idx idx)
+{
+	u8 txsc40 = 0, txsc20 = 0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	txsc20 = idx;
+	if (txsc20 == HALMAC_CH_IDX_1 || txsc20 == HALMAC_CH_IDX_3)
+		txsc40 = 9;
+	else
+		txsc40 = 10;
+
+	HALMAC_REG_W8(REG_DATA_SC, BIT_TXSC_20M(txsc20) | BIT_TXSC_40M(txsc40));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_bw_88xx() - config bandwidth
+ * @adapter : the adapter of halmac
+ * @bw : band width, 20, 40, 80, 160, 5 ,10
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_bw_88xx(struct halmac_adapter *adapter, enum halmac_bw bw)
+{
+	u32 value32;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	value32 = HALMAC_REG_R32(REG_WMAC_TRXPTCL_CTL);
+	value32 = value32 & (~(BIT(7) | BIT(8)));
+
+	switch (bw) {
+	case HALMAC_BW_80:
+		value32 = value32 | BIT(7);
+		break;
+	case HALMAC_BW_40:
+		value32 = value32 | BIT(8);
+		break;
+	case HALMAC_BW_20:
+	case HALMAC_BW_10:
+	case HALMAC_BW_5:
+		break;
+	default:
+		break;
+	}
+
+	HALMAC_REG_W32(REG_WMAC_TRXPTCL_CTL, value32);
+
+	/* TODO:Move to change mac clk api later... */
+	value32 = HALMAC_REG_R32(REG_AFE_CTRL1) & ~(BIT(20) | BIT(21));
+	value32 |= (MAC_CLK_HW_DEF_80M << BIT_SHIFT_MAC_CLK_SEL);
+	HALMAC_REG_W32(REG_AFE_CTRL1, value32);
+
+	HALMAC_REG_W8(REG_USTIME_TSF, MAC_CLK_SPEED);
+	HALMAC_REG_W8(REG_USTIME_EDCA, MAC_CLK_SPEED);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+void
+enable_bb_rf_88xx(struct halmac_adapter *adapter, u8 enable)
+{
+	u8 value8;
+	u32 value32;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (enable == 1) {
+		value8 = HALMAC_REG_R8(REG_SYS_FUNC_EN);
+		value8 = value8 | BIT(0) | BIT(1);
+		HALMAC_REG_W8(REG_SYS_FUNC_EN, value8);
+
+		value8 = HALMAC_REG_R8(REG_RF_CTRL);
+		value8 = value8 | BIT(0) | BIT(1) | BIT(2);
+		HALMAC_REG_W8(REG_RF_CTRL, value8);
+
+		value32 = HALMAC_REG_R32(REG_WLRF1);
+		value32 = value32 | BIT(24) | BIT(25) | BIT(26);
+		HALMAC_REG_W32(REG_WLRF1, value32);
+	} else {
+		value8 = HALMAC_REG_R8(REG_SYS_FUNC_EN);
+		value8 = value8 & (~(BIT(0) | BIT(1)));
+		HALMAC_REG_W8(REG_SYS_FUNC_EN, value8);
+
+		value8 = HALMAC_REG_R8(REG_RF_CTRL);
+		value8 = value8 & (~(BIT(0) | BIT(1) | BIT(2)));
+		HALMAC_REG_W8(REG_RF_CTRL, value8);
+
+		value32 = HALMAC_REG_R32(REG_WLRF1);
+		value32 = value32 & (~(BIT(24) | BIT(25) | BIT(26)));
+		HALMAC_REG_W32(REG_WLRF1, value32);
+	}
+}
+
+/**
+ * cfg_la_mode_88xx() - config la mode
+ * @adapter : the adapter of halmac
+ * @mode :
+ *	disable : no TXFF space reserved for LA debug
+ *	partial : partial TXFF space is reserved for LA debug
+ *	full : all TXFF space is reserved for LA debug
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_la_mode_88xx(struct halmac_adapter *adapter, enum halmac_la_mode mode)
+{
+	if (adapter->api_registry.la_mode_en == 0)
+		return HALMAC_RET_NOT_SUPPORT;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	adapter->txff_alloc.la_mode = mode;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_rxfifo_expand_mode_88xx() - rx fifo expanding
+ * @adapter : the adapter of halmac
+ * @mode :
+ *	disable : normal mode
+ *	1 block : Rx FIFO + 1 FIFO block; Tx fifo - 1 FIFO block
+ *	2 block : Rx FIFO + 2 FIFO block; Tx fifo - 2 FIFO block
+ *	3 block : Rx FIFO + 3 FIFO block; Tx fifo - 3 FIFO block
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_rxfifo_expand_mode_88xx(struct halmac_adapter *adapter,
+			    enum halmac_rx_fifo_expanding_mode mode)
+{
+	if (adapter->api_registry.rx_exp_en == 0)
+		return HALMAC_RET_NOT_SUPPORT;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	adapter->txff_alloc.rx_fifo_exp_mode = mode;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+config_security_88xx(struct halmac_adapter *adapter,
+		     struct halmac_security_setting *setting)
+{
+	u8 sec_cfg;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	HALMAC_REG_W16_SET(REG_CR, BIT_MAC_SEC_EN);
+
+	if (setting->compare_keyid == 1) {
+		HALMAC_REG_W8_SET(REG_SECCFG + 1, BIT(0));
+		adapter->hw_cfg_info.chk_security_keyid = 1;
+	} else {
+		adapter->hw_cfg_info.chk_security_keyid = 0;
+	}
+
+	sec_cfg = HALMAC_REG_R8(REG_SECCFG);
+
+	/* BC/MC uses default key */
+	/* cam entry 0~3, kei id = 0 -> entry0, kei id = 1 -> entry1... */
+	sec_cfg |= (BIT_TXBCUSEDK | BIT_RXBCUSEDK);
+
+	if (setting->tx_encryption == 1)
+		sec_cfg |= BIT_TXENC;
+	else
+		sec_cfg &= ~BIT_TXENC;
+
+	if (setting->rx_decryption == 1)
+		sec_cfg |= BIT_RXDEC;
+	else
+		sec_cfg &= ~BIT_RXDEC;
+
+	HALMAC_REG_W8(REG_SECCFG, sec_cfg);
+
+	if (setting->bip_enable == 1) {
+		if (adapter->chip_id == HALMAC_CHIP_ID_8822B)
+			return HALMAC_RET_BIP_NO_SUPPORT;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+u8
+get_used_cam_entry_num_88xx(struct halmac_adapter *adapter,
+			    enum hal_security_type sec_type)
+{
+	u8 entry_num;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	switch (sec_type) {
+	case HAL_SECURITY_TYPE_WEP40:
+	case HAL_SECURITY_TYPE_WEP104:
+	case HAL_SECURITY_TYPE_TKIP:
+	case HAL_SECURITY_TYPE_AES128:
+	case HAL_SECURITY_TYPE_GCMP128:
+	case HAL_SECURITY_TYPE_GCMSMS4:
+	case HAL_SECURITY_TYPE_BIP:
+		entry_num = 1;
+		break;
+	case HAL_SECURITY_TYPE_WAPI:
+	case HAL_SECURITY_TYPE_AES256:
+	case HAL_SECURITY_TYPE_GCMP256:
+		entry_num = 2;
+		break;
+	default:
+		entry_num = 0;
+		break;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return entry_num;
+}
+
+enum halmac_ret_status
+write_cam_88xx(struct halmac_adapter *adapter, u32 idx,
+	       struct halmac_cam_entry_info *info)
+{
+	u32 i;
+	u32 cmd = 0x80010000;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	struct halmac_cam_entry_format *fmt = NULL;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (idx >= adapter->hw_cfg_info.cam_entry_num)
+		return HALMAC_RET_ENTRY_INDEX_ERROR;
+
+	if (info->key_id > 3)
+		return HALMAC_RET_FAIL;
+
+	fmt = kzalloc(sizeof(*fmt), GFP_KERNEL);
+	if (!fmt)
+		return HALMAC_RET_NULL_POINTER;
+	memset(fmt, 0x00, sizeof(*fmt));
+
+	if (adapter->hw_cfg_info.chk_security_keyid == 1)
+		fmt->key_id = info->key_id;
+	fmt->valid = info->valid;
+	memcpy(fmt->mac_address, info->mac_address, 6);
+	memcpy(fmt->key, info->key, 16);
+
+	switch (info->security_type) {
+	case HAL_SECURITY_TYPE_NONE:
+		fmt->type = 0;
+		break;
+	case HAL_SECURITY_TYPE_WEP40:
+		fmt->type = 1;
+		break;
+	case HAL_SECURITY_TYPE_WEP104:
+		fmt->type = 5;
+		break;
+	case HAL_SECURITY_TYPE_TKIP:
+		fmt->type = 2;
+		break;
+	case HAL_SECURITY_TYPE_AES128:
+		fmt->type = 4;
+		break;
+	case HAL_SECURITY_TYPE_WAPI:
+		fmt->type = 6;
+		break;
+	case HAL_SECURITY_TYPE_AES256:
+		fmt->type = 4;
+		fmt->ext_sectype = 1;
+		break;
+	case HAL_SECURITY_TYPE_GCMP128:
+		fmt->type = 7;
+		break;
+	case HAL_SECURITY_TYPE_GCMP256:
+	case HAL_SECURITY_TYPE_GCMSMS4:
+		fmt->type = 7;
+		fmt->ext_sectype = 1;
+		break;
+	case HAL_SECURITY_TYPE_BIP:
+		fmt->type = (info->unicast == 1) ? 4 : 0;
+		fmt->mgnt = 1;
+		fmt->grp = (info->unicast == 1) ? 0 : 1;
+		break;
+	default:
+		kfree(fmt);
+		return HALMAC_RET_FAIL;
+	}
+
+	for (i = 0; i < 8; i++) {
+		HALMAC_REG_W32(REG_CAMWRITE, *((u32 *)fmt + i));
+		HALMAC_REG_W32(REG_CAMCMD, cmd | ((idx << 3) + i));
+	}
+
+	if (info->security_type == HAL_SECURITY_TYPE_WAPI ||
+	    info->security_type == HAL_SECURITY_TYPE_AES256 ||
+	    info->security_type == HAL_SECURITY_TYPE_GCMP256 ||
+	    info->security_type == HAL_SECURITY_TYPE_GCMSMS4) {
+		fmt->mic = 1;
+		memcpy(fmt->key, info->key_ext, 16);
+		idx++;
+		for (i = 0; i < 8; i++) {
+			HALMAC_REG_W32(REG_CAMWRITE, *((u32 *)fmt + i));
+			HALMAC_REG_W32(REG_CAMCMD, cmd | ((idx << 3) + i));
+		}
+	}
+
+	kfree(fmt);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+read_cam_entry_88xx(struct halmac_adapter *adapter, u32 idx,
+		    struct halmac_cam_entry_format *content)
+{
+	u32 i;
+	u32 cmd = 0x80000000;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (idx >= adapter->hw_cfg_info.cam_entry_num)
+		return HALMAC_RET_ENTRY_INDEX_ERROR;
+
+	for (i = 0; i < 8; i++) {
+		HALMAC_REG_W32(REG_CAMCMD, cmd | ((idx << 3) + i));
+		*((u32 *)content + i) = HALMAC_REG_R32(REG_CAMREAD);
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+clear_cam_entry_88xx(struct halmac_adapter *adapter, u32 idx)
+{
+	u32 i;
+	u32 cmd = 0x80010000;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	struct halmac_cam_entry_format *fmt = NULL;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (idx >= adapter->hw_cfg_info.cam_entry_num)
+		return HALMAC_RET_ENTRY_INDEX_ERROR;
+
+	fmt = kzalloc(sizeof(*fmt), GFP_KERNEL);
+	if (!fmt)
+		return HALMAC_RET_NULL_POINTER;
+	memset(fmt, 0x00, sizeof(*fmt));
+
+	for (i = 0; i < 8; i++) {
+		HALMAC_REG_W32(REG_CAMWRITE, *((u32 *)fmt + i));
+		HALMAC_REG_W32(REG_CAMCMD, cmd | ((idx << 3) + i));
+	}
+
+	kfree(fmt);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+void
+rx_shift_88xx(struct halmac_adapter *adapter, u8 enable)
+{
+	u8 value8;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	value8 = HALMAC_REG_R8(REG_TXDMA_PQ_MAP);
+
+	if (enable == 1)
+		HALMAC_REG_W8(REG_TXDMA_PQ_MAP, value8 | BIT(1));
+	else
+		HALMAC_REG_W8(REG_TXDMA_PQ_MAP, value8 & ~(BIT(1)));
+}
+
+/**
+ * cfg_edca_para_88xx() - config edca parameter
+ * @adapter : the adapter of halmac
+ * @acq_id : VO/VI/BE/BK
+ * @param : aifs, cw, txop limit
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_edca_para_88xx(struct halmac_adapter *adapter, enum halmac_acq_id acq_id,
+		   struct halmac_edca_para *param)
+{
+	u32 offset;
+	u32 value32;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	switch (acq_id) {
+	case HALMAC_ACQ_ID_VO:
+		offset = REG_EDCA_VO_PARAM;
+		break;
+	case HALMAC_ACQ_ID_VI:
+		offset = REG_EDCA_VI_PARAM;
+		break;
+	case HALMAC_ACQ_ID_BE:
+		offset = REG_EDCA_BE_PARAM;
+		break;
+	case HALMAC_ACQ_ID_BK:
+		offset = REG_EDCA_BK_PARAM;
+		break;
+	default:
+		return HALMAC_RET_SWITCH_CASE_ERROR;
+	}
+
+	param->txop_limit &= 0x7FF;
+	value32 = (param->aifs) | (param->cw << 8) | (param->txop_limit << 16);
+
+	HALMAC_REG_W32(offset, value32);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+void
+rx_clk_gate_88xx(struct halmac_adapter *adapter, u8 enable)
+{
+	u8 value8;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	value8 = HALMAC_REG_R8(REG_RCR + 2);
+
+	if (enable == 1)
+		HALMAC_REG_W8(REG_RCR + 2, value8 & ~(BIT(3)));
+	else
+		HALMAC_REG_W8(REG_RCR + 2, value8 | BIT(3));
+}
+
+enum halmac_ret_status
+rx_cut_amsdu_cfg_88xx(struct halmac_adapter *adapter,
+		      struct halmac_cut_amsdu_cfg *cfg)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+enum halmac_ret_status
+fast_edca_cfg_88xx(struct halmac_adapter *adapter,
+		   struct halmac_fast_edca_cfg *cfg)
+{
+	u16 value16;
+	u32 offset;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	switch (cfg->acq_id) {
+	case HALMAC_ACQ_ID_VO:
+		offset = REG_FAST_EDCA_VOVI_SETTING;
+		break;
+	case HALMAC_ACQ_ID_VI:
+		offset = REG_FAST_EDCA_VOVI_SETTING + 2;
+		break;
+	case HALMAC_ACQ_ID_BE:
+		offset = REG_FAST_EDCA_BEBK_SETTING;
+		break;
+	case HALMAC_ACQ_ID_BK:
+		offset = REG_FAST_EDCA_BEBK_SETTING + 2;
+		break;
+	default:
+		return HALMAC_RET_SWITCH_CASE_ERROR;
+	}
+
+	value16 = HALMAC_REG_R16(offset);
+	value16 &= 0xFF;
+	value16 = value16 | (cfg->queue_to << 8);
+
+	HALMAC_REG_W16(offset, value16);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * get_mac_addr_88xx() - get mac address
+ * @adapter : the adapter of halmac
+ * @port : 0 for port0, 1 for port1, 2 for port2, 3 for port3, 4 for port4
+ * @addr : mac address
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_mac_addr_88xx(struct halmac_adapter *adapter, u8 port,
+		  union halmac_wlan_addr *addr)
+{
+	u16 mac_addr_h;
+	u32 mac_addr_l;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (port >= HALMAC_PORTID_NUM) {
+		pr_err("port index >= 5\n");
+		return HALMAC_RET_PORT_NOT_SUPPORT;
+	}
+
+	switch (port) {
+	case HALMAC_PORTID0:
+		mac_addr_l = HALMAC_REG_R32(REG_MACID);
+		mac_addr_h = HALMAC_REG_R16(REG_MACID + 4);
+		break;
+	case HALMAC_PORTID1:
+		mac_addr_l = HALMAC_REG_R32(REG_MACID1);
+		mac_addr_h = HALMAC_REG_R16(REG_MACID1 + 4);
+		break;
+	case HALMAC_PORTID2:
+		mac_addr_l = HALMAC_REG_R32(REG_MACID2);
+		mac_addr_h = HALMAC_REG_R16(REG_MACID2 + 4);
+		break;
+	case HALMAC_PORTID3:
+		mac_addr_l = HALMAC_REG_R32(REG_MACID3);
+		mac_addr_h = HALMAC_REG_R16(REG_MACID3 + 4);
+		break;
+	case HALMAC_PORTID4:
+		mac_addr_l = HALMAC_REG_R32(REG_MACID4);
+		mac_addr_h = HALMAC_REG_R16(REG_MACID4 + 4);
+		break;
+	default:
+		return HALMAC_RET_PORT_NOT_SUPPORT;
+	}
+
+	addr->addr_l_h.low = cpu_to_le32(mac_addr_l);
+	addr->addr_l_h.high = cpu_to_le16(mac_addr_h);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+void
+rts_full_bw_88xx(struct halmac_adapter *adapter, u8 enable)
+{
+	u8 value8;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	value8 = HALMAC_REG_R8(REG_INIRTS_RATE_SEL);
+
+	if (enable == 1)
+		HALMAC_REG_W8(REG_INIRTS_RATE_SEL, value8 | BIT(5));
+	else
+		HALMAC_REG_W8(REG_INIRTS_RATE_SEL, value8 & ~(BIT(5)));
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_cfg_wmac_88xx.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_cfg_wmac_88xx.h
new file mode 100644
index 000000000000..b06ee29dd22c
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_cfg_wmac_88xx.h
@@ -0,0 +1,122 @@
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
+#ifndef _HALMAC_CFG_WMAC_88XX_H_
+#define _HALMAC_CFG_WMAC_88XX_H_
+
+#include "../halmac_api.h"
+
+enum halmac_ret_status
+cfg_mac_addr_88xx(struct halmac_adapter *adapter, u8 port,
+		  union halmac_wlan_addr *addr);
+
+enum halmac_ret_status
+cfg_bssid_88xx(struct halmac_adapter *adapter, u8 port,
+	       union halmac_wlan_addr *addr);
+
+enum halmac_ret_status
+cfg_transmitter_addr_88xx(struct halmac_adapter *adapter, u8 port,
+			  union halmac_wlan_addr *addr);
+
+enum halmac_ret_status
+cfg_net_type_88xx(struct halmac_adapter *adapter, u8 port,
+		  enum halmac_network_type_select net_type);
+
+enum halmac_ret_status
+cfg_tsf_rst_88xx(struct halmac_adapter *adapter, u8 port);
+
+enum halmac_ret_status
+cfg_bcn_space_88xx(struct halmac_adapter *adapter, u8 port, u32 bcn_space);
+
+enum halmac_ret_status
+rw_bcn_ctrl_88xx(struct halmac_adapter *adapter, u8 port, u8 write_en,
+		 struct halmac_bcn_ctrl *ctrl);
+
+enum halmac_ret_status
+cfg_multicast_addr_88xx(struct halmac_adapter *adapter,
+			union halmac_wlan_addr *addr);
+
+enum halmac_ret_status
+cfg_operation_mode_88xx(struct halmac_adapter *adapter,
+			enum halmac_wireless_mode mode);
+
+enum halmac_ret_status
+cfg_ch_bw_88xx(struct halmac_adapter *adapter, u8 ch,
+	       enum halmac_pri_ch_idx idx, enum halmac_bw bw);
+
+enum halmac_ret_status
+cfg_ch_88xx(struct halmac_adapter *adapter, u8 ch);
+
+enum halmac_ret_status
+cfg_pri_ch_idx_88xx(struct halmac_adapter *adapter, enum halmac_pri_ch_idx idx);
+
+enum halmac_ret_status
+cfg_bw_88xx(struct halmac_adapter *adapter, enum halmac_bw bw);
+
+void
+enable_bb_rf_88xx(struct halmac_adapter *adapter, u8 enable);
+
+enum halmac_ret_status
+cfg_la_mode_88xx(struct halmac_adapter *adapter, enum halmac_la_mode mode);
+
+enum halmac_ret_status
+cfg_rxfifo_expand_mode_88xx(struct halmac_adapter *adapter,
+			    enum halmac_rx_fifo_expanding_mode mode);
+
+enum halmac_ret_status
+config_security_88xx(struct halmac_adapter *adapter,
+		     struct halmac_security_setting *setting);
+
+u8
+get_used_cam_entry_num_88xx(struct halmac_adapter *adapter,
+			    enum hal_security_type sec_type);
+
+enum halmac_ret_status
+write_cam_88xx(struct halmac_adapter *adapter, u32 idx,
+	       struct halmac_cam_entry_info *info);
+
+enum halmac_ret_status
+read_cam_entry_88xx(struct halmac_adapter *adapter, u32 idx,
+		    struct halmac_cam_entry_format *content);
+
+enum halmac_ret_status
+clear_cam_entry_88xx(struct halmac_adapter *adapter, u32 idx);
+
+void
+rx_shift_88xx(struct halmac_adapter *adapter, u8 enable);
+
+enum halmac_ret_status
+cfg_edca_para_88xx(struct halmac_adapter *adapter, enum halmac_acq_id acq_id,
+		   struct halmac_edca_para *param);
+
+void
+rx_clk_gate_88xx(struct halmac_adapter *adapter, u8 enable);
+
+enum halmac_ret_status
+rx_cut_amsdu_cfg_88xx(struct halmac_adapter *adapter,
+		      struct halmac_cut_amsdu_cfg *cfg);
+
+enum halmac_ret_status
+fast_edca_cfg_88xx(struct halmac_adapter *adapter,
+		   struct halmac_fast_edca_cfg *cfg);
+
+enum halmac_ret_status
+get_mac_addr_88xx(struct halmac_adapter *adapter, u8 port,
+		  union halmac_wlan_addr *addr);
+
+void
+rts_full_bw_88xx(struct halmac_adapter *adapter, u8 enable);
+
+#endif/* _HALMAC_CFG_WMAC_88XX_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_common_88xx.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_common_88xx.c
new file mode 100644
index 000000000000..e1b83c887bb9
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_common_88xx.c
@@ -0,0 +1,2931 @@
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
+#include "halmac_common_88xx.h"
+#include "halmac_88xx_cfg.h"
+#include "halmac_init_88xx.h"
+#include "halmac_cfg_wmac_88xx.h"
+#include "halmac_efuse_88xx.h"
+#include "halmac_bb_rf_88xx.h"
+#include "halmac_usb_88xx.h"
+#include "halmac_sdio_88xx.h"
+#include "halmac_pcie_88xx.h"
+#include "halmac_mimo_88xx.h"
+
+#define CFG_PARAM_H2C_INFO_SIZE	12
+#define ORIGINAL_H2C_CMD_SIZE	8
+
+#define WLHDR_PROT_VER	0
+
+#define WLHDR_TYPE_MGMT		0
+#define WLHDR_TYPE_CTRL		1
+#define WLHDR_TYPE_DATA		2
+
+/* mgmt frame */
+#define WLHDR_SUB_TYPE_ASSOC_REQ	0
+#define WLHDR_SUB_TYPE_ASSOC_RSPNS	1
+#define WLHDR_SUB_TYPE_REASSOC_REQ	2
+#define WLHDR_SUB_TYPE_REASSOC_RSPNS	3
+#define WLHDR_SUB_TYPE_PROBE_REQ	4
+#define WLHDR_SUB_TYPE_PROBE_RSPNS	5
+#define WLHDR_SUB_TYPE_BCN		8
+#define WLHDR_SUB_TYPE_DISASSOC		10
+#define WLHDR_SUB_TYPE_AUTH		11
+#define WLHDR_SUB_TYPE_DEAUTH		12
+#define WLHDR_SUB_TYPE_ACTION		13
+#define WLHDR_SUB_TYPE_ACTION_NOACK	14
+
+/* ctrl frame */
+#define WLHDR_SUB_TYPE_BF_RPT_POLL	4
+#define WLHDR_SUB_TYPE_NDPA		5
+
+/* data frame */
+#define WLHDR_SUB_TYPE_DATA		0
+#define WLHDR_SUB_TYPE_NULL		4
+#define WLHDR_SUB_TYPE_QOS_DATA		8
+#define WLHDR_SUB_TYPE_QOS_NULL		12
+
+#define LTECOEX_ACCESS_CTRL REG_WL2LTECOEX_INDIRECT_ACCESS_CTRL_V1
+
+struct wlhdr_frame_ctrl {
+	u16 protocol:2;
+	u16 type:2;
+	u16 sub_type:4;
+	u16 to_ds:1;
+	u16 from_ds:1;
+	u16 more_frag:1;
+	u16 retry:1;
+	u16 pwr_mgmt:1;
+	u16 more_data:1;
+	u16 protect_frame:1;
+	u16 order:1;
+};
+
+static enum halmac_ret_status
+parse_c2h_pkt_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+static enum halmac_ret_status
+get_c2h_dbg_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+static enum halmac_ret_status
+get_h2c_ack_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+static enum halmac_ret_status
+get_scan_rpt_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+static enum halmac_ret_status
+get_h2c_ack_cfg_param_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+static enum halmac_ret_status
+get_h2c_ack_update_pkt_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+static enum halmac_ret_status
+get_h2c_ack_update_datapkt_88xx(struct halmac_adapter *adapter, u8 *buf,
+				u32 size);
+
+static enum halmac_ret_status
+get_h2c_ack_run_datapkt_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+static enum halmac_ret_status
+get_h2c_ack_ch_switch_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+static enum halmac_ret_status
+malloc_cfg_param_buf_88xx(struct halmac_adapter *adapter, u8 full_fifo);
+
+static enum halmac_cmd_construct_state
+cfg_param_cmd_cnstr_state_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+proc_cfg_param_88xx(struct halmac_adapter *adapter,
+		    struct halmac_phy_parameter_info *param, u8 full_fifo);
+
+static enum halmac_ret_status
+send_cfg_param_h2c_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+cnv_cfg_param_state_88xx(struct halmac_adapter *adapter,
+			 enum halmac_cmd_construct_state dest_state);
+
+static enum halmac_ret_status
+add_param_buf_88xx(struct halmac_adapter *adapter,
+		   struct halmac_phy_parameter_info *param, u8 *buf,
+		   u8 *end_cmd);
+
+static enum halmac_ret_status
+gen_cfg_param_h2c_88xx(struct halmac_adapter *adapter, u8 *buff);
+
+static enum halmac_ret_status
+send_h2c_update_packet_88xx(struct halmac_adapter *adapter,
+			    enum halmac_packet_id pkt_id, u8 *pkt, u32 size);
+
+static enum halmac_ret_status
+send_bt_coex_cmd_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size,
+		      u8 ack);
+
+static enum halmac_ret_status
+read_buf_88xx(struct halmac_adapter *adapter, u32 offset, u32 size,
+	      enum hal_fifo_sel sel, u8 *data);
+
+static enum halmac_cmd_construct_state
+scan_cmd_cnstr_state_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+cnv_scan_state_88xx(struct halmac_adapter *adapter,
+		    enum halmac_cmd_construct_state dest_state);
+
+static enum halmac_ret_status
+proc_ctrl_ch_switch_88xx(struct halmac_adapter *adapter,
+			 struct halmac_ch_switch_option *opt);
+
+static enum halmac_ret_status
+proc_p2pps_88xx(struct halmac_adapter *adapter, struct halmac_p2pps *info);
+
+static enum halmac_ret_status
+get_cfg_param_status_88xx(struct halmac_adapter *adapter,
+			  enum halmac_cmd_process_status *proc_status);
+
+static enum halmac_ret_status
+get_ch_switch_status_88xx(struct halmac_adapter *adapter,
+			  enum halmac_cmd_process_status *proc_status);
+
+static enum halmac_ret_status
+get_update_packet_status_88xx(struct halmac_adapter *adapter,
+			      enum halmac_cmd_process_status *proc_status);
+
+static enum halmac_ret_status
+pwr_sub_seq_parser_88xx(struct halmac_adapter *adapter, u8 cut, u8 intf,
+			struct halmac_wlan_pwr_cfg *cmd);
+
+static void
+pwr_state_88xx(struct halmac_adapter *adapter, enum halmac_mac_power *state);
+
+static enum halmac_ret_status
+pwr_cmd_polling_88xx(struct halmac_adapter *adapter,
+		     struct halmac_wlan_pwr_cfg *cmd);
+
+static void
+get_pq_mapping_88xx(struct halmac_adapter *adapter,
+		    struct halmac_rqpn_map *mapping);
+
+static void
+dump_reg_sdio_88xx(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+wlhdr_valid_88xx(struct halmac_adapter *adapter, u8 *buf);
+
+static u8
+wlhdr_mgmt_valid_88xx(struct halmac_adapter *adapter,
+		      struct wlhdr_frame_ctrl *wlhdr);
+
+static u8
+wlhdr_ctrl_valid_88xx(struct halmac_adapter *adapter,
+		      struct wlhdr_frame_ctrl *wlhdr);
+
+static u8
+wlhdr_data_valid_88xx(struct halmac_adapter *adapter,
+		      struct wlhdr_frame_ctrl *wlhdr);
+
+static void
+dump_reg_88xx(struct halmac_adapter *adapter);
+
+/**
+ * ofld_func_cfg_88xx() - config offload function
+ * @adapter : the adapter of halmac
+ * @info : offload function information
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+ofld_func_cfg_88xx(struct halmac_adapter *adapter,
+		   struct halmac_ofld_func_info *info)
+{
+	if (adapter->intf == HALMAC_INTERFACE_SDIO &&
+	    info->rsvd_pg_drv_buf_max_sz > SDIO_TX_MAX_SIZE_88XX)
+		return HALMAC_RET_FAIL;
+
+	adapter->pltfm_info.malloc_size = info->halmac_malloc_max_sz;
+	adapter->pltfm_info.rsvd_pg_size = info->rsvd_pg_drv_buf_max_sz;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * dl_drv_rsvd_page_88xx() - download packet to rsvd page
+ * @adapter : the adapter of halmac
+ * @pg_offset : page offset of driver's rsvd page
+ * @halmac_buf : data to be downloaded, tx_desc is not included
+ * @halmac_size : data size to be downloaded
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+dl_drv_rsvd_page_88xx(struct halmac_adapter *adapter, u8 pg_offset, u8 *buf,
+		      u32 size)
+{
+	enum halmac_ret_status status;
+	u32 pg_size;
+	u32 pg_num = 0;
+	u16 pg_addr = 0;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	pg_size = adapter->hw_cfg_info.page_size;
+	pg_num = size / pg_size + ((size & (pg_size - 1)) ? 1 : 0);
+	if (pg_offset + pg_num > adapter->txff_alloc.rsvd_drv_pg_num) {
+		pr_err("pkt overflow!!\n");
+		return HALMAC_RET_DRV_DL_ERR;
+	}
+
+	pg_addr = adapter->txff_alloc.rsvd_drv_addr + pg_offset;
+
+	status = dl_rsvd_page_88xx(adapter, pg_addr, buf, size);
+
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("dl rsvd page fail!!\n");
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
+dl_rsvd_page_88xx(struct halmac_adapter *adapter, u16 pg_addr, u8 *buf,
+		  u32 size)
+{
+	u8 restore[2];
+	u8 value8;
+	u16 rsvd_pg_head;
+	u32 cnt;
+	enum halmac_rsvd_pg_state *state = &adapter->halmac_state.rsvd_pg_state;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (size == 0) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "pkt size = 0\n");
+		return HALMAC_RET_ZERO_LEN_RSVD_PACKET;
+	}
+
+	if (*state == HALMAC_RSVD_PG_STATE_BUSY)
+		return HALMAC_RET_BUSY_STATE;
+
+	*state = HALMAC_RSVD_PG_STATE_BUSY;
+
+	pg_addr &= BIT_MASK_BCN_HEAD_1_V1;
+	HALMAC_REG_W16(REG_FIFOPAGE_CTRL_2, (u16)(pg_addr | BIT(15)));
+
+	value8 = HALMAC_REG_R8(REG_CR + 1);
+	restore[0] = value8;
+	value8 = (u8)(value8 | BIT(0));
+	HALMAC_REG_W8(REG_CR + 1, value8);
+
+	value8 = HALMAC_REG_R8(REG_FWHW_TXQ_CTRL + 2);
+	restore[1] = value8;
+	value8 = (u8)(value8 & ~(BIT(6)));
+	HALMAC_REG_W8(REG_FWHW_TXQ_CTRL + 2, value8);
+
+	if (PLTFM_SEND_RSVD_PAGE(buf, size) == 0) {
+		pr_err("send rvsd pg(pltfm)!!\n");
+		status = HALMAC_RET_DL_RSVD_PAGE_FAIL;
+		goto DL_RSVD_PG_END;
+	}
+
+	cnt = 1000;
+	while (!(HALMAC_REG_R8(REG_FIFOPAGE_CTRL_2 + 1) & BIT(7))) {
+		usleep_range(10, 20);
+		cnt--;
+		if (cnt == 0) {
+			pr_err("bcn valid!!\n");
+			status = HALMAC_RET_POLLING_BCN_VALID_FAIL;
+			break;
+		}
+	}
+DL_RSVD_PG_END:
+	rsvd_pg_head = adapter->txff_alloc.rsvd_boundary;
+	HALMAC_REG_W16(REG_FIFOPAGE_CTRL_2, rsvd_pg_head | BIT(15));
+	HALMAC_REG_W8(REG_FWHW_TXQ_CTRL + 2, restore[1]);
+	HALMAC_REG_W8(REG_CR + 1, restore[0]);
+
+	*state = HALMAC_RSVD_PG_STATE_IDLE;
+
+	return status;
+}
+
+enum halmac_ret_status
+get_hw_value_88xx(struct halmac_adapter *adapter, enum halmac_hw_id hw_id,
+		  void *value)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	switch (hw_id) {
+	case HALMAC_HW_RQPN_MAPPING:
+		get_pq_mapping_88xx(adapter, (struct halmac_rqpn_map *)value);
+		break;
+	case HALMAC_HW_EFUSE_SIZE:
+		*(u32 *)value = adapter->hw_cfg_info.efuse_size;
+		break;
+	case HALMAC_HW_EEPROM_SIZE:
+		*(u32 *)value = adapter->hw_cfg_info.eeprom_size;
+		break;
+	case HALMAC_HW_BT_BANK_EFUSE_SIZE:
+		*(u32 *)value = adapter->hw_cfg_info.bt_efuse_size;
+		break;
+	case HALMAC_HW_BT_BANK1_EFUSE_SIZE:
+	case HALMAC_HW_BT_BANK2_EFUSE_SIZE:
+		*(u32 *)value = 0;
+		break;
+	case HALMAC_HW_TXFIFO_SIZE:
+		*(u32 *)value = adapter->hw_cfg_info.tx_fifo_size;
+		break;
+	case HALMAC_HW_RXFIFO_SIZE:
+		*(u32 *)value = adapter->hw_cfg_info.rx_fifo_size;
+		break;
+	case HALMAC_HW_RSVD_PG_BNDY:
+		*(u16 *)value = adapter->txff_alloc.rsvd_drv_addr;
+		break;
+	case HALMAC_HW_CAM_ENTRY_NUM:
+		*(u8 *)value = adapter->hw_cfg_info.cam_entry_num;
+		break;
+	case HALMAC_HW_WLAN_EFUSE_AVAILABLE_SIZE:
+		get_efuse_available_size_88xx(adapter, (u32 *)value);
+		break;
+	case HALMAC_HW_IC_VERSION:
+		*(u8 *)value = adapter->chip_ver;
+		break;
+	case HALMAC_HW_PAGE_SIZE:
+		*(u32 *)value = adapter->hw_cfg_info.page_size;
+		break;
+	case HALMAC_HW_TX_AGG_ALIGN_SIZE:
+		*(u16 *)value = adapter->hw_cfg_info.tx_align_size;
+		break;
+	case HALMAC_HW_RX_AGG_ALIGN_SIZE:
+		*(u8 *)value = 8;
+		break;
+	case HALMAC_HW_DRV_INFO_SIZE:
+		*(u8 *)value = adapter->drv_info_size;
+		break;
+	case HALMAC_HW_TXFF_ALLOCATION:
+		memcpy(value, &adapter->txff_alloc,
+		       sizeof(struct halmac_txff_allocation));
+		break;
+	case HALMAC_HW_RSVD_EFUSE_SIZE:
+		*(u32 *)value = get_rsvd_efuse_size_88xx(adapter);
+		break;
+	case HALMAC_HW_FW_HDR_SIZE:
+		*(u32 *)value = WLAN_FW_HDR_SIZE;
+		break;
+	case HALMAC_HW_TX_DESC_SIZE:
+		*(u32 *)value = adapter->hw_cfg_info.txdesc_size;
+		break;
+	case HALMAC_HW_RX_DESC_SIZE:
+		*(u32 *)value = adapter->hw_cfg_info.rxdesc_size;
+		break;
+	case HALMAC_HW_ORI_H2C_SIZE:
+		*(u32 *)value = ORIGINAL_H2C_CMD_SIZE;
+		break;
+	case HALMAC_HW_RSVD_DRV_PGNUM:
+		*(u16 *)value = adapter->txff_alloc.rsvd_drv_pg_num;
+		break;
+	case HALMAC_HW_TX_PAGE_SIZE:
+		*(u16 *)value = TX_PAGE_SIZE_88XX;
+		break;
+	case HALMAC_HW_USB_TXAGG_DESC_NUM:
+		*(u8 *)value = adapter->hw_cfg_info.usb_txagg_num;
+		break;
+	case HALMAC_HW_AC_OQT_SIZE:
+		*(u8 *)value = adapter->hw_cfg_info.ac_oqt_size;
+		break;
+	case HALMAC_HW_NON_AC_OQT_SIZE:
+		*(u8 *)value = adapter->hw_cfg_info.non_ac_oqt_size;
+		break;
+	case HALMAC_HW_AC_QUEUE_NUM:
+		*(u8 *)value = adapter->hw_cfg_info.acq_num;
+		break;
+	case HALMAC_HW_PWR_STATE:
+		pwr_state_88xx(adapter, (enum halmac_mac_power *)value);
+		break;
+	default:
+		return HALMAC_RET_PARA_NOT_SUPPORT;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static void
+get_pq_mapping_88xx(struct halmac_adapter *adapter,
+		    struct halmac_rqpn_map *mapping)
+{
+	mapping->dma_map_vo = adapter->pq_map[HALMAC_PQ_MAP_VO];
+	mapping->dma_map_vi = adapter->pq_map[HALMAC_PQ_MAP_VI];
+	mapping->dma_map_be = adapter->pq_map[HALMAC_PQ_MAP_BE];
+	mapping->dma_map_bk = adapter->pq_map[HALMAC_PQ_MAP_BK];
+	mapping->dma_map_mg = adapter->pq_map[HALMAC_PQ_MAP_MG];
+	mapping->dma_map_hi = adapter->pq_map[HALMAC_PQ_MAP_HI];
+}
+
+/**
+ * set_hw_value_88xx() -set hw config value
+ * @adapter : the adapter of halmac
+ * @hw_id : hw id for driver to config
+ * @value : hw value, reference table to get data type
+ * Author : KaiYuan Chang / Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+set_hw_value_88xx(struct halmac_adapter *adapter, enum halmac_hw_id hw_id,
+		  void *value)
+{
+	enum halmac_ret_status status;
+	struct halmac_tx_page_threshold_info *th_info;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (!value) {
+		pr_err("null ptr-set hw value\n");
+		return HALMAC_RET_NULL_POINTER;
+	}
+
+	switch (hw_id) {
+	case HALMAC_HW_USB_MODE:
+		status = set_usb_mode_88xx(adapter,
+					   *(enum halmac_usb_mode *)value);
+		if (status != HALMAC_RET_SUCCESS)
+			return status;
+		break;
+	case HALMAC_HW_BANDWIDTH:
+		cfg_bw_88xx(adapter, *(enum halmac_bw *)value);
+		break;
+	case HALMAC_HW_CHANNEL:
+		cfg_ch_88xx(adapter, *(u8 *)value);
+		break;
+	case HALMAC_HW_PRI_CHANNEL_IDX:
+		cfg_pri_ch_idx_88xx(adapter, *(enum halmac_pri_ch_idx *)value);
+		break;
+	case HALMAC_HW_EN_BB_RF:
+		enable_bb_rf_88xx(adapter, *(u8 *)value);
+		break;
+	case HALMAC_HW_SDIO_TX_PAGE_THRESHOLD:
+		if (adapter->intf == HALMAC_INTERFACE_SDIO) {
+			th_info = (struct halmac_tx_page_threshold_info *)value;
+			cfg_sdio_tx_page_threshold_88xx(adapter, th_info);
+		} else {
+			return HALMAC_RET_FAIL;
+		}
+		break;
+	case HALMAC_HW_RX_SHIFT:
+		rx_shift_88xx(adapter, *(u8 *)value);
+		break;
+	case HALMAC_HW_TXDESC_CHECKSUM:
+		tx_desc_chksum_88xx(adapter, *(u8 *)value);
+		break;
+	case HALMAC_HW_RX_CLK_GATE:
+		rx_clk_gate_88xx(adapter, *(u8 *)value);
+		break;
+	case HALMAC_HW_FAST_EDCA:
+		fast_edca_cfg_88xx(adapter,
+				   (struct halmac_fast_edca_cfg *)value);
+		break;
+	case HALMAC_HW_RTS_FULL_BW:
+		rts_full_bw_88xx(adapter, *(u8 *)value);
+		break;
+	case HALMAC_HW_FREE_CNT_EN:
+		HALMAC_REG_W8_SET(REG_MISC_CTRL, BIT_EN_FREECNT);
+		break;
+	default:
+		return HALMAC_RET_PARA_NOT_SUPPORT;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+set_h2c_pkt_hdr_88xx(struct halmac_adapter *adapter, u8 *hdr,
+		     struct halmac_h2c_header_info *info, u16 *seq_num)
+{
+	u16 total_size;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s!!\n",
+		 __func__);
+
+	total_size = H2C_PKT_HDR_SIZE_88XX + info->content_size;
+	FW_OFFLOAD_H2C_SET_TOTAL_LEN(hdr, total_size);
+	FW_OFFLOAD_H2C_SET_SUB_CMD_ID(hdr, info->sub_cmd_id);
+
+	FW_OFFLOAD_H2C_SET_CATEGORY(hdr, 0x01);
+	FW_OFFLOAD_H2C_SET_CMD_ID(hdr, 0xFF);
+
+	mutex_lock(&adapter->h2c_seq_mutex);
+	FW_OFFLOAD_H2C_SET_SEQ_NUM(hdr, adapter->h2c_info.seq_num);
+	*seq_num = adapter->h2c_info.seq_num;
+	(adapter->h2c_info.seq_num)++;
+	mutex_unlock(&adapter->h2c_seq_mutex);
+
+	if (info->ack == 1)
+		FW_OFFLOAD_H2C_SET_ACK(hdr, 1);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+send_h2c_pkt_88xx(struct halmac_adapter *adapter, u8 *pkt)
+{
+	u32 cnt = 100;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	while (adapter->h2c_info.buf_fs <= H2C_PKT_SIZE_88XX) {
+		get_h2c_buf_free_space_88xx(adapter);
+		cnt--;
+		if (cnt == 0) {
+			pr_err("h2c free space!!\n");
+			return HALMAC_RET_H2C_SPACE_FULL;
+		}
+	}
+
+	cnt = 100;
+	do {
+		if (PLTFM_SEND_H2C_PKT(pkt, H2C_PKT_SIZE_88XX) == 1)
+			break;
+		cnt--;
+		if (cnt == 0) {
+			pr_err("pltfm - sned h2c pkt!!\n");
+			return HALMAC_RET_SEND_H2C_FAIL;
+		}
+		udelay(5);
+
+	} while (1);
+
+	adapter->h2c_info.buf_fs -= H2C_PKT_SIZE_88XX;
+
+	return status;
+}
+
+enum halmac_ret_status
+get_h2c_buf_free_space_88xx(struct halmac_adapter *adapter)
+{
+	u32 hw_wptr;
+	u32 fw_rptr;
+	struct halmac_h2c_info *info = &adapter->h2c_info;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	hw_wptr = HALMAC_REG_R32(REG_H2C_PKT_WRITEADDR) & 0x3FFFF;
+	fw_rptr = HALMAC_REG_R32(REG_H2C_PKT_READADDR) & 0x3FFFF;
+
+	if (hw_wptr >= fw_rptr)
+		info->buf_fs = info->buf_size - (hw_wptr - fw_rptr);
+	else
+		info->buf_fs = fw_rptr - hw_wptr;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * get_c2h_info_88xx() - process halmac C2H packet
+ * @adapter : the adapter of halmac
+ * @buf : RX Packet pointer
+ * @size : RX Packet size
+ *
+ * Note : Don't use any IO or DELAY in this API
+ *
+ * Author : KaiYuan Chang/Ivan Lin
+ *
+ * Used to process c2h packet info from RX path. After receiving the packet,
+ * user need to call this api and pass the packet pointer.
+ *
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_c2h_info_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (GET_RX_DESC_C2H(buf) == 1) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "Parse c2h pkt\n");
+
+		status = parse_c2h_pkt_88xx(adapter, buf, size);
+		if (status != HALMAC_RET_SUCCESS) {
+			pr_err("Parse c2h pkt\n");
+			return status;
+		}
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+parse_c2h_pkt_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u8 cmd_id;
+	u8 sub_cmd_id;
+	u8 *c2h_pkt = buf + adapter->hw_cfg_info.rxdesc_size;
+	u32 c2h_size = size - adapter->hw_cfg_info.rxdesc_size;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	cmd_id = (u8)C2H_HDR_GET_CMD_ID(c2h_pkt);
+
+	if (cmd_id != 0xFF) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "Not 0xFF cmd!!\n");
+		return HALMAC_RET_C2H_NOT_HANDLED;
+	}
+
+	sub_cmd_id = (u8)C2H_HDR_GET_C2H_SUB_CMD_ID(c2h_pkt);
+
+	switch (sub_cmd_id) {
+	case C2H_SUB_CMD_ID_C2H_DBG:
+		status = get_c2h_dbg_88xx(adapter, c2h_pkt, c2h_size);
+		break;
+	case C2H_SUB_CMD_ID_H2C_ACK_HDR:
+		status = get_h2c_ack_88xx(adapter, c2h_pkt, c2h_size);
+		break;
+	case C2H_SUB_CMD_ID_BT_COEX_INFO:
+		status = HALMAC_RET_C2H_NOT_HANDLED;
+		break;
+	case C2H_SUB_CMD_ID_SCAN_STATUS_RPT:
+		status = get_scan_rpt_88xx(adapter, c2h_pkt, c2h_size);
+		break;
+	case C2H_SUB_CMD_ID_PSD_DATA:
+		status = get_psd_data_88xx(adapter, c2h_pkt, c2h_size);
+		break;
+	case C2H_SUB_CMD_ID_EFUSE_DATA:
+		status = get_efuse_data_88xx(adapter, c2h_pkt, c2h_size);
+		break;
+	default:
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "Sub cmd id!!\n");
+		status = HALMAC_RET_C2H_NOT_HANDLED;
+		break;
+	}
+
+	return status;
+}
+
+static enum halmac_ret_status
+get_c2h_dbg_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u8 i;
+	u8 next_msg = 0;
+	u8 cur_msg = 0;
+	u8 msg_len = 0;
+	char *c2h_buf = (char *)NULL;
+	u8 content_len = 0;
+	u8 seq_num = 0;
+
+	content_len = (u8)C2H_HDR_GET_LEN((u8 *)buf);
+
+	if (content_len > C2H_DBG_CONTENT_MAX_LENGTH) {
+		pr_err("c2h size > max len!\n");
+		return HALMAC_RET_C2H_NOT_HANDLED;
+	}
+
+	for (i = 0; i < content_len; i++) {
+		if (*(buf + C2H_DBG_HDR_LEN + i) == '\n') {
+			if ((*(buf + C2H_DBG_HDR_LEN + i + 1) == '\0') ||
+			    (*(buf + C2H_DBG_HDR_LEN + i + 1) == 0xff)) {
+				next_msg = C2H_DBG_HDR_LEN + i + 1;
+				goto _ENDFOUND;
+			}
+		}
+	}
+
+_ENDFOUND:
+	msg_len = next_msg - C2H_DBG_HDR_LEN;
+
+	c2h_buf = kzalloc(msg_len, GFP_KERNEL);
+	if (!c2h_buf)
+		return HALMAC_RET_MALLOC_FAIL;
+
+	memcpy(c2h_buf, buf + C2H_DBG_HDR_LEN, msg_len);
+
+	seq_num = (u8)(*(c2h_buf));
+	*(c2h_buf + msg_len - 1) = '\0';
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "[RTKFW, SEQ=%d]: %s\n", seq_num, (char *)(c2h_buf + 1));
+	kfree(c2h_buf);
+
+	while (*(buf + next_msg) != '\0') {
+		cur_msg = next_msg;
+
+		msg_len = (u8)(*(buf + cur_msg + 3)) - 1;
+		next_msg += C2H_DBG_HDR_LEN + msg_len;
+
+		c2h_buf = kzalloc(msg_len, GFP_KERNEL);
+		if (!c2h_buf)
+			return HALMAC_RET_MALLOC_FAIL;
+
+		memcpy(c2h_buf, buf + cur_msg + C2H_DBG_HDR_LEN, msg_len);
+		*(c2h_buf + msg_len - 1) = '\0';
+		seq_num = (u8)(*(c2h_buf));
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "[RTKFW, SEQ=%d]: %s\n", seq_num,
+			 (char *)(c2h_buf + 1));
+		kfree(c2h_buf);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+get_h2c_ack_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u8 cmd_id;
+	u8 sub_cmd_id;
+	u8 fw_rc;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "Ack for C2H!!\n");
+
+	fw_rc = (u8)H2C_ACK_HDR_GET_H2C_RETURN_CODE(buf);
+	if (HALMAC_H2C_RETURN_SUCCESS != (enum halmac_h2c_return_code)fw_rc)
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "fw rc = %d\n", fw_rc);
+
+	cmd_id = (u8)H2C_ACK_HDR_GET_H2C_CMD_ID(buf);
+
+	if (cmd_id != 0xFF) {
+		pr_err("h2c ack cmd id!!\n");
+		return HALMAC_RET_C2H_NOT_HANDLED;
+	}
+
+	sub_cmd_id = (u8)H2C_ACK_HDR_GET_H2C_SUB_CMD_ID(buf);
+
+	switch (sub_cmd_id) {
+	case H2C_SUB_CMD_ID_DUMP_PHYSICAL_EFUSE_ACK:
+		status = get_h2c_ack_phy_efuse_88xx(adapter, buf, size);
+		break;
+	case H2C_SUB_CMD_ID_CFG_PARAM_ACK:
+		status = get_h2c_ack_cfg_param_88xx(adapter, buf, size);
+		break;
+	case H2C_SUB_CMD_ID_UPDATE_PKT_ACK:
+		status = get_h2c_ack_update_pkt_88xx(adapter, buf, size);
+		break;
+	case H2C_SUB_CMD_ID_UPDATE_DATAPACK_ACK:
+		status = get_h2c_ack_update_datapkt_88xx(adapter, buf, size);
+		break;
+	case H2C_SUB_CMD_ID_RUN_DATAPACK_ACK:
+		status = get_h2c_ack_run_datapkt_88xx(adapter, buf, size);
+		break;
+	case H2C_SUB_CMD_ID_CH_SWITCH_ACK:
+		status = get_h2c_ack_ch_switch_88xx(adapter, buf, size);
+		break;
+	case H2C_SUB_CMD_ID_IQK_ACK:
+		status = get_h2c_ack_iqk_88xx(adapter, buf, size);
+		break;
+	case H2C_SUB_CMD_ID_PWR_TRK_ACK:
+		status = get_h2c_ack_pwr_trk_88xx(adapter, buf, size);
+		break;
+	case H2C_SUB_CMD_ID_PSD_ACK:
+		break;
+	case H2C_SUB_CMD_ID_FW_SNDING_ACK:
+		status = get_h2c_ack_fw_snding_88xx(adapter, buf, size);
+		break;
+	default:
+		status = HALMAC_RET_C2H_NOT_HANDLED;
+		break;
+	}
+
+	return status;
+}
+
+static enum halmac_ret_status
+get_scan_rpt_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u8 fw_rc;
+	enum halmac_cmd_process_status proc_status;
+
+	fw_rc = (u8)SCAN_STATUS_RPT_GET_H2C_RETURN_CODE(buf);
+	proc_status = (HALMAC_H2C_RETURN_SUCCESS ==
+		(enum halmac_h2c_return_code)fw_rc) ?
+		HALMAC_CMD_PROCESS_DONE : HALMAC_CMD_PROCESS_ERROR;
+
+	PLTFM_EVENT_SIG(HALMAC_FEATURE_CHANNEL_SWITCH, proc_status, NULL, 0);
+
+	adapter->halmac_state.scan_state.proc_status = proc_status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "scan : %X\n",
+		 proc_status);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+get_h2c_ack_cfg_param_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u8 seq_num;
+	u8 fw_rc;
+	u32 offset_accum;
+	u32 value_accum;
+	struct halmac_cfg_param_state *state =
+		&adapter->halmac_state.cfg_param_state;
+	enum halmac_cmd_process_status proc_status =
+		HALMAC_CMD_PROCESS_UNDEFINE;
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
+	offset_accum = CFG_PARAM_ACK_GET_OFFSET_ACCUMULATION(buf);
+	value_accum = CFG_PARAM_ACK_GET_VALUE_ACCUMULATION(buf);
+
+	if (offset_accum != adapter->cfg_param_info.offset_accum ||
+	    value_accum != adapter->cfg_param_info.value_accum) {
+		pr_err("[C2H]offset_accu : %x, value_accu : %xn", offset_accum,
+		       value_accum);
+		pr_err("[Ada]offset_accu : %x, value_accu : %x\n",
+		       adapter->cfg_param_info.offset_accum,
+		       adapter->cfg_param_info.value_accum);
+		proc_status = HALMAC_CMD_PROCESS_ERROR;
+	}
+
+	if ((enum halmac_h2c_return_code)fw_rc == HALMAC_H2C_RETURN_SUCCESS &&
+	    proc_status != HALMAC_CMD_PROCESS_ERROR) {
+		proc_status = HALMAC_CMD_PROCESS_DONE;
+		state->proc_status = proc_status;
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_CFG_PARA, proc_status, NULL, 0);
+	} else {
+		proc_status = HALMAC_CMD_PROCESS_ERROR;
+		state->proc_status = proc_status;
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_CFG_PARA, proc_status,
+				&fw_rc, 1);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+get_h2c_ack_update_pkt_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u8 seq_num;
+	u8 fw_rc;
+	struct halmac_update_pkt_state *state =
+		&adapter->halmac_state.update_pkt_state;
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
+	if (HALMAC_H2C_RETURN_SUCCESS == (enum halmac_h2c_return_code)fw_rc) {
+		proc_status = HALMAC_CMD_PROCESS_DONE;
+		state->proc_status = proc_status;
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_UPDATE_PACKET, proc_status,
+				NULL, 0);
+	} else {
+		proc_status = HALMAC_CMD_PROCESS_ERROR;
+		state->proc_status = proc_status;
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_UPDATE_PACKET, proc_status,
+				&state->fw_rc, 1);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+get_h2c_ack_update_datapkt_88xx(struct halmac_adapter *adapter, u8 *buf,
+				u32 size)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+static enum halmac_ret_status
+get_h2c_ack_run_datapkt_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+static enum halmac_ret_status
+get_h2c_ack_ch_switch_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u8 seq_num;
+	u8 fw_rc;
+	struct halmac_scan_state *state = &adapter->halmac_state.scan_state;
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
+		proc_status = HALMAC_CMD_PROCESS_RCVD;
+		state->proc_status = proc_status;
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_CHANNEL_SWITCH, proc_status,
+				NULL, 0);
+	} else {
+		proc_status = HALMAC_CMD_PROCESS_ERROR;
+		state->proc_status = proc_status;
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_CHANNEL_SWITCH, proc_status,
+				&fw_rc, 1);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * mac_debug_88xx_v1() - read some registers for debug
+ * @adapter
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ */
+enum halmac_ret_status
+mac_debug_88xx(struct halmac_adapter *adapter)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (adapter->intf == HALMAC_INTERFACE_SDIO)
+		dump_reg_sdio_88xx(adapter);
+	else
+		dump_reg_88xx(adapter);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static void
+dump_reg_sdio_88xx(struct halmac_adapter *adapter)
+{
+	u8 tmp8;
+	u32 i;
+
+	/* Dump CCCR, it needs new platform api */
+
+	/*Dump SDIO Local Register, use CMD52*/
+	for (i = 0x10250000; i < 0x102500ff; i++) {
+		tmp8 = PLTFM_SDIO_CMD52_R(i);
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "dbg-sdio[%x]=%x\n", i, tmp8);
+	}
+
+	/*Dump MAC Register*/
+	for (i = 0x0000; i < 0x17ff; i++) {
+		tmp8 = PLTFM_SDIO_CMD52_R(i);
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "dbg-mac[%x]=%x\n", i, tmp8);
+	}
+
+	tmp8 = PLTFM_SDIO_CMD52_R(REG_SDIO_CRC_ERR_IDX);
+	if (tmp8)
+		pr_err("sdio crc=%x\n", tmp8);
+
+	/*Check RX Fifo status*/
+	i = REG_RXFF_PTR_V1;
+	tmp8 = PLTFM_SDIO_CMD52_R(i);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "dbg-mac[%x]=%x\n", i, tmp8);
+	i = REG_RXFF_WTR_V1;
+	tmp8 = PLTFM_SDIO_CMD52_R(i);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "dbg-mac[%x]=%x\n", i, tmp8);
+	i = REG_RXFF_PTR_V1;
+	tmp8 = PLTFM_SDIO_CMD52_R(i);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "dbg-mac[%x]=%x\n", i, tmp8);
+	i = REG_RXFF_WTR_V1;
+	tmp8 = PLTFM_SDIO_CMD52_R(i);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "dbg-mac[%x]=%x\n", i, tmp8);
+}
+
+static void
+dump_reg_88xx(struct halmac_adapter *adapter)
+{
+	u32 tmp32;
+	u32 i;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	/*Dump MAC Register*/
+	for (i = 0x0000; i < 0x17fc; i += 4) {
+		tmp32 = HALMAC_REG_R32(i);
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "dbg-mac[%x]=%x\n", i, tmp32);
+	}
+
+	/*Check RX Fifo status*/
+	i = REG_RXFF_PTR_V1;
+	tmp32 = HALMAC_REG_R32(i);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "dbg-mac[%x]=%x\n", i, tmp32);
+	i = REG_RXFF_WTR_V1;
+	tmp32 = HALMAC_REG_R32(i);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "dbg-mac[%x]=%x\n", i, tmp32);
+	i = REG_RXFF_PTR_V1;
+	tmp32 = HALMAC_REG_R32(i);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "dbg-mac[%x]=%x\n", i, tmp32);
+	i = REG_RXFF_WTR_V1;
+	tmp32 = HALMAC_REG_R32(i);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "dbg-mac[%x]=%x\n", i, tmp32);
+}
+
+/**
+ * cfg_parameter_88xx() - config parameter by FW
+ * @adapter : the adapter of halmac
+ * @info : cmd id, content
+ * @full_fifo : parameter information
+ *
+ * If msk_en = 1, the format of array is {reg_info, mask, value}.
+ * If msk_en =_FAUSE, the format of array is {reg_info, value}
+ * The format of reg_info is
+ * reg_info[31]=rf_reg, 0: MAC_BB reg, 1: RF reg
+ * reg_info[27:24]=rf_path, 0: path_A, 1: path_B
+ * if rf_reg=0(MAC_BB reg), rf_path is meaningless.
+ * ref_info[15:0]=offset
+ *
+ * Example: msk_en = 0
+ * {0x8100000a, 0x00001122}
+ * =>Set RF register, path_B, offset 0xA to 0x00001122
+ * {0x00000824, 0x11224433}
+ * =>Set MAC_BB register, offset 0x800 to 0x11224433
+ *
+ * Note : full fifo mode only for init flow
+ *
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_parameter_88xx(struct halmac_adapter *adapter,
+		   struct halmac_phy_parameter_info *info, u8 full_fifo)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_cmd_process_status *proc_status;
+	enum halmac_cmd_construct_state cmd_state;
+
+	proc_status = &adapter->halmac_state.cfg_param_state.proc_status;
+
+	if (halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	if (adapter->fw_ver.h2c_version < 4)
+		return HALMAC_RET_FW_NO_SUPPORT;
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "Wait event(para)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	cmd_state = cfg_param_cmd_cnstr_state_88xx(adapter);
+	if (cmd_state != HALMAC_CMD_CNSTR_IDLE &&
+	    cmd_state != HALMAC_CMD_CNSTR_CNSTR) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "Not idle(para)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	*proc_status = HALMAC_CMD_PROCESS_IDLE;
+
+	status = proc_cfg_param_88xx(adapter, info, full_fifo);
+
+	if (status != HALMAC_RET_SUCCESS && status != HALMAC_RET_PARA_SENDING) {
+		pr_err("send param h2c\n");
+		return status;
+	}
+
+	return status;
+}
+
+static enum halmac_cmd_construct_state
+cfg_param_cmd_cnstr_state_88xx(struct halmac_adapter *adapter)
+{
+	return adapter->halmac_state.cfg_param_state.cmd_cnstr_state;
+}
+
+static enum halmac_ret_status
+proc_cfg_param_88xx(struct halmac_adapter *adapter,
+		    struct halmac_phy_parameter_info *param, u8 full_fifo)
+{
+	u8 end_cmd = 0;
+	u32 rsvd_size;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	struct halmac_cfg_param_info *info = &adapter->cfg_param_info;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.cfg_param_state.proc_status;
+
+	status = malloc_cfg_param_buf_88xx(adapter, full_fifo);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	if (cnv_cfg_param_state_88xx(adapter, HALMAC_CMD_CNSTR_CNSTR) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	add_param_buf_88xx(adapter, param, info->buf_wptr, &end_cmd);
+	if (param->cmd_id != HALMAC_PARAMETER_CMD_END) {
+		info->num++;
+		info->buf_wptr += CFG_PARAM_H2C_INFO_SIZE;
+		info->avl_buf_size -= CFG_PARAM_H2C_INFO_SIZE;
+	}
+
+	rsvd_size = info->avl_buf_size - adapter->hw_cfg_info.txdesc_size;
+	if (rsvd_size > CFG_PARAM_H2C_INFO_SIZE && end_cmd == 0)
+		return HALMAC_RET_SUCCESS;
+
+	if (info->num == 0) {
+		kfree(info->buf);
+		info->buf = NULL;
+		info->buf_wptr = NULL;
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "param num = 0!!\n");
+
+		*proc_status = HALMAC_CMD_PROCESS_DONE;
+		PLTFM_EVENT_SIG(HALMAC_FEATURE_CFG_PARA, *proc_status, NULL, 0);
+
+		reset_ofld_feature_88xx(adapter, HALMAC_FEATURE_CFG_PARA);
+
+		return HALMAC_RET_SUCCESS;
+	}
+
+	status = send_cfg_param_h2c_88xx(adapter);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	if (end_cmd == 0) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "send h2c-buf full\n");
+		return HALMAC_RET_PARA_SENDING;
+	}
+
+	return status;
+}
+
+static enum halmac_ret_status
+send_cfg_param_h2c_88xx(struct halmac_adapter *adapter)
+{
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = { 0 };
+	u16 pg_addr;
+	u16 seq_num = 0;
+	u32 info_size;
+	struct halmac_h2c_header_info hdr_info;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	struct halmac_cfg_param_info *info = &adapter->cfg_param_info;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.cfg_param_state.proc_status;
+
+	if (cnv_cfg_param_state_88xx(adapter, HALMAC_CMD_CNSTR_H2C_SENT) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	*proc_status = HALMAC_CMD_PROCESS_SENDING;
+
+	if (info->full_fifo_mode == 1)
+		pg_addr = 0;
+	else
+		pg_addr = adapter->txff_alloc.rsvd_h2c_info_addr;
+
+	info_size = info->num * CFG_PARAM_H2C_INFO_SIZE;
+
+	status = dl_rsvd_page_88xx(adapter, pg_addr, info->buf, info_size);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("dl rsvd pg!!\n");
+		goto CFG_PARAM_H2C_FAIL;
+	}
+
+	gen_cfg_param_h2c_88xx(adapter, h2c_buf);
+
+	hdr_info.sub_cmd_id = SUB_CMD_ID_CFG_PARAM;
+	hdr_info.content_size = 4;
+	hdr_info.ack = 1;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+
+	adapter->halmac_state.cfg_param_state.seq_num = seq_num;
+
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("send h2c!!\n");
+		reset_ofld_feature_88xx(adapter, HALMAC_FEATURE_CFG_PARA);
+	}
+
+CFG_PARAM_H2C_FAIL:
+	kfree(info->buf);
+	info->buf = NULL;
+	info->buf_wptr = NULL;
+
+	if (cnv_cfg_param_state_88xx(adapter, HALMAC_CMD_CNSTR_IDLE) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	return status;
+}
+
+static enum halmac_ret_status
+cnv_cfg_param_state_88xx(struct halmac_adapter *adapter,
+			 enum halmac_cmd_construct_state dest_state)
+{
+	enum halmac_cmd_construct_state *state;
+
+	state = &adapter->halmac_state.cfg_param_state.cmd_cnstr_state;
+
+	if ((*state != HALMAC_CMD_CNSTR_IDLE) &&
+	    (*state != HALMAC_CMD_CNSTR_CNSTR) &&
+	    (*state != HALMAC_CMD_CNSTR_H2C_SENT))
+		return HALMAC_RET_ERROR_STATE;
+
+	if (dest_state == HALMAC_CMD_CNSTR_IDLE) {
+		if (*state == HALMAC_CMD_CNSTR_CNSTR)
+			return HALMAC_RET_ERROR_STATE;
+	} else if (dest_state == HALMAC_CMD_CNSTR_CNSTR) {
+		if (*state == HALMAC_CMD_CNSTR_H2C_SENT)
+			return HALMAC_RET_ERROR_STATE;
+	} else if (dest_state == HALMAC_CMD_CNSTR_H2C_SENT) {
+		if ((*state == HALMAC_CMD_CNSTR_IDLE) ||
+		    (*state == HALMAC_CMD_CNSTR_H2C_SENT))
+			return HALMAC_RET_ERROR_STATE;
+	}
+
+	*state = dest_state;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+add_param_buf_88xx(struct halmac_adapter *adapter,
+		   struct halmac_phy_parameter_info *param, u8 *buf,
+		   u8 *end_cmd)
+{
+	struct halmac_cfg_param_info *info = &adapter->cfg_param_info;
+	union halmac_parameter_content *content = &param->content;
+
+	*end_cmd = 0;
+
+	PARAM_INFO_SET_LEN(buf, CFG_PARAM_H2C_INFO_SIZE);
+	PARAM_INFO_SET_IO_CMD(buf, param->cmd_id);
+
+	switch (param->cmd_id) {
+	case HALMAC_PARAMETER_CMD_BB_W8:
+	case HALMAC_PARAMETER_CMD_BB_W16:
+	case HALMAC_PARAMETER_CMD_BB_W32:
+	case HALMAC_PARAMETER_CMD_MAC_W8:
+	case HALMAC_PARAMETER_CMD_MAC_W16:
+	case HALMAC_PARAMETER_CMD_MAC_W32:
+		PARAM_INFO_SET_IO_ADDR(buf, content->MAC_REG_W.offset);
+		PARAM_INFO_SET_DATA(buf, content->MAC_REG_W.value);
+		PARAM_INFO_SET_MASK(buf, content->MAC_REG_W.msk);
+		PARAM_INFO_SET_MSK_EN(buf, content->MAC_REG_W.msk_en);
+		info->value_accum += content->MAC_REG_W.value;
+		info->offset_accum += content->MAC_REG_W.offset;
+		break;
+	case HALMAC_PARAMETER_CMD_RF_W:
+		/*In rf register, the address is only 1 byte*/
+		PARAM_INFO_SET_RF_ADDR(buf, content->RF_REG_W.offset);
+		PARAM_INFO_SET_RF_PATH(buf, content->RF_REG_W.rf_path);
+		PARAM_INFO_SET_DATA(buf, content->RF_REG_W.value);
+		PARAM_INFO_SET_MASK(buf, content->RF_REG_W.msk);
+		PARAM_INFO_SET_MSK_EN(buf, content->RF_REG_W.msk_en);
+		info->value_accum += content->RF_REG_W.value;
+		info->offset_accum += (content->RF_REG_W.offset +
+					(content->RF_REG_W.rf_path << 8));
+		break;
+	case HALMAC_PARAMETER_CMD_DELAY_US:
+	case HALMAC_PARAMETER_CMD_DELAY_MS:
+		PARAM_INFO_SET_DELAY_VAL(buf, content->DELAY_TIME.delay_time);
+		break;
+	case HALMAC_PARAMETER_CMD_END:
+		*end_cmd = 1;
+		break;
+	default:
+		pr_err("cmd id!!\n");
+		break;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+gen_cfg_param_h2c_88xx(struct halmac_adapter *adapter, u8 *buff)
+{
+	struct halmac_cfg_param_info *info = &adapter->cfg_param_info;
+	u16 h2c_info_addr = adapter->txff_alloc.rsvd_h2c_info_addr;
+	u16 rsvd_pg_addr = adapter->txff_alloc.rsvd_boundary;
+
+	CFG_PARAM_SET_NUM(buff, info->num);
+
+	if (info->full_fifo_mode == 1) {
+		CFG_PARAM_SET_INIT_CASE(buff, 0x1);
+		CFG_PARAM_SET_LOC(buff, 0);
+	} else {
+		CFG_PARAM_SET_INIT_CASE(buff, 0x0);
+		CFG_PARAM_SET_LOC(buff, h2c_info_addr - rsvd_pg_addr);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+malloc_cfg_param_buf_88xx(struct halmac_adapter *adapter, u8 full_fifo)
+{
+	struct halmac_cfg_param_info *info = &adapter->cfg_param_info;
+	struct halmac_pltfm_cfg_info *pltfm_info = &adapter->pltfm_info;
+
+	if (info->buf)
+		return HALMAC_RET_SUCCESS;
+
+	if (full_fifo == 1)
+		info->buf_size = pltfm_info->malloc_size;
+	else
+		info->buf_size = CFG_PARAM_RSVDPG_SIZE;
+
+	if (info->buf_size > pltfm_info->rsvd_pg_size)
+		info->buf_size = pltfm_info->rsvd_pg_size;
+
+	info->buf = smart_malloc_88xx(adapter, info->buf_size, &info->buf_size);
+	if (info->buf) {
+		memset(info->buf, 0x00, info->buf_size);
+		info->full_fifo_mode = full_fifo;
+		info->buf_wptr = info->buf;
+		info->num = 0;
+		info->avl_buf_size = info->buf_size;
+		info->value_accum = 0;
+		info->offset_accum = 0;
+	} else {
+		return HALMAC_RET_MALLOC_FAIL;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * update_packet_88xx() - send specific packet to FW
+ * @adapter : the adapter of halmac
+ * @pkt_id : packet id, to know the purpose of this packet
+ * @pkt : packet
+ * @size : packet size
+ *
+ * Note : TX_DESC is not included in the pkt
+ *
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+update_packet_88xx(struct halmac_adapter *adapter, enum halmac_packet_id pkt_id,
+		   u8 *pkt, u32 size)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_cmd_process_status *proc_status =
+		&adapter->halmac_state.update_pkt_state.proc_status;
+
+	if (halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	if (adapter->fw_ver.h2c_version < 4)
+		return HALMAC_RET_FW_NO_SUPPORT;
+
+	if (size > UPDATE_PKT_RSVDPG_SIZE)
+		return HALMAC_RET_RSVD_PG_OVERFLOW_FAIL;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (*proc_status == HALMAC_CMD_PROCESS_SENDING) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "Wait event(upd)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	*proc_status = HALMAC_CMD_PROCESS_SENDING;
+
+	status = send_h2c_update_packet_88xx(adapter, pkt_id, pkt, size);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("send h2c!!\n");
+		pr_err("pkt id : %X!!\n", pkt_id);
+		return status;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+send_h2c_update_packet_88xx(struct halmac_adapter *adapter,
+			    enum halmac_packet_id pkt_id, u8 *pkt, u32 size)
+{
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = { 0 };
+	u16 seq_num = 0;
+	u16 pg_addr = adapter->txff_alloc.rsvd_h2c_info_addr;
+	u16 pg_offset;
+	struct halmac_h2c_header_info hdr_info;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	status = dl_rsvd_page_88xx(adapter, pg_addr, pkt, size);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("dl rsvd pg!!\n");
+		return status;
+	}
+
+	pg_offset = pg_addr - adapter->txff_alloc.rsvd_boundary;
+	UPDATE_PKT_SET_SIZE(h2c_buf, size + adapter->hw_cfg_info.txdesc_size);
+	UPDATE_PKT_SET_ID(h2c_buf, pkt_id);
+	UPDATE_PKT_SET_LOC(h2c_buf, pg_offset);
+
+	hdr_info.sub_cmd_id = SUB_CMD_ID_UPDATE_PKT;
+	hdr_info.content_size = 8;
+	hdr_info.ack = 1;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+	adapter->halmac_state.update_pkt_state.seq_num = seq_num;
+
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("send h2c!!\n");
+		reset_ofld_feature_88xx(adapter, HALMAC_FEATURE_UPDATE_PACKET);
+		return status;
+	}
+
+	return status;
+}
+
+enum halmac_ret_status
+bcn_ie_filter_88xx(struct halmac_adapter *adapter,
+		   struct halmac_bcn_ie_info *info)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+enum halmac_ret_status
+update_datapack_88xx(struct halmac_adapter *adapter,
+		     enum halmac_data_type data_type,
+		     struct halmac_phy_parameter_info *info)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+enum halmac_ret_status
+run_datapack_88xx(struct halmac_adapter *adapter,
+		  enum halmac_data_type data_type)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+enum halmac_ret_status
+send_bt_coex_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size, u8 ack)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	status = send_bt_coex_cmd_88xx(adapter, buf, size, ack);
+
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("bt coex cmd!!\n");
+		return status;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+send_bt_coex_cmd_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size,
+		      u8 ack)
+{
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = { 0 };
+	u16 seq_num = 0;
+	struct halmac_h2c_header_info hdr_info;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	memcpy(h2c_buf + 8, buf, size);
+
+	hdr_info.sub_cmd_id = SUB_CMD_ID_BT_COEX;
+	hdr_info.content_size = (u16)size;
+	hdr_info.ack = ack;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("send h2c!!\n");
+		return status;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * dump_fifo_88xx() - dump fifo data
+ * @adapter : the adapter of halmac
+ * @sel : FIFO selection
+ * @start_addr : start address of selected FIFO
+ * @size : dump size of selected FIFO
+ * @data : FIFO data
+ *
+ * Note : before dump fifo, user need to call halmac_get_fifo_size to
+ * get fifo size. Then input this size to halmac_dump_fifo.
+ *
+ * Author : Ivan Lin/KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+dump_fifo_88xx(struct halmac_adapter *adapter, enum hal_fifo_sel sel,
+	       u32 start_addr, u32 size, u8 *data)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	u8 tmp8;
+	u8 enable;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (sel == HAL_FIFO_SEL_TX &&
+	    (start_addr + size) > adapter->hw_cfg_info.tx_fifo_size) {
+		pr_err("size overflow!!\n");
+		return HALMAC_RET_DUMP_FIFOSIZE_INCORRECT;
+	}
+
+	if (sel == HAL_FIFO_SEL_RX &&
+	    (start_addr + size) > adapter->hw_cfg_info.rx_fifo_size) {
+		pr_err("size overflow!!\n");
+		return HALMAC_RET_DUMP_FIFOSIZE_INCORRECT;
+	}
+
+	if ((size & (4 - 1)) != 0) {
+		pr_err("not 4byte alignment!!\n");
+		return HALMAC_RET_DUMP_FIFOSIZE_INCORRECT;
+	}
+
+	if (!data)
+		return HALMAC_RET_NULL_POINTER;
+
+	tmp8 = HALMAC_REG_R8(REG_RCR + 2);
+	enable = 0;
+	status = api->halmac_set_hw_value(adapter, HALMAC_HW_RX_CLK_GATE,
+					  &enable);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+	status = read_buf_88xx(adapter, start_addr, size, sel, data);
+
+	HALMAC_REG_W8(REG_RCR + 2, tmp8);
+
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("read buf!!\n");
+		return status;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+read_buf_88xx(struct halmac_adapter *adapter, u32 offset, u32 size,
+	      enum hal_fifo_sel sel, u8 *data)
+{
+	u32 start_pg;
+	u32 value32;
+	u32 i;
+	u32 residue;
+	u32 cnt = 0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (sel == HAL_FIFO_SEL_RSVD_PAGE)
+		offset += (adapter->txff_alloc.rsvd_boundary <<
+			   TX_PAGE_SIZE_SHIFT_88XX);
+
+	start_pg = offset >> 12;
+	residue = offset & (4096 - 1);
+
+	if (sel == HAL_FIFO_SEL_TX || sel == HAL_FIFO_SEL_RSVD_PAGE)
+		start_pg += 0x780;
+	else if (sel == HAL_FIFO_SEL_RX)
+		start_pg += 0x700;
+	else if (sel == HAL_FIFO_SEL_REPORT)
+		start_pg += 0x660;
+	else if (sel == HAL_FIFO_SEL_LLT)
+		start_pg += 0x650;
+	else if (sel == HAL_FIFO_SEL_RXBUF_FW)
+		start_pg += 0x680;
+	else
+		return HALMAC_RET_NOT_SUPPORT;
+
+	value32 = HALMAC_REG_R16(REG_PKTBUF_DBG_CTRL) & 0xF000;
+
+	do {
+		HALMAC_REG_W16(REG_PKTBUF_DBG_CTRL, (u16)(start_pg | value32));
+
+		for (i = 0x8000 + residue; i <= 0x8FFF; i += 4) {
+			*(u32 *)(data + cnt) = HALMAC_REG_R32(i);
+			*(u32 *)(data + cnt) =
+				le32_to_cpu(*(u32 *)(data + cnt));
+			cnt += 4;
+			if (size == cnt)
+				goto HALMAC_BUF_READ_OK;
+		}
+
+		residue = 0;
+		start_pg++;
+	} while (1);
+
+HALMAC_BUF_READ_OK:
+	HALMAC_REG_W16(REG_PKTBUF_DBG_CTRL, (u16)value32);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * get_fifo_size_88xx() - get fifo size
+ * @adapter : the adapter of halmac
+ * @sel : FIFO selection
+ * Author : Ivan Lin/KaiYuan Chang
+ * Return : u32
+ * More details of status code can be found in prototype document
+ */
+u32
+get_fifo_size_88xx(struct halmac_adapter *adapter, enum hal_fifo_sel sel)
+{
+	u32 size = 0;
+
+	if (sel == HAL_FIFO_SEL_TX)
+		size = adapter->hw_cfg_info.tx_fifo_size;
+	else if (sel == HAL_FIFO_SEL_RX)
+		size = adapter->hw_cfg_info.rx_fifo_size;
+	else if (sel == HAL_FIFO_SEL_RSVD_PAGE)
+		size = adapter->hw_cfg_info.tx_fifo_size -
+		       (adapter->txff_alloc.rsvd_boundary <<
+			TX_PAGE_SIZE_SHIFT_88XX);
+	else if (sel == HAL_FIFO_SEL_REPORT)
+		size = 65536;
+	else if (sel == HAL_FIFO_SEL_LLT)
+		size = 65536;
+	else if (sel == HAL_FIFO_SEL_RXBUF_FW)
+		size = RX_BUF_FW_88XX;
+
+	return size;
+}
+
+enum halmac_ret_status
+set_h2c_header_88xx(struct halmac_adapter *adapter, u8 *hdr, u16 *seq, u8 ack)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s!!\n",
+		 __func__);
+
+	H2C_CMD_HEADER_SET_CATEGORY(hdr, 0x00);
+	H2C_CMD_HEADER_SET_TOTAL_LEN(hdr, 16);
+
+	mutex_lock(&adapter->h2c_seq_mutex);
+	H2C_CMD_HEADER_SET_SEQ_NUM(hdr, adapter->h2c_info.seq_num);
+	*seq = adapter->h2c_info.seq_num;
+	(adapter->h2c_info.seq_num)++;
+	mutex_unlock(&adapter->h2c_seq_mutex);
+
+	if (ack == 1)
+		H2C_CMD_HEADER_SET_ACK(hdr, 1);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * add_ch_info_88xx() -add channel information
+ * @adapter : the adapter of halmac
+ * @info : channel information
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+add_ch_info_88xx(struct halmac_adapter *adapter, struct halmac_ch_info *info)
+{
+	struct halmac_ch_sw_info *ch_sw_info = &adapter->ch_sw_info;
+	enum halmac_cmd_construct_state state;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (adapter->halmac_state.dlfw_state != HALMAC_GEN_INFO_SENT) {
+		pr_err("gen info\n");
+		return HALMAC_RET_GEN_INFO_NOT_SENT;
+	}
+
+	state = scan_cmd_cnstr_state_88xx(adapter);
+	if (state != HALMAC_CMD_CNSTR_BUF_CLR &&
+	    state != HALMAC_CMD_CNSTR_CNSTR) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "cmd state (scan)\n");
+		return HALMAC_RET_ERROR_STATE;
+	}
+
+	if (!ch_sw_info->buf) {
+		ch_sw_info->buf = kzalloc(SCAN_INFO_RSVDPG_SIZE, GFP_KERNEL);
+		if (!ch_sw_info->buf)
+			return HALMAC_RET_NULL_POINTER;
+		ch_sw_info->buf_wptr = ch_sw_info->buf;
+		ch_sw_info->buf_size = SCAN_INFO_RSVDPG_SIZE;
+		ch_sw_info->avl_buf_size = SCAN_INFO_RSVDPG_SIZE;
+		ch_sw_info->total_size = 0;
+		ch_sw_info->extra_info_en = 0;
+		ch_sw_info->ch_num = 0;
+	}
+
+	if (ch_sw_info->extra_info_en == 1) {
+		pr_err("extra info = 1!!\n");
+		return HALMAC_RET_CH_SW_SEQ_WRONG;
+	}
+
+	if (ch_sw_info->avl_buf_size < 4) {
+		pr_err("buf full!!\n");
+		return HALMAC_RET_CH_SW_NO_BUF;
+	}
+
+	if (cnv_scan_state_88xx(adapter, HALMAC_CMD_CNSTR_CNSTR) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	CH_INFO_SET_CH(ch_sw_info->buf_wptr, info->channel);
+	CH_INFO_SET_PRI_CH_IDX(ch_sw_info->buf_wptr, info->pri_ch_idx);
+	CH_INFO_SET_BW(ch_sw_info->buf_wptr, info->bw);
+	CH_INFO_SET_TIMEOUT(ch_sw_info->buf_wptr, info->timeout);
+	CH_INFO_SET_ACTION_ID(ch_sw_info->buf_wptr, info->action_id);
+	CH_INFO_SET_EXTRA_INFO(ch_sw_info->buf_wptr, info->extra_info);
+
+	ch_sw_info->avl_buf_size = ch_sw_info->avl_buf_size - 4;
+	ch_sw_info->total_size = ch_sw_info->total_size + 4;
+	ch_sw_info->ch_num++;
+	ch_sw_info->extra_info_en = info->extra_info;
+	ch_sw_info->buf_wptr = ch_sw_info->buf_wptr + 4;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_cmd_construct_state
+scan_cmd_cnstr_state_88xx(struct halmac_adapter *adapter)
+{
+	return adapter->halmac_state.scan_state.cmd_cnstr_state;
+}
+
+static enum halmac_ret_status
+cnv_scan_state_88xx(struct halmac_adapter *adapter,
+		    enum halmac_cmd_construct_state dest_state)
+{
+	enum halmac_cmd_construct_state *state;
+
+	state = &adapter->halmac_state.scan_state.cmd_cnstr_state;
+
+	if (dest_state == HALMAC_CMD_CNSTR_IDLE) {
+		if ((*state == HALMAC_CMD_CNSTR_BUF_CLR) ||
+		    (*state == HALMAC_CMD_CNSTR_CNSTR))
+			return HALMAC_RET_ERROR_STATE;
+	} else if (dest_state == HALMAC_CMD_CNSTR_BUF_CLR) {
+		if (*state == HALMAC_CMD_CNSTR_H2C_SENT)
+			return HALMAC_RET_ERROR_STATE;
+	} else if (dest_state == HALMAC_CMD_CNSTR_CNSTR) {
+		if ((*state == HALMAC_CMD_CNSTR_IDLE) ||
+		    (*state == HALMAC_CMD_CNSTR_H2C_SENT))
+			return HALMAC_RET_ERROR_STATE;
+	} else if (dest_state == HALMAC_CMD_CNSTR_H2C_SENT) {
+		if ((*state != HALMAC_CMD_CNSTR_CNSTR) &&
+		    (*state != HALMAC_CMD_CNSTR_BUF_CLR))
+			return HALMAC_RET_ERROR_STATE;
+	}
+
+	*state = dest_state;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * add_extra_ch_info_88xx() -add extra channel information
+ * @adapter : the adapter of halmac
+ * @info : extra channel information
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+add_extra_ch_info_88xx(struct halmac_adapter *adapter,
+		       struct halmac_ch_extra_info *info)
+{
+	struct halmac_ch_sw_info *ch_sw_info = &adapter->ch_sw_info;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (!ch_sw_info->buf) {
+		pr_err("buf = null!!\n");
+		return HALMAC_RET_CH_SW_SEQ_WRONG;
+	}
+
+	if (ch_sw_info->extra_info_en == 0) {
+		pr_err("extra info = 0!!\n");
+		return HALMAC_RET_CH_SW_SEQ_WRONG;
+	}
+
+	if (ch_sw_info->avl_buf_size < (u32)(info->extra_info_size + 2)) {
+		pr_err("no available buffer!!\n");
+		return HALMAC_RET_CH_SW_NO_BUF;
+	}
+
+	if (scan_cmd_cnstr_state_88xx(adapter) != HALMAC_CMD_CNSTR_CNSTR) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "cmd state (ex scan)\n");
+		return HALMAC_RET_ERROR_STATE;
+	}
+
+	if (cnv_scan_state_88xx(adapter, HALMAC_CMD_CNSTR_CNSTR) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	CH_EXTRA_INFO_SET_ID(ch_sw_info->buf_wptr, info->extra_action_id);
+	CH_EXTRA_INFO_SET_INFO(ch_sw_info->buf_wptr, info->extra_info);
+	CH_EXTRA_INFO_SET_SIZE(ch_sw_info->buf_wptr, info->extra_info_size);
+	memcpy(ch_sw_info->buf_wptr + 2, info->extra_info_data,
+	       info->extra_info_size);
+
+	ch_sw_info->avl_buf_size -= (2 + info->extra_info_size);
+	ch_sw_info->total_size += (2 + info->extra_info_size);
+	ch_sw_info->extra_info_en = info->extra_info;
+	ch_sw_info->buf_wptr += (2 + info->extra_info_size);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * ctrl_ch_switch_88xx() -send channel switch cmd
+ * @adapter : the adapter of halmac
+ * @opt : channel switch config
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+ctrl_ch_switch_88xx(struct halmac_adapter *adapter,
+		    struct halmac_ch_switch_option *opt)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_cmd_construct_state state;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.scan_state.proc_status;
+
+	if (halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	if (adapter->fw_ver.h2c_version < 4)
+		return HALMAC_RET_FW_NO_SUPPORT;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (opt->switch_en == 0)
+		*proc_status = HALMAC_CMD_PROCESS_IDLE;
+
+	if ((*proc_status == HALMAC_CMD_PROCESS_SENDING) ||
+	    (*proc_status == HALMAC_CMD_PROCESS_RCVD)) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "Wait event(scan)\n");
+		return HALMAC_RET_BUSY_STATE;
+	}
+
+	state = scan_cmd_cnstr_state_88xx(adapter);
+	if (opt->switch_en == 1) {
+		if (state != HALMAC_CMD_CNSTR_CNSTR) {
+			pr_err("state(en = 1)\n");
+			return HALMAC_RET_ERROR_STATE;
+		}
+	} else {
+		if (state != HALMAC_CMD_CNSTR_BUF_CLR) {
+			pr_err("state(en = 0)\n");
+			return HALMAC_RET_ERROR_STATE;
+		}
+	}
+
+	status = proc_ctrl_ch_switch_88xx(adapter, opt);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("ctrl ch sw!!\n");
+		return status;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+proc_ctrl_ch_switch_88xx(struct halmac_adapter *adapter,
+			 struct halmac_ch_switch_option *opt)
+{
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = { 0 };
+	u16 seq_num = 0;
+	u16 pg_addr = adapter->txff_alloc.rsvd_h2c_info_addr;
+	struct halmac_h2c_header_info hdr_info;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_cmd_process_status *proc_status;
+
+	proc_status = &adapter->halmac_state.scan_state.proc_status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (cnv_scan_state_88xx(adapter, HALMAC_CMD_CNSTR_H2C_SENT) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	*proc_status = HALMAC_CMD_PROCESS_SENDING;
+
+	if (opt->switch_en != 0) {
+		status = dl_rsvd_page_88xx(adapter, pg_addr,
+					   adapter->ch_sw_info.buf,
+					   adapter->ch_sw_info.total_size);
+		if (status != HALMAC_RET_SUCCESS) {
+			pr_err("dl rsvd pg!!\n");
+			return status;
+		}
+	}
+
+	CH_SWITCH_SET_START(h2c_buf, opt->switch_en);
+	CH_SWITCH_SET_CH_NUM(h2c_buf, adapter->ch_sw_info.ch_num);
+	CH_SWITCH_SET_INFO_LOC(h2c_buf,
+			       pg_addr - adapter->txff_alloc.rsvd_boundary);
+	CH_SWITCH_SET_DEST_CH_EN(h2c_buf, opt->dest_ch_en);
+	CH_SWITCH_SET_DEST_CH(h2c_buf, opt->dest_ch);
+	CH_SWITCH_SET_PRI_CH_IDX(h2c_buf, opt->dest_pri_ch_idx);
+	CH_SWITCH_SET_ABSOLUTE_TIME(h2c_buf, opt->absolute_time_en);
+	CH_SWITCH_SET_TSF_LOW(h2c_buf, opt->tsf_low);
+	CH_SWITCH_SET_PERIODIC_OPT(h2c_buf, opt->periodic_option);
+	CH_SWITCH_SET_NORMAL_CYCLE(h2c_buf, opt->normal_cycle);
+	CH_SWITCH_SET_NORMAL_PERIOD(h2c_buf, opt->normal_period);
+	CH_SWITCH_SET_SLOW_PERIOD(h2c_buf, opt->phase_2_period);
+	CH_SWITCH_SET_NORMAL_PERIOD_SEL(h2c_buf, opt->normal_period_sel);
+	CH_SWITCH_SET_SLOW_PERIOD_SEL(h2c_buf, opt->phase_2_period_sel);
+	CH_SWITCH_SET_INFO_SIZE(h2c_buf, adapter->ch_sw_info.total_size);
+
+	hdr_info.sub_cmd_id = SUB_CMD_ID_CH_SWITCH;
+	hdr_info.content_size = 20;
+	hdr_info.ack = 1;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+	adapter->halmac_state.scan_state.seq_num = seq_num;
+
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("send h2c!!\n");
+		reset_ofld_feature_88xx(adapter, HALMAC_FEATURE_CHANNEL_SWITCH);
+	}
+	kfree(adapter->ch_sw_info.buf);
+	adapter->ch_sw_info.buf = NULL;
+	adapter->ch_sw_info.buf_wptr = NULL;
+	adapter->ch_sw_info.extra_info_en = 0;
+	adapter->ch_sw_info.buf_size = 0;
+	adapter->ch_sw_info.avl_buf_size = 0;
+	adapter->ch_sw_info.total_size = 0;
+	adapter->ch_sw_info.ch_num = 0;
+
+	if (cnv_scan_state_88xx(adapter, HALMAC_CMD_CNSTR_IDLE) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	return status;
+}
+
+/**
+ * clear_ch_info_88xx() -clear channel information
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+clear_ch_info_88xx(struct halmac_adapter *adapter)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (scan_cmd_cnstr_state_88xx(adapter) == HALMAC_CMD_CNSTR_H2C_SENT) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "state(clear)\n");
+		return HALMAC_RET_ERROR_STATE;
+	}
+
+	if (cnv_scan_state_88xx(adapter, HALMAC_CMD_CNSTR_BUF_CLR) !=
+	    HALMAC_RET_SUCCESS)
+		return HALMAC_RET_ERROR_STATE;
+
+	kfree(adapter->ch_sw_info.buf);
+	adapter->ch_sw_info.buf = NULL;
+	adapter->ch_sw_info.buf_wptr = NULL;
+	adapter->ch_sw_info.extra_info_en = 0;
+	adapter->ch_sw_info.buf_size = 0;
+	adapter->ch_sw_info.avl_buf_size = 0;
+	adapter->ch_sw_info.total_size = 0;
+	adapter->ch_sw_info.ch_num = 0;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * chk_txdesc_88xx() -check if the tx packet format is incorrect
+ * @adapter : the adapter of halmac
+ * @buf : tx Packet buffer, tx desc is included
+ * @size : tx packet size
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+chk_txdesc_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u32 mac_clk = 0;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (GET_TX_DESC_BMC(buf) == 1 && GET_TX_DESC_AGG_EN(buf) == 1)
+		pr_err("txdesc - agg + bmc\n");
+
+	if (size < (GET_TX_DESC_TXPKTSIZE(buf) +
+		    adapter->hw_cfg_info.txdesc_size +
+		    (GET_TX_DESC_PKT_OFFSET(buf) << 3))) {
+		pr_err("txdesc - total size\n");
+		status = HALMAC_RET_TXDESC_SET_FAIL;
+	}
+
+	if (wlhdr_valid_88xx(adapter, buf) != HALMAC_RET_SUCCESS) {
+		pr_err("wlhdr\n");
+		status = HALMAC_RET_WLHDR_FAIL;
+	}
+
+	if (GET_TX_DESC_AMSDU_PAD_EN(buf) != 0) {
+		pr_err("txdesc - amsdu_pad\n");
+		status = HALMAC_RET_TXDESC_SET_FAIL;
+	}
+
+	switch (BIT_GET_MAC_CLK_SEL(HALMAC_REG_R32(REG_AFE_CTRL1))) {
+	case 0x0:
+		mac_clk = 80;
+		break;
+	case 0x1:
+		mac_clk = 40;
+		break;
+	case 0x2:
+		mac_clk = 20;
+		break;
+	case 0x3:
+		mac_clk = 10;
+		break;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "MAC clock : 0x%XM\n", mac_clk);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "mac agg en : 0x%X\n", GET_TX_DESC_AGG_EN(buf));
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "mac agg num : 0x%X\n", GET_TX_DESC_MAX_AGG_NUM(buf));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return status;
+}
+
+static enum halmac_ret_status
+wlhdr_valid_88xx(struct halmac_adapter *adapter, u8 *buf)
+{
+	u32 txdesc_size = adapter->hw_cfg_info.txdesc_size +
+						GET_TX_DESC_PKT_OFFSET(buf);
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	struct wlhdr_frame_ctrl *wlhdr;
+
+	wlhdr = (struct wlhdr_frame_ctrl *)(buf + txdesc_size);
+
+	if (wlhdr->protocol != WLHDR_PROT_VER) {
+		pr_err("prot ver!!\n");
+		return HALMAC_RET_WLHDR_FAIL;
+	}
+
+	switch (wlhdr->type) {
+	case WLHDR_TYPE_MGMT:
+		if (wlhdr_mgmt_valid_88xx(adapter, wlhdr) != 1)
+			status = HALMAC_RET_WLHDR_FAIL;
+		break;
+	case WLHDR_TYPE_CTRL:
+		if (wlhdr_ctrl_valid_88xx(adapter, wlhdr) != 1)
+			status = HALMAC_RET_WLHDR_FAIL;
+		break;
+	case WLHDR_TYPE_DATA:
+		if (wlhdr_data_valid_88xx(adapter, wlhdr) != 1)
+			status = HALMAC_RET_WLHDR_FAIL;
+		break;
+	default:
+		pr_err("undefined type!!\n");
+		status = HALMAC_RET_WLHDR_FAIL;
+		break;
+	}
+
+	return status;
+}
+
+static u8
+wlhdr_mgmt_valid_88xx(struct halmac_adapter *adapter,
+		      struct wlhdr_frame_ctrl *wlhdr)
+{
+	u8 state;
+
+	switch (wlhdr->sub_type) {
+	case WLHDR_SUB_TYPE_ASSOC_REQ:
+	case WLHDR_SUB_TYPE_ASSOC_RSPNS:
+	case WLHDR_SUB_TYPE_REASSOC_REQ:
+	case WLHDR_SUB_TYPE_REASSOC_RSPNS:
+	case WLHDR_SUB_TYPE_PROBE_REQ:
+	case WLHDR_SUB_TYPE_PROBE_RSPNS:
+	case WLHDR_SUB_TYPE_BCN:
+	case WLHDR_SUB_TYPE_DISASSOC:
+	case WLHDR_SUB_TYPE_AUTH:
+	case WLHDR_SUB_TYPE_DEAUTH:
+	case WLHDR_SUB_TYPE_ACTION:
+	case WLHDR_SUB_TYPE_ACTION_NOACK:
+		state = 1;
+		break;
+	default:
+		pr_err("mgmt invalid!!\n");
+		state = 0;
+		break;
+	}
+
+	return state;
+}
+
+static u8
+wlhdr_ctrl_valid_88xx(struct halmac_adapter *adapter,
+		      struct wlhdr_frame_ctrl *wlhdr)
+{
+	u8 state;
+
+	switch (wlhdr->sub_type) {
+	case WLHDR_SUB_TYPE_BF_RPT_POLL:
+	case WLHDR_SUB_TYPE_NDPA:
+		state = 1;
+		break;
+	default:
+		pr_err("ctrl invalid!!\n");
+		state = 0;
+		break;
+	}
+
+	return state;
+}
+
+static u8
+wlhdr_data_valid_88xx(struct halmac_adapter *adapter,
+		      struct wlhdr_frame_ctrl *wlhdr)
+{
+	u8 state;
+
+	switch (wlhdr->sub_type) {
+	case WLHDR_SUB_TYPE_DATA:
+	case WLHDR_SUB_TYPE_NULL:
+	case WLHDR_SUB_TYPE_QOS_DATA:
+	case WLHDR_SUB_TYPE_QOS_NULL:
+		state = 1;
+		break;
+	default:
+		pr_err("data invalid!!\n");
+		state = 0;
+		break;
+	}
+
+	return state;
+}
+
+/**
+ * get_version_88xx() - get HALMAC version
+ * @ver : return version of major, prototype and minor information
+ * Author : KaiYuan Chang / Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_version_88xx(struct halmac_adapter *adapter, struct halmac_ver *ver)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	ver->major_ver = (u8)HALMAC_MAJOR_VER;
+	ver->prototype_ver = (u8)HALMAC_PROTOTYPE_VER;
+	ver->minor_ver = (u8)HALMAC_MINOR_VER;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+p2pps_88xx(struct halmac_adapter *adapter, struct halmac_p2pps *info)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (halmac_fw_validate(adapter) != HALMAC_RET_SUCCESS)
+		return HALMAC_RET_NO_DLFW;
+
+	if (adapter->fw_ver.h2c_version < 6)
+		return HALMAC_RET_FW_NO_SUPPORT;
+
+	status = proc_p2pps_88xx(adapter, info);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("p2pps!!\n");
+		return status;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+proc_p2pps_88xx(struct halmac_adapter *adapter, struct halmac_p2pps *info)
+{
+	u8 h2c_buf[H2C_PKT_SIZE_88XX] = { 0 };
+	u16 seq_num = 0;
+	struct halmac_h2c_header_info hdr_info;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	P2PPS_SET_OFFLOAD_EN(h2c_buf, info->offload_en);
+	P2PPS_SET_ROLE(h2c_buf, info->role);
+	P2PPS_SET_CTWINDOW_EN(h2c_buf, info->ctwindow_en);
+	P2PPS_SET_NOA_EN(h2c_buf, info->noa_en);
+	P2PPS_SET_NOA_SEL(h2c_buf, info->noa_sel);
+	P2PPS_SET_ALLSTASLEEP(h2c_buf, info->all_sta_sleep);
+	P2PPS_SET_DISCOVERY(h2c_buf, info->discovery);
+	P2PPS_SET_DISABLE_CLOSERF(h2c_buf, info->disable_close_rf);
+	P2PPS_SET_P2P_PORT_ID(h2c_buf, info->p2p_port_id);
+	P2PPS_SET_P2P_GROUP(h2c_buf, info->p2p_group);
+	P2PPS_SET_P2P_MACID(h2c_buf, info->p2p_macid);
+
+	P2PPS_SET_CTWINDOW_LENGTH(h2c_buf, info->ctwindow_length);
+
+	P2PPS_SET_NOA_DURATION_PARA(h2c_buf, info->noa_duration_para);
+	P2PPS_SET_NOA_INTERVAL_PARA(h2c_buf, info->noa_interval_para);
+	P2PPS_SET_NOA_START_TIME_PARA(h2c_buf, info->noa_start_time_para);
+	P2PPS_SET_NOA_COUNT_PARA(h2c_buf, info->noa_count_para);
+
+	hdr_info.sub_cmd_id = SUB_CMD_ID_P2PPS;
+	hdr_info.content_size = 24;
+	hdr_info.ack = 0;
+	set_h2c_pkt_hdr_88xx(adapter, h2c_buf, &hdr_info, &seq_num);
+
+	status = send_h2c_pkt_88xx(adapter, h2c_buf);
+
+	if (status != HALMAC_RET_SUCCESS)
+		pr_err("send h2c!!\n");
+
+	return status;
+}
+
+/**
+ * query_status_88xx() -query the offload feature status
+ * @adapter : the adapter of halmac
+ * @feature_id : feature_id
+ * @proc_status : feature_status
+ * @data : data buffer
+ * @size : data size
+ *
+ * Note :
+ * If user wants to know the data size, user can allocate zero
+ * size buffer first. If this size less than the data size, halmac
+ * will return  HALMAC_RET_BUFFER_TOO_SMALL. User need to
+ * re-allocate data buffer with correct data size.
+ *
+ * Author : Ivan Lin/KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+query_status_88xx(struct halmac_adapter *adapter,
+		  enum halmac_feature_id feature_id,
+		  enum halmac_cmd_process_status *proc_status, u8 *data,
+		  u32 *size)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (!proc_status)
+		return HALMAC_RET_NULL_POINTER;
+
+	switch (feature_id) {
+	case HALMAC_FEATURE_CFG_PARA:
+		status = get_cfg_param_status_88xx(adapter, proc_status);
+		break;
+	case HALMAC_FEATURE_DUMP_PHYSICAL_EFUSE:
+		status = get_dump_phy_efuse_status_88xx(adapter, proc_status,
+							data, size);
+		break;
+	case HALMAC_FEATURE_DUMP_LOGICAL_EFUSE:
+		status = get_dump_log_efuse_status_88xx(adapter, proc_status,
+							data, size);
+		break;
+	case HALMAC_FEATURE_CHANNEL_SWITCH:
+		status = get_ch_switch_status_88xx(adapter, proc_status);
+		break;
+	case HALMAC_FEATURE_UPDATE_PACKET:
+		status = get_update_packet_status_88xx(adapter, proc_status);
+		break;
+	case HALMAC_FEATURE_IQK:
+		status = get_iqk_status_88xx(adapter, proc_status);
+		break;
+	case HALMAC_FEATURE_POWER_TRACKING:
+		status = get_pwr_trk_status_88xx(adapter, proc_status);
+		break;
+	case HALMAC_FEATURE_PSD:
+		status = get_psd_status_88xx(adapter, proc_status, data, size);
+		break;
+	case HALMAC_FEATURE_FW_SNDING:
+		status = get_fw_snding_status_88xx(adapter, proc_status);
+		break;
+	default:
+		return HALMAC_RET_INVALID_FEATURE_ID;
+	}
+
+	return status;
+}
+
+static enum halmac_ret_status
+get_cfg_param_status_88xx(struct halmac_adapter *adapter,
+			  enum halmac_cmd_process_status *proc_status)
+{
+	*proc_status = adapter->halmac_state.cfg_param_state.proc_status;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+get_ch_switch_status_88xx(struct halmac_adapter *adapter,
+			  enum halmac_cmd_process_status *proc_status)
+{
+	*proc_status = adapter->halmac_state.scan_state.proc_status;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+get_update_packet_status_88xx(struct halmac_adapter *adapter,
+			      enum halmac_cmd_process_status *proc_status)
+{
+	*proc_status = adapter->halmac_state.update_pkt_state.proc_status;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_drv_rsvd_pg_num_88xx() -config reserved page number for driver
+ * @adapter : the adapter of halmac
+ * @pg_num : page number
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_drv_rsvd_pg_num_88xx(struct halmac_adapter *adapter,
+			 enum halmac_drv_rsvd_pg_num pg_num)
+{
+	if (adapter->api_registry.cfg_drv_rsvd_pg_en == 0)
+		return HALMAC_RET_NOT_SUPPORT;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "pg_num = %d\n",
+		 pg_num);
+
+	switch (pg_num) {
+	case HALMAC_RSVD_PG_NUM8:
+		adapter->txff_alloc.rsvd_drv_pg_num = 8;
+		break;
+	case HALMAC_RSVD_PG_NUM16:
+		adapter->txff_alloc.rsvd_drv_pg_num = 16;
+		break;
+	case HALMAC_RSVD_PG_NUM24:
+		adapter->txff_alloc.rsvd_drv_pg_num = 24;
+		break;
+	case HALMAC_RSVD_PG_NUM32:
+		adapter->txff_alloc.rsvd_drv_pg_num = 32;
+		break;
+	case HALMAC_RSVD_PG_NUM64:
+		adapter->txff_alloc.rsvd_drv_pg_num = 64;
+		break;
+	case HALMAC_RSVD_PG_NUM128:
+		adapter->txff_alloc.rsvd_drv_pg_num = 128;
+		break;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * (debug API)h2c_lb_88xx() - send h2c loopback packet
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+h2c_lb_88xx(struct halmac_adapter *adapter)
+{
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+pwr_seq_parser_88xx(struct halmac_adapter *adapter,
+		    struct halmac_wlan_pwr_cfg **cmd_seq)
+{
+	u8 cut;
+	u8 intf;
+	u32 idx = 0;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	struct halmac_wlan_pwr_cfg *cmd;
+
+	switch (adapter->chip_ver) {
+	case HALMAC_CHIP_VER_A_CUT:
+		cut = HALMAC_PWR_CUT_A_MSK;
+		break;
+	case HALMAC_CHIP_VER_B_CUT:
+		cut = HALMAC_PWR_CUT_B_MSK;
+		break;
+	case HALMAC_CHIP_VER_C_CUT:
+		cut = HALMAC_PWR_CUT_C_MSK;
+		break;
+	case HALMAC_CHIP_VER_D_CUT:
+		cut = HALMAC_PWR_CUT_D_MSK;
+		break;
+	case HALMAC_CHIP_VER_E_CUT:
+		cut = HALMAC_PWR_CUT_E_MSK;
+		break;
+	case HALMAC_CHIP_VER_F_CUT:
+		cut = HALMAC_PWR_CUT_F_MSK;
+		break;
+	case HALMAC_CHIP_VER_TEST:
+		cut = HALMAC_PWR_CUT_TESTCHIP_MSK;
+		break;
+	default:
+		pr_err("cut version!!\n");
+		return HALMAC_RET_SWITCH_CASE_ERROR;
+	}
+
+	switch (adapter->intf) {
+	case HALMAC_INTERFACE_PCIE:
+	case HALMAC_INTERFACE_AXI:
+		intf = HALMAC_PWR_INTF_PCI_MSK;
+		break;
+	case HALMAC_INTERFACE_USB:
+		intf = HALMAC_PWR_INTF_USB_MSK;
+		break;
+	case HALMAC_INTERFACE_SDIO:
+		intf = HALMAC_PWR_INTF_SDIO_MSK;
+		break;
+	default:
+		pr_err("interface!!\n");
+		return HALMAC_RET_SWITCH_CASE_ERROR;
+	}
+
+	do {
+		cmd = cmd_seq[idx];
+
+		if (!cmd)
+			break;
+
+		status = pwr_sub_seq_parser_88xx(adapter, cut, intf, cmd);
+		if (status != HALMAC_RET_SUCCESS) {
+			pr_err("pwr sub seq!!\n");
+			return status;
+		}
+
+		idx++;
+	} while (1);
+
+	return status;
+}
+
+static enum halmac_ret_status
+pwr_sub_seq_parser_88xx(struct halmac_adapter *adapter, u8 cut, u8 intf,
+			struct halmac_wlan_pwr_cfg *cmd)
+{
+	u8 value;
+	u32 offset;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	do {
+		if ((cmd->interface_msk & intf) && (cmd->cut_msk & cut)) {
+			switch (cmd->cmd) {
+			case HALMAC_PWR_CMD_WRITE:
+				offset = cmd->offset;
+
+				if (cmd->base == HALMAC_PWR_ADDR_SDIO)
+					offset |= SDIO_LOCAL_OFFSET;
+
+				value = HALMAC_REG_R8(offset);
+				value = (u8)(value & (u8)(~(cmd->msk)));
+				value = (u8)(value | (cmd->value & cmd->msk));
+
+				HALMAC_REG_W8(offset, value);
+				break;
+			case HALMAC_PWR_CMD_POLLING:
+				if (pwr_cmd_polling_88xx(adapter, cmd) !=
+				    HALMAC_RET_SUCCESS)
+					return HALMAC_RET_PWRSEQ_POLLING_FAIL;
+				break;
+			case HALMAC_PWR_CMD_DELAY:
+				if (cmd->value == HALMAC_PWR_DELAY_US)
+					udelay(cmd->offset);
+				else
+					udelay(1000 * cmd->offset);
+				break;
+			case HALMAC_PWR_CMD_READ:
+				break;
+			case HALMAC_PWR_CMD_END:
+				return HALMAC_RET_SUCCESS;
+			default:
+				return HALMAC_RET_PWRSEQ_CMD_INCORRECT;
+			}
+		}
+		cmd++;
+	} while (1);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+pwr_cmd_polling_88xx(struct halmac_adapter *adapter,
+		     struct halmac_wlan_pwr_cfg *cmd)
+{
+	u8 value;
+	u8 flg;
+	u8 poll_bit;
+	u32 offset;
+	u32 cnt;
+	static u32 stats;
+	enum halmac_interface intf;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	poll_bit = 0;
+	cnt = HALMAC_PWR_POLLING_CNT;
+	flg = 0;
+	intf = adapter->intf;
+
+	if (cmd->base == HALMAC_PWR_ADDR_SDIO)
+		offset = cmd->offset | SDIO_LOCAL_OFFSET;
+	else
+		offset = cmd->offset;
+
+	do {
+		cnt--;
+		value = HALMAC_REG_R8(offset);
+		value = (u8)(value & cmd->msk);
+
+		if (value == (cmd->value & cmd->msk)) {
+			poll_bit = 1;
+		} else {
+			if (cnt == 0) {
+				if (intf == HALMAC_INTERFACE_PCIE && flg == 0) {
+					/* PCIE + USB package */
+					/* power bit polling timeout issue */
+					stats++;
+					RT_TRACE(adapter->drv_adapter,
+						 COMP_HALMAC, DBG_WARNING,
+						 "PCIE stats:%d\n", stats);
+					value = HALMAC_REG_R8(REG_SYS_PW_CTRL);
+					value |= BIT(3);
+					HALMAC_REG_W8(REG_SYS_PW_CTRL, value);
+					value &= ~BIT(3);
+					HALMAC_REG_W8(REG_SYS_PW_CTRL, value);
+					poll_bit = 0;
+					cnt = HALMAC_PWR_POLLING_CNT;
+					flg = 1;
+				} else {
+					pr_err("polling to!!\n");
+					pr_err("cmd offset:%X\n", cmd->offset);
+					pr_err("cmd value:%X\n", cmd->value);
+					pr_err("cmd msk:%X\n", cmd->msk);
+					pr_err("offset = %X\n", offset);
+					pr_err("value = %X\n", value);
+					return HALMAC_RET_PWRSEQ_POLLING_FAIL;
+				}
+			} else {
+				usleep_range(50, 60);
+			}
+		}
+	} while (!poll_bit);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+parse_intf_phy_88xx(struct halmac_adapter *adapter,
+		    struct halmac_intf_phy_para *param,
+		    enum halmac_intf_phy_platform pltfm,
+		    enum hal_intf_phy intf_phy)
+{
+	u16 value;
+	u16 cur_cut;
+	u16 offset;
+	u16 ip_sel;
+	struct halmac_intf_phy_para *cur_param;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	u8 result = HALMAC_RET_SUCCESS;
+
+	switch (adapter->chip_ver) {
+	case HALMAC_CHIP_VER_A_CUT:
+		cur_cut = (u16)HALMAC_INTF_PHY_CUT_A;
+		break;
+	case HALMAC_CHIP_VER_B_CUT:
+		cur_cut = (u16)HALMAC_INTF_PHY_CUT_B;
+		break;
+	case HALMAC_CHIP_VER_C_CUT:
+		cur_cut = (u16)HALMAC_INTF_PHY_CUT_C;
+		break;
+	case HALMAC_CHIP_VER_D_CUT:
+		cur_cut = (u16)HALMAC_INTF_PHY_CUT_D;
+		break;
+	case HALMAC_CHIP_VER_E_CUT:
+		cur_cut = (u16)HALMAC_INTF_PHY_CUT_E;
+		break;
+	case HALMAC_CHIP_VER_F_CUT:
+		cur_cut = (u16)HALMAC_INTF_PHY_CUT_F;
+		break;
+	case HALMAC_CHIP_VER_TEST:
+		cur_cut = (u16)HALMAC_INTF_PHY_CUT_TESTCHIP;
+		break;
+	default:
+		return HALMAC_RET_FAIL;
+	}
+
+	cur_param = param;
+
+	do {
+		if ((cur_param->cut & cur_cut) &&
+		    (cur_param->plaform & (u16)pltfm)) {
+			offset =  cur_param->offset;
+			value = cur_param->value;
+			ip_sel = cur_param->ip_sel;
+
+			if (offset == 0xFFFF)
+				break;
+
+			if (ip_sel == HALMAC_IP_SEL_MAC) {
+				HALMAC_REG_W8((u32)offset, (u8)value);
+			} else if (intf_phy == HAL_INTF_PHY_USB2 ||
+				   intf_phy == HAL_INTF_PHY_USB3) {
+				result = usbphy_write_88xx(adapter, (u8)offset,
+							   value, intf_phy);
+				if (result != HALMAC_RET_SUCCESS)
+					pr_err("usb phy!!\n");
+
+			} else if (intf_phy == HAL_INTF_PHY_PCIE_GEN1 ||
+				   intf_phy == HAL_INTF_PHY_PCIE_GEN2) {
+				if (ip_sel == HALMAC_IP_INTF_PHY)
+					result = mdio_write_88xx(adapter,
+								 (u8)offset,
+								 value,
+								 intf_phy);
+				else
+					result = dbi_w8_88xx(adapter, offset,
+							     (u8)value);
+				if (result != HALMAC_RET_SUCCESS)
+					pr_err("mdio/dbi!!\n");
+
+			} else {
+				pr_err("intf phy sel!!\n");
+			}
+		}
+		cur_param++;
+	} while (1);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * txfifo_is_empty_88xx() -check if txfifo is empty
+ * @adapter : the adapter of halmac
+ * @chk_num : check number
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+txfifo_is_empty_88xx(struct halmac_adapter *adapter, u32 chk_num)
+{
+	u32 cnt;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	cnt = (chk_num <= 10) ? 10 : chk_num;
+	do {
+		if (HALMAC_REG_R8(REG_TXPKT_EMPTY) != 0xFF)
+			return HALMAC_RET_TXFIFO_NO_EMPTY;
+
+		if ((HALMAC_REG_R8(REG_TXPKT_EMPTY + 1) & 0x06) != 0x06)
+			return HALMAC_RET_TXFIFO_NO_EMPTY;
+		cnt--;
+
+	} while (cnt != 0);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * (internal use)
+ * smart_malloc_88xx() - adapt malloc size
+ * @adapter : the adapter of halmac
+ * @size : expected malloc size
+ * @pNew_size : real malloc size
+ * Author : Ivan Lin
+ * Return : address pointer
+ */
+u8*
+smart_malloc_88xx(struct halmac_adapter *adapter, u32 size, u32 *new_size)
+{
+	u8 retry_num;
+	u8 *malloc_buf = NULL;
+
+	for (retry_num = 0; retry_num < 5; retry_num++) {
+		malloc_buf = kzalloc(size, GFP_KERNEL);
+
+		if (malloc_buf) {
+			*new_size = size;
+			return malloc_buf;
+		}
+
+		size = size >> 1;
+
+		if (size == 0)
+			break;
+	}
+
+	pr_err("adptive malloc!!\n");
+
+	return NULL;
+}
+
+/**
+ * (internal use)
+ * ltecoex_reg_read_88xx() - read ltecoex register
+ * @adapter : the adapter of halmac
+ * @offset : offset
+ * @pValue : value
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ */
+enum halmac_ret_status
+ltecoex_reg_read_88xx(struct halmac_adapter *adapter, u16 offset, u32 *value)
+{
+	u32 cnt;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	cnt = 10000;
+	while ((HALMAC_REG_R8(LTECOEX_ACCESS_CTRL + 3) & BIT(5)) == 0) {
+		if (cnt == 0) {
+			pr_err("lte ready(R)\n");
+			return HALMAC_RET_LTECOEX_READY_FAIL;
+		}
+		cnt--;
+		usleep_range(50, 60);
+	}
+
+	HALMAC_REG_W32(LTECOEX_ACCESS_CTRL, 0x800F0000 | offset);
+	*value = HALMAC_REG_R32(REG_WL2LTECOEX_INDIRECT_ACCESS_READ_DATA_V1);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * (internal use)
+ * ltecoex_reg_write_88xx() - write ltecoex register
+ * @adapter : the adapter of halmac
+ * @offset : offset
+ * @value : value
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ */
+enum halmac_ret_status
+ltecoex_reg_write_88xx(struct halmac_adapter *adapter, u16 offset, u32 value)
+{
+	u32 cnt;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	cnt = 10000;
+	while ((HALMAC_REG_R8(LTECOEX_ACCESS_CTRL + 3) & BIT(5)) == 0) {
+		if (cnt == 0) {
+			pr_err("lte ready(W)\n");
+			return HALMAC_RET_LTECOEX_READY_FAIL;
+		}
+		cnt--;
+		usleep_range(50, 60);
+	}
+
+	HALMAC_REG_W32(REG_WL2LTECOEX_INDIRECT_ACCESS_WRITE_DATA_V1, value);
+	HALMAC_REG_W32(LTECOEX_ACCESS_CTRL, 0xC00F0000 | offset);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static void
+pwr_state_88xx(struct halmac_adapter *adapter, enum halmac_mac_power *state)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if ((HALMAC_REG_R8(REG_SYS_FUNC_EN + 1) & BIT(3)) == 0)
+		*state = HALMAC_MAC_POWER_OFF;
+	else
+		*state = HALMAC_MAC_POWER_ON;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_common_88xx.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_common_88xx.h
new file mode 100644
index 000000000000..c912e0e4a8f0
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_common_88xx.h
@@ -0,0 +1,151 @@
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
+#ifndef _HALMAC_COMMON_88XX_H_
+#define _HALMAC_COMMON_88XX_H_
+
+#include "../halmac_api.h"
+#include "../halmac_pwr_seq_cmd.h"
+#include "../halmac_gpio_cmd.h"
+
+enum halmac_ret_status
+ofld_func_cfg_88xx(struct halmac_adapter *adapter,
+		   struct halmac_ofld_func_info *info);
+
+enum halmac_ret_status
+dl_drv_rsvd_page_88xx(struct halmac_adapter *adapter, u8 pg_offset, u8 *buf,
+		      u32 size);
+
+enum halmac_ret_status
+dl_rsvd_page_88xx(struct halmac_adapter *adapter, u16 pg_addr, u8 *buf,
+		  u32 size);
+
+enum halmac_ret_status
+get_hw_value_88xx(struct halmac_adapter *adapter, enum halmac_hw_id hw_id,
+		  void *value);
+
+enum halmac_ret_status
+set_hw_value_88xx(struct halmac_adapter *adapter, enum halmac_hw_id hw_id,
+		  void *value);
+
+enum halmac_ret_status
+set_h2c_pkt_hdr_88xx(struct halmac_adapter *adapter, u8 *hdr,
+		     struct halmac_h2c_header_info *info, u16 *seq_num);
+
+enum halmac_ret_status
+send_h2c_pkt_88xx(struct halmac_adapter *adapter, u8 *pkt);
+
+enum halmac_ret_status
+get_h2c_buf_free_space_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+get_c2h_info_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+enum halmac_ret_status
+mac_debug_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+cfg_parameter_88xx(struct halmac_adapter *adapter,
+		   struct halmac_phy_parameter_info *info, u8 full_fifo);
+
+enum halmac_ret_status
+update_packet_88xx(struct halmac_adapter *adapter, enum halmac_packet_id pkt_id,
+		   u8 *pkt, u32 size);
+
+enum halmac_ret_status
+bcn_ie_filter_88xx(struct halmac_adapter *adapter,
+		   struct halmac_bcn_ie_info *info);
+
+enum halmac_ret_status
+update_datapack_88xx(struct halmac_adapter *adapter,
+		     enum halmac_data_type data_type,
+		     struct halmac_phy_parameter_info *info);
+
+enum halmac_ret_status
+run_datapack_88xx(struct halmac_adapter *adapter,
+		  enum halmac_data_type data_type);
+
+enum halmac_ret_status
+send_bt_coex_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size, u8 ack);
+
+enum halmac_ret_status
+dump_fifo_88xx(struct halmac_adapter *adapter, enum hal_fifo_sel sel,
+	       u32 start_addr, u32 size, u8 *data);
+
+u32
+get_fifo_size_88xx(struct halmac_adapter *adapter, enum hal_fifo_sel sel);
+
+enum halmac_ret_status
+set_h2c_header_88xx(struct halmac_adapter *adapter, u8 *hdr, u16 *seq, u8 ack);
+
+enum halmac_ret_status
+add_ch_info_88xx(struct halmac_adapter *adapter, struct halmac_ch_info *info);
+
+enum halmac_ret_status
+add_extra_ch_info_88xx(struct halmac_adapter *adapter,
+		       struct halmac_ch_extra_info *info);
+
+enum halmac_ret_status
+ctrl_ch_switch_88xx(struct halmac_adapter *adapter,
+		    struct halmac_ch_switch_option *opt);
+
+enum halmac_ret_status
+clear_ch_info_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+chk_txdesc_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+enum halmac_ret_status
+get_version_88xx(struct halmac_adapter *adapter, struct halmac_ver *ver);
+
+enum halmac_ret_status
+p2pps_88xx(struct halmac_adapter *adapter, struct halmac_p2pps *info);
+
+enum halmac_ret_status
+query_status_88xx(struct halmac_adapter *adapter,
+		  enum halmac_feature_id feature_id,
+		  enum halmac_cmd_process_status *proc_status, u8 *data,
+		  u32 *size);
+
+enum halmac_ret_status
+cfg_drv_rsvd_pg_num_88xx(struct halmac_adapter *adapter,
+			 enum halmac_drv_rsvd_pg_num pg_num);
+
+enum halmac_ret_status
+h2c_lb_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+pwr_seq_parser_88xx(struct halmac_adapter *adapter,
+		    struct halmac_wlan_pwr_cfg **cmd_seq);
+
+enum halmac_ret_status
+parse_intf_phy_88xx(struct halmac_adapter *adapter,
+		    struct halmac_intf_phy_para *param,
+		    enum halmac_intf_phy_platform pltfm,
+		    enum hal_intf_phy intf_phy);
+
+enum halmac_ret_status
+txfifo_is_empty_88xx(struct halmac_adapter *adapter, u32 chk_num);
+
+u8*
+smart_malloc_88xx(struct halmac_adapter *adapter, u32 size, u32 *new_size);
+
+enum halmac_ret_status
+ltecoex_reg_read_88xx(struct halmac_adapter *adapter, u16 offset, u32 *value);
+
+enum halmac_ret_status
+ltecoex_reg_write_88xx(struct halmac_adapter *adapter, u16 offset, u32 value);
+
+#endif/* _HALMAC_COMMON_88XX_H_ */
-- 
2.15.1
