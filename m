Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40321 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbbIPJyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 05:54:20 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 8/8] staging: wilc1000: remove unused variable rxq_thread
Date: Wed, 16 Sep 2015 18:53:27 +0900
Message-ID: <1442397207-20491-8-git-send-email-tony.cho@atmel.com> (sfid-20150916_115422_704720_D8CFA0A2)
In-Reply-To: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
References: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

The rxq_thread never runs since it's kthread_run code was delete in a previous
patch. Remove kthread_run and it's related codes.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 6 ------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 186e42e..a4f43d2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1276,7 +1276,6 @@ int wlan_initialize_threads(perInterface_wlan_t *nic)
 _fail_2:
 	/*De-Initialize 2nd thread*/
 	g_linux_wlan->close = 1;
-	kthread_stop(g_linux_wlan->rxq_thread);
 
 	#if (RX_BH_TYPE == RX_BH_KTHREAD)
 	/*De-Initialize 1st thread*/
@@ -1295,11 +1294,6 @@ static void wlan_deinitialize_threads(linux_wlan_t *nic)
 	g_linux_wlan->close = 1;
 	PRINT_D(INIT_DBG, "Deinitializing Threads\n");
 
-	if (g_linux_wlan->rxq_thread != NULL) {
-		kthread_stop(g_linux_wlan->rxq_thread);
-		g_linux_wlan->rxq_thread = NULL;
-	}
-
 	if (&g_linux_wlan->txq_event != NULL)
 		up(&g_linux_wlan->txq_event);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index c98eab6..aa96ef3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -199,7 +199,6 @@ typedef struct {
 #endif
 	struct semaphore txq_thread_started;
 
-	struct task_struct *rxq_thread;
 	struct task_struct *txq_thread;
 
 	unsigned char eth_src_address[NUM_CONCURRENT_IFC][6];
-- 
1.9.1

