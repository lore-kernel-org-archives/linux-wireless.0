Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:37514 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933101Ab2DKTyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:04 -0400
Received: by lbbgm6 with SMTP id gm6so1026378lbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:54:01 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 13/24] wlcore/wl12xx: add hw_init operation
Date: Wed, 11 Apr 2012 22:53:29 +0300
Message-Id: <1334174020-18957-14-git-send-email-coelho@ti.com> (sfid-20120411_215430_346721_26748B97)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move all the wl12xx-specific hw initialization procedures into a new
hw_init op.  Move some commands and ACX functions to wl12xx.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/Makefile |    2 +-
 drivers/net/wireless/ti/wl12xx/acx.c    |   53 +++++++
 drivers/net/wireless/ti/wl12xx/acx.h    |   36 +++++
 drivers/net/wireless/ti/wl12xx/cmd.c    |  252 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl12xx/cmd.h    |  110 ++++++++++++++
 drivers/net/wireless/ti/wl12xx/main.c   |   40 +++++
 drivers/net/wireless/ti/wlcore/acx.c    |   26 ---
 drivers/net/wireless/ti/wlcore/acx.h    |    8 +-
 drivers/net/wireless/ti/wlcore/cmd.c    |  228 +---------------------------
 drivers/net/wireless/ti/wlcore/cmd.h    |   82 ----------
 drivers/net/wireless/ti/wlcore/init.c   |   43 +-----
 drivers/net/wireless/ti/wlcore/main.c   |   23 +---
 drivers/net/wireless/ti/wlcore/wlcore.h |    1 +
 13 files changed, 499 insertions(+), 405 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl12xx/acx.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/acx.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/cmd.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/cmd.h

diff --git a/drivers/net/wireless/ti/wl12xx/Makefile b/drivers/net/wireless/ti/wl12xx/Makefile
index 1df22d5..87f64b1 100644
--- a/drivers/net/wireless/ti/wl12xx/Makefile
+++ b/drivers/net/wireless/ti/wl12xx/Makefile
@@ -1,3 +1,3 @@
-wl12xx-objs	= main.o
+wl12xx-objs	= main.o cmd.o acx.o
 
 obj-$(CONFIG_WL12XX)		+= wl12xx.o
diff --git a/drivers/net/wireless/ti/wl12xx/acx.c b/drivers/net/wireless/ti/wl12xx/acx.c
new file mode 100644
index 0000000..bea06b2
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/acx.c
@@ -0,0 +1,53 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
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
+#include "../wlcore/cmd.h"
+#include "../wlcore/debug.h"
+#include "../wlcore/acx.h"
+
+#include "acx.h"
+
+int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap)
+{
+	struct wl1271_acx_host_config_bitmap *bitmap_conf;
+	int ret;
+
+	bitmap_conf = kzalloc(sizeof(*bitmap_conf), GFP_KERNEL);
+	if (!bitmap_conf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	bitmap_conf->host_cfg_bitmap = cpu_to_le32(host_cfg_bitmap);
+
+	ret = wl1271_cmd_configure(wl, ACX_HOST_IF_CFG_BITMAP,
+				   bitmap_conf, sizeof(*bitmap_conf));
+	if (ret < 0) {
+		wl1271_warning("wl1271 bitmap config opt failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(bitmap_conf);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl12xx/acx.h b/drivers/net/wireless/ti/wl12xx/acx.h
new file mode 100644
index 0000000..d1f5aba
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/acx.h
@@ -0,0 +1,36 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 1998-2009, 2011 Texas Instruments. All rights reserved.
+ * Copyright (C) 2008-2010 Nokia Corporation
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
+#ifndef __WL12XX_ACX_H__
+#define __WL12XX_ACX_H__
+
+#include "../wlcore/wlcore.h"
+
+struct wl1271_acx_host_config_bitmap {
+	struct acx_header header;
+
+	__le32 host_cfg_bitmap;
+} __packed;
+
+int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap);
+
+#endif /* __WL12XX_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wl12xx/cmd.c b/drivers/net/wireless/ti/wl12xx/cmd.c
new file mode 100644
index 0000000..e46512d
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/cmd.c
@@ -0,0 +1,252 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2009-2010 Nokia Corporation
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
+#include "../wlcore/cmd.h"
+#include "../wlcore/debug.h"
+
+#include "cmd.h"
+
+int wl1271_cmd_ext_radio_parms(struct wl1271 *wl)
+{
+	struct wl1271_ext_radio_parms_cmd *ext_radio_parms;
+	struct conf_rf_settings *rf = &wl->conf.rf;
+	int ret;
+
+	if (!wl->nvs)
+		return -ENODEV;
+
+	ext_radio_parms = kzalloc(sizeof(*ext_radio_parms), GFP_KERNEL);
+	if (!ext_radio_parms)
+		return -ENOMEM;
+
+	ext_radio_parms->test.id = TEST_CMD_INI_FILE_RF_EXTENDED_PARAM;
+
+	memcpy(ext_radio_parms->tx_per_channel_power_compensation_2,
+	       rf->tx_per_channel_power_compensation_2,
+	       CONF_TX_PWR_COMPENSATION_LEN_2);
+	memcpy(ext_radio_parms->tx_per_channel_power_compensation_5,
+	       rf->tx_per_channel_power_compensation_5,
+	       CONF_TX_PWR_COMPENSATION_LEN_5);
+
+	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_EXT_RADIO_PARAM: ",
+		    ext_radio_parms, sizeof(*ext_radio_parms));
+
+	ret = wl1271_cmd_test(wl, ext_radio_parms, sizeof(*ext_radio_parms), 0);
+	if (ret < 0)
+		wl1271_warning("TEST_CMD_INI_FILE_RF_EXTENDED_PARAM failed");
+
+	kfree(ext_radio_parms);
+	return ret;
+}
+
+int wl1271_cmd_general_parms(struct wl1271 *wl)
+{
+	struct wl1271_general_parms_cmd *gen_parms;
+	struct wl1271_ini_general_params *gp =
+		&((struct wl1271_nvs_file *)wl->nvs)->general_params;
+	bool answer = false;
+	int ret;
+
+	if (!wl->nvs)
+		return -ENODEV;
+
+	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
+		wl1271_warning("FEM index from INI out of bounds");
+		return -EINVAL;
+	}
+
+	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
+	if (!gen_parms)
+		return -ENOMEM;
+
+	gen_parms->test.id = TEST_CMD_INI_FILE_GENERAL_PARAM;
+
+	memcpy(&gen_parms->general_params, gp, sizeof(*gp));
+
+	if (gp->tx_bip_fem_auto_detect)
+		answer = true;
+
+	/* Override the REF CLK from the NVS with the one from platform data */
+	gen_parms->general_params.ref_clock = wl->ref_clock;
+
+	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
+	if (ret < 0) {
+		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
+		goto out;
+	}
+
+	gp->tx_bip_fem_manufacturer =
+		gen_parms->general_params.tx_bip_fem_manufacturer;
+
+	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
+		wl1271_warning("FEM index from FW out of bounds");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	wl1271_debug(DEBUG_CMD, "FEM autodetect: %s, manufacturer: %d\n",
+		     answer ? "auto" : "manual", gp->tx_bip_fem_manufacturer);
+
+out:
+	kfree(gen_parms);
+	return ret;
+}
+
+int wl128x_cmd_general_parms(struct wl1271 *wl)
+{
+	struct wl128x_general_parms_cmd *gen_parms;
+	struct wl128x_ini_general_params *gp =
+		&((struct wl128x_nvs_file *)wl->nvs)->general_params;
+	bool answer = false;
+	int ret;
+
+	if (!wl->nvs)
+		return -ENODEV;
+
+	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
+		wl1271_warning("FEM index from ini out of bounds");
+		return -EINVAL;
+	}
+
+	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
+	if (!gen_parms)
+		return -ENOMEM;
+
+	gen_parms->test.id = TEST_CMD_INI_FILE_GENERAL_PARAM;
+
+	memcpy(&gen_parms->general_params, gp, sizeof(*gp));
+
+	if (gp->tx_bip_fem_auto_detect)
+		answer = true;
+
+	/* Replace REF and TCXO CLKs with the ones from platform data */
+	gen_parms->general_params.ref_clock = wl->ref_clock;
+	gen_parms->general_params.tcxo_ref_clock = wl->tcxo_clock;
+
+	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
+	if (ret < 0) {
+		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
+		goto out;
+	}
+
+	gp->tx_bip_fem_manufacturer =
+		gen_parms->general_params.tx_bip_fem_manufacturer;
+
+	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
+		wl1271_warning("FEM index from FW out of bounds");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	wl1271_debug(DEBUG_CMD, "FEM autodetect: %s, manufacturer: %d\n",
+		     answer ? "auto" : "manual", gp->tx_bip_fem_manufacturer);
+
+out:
+	kfree(gen_parms);
+	return ret;
+}
+
+int wl1271_cmd_radio_parms(struct wl1271 *wl)
+{
+	struct wl1271_nvs_file *nvs = (struct wl1271_nvs_file *)wl->nvs;
+	struct wl1271_radio_parms_cmd *radio_parms;
+	struct wl1271_ini_general_params *gp = &nvs->general_params;
+	int ret;
+
+	if (!wl->nvs)
+		return -ENODEV;
+
+	radio_parms = kzalloc(sizeof(*radio_parms), GFP_KERNEL);
+	if (!radio_parms)
+		return -ENOMEM;
+
+	radio_parms->test.id = TEST_CMD_INI_FILE_RADIO_PARAM;
+
+	/* 2.4GHz parameters */
+	memcpy(&radio_parms->static_params_2, &nvs->stat_radio_params_2,
+	       sizeof(struct wl1271_ini_band_params_2));
+	memcpy(&radio_parms->dyn_params_2,
+	       &nvs->dyn_radio_params_2[gp->tx_bip_fem_manufacturer].params,
+	       sizeof(struct wl1271_ini_fem_params_2));
+
+	/* 5GHz parameters */
+	memcpy(&radio_parms->static_params_5,
+	       &nvs->stat_radio_params_5,
+	       sizeof(struct wl1271_ini_band_params_5));
+	memcpy(&radio_parms->dyn_params_5,
+	       &nvs->dyn_radio_params_5[gp->tx_bip_fem_manufacturer].params,
+	       sizeof(struct wl1271_ini_fem_params_5));
+
+	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_RADIO_PARAM: ",
+		    radio_parms, sizeof(*radio_parms));
+
+	ret = wl1271_cmd_test(wl, radio_parms, sizeof(*radio_parms), 0);
+	if (ret < 0)
+		wl1271_warning("CMD_INI_FILE_RADIO_PARAM failed");
+
+	kfree(radio_parms);
+	return ret;
+}
+
+int wl128x_cmd_radio_parms(struct wl1271 *wl)
+{
+	struct wl128x_nvs_file *nvs = (struct wl128x_nvs_file *)wl->nvs;
+	struct wl128x_radio_parms_cmd *radio_parms;
+	struct wl128x_ini_general_params *gp = &nvs->general_params;
+	int ret;
+
+	if (!wl->nvs)
+		return -ENODEV;
+
+	radio_parms = kzalloc(sizeof(*radio_parms), GFP_KERNEL);
+	if (!radio_parms)
+		return -ENOMEM;
+
+	radio_parms->test.id = TEST_CMD_INI_FILE_RADIO_PARAM;
+
+	/* 2.4GHz parameters */
+	memcpy(&radio_parms->static_params_2, &nvs->stat_radio_params_2,
+	       sizeof(struct wl128x_ini_band_params_2));
+	memcpy(&radio_parms->dyn_params_2,
+	       &nvs->dyn_radio_params_2[gp->tx_bip_fem_manufacturer].params,
+	       sizeof(struct wl128x_ini_fem_params_2));
+
+	/* 5GHz parameters */
+	memcpy(&radio_parms->static_params_5,
+	       &nvs->stat_radio_params_5,
+	       sizeof(struct wl128x_ini_band_params_5));
+	memcpy(&radio_parms->dyn_params_5,
+	       &nvs->dyn_radio_params_5[gp->tx_bip_fem_manufacturer].params,
+	       sizeof(struct wl128x_ini_fem_params_5));
+
+	radio_parms->fem_vendor_and_options = nvs->fem_vendor_and_options;
+
+	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_RADIO_PARAM: ",
+		    radio_parms, sizeof(*radio_parms));
+
+	ret = wl1271_cmd_test(wl, radio_parms, sizeof(*radio_parms), 0);
+	if (ret < 0)
+		wl1271_warning("CMD_INI_FILE_RADIO_PARAM failed");
+
+	kfree(radio_parms);
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl12xx/cmd.h b/drivers/net/wireless/ti/wl12xx/cmd.h
new file mode 100644
index 0000000..ff45830
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/cmd.h
@@ -0,0 +1,110 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 1998-2009, 2011 Texas Instruments. All rights reserved.
+ * Copyright (C) 2009 Nokia Corporation
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
+#ifndef __WL12XX_CMD_H__
+#define __WL12XX_CMD_H__
+
+#define TEST_CMD_INI_FILE_RADIO_PARAM       0x19
+#define TEST_CMD_INI_FILE_GENERAL_PARAM     0x1E
+
+struct wl1271_general_parms_cmd {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	struct wl1271_ini_general_params general_params;
+
+	u8 sr_debug_table[WL1271_INI_MAX_SMART_REFLEX_PARAM];
+	u8 sr_sen_n_p;
+	u8 sr_sen_n_p_gain;
+	u8 sr_sen_nrn;
+	u8 sr_sen_prn;
+	u8 padding[3];
+} __packed;
+
+struct wl128x_general_parms_cmd {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	struct wl128x_ini_general_params general_params;
+
+	u8 sr_debug_table[WL1271_INI_MAX_SMART_REFLEX_PARAM];
+	u8 sr_sen_n_p;
+	u8 sr_sen_n_p_gain;
+	u8 sr_sen_nrn;
+	u8 sr_sen_prn;
+	u8 padding[3];
+} __packed;
+
+struct wl1271_radio_parms_cmd {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	/* Static radio parameters */
+	struct wl1271_ini_band_params_2 static_params_2;
+	struct wl1271_ini_band_params_5 static_params_5;
+
+	/* Dynamic radio parameters */
+	struct wl1271_ini_fem_params_2 dyn_params_2;
+	u8 padding2;
+	struct wl1271_ini_fem_params_5 dyn_params_5;
+	u8 padding3[2];
+} __packed;
+
+struct wl128x_radio_parms_cmd {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	/* Static radio parameters */
+	struct wl128x_ini_band_params_2 static_params_2;
+	struct wl128x_ini_band_params_5 static_params_5;
+
+	u8 fem_vendor_and_options;
+
+	/* Dynamic radio parameters */
+	struct wl128x_ini_fem_params_2 dyn_params_2;
+	u8 padding2;
+	struct wl128x_ini_fem_params_5 dyn_params_5;
+} __packed;
+
+#define TEST_CMD_INI_FILE_RF_EXTENDED_PARAM 0x26
+
+struct wl1271_ext_radio_parms_cmd {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	u8 tx_per_channel_power_compensation_2[CONF_TX_PWR_COMPENSATION_LEN_2];
+	u8 tx_per_channel_power_compensation_5[CONF_TX_PWR_COMPENSATION_LEN_5];
+	u8 padding[3];
+} __packed;
+
+int wl1271_cmd_general_parms(struct wl1271 *wl);
+int wl128x_cmd_general_parms(struct wl1271 *wl);
+int wl1271_cmd_radio_parms(struct wl1271 *wl);
+int wl128x_cmd_radio_parms(struct wl1271 *wl);
+int wl1271_cmd_ext_radio_parms(struct wl1271 *wl);
+
+#endif /* __WL12XX_CMD_H__ */
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 00ecd2a..9b2f40c 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -36,6 +36,8 @@
 #include "../wlcore/boot.h"
 
 #include "reg.h"
+#include "cmd.h"
+#include "acx.h"
 
 #define WL12XX_TX_HW_BLOCK_SPARE_DEFAULT        1
 #define WL12XX_TX_HW_BLOCK_GEM_SPARE            2
@@ -800,6 +802,43 @@ static void wl12xx_tx_delayed_compl(struct wl1271 *wl)
 	wl1271_tx_complete(wl);
 }
 
+static int wl12xx_hw_init(struct wl1271 *wl)
+{
+	int ret;
+
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		u32 host_cfg_bitmap = HOST_IF_CFG_RX_FIFO_ENABLE;
+
+		ret = wl128x_cmd_general_parms(wl);
+		if (ret < 0)
+			goto out;
+		ret = wl128x_cmd_radio_parms(wl);
+		if (ret < 0)
+			goto out;
+
+		if (wl->quirks & WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN)
+			/* Enable SDIO padding */
+			host_cfg_bitmap |= HOST_IF_CFG_TX_PAD_TO_SDIO_BLK;
+
+		/* Must be before wl1271_acx_init_mem_config() */
+		ret = wl1271_acx_host_if_cfg_bitmap(wl, host_cfg_bitmap);
+		if (ret < 0)
+			goto out;
+	} else {
+		ret = wl1271_cmd_general_parms(wl);
+		if (ret < 0)
+			goto out;
+		ret = wl1271_cmd_radio_parms(wl);
+		if (ret < 0)
+			goto out;
+		ret = wl1271_cmd_ext_radio_parms(wl);
+		if (ret < 0)
+			goto out;
+	}
+out:
+	return ret;
+}
+
 static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
 {
 	bool supported = false;
@@ -875,6 +914,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.get_rx_packet_len	= wl12xx_get_rx_packet_len,
 	.tx_immediate_compl	= NULL,
 	.tx_delayed_compl	= wl12xx_tx_delayed_compl,
+	.hw_init		= wl12xx_hw_init,
 	.get_pg_ver		= wl12xx_get_pg_ver,
 	.get_mac		= wl12xx_get_mac,
 };
diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index c811f75..01dba46 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -997,32 +997,6 @@ out:
 	return ret;
 }
 
-int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap)
-{
-	struct wl1271_acx_host_config_bitmap *bitmap_conf;
-	int ret;
-
-	bitmap_conf = kzalloc(sizeof(*bitmap_conf), GFP_KERNEL);
-	if (!bitmap_conf) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	bitmap_conf->host_cfg_bitmap = cpu_to_le32(host_cfg_bitmap);
-
-	ret = wl1271_cmd_configure(wl, ACX_HOST_IF_CFG_BITMAP,
-				   bitmap_conf, sizeof(*bitmap_conf));
-	if (ret < 0) {
-		wl1271_warning("wl1271 bitmap config opt failed: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(bitmap_conf);
-
-	return ret;
-}
-
 int wl1271_acx_init_mem_config(struct wl1271 *wl)
 {
 	int ret;
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index e24511a..b2f8883 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -824,16 +824,11 @@ struct wl1271_acx_keep_alive_config {
 	__le32 period;
 } __packed;
 
+/* TODO: maybe this needs to be moved somewhere else? */
 #define HOST_IF_CFG_RX_FIFO_ENABLE     BIT(0)
 #define HOST_IF_CFG_TX_EXTRA_BLKS_SWAP BIT(1)
 #define HOST_IF_CFG_TX_PAD_TO_SDIO_BLK BIT(3)
 
-struct wl1271_acx_host_config_bitmap {
-	struct acx_header header;
-
-	__le32 host_cfg_bitmap;
-} __packed;
-
 enum {
 	WL1271_ACX_TRIG_TYPE_LEVEL = 0,
 	WL1271_ACX_TRIG_TYPE_EDGE,
@@ -1274,7 +1269,6 @@ int wl1271_acx_frag_threshold(struct wl1271 *wl, u32 frag_threshold);
 int wl1271_acx_tx_config_options(struct wl1271 *wl);
 int wl12xx_acx_mem_cfg(struct wl1271 *wl);
 int wl1271_acx_init_mem_config(struct wl1271 *wl);
-int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap);
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
 int wl1271_acx_smart_reflex(struct wl1271 *wl);
 int wl1271_acx_bet_enable(struct wl1271 *wl, struct wl12xx_vif *wlvif,
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index e80f674..8407590 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -112,232 +112,6 @@ fail:
 	return ret;
 }
 
-int wl1271_cmd_general_parms(struct wl1271 *wl)
-{
-	struct wl1271_general_parms_cmd *gen_parms;
-	struct wl1271_ini_general_params *gp =
-		&((struct wl1271_nvs_file *)wl->nvs)->general_params;
-	bool answer = false;
-	int ret;
-
-	if (!wl->nvs)
-		return -ENODEV;
-
-	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
-		wl1271_warning("FEM index from INI out of bounds");
-		return -EINVAL;
-	}
-
-	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
-	if (!gen_parms)
-		return -ENOMEM;
-
-	gen_parms->test.id = TEST_CMD_INI_FILE_GENERAL_PARAM;
-
-	memcpy(&gen_parms->general_params, gp, sizeof(*gp));
-
-	if (gp->tx_bip_fem_auto_detect)
-		answer = true;
-
-	/* Override the REF CLK from the NVS with the one from platform data */
-	gen_parms->general_params.ref_clock = wl->ref_clock;
-
-	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
-	if (ret < 0) {
-		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
-		goto out;
-	}
-
-	gp->tx_bip_fem_manufacturer =
-		gen_parms->general_params.tx_bip_fem_manufacturer;
-
-	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
-		wl1271_warning("FEM index from FW out of bounds");
-		ret = -EINVAL;
-		goto out;
-	}
-
-	wl1271_debug(DEBUG_CMD, "FEM autodetect: %s, manufacturer: %d\n",
-		     answer ? "auto" : "manual", gp->tx_bip_fem_manufacturer);
-
-out:
-	kfree(gen_parms);
-	return ret;
-}
-
-int wl128x_cmd_general_parms(struct wl1271 *wl)
-{
-	struct wl128x_general_parms_cmd *gen_parms;
-	struct wl128x_ini_general_params *gp =
-		&((struct wl128x_nvs_file *)wl->nvs)->general_params;
-	bool answer = false;
-	int ret;
-
-	if (!wl->nvs)
-		return -ENODEV;
-
-	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
-		wl1271_warning("FEM index from ini out of bounds");
-		return -EINVAL;
-	}
-
-	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
-	if (!gen_parms)
-		return -ENOMEM;
-
-	gen_parms->test.id = TEST_CMD_INI_FILE_GENERAL_PARAM;
-
-	memcpy(&gen_parms->general_params, gp, sizeof(*gp));
-
-	if (gp->tx_bip_fem_auto_detect)
-		answer = true;
-
-	/* Replace REF and TCXO CLKs with the ones from platform data */
-	gen_parms->general_params.ref_clock = wl->ref_clock;
-	gen_parms->general_params.tcxo_ref_clock = wl->tcxo_clock;
-
-	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), answer);
-	if (ret < 0) {
-		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
-		goto out;
-	}
-
-	gp->tx_bip_fem_manufacturer =
-		gen_parms->general_params.tx_bip_fem_manufacturer;
-
-	if (gp->tx_bip_fem_manufacturer >= WL1271_INI_FEM_MODULE_COUNT) {
-		wl1271_warning("FEM index from FW out of bounds");
-		ret = -EINVAL;
-		goto out;
-	}
-
-	wl1271_debug(DEBUG_CMD, "FEM autodetect: %s, manufacturer: %d\n",
-		     answer ? "auto" : "manual", gp->tx_bip_fem_manufacturer);
-
-out:
-	kfree(gen_parms);
-	return ret;
-}
-
-int wl1271_cmd_radio_parms(struct wl1271 *wl)
-{
-	struct wl1271_nvs_file *nvs = (struct wl1271_nvs_file *)wl->nvs;
-	struct wl1271_radio_parms_cmd *radio_parms;
-	struct wl1271_ini_general_params *gp = &nvs->general_params;
-	int ret;
-
-	if (!wl->nvs)
-		return -ENODEV;
-
-	radio_parms = kzalloc(sizeof(*radio_parms), GFP_KERNEL);
-	if (!radio_parms)
-		return -ENOMEM;
-
-	radio_parms->test.id = TEST_CMD_INI_FILE_RADIO_PARAM;
-
-	/* 2.4GHz parameters */
-	memcpy(&radio_parms->static_params_2, &nvs->stat_radio_params_2,
-	       sizeof(struct wl1271_ini_band_params_2));
-	memcpy(&radio_parms->dyn_params_2,
-	       &nvs->dyn_radio_params_2[gp->tx_bip_fem_manufacturer].params,
-	       sizeof(struct wl1271_ini_fem_params_2));
-
-	/* 5GHz parameters */
-	memcpy(&radio_parms->static_params_5,
-	       &nvs->stat_radio_params_5,
-	       sizeof(struct wl1271_ini_band_params_5));
-	memcpy(&radio_parms->dyn_params_5,
-	       &nvs->dyn_radio_params_5[gp->tx_bip_fem_manufacturer].params,
-	       sizeof(struct wl1271_ini_fem_params_5));
-
-	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_RADIO_PARAM: ",
-		    radio_parms, sizeof(*radio_parms));
-
-	ret = wl1271_cmd_test(wl, radio_parms, sizeof(*radio_parms), 0);
-	if (ret < 0)
-		wl1271_warning("CMD_INI_FILE_RADIO_PARAM failed");
-
-	kfree(radio_parms);
-	return ret;
-}
-
-int wl128x_cmd_radio_parms(struct wl1271 *wl)
-{
-	struct wl128x_nvs_file *nvs = (struct wl128x_nvs_file *)wl->nvs;
-	struct wl128x_radio_parms_cmd *radio_parms;
-	struct wl128x_ini_general_params *gp = &nvs->general_params;
-	int ret;
-
-	if (!wl->nvs)
-		return -ENODEV;
-
-	radio_parms = kzalloc(sizeof(*radio_parms), GFP_KERNEL);
-	if (!radio_parms)
-		return -ENOMEM;
-
-	radio_parms->test.id = TEST_CMD_INI_FILE_RADIO_PARAM;
-
-	/* 2.4GHz parameters */
-	memcpy(&radio_parms->static_params_2, &nvs->stat_radio_params_2,
-	       sizeof(struct wl128x_ini_band_params_2));
-	memcpy(&radio_parms->dyn_params_2,
-	       &nvs->dyn_radio_params_2[gp->tx_bip_fem_manufacturer].params,
-	       sizeof(struct wl128x_ini_fem_params_2));
-
-	/* 5GHz parameters */
-	memcpy(&radio_parms->static_params_5,
-	       &nvs->stat_radio_params_5,
-	       sizeof(struct wl128x_ini_band_params_5));
-	memcpy(&radio_parms->dyn_params_5,
-	       &nvs->dyn_radio_params_5[gp->tx_bip_fem_manufacturer].params,
-	       sizeof(struct wl128x_ini_fem_params_5));
-
-	radio_parms->fem_vendor_and_options = nvs->fem_vendor_and_options;
-
-	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_RADIO_PARAM: ",
-		    radio_parms, sizeof(*radio_parms));
-
-	ret = wl1271_cmd_test(wl, radio_parms, sizeof(*radio_parms), 0);
-	if (ret < 0)
-		wl1271_warning("CMD_INI_FILE_RADIO_PARAM failed");
-
-	kfree(radio_parms);
-	return ret;
-}
-
-int wl1271_cmd_ext_radio_parms(struct wl1271 *wl)
-{
-	struct wl1271_ext_radio_parms_cmd *ext_radio_parms;
-	struct conf_rf_settings *rf = &wl->conf.rf;
-	int ret;
-
-	if (!wl->nvs)
-		return -ENODEV;
-
-	ext_radio_parms = kzalloc(sizeof(*ext_radio_parms), GFP_KERNEL);
-	if (!ext_radio_parms)
-		return -ENOMEM;
-
-	ext_radio_parms->test.id = TEST_CMD_INI_FILE_RF_EXTENDED_PARAM;
-
-	memcpy(ext_radio_parms->tx_per_channel_power_compensation_2,
-	       rf->tx_per_channel_power_compensation_2,
-	       CONF_TX_PWR_COMPENSATION_LEN_2);
-	memcpy(ext_radio_parms->tx_per_channel_power_compensation_5,
-	       rf->tx_per_channel_power_compensation_5,
-	       CONF_TX_PWR_COMPENSATION_LEN_5);
-
-	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_EXT_RADIO_PARAM: ",
-		    ext_radio_parms, sizeof(*ext_radio_parms));
-
-	ret = wl1271_cmd_test(wl, ext_radio_parms, sizeof(*ext_radio_parms), 0);
-	if (ret < 0)
-		wl1271_warning("TEST_CMD_INI_FILE_RF_EXTENDED_PARAM failed");
-
-	kfree(ext_radio_parms);
-	return ret;
-}
-
 /*
  * Poll the mailbox event field until any of the bits in the mask is set or a
  * timeout occurs (WL1271_EVENT_TIMEOUT in msecs)
@@ -913,6 +687,7 @@ int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(wl1271_cmd_test);
 
 /**
  * read acx from firmware
@@ -969,6 +744,7 @@ int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wl1271_cmd_configure);
 
 int wl1271_cmd_data_path(struct wl1271 *wl, bool enable)
 {
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index cd1eb2e..a46ae07 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -31,11 +31,6 @@ struct acx_header;
 
 int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		    size_t res_len);
-int wl1271_cmd_general_parms(struct wl1271 *wl);
-int wl128x_cmd_general_parms(struct wl1271 *wl);
-int wl1271_cmd_radio_parms(struct wl1271 *wl);
-int wl128x_cmd_radio_parms(struct wl1271 *wl);
-int wl1271_cmd_ext_radio_parms(struct wl1271 *wl);
 int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 *addr, u8 role_type,
 			   u8 *role_id);
 int wl12xx_cmd_role_disable(struct wl1271 *wl, u8 *role_id);
@@ -494,83 +489,6 @@ enum wl1271_channel_tune_bands {
 
 #define WL1271_PD_REFERENCE_POINT_BAND_B_G  0
 
-#define TEST_CMD_INI_FILE_RADIO_PARAM       0x19
-#define TEST_CMD_INI_FILE_GENERAL_PARAM     0x1E
-#define TEST_CMD_INI_FILE_RF_EXTENDED_PARAM 0x26
-
-struct wl1271_general_parms_cmd {
-	struct wl1271_cmd_header header;
-
-	struct wl1271_cmd_test_header test;
-
-	struct wl1271_ini_general_params general_params;
-
-	u8 sr_debug_table[WL1271_INI_MAX_SMART_REFLEX_PARAM];
-	u8 sr_sen_n_p;
-	u8 sr_sen_n_p_gain;
-	u8 sr_sen_nrn;
-	u8 sr_sen_prn;
-	u8 padding[3];
-} __packed;
-
-struct wl128x_general_parms_cmd {
-	struct wl1271_cmd_header header;
-
-	struct wl1271_cmd_test_header test;
-
-	struct wl128x_ini_general_params general_params;
-
-	u8 sr_debug_table[WL1271_INI_MAX_SMART_REFLEX_PARAM];
-	u8 sr_sen_n_p;
-	u8 sr_sen_n_p_gain;
-	u8 sr_sen_nrn;
-	u8 sr_sen_prn;
-	u8 padding[3];
-} __packed;
-
-struct wl1271_radio_parms_cmd {
-	struct wl1271_cmd_header header;
-
-	struct wl1271_cmd_test_header test;
-
-	/* Static radio parameters */
-	struct wl1271_ini_band_params_2 static_params_2;
-	struct wl1271_ini_band_params_5 static_params_5;
-
-	/* Dynamic radio parameters */
-	struct wl1271_ini_fem_params_2 dyn_params_2;
-	u8 padding2;
-	struct wl1271_ini_fem_params_5 dyn_params_5;
-	u8 padding3[2];
-} __packed;
-
-struct wl128x_radio_parms_cmd {
-	struct wl1271_cmd_header header;
-
-	struct wl1271_cmd_test_header test;
-
-	/* Static radio parameters */
-	struct wl128x_ini_band_params_2 static_params_2;
-	struct wl128x_ini_band_params_5 static_params_5;
-
-	u8 fem_vendor_and_options;
-
-	/* Dynamic radio parameters */
-	struct wl128x_ini_fem_params_2 dyn_params_2;
-	u8 padding2;
-	struct wl128x_ini_fem_params_5 dyn_params_5;
-} __packed;
-
-struct wl1271_ext_radio_parms_cmd {
-	struct wl1271_cmd_header header;
-
-	struct wl1271_cmd_test_header test;
-
-	u8 tx_per_channel_power_compensation_2[CONF_TX_PWR_COMPENSATION_LEN_2];
-	u8 tx_per_channel_power_compensation_5[CONF_TX_PWR_COMPENSATION_LEN_5];
-	u8 padding[3];
-} __packed;
-
 /*
  * There are three types of disconnections:
  *
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index c332da2..afe4f75 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -493,26 +493,6 @@ static int wl1271_set_ba_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	return wl12xx_acx_set_ba_initiator_policy(wl, wlvif);
 }
 
-int wl1271_chip_specific_init(struct wl1271 *wl)
-{
-	int ret = 0;
-
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
-		u32 host_cfg_bitmap = HOST_IF_CFG_RX_FIFO_ENABLE;
-
-		if (wl->quirks & WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN)
-			/* Enable SDIO padding */
-			host_cfg_bitmap |= HOST_IF_CFG_TX_PAD_TO_SDIO_BLK;
-
-		/* Must be before wl1271_acx_init_mem_config() */
-		ret = wl1271_acx_host_if_cfg_bitmap(wl, host_cfg_bitmap);
-		if (ret < 0)
-			goto out;
-	}
-out:
-	return ret;
-}
-
 /* vif-specifc initialization */
 static int wl12xx_init_sta_role(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
@@ -665,27 +645,8 @@ int wl1271_hw_init(struct wl1271 *wl)
 {
 	int ret;
 
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
-		ret = wl128x_cmd_general_parms(wl);
-		if (ret < 0)
-			return ret;
-		ret = wl128x_cmd_radio_parms(wl);
-		if (ret < 0)
-			return ret;
-	} else {
-		ret = wl1271_cmd_general_parms(wl);
-		if (ret < 0)
-			return ret;
-		ret = wl1271_cmd_radio_parms(wl);
-		if (ret < 0)
-			return ret;
-		ret = wl1271_cmd_ext_radio_parms(wl);
-		if (ret < 0)
-			return ret;
-	}
-
-	/* Chip-specific init */
-	ret = wl1271_chip_specific_init(wl);
+	/* Chip-specific hw init */
+	ret = wl->ops->hw_init(wl);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 83be5be..6a98013 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -672,28 +672,7 @@ static int wl1271_plt_init(struct wl1271 *wl)
 {
 	int ret;
 
-	if (wl->chip.id == CHIP_ID_1283_PG20)
-		ret = wl128x_cmd_general_parms(wl);
-	else
-		ret = wl1271_cmd_general_parms(wl);
-	if (ret < 0)
-		return ret;
-
-	if (wl->chip.id == CHIP_ID_1283_PG20)
-		ret = wl128x_cmd_radio_parms(wl);
-	else
-		ret = wl1271_cmd_radio_parms(wl);
-	if (ret < 0)
-		return ret;
-
-	if (wl->chip.id != CHIP_ID_1283_PG20) {
-		ret = wl1271_cmd_ext_radio_parms(wl);
-		if (ret < 0)
-			return ret;
-	}
-
-	/* Chip-specific initializations */
-	ret = wl1271_chip_specific_init(wl);
+	ret = wl->ops->hw_init(wl);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index db7ad71..91ccd1e 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -53,6 +53,7 @@ struct wlcore_ops {
 				 u32 data_len);
 	void (*tx_delayed_compl)(struct wl1271 *wl);
 	void (*tx_immediate_compl)(struct wl1271 *wl);
+	int (*hw_init)(struct wl1271 *wl);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
 	void (*get_mac)(struct wl1271 *wl);
 };
-- 
1.7.5.4

