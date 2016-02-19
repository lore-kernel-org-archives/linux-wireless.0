Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:4931 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbcBSKAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 05:00:24 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH 1/4] staging: wilc1000: move WILC_MULTICAST_TABLE_SIZE define to wilc_wlan_if.h file
Date: Fri, 19 Feb 2016 18:57:42 +0900
Message-ID: <1455875865-15505-1-git-send-email-leo.kim@atmel.com> (sfid-20160219_110030_606692_7B363A76)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch moves WILC_MULTICAST_TABLE_SIZE define to wilc_wlan_if.h file.
This define is used to three files(host_interface.c,host_interface.h,
linux_wlan.c) these files already include wilc_wlan_if.h file in common.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_common.h | 2 --
 drivers/staging/wilc1000/wilc_wlan_if.h      | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index aa2c026..5a53512 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -1,8 +1,6 @@
 #ifndef LINUX_WLAN_COMMON_H
 #define LINUX_WLAN_COMMON_H
 
-#define WILC_MULTICAST_TABLE_SIZE	8
-
 #if defined(BEAGLE_BOARD)
 	#define SPI_CHANNEL	4
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 269c56e..c33f7a6 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -95,7 +95,7 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
  *      Wlan Configuration ID
  *
  ********************************************/
-
+#define WILC_MULTICAST_TABLE_SIZE	8
 #define MAX_SSID_LEN            33
 #define MAX_RATES_SUPPORTED     12
 
-- 
1.9.1

