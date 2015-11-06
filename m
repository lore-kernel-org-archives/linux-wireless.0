Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37123 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031099AbbKFCOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:14:23 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 39/73] staging: wilc1000: remove unused argument of chip_sleep_manually function
Date: Fri, 6 Nov 2015 11:13:00 +0900
Message-ID: <1446776014-28094-39-git-send-email-glen.lee@atmel.com> (sfid-20151106_033802_472051_8F15A133)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes u32SleepTime that is second argument of
chip_sleep_manually function because it is not used in this function.
Remove argument in the function call also.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 +--
 drivers/staging/wilc1000/wilc_wlan.c      | 2 +-
 drivers/staging/wilc1000/wilc_wlan.h      | 1 +
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 84a2479..7014915 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -271,7 +271,6 @@ static struct host_if_drv *join_req_drv;
 
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
 
-extern void chip_sleep_manually(u32 u32SleepTime);
 extern int linux_wlan_get_num_conn_ifcs(void);
 
 static int add_handler_in_list(struct host_if_drv *handler)
@@ -2906,7 +2905,7 @@ static int hostIFthread(void *pvArg)
 			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
 			if (!linux_wlan_get_num_conn_ifcs())
-				chip_sleep_manually(INFINITE_SLEEP_TIME);
+				chip_sleep_manually();
 
 			Handle_ScanDone(msg.drv, SCAN_EVENT_DONE);
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 0c08a9a..66d5d42 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -680,7 +680,7 @@ static inline void chip_wakeup(void)
 	chip_ps_state = CHIP_WAKEDUP;
 }
 #endif
-void chip_sleep_manually(u32 u32SleepTime)
+void chip_sleep_manually(void)
 {
 	if (chip_ps_state != CHIP_WAKEDUP)
 		return;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 2eb7e20..de2fb7c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -309,4 +309,5 @@ int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler);
 int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 			       u32 buffer_size, wilc_tx_complete_func_t func);
+void chip_sleep_manually(void);
 #endif
-- 
1.9.1

