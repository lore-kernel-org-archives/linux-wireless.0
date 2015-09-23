Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33278 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbbIWJEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 05:04:10 -0400
Received: by pacex6 with SMTP id ex6so35319022pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2015 02:04:10 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 5/6] staging: wilc1000: remove wilc_platform include file
Date: Wed, 23 Sep 2015 18:03:49 +0900
Message-Id: <1442999030-31934-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150923_110418_591208_3E315D25)
In-Reply-To: <1442999030-31934-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442999030-31934-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes wilc_platform.h include file in wilc_oswrapper.h
Because wilc_platform.h have several standard header files so that some
header file should be included .c file to avoid compilation errors.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 1 +
 drivers/staging/wilc1000/host_interface.c   | 4 ++++
 drivers/staging/wilc1000/wilc_oswrapper.h   | 2 --
 drivers/staging/wilc1000/wilc_wlan_if.h     | 2 +-
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 68e3c7f..34a6c10 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -12,6 +12,7 @@
 #include "coreconfigurator.h"
 #include "wilc_wlan_if.h"
 #include <linux/errno.h>
+#include <linux/slab.h>
 #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
 							BEACON_INTERVAL_LEN + CAP_INFO_LEN)
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 49f3de9..0dd7639 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1,3 +1,7 @@
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/kthread.h>
+#include <linux/delay.h>
 #include "host_interface.h"
 #include "coreconfigurator.h"
 #include "wilc_wlan_if.h"
diff --git a/drivers/staging/wilc1000/wilc_oswrapper.h b/drivers/staging/wilc1000/wilc_oswrapper.h
index 5456c96..10d16e9 100644
--- a/drivers/staging/wilc1000/wilc_oswrapper.h
+++ b/drivers/staging/wilc1000/wilc_oswrapper.h
@@ -11,8 +11,6 @@
  */
 
 
-/* Os Configuration File */
-#include "wilc_platform.h"
 
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 668f1b8..fd37997 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -14,7 +14,7 @@
 /* #define MEMORY_STATIC */
 /* #define USE_OLD_SPI_SW */
 
-
+#include <linux/semaphore.h>
 #include "wilc_oswrapper.h"
 #include "linux_wlan_common.h"
 
-- 
2.5.1

