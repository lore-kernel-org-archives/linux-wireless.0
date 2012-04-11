Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:60510 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754467Ab2DKJi1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:27 -0400
Received: by lagz14 with SMTP id z14so717489lag.14
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:24 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 10/16] wlcore/wl12xx: move top initialization to wl12xx
Date: Wed, 11 Apr 2012 12:37:57 +0300
Message-Id: <1334137083-13490-11-git-send-email-coelho@ti.com> (sfid-20120411_113836_161753_F8DF960C)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The top registers initialization is very specific to the actual
hardware used, even the way in which we read from and write to the top
registers varies from chip to chip.  This patch moves all top
registers initialization to wl12xx.  Also add a boot op for the wlcore
module to call at the right time and a few callbacks with the common
called to be called from the lower drivers boot operations.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |  399 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ti/wl12xx/reg.h    |   10 -
 drivers/net/wireless/ti/wlcore/boot.c   |  370 +----------------------------
 drivers/net/wireless/ti/wlcore/boot.h   |    5 +-
 drivers/net/wireless/ti/wlcore/io.c     |   57 +----
 drivers/net/wireless/ti/wlcore/io.h     |    9 +-
 drivers/net/wireless/ti/wlcore/main.c   |   22 +-
 drivers/net/wireless/ti/wlcore/wlcore.h |    1 +
 8 files changed, 425 insertions(+), 448 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 880615f..d235da2 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -24,9 +24,13 @@
 
 #include <linux/err.h>
 
+#include <linux/wl12xx.h>
+
 #include "../wlcore/wlcore.h"
 #include "../wlcore/debug.h"
 #include "../wlcore/io.h"
+#include "../wlcore/acx.h"
+#include "../wlcore/boot.h"
 
 #include "reg.h"
 
@@ -181,21 +185,408 @@ out:
 	return ret;
 }
 
+static void wl12xx_top_reg_write(struct wl1271 *wl, int addr, u16 val)
+{
+	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
+	addr = (addr >> 1) + 0x30000;
+	wl1271_write32(wl, WL12XX_OCP_POR_CTR, addr);
+
+	/* write value to OCP_POR_WDATA */
+	wl1271_write32(wl, WL12XX_OCP_DATA_WRITE, val);
+
+	/* write 1 to OCP_CMD */
+	wl1271_write32(wl, WL12XX_OCP_CMD, OCP_CMD_WRITE);
+}
+
+static u16 wl12xx_top_reg_read(struct wl1271 *wl, int addr)
+{
+	u32 val;
+	int timeout = OCP_CMD_LOOP;
+
+	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
+	addr = (addr >> 1) + 0x30000;
+	wl1271_write32(wl, WL12XX_OCP_POR_CTR, addr);
+
+	/* write 2 to OCP_CMD */
+	wl1271_write32(wl, WL12XX_OCP_CMD, OCP_CMD_READ);
+
+	/* poll for data ready */
+	do {
+		val = wl1271_read32(wl, WL12XX_OCP_DATA_READ);
+	} while (!(val & OCP_READY_MASK) && --timeout);
+
+	if (!timeout) {
+		wl1271_warning("Top register access timed out.");
+		return 0xffff;
+	}
+
+	/* check data status and return if OK */
+	if ((val & OCP_STATUS_MASK) == OCP_STATUS_OK)
+		return val & 0xffff;
+	else {
+		wl1271_warning("Top register access returned error.");
+		return 0xffff;
+	}
+}
+
+static int wl128x_switch_tcxo_to_fref(struct wl1271 *wl)
+{
+	u16 spare_reg;
+
+	/* Mask bits [2] & [8:4] in the sys_clk_cfg register */
+	spare_reg = wl12xx_top_reg_read(wl, WL_SPARE_REG);
+	if (spare_reg == 0xFFFF)
+		return -EFAULT;
+	spare_reg |= (BIT(3) | BIT(5) | BIT(6));
+	wl12xx_top_reg_write(wl, WL_SPARE_REG, spare_reg);
+
+	/* Enable FREF_CLK_REQ & mux MCS and coex PLLs to FREF */
+	wl12xx_top_reg_write(wl, SYS_CLK_CFG_REG,
+			     WL_CLK_REQ_TYPE_PG2 | MCS_PLL_CLK_SEL_FREF);
+
+	/* Delay execution for 15msec, to let the HW settle */
+	mdelay(15);
+
+	return 0;
+}
+
+static bool wl128x_is_tcxo_valid(struct wl1271 *wl)
+{
+	u16 tcxo_detection;
+
+	tcxo_detection = wl12xx_top_reg_read(wl, TCXO_CLK_DETECT_REG);
+	if (tcxo_detection & TCXO_DET_FAILED)
+		return false;
+
+	return true;
+}
+
+static bool wl128x_is_fref_valid(struct wl1271 *wl)
+{
+	u16 fref_detection;
+
+	fref_detection = wl12xx_top_reg_read(wl, FREF_CLK_DETECT_REG);
+	if (fref_detection & FREF_CLK_DETECT_FAIL)
+		return false;
+
+	return true;
+}
+
+static int wl128x_manually_configure_mcs_pll(struct wl1271 *wl)
+{
+	wl12xx_top_reg_write(wl, MCS_PLL_M_REG, MCS_PLL_M_REG_VAL);
+	wl12xx_top_reg_write(wl, MCS_PLL_N_REG, MCS_PLL_N_REG_VAL);
+	wl12xx_top_reg_write(wl, MCS_PLL_CONFIG_REG, MCS_PLL_CONFIG_REG_VAL);
+
+	return 0;
+}
+
+static int wl128x_configure_mcs_pll(struct wl1271 *wl, int clk)
+{
+	u16 spare_reg;
+	u16 pll_config;
+	u8 input_freq;
+
+	/* Mask bits [3:1] in the sys_clk_cfg register */
+	spare_reg = wl12xx_top_reg_read(wl, WL_SPARE_REG);
+	if (spare_reg == 0xFFFF)
+		return -EFAULT;
+	spare_reg |= BIT(2);
+	wl12xx_top_reg_write(wl, WL_SPARE_REG, spare_reg);
+
+	/* Handle special cases of the TCXO clock */
+	if (wl->tcxo_clock == WL12XX_TCXOCLOCK_16_8 ||
+	    wl->tcxo_clock == WL12XX_TCXOCLOCK_33_6)
+		return wl128x_manually_configure_mcs_pll(wl);
+
+	/* Set the input frequency according to the selected clock source */
+	input_freq = (clk & 1) + 1;
+
+	pll_config = wl12xx_top_reg_read(wl, MCS_PLL_CONFIG_REG);
+	if (pll_config == 0xFFFF)
+		return -EFAULT;
+	pll_config |= (input_freq << MCS_SEL_IN_FREQ_SHIFT);
+	pll_config |= MCS_PLL_ENABLE_HP;
+	wl12xx_top_reg_write(wl, MCS_PLL_CONFIG_REG, pll_config);
+
+	return 0;
+}
+
+/*
+ * WL128x has two clocks input - TCXO and FREF.
+ * TCXO is the main clock of the device, while FREF is used to sync
+ * between the GPS and the cellular modem.
+ * In cases where TCXO is 32.736MHz or 16.368MHz, the FREF will be used
+ * as the WLAN/BT main clock.
+ */
+static int wl128x_boot_clk(struct wl1271 *wl, int *selected_clock)
+{
+	u16 sys_clk_cfg;
+
+	/* For XTAL-only modes, FREF will be used after switching from TCXO */
+	if (wl->ref_clock == WL12XX_REFCLOCK_26_XTAL ||
+	    wl->ref_clock == WL12XX_REFCLOCK_38_XTAL) {
+		if (!wl128x_switch_tcxo_to_fref(wl))
+			return -EINVAL;
+		goto fref_clk;
+	}
+
+	/* Query the HW, to determine which clock source we should use */
+	sys_clk_cfg = wl12xx_top_reg_read(wl, SYS_CLK_CFG_REG);
+	if (sys_clk_cfg == 0xFFFF)
+		return -EINVAL;
+	if (sys_clk_cfg & PRCM_CM_EN_MUX_WLAN_FREF)
+		goto fref_clk;
+
+	/* If TCXO is either 32.736MHz or 16.368MHz, switch to FREF */
+	if (wl->tcxo_clock == WL12XX_TCXOCLOCK_16_368 ||
+	    wl->tcxo_clock == WL12XX_TCXOCLOCK_32_736) {
+		if (!wl128x_switch_tcxo_to_fref(wl))
+			return -EINVAL;
+		goto fref_clk;
+	}
+
+	/* TCXO clock is selected */
+	if (!wl128x_is_tcxo_valid(wl))
+		return -EINVAL;
+	*selected_clock = wl->tcxo_clock;
+	goto config_mcs_pll;
+
+fref_clk:
+	/* FREF clock is selected */
+	if (!wl128x_is_fref_valid(wl))
+		return -EINVAL;
+	*selected_clock = wl->ref_clock;
+
+config_mcs_pll:
+	return wl128x_configure_mcs_pll(wl, *selected_clock);
+}
+
+static int wl127x_boot_clk(struct wl1271 *wl)
+{
+	u32 pause;
+	u32 clk;
+
+	if (WL127X_PG_GET_MAJOR(wl->hw_pg_ver) < 3)
+		wl->quirks |= WLCORE_QUIRK_END_OF_TRANSACTION;
+
+	if (wl->ref_clock == CONF_REF_CLK_19_2_E ||
+	    wl->ref_clock == CONF_REF_CLK_38_4_E ||
+	    wl->ref_clock == CONF_REF_CLK_38_4_M_XTAL)
+		/* ref clk: 19.2/38.4/38.4-XTAL */
+		clk = 0x3;
+	else if (wl->ref_clock == CONF_REF_CLK_26_E ||
+		 wl->ref_clock == CONF_REF_CLK_52_E)
+		/* ref clk: 26/52 */
+		clk = 0x5;
+	else
+		return -EINVAL;
+
+	if (wl->ref_clock != CONF_REF_CLK_19_2_E) {
+		u16 val;
+		/* Set clock type (open drain) */
+		val = wl12xx_top_reg_read(wl, OCP_REG_CLK_TYPE);
+		val &= FREF_CLK_TYPE_BITS;
+		wl12xx_top_reg_write(wl, OCP_REG_CLK_TYPE, val);
+
+		/* Set clock pull mode (no pull) */
+		val = wl12xx_top_reg_read(wl, OCP_REG_CLK_PULL);
+		val |= NO_PULL;
+		wl12xx_top_reg_write(wl, OCP_REG_CLK_PULL, val);
+	} else {
+		u16 val;
+		/* Set clock polarity */
+		val = wl12xx_top_reg_read(wl, OCP_REG_CLK_POLARITY);
+		val &= FREF_CLK_POLARITY_BITS;
+		val |= CLK_REQ_OUTN_SEL;
+		wl12xx_top_reg_write(wl, OCP_REG_CLK_POLARITY, val);
+	}
+
+	wl1271_write32(wl, WL12XX_PLL_PARAMETERS, clk);
+
+	pause = wl1271_read32(wl, WL12XX_PLL_PARAMETERS);
+
+	wl1271_debug(DEBUG_BOOT, "pause1 0x%x", pause);
+
+	pause &= ~(WU_COUNTER_PAUSE_VAL);
+	pause |= WU_COUNTER_PAUSE_VAL;
+	wl1271_write32(wl, WL12XX_WU_COUNTER_PAUSE, pause);
+
+	return 0;
+}
+
+static int wl1271_boot_soft_reset(struct wl1271 *wl)
+{
+	unsigned long timeout;
+	u32 boot_data;
+
+	/* perform soft reset */
+	wl1271_write32(wl, WL12XX_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
+
+	/* SOFT_RESET is self clearing */
+	timeout = jiffies + usecs_to_jiffies(SOFT_RESET_MAX_TIME);
+	while (1) {
+		boot_data = wl1271_read32(wl, WL12XX_SLV_SOFT_RESET);
+		wl1271_debug(DEBUG_BOOT, "soft reset bootdata 0x%x", boot_data);
+		if ((boot_data & ACX_SLV_SOFT_RESET_BIT) == 0)
+			break;
+
+		if (time_after(jiffies, timeout)) {
+			/* 1.2 check pWhalBus->uSelfClearTime if the
+			 * timeout was reached */
+			wl1271_error("soft reset timeout");
+			return -1;
+		}
+
+		udelay(SOFT_RESET_STALL_TIME);
+	}
+
+	/* disable Rx/Tx */
+	wl1271_write32(wl, WL12XX_ENABLE, 0x0);
+
+	/* disable auto calibration on start*/
+	wl1271_write32(wl, WL12XX_SPARE_A2, 0xffff);
+
+	return 0;
+}
+
+static int wl12xx_pre_boot(struct wl1271 *wl)
+{
+	int ret = 0;
+	u32 clk;
+	int selected_clock = -1;
+
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		ret = wl128x_boot_clk(wl, &selected_clock);
+		if (ret < 0)
+			goto out;
+	} else {
+		ret = wl127x_boot_clk(wl);
+		if (ret < 0)
+			goto out;
+	}
+
+	/* Continue the ELP wake up sequence */
+	wl1271_write32(wl, WL12XX_WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
+	udelay(500);
+
+	wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
+
+	/* Read-modify-write DRPW_SCRATCH_START register (see next state)
+	   to be used by DRPw FW. The RTRIM value will be added by the FW
+	   before taking DRPw out of reset */
+
+	clk = wl1271_read32(wl, WL12XX_DRPW_SCRATCH_START);
+
+	wl1271_debug(DEBUG_BOOT, "clk2 0x%x", clk);
+
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		clk |= ((selected_clock & 0x3) << 1) << 4;
+	else
+		clk |= (wl->ref_clock << 1) << 4;
+
+	wl1271_write32(wl, WL12XX_DRPW_SCRATCH_START, clk);
+
+	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
+
+	/* Disable interrupts */
+	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
+
+	ret = wl1271_boot_soft_reset(wl);
+	if (ret < 0)
+		goto out;
+
+out:
+	return ret;
+}
+
+static void wl12xx_pre_upload(struct wl1271 *wl)
+{
+	u32 tmp;
+
+	/* write firmware's last address (ie. it's length) to
+	 * ACX_EEPROMLESS_IND_REG */
+	wl1271_debug(DEBUG_BOOT, "ACX_EEPROMLESS_IND_REG");
+
+	wl1271_write32(wl, WL12XX_EEPROMLESS_IND, WL12XX_EEPROMLESS_IND);
+
+	tmp = wlcore_read_reg(wl, REG_CHIP_ID_B);
+
+	wl1271_debug(DEBUG_BOOT, "chip id 0x%x", tmp);
+
+	/* 6. read the EEPROM parameters */
+	tmp = wl1271_read32(wl, WL12XX_SCR_PAD2);
+
+	/* WL1271: The reference driver skips steps 7 to 10 (jumps directly
+	 * to upload_fw) */
+
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		wl12xx_top_reg_write(wl, SDIO_IO_DS, HCI_IO_DS_6MA);
+}
+
+static void wl12xx_enable_interrupts(struct wl1271 *wl)
+{
+	u32 polarity;
+
+	polarity = wl12xx_top_reg_read(wl, OCP_REG_POLARITY);
+
+	/* We use HIGH polarity, so unset the LOW bit */
+	polarity &= ~POLARITY_LOW;
+	wl12xx_top_reg_write(wl, OCP_REG_POLARITY, polarity);
+
+	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_ALL_EVENTS_VECTOR);
+
+	wlcore_enable_interrupts(wl);
+	wlcore_write_reg(wl, REG_INTERRUPT_MASK,
+			 WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
+
+	wl1271_write32(wl, WL12XX_HI_CFG, HI_CFG_DEF_VAL);
+}
+
+static int wl12xx_boot(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl12xx_pre_boot(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_boot_upload_nvs(wl);
+	if (ret < 0)
+		goto out;
+
+	wl12xx_pre_upload(wl);
+
+	ret = wlcore_boot_upload_firmware(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_boot_run_firmware(wl);
+	if (ret < 0)
+		goto out;
+
+	wl12xx_enable_interrupts(wl);
+
+out:
+	return ret;
+}
+
 static s8 wl12xx_get_pg_ver(struct wl1271 *wl)
 {
 	u32 die_info;
 
 	if (wl->chip.id == CHIP_ID_1283_PG20)
-		die_info = wl1271_top_reg_read(wl, WL128X_REG_FUSE_DATA_2_1);
+		die_info = wl12xx_top_reg_read(wl, WL128X_REG_FUSE_DATA_2_1);
 	else
-		die_info = wl1271_top_reg_read(wl, WL127X_REG_FUSE_DATA_2_1);
+		die_info = wl12xx_top_reg_read(wl, WL127X_REG_FUSE_DATA_2_1);
 
 	return (s8) (die_info & PG_VER_MASK) >> PG_VER_OFFSET;
 }
 
 static struct wlcore_ops wl12xx_ops = {
-	.identify_chip = wl12xx_identify_chip,
-	.get_pg_ver     = wl12xx_get_pg_ver,
+	.identify_chip	= wl12xx_identify_chip,
+	.boot		= wl12xx_boot,
+	.get_pg_ver	= wl12xx_get_pg_ver,
 };
 
 static int __devinit wl12xx_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/ti/wl12xx/reg.h b/drivers/net/wireless/ti/wl12xx/reg.h
index 52012ca..003041b 100644
--- a/drivers/net/wireless/ti/wl12xx/reg.h
+++ b/drivers/net/wireless/ti/wl12xx/reg.h
@@ -428,16 +428,6 @@ b12-b0 - Supported Rate indicator bits as defined below.
 #define OCP_REG_CLK_POLARITY 0x0cb2
 #define OCP_REG_CLK_PULL     0x0cb4
 
-#define WL127X_REG_FUSE_DATA_2_1    0x050a
-#define WL128X_REG_FUSE_DATA_2_1    0x2152
-#define PG_VER_MASK          0x3c
-#define PG_VER_OFFSET        2
-
-#define PG_MAJOR_VER_MASK    0x3
-#define PG_MAJOR_VER_OFFSET  0x0
-#define PG_MINOR_VER_MASK    0xc
-#define PG_MINOR_VER_OFFSET  0x2
-
 #define POLARITY_LOW         BIT(1)
 #define NO_PULL              (BIT(14) | BIT(15))
 
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 7c72e16..7d49870 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -32,12 +32,6 @@
 #include "event.h"
 #include "rx.h"
 
-/*
- * TODO: this is here just for now, it will be removed when we move
- * the top_reg stuff to wl12xx
- */
-#include "../wl12xx/reg.h"
-
 static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 {
 	u32 cpu_ctrl;
@@ -177,7 +171,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 	return 0;
 }
 
-static int wl1271_boot_upload_firmware(struct wl1271 *wl)
+int wlcore_boot_upload_firmware(struct wl1271 *wl)
 {
 	u32 chunks, addr, len;
 	int ret = 0;
@@ -209,8 +203,9 @@ static int wl1271_boot_upload_firmware(struct wl1271 *wl)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(wlcore_boot_upload_firmware);
 
-static int wl1271_boot_upload_nvs(struct wl1271 *wl)
+int wlcore_boot_upload_nvs(struct wl1271 *wl)
 {
 	size_t nvs_len, burst_len;
 	int i;
@@ -356,55 +351,16 @@ out_badnvs:
 	wl1271_error("nvs data is malformed");
 	return -EILSEQ;
 }
+EXPORT_SYMBOL_GPL(wlcore_boot_upload_nvs);
 
-static void wl1271_boot_enable_interrupts(struct wl1271 *wl)
-{
-	wl1271_enable_interrupts(wl);
-	wlcore_write_reg(wl, REG_INTERRUPT_MASK,
-			 WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
-	wl1271_write32(wl, WL12XX_HI_CFG, HI_CFG_DEF_VAL);
-}
-
-static int wl1271_boot_soft_reset(struct wl1271 *wl)
-{
-	unsigned long timeout;
-	u32 boot_data;
-
-	/* perform soft reset */
-	wl1271_write32(wl, WL12XX_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
-
-	/* SOFT_RESET is self clearing */
-	timeout = jiffies + usecs_to_jiffies(SOFT_RESET_MAX_TIME);
-	while (1) {
-		boot_data = wl1271_read32(wl, WL12XX_SLV_SOFT_RESET);
-		wl1271_debug(DEBUG_BOOT, "soft reset bootdata 0x%x", boot_data);
-		if ((boot_data & ACX_SLV_SOFT_RESET_BIT) == 0)
-			break;
-
-		if (time_after(jiffies, timeout)) {
-			/* 1.2 check pWhalBus->uSelfClearTime if the
-			 * timeout was reached */
-			wl1271_error("soft reset timeout");
-			return -1;
-		}
-
-		udelay(SOFT_RESET_STALL_TIME);
-	}
-
-	/* disable Rx/Tx */
-	wl1271_write32(wl, WL12XX_ENABLE, 0x0);
-
-	/* disable auto calibration on start*/
-	wl1271_write32(wl, WL12XX_SPARE_A2, 0xffff);
-
-	return 0;
-}
-
-static int wl1271_boot_run_firmware(struct wl1271 *wl)
+int wlcore_boot_run_firmware(struct wl1271 *wl)
 {
 	int loop, ret;
 	u32 chip_id, intr;
 
+	/* Make sure we have the boot partition */
+	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+
 	wl1271_boot_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
 
 	chip_id = wlcore_read_reg(wl, REG_CHIP_ID_B);
@@ -488,312 +444,4 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	/* firmware startup completed */
 	return 0;
 }
-
-static int wl1271_boot_write_irq_polarity(struct wl1271 *wl)
-{
-	u32 polarity;
-
-	polarity = wl1271_top_reg_read(wl, OCP_REG_POLARITY);
-
-	/* We use HIGH polarity, so unset the LOW bit */
-	polarity &= ~POLARITY_LOW;
-	wl1271_top_reg_write(wl, OCP_REG_POLARITY, polarity);
-
-	return 0;
-}
-
-static int wl128x_switch_tcxo_to_fref(struct wl1271 *wl)
-{
-	u16 spare_reg;
-
-	/* Mask bits [2] & [8:4] in the sys_clk_cfg register */
-	spare_reg = wl1271_top_reg_read(wl, WL_SPARE_REG);
-	if (spare_reg == 0xFFFF)
-		return -EFAULT;
-	spare_reg |= (BIT(3) | BIT(5) | BIT(6));
-	wl1271_top_reg_write(wl, WL_SPARE_REG, spare_reg);
-
-	/* Enable FREF_CLK_REQ & mux MCS and coex PLLs to FREF */
-	wl1271_top_reg_write(wl, SYS_CLK_CFG_REG,
-			     WL_CLK_REQ_TYPE_PG2 | MCS_PLL_CLK_SEL_FREF);
-
-	/* Delay execution for 15msec, to let the HW settle */
-	mdelay(15);
-
-	return 0;
-}
-
-static bool wl128x_is_tcxo_valid(struct wl1271 *wl)
-{
-	u16 tcxo_detection;
-
-	tcxo_detection = wl1271_top_reg_read(wl, TCXO_CLK_DETECT_REG);
-	if (tcxo_detection & TCXO_DET_FAILED)
-		return false;
-
-	return true;
-}
-
-static bool wl128x_is_fref_valid(struct wl1271 *wl)
-{
-	u16 fref_detection;
-
-	fref_detection = wl1271_top_reg_read(wl, FREF_CLK_DETECT_REG);
-	if (fref_detection & FREF_CLK_DETECT_FAIL)
-		return false;
-
-	return true;
-}
-
-static int wl128x_manually_configure_mcs_pll(struct wl1271 *wl)
-{
-	wl1271_top_reg_write(wl, MCS_PLL_M_REG, MCS_PLL_M_REG_VAL);
-	wl1271_top_reg_write(wl, MCS_PLL_N_REG, MCS_PLL_N_REG_VAL);
-	wl1271_top_reg_write(wl, MCS_PLL_CONFIG_REG, MCS_PLL_CONFIG_REG_VAL);
-
-	return 0;
-}
-
-static int wl128x_configure_mcs_pll(struct wl1271 *wl, int clk)
-{
-	u16 spare_reg;
-	u16 pll_config;
-	u8 input_freq;
-
-	/* Mask bits [3:1] in the sys_clk_cfg register */
-	spare_reg = wl1271_top_reg_read(wl, WL_SPARE_REG);
-	if (spare_reg == 0xFFFF)
-		return -EFAULT;
-	spare_reg |= BIT(2);
-	wl1271_top_reg_write(wl, WL_SPARE_REG, spare_reg);
-
-	/* Handle special cases of the TCXO clock */
-	if (wl->tcxo_clock == WL12XX_TCXOCLOCK_16_8 ||
-	    wl->tcxo_clock == WL12XX_TCXOCLOCK_33_6)
-		return wl128x_manually_configure_mcs_pll(wl);
-
-	/* Set the input frequency according to the selected clock source */
-	input_freq = (clk & 1) + 1;
-
-	pll_config = wl1271_top_reg_read(wl, MCS_PLL_CONFIG_REG);
-	if (pll_config == 0xFFFF)
-		return -EFAULT;
-	pll_config |= (input_freq << MCS_SEL_IN_FREQ_SHIFT);
-	pll_config |= MCS_PLL_ENABLE_HP;
-	wl1271_top_reg_write(wl, MCS_PLL_CONFIG_REG, pll_config);
-
-	return 0;
-}
-
-/*
- * WL128x has two clocks input - TCXO and FREF.
- * TCXO is the main clock of the device, while FREF is used to sync
- * between the GPS and the cellular modem.
- * In cases where TCXO is 32.736MHz or 16.368MHz, the FREF will be used
- * as the WLAN/BT main clock.
- */
-static int wl128x_boot_clk(struct wl1271 *wl, int *selected_clock)
-{
-	u16 sys_clk_cfg;
-
-	/* For XTAL-only modes, FREF will be used after switching from TCXO */
-	if (wl->ref_clock == WL12XX_REFCLOCK_26_XTAL ||
-	    wl->ref_clock == WL12XX_REFCLOCK_38_XTAL) {
-		if (!wl128x_switch_tcxo_to_fref(wl))
-			return -EINVAL;
-		goto fref_clk;
-	}
-
-	/* Query the HW, to determine which clock source we should use */
-	sys_clk_cfg = wl1271_top_reg_read(wl, SYS_CLK_CFG_REG);
-	if (sys_clk_cfg == 0xFFFF)
-		return -EINVAL;
-	if (sys_clk_cfg & PRCM_CM_EN_MUX_WLAN_FREF)
-		goto fref_clk;
-
-	/* If TCXO is either 32.736MHz or 16.368MHz, switch to FREF */
-	if (wl->tcxo_clock == WL12XX_TCXOCLOCK_16_368 ||
-	    wl->tcxo_clock == WL12XX_TCXOCLOCK_32_736) {
-		if (!wl128x_switch_tcxo_to_fref(wl))
-			return -EINVAL;
-		goto fref_clk;
-	}
-
-	/* TCXO clock is selected */
-	if (!wl128x_is_tcxo_valid(wl))
-		return -EINVAL;
-	*selected_clock = wl->tcxo_clock;
-	goto config_mcs_pll;
-
-fref_clk:
-	/* FREF clock is selected */
-	if (!wl128x_is_fref_valid(wl))
-		return -EINVAL;
-	*selected_clock = wl->ref_clock;
-
-config_mcs_pll:
-	return wl128x_configure_mcs_pll(wl, *selected_clock);
-}
-
-static int wl127x_boot_clk(struct wl1271 *wl)
-{
-	u32 pause;
-	u32 clk;
-
-	if (WL127X_PG_GET_MAJOR(wl->hw_pg_ver) < 3)
-		wl->quirks |= WLCORE_QUIRK_END_OF_TRANSACTION;
-
-	if (wl->ref_clock == CONF_REF_CLK_19_2_E ||
-	    wl->ref_clock == CONF_REF_CLK_38_4_E ||
-	    wl->ref_clock == CONF_REF_CLK_38_4_M_XTAL)
-		/* ref clk: 19.2/38.4/38.4-XTAL */
-		clk = 0x3;
-	else if (wl->ref_clock == CONF_REF_CLK_26_E ||
-		 wl->ref_clock == CONF_REF_CLK_52_E)
-		/* ref clk: 26/52 */
-		clk = 0x5;
-	else
-		return -EINVAL;
-
-	if (wl->ref_clock != CONF_REF_CLK_19_2_E) {
-		u16 val;
-		/* Set clock type (open drain) */
-		val = wl1271_top_reg_read(wl, OCP_REG_CLK_TYPE);
-		val &= FREF_CLK_TYPE_BITS;
-		wl1271_top_reg_write(wl, OCP_REG_CLK_TYPE, val);
-
-		/* Set clock pull mode (no pull) */
-		val = wl1271_top_reg_read(wl, OCP_REG_CLK_PULL);
-		val |= NO_PULL;
-		wl1271_top_reg_write(wl, OCP_REG_CLK_PULL, val);
-	} else {
-		u16 val;
-		/* Set clock polarity */
-		val = wl1271_top_reg_read(wl, OCP_REG_CLK_POLARITY);
-		val &= FREF_CLK_POLARITY_BITS;
-		val |= CLK_REQ_OUTN_SEL;
-		wl1271_top_reg_write(wl, OCP_REG_CLK_POLARITY, val);
-	}
-
-	wl1271_write32(wl, WL12XX_PLL_PARAMETERS, clk);
-
-	pause = wl1271_read32(wl, WL12XX_PLL_PARAMETERS);
-
-	wl1271_debug(DEBUG_BOOT, "pause1 0x%x", pause);
-
-	pause &= ~(WU_COUNTER_PAUSE_VAL);
-	pause |= WU_COUNTER_PAUSE_VAL;
-	wl1271_write32(wl, WL12XX_WU_COUNTER_PAUSE, pause);
-
-	return 0;
-}
-
-/* uploads NVS and firmware */
-int wl1271_load_firmware(struct wl1271 *wl)
-{
-	int ret = 0;
-	u32 tmp, clk;
-	int selected_clock = -1;
-
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
-		ret = wl128x_boot_clk(wl, &selected_clock);
-		if (ret < 0)
-			goto out;
-	} else {
-		ret = wl127x_boot_clk(wl);
-		if (ret < 0)
-			goto out;
-	}
-
-	/* Continue the ELP wake up sequence */
-	wl1271_write32(wl, WL12XX_WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
-	udelay(500);
-
-	wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
-
-	/* Read-modify-write DRPW_SCRATCH_START register (see next state)
-	   to be used by DRPw FW. The RTRIM value will be added by the FW
-	   before taking DRPw out of reset */
-
-	clk = wl1271_read32(wl, WL12XX_DRPW_SCRATCH_START);
-
-	wl1271_debug(DEBUG_BOOT, "clk2 0x%x", clk);
-
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
-		clk |= ((selected_clock & 0x3) << 1) << 4;
-	} else {
-		clk |= (wl->ref_clock << 1) << 4;
-	}
-
-	wl1271_write32(wl, WL12XX_DRPW_SCRATCH_START, clk);
-
-	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
-
-	/* Disable interrupts */
-	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
-
-	ret = wl1271_boot_soft_reset(wl);
-	if (ret < 0)
-		goto out;
-
-	/* 2. start processing NVS file */
-	ret = wl1271_boot_upload_nvs(wl);
-	if (ret < 0)
-		goto out;
-
-	/* write firmware's last address (ie. it's length) to
-	 * ACX_EEPROMLESS_IND_REG */
-	wl1271_debug(DEBUG_BOOT, "ACX_EEPROMLESS_IND_REG");
-
-	wl1271_write32(wl, WL12XX_EEPROMLESS_IND, WL12XX_EEPROMLESS_IND);
-
-	tmp = wlcore_read_reg(wl, REG_CHIP_ID_B);
-
-	wl1271_debug(DEBUG_BOOT, "chip id 0x%x", tmp);
-
-	/* 6. read the EEPROM parameters */
-	tmp = wl1271_read32(wl, WL12XX_SCR_PAD2);
-
-	/* WL1271: The reference driver skips steps 7 to 10 (jumps directly
-	 * to upload_fw) */
-
-	if (wl->chip.id == CHIP_ID_1283_PG20)
-		wl1271_top_reg_write(wl, SDIO_IO_DS, HCI_IO_DS_6MA);
-
-	ret = wl1271_boot_upload_firmware(wl);
-	if (ret < 0)
-		goto out;
-
-out:
-	return ret;
-}
-EXPORT_SYMBOL_GPL(wl1271_load_firmware);
-
-int wl1271_boot(struct wl1271 *wl)
-{
-	int ret;
-
-	/* upload NVS and firmware */
-	ret = wl1271_load_firmware(wl);
-	if (ret)
-		return ret;
-
-	/* 10.5 start firmware */
-	ret = wl1271_boot_run_firmware(wl);
-	if (ret < 0)
-		goto out;
-
-	ret = wl1271_boot_write_irq_polarity(wl);
-	if (ret < 0)
-		goto out;
-
-	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_ALL_EVENTS_VECTOR);
-
-	/* Enable firmware interrupts now */
-	wl1271_boot_enable_interrupts(wl);
-
-	wl1271_event_mbox_config(wl);
-
-out:
-	return ret;
-}
+EXPORT_SYMBOL_GPL(wlcore_boot_run_firmware);
diff --git a/drivers/net/wireless/ti/wlcore/boot.h b/drivers/net/wireless/ti/wlcore/boot.h
index 842ae3f..094981d 100644
--- a/drivers/net/wireless/ti/wlcore/boot.h
+++ b/drivers/net/wireless/ti/wlcore/boot.h
@@ -26,8 +26,9 @@
 
 #include "wlcore.h"
 
-int wl1271_boot(struct wl1271 *wl);
-int wl1271_load_firmware(struct wl1271 *wl);
+int wlcore_boot_upload_firmware(struct wl1271 *wl);
+int wlcore_boot_upload_nvs(struct wl1271 *wl);
+int wlcore_boot_run_firmware(struct wl1271 *wl);
 
 #define WL1271_NO_SUBBANDS 8
 #define WL1271_NO_POWER_LEVELS 4
diff --git a/drivers/net/wireless/ti/wlcore/io.c b/drivers/net/wireless/ti/wlcore/io.c
index 08cfa39..7cd0081 100644
--- a/drivers/net/wireless/ti/wlcore/io.c
+++ b/drivers/net/wireless/ti/wlcore/io.c
@@ -32,12 +32,6 @@
 #include "io.h"
 #include "tx.h"
 
-/*
- * TODO: this is here just for now, it will be removed when we move
- * the top_reg stuff to wl12xx
- */
-#include "../wl12xx/reg.h"
-
 bool wl1271_set_block_size(struct wl1271 *wl)
 {
 	if (wl->if_ops->set_block_size) {
@@ -48,15 +42,17 @@ bool wl1271_set_block_size(struct wl1271 *wl)
 	return false;
 }
 
-void wl1271_disable_interrupts(struct wl1271 *wl)
+void wlcore_disable_interrupts(struct wl1271 *wl)
 {
 	disable_irq(wl->irq);
 }
+EXPORT_SYMBOL_GPL(wlcore_disable_interrupts);
 
-void wl1271_enable_interrupts(struct wl1271 *wl)
+void wlcore_enable_interrupts(struct wl1271 *wl)
 {
 	enable_irq(wl->irq);
 }
+EXPORT_SYMBOL_GPL(wlcore_enable_interrupts);
 
 int wlcore_translate_addr(struct wl1271 *wl, int addr)
 {
@@ -175,48 +171,3 @@ void wl1271_io_init(struct wl1271 *wl)
 	if (wl->if_ops->init)
 		wl->if_ops->init(wl->dev);
 }
-
-void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val)
-{
-	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
-	addr = (addr >> 1) + 0x30000;
-	wl1271_write32(wl, WL12XX_OCP_POR_CTR, addr);
-
-	/* write value to OCP_POR_WDATA */
-	wl1271_write32(wl, WL12XX_OCP_DATA_WRITE, val);
-
-	/* write 1 to OCP_CMD */
-	wl1271_write32(wl, WL12XX_OCP_CMD, OCP_CMD_WRITE);
-}
-
-u16 wl1271_top_reg_read(struct wl1271 *wl, int addr)
-{
-	u32 val;
-	int timeout = OCP_CMD_LOOP;
-
-	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
-	addr = (addr >> 1) + 0x30000;
-	wl1271_write32(wl, WL12XX_OCP_POR_CTR, addr);
-
-	/* write 2 to OCP_CMD */
-	wl1271_write32(wl, WL12XX_OCP_CMD, OCP_CMD_READ);
-
-	/* poll for data ready */
-	do {
-		val = wl1271_read32(wl, WL12XX_OCP_DATA_READ);
-	} while (!(val & OCP_READY_MASK) && --timeout);
-
-	if (!timeout) {
-		wl1271_warning("Top register access timed out.");
-		return 0xffff;
-	}
-
-	/* check data status and return if OK */
-	if ((val & OCP_STATUS_MASK) == OCP_STATUS_OK)
-		return val & 0xffff;
-	else {
-		wl1271_warning("Top register access returned error.");
-		return 0xffff;
-	}
-}
-EXPORT_SYMBOL_GPL(wl1271_top_reg_read);
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index c5ca3c8..8942954 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -44,8 +44,8 @@
 
 struct wl1271;
 
-void wl1271_disable_interrupts(struct wl1271 *wl);
-void wl1271_enable_interrupts(struct wl1271 *wl);
+void wlcore_disable_interrupts(struct wl1271 *wl);
+void wlcore_enable_interrupts(struct wl1271 *wl);
 
 void wl1271_io_reset(struct wl1271 *wl);
 void wl1271_io_init(struct wl1271 *wl);
@@ -173,11 +173,6 @@ static inline int wl1271_power_on(struct wl1271 *wl)
 	return ret;
 }
 
-
-/* Top Register IO */
-void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val);
-u16 wl1271_top_reg_read(struct wl1271 *wl, int addr);
-
 void wlcore_set_partition(struct wl1271 *wl,
 			  const struct wlcore_partition_set *p);
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 20f3d22..f761a61 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1397,7 +1397,7 @@ int wl1271_plt_start(struct wl1271 *wl)
 		if (ret < 0)
 			goto power_off;
 
-		ret = wl1271_boot(wl);
+		ret = wl->ops->boot(wl);
 		if (ret < 0)
 			goto power_off;
 
@@ -1426,7 +1426,7 @@ irq_disable:
 		   work function will not do anything.) Also, any other
 		   possible concurrent operations will fail due to the
 		   current state, hence the wl1271 struct should be safe. */
-		wl1271_disable_interrupts(wl);
+		wlcore_disable_interrupts(wl);
 		wl1271_flush_deferred_work(wl);
 		cancel_work_sync(&wl->netstack_work);
 		mutex_lock(&wl->mutex);
@@ -1453,7 +1453,7 @@ int wl1271_plt_stop(struct wl1271 *wl)
 	 * Otherwise, the interrupt handler might be called and exit without
 	 * reading the interrupt status.
 	 */
-	wl1271_disable_interrupts(wl);
+	wlcore_disable_interrupts(wl);
 	mutex_lock(&wl->mutex);
 	if (!wl->plt) {
 		mutex_unlock(&wl->mutex);
@@ -1463,7 +1463,7 @@ int wl1271_plt_stop(struct wl1271 *wl)
 		 * may have been disabled when op_stop was called. It will,
 		 * however, balance the above call to disable_interrupts().
 		 */
-		wl1271_enable_interrupts(wl);
+		wlcore_enable_interrupts(wl);
 
 		wl1271_error("cannot power down because not in PLT "
 			     "state: %d", wl->state);
@@ -1734,7 +1734,7 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	 * disable and re-enable interrupts in order to flush
 	 * the threaded_irq
 	 */
-	wl1271_disable_interrupts(wl);
+	wlcore_disable_interrupts(wl);
 
 	/*
 	 * set suspended flag to avoid triggering a new threaded_irq
@@ -1742,7 +1742,7 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	 */
 	set_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
 
-	wl1271_enable_interrupts(wl);
+	wlcore_enable_interrupts(wl);
 	flush_work(&wl->tx_work);
 	flush_delayed_work(&wl->elp_work);
 
@@ -1774,7 +1774,7 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 		wl1271_debug(DEBUG_MAC80211,
 			     "run postponed irq_work directly");
 		wl1271_irq(0, wl);
-		wl1271_enable_interrupts(wl);
+		wlcore_enable_interrupts(wl);
 	}
 
 	mutex_lock(&wl->mutex);
@@ -1818,7 +1818,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	 * Otherwise, the interrupt handler might be called and exit without
 	 * reading the interrupt status.
 	 */
-	wl1271_disable_interrupts(wl);
+	wlcore_disable_interrupts(wl);
 	mutex_lock(&wl->mutex);
 	if (wl->state == WL1271_STATE_OFF) {
 		mutex_unlock(&wl->mutex);
@@ -1828,7 +1828,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 		 * may have been disabled when op_stop was called. It will,
 		 * however, balance the above call to disable_interrupts().
 		 */
-		wl1271_enable_interrupts(wl);
+		wlcore_enable_interrupts(wl);
 		return;
 	}
 
@@ -2034,7 +2034,7 @@ static bool wl12xx_init_fw(struct wl1271 *wl)
 		if (ret < 0)
 			goto power_off;
 
-		ret = wl1271_boot(wl);
+		ret = wl->ops->boot(wl);
 		if (ret < 0)
 			goto power_off;
 
@@ -2054,7 +2054,7 @@ irq_disable:
 		   work function will not do anything.) Also, any other
 		   possible concurrent operations will fail due to the
 		   current state, hence the wl1271 struct should be safe. */
-		wl1271_disable_interrupts(wl);
+		wlcore_disable_interrupts(wl);
 		wl1271_flush_deferred_work(wl);
 		cancel_work_sync(&wl->netstack_work);
 		mutex_lock(&wl->mutex);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index f49e035..f2b18be 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -29,6 +29,7 @@
 
 struct wlcore_ops {
 	int (*identify_chip)(struct wl1271 *wl);
+	int (*boot)(struct wl1271 *wl);
 	s8 (*get_pg_ver)(struct wl1271 *wl);
 };
 
-- 
1.7.5.4

