Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34889 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbbI3Iw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 04:52:27 -0400
Received: by pacfv12 with SMTP id fv12so35163501pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2015 01:52:27 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH] staging: wilc1000: fix build error for openrisc-allmodconfig
Date: Wed, 30 Sep 2015 17:52:14 +0900
Message-Id: <1443603134-11582-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150930_105235_886576_FB142A8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kbuild test robot reports the following build error for
openrisc-allmodconfig.

>> drivers/staging/wilc1000/wilc_sdio.c:584:2: error: implicit
>> declaration of function 'memset'

The error occurs due to missing a standard header file as
<linux/string.h> so that three .c files are included it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_sdio.c     | 1 +
 drivers/staging/wilc1000/wilc_spi.c      | 1 +
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 6da65e8..6e28ca0 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -7,6 +7,7 @@
 /*  */
 /* //////////////////////////////////////////////////////////////////////////// */
 
+#include <linux/string.h>
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index f762770..0e06fc2 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -7,6 +7,7 @@
 /*  */
 /* //////////////////////////////////////////////////////////////////////////// */
 
+#include <linux/string.h>
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 73a1508..d761a37 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -7,6 +7,7 @@
 /*  */
 /* ///////////////////////////////////////////////////////////////////////// */
 
+#include <linux/string.h>
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 #include "wilc_wlan_cfg.h"
-- 
2.6.0

