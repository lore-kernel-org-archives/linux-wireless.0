Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:45196 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbbFLKEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 06:04:10 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>
Subject: [PATCH v2] staging: wilc1000: remove oswrapper & type file
Date: Fri, 12 Jun 2015 19:03:02 +0900
Message-ID: <1434103382-4313-1-git-send-email-dean.lee@atmel.com> (sfid-20150612_120429_462859_B942E0D8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove OS Wrapper function(wilc_oswrapper.h) is in our plan.
i try removed OS Wrapper function and it's done.
and i found wilc_type.h file is does not used it.
so i deleted them and modify #include line in another file.

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
Change
 modify commit message.
---
 drivers/staging/wilc1000/coreconfigurator.h |  1 -
 drivers/staging/wilc1000/fifo_buffer.c      |  1 -
 drivers/staging/wilc1000/fifo_buffer.h      |  5 ++-
 drivers/staging/wilc1000/host_interface.c   |  1 -
 drivers/staging/wilc1000/wilc_log.h         | 53 ++++++++++++++++-------------
 drivers/staging/wilc1000/wilc_memory.c      |  2 +-
 drivers/staging/wilc1000/wilc_memory.h      |  4 ++-
 drivers/staging/wilc1000/wilc_msgqueue.c    |  2 +-
 drivers/staging/wilc1000/wilc_msgqueue.h    |  5 +++
 drivers/staging/wilc1000/wilc_oswrapper.h   | 41 ----------------------
 drivers/staging/wilc1000/wilc_sleep.c       |  2 +-
 drivers/staging/wilc1000/wilc_sleep.h       |  3 ++
 drivers/staging/wilc1000/wilc_strutils.c    |  2 +-
 drivers/staging/wilc1000/wilc_strutils.h    |  4 +++
 drivers/staging/wilc1000/wilc_timer.c       |  2 +-
 drivers/staging/wilc1000/wilc_timer.h       |  3 ++
 drivers/staging/wilc1000/wilc_type.h        | 34 ------------------
 drivers/staging/wilc1000/wilc_wlan.h        |  2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h     | 10 +++++-
 19 files changed, 67 insertions(+), 110 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_oswrapper.h
 delete mode 100644 drivers/staging/wilc1000/wilc_type.h

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 697ceb1..f2f6e64 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -12,7 +12,6 @@
 #ifndef CORECONFIGURATOR_H
 #define CORECONFIGURATOR_H
 
-#include "wilc_oswrapper.h"
 #include "wilc_wlan_if.h"
 /*****************************************************************************/
 /* Constants                                                                 */
diff --git a/drivers/staging/wilc1000/fifo_buffer.c b/drivers/staging/wilc1000/fifo_buffer.c
index c801406..b6c07cf 100644
--- a/drivers/staging/wilc1000/fifo_buffer.c
+++ b/drivers/staging/wilc1000/fifo_buffer.c
@@ -1,6 +1,5 @@
 
 
-#include "wilc_oswrapper.h"
 #include "fifo_buffer.h"
 
 
diff --git a/drivers/staging/wilc1000/fifo_buffer.h b/drivers/staging/wilc1000/fifo_buffer.h
index 57f7732..7b76998 100644
--- a/drivers/staging/wilc1000/fifo_buffer.h
+++ b/drivers/staging/wilc1000/fifo_buffer.h
@@ -1,5 +1,8 @@
 
-#include "wilc_oswrapper.h"
+#include <linux/types.h>
+#include <linux/semaphore.h>
+#include "wilc_memory.h"
+#include "wilc_strutils.h"
 
 
 #define tHANDLE	void *
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a1e90a5..60245b1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1,5 +1,4 @@
 #include "host_interface.h"
-#include "wilc_oswrapper.h"
 #include "itypes.h"
 #include "coreconfigurator.h"
 
diff --git a/drivers/staging/wilc1000/wilc_log.h b/drivers/staging/wilc1000/wilc_log.h
index 2269ebd..93f467a 100644
--- a/drivers/staging/wilc1000/wilc_log.h
+++ b/drivers/staging/wilc1000/wilc_log.h
@@ -2,46 +2,53 @@
 #define __WILC_LOG_H__
 
 /* Errors will always get printed */
-#define WILC_ERROR(...) do {  WILC_PRINTF("(ERR)(%s:%d) ", __WILC_FUNCTION__, __WILC_LINE__); \
-			      WILC_PRINTF(__VA_ARGS__); \
-				} while (0)
+#define WILC_ERROR(...)							\
+do {									\
+	WILC_PRINTF("(ERR)(%s:%d)", __WILC_FUNCTION__, __WILC_LINE__);	\
+	WILC_PRINTF(__VA_ARGS__);					\
+} while (0)
 
 /* Wraning only printed if verbosity is 1 or more */
 #if (WILC_LOG_VERBOSITY_LEVEL > 0)
-#define WILC_WARN(...) do { WILC_PRINTF("(WRN)"); \
-			    WILC_PRINTF(__VA_ARGS__); \
-				} while (0)
+#define WILC_WARN(...)				\
+do {						\
+	WILC_PRINTF("(WRN)");			\
+	WILC_PRINTF(__VA_ARGS__);		\
+} while (0)
 #else
-#define WILC_WARN(...) (0)
+#define WILC_WARN(...)	(0)
 #endif
 
 /* Info only printed if verbosity is 2 or more */
 #if (WILC_LOG_VERBOSITY_LEVEL > 1)
-#define WILC_INFO(...) do {  WILC_PRINTF("(INF)"); \
-			     WILC_PRINTF(__VA_ARGS__); \
-				} while (0)
+#define WILC_INFO(...)				\
+do {						\
+	WILC_PRINTF("(INF)");			\
+	WILC_PRINTF(__VA_ARGS__);		\
+} while (0)
 #else
-#define WILC_INFO(...) (0)
+#define WILC_INFO(...)	(0)
 #endif
 
 /* Debug is only printed if verbosity is 3 or more */
 #if (WILC_LOG_VERBOSITY_LEVEL > 2)
-#define WILC_DBG(...) do { WILC_PRINTF("(DBG)(%s:%d) ", __WILC_FUNCTION__, __WILC_LINE__); \
-			   WILC_PRINTF(__VA_ARGS__); \
-			} while (0)
-
+#define WILC_DBG(...)							\
+do {									\
+	WILC_PRINTF("(DBG)(%s:%d)", __WILC_FUNCTION__, __WILC_LINE__);	\
+	WILC_PRINTF(__VA_ARGS__);					\
+} while (0)
 #else
-#define WILC_DBG(...) (0)
+#define WILC_DBG(...)	(0)
 #endif
 
 /* Function In/Out is only printed if verbosity is 4 or more */
 #if (WILC_LOG_VERBOSITY_LEVEL > 3)
-#define WILC_FN_IN do { WILC_PRINTF("(FIN) (%s:%d) \n", __WILC_FUNCTION__, __WILC_LINE__);  } while (0)
-#define WILC_FN_OUT(ret) do { WILC_PRINTF("(FOUT) (%s:%d) %d.\n", __WILC_FUNCTION__, __WILC_LINE__, (ret));  } while (0)
+#define WILC_FN_IN		\
+	WILC_PRINTF("(FIN)(%s:%d)\n", __WILC_FUNCTION__, __WILC_LINE__)
+#define WILC_FN_OUT(ret)	\
+	WILC_PRINTF("(FOUT)(%s:%d)%d\n", __WILC_FUNCTION__, __WILC_LINE__, ret)
 #else
-#define WILC_FN_IN (0)
-#define WILC_FN_OUT(ret) (0)
+#define WILC_FN_IN		(0)
+#define WILC_FN_OUT(ret)	(0)
+#endif
 #endif
-
-
-#endif
\ No newline at end of file
diff --git a/drivers/staging/wilc1000/wilc_memory.c b/drivers/staging/wilc1000/wilc_memory.c
index 080fa61..ca6850c7 100644
--- a/drivers/staging/wilc1000/wilc_memory.c
+++ b/drivers/staging/wilc1000/wilc_memory.c
@@ -1,5 +1,5 @@
 
-#include "wilc_oswrapper.h"
+#include "wilc_memory.h"
 
 /*!
  *  @author	syounan
diff --git a/drivers/staging/wilc1000/wilc_memory.h b/drivers/staging/wilc1000/wilc_memory.h
index 93642d0..a7a80e5 100644
--- a/drivers/staging/wilc1000/wilc_memory.h
+++ b/drivers/staging/wilc1000/wilc_memory.h
@@ -10,6 +10,9 @@
  *  @version	1.0
  */
 
+#include <linux/types.h>
+#include <linux/slab.h>
+
 /*!
  *  @struct             tstrWILC_MemoryAttrs
  *  @brief		Memory API options
@@ -234,4 +237,3 @@ void WILC_MemoryFree(const void *pvBlock, tstrWILC_MemoryAttrs *strAttrs,
 
 
 #endif
-
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 04fe5a5..16bcef4 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -1,5 +1,5 @@
 
-#include "wilc_oswrapper.h"
+#include "wilc_msgqueue.h"
 #include <linux/spinlock.h>
 
 /*!
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 2ca02db..35b1001 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -10,6 +10,11 @@
  *  @version	1.0
  */
 
+#include "wilc_platform.h"
+#include "wilc_errorsupport.h"
+#include "wilc_memory.h"
+#include "wilc_strutils.h"
+
 /*!
  *  @struct             tstrWILC_MsgQueueAttrs
  *  @brief		Message Queue API options
diff --git a/drivers/staging/wilc1000/wilc_oswrapper.h b/drivers/staging/wilc1000/wilc_oswrapper.h
deleted file mode 100644
index e97aa96..0000000
--- a/drivers/staging/wilc1000/wilc_oswrapper.h
+++ /dev/null
@@ -1,41 +0,0 @@
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
-#include "wilc_osconfig.h"
-#include "wilc_platform.h"
-
-/* Logging Functions */
-#include "wilc_log.h"
-
-/* Error reporting and handling support */
-#include "wilc_errorsupport.h"
-
-/* Sleep support */
-#include "wilc_sleep.h"
-
-/* Timer support */
-#include "wilc_timer.h"
-
-/* Memory support */
-#include "wilc_memory.h"
-
-/* String Utilities */
-#include "wilc_strutils.h"
-
-/* Message Queue */
-#include "wilc_msgqueue.h"
-
-#endif
diff --git a/drivers/staging/wilc1000/wilc_sleep.c b/drivers/staging/wilc1000/wilc_sleep.c
index 569b833..adab3ca 100644
--- a/drivers/staging/wilc1000/wilc_sleep.c
+++ b/drivers/staging/wilc1000/wilc_sleep.c
@@ -1,5 +1,5 @@
 
-#include "wilc_oswrapper.h"
+#include "wilc_sleep.h"
 
 /*
  *  @author	mdaftedar
diff --git a/drivers/staging/wilc1000/wilc_sleep.h b/drivers/staging/wilc1000/wilc_sleep.h
index 261f4ed..cf9047f 100644
--- a/drivers/staging/wilc1000/wilc_sleep.h
+++ b/drivers/staging/wilc1000/wilc_sleep.h
@@ -1,6 +1,9 @@
 #ifndef __WILC_SLEEP_H__
 #define __WILC_SLEEP_H__
 
+#include <linux/types.h>
+#include <linux/delay.h>
+
 /*!
  *  @brief	forces the current thread to sleep until the given time has elapsed
  *  @param[in]	u32TimeMilliSec Time to sleep in Milli seconds
diff --git a/drivers/staging/wilc1000/wilc_strutils.c b/drivers/staging/wilc1000/wilc_strutils.c
index 19c561b..fa279808 100644
--- a/drivers/staging/wilc1000/wilc_strutils.c
+++ b/drivers/staging/wilc1000/wilc_strutils.c
@@ -1,7 +1,7 @@
 
 #define _CRT_SECURE_NO_DEPRECATE
 
-#include "wilc_oswrapper.h"
+#include "wilc_strutils.h"
 
 
 /*!
diff --git a/drivers/staging/wilc1000/wilc_strutils.h b/drivers/staging/wilc1000/wilc_strutils.h
index 936e8da..1e1be13 100644
--- a/drivers/staging/wilc1000/wilc_strutils.h
+++ b/drivers/staging/wilc1000/wilc_strutils.h
@@ -10,6 +10,10 @@
  *  @version	1.0
  */
 
+#include <linux/types.h>
+#include <linux/string.h>
+#include "wilc_errorsupport.h"
+
 /*!
  *  @brief	Compares two memory buffers
  *  @param[in]	pvArg1 pointer to the first memory location
diff --git a/drivers/staging/wilc1000/wilc_timer.c b/drivers/staging/wilc1000/wilc_timer.c
index c31bf0c..dc71157 100644
--- a/drivers/staging/wilc1000/wilc_timer.c
+++ b/drivers/staging/wilc1000/wilc_timer.c
@@ -1,5 +1,5 @@
 
-#include "wilc_oswrapper.h"
+#include "wilc_timer.h"
 
 WILC_ErrNo WILC_TimerCreate(WILC_TimerHandle *pHandle,
 	tpfWILC_TimerFunction pfCallback, tstrWILC_TimerAttrs *pstrAttrs)
diff --git a/drivers/staging/wilc1000/wilc_timer.h b/drivers/staging/wilc1000/wilc_timer.h
index a0f9154..931269d 100644
--- a/drivers/staging/wilc1000/wilc_timer.h
+++ b/drivers/staging/wilc1000/wilc_timer.h
@@ -10,6 +10,9 @@
  *  @version	1.0
  */
 
+#include "wilc_platform.h"
+#include "wilc_errorsupport.h"
+
 typedef void (*tpfWILC_TimerFunction)(void *);
 
 /*!
diff --git a/drivers/staging/wilc1000/wilc_type.h b/drivers/staging/wilc1000/wilc_type.h
deleted file mode 100644
index 5f36e7f..0000000
--- a/drivers/staging/wilc1000/wilc_type.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_type.h */
-/*  */
-/*  */
-/* //////////////////////////////////////////////////////////////////////////// */
-#ifndef WILC_TYPE_H
-#define WILC_TYPE_H
-
-/********************************************
- *
- *      Type Defines
- *
- ********************************************/
-#ifdef WIN32
-typedef char int8_t;
-typedef short int16_t;
-typedef long int32_t;
-typedef unsigned char uint8_t;
-typedef unsigned short uint16_t;
-typedef unsigned long uint32_t;
-#else
-#ifdef _linux_
-/*typedef unsigned char         uint8_t;
- * typedef unsigned short       uint16_t;
- * typedef unsigned long        uint32_t;*/
-#include <stdint.h>
-#else
-#include "wilc_oswrapper.h"
-#endif
-#endif
-#endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 0ba7ec6..5c9c4bb 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -1,7 +1,7 @@
 #ifndef WILC_WLAN_H
 #define WILC_WLAN_H
 
-#include "wilc_type.h"
+#include <linux/types.h>
 
 
 #define ISWILC1000(id)   (((id & 0xfffff000) == 0x100000) ? 1 : 0)
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index ea0ec41..d7271b9 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -20,7 +20,15 @@
 /* #define USE_OLD_SPI_SW */
 
 
-#include "wilc_type.h"
+#include "wilc_osconfig.h"
+#include "wilc_platform.h"
+#include "wilc_log.h"
+#include "wilc_errorsupport.h"
+#include "wilc_sleep.h"
+#include "wilc_timer.h"
+#include "wilc_memory.h"
+#include "wilc_strutils.h"
+#include "wilc_msgqueue.h"
 #include "linux_wlan_common.h"
 
 
-- 
2.4.3

