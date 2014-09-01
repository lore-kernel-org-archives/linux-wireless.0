Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:64583 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaIAVL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 17:11:26 -0400
Received: by mail-wg0-f48.google.com with SMTP id n12so5891916wgh.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 14:11:25 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 2/2] bcma: use separated function to initialize bus on SoC
Date: Mon,  1 Sep 2014 23:11:07 +0200
Message-Id: <1409605867-30051-2-git-send-email-zajec5@gmail.com> (sfid-20140901_231133_304840_7E242E55)
In-Reply-To: <1409605867-30051-1-git-send-email-zajec5@gmail.com>
References: <1409605867-30051-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is required to split SoC bus init into two phases. The later one
(which includes scanning) should be called when kalloc is available.

Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: please note this patch touches arch/mips/bcm47xx/setup.c

This patches is a first step of simplifying MIPS booting process on
Broadcom SoCs. My research described in:
> Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
e-mail thread explained how we could get rid of all these early scanning
tricks. The main idea is to postpone bus initialization a bit and use
all standard calls then. So far we were doing it so early we had to
avoid kalloc.
---
 arch/mips/bcm47xx/setup.c     |  4 ++++
 drivers/bcma/host_soc.c       | 11 +++++++++--
 include/linux/bcma/bcma_soc.h |  1 +
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
index 2b63e7e..fff6ed4 100644
--- a/arch/mips/bcm47xx/setup.c
+++ b/arch/mips/bcm47xx/setup.c
@@ -202,6 +202,10 @@ static void __init bcm47xx_register_bcma(void)
 
 	err = bcma_host_soc_register(&bcm47xx_bus.bcma);
 	if (err)
+		panic("Failed to register BCMA bus (err %d)", err);
+
+	err = bcma_host_soc_init(&bcm47xx_bus.bcma);
+	if (err)
 		panic("Failed to initialize BCMA bus (err %d)", err);
 
 	bcm47xx_fill_bcma_boardinfo(&bcm47xx_bus.bcma.bus.boardinfo, NULL);
diff --git a/drivers/bcma/host_soc.c b/drivers/bcma/host_soc.c
index 379e0d4e..718e054 100644
--- a/drivers/bcma/host_soc.c
+++ b/drivers/bcma/host_soc.c
@@ -165,7 +165,6 @@ static const struct bcma_host_ops bcma_host_soc_ops = {
 int __init bcma_host_soc_register(struct bcma_soc *soc)
 {
 	struct bcma_bus *bus = &soc->bus;
-	int err;
 
 	/* iomap only first core. We have to read some register on this core
 	 * to scan the bus.
@@ -181,7 +180,15 @@ int __init bcma_host_soc_register(struct bcma_soc *soc)
 	/* Initialize struct, detect chip */
 	bcma_init_bus(bus);
 
-	/* Register */
+	return 0;
+}
+
+int __init bcma_host_soc_init(struct bcma_soc *soc)
+{
+	struct bcma_bus *bus = &soc->bus;
+	int err;
+
+	/* Scan bus and initialize it */
 	err = bcma_bus_early_register(bus, &soc->core_cc, &soc->core_mips);
 	if (err)
 		iounmap(bus->mmio);
diff --git a/include/linux/bcma/bcma_soc.h b/include/linux/bcma/bcma_soc.h
index 4203c55..f24d245 100644
--- a/include/linux/bcma/bcma_soc.h
+++ b/include/linux/bcma/bcma_soc.h
@@ -10,6 +10,7 @@ struct bcma_soc {
 };
 
 int __init bcma_host_soc_register(struct bcma_soc *soc);
+int __init bcma_host_soc_init(struct bcma_soc *soc);
 
 int bcma_bus_register(struct bcma_bus *bus);
 
-- 
1.8.4.5

