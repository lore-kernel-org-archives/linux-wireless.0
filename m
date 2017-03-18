Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:49750 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751391AbdCRSXn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Mar 2017 14:23:43 -0400
From: Sergei Trofimovich <slyfox@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
        Charles Gorand <charles.gorand@effinnov.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org
Subject: [PATCH] nfc: ia64: fix redefinition of 'put_unaligned_be64'
Date: Sat, 18 Mar 2017 18:21:03 +0000
Message-Id: <20170318182103.10965-1-slyfox@gentoo.org> (sfid-20170318_192429_554340_1C022AFC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ia64 allmodconfig build failed as:

  In file included from /home/slyfox/linux-2.6/drivers/nfc/nxp-nci/i2c.c:39:0:
  linux/include/linux/unaligned/access_ok.h:62:29: error: redefinition of 'put_unaligned_be64'
   static __always_inline void put_unaligned_be64(u64 val, void *p)
                               ^
  In file included from linux/arch/ia64/include/asm/unaligned.h:5:0,
  ...
  linux/include/linux/unaligned/be_byteshift.h:65:20: note: previous definition of 'put_unaligned_be64' was here
   static inline void put_unaligned_be64(u64 val, void *p)
                      ^

The error here is the inclusion of
    #include <linux/unaligned/access_ok.h>
header instead of
    #include <linux/uaccess.h>
for unaligned helpers.

CC: Charles Gorand <charles.gorand@effinnov.com>
CC: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: linux-nfc@lists.01.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 drivers/nfc/nfcmrvl/fw_dnld.c  | 2 +-
 drivers/nfc/nxp-nci/firmware.c | 2 +-
 drivers/nfc/nxp-nci/i2c.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.c
index f8dcdf4b24f6..b93b913e8983 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -17,7 +17,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/unaligned/access_ok.h>
+#include <linux/uaccess.h>
 #include <linux/firmware.h>
 #include <linux/nfc.h>
 #include <net/nfc/nci.h>
diff --git a/drivers/nfc/nxp-nci/firmware.c b/drivers/nfc/nxp-nci/firmware.c
index 5291797324ba..432f58fe327c 100644
--- a/drivers/nfc/nxp-nci/firmware.c
+++ b/drivers/nfc/nxp-nci/firmware.c
@@ -24,7 +24,7 @@
 #include <linux/completion.h>
 #include <linux/firmware.h>
 #include <linux/nfc.h>
-#include <linux/unaligned/access_ok.h>
+#include <linux/uaccess.h>
 
 #include "nxp-nci.h"
 
diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 36099e557730..a926be0d784e 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -36,7 +36,7 @@
 #include <linux/of_gpio.h>
 #include <linux/of_irq.h>
 #include <linux/platform_data/nxp-nci.h>
-#include <linux/unaligned/access_ok.h>
+#include <linux/uaccess.h>
 
 #include <net/nfc/nfc.h>
 
-- 
2.12.0
