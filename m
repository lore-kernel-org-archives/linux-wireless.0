Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34609 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636Ab2HPUmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 16:42:38 -0400
Received: by ghrr11 with SMTP id r11so3397596ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Aug 2012 13:42:38 -0700 (PDT)
Date: Thu, 16 Aug 2012 15:42:30 -0500
From: "Saul St. John" <saul.stjohn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: [PATCH] bcma: don't leak memory for PCIE, MIPS, GBIT cores
Message-ID: <20120816204200.GA6573@eris.garyseven.net> (sfid-20120816_224242_343442_1929FBA6)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bcma_scan_bus allocates a bcma_core for each core found on the bus, but the
memory for cores handled by the bcma driver itself was not being freed when
the bus was unregistered. This patch adds special handling for the PCIE,
MIPS, and GBIT COMMON cores, to ensure that their memory allocation is
freed as well.

Note that this patch doesn't address the memory allocated for the CC core,
as that was corrected in my previous patch "bcma: register cc core driver,
device."

Cc: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Saul St. John <saul.stjohn@gmail.com>
---
 drivers/bcma/main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 498733b..ccc166e 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -214,7 +214,17 @@ int __devinit bcma_bus_register(struct bcma_bus *bus)
 
 void bcma_bus_unregister(struct bcma_bus *bus)
 {
+	struct bcma_device *cores[3];
+
+	cores[0] = bcma_find_core(bus, BCMA_CORE_MIPS_74K);
+	cores[1] = bcma_find_core(bus, BCMA_CORE_PCIE);
+	cores[2] = bcma_find_core(bus, BCMA_CORE_4706_MAC_GBIT_COMMON);
+
 	bcma_unregister_cores(bus);
+
+	kfree(cores[2]);
+	kfree(cores[1]);
+	kfree(cores[0]);
 }
 
 int __init bcma_bus_early_register(struct bcma_bus *bus,
-- 
1.7.10.4

