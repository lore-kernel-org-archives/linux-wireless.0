Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3416 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbJAHEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 03:04:13 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/12] staging: wilc1000: remove function pointer wlan_stop
Date: Thu, 1 Oct 2015 16:03:34 +0900
Message-ID: <1443683023-6498-3-git-send-email-tony.cho@atmel.com> (sfid-20151001_090416_162056_7CBB317A)
In-Reply-To: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
References: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer wlan_stop and just call
the function wilc_wlan_stop. Remove static from the function also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 10 ++--------
 drivers/staging/wilc1000/wilc_wlan.c    |  3 +--
 drivers/staging/wilc1000/wilc_wlan.h    |  1 +
 drivers/staging/wilc1000/wilc_wlan_if.h |  1 -
 4 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f515fca..245357e 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -983,10 +983,7 @@ void wilc1000_wlan_deinit(linux_wlan_t *nic)
 		PRINT_D(INIT_DBG, "Deinitializing IRQ\n");
 		deinit_irq(g_linux_wlan);
 
-		if (&g_linux_wlan->oup != NULL) {
-			if (g_linux_wlan->oup.wlan_stop != NULL)
-				g_linux_wlan->oup.wlan_stop();
-		}
+		wilc_wlan_stop();
 
 		PRINT_D(INIT_DBG, "Deinitializing WILC Wlan\n");
 		wilc_wlan_deinit(nic);
@@ -1322,10 +1319,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		return 0; /*success*/
 
 _fail_fw_start_:
-		if (&g_linux_wlan->oup != NULL) {
-			if (g_linux_wlan->oup.wlan_stop != NULL)
-				g_linux_wlan->oup.wlan_stop();
-		}
+		wilc_wlan_stop();
 
 _fail_irq_enable_:
 #if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 6e2bf4c..745953c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1581,7 +1581,7 @@ void wilc_wlan_global_reset(void)
 	p->hif_func.hif_write_reg(WILC_GLB_RESET_0, 0x0);
 	release_bus(RELEASE_ONLY);
 }
-static int wilc_wlan_stop(void)
+int wilc_wlan_stop(void)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	u32 reg = 0;
@@ -2027,7 +2027,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	/**
 	 *      export functions
 	 **/
-	oup->wlan_stop = wilc_wlan_stop;
 	oup->wlan_add_to_tx_que = wilc_wlan_txq_add_net_pkt;
 	oup->wlan_handle_tx_que = wilc_wlan_handle_txq;
 	oup->wlan_handle_rx_isr = wilc_handle_isr;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 15ae9ae..b32ba4f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -307,4 +307,5 @@ typedef struct {
 
 int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size);
 int wilc_wlan_start(void);
+int wilc_wlan_stop(void);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index e752092..9e749c7 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -122,7 +122,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define WILC_TX_ERR_NO_BUF	(-2)
 
 typedef struct {
-	int (*wlan_stop)(void);
 	int (*wlan_add_to_tx_que)(void *, u8 *, u32, wilc_tx_complete_func_t);
 	int (*wlan_handle_tx_que)(u32 *);
 	void (*wlan_handle_rx_isr)(void);
-- 
1.9.1

