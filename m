Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbcD1TTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 15:19:17 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 04/11] rtl8xxxu: move rtl8723a related code into rtl8xxxu_8723a.c
Date: Thu, 28 Apr 2016 15:19:08 -0400
Message-Id: <1461871155-11826-5-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160428_211925_501458_67608607)
In-Reply-To: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1461871155-11826-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This moves the rtl8723a code into it's own file. This is purely a code
moving exercise, no code changes.

This device specific file is a lot smaller since the gen1 chips
(8723a, 8188c, 8188r, 8192c) share a lot more common code than the
gen2 chips.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/Makefile     |   3 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  17 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c | 399 +++++++++++++++++++++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 388 +-------------------
 4 files changed, 432 insertions(+), 375 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/Makefile b/drivers/net/wireless/realtek/rtl8xxxu/Makefile
index d27128c..7bdce80 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/Makefile
+++ b/drivers/net/wireless/realtek/rtl8xxxu/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_RTL8XXXU)	+= rtl8xxxu.o
 
-rtl8xxxu-y	:= rtl8xxxu_core.o rtl8xxxu_8192e.o rtl8xxxu_8723b.o
+rtl8xxxu-y	:= rtl8xxxu_core.o rtl8xxxu_8192e.o rtl8xxxu_8723b.o \
+		   rtl8xxxu_8723a.o
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 2807cb5..6d179d6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1350,6 +1350,7 @@ struct rtl8xxxu_fileops {
 
 extern int rtl8xxxu_debug;
 
+extern struct rtl8xxxu_reg8val rtl8xxxu_gen1_mac_init_table[];
 extern const u32 rtl8xxxu_iqk_phy_iq_bb_reg[];
 u8 rtl8xxxu_read8(struct rtl8xxxu_priv *priv, u16 addr);
 u16 rtl8xxxu_read16(struct rtl8xxxu_priv *priv, u16 addr);
@@ -1392,13 +1393,28 @@ int rtl8xxxu_flush_fifo(struct rtl8xxxu_priv *priv);
 int rtl8723a_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c, int len);
 int rtl8xxxu_active_to_lps(struct rtl8xxxu_priv *priv);
 void rtl8723a_disabled_to_emu(struct rtl8xxxu_priv *priv);
+int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page);
+void rtl8xxxu_gen1_phy_iq_calibrate(struct rtl8xxxu_priv *priv);
+void rtl8xxxu_gen1_init_phy_bb(struct rtl8xxxu_priv *priv);
+void rtl8xxxu_gen1_set_tx_power(struct rtl8xxxu_priv *priv,
+				int channel, bool ht40);
+void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw);
 void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw);
+void rtl8xxxu_gen1_usb_quirks(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen2_usb_quirks(struct rtl8xxxu_priv *priv);
+void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
+			       u32 ramask, int sgi);
 void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
 				    u32 ramask, int sgi);
+void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
+				  u8 macid, bool connect);
 void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 				  u8 macid, bool connect);
+void rtl8xxxu_gen1_enable_rf(struct rtl8xxxu_priv *priv);
+void rtl8xxxu_gen1_disable_rf(struct rtl8xxxu_priv *priv);
 void rtl8xxxu_gen2_disable_rf(struct rtl8xxxu_priv *priv);
+int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
+			    struct ieee80211_rx_status *rx_status);
 int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
 			    struct ieee80211_rx_status *rx_status);
 int rtl8xxxu_gen2_channel_to_group(int channel);
@@ -1406,4 +1422,5 @@ bool rtl8xxxu_gen2_simularity_compare(struct rtl8xxxu_priv *priv,
 				      int result[][8], int c1, int c2);
 
 extern struct rtl8xxxu_fileops rtl8192eu_fops;
+extern struct rtl8xxxu_fileops rtl8723au_fops;
 extern struct rtl8xxxu_fileops rtl8723bu_fops;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
new file mode 100644
index 0000000..b464e22
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c
@@ -0,0 +1,399 @@
+/*
+ * RTL8XXXU mac80211 USB driver - 8723a specific subdriver
+ *
+ * Copyright (c) 2014 - 2016 Jes Sorensen <Jes.Sorensen@redhat.com>
+ *
+ * Portions, notably calibration code:
+ * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
+ *
+ * This driver was written as a replacement for the vendor provided
+ * rtl8723au driver. As the Realtek 8xxx chips are very similar in
+ * their programming interface, I have started adding support for
+ * additional 8xxx chips like the 8192cu, 8188cus, etc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/usb.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/wireless.h>
+#include <linux/firmware.h>
+#include <linux/moduleparam.h>
+#include <net/mac80211.h>
+#include "rtl8xxxu.h"
+#include "rtl8xxxu_regs.h"
+
+static struct rtl8xxxu_power_base rtl8723a_power_base = {
+	.reg_0e00 = 0x0a0c0c0c,
+	.reg_0e04 = 0x02040608,
+	.reg_0e08 = 0x00000000,
+	.reg_086c = 0x00000000,
+
+	.reg_0e10 = 0x0a0c0d0e,
+	.reg_0e14 = 0x02040608,
+	.reg_0e18 = 0x0a0c0d0e,
+	.reg_0e1c = 0x02040608,
+
+	.reg_0830 = 0x0a0c0c0c,
+	.reg_0834 = 0x02040608,
+	.reg_0838 = 0x00000000,
+	.reg_086c_2 = 0x00000000,
+
+	.reg_083c = 0x0a0c0d0e,
+	.reg_0848 = 0x02040608,
+	.reg_084c = 0x0a0c0d0e,
+	.reg_0868 = 0x02040608,
+};
+
+static struct rtl8xxxu_rfregval rtl8723au_radioa_1t_init_table[] = {
+	{0x00, 0x00030159}, {0x01, 0x00031284},
+	{0x02, 0x00098000}, {0x03, 0x00039c63},
+	{0x04, 0x000210e7}, {0x09, 0x0002044f},
+	{0x0a, 0x0001a3f1}, {0x0b, 0x00014787},
+	{0x0c, 0x000896fe}, {0x0d, 0x0000e02c},
+	{0x0e, 0x00039ce7}, {0x0f, 0x00000451},
+	{0x19, 0x00000000}, {0x1a, 0x00030355},
+	{0x1b, 0x00060a00}, {0x1c, 0x000fc378},
+	{0x1d, 0x000a1250}, {0x1e, 0x0000024f},
+	{0x1f, 0x00000000}, {0x20, 0x0000b614},
+	{0x21, 0x0006c000}, {0x22, 0x00000000},
+	{0x23, 0x00001558}, {0x24, 0x00000060},
+	{0x25, 0x00000483}, {0x26, 0x0004f000},
+	{0x27, 0x000ec7d9}, {0x28, 0x00057730},
+	{0x29, 0x00004783}, {0x2a, 0x00000001},
+	{0x2b, 0x00021334}, {0x2a, 0x00000000},
+	{0x2b, 0x00000054}, {0x2a, 0x00000001},
+	{0x2b, 0x00000808}, {0x2b, 0x00053333},
+	{0x2c, 0x0000000c}, {0x2a, 0x00000002},
+	{0x2b, 0x00000808}, {0x2b, 0x0005b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000003},
+	{0x2b, 0x00000808}, {0x2b, 0x00063333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000004},
+	{0x2b, 0x00000808}, {0x2b, 0x0006b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000005},
+	{0x2b, 0x00000808}, {0x2b, 0x00073333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000006},
+	{0x2b, 0x00000709}, {0x2b, 0x0005b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000007},
+	{0x2b, 0x00000709}, {0x2b, 0x00063333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000008},
+	{0x2b, 0x0000060a}, {0x2b, 0x0004b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x00000009},
+	{0x2b, 0x0000060a}, {0x2b, 0x00053333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000a},
+	{0x2b, 0x0000060a}, {0x2b, 0x0005b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000b},
+	{0x2b, 0x0000060a}, {0x2b, 0x00063333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000c},
+	{0x2b, 0x0000060a}, {0x2b, 0x0006b333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000d},
+	{0x2b, 0x0000060a}, {0x2b, 0x00073333},
+	{0x2c, 0x0000000d}, {0x2a, 0x0000000e},
+	{0x2b, 0x0000050b}, {0x2b, 0x00066666},
+	{0x2c, 0x0000001a}, {0x2a, 0x000e0000},
+	{0x10, 0x0004000f}, {0x11, 0x000e31fc},
+	{0x10, 0x0006000f}, {0x11, 0x000ff9f8},
+	{0x10, 0x0002000f}, {0x11, 0x000203f9},
+	{0x10, 0x0003000f}, {0x11, 0x000ff500},
+	{0x10, 0x00000000}, {0x11, 0x00000000},
+	{0x10, 0x0008000f}, {0x11, 0x0003f100},
+	{0x10, 0x0009000f}, {0x11, 0x00023100},
+	{0x12, 0x00032000}, {0x12, 0x00071000},
+	{0x12, 0x000b0000}, {0x12, 0x000fc000},
+	{0x13, 0x000287b3}, {0x13, 0x000244b7},
+	{0x13, 0x000204ab}, {0x13, 0x0001c49f},
+	{0x13, 0x00018493}, {0x13, 0x0001429b},
+	{0x13, 0x00010299}, {0x13, 0x0000c29c},
+	{0x13, 0x000081a0}, {0x13, 0x000040ac},
+	{0x13, 0x00000020}, {0x14, 0x0001944c},
+	{0x14, 0x00059444}, {0x14, 0x0009944c},
+	{0x14, 0x000d9444}, {0x15, 0x0000f474},
+	{0x15, 0x0004f477}, {0x15, 0x0008f455},
+	{0x15, 0x000cf455}, {0x16, 0x00000339},
+	{0x16, 0x00040339}, {0x16, 0x00080339},
+	{0x16, 0x000c0366}, {0x00, 0x00010159},
+	{0x18, 0x0000f401}, {0xfe, 0x00000000},
+	{0xfe, 0x00000000}, {0x1f, 0x00000003},
+	{0xfe, 0x00000000}, {0xfe, 0x00000000},
+	{0x1e, 0x00000247}, {0x1f, 0x00000000},
+	{0x00, 0x00030159},
+	{0xff, 0xffffffff}
+};
+
+static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
+{
+	struct rtl8723au_efuse *efuse = &priv->efuse_wifi.efuse8723;
+
+	if (efuse->rtl_id != cpu_to_le16(0x8129))
+		return -EINVAL;
+
+	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
+
+	memcpy(priv->cck_tx_power_index_A,
+	       efuse->cck_tx_power_index_A,
+	       sizeof(efuse->cck_tx_power_index_A));
+	memcpy(priv->cck_tx_power_index_B,
+	       efuse->cck_tx_power_index_B,
+	       sizeof(efuse->cck_tx_power_index_B));
+
+	memcpy(priv->ht40_1s_tx_power_index_A,
+	       efuse->ht40_1s_tx_power_index_A,
+	       sizeof(efuse->ht40_1s_tx_power_index_A));
+	memcpy(priv->ht40_1s_tx_power_index_B,
+	       efuse->ht40_1s_tx_power_index_B,
+	       sizeof(efuse->ht40_1s_tx_power_index_B));
+
+	memcpy(priv->ht20_tx_power_index_diff,
+	       efuse->ht20_tx_power_index_diff,
+	       sizeof(efuse->ht20_tx_power_index_diff));
+	memcpy(priv->ofdm_tx_power_index_diff,
+	       efuse->ofdm_tx_power_index_diff,
+	       sizeof(efuse->ofdm_tx_power_index_diff));
+
+	memcpy(priv->ht40_max_power_offset,
+	       efuse->ht40_max_power_offset,
+	       sizeof(efuse->ht40_max_power_offset));
+	memcpy(priv->ht20_max_power_offset,
+	       efuse->ht20_max_power_offset,
+	       sizeof(efuse->ht20_max_power_offset));
+
+	if (priv->efuse_wifi.efuse8723.version >= 0x01) {
+		priv->has_xtalk = 1;
+		priv->xtalk = priv->efuse_wifi.efuse8723.xtal_k & 0x3f;
+	}
+
+	priv->power_base = &rtl8723a_power_base;
+
+	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
+		 efuse->vendor_name);
+	dev_info(&priv->udev->dev, "Product: %.41s\n",
+		 efuse->device_name);
+	return 0;
+}
+
+static int rtl8723au_load_firmware(struct rtl8xxxu_priv *priv)
+{
+	char *fw_name;
+	int ret;
+
+	switch (priv->chip_cut) {
+	case 0:
+		fw_name = "rtlwifi/rtl8723aufw_A.bin";
+		break;
+	case 1:
+		if (priv->enable_bluetooth)
+			fw_name = "rtlwifi/rtl8723aufw_B.bin";
+		else
+			fw_name = "rtlwifi/rtl8723aufw_B_NoBT.bin";
+
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = rtl8xxxu_load_firmware(priv, fw_name);
+	return ret;
+}
+
+static int rtl8723au_init_phy_rf(struct rtl8xxxu_priv *priv)
+{
+	int ret;
+
+	ret = rtl8xxxu_init_phy_rf(priv, rtl8723au_radioa_1t_init_table, RF_A);
+
+	/* Reduce 80M spur */
+	rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, 0x0381808d);
+	rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
+	rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff82);
+	rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
+
+	return ret;
+}
+
+static int rtl8723a_emu_to_active(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u32 val32;
+	int count, ret = 0;
+
+	/* 0x20[0] = 1 enable LDOA12 MACRO block for all interface*/
+	val8 = rtl8xxxu_read8(priv, REG_LDOA15_CTRL);
+	val8 |= LDOA15_ENABLE;
+	rtl8xxxu_write8(priv, REG_LDOA15_CTRL, val8);
+
+	/* 0x67[0] = 0 to disable BT_GPS_SEL pins*/
+	val8 = rtl8xxxu_read8(priv, 0x0067);
+	val8 &= ~BIT(4);
+	rtl8xxxu_write8(priv, 0x0067, val8);
+
+	mdelay(1);
+
+	/* 0x00[5] = 0 release analog Ips to digital, 1:isolation */
+	val8 = rtl8xxxu_read8(priv, REG_SYS_ISO_CTRL);
+	val8 &= ~SYS_ISO_ANALOG_IPS;
+	rtl8xxxu_write8(priv, REG_SYS_ISO_CTRL, val8);
+
+	/* disable SW LPS 0x04[10]= 0 */
+	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
+	val8 &= ~BIT(2);
+	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
+
+	/* wait till 0x04[17] = 1 power ready*/
+	for (count = RTL8XXXU_MAX_REG_POLL; count; count--) {
+		val32 = rtl8xxxu_read32(priv, REG_APS_FSMCO);
+		if (val32 & BIT(17))
+			break;
+
+		udelay(10);
+	}
+
+	if (!count) {
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	/* We should be able to optimize the following three entries into one */
+
+	/* release WLON reset 0x04[16]= 1*/
+	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 2);
+	val8 |= BIT(0);
+	rtl8xxxu_write8(priv, REG_APS_FSMCO + 2, val8);
+
+	/* disable HWPDN 0x04[15]= 0*/
+	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
+	val8 &= ~BIT(7);
+	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
+
+	/* disable WL suspend*/
+	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
+	val8 &= ~(BIT(3) | BIT(4));
+	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
+
+	/* set, then poll until 0 */
+	val32 = rtl8xxxu_read32(priv, REG_APS_FSMCO);
+	val32 |= APS_FSMCO_MAC_ENABLE;
+	rtl8xxxu_write32(priv, REG_APS_FSMCO, val32);
+
+	for (count = RTL8XXXU_MAX_REG_POLL; count; count--) {
+		val32 = rtl8xxxu_read32(priv, REG_APS_FSMCO);
+		if ((val32 & APS_FSMCO_MAC_ENABLE) == 0) {
+			ret = 0;
+			break;
+		}
+		udelay(10);
+	}
+
+	if (!count) {
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	/* 0x4C[23] = 0x4E[7] = 1, switch DPDT_SEL_P output from WL BB */
+	/*
+	 * Note: Vendor driver actually clears this bit, despite the
+	 * documentation claims it's being set!
+	 */
+	val8 = rtl8xxxu_read8(priv, REG_LEDCFG2);
+	val8 |= LEDCFG2_DPDT_SELECT;
+	val8 &= ~LEDCFG2_DPDT_SELECT;
+	rtl8xxxu_write8(priv, REG_LEDCFG2, val8);
+
+exit:
+	return ret;
+}
+
+static int rtl8723au_power_on(struct rtl8xxxu_priv *priv)
+{
+	u8 val8;
+	u16 val16;
+	u32 val32;
+	int ret;
+
+	/*
+	 * RSV_CTRL 0x001C[7:0] = 0x00, unlock ISO/CLK/Power control register
+	 */
+	rtl8xxxu_write8(priv, REG_RSV_CTRL, 0x0);
+
+	rtl8723a_disabled_to_emu(priv);
+
+	ret = rtl8723a_emu_to_active(priv);
+	if (ret)
+		goto exit;
+
+	/*
+	 * 0x0004[19] = 1, reset 8051
+	 */
+	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 2);
+	val8 |= BIT(3);
+	rtl8xxxu_write8(priv, REG_APS_FSMCO + 2, val8);
+
+	/*
+	 * Enable MAC DMA/WMAC/SCHEDULE/SEC block
+	 * Set CR bit10 to enable 32k calibration.
+	 */
+	val16 = rtl8xxxu_read16(priv, REG_CR);
+	val16 |= (CR_HCI_TXDMA_ENABLE | CR_HCI_RXDMA_ENABLE |
+		  CR_TXDMA_ENABLE | CR_RXDMA_ENABLE |
+		  CR_PROTOCOL_ENABLE | CR_SCHEDULE_ENABLE |
+		  CR_MAC_TX_ENABLE | CR_MAC_RX_ENABLE |
+		  CR_SECURITY_ENABLE | CR_CALTIMER_ENABLE);
+	rtl8xxxu_write16(priv, REG_CR, val16);
+
+	/* For EFuse PG */
+	val32 = rtl8xxxu_read32(priv, REG_EFUSE_CTRL);
+	val32 &= ~(BIT(28) | BIT(29) | BIT(30));
+	val32 |= (0x06 << 28);
+	rtl8xxxu_write32(priv, REG_EFUSE_CTRL, val32);
+exit:
+	return ret;
+}
+
+struct rtl8xxxu_fileops rtl8723au_fops = {
+	.parse_efuse = rtl8723au_parse_efuse,
+	.load_firmware = rtl8723au_load_firmware,
+	.power_on = rtl8723au_power_on,
+	.power_off = rtl8xxxu_power_off,
+	.reset_8051 = rtl8xxxu_reset_8051,
+	.llt_init = rtl8xxxu_init_llt_table,
+	.init_phy_bb = rtl8xxxu_gen1_init_phy_bb,
+	.init_phy_rf = rtl8723au_init_phy_rf,
+	.phy_iq_calibrate = rtl8xxxu_gen1_phy_iq_calibrate,
+	.config_channel = rtl8xxxu_gen1_config_channel,
+	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
+	.enable_rf = rtl8xxxu_gen1_enable_rf,
+	.disable_rf = rtl8xxxu_gen1_disable_rf,
+	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
+	.set_tx_power = rtl8xxxu_gen1_set_tx_power,
+	.update_rate_mask = rtl8xxxu_update_rate_mask,
+	.report_connect = rtl8xxxu_gen1_report_connect,
+	.writeN_block_size = 1024,
+	.mbox_ext_reg = REG_HMBOX_EXT_0,
+	.mbox_ext_width = 2,
+	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc32),
+	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc16),
+	.adda_1t_init = 0x0b1b25a0,
+	.adda_1t_path_on = 0x0bdb25a0,
+	.adda_2t_path_on_a = 0x04db25a4,
+	.adda_2t_path_on_b = 0x0b1b25a4,
+	.trxff_boundary = 0x27ff,
+	.pbp_rx = PBP_PAGE_SIZE_128,
+	.pbp_tx = PBP_PAGE_SIZE_128,
+	.mactable = rtl8xxxu_gen1_mac_init_table,
+};
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 5542a41..6434558 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -128,7 +128,7 @@ static struct ieee80211_supported_band rtl8xxxu_supported_band = {
 	.n_bitrates = ARRAY_SIZE(rtl8xxxu_rates),
 };
 
-static struct rtl8xxxu_reg8val rtl8xxxu_gen1_mac_init_table[] = {
+struct rtl8xxxu_reg8val rtl8xxxu_gen1_mac_init_table[] = {
 	{0x420, 0x80}, {0x423, 0x00}, {0x430, 0x00}, {0x431, 0x00},
 	{0x432, 0x00}, {0x433, 0x01}, {0x434, 0x04}, {0x435, 0x05},
 	{0x436, 0x06}, {0x437, 0x07}, {0x438, 0x00}, {0x439, 0x00},
@@ -199,28 +199,6 @@ static struct rtl8xxxu_power_base rtl8192c_power_base = {
 };
 #endif
 
-static struct rtl8xxxu_power_base rtl8723a_power_base = {
-	.reg_0e00 = 0x0a0c0c0c,
-	.reg_0e04 = 0x02040608,
-	.reg_0e08 = 0x00000000,
-	.reg_086c = 0x00000000,
-
-	.reg_0e10 = 0x0a0c0d0e,
-	.reg_0e14 = 0x02040608,
-	.reg_0e18 = 0x0a0c0d0e,
-	.reg_0e1c = 0x02040608,
-
-	.reg_0830 = 0x0a0c0c0c,
-	.reg_0834 = 0x02040608,
-	.reg_0838 = 0x00000000,
-	.reg_086c_2 = 0x00000000,
-
-	.reg_083c = 0x0a0c0d0e,
-	.reg_0848 = 0x02040608,
-	.reg_084c = 0x0a0c0d0e,
-	.reg_0868 = 0x02040608,
-};
-
 static struct rtl8xxxu_reg32val rtl8723a_phy_1t_init_table[] = {
 	{0x800, 0x80040000}, {0x804, 0x00000003},
 	{0x808, 0x0000fc00}, {0x80c, 0x0000000a},
@@ -684,81 +662,6 @@ static struct rtl8xxxu_reg32val rtl8xxx_agc_highpa_table[] = {
 	{0xffff, 0xffffffff}
 };
 
-static struct rtl8xxxu_rfregval rtl8723au_radioa_1t_init_table[] = {
-	{0x00, 0x00030159}, {0x01, 0x00031284},
-	{0x02, 0x00098000}, {0x03, 0x00039c63},
-	{0x04, 0x000210e7}, {0x09, 0x0002044f},
-	{0x0a, 0x0001a3f1}, {0x0b, 0x00014787},
-	{0x0c, 0x000896fe}, {0x0d, 0x0000e02c},
-	{0x0e, 0x00039ce7}, {0x0f, 0x00000451},
-	{0x19, 0x00000000}, {0x1a, 0x00030355},
-	{0x1b, 0x00060a00}, {0x1c, 0x000fc378},
-	{0x1d, 0x000a1250}, {0x1e, 0x0000024f},
-	{0x1f, 0x00000000}, {0x20, 0x0000b614},
-	{0x21, 0x0006c000}, {0x22, 0x00000000},
-	{0x23, 0x00001558}, {0x24, 0x00000060},
-	{0x25, 0x00000483}, {0x26, 0x0004f000},
-	{0x27, 0x000ec7d9}, {0x28, 0x00057730},
-	{0x29, 0x00004783}, {0x2a, 0x00000001},
-	{0x2b, 0x00021334}, {0x2a, 0x00000000},
-	{0x2b, 0x00000054}, {0x2a, 0x00000001},
-	{0x2b, 0x00000808}, {0x2b, 0x00053333},
-	{0x2c, 0x0000000c}, {0x2a, 0x00000002},
-	{0x2b, 0x00000808}, {0x2b, 0x0005b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000003},
-	{0x2b, 0x00000808}, {0x2b, 0x00063333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000004},
-	{0x2b, 0x00000808}, {0x2b, 0x0006b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000005},
-	{0x2b, 0x00000808}, {0x2b, 0x00073333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000006},
-	{0x2b, 0x00000709}, {0x2b, 0x0005b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000007},
-	{0x2b, 0x00000709}, {0x2b, 0x00063333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000008},
-	{0x2b, 0x0000060a}, {0x2b, 0x0004b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x00000009},
-	{0x2b, 0x0000060a}, {0x2b, 0x00053333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000a},
-	{0x2b, 0x0000060a}, {0x2b, 0x0005b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000b},
-	{0x2b, 0x0000060a}, {0x2b, 0x00063333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000c},
-	{0x2b, 0x0000060a}, {0x2b, 0x0006b333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000d},
-	{0x2b, 0x0000060a}, {0x2b, 0x00073333},
-	{0x2c, 0x0000000d}, {0x2a, 0x0000000e},
-	{0x2b, 0x0000050b}, {0x2b, 0x00066666},
-	{0x2c, 0x0000001a}, {0x2a, 0x000e0000},
-	{0x10, 0x0004000f}, {0x11, 0x000e31fc},
-	{0x10, 0x0006000f}, {0x11, 0x000ff9f8},
-	{0x10, 0x0002000f}, {0x11, 0x000203f9},
-	{0x10, 0x0003000f}, {0x11, 0x000ff500},
-	{0x10, 0x00000000}, {0x11, 0x00000000},
-	{0x10, 0x0008000f}, {0x11, 0x0003f100},
-	{0x10, 0x0009000f}, {0x11, 0x00023100},
-	{0x12, 0x00032000}, {0x12, 0x00071000},
-	{0x12, 0x000b0000}, {0x12, 0x000fc000},
-	{0x13, 0x000287b3}, {0x13, 0x000244b7},
-	{0x13, 0x000204ab}, {0x13, 0x0001c49f},
-	{0x13, 0x00018493}, {0x13, 0x0001429b},
-	{0x13, 0x00010299}, {0x13, 0x0000c29c},
-	{0x13, 0x000081a0}, {0x13, 0x000040ac},
-	{0x13, 0x00000020}, {0x14, 0x0001944c},
-	{0x14, 0x00059444}, {0x14, 0x0009944c},
-	{0x14, 0x000d9444}, {0x15, 0x0000f474},
-	{0x15, 0x0004f477}, {0x15, 0x0008f455},
-	{0x15, 0x000cf455}, {0x16, 0x00000339},
-	{0x16, 0x00040339}, {0x16, 0x00080339},
-	{0x16, 0x000c0366}, {0x00, 0x00010159},
-	{0x18, 0x0000f401}, {0xfe, 0x00000000},
-	{0xfe, 0x00000000}, {0x1f, 0x00000003},
-	{0xfe, 0x00000000}, {0xfe, 0x00000000},
-	{0x1e, 0x00000247}, {0x1f, 0x00000000},
-	{0x00, 0x00030159},
-	{0xff, 0xffffffff}
-};
-
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 static struct rtl8xxxu_rfregval rtl8192cu_radioa_2t_init_table[] = {
 	{0x00, 0x00030159}, {0x01, 0x00031284},
@@ -1340,7 +1243,7 @@ error:
 	return retval;
 }
 
-static void rtl8xxxu_gen1_enable_rf(struct rtl8xxxu_priv *priv)
+void rtl8xxxu_gen1_enable_rf(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
 	u32 val32;
@@ -1384,7 +1287,7 @@ static void rtl8xxxu_gen1_enable_rf(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
 }
 
-static void rtl8xxxu_gen1_disable_rf(struct rtl8xxxu_priv *priv)
+void rtl8xxxu_gen1_disable_rf(struct rtl8xxxu_priv *priv)
 {
 	u8 sps0;
 	u32 val32;
@@ -1483,7 +1386,7 @@ int rtl8xxxu_gen2_channel_to_group(int channel)
 	return group;
 }
 
-static void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw)
+void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	u32 val32, rsr;
@@ -1735,7 +1638,7 @@ void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw)
 	}
 }
 
-static void
+void
 rtl8xxxu_gen1_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 {
 	struct rtl8xxxu_power_base *power_base = priv->power_base;
@@ -2110,57 +2013,6 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 	return 0;
 }
 
-static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
-{
-	struct rtl8723au_efuse *efuse = &priv->efuse_wifi.efuse8723;
-
-	if (efuse->rtl_id != cpu_to_le16(0x8129))
-		return -EINVAL;
-
-	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
-
-	memcpy(priv->cck_tx_power_index_A,
-	       efuse->cck_tx_power_index_A,
-	       sizeof(efuse->cck_tx_power_index_A));
-	memcpy(priv->cck_tx_power_index_B,
-	       efuse->cck_tx_power_index_B,
-	       sizeof(efuse->cck_tx_power_index_B));
-
-	memcpy(priv->ht40_1s_tx_power_index_A,
-	       efuse->ht40_1s_tx_power_index_A,
-	       sizeof(efuse->ht40_1s_tx_power_index_A));
-	memcpy(priv->ht40_1s_tx_power_index_B,
-	       efuse->ht40_1s_tx_power_index_B,
-	       sizeof(efuse->ht40_1s_tx_power_index_B));
-
-	memcpy(priv->ht20_tx_power_index_diff,
-	       efuse->ht20_tx_power_index_diff,
-	       sizeof(efuse->ht20_tx_power_index_diff));
-	memcpy(priv->ofdm_tx_power_index_diff,
-	       efuse->ofdm_tx_power_index_diff,
-	       sizeof(efuse->ofdm_tx_power_index_diff));
-
-	memcpy(priv->ht40_max_power_offset,
-	       efuse->ht40_max_power_offset,
-	       sizeof(efuse->ht40_max_power_offset));
-	memcpy(priv->ht20_max_power_offset,
-	       efuse->ht20_max_power_offset,
-	       sizeof(efuse->ht20_max_power_offset));
-
-	if (priv->efuse_wifi.efuse8723.version >= 0x01) {
-		priv->has_xtalk = 1;
-		priv->xtalk = priv->efuse_wifi.efuse8723.xtal_k & 0x3f;
-	}
-
-	priv->power_base = &rtl8723a_power_base;
-
-	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
-		 efuse->vendor_name);
-	dev_info(&priv->udev->dev, "Product: %.41s\n",
-		 efuse->device_name);
-	return 0;
-}
-
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 
 static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
@@ -2590,30 +2442,6 @@ exit:
 	return ret;
 }
 
-static int rtl8723au_load_firmware(struct rtl8xxxu_priv *priv)
-{
-	char *fw_name;
-	int ret;
-
-	switch (priv->chip_cut) {
-	case 0:
-		fw_name = "rtlwifi/rtl8723aufw_A.bin";
-		break;
-	case 1:
-		if (priv->enable_bluetooth)
-			fw_name = "rtlwifi/rtl8723aufw_B.bin";
-		else
-			fw_name = "rtlwifi/rtl8723aufw_B_NoBT.bin";
-
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	ret = rtl8xxxu_load_firmware(priv, fw_name);
-	return ret;
-}
-
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 
 static int rtl8192cu_load_firmware(struct rtl8xxxu_priv *priv)
@@ -2718,7 +2546,7 @@ int rtl8xxxu_init_phy_regs(struct rtl8xxxu_priv *priv,
 	return 0;
 }
 
-static void rtl8xxxu_gen1_init_phy_bb(struct rtl8xxxu_priv *priv)
+void rtl8xxxu_gen1_init_phy_bb(struct rtl8xxxu_priv *priv)
 {
 	u8 val8, ldoa15, ldov12d, lpldo, ldohci12;
 	u16 val16;
@@ -2970,21 +2798,6 @@ int rtl8xxxu_init_phy_rf(struct rtl8xxxu_priv *priv,
 	return 0;
 }
 
-static int rtl8723au_init_phy_rf(struct rtl8xxxu_priv *priv)
-{
-	int ret;
-
-	ret = rtl8xxxu_init_phy_rf(priv, rtl8723au_radioa_1t_init_table, RF_A);
-
-	/* Reduce 80M spur */
-	rtl8xxxu_write32(priv, REG_AFE_XTAL_CTRL, 0x0381808d);
-	rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
-	rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff82);
-	rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
-
-	return ret;
-}
-
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 static int rtl8192cu_init_phy_rf(struct rtl8xxxu_priv *priv)
 {
@@ -3032,7 +2845,7 @@ static int rtl8xxxu_llt_write(struct rtl8xxxu_priv *priv, u8 address, u8 data)
 	return ret;
 }
 
-static int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page)
+int rtl8xxxu_init_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page)
 {
 	int ret;
 	int i;
@@ -3888,7 +3701,7 @@ void rtl8xxxu_prepare_calibrate(struct rtl8xxxu_priv *priv, u8 start)
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.bt_wlan_calibration));
 }
 
-static void rtl8xxxu_gen1_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
+void rtl8xxxu_gen1_phy_iq_calibrate(struct rtl8xxxu_priv *priv)
 {
 	struct device *dev = &priv->udev->dev;
 	int result[4][8];	/* last is final result */
@@ -4236,98 +4049,6 @@ void rtl8723a_disabled_to_emu(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
 }
 
-static int rtl8723a_emu_to_active(struct rtl8xxxu_priv *priv)
-{
-	u8 val8;
-	u32 val32;
-	int count, ret = 0;
-
-	/* 0x20[0] = 1 enable LDOA12 MACRO block for all interface*/
-	val8 = rtl8xxxu_read8(priv, REG_LDOA15_CTRL);
-	val8 |= LDOA15_ENABLE;
-	rtl8xxxu_write8(priv, REG_LDOA15_CTRL, val8);
-
-	/* 0x67[0] = 0 to disable BT_GPS_SEL pins*/
-	val8 = rtl8xxxu_read8(priv, 0x0067);
-	val8 &= ~BIT(4);
-	rtl8xxxu_write8(priv, 0x0067, val8);
-
-	mdelay(1);
-
-	/* 0x00[5] = 0 release analog Ips to digital, 1:isolation */
-	val8 = rtl8xxxu_read8(priv, REG_SYS_ISO_CTRL);
-	val8 &= ~SYS_ISO_ANALOG_IPS;
-	rtl8xxxu_write8(priv, REG_SYS_ISO_CTRL, val8);
-
-	/* disable SW LPS 0x04[10]= 0 */
-	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
-	val8 &= ~BIT(2);
-	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
-
-	/* wait till 0x04[17] = 1 power ready*/
-	for (count = RTL8XXXU_MAX_REG_POLL; count; count--) {
-		val32 = rtl8xxxu_read32(priv, REG_APS_FSMCO);
-		if (val32 & BIT(17))
-			break;
-
-		udelay(10);
-	}
-
-	if (!count) {
-		ret = -EBUSY;
-		goto exit;
-	}
-
-	/* We should be able to optimize the following three entries into one */
-
-	/* release WLON reset 0x04[16]= 1*/
-	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 2);
-	val8 |= BIT(0);
-	rtl8xxxu_write8(priv, REG_APS_FSMCO + 2, val8);
-
-	/* disable HWPDN 0x04[15]= 0*/
-	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
-	val8 &= ~BIT(7);
-	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
-
-	/* disable WL suspend*/
-	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 1);
-	val8 &= ~(BIT(3) | BIT(4));
-	rtl8xxxu_write8(priv, REG_APS_FSMCO + 1, val8);
-
-	/* set, then poll until 0 */
-	val32 = rtl8xxxu_read32(priv, REG_APS_FSMCO);
-	val32 |= APS_FSMCO_MAC_ENABLE;
-	rtl8xxxu_write32(priv, REG_APS_FSMCO, val32);
-
-	for (count = RTL8XXXU_MAX_REG_POLL; count; count--) {
-		val32 = rtl8xxxu_read32(priv, REG_APS_FSMCO);
-		if ((val32 & APS_FSMCO_MAC_ENABLE) == 0) {
-			ret = 0;
-			break;
-		}
-		udelay(10);
-	}
-
-	if (!count) {
-		ret = -EBUSY;
-		goto exit;
-	}
-
-	/* 0x4C[23] = 0x4E[7] = 1, switch DPDT_SEL_P output from WL BB */
-	/*
-	 * Note: Vendor driver actually clears this bit, despite the
-	 * documentation claims it's being set!
-	 */
-	val8 = rtl8xxxu_read8(priv, REG_LEDCFG2);
-	val8 |= LEDCFG2_DPDT_SELECT;
-	val8 &= ~LEDCFG2_DPDT_SELECT;
-	rtl8xxxu_write8(priv, REG_LEDCFG2, val8);
-
-exit:
-	return ret;
-}
-
 static int rtl8xxxu_emu_to_disabled(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
@@ -4386,7 +4107,7 @@ int rtl8xxxu_flush_fifo(struct rtl8xxxu_priv *priv)
 	return retval;
 }
 
-static void rtl8xxxu_gen1_usb_quirks(struct rtl8xxxu_priv *priv)
+void rtl8xxxu_gen1_usb_quirks(struct rtl8xxxu_priv *priv)
 {
 	/* Fix USB interface interference issue */
 	rtl8xxxu_write8(priv, 0xfe40, 0xe0);
@@ -4430,52 +4151,6 @@ void rtl8xxxu_gen2_usb_quirks(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, val32);
 }
 
-static int rtl8723au_power_on(struct rtl8xxxu_priv *priv)
-{
-	u8 val8;
-	u16 val16;
-	u32 val32;
-	int ret;
-
-	/*
-	 * RSV_CTRL 0x001C[7:0] = 0x00, unlock ISO/CLK/Power control register
-	 */
-	rtl8xxxu_write8(priv, REG_RSV_CTRL, 0x0);
-
-	rtl8723a_disabled_to_emu(priv);
-
-	ret = rtl8723a_emu_to_active(priv);
-	if (ret)
-		goto exit;
-
-	/*
-	 * 0x0004[19] = 1, reset 8051
-	 */
-	val8 = rtl8xxxu_read8(priv, REG_APS_FSMCO + 2);
-	val8 |= BIT(3);
-	rtl8xxxu_write8(priv, REG_APS_FSMCO + 2, val8);
-
-	/*
-	 * Enable MAC DMA/WMAC/SCHEDULE/SEC block
-	 * Set CR bit10 to enable 32k calibration.
-	 */
-	val16 = rtl8xxxu_read16(priv, REG_CR);
-	val16 |= (CR_HCI_TXDMA_ENABLE | CR_HCI_RXDMA_ENABLE |
-		  CR_TXDMA_ENABLE | CR_RXDMA_ENABLE |
-		  CR_PROTOCOL_ENABLE | CR_SCHEDULE_ENABLE |
-		  CR_MAC_TX_ENABLE | CR_MAC_RX_ENABLE |
-		  CR_SECURITY_ENABLE | CR_CALTIMER_ENABLE);
-	rtl8xxxu_write16(priv, REG_CR, val16);
-
-	/* For EFuse PG */
-	val32 = rtl8xxxu_read32(priv, REG_EFUSE_CTRL);
-	val32 &= ~(BIT(28) | BIT(29) | BIT(30));
-	val32 |= (0x06 << 28);
-	rtl8xxxu_write32(priv, REG_EFUSE_CTRL, val32);
-exit:
-	return ret;
-}
-
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 
 static int rtl8192cu_power_on(struct rtl8xxxu_priv *priv)
@@ -5150,8 +4825,7 @@ static void rtl8xxxu_sw_scan_complete(struct ieee80211_hw *hw,
 	rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
 }
 
-static void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
-				      u32 ramask, int sgi)
+void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv, u32 ramask, int sgi)
 {
 	struct h2c_cmd h2c;
 
@@ -5196,8 +4870,8 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.b_macid_cfg));
 }
 
-static void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
-					 u8 macid, bool connect)
+void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
+				  u8 macid, bool connect)
 {
 	struct h2c_cmd h2c;
 
@@ -5867,9 +5541,8 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 	}
 }
 
-static int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv,
-				   struct sk_buff *skb,
-				   struct ieee80211_rx_status *rx_status)
+int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb,
+			    struct ieee80211_rx_status *rx_status)
 {
 	struct rtl8xxxu_rxdesc16 *rx_desc =
 		(struct rtl8xxxu_rxdesc16 *)skb->data;
@@ -6819,39 +6492,6 @@ static void rtl8xxxu_disconnect(struct usb_interface *interface)
 	ieee80211_free_hw(hw);
 }
 
-static struct rtl8xxxu_fileops rtl8723au_fops = {
-	.parse_efuse = rtl8723au_parse_efuse,
-	.load_firmware = rtl8723au_load_firmware,
-	.power_on = rtl8723au_power_on,
-	.power_off = rtl8xxxu_power_off,
-	.reset_8051 = rtl8xxxu_reset_8051,
-	.llt_init = rtl8xxxu_init_llt_table,
-	.init_phy_bb = rtl8xxxu_gen1_init_phy_bb,
-	.init_phy_rf = rtl8723au_init_phy_rf,
-	.phy_iq_calibrate = rtl8xxxu_gen1_phy_iq_calibrate,
-	.config_channel = rtl8xxxu_gen1_config_channel,
-	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
-	.enable_rf = rtl8xxxu_gen1_enable_rf,
-	.disable_rf = rtl8xxxu_gen1_disable_rf,
-	.usb_quirks = rtl8xxxu_gen1_usb_quirks,
-	.set_tx_power = rtl8xxxu_gen1_set_tx_power,
-	.update_rate_mask = rtl8xxxu_update_rate_mask,
-	.report_connect = rtl8xxxu_gen1_report_connect,
-	.writeN_block_size = 1024,
-	.mbox_ext_reg = REG_HMBOX_EXT_0,
-	.mbox_ext_width = 2,
-	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc32),
-	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc16),
-	.adda_1t_init = 0x0b1b25a0,
-	.adda_1t_path_on = 0x0bdb25a0,
-	.adda_2t_path_on_a = 0x04db25a4,
-	.adda_2t_path_on_b = 0x0b1b25a4,
-	.trxff_boundary = 0x27ff,
-	.pbp_rx = PBP_PAGE_SIZE_128,
-	.pbp_tx = PBP_PAGE_SIZE_128,
-	.mactable = rtl8xxxu_gen1_mac_init_table,
-};
-
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 
 static struct rtl8xxxu_fileops rtl8192cu_fops = {
-- 
2.5.5

