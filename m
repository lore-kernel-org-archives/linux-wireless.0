Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:28348 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbbFPG3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 02:29:19 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>
Subject: [PATCH 2/3] staging: wilc1000: rework include wilc_type.h
Date: Tue, 16 Jun 2015 15:28:22 +0900
Message-ID: <78f832bdca88f58160bce4efef9ef338472cd40e.1434432989.git.dean.lee@atmel.com> (sfid-20150616_082933_575574_39C1B20D)
In-Reply-To: <adf4906fecff029d52e8c8e0e1537dd7f9ef568c.1434432989.git.dean.lee@atmel.com>
References: <adf4906fecff029d52e8c8e0e1537dd7f9ef568c.1434432989.git.dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rework line '#include "wilc_type.h"'
it does not require after rework include wilc_oswrapper.h

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.h    |  2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h | 10 +++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

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

