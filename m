Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:33962 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3A3HrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 02:47:03 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so620106eei.7
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2013 23:47:02 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: Xflash: reorder includes to make pr_fmt work
Date: Wed, 30 Jan 2013 08:46:53 +0100
Message-Id: <1359532013-10276-1-git-send-email-zajec5@gmail.com> (sfid-20130130_084708_956013_97FE45DB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon_nflash.c |    4 ++--
 drivers/bcma/driver_chipcommon_sflash.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_nflash.c b/drivers/bcma/driver_chipcommon_nflash.c
index dbda91e..19fafcf 100644
--- a/drivers/bcma/driver_chipcommon_nflash.c
+++ b/drivers/bcma/driver_chipcommon_nflash.c
@@ -5,11 +5,11 @@
  * Licensed under the GNU/GPL. See COPYING for details.
  */
 
+#include "bcma_private.h"
+
 #include <linux/platform_device.h>
 #include <linux/bcma/bcma.h>
 
-#include "bcma_private.h"
-
 struct platform_device bcma_nflash_dev = {
 	.name		= "bcma_nflash",
 	.num_resources	= 0,
diff --git a/drivers/bcma/driver_chipcommon_sflash.c b/drivers/bcma/driver_chipcommon_sflash.c
index 1e694db..e6ed4fe 100644
--- a/drivers/bcma/driver_chipcommon_sflash.c
+++ b/drivers/bcma/driver_chipcommon_sflash.c
@@ -5,11 +5,11 @@
  * Licensed under the GNU/GPL. See COPYING for details.
  */
 
+#include "bcma_private.h"
+
 #include <linux/platform_device.h>
 #include <linux/bcma/bcma.h>
 
-#include "bcma_private.h"
-
 static struct resource bcma_sflash_resource = {
 	.name	= "bcma_sflash",
 	.start	= BCMA_SOC_FLASH2,
-- 
1.7.10.4

