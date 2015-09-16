Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40200 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbbIPJyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 05:54:00 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 5/8] staging: wilc1000: remove variable rxq_thread_started
Date: Wed, 16 Sep 2015 18:53:24 +0900
Message-ID: <1442397207-20491-5-git-send-email-tony.cho@atmel.com> (sfid-20150916_115405_986211_8ABC7CE2)
In-Reply-To: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
References: <1442397207-20491-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

rxq_thread_started is initiallized but never used in the driver. Remove
the variable and init code line.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 1 -
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index de04779..f104a23 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1161,7 +1161,6 @@ int wlan_init_locks(linux_wlan_t *p_nic)
 	sema_init(&g_linux_wlan->cfg_event, 0);
 	sema_init(&g_linux_wlan->sync_event, 0);
 
-	sema_init(&g_linux_wlan->rxq_thread_started, 0);
 	sema_init(&g_linux_wlan->txq_thread_started, 0);
 
 	#if (RX_BH_TYPE == RX_BH_KTHREAD)
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 27c9ccf..c68df360 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -198,7 +198,6 @@ typedef struct {
 	struct task_struct *rx_bh_thread;
 	struct semaphore rx_sem;
 #endif
-	struct semaphore rxq_thread_started;
 	struct semaphore txq_thread_started;
 
 	struct task_struct *rxq_thread;
-- 
1.9.1

