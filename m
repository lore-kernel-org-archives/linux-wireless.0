Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33090 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdCCKlq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 05:41:46 -0500
Received: by mail-lf0-f67.google.com with SMTP id r36so7742404lfi.0
        for <linux-wireless@vger.kernel.org>; Fri, 03 Mar 2017 02:41:33 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.12] bcma: drop unneeded check for CONFIG_OF_IRQ
Date: Fri,  3 Mar 2017 11:33:30 +0100
Message-Id: <20170303103330.4914-1-zajec5@gmail.com> (sfid-20170303_114410_127151_31FE51A7)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

We already have the same check in bcma_of_get_irq which really calls
symbols available with CONFIG_OF_IRQ only. It appears this duplicated
check was accidentally added in commit c58d900cc96a ("bcma: fix building
without OF_IRQ"). The rest of code in bcma_of_fill_device should work
fine without CONFIG_OF_IRQ.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/bcma/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 2da7fe1d20a7..e6986c7608f1 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -201,9 +201,6 @@ static void bcma_of_fill_device(struct device *parent,
 {
 	struct device_node *node;
 
-	if (!IS_ENABLED(CONFIG_OF_IRQ))
-		return;
-
 	node = bcma_of_find_child_device(parent, core);
 	if (node)
 		core->dev.of_node = node;
-- 
2.11.0
