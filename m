Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51688 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030437Ab2HHRKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 13:10:32 -0400
Received: by wgbdr13 with SMTP id dr13so935670wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 10:10:30 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: add (mostly) NAND defines
Date: Wed,  8 Aug 2012 19:10:14 +0200
Message-Id: <1344445816-11871-1-git-send-email-zajec5@gmail.com> (sfid-20120808_191036_661496_6AEA05F6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 include/linux/bcma/bcma_driver_chipcommon.h |   85 +++++++++++++++++++++++++++
 include/linux/bcma/bcma_regs.h              |    2 +
 2 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index d323a4b..3fb8bba 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -100,6 +100,7 @@
 #define  BCMA_CC_CHIPST_4706_SFLASH_TYPE	BIT(2) /* 0: 8b-p/ST-s flash, 1: 16b-p/Atmal-s flash */
 #define  BCMA_CC_CHIPST_4706_MIPS_BENDIAN	BIT(3) /* 0: little, 1: big endian */
 #define  BCMA_CC_CHIPST_4706_PCIE1_DISABLE	BIT(5) /* PCIE1 enable strap pin */
+#define  BCMA_CC_CHIPST_5357_NAND_BOOT		BIT(4) /* NAND boot, valid for CC rev 38 and/or BCM5357 */
 #define BCMA_CC_JCMD			0x0030		/* Rev >= 10 only */
 #define  BCMA_CC_JCMD_START		0x80000000
 #define  BCMA_CC_JCMD_BUSY		0x80000000
@@ -266,6 +267,29 @@
 #define  BCMA_CC_SROM_CONTROL_SIZE_16K	0x00000004
 #define  BCMA_CC_SROM_CONTROL_SIZE_SHIFT	1
 #define  BCMA_CC_SROM_CONTROL_PRESENT	0x00000001
+/* Block 0x140 - 0x190 registers are chipset specific */
+#define BCMA_CC_4706_FLASHSCFG		0x18C		/* Flash struct configuration */
+#define  BCMA_CC_4706_FLASHSCFG_MASK	0x000000ff
+#define  BCMA_CC_4706_FLASHSCFG_SF1	0x00000001	/* 2nd serial flash present */
+#define  BCMA_CC_4706_FLASHSCFG_PF1	0x00000002	/* 2nd parallel flash present */
+#define  BCMA_CC_4706_FLASHSCFG_SF1_TYPE	0x00000004	/* 2nd serial flash type : 0 : ST, 1 : Atmel */
+#define  BCMA_CC_4706_FLASHSCFG_NF1	0x00000008	/* 2nd NAND flash present */
+#define  BCMA_CC_4706_FLASHSCFG_1ST_MADDR_SEG_MASK	0x000000f0
+#define  BCMA_CC_4706_FLASHSCFG_1ST_MADDR_SEG_4MB	0x00000010	/* 4MB */
+#define  BCMA_CC_4706_FLASHSCFG_1ST_MADDR_SEG_8MB	0x00000020	/* 8MB */
+#define  BCMA_CC_4706_FLASHSCFG_1ST_MADDR_SEG_16MB	0x00000030	/* 16MB */
+#define  BCMA_CC_4706_FLASHSCFG_1ST_MADDR_SEG_32MB	0x00000040	/* 32MB */
+#define  BCMA_CC_4706_FLASHSCFG_1ST_MADDR_SEG_64MB	0x00000050	/* 64MB */
+#define  BCMA_CC_4706_FLASHSCFG_1ST_MADDR_SEG_128MB	0x00000060	/* 128MB */
+#define  BCMA_CC_4706_FLASHSCFG_1ST_MADDR_SEG_256MB	0x00000070	/* 256MB */
+/* NAND flash registers for BCM4706 (corerev = 31) */
+#define BCMA_CC_NFLASH_CTL		0x01A0
+#define  BCMA_CC_NFLASH_CTL_ERR		0x08000000
+#define BCMA_CC_NFLASH_CONF		0x01A4
+#define BCMA_CC_NFLASH_COL_ADDR		0x01A8
+#define BCMA_CC_NFLASH_ROW_ADDR		0x01AC
+#define BCMA_CC_NFLASH_DATA		0x01B0
+#define BCMA_CC_NFLASH_WAITCNT0		0x01B4
 /* 0x1E0 is defined as shared BCMA_CLKCTLST */
 #define BCMA_CC_HW_WORKAROUND		0x01E4 /* Hardware workaround (rev >= 20) */
 #define BCMA_CC_UART0_DATA		0x0300
@@ -325,6 +349,60 @@
 #define BCMA_CC_PLLCTL_ADDR		0x0660
 #define BCMA_CC_PLLCTL_DATA		0x0664
 #define BCMA_CC_SPROM			0x0800 /* SPROM beginning */
+/* NAND flash MLC controller registers (corerev >= 38) */
+#define BCMA_CC_NAND_REVISION		0x0C00
+#define BCMA_CC_NAND_CMD_START		0x0C04
+#define BCMA_CC_NAND_CMD_ADDR_X		0x0C08
+#define BCMA_CC_NAND_CMD_ADDR		0x0C0C
+#define BCMA_CC_NAND_CMD_END_ADDR	0x0C10
+#define BCMA_CC_NAND_CS_NAND_SELECT	0x0C14
+#define BCMA_CC_NAND_CS_NAND_XOR	0x0C18
+#define BCMA_CC_NAND_SPARE_RD0		0x0C20
+#define BCMA_CC_NAND_SPARE_RD4		0x0C24
+#define BCMA_CC_NAND_SPARE_RD8		0x0C28
+#define BCMA_CC_NAND_SPARE_RD12		0x0C2C
+#define BCMA_CC_NAND_SPARE_WR0		0x0C30
+#define BCMA_CC_NAND_SPARE_WR4		0x0C34
+#define BCMA_CC_NAND_SPARE_WR8		0x0C38
+#define BCMA_CC_NAND_SPARE_WR12		0x0C3C
+#define BCMA_CC_NAND_ACC_CONTROL	0x0C40
+#define BCMA_CC_NAND_CONFIG		0x0C48
+#define BCMA_CC_NAND_TIMING_1		0x0C50
+#define BCMA_CC_NAND_TIMING_2		0x0C54
+#define BCMA_CC_NAND_SEMAPHORE		0x0C58
+#define BCMA_CC_NAND_DEVID		0x0C60
+#define BCMA_CC_NAND_DEVID_X		0x0C64
+#define BCMA_CC_NAND_BLOCK_LOCK_STATUS	0x0C68
+#define BCMA_CC_NAND_INTFC_STATUS	0x0C6C
+#define BCMA_CC_NAND_ECC_CORR_ADDR_X	0x0C70
+#define BCMA_CC_NAND_ECC_CORR_ADDR	0x0C74
+#define BCMA_CC_NAND_ECC_UNC_ADDR_X	0x0C78
+#define BCMA_CC_NAND_ECC_UNC_ADDR	0x0C7C
+#define BCMA_CC_NAND_READ_ERROR_COUNT	0x0C80
+#define BCMA_CC_NAND_CORR_STAT_THRESHOLD	0x0C84
+#define BCMA_CC_NAND_READ_ADDR_X	0x0C90
+#define BCMA_CC_NAND_READ_ADDR		0x0C94
+#define BCMA_CC_NAND_PAGE_PROGRAM_ADDR_X	0x0C98
+#define BCMA_CC_NAND_PAGE_PROGRAM_ADDR	0x0C9C
+#define BCMA_CC_NAND_COPY_BACK_ADDR_X	0x0CA0
+#define BCMA_CC_NAND_COPY_BACK_ADDR	0x0CA4
+#define BCMA_CC_NAND_BLOCK_ERASE_ADDR_X	0x0CA8
+#define BCMA_CC_NAND_BLOCK_ERASE_ADDR	0x0CAC
+#define BCMA_CC_NAND_INV_READ_ADDR_X	0x0CB0
+#define BCMA_CC_NAND_INV_READ_ADDR	0x0CB4
+#define BCMA_CC_NAND_BLK_WR_PROTECT	0x0CC0
+#define BCMA_CC_NAND_ACC_CONTROL_CS1	0x0CD0
+#define BCMA_CC_NAND_CONFIG_CS1		0x0CD4
+#define BCMA_CC_NAND_TIMING_1_CS1	0x0CD8
+#define BCMA_CC_NAND_TIMING_2_CS1	0x0CDC
+#define BCMA_CC_NAND_SPARE_RD16		0x0D30
+#define BCMA_CC_NAND_SPARE_RD20		0x0D34
+#define BCMA_CC_NAND_SPARE_RD24		0x0D38
+#define BCMA_CC_NAND_SPARE_RD28		0x0D3C
+#define BCMA_CC_NAND_CACHE_ADDR		0x0D40
+#define BCMA_CC_NAND_CACHE_DATA		0x0D44
+#define BCMA_CC_NAND_CTRL_CONFIG	0x0D48
+#define BCMA_CC_NAND_CTRL_STATUS	0x0D4C
 
 /* Divider allocation in 4716/47162/5356 */
 #define BCMA_CC_PMU5_MAINPLL_CPU	1
@@ -415,6 +493,13 @@
 /* 4313 Chip specific ChipControl register bits */
 #define BCMA_CCTRL_4313_12MA_LED_DRIVE		0x00000007	/* 12 mA drive strengh for later 4313 */
 
+/* BCM5357 ChipControl register bits */
+#define BCMA_CHIPCTL_5357_EXTPA			BIT(14)
+#define BCMA_CHIPCTL_5357_ANT_MUX_2O3		BIT(15)
+#define BCMA_CHIPCTL_5357_NFLASH		BIT(16)
+#define BCMA_CHIPCTL_5357_I2S_PINS_ENABLE	BIT(18)
+#define BCMA_CHIPCTL_5357_I2CSPI_PINS_ENABLE	BIT(19)
+
 /* Data for the PMU, if available.
  * Check availability with ((struct bcma_chipcommon)->capabilities & BCMA_CC_CAP_PMU)
  */
diff --git a/include/linux/bcma/bcma_regs.h b/include/linux/bcma/bcma_regs.h
index 5a71d57..a393e82 100644
--- a/include/linux/bcma/bcma_regs.h
+++ b/include/linux/bcma/bcma_regs.h
@@ -11,11 +11,13 @@
 #define  BCMA_CLKCTLST_HAVEHTREQ	0x00000010 /* HT available request */
 #define  BCMA_CLKCTLST_HWCROFF		0x00000020 /* Force HW clock request off */
 #define  BCMA_CLKCTLST_EXTRESREQ	0x00000700 /* Mask of external resource requests */
+#define  BCMA_CLKCTLST_EXTRESREQ_SHIFT	8
 #define  BCMA_CLKCTLST_HAVEALP		0x00010000 /* ALP available */
 #define  BCMA_CLKCTLST_HAVEHT		0x00020000 /* HT available */
 #define  BCMA_CLKCTLST_BP_ON_ALP	0x00040000 /* RO: running on ALP clock */
 #define  BCMA_CLKCTLST_BP_ON_HT		0x00080000 /* RO: running on HT clock */
 #define  BCMA_CLKCTLST_EXTRESST		0x07000000 /* Mask of external resource status */
+#define  BCMA_CLKCTLST_EXTRESST_SHIFT	24
 /* Is there any BCM4328 on BCMA bus? */
 #define  BCMA_CLKCTLST_4328A0_HAVEHT	0x00010000 /* 4328a0 has reversed bits */
 #define  BCMA_CLKCTLST_4328A0_HAVEALP	0x00020000 /* 4328a0 has reversed bits */
-- 
1.7.7

