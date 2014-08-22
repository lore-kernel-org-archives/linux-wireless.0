Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48320 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaHVGp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 02:45:29 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so9698964wiv.13
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2014 23:45:28 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: only map wrapper if its address is available
Date: Fri, 22 Aug 2014 08:44:52 +0200
Message-Id: <1408689892-7617-1-git-send-email-zajec5@gmail.com> (sfid-20140822_084532_746021_D7609317)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hauke Mehrtens <hauke@hauke-m.de>

The Chipcommon B core does not have a wrap address and it would fail here.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/host_soc.c |  4 ++++
 drivers/bcma/scan.c     | 11 +++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/host_soc.c b/drivers/bcma/host_soc.c
index 3475e60..1edd7e0 100644
--- a/drivers/bcma/host_soc.c
+++ b/drivers/bcma/host_soc.c
@@ -134,12 +134,16 @@ static void bcma_host_soc_block_write(struct bcma_device *core,
 
 static u32 bcma_host_soc_aread32(struct bcma_device *core, u16 offset)
 {
+	if (WARN_ONCE(!core->io_wrap, "Accessed core has no wrapper/agent\n"))
+		return ~0;
 	return readl(core->io_wrap + offset);
 }
 
 static void bcma_host_soc_awrite32(struct bcma_device *core, u16 offset,
 				  u32 value)
 {
+	if (WARN_ONCE(!core->io_wrap, "Accessed core has no wrapper/agent\n"))
+		return;
 	writel(value, core->io_wrap + offset);
 }
 
diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index b4764c6..e9bd772 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -421,10 +421,13 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		core->io_addr = ioremap_nocache(core->addr, BCMA_CORE_SIZE);
 		if (!core->io_addr)
 			return -ENOMEM;
-		core->io_wrap = ioremap_nocache(core->wrap, BCMA_CORE_SIZE);
-		if (!core->io_wrap) {
-			iounmap(core->io_addr);
-			return -ENOMEM;
+		if (core->wrap) {
+			core->io_wrap = ioremap_nocache(core->wrap,
+							BCMA_CORE_SIZE);
+			if (!core->io_wrap) {
+				iounmap(core->io_addr);
+				return -ENOMEM;
+			}
 		}
 	}
 	return 0;
-- 
1.8.4.5

