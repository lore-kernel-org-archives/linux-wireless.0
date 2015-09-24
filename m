Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25555 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbbIXJNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:13:51 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/15] staging: wilc1000: remove pointer varialbes of hif_cs
Date: Thu, 24 Sep 2015 18:15:01 +0900
Message-ID: <1443086106-20482-10-git-send-email-glen.lee@atmel.com> (sfid-20150924_111355_928624_3F6FA8B5)
In-Reply-To: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
References: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove hif_lock and hif_critical_section which are pointer of
g_linux_wlan->hif_cs. Remove also it's related codes.
Just use mutex varialbe g_linux_wlan->hif_cs.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   |  1 -
 drivers/staging/wilc1000/wilc_wlan.c    | 10 ++++------
 drivers/staging/wilc1000/wilc_wlan_if.h |  3 ---
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 61161b9..5bb5588 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1055,7 +1055,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 
 	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
 
-	nwi->os_context.hif_critical_section = (void *)&g_linux_wlan->hif_cs;
 	nwi->os_context.os_private = (void *)nic;
 	nwi->os_context.tx_buffer_size = LINUX_TX_SIZE;
 	nwi->os_context.txq_critical_section = (void *)&g_linux_wlan->txq_cs;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f042b78..9df2110 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -37,7 +37,6 @@ typedef struct {
 	 *      host interface functions
 	 **/
 	wilc_hif_func_t hif_func;
-	struct mutex *hif_lock;
 
 	/**
 	 *      configuration interface functions
@@ -120,7 +119,7 @@ static CHIP_PS_STATE_T genuChipPSstate = CHIP_WAKEDUP;
 static inline void acquire_bus(BUS_ACQUIRE_T acquire)
 {
 
-	mutex_lock(g_wlan.hif_lock);
+	mutex_lock(&g_linux_wlan->hif_cs);
 	#ifndef WILC_OPTIMIZE_SLEEP_INT
 	if (genuChipPSstate != CHIP_WAKEDUP)
 	#endif
@@ -136,7 +135,7 @@ static inline void release_bus(BUS_RELEASE_T release)
 	if (release == RELEASE_ALLOW_SLEEP)
 		chip_allow_sleep();
 	#endif
-	mutex_unlock(g_wlan.hif_lock);
+	mutex_unlock(&g_linux_wlan->hif_cs);
 }
 /********************************************
  *
@@ -1969,7 +1968,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	 **/
 	memcpy((void *)&g_wlan.os_func, (void *)&inp->os_func, sizeof(wilc_wlan_os_func_t));
 	memcpy((void *)&g_wlan.io_func, (void *)&inp->io_func, sizeof(wilc_wlan_io_func_t));
-	g_wlan.hif_lock = inp->os_context.hif_critical_section;
 	g_wlan.txq_lock = inp->os_context.txq_critical_section;
 
 	g_wlan.tx_buffer_size = inp->os_context.tx_buffer_size;
@@ -2088,7 +2086,7 @@ u16 Set_machw_change_vir_if(bool bValue)
 	u32 reg;
 
 	/*Reset WILC_CHANGING_VIR_IF register to allow adding futrue keys to CE H/W*/
-	mutex_lock((&g_wlan)->hif_lock);
+	mutex_lock(&g_linux_wlan->hif_cs);
 	ret = (&g_wlan)->hif_func.hif_read_reg(WILC_CHANGING_VIR_IF, &reg);
 	if (!ret) {
 		PRINT_ER("Error while Reading reg WILC_CHANGING_VIR_IF\n");
@@ -2104,7 +2102,7 @@ u16 Set_machw_change_vir_if(bool bValue)
 	if (!ret) {
 		PRINT_ER("Error while writing reg WILC_CHANGING_VIR_IF\n");
 	}
-	mutex_unlock((&g_wlan)->hif_lock);
+	mutex_unlock(&g_linux_wlan->hif_cs);
 
 	return ret;
 }
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 6f19277..42013e7 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -107,9 +107,6 @@ typedef struct {
 
 typedef struct {
 	void *os_private;
-
-	struct mutex *hif_critical_section;
-
 	u32 tx_buffer_size;
 	void *txq_critical_section;
 #if defined(MEMORY_STATIC)
-- 
1.9.1

