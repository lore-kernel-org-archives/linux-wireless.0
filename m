Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:53861 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754656AbeBPPMh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 10:12:37 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 12/12] staging: wilc1000: fix line over 80 chars in wilc_wlan_handle_txq()
Date: Fri, 16 Feb 2018 20:41:49 +0530
Message-ID: <1518793909-15573-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180216_161242_794400_E463B283)
In-Reply-To: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "line over 80 characters" issue reported by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 38 +++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 98cd949..1a9ef1a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -576,6 +576,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 	u32 vmm_table[WILC_VMM_TBL_SIZE];
 	struct wilc_vif *vif;
 	struct wilc *wilc;
+	const struct wilc_hif_func *func;
 
 	vif = netdev_priv(dev);
 	wilc = vif->wilc;
@@ -629,10 +630,9 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 
 		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 		counter = 0;
+		func = wilc->hif_func;
 		do {
-			ret = wilc->hif_func->hif_read_reg(wilc,
-							   WILC_HOST_TX_CTRL,
-							   &reg);
+			ret = func->hif_read_reg(wilc, WILC_HOST_TX_CTRL, &reg);
 			if (!ret)
 				break;
 
@@ -642,7 +642,8 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 			counter++;
 			if (counter > 200) {
 				counter = 0;
-				ret = wilc->hif_func->hif_write_reg(wilc, WILC_HOST_TX_CTRL, 0);
+				ret = func->hif_write_reg(wilc,
+							  WILC_HOST_TX_CTRL, 0);
 				break;
 			}
 		} while (!wilc->quit);
@@ -652,18 +653,21 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 
 		timeout = 200;
 		do {
-			ret = wilc->hif_func->hif_block_tx(wilc, WILC_VMM_TBL_RX_SHADOW_BASE, (u8 *)vmm_table, ((i + 1) * 4));
+			ret = func->hif_block_tx(wilc,
+						 WILC_VMM_TBL_RX_SHADOW_BASE,
+						 (u8 *)vmm_table,
+						 ((i + 1) * 4));
 			if (!ret)
 				break;
 
-			ret = wilc->hif_func->hif_write_reg(wilc,
-							    WILC_HOST_VMM_CTL,
-							    0x2);
+			ret = func->hif_write_reg(wilc, WILC_HOST_VMM_CTL, 0x2);
 			if (!ret)
 				break;
 
 			do {
-				ret = wilc->hif_func->hif_read_reg(wilc, WILC_HOST_VMM_CTL, &reg);
+				ret = func->hif_read_reg(wilc,
+							 WILC_HOST_VMM_CTL,
+							 &reg);
 				if (!ret)
 					break;
 				if ((reg >> 2) & 0x1) {
@@ -673,7 +677,9 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				release_bus(wilc, RELEASE_ALLOW_SLEEP);
 			} while (--timeout);
 			if (timeout <= 0) {
-				ret = wilc->hif_func->hif_write_reg(wilc, WILC_HOST_VMM_CTL, 0x0);
+				ret = func->hif_write_reg(wilc,
+							  WILC_HOST_VMM_CTL,
+							  0x0);
 				break;
 			}
 
@@ -681,11 +687,15 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				break;
 
 			if (entries == 0) {
-				ret = wilc->hif_func->hif_read_reg(wilc, WILC_HOST_TX_CTRL, &reg);
+				ret = func->hif_read_reg(wilc,
+							 WILC_HOST_TX_CTRL,
+							 &reg);
 				if (!ret)
 					break;
 				reg &= ~BIT(0);
-				ret = wilc->hif_func->hif_write_reg(wilc, WILC_HOST_TX_CTRL, reg);
+				ret = func->hif_write_reg(wilc,
+							  WILC_HOST_TX_CTRL,
+							  reg);
 				if (!ret)
 					break;
 				break;
@@ -753,11 +763,11 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 
 		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 
-		ret = wilc->hif_func->hif_clear_int_ext(wilc, ENABLE_TX_VMM);
+		ret = func->hif_clear_int_ext(wilc, ENABLE_TX_VMM);
 		if (!ret)
 			goto _end_;
 
-		ret = wilc->hif_func->hif_block_tx_ext(wilc, 0, txb, offset);
+		ret = func->hif_block_tx_ext(wilc, 0, txb, offset);
 		if (!ret)
 			goto _end_;
 
-- 
2.7.4
