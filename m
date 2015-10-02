Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36585 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbJBHld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 03:41:33 -0400
Received: by pablk4 with SMTP id lk4so99271948pab.3
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 00:41:32 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 02/12] staging: wilc1000: remove commented codes
Date: Fri,  2 Oct 2015 16:41:11 +0900
Message-Id: <1443771681-15540-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20151002_094136_202337_17213665)
In-Reply-To: <1443771681-15540-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443771681-15540-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes commented codes that is not used in this driver.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: resend because 08/12 patch is changed.

 drivers/staging/wilc1000/linux_wlan.c         | 3 ---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 -
 drivers/staging/wilc1000/wilc_wlan.c          | 4 ----
 drivers/staging/wilc1000/wilc_wlan_if.h       | 3 ---
 4 files changed, 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 701d317..bd83da1 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1967,9 +1967,6 @@ static void __exit exit_wilc_driver(void)
 		}
 	}
 
-	/* WILC_WFI_deinit_mon_interface(); */
-
-	/* if(g_linux_wlan->open_ifcs==0) */
 	{
 	#ifndef WILC_SDIO
 		PRINT_D(INIT_DBG, "SPI unregsiter...\n");
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index d3a03c6..4878f12 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -185,7 +185,6 @@ typedef struct {
 	struct task_struct *txq_thread;
 
 	unsigned char eth_src_address[NUM_CONCURRENT_IFC][6];
-	/* unsigned char eth_dst_address[6]; */
 
 	const struct firmware *wilc_firmware;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 428e94f..de70c59 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -142,7 +142,6 @@ static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 {
 
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
-	/* unsigned long flags; */
 	if (tqe == p->txq_head)	{
 
 		p->txq_head = tqe->next;
@@ -848,8 +847,6 @@ static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 		i = 0;
 		sum = 0;
 		do {
-			/* if ((tqe != NULL) && (i < (8)) && */
-			/* if ((tqe != NULL) && (i < (WILC_VMM_TBL_SIZE-1)) && */
 			if ((tqe != NULL) && (i < (WILC_VMM_TBL_SIZE - 1)) /* reserve last entry to 0 */) {
 
 				if (tqe->type == WILC_CFG_PKT) {
@@ -972,7 +969,6 @@ static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 					 *      Get the entries
 					 **/
 					entries = ((reg >> 3) & 0x3f);
-					/* entries = ((reg>>3)&0x2f); */
 					break;
 				} else {
 					release_bus(RELEASE_ALLOW_SLEEP);
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 7aa317d..75c1ebc 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -10,9 +10,6 @@
 #ifndef WILC_WLAN_IF_H
 #define WILC_WLAN_IF_H
 
-/* #define MEMORY_STATIC */
-/* #define USE_OLD_SPI_SW */
-
 #include <linux/semaphore.h>
 #include "linux_wlan_common.h"
 
-- 
2.6.0

