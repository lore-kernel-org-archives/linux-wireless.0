Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:59340 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1GPQE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 12:04:58 -0400
Received: by fxd18 with SMTP id 18so4268723fxd.11
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jul 2011 09:04:57 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] bcma: move define of BCMA_CLKCTLST register
Date: Sat, 16 Jul 2011 18:43:36 +0200
Message-Id: <1310834616-3314-1-git-send-email-zajec5@gmail.com> (sfid-20110716_180501_728022_DE0DA45C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent experiments have shown many cores share 0x1E0 register used for
clock management.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Is this OK to move it this way? I prefer this over defining same names
for 3 different cores.
Do you have any better ideas?
---
 include/linux/bcma/bcma_driver_chipcommon.h |   10 +---------
 include/linux/bcma/bcma_regs.h              |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 9c5b69f..6e7b8b5 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -179,15 +179,7 @@
 #define BCMA_CC_PROG_WAITCNT		0x0124
 #define BCMA_CC_FLASH_CFG		0x0128
 #define BCMA_CC_FLASH_WAITCNT		0x012C
-#define BCMA_CC_CLKCTLST		0x01E0 /* Clock control and status (rev >= 20) */
-#define  BCMA_CC_CLKCTLST_FORCEALP	0x00000001 /* Force ALP request */
-#define  BCMA_CC_CLKCTLST_FORCEHT	0x00000002 /* Force HT request */
-#define  BCMA_CC_CLKCTLST_FORCEILP	0x00000004 /* Force ILP request */
-#define  BCMA_CC_CLKCTLST_HAVEALPREQ	0x00000008 /* ALP available request */
-#define  BCMA_CC_CLKCTLST_HAVEHTREQ	0x00000010 /* HT available request */
-#define  BCMA_CC_CLKCTLST_HWCROFF	0x00000020 /* Force HW clock request off */
-#define  BCMA_CC_CLKCTLST_HAVEHT	0x00010000 /* HT available */
-#define  BCMA_CC_CLKCTLST_HAVEALP	0x00020000 /* APL available */
+/* 0x1E0 is defined as shared BCMA_CLKCTLST */
 #define BCMA_CC_HW_WORKAROUND		0x01E4 /* Hardware workaround (rev >= 20) */
 #define BCMA_CC_UART0_DATA		0x0300
 #define BCMA_CC_UART0_IMR		0x0304
diff --git a/include/linux/bcma/bcma_regs.h b/include/linux/bcma/bcma_regs.h
index f82d88a..3e0a27f 100644
--- a/include/linux/bcma/bcma_regs.h
+++ b/include/linux/bcma/bcma_regs.h
@@ -1,6 +1,25 @@
 #ifndef LINUX_BCMA_REGS_H_
 #define LINUX_BCMA_REGS_H_
 
+/* Some single registers are shared between many cores */
+/* BCMA_CLKCTLST: ChipCommon (rev >= 20), PCIe, 80211 */
+#define BCMA_CLKCTLST			0x01E0 /* Clock control and status */
+#define  BCMA_CLKCTLST_FORCEALP		0x00000001 /* Force ALP request */
+#define  BCMA_CLKCTLST_FORCEHT		0x00000002 /* Force HT request */
+#define  BCMA_CLKCTLST_FORCEILP		0x00000004 /* Force ILP request */
+#define  BCMA_CLKCTLST_HAVEALPREQ	0x00000008 /* ALP available request */
+#define  BCMA_CLKCTLST_HAVEHTREQ	0x00000010 /* HT available request */
+#define  BCMA_CLKCTLST_HWCROFF		0x00000020 /* Force HW clock request off */
+#define  BCMA_CLKCTLST_EXTRESREQ	0x00000700 /* Mask of external resource requests */
+#define  BCMA_CLKCTLST_HAVEALP		0x00010000 /* ALP available */
+#define  BCMA_CLKCTLST_HAVEHT		0x00020000 /* HT available */
+#define  BCMA_CLKCTLST_BP_ON_ALP	0x00040000 /* RO: running on ALP clock */
+#define  BCMA_CLKCTLST_BP_ON_HT		0x00080000 /* RO: running on HT clock */
+#define  BCMA_CLKCTLST_EXTRESST		0x07000000 /* Mask of external resource status */
+/* Is there any BCM4328 on BCMA bus? */
+#define  BCMA_CLKCTLST_4328A0_HAVEHT	0x00010000 /* 4328a0 has reversed bits */
+#define  BCMA_CLKCTLST_4328A0_HAVEALP	0x00020000 /* 4328a0 has reversed bits */
+
 /* Agent registers (common for every core) */
 #define BCMA_IOCTL			0x0408
 #define  BCMA_IOCTL_CLK			0x0001
-- 
1.7.3.4

