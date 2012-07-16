Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38877 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2GPJqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jul 2012 05:46:54 -0400
Received: by bkwj10 with SMTP id j10so4489980bkw.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jul 2012 02:46:52 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: cc: update defines
Date: Mon, 16 Jul 2012 11:46:52 +0200
Message-Id: <1342432012-25083-1-git-send-email-zajec5@gmail.com> (sfid-20120716_114658_332632_880769C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 include/linux/bcma/bcma_driver_chipcommon.h |   51 ++++++++++++++++++++++++++-
 1 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index fbd0d49..3c80885 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -24,7 +24,7 @@
 #define   BCMA_CC_FLASHT_NONE		0x00000000	/* No flash */
 #define   BCMA_CC_FLASHT_STSER		0x00000100	/* ST serial flash */
 #define   BCMA_CC_FLASHT_ATSER		0x00000200	/* Atmel serial flash */
-#define   BCMA_CC_FLASHT_NFLASH		0x00000200
+#define   BCMA_CC_FLASHT_NFLASH		0x00000200	/* NAND flash */
 #define	  BCMA_CC_FLASHT_PARA		0x00000700	/* Parallel flash */
 #define  BCMA_CC_CAP_PLLT		0x00038000	/* PLL Type */
 #define   BCMA_PLLTYPE_NONE		0x00000000
@@ -45,6 +45,7 @@
 #define  BCMA_CC_CAP_PMU		0x10000000	/* PMU available (rev >= 20) */
 #define  BCMA_CC_CAP_ECI		0x20000000	/* ECI available (rev >= 20) */
 #define  BCMA_CC_CAP_SPROM		0x40000000	/* SPROM present */
+#define  BCMA_CC_CAP_NFLASH		0x80000000	/* NAND flash present (rev >= 35 or BCM4706?) */
 #define BCMA_CC_CORECTL			0x0008
 #define  BCMA_CC_CORECTL_UARTCLK0	0x00000001	/* Drive UART with internal clock */
 #define	 BCMA_CC_CORECTL_SE		0x00000002	/* sync clk out enable (corerev >= 3) */
@@ -122,10 +123,58 @@
 #define  BCMA_CC_JCTL_EXT_EN		2		/* Enable external targets */
 #define  BCMA_CC_JCTL_EN		1		/* Enable Jtag master */
 #define BCMA_CC_FLASHCTL		0x0040
+/* Start/busy bit in flashcontrol */
+#define  BCMA_CC_FLASHCTL_OPCODE	0x000000ff
+#define  BCMA_CC_FLASHCTL_ACTION	0x00000700
+#define  BCMA_CC_FLASHCTL_CS_ACTIVE	0x00001000	/* Chip Select Active, rev >= 20 */
 #define  BCMA_CC_FLASHCTL_START		0x80000000
 #define  BCMA_CC_FLASHCTL_BUSY		BCMA_CC_FLASHCTL_START
+/* Flashcontrol action + opcodes for ST flashes */
+#define  BCMA_CC_FLASHCTL_ST_WREN	0x0006		/* Write Enable */
+#define  BCMA_CC_FLASHCTL_ST_WRDIS	0x0004		/* Write Disable */
+#define  BCMA_CC_FLASHCTL_ST_RDSR	0x0105		/* Read Status Register */
+#define  BCMA_CC_FLASHCTL_ST_WRSR	0x0101		/* Write Status Register */
+#define  BCMA_CC_FLASHCTL_ST_READ	0x0303		/* Read Data Bytes */
+#define  BCMA_CC_FLASHCTL_ST_PP		0x0302		/* Page Program */
+#define  BCMA_CC_FLASHCTL_ST_SE		0x02d8		/* Sector Erase */
+#define  BCMA_CC_FLASHCTL_ST_BE		0x00c7		/* Bulk Erase */
+#define  BCMA_CC_FLASHCTL_ST_DP		0x00b9		/* Deep Power-down */
+#define  BCMA_CC_FLASHCTL_ST_RES	0x03ab		/* Read Electronic Signature */
+#define  BCMA_CC_FLASHCTL_ST_CSA	0x1000		/* Keep chip select asserted */
+#define  BCMA_CC_FLASHCTL_ST_SSE	0x0220		/* Sub-sector Erase */
+/* Flashcontrol action + opcodes for Atmel flashes */
+#define  BCMA_CC_FLASHCTL_AT_READ			0x07e8
+#define  BCMA_CC_FLASHCTL_AT_PAGE_READ			0x07d2
+#define  BCMA_CC_FLASHCTL_AT_STATUS			0x01d7
+#define  BCMA_CC_FLASHCTL_AT_BUF1_WRITE			0x0384
+#define  BCMA_CC_FLASHCTL_AT_BUF2_WRITE			0x0387
+#define  BCMA_CC_FLASHCTL_AT_BUF1_ERASE_PROGRAM		0x0283
+#define  BCMA_CC_FLASHCTL_AT_BUF2_ERASE_PROGRAM		0x0286
+#define  BCMA_CC_FLASHCTL_AT_BUF1_PROGRAM		0x0288
+#define  BCMA_CC_FLASHCTL_AT_BUF2_PROGRAM		0x0289
+#define  BCMA_CC_FLASHCTL_AT_PAGE_ERASE			0x0281
+#define  BCMA_CC_FLASHCTL_AT_BLOCK_ERASE		0x0250
+#define  BCMA_CC_FLASHCTL_AT_BUF1_WRITE_ERASE_PROGRAM	0x0382
+#define  BCMA_CC_FLASHCTL_AT_BUF2_WRITE_ERASE_PROGRAM	0x0385
+#define  BCMA_CC_FLASHCTL_AT_BUF1_LOAD			0x0253
+#define  BCMA_CC_FLASHCTL_AT_BUF2_LOAD			0x0255
+#define  BCMA_CC_FLASHCTL_AT_BUF1_COMPARE		0x0260
+#define  BCMA_CC_FLASHCTL_AT_BUF2_COMPARE		0x0261
+#define  BCMA_CC_FLASHCTL_AT_BUF1_REPROGRAM		0x0258
+#define  BCMA_CC_FLASHCTL_AT_BUF2_REPROGRAM		0x0259
 #define BCMA_CC_FLASHADDR		0x0044
 #define BCMA_CC_FLASHDATA		0x0048
+/* Status register bits for ST flashes */
+#define  BCMA_CC_FLASHDATA_ST_WIP	0x01		/* Write In Progress */
+#define  BCMA_CC_FLASHDATA_ST_WEL	0x02		/* Write Enable Latch */
+#define  BCMA_CC_FLASHDATA_ST_BP_MASK	0x1c		/* Block Protect */
+#define  BCMA_CC_FLASHDATA_ST_BP_SHIFT	2
+#define  BCMA_CC_FLASHDATA_ST_SRWD	0x80		/* Status Register Write Disable */
+/* Status register bits for Atmel flashes */
+#define  BCMA_CC_FLASHDATA_AT_READY	0x80
+#define  BCMA_CC_FLASHDATA_AT_MISMATCH	0x40
+#define  BCMA_CC_FLASHDATA_AT_ID_MASK	0x38
+#define  BCMA_CC_FLASHDATA_AT_ID_SHIFT	3
 #define BCMA_CC_BCAST_ADDR		0x0050
 #define BCMA_CC_BCAST_DATA		0x0054
 #define BCMA_CC_GPIOPULLUP		0x0058		/* Rev >= 20 only */
-- 
1.7.7

