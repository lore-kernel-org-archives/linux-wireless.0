Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:20879 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965264AbbJ3DJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 23:09:09 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/17] staging: wilc1000: release_bus: add argument struct wilc
Date: Fri, 30 Oct 2015 12:10:40 +0900
Message-ID: <1446174642-28570-15-git-send-email-glen.lee@atmel.com> (sfid-20151030_040928_156099_2186E705)
In-Reply-To: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct wilc and use it instead of g_linux_wlan,
pass wilc to the functions as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 44 ++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a61dbea..898f60e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -122,13 +122,13 @@ static inline void acquire_bus(struct wilc *wilc, BUS_ACQUIRE_T acquire)
 	}
 
 }
-static inline void release_bus(BUS_RELEASE_T release)
+static inline void release_bus(struct wilc *wilc, BUS_RELEASE_T release)
 {
 	#ifdef WILC_OPTIMIZE_SLEEP_INT
 	if (release == RELEASE_ALLOW_SLEEP)
 		chip_allow_sleep();
 	#endif
-	mutex_unlock(&g_linux_wlan->hif_cs);
+	mutex_unlock(&wilc->hif_cs);
 }
 /********************************************
  *
@@ -831,7 +831,7 @@ void chip_sleep_manually(struct net_device *dev, u32 u32SleepTime)
 	g_wlan.hif_func.hif_write_reg(0x10a8, 1);
 
 	genuChipPSstate = CHIP_SLEEPING_MANUAL;
-	release_bus(RELEASE_ONLY);
+	release_bus(wilc, RELEASE_ONLY);
 
 }
 
@@ -954,7 +954,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 				 *      wait for vmm table is ready
 				 **/
 				PRINT_WRN(GENERIC_DBG, "[wilc txq]: warn, vmm table not clear yet, wait...\n");
-				release_bus(RELEASE_ALLOW_SLEEP);
+				release_bus(wilc, RELEASE_ALLOW_SLEEP);
 				usleep_range(3000, 3000);
 				acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 			}
@@ -1002,7 +1002,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 					entries = ((reg >> 3) & 0x3f);
 					break;
 				} else {
-					release_bus(RELEASE_ALLOW_SLEEP);
+					release_bus(wilc, RELEASE_ALLOW_SLEEP);
 					usleep_range(3000, 3000);
 					acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 					PRINT_WRN(GENERIC_DBG, "Can't get VMM entery - reg = %2x\n", reg);
@@ -1047,7 +1047,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 
 		/* since copying data into txb takes some time, then
 		 * allow the bus lock to be released let the RX task go. */
-		release_bus(RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 
 		/**
 		 *      Copy data to the TX buffer
@@ -1126,7 +1126,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 
 _end_:
 
-		release_bus(RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 		if (ret != 1)
 			break;
 	} while (0);
@@ -1412,7 +1412,7 @@ void wilc_handle_isr(void *wilc)
 #endif
 		wilc_unknown_isr_ext();
 	}
-	release_bus(RELEASE_ALLOW_SLEEP);
+	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 }
 
 /********************************************
@@ -1473,7 +1473,7 @@ int wilc_wlan_firmware_download(struct net_device *dev, const u8 *buffer,
 			offset += size2;
 			size -= size2;
 		}
-		release_bus(RELEASE_ONLY);
+		release_bus(wilc, RELEASE_ONLY);
 
 		if (!ret) {
 			/*EIO	5*/
@@ -1522,7 +1522,7 @@ int wilc_wlan_start(struct net_device *dev)
 	ret = p->hif_func.hif_write_reg(WILC_VMM_CORE_CFG, reg);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail write reg vmm_core_cfg...\n");
-		release_bus(RELEASE_ONLY);
+		release_bus(wilc, RELEASE_ONLY);
 		/* EIO  5*/
 		ret = -5;
 		return ret;
@@ -1563,7 +1563,7 @@ int wilc_wlan_start(struct net_device *dev)
 	ret = p->hif_func.hif_write_reg(WILC_GP_REG_1, reg);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail write WILC_GP_REG_1 ...\n");
-		release_bus(RELEASE_ONLY);
+		release_bus(wilc, RELEASE_ONLY);
 		/* EIO  5*/
 		ret = -5;
 		return ret;
@@ -1577,7 +1577,7 @@ int wilc_wlan_start(struct net_device *dev)
 	ret = p->hif_func.hif_read_reg(0x1000, &chipid);
 	if (!ret) {
 		wilc_debug(N_ERR, "[wilc start]: fail read reg 0x1000 ...\n");
-		release_bus(RELEASE_ONLY);
+		release_bus(wilc, RELEASE_ONLY);
 		/* EIO  5*/
 		ret = -5;
 		return ret;
@@ -1598,7 +1598,7 @@ int wilc_wlan_start(struct net_device *dev)
 	reg |= BIT(10);
 	ret = p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
 	p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
-	release_bus(RELEASE_ONLY);
+	release_bus(wilc, RELEASE_ONLY);
 
 	return (ret < 0) ? ret : 0;
 }
@@ -1621,7 +1621,7 @@ int wilc_wlan_stop(struct net_device *dev)
 	ret = p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
 	if (!ret) {
 		PRINT_ER("Error while reading reg\n");
-		release_bus(RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 		return ret;
 	}
 
@@ -1631,7 +1631,7 @@ int wilc_wlan_stop(struct net_device *dev)
 	ret = p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
 	if (!ret) {
 		PRINT_ER("Error while writing reg\n");
-		release_bus(RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 		return ret;
 	}
 
@@ -1641,7 +1641,7 @@ int wilc_wlan_stop(struct net_device *dev)
 		ret = p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
 		if (!ret) {
 			PRINT_ER("Error while reading reg\n");
-			release_bus(RELEASE_ALLOW_SLEEP);
+			release_bus(wilc, RELEASE_ALLOW_SLEEP);
 			return ret;
 		}
 		PRINT_D(GENERIC_DBG, "Read RESET Reg %x : Retry%d\n", reg, timeout);
@@ -1656,7 +1656,7 @@ int wilc_wlan_stop(struct net_device *dev)
 			ret = p->hif_func.hif_read_reg(WILC_GLB_RESET_0, &reg);
 			if (!ret) {
 				PRINT_ER("Error while reading reg\n");
-				release_bus(RELEASE_ALLOW_SLEEP);
+				release_bus(wilc, RELEASE_ALLOW_SLEEP);
 				return ret;
 			}
 			PRINT_D(GENERIC_DBG, "Read RESET Reg %x : Retry%d\n", reg, timeout);
@@ -1672,7 +1672,7 @@ int wilc_wlan_stop(struct net_device *dev)
 
 	ret = p->hif_func.hif_write_reg(WILC_GLB_RESET_0, reg);
 
-	release_bus(RELEASE_ALLOW_SLEEP);
+	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 
 	return ret;
 }
@@ -1726,15 +1726,15 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	ret = p->hif_func.hif_read_reg(WILC_GP_REG_0, &reg);
 	if (!ret) {
 		PRINT_ER("Error while reading reg\n");
-		release_bus(RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 	}
 	PRINT_ER("Writing ABORT reg\n");
 	ret = p->hif_func.hif_write_reg(WILC_GP_REG_0, (reg | ABORT_INT));
 	if (!ret) {
 		PRINT_ER("Error while writing reg\n");
-		release_bus(RELEASE_ALLOW_SLEEP);
+		release_bus(wilc, RELEASE_ALLOW_SLEEP);
 	}
-	release_bus(RELEASE_ALLOW_SLEEP);
+	release_bus(wilc, RELEASE_ALLOW_SLEEP);
 	/**
 	 *      io clean up
 	 **/
@@ -1931,7 +1931,7 @@ u32 init_chip(struct net_device *dev)
 		}
 	}
 
-	release_bus(RELEASE_ONLY);
+	release_bus(wilc, RELEASE_ONLY);
 
 	return ret;
 
-- 
1.9.1

