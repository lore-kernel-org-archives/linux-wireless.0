Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56166 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab2GKKdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 06:33:24 -0400
Received: by bkwj10 with SMTP id j10so892500bkw.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2012 03:33:22 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: add new cores at the end of list
Date: Wed, 11 Jul 2012 12:33:19 +0200
Message-Id: <1342002799-29158-1-git-send-email-zajec5@gmail.com> (sfid-20120711_123338_328568_00F094BA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes order in list more natural and fixes core->core_unit for more
than 2 cores.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 3bc3ec2..79e71a8 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -491,7 +491,7 @@ int bcma_bus_scan(struct bcma_bus *bus)
 			  core->id.manuf, core->id.id, core->id.rev,
 			  core->id.class);
 
-		list_add(&core->list, &bus->cores);
+		list_add_tail(&core->list, &bus->cores);
 	}
 
 	if (bus->hosttype == BCMA_HOSTTYPE_SOC)
-- 
1.7.7

