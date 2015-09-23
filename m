Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33106 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbbIWJEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 05:04:00 -0400
Received: by pacex6 with SMTP id ex6so35315135pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2015 02:04:00 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/6] staging: wilc1000: remove wilc_platform.h include file
Date: Wed, 23 Sep 2015 18:03:46 +0900
Message-Id: <1442999030-31934-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150923_110436_339659_B6478A2E)
In-Reply-To: <1442999030-31934-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442999030-31934-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes wilc_platform.h include file that is defined in
wilc_msgqueue.h file. After removing it, compilation error occurs so
that it is included two header files as <linux/semaphore.h> and
<linux/slab.h> at wilc_msgqueue.h and wilc_msgqueue.c

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_msgqueue.c | 1 +
 drivers/staging/wilc1000/wilc_msgqueue.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 869736a..d5ebd6d 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -3,6 +3,7 @@
 #include <linux/spinlock.h>
 #include "linux_wlan_common.h"
 #include <linux/errno.h>
+#include <linux/slab.h>
 
 /*!
  *  @author		syounan
diff --git a/drivers/staging/wilc1000/wilc_msgqueue.h b/drivers/staging/wilc1000/wilc_msgqueue.h
index 982628e..d231c33 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.h
+++ b/drivers/staging/wilc1000/wilc_msgqueue.h
@@ -10,7 +10,7 @@
  *  @version	1.0
  */
 
-#include "wilc_platform.h"
+#include <linux/semaphore.h>
 
 /* Message Queue type is a structure */
 typedef struct __Message_struct {
-- 
2.5.1

