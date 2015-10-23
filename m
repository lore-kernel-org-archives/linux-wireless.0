Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52043 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbbJWF1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:27:47 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 19/28] staging: wilc1000: wilc_wlan_cleanup: add parameter net_device *dev
Date: Fri, 23 Oct 2015 14:28:35 +0900
Message-ID: <1445578124-31486-19-git-send-email-glen.lee@atmel.com> (sfid-20151023_074659_408390_4A9148C1)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new function parameter net_device *dev and pass dev to
the functions.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.c  | 2 +-
 drivers/staging/wilc1000/wilc_wlan.h  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 05cb442..a73fe19 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -926,7 +926,7 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 		wilc_wlan_stop();
 
 		PRINT_D(INIT_DBG, "Deinitializing WILC Wlan\n");
-		wilc_wlan_cleanup();
+		wilc_wlan_cleanup(dev);
 #if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
   #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
 		PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
@@ -1171,7 +1171,7 @@ _fail_irq_init_:
 #endif
 		wlan_deinitialize_threads(dev);
 _fail_wilc_wlan_:
-		wilc_wlan_cleanup();
+		wilc_wlan_cleanup(dev);
 _fail_locks_:
 		wlan_deinit_locks(wl);
 		PRINT_ER("WLAN Iinitialization FAILED\n");
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 531d342..43df5f1 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1647,7 +1647,7 @@ int wilc_wlan_stop(void)
 	return ret;
 }
 
-void wilc_wlan_cleanup(void)
+void wilc_wlan_cleanup(struct net_device *dev)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	struct txq_entry_t *tqe;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 79b35e6..d0b2448 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -302,7 +302,7 @@ int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size,
 			      wilc_tx_complete_func_t func);
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount);
 void wilc_handle_isr(void *wilc);
-void wilc_wlan_cleanup(void);
+void wilc_wlan_cleanup(struct net_device *dev);
 int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		      int commit, u32 drvHandler);
 int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler);
-- 
1.9.1

