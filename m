Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:43050 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3FQQel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 12:34:41 -0400
Received: by mail-ea0-f181.google.com with SMTP id a15so1986514eae.12
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 09:34:40 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: update core (en|dis)abling functions
Date: Mon, 17 Jun 2013 18:34:32 +0200
Message-Id: <1371486872-13251-1-git-send-email-zajec5@gmail.com> (sfid-20130617_183445_161243_8B4F64F4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Broadocm updated their code, this may be needed for newer hardware or
some corner cases.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/core.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
index 17b26ce..37a5ffe 100644
--- a/drivers/bcma/core.c
+++ b/drivers/bcma/core.c
@@ -9,6 +9,25 @@
 #include <linux/export.h>
 #include <linux/bcma/bcma.h>
 
+static bool bcma_core_wait_value(struct bcma_device *core, u16 reg, u32 mask,
+				 u32 value, int timeout)
+{
+	unsigned long deadline = jiffies + timeout;
+	u32 val;
+
+	do {
+		val = bcma_aread32(core, reg);
+		if ((val & mask) == value)
+			return true;
+		cpu_relax();
+		udelay(10);
+	} while (!time_after_eq(jiffies, deadline));
+
+	bcma_warn(core->bus, "Timeout waiting for register 0x%04X!\n", reg);
+
+	return false;
+}
+
 bool bcma_core_is_enabled(struct bcma_device *core)
 {
 	if ((bcma_aread32(core, BCMA_IOCTL) & (BCMA_IOCTL_CLK | BCMA_IOCTL_FGC))
@@ -25,13 +44,15 @@ void bcma_core_disable(struct bcma_device *core, u32 flags)
 	if (bcma_aread32(core, BCMA_RESET_CTL) & BCMA_RESET_CTL_RESET)
 		return;
 
-	bcma_awrite32(core, BCMA_IOCTL, flags);
-	bcma_aread32(core, BCMA_IOCTL);
-	udelay(10);
+	bcma_core_wait_value(core, BCMA_RESET_ST, ~0, 0, 300);
 
 	bcma_awrite32(core, BCMA_RESET_CTL, BCMA_RESET_CTL_RESET);
 	bcma_aread32(core, BCMA_RESET_CTL);
 	udelay(1);
+
+	bcma_awrite32(core, BCMA_IOCTL, flags);
+	bcma_aread32(core, BCMA_IOCTL);
+	udelay(10);
 }
 EXPORT_SYMBOL_GPL(bcma_core_disable);
 
@@ -43,6 +64,7 @@ int bcma_core_enable(struct bcma_device *core, u32 flags)
 	bcma_aread32(core, BCMA_IOCTL);
 
 	bcma_awrite32(core, BCMA_RESET_CTL, 0);
+	bcma_aread32(core, BCMA_RESET_CTL);
 	udelay(1);
 
 	bcma_awrite32(core, BCMA_IOCTL, (BCMA_IOCTL_CLK | flags));
-- 
1.7.10.4

