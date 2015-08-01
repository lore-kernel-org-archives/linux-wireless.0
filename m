Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:47424 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbbHAN7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2015 09:59:42 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?=
	<clement.perrochaud@effinnov.com>
Cc: Charles Gorand <charles.gorand@effinnov.com>,
	linux-nfc@lists.01.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] NFC: nxp-nci: Include unaligned.h instead of access_ok.h
Date: Sat,  1 Aug 2015 06:59:29 -0700
Message-Id: <1438437569-31472-1-git-send-email-linux@roeck-us.net> (sfid-20150801_155958_580222_2A8E1E7F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Directly including access_ok.h can result in the following compile errors
if an architecture such as ia64 does not support direct unaligned accesses.

include/linux/unaligned/access_ok.h:7:19: error:
	redefinition of 'get_unaligned_le16'
include/linux/unaligned/le_struct.h:6:19: note:
	previous definition of 'get_unaligned_le16' was here
include/linux/unaligned/access_ok.h:12:19: error:
	redefinition of 'get_unaligned_le32'
include/linux/unaligned/le_struct.h:11:19: note:
	previous definition of 'get_unaligned_le32' was here

Include asm/unaligned.h instead and let the architecture decide which
access functions to use.

Cc: Clément Perrochaud <clement.perrochaud@effinnov.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/nfc/nxp-nci/firmware.c | 2 +-
 drivers/nfc/nxp-nci/i2c.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nxp-nci/firmware.c b/drivers/nfc/nxp-nci/firmware.c
index 5291797324ba..553011f58339 100644
--- a/drivers/nfc/nxp-nci/firmware.c
+++ b/drivers/nfc/nxp-nci/firmware.c
@@ -24,7 +24,7 @@
 #include <linux/completion.h>
 #include <linux/firmware.h>
 #include <linux/nfc.h>
-#include <linux/unaligned/access_ok.h>
+#include <asm/unaligned.h>
 
 #include "nxp-nci.h"
 
diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 2f77f1d03638..5907e7a727a1 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -36,7 +36,7 @@
 #include <linux/of_gpio.h>
 #include <linux/of_irq.h>
 #include <linux/platform_data/nxp-nci.h>
-#include <linux/unaligned/access_ok.h>
+#include <asm/unaligned.h>
 
 #include <net/nfc/nfc.h>
 
-- 
2.1.4

