Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35336 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbE3Uoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2015 16:44:44 -0400
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Subject: [PATCH 1/2] staging: wilc1000: Fix some compile warnings
Date: Sat, 30 May 2015 23:44:18 +0300
Message-Id: <1433018659-25958-1-git-send-email-kholmanskikh.s.s@gmail.com> (sfid-20150530_224511_329434_C7A4448B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reduces (a little bit) the amount of compile time
warnings.

The change of WILC_WFI_init_mon_interface() prototype seems to be ok,
because alloc_netdev() also expects 'const char *name'.

Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
---
 drivers/staging/wilc1000/linux_mon.c              | 2 +-
 drivers/staging/wilc1000/wilc_spi.c               | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c              | 6 ++----
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index a19be45..f0a20a9 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -522,7 +522,7 @@ static void WILC_WFI_mon_setup(struct net_device *dev)
  *  @date	12 JUL 2012
  *  @version	1.0
  */
-struct net_device *WILC_WFI_init_mon_interface(char *name, struct net_device *real_dev)
+struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev)
 {
 
 
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 2f38dda..46f28ca 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1194,10 +1194,10 @@ static int spi_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 		/* Read failed. Try with CRC off. This might happen when module
 		 * is removed but chip isn't reset*/
 		g_spi.crc_off = 1;
-		PRINT_ER("[wilc spi]: Failed internal read protocol with CRC on, retyring with CRC off...\n", __LINE__);
+		PRINT_ER("[wilc spi %d]: Failed internal read protocol with CRC on, retyring with CRC off...\n", __LINE__);
 		if (!spi_internal_read(WILC_SPI_PROTOCOL_OFFSET, &reg)) {
-			/* Reaad failed with both CRC on and off, something went bad */
-			PRINT_ER("[wilc spi]: Failed internal read protocol...\n", __LINE__);
+			/* Read failed with both CRC on and off, something went bad */
+			PRINT_ER("[wilc spi %d]: Failed internal read protocol...\n", __LINE__);
 			return 0;
 		}
 	}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 9eb8f37..b63c746 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -123,7 +123,7 @@ int WILC_WFI_DeInitHostInt(struct net_device *net);
 int WILC_WFI_InitHostInt(struct net_device *net);
 void WILC_WFI_monitor_rx(uint8_t *buff, uint32_t size);
 int WILC_WFI_deinit_mon_interface(void);
-struct net_device *WILC_WFI_init_mon_interface(char *name, struct net_device *real_dev);
+struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev);
 
 #ifdef TCP_ENHANCEMENTS
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH 54
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 92ed42a..bdee5e6 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -894,8 +894,6 @@ INLINE void chip_wakeup(void)
 #endif
 void chip_sleep_manually(WILC_Uint32 u32SleepTime)
 {
-	uint32_t val32;
-
 	if (genuChipPSstate != CHIP_WAKEDUP) {
 		/* chip is already sleeping. Do nothing */
 		return;
@@ -2302,7 +2300,7 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 #else
 		g_wlan.tx_buffer = (uint8_t *)g_wlan.os_func.os_malloc(g_wlan.tx_buffer_size);
 #endif
-	PRINT_D(TX_DBG, "g_wlan.tx_buffer = 0x%x\n", g_wlan.tx_buffer);
+	PRINT_D(TX_DBG, "g_wlan.tx_buffer = 0x%p\n", g_wlan.tx_buffer);
 
 	if (g_wlan.tx_buffer == WILC_NULL) {
 		/* ENOBUFS	105 */
@@ -2319,7 +2317,7 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
   #else
 		g_wlan.rx_buffer = (uint8_t *)g_wlan.os_func.os_malloc(g_wlan.rx_buffer_size);
   #endif
-	PRINT_D(TX_DBG, "g_wlan.rx_buffer =0x%x\n", g_wlan.rx_buffer);
+	PRINT_D(TX_DBG, "g_wlan.rx_buffer =0x%p\n", g_wlan.rx_buffer);
 	if (g_wlan.rx_buffer == WILC_NULL) {
 		/* ENOBUFS	105 */
 		ret = -105;
-- 
1.9.1

