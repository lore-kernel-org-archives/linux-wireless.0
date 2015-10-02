Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9738 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbJBFWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 01:22:54 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/10] staging: wilc1000: Delete undefined DEBUG_MODE and it's related codes
Date: Fri, 2 Oct 2015 14:22:06 +0900
Message-ID: <1443763332-7330-4-git-send-email-tony.cho@atmel.com> (sfid-20151002_072257_304173_D683CB95)
In-Reply-To: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
References: <1443763332-7330-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes undefined DEBUG_MODE and it's related codes.
We won't use this at the moment.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 63 -----------------------------------
 1 file changed, 63 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index c2e528f..c4915d3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -128,60 +128,6 @@ static const struct net_device_ops wilc_netdev_ops = {
 
 };
 
-#ifdef DEBUG_MODE
-
-extern volatile int timeNo;
-
-#define DEGUG_BUFFER_LENGTH 1000
-volatile int WatchDogdebuggerCounter;
-char DebugBuffer[DEGUG_BUFFER_LENGTH + 20] = {0};
-static char *ps8current = DebugBuffer;
-
-void printk_later(const char *format, ...)
-{
-	va_list args;
-
-	va_start(args, format);
-	ps8current += vsprintf(ps8current, format, args);
-	va_end(args);
-	if ((ps8current - DebugBuffer) > DEGUG_BUFFER_LENGTH)
-		ps8current = DebugBuffer;
-
-}
-
-void dump_logs(void)
-{
-	if (DebugBuffer[0]) {
-		DebugBuffer[DEGUG_BUFFER_LENGTH] = 0;
-		PRINT_INFO(GENERIC_DBG, "early printed\n");
-		PRINT_D(GENERIC_DBG, ps8current + 1);
-		ps8current[1] = 0;
-		PRINT_INFO(GENERIC_DBG, "latest printed\n");
-		PRINT_D(GENERIC_DBG, DebugBuffer);
-		DebugBuffer[0] = 0;
-		ps8current = DebugBuffer;
-	}
-}
-
-void Reset_WatchDogdebugger(void)
-{
-	WatchDogdebuggerCounter = 0;
-}
-
-static int DebuggingThreadTask(void *vp)
-{
-	while (1) {
-		while (!WatchDogdebuggerCounter) {
-			PRINT_D(GENERIC_DBG, "Debug Thread Running %d\n", timeNo);
-			WatchDogdebuggerCounter = 1;
-			msleep(10000);
-		}
-		dump_logs();
-		WatchDogdebuggerCounter = 0;
-	}
-}
-#endif
-
 static int dev_state_ev_handler(struct notifier_block *this, unsigned long event, void *ptr)
 {
 	struct in_ifaddr *dev_iface = (struct in_ifaddr *)ptr;
@@ -1072,15 +1018,6 @@ int wlan_initialize_threads(perInterface_wlan_t *nic)
 		ret = -ENOBUFS;
 		goto _fail_2;
 	}
-#ifdef DEBUG_MODE
-	PRINT_D(INIT_DBG, "Creating kthread for Debugging\n");
-	g_linux_wlan->txq_thread = kthread_run(DebuggingThreadTask, (void *)g_linux_wlan, "DebugThread");
-	if (g_linux_wlan->txq_thread == 0) {
-		PRINT_ER("couldn't create TXQ thread\n");
-		ret = -ENOBUFS;
-		goto _fail_2;
-	}
-#endif
 	/* wait for TXQ task to start. */
 	down(&g_linux_wlan->txq_thread_started);
 
-- 
1.9.1

