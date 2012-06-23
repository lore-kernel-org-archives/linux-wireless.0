Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:58963 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754779Ab2FWGmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:07 -0400
Received: by lbbgo11 with SMTP id go11so4844288lbb.31
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:42:03 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 08/18] wlcore: Propagate errors from wl1271_raw_read32
Date: Sat, 23 Jun 2012 09:41:19 +0300
Message-Id: <1340433689-24320-9-git-send-email-coelho@ti.com> (sfid-20120623_084214_714943_7CDBCB06)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Propagate errors from wl1271_raw_read32. Since the read functions had no
way of returning errors in-band, change their prototypes.
Also rename prefixes of wlcore functions which their prototypes had to
be changed.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |  152 +++++++++++++++++++++++--------
 drivers/net/wireless/ti/wl18xx/io.c     |   35 +++++--
 drivers/net/wireless/ti/wl18xx/io.h     |    4 +-
 drivers/net/wireless/ti/wl18xx/main.c   |  114 ++++++++++++++++-------
 drivers/net/wireless/ti/wlcore/boot.c   |   31 +++++--
 drivers/net/wireless/ti/wlcore/cmd.c    |    9 +-
 drivers/net/wireless/ti/wlcore/io.h     |   26 ++++--
 drivers/net/wireless/ti/wlcore/main.c   |   47 +++++++---
 drivers/net/wireless/ti/wlcore/wlcore.h |    4 +-
 9 files changed, 309 insertions(+), 113 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 257745f..ab486f7 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -701,10 +701,11 @@ static void wl12xx_top_reg_write(struct wl1271 *wl, int addr, u16 val)
 	wl1271_write32(wl, WL12XX_OCP_CMD, OCP_CMD_WRITE);
 }
 
-static u16 wl12xx_top_reg_read(struct wl1271 *wl, int addr)
+static int wl12xx_top_reg_read(struct wl1271 *wl, int addr, u16 *out)
 {
 	u32 val;
 	int timeout = OCP_CMD_LOOP;
+	int ret;
 
 	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
 	addr = (addr >> 1) + 0x30000;
@@ -715,29 +716,38 @@ static u16 wl12xx_top_reg_read(struct wl1271 *wl, int addr)
 
 	/* poll for data ready */
 	do {
-		val = wl1271_read32(wl, WL12XX_OCP_DATA_READ);
+		ret = wlcore_read32(wl, WL12XX_OCP_DATA_READ, &val);
+		if (ret < 0)
+			return ret;
 	} while (!(val & OCP_READY_MASK) && --timeout);
 
 	if (!timeout) {
 		wl1271_warning("Top register access timed out.");
-		return 0xffff;
+		return -ETIMEDOUT;
 	}
 
 	/* check data status and return if OK */
-	if ((val & OCP_STATUS_MASK) == OCP_STATUS_OK)
-		return val & 0xffff;
-	else {
+	if ((val & OCP_STATUS_MASK) != OCP_STATUS_OK) {
 		wl1271_warning("Top register access returned error.");
-		return 0xffff;
+		return -EIO;
 	}
+
+	if (out)
+		*out = val & 0xffff;
+
+	return 0;
 }
 
 static int wl128x_switch_tcxo_to_fref(struct wl1271 *wl)
 {
 	u16 spare_reg;
+	int ret;
 
 	/* Mask bits [2] & [8:4] in the sys_clk_cfg register */
-	spare_reg = wl12xx_top_reg_read(wl, WL_SPARE_REG);
+	ret = wl12xx_top_reg_read(wl, WL_SPARE_REG, &spare_reg);
+	if (ret < 0)
+		return ret;
+
 	if (spare_reg == 0xFFFF)
 		return -EFAULT;
 	spare_reg |= (BIT(3) | BIT(5) | BIT(6));
@@ -756,8 +766,12 @@ static int wl128x_switch_tcxo_to_fref(struct wl1271 *wl)
 static bool wl128x_is_tcxo_valid(struct wl1271 *wl)
 {
 	u16 tcxo_detection;
+	int ret;
+
+	ret = wl12xx_top_reg_read(wl, TCXO_CLK_DETECT_REG, &tcxo_detection);
+	if (ret < 0)
+		return false;
 
-	tcxo_detection = wl12xx_top_reg_read(wl, TCXO_CLK_DETECT_REG);
 	if (tcxo_detection & TCXO_DET_FAILED)
 		return false;
 
@@ -767,8 +781,12 @@ static bool wl128x_is_tcxo_valid(struct wl1271 *wl)
 static bool wl128x_is_fref_valid(struct wl1271 *wl)
 {
 	u16 fref_detection;
+	int ret;
+
+	ret = wl12xx_top_reg_read(wl, FREF_CLK_DETECT_REG, &fref_detection);
+	if (ret < 0)
+		return false;
 
-	fref_detection = wl12xx_top_reg_read(wl, FREF_CLK_DETECT_REG);
 	if (fref_detection & FREF_CLK_DETECT_FAIL)
 		return false;
 
@@ -790,9 +808,13 @@ static int wl128x_configure_mcs_pll(struct wl1271 *wl, int clk)
 	u16 pll_config;
 	u8 input_freq;
 	struct wl12xx_priv *priv = wl->priv;
+	int ret;
 
 	/* Mask bits [3:1] in the sys_clk_cfg register */
-	spare_reg = wl12xx_top_reg_read(wl, WL_SPARE_REG);
+	ret = wl12xx_top_reg_read(wl, WL_SPARE_REG, &spare_reg);
+	if (ret < 0)
+		return ret;
+
 	if (spare_reg == 0xFFFF)
 		return -EFAULT;
 	spare_reg |= BIT(2);
@@ -806,7 +828,10 @@ static int wl128x_configure_mcs_pll(struct wl1271 *wl, int clk)
 	/* Set the input frequency according to the selected clock source */
 	input_freq = (clk & 1) + 1;
 
-	pll_config = wl12xx_top_reg_read(wl, MCS_PLL_CONFIG_REG);
+	ret = wl12xx_top_reg_read(wl, MCS_PLL_CONFIG_REG, &pll_config);
+	if (ret < 0)
+		return ret;
+
 	if (pll_config == 0xFFFF)
 		return -EFAULT;
 	pll_config |= (input_freq << MCS_SEL_IN_FREQ_SHIFT);
@@ -827,6 +852,7 @@ static int wl128x_boot_clk(struct wl1271 *wl, int *selected_clock)
 {
 	struct wl12xx_priv *priv = wl->priv;
 	u16 sys_clk_cfg;
+	int ret;
 
 	/* For XTAL-only modes, FREF will be used after switching from TCXO */
 	if (priv->ref_clock == WL12XX_REFCLOCK_26_XTAL ||
@@ -837,7 +863,10 @@ static int wl128x_boot_clk(struct wl1271 *wl, int *selected_clock)
 	}
 
 	/* Query the HW, to determine which clock source we should use */
-	sys_clk_cfg = wl12xx_top_reg_read(wl, SYS_CLK_CFG_REG);
+	ret = wl12xx_top_reg_read(wl, SYS_CLK_CFG_REG, &sys_clk_cfg);
+	if (ret < 0)
+		return ret;
+
 	if (sys_clk_cfg == 0xFFFF)
 		return -EINVAL;
 	if (sys_clk_cfg & PRCM_CM_EN_MUX_WLAN_FREF)
@@ -872,6 +901,7 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 	struct wl12xx_priv *priv = wl->priv;
 	u32 pause;
 	u32 clk;
+	int ret;
 
 	if (WL127X_PG_GET_MAJOR(wl->hw_pg_ver) < 3)
 		wl->quirks |= WLCORE_QUIRK_END_OF_TRANSACTION;
@@ -892,18 +922,27 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 	if (priv->ref_clock != CONF_REF_CLK_19_2_E) {
 		u16 val;
 		/* Set clock type (open drain) */
-		val = wl12xx_top_reg_read(wl, OCP_REG_CLK_TYPE);
+		ret = wl12xx_top_reg_read(wl, OCP_REG_CLK_TYPE, &val);
+		if (ret < 0)
+			goto out;
+
 		val &= FREF_CLK_TYPE_BITS;
 		wl12xx_top_reg_write(wl, OCP_REG_CLK_TYPE, val);
 
 		/* Set clock pull mode (no pull) */
-		val = wl12xx_top_reg_read(wl, OCP_REG_CLK_PULL);
+		ret = wl12xx_top_reg_read(wl, OCP_REG_CLK_PULL, &val);
+		if (ret < 0)
+			goto out;
+
 		val |= NO_PULL;
 		wl12xx_top_reg_write(wl, OCP_REG_CLK_PULL, val);
 	} else {
 		u16 val;
 		/* Set clock polarity */
-		val = wl12xx_top_reg_read(wl, OCP_REG_CLK_POLARITY);
+		ret = wl12xx_top_reg_read(wl, OCP_REG_CLK_POLARITY, &val);
+		if (ret < 0)
+			goto out;
+
 		val &= FREF_CLK_POLARITY_BITS;
 		val |= CLK_REQ_OUTN_SEL;
 		wl12xx_top_reg_write(wl, OCP_REG_CLK_POLARITY, val);
@@ -911,7 +950,9 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 
 	wl1271_write32(wl, WL12XX_PLL_PARAMETERS, clk);
 
-	pause = wl1271_read32(wl, WL12XX_PLL_PARAMETERS);
+	ret = wlcore_read32(wl, WL12XX_PLL_PARAMETERS, &pause);
+	if (ret < 0)
+		goto out;
 
 	wl1271_debug(DEBUG_BOOT, "pause1 0x%x", pause);
 
@@ -919,13 +960,15 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 	pause |= WU_COUNTER_PAUSE_VAL;
 	wl1271_write32(wl, WL12XX_WU_COUNTER_PAUSE, pause);
 
-	return 0;
+out:
+	return ret;
 }
 
 static int wl1271_boot_soft_reset(struct wl1271 *wl)
 {
 	unsigned long timeout;
 	u32 boot_data;
+	int ret = 0;
 
 	/* perform soft reset */
 	wl1271_write32(wl, WL12XX_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
@@ -933,7 +976,10 @@ static int wl1271_boot_soft_reset(struct wl1271 *wl)
 	/* SOFT_RESET is self clearing */
 	timeout = jiffies + usecs_to_jiffies(SOFT_RESET_MAX_TIME);
 	while (1) {
-		boot_data = wl1271_read32(wl, WL12XX_SLV_SOFT_RESET);
+		ret = wlcore_read32(wl, WL12XX_SLV_SOFT_RESET, &boot_data);
+		if (ret < 0)
+			goto out;
+
 		wl1271_debug(DEBUG_BOOT, "soft reset bootdata 0x%x", boot_data);
 		if ((boot_data & ACX_SLV_SOFT_RESET_BIT) == 0)
 			break;
@@ -954,7 +1000,8 @@ static int wl1271_boot_soft_reset(struct wl1271 *wl)
 	/* disable auto calibration on start*/
 	wl1271_write32(wl, WL12XX_SPARE_A2, 0xffff);
 
-	return 0;
+out:
+	return ret;
 }
 
 static int wl12xx_pre_boot(struct wl1271 *wl)
@@ -984,7 +1031,9 @@ static int wl12xx_pre_boot(struct wl1271 *wl)
 	   to be used by DRPw FW. The RTRIM value will be added by the FW
 	   before taking DRPw out of reset */
 
-	clk = wl1271_read32(wl, WL12XX_DRPW_SCRATCH_START);
+	ret = wlcore_read32(wl, WL12XX_DRPW_SCRATCH_START, &clk);
+	if (ret < 0)
+		goto out;
 
 	wl1271_debug(DEBUG_BOOT, "clk2 0x%x", clk);
 
@@ -1008,9 +1057,11 @@ out:
 	return ret;
 }
 
-static void wl12xx_pre_upload(struct wl1271 *wl)
+static int wl12xx_pre_upload(struct wl1271 *wl)
 {
-	u32 tmp, polarity;
+	u32 tmp;
+	u16 polarity;
+	int ret;
 
 	/* write firmware's last address (ie. it's length) to
 	 * ACX_EEPROMLESS_IND_REG */
@@ -1018,12 +1069,16 @@ static void wl12xx_pre_upload(struct wl1271 *wl)
 
 	wl1271_write32(wl, WL12XX_EEPROMLESS_IND, WL12XX_EEPROMLESS_IND);
 
-	tmp = wlcore_read_reg(wl, REG_CHIP_ID_B);
+	ret = wlcore_read_reg(wl, REG_CHIP_ID_B, &tmp);
+	if (ret < 0)
+		goto out;
 
 	wl1271_debug(DEBUG_BOOT, "chip id 0x%x", tmp);
 
 	/* 6. read the EEPROM parameters */
-	tmp = wl1271_read32(wl, WL12XX_SCR_PAD2);
+	ret = wlcore_read32(wl, WL12XX_SCR_PAD2, &tmp);
+	if (ret < 0)
+		goto out;
 
 	/* WL1271: The reference driver skips steps 7 to 10 (jumps directly
 	 * to upload_fw) */
@@ -1032,12 +1087,16 @@ static void wl12xx_pre_upload(struct wl1271 *wl)
 		wl12xx_top_reg_write(wl, SDIO_IO_DS, HCI_IO_DS_6MA);
 
 	/* polarity must be set before the firmware is loaded */
-	polarity = wl12xx_top_reg_read(wl, OCP_REG_POLARITY);
+	ret = wl12xx_top_reg_read(wl, OCP_REG_POLARITY, &polarity);
+	if (ret < 0)
+		goto out;
 
 	/* We use HIGH polarity, so unset the LOW bit */
 	polarity &= ~POLARITY_LOW;
 	wl12xx_top_reg_write(wl, OCP_REG_POLARITY, polarity);
 
+out:
+	return ret;
 }
 
 static void wl12xx_enable_interrupts(struct wl1271 *wl)
@@ -1063,7 +1122,9 @@ static int wl12xx_boot(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	wl12xx_pre_upload(wl);
+	ret = wl12xx_pre_upload(wl);
+	if (ret < 0)
+		goto out;
 
 	ret = wlcore_boot_upload_firmware(wl);
 	if (ret < 0)
@@ -1282,14 +1343,20 @@ static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
 	return supported;
 }
 
-static void wl12xx_get_fuse_mac(struct wl1271 *wl)
+static int wl12xx_get_fuse_mac(struct wl1271 *wl)
 {
 	u32 mac1, mac2;
+	int ret;
 
 	wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
 
-	mac1 = wl1271_read32(wl, WL12XX_REG_FUSE_BD_ADDR_1);
-	mac2 = wl1271_read32(wl, WL12XX_REG_FUSE_BD_ADDR_2);
+	ret = wlcore_read32(wl, WL12XX_REG_FUSE_BD_ADDR_1, &mac1);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_read32(wl, WL12XX_REG_FUSE_BD_ADDR_2, &mac2);
+	if (ret < 0)
+		goto out;
 
 	/* these are the two parts of the BD_ADDR */
 	wl->fuse_oui_addr = ((mac2 & 0xffff) << 8) +
@@ -1297,24 +1364,35 @@ static void wl12xx_get_fuse_mac(struct wl1271 *wl)
 	wl->fuse_nic_addr = mac1 & 0xffffff;
 
 	wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
+
+out:
+	return ret;
 }
 
-static s8 wl12xx_get_pg_ver(struct wl1271 *wl)
+static int wl12xx_get_pg_ver(struct wl1271 *wl, s8 *ver)
 {
-	u32 die_info;
+	u16 die_info;
+	int ret;
 
 	if (wl->chip.id == CHIP_ID_1283_PG20)
-		die_info = wl12xx_top_reg_read(wl, WL128X_REG_FUSE_DATA_2_1);
+		ret = wl12xx_top_reg_read(wl, WL128X_REG_FUSE_DATA_2_1,
+					  &die_info);
 	else
-		die_info = wl12xx_top_reg_read(wl, WL127X_REG_FUSE_DATA_2_1);
+		ret = wl12xx_top_reg_read(wl, WL127X_REG_FUSE_DATA_2_1,
+					  &die_info);
 
-	return (s8) (die_info & PG_VER_MASK) >> PG_VER_OFFSET;
+	if (ret >= 0 && ver)
+		*ver = (s8)((die_info & PG_VER_MASK) >> PG_VER_OFFSET);
+
+	return ret;
 }
 
-static void wl12xx_get_mac(struct wl1271 *wl)
+static int wl12xx_get_mac(struct wl1271 *wl)
 {
 	if (wl12xx_mac_in_fuse(wl))
-		wl12xx_get_fuse_mac(wl);
+		return wl12xx_get_fuse_mac(wl);
+
+	return 0;
 }
 
 static void wl12xx_set_tx_desc_csum(struct wl1271 *wl,
diff --git a/drivers/net/wireless/ti/wl18xx/io.c b/drivers/net/wireless/ti/wl18xx/io.c
index 598c057..92c2c03 100644
--- a/drivers/net/wireless/ti/wl18xx/io.c
+++ b/drivers/net/wireless/ti/wl18xx/io.c
@@ -24,37 +24,52 @@
 
 #include "io.h"
 
-void wl18xx_top_reg_write(struct wl1271 *wl, int addr, u16 val)
+int wl18xx_top_reg_write(struct wl1271 *wl, int addr, u16 val)
 {
 	u32 tmp;
+	int ret;
 
 	if (WARN_ON(addr % 2))
-		return;
+		return -EINVAL;
 
 	if ((addr % 4) == 0) {
-		tmp = wl1271_read32(wl, addr);
+		ret = wlcore_read32(wl, addr, &tmp);
+		if (ret < 0)
+			goto out;
+
 		tmp = (tmp & 0xffff0000) | val;
 		wl1271_write32(wl, addr, tmp);
 	} else {
-		tmp = wl1271_read32(wl, addr - 2);
+		ret = wlcore_read32(wl, addr - 2, &tmp);
+		if (ret < 0)
+			goto out;
+
 		tmp = (tmp & 0xffff) | (val << 16);
 		wl1271_write32(wl, addr - 2, tmp);
 	}
+
+out:
+	return ret;
 }
 
-u16 wl18xx_top_reg_read(struct wl1271 *wl, int addr)
+int wl18xx_top_reg_read(struct wl1271 *wl, int addr, u16 *out)
 {
 	u32 val;
+	int ret;
 
 	if (WARN_ON(addr % 2))
-		return 0;
+		return -EINVAL;
 
 	if ((addr % 4) == 0) {
 		/* address is 4-bytes aligned */
-		val = wl1271_read32(wl, addr);
-		return val & 0xffff;
+		ret = wlcore_read32(wl, addr, &val);
+		if (ret >= 0 && out)
+			*out = val & 0xffff;
 	} else {
-		val = wl1271_read32(wl, addr - 2);
-		return (val & 0xffff0000) >> 16;
+		ret = wlcore_read32(wl, addr - 2, &val);
+		if (ret >= 0 && out)
+			*out = (val & 0xffff0000) >> 16;
 	}
+
+	return ret;
 }
diff --git a/drivers/net/wireless/ti/wl18xx/io.h b/drivers/net/wireless/ti/wl18xx/io.h
index be4e126..0e1b8d2 100644
--- a/drivers/net/wireless/ti/wl18xx/io.h
+++ b/drivers/net/wireless/ti/wl18xx/io.h
@@ -22,7 +22,7 @@
 #ifndef __WL18XX_IO_H__
 #define __WL18XX_IO_H__
 
-void wl18xx_top_reg_write(struct wl1271 *wl, int addr, u16 val);
-u16 wl18xx_top_reg_read(struct wl1271 *wl, int addr);
+int wl18xx_top_reg_write(struct wl1271 *wl, int addr, u16 val);
+int wl18xx_top_reg_read(struct wl1271 *wl, int addr, u16 *out);
 
 #endif /* __WL18XX_IO_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 974a6ff..f99f003 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -636,45 +636,67 @@ out:
 	return ret;
 }
 
-static void wl18xx_set_clk(struct wl1271 *wl)
+static int wl18xx_set_clk(struct wl1271 *wl)
 {
-	u32 clk_freq;
+	u16 clk_freq;
+	int ret;
 
 	wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
 
 	/* TODO: PG2: apparently we need to read the clk type */
 
-	clk_freq = wl18xx_top_reg_read(wl, PRIMARY_CLK_DETECT);
+	ret = wl18xx_top_reg_read(wl, PRIMARY_CLK_DETECT, &clk_freq);
+	if (ret < 0)
+		goto out;
+
 	wl1271_debug(DEBUG_BOOT, "clock freq %d (%d, %d, %d, %d, %s)", clk_freq,
 		     wl18xx_clk_table[clk_freq].n, wl18xx_clk_table[clk_freq].m,
 		     wl18xx_clk_table[clk_freq].p, wl18xx_clk_table[clk_freq].q,
 		     wl18xx_clk_table[clk_freq].swallow ? "swallow" : "spit");
 
-	wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_N, wl18xx_clk_table[clk_freq].n);
-	wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_M, wl18xx_clk_table[clk_freq].m);
+	ret = wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_N,
+				   wl18xx_clk_table[clk_freq].n);
+	if (ret < 0)
+		goto out;
+
+	ret = wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_M,
+				   wl18xx_clk_table[clk_freq].m);
+	if (ret < 0)
+		goto out;
 
 	if (wl18xx_clk_table[clk_freq].swallow) {
 		/* first the 16 lower bits */
-		wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_Q_FACTOR_CFG_1,
-				     wl18xx_clk_table[clk_freq].q &
-				     PLLSH_WCS_PLL_Q_FACTOR_CFG_1_MASK);
+		ret = wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_Q_FACTOR_CFG_1,
+					   wl18xx_clk_table[clk_freq].q &
+					   PLLSH_WCS_PLL_Q_FACTOR_CFG_1_MASK);
+		if (ret < 0)
+			goto out;
+
 		/* then the 16 higher bits, masked out */
-		wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_Q_FACTOR_CFG_2,
-				     (wl18xx_clk_table[clk_freq].q >> 16) &
-				     PLLSH_WCS_PLL_Q_FACTOR_CFG_2_MASK);
+		ret = wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_Q_FACTOR_CFG_2,
+					(wl18xx_clk_table[clk_freq].q >> 16) &
+					PLLSH_WCS_PLL_Q_FACTOR_CFG_2_MASK);
+		if (ret < 0)
+			goto out;
 
 		/* first the 16 lower bits */
-		wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_P_FACTOR_CFG_1,
-				     wl18xx_clk_table[clk_freq].p &
-				     PLLSH_WCS_PLL_P_FACTOR_CFG_1_MASK);
+		ret = wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_P_FACTOR_CFG_1,
+					   wl18xx_clk_table[clk_freq].p &
+					   PLLSH_WCS_PLL_P_FACTOR_CFG_1_MASK);
+		if (ret < 0)
+			goto out;
+
 		/* then the 16 higher bits, masked out */
-		wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_P_FACTOR_CFG_2,
-				     (wl18xx_clk_table[clk_freq].p >> 16) &
-				     PLLSH_WCS_PLL_P_FACTOR_CFG_2_MASK);
+		ret = wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_P_FACTOR_CFG_2,
+					(wl18xx_clk_table[clk_freq].p >> 16) &
+					PLLSH_WCS_PLL_P_FACTOR_CFG_2_MASK);
 	} else {
-		wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_SWALLOW_EN,
-				     PLLSH_WCS_PLL_SWALLOW_EN_VAL2);
+		ret = wl18xx_top_reg_write(wl, PLLSH_WCS_PLL_SWALLOW_EN,
+					   PLLSH_WCS_PLL_SWALLOW_EN_VAL2);
 	}
+
+out:
+	return ret;
 }
 
 static void wl18xx_boot_soft_reset(struct wl1271 *wl)
@@ -688,7 +710,11 @@ static void wl18xx_boot_soft_reset(struct wl1271 *wl)
 
 static int wl18xx_pre_boot(struct wl1271 *wl)
 {
-	wl18xx_set_clk(wl);
+	int ret;
+
+	ret = wl18xx_set_clk(wl);
+	if (ret < 0)
+		goto out;
 
 	/* Continue the ELP wake up sequence */
 	wl1271_write32(wl, WL18XX_WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
@@ -701,23 +727,30 @@ static int wl18xx_pre_boot(struct wl1271 *wl)
 
 	wl18xx_boot_soft_reset(wl);
 
-	return 0;
+out:
+	return ret;
 }
 
-static void wl18xx_pre_upload(struct wl1271 *wl)
+static int wl18xx_pre_upload(struct wl1271 *wl)
 {
 	u32 tmp;
+	int ret;
 
 	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
 
 	/* TODO: check if this is all needed */
 	wl1271_write32(wl, WL18XX_EEPROMLESS_IND, WL18XX_EEPROMLESS_IND);
 
-	tmp = wlcore_read_reg(wl, REG_CHIP_ID_B);
+	ret = wlcore_read_reg(wl, REG_CHIP_ID_B, &tmp);
+	if (ret < 0)
+		goto out;
 
 	wl1271_debug(DEBUG_BOOT, "chip id 0x%x", tmp);
 
-	tmp = wl1271_read32(wl, WL18XX_SCR_PAD2);
+	ret = wlcore_read32(wl, WL18XX_SCR_PAD2, &tmp);
+
+out:
+	return ret;
 }
 
 static int wl18xx_set_mac_and_phy(struct wl1271 *wl)
@@ -766,7 +799,9 @@ static int wl18xx_boot(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	wl18xx_pre_upload(wl);
+	ret = wl18xx_pre_upload(wl);
+	if (ret < 0)
+		goto out;
 
 	ret = wlcore_boot_upload_firmware(wl);
 	if (ret < 0)
@@ -998,18 +1033,24 @@ static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 	}
 }
 
-static s8 wl18xx_get_pg_ver(struct wl1271 *wl)
+static int wl18xx_get_pg_ver(struct wl1271 *wl, s8 *ver)
 {
 	u32 fuse;
+	int ret;
 
 	wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
 
-	fuse = wl1271_read32(wl, WL18XX_REG_FUSE_DATA_1_3);
-	fuse = (fuse & WL18XX_PG_VER_MASK) >> WL18XX_PG_VER_OFFSET;
+	ret = wlcore_read32(wl, WL18XX_REG_FUSE_DATA_1_3, &fuse);
+	if (ret < 0)
+		goto out;
+
+	if (ver)
+		*ver = (fuse & WL18XX_PG_VER_MASK) >> WL18XX_PG_VER_OFFSET;
 
 	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
 
-	return (s8)fuse;
+out:
+	return ret;
 }
 
 #define WL18XX_CONF_FILE_NAME "ti-connectivity/wl18xx-conf.bin"
@@ -1080,14 +1121,20 @@ static int wl18xx_plt_init(struct wl1271 *wl)
 	return wl->ops->boot(wl);
 }
 
-static void wl18xx_get_mac(struct wl1271 *wl)
+static int wl18xx_get_mac(struct wl1271 *wl)
 {
 	u32 mac1, mac2;
+	int ret;
 
 	wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
 
-	mac1 = wl1271_read32(wl, WL18XX_REG_FUSE_BD_ADDR_1);
-	mac2 = wl1271_read32(wl, WL18XX_REG_FUSE_BD_ADDR_2);
+	ret = wlcore_read32(wl, WL18XX_REG_FUSE_BD_ADDR_1, &mac1);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_read32(wl, WL18XX_REG_FUSE_BD_ADDR_2, &mac2);
+	if (ret < 0)
+		goto out;
 
 	/* these are the two parts of the BD_ADDR */
 	wl->fuse_oui_addr = ((mac2 & 0xffff) << 8) +
@@ -1095,6 +1142,9 @@ static void wl18xx_get_mac(struct wl1271 *wl)
 	wl->fuse_nic_addr = (mac1 & 0xffffff);
 
 	wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
+
+out:
+	return ret;
 }
 
 static int wl18xx_handle_static_data(struct wl1271 *wl,
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index ee7a401..0aa0e29 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -33,16 +33,22 @@
 #include "rx.h"
 #include "hw_ops.h"
 
-static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
+static int wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 {
 	u32 cpu_ctrl;
+	int ret;
 
 	/* 10.5.0 run the firmware (I) */
-	cpu_ctrl = wlcore_read_reg(wl, REG_ECPU_CONTROL);
+	ret = wlcore_read_reg(wl, REG_ECPU_CONTROL, &cpu_ctrl);
+	if (ret < 0)
+		goto out;
 
 	/* 10.5.1 run the firmware (II) */
 	cpu_ctrl |= flag;
 	wlcore_write_reg(wl, REG_ECPU_CONTROL, cpu_ctrl);
+
+out:
+	return ret;
 }
 
 static int wlcore_boot_parse_fw_ver(struct wl1271 *wl,
@@ -368,9 +374,13 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 	/* Make sure we have the boot partition */
 	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
 
-	wl1271_boot_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
+	ret = wl1271_boot_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
+	if (ret < 0)
+		return ret;
 
-	chip_id = wlcore_read_reg(wl, REG_CHIP_ID_B);
+	ret = wlcore_read_reg(wl, REG_CHIP_ID_B, &chip_id);
+	if (ret < 0)
+		return ret;
 
 	wl1271_debug(DEBUG_BOOT, "chip id after firmware boot: 0x%x", chip_id);
 
@@ -383,7 +393,9 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 	loop = 0;
 	while (loop++ < INIT_LOOP) {
 		udelay(INIT_LOOP_DELAY);
-		intr = wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR);
+		ret = wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR, &intr);
+		if (ret < 0)
+			return ret;
 
 		if (intr == 0xffffffff) {
 			wl1271_error("error reading hardware complete "
@@ -405,12 +417,17 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 	}
 
 	/* get hardware config command mail box */
-	wl->cmd_box_addr = wlcore_read_reg(wl, REG_COMMAND_MAILBOX_PTR);
+	ret = wlcore_read_reg(wl, REG_COMMAND_MAILBOX_PTR, &wl->cmd_box_addr);
+	if (ret < 0)
+		return ret;
 
 	wl1271_debug(DEBUG_MAILBOX, "cmd_box_addr 0x%x", wl->cmd_box_addr);
 
 	/* get hardware config event mail box */
-	wl->mbox_ptr[0] = wlcore_read_reg(wl, REG_EVENT_MAILBOX_PTR);
+	ret = wlcore_read_reg(wl, REG_EVENT_MAILBOX_PTR, &wl->mbox_ptr[0]);
+	if (ret < 0)
+		return ret;
+
 	wl->mbox_ptr[1] = wl->mbox_ptr[0] + sizeof(struct event_mailbox);
 
 	wl1271_debug(DEBUG_MAILBOX, "MBOX ptrs: 0x%x 0x%x",
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 658dccb..f2ac982 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -79,7 +79,10 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 
 	timeout = jiffies + msecs_to_jiffies(WL1271_COMMAND_TIMEOUT);
 
-	intr = wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR);
+	ret = wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR, &intr);
+	if (ret < 0)
+		goto fail;
+
 	while (!(intr & WL1271_ACX_INTR_CMD_COMPLETE)) {
 		if (time_after(jiffies, timeout)) {
 			wl1271_error("command complete timeout");
@@ -93,7 +96,9 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		else
 			msleep(1);
 
-		intr = wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR);
+		ret = wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR, &intr);
+		if (ret < 0)
+			goto fail;
 	}
 
 	/* read back the status code of the command */
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 2cbf762..0395b03 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -77,12 +77,19 @@ static inline int wlcore_raw_write_data(struct wl1271 *wl, int reg, void *buf,
 	return wlcore_raw_write(wl, wl->rtable[reg], buf, len, fixed);
 }
 
-static inline u32 wl1271_raw_read32(struct wl1271 *wl, int addr)
+static inline int wlcore_raw_read32(struct wl1271 *wl, int addr, u32 *val)
 {
-	wlcore_raw_read(wl, addr, &wl->buffer_32,
-			    sizeof(wl->buffer_32), false);
+	int ret;
+
+	ret = wlcore_raw_read(wl, addr, &wl->buffer_32,
+			      sizeof(wl->buffer_32), false);
+	if (ret < 0)
+		return ret;
+
+	if (val)
+		*val = le32_to_cpu(wl->buffer_32);
 
-	return le32_to_cpu(wl->buffer_32);
+	return 0;
 }
 
 static inline void wl1271_raw_write32(struct wl1271 *wl, int addr, u32 val)
@@ -138,9 +145,9 @@ static inline void wl1271_read_hwaddr(struct wl1271 *wl, int hwaddr,
 	wlcore_raw_read(wl, physical, buf, len, fixed);
 }
 
-static inline u32 wl1271_read32(struct wl1271 *wl, int addr)
+static inline int wlcore_read32(struct wl1271 *wl, int addr, u32 *val)
 {
-	return wl1271_raw_read32(wl, wlcore_translate_addr(wl, addr));
+	return wlcore_raw_read32(wl, wlcore_translate_addr(wl, addr), val);
 }
 
 static inline void wl1271_write32(struct wl1271 *wl, int addr, u32 val)
@@ -148,10 +155,11 @@ static inline void wl1271_write32(struct wl1271 *wl, int addr, u32 val)
 	wl1271_raw_write32(wl, wlcore_translate_addr(wl, addr), val);
 }
 
-static inline u32 wlcore_read_reg(struct wl1271 *wl, int reg)
+static inline int wlcore_read_reg(struct wl1271 *wl, int reg, u32 *val)
 {
-	return wl1271_raw_read32(wl,
-				 wlcore_translate_addr(wl, wl->rtable[reg]));
+	return wlcore_raw_read32(wl,
+				 wlcore_translate_addr(wl, wl->rtable[reg]),
+				 val);
 }
 
 static inline void wlcore_write_reg(struct wl1271 *wl, int reg, u32 val)
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 0461d4e..c16d266 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -872,6 +872,32 @@ out:
 	kfree(block);
 }
 
+static void wlcore_print_recovery(struct wl1271 *wl)
+{
+	u32 pc = 0;
+	u32 hint_sts = 0;
+	int ret;
+
+	wl1271_info("Hardware recovery in progress. FW ver: %s",
+		    wl->chip.fw_ver_str);
+
+	/* change partitions momentarily so we can read the FW pc */
+	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+
+	ret = wlcore_read_reg(wl, REG_PC_ON_RECOVERY, &pc);
+	if (ret < 0)
+		return;
+
+	ret = wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR, &hint_sts);
+	if (ret < 0)
+		return;
+
+	wl1271_info("pc: 0x%x, hint_sts: 0x%08x", pc, hint_sts);
+
+	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
+}
+
+
 static void wl1271_recovery_work(struct work_struct *work)
 {
 	struct wl1271 *wl =
@@ -886,14 +912,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 
 	wl12xx_read_fwlog_panic(wl);
 
-	/* change partitions momentarily so we can read the FW pc */
-	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
-	wl1271_info("Hardware recovery in progress. FW ver: %s pc: 0x%x "
-		    "hint_sts: 0x%08x",
-		    wl->chip.fw_ver_str,
-		    wlcore_read_reg(wl, REG_PC_ON_RECOVERY),
-		    wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR));
-	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
+	wlcore_print_recovery(wl);
 
 	BUG_ON(bug_on_recovery &&
 	       !test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags));
@@ -4979,18 +4998,22 @@ static int wl12xx_get_hw_info(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	wl->chip.id = wlcore_read_reg(wl, REG_CHIP_ID_B);
+	ret = wlcore_read_reg(wl, REG_CHIP_ID_B, &wl->chip.id);
+	if (ret < 0)
+		goto out;
 
 	wl->fuse_oui_addr = 0;
 	wl->fuse_nic_addr = 0;
 
-	wl->hw_pg_ver = wl->ops->get_pg_ver(wl);
+	ret = wl->ops->get_pg_ver(wl, &wl->hw_pg_ver);
+	if (ret < 0)
+		goto out;
 
 	if (wl->ops->get_mac)
-		wl->ops->get_mac(wl);
+		ret = wl->ops->get_mac(wl);
 
-	wl1271_power_off(wl);
 out:
+	wl1271_power_off(wl);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 5d51647..2fb5374 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -62,8 +62,8 @@ struct wlcore_ops {
 	int (*init_vif)(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 	u32 (*sta_get_ap_rate_mask)(struct wl1271 *wl,
 				    struct wl12xx_vif *wlvif);
-	s8 (*get_pg_ver)(struct wl1271 *wl);
-	void (*get_mac)(struct wl1271 *wl);
+	int (*get_pg_ver)(struct wl1271 *wl, s8 *ver);
+	int (*get_mac)(struct wl1271 *wl);
 	void (*set_tx_desc_csum)(struct wl1271 *wl,
 				 struct wl1271_tx_hw_descr *desc,
 				 struct sk_buff *skb);
-- 
1.7.10

