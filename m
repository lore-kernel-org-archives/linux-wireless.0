Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:52275 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750AbcALHf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 02:35:58 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/26] staging: wilc1000: support suspend/resume functionality
Date: Tue, 12 Jan 2016 16:39:32 +0900
Message-ID: <1452584395-24910-4-git-send-email-glen.lee@atmel.com> (sfid-20160112_083601_288458_41116C49)
In-Reply-To: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
References: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc supports suspend/resume functionality. Introduce new sleep and wakeup
functions and remove old codes since that will be handled in the new functions.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 31 +++++++++++++++++++------------
 drivers/staging/wilc1000/wilc_wlan.h |  4 +++-
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index dabb0bd..977bd8a0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -522,6 +522,7 @@ static inline void chip_allow_sleep(struct wilc *wilc)
 	wilc->hif_func->hif_read_reg(wilc, 0xf0, &reg);
 
 	wilc->hif_func->hif_write_reg(wilc, 0xf0, reg & ~BIT(0));
+	wilc->hif_func->hif_write_reg(wilc, 0xfa, 0);
 }
 
 static inline void chip_wakeup(struct wilc *wilc)
@@ -543,6 +544,8 @@ static inline void chip_wakeup(struct wilc *wilc)
 
 		} while (wilc_get_chipid(wilc, true) == 0);
 	} else if ((wilc->io_type & 0x1) == HIF_SDIO)	 {
+		wilc->hif_func->hif_write_reg(wilc, 0xfa, 1);
+		udelay(200);
 		wilc->hif_func->hif_read_reg(wilc, 0xf0, &reg);
 		do {
 			wilc->hif_func->hif_write_reg(wilc, 0xf0,
@@ -567,11 +570,7 @@ static inline void chip_wakeup(struct wilc *wilc)
 	}
 
 	if (chip_ps_state == CHIP_SLEEPING_MANUAL) {
-		wilc->hif_func->hif_read_reg(wilc, 0x1C0C, &reg);
-		reg &= ~BIT(0);
-		wilc->hif_func->hif_write_reg(wilc, 0x1C0C, reg);
-
-		if (wilc_get_chipid(wilc, false) >= 0x1002b0) {
+		if (wilc_get_chipid(wilc, false) < 0x1002b0) {
 			u32 val32;
 
 			wilc->hif_func->hif_read_reg(wilc, 0x1e1c, &val32);
@@ -599,6 +598,20 @@ void wilc_chip_sleep_manually(struct wilc *wilc)
 	release_bus(wilc, RELEASE_ONLY);
 }
 
+void host_wakeup_notify(struct wilc *wilc)
+{
+	acquire_bus(wilc, ACQUIRE_ONLY);
+	wilc->hif_func->hif_write_reg(wilc, 0x10b0, 1);
+	release_bus(wilc, RELEASE_ONLY);
+}
+
+void host_sleep_notify(struct wilc *wilc)
+{
+	acquire_bus(wilc, ACQUIRE_ONLY);
+	wilc->hif_func->hif_write_reg(wilc, 0x10ac, 1);
+	release_bus(wilc, RELEASE_ONLY);
+}
+
 int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 {
 	int i, entries = 0;
@@ -701,9 +714,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 					break;
 				}
 				PRINT_WRN(GENERIC_DBG, "[wilc txq]: warn, vmm table not clear yet, wait...\n");
-				release_bus(wilc, RELEASE_ALLOW_SLEEP);
-				usleep_range(3000, 3000);
-				acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 			}
 		} while (!wilc->quit);
 
@@ -736,9 +746,6 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 					break;
 				} else {
 					release_bus(wilc, RELEASE_ALLOW_SLEEP);
-					usleep_range(3000, 3000);
-					acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
-					PRINT_WRN(GENERIC_DBG, "Can't get VMM entery - reg = %2x\n", reg);
 				}
 			} while (--timeout);
 			if (timeout <= 0) {
@@ -1156,7 +1163,7 @@ int wilc_wlan_start(struct wilc *wilc)
 #ifdef WILC_EXT_PA_INV_TX_RX
 	reg |= WILC_HAVE_EXT_PA_INV_TX_RX;
 #endif
-
+	reg |= WILC_HAVE_USE_IRQ_AS_HOST_WAKE;
 	reg |= WILC_HAVE_LEGACY_RF_SETTINGS;
 #ifdef XTAL_24
 	reg |= WILC_HAVE_XTAL_24;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 2edd744..dd5abc5 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -106,6 +106,7 @@
 #define WILC_HAVE_LEGACY_RF_SETTINGS	BIT(5)
 #define WILC_HAVE_XTAL_24		BIT(6)
 #define WILC_HAVE_DISABLE_WILC_UART	BIT(7)
+#define WILC_HAVE_USE_IRQ_AS_HOST_WAKE	BIT(8)
 
 /********************************************
  *
@@ -294,7 +295,8 @@ int wilc_mac_close(struct net_device *ndev);
 
 int wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID);
 void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
-
+void host_wakeup_notify(struct wilc *wilc);
+void host_sleep_notify(struct wilc *wilc);
 extern bool wilc_enable_ps;
 
 #endif
-- 
1.9.1

