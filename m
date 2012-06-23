Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:51621 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845Ab2FWGmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:09 -0400
Received: by lbom4 with SMTP id m4so3916248lbo.30
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:42:05 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 09/18] wlcore: Propagate errors from wl1271_raw_write32
Date: Sat, 23 Jun 2012 09:41:20 +0300
Message-Id: <1340433689-24320-10-git-send-email-coelho@ti.com> (sfid-20120623_084217_170802_51D58A12)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

Propagate errors from wl1271_raw_write32 and request for recovery when
appropriate.
Also rename prefixes of wlcore functions which their prototypes had to
be changed.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |  160 ++++++++++++++++++++++---------
 drivers/net/wireless/ti/wl18xx/io.c     |    4 +-
 drivers/net/wireless/ti/wl18xx/main.c   |   86 ++++++++++++-----
 drivers/net/wireless/ti/wlcore/boot.c   |   32 +++++--
 drivers/net/wireless/ti/wlcore/cmd.c    |    6 +-
 drivers/net/wireless/ti/wlcore/event.c  |    4 +-
 drivers/net/wireless/ti/wlcore/io.c     |   49 ++++++----
 drivers/net/wireless/ti/wlcore/io.h     |   22 ++---
 drivers/net/wireless/ti/wlcore/main.c   |   20 +++-
 drivers/net/wireless/ti/wlcore/ps.c     |   14 ++-
 drivers/net/wireless/ti/wlcore/rx.c     |    9 +-
 drivers/net/wireless/ti/wlcore/tx.c     |   17 ++--
 drivers/net/wireless/ti/wlcore/wlcore.h |    2 +-
 13 files changed, 298 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index ab486f7..3a4ab65 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -688,17 +688,28 @@ out:
 	return ret;
 }
 
-static void wl12xx_top_reg_write(struct wl1271 *wl, int addr, u16 val)
+static int wl12xx_top_reg_write(struct wl1271 *wl, int addr, u16 val)
 {
+	int ret;
+
 	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
 	addr = (addr >> 1) + 0x30000;
-	wl1271_write32(wl, WL12XX_OCP_POR_CTR, addr);
+	ret = wlcore_write32(wl, WL12XX_OCP_POR_CTR, addr);
+	if (ret < 0)
+		goto out;
 
 	/* write value to OCP_POR_WDATA */
-	wl1271_write32(wl, WL12XX_OCP_DATA_WRITE, val);
+	ret = wlcore_write32(wl, WL12XX_OCP_DATA_WRITE, val);
+	if (ret < 0)
+		goto out;
 
 	/* write 1 to OCP_CMD */
-	wl1271_write32(wl, WL12XX_OCP_CMD, OCP_CMD_WRITE);
+	ret = wlcore_write32(wl, WL12XX_OCP_CMD, OCP_CMD_WRITE);
+	if (ret < 0)
+		goto out;
+
+out:
+	return ret;
 }
 
 static int wl12xx_top_reg_read(struct wl1271 *wl, int addr, u16 *out)
@@ -709,10 +720,14 @@ static int wl12xx_top_reg_read(struct wl1271 *wl, int addr, u16 *out)
 
 	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
 	addr = (addr >> 1) + 0x30000;
-	wl1271_write32(wl, WL12XX_OCP_POR_CTR, addr);
+	ret = wlcore_write32(wl, WL12XX_OCP_POR_CTR, addr);
+	if (ret < 0)
+		return ret;
 
 	/* write 2 to OCP_CMD */
-	wl1271_write32(wl, WL12XX_OCP_CMD, OCP_CMD_READ);
+	ret = wlcore_write32(wl, WL12XX_OCP_CMD, OCP_CMD_READ);
+	if (ret < 0)
+		return ret;
 
 	/* poll for data ready */
 	do {
@@ -751,11 +766,15 @@ static int wl128x_switch_tcxo_to_fref(struct wl1271 *wl)
 	if (spare_reg == 0xFFFF)
 		return -EFAULT;
 	spare_reg |= (BIT(3) | BIT(5) | BIT(6));
-	wl12xx_top_reg_write(wl, WL_SPARE_REG, spare_reg);
+	ret = wl12xx_top_reg_write(wl, WL_SPARE_REG, spare_reg);
+	if (ret < 0)
+		return ret;
 
 	/* Enable FREF_CLK_REQ & mux MCS and coex PLLs to FREF */
-	wl12xx_top_reg_write(wl, SYS_CLK_CFG_REG,
-			     WL_CLK_REQ_TYPE_PG2 | MCS_PLL_CLK_SEL_FREF);
+	ret = wl12xx_top_reg_write(wl, SYS_CLK_CFG_REG,
+				   WL_CLK_REQ_TYPE_PG2 | MCS_PLL_CLK_SEL_FREF);
+	if (ret < 0)
+		return ret;
 
 	/* Delay execution for 15msec, to let the HW settle */
 	mdelay(15);
@@ -795,11 +814,21 @@ static bool wl128x_is_fref_valid(struct wl1271 *wl)
 
 static int wl128x_manually_configure_mcs_pll(struct wl1271 *wl)
 {
-	wl12xx_top_reg_write(wl, MCS_PLL_M_REG, MCS_PLL_M_REG_VAL);
-	wl12xx_top_reg_write(wl, MCS_PLL_N_REG, MCS_PLL_N_REG_VAL);
-	wl12xx_top_reg_write(wl, MCS_PLL_CONFIG_REG, MCS_PLL_CONFIG_REG_VAL);
+	int ret;
 
-	return 0;
+	ret = wl12xx_top_reg_write(wl, MCS_PLL_M_REG, MCS_PLL_M_REG_VAL);
+	if (ret < 0)
+		goto out;
+
+	ret = wl12xx_top_reg_write(wl, MCS_PLL_N_REG, MCS_PLL_N_REG_VAL);
+	if (ret < 0)
+		goto out;
+
+	ret = wl12xx_top_reg_write(wl, MCS_PLL_CONFIG_REG,
+				   MCS_PLL_CONFIG_REG_VAL);
+
+out:
+	return ret;
 }
 
 static int wl128x_configure_mcs_pll(struct wl1271 *wl, int clk)
@@ -818,7 +847,9 @@ static int wl128x_configure_mcs_pll(struct wl1271 *wl, int clk)
 	if (spare_reg == 0xFFFF)
 		return -EFAULT;
 	spare_reg |= BIT(2);
-	wl12xx_top_reg_write(wl, WL_SPARE_REG, spare_reg);
+	ret = wl12xx_top_reg_write(wl, WL_SPARE_REG, spare_reg);
+	if (ret < 0)
+		return ret;
 
 	/* Handle special cases of the TCXO clock */
 	if (priv->tcxo_clock == WL12XX_TCXOCLOCK_16_8 ||
@@ -836,9 +867,9 @@ static int wl128x_configure_mcs_pll(struct wl1271 *wl, int clk)
 		return -EFAULT;
 	pll_config |= (input_freq << MCS_SEL_IN_FREQ_SHIFT);
 	pll_config |= MCS_PLL_ENABLE_HP;
-	wl12xx_top_reg_write(wl, MCS_PLL_CONFIG_REG, pll_config);
+	ret = wl12xx_top_reg_write(wl, MCS_PLL_CONFIG_REG, pll_config);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -927,7 +958,9 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 			goto out;
 
 		val &= FREF_CLK_TYPE_BITS;
-		wl12xx_top_reg_write(wl, OCP_REG_CLK_TYPE, val);
+		ret = wl12xx_top_reg_write(wl, OCP_REG_CLK_TYPE, val);
+		if (ret < 0)
+			goto out;
 
 		/* Set clock pull mode (no pull) */
 		ret = wl12xx_top_reg_read(wl, OCP_REG_CLK_PULL, &val);
@@ -935,7 +968,9 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 			goto out;
 
 		val |= NO_PULL;
-		wl12xx_top_reg_write(wl, OCP_REG_CLK_PULL, val);
+		ret = wl12xx_top_reg_write(wl, OCP_REG_CLK_PULL, val);
+		if (ret < 0)
+			goto out;
 	} else {
 		u16 val;
 		/* Set clock polarity */
@@ -945,10 +980,14 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 
 		val &= FREF_CLK_POLARITY_BITS;
 		val |= CLK_REQ_OUTN_SEL;
-		wl12xx_top_reg_write(wl, OCP_REG_CLK_POLARITY, val);
+		ret = wl12xx_top_reg_write(wl, OCP_REG_CLK_POLARITY, val);
+		if (ret < 0)
+			goto out;
 	}
 
-	wl1271_write32(wl, WL12XX_PLL_PARAMETERS, clk);
+	ret = wlcore_write32(wl, WL12XX_PLL_PARAMETERS, clk);
+	if (ret < 0)
+		goto out;
 
 	ret = wlcore_read32(wl, WL12XX_PLL_PARAMETERS, &pause);
 	if (ret < 0)
@@ -958,7 +997,7 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 
 	pause &= ~(WU_COUNTER_PAUSE_VAL);
 	pause |= WU_COUNTER_PAUSE_VAL;
-	wl1271_write32(wl, WL12XX_WU_COUNTER_PAUSE, pause);
+	ret = wlcore_write32(wl, WL12XX_WU_COUNTER_PAUSE, pause);
 
 out:
 	return ret;
@@ -971,7 +1010,9 @@ static int wl1271_boot_soft_reset(struct wl1271 *wl)
 	int ret = 0;
 
 	/* perform soft reset */
-	wl1271_write32(wl, WL12XX_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
+	ret = wlcore_write32(wl, WL12XX_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
+	if (ret < 0)
+		goto out;
 
 	/* SOFT_RESET is self clearing */
 	timeout = jiffies + usecs_to_jiffies(SOFT_RESET_MAX_TIME);
@@ -995,10 +1036,12 @@ static int wl1271_boot_soft_reset(struct wl1271 *wl)
 	}
 
 	/* disable Rx/Tx */
-	wl1271_write32(wl, WL12XX_ENABLE, 0x0);
+	ret = wlcore_write32(wl, WL12XX_ENABLE, 0x0);
+	if (ret < 0)
+		goto out;
 
 	/* disable auto calibration on start*/
-	wl1271_write32(wl, WL12XX_SPARE_A2, 0xffff);
+	ret = wlcore_write32(wl, WL12XX_SPARE_A2, 0xffff);
 
 out:
 	return ret;
@@ -1022,10 +1065,15 @@ static int wl12xx_pre_boot(struct wl1271 *wl)
 	}
 
 	/* Continue the ELP wake up sequence */
-	wl1271_write32(wl, WL12XX_WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
+	ret = wlcore_write32(wl, WL12XX_WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
+	if (ret < 0)
+		goto out;
+
 	udelay(500);
 
-	wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
+	if (ret < 0)
+		goto out;
 
 	/* Read-modify-write DRPW_SCRATCH_START register (see next state)
 	   to be used by DRPw FW. The RTRIM value will be added by the FW
@@ -1042,12 +1090,18 @@ static int wl12xx_pre_boot(struct wl1271 *wl)
 	else
 		clk |= (priv->ref_clock << 1) << 4;
 
-	wl1271_write32(wl, WL12XX_DRPW_SCRATCH_START, clk);
+	ret = wlcore_write32(wl, WL12XX_DRPW_SCRATCH_START, clk);
+	if (ret < 0)
+		goto out;
 
-	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
+	if (ret < 0)
+		goto out;
 
 	/* Disable interrupts */
-	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
+	ret = wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
+	if (ret < 0)
+		goto out;
 
 	ret = wl1271_boot_soft_reset(wl);
 	if (ret < 0)
@@ -1067,7 +1121,9 @@ static int wl12xx_pre_upload(struct wl1271 *wl)
 	 * ACX_EEPROMLESS_IND_REG */
 	wl1271_debug(DEBUG_BOOT, "ACX_EEPROMLESS_IND_REG");
 
-	wl1271_write32(wl, WL12XX_EEPROMLESS_IND, WL12XX_EEPROMLESS_IND);
+	ret = wlcore_write32(wl, WL12XX_EEPROMLESS_IND, WL12XX_EEPROMLESS_IND);
+	if (ret < 0)
+		goto out;
 
 	ret = wlcore_read_reg(wl, REG_CHIP_ID_B, &tmp);
 	if (ret < 0)
@@ -1083,8 +1139,11 @@ static int wl12xx_pre_upload(struct wl1271 *wl)
 	/* WL1271: The reference driver skips steps 7 to 10 (jumps directly
 	 * to upload_fw) */
 
-	if (wl->chip.id == CHIP_ID_1283_PG20)
-		wl12xx_top_reg_write(wl, SDIO_IO_DS, HCI_IO_DS_6MA);
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		ret = wl12xx_top_reg_write(wl, SDIO_IO_DS, HCI_IO_DS_6MA);
+		if (ret < 0)
+			goto out;
+	}
 
 	/* polarity must be set before the firmware is loaded */
 	ret = wl12xx_top_reg_read(wl, OCP_REG_POLARITY, &polarity);
@@ -1093,21 +1152,31 @@ static int wl12xx_pre_upload(struct wl1271 *wl)
 
 	/* We use HIGH polarity, so unset the LOW bit */
 	polarity &= ~POLARITY_LOW;
-	wl12xx_top_reg_write(wl, OCP_REG_POLARITY, polarity);
+	ret = wl12xx_top_reg_write(wl, OCP_REG_POLARITY, polarity);
 
 out:
 	return ret;
 }
 
-static void wl12xx_enable_interrupts(struct wl1271 *wl)
+static int wl12xx_enable_interrupts(struct wl1271 *wl)
 {
-	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL12XX_ACX_ALL_EVENTS_VECTOR);
+	int ret;
+
+	ret = wlcore_write_reg(wl, REG_INTERRUPT_MASK,
+			       WL12XX_ACX_ALL_EVENTS_VECTOR);
+	if (ret < 0)
+		goto out;
 
 	wlcore_enable_interrupts(wl);
-	wlcore_write_reg(wl, REG_INTERRUPT_MASK,
-			 WL1271_ACX_INTR_ALL & ~(WL12XX_INTR_MASK));
+	ret = wlcore_write_reg(wl, REG_INTERRUPT_MASK,
+			       WL1271_ACX_INTR_ALL & ~(WL12XX_INTR_MASK));
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_write32(wl, WL12XX_HI_CFG, HI_CFG_DEF_VAL);
 
-	wl1271_write32(wl, WL12XX_HI_CFG, HI_CFG_DEF_VAL);
+out:
+	return ret;
 }
 
 static int wl12xx_boot(struct wl1271 *wl)
@@ -1134,7 +1203,7 @@ static int wl12xx_boot(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	wl12xx_enable_interrupts(wl);
+	ret = wl12xx_enable_interrupts(wl);
 
 out:
 	return ret;
@@ -1149,14 +1218,15 @@ static int wl12xx_trigger_cmd(struct wl1271 *wl, int cmd_box_addr,
 	if (ret < 0)
 		return ret;
 
-	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, WL12XX_INTR_TRIG_CMD);
+	ret = wlcore_write_reg(wl, REG_INTERRUPT_TRIG, WL12XX_INTR_TRIG_CMD);
 
 	return ret;
 }
 
-static void wl12xx_ack_event(struct wl1271 *wl)
+static int wl12xx_ack_event(struct wl1271 *wl)
 {
-	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, WL12XX_INTR_TRIG_EVENT_ACK);
+	return wlcore_write_reg(wl, REG_INTERRUPT_TRIG,
+				WL12XX_INTR_TRIG_EVENT_ACK);
 }
 
 static u32 wl12xx_calc_tx_blocks(struct wl1271 *wl, u32 len, u32 spare_blks)
@@ -1348,7 +1418,9 @@ static int wl12xx_get_fuse_mac(struct wl1271 *wl)
 	u32 mac1, mac2;
 	int ret;
 
-	wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
+	if (ret < 0)
+		goto out;
 
 	ret = wlcore_read32(wl, WL12XX_REG_FUSE_BD_ADDR_1, &mac1);
 	if (ret < 0)
@@ -1363,7 +1435,7 @@ static int wl12xx_get_fuse_mac(struct wl1271 *wl)
 		((mac1 & 0xff000000) >> 24);
 	wl->fuse_nic_addr = mac1 & 0xffffff;
 
-	wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
 
 out:
 	return ret;
diff --git a/drivers/net/wireless/ti/wl18xx/io.c b/drivers/net/wireless/ti/wl18xx/io.c
index 92c2c03..0c06ccf 100644
--- a/drivers/net/wireless/ti/wl18xx/io.c
+++ b/drivers/net/wireless/ti/wl18xx/io.c
@@ -38,14 +38,14 @@ int wl18xx_top_reg_write(struct wl1271 *wl, int addr, u16 val)
 			goto out;
 
 		tmp = (tmp & 0xffff0000) | val;
-		wl1271_write32(wl, addr, tmp);
+		ret = wlcore_write32(wl, addr, tmp);
 	} else {
 		ret = wlcore_read32(wl, addr - 2, &tmp);
 		if (ret < 0)
 			goto out;
 
 		tmp = (tmp & 0xffff) | (val << 16);
-		wl1271_write32(wl, addr - 2, tmp);
+		ret = wlcore_write32(wl, addr - 2, tmp);
 	}
 
 out:
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index f99f003..c25b960 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -641,7 +641,9 @@ static int wl18xx_set_clk(struct wl1271 *wl)
 	u16 clk_freq;
 	int ret;
 
-	wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
+	if (ret < 0)
+		goto out;
 
 	/* TODO: PG2: apparently we need to read the clk type */
 
@@ -699,13 +701,20 @@ out:
 	return ret;
 }
 
-static void wl18xx_boot_soft_reset(struct wl1271 *wl)
+static int wl18xx_boot_soft_reset(struct wl1271 *wl)
 {
+	int ret;
+
 	/* disable Rx/Tx */
-	wl1271_write32(wl, WL18XX_ENABLE, 0x0);
+	ret = wlcore_write32(wl, WL18XX_ENABLE, 0x0);
+	if (ret < 0)
+		goto out;
 
 	/* disable auto calibration on start*/
-	wl1271_write32(wl, WL18XX_SPARE_A2, 0xffff);
+	ret = wlcore_write32(wl, WL18XX_SPARE_A2, 0xffff);
+
+out:
+	return ret;
 }
 
 static int wl18xx_pre_boot(struct wl1271 *wl)
@@ -717,15 +726,22 @@ static int wl18xx_pre_boot(struct wl1271 *wl)
 		goto out;
 
 	/* Continue the ELP wake up sequence */
-	wl1271_write32(wl, WL18XX_WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
+	ret = wlcore_write32(wl, WL18XX_WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
+	if (ret < 0)
+		goto out;
+
 	udelay(500);
 
-	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+	if (ret < 0)
+		goto out;
 
 	/* Disable interrupts */
-	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
+	ret = wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
+	if (ret < 0)
+		goto out;
 
-	wl18xx_boot_soft_reset(wl);
+	ret = wl18xx_boot_soft_reset(wl);
 
 out:
 	return ret;
@@ -736,10 +752,14 @@ static int wl18xx_pre_upload(struct wl1271 *wl)
 	u32 tmp;
 	int ret;
 
-	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+	if (ret < 0)
+		goto out;
 
 	/* TODO: check if this is all needed */
-	wl1271_write32(wl, WL18XX_EEPROMLESS_IND, WL18XX_EEPROMLESS_IND);
+	ret = wlcore_write32(wl, WL18XX_EEPROMLESS_IND, WL18XX_EEPROMLESS_IND);
+	if (ret < 0)
+		goto out;
 
 	ret = wlcore_read_reg(wl, REG_CHIP_ID_B, &tmp);
 	if (ret < 0)
@@ -765,16 +785,21 @@ static int wl18xx_set_mac_and_phy(struct wl1271 *wl)
 	else
 		len = sizeof(struct wl18xx_mac_and_phy_params);
 
-	wlcore_set_partition(wl, &wl->ptable[PART_PHY_INIT]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_PHY_INIT]);
+	if (ret < 0)
+		goto out;
+
 	ret = wlcore_write(wl, WL18XX_PHY_INIT_MEM_ADDR, (u8 *)&priv->conf.phy,
 			   len, false);
 
+out:
 	return ret;
 }
 
-static void wl18xx_enable_interrupts(struct wl1271 *wl)
+static int wl18xx_enable_interrupts(struct wl1271 *wl)
 {
 	u32 event_mask, intr_mask;
+	int ret;
 
 	if (wl->chip.id == CHIP_ID_185x_PG10) {
 		event_mask = WL18XX_ACX_EVENTS_VECTOR_PG1;
@@ -784,11 +809,17 @@ static void wl18xx_enable_interrupts(struct wl1271 *wl)
 		intr_mask = WL18XX_INTR_MASK_PG2;
 	}
 
-	wlcore_write_reg(wl, REG_INTERRUPT_MASK, event_mask);
+	ret = wlcore_write_reg(wl, REG_INTERRUPT_MASK, event_mask);
+	if (ret < 0)
+		goto out;
 
 	wlcore_enable_interrupts(wl);
-	wlcore_write_reg(wl, REG_INTERRUPT_MASK,
-			 WL1271_ACX_INTR_ALL & ~intr_mask);
+
+	ret = wlcore_write_reg(wl, REG_INTERRUPT_MASK,
+			       WL1271_ACX_INTR_ALL & ~intr_mask);
+
+out:
+	return ret;
 }
 
 static int wl18xx_boot(struct wl1271 *wl)
@@ -815,7 +846,7 @@ static int wl18xx_boot(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	wl18xx_enable_interrupts(wl);
+	ret = wl18xx_enable_interrupts(wl);
 
 out:
 	return ret;
@@ -833,9 +864,10 @@ static int wl18xx_trigger_cmd(struct wl1271 *wl, int cmd_box_addr,
 			    WL18XX_CMD_MAX_SIZE, false);
 }
 
-static void wl18xx_ack_event(struct wl1271 *wl)
+static int wl18xx_ack_event(struct wl1271 *wl)
 {
-	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, WL18XX_INTR_TRIG_EVENT_ACK);
+	return wlcore_write_reg(wl, REG_INTERRUPT_TRIG,
+				WL18XX_INTR_TRIG_EVENT_ACK);
 }
 
 static u32 wl18xx_calc_tx_blocks(struct wl1271 *wl, u32 len, u32 spare_blks)
@@ -1038,7 +1070,9 @@ static int wl18xx_get_pg_ver(struct wl1271 *wl, s8 *ver)
 	u32 fuse;
 	int ret;
 
-	wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
+	if (ret < 0)
+		goto out;
 
 	ret = wlcore_read32(wl, WL18XX_REG_FUSE_DATA_1_3, &fuse);
 	if (ret < 0)
@@ -1047,7 +1081,7 @@ static int wl18xx_get_pg_ver(struct wl1271 *wl, s8 *ver)
 	if (ver)
 		*ver = (fuse & WL18XX_PG_VER_MASK) >> WL18XX_PG_VER_OFFSET;
 
-	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
 
 out:
 	return ret;
@@ -1116,7 +1150,11 @@ out:
 
 static int wl18xx_plt_init(struct wl1271 *wl)
 {
-	wl1271_write32(wl, WL18XX_SCR_PAD8, WL18XX_SCR_PAD8_PLT);
+	int ret;
+
+	ret = wlcore_write32(wl, WL18XX_SCR_PAD8, WL18XX_SCR_PAD8_PLT);
+	if (ret < 0)
+		return ret;
 
 	return wl->ops->boot(wl);
 }
@@ -1126,7 +1164,9 @@ static int wl18xx_get_mac(struct wl1271 *wl)
 	u32 mac1, mac2;
 	int ret;
 
-	wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
+	if (ret < 0)
+		goto out;
 
 	ret = wlcore_read32(wl, WL18XX_REG_FUSE_BD_ADDR_1, &mac1);
 	if (ret < 0)
@@ -1141,7 +1181,7 @@ static int wl18xx_get_mac(struct wl1271 *wl)
 		((mac1 & 0xff000000) >> 24);
 	wl->fuse_nic_addr = (mac1 & 0xffffff);
 
-	wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
 
 out:
 	return ret;
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 0aa0e29..8965960 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -45,7 +45,7 @@ static int wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 
 	/* 10.5.1 run the firmware (II) */
 	cpu_ctrl |= flag;
-	wlcore_write_reg(wl, REG_ECPU_CONTROL, cpu_ctrl);
+	ret = wlcore_write_reg(wl, REG_ECPU_CONTROL, cpu_ctrl);
 
 out:
 	return ret;
@@ -139,7 +139,9 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 
 	memcpy(&partition, &wl->ptable[PART_DOWN], sizeof(partition));
 	partition.mem.start = dest;
-	wlcore_set_partition(wl, &partition);
+	ret = wlcore_set_partition(wl, &partition);
+	if (ret < 0)
+		return ret;
 
 	/* 10.1 set partition limit and chunk num */
 	chunk_num = 0;
@@ -153,7 +155,9 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 			partition_limit = chunk_num * CHUNK_SIZE +
 				wl->ptable[PART_DOWN].mem.size;
 			partition.mem.start = addr;
-			wlcore_set_partition(wl, &partition);
+			ret = wlcore_set_partition(wl, &partition);
+			if (ret < 0)
+				return ret;
 		}
 
 		/* 10.3 upload the chunk */
@@ -320,7 +324,9 @@ int wlcore_boot_upload_nvs(struct wl1271 *wl)
 			wl1271_debug(DEBUG_BOOT,
 				     "nvs burst write 0x%x: 0x%x",
 				     dest_addr, val);
-			wl1271_write32(wl, dest_addr, val);
+			ret = wlcore_write32(wl, dest_addr, val);
+			if (ret < 0)
+				return ret;
 
 			nvs_ptr += 4;
 			dest_addr += 4;
@@ -346,7 +352,9 @@ int wlcore_boot_upload_nvs(struct wl1271 *wl)
 	nvs_len -= nvs_ptr - (u8 *)wl->nvs;
 
 	/* Now we must set the partition correctly */
-	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
+	if (ret < 0)
+		return ret;
 
 	/* Copy the NVS tables to a new block to ensure alignment */
 	nvs_aligned = kmemdup(nvs_ptr, nvs_len, GFP_KERNEL);
@@ -372,7 +380,9 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 	u32 chip_id, intr;
 
 	/* Make sure we have the boot partition */
-	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+	if (ret < 0)
+		return ret;
 
 	ret = wl1271_boot_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
 	if (ret < 0)
@@ -404,8 +414,10 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 		}
 		/* check that ACX_INTR_INIT_COMPLETE is enabled */
 		else if (intr & WL1271_ACX_INTR_INIT_COMPLETE) {
-			wlcore_write_reg(wl, REG_INTERRUPT_ACK,
-					 WL1271_ACX_INTR_INIT_COMPLETE);
+			ret = wlcore_write_reg(wl, REG_INTERRUPT_ACK,
+					       WL1271_ACX_INTR_INIT_COMPLETE);
+			if (ret < 0)
+				return ret;
 			break;
 		}
 	}
@@ -469,9 +481,9 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 	}
 
 	/* set the working partition to its "running" mode offset */
-	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
 
 	/* firmware startup completed */
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(wlcore_boot_run_firmware);
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index f2ac982..84dd808 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -116,7 +116,11 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		goto fail;
 	}
 
-	wlcore_write_reg(wl, REG_INTERRUPT_ACK, WL1271_ACX_INTR_CMD_COMPLETE);
+	ret = wlcore_write_reg(wl, REG_INTERRUPT_ACK,
+			       WL1271_ACX_INTR_CMD_COMPLETE);
+	if (ret < 0)
+		goto fail;
+
 	return 0;
 
 fail:
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 123d26d..4890705 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -318,7 +318,7 @@ int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
 	 * TODO: we just need this because one bit is in a different
 	 * place.  Is there any better way?
 	 */
-	wl->ops->ack_event(wl);
+	ret = wl->ops->ack_event(wl);
 
-	return 0;
+	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/io.c b/drivers/net/wireless/ti/wlcore/io.c
index 62d6573..9976219 100644
--- a/drivers/net/wireless/ti/wlcore/io.c
+++ b/drivers/net/wireless/ti/wlcore/io.c
@@ -128,9 +128,11 @@ EXPORT_SYMBOL_GPL(wlcore_translate_addr);
  *                                    |    |
  *
  */
-void wlcore_set_partition(struct wl1271 *wl,
-			  const struct wlcore_partition_set *p)
+int wlcore_set_partition(struct wl1271 *wl,
+			 const struct wlcore_partition_set *p)
 {
+	int ret;
+
 	/* copy partition info */
 	memcpy(&wl->curr_part, p, sizeof(*p));
 
@@ -143,28 +145,41 @@ void wlcore_set_partition(struct wl1271 *wl,
 	wl1271_debug(DEBUG_IO, "mem3_start %08X mem3_size %08X",
 		     p->mem3.start, p->mem3.size);
 
-	wl1271_raw_write32(wl, HW_PART0_START_ADDR, p->mem.start);
-	wl1271_raw_write32(wl, HW_PART0_SIZE_ADDR, p->mem.size);
-	wl1271_raw_write32(wl, HW_PART1_START_ADDR, p->reg.start);
-	wl1271_raw_write32(wl, HW_PART1_SIZE_ADDR, p->reg.size);
-	wl1271_raw_write32(wl, HW_PART2_START_ADDR, p->mem2.start);
-	wl1271_raw_write32(wl, HW_PART2_SIZE_ADDR, p->mem2.size);
+	ret = wlcore_raw_write32(wl, HW_PART0_START_ADDR, p->mem.start);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_raw_write32(wl, HW_PART0_SIZE_ADDR, p->mem.size);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_raw_write32(wl, HW_PART1_START_ADDR, p->reg.start);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_raw_write32(wl, HW_PART1_SIZE_ADDR, p->reg.size);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_raw_write32(wl, HW_PART2_START_ADDR, p->mem2.start);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_raw_write32(wl, HW_PART2_SIZE_ADDR, p->mem2.size);
+	if (ret < 0)
+		goto out;
+
 	/*
 	 * We don't need the size of the last partition, as it is
 	 * automatically calculated based on the total memory size and
 	 * the sizes of the previous partitions.
 	 */
-	wl1271_raw_write32(wl, HW_PART3_START_ADDR, p->mem3.start);
-}
-EXPORT_SYMBOL_GPL(wlcore_set_partition);
+	ret = wlcore_raw_write32(wl, HW_PART3_START_ADDR, p->mem3.start);
 
-void wlcore_select_partition(struct wl1271 *wl, u8 part)
-{
-	wl1271_debug(DEBUG_IO, "setting partition %d", part);
-
-	wlcore_set_partition(wl, &wl->ptable[part]);
+out:
+	return ret;
 }
-EXPORT_SYMBOL_GPL(wlcore_select_partition);
+EXPORT_SYMBOL_GPL(wlcore_set_partition);
 
 void wl1271_io_reset(struct wl1271 *wl)
 {
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 0395b03..5e4a3d1 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -92,11 +92,11 @@ static inline int wlcore_raw_read32(struct wl1271 *wl, int addr, u32 *val)
 	return 0;
 }
 
-static inline void wl1271_raw_write32(struct wl1271 *wl, int addr, u32 val)
+static inline int wlcore_raw_write32(struct wl1271 *wl, int addr, u32 val)
 {
 	wl->buffer_32 = cpu_to_le32(val);
-	wlcore_raw_write(wl, addr, &wl->buffer_32,
-			     sizeof(wl->buffer_32), false);
+	return wlcore_raw_write(wl, addr, &wl->buffer_32,
+				sizeof(wl->buffer_32), false);
 }
 
 static inline int wlcore_read(struct wl1271 *wl, int addr, void *buf,
@@ -150,9 +150,9 @@ static inline int wlcore_read32(struct wl1271 *wl, int addr, u32 *val)
 	return wlcore_raw_read32(wl, wlcore_translate_addr(wl, addr), val);
 }
 
-static inline void wl1271_write32(struct wl1271 *wl, int addr, u32 val)
+static inline int wlcore_write32(struct wl1271 *wl, int addr, u32 val)
 {
-	wl1271_raw_write32(wl, wlcore_translate_addr(wl, addr), val);
+	return wlcore_raw_write32(wl, wlcore_translate_addr(wl, addr), val);
 }
 
 static inline int wlcore_read_reg(struct wl1271 *wl, int reg, u32 *val)
@@ -162,9 +162,11 @@ static inline int wlcore_read_reg(struct wl1271 *wl, int reg, u32 *val)
 				 val);
 }
 
-static inline void wlcore_write_reg(struct wl1271 *wl, int reg, u32 val)
+static inline int wlcore_write_reg(struct wl1271 *wl, int reg, u32 val)
 {
-	wl1271_raw_write32(wl, wlcore_translate_addr(wl, wl->rtable[reg]), val);
+	return wlcore_raw_write32(wl,
+				  wlcore_translate_addr(wl, wl->rtable[reg]),
+				  val);
 }
 
 static inline void wl1271_power_off(struct wl1271 *wl)
@@ -188,8 +190,8 @@ static inline int wl1271_power_on(struct wl1271 *wl)
 	return ret;
 }
 
-void wlcore_set_partition(struct wl1271 *wl,
-			  const struct wlcore_partition_set *p);
+int wlcore_set_partition(struct wl1271 *wl,
+			 const struct wlcore_partition_set *p);
 
 bool wl1271_set_block_size(struct wl1271 *wl);
 
@@ -197,6 +199,4 @@ bool wl1271_set_block_size(struct wl1271 *wl);
 
 int wl1271_tx_dummy_packet(struct wl1271 *wl);
 
-void wlcore_select_partition(struct wl1271 *wl, u8 part);
-
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index c16d266..546fcb0 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -882,7 +882,9 @@ static void wlcore_print_recovery(struct wl1271 *wl)
 		    wl->chip.fw_ver_str);
 
 	/* change partitions momentarily so we can read the FW pc */
-	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+	if (ret < 0)
+		return;
 
 	ret = wlcore_read_reg(wl, REG_PC_ON_RECOVERY, &pc);
 	if (ret < 0)
@@ -967,9 +969,9 @@ out_unlock:
 	mutex_unlock(&wl->mutex);
 }
 
-static void wl1271_fw_wakeup(struct wl1271 *wl)
+static int wlcore_fw_wakeup(struct wl1271 *wl)
 {
-	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP);
+	return wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP);
 }
 
 static int wl1271_setup(struct wl1271 *wl)
@@ -1005,13 +1007,21 @@ static int wl12xx_set_power_on(struct wl1271 *wl)
 	wl1271_io_reset(wl);
 	wl1271_io_init(wl);
 
-	wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+	ret = wlcore_set_partition(wl, &wl->ptable[PART_BOOT]);
+	if (ret < 0)
+		goto fail;
 
 	/* ELP module wake up */
-	wl1271_fw_wakeup(wl);
+	ret = wlcore_fw_wakeup(wl);
+	if (ret < 0)
+		goto fail;
 
 out:
 	return ret;
+
+fail:
+	wl1271_power_off(wl);
+	return ret;
 }
 
 static int wl12xx_chip_wakeup(struct wl1271 *wl, bool plt)
diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
index 95d8797..46d36fd 100644
--- a/drivers/net/wireless/ti/wlcore/ps.c
+++ b/drivers/net/wireless/ti/wlcore/ps.c
@@ -35,6 +35,7 @@ void wl1271_elp_work(struct work_struct *work)
 	struct delayed_work *dwork;
 	struct wl1271 *wl;
 	struct wl12xx_vif *wlvif;
+	int ret;
 
 	dwork = container_of(work, struct delayed_work, work);
 	wl = container_of(dwork, struct wl1271, elp_work);
@@ -63,7 +64,12 @@ void wl1271_elp_work(struct work_struct *work)
 	}
 
 	wl1271_debug(DEBUG_PSM, "chip to elp");
-	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_SLEEP);
+	ret = wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_SLEEP);
+	if (ret < 0) {
+		wl12xx_queue_recovery_work(wl);
+		goto out;
+	}
+
 	set_bit(WL1271_FLAG_IN_ELP, &wl->flags);
 
 out:
@@ -135,7 +141,11 @@ int wl1271_ps_elp_wakeup(struct wl1271 *wl)
 		wl->elp_compl = &compl;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
-	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP);
+	ret = wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP);
+	if (ret < 0) {
+		wl12xx_queue_recovery_work(wl);
+		goto err;
+	}
 
 	if (!pending) {
 		ret = wait_for_completion_timeout(
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index be24b30..f42b969 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -279,9 +279,12 @@ int wlcore_rx(struct wl1271 *wl, struct wl_fw_status_1 *status)
 	 * Write the driver's packet counter to the FW. This is only required
 	 * for older hardware revisions
 	 */
-	if (wl->quirks & WLCORE_QUIRK_END_OF_TRANSACTION)
-		wl1271_write32(wl, WL12XX_REG_RX_DRIVER_COUNTER,
-			       wl->rx_counter);
+	if (wl->quirks & WLCORE_QUIRK_END_OF_TRANSACTION) {
+		ret = wlcore_write32(wl, WL12XX_REG_RX_DRIVER_COUNTER,
+				     wl->rx_counter);
+		if (ret < 0)
+			goto out;
+	}
 
 	wl12xx_rearm_rx_streaming(wl, active_hlids);
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 90bddf5..b5211be 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -746,9 +746,12 @@ out_ack:
 		 * Interrupt the firmware with the new packets. This is only
 		 * required for older hardware revisions
 		 */
-		if (wl->quirks & WLCORE_QUIRK_END_OF_TRANSACTION)
-			wl1271_write32(wl, WL12XX_HOST_WR_ACCESS,
-				       wl->tx_packets_count);
+		if (wl->quirks & WLCORE_QUIRK_END_OF_TRANSACTION) {
+			ret = wlcore_write32(wl, WL12XX_HOST_WR_ACCESS,
+					     wl->tx_packets_count);
+			if (ret < 0)
+				goto out;
+		}
 
 		wl1271_handle_tx_low_watermark(wl);
 	}
@@ -911,9 +914,11 @@ int wlcore_tx_complete(struct wl1271 *wl)
 	fw_counter = le32_to_cpu(wl->tx_res_if->tx_result_fw_counter);
 
 	/* write host counter to chipset (to ack) */
-	wl1271_write32(wl, le32_to_cpu(memmap->tx_result) +
-		       offsetof(struct wl1271_tx_hw_res_if,
-				tx_result_host_counter), fw_counter);
+	ret = wlcore_write32(wl, le32_to_cpu(memmap->tx_result) +
+			     offsetof(struct wl1271_tx_hw_res_if,
+				      tx_result_host_counter), fw_counter);
+	if (ret < 0)
+		goto out;
 
 	count = fw_counter - wl->tx_results_count;
 	wl1271_debug(DEBUG_TX, "tx_complete received, packets: %d", count);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 2fb5374..e796974 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -43,7 +43,7 @@ struct wlcore_ops {
 	int (*plt_init)(struct wl1271 *wl);
 	int (*trigger_cmd)(struct wl1271 *wl, int cmd_box_addr,
 			   void *buf, size_t len);
-	void (*ack_event)(struct wl1271 *wl);
+	int (*ack_event)(struct wl1271 *wl);
 	u32 (*calc_tx_blocks)(struct wl1271 *wl, u32 len, u32 spare_blks);
 	void (*set_tx_desc_blocks)(struct wl1271 *wl,
 				   struct wl1271_tx_hw_descr *desc,
-- 
1.7.10

