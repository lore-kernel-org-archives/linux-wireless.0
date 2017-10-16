Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:53670 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752546AbdJPMyq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 08:54:46 -0400
Received: by mail-lf0-f68.google.com with SMTP id l23so16869637lfk.10
        for <linux-wireless@vger.kernel.org>; Mon, 16 Oct 2017 05:54:45 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] bcma: use bcma_debug and pr_cont in MIPS driver
Date: Mon, 16 Oct 2017 14:54:32 +0200
Message-Id: <20171016125432.11655-1-zajec5@gmail.com> (sfid-20171016_145451_454211_7F477762)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Using bcma_debug gives a device-specific prefix for messages and pr_cont
is a common helper for continuing a line.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/bcma/driver_mips.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 89af807cf29c..5904ef1aa624 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -184,10 +184,11 @@ static void bcma_core_mips_print_irq(struct bcma_device *dev, unsigned int irq)
 {
 	int i;
 	static const char *irq_name[] = {"2(S)", "3", "4", "5", "6", "D", "I"};
-	printk(KERN_DEBUG KBUILD_MODNAME ": core 0x%04x, irq :", dev->id.id);
+
+	bcma_debug(dev->bus, "core 0x%04x, irq :", dev->id.id);
 	for (i = 0; i <= 6; i++)
-		printk(" %s%s", irq_name[i], i == irq ? "*" : " ");
-	printk("\n");
+		pr_cont(" %s%s", irq_name[i], i == irq ? "*" : " ");
+	pr_cont("\n");
 }
 
 static void bcma_core_mips_dump_irq(struct bcma_bus *bus)
-- 
2.11.0
