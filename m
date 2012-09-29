Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59077 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545Ab2I2Sg0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 14:36:26 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] ssb: move parallel flash config into an own struct
Date: Sat, 29 Sep 2012 20:36:17 +0200
Message-Id: <1348943778-23079-2-git-send-email-hauke@hauke-m.de> (sfid-20120929_203629_866755_D71204F9)
In-Reply-To: <1348943778-23079-1-git-send-email-hauke@hauke-m.de>
References: <1348943778-23079-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a preparing step for adding serial flash support.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 arch/mips/bcm47xx/nvram.c           |    4 ++--
 arch/mips/bcm47xx/wgt634u.c         |    8 ++++----
 drivers/ssb/driver_mipscore.c       |   14 +++++++-------
 include/linux/ssb/ssb_driver_mips.h |    9 ++++++---
 4 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/mips/bcm47xx/nvram.c b/arch/mips/bcm47xx/nvram.c
index d43ceff..48a4c70 100644
--- a/arch/mips/bcm47xx/nvram.c
+++ b/arch/mips/bcm47xx/nvram.c
@@ -43,8 +43,8 @@ static void early_nvram_init(void)
 #ifdef CONFIG_BCM47XX_SSB
 	case BCM47XX_BUS_TYPE_SSB:
 		mcore_ssb = &bcm47xx_bus.ssb.mipscore;
-		base = mcore_ssb->flash_window;
-		lim = mcore_ssb->flash_window_size;
+		base = mcore_ssb->pflash.window;
+		lim = mcore_ssb->pflash.window_size;
 		break;
 #endif
 #ifdef CONFIG_BCM47XX_BCMA
diff --git a/arch/mips/bcm47xx/wgt634u.c b/arch/mips/bcm47xx/wgt634u.c
index e9f9ec8..e80d585 100644
--- a/arch/mips/bcm47xx/wgt634u.c
+++ b/arch/mips/bcm47xx/wgt634u.c
@@ -156,10 +156,10 @@ static int __init wgt634u_init(void)
 					    SSB_CHIPCO_IRQ_GPIO);
 		}
 
-		wgt634u_flash_data.width = mcore->flash_buswidth;
-		wgt634u_flash_resource.start = mcore->flash_window;
-		wgt634u_flash_resource.end = mcore->flash_window
-					   + mcore->flash_window_size
+		wgt634u_flash_data.width = mcore->pflash.buswidth;
+		wgt634u_flash_resource.start = mcore->pflash.window;
+		wgt634u_flash_resource.end = mcore->pflash.window
+					   + mcore->pflash.window_size
 					   - 1;
 		return platform_add_devices(wgt634u_devices,
 					    ARRAY_SIZE(wgt634u_devices));
diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
index c625086..dcad2c4 100644
--- a/drivers/ssb/driver_mipscore.c
+++ b/drivers/ssb/driver_mipscore.c
@@ -192,9 +192,9 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
 
 	/* When there is no chipcommon on the bus there is 4MB flash */
 	if (!bus->chipco.dev) {
-		mcore->flash_buswidth = 2;
-		mcore->flash_window = SSB_FLASH1;
-		mcore->flash_window_size = SSB_FLASH1_SZ;
+		mcore->pflash.buswidth = 2;
+		mcore->pflash.window = SSB_FLASH1;
+		mcore->pflash.window_size = SSB_FLASH1_SZ;
 		return;
 	}
 
@@ -206,13 +206,13 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
 		break;
 	case SSB_CHIPCO_FLASHT_PARA:
 		pr_debug("Found parallel flash\n");
-		mcore->flash_window = SSB_FLASH2;
-		mcore->flash_window_size = SSB_FLASH2_SZ;
+		mcore->pflash.window = SSB_FLASH2;
+		mcore->pflash.window_size = SSB_FLASH2_SZ;
 		if ((ssb_read32(bus->chipco.dev, SSB_CHIPCO_FLASH_CFG)
 		               & SSB_CHIPCO_CFG_DS16) == 0)
-			mcore->flash_buswidth = 1;
+			mcore->pflash.buswidth = 1;
 		else
-			mcore->flash_buswidth = 2;
+			mcore->pflash.buswidth = 2;
 		break;
 	}
 }
diff --git a/include/linux/ssb/ssb_driver_mips.h b/include/linux/ssb/ssb_driver_mips.h
index 5f44e97..5d057db 100644
--- a/include/linux/ssb/ssb_driver_mips.h
+++ b/include/linux/ssb/ssb_driver_mips.h
@@ -13,6 +13,11 @@ struct ssb_serial_port {
 	unsigned int reg_shift;
 };
 
+struct ssb_pflash {
+	u8 buswidth;
+	u32 window;
+	u32 window_size;
+};
 
 struct ssb_mipscore {
 	struct ssb_device *dev;
@@ -20,9 +25,7 @@ struct ssb_mipscore {
 	int nr_serial_ports;
 	struct ssb_serial_port serial_ports[4];
 
-	u8 flash_buswidth;
-	u32 flash_window;
-	u32 flash_window_size;
+	struct ssb_pflash pflash;
 };
 
 extern void ssb_mipscore_init(struct ssb_mipscore *mcore);
-- 
1.7.9.5

