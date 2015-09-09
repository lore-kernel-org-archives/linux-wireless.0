Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:51459 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbbIIHII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 03:08:08 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/4] staging: wilc1000: delete wilc_oswrapper.h and wilc_platform.h
Date: Wed, 9 Sep 2015 16:08:12 +0900
Message-ID: <1441782493-11338-3-git-send-email-tony.cho@atmel.com> (sfid-20150909_090811_677824_915631E4)
In-Reply-To: <1441782493-11338-1-git-send-email-tony.cho@atmel.com>
References: <1441782493-11338-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

wilc1000 driver runs on Linux. No need to have oswrapper or platform
dependent files.
Before delete two header files, move two structures in wilc_platform.h to
wilc_msgqueue.h where it is used. Include linux header files where is needs
since wilc_platform is deleted.
Finally, remove wilc_oswrapper.h and wilc_platform.h.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c |  1 +
 drivers/staging/wilc1000/host_interface.c   |  3 ++
 drivers/staging/wilc1000/host_interface.h   |  1 +
 drivers/staging/wilc1000/wilc_msgqueue.c    |  1 +
 drivers/staging/wilc1000/wilc_msgqueue.h    | 16 +++++++++-
 drivers/staging/wilc1000/wilc_oswrapper.h   | 25 ---------------
 drivers/staging/wilc1000/wilc_platform.h    | 48 -----------------------------
 drivers/staging/wilc1000/wilc_wlan.h        |  3 --
 drivers/staging/wilc1000/wilc_wlan_if.h     |  5 ++-
 9 files changed, 23 insertions(+), 80 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_oswrapper.h
 delete mode 100644 drivers/staging/wilc1000/wilc_platform.h

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 1889195..58e6108 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -13,6 +13,7 @@
 /* File Includes                                                             */
 /*****************************************************************************/
 #include "coreconfigurator.h"
+#include <linux/slab.h>
 /*****************************************************************************/
 /* Constants                                                                 */
 /*****************************************************************************/
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 59a1a9d..e1fccb3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1,5 +1,8 @@
 #include "host_interface.h"
 #include "coreconfigurator.h"
+#include "wilc_msgqueue.h"
+#include <linux/kthread.h>
+#include <linux/delay.h>
 
 extern s32 TransportInit(void);
 extern s32 TransportDeInit(void);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index a107377..96bc9a5 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -11,6 +11,7 @@
 #define HOST_INT_H
 
 #include "coreconfigurator.h"
+#include <linux/slab.h>
 /*****************************************************************************/
 /*								Macros                                       */
 /*****************************************************************************/
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 0a49cbe..59e1a0d 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -1,6 +1,7 @@
 
 #include "wilc_msgqueue.h"
 #include <linux/spinlock.h>
+#include <linux/slab.h>
 
 /*!
  *  @author		syounan
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index fb26463..5e73211 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -10,9 +10,23 @@
  *  @version	1.0
  */
 
-#include "wilc_platform.h"
+#include <linux/semaphore.h>
 #include "wilc_errorsupport.h"
 
+typedef struct __Message_struct {
+	void *pvBuffer;
+	u32 u32Length;
+	struct __Message_struct *pstrNext;
+} Message;
+
+typedef struct __MessageQueue_struct {
+	struct semaphore hSem;
+	spinlock_t strCriticalSection;
+	bool bExiting;
+	u32 u32ReceiversCount;
+	Message *pstrMessageList;
+} WILC_MsgQueueHandle;
+
 /*!
  *  @brief		Creates a new Message queue
  *  @details		Creates a new Message queue, if the feature
diff --git a/drivers/staging/wilc1000/wilc_oswrapper.h b/drivers/staging/wilc1000/wilc_oswrapper.h
deleted file mode 100644
index 68f6efe..0000000
--- a/drivers/staging/wilc1000/wilc_oswrapper.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef __WILC_OSWRAPPER_H__
-#define __WILC_OSWRAPPER_H__
-
-/*!
- *  @file	wilc_oswrapper.h
- *  @brief	Top level OS Wrapper, include this file and it will include all
- *              other files as necessary
- *  @author	syounan
- *  @date	10 Aug 2010
- *  @version	1.0
- */
-
-/* OS Wrapper interface version */
-#define WILC_OSW_INTERFACE_VER 2
-
-/* Os Configuration File */
-#include "wilc_platform.h"
-
-/* Error reporting and handling support */
-#include "wilc_errorsupport.h"
-
-/* Message Queue */
-#include "wilc_msgqueue.h"
-
-#endif
diff --git a/drivers/staging/wilc1000/wilc_platform.h b/drivers/staging/wilc1000/wilc_platform.h
deleted file mode 100644
index 1e56973..0000000
--- a/drivers/staging/wilc1000/wilc_platform.h
+++ /dev/null
@@ -1,48 +0,0 @@
-#ifndef __WILC_platform_H__
-#define __WILC_platform_H__
-
-#include <linux/kthread.h>
-#include <linux/semaphore.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/types.h>
-#include <linux/stat.h>
-#include <linux/time.h>
-#include <linux/version.h>
-#include "linux/string.h"
-/******************************************************************
- *      OS specific types
- *******************************************************************/
-
-/* Message Queue type is a structure */
-typedef struct __Message_struct {
-	void *pvBuffer;
-	u32 u32Length;
-	struct __Message_struct *pstrNext;
-} Message;
-
-typedef struct __MessageQueue_struct {
-	struct semaphore hSem;
-	spinlock_t strCriticalSection;
-	bool bExiting;
-	u32 u32ReceiversCount;
-	Message *pstrMessageList;
-} WILC_MsgQueueHandle;
-
-
-
-/*Time represented in 64 bit format*/
-typedef time_t WILC_Time;
-
-
-/*******************************************************************
- *      others
- ********************************************************************/
-
-/* Generic printf function */
-#define __WILC_FILE__		__FILE__
-#define __WILC_FUNCTION__	__func__
-#define __WILC_LINE__		__LINE__
-#endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 99e07de..7cf3d00 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -1,9 +1,6 @@
 #ifndef WILC_WLAN_H
 #define WILC_WLAN_H
 
-#include "wilc_oswrapper.h"
-
-
 #define ISWILC1000(id)   (((id & 0xfffff000) == 0x100000) ? 1 : 0)
 
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 9f9f4a9..f9e5fe2 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -17,9 +17,8 @@
 #define TCP_ENHANCEMENTS
 /* #define MEMORY_STATIC */
 /* #define USE_OLD_SPI_SW */
-
-
-#include "wilc_oswrapper.h"
+#include <linux/semaphore.h>
+#include "wilc_errorsupport.h"
 #include "linux_wlan_common.h"
 
 
-- 
1.9.1

