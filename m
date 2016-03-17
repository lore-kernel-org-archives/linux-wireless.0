Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:49494 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251AbcCQJUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 05:20:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] bcma: fix building without OF_IRQ
Date: Thu, 17 Mar 2016 10:20:20 +0100
Message-Id: <1458206432-3039552-1-git-send-email-arnd@arndb.de> (sfid-20160317_102106_024427_CAB28D55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bcma driver core can be built with or without DT support, but
it fails to build when CONFIG_OF=y and CONFIG_OF_IRQ=n, which
can happen on platforms that do not support IRQ domains.

ERROR: "irq_create_of_mapping" [drivers/bcma/bcma.ko] undefined!
ERROR: "of_irq_parse_raw" [drivers/bcma/bcma.ko] undefined!
ERROR: "of_irq_parse_one" [drivers/bcma/bcma.ko] undefined!

This adds another compile-time check for OF_IRQ, but also
gets rid of now unneeded #ifdef checks: Using the simpler
IS_ENABLED() check for OF_IRQ also covers the case of not
having CONFIG_OF enabled. The check for CONFIG_OF_ADDRESS
was added to allow building on architectures without
OF_ADDRESS, but that has been addressed already in
b1d06b60e90c ("of: Provide static inline function for
of_translate_address if needed").

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/bcma/main.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 786be8fed39e..1f635471f318 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -136,7 +136,6 @@ static bool bcma_is_core_needed_early(u16 core_id)
 	return false;
 }
 
-#if defined(CONFIG_OF) && defined(CONFIG_OF_ADDRESS)
 static struct device_node *bcma_of_find_child_device(struct platform_device *parent,
 						     struct bcma_device *core)
 {
@@ -184,7 +183,7 @@ static unsigned int bcma_of_get_irq(struct platform_device *parent,
 	struct of_phandle_args out_irq;
 	int ret;
 
-	if (!parent || !parent->dev.of_node)
+	if (!IS_ENABLED(CONFIG_OF_IRQ) || !parent || !parent->dev.of_node)
 		return 0;
 
 	ret = bcma_of_irq_parse(parent, core, &out_irq, num);
@@ -202,23 +201,15 @@ static void bcma_of_fill_device(struct platform_device *parent,
 {
 	struct device_node *node;
 
+	if (!IS_ENABLED(CONFIG_OF_IRQ))
+		return;
+
 	node = bcma_of_find_child_device(parent, core);
 	if (node)
 		core->dev.of_node = node;
 
 	core->irq = bcma_of_get_irq(parent, core, 0);
 }
-#else
-static void bcma_of_fill_device(struct platform_device *parent,
-				struct bcma_device *core)
-{
-}
-static inline unsigned int bcma_of_get_irq(struct platform_device *parent,
-					   struct bcma_device *core, int num)
-{
-	return 0;
-}
-#endif /* CONFIG_OF */
 
 unsigned int bcma_core_irq(struct bcma_device *core, int num)
 {
-- 
2.7.0

