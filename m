Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:27168 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbbIJJ0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 05:26:43 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/5] staging: wilc1000: remove unused global variables
Date: Thu, 10 Sep 2015 18:26:28 +0900
Message-ID: <1441877190-4546-3-git-send-email-tony.cho@atmel.com> (sfid-20150910_112646_068697_FA5A78A9)
In-Reply-To: <1441877190-4546-1-git-send-email-tony.cho@atmel.com>
References: <1441877190-4546-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the followings from the driver because they are in
debugging purpose but not used anymore.
- int_clrd
- int_rcvdU
- int_rcvdB
- android_wifi_priv_cmd structure

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 17 -----------------
 drivers/staging/wilc1000/wilc_sdio.c  |  3 ---
 drivers/staging/wilc1000/wilc_spi.c   |  3 ---
 3 files changed, 23 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8e19095..63f44f8 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -101,12 +101,6 @@ static struct notifier_block g_dev_notifier = {
 		if (g_linux_wlan->oup.wlan_cleanup != NULL) \
 			g_linux_wlan->oup.wlan_cleanup(); }
 
-typedef struct android_wifi_priv_cmd {
-	char *buf;
-	int used_len;
-	int total_len;
-} android_wifi_priv_cmd;
-
 #define IRQ_WAIT	1
 #define IRQ_NO_WAIT	0
 /*
@@ -116,9 +110,6 @@ typedef struct android_wifi_priv_cmd {
  *      deinitialized from mdoule_exit
  */
 static struct semaphore close_exit_sync;
-unsigned int int_rcvdU;
-unsigned int int_rcvdB;
-unsigned int int_clrd;
 
 static int wlan_deinit_locks(linux_wlan_t *nic);
 static void wlan_deinitialize_threads(linux_wlan_t *nic);
@@ -340,7 +331,6 @@ void linux_wlan_disable_irq(int wait)
 #if (defined WILC_SPI) || (defined WILC_SDIO_IRQ_GPIO)
 static irqreturn_t isr_uh_routine(int irq, void *user_data)
 {
-	int_rcvdU++;
 #if (RX_BH_TYPE != RX_BH_THREADED_IRQ)
 	linux_wlan_disable_irq(IRQ_NO_WAIT);
 #endif
@@ -395,7 +385,6 @@ static void isr_bh_routine(struct work_struct *work)
 	#endif
 	}
 
-	int_rcvdB++;
 	PRINT_D(INT_DBG, "Interrupt received BH\n");
 	if (g_linux_wlan->oup.wlan_handle_rx_isr != 0)
 		g_linux_wlan->oup.wlan_handle_rx_isr();
@@ -422,7 +411,6 @@ static int isr_bh_routine(void *vp)
 
 			break;
 		}
-		int_rcvdB++;
 		PRINT_D(INT_DBG, "Interrupt received BH\n");
 		if (g_linux_wlan->oup.wlan_handle_rx_isr != 0)
 			g_linux_wlan->oup.wlan_handle_rx_isr();
@@ -1792,7 +1780,6 @@ int mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	nic = netdev_priv(ndev);
 
-	PRINT_D(INT_DBG, "\n========\n IntUH: %d - IntBH: %d - IntCld: %d\n========\n", int_rcvdU, int_rcvdB, int_clrd);
 	PRINT_D(TX_DBG, "Sending packet just received from TCP/IP\n");
 
 	/* Stop the network interface queue */
@@ -2096,10 +2083,6 @@ int wilc_netdev_init(void)
 	if (!g_linux_wlan)
 		return -ENOMEM;
 
-	/*Reset interrupt count debug*/
-	int_rcvdU = 0;
-	int_rcvdB = 0;
-	int_clrd = 0;
 	#ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
 	register_inetaddr_notifier(&g_dev_notifier);
 	#endif
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 5a18148..79aa4a1 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -32,7 +32,6 @@ static wilc_sdio_t g_sdio;
 static int sdio_write_reg(uint32_t addr, uint32_t data);
 static int sdio_read_reg(uint32_t addr, uint32_t *data);
 #endif
-extern unsigned int int_clrd;
 
 /********************************************
  *
@@ -167,7 +166,6 @@ static int sdio_clear_int(void)
 	cmd.address = 0x4;
 	cmd.data = 0;
 	g_sdio.sdio_cmd52(&cmd);
-	int_clrd++;
 
 	return cmd.data;
 #else
@@ -179,7 +177,6 @@ static int sdio_clear_int(void)
 	}
 	reg &= ~0x1;
 	sdio_write_reg(WILC_HOST_RX_CTRL_0, reg);
-	int_clrd++;
 	return 1;
 #endif
 
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index d7bb204..d9ccca9 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -10,8 +10,6 @@
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
 
-extern unsigned int int_clrd;
-
 /*
  * #include <linux/kernel.h>
  * #include <linux/string.h>
@@ -1030,7 +1028,6 @@ static int spi_clear_int(void)
 	}
 	reg &= ~0x1;
 	spi_write_reg(WILC_HOST_RX_CTRL_0, reg);
-	int_clrd++;
 	return 1;
 }
 
-- 
1.9.1

