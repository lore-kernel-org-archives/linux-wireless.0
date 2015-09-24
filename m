Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25622 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbbIXJOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:14:11 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/15] staging: wilc1000: remove mutex txq_cs and it's related codes
Date: Thu, 24 Sep 2015 18:15:04 +0900
Message-ID: <1443086106-20482-13-git-send-email-glen.lee@atmel.com> (sfid-20150924_111415_858728_3F192AEF)
In-Reply-To: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
References: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mutex txq_cs is never used in the driver. txq_cs, txq_critical_section and
txq_lock have same pointer so just delete them and it's related codes.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 5 -----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 -
 drivers/staging/wilc1000/wilc_wlan.c          | 2 --
 drivers/staging/wilc1000/wilc_wlan_if.h       | 1 -
 4 files changed, 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 519fb16..3547750 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1020,7 +1020,6 @@ int wlan_init_locks(linux_wlan_t *p_nic)
 
 	mutex_init(&g_linux_wlan->hif_cs);
 	mutex_init(&g_linux_wlan->rxq_cs);
-	mutex_init(&g_linux_wlan->txq_cs);
 
 	spin_lock_init(&g_linux_wlan->txq_spinlock);
 	sema_init(&g_linux_wlan->txq_add_to_head_cs, 1);
@@ -1045,9 +1044,6 @@ static int wlan_deinit_locks(linux_wlan_t *nic)
 	if (&g_linux_wlan->rxq_cs != NULL)
 		mutex_destroy(&g_linux_wlan->rxq_cs);
 
-	if (&g_linux_wlan->txq_cs != NULL)
-		mutex_destroy(&g_linux_wlan->txq_cs);
-
 	return 0;
 }
 void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
@@ -1056,7 +1052,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
 
 	nwi->os_context.os_private = (void *)nic;
-	nwi->os_context.txq_critical_section = (void *)&g_linux_wlan->txq_cs;
 	nwi->os_func.os_wait = linux_wlan_lock_timeout;
 
 #ifdef WILC_SDIO
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index b24b9a9..e844306 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -169,7 +169,6 @@ typedef struct {
 	u8 u8NoIfcs;
 	tstrInterfaceInfo strInterfaceInfo[NUM_CONCURRENT_IFC];
 	u8 open_ifcs;
-	struct mutex txq_cs;
 
 	struct semaphore txq_add_to_head_cs;
 	spinlock_t txq_spinlock;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 84e544d..6ed5ecf 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -63,7 +63,6 @@ typedef struct {
 	/**
 	 *      TX queue
 	 **/
-	void *txq_lock;
 
 	unsigned long txq_spinlock_flags;
 
@@ -1966,7 +1965,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	 **/
 	memcpy((void *)&g_wlan.os_func, (void *)&inp->os_func, sizeof(wilc_wlan_os_func_t));
 	memcpy((void *)&g_wlan.io_func, (void *)&inp->io_func, sizeof(wilc_wlan_io_func_t));
-	g_wlan.txq_lock = inp->os_context.txq_critical_section;
 	/***
 	 *      host interface init
 	 **/
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 9ab34ca..df4e3bb 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -107,7 +107,6 @@ typedef struct {
 
 typedef struct {
 	void *os_private;
-	void *txq_critical_section;
 } wilc_wlan_os_context_t;
 
 typedef struct {
-- 
1.9.1

