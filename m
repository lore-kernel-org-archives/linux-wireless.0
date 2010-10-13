Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49239 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab0JMLDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 07:03:00 -0400
From: csanjay@mistralsolutions.com
To: linux-omap@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Sanjay Kumar Champati <csanjay@mistralsolutions.com>
Subject: [WL1271 DC supprot on OMAP3EVM 1/5] ARM: Supported MMC 2 features for OMAP3EVM
Date: Wed, 13 Oct 2010 16:21:13 +0530
Message-Id: <1286967077-20071-2-git-send-email-csanjay@mistralsolutions.com>
In-Reply-To: <1286967077-20071-1-git-send-email-csanjay@mistralsolutions.com>
References: <1286967077-20071-1-git-send-email-csanjay@mistralsolutions.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sanjay Kumar Champati <csanjay@mistralsolutions.com>

* Modified "board-omap3evm.c" file for MMC2 support
* Modified "mmc-twl4030.c" and "mmc-twl4030.h" file for MMC2 power support

Signed-off-by: Sanjay Kumar Champati <csanjay@mistralsolutions.com>
---
 arch/arm/mach-omap2/board-omap3evm.c |   15 +++++++++++++++
 arch/arm/mach-omap2/mmc-twl4030.c    |    1 +
 arch/arm/mach-omap2/mmc-twl4030.h    |    2 ++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index d2c8dcf..6b45b6e 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -611,6 +611,13 @@ static struct twl4030_hsmmc_info mmc[] = {
 		.gpio_cd	= -EINVAL,
 		.gpio_wp	= 63,
 	},
+	{
+		.mmc            = 2,
+		.wires          = 4,
+		.gpio_cd        = -EINVAL,
+		.gpio_wp        = -EINVAL,
+		.ocr_mask	= 0x00000080,
+	},
 	{}	/* Terminator */
 };
 
@@ -741,6 +748,7 @@ static int omap3evm_twl_gpio_setup(struct device *dev,
 	/* link regulators to MMC adapters */
 	twl4030_vmmc1_supply.dev = mmc[0].dev;
 	twl4030_vsim_supply.dev = mmc[0].dev;
+	twl4030_vmmc2_supply.dev = mmc[1].dev;
 
 	/*
 	 * Most GPIOs are for USB OTG.  Some are mostly sent to
@@ -949,6 +957,7 @@ static int __init omap3_evm_i2c_init(void)
 	 */
 	omap3evm_twldata.vmmc1 = &vmmc1_data;
 	omap3evm_twldata.vsim = &vsim_data;
+	omap3evm_twldata.vmmc2 = &vmmc2_data;
 
 	omap_register_i2c_bus(1, 2600, omap3evm_i2c_boardinfo,
 			ARRAY_SIZE(omap3evm_i2c_boardinfo));
@@ -1067,6 +1076,12 @@ static struct omap_board_mux omap35x_board_mux[] __initdata = {
 				OMAP_PIN_OFF_INPUT_PULLUP | OMAP_PIN_OFF_OUTPUT_LOW |
 				OMAP_PIN_OFF_WAKEUPENABLE),
 #endif
+	OMAP3_MUX(SDMMC2_CLK, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP3_MUX(SDMMC2_CMD, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP3_MUX(SDMMC2_DAT0, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP3_MUX(SDMMC2_DAT1, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP3_MUX(SDMMC2_DAT2, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP3_MUX(SDMMC2_DAT3, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
 
 	{ .reg_offset = OMAP_MUX_TERMINATOR },
 };
diff --git a/arch/arm/mach-omap2/mmc-twl4030.c b/arch/arm/mach-omap2/mmc-twl4030.c
index 0c3c72d..c56f8c7 100644
--- a/arch/arm/mach-omap2/mmc-twl4030.c
+++ b/arch/arm/mach-omap2/mmc-twl4030.c
@@ -124,6 +124,7 @@ static int twl_mmc_late_init(struct device *dev)
 			}
 			hsmmc[i].vcc = reg;
 			mmc->slots[0].ocr_mask = mmc_regulator_get_ocrmask(reg);
+			mmc->slots[1].ocr_mask = mmc_regulator_get_ocrmask(reg);
 
 			/* allow an aux regulator */
 			reg = regulator_get(dev, "vmmc_aux");
diff --git a/arch/arm/mach-omap2/mmc-twl4030.h b/arch/arm/mach-omap2/mmc-twl4030.h
index a47e685..88bcf46 100644
--- a/arch/arm/mach-omap2/mmc-twl4030.h
+++ b/arch/arm/mach-omap2/mmc-twl4030.h
@@ -34,3 +34,5 @@ static inline void twl4030_mmc_init(struct twl4030_hsmmc_info *info)
 }
 
 #endif
+extern struct regulator_consumer_supply twl4030_vmmc2_supply;
+extern struct regulator_init_data vmmc2_data;
-- 
1.6.3.3

