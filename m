Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:39793 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbbISMnz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Sep 2015 08:43:55 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: kvalo@codeaurora.org
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: add support for population subnodes also when build as module
Date: Sat, 19 Sep 2015 14:43:50 +0200
Message-Id: <1442666630-19087-1-git-send-email-hauke@hauke-m.de> (sfid-20150919_144421_654943_0A839B49)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

of_default_bus_match_table was not exported earlier, so it could only
be accessed by code compiled into the kernel. A new function
of_platform_default_populate() was added which uses
of_default_bus_match_table and this function is also exported. This way
it is possible to create a bus with the content of
of_default_bus_match_table and we can remove the hacks from bcma.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/main.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 24882c1..59d8d0d 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -436,13 +436,8 @@ int bcma_bus_register(struct bcma_bus *bus)
 	}
 
 	dev = bcma_bus_get_host_dev(bus);
-	/* TODO: remove check for IS_BUILTIN(CONFIG_BCMA) check when
-	 * of_default_bus_match_table is exported or in some other way
-	 * accessible. This is just a temporary workaround.
-	 */
-	if (IS_BUILTIN(CONFIG_BCMA) && dev) {
-		of_platform_populate(dev->of_node, of_default_bus_match_table,
-				     NULL, dev);
+	if (dev) {
+		of_platform_default_populate(dev->of_node, NULL, dev);
 	}
 
 	/* Cores providing flash access go before SPROM init */
-- 
2.1.4

