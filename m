Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:61734 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1GTRNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 13:13:37 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so2056296fxd.11
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 10:13:37 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Pavel Roskin <proski@gnu.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3 V3] bcma: inform drivers about translation bits needed for the core
Date: Wed, 20 Jul 2011 19:52:15 +0200
Message-Id: <1311184336-3633-2-git-send-email-zajec5@gmail.com> (sfid-20110720_191348_960649_C2893CA0)
In-Reply-To: <1311184336-3633-1-git-send-email-zajec5@gmail.com>
References: <1311184336-3633-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using DMA, drivers need to pass special translation info to the
hardware.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/core.c       |   16 ++++++++++++++++
 include/linux/bcma/bcma.h |    5 +++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
index 2d8506d..4a04a49 100644
--- a/drivers/bcma/core.c
+++ b/drivers/bcma/core.c
@@ -106,3 +106,19 @@ void bcma_core_pll_ctl(struct bcma_device *core, u32 req, u32 status, bool on)
 	}
 }
 EXPORT_SYMBOL_GPL(bcma_core_pll_ctl);
+
+u32 bcma_core_dma_translation(struct bcma_device *core)
+{
+	switch (core->bus->hosttype) {
+	case BCMA_HOSTTYPE_PCI:
+		if (bcma_aread32(core, BCMA_IOST) & BCMA_IOST_DMA64)
+			return BCMA_DMA_TRANSLATION_DMA64_CMT;
+		else
+			return BCMA_DMA_TRANSLATION_DMA32_CMT;
+	default:
+		pr_err("DMA translation unknown for host %d\n",
+		       core->bus->hosttype);
+	}
+	return BCMA_DMA_TRANSLATION_NONE;
+}
+EXPORT_SYMBOL(bcma_core_dma_translation);
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index cc1582d..8c96654 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -262,5 +262,10 @@ extern void bcma_core_set_clockmode(struct bcma_device *core,
 				    enum bcma_clkmode clkmode);
 extern void bcma_core_pll_ctl(struct bcma_device *core, u32 req, u32 status,
 			      bool on);
+#define BCMA_DMA_TRANSLATION_MASK	0xC0000000
+#define  BCMA_DMA_TRANSLATION_NONE	0x00000000
+#define  BCMA_DMA_TRANSLATION_DMA32_CMT	0x40000000 /* Client Mode Translation for 32-bit DMA */
+#define  BCMA_DMA_TRANSLATION_DMA64_CMT	0x80000000 /* Client Mode Translation for 64-bit DMA */
+extern u32 bcma_core_dma_translation(struct bcma_device *core);
 
 #endif /* LINUX_BCMA_H_ */
-- 
1.7.3.4

