Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33699 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbbHJCeA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 22:34:00 -0400
Received: by pdrh1 with SMTP id h1so47767954pdr.0
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2015 19:34:00 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/11] staging: wilc1000: remove wilc_strutils.c and wilc_strutils.h
Date: Mon, 10 Aug 2015 11:33:22 +0900
Message-Id: <1439174002-7365-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20150810_043715_908069_66930A29)
In-Reply-To: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439174002-7365-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove wilc_strutils.c and wilc_strutils.h that are not needed.
wilc_strutils.o is also removed in Makefile.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/Makefile         |  2 +-
 drivers/staging/wilc1000/wilc_msgqueue.h  |  1 -
 drivers/staging/wilc1000/wilc_oswrapper.h |  2 --
 drivers/staging/wilc1000/wilc_strutils.c  | 12 ------------
 drivers/staging/wilc1000/wilc_strutils.h  | 24 ------------------------
 5 files changed, 1 insertion(+), 40 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_strutils.c
 delete mode 100644 drivers/staging/wilc1000/wilc_strutils.h

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 5ca8fa2..ec4b877 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -26,7 +26,7 @@ ccflags-$(CONFIG_WILC1000_DYNAMICALLY_ALLOCATE_MEMROY) += -DWILC_NORMAL_ALLOC
 
 
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
-			wilc_memory.o wilc_msgqueue.o wilc_sleep.o wilc_strutils.o \
+			wilc_memory.o wilc_msgqueue.o wilc_sleep.o \
 			wilc_timer.o coreconfigurator.o host_interface.o \
 			wilc_sdio.o wilc_spi.o wilc_wlan_cfg.o wilc_debugfs.o
 
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 35b1001..de374ac 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -13,7 +13,6 @@
 #include "wilc_platform.h"
 #include "wilc_errorsupport.h"
 #include "wilc_memory.h"
-#include "wilc_strutils.h"
 
 /*!
  *  @struct             tstrWILC_MsgQueueAttrs
diff --git a/drivers/staging/wilc1000/wilc_oswrapper.h b/drivers/staging/wilc1000/wilc_oswrapper.h
index e97aa96..652c882 100644
--- a/drivers/staging/wilc1000/wilc_oswrapper.h
+++ b/drivers/staging/wilc1000/wilc_oswrapper.h
@@ -32,8 +32,6 @@
 /* Memory support */
 #include "wilc_memory.h"
 
-/* String Utilities */
-#include "wilc_strutils.h"
 
 /* Message Queue */
 #include "wilc_msgqueue.h"
diff --git a/drivers/staging/wilc1000/wilc_strutils.c b/drivers/staging/wilc1000/wilc_strutils.c
deleted file mode 100644
index ebc8668..0000000
--- a/drivers/staging/wilc1000/wilc_strutils.c
+++ /dev/null
@@ -1,12 +0,0 @@
-
-#define _CRT_SECURE_NO_DEPRECATE
-
-#include "wilc_strutils.h"
-
-
-
-
-
-
-
-
diff --git a/drivers/staging/wilc1000/wilc_strutils.h b/drivers/staging/wilc1000/wilc_strutils.h
deleted file mode 100644
index bb7b61d..0000000
--- a/drivers/staging/wilc1000/wilc_strutils.h
+++ /dev/null
@@ -1,24 +0,0 @@
-#ifndef __WILC_STRUTILS_H__
-#define __WILC_STRUTILS_H__
-
-/*!
- *  @file	wilc_strutils.h
- *  @brief	Basic string utilities
- *  @author	syounan
- *  @sa		wilc_oswrapper.h top level OS wrapper file
- *  @date	16 Aug 2010
- *  @version	1.0
- */
-
-#include <linux/types.h>
-#include <linux/string.h>
-#include "wilc_errorsupport.h"
-
-
-
-
-
-
-
-
-#endif
-- 
1.9.1

