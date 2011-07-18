Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:41224 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab1GQXWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 19:22:52 -0400
Received: by fxd18 with SMTP id 18so5569858fxd.11
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 16:22:51 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] bcma: define IO status register
Date: Mon, 18 Jul 2011 02:01:28 +0200
Message-Id: <1310947290-3099-1-git-send-email-zajec5@gmail.com> (sfid-20110718_012255_787031_13AE6EB9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 include/linux/bcma/bcma_regs.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/bcma/bcma_regs.h b/include/linux/bcma/bcma_regs.h
index 3e0a27f..9faae2a 100644
--- a/include/linux/bcma/bcma_regs.h
+++ b/include/linux/bcma/bcma_regs.h
@@ -21,12 +21,18 @@
 #define  BCMA_CLKCTLST_4328A0_HAVEALP	0x00020000 /* 4328a0 has reversed bits */
 
 /* Agent registers (common for every core) */
-#define BCMA_IOCTL			0x0408
+#define BCMA_IOCTL			0x0408 /* IO control */
 #define  BCMA_IOCTL_CLK			0x0001
 #define  BCMA_IOCTL_FGC			0x0002
 #define  BCMA_IOCTL_CORE_BITS		0x3FFC
 #define  BCMA_IOCTL_PME_EN		0x4000
 #define  BCMA_IOCTL_BIST_EN		0x8000
+#define BCMA_IOST			0x0500 /* IO status */
+#define  BCMA_IOST_CORE_BITS		0x0FFF
+#define  BCMA_IOST_DMA64		0x1000
+#define  BCMA_IOST_GATED_CLK		0x2000
+#define  BCMA_IOST_BIST_ERROR		0x4000
+#define  BCMA_IOST_BIST_DONE		0x8000
 #define BCMA_RESET_CTL			0x0800
 #define  BCMA_RESET_CTL_RESET		0x0001
 
-- 
1.7.3.4

