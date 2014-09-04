Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55497 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813AbaIDWTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 18:19:09 -0400
Received: by mail-wi0-f180.google.com with SMTP id ex7so1989984wid.7
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 15:19:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] bcma: register NAND and QSPI cores early
Date: Fri,  5 Sep 2014 00:18:49 +0200
Message-Id: <1409869129-15674-2-git-send-email-zajec5@gmail.com> (sfid-20140905_001913_847489_B0E2FFF4)
In-Reply-To: <1409869129-15674-1-git-send-email-zajec5@gmail.com>
References: <1409869129-15674-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Northstar (ARM arch) we will use MTD subsystem to access NVRAM and
SPROM. To get access to flash device we need to register these cores
first.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/main.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 9a86352..297a2d4 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -120,6 +120,17 @@ static void bcma_release_core_dev(struct device *dev)
 	kfree(core);
 }
 
+static bool bcma_is_core_needed_early(u16 core_id)
+{
+	switch (core_id) {
+	case BCMA_CORE_NS_NAND:
+	case BCMA_CORE_NS_QSPI:
+		return true;
+	}
+
+	return false;
+}
+
 static void bcma_register_core(struct bcma_bus *bus, struct bcma_device *core)
 {
 	int err;
@@ -170,6 +181,10 @@ static int bcma_register_devices(struct bcma_bus *bus)
 			continue;
 		}
 
+		/* Early cores were already registered */
+		if (bcma_is_core_needed_early(core->id.id))
+			continue;
+
 		/* Only first GMAC core on BCM4706 is connected and working */
 		if (core->id.id == BCMA_CORE_4706_MAC_GBIT &&
 		    core->core_unit > 0)
@@ -252,6 +267,12 @@ int bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_chipcommon_early_init(&bus->drv_cc);
 	}
 
+	/* Cores providing flash access go before SPROM init */
+	list_for_each_entry(core, &bus->cores, list) {
+		if (bcma_is_core_needed_early(core->id.id))
+			bcma_register_core(bus, core);
+	}
+
 	/* Try to get SPROM */
 	err = bcma_sprom_get(bus);
 	if (err == -ENOENT) {
-- 
1.8.4.5

