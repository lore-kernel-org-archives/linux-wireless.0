Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5085 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1426440AbcBSKBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 05:01:04 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH 4/4] staging: wilc1000: removes linux_wlan_common.h file
Date: Fri, 19 Feb 2016 18:57:45 +0900
Message-ID: <1455875865-15505-4-git-send-email-leo.kim@atmel.com> (sfid-20160219_110115_533826_4FAD4133)
In-Reply-To: <1455875865-15505-1-git-send-email-leo.kim@atmel.com>
References: <1455875865-15505-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes linux_wlan_common.h file and also removes the following
preprocessor at files that include it:
 - #include 'linux_wlan_common.h'

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_mon.c         | 1 -
 drivers/staging/wilc1000/linux_wlan.c        | 1 -
 drivers/staging/wilc1000/linux_wlan_common.h | 3 ---
 drivers/staging/wilc1000/wilc_msgqueue.c     | 1 -
 drivers/staging/wilc1000/wilc_spi.c          | 1 -
 drivers/staging/wilc1000/wilc_wlan_if.h      | 1 -
 6 files changed, 8 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/linux_wlan_common.h

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 28e52eb..637233b 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -7,7 +7,6 @@
  *  @version	1.0
  */
 #include "wilc_wfi_cfgoperations.h"
-#include "linux_wlan_common.h"
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b0cd21b..4bf3440 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1,5 +1,4 @@
 #include "wilc_wfi_cfgoperations.h"
-#include "linux_wlan_common.h"
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
deleted file mode 100644
index 18d902b..0000000
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ /dev/null
@@ -1,3 +0,0 @@
-#ifndef LINUX_WLAN_COMMON_H
-#define LINUX_WLAN_COMMON_H
-#endif
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 780ddd3..6cb894e 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -1,7 +1,6 @@
 
 #include "wilc_msgqueue.h"
 #include <linux/spinlock.h>
-#include "linux_wlan_common.h"
 #include <linux/errno.h>
 #include <linux/slab.h>
 
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 2928712..83b6910 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -18,7 +18,6 @@
 #include <linux/spi/spi.h>
 #include <linux/of_gpio.h>
 
-#include "linux_wlan_common.h"
 #include <linux/string.h>
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index c33f7a6..fbe34eb 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -11,7 +11,6 @@
 #define WILC_WLAN_IF_H
 
 #include <linux/semaphore.h>
-#include "linux_wlan_common.h"
 #include <linux/netdevice.h>
 
 /********************************************
-- 
1.9.1

