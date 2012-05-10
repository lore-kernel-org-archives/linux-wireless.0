Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902Ab2EJJOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:14:47 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:14:46 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 07/78] wl18xx: add some boot operations and hw-specific configurations
Date: Thu, 10 May 2012 12:13:12 +0300
Message-Id: <1336641263-5761-8-git-send-email-arik@wizery.com> (sfid-20120510_111451_631779_4FF1A31C)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Implement the boot operation.  Add a wl18xx-specific configuration
structure (namely to configure the mac and phy parameters).

The default hw configuration matches the DVP board.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/conf.h |   57 +++++++++++
 drivers/net/wireless/ti/wl18xx/main.c |  180 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ti/wl18xx/reg.h  |   75 ++++++++++++++
 3 files changed, 311 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/ti/wl18xx/conf.h

diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
new file mode 100644
index 0000000..7cd7bf1
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -0,0 +1,57 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2011 Texas Instruments Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL18XX_CONF_H__
+#define __WL18XX_CONF_H__
+
+struct wl18xx_conf_phy {
+	u8 phy_standalone;
+	u8 rdl;
+	u8 enable_clpc;
+	u8 enable_tx_low_pwr_on_siso_rdl;
+	u8 auto_detect;
+	u8 dedicated_fem;
+	u8 low_band_component;
+	u8 low_band_component_type;
+	u8 high_band_component;
+	u8 high_band_component_type;
+	u8 number_of_assembled_ant2_4;
+	u8 number_of_assembled_ant5;
+	u8 external_pa_dc2dc;
+	u8 tcxo_ldo_voltage;
+	u8 xtal_itrim_val;
+	u8 srf_state;
+	u8 io_configuration;
+	u8 sdio_configuration;
+	u8 settings;
+	u8 rx_profile;
+	u8 primary_clock_setting_time;
+	u8 clock_valid_on_wake_up;
+	u8 secondary_clock_setting_time;
+};
+
+struct wl18xx_conf {
+	/* TODO: move the wlcore conf here? */
+
+	struct wl18xx_conf_phy phy;
+};
+
+#endif /* __WL18XX_CONF_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index e517afd..12632d0 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -24,8 +24,40 @@
 
 #include "../wlcore/wlcore.h"
 #include "../wlcore/debug.h"
+#include "../wlcore/io.h"
+#include "../wlcore/acx.h"
+#include "../wlcore/boot.h"
 
 #include "reg.h"
+#include "conf.h"
+
+static struct wl18xx_conf wl18xx_default_conf = {
+	.phy = {
+		.phy_standalone			= 0x00,
+		.primary_clock_setting_time	= 0x05,
+		.clock_valid_on_wake_up		= 0x00,
+		.secondary_clock_setting_time	= 0x05,
+		.rdl				= 0x01,
+		.auto_detect			= 0x00,
+		.dedicated_fem			= FEM_NONE,
+		.low_band_component		= COMPONENT_2_WAY_SWITCH,
+		.low_band_component_type	= 0x05,
+		.high_band_component		= COMPONENT_2_WAY_SWITCH,
+		.high_band_component_type	= 0x09,
+		.number_of_assembled_ant2_4	= 0x01,
+		.number_of_assembled_ant5	= 0x01,
+		.external_pa_dc2dc		= 0x00,
+		.tcxo_ldo_voltage		= 0x00,
+		.xtal_itrim_val			= 0x04,
+		.srf_state			= 0x00,
+		.io_configuration		= 0x01,
+		.sdio_configuration		= 0x00,
+		.settings			= 0x00,
+		.enable_clpc			= 0x00,
+		.enable_tx_low_pwr_on_siso_rdl	= 0x00,
+		.rx_profile			= 0x00,
+	},
+};
 
 static const struct wlcore_partition_set wl18xx_ptable[PART_TABLE_LEN] = {
 	[PART_TOP_PRCM_ELP_SOC] = {
@@ -107,8 +139,154 @@ out:
 	return ret;
 }
 
+static void wl18xx_set_clk(struct wl1271 *wl)
+{
+	/*
+	 * TODO: this is hardcoded just for DVP/EVB, fix according to
+	 * new unified_drv.
+	 */
+	wl1271_write32(wl, WL18XX_SCR_PAD2, 0xB3);
+
+	wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
+	wl1271_write32(wl, 0x00A02360, 0xD0078);
+	wl1271_write32(wl, 0x00A0236c, 0x12);
+	wl1271_write32(wl, 0x00A02390, 0x20118);
+}
+
+static void wl18xx_boot_soft_reset(struct wl1271 *wl)
+{
+	/* disable Rx/Tx */
+	wl1271_write32(wl, WL18XX_ENABLE, 0x0);
+
+	/* disable auto calibration on start*/
+	wl1271_write32(wl, WL18XX_SPARE_A2, 0xffff);
+}
+
+static int wl18xx_pre_boot(struct wl1271 *wl)
+{
+	/* TODO: add hw_pg_ver reading */
+
+	wl18xx_set_clk(wl);
+
+	/* Continue the ELP wake up sequence */
+	wl1271_write32(wl, WL18XX_WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
+	udelay(500);
+
+	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+
+	/* Disable interrupts */
+	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
+
+	wl18xx_boot_soft_reset(wl);
+
+	return 0;
+}
+
+static void wl18xx_pre_upload(struct wl1271 *wl)
+{
+	u32 tmp;
+
+	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+
+	/* TODO: check if this is all needed */
+	wl1271_write32(wl, WL18XX_EEPROMLESS_IND, WL18XX_EEPROMLESS_IND);
+
+	tmp = wlcore_read_reg(wl, REG_CHIP_ID_B);
+
+	wl1271_debug(DEBUG_BOOT, "chip id 0x%x", tmp);
+
+	tmp = wl1271_read32(wl, WL18XX_SCR_PAD2);
+}
+
+static void wl18xx_set_mac_and_phy(struct wl1271 *wl)
+{
+	struct wl18xx_mac_and_phy_params params;
+
+	memset(&params, 0, sizeof(params));
+
+	params.phy_standalone = wl18xx_default_conf.phy.phy_standalone;
+	params.rdl = wl18xx_default_conf.phy.rdl;
+	params.enable_clpc = wl18xx_default_conf.phy.enable_clpc;
+	params.enable_tx_low_pwr_on_siso_rdl =
+		wl18xx_default_conf.phy.enable_tx_low_pwr_on_siso_rdl;
+	params.auto_detect = wl18xx_default_conf.phy.auto_detect;
+	params.dedicated_fem = wl18xx_default_conf.phy.dedicated_fem;
+	params.low_band_component = wl18xx_default_conf.phy.low_band_component;
+	params.low_band_component_type =
+		wl18xx_default_conf.phy.low_band_component_type;
+	params.high_band_component =
+		wl18xx_default_conf.phy.high_band_component;
+	params.high_band_component_type =
+		wl18xx_default_conf.phy.high_band_component_type;
+	params.number_of_assembled_ant2_4 =
+		wl18xx_default_conf.phy.number_of_assembled_ant2_4;
+	params.number_of_assembled_ant5 =
+		wl18xx_default_conf.phy.number_of_assembled_ant5;
+	params.external_pa_dc2dc = wl18xx_default_conf.phy.external_pa_dc2dc;
+	params.tcxo_ldo_voltage = wl18xx_default_conf.phy.tcxo_ldo_voltage;
+	params.xtal_itrim_val = wl18xx_default_conf.phy.xtal_itrim_val;
+	params.srf_state = wl18xx_default_conf.phy.srf_state;
+	params.io_configuration = wl18xx_default_conf.phy.io_configuration;
+	params.sdio_configuration = wl18xx_default_conf.phy.sdio_configuration;
+	params.settings = wl18xx_default_conf.phy.settings;
+	params.rx_profile = wl18xx_default_conf.phy.rx_profile;
+	params.primary_clock_setting_time =
+		wl18xx_default_conf.phy.primary_clock_setting_time;
+	params.clock_valid_on_wake_up =
+		wl18xx_default_conf.phy.clock_valid_on_wake_up;
+	params.secondary_clock_setting_time =
+		wl18xx_default_conf.phy.secondary_clock_setting_time;
+
+	/* TODO: hardcoded for now */
+	params.board_type = BOARD_TYPE_DVP_EVB_18XX;
+
+	wlcore_set_partition(wl, &wl->ptable[PART_PHY_INIT]);
+	wl1271_write(wl, WL18XX_PHY_INIT_MEM_ADDR, (u8 *)&params,
+		     sizeof(params), false);
+}
+
+static void wl18xx_enable_interrupts(struct wl1271 *wl)
+{
+	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_ALL_EVENTS_VECTOR);
+
+	wlcore_enable_interrupts(wl);
+	wlcore_write_reg(wl, REG_INTERRUPT_MASK,
+			 WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
+}
+
+static int wl18xx_boot(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl18xx_pre_boot(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_boot_upload_nvs(wl);
+	if (ret < 0)
+		goto out;
+
+	wl18xx_pre_upload(wl);
+
+	ret = wlcore_boot_upload_firmware(wl);
+	if (ret < 0)
+		goto out;
+
+	wl18xx_set_mac_and_phy(wl);
+
+	ret = wlcore_boot_run_firmware(wl);
+	if (ret < 0)
+		goto out;
+
+	wl18xx_enable_interrupts(wl);
+
+out:
+	return ret;
+}
+
 static struct wlcore_ops wl18xx_ops = {
-	.identify_chip = wl18xx_identify_chip,
+	.identify_chip	= wl18xx_identify_chip,
+	.boot		= wl18xx_boot,
 };
 
 int __devinit wl18xx_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index 9af0c83..2916d69 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -102,6 +102,10 @@
 
 #define WL18XX_REG_COMMAND_MAILBOX_PTR	(WL18XX_SCR_PAD0)
 #define WL18XX_REG_EVENT_MAILBOX_PTR	(WL18XX_SCR_PAD1)
+#define WL18XX_EEPROMLESS_IND		(WL18XX_SCR_PAD4)
+
+#define WL18XX_WELP_ARM_COMMAND		(WL18XX_REGISTERS_BASE + 0x7100)
+#define WL18XX_ENABLE			(WL18XX_REGISTERS_BASE + 0x01543C)
 
 #define WL18XX_CMD_MBOX_ADDRESS		0xB007B4
 
@@ -109,4 +113,75 @@
 
 #define CHIP_ID_185x_PG10              (0x06030101)
 
+/* TODO: maybe move elsewhere? */
+#define NUM_OF_CHANNELS_11_ABG 150
+#define NUM_OF_CHANNELS_11_P 7
+#define WL18XX_NUM_OF_SUB_BANDS 9
+#define SRF_TABLE_LEN 16
+#define PIN_MUXING_SIZE 2
+
+enum {
+	COMPONENT_NO_SWITCH	= 0x0,
+	COMPONENT_2_WAY_SWITCH	= 0x1,
+	COMPONENT_3_WAY_SWITCH	= 0x2,
+	COMPONENT_MATCHING	= 0x3,
+};
+
+enum {
+	FEM_NONE	= 0x0,
+	FEM_VENDOR_1	= 0x1,
+	FEM_VENDOR_2	= 0x2,
+	FEM_VENDOR_3	= 0x3,
+};
+
+enum {
+	BOARD_TYPE_FPGA_18XX	= 0,
+	BOARD_TYPE_HDK_18XX	= 1,
+	BOARD_TYPE_DVP_EVB_18XX	= 2,
+};
+
+struct wl18xx_mac_and_phy_params {
+	u8 phy_standalone;
+	u8 rdl;
+	u8 enable_clpc;
+	u8 enable_tx_low_pwr_on_siso_rdl;
+	u8 auto_detect;
+	u8 dedicated_fem;
+
+	u8 low_band_component;
+
+	/* Bit 0: One Hot, Bit 1: Control Enable, Bit 2: 1.8V, Bit 3: 3V */
+	u8 low_band_component_type;
+
+	u8 high_band_component;
+
+	/* Bit 0: One Hot, Bit 1: Control Enable, Bit 2: 1.8V, Bit 3: 3V */
+	u8 high_band_component_type;
+	u8 number_of_assembled_ant2_4;
+	u8 number_of_assembled_ant5;
+	u8 pin_muxing_platform_options[PIN_MUXING_SIZE];
+	u8 external_pa_dc2dc;
+	u8 tcxo_ldo_voltage;
+	u8 xtal_itrim_val;
+	u8 srf_state;
+	u8 srf1[SRF_TABLE_LEN];
+	u8 srf2[SRF_TABLE_LEN];
+	u8 srf3[SRF_TABLE_LEN];
+	u8 io_configuration;
+	u8 sdio_configuration;
+	u8 settings;
+	u8 rx_profile;
+	u8 per_chan_pwr_limit_arr_11abg[NUM_OF_CHANNELS_11_ABG];
+	u8 pwr_limit_reference_11_abg;
+	u8 per_chan_pwr_limit_arr_11p[NUM_OF_CHANNELS_11_P];
+	u8 pwr_limit_reference_11p;
+	u8 per_sub_band_tx_trace_loss[WL18XX_NUM_OF_SUB_BANDS];
+	u8 per_sub_band_rx_trace_loss[WL18XX_NUM_OF_SUB_BANDS];
+	u8 primary_clock_setting_time;
+	u8 clock_valid_on_wake_up;
+	u8 secondary_clock_setting_time;
+	u8 board_type;
+	u8 padding[1];
+} __packed;
+
 #endif /* __REG_H__ */
-- 
1.7.9.5

