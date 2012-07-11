Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39371 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2GKKhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 06:37:31 -0400
Received: by wibhm11 with SMTP id hm11so5557165wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2012 03:37:30 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] bcma: add new cores at the end of list
Date: Wed, 11 Jul 2012 12:37:00 +0200
Message-Id: <1342003020-18255-1-git-send-email-zajec5@gmail.com> (sfid-20120711_123734_684714_B86BDF5B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes order in list more natural and fixes core->core_unit for more
than 2 cores.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: fix bcma_bus_scan_early as well
---
 drivers/bcma/scan.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 3bc3ec2..5672b13 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -491,7 +491,7 @@ int bcma_bus_scan(struct bcma_bus *bus)
 			  core->id.manuf, core->id.id, core->id.rev,
 			  core->id.class);
 
-		list_add(&core->list, &bus->cores);
+		list_add_tail(&core->list, &bus->cores);
 	}
 
 	if (bus->hosttype == BCMA_HOSTTYPE_SOC)
@@ -546,7 +546,7 @@ int __init bcma_bus_scan_early(struct bcma_bus *bus,
 			  core->id.manuf, core->id.id, core->id.rev,
 			  core->id.class);
 
-		list_add(&core->list, &bus->cores);
+		list_add_tail(&core->list, &bus->cores);
 		err = 0;
 		break;
 	}
-- 
1.7.7

