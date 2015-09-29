Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34175 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbbI2XP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 19:15:56 -0400
Received: by padhy16 with SMTP id hy16so19099469pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2015 16:15:56 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/2] staging: wilc1000: remove wilc_platform include file
Date: Wed, 30 Sep 2015 08:15:41 +0900
Message-Id: <1443568542-15372-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150930_011600_352051_55896D34)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes wilc_platform.h include file in wilc_oswrapper.h
wilc_platform.h have several standard header files so that some header
files should be included to avoid compilation errors.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 1 +
 drivers/staging/wilc1000/host_interface.c   | 4 ++++
 drivers/staging/wilc1000/wilc_oswrapper.h   | 2 --
 drivers/staging/wilc1000/wilc_wlan_if.h     | 1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

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
index 99de804..bc990b3 100644
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
index 2d6e0ce..e4807ae 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -13,6 +13,7 @@
 /* #define MEMORY_STATIC */
 /* #define USE_OLD_SPI_SW */
 
+#include <linux/semaphore.h>
 #include "wilc_oswrapper.h"
 #include "linux_wlan_common.h"
 
-- 
2.5.1

