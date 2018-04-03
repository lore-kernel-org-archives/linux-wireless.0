Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:36874 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754932AbeDCHyX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 03:54:23 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 14/17] rtlwifi: halmac: add bus interface commands
Date: Tue, 3 Apr 2018 15:53:29 +0800
Message-ID: <20180403075332.3344-15-pkshih@realtek.com> (sfid-20180403_095432_444059_CA00B23A)
In-Reply-To: <20180403075332.3344-1-pkshih@realtek.com>
References: <20180403075332.3344-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The halmac supports three buses interfaces, PCI, USB and SDIO, and this
commit makes it possible to change their phy parameters.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../halmac_88xx/halmac_8822b/halmac_pcie_8822b.c   | 218 +++++
 .../halmac_88xx/halmac_8822b/halmac_pcie_8822b.h   |  38 +
 .../halmac_88xx/halmac_8822b/halmac_phy_8822b.c    | 148 ++++
 .../halmac_88xx/halmac_8822b/halmac_sdio_8822b.c   | 880 ++++++++++++++++++++
 .../halmac_88xx/halmac_8822b/halmac_sdio_8822b.h   |  62 ++
 .../halmac_88xx/halmac_8822b/halmac_usb_8822b.c    | 161 ++++
 .../halmac_88xx/halmac_8822b/halmac_usb_8822b.h    |  38 +
 .../rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.c  | 538 +++++++++++++
 .../rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.h  |  98 +++
 .../rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.c  | 895 +++++++++++++++++++++
 .../rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.h  |  75 ++
 .../rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.c   | 522 ++++++++++++
 .../rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.h   |  83 ++
 .../realtek/rtlwifi/halmac/halmac_intf_phy_cmd.h   |  45 ++
 .../realtek/rtlwifi/halmac/halmac_pcie_reg.h       |  36 +
 .../realtek/rtlwifi/halmac/halmac_sdio_reg.h       |  53 ++
 .../realtek/rtlwifi/halmac/halmac_usb_reg.h        |  19 +
 17 files changed, 3909 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pcie_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pcie_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_phy_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_sdio_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_sdio_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_usb_8822b.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_usb_8822b.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_intf_phy_cmd.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_pcie_reg.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_sdio_reg.h
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/halmac/halmac_usb_reg.h

diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pcie_8822b.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pcie_8822b.c
new file mode 100644
index 000000000000..88a148e528a5
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pcie_8822b.c
@@ -0,0 +1,218 @@
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
+#include "halmac_pcie_8822b.h"
+#include "halmac_pwr_seq_8822b.h"
+#include "../halmac_init_88xx.h"
+#include "../halmac_common_88xx.h"
+#include "../halmac_pcie_88xx.h"
+#include "../halmac_88xx_cfg.h"
+
+/**
+ * mac_pwr_switch_pcie_8822b() - switch mac power
+ * @adapter : the adapter of halmac
+ * @pwr : power state
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+mac_pwr_switch_pcie_8822b(struct halmac_adapter *adapter,
+			  enum halmac_mac_power pwr)
+{
+	u8 value8;
+	u8 rpwm;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	enum halmac_ret_status status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "pwr = %x\n",
+		 pwr);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "8822B pwr seq ver = %s\n", HALMAC_8822B_PWR_SEQ_VER);
+
+	adapter->rpwm = HALMAC_REG_R8(REG_PCIE_HRPWM1_V1);
+
+	/* Check FW still exist or not */
+	if (HALMAC_REG_R16(REG_MCUFW_CTRL) == 0xC078) {
+		/* Leave 32K */
+		rpwm = (u8)((adapter->rpwm ^ BIT(7)) & 0x80);
+		HALMAC_REG_W8(REG_PCIE_HRPWM1_V1, rpwm);
+	}
+
+	value8 = HALMAC_REG_R8(REG_CR);
+	if (value8 == 0xEA)
+		adapter->halmac_state.mac_pwr = HALMAC_MAC_POWER_OFF;
+	else
+		adapter->halmac_state.mac_pwr = HALMAC_MAC_POWER_ON;
+
+	/* Check if power switch is needed */
+	if (pwr == HALMAC_MAC_POWER_ON &&
+	    adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_ON) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "power state unchange!!\n");
+		return HALMAC_RET_PWR_UNCHANGE;
+	}
+
+	if (pwr == HALMAC_MAC_POWER_OFF) {
+		status = trxdma_check_idle_88xx(adapter);
+		if (status != HALMAC_RET_SUCCESS)
+			return status;
+		if (pwr_seq_parser_88xx(adapter, card_dis_flow_8822b) !=
+		    HALMAC_RET_SUCCESS) {
+			pr_err("Handle power off cmd error\n");
+			return HALMAC_RET_POWER_OFF_FAIL;
+		}
+
+		adapter->halmac_state.mac_pwr = HALMAC_MAC_POWER_OFF;
+		adapter->halmac_state.dlfw_state = HALMAC_DLFW_NONE;
+		init_adapter_dynamic_param_88xx(adapter);
+	} else {
+		if (pwr_seq_parser_88xx(adapter, card_en_flow_8822b) !=
+		    HALMAC_RET_SUCCESS) {
+			pr_err("Handle power on cmd error\n");
+			return HALMAC_RET_POWER_ON_FAIL;
+		}
+
+		adapter->halmac_state.mac_pwr = HALMAC_MAC_POWER_ON;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * halmac_pcie_switch_8822b() - pcie gen1/gen2 switch
+ * @adapter : the adapter of halmac
+ * @cfg : gen1/gen2 selection
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+pcie_switch_8822b(struct halmac_adapter *adapter, enum halmac_pcie_cfg cfg)
+{
+	u8 value8;
+	u32 value32;
+	u8 speed = 0;
+	u32 cnt = 0;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (cfg == HALMAC_PCIE_GEN1) {
+		value8 = dbi_r8_88xx(adapter, LINK_CTRL2_REG_OFFSET) & 0xF0;
+		dbi_w8_88xx(adapter, LINK_CTRL2_REG_OFFSET, value8 | BIT(0));
+
+		value32 = dbi_r32_88xx(adapter, GEN2_CTRL_OFFSET);
+		dbi_w32_88xx(adapter, GEN2_CTRL_OFFSET, value32 | BIT(17));
+
+		speed = dbi_r8_88xx(adapter, LINK_STATUS_REG_OFFSET) & 0x0F;
+		cnt = 2000;
+
+		while ((speed != PCIE_GEN1_SPEED) && (cnt != 0)) {
+			usleep_range(50, 60);
+			speed = dbi_r8_88xx(adapter, LINK_STATUS_REG_OFFSET);
+			speed &= 0x0F;
+			cnt--;
+		}
+
+		if (speed != PCIE_GEN1_SPEED) {
+			pr_err("Speed change to GEN1 fail !\n");
+			return HALMAC_RET_FAIL;
+		}
+
+	} else if (cfg == HALMAC_PCIE_GEN2) {
+		value8 = dbi_r8_88xx(adapter, LINK_CTRL2_REG_OFFSET) & 0xF0;
+		dbi_w8_88xx(adapter, LINK_CTRL2_REG_OFFSET, value8 | BIT(1));
+
+		value32 = dbi_r32_88xx(adapter, GEN2_CTRL_OFFSET);
+		dbi_w32_88xx(adapter, GEN2_CTRL_OFFSET, value32 | BIT(17));
+
+		speed = dbi_r8_88xx(adapter, LINK_STATUS_REG_OFFSET) & 0x0F;
+		cnt = 2000;
+
+		while ((speed != PCIE_GEN2_SPEED) && (cnt != 0)) {
+			usleep_range(50, 60);
+			speed = dbi_r8_88xx(adapter, LINK_STATUS_REG_OFFSET);
+			speed &= 0x0F;
+			cnt--;
+		}
+
+		if (speed != PCIE_GEN2_SPEED) {
+			pr_err("Speed change to GEN1 fail !\n");
+			return HALMAC_RET_FAIL;
+		}
+
+	} else {
+		pr_err("Error Speed !\n");
+		return HALMAC_RET_FAIL;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * phy_cfg_pcie_8822b() - phy config
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+phy_cfg_pcie_8822b(struct halmac_adapter *adapter,
+		   enum halmac_intf_phy_platform pltfm)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	status = parse_intf_phy_88xx(adapter, pcie_gen1_phy_param_8822b, pltfm,
+				     HAL_INTF_PHY_PCIE_GEN1);
+
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	status = parse_intf_phy_88xx(adapter, pcie_gen2_phy_param_8822b, pltfm,
+				     HAL_INTF_PHY_PCIE_GEN2);
+
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * intf_tun_pcie_8822b() - pcie interface fine tuning
+ * @adapter : the adapter of halmac
+ * Author : Rick Liu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+intf_tun_pcie_8822b(struct halmac_adapter *adapter)
+{
+	return HALMAC_RET_SUCCESS;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pcie_8822b.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pcie_8822b.h
new file mode 100644
index 000000000000..6616f53df7a8
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_pcie_8822b.h
@@ -0,0 +1,38 @@
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
+#ifndef _HALMAC_API_8822B_PCIE_H_
+#define _HALMAC_API_8822B_PCIE_H_
+
+#include "../../halmac_api.h"
+
+extern struct halmac_intf_phy_para pcie_gen1_phy_param_8822b[];
+extern struct halmac_intf_phy_para pcie_gen2_phy_param_8822b[];
+
+enum halmac_ret_status
+mac_pwr_switch_pcie_8822b(struct halmac_adapter *adapter,
+			  enum halmac_mac_power pwr);
+
+enum halmac_ret_status
+pcie_switch_8822b(struct halmac_adapter *adapter, enum halmac_pcie_cfg cfg);
+
+enum halmac_ret_status
+phy_cfg_pcie_8822b(struct halmac_adapter *adapter,
+		   enum halmac_intf_phy_platform pltfm);
+
+enum halmac_ret_status
+intf_tun_pcie_8822b(struct halmac_adapter *adapter);
+
+#endif/* _HALMAC_API_8822B_PCIE_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_phy_8822b.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_phy_8822b.c
new file mode 100644
index 000000000000..3d5db54c6f26
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_phy_8822b.c
@@ -0,0 +1,148 @@
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
+#include "../../halmac_type.h"
+#include "halmac_usb_8822b.h"
+#include "halmac_pcie_8822b.h"
+
+/**
+ * ============ip sel item list============
+ * HALMAC_IP_INTF_PHY
+ *	USB2 : usb2 phy, 1byte value
+ *	USB3 : usb3 phy, 2byte value
+ *	PCIE1 : pcie gen1 mdio, 2byte value
+ *	PCIE2 : pcie gen2 mdio, 2byte value
+ * HALMAC_IP_SEL_MAC
+ *	USB2, USB3, PCIE1, PCIE2 : mac ip, 1byte value
+ * HALMAC_IP_PCIE_DBI
+ *	USB2 USB3 : none
+ *	PCIE1, PCIE2 : pcie dbi, 1byte value
+ */
+
+struct halmac_intf_phy_para usb2_phy_param_8822b[] = {
+	/* {offset, value, ip sel, cut mask, platform mask} */
+	{0xFFFF, 0x00,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_ALL,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+};
+
+struct halmac_intf_phy_para usb3_phy_param_8822b[] = {
+	/* {offset, value, ip sel, cut mask, platform mask} */
+	{0x0001, 0xA841,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_D,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0xFFFF, 0x0000,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_ALL,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+};
+
+struct halmac_intf_phy_para pcie_gen1_phy_param_8822b[] = {
+	/* {offset, value, ip sel, cut mask, platform mask} */
+	{0x0001, 0xA841,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0002, 0x60C6,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0008, 0x3596,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0009, 0x321C,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x000A, 0x9623,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0020, 0x94FF,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0021, 0xFFCF,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0026, 0xC006,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0029, 0xFF0E,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x002A, 0x1840,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0xFFFF, 0x0000,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_ALL,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+};
+
+struct halmac_intf_phy_para pcie_gen2_phy_param_8822b[] = {
+	/* {offset, value, ip sel, cut mask, platform mask} */
+	{0x0001, 0xA841,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0002, 0x60C6,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0008, 0x3597,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0009, 0x321C,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x000A, 0x9623,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0020, 0x94FF,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0021, 0xFFCF,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0026, 0xC006,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x0029, 0xFF0E,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0x002A, 0x3040,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_C,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+	{0xFFFF, 0x0000,
+	 HALMAC_IP_INTF_PHY,
+	 HALMAC_INTF_PHY_CUT_ALL,
+	 HALMAC_INTF_PHY_PLATFORM_ALL},
+};
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_sdio_8822b.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_sdio_8822b.c
new file mode 100644
index 000000000000..e014f02e30cd
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_sdio_8822b.c
@@ -0,0 +1,880 @@
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
+#include "halmac_sdio_8822b.h"
+#include "halmac_pwr_seq_8822b.h"
+#include "../halmac_init_88xx.h"
+#include "../halmac_common_88xx.h"
+#include "../halmac_sdio_88xx.h"
+
+#define WLAN_ACQ_NUM_MAX	8
+
+static enum halmac_ret_status
+chk_oqt_8822b(struct halmac_adapter *adapter, u32 tx_agg_num, u8 *buf,
+	      u8 macid_cnt);
+
+static enum halmac_ret_status
+update_oqt_free_space_8822b(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+update_sdio_free_page_8822b(struct halmac_adapter *adapter);
+
+static enum halmac_ret_status
+chk_qsel_8822b(struct halmac_adapter *adapter, u8 qsel_first, u8 *pkt,
+	       u8 *macid_cnt);
+
+static enum halmac_ret_status
+chk_dma_mapping_8822b(struct halmac_adapter *adapter, u16 **cur_fs,
+		      u8 qsel_first);
+
+static enum halmac_ret_status
+chk_rqd_page_num_8822b(struct halmac_adapter *adapter, u8 *buf, u32 *rqd_pg_num,
+		       u16 **cur_fs, u8 *macid_cnt, u32 tx_agg_num);
+
+/**
+ * mac_pwr_switch_sdio_8822b() - switch mac power
+ * @adapter : the adapter of halmac
+ * @pwr : power state
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+mac_pwr_switch_sdio_8822b(struct halmac_adapter *adapter,
+			  enum halmac_mac_power pwr)
+{
+	u8 value8;
+	u8 rpwm;
+	u32 imr_backup;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "8822B pwr seq ver = %s\n", HALMAC_8822B_PWR_SEQ_VER);
+
+	adapter->rpwm = HALMAC_REG_R8(REG_SDIO_HRPWM1);
+
+	/* Check FW still exist or not */
+	if (HALMAC_REG_R16(REG_MCUFW_CTRL) == 0xC078) {
+		/* Leave 32K */
+		rpwm = (u8)((adapter->rpwm ^ BIT(7)) & 0x80);
+		HALMAC_REG_W8(REG_SDIO_HRPWM1, rpwm);
+	}
+
+	value8 = HALMAC_REG_R8(REG_CR);
+	if (value8 == 0xEA)
+		adapter->halmac_state.mac_pwr = HALMAC_MAC_POWER_OFF;
+	else
+		adapter->halmac_state.mac_pwr = HALMAC_MAC_POWER_ON;
+
+	/*Check if power switch is needed*/
+	if (pwr == HALMAC_MAC_POWER_ON &&
+	    adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_ON) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "power state unchange!!\n");
+		return HALMAC_RET_PWR_UNCHANGE;
+	}
+
+	imr_backup = HALMAC_REG_R32(REG_SDIO_HIMR);
+	HALMAC_REG_W32(REG_SDIO_HIMR, 0);
+
+	if (pwr == HALMAC_MAC_POWER_OFF) {
+		adapter->pwr_off_flow_flag = 1;
+		if (pwr_seq_parser_88xx(adapter, card_dis_flow_8822b) !=
+		    HALMAC_RET_SUCCESS) {
+			pr_err("Handle power off cmd error\n");
+			HALMAC_REG_W32(REG_SDIO_HIMR, imr_backup);
+			return HALMAC_RET_POWER_OFF_FAIL;
+		}
+
+		adapter->halmac_state.mac_pwr = HALMAC_MAC_POWER_OFF;
+		adapter->halmac_state.dlfw_state = HALMAC_DLFW_NONE;
+		adapter->pwr_off_flow_flag = 0;
+		init_adapter_dynamic_param_88xx(adapter);
+	} else {
+		if (pwr_seq_parser_88xx(adapter, card_en_flow_8822b) !=
+		    HALMAC_RET_SUCCESS) {
+			pr_err("Handle power on cmd error\n");
+			HALMAC_REG_W32(REG_SDIO_HIMR, imr_backup);
+			return HALMAC_RET_POWER_ON_FAIL;
+		}
+
+		adapter->halmac_state.mac_pwr = HALMAC_MAC_POWER_ON;
+	}
+
+	HALMAC_REG_W32(REG_SDIO_HIMR, imr_backup);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * halmac_tx_allowed_sdio_88xx() - check tx status
+ * @adapter : the adapter of halmac
+ * @buf : tx packet, include txdesc
+ * @size : tx packet size, include txdesc
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+tx_allowed_sdio_8822b(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	u16 *cur_fs = NULL;
+	u32 cnt;
+	u32 tx_agg_num;
+	u32 rqd_pg_num = 0;
+	u8 macid_cnt = 0;
+	struct halmac_sdio_free_space *fs_info = &adapter->sdio_fs;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	enum halmac_qsel qsel;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (!fs_info->macid_map) {
+		pr_err("halmac allocate Macid_map Fail!!\n");
+		return HALMAC_RET_MALLOC_FAIL;
+	}
+
+	memset(fs_info->macid_map, 0x00, fs_info->macid_map_size);
+
+	tx_agg_num = GET_TX_DESC_DMA_TXAGG_NUM(buf);
+	tx_agg_num = (tx_agg_num == 0) ? 1 : tx_agg_num;
+
+	status = chk_rqd_page_num_8822b(adapter, buf, &rqd_pg_num, &cur_fs,
+					&macid_cnt, tx_agg_num);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	qsel = (enum halmac_qsel)GET_TX_DESC_QSEL(buf);
+	if (qsel == HALMAC_QSEL_BCN || qsel == HALMAC_QSEL_CMD)
+		return HALMAC_RET_SUCCESS;
+
+	cnt = 10;
+	do {
+		if ((u32)(*cur_fs + fs_info->pubq_pg_num) > rqd_pg_num) {
+			status = chk_oqt_8822b(adapter, tx_agg_num, buf,
+					       macid_cnt);
+			if (status != HALMAC_RET_SUCCESS) {
+				RT_TRACE(adapter->drv_adapter, COMP_HALMAC,
+					 DBG_WARNING, "oqt buffer full!!\n");
+				return status;
+			}
+
+			if (*cur_fs >= rqd_pg_num) {
+				*cur_fs -= (u16)rqd_pg_num;
+			} else {
+				fs_info->pubq_pg_num -=
+						(u16)(rqd_pg_num - *cur_fs);
+				*cur_fs = 0;
+			}
+
+			break;
+		}
+
+		update_sdio_free_page_8822b(adapter);
+
+		cnt--;
+		if (cnt == 0)
+			return HALMAC_RET_FREE_SPACE_NOT_ENOUGH;
+	} while (1);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * halmac_reg_read_8_sdio_88xx() - read 1byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+u8
+reg_r8_sdio_8822b(struct halmac_adapter *adapter, u32 offset)
+{
+	u8 value8;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if ((offset & 0xFFFF0000) == 0) {
+		value8 = (u8)r_indir_sdio_88xx(adapter, offset, HALMAC_IO_BYTE);
+	} else {
+		status = cnv_to_sdio_bus_offset_88xx(adapter, &offset);
+		if (status != HALMAC_RET_SUCCESS) {
+			pr_err("convert offset\n");
+			return status;
+		}
+		value8 = PLTFM_SDIO_CMD52_R(offset);
+	}
+
+	return value8;
+}
+
+/**
+ * halmac_reg_write_8_sdio_88xx() - write 1byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * @value : register value
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+reg_w8_sdio_8822b(struct halmac_adapter *adapter, u32 offset, u8 value)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if ((offset & 0xFFFF0000) == 0)
+		offset |= WLAN_IOREG_OFFSET;
+
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &offset);
+
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("convert offset\n");
+		return status;
+	}
+
+	PLTFM_SDIO_CMD52_W(offset, value);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * halmac_reg_read_16_sdio_88xx() - read 2byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+u16
+reg_r16_sdio_8822b(struct halmac_adapter *adapter, u32 offset)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	union {
+		__le16 word;
+		u8 byte[2];
+	} value16 = { 0x0000 };
+
+	if ((offset & 0xFFFF0000) == 0)
+		return (u16)r_indir_sdio_88xx(adapter, offset, HALMAC_IO_WORD);
+
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &offset);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("convert offset\n");
+		return status;
+	}
+
+	if (adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF ||
+	    ((offset & (2 - 1)) != 0) ||
+	    adapter->sdio_cmd53_4byte == HALMAC_SDIO_CMD53_4BYTE_MODE_RW ||
+	    adapter->sdio_cmd53_4byte == HALMAC_SDIO_CMD53_4BYTE_MODE_R) {
+		value16.byte[0] = PLTFM_SDIO_CMD52_R(offset);
+		value16.byte[1] = PLTFM_SDIO_CMD52_R(offset + 1);
+
+		return le16_to_cpu(value16.word);
+	}
+
+	return PLTFM_SDIO_CMD53_R16(offset);
+}
+
+/**
+ * halmac_reg_write_16_sdio_88xx() - write 2byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * @value : register value
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+reg_w16_sdio_8822b(struct halmac_adapter *adapter, u32 offset, u16 value)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF ||
+	    ((offset & (2 - 1)) != 0) ||
+	    adapter->sdio_cmd53_4byte == HALMAC_SDIO_CMD53_4BYTE_MODE_RW ||
+	    adapter->sdio_cmd53_4byte == HALMAC_SDIO_CMD53_4BYTE_MODE_W) {
+		if ((offset & 0xFFFF0000) == 0 && ((offset & (2 - 1)) == 0)) {
+			status = w_indir_sdio_88xx(adapter, offset, value,
+						   HALMAC_IO_WORD);
+		} else {
+			if ((offset & 0xFFFF0000) == 0)
+				offset |= WLAN_IOREG_OFFSET;
+
+			status = cnv_to_sdio_bus_offset_88xx(adapter, &offset);
+			if (status != HALMAC_RET_SUCCESS) {
+				pr_err("convert offset\n");
+				return status;
+			}
+			PLTFM_SDIO_CMD52_W(offset, (u8)(value & 0xFF));
+			PLTFM_SDIO_CMD52_W(offset + 1,
+					   (u8)((value & 0xFF00) >> 8));
+		}
+	} else {
+		if ((offset & 0xFFFF0000) == 0)
+			offset |= WLAN_IOREG_OFFSET;
+
+		status = cnv_to_sdio_bus_offset_88xx(adapter, &offset);
+		if (status != HALMAC_RET_SUCCESS) {
+			pr_err("convert offset\n");
+			return status;
+		}
+
+		PLTFM_SDIO_CMD53_W16(offset, value);
+	}
+	return status;
+}
+
+/**
+ * halmac_reg_read_32_sdio_88xx() - read 4byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+u32
+reg_r32_sdio_8822b(struct halmac_adapter *adapter, u32 offset)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+	union {
+		__le32 dword;
+		u8 byte[4];
+	} value32 = { 0x00000000 };
+
+	if ((offset & 0xFFFF0000) == 0)
+		return r_indir_sdio_88xx(adapter, offset, HALMAC_IO_DWORD);
+
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &offset);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("convert offset\n");
+		return status;
+	}
+
+	if (adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF ||
+	    (offset & (4 - 1)) != 0) {
+		value32.byte[0] = PLTFM_SDIO_CMD52_R(offset);
+		value32.byte[1] = PLTFM_SDIO_CMD52_R(offset + 1);
+		value32.byte[2] = PLTFM_SDIO_CMD52_R(offset + 2);
+		value32.byte[3] = PLTFM_SDIO_CMD52_R(offset + 3);
+
+		return le32_to_cpu(value32.dword);
+	}
+
+	return PLTFM_SDIO_CMD53_R32(offset);
+}
+
+/**
+ * halmac_reg_write_32_sdio_88xx() - write 4byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * @value : register value
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+reg_w32_sdio_8822b(struct halmac_adapter *adapter, u32 offset, u32 value)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF ||
+	    (offset & (4 - 1)) !=  0) {
+		if ((offset & 0xFFFF0000) == 0 && ((offset & (4 - 1)) == 0)) {
+			status = w_indir_sdio_88xx(adapter, offset, value,
+						   HALMAC_IO_DWORD);
+		} else {
+			if ((offset & 0xFFFF0000) == 0)
+				offset |= WLAN_IOREG_OFFSET;
+
+			status = cnv_to_sdio_bus_offset_88xx(adapter, &offset);
+			if (status != HALMAC_RET_SUCCESS) {
+				pr_err("convert offset\n");
+				return status;
+			}
+			PLTFM_SDIO_CMD52_W(offset, (u8)(value & 0xFF));
+			PLTFM_SDIO_CMD52_W(offset + 1,
+					   (u8)((value >> 8) & 0xFF));
+			PLTFM_SDIO_CMD52_W(offset + 2,
+					   (u8)((value >> 16) & 0xFF));
+			PLTFM_SDIO_CMD52_W(offset + 3,
+					   (u8)((value >> 24) & 0xFF));
+		}
+	} else {
+		if ((offset & 0xFFFF0000) == 0)
+			offset |= WLAN_IOREG_OFFSET;
+
+		status = cnv_to_sdio_bus_offset_88xx(adapter, &offset);
+		if (status != HALMAC_RET_SUCCESS) {
+			pr_err("convert offset\n");
+			return status;
+		}
+		PLTFM_SDIO_CMD53_W32(offset, value);
+	}
+
+	return status;
+}
+
+static enum halmac_ret_status
+chk_oqt_8822b(struct halmac_adapter *adapter, u32 tx_agg_num, u8 *buf,
+	      u8 macid_cnt)
+{
+	u32 cnt = 10;
+	struct halmac_sdio_free_space *fs_info = &adapter->sdio_fs;
+
+	/*S0, S1 are not allowed to use, 0x4E4[0] should be 0. Soar 20160323*/
+	/*no need to check non_ac_oqt_number*/
+	/*HI and MGQ blocked will cause protocal issue before H_OQT being full*/
+	switch ((enum halmac_qsel)GET_TX_DESC_QSEL(buf)) {
+	case HALMAC_QSEL_VO:
+	case HALMAC_QSEL_VO_V2:
+	case HALMAC_QSEL_VI:
+	case HALMAC_QSEL_VI_V2:
+	case HALMAC_QSEL_BE:
+	case HALMAC_QSEL_BE_V2:
+	case HALMAC_QSEL_BK:
+	case HALMAC_QSEL_BK_V2:
+		if (macid_cnt > WLAN_ACQ_NUM_MAX &&
+		    tx_agg_num > OQT_ENTRY_AC_8822B) {
+			RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+				 "txagg num %d > oqt entry\n", tx_agg_num);
+			RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+				 "macid cnt %d > acq max\n", macid_cnt);
+		}
+
+		cnt = 10;
+		do {
+			if (fs_info->ac_empty >= macid_cnt) {
+				fs_info->ac_empty -= macid_cnt;
+				break;
+			}
+
+			if (fs_info->ac_oqt_num >= tx_agg_num) {
+				fs_info->ac_empty = 0;
+				fs_info->ac_oqt_num -= (u8)tx_agg_num;
+				break;
+			}
+
+			update_oqt_free_space_8822b(adapter);
+
+			cnt--;
+			if (cnt == 0)
+				return HALMAC_RET_OQT_NOT_ENOUGH;
+		} while (1);
+		break;
+	case HALMAC_QSEL_MGNT:
+	case HALMAC_QSEL_HIGH:
+		if (tx_agg_num > OQT_ENTRY_NOAC_8822B)
+			RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+				 "tx_agg_num %d > oqt entry\n", tx_agg_num);
+
+		cnt = 10;
+		do {
+			if (fs_info->non_ac_oqt_num >= tx_agg_num) {
+				fs_info->non_ac_oqt_num -= (u8)tx_agg_num;
+				break;
+			}
+
+			update_oqt_free_space_8822b(adapter);
+
+			cnt--;
+			if (cnt == 0)
+				return HALMAC_RET_OQT_NOT_ENOUGH;
+		} while (1);
+		break;
+	default:
+		break;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+update_oqt_free_space_8822b(struct halmac_adapter *adapter)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	struct halmac_sdio_free_space *fs_info = &adapter->sdio_fs;
+	u8 value;
+	u32 oqt_free_page;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	oqt_free_page = HALMAC_REG_R32(REG_SDIO_OQT_FREE_TXPG_V1);
+	fs_info->ac_oqt_num = (u8)BIT_GET_AC_OQT_FREEPG_V1(oqt_free_page);
+	fs_info->non_ac_oqt_num = (u8)BIT_GET_NOAC_OQT_FREEPG_V1(oqt_free_page);
+	fs_info->ac_empty = 0;
+	if (fs_info->ac_oqt_num == OQT_ENTRY_AC_8822B) {
+		value = HALMAC_REG_R8(REG_TXPKT_EMPTY);
+		while (value > 0) {
+			value = value & (value - 1);
+			fs_info->ac_empty++;
+		};
+	} else {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "free_space->ac_oqt_num %d != %d\n",
+			 fs_info->ac_oqt_num, OQT_ENTRY_AC_8822B);
+	}
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+update_sdio_free_page_8822b(struct halmac_adapter *adapter)
+{
+	u32 free_page = 0;
+	u32 free_page2 = 0;
+	u32 free_page3 = 0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	struct halmac_sdio_free_space *fs_info = &adapter->sdio_fs;
+	u8 data[12] = {0};
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	HALMAC_REG_SDIO_RN(REG_SDIO_FREE_TXPG, 12, data);
+
+	free_page = le32_to_cpu(*(__le32 *)(data + 0));
+	free_page2 = le32_to_cpu(*(__le32 *)(data + 4));
+	free_page3 = le32_to_cpu(*(__le32 *)(data + 8));
+
+	fs_info->hiq_pg_num = (u16)BIT_GET_HIQ_FREEPG_V1(free_page);
+	fs_info->miq_pg_num = (u16)BIT_GET_MID_FREEPG_V1(free_page);
+	fs_info->lowq_pg_num = (u16)BIT_GET_LOW_FREEPG_V1(free_page2);
+	fs_info->pubq_pg_num = (u16)BIT_GET_PUB_FREEPG_V1(free_page2);
+	fs_info->exq_pg_num = (u16)BIT_GET_EXQ_FREEPG_V1(free_page3);
+	fs_info->ac_oqt_num = (u8)BIT_GET_AC_OQT_FREEPG_V1(free_page3);
+	fs_info->non_ac_oqt_num = (u8)BIT_GET_NOAC_OQT_FREEPG_V1(free_page3);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * phy_cfg_sdio_8822b() - phy config
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+phy_cfg_sdio_8822b(struct halmac_adapter *adapter,
+		   enum halmac_intf_phy_platform pltfm)
+{
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * halmac_pcie_switch_8821c() - pcie gen1/gen2 switch
+ * @adapter : the adapter of halmac
+ * @cfg : gen1/gen2 selection
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+pcie_switch_sdio_8822b(struct halmac_adapter *adapter,
+		       enum halmac_pcie_cfg cfg)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+/**
+ * intf_tun_sdio_8822b() - sdio interface fine tuning
+ * @adapter : the adapter of halmac
+ * Author : Ivan
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+intf_tun_sdio_8822b(struct halmac_adapter *adapter)
+{
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * halmac_get_sdio_tx_addr_sdio_88xx() - get CMD53 addr for the TX packet
+ * @adapter : the adapter of halmac
+ * @buf : tx packet, include txdesc
+ * @size : tx packet size
+ * @cmd53_addr : cmd53 addr value
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_sdio_tx_addr_8822b(struct halmac_adapter *adapter, u8 *buf, u32 size,
+		       u32 *cmd53_addr)
+{
+	u32 len_unit4;
+	enum halmac_qsel queue_sel;
+	enum halmac_dma_mapping dma_mapping;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (!buf) {
+		pr_err("buf is NULL!!\n");
+		return HALMAC_RET_DATA_BUF_NULL;
+	}
+
+	if (size == 0) {
+		pr_err("size is 0!!\n");
+		return HALMAC_RET_DATA_SIZE_INCORRECT;
+	}
+
+	queue_sel = (enum halmac_qsel)GET_TX_DESC_QSEL(buf);
+
+	switch (queue_sel) {
+	case HALMAC_QSEL_VO:
+	case HALMAC_QSEL_VO_V2:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_VO];
+		break;
+	case HALMAC_QSEL_VI:
+	case HALMAC_QSEL_VI_V2:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_VI];
+		break;
+	case HALMAC_QSEL_BE:
+	case HALMAC_QSEL_BE_V2:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_BE];
+		break;
+	case HALMAC_QSEL_BK:
+	case HALMAC_QSEL_BK_V2:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_BK];
+		break;
+	case HALMAC_QSEL_MGNT:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_MG];
+		break;
+	case HALMAC_QSEL_HIGH:
+	case HALMAC_QSEL_BCN:
+	case HALMAC_QSEL_CMD:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_HI];
+		break;
+	default:
+		pr_err("Qsel is out of range\n");
+		return HALMAC_RET_QSEL_INCORRECT;
+	}
+
+	len_unit4 = (size >> 2) + ((size & (4 - 1)) ? 1 : 0);
+
+	switch (dma_mapping) {
+	case HALMAC_DMA_MAPPING_HIGH:
+		*cmd53_addr = HALMAC_SDIO_CMD_ADDR_TXFF_HIGH;
+		break;
+	case HALMAC_DMA_MAPPING_NORMAL:
+		*cmd53_addr = HALMAC_SDIO_CMD_ADDR_TXFF_NORMAL;
+		break;
+	case HALMAC_DMA_MAPPING_LOW:
+		*cmd53_addr = HALMAC_SDIO_CMD_ADDR_TXFF_LOW;
+		break;
+	case HALMAC_DMA_MAPPING_EXTRA:
+		*cmd53_addr = HALMAC_SDIO_CMD_ADDR_TXFF_EXTRA;
+		break;
+	default:
+		pr_err("DmaMapping is out of range\n");
+		return HALMAC_RET_DMA_MAP_INCORRECT;
+	}
+
+	*cmd53_addr = (*cmd53_addr << 13) |
+				(len_unit4 & HALMAC_SDIO_4BYTE_LEN_MASK);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+chk_qsel_8822b(struct halmac_adapter *adapter, u8 qsel_first, u8 *pkt,
+	       u8 *macid_cnt)
+{
+	u8 flag = 0;
+	u8 qsel_now;
+	u8 macid;
+	struct halmac_sdio_free_space *fs_info = &adapter->sdio_fs;
+
+	macid = (u8)GET_TX_DESC_MACID(pkt);
+	qsel_now = (u8)GET_TX_DESC_QSEL(pkt);
+	if (qsel_first == qsel_now) {
+		if (*(fs_info->macid_map + macid) == 0) {
+			*(fs_info->macid_map + macid) = 1;
+			(*macid_cnt)++;
+		}
+	} else {
+		switch ((enum halmac_qsel)qsel_now) {
+		case HALMAC_QSEL_VO:
+			if ((enum halmac_qsel)qsel_first != HALMAC_QSEL_VO_V2)
+				flag = 1;
+			break;
+		case HALMAC_QSEL_VO_V2:
+			if ((enum halmac_qsel)qsel_first != HALMAC_QSEL_VO)
+				flag = 1;
+			break;
+		case HALMAC_QSEL_VI:
+			if ((enum halmac_qsel)qsel_first != HALMAC_QSEL_VI_V2)
+				flag = 1;
+			break;
+		case HALMAC_QSEL_VI_V2:
+			if ((enum halmac_qsel)qsel_first != HALMAC_QSEL_VI)
+				flag = 1;
+			break;
+		case HALMAC_QSEL_BE:
+			if ((enum halmac_qsel)qsel_first != HALMAC_QSEL_BE_V2)
+				flag = 1;
+			break;
+		case HALMAC_QSEL_BE_V2:
+			if ((enum halmac_qsel)qsel_first != HALMAC_QSEL_BE)
+				flag = 1;
+			break;
+		case HALMAC_QSEL_BK:
+			if ((enum halmac_qsel)qsel_first != HALMAC_QSEL_BK_V2)
+				flag = 1;
+			break;
+		case HALMAC_QSEL_BK_V2:
+			if ((enum halmac_qsel)qsel_first != HALMAC_QSEL_BK)
+				flag = 1;
+			break;
+		case HALMAC_QSEL_MGNT:
+		case HALMAC_QSEL_HIGH:
+		case HALMAC_QSEL_BCN:
+		case HALMAC_QSEL_CMD:
+			flag = 1;
+			break;
+		default:
+			pr_err("Qsel is out of range\n");
+			return HALMAC_RET_QSEL_INCORRECT;
+		}
+		if (flag == 1) {
+			pr_err("Multi-Qsel is not allowed\n");
+			pr_err("qsel = %d, %d\n", qsel_first, qsel_now);
+			return HALMAC_RET_QSEL_INCORRECT;
+		}
+		if (*(fs_info->macid_map + macid + MACID_MAX_8822B) == 0) {
+			*(fs_info->macid_map + macid + MACID_MAX_8822B) = 1;
+			(*macid_cnt)++;
+		}
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+chk_dma_mapping_8822b(struct halmac_adapter *adapter, u16 **cur_fs,
+		      u8 qsel_first)
+{
+	enum halmac_dma_mapping dma_mapping;
+
+	switch ((enum halmac_qsel)qsel_first) {
+	case HALMAC_QSEL_VO:
+	case HALMAC_QSEL_VO_V2:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_VO];
+		break;
+	case HALMAC_QSEL_VI:
+	case HALMAC_QSEL_VI_V2:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_VI];
+		break;
+	case HALMAC_QSEL_BE:
+	case HALMAC_QSEL_BE_V2:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_BE];
+		break;
+	case HALMAC_QSEL_BK:
+	case HALMAC_QSEL_BK_V2:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_BK];
+		break;
+	case HALMAC_QSEL_MGNT:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_MG];
+		break;
+	case HALMAC_QSEL_HIGH:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_HI];
+		break;
+	case HALMAC_QSEL_BCN:
+	case HALMAC_QSEL_CMD:
+		*cur_fs = &adapter->sdio_fs.hiq_pg_num;
+		return HALMAC_RET_SUCCESS;
+	default:
+		pr_err("Qsel is out of range: %d\n", qsel_first);
+		return HALMAC_RET_QSEL_INCORRECT;
+	}
+
+	switch (dma_mapping) {
+	case HALMAC_DMA_MAPPING_HIGH:
+		*cur_fs = &adapter->sdio_fs.hiq_pg_num;
+		break;
+	case HALMAC_DMA_MAPPING_NORMAL:
+		*cur_fs = &adapter->sdio_fs.miq_pg_num;
+		break;
+	case HALMAC_DMA_MAPPING_LOW:
+		*cur_fs = &adapter->sdio_fs.lowq_pg_num;
+		break;
+	case HALMAC_DMA_MAPPING_EXTRA:
+		*cur_fs = &adapter->sdio_fs.exq_pg_num;
+		break;
+	default:
+		pr_err("DmaMapping is out of range\n");
+		return HALMAC_RET_DMA_MAP_INCORRECT;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+static enum halmac_ret_status
+chk_rqd_page_num_8822b(struct halmac_adapter *adapter, u8 *buf, u32 *rqd_pg_num,
+		       u16 **cur_fs, u8 *macid_cnt, u32 tx_agg_num)
+{
+	u8 *pkt;
+	u8 qsel_first;
+	u32 i;
+	u32 pkt_size;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	pkt = buf;
+
+	qsel_first = (u8)GET_TX_DESC_QSEL(pkt);
+
+	status = chk_dma_mapping_8822b(adapter, cur_fs, qsel_first);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	for (i = 0; i < tx_agg_num; i++) {
+		/*QSEL parser*/
+		status = chk_qsel_8822b(adapter, qsel_first, pkt, macid_cnt);
+		if (status != HALMAC_RET_SUCCESS)
+			return status;
+
+		/*Page number parser*/
+		pkt_size = GET_TX_DESC_TXPKTSIZE(pkt) + GET_TX_DESC_OFFSET(pkt);
+		*rqd_pg_num += (pkt_size >> TX_PAGE_SIZE_SHIFT_88XX) +
+				((pkt_size & (TX_PAGE_SIZE_88XX - 1)) ? 1 : 0);
+
+		pkt += ALIGN(GET_TX_DESC_TXPKTSIZE(pkt) +
+			     (GET_TX_DESC_PKT_OFFSET(pkt) << 3) +
+			     TX_DESC_SIZE_88XX, 8);
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_sdio_8822b.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_sdio_8822b.h
new file mode 100644
index 000000000000..c29fba2d8a8f
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_sdio_8822b.h
@@ -0,0 +1,62 @@
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
+#ifndef _HALMAC_API_8822B_SDIO_H_
+#define _HALMAC_API_8822B_SDIO_H_
+
+#include "../../halmac_api.h"
+#include "halmac_8822b_cfg.h"
+
+enum halmac_ret_status
+mac_pwr_switch_sdio_8822b(struct halmac_adapter *adapter,
+			  enum halmac_mac_power pwr);
+
+enum halmac_ret_status
+tx_allowed_sdio_8822b(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+u8
+reg_r8_sdio_8822b(struct halmac_adapter *adapter, u32 offset);
+
+enum halmac_ret_status
+reg_w8_sdio_8822b(struct halmac_adapter *adapter, u32 offset, u8 value);
+
+u16
+reg_r16_sdio_8822b(struct halmac_adapter *adapter, u32 offset);
+
+enum halmac_ret_status
+reg_w16_sdio_8822b(struct halmac_adapter *adapter, u32 offset, u16 value);
+
+u32
+reg_r32_sdio_8822b(struct halmac_adapter *adapter, u32 offset);
+
+enum halmac_ret_status
+reg_w32_sdio_8822b(struct halmac_adapter *adapter, u32 offset, u32 value);
+
+enum halmac_ret_status
+phy_cfg_sdio_8822b(struct halmac_adapter *adapter,
+		   enum halmac_intf_phy_platform pltfm);
+
+enum halmac_ret_status
+pcie_switch_sdio_8822b(struct halmac_adapter *adapter,
+		       enum halmac_pcie_cfg cfg);
+
+enum halmac_ret_status
+intf_tun_sdio_8822b(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+get_sdio_tx_addr_8822b(struct halmac_adapter *adapter, u8 *buf, u32 size,
+		       u32 *cmd53_addr);
+
+#endif/* _HALMAC_API_8822B_SDIO_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_usb_8822b.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_usb_8822b.c
new file mode 100644
index 000000000000..a8d8b6d50063
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_usb_8822b.c
@@ -0,0 +1,161 @@
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
+#include "halmac_usb_8822b.h"
+#include "halmac_pwr_seq_8822b.h"
+#include "../halmac_init_88xx.h"
+#include "../halmac_common_88xx.h"
+
+/**
+ * mac_pwr_switch_usb_8822b() - switch mac power
+ * @adapter : the adapter of halmac
+ * @pwr : power state
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+mac_pwr_switch_usb_8822b(struct halmac_adapter *adapter,
+			 enum halmac_mac_power pwr)
+{
+	u8 value8;
+	u8 rpwm;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s\n",
+		 __func__);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%x\n", pwr);
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "8821C pwr seq ver = %s\n", HALMAC_8822B_PWR_SEQ_VER);
+
+	adapter->rpwm = HALMAC_REG_R8(0xFE58);
+
+	/* Check FW still exist or not */
+	if (HALMAC_REG_R16(REG_MCUFW_CTRL) == 0xC078) {
+		/* Leave 32K */
+		rpwm = (u8)((adapter->rpwm ^ BIT(7)) & 0x80);
+		HALMAC_REG_W8(0xFE58, rpwm);
+	}
+
+	value8 = HALMAC_REG_R8(REG_CR);
+	if (value8 == 0xEA) {
+		adapter->halmac_state.mac_pwr = HALMAC_MAC_POWER_OFF;
+	} else {
+		if (BIT(0) == (HALMAC_REG_R8(REG_SYS_STATUS1 + 1) & BIT(0)))
+			adapter->halmac_state.mac_pwr = HALMAC_MAC_POWER_OFF;
+		else
+			adapter->halmac_state.mac_pwr = HALMAC_MAC_POWER_ON;
+	}
+
+	/*Check if power switch is needed*/
+	if (pwr == HALMAC_MAC_POWER_ON &&
+	    adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_ON) {
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "power state unchange!!\n");
+		return HALMAC_RET_PWR_UNCHANGE;
+	}
+
+	if (pwr == HALMAC_MAC_POWER_OFF) {
+		if (pwr_seq_parser_88xx(adapter, card_dis_flow_8822b) !=
+		    HALMAC_RET_SUCCESS) {
+			pr_err("Handle power off cmd error\n");
+			return HALMAC_RET_POWER_OFF_FAIL;
+		}
+
+		adapter->halmac_state.mac_pwr = HALMAC_MAC_POWER_OFF;
+		adapter->halmac_state.dlfw_state = HALMAC_DLFW_NONE;
+		init_adapter_dynamic_param_88xx(adapter);
+	} else {
+		if (pwr_seq_parser_88xx(adapter, card_en_flow_8822b) !=
+		    HALMAC_RET_SUCCESS) {
+			pr_err("Handle power on cmd error\n");
+			return HALMAC_RET_POWER_ON_FAIL;
+		}
+
+		HALMAC_REG_W8_CLR(REG_SYS_STATUS1 + 1, BIT(0));
+
+		if ((HALMAC_REG_R8(REG_SW_MDIO + 3) & BIT(0)) == BIT(0))
+			RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+				 "[ALWAYS]shall R reg twice!!\n");
+
+		adapter->halmac_state.mac_pwr = HALMAC_MAC_POWER_ON;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * phy_cfg_usb_8822b() - phy config
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+phy_cfg_usb_8822b(struct halmac_adapter *adapter,
+		  enum halmac_intf_phy_platform pltfm)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	status = parse_intf_phy_88xx(adapter, usb2_phy_param_8822b, pltfm,
+				     HAL_INTF_PHY_USB2);
+
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	status = parse_intf_phy_88xx(adapter, usb3_phy_param_8822b, pltfm,
+				     HAL_INTF_PHY_USB3);
+
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * halmac_pcie_switch_8822b() - pcie gen1/gen2 switch
+ * @adapter : the adapter of halmac
+ * @cfg : gen1/gen2 selection
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+pcie_switch_usb_8822b(struct halmac_adapter *adapter, enum halmac_pcie_cfg cfg)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+/**
+ * intf_tun_usb_8822b() - usb interface fine tuning
+ * @adapter : the adapter of halmac
+ * Author : Ivan
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+intf_tun_usb_8822b(struct halmac_adapter *adapter)
+{
+	return HALMAC_RET_SUCCESS;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_usb_8822b.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_usb_8822b.h
new file mode 100644
index 000000000000..683b45e36c3b
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_8822b/halmac_usb_8822b.h
@@ -0,0 +1,38 @@
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
+#ifndef _HALMAC_API_8822B_USB_H_
+#define _HALMAC_API_8822B_USB_H_
+
+#include "../../halmac_api.h"
+
+extern struct halmac_intf_phy_para usb2_phy_param_8822b[];
+extern struct halmac_intf_phy_para usb3_phy_param_8822b[];
+
+enum halmac_ret_status
+mac_pwr_switch_usb_8822b(struct halmac_adapter *adapter,
+			 enum halmac_mac_power pwr);
+
+enum halmac_ret_status
+phy_cfg_usb_8822b(struct halmac_adapter *adapter,
+		  enum halmac_intf_phy_platform pltfm);
+
+enum halmac_ret_status
+pcie_switch_usb_8822b(struct halmac_adapter *adapter, enum halmac_pcie_cfg cfg);
+
+enum halmac_ret_status
+intf_tun_usb_8822b(struct halmac_adapter *adapter);
+
+#endif/* _HALMAC_API_8822B_USB_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.c
new file mode 100644
index 000000000000..01450a84cfde
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.c
@@ -0,0 +1,538 @@
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
+#include "halmac_pcie_88xx.h"
+
+/**
+ * init_pcie_cfg_88xx() -  init PCIe
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+init_pcie_cfg_88xx(struct halmac_adapter *adapter)
+{
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * deinit_pcie_cfg_88xx() - deinit PCIE
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+deinit_pcie_cfg_88xx(struct halmac_adapter *adapter)
+{
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_pcie_rx_agg_88xx() - config rx aggregation
+ * @adapter : the adapter of halmac
+ * @halmac_rx_agg_mode
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_pcie_rx_agg_88xx(struct halmac_adapter *adapter,
+		     struct halmac_rxagg_cfg *cfg)
+{
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * reg_r8_pcie_88xx() - read 1byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+u8
+reg_r8_pcie_88xx(struct halmac_adapter *adapter, u32 offset)
+{
+	return PLTFM_REG_R8(offset);
+}
+
+/**
+ * reg_w8_pcie_88xx() - write 1byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * @value : register value
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+reg_w8_pcie_88xx(struct halmac_adapter *adapter, u32 offset, u8 value)
+{
+	PLTFM_REG_W8(offset, value);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * reg_r16_pcie_88xx() - read 2byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+u16
+reg_r16_pcie_88xx(struct halmac_adapter *adapter, u32 offset)
+{
+	return PLTFM_REG_R16(offset);
+}
+
+/**
+ * reg_w16_pcie_88xx() - write 2byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * @value : register value
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+reg_w16_pcie_88xx(struct halmac_adapter *adapter, u32 offset, u16 value)
+{
+	PLTFM_REG_W16(offset, value);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * reg_r32_pcie_88xx() - read 4byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+u32
+reg_r32_pcie_88xx(struct halmac_adapter *adapter, u32 offset)
+{
+	return PLTFM_REG_R32(offset);
+}
+
+/**
+ * reg_w32_pcie_88xx() - write 4byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * @value : register value
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+reg_w32_pcie_88xx(struct halmac_adapter *adapter, u32 offset, u32 value)
+{
+	PLTFM_REG_W32(offset, value);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_txagg_pcie_align_88xx() -config sdio bus tx agg alignment
+ * @adapter : the adapter of halmac
+ * @enable : function enable(1)/disable(0)
+ * @align_size : sdio bus tx agg alignment size (2^n, n = 3~11)
+ * Author : Soar Tu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_txagg_pcie_align_88xx(struct halmac_adapter *adapter, u8 enable,
+			  u16 align_size)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+/**
+ * tx_allowed_pcie_88xx() - check tx status
+ * @adapter : the adapter of halmac
+ * @buf : tx packet, include txdesc
+ * @size : tx packet size, include txdesc
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+tx_allowed_pcie_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+/**
+ * pcie_indirect_reg_r32_88xx() - read MAC reg by SDIO reg
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+u32
+pcie_indirect_reg_r32_88xx(struct halmac_adapter *adapter, u32 offset)
+{
+	return 0xFFFFFFFF;
+}
+
+/**
+ * pcie_reg_rn_88xx() - read n byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * @size : register value size
+ * @value : register value
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+pcie_reg_rn_88xx(struct halmac_adapter *adapter, u32 offset, u32 size,
+		 u8 *value)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+/**
+ * set_pcie_bulkout_num_88xx() - inform bulk-out num
+ * @adapter : the adapter of halmac
+ * @num : usb bulk-out number
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+set_pcie_bulkout_num_88xx(struct halmac_adapter *adapter, u8 num)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+/**
+ * get_pcie_tx_addr_88xx() - get CMD53 addr for the TX packet
+ * @adapter : the adapter of halmac
+ * @buf : tx packet, include txdesc
+ * @size : tx packet size
+ * @cmd53_addr : cmd53 addr value
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_pcie_tx_addr_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size,
+		      u32 *cmd53_addr)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+/**
+ * get_pcie_bulkout_id_88xx() - get bulk out id for the TX packet
+ * @adapter : the adapter of halmac
+ * @buf : tx packet, include txdesc
+ * @size : tx packet size
+ * @id : usb bulk-out id
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_pcie_bulkout_id_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size,
+			 u8 *id)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+enum halmac_ret_status
+mdio_write_88xx(struct halmac_adapter *adapter, u8 addr, u16 data, u8 speed)
+{
+	u8 tmp_u1b = 0;
+	u32 cnt = 0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	u8 real_addr = 0;
+
+	HALMAC_REG_W16(REG_MDIO_V1, data);
+
+	real_addr = (addr & 0x1F);
+	HALMAC_REG_W8(REG_PCIE_MIX_CFG, real_addr);
+
+	if (speed == HAL_INTF_PHY_PCIE_GEN1) {
+		if (addr < 0x20)
+			HALMAC_REG_W8(REG_PCIE_MIX_CFG + 3, 0x00);
+		else
+			HALMAC_REG_W8(REG_PCIE_MIX_CFG + 3, 0x01);
+	} else if (speed == HAL_INTF_PHY_PCIE_GEN2) {
+		if (addr < 0x20)
+			HALMAC_REG_W8(REG_PCIE_MIX_CFG + 3, 0x02);
+		else
+			HALMAC_REG_W8(REG_PCIE_MIX_CFG + 3, 0x03);
+	} else {
+		pr_err("Error Speed !\n");
+	}
+
+	HALMAC_REG_W8_SET(REG_PCIE_MIX_CFG, BIT_MDIO_WFLAG_V1);
+
+	tmp_u1b = HALMAC_REG_R8(REG_PCIE_MIX_CFG) & BIT_MDIO_WFLAG_V1;
+	cnt = 20;
+
+	while (tmp_u1b && (cnt != 0)) {
+		usleep_range(10, 20);
+		tmp_u1b = HALMAC_REG_R8(REG_PCIE_MIX_CFG) & BIT_MDIO_WFLAG_V1;
+		cnt--;
+	}
+
+	if (tmp_u1b) {
+		pr_err("MDIO write fail!\n");
+		return HALMAC_RET_FAIL;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+u16
+mdio_read_88xx(struct halmac_adapter *adapter, u8 addr, u8 speed)
+{
+	u16 ret = 0;
+	u8 tmp_u1b = 0;
+	u32 cnt = 0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	u8 real_addr = 0;
+
+	real_addr = (addr & 0x1F);
+	HALMAC_REG_W8(REG_PCIE_MIX_CFG, real_addr);
+
+	if (speed == HAL_INTF_PHY_PCIE_GEN1) {
+		if (addr < 0x20)
+			HALMAC_REG_W8(REG_PCIE_MIX_CFG + 3, 0x00);
+		else
+			HALMAC_REG_W8(REG_PCIE_MIX_CFG + 3, 0x01);
+	} else if (speed == HAL_INTF_PHY_PCIE_GEN2) {
+		if (addr < 0x20)
+			HALMAC_REG_W8(REG_PCIE_MIX_CFG + 3, 0x02);
+		else
+			HALMAC_REG_W8(REG_PCIE_MIX_CFG + 3, 0x03);
+	} else {
+		pr_err("Error Speed !\n");
+	}
+
+	HALMAC_REG_W8_SET(REG_PCIE_MIX_CFG, BIT_MDIO_RFLAG_V1);
+
+	tmp_u1b = HALMAC_REG_R8(REG_PCIE_MIX_CFG) & BIT_MDIO_RFLAG_V1;
+	cnt = 20;
+	while (tmp_u1b && (cnt != 0)) {
+		usleep_range(10, 20);
+		tmp_u1b = HALMAC_REG_R8(REG_PCIE_MIX_CFG) & BIT_MDIO_RFLAG_V1;
+		cnt--;
+	}
+
+	if (tmp_u1b) {
+		ret  = 0xFFFF;
+		pr_err("MDIO read fail!\n");
+	} else {
+		ret = HALMAC_REG_R16(REG_MDIO_V1 + 2);
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "Value-R = %x\n", ret);
+	}
+
+	return ret;
+}
+
+enum halmac_ret_status
+dbi_w32_88xx(struct halmac_adapter *adapter, u16 addr, u32 data)
+{
+	u8 tmp_u1b = 0;
+	u32 cnt = 0;
+	u16 write_addr = 0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	HALMAC_REG_W32(REG_DBI_WDATA_V1, data);
+
+	write_addr = ((addr & 0x0ffc) | (0x000F << 12));
+	HALMAC_REG_W16(REG_DBI_FLAG_V1, write_addr);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "Addr-W = %x\n",
+		 write_addr);
+
+	HALMAC_REG_W8(REG_DBI_FLAG_V1 + 2, 0x01);
+	tmp_u1b = HALMAC_REG_R8(REG_DBI_FLAG_V1 + 2);
+
+	cnt = 20;
+	while (tmp_u1b && (cnt != 0)) {
+		usleep_range(10, 20);
+		tmp_u1b = HALMAC_REG_R8(REG_DBI_FLAG_V1 + 2);
+		cnt--;
+	}
+
+	if (tmp_u1b) {
+		pr_err("DBI write fail!\n");
+		return HALMAC_RET_FAIL;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+u32
+dbi_r32_88xx(struct halmac_adapter *adapter, u16 addr)
+{
+	u16 read_addr = addr & 0x0ffc;
+	u8 tmp_u1b = 0;
+	u32 cnt = 0;
+	u32 ret = 0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	HALMAC_REG_W16(REG_DBI_FLAG_V1, read_addr);
+
+	HALMAC_REG_W8(REG_DBI_FLAG_V1 + 2, 0x2);
+	tmp_u1b = HALMAC_REG_R8(REG_DBI_FLAG_V1 + 2);
+
+	cnt = 20;
+	while (tmp_u1b && (cnt != 0)) {
+		usleep_range(10, 20);
+		tmp_u1b = HALMAC_REG_R8(REG_DBI_FLAG_V1 + 2);
+		cnt--;
+	}
+
+	if (tmp_u1b) {
+		ret  = 0xFFFF;
+		pr_err("DBI read fail!\n");
+	} else {
+		ret = HALMAC_REG_R32(REG_DBI_RDATA_V1);
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "Value-R = %x\n", ret);
+	}
+
+	return ret;
+}
+
+enum halmac_ret_status
+dbi_w8_88xx(struct halmac_adapter *adapter, u16 addr, u8 data)
+{
+	u8 tmp_u1b = 0;
+	u32 cnt = 0;
+	u16 write_addr = 0;
+	u16 remainder = addr & (4 - 1);
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	HALMAC_REG_W8(REG_DBI_WDATA_V1 + remainder, data);
+
+	write_addr = ((addr & 0x0ffc) | (BIT(0) << (remainder + 12)));
+
+	HALMAC_REG_W16(REG_DBI_FLAG_V1, write_addr);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "Addr-W = %x\n",
+		 write_addr);
+
+	HALMAC_REG_W8(REG_DBI_FLAG_V1 + 2, 0x01);
+
+	tmp_u1b = HALMAC_REG_R8(REG_DBI_FLAG_V1 + 2);
+
+	cnt = 20;
+	while (tmp_u1b && (cnt != 0)) {
+		usleep_range(10, 20);
+		tmp_u1b = HALMAC_REG_R8(REG_DBI_FLAG_V1 + 2);
+		cnt--;
+	}
+
+	if (tmp_u1b) {
+		pr_err("DBI write fail!\n");
+		return HALMAC_RET_FAIL;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+u8
+dbi_r8_88xx(struct halmac_adapter *adapter, u16 addr)
+{
+	u16 read_addr = addr & 0x0ffc;
+	u8 tmp_u1b = 0;
+	u32 cnt = 0;
+	u8 ret = 0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	HALMAC_REG_W16(REG_DBI_FLAG_V1, read_addr);
+	HALMAC_REG_W8(REG_DBI_FLAG_V1 + 2, 0x2);
+
+	tmp_u1b = HALMAC_REG_R8(REG_DBI_FLAG_V1 + 2);
+
+	cnt = 20;
+	while (tmp_u1b && (cnt != 0)) {
+		usleep_range(10, 20);
+		tmp_u1b = HALMAC_REG_R8(REG_DBI_FLAG_V1 + 2);
+		cnt--;
+	}
+
+	if (tmp_u1b) {
+		ret  = 0xFF;
+		pr_err("DBI read fail!\n");
+	} else {
+		ret = HALMAC_REG_R8(REG_DBI_RDATA_V1 + (addr & (4 - 1)));
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "Value-R = %x\n", ret);
+	}
+
+	return ret;
+}
+
+enum halmac_ret_status
+trxdma_check_idle_88xx(struct halmac_adapter *adapter)
+{
+	u32 cnt = 0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	/* Stop Tx & Rx DMA */
+	HALMAC_REG_W32_SET(REG_RXPKT_NUM, BIT(18));
+	HALMAC_REG_W16_SET(REG_PCIE_CTRL, ~(BIT(15) | BIT(8)));
+
+	/* Stop FW */
+	HALMAC_REG_W16_CLR(REG_SYS_FUNC_EN, BIT(10));
+
+	/* Check Tx DMA is idle */
+	cnt = 20;
+	while ((HALMAC_REG_R8(REG_SYS_CFG5) & BIT(2)) == BIT(2)) {
+		usleep_range(10, 20);
+		cnt--;
+		if (cnt == 0) {
+			pr_err("Chk tx idle\n");
+			return HALMAC_RET_POWER_OFF_FAIL;
+		}
+	}
+
+	/* Check Rx DMA is idle */
+	cnt = 20;
+	while ((HALMAC_REG_R32(REG_RXPKT_NUM) & BIT(17)) != BIT(17)) {
+		usleep_range(10, 20);
+		cnt--;
+		if (cnt == 0) {
+			pr_err("Chk rx idle\n");
+			return HALMAC_RET_POWER_OFF_FAIL;
+		}
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+void
+en_ref_autok_88xx(struct halmac_adapter *adapter, u8 en)
+{
+	if (en == 1)
+		adapter->pcie_refautok_en = 1;
+	else
+		adapter->pcie_refautok_en = 0;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.h
new file mode 100644
index 000000000000..3c9bc50a327f
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_pcie_88xx.h
@@ -0,0 +1,98 @@
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
+#ifndef _HALMAC_PCIE_88XX_H_
+#define _HALMAC_PCIE_88XX_H_
+
+#include "../halmac_api.h"
+
+enum halmac_ret_status
+init_pcie_cfg_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+deinit_pcie_cfg_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+cfg_pcie_rx_agg_88xx(struct halmac_adapter *adapter,
+		     struct halmac_rxagg_cfg *cfg);
+
+u8
+reg_r8_pcie_88xx(struct halmac_adapter *adapter, u32 offset);
+
+enum halmac_ret_status
+reg_w8_pcie_88xx(struct halmac_adapter *adapter, u32 offset, u8 value);
+
+u16
+reg_r16_pcie_88xx(struct halmac_adapter *adapter, u32 offset);
+
+enum halmac_ret_status
+reg_w16_pcie_88xx(struct halmac_adapter *adapter, u32 offset, u16 value);
+
+u32
+reg_r32_pcie_88xx(struct halmac_adapter *adapter, u32 offset);
+
+enum halmac_ret_status
+reg_w32_pcie_88xx(struct halmac_adapter *adapter, u32 offset, u32 value);
+
+enum halmac_ret_status
+cfg_txagg_pcie_align_88xx(struct halmac_adapter *adapter, u8 enable,
+			  u16 align_size);
+
+enum halmac_ret_status
+tx_allowed_pcie_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+u32
+pcie_indirect_reg_r32_88xx(struct halmac_adapter *adapter, u32 offset);
+
+enum halmac_ret_status
+pcie_reg_rn_88xx(struct halmac_adapter *adapter, u32 offset, u32 size,
+		 u8 *value);
+
+enum halmac_ret_status
+set_pcie_bulkout_num_88xx(struct halmac_adapter *adapter, u8 num);
+
+enum halmac_ret_status
+get_pcie_tx_addr_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size,
+		      u32 *cmd53_addr);
+
+enum halmac_ret_status
+get_pcie_bulkout_id_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size,
+			 u8 *id);
+
+enum halmac_ret_status
+mdio_write_88xx(struct halmac_adapter *adapter, u8 addr, u16 data, u8 speed);
+
+u16
+mdio_read_88xx(struct halmac_adapter *adapter, u8 addr, u8 speed);
+
+enum halmac_ret_status
+dbi_w32_88xx(struct halmac_adapter *adapter, u16 addr, u32 data);
+
+u32
+dbi_r32_88xx(struct halmac_adapter *adapter, u16 addr);
+
+enum halmac_ret_status
+dbi_w8_88xx(struct halmac_adapter *adapter, u16 addr, u8 data);
+
+u8
+dbi_r8_88xx(struct halmac_adapter *adapter, u16 addr);
+
+enum halmac_ret_status
+trxdma_check_idle_88xx(struct halmac_adapter *adapter);
+
+void
+en_ref_autok_88xx(struct halmac_adapter *dapter, u8 en);
+
+#endif/* _HALMAC_PCIE_88XX_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.c
new file mode 100644
index 000000000000..97a3112e63c6
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.c
@@ -0,0 +1,895 @@
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
+#include "halmac_sdio_88xx.h"
+#include "halmac_88xx_cfg.h"
+
+/* define the SDIO Bus CLK threshold */
+/* for avoiding CMD53 fails that result from SDIO CLK sync to ana_clk fail */
+#define SDIO_CLK_HIGH_SPEED_TH		50 /* 50MHz */
+#define SDIO_CLK_SPEED_MAX		208 /* 208MHz */
+
+/*only for r_indir_sdio_88xx !!, Soar 20171222*/
+static u8
+r_indir_cmd52_88xx(struct halmac_adapter *adapter, u32 offset);
+
+/*only for r_indir_sdio_88xx !!, Soar 20171222*/
+static u32
+r_indir_cmd53_88xx(struct halmac_adapter *adapter, u32 offset);
+
+/*only for r_indir_sdio_88xx !!, Soar 20171222*/
+static u32
+r8_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr);
+
+/*only for r_indir_sdio_88xx !!, Soar 20171222*/
+static u32
+r16_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr);
+
+/*only for r_indir_sdio_88xx !!, Soar 20171222*/
+static u32
+r32_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr);
+
+/*only for w_indir_sdio_88xx !!, Soar 20171222*/
+static enum halmac_ret_status
+w_indir_cmd52_88xx(struct halmac_adapter *adapter, u32 adr, u32 val,
+		   enum halmac_io_size size);
+
+/*only for w_indir_sdio_88xx !!, Soar 20171222*/
+static enum halmac_ret_status
+w_indir_cmd53_88xx(struct halmac_adapter *adapter, u32 adr, u32 val,
+		   enum halmac_io_size size);
+
+/*only for w_indir_sdio_88xx !!, Soar 20171222*/
+static enum halmac_ret_status
+w8_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr, u32 val);
+
+/*only for w_indir_sdio_88xx !!, Soar 20171222*/
+static enum halmac_ret_status
+w16_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr, u32 val);
+
+/*only for w_indir_sdio_88xx !!, Soar 20171222*/
+static enum halmac_ret_status
+w32_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr, u32 val);
+
+/**
+ * init_sdio_cfg_88xx() - init SDIO
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+init_sdio_cfg_88xx(struct halmac_adapter *adapter)
+{
+	u32 value32;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (adapter->intf != HALMAC_INTERFACE_SDIO)
+		return HALMAC_RET_WRONG_INTF;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	HALMAC_REG_R32(REG_SDIO_FREE_TXPG);
+
+	value32 = HALMAC_REG_R32(REG_SDIO_TX_CTRL) & 0xFFFF;
+	value32 &= ~(BIT_CMD_ERR_STOP_INT_EN | BIT_EN_MASK_TIMER |
+							BIT_EN_RXDMA_MASK_INT);
+	HALMAC_REG_W32(REG_SDIO_TX_CTRL, value32);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * deinit_sdio_cfg_88xx() - deinit SDIO
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+deinit_sdio_cfg_88xx(struct halmac_adapter *adapter)
+{
+	if (adapter->intf != HALMAC_INTERFACE_SDIO)
+		return HALMAC_RET_WRONG_INTF;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_sdio_rx_agg_88xx() - config rx aggregation
+ * @adapter : the adapter of halmac
+ * @halmac_rx_agg_mode
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_sdio_rx_agg_88xx(struct halmac_adapter *adapter,
+		     struct halmac_rxagg_cfg *cfg)
+{
+	u8 value8;
+	u8 size;
+	u8 timeout;
+	u8 agg_enable;
+	u32 value32;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	agg_enable = HALMAC_REG_R8(REG_TXDMA_PQ_MAP);
+
+	switch (cfg->mode) {
+	case HALMAC_RX_AGG_MODE_NONE:
+		agg_enable &= ~(BIT_RXDMA_AGG_EN);
+		break;
+	case HALMAC_RX_AGG_MODE_DMA:
+	case HALMAC_RX_AGG_MODE_USB:
+		agg_enable |= BIT_RXDMA_AGG_EN;
+		break;
+	default:
+		pr_err("unsupported mode\n");
+		agg_enable &= ~BIT_RXDMA_AGG_EN;
+		break;
+	}
+
+	if (cfg->threshold.drv_define == 0) {
+		size = 0xFF;
+		timeout = 0x01;
+	} else {
+		size = cfg->threshold.size;
+		timeout = cfg->threshold.timeout;
+	}
+
+	value32 = HALMAC_REG_R32(REG_RXDMA_AGG_PG_TH);
+	if (cfg->threshold.size_limit_en == 0)
+		HALMAC_REG_W32(REG_RXDMA_AGG_PG_TH, value32 & ~BIT_EN_PRE_CALC);
+	else
+		HALMAC_REG_W32(REG_RXDMA_AGG_PG_TH, value32 | BIT_EN_PRE_CALC);
+
+	HALMAC_REG_W8(REG_TXDMA_PQ_MAP, agg_enable);
+	HALMAC_REG_W16(REG_RXDMA_AGG_PG_TH,
+		       (u16)(size | (timeout << BIT_SHIFT_DMA_AGG_TO_V1)));
+
+	value8 = HALMAC_REG_R8(REG_RXDMA_MODE);
+	if (0 != (agg_enable & BIT_RXDMA_AGG_EN))
+		HALMAC_REG_W8(REG_RXDMA_MODE, value8 | BIT_DMA_MODE);
+	else
+		HALMAC_REG_W8(REG_RXDMA_MODE, value8 & ~(BIT_DMA_MODE));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * sdio_reg_rn_88xx() - read n byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * @halmac_size : register value size
+ * @value : register value
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+sdio_reg_rn_88xx(struct halmac_adapter *adapter, u32 offset, u32 size,
+		 u8 *value)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (0 == (offset & 0xFFFF0000)) {
+		pr_err("offset 0x%x\n", offset);
+		return HALMAC_RET_FAIL;
+	}
+
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &offset);
+	if (status != HALMAC_RET_SUCCESS) {
+		pr_err("convert offset\n");
+		return status;
+	}
+
+	if (adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF) {
+		pr_err("power off\n");
+		return HALMAC_RET_FAIL;
+	}
+
+	PLTFM_SDIO_CMD53_RN(offset, size, value);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_txagg_sdio_align_88xx() -config sdio bus tx agg alignment
+ * @adapter : the adapter of halmac
+ * @enable : function enable(1)/disable(0)
+ * @align_size : sdio bus tx agg alignment size (2^n, n = 3~11)
+ * Author : Soar Tu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_txagg_sdio_align_88xx(struct halmac_adapter *adapter, u8 enable,
+			  u16 align_size)
+{
+	u8 i;
+	u8 flag = 0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (adapter->chip_id == HALMAC_CHIP_ID_8822B)
+		return HALMAC_RET_NOT_SUPPORT;
+
+	if ((align_size & 0xF000) != 0) {
+		pr_err("out of range\n");
+		return HALMAC_RET_FAIL;
+	}
+
+	for (i = 3; i <= 11; i++) {
+		if (align_size == 1 << i) {
+			flag = 1;
+			break;
+		}
+	}
+
+	if (flag == 0) {
+		pr_err("not 2^3 ~ 2^11\n");
+		return HALMAC_RET_FAIL;
+	}
+
+	adapter->hw_cfg_info.tx_align_size = align_size;
+
+	if (enable)
+		HALMAC_REG_W16(REG_RQPN_CTRL_2, 0x8000 | align_size);
+	else
+		HALMAC_REG_W16(REG_RQPN_CTRL_2, align_size);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * sdio_indirect_reg_r32_88xx() - read MAC reg by SDIO reg
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+u32
+sdio_indirect_reg_r32_88xx(struct halmac_adapter *adapter, u32 offset)
+{
+	return r_indir_sdio_88xx(adapter, offset, HALMAC_IO_DWORD);
+}
+
+/**
+ * set_sdio_bulkout_num_88xx() - inform bulk-out num
+ * @adapter : the adapter of halmac
+ * @bulkout_num : usb bulk-out number
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+set_sdio_bulkout_num_88xx(struct halmac_adapter *adapter, u8 num)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+/**
+ * get_sdio_bulkout_id_88xx() - get bulk out id for the TX packet
+ * @adapter : the adapter of halmac
+ * @halmac_buf : tx packet, include txdesc
+ * @halmac_size : tx packet size
+ * @bulkout_id : usb bulk-out id
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_sdio_bulkout_id_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size,
+			 u8 *id)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+/**
+ * sdio_cmd53_4byte_88xx() - cmd53 only for 4byte len register IO
+ * @adapter : the adapter of halmac
+ * @enable : 1->CMD53 only use in 4byte reg, 0 : No limitation
+ * Author : Ivan Lin/KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+sdio_cmd53_4byte_88xx(struct halmac_adapter *adapter,
+		      enum halmac_sdio_cmd53_4byte_mode mode)
+{
+	if (adapter->intf != HALMAC_INTERFACE_SDIO)
+		return HALMAC_RET_WRONG_INTF;
+
+	if (adapter->api_registry.sdio_cmd53_4byte_en == 0)
+		return HALMAC_RET_NOT_SUPPORT;
+
+	adapter->sdio_cmd53_4byte = mode;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * sdio_hw_info_88xx() - info sdio hw info
+ * @adapter : the adapter of halmac
+ * @HALMAC_SDIO_CMD53_4BYTE_MODE :
+ * clock_speed : sdio bus clock. Unit -> MHz
+ * spec_ver : sdio spec version
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+sdio_hw_info_88xx(struct halmac_adapter *adapter,
+		  struct halmac_sdio_hw_info *info)
+{
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (adapter->intf != HALMAC_INTERFACE_SDIO)
+		return HALMAC_RET_WRONG_INTF;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+		 "SDIO clock:%d, spec:%d\n", info->clock_speed, info->spec_ver);
+
+	if (info->clock_speed > SDIO_CLK_SPEED_MAX)
+		return HALMAC_RET_SDIO_CLOCK_ERR;
+
+	if (info->clock_speed > SDIO_CLK_HIGH_SPEED_TH)
+		adapter->sdio_hw_info.io_hi_speed_flag = 1;
+
+	adapter->sdio_hw_info.io_indir_flag = info->io_indir_flag;
+	if (info->clock_speed > SDIO_CLK_HIGH_SPEED_TH &&
+	    adapter->sdio_hw_info.io_indir_flag == 0)
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_WARNING,
+			 "SDIO clock:%d, indir access is better\n",
+			 info->clock_speed);
+
+	adapter->sdio_hw_info.clock_speed = info->clock_speed;
+	adapter->sdio_hw_info.spec_ver = info->spec_ver;
+	adapter->sdio_hw_info.block_size = info->block_size;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+void
+cfg_sdio_tx_page_threshold_88xx(struct halmac_adapter *adapter,
+				struct halmac_tx_page_threshold_info *info)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	u32 threshold = info->threshold;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (info->enable == 1) {
+		threshold = BIT(31) | threshold;
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "enable\n");
+	} else {
+		threshold = ~(BIT(31)) & threshold;
+		RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG,
+			 "disable\n");
+	}
+
+	switch (info->dma_queue_sel) {
+	case HALMAC_MAP2_HQ:
+		HALMAC_REG_W32(REG_TQPNT1, threshold);
+		break;
+	case HALMAC_MAP2_NQ:
+		HALMAC_REG_W32(REG_TQPNT2, threshold);
+		break;
+	case HALMAC_MAP2_LQ:
+		HALMAC_REG_W32(REG_TQPNT3, threshold);
+		break;
+	case HALMAC_MAP2_EXQ:
+		HALMAC_REG_W32(REG_TQPNT4, threshold);
+		break;
+	default:
+		break;
+	}
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+}
+
+enum halmac_ret_status
+cnv_to_sdio_bus_offset_88xx(struct halmac_adapter *adapter, u32 *offset)
+{
+	switch ((*offset) & 0xFFFF0000) {
+	case WLAN_IOREG_OFFSET:
+		*offset &= HALMAC_WLAN_MAC_REG_MSK;
+		*offset |= HALMAC_SDIO_CMD_ADDR_MAC_REG << 13;
+		break;
+	case SDIO_LOCAL_OFFSET:
+		*offset &= HALMAC_SDIO_LOCAL_MSK;
+		*offset |= HALMAC_SDIO_CMD_ADDR_SDIO_REG << 13;
+		break;
+	default:
+		*offset = 0xFFFFFFFF;
+		pr_err("base address!!\n");
+		return HALMAC_RET_CONVERT_SDIO_OFFSET_FAIL;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+leave_sdio_suspend_88xx(struct halmac_adapter *adapter)
+{
+	u8 value8;
+	u32 cnt;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	value8 = HALMAC_REG_R8(REG_SDIO_HSUS_CTRL);
+	HALMAC_REG_W8(REG_SDIO_HSUS_CTRL, value8 & ~(BIT(0)));
+
+	cnt = 10000;
+	while (!(HALMAC_REG_R8(REG_SDIO_HSUS_CTRL) & 0x02)) {
+		cnt--;
+		if (cnt == 0)
+			return HALMAC_RET_SDIO_LEAVE_SUSPEND_FAIL;
+	}
+
+	value8 = HALMAC_REG_R8(REG_HCI_OPT_CTRL + 2);
+	if (adapter->sdio_hw_info.spec_ver == HALMAC_SDIO_SPEC_VER_3_00)
+		HALMAC_REG_W8(REG_HCI_OPT_CTRL + 2, value8 | BIT(2));
+	else
+		HALMAC_REG_W8(REG_HCI_OPT_CTRL + 2, value8 & ~(BIT(2)));
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/*only for r_indir_sdio_88xx !!, Soar 20171222*/
+static u8
+r_indir_cmd52_88xx(struct halmac_adapter *adapter, u32 offset)
+{
+	u8 value8, tmp, cnt = 50;
+	u32 reg_cfg = REG_SDIO_INDIRECT_REG_CFG;
+	u32 reg_data = REG_SDIO_INDIRECT_REG_DATA;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &reg_cfg);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &reg_data);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	PLTFM_SDIO_CMD52_W(reg_cfg, (u8)offset);
+	PLTFM_SDIO_CMD52_W(reg_cfg + 1, (u8)(offset >> 8));
+	PLTFM_SDIO_CMD52_W(reg_cfg + 2, (u8)(BIT(3) | BIT(4)));
+
+	do {
+		tmp = PLTFM_SDIO_CMD52_R(reg_cfg + 2);
+		cnt--;
+	} while (((tmp & BIT(4)) == 0) && (cnt > 0));
+
+	if (((cnt & BIT(4)) == 0) && cnt == 0)
+		pr_err("sdio indirect CMD52 read\n");
+
+	value8 = PLTFM_SDIO_CMD52_R(reg_data);
+
+	return value8;
+}
+
+/*only for r_indir_sdio_88xx !!, Soar 20171222*/
+static u32
+r_indir_cmd53_88xx(struct halmac_adapter *adapter, u32 offset)
+{
+	u8 cnt = 50;
+	u8 value[6];
+	u32 reg_cfg = REG_SDIO_INDIRECT_REG_CFG;
+	u32 reg_data = REG_SDIO_INDIRECT_REG_DATA;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	union {
+		__le32 dword;
+		u8 byte[4];
+	} value32 = { 0x00000000 };
+
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &reg_cfg);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &reg_data);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	PLTFM_SDIO_CMD53_W32(reg_cfg, offset | BIT(19) | BIT(20));
+
+	do {
+		PLTFM_SDIO_CMD53_RN(reg_cfg + 2, sizeof(value), value);
+		cnt--;
+	} while (((value[0] & BIT(4)) == 0) && (cnt > 0));
+
+	if (((cnt & BIT(4)) == 0) && cnt == 0)
+		pr_err("sdio indirect CMD53 read\n");
+
+	value32.byte[0] = value[2];
+	value32.byte[1] = value[3];
+	value32.byte[2] = value[4];
+	value32.byte[3] = value[5];
+
+	return le32_to_cpu(value32.dword);
+}
+
+/*only for r_indir_sdio_88xx !!, Soar 20171222*/
+static u32
+r8_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr)
+{
+	union {
+		__le32 dword;
+		u8 byte[4];
+	} val = { 0x00000000 };
+
+	if (adapter->pwr_off_flow_flag == 1 ||
+	    adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF) {
+		val.byte[0] = r_indir_cmd52_88xx(adapter, adr);
+		return le32_to_cpu(val.dword);
+	}
+
+	return r_indir_cmd53_88xx(adapter, adr);
+}
+
+/*only for r_indir_sdio_88xx !!, Soar 20171222*/
+static u32
+r16_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr)
+{
+	u32 reg_data = REG_SDIO_INDIRECT_REG_DATA;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	union {
+		__le32 dword;
+		u8 byte[4];
+	} val = { 0x00000000 };
+
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &reg_data);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	if (adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF) {
+		if (0 != (adr & (2 - 1))) {
+			val.byte[0] = r_indir_cmd52_88xx(adapter, adr);
+			val.byte[1] = r_indir_cmd52_88xx(adapter, adr + 1);
+		} else {
+			val.byte[0] = r_indir_cmd52_88xx(adapter, adr);
+			val.byte[1] = PLTFM_SDIO_CMD52_R(reg_data + 1);
+		}
+
+		return  le32_to_cpu(val.dword);
+	}
+
+	if (0 != (adr & (2 - 1))) {
+		val.byte[0] = (u8)r_indir_cmd53_88xx(adapter, adr);
+		val.byte[1] = (u8)r_indir_cmd53_88xx(adapter, adr + 1);
+
+		return le32_to_cpu(val.dword);
+	}
+
+	return r_indir_cmd53_88xx(adapter, adr);
+}
+
+/*only for r_indir_sdio_88xx !!, Soar 20171222*/
+static u32
+r32_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr)
+{
+	u32 reg_data = REG_SDIO_INDIRECT_REG_DATA;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	union {
+		__le32 dword;
+		u8 byte[4];
+	} val = { 0x00000000 };
+
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &reg_data);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	if (adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF) {
+		if (0 != (adr & (4 - 1))) {
+			val.byte[0] = r_indir_cmd52_88xx(adapter, adr);
+			val.byte[1] = r_indir_cmd52_88xx(adapter, adr + 1);
+			val.byte[2] = r_indir_cmd52_88xx(adapter, adr + 2);
+			val.byte[3] = r_indir_cmd52_88xx(adapter, adr + 3);
+		} else {
+			val.byte[0] = r_indir_cmd52_88xx(adapter, adr);
+			val.byte[1] = PLTFM_SDIO_CMD52_R(reg_data + 1);
+			val.byte[2] = PLTFM_SDIO_CMD52_R(reg_data + 2);
+			val.byte[3] = PLTFM_SDIO_CMD52_R(reg_data + 3);
+		}
+
+		return le32_to_cpu(val.dword);
+	}
+
+	if (0 != (adr & (4 - 1))) {
+		val.byte[0] = (u8)r_indir_cmd53_88xx(adapter, adr);
+		val.byte[1] = (u8)r_indir_cmd53_88xx(adapter, adr + 1);
+		val.byte[2] = (u8)r_indir_cmd53_88xx(adapter, adr + 2);
+		val.byte[3] = (u8)r_indir_cmd53_88xx(adapter, adr + 3);
+
+		return le32_to_cpu(val.dword);
+	}
+
+	return r_indir_cmd53_88xx(adapter, adr);
+}
+
+u32
+r_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr,
+		  enum halmac_io_size size)
+{
+	u32 value32 = 0;
+
+	mutex_lock(&adapter->sdio_indir_mutex);
+
+	switch (size) {
+	case HALMAC_IO_BYTE:
+		value32 = r8_indir_sdio_88xx(adapter, adr);
+		break;
+	case HALMAC_IO_WORD:
+		value32 = r16_indir_sdio_88xx(adapter, adr);
+		break;
+	case HALMAC_IO_DWORD:
+		value32 = r32_indir_sdio_88xx(adapter, adr);
+		break;
+	default:
+		break;
+	}
+
+	mutex_unlock(&adapter->sdio_indir_mutex);
+
+	return value32;
+}
+
+/*only for w_indir_sdio_88xx !!, Soar 20171222*/
+static enum halmac_ret_status
+w_indir_cmd52_88xx(struct halmac_adapter *adapter, u32 adr, u32 val,
+		   enum halmac_io_size size)
+{
+	u8 tmp, cnt = 50;
+	u32 reg_cfg = REG_SDIO_INDIRECT_REG_CFG;
+	u32 reg_data = REG_SDIO_INDIRECT_REG_DATA;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &reg_cfg);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &reg_data);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	PLTFM_SDIO_CMD52_W(reg_cfg, (u8)adr);
+	PLTFM_SDIO_CMD52_W(reg_cfg + 1, (u8)(adr >> 8));
+	switch (size) {
+	case HALMAC_IO_BYTE:
+		PLTFM_SDIO_CMD52_W(reg_data, (u8)val);
+		PLTFM_SDIO_CMD52_W(reg_cfg + 2, (u8)(BIT(2) | BIT(4)));
+		break;
+	case HALMAC_IO_WORD:
+		PLTFM_SDIO_CMD52_W(reg_data, (u8)val);
+		PLTFM_SDIO_CMD52_W(reg_data + 1, (u8)(val >> 8));
+		PLTFM_SDIO_CMD52_W(reg_cfg + 2,
+				   (u8)(BIT(0) | BIT(2) | BIT(4)));
+		break;
+	case HALMAC_IO_DWORD:
+		PLTFM_SDIO_CMD52_W(reg_data, (u8)val);
+		PLTFM_SDIO_CMD52_W(reg_data + 1, (u8)(val >> 8));
+		PLTFM_SDIO_CMD52_W(reg_data + 2, (u8)(val >> 16));
+		PLTFM_SDIO_CMD52_W(reg_data + 3, (u8)(val >> 24));
+		PLTFM_SDIO_CMD52_W(reg_cfg + 2,
+				   (u8)(BIT(1) | BIT(2) | BIT(4)));
+		break;
+	default:
+		break;
+	}
+
+	do {
+		tmp = PLTFM_SDIO_CMD52_R(reg_cfg + 2);
+		cnt--;
+	} while (((tmp & BIT(4)) == 0) && (cnt > 0));
+
+	if (((cnt & BIT(4)) == 0) && cnt == 0)
+		pr_err("sdio indirect CMD52 write\n");
+
+	return status;
+}
+
+/*only for w_indir_sdio_88xx !!, Soar 20171222*/
+static enum halmac_ret_status
+w_indir_cmd53_88xx(struct halmac_adapter *adapter, u32 adr, u32 val,
+		   enum halmac_io_size size)
+{
+	u8 tmp, cnt = 50;
+	u32 reg_cfg = REG_SDIO_INDIRECT_REG_CFG;
+	u32 reg_data = REG_SDIO_INDIRECT_REG_DATA;
+	u32 value32 = 0;
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &reg_cfg);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+	status = cnv_to_sdio_bus_offset_88xx(adapter, &reg_data);
+	if (status != HALMAC_RET_SUCCESS)
+		return status;
+
+	switch (size) {
+	case HALMAC_IO_BYTE:
+		value32 = adr | BIT(18) | BIT(20);
+		break;
+	case HALMAC_IO_WORD:
+		value32 = adr | BIT(16) | BIT(18) | BIT(20);
+		break;
+	case HALMAC_IO_DWORD:
+		value32 = adr | BIT(17) | BIT(18) | BIT(20);
+		break;
+	default:
+		return HALMAC_RET_FAIL;
+	}
+
+	PLTFM_SDIO_CMD53_W32(reg_data, val);
+	PLTFM_SDIO_CMD53_W32(reg_cfg, value32);
+
+	do {
+		tmp = PLTFM_SDIO_CMD52_R(reg_cfg + 2);
+		cnt--;
+	} while (((tmp & BIT(4)) == 0) && (cnt > 0));
+
+	if (((cnt & BIT(4)) == 0) && cnt == 0)
+		pr_err("sdio indirect CMD53 read\n");
+
+	return status;
+}
+
+/*only for w_indir_sdio_88xx !!, Soar 20171222*/
+static enum halmac_ret_status
+w8_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr, u32 val)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (adapter->pwr_off_flow_flag == 1 ||
+	    adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF)
+		status = w_indir_cmd52_88xx(adapter, adr, val, HALMAC_IO_BYTE);
+	else
+		status = w_indir_cmd53_88xx(adapter, adr, val, HALMAC_IO_BYTE);
+	return status;
+}
+
+/*only for w_indir_sdio_88xx !!, Soar 20171222*/
+static enum halmac_ret_status
+w16_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr, u32 val)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF) {
+		if (0 != (adr & (2 - 1))) {
+			status = w_indir_cmd52_88xx(adapter, adr, val,
+						    HALMAC_IO_BYTE);
+			if (status != HALMAC_RET_SUCCESS)
+				return status;
+			status = w_indir_cmd52_88xx(adapter, adr + 1, val >> 8,
+						    HALMAC_IO_BYTE);
+		} else {
+			status = w_indir_cmd52_88xx(adapter, adr, val,
+						    HALMAC_IO_WORD);
+		}
+	} else {
+		if (0 != (adr & (2 - 1))) {
+			status = w_indir_cmd53_88xx(adapter, adr, val,
+						    HALMAC_IO_BYTE);
+			if (status != HALMAC_RET_SUCCESS)
+				return status;
+			status = w_indir_cmd53_88xx(adapter, adr + 1, val >> 8,
+						    HALMAC_IO_BYTE);
+		} else {
+			status = w_indir_cmd53_88xx(adapter, adr, val,
+						    HALMAC_IO_WORD);
+		}
+	}
+	return status;
+}
+
+/*only for w_indir_sdio_88xx !!, Soar 20171222*/
+static enum halmac_ret_status
+w32_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr, u32 val)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	if (adapter->halmac_state.mac_pwr == HALMAC_MAC_POWER_OFF) {
+		if (0 != (adr & (4 - 1))) {
+			status = w_indir_cmd52_88xx(adapter, adr, val,
+						    HALMAC_IO_BYTE);
+			if (status != HALMAC_RET_SUCCESS)
+				return status;
+			status = w_indir_cmd52_88xx(adapter, adr + 1, val >> 8,
+						    HALMAC_IO_BYTE);
+			if (status != HALMAC_RET_SUCCESS)
+				return status;
+			status = w_indir_cmd52_88xx(adapter, adr + 2, val >> 16,
+						    HALMAC_IO_BYTE);
+			if (status != HALMAC_RET_SUCCESS)
+				return status;
+			status = w_indir_cmd52_88xx(adapter, adr + 3, val >> 24,
+						    HALMAC_IO_BYTE);
+		} else {
+			status = w_indir_cmd52_88xx(adapter, adr, val,
+						    HALMAC_IO_DWORD);
+		}
+	} else {
+		if (0 != (adr & (4 - 1))) {
+			status = w_indir_cmd53_88xx(adapter, adr, val,
+						    HALMAC_IO_BYTE);
+			if (status != HALMAC_RET_SUCCESS)
+				return status;
+			status = w_indir_cmd53_88xx(adapter, adr + 1, val >> 8,
+						    HALMAC_IO_BYTE);
+			if (status != HALMAC_RET_SUCCESS)
+				return status;
+			status = w_indir_cmd53_88xx(adapter, adr + 2, val >> 16,
+						    HALMAC_IO_BYTE);
+			if (status != HALMAC_RET_SUCCESS)
+				return status;
+			status = w_indir_cmd53_88xx(adapter, adr + 3, val >> 24,
+						    HALMAC_IO_BYTE);
+		} else {
+			status = w_indir_cmd53_88xx(adapter, adr, val,
+						    HALMAC_IO_DWORD);
+		}
+	}
+	return status;
+}
+
+enum halmac_ret_status
+w_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr, u32 val,
+		  enum halmac_io_size size)
+{
+	enum halmac_ret_status status = HALMAC_RET_SUCCESS;
+
+	mutex_lock(&adapter->sdio_indir_mutex);
+
+	switch (size) {
+	case HALMAC_IO_BYTE:
+		status = w8_indir_sdio_88xx(adapter, adr, val);
+		break;
+	case HALMAC_IO_WORD:
+		status = w16_indir_sdio_88xx(adapter, adr, val);
+		break;
+	case HALMAC_IO_DWORD:
+		status = w32_indir_sdio_88xx(adapter, adr, val);
+		break;
+	default:
+		break;
+	}
+
+	mutex_unlock(&adapter->sdio_indir_mutex);
+
+	return status;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.h
new file mode 100644
index 000000000000..d16c80902486
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_sdio_88xx.h
@@ -0,0 +1,75 @@
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
+#ifndef _HALMAC_SDIO_88XX_H_
+#define _HALMAC_SDIO_88XX_H_
+
+#include "../halmac_api.h"
+
+enum halmac_ret_status
+init_sdio_cfg_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+deinit_sdio_cfg_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+cfg_sdio_rx_agg_88xx(struct halmac_adapter *adapter,
+		     struct halmac_rxagg_cfg *cfg);
+
+enum halmac_ret_status
+cfg_txagg_sdio_align_88xx(struct halmac_adapter *adapter, u8 enable,
+			  u16 align_size);
+
+u32
+sdio_indirect_reg_r32_88xx(struct halmac_adapter *adapter, u32 offset);
+
+enum halmac_ret_status
+sdio_reg_rn_88xx(struct halmac_adapter *adapter, u32 offset, u32 size,
+		 u8 *value);
+
+enum halmac_ret_status
+set_sdio_bulkout_num_88xx(struct halmac_adapter *adapter, u8 num);
+
+enum halmac_ret_status
+get_sdio_bulkout_id_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size,
+			 u8 *id);
+
+enum halmac_ret_status
+sdio_cmd53_4byte_88xx(struct halmac_adapter *adapter,
+		      enum halmac_sdio_cmd53_4byte_mode mode);
+
+enum halmac_ret_status
+sdio_hw_info_88xx(struct halmac_adapter *adapter,
+		  struct halmac_sdio_hw_info *info);
+
+void
+cfg_sdio_tx_page_threshold_88xx(struct halmac_adapter *adapter,
+				struct halmac_tx_page_threshold_info *info);
+
+enum halmac_ret_status
+cnv_to_sdio_bus_offset_88xx(struct halmac_adapter *adapter, u32 *offset);
+
+enum halmac_ret_status
+leave_sdio_suspend_88xx(struct halmac_adapter *adapter);
+
+u32
+r_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr,
+		  enum halmac_io_size size);
+
+enum halmac_ret_status
+w_indir_sdio_88xx(struct halmac_adapter *adapter, u32 adr, u32 val,
+		  enum halmac_io_size size);
+
+#endif/* _HALMAC_SDIO_88XX_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.c b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.c
new file mode 100644
index 000000000000..8ab1d31fb227
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.c
@@ -0,0 +1,522 @@
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
+#include "halmac_usb_88xx.h"
+
+enum usb_burst_size {
+	USB_BURST_SIZE_3_0 = 0x0,
+	USB_BURST_SIZE_2_0_HS = 0x1,
+	USB_BURST_SIZE_2_0_FS = 0x2,
+	USB_BURST_SIZE_2_0_OTHERS = 0x3,
+	USB_BURST_SIZE_UNDEFINE = 0x7F,
+};
+
+/**
+ * init_usb_cfg_88xx() - init USB
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+init_usb_cfg_88xx(struct halmac_adapter *adapter)
+{
+	u8 value8 = 0;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	value8 |= (BIT_DMA_MODE | (0x3 << BIT_SHIFT_BURST_CNT));
+
+	if (HALMAC_REG_R8(REG_SYS_CFG2 + 3) == 0x20) {
+		 /* usb3.0 */
+		value8 |= (USB_BURST_SIZE_3_0 << BIT_SHIFT_BURST_SIZE);
+	} else {
+		if ((HALMAC_REG_R8(REG_USB_USBSTAT) & 0x3) == 0x1)/* usb2.0 */
+			value8 |= USB_BURST_SIZE_2_0_HS << BIT_SHIFT_BURST_SIZE;
+		else /* usb1.1 */
+			value8 |= USB_BURST_SIZE_2_0_FS << BIT_SHIFT_BURST_SIZE;
+	}
+
+	HALMAC_REG_W8(REG_RXDMA_MODE, value8);
+	HALMAC_REG_W16_SET(REG_TXDMA_OFFSET_CHK, BIT_DROP_DATA_EN);
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * deinit_usb_cfg_88xx() - deinit USB
+ * @adapter : the adapter of halmac
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+deinit_usb_cfg_88xx(struct halmac_adapter *adapter)
+{
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_usb_rx_agg_88xx() - config rx aggregation
+ * @adapter : the adapter of halmac
+ * @halmac_rx_agg_mode
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_usb_rx_agg_88xx(struct halmac_adapter *adapter,
+		    struct halmac_rxagg_cfg *cfg)
+{
+	u8 dma_usb_agg;
+	u8 size;
+	u8 timeout;
+	u8 agg_enable;
+	u32 value32;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	dma_usb_agg = HALMAC_REG_R8(REG_RXDMA_AGG_PG_TH + 3);
+	agg_enable = HALMAC_REG_R8(REG_TXDMA_PQ_MAP);
+
+	switch (cfg->mode) {
+	case HALMAC_RX_AGG_MODE_NONE:
+		agg_enable &= ~BIT_RXDMA_AGG_EN;
+		break;
+	case HALMAC_RX_AGG_MODE_DMA:
+		agg_enable |= BIT_RXDMA_AGG_EN;
+		dma_usb_agg |= BIT(7);
+		break;
+
+	case HALMAC_RX_AGG_MODE_USB:
+		agg_enable |= BIT_RXDMA_AGG_EN;
+		dma_usb_agg &= ~BIT(7);
+		break;
+	default:
+		pr_err("unsupported mode\n");
+		agg_enable &= ~BIT_RXDMA_AGG_EN;
+		break;
+	}
+
+	if (cfg->threshold.drv_define == 0) {
+		if (HALMAC_REG_R8(REG_SYS_CFG2 + 3) == 0x20) {
+			/* usb3.0 */
+			size = 0x5;
+			timeout = 0xA;
+		} else {
+			/* usb2.0 */
+			size = 0x5;
+			timeout = 0x20;
+		}
+	} else {
+		size = cfg->threshold.size;
+		timeout = cfg->threshold.timeout;
+	}
+
+	value32 = HALMAC_REG_R32(REG_RXDMA_AGG_PG_TH);
+	if (cfg->threshold.size_limit_en == 0)
+		HALMAC_REG_W32(REG_RXDMA_AGG_PG_TH, value32 & ~BIT_EN_PRE_CALC);
+	else
+		HALMAC_REG_W32(REG_RXDMA_AGG_PG_TH, value32 | BIT_EN_PRE_CALC);
+
+	HALMAC_REG_W8(REG_TXDMA_PQ_MAP, agg_enable);
+	HALMAC_REG_W8(REG_RXDMA_AGG_PG_TH + 3, dma_usb_agg);
+	HALMAC_REG_W16(REG_RXDMA_AGG_PG_TH,
+		       (u16)(size | (timeout << BIT_SHIFT_DMA_AGG_TO_V1)));
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * reg_r8_usb_88xx() - read 1byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+u8
+reg_r8_usb_88xx(struct halmac_adapter *adapter, u32 offset)
+{
+	return PLTFM_REG_R8(offset);
+}
+
+/**
+ * reg_w8_usb_88xx() - write 1byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * @value : register value
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+reg_w8_usb_88xx(struct halmac_adapter *adapter, u32 offset, u8 value)
+{
+	PLTFM_REG_W8(offset, value);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * reg_r16_usb_88xx() - read 2byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+u16
+reg_r16_usb_88xx(struct halmac_adapter *adapter, u32 offset)
+{
+	return PLTFM_REG_R16(offset);
+}
+
+/**
+ * reg_w16_usb_88xx() - write 2byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * @value : register value
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+reg_w16_usb_88xx(struct halmac_adapter *adapter, u32 offset, u16 value)
+{
+	PLTFM_REG_W16(offset, value);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * reg_r32_usb_88xx() - read 4byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+u32
+reg_r32_usb_88xx(struct halmac_adapter *adapter, u32 offset)
+{
+	return PLTFM_REG_R32(offset);
+}
+
+/**
+ * reg_w32_usb_88xx() - write 4byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * @value : register value
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+reg_w32_usb_88xx(struct halmac_adapter *adapter, u32 offset, u32 value)
+{
+	PLTFM_REG_W32(offset, value);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * set_usb_bulkout_num_88xx() - inform bulk-out num
+ * @adapter : the adapter of halmac
+ * @bulkout_num : usb bulk-out number
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+set_usb_bulkout_num_88xx(struct halmac_adapter *adapter, u8 num)
+{
+	adapter->bulkout_num = num;
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * get_usb_bulkout_id_88xx() - get bulk out id for the TX packet
+ * @adapter : the adapter of halmac
+ * @buf : tx packet, include txdesc
+ * @size : tx packet size
+ * @id : usb bulk-out id
+ * Author : KaiYuan Chang
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_usb_bulkout_id_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size,
+			u8 *id)
+{
+	enum halmac_qsel queue_sel;
+	enum halmac_dma_mapping dma_mapping;
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s ===>\n",
+		 __func__);
+
+	if (!buf) {
+		pr_err("buf is NULL!!\n");
+		return HALMAC_RET_DATA_BUF_NULL;
+	}
+
+	if (size == 0) {
+		pr_err("size is 0!!\n");
+		return HALMAC_RET_DATA_SIZE_INCORRECT;
+	}
+
+	queue_sel = (enum halmac_qsel)GET_TX_DESC_QSEL(buf);
+
+	switch (queue_sel) {
+	case HALMAC_QSEL_VO:
+	case HALMAC_QSEL_VO_V2:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_VO];
+		break;
+	case HALMAC_QSEL_VI:
+	case HALMAC_QSEL_VI_V2:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_VI];
+		break;
+	case HALMAC_QSEL_BE:
+	case HALMAC_QSEL_BE_V2:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_BE];
+		break;
+	case HALMAC_QSEL_BK:
+	case HALMAC_QSEL_BK_V2:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_BK];
+		break;
+	case HALMAC_QSEL_MGNT:
+		dma_mapping = adapter->pq_map[HALMAC_PQ_MAP_MG];
+		break;
+	case HALMAC_QSEL_HIGH:
+	case HALMAC_QSEL_BCN:
+	case HALMAC_QSEL_CMD:
+		dma_mapping = HALMAC_DMA_MAPPING_HIGH;
+		break;
+	default:
+		pr_err("Qsel is out of range\n");
+		return HALMAC_RET_QSEL_INCORRECT;
+	}
+
+	switch (dma_mapping) {
+	case HALMAC_DMA_MAPPING_HIGH:
+		*id = 0;
+		break;
+	case HALMAC_DMA_MAPPING_NORMAL:
+		*id = 1;
+		break;
+	case HALMAC_DMA_MAPPING_LOW:
+		*id = 2;
+		break;
+	case HALMAC_DMA_MAPPING_EXTRA:
+		*id = 3;
+		break;
+	default:
+		pr_err("out of range\n");
+		return HALMAC_RET_DMA_MAP_INCORRECT;
+	}
+
+	RT_TRACE(adapter->drv_adapter, COMP_HALMAC, DBG_DMESG, "%s <===\n",
+		 __func__);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+/**
+ * cfg_txagg_usb_align_88xx() -config sdio bus tx agg alignment
+ * @adapter : the adapter of halmac
+ * @enable : function enable(1)/disable(0)
+ * @align_size : sdio bus tx agg alignment size (2^n, n = 3~11)
+ * Author : Soar Tu
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+cfg_txagg_usb_align_88xx(struct halmac_adapter *adapter, u8 enable,
+			 u16 align_size)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+/**
+ * tx_allowed_usb_88xx() - check tx status
+ * @adapter : the adapter of halmac
+ * @buf : tx packet, include txdesc
+ * @size : tx packet size, include txdesc
+ * Author : Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+tx_allowed_usb_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+/**
+ * usb_indirect_reg_r32_88xx() - read MAC reg by SDIO reg
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+u32
+usb_indirect_reg_r32_88xx(struct halmac_adapter *adapter, u32 offset)
+{
+	return 0xFFFFFFFF;
+}
+
+/**
+ * usb_reg_rn_88xx() - read n byte register
+ * @adapter : the adapter of halmac
+ * @offset : register offset
+ * @size : register value size
+ * @value : register value
+ * Author : Soar
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+usb_reg_rn_88xx(struct halmac_adapter *adapter, u32 offset, u32 size,
+		u8 *value)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+/**
+ * get_usb_tx_addr_88xx() - get CMD53 addr for the TX packet
+ * @adapter : the adapter of halmac
+ * @buf : tx packet, include txdesc
+ * @size : tx packet size
+ * @pcmd53_addr : cmd53 addr value
+ * Author : KaiYuan Chang/Ivan Lin
+ * Return : enum halmac_ret_status
+ * More details of status code can be found in prototype document
+ */
+enum halmac_ret_status
+get_usb_tx_addr_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size,
+		     u32 *cmd53_addr)
+{
+	return HALMAC_RET_NOT_SUPPORT;
+}
+
+enum halmac_ret_status
+set_usb_mode_88xx(struct halmac_adapter *adapter, enum halmac_usb_mode mode)
+{
+	u32 usb_tmp;
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	enum halmac_usb_mode cur_mode;
+
+	cur_mode = (HALMAC_REG_R8(REG_SYS_CFG2 + 3) == 0x20) ?
+					HALMAC_USB_MODE_U3 : HALMAC_USB_MODE_U2;
+
+	/* check if HW supports usb2_usb3 switch */
+	usb_tmp = HALMAC_REG_R32(REG_PAD_CTRL2);
+	if (0 == (BIT_GET_USB23_SW_MODE_V1(usb_tmp) |
+	    (usb_tmp & BIT_USB3_USB2_TRANSITION))) {
+		pr_err("u2/u3 switch\n");
+		return HALMAC_RET_USB2_3_SWITCH_UNSUPPORT;
+	}
+
+	if (mode == cur_mode) {
+		pr_err("u2/u3 unchange\n");
+		return HALMAC_RET_USB_MODE_UNCHANGE;
+	}
+
+	/* Enable IO wrapper timeout */
+	if (adapter->chip_id == HALMAC_CHIP_ID_8822B ||
+	    adapter->chip_id == HALMAC_CHIP_ID_8821C)
+		HALMAC_REG_W8_CLR(REG_SW_MDIO + 3, BIT(0));
+
+	usb_tmp &= ~(BIT_USB23_SW_MODE_V1(0x3));
+
+	if (mode == HALMAC_USB_MODE_U2)
+		HALMAC_REG_W32(REG_PAD_CTRL2,
+			       usb_tmp |
+			       BIT_USB23_SW_MODE_V1(HALMAC_USB_MODE_U2) |
+			       BIT_RSM_EN_V1);
+	else
+		HALMAC_REG_W32(REG_PAD_CTRL2,
+			       usb_tmp |
+			       BIT_USB23_SW_MODE_V1(HALMAC_USB_MODE_U3) |
+			       BIT_RSM_EN_V1);
+
+	HALMAC_REG_W8(REG_PAD_CTRL2 + 1, 4);
+	HALMAC_REG_W16_SET(REG_SYS_PW_CTRL, BIT_APFM_OFFMAC);
+	usleep_range(1000, 1100);
+	HALMAC_REG_W32_SET(REG_PAD_CTRL2, BIT_NO_PDN_CHIPOFF_V1);
+
+	return HALMAC_RET_SUCCESS;
+}
+
+enum halmac_ret_status
+usbphy_write_88xx(struct halmac_adapter *adapter, u8 addr, u16 data, u8 speed)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+
+	if (speed == HAL_INTF_PHY_USB3) {
+		HALMAC_REG_W8(0xff0d, (u8)data);
+		HALMAC_REG_W8(0xff0e, (u8)(data >> 8));
+		HALMAC_REG_W8(0xff0c, addr | BIT(7));
+	} else if (speed == HAL_INTF_PHY_USB2) {
+		HALMAC_REG_W8(0xfe41, (u8)data);
+		HALMAC_REG_W8(0xfe40, addr);
+		HALMAC_REG_W8(0xfe42, 0x81);
+	} else {
+		pr_err("Error USB Speed !\n");
+		return HALMAC_RET_NOT_SUPPORT;
+	}
+
+	return HALMAC_RET_SUCCESS;
+}
+
+u16
+usbphy_read_88xx(struct halmac_adapter *adapter, u8 addr, u8 speed)
+{
+	struct halmac_api *api = (struct halmac_api *)adapter->halmac_api;
+	u16 value = 0;
+
+	if (speed == HAL_INTF_PHY_USB3) {
+		HALMAC_REG_W8(0xff0c, addr | BIT(6));
+		value = (u16)(HALMAC_REG_R32(0xff0c) >> 8);
+	} else if (speed == HAL_INTF_PHY_USB2) {
+		if (addr >= 0xE0)
+			addr -= 0x20;
+		if (addr >= 0xC0 && addr <= 0xDF) {
+			HALMAC_REG_W8(0xfe40, addr);
+			HALMAC_REG_W8(0xfe42, 0x81);
+			value = HALMAC_REG_R8(0xfe43);
+		} else {
+			pr_err("phy offset\n");
+			return HALMAC_RET_NOT_SUPPORT;
+		}
+	} else {
+		pr_err("usb speed !\n");
+		return HALMAC_RET_NOT_SUPPORT;
+	}
+
+	return value;
+}
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.h
new file mode 100644
index 000000000000..895215f8df1f
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_88xx/halmac_usb_88xx.h
@@ -0,0 +1,83 @@
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
+#ifndef _HALMAC_USB_88XX_H_
+#define _HALMAC_USB_88XX_H_
+
+#include "../halmac_api.h"
+
+enum halmac_ret_status
+init_usb_cfg_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+deinit_usb_cfg_88xx(struct halmac_adapter *adapter);
+
+enum halmac_ret_status
+cfg_usb_rx_agg_88xx(struct halmac_adapter *adapter,
+		    struct halmac_rxagg_cfg *cfg);
+
+u8
+reg_r8_usb_88xx(struct halmac_adapter *adapter, u32 offset);
+
+enum halmac_ret_status
+reg_w8_usb_88xx(struct halmac_adapter *adapter, u32 offset, u8 value);
+
+u16
+reg_r16_usb_88xx(struct halmac_adapter *adapter, u32 offset);
+
+enum halmac_ret_status
+reg_w16_usb_88xx(struct halmac_adapter *adapter, u32 offset, u16 value);
+
+u32
+reg_r32_usb_88xx(struct halmac_adapter *adapter, u32 offset);
+
+enum halmac_ret_status
+reg_w32_usb_88xx(struct halmac_adapter *adapter, u32 offset, u32 value);
+
+enum halmac_ret_status
+set_usb_bulkout_num_88xx(struct halmac_adapter *adapter, u8 num);
+
+enum halmac_ret_status
+get_usb_bulkout_id_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size,
+			u8 *id);
+
+enum halmac_ret_status
+cfg_txagg_usb_align_88xx(struct halmac_adapter *adapter, u8 enable,
+			 u16 align_size);
+
+enum halmac_ret_status
+tx_allowed_usb_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size);
+
+u32
+usb_indirect_reg_r32_88xx(struct halmac_adapter *adapter, u32 offset);
+
+enum halmac_ret_status
+usb_reg_rn_88xx(struct halmac_adapter *adapter, u32 offset, u32 size,
+		u8 *value);
+
+enum halmac_ret_status
+get_usb_tx_addr_88xx(struct halmac_adapter *adapter, u8 *buf, u32 size,
+		     u32 *cmd53_addr);
+
+enum halmac_ret_status
+set_usb_mode_88xx(struct halmac_adapter *adapter, enum halmac_usb_mode mode);
+
+enum halmac_ret_status
+usbphy_write_88xx(struct halmac_adapter *adapter, u8 addr, u16 data, u8 speed);
+
+u16
+usbphy_read_88xx(struct halmac_adapter *adapter, u8 addr, u8 speed);
+
+#endif/* _HALMAC_API_88XX_USB_H_ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_intf_phy_cmd.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_intf_phy_cmd.h
new file mode 100644
index 000000000000..f44bfa11e4d9
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_intf_phy_cmd.h
@@ -0,0 +1,45 @@
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
+#ifndef HALMAC_INTF_PHY_CMD
+#define HALMAC_INTF_PHY_CMD
+
+/* Cut mask */
+enum halmac_intf_phy_cut {
+	HALMAC_INTF_PHY_CUT_TESTCHIP = BIT(0),
+	HALMAC_INTF_PHY_CUT_A = BIT(1),
+	HALMAC_INTF_PHY_CUT_B = BIT(2),
+	HALMAC_INTF_PHY_CUT_C = BIT(3),
+	HALMAC_INTF_PHY_CUT_D = BIT(4),
+	HALMAC_INTF_PHY_CUT_E = BIT(5),
+	HALMAC_INTF_PHY_CUT_F = BIT(6),
+	HALMAC_INTF_PHY_CUT_G = BIT(7),
+	HALMAC_INTF_PHY_CUT_ALL = 0x7FFF,
+};
+
+/* IP selection */
+enum halmac_ip_sel {
+	HALMAC_IP_INTF_PHY = 0,
+	HALMAC_IP_SEL_MAC = 1,
+	HALMAC_IP_PCIE_DBI = 2,
+	HALMAC_IP_SEL_UNDEFINE = 0x7FFF,
+};
+
+/* Platform mask */
+enum halmac_intf_phy_platform {
+	HALMAC_INTF_PHY_PLATFORM_ALL = 0x7FFF,
+};
+
+#endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_pcie_reg.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_pcie_reg.h
new file mode 100644
index 000000000000..a2406bea00be
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_pcie_reg.h
@@ -0,0 +1,36 @@
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
+#ifndef __HALMAC_PCIE_REG_H__
+#define __HALMAC_PCIE_REG_H__
+
+/* PCIE PHY register */
+#define RAC_CTRL_PPR		0x00
+#define RAC_SET_PPR		0x20
+#define RAC_TRG_PPR		0x21
+
+/* PCIE CFG register */
+#define PCIE_L1_BACKDOOR		0x719
+#define PCIE_ASPM_CTRL			0x70F
+
+/* PCIE MAC register */
+#define LINK_CTRL2_REG_OFFSET		0xA0
+#define GEN2_CTRL_OFFSET		0x80C
+#define LINK_STATUS_REG_OFFSET		0x82
+
+#define PCIE_GEN1_SPEED			0x01
+#define PCIE_GEN2_SPEED			0x02
+
+#endif/* __HALMAC_PCIE_REG_H__ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_sdio_reg.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_sdio_reg.h
new file mode 100644
index 000000000000..53b6b85d0e43
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_sdio_reg.h
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
+#ifndef __HALMAC_SDIO_REG_H__
+#define __HALMAC_SDIO_REG_H__
+
+/* SDIO CMD address mapping */
+
+#define HALMAC_SDIO_4BYTE_LEN_MASK      0x1FFF
+#define HALMAC_SDIO_LOCAL_MSK           0x0FFF
+#define HALMAC_WLAN_MAC_REG_MSK		0xFFFF
+#define	HALMAC_WLAN_IOREG_MSK		0xFFFF
+
+/* Sdio Address for SDIO Local Reg, TRX FIFO, MAC Reg */
+enum halmac_sdio_cmd_addr {
+	HALMAC_SDIO_CMD_ADDR_SDIO_REG = 0,
+	HALMAC_SDIO_CMD_ADDR_MAC_REG = 8,
+	HALMAC_SDIO_CMD_ADDR_TXFF_HIGH = 4,
+	HALMAC_SDIO_CMD_ADDR_TXFF_LOW = 6,
+	HALMAC_SDIO_CMD_ADDR_TXFF_NORMAL = 5,
+	HALMAC_SDIO_CMD_ADDR_TXFF_EXTRA = 7,
+	HALMAC_SDIO_CMD_ADDR_RXFF = 7,
+};
+
+/* IO Bus domain address mapping */
+#define SDIO_LOCAL_OFFSET		0x10250000
+#define WLAN_IOREG_OFFSET		0x10260000
+#define FW_FIFO_OFFSET			0x10270000
+#define TX_HIQ_OFFSET			0x10310000
+#define TX_MIQ_OFFSET			0x10320000
+#define TX_LOQ_OFFSET			0x10330000
+#define TX_EXQ_OFFSET			0x10350000
+#define RX_RXOFF_OFFSET			0x10340000
+
+/* Get TX WLAN FIFO information in CMD53 addr  */
+#define GET_WLAN_TXFF_DEVICE_ID(cmd53_addr) \
+			LE_BITS_TO_4BYTE((u32 *)cmd53_addr, 13, 4)
+#define GET_WLAN_TXFF_PKT_SIZE(cmd53_addr) \
+			(LE_BITS_TO_4BYTE((u32 *)cmd53_addr, 0, 13) << 2)
+
+#endif/* __HALMAC_SDIO_REG_H__ */
diff --git a/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_usb_reg.h b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_usb_reg.h
new file mode 100644
index 000000000000..b856c55ef6cf
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtlwifi/halmac/halmac_usb_reg.h
@@ -0,0 +1,19 @@
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
+#ifndef __HALMAC_USB_REG_H__
+#define __HALMAC_USB_REG_H__
+
+#endif/* __HALMAC_USB_REG_H__ */
-- 
2.15.1
