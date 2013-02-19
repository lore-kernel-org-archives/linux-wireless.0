Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:55014 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933491Ab3BSSgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 13:36:24 -0500
Received: by mail-we0-f175.google.com with SMTP id x8so5944570wey.6
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2013 10:36:22 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: ignore extra GMAC cores on BCM4706
Date: Tue, 19 Feb 2013 19:36:14 +0100
Message-Id: <1361298974-4392-1-git-send-email-zajec5@gmail.com> (sfid-20130219_193628_277252_3F5362CB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This was noticed on two BCM4706 SoCs (the second core wasn't connected
to anything or working correctly). It matches the Broadcom's code from
hndpci.c file.
---
 drivers/bcma/main.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 9a6188a..fbf56b3 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -120,6 +120,10 @@ static int bcma_register_cores(struct bcma_bus *bus)
 			continue;
 		}
 
+		if (core->id.id == BCMA_CORE_4706_MAC_GBIT &&
+		    core->core_unit > 0)
+			continue;
+
 		core->dev.release = bcma_release_core_dev;
 		core->dev.bus = &bcma_bus_type;
 		dev_set_name(&core->dev, "bcma%d:%d", bus->num, dev_id);
-- 
1.7.10.4

