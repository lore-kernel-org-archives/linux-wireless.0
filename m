Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25429 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbbIXJNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:13:09 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/15] staging: wilc1000: remove function pointer os_debug
Date: Thu, 24 Sep 2015 18:14:55 +0900
Message-ID: <1443086106-20482-4-git-send-email-glen.lee@atmel.com> (sfid-20150924_111317_812410_19501D16)
In-Reply-To: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
References: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes os_debug and call linux_wlan_dbg function instead of
os_debug. Delete static from the linux_wlan_dbg.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 3 +--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 +
 drivers/staging/wilc1000/wilc_wlan.c          | 3 +--
 drivers/staging/wilc1000/wilc_wlan_if.h       | 1 -
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 7b76b22..d2678a3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -376,7 +376,7 @@ static void deinit_irq(linux_wlan_t *nic)
 /*
  *      OS functions
  */
-static void linux_wlan_dbg(u8 *buff)
+void linux_wlan_dbg(u8 *buff)
 {
 	PRINT_D(INIT_DBG, "%d\n", *buff);
 }
@@ -1072,7 +1072,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 	nwi->os_context.rxq_critical_section = (void *)&g_linux_wlan->rxq_cs;
 	nwi->os_context.cfg_wait_event = (void *)&g_linux_wlan->cfg_event;
 
-	nwi->os_func.os_debug = linux_wlan_dbg;
 	nwi->os_func.os_wait = linux_wlan_lock_timeout;
 
 #ifdef WILC_SDIO
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index bda9244..47e04c2 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -219,5 +219,6 @@ extern struct net_device *WILC_WFI_devs[];
 void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset);
 void linux_wlan_mac_indicate(int flag);
 void linux_wlan_rx_complete(void);
+void linux_wlan_dbg(u8 *buff);
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a133595..3e1479f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -113,8 +113,7 @@ static void wilc_debug(u32 flag, char *fmt, ...)
 		vsprintf(buf, fmt, args);
 		va_end(args);
 
-		if (g_wlan.os_func.os_debug)
-			g_wlan.os_func.os_debug(buf);
+		linux_wlan_dbg(buf);
 	}
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 4ff1a8f..aafb492 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -75,7 +75,6 @@ typedef struct {
 } sdio_cmd53_t;
 
 typedef struct {
-	void (*os_debug)(u8 *);
 	int (*os_wait)(void *, u32);
 } wilc_wlan_os_func_t;
 
-- 
1.9.1

