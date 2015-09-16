Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40161 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbbIPJxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 05:53:54 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 4/8] staging: wilc1000: remove function linux_wlan_rxq_task
Date: Wed, 16 Sep 2015 18:53:23 +0900
Message-ID: <1442397207-20491-4-git-send-email-tony.cho@atmel.com> (sfid-20150916_115359_288451_0C9D9BF0)
In-Reply-To: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
References: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

linux_wlan_rxq_task is not used in the driver. Just remove it.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 08d75ab..de04779 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -587,32 +587,6 @@ int linux_wlan_get_num_conn_ifcs(void)
 	return ret_val;
 }
 
-static int linux_wlan_rxq_task(void *vp)
-{
-
-	/* inform wilc1000_wlan_init that RXQ task is started. */
-	up(&g_linux_wlan->rxq_thread_started);
-	while (1) {
-		down(&g_linux_wlan->rxq_event);
-		/* wait_for_completion(&g_linux_wlan->rxq_event); */
-
-		if (g_linux_wlan->close) {
-			/*Unlock the mutex in the mac_close function to indicate the exiting of the RX thread */
-			up(&g_linux_wlan->rxq_thread_started);
-
-			while (!kthread_should_stop())
-				schedule();
-
-			PRINT_D(RX_DBG, " RX thread stopped\n");
-			break;
-		}
-		PRINT_D(RX_DBG, "Calling wlan_handle_rx_que()\n");
-
-		g_linux_wlan->oup.wlan_handle_rx_que();
-	}
-	return 0;
-}
-
 #define USE_TX_BACKOFF_DELAY_IF_NO_BUFFERS
 
 static int linux_wlan_txq_task(void *vp)
-- 
1.9.1

