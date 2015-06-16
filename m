Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:15639 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbbFPFjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:39:13 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>
Subject: [PATCH 1/3] staging: wilc1000: rework include wilc_oswrapper.h
Date: Tue, 16 Jun 2015 14:38:20 +0900
Message-ID: <adf4906fecff029d52e8c8e0e1537dd7f9ef568c.1434432989.git.dean.lee@atmel.com> (sfid-20150616_073923_734749_1EC8AB43)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rework line '#include "wilc_oswrapper.h"'
it does not require after change own data type to common data type.

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 1 -
 drivers/staging/wilc1000/fifo_buffer.c      | 1 -
 drivers/staging/wilc1000/fifo_buffer.h      | 5 ++++-
 drivers/staging/wilc1000/wilc_memory.c      | 2 +-
 drivers/staging/wilc1000/wilc_memory.h      | 4 +++-
 drivers/staging/wilc1000/wilc_msgqueue.c    | 2 +-
 drivers/staging/wilc1000/wilc_msgqueue.h    | 5 +++++
 drivers/staging/wilc1000/wilc_sleep.c       | 2 +-
 drivers/staging/wilc1000/wilc_sleep.h       | 3 +++
 drivers/staging/wilc1000/wilc_strutils.c    | 2 +-
 drivers/staging/wilc1000/wilc_strutils.h    | 4 ++++
 drivers/staging/wilc1000/wilc_timer.c       | 2 +-
 drivers/staging/wilc1000/wilc_timer.h       | 3 +++
 13 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 6c1dad1..3ca067e 100644
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
diff --git a/drivers/staging/wilc1000/wilc_memory.c b/drivers/staging/wilc1000/wilc_memory.c
index 5670b5a..c70707f 100644
--- a/drivers/staging/wilc1000/wilc_memory.c
+++ b/drivers/staging/wilc1000/wilc_memory.c
@@ -1,5 +1,5 @@
 
-#include "wilc_oswrapper.h"
+#include "wilc_memory.h"
 
 /*!
  *  @author	syounan
diff --git a/drivers/staging/wilc1000/wilc_memory.h b/drivers/staging/wilc1000/wilc_memory.h
index 1bc4b53..372d705 100644
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
index ac9bb06..e014595 100644
--- a/drivers/staging/wilc1000/wilc_strutils.c
+++ b/drivers/staging/wilc1000/wilc_strutils.c
@@ -1,7 +1,7 @@
 
 #define _CRT_SECURE_NO_DEPRECATE
 
-#include "wilc_oswrapper.h"
+#include "wilc_strutils.h"
 
 
 /*!
diff --git a/drivers/staging/wilc1000/wilc_strutils.h b/drivers/staging/wilc1000/wilc_strutils.h
index bb31bea..d144557 100644
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
-- 
2.4.3

