Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35265 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbbFAS4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 14:56:34 -0400
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Subject: [PATCH v2 1/4] staging: wilc1000: Fix some compile time warnings
Date: Mon,  1 Jun 2015 21:56:18 +0300
Message-Id: <1433184981-6077-1-git-send-email-kholmanskikh.s.s@gmail.com> (sfid-20150601_205737_126763_5CB90846)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
---
Changes since V1:

Split the V1 series into more logically unrelated patches
and updated patch descriptions accordingly.

 drivers/staging/wilc1000/wilc_spi.c  | 6 +++---
 drivers/staging/wilc1000/wilc_wlan.c | 6 ++----
 2 files changed, 5 insertions(+), 7 deletions(-)

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

