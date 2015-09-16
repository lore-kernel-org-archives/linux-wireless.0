Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26958 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbbIPJgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 05:36:51 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 6/6] staging: wilc1000: remove wilc_errorsupport.h
Date: Wed, 16 Sep 2015 18:36:04 +0900
Message-ID: <1442396164-18728-7-git-send-email-tony.cho@atmel.com> (sfid-20150916_113653_496804_C188FB8F)
In-Reply-To: <1442396164-18728-1-git-send-email-tony.cho@atmel.com>
References: <1442396164-18728-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes the wilc_errorsupport.h which is not used anymore and
also deletes #include "wilc_errorsupport.h" from the source code.

In addition, adds linux_wlan_common.h file in the wilc_msgqueue.c file
in order to use PRINT macros defined in the linux_wlan_common.h file.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_errorsupport.h | 15 ---------------
 drivers/staging/wilc1000/wilc_msgqueue.c     |  1 +
 drivers/staging/wilc1000/wilc_msgqueue.h     |  1 -
 drivers/staging/wilc1000/wilc_oswrapper.h    |  3 ---
 4 files changed, 1 insertion(+), 19 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_errorsupport.h

diff --git a/drivers/staging/wilc1000/wilc_errorsupport.h b/drivers/staging/wilc1000/wilc_errorsupport.h
deleted file mode 100644
index b0babbd..0000000
--- a/drivers/staging/wilc1000/wilc_errorsupport.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef __WILC_ERRORSUPPORT_H__
-#define __WILC_ERRORSUPPORT_H__
-
-/*!
- *  @file		wilc_errorsupport.h
- *  @brief		Error reporting and handling support
- *  @author		syounan
- *  @sa			wilc_oswrapper.h top level OS wrapper file
- *  @date		10 Aug 2010
- *  @version		1.0
- */
-
-#include "linux_wlan_common.h"
-
-#endif
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 94a2d3d..225bb99 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -1,6 +1,7 @@
 
 #include "wilc_msgqueue.h"
 #include <linux/spinlock.h>
+#include "linux_wlan_common.h"
 #include <linux/errno.h>
 
 /*!
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index fb26463..a3c0bba 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -11,7 +11,6 @@
  */
 
 #include "wilc_platform.h"
-#include "wilc_errorsupport.h"
 
 /*!
  *  @brief		Creates a new Message queue
diff --git a/drivers/staging/wilc1000/wilc_oswrapper.h b/drivers/staging/wilc1000/wilc_oswrapper.h
index 68f6efe..9b5c23a 100644
--- a/drivers/staging/wilc1000/wilc_oswrapper.h
+++ b/drivers/staging/wilc1000/wilc_oswrapper.h
@@ -16,9 +16,6 @@
 /* Os Configuration File */
 #include "wilc_platform.h"
 
-/* Error reporting and handling support */
-#include "wilc_errorsupport.h"
-
 /* Message Queue */
 #include "wilc_msgqueue.h"
 
-- 
1.9.1

