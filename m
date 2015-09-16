Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5564 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbIPBoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 21:44:02 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 01/10] staging: wilc1000: remove PANDA_BOARD
Date: Wed, 16 Sep 2015 10:43:46 +0900
Message-ID: <1442367835-30733-2-git-send-email-tony.cho@atmel.com> (sfid-20150916_034407_097171_D24E5FC1)
In-Reply-To: <1442367835-30733-1-git-send-email-tony.cho@atmel.com>
References: <1442367835-30733-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes one of the platform dependencies, PANDA_BOARD from the
driver codes. The device tree will provide the platform dependencies in
the future commits.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 4 ----
 drivers/staging/wilc1000/linux_wlan_common.h  | 3 ---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 4 ----
 3 files changed, 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 6ad8cd5..bd77eb3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -435,10 +435,6 @@ static int init_irq(linux_wlan_t *p_nic)
  *
  * ex) nic->dev_irq_num = gpio_to_irq(GPIO_NUM);
  */
-#elif defined(PANDA_BOARD)
-		gpio_export(GPIO_NUM, 1);
-		nic->dev_irq_num = OMAP_GPIO_IRQ(GPIO_NUM);
-		irq_set_irq_type(nic->dev_irq_num, IRQ_TYPE_LEVEL_LOW);
 #else
 		nic->dev_irq_num = gpio_to_irq(GPIO_NUM);
 #endif
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index ea121f9..5d13c15 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -145,9 +145,6 @@ extern atomic_t DEBUG_LEVEL;
 		#define MODALIAS	"wilc_spi3"
 		#define GPIO_NUM	133
 	#endif
-#elif defined(PANDA_BOARD)
-	#define MODALIAS	"WILC_SPI"
-	#define GPIO_NUM	139
 #elif defined(PLAT_WMS8304)             /* rachel */
 	#define MODALIAS	"wilc_spi"
 	#define GPIO_NUM	139
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 6ea5c87f..904d9c3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -80,11 +80,7 @@ struct WILC_WFI_stats {
  * LPC3131 which is important to get the MAC start status when you are blocked
  * inside linux_wlan_firmware_download() which blocks mac_open().
  */
-#if defined(PANDA_BOARD)
- #define RX_BH_TYPE  RX_BH_THREADED_IRQ
-#else
  #define RX_BH_TYPE  RX_BH_KTHREAD
-#endif
 
 struct wilc_wfi_key {
 	u8 *key;
-- 
1.9.1

