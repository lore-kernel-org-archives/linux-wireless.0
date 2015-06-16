Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:15716 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbbFPFj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:39:26 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>
Subject: [PATCH 3/3] staging: wilc1000: delete unused files (wilc_oswrapper.h wilc_type.h)
Date: Tue, 16 Jun 2015 14:38:22 +0900
Message-ID: <182d845608c3b6a8df0a205e21044ee338451313.1434432989.git.dean.lee@atmel.com> (sfid-20150616_073930_795137_968FB84C)
In-Reply-To: <adf4906fecff029d52e8c8e0e1537dd7f9ef568c.1434432989.git.dean.lee@atmel.com>
References: <adf4906fecff029d52e8c8e0e1537dd7f9ef568c.1434432989.git.dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

delete unsued files

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_oswrapper.h | 41 -------------------------------
 drivers/staging/wilc1000/wilc_type.h      | 34 -------------------------
 2 files changed, 75 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_oswrapper.h
 delete mode 100644 drivers/staging/wilc1000/wilc_type.h

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
-- 
2.4.3

