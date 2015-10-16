Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52454 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbbJPEkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:40:03 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 17/40] staging: wilc1000: rename variable g_hPeriodicRSSI
Date: Fri, 16 Oct 2015 13:37:47 +0900
Message-ID: <1444970290-17609-17-git-send-email-tony.cho@atmel.com> (sfid-20151016_064659_655891_B5730A4B)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable g_hPeriodicRSSI to periodic_rssi
to avoid CamelCase naming convention.

Add to static because follow warning reported by kbuild system.
 - drivers/staging/wilc1000/host_interface.c:248:19: sparse: symbol
   'periodic_rssi' was not declared. Should it be static?

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5900972..8c529d1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -245,9 +245,7 @@ static struct semaphore hif_sema_thread;
 static struct semaphore hif_sema_driver;
 static struct semaphore hif_sema_wait_response;
 static struct semaphore hif_sema_deinit;
-struct timer_list g_hPeriodicRSSI;
-
-
+static struct timer_list periodic_rssi;
 
 u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
@@ -4207,8 +4205,8 @@ static void GetPeriodicRSSI(unsigned long arg)
 			return;
 		}
 	}
-	g_hPeriodicRSSI.data = (unsigned long)hif_drv;
-	mod_timer(&g_hPeriodicRSSI, jiffies + msecs_to_jiffies(5000));
+	periodic_rssi.data = (unsigned long)hif_drv;
+	mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 }
 
 
@@ -4276,9 +4274,9 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 			result = -EFAULT;
 			goto _fail_mq_;
 		}
-		setup_timer(&g_hPeriodicRSSI, GetPeriodicRSSI,
+		setup_timer(&periodic_rssi, GetPeriodicRSSI,
 			    (unsigned long)hif_drv);
-		mod_timer(&g_hPeriodicRSSI, jiffies + msecs_to_jiffies(5000));
+		mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 	}
 
 	setup_timer(&hif_drv->hScanTimer, TimerCB_Scan, 0);
@@ -4346,10 +4344,8 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
 	}
 
-
-	if (del_timer_sync(&g_hPeriodicRSSI)) {
+	if (del_timer_sync(&periodic_rssi))
 		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
-	}
 
 	del_timer_sync(&hif_drv->hRemainOnChannel);
 
@@ -4370,9 +4366,9 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	if (clients_count == 1)	{
-		if (del_timer_sync(&g_hPeriodicRSSI)) {
+		if (del_timer_sync(&periodic_rssi))
 			PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
-		}
+
 		msg.id = HOST_IF_MSG_EXIT;
 		msg.drv = hif_drv;
 
-- 
1.9.1

