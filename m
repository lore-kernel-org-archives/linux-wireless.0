Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35330 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbbIWJEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 05:04:04 -0400
Received: by pacfv12 with SMTP id fv12so35766523pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2015 02:04:03 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/6] staging: wilc1000: move wilc_msgqueue.h include file
Date: Wed, 23 Sep 2015 18:03:47 +0900
Message-Id: <1442999030-31934-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150923_110417_298705_671AC006)
In-Reply-To: <1442999030-31934-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442999030-31934-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves wilc_msgqueue.h include file from wilc_oswrapper.h to
host_interface.c because message queue function as wilc_mq_create,
wilc_mq_send, wilc_mq_recv and wilc_mq_destroy are used only at
host_interface.c file.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 1 +
 drivers/staging/wilc1000/wilc_oswrapper.h | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e7fc648..49f3de9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1,6 +1,7 @@
 #include "host_interface.h"
 #include "coreconfigurator.h"
 #include "wilc_wlan_if.h"
+#include "wilc_msgqueue.h"
 
 extern u8 connecting;
 
diff --git a/drivers/staging/wilc1000/wilc_oswrapper.h b/drivers/staging/wilc1000/wilc_oswrapper.h
index 9b5c23a..4f7bd89 100644
--- a/drivers/staging/wilc1000/wilc_oswrapper.h
+++ b/drivers/staging/wilc1000/wilc_oswrapper.h
@@ -16,7 +16,5 @@
 /* Os Configuration File */
 #include "wilc_platform.h"
 
-/* Message Queue */
-#include "wilc_msgqueue.h"
 
 #endif
-- 
2.5.1

