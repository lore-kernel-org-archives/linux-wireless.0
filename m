Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35125 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422699AbcFMKij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 06:38:39 -0400
Received: by mail-pa0-f45.google.com with SMTP id hl6so44780108pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2016 03:38:39 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 7/7] staging: wilc1000: Remove unused inclusion of semaphore header
Date: Mon, 13 Jun 2016 16:07:39 +0530
Message-Id: <1465814259-3009-8-git-send-email-binoy.jayan@linaro.org> (sfid-20160613_123902_678492_4B7FB440)
In-Reply-To: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unused inclusions of semaphore header and remove the same
from the todo list. Also remove the now unused wrapper 'wilc_lock_timeout'.
Semaphores are going away in the future.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/staging/wilc1000/TODO                 |  1 -
 drivers/staging/wilc1000/linux_wlan.c         | 12 ------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  3 +--
 drivers/staging/wilc1000/wilc_wlan.h          |  2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h       |  1 -
 5 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
index 95199d8..83e66b2 100644
--- a/drivers/staging/wilc1000/TODO
+++ b/drivers/staging/wilc1000/TODO
@@ -3,7 +3,6 @@ TODO:
 - remove OS wrapper functions
 - remove custom debug and tracing functions
 - rework comments and function headers(also coding style)
-- replace all semaphores with mutexes or completions
 - make spi and sdio components coexist in one build
 - turn compile-time platform configuration (BEAGLE_BOARD,
   PANDA_BOARD, PLAT_WMS8304, PLAT_RKXXXX, CUSTOMER_PLATFORM, ...)
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index ac537c7..66c1dd7 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -21,7 +21,6 @@
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/mutex.h>
-#include <linux/semaphore.h>
 #include <linux/completion.h>
 
 static int dev_state_ev_handler(struct notifier_block *this,
@@ -221,17 +220,6 @@ static void deinit_irq(struct net_device *dev)
 	}
 }
 
-int wilc_lock_timeout(struct wilc *nic, void *vp, u32 timeout)
-{
-	/* FIXME: replace with mutex_lock or wait_for_completion */
-	int error = -1;
-
-	if (vp)
-		error = down_timeout(vp,
-				     msecs_to_jiffies(timeout));
-	return error;
-}
-
 void wilc_mac_indicate(struct wilc *wilc, int flag)
 {
 	int status;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 5cc6a82..b1db761 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -131,7 +131,7 @@ struct wilc_priv {
 	struct wilc_wfi_key *wilc_gtk[MAX_NUM_STA];
 	struct wilc_wfi_key *wilc_ptk[MAX_NUM_STA];
 	u8 wilc_groupkey;
-	/* semaphores */
+	/* locks */
 	struct mutex scan_req_lock;
 	/*  */
 	bool gbAutoRateAdjusted;
@@ -225,7 +225,6 @@ int wilc1000_wlan_init(struct net_device *dev, struct wilc_vif *vif);
 
 void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void wilc_mac_indicate(struct wilc *wilc, int flag);
-int wilc_lock_timeout(struct wilc *wilc, void *, u32 timeout);
 void wilc_netdev_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc, struct device *, int io_type, int gpio,
 		     const struct wilc_hif_func *ops);
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 30e5312..de6c4dd 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -192,7 +192,7 @@
 
 #define ENABLE_RX_VMM		(SEL_VMM_TBL1 | EN_VMM)
 #define ENABLE_TX_VMM		(SEL_VMM_TBL0 | EN_VMM)
-/*time for expiring the semaphores of cfg packets*/
+/*time for expiring the completion of cfg packets*/
 #define CFG_PKTS_TIMEOUT	2000
 /********************************************
  *
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 410bfc0..439ac6f 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -10,7 +10,6 @@
 #ifndef WILC_WLAN_IF_H
 #define WILC_WLAN_IF_H
 
-#include <linux/semaphore.h>
 #include <linux/netdevice.h>
 
 /********************************************
-- 
2.7.4

