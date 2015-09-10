Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:28441 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbbIJDCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 23:02:51 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 2/2] staging: wilc1000: delete wilc_memory.c and wilc_memory.h
Date: Thu, 10 Sep 2015 12:03:05 +0900
Message-ID: <1441854185-10671-2-git-send-email-tony.cho@atmel.com> (sfid-20150910_050253_593696_FF6C2A9A)
In-Reply-To: <1441854185-10671-1-git-send-email-tony.cho@atmel.com>
References: <1441854185-10671-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

The macro WILC_MALLOC is not used in the driver anymore, so just
delete files.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/Makefile         |  2 +-
 drivers/staging/wilc1000/wilc_memory.c    | 16 --------
 drivers/staging/wilc1000/wilc_memory.h    | 66 -------------------------------
 drivers/staging/wilc1000/wilc_msgqueue.h  |  1 -
 drivers/staging/wilc1000/wilc_oswrapper.h |  4 --
 5 files changed, 1 insertion(+), 88 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_memory.c
 delete mode 100644 drivers/staging/wilc1000/wilc_memory.h

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 8336a89..bdeffea 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -21,7 +21,7 @@ ccflags-$(CONFIG_WILC1000_DYNAMICALLY_ALLOCATE_MEMROY) += -DWILC_NORMAL_ALLOC
 
 
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
-			wilc_memory.o wilc_msgqueue.o \
+			wilc_msgqueue.o \
 			coreconfigurator.o host_interface.o \
 			wilc_sdio.o wilc_spi.o wilc_wlan_cfg.o wilc_debugfs.o
 
diff --git a/drivers/staging/wilc1000/wilc_memory.c b/drivers/staging/wilc1000/wilc_memory.c
deleted file mode 100644
index e90a957..0000000
--- a/drivers/staging/wilc1000/wilc_memory.c
+++ /dev/null
@@ -1,16 +0,0 @@
-
-#include "wilc_memory.h"
-
-/*!
- *  @author	syounan
- *  @date	18 Aug 2010
- *  @version	1.0
- */
-void *WILC_MemoryAlloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
-		       char *pcFileName, u32 u32LineNo)
-{
-	if (u32Size > 0)
-		return kmalloc(u32Size, GFP_ATOMIC);
-	else
-		return NULL;
-}
diff --git a/drivers/staging/wilc1000/wilc_memory.h b/drivers/staging/wilc1000/wilc_memory.h
deleted file mode 100644
index f19cec1..0000000
--- a/drivers/staging/wilc1000/wilc_memory.h
+++ /dev/null
@@ -1,66 +0,0 @@
-#ifndef __WILC_MEMORY_H__
-#define __WILC_MEMORY_H__
-
-/*!
- *  @file	wilc_memory.h
- *  @brief	Memory OS wrapper functionality
- *  @author	syounan
- *  @sa		wilc_oswrapper.h top level OS wrapper file
- *  @date	16 Aug 2010
- *  @version	1.0
- */
-
-#include <linux/types.h>
-#include <linux/slab.h>
-
-/*!
- *  @struct             tstrWILC_MemoryAttrs
- *  @brief		Memory API options
- *  @author		syounan
- *  @date		16 Aug 2010
- *  @version		1.0
- */
-typedef struct {
-} tstrWILC_MemoryAttrs;
-
-/*!
- *  @brief	Allocates a given size of bytes
- *  @param[in]	u32Size size of memory in bytes to be allocated
- *  @param[in]	strAttrs Optional attributes, NULL for default
- *              if not NULL, pAllocationPool should point to the pool to use for
- *              this allocation. if NULL memory will be allocated directly from
- *              the system
- *  @param[in]	pcFileName file name of the calling code for debugging
- *  @param[in]	u32LineNo line number of the calling code for debugging
- *  @return	The new allocated block, NULL if allocation fails
- *  @note	It is recommended to use of of the wrapper macros instead of
- *              calling this function directly
- *  @sa		sttrWILC_MemoryAttrs
- *  @sa		WILC_MALLOC
- *  @sa		WILC_MALLOC_EX
- *  @author	syounan
- *  @date	16 Aug 2010
- *  @version	1.0
- */
-void *WILC_MemoryAlloc(u32 u32Size, tstrWILC_MemoryAttrs *strAttrs,
-		       char *pcFileName, u32 u32LineNo);
-
-/*!
- * @brief	standrad malloc wrapper with custom attributes
- */
-	#define WILC_MALLOC_EX(__size__, __attrs__) \
-	(WILC_MemoryAlloc( \
-		 (__size__), __attrs__, NULL, 0))
-
-
-/*!
- * @brief	standrad malloc wrapper with default attributes
- */
-#define WILC_MALLOC(__size__) \
-	WILC_MALLOC_EX(__size__, NULL)
-
-
-
-
-
-#endif
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index fc65dfe..fb26463 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -12,7 +12,6 @@
 
 #include "wilc_platform.h"
 #include "wilc_errorsupport.h"
-#include "wilc_memory.h"
 
 /*!
  *  @brief		Creates a new Message queue
diff --git a/drivers/staging/wilc1000/wilc_oswrapper.h b/drivers/staging/wilc1000/wilc_oswrapper.h
index cb48325..68f6efe 100644
--- a/drivers/staging/wilc1000/wilc_oswrapper.h
+++ b/drivers/staging/wilc1000/wilc_oswrapper.h
@@ -19,10 +19,6 @@
 /* Error reporting and handling support */
 #include "wilc_errorsupport.h"
 
-/* Memory support */
-#include "wilc_memory.h"
-
-
 /* Message Queue */
 #include "wilc_msgqueue.h"
 
-- 
1.9.1

