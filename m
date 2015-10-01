Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3515 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbbJAHEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 03:04:39 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/12] staging: wilc1000: remove function pointer wlan_cleanup
Date: Thu, 1 Oct 2015 16:03:38 +0900
Message-ID: <1443683023-6498-7-git-send-email-tony.cho@atmel.com> (sfid-20151001_090442_264455_F28DF79B)
In-Reply-To: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
References: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer wlan_cleanup and just call the function
wilc_wlan_cleanup. Remove static from the function also.
After changing function pointer wlan_cleanup with wilc_wlan_cleanup,
the define wilc_wlan_deinit will be like folowing.

-define wilc_wlan_deinit(nic)  { wilc_wlan_cleanup(); }

The define is unnecessary so just call wilc_wlan_cleanup instead of
wilc_wlan_deinit() and remove the define also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 10 +++-------
 drivers/staging/wilc1000/wilc_wlan.c    |  3 +--
 drivers/staging/wilc1000/wilc_wlan.h    |  1 +
 drivers/staging/wilc1000/wilc_wlan_if.h |  1 -
 4 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e278d94..9e22247 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -86,10 +86,6 @@ static struct notifier_block g_dev_notifier = {
 	.notifier_call = dev_state_ev_handler
 };
 
-#define wilc_wlan_deinit(nic)	{ if (&g_linux_wlan->oup != NULL)	 \
-		if (g_linux_wlan->oup.wlan_cleanup != NULL) \
-			g_linux_wlan->oup.wlan_cleanup(); }
-
 #define IRQ_WAIT	1
 #define IRQ_NO_WAIT	0
 /*
@@ -983,7 +979,7 @@ void wilc1000_wlan_deinit(linux_wlan_t *nic)
 		wilc_wlan_stop();
 
 		PRINT_D(INIT_DBG, "Deinitializing WILC Wlan\n");
-		wilc_wlan_deinit(nic);
+		wilc_wlan_cleanup();
 #if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
   #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
 		PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
@@ -1132,7 +1128,7 @@ u8 wilc1000_prepare_11b_core(wilc_wlan_inp_t *nwi,	wilc_wlan_oup_t *nwo, linux_w
 
 	while ((core_11b_ready() && (READY_CHECK_THRESHOLD > (trials++)))) {
 		PRINT_D(INIT_DBG, "11b core not ready yet: %u\n", trials);
-		wilc_wlan_deinit(nic);
+		wilc_wlan_cleanup();
 		wilc_wlan_global_reset();
 		sdio_unregister_driver(&wilc_bus);
 
@@ -1330,7 +1326,7 @@ _fail_irq_init_:
 _fail_threads_:
 		wlan_deinitialize_threads(g_linux_wlan);
 _fail_wilc_wlan_:
-		wilc_wlan_deinit(g_linux_wlan);
+		wilc_wlan_cleanup();
 _fail_locks_:
 		wlan_deinit_locks(g_linux_wlan);
 		PRINT_ER("WLAN Iinitialization FAILED\n");
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index e9af745..d352f24 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1652,7 +1652,7 @@ int wilc_wlan_stop(void)
 	return ret;
 }
 
-static void wilc_wlan_cleanup(void)
+void wilc_wlan_cleanup(void)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	struct txq_entry_t *tqe;
@@ -2028,7 +2028,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	/**
 	 *      export functions
 	 **/
-	oup->wlan_cleanup = wilc_wlan_cleanup;
 	oup->wlan_cfg_set = wilc_wlan_cfg_set;
 	oup->wlan_cfg_get = wilc_wlan_cfg_get;
 	oup->wlan_cfg_get_value = wilc_wlan_cfg_get_val;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 2054ad5..198ddb7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -312,4 +312,5 @@ int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size,
 			      wilc_tx_complete_func_t func);
 int wilc_wlan_handle_txq(u32 *pu32TxqCount);
 void wilc_handle_isr(void);
+void wilc_wlan_cleanup(void);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 91bf68a..624b99f 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -122,7 +122,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define WILC_TX_ERR_NO_BUF	(-2)
 
 typedef struct {
-	void (*wlan_cleanup)(void);
 	int (*wlan_cfg_set)(int, u32, u8 *, u32, int, u32);
 	int (*wlan_cfg_get)(int, u32, int, u32);
 	int (*wlan_cfg_get_value)(u32, u8 *, u32);
-- 
1.9.1

