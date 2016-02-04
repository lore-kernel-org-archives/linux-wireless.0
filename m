Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:10324 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966103AbcBDJ0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:26:33 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH RESEND 32/70] staging: wilc1000: fix warnings for line over 80 characters
Date: Thu, 4 Feb 2016 18:15:49 +0900
Message-ID: <1454577387-509-33-git-send-email-glen.lee@atmel.com> (sfid-20160204_102646_065458_F9465671)
In-Reply-To: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
References: <1454577387-509-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch fixes warnings reported by checkpatch.pl
for line over 80 characters

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 33 ++++++++++++++++++++-------------
 drivers/staging/wilc1000/wilc_wlan.h |  3 ++-
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ebf38a5..a6f4e15 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -113,7 +113,8 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 	up(&wilc->txq_event);
 }
 
-static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif, struct txq_entry_t *tqe)
+static int wilc_wlan_txq_add_to_head(struct wilc_vif *vif,
+				     struct txq_entry_t *tqe)
 {
 	unsigned long flags;
 	struct wilc *wilc = vif->wilc;
@@ -695,8 +696,9 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 		acquire_bus(wilc, ACQUIRE_AND_WAKEUP);
 		counter = 0;
 		do {
-			ret = wilc->hif_func->hif_read_reg(wilc, WILC_HOST_TX_CTRL,
-						       &reg);
+			ret = wilc->hif_func->hif_read_reg(wilc,
+							   WILC_HOST_TX_CTRL,
+							   &reg);
 			if (!ret) {
 				wilc_debug(N_ERR, "[wilc txq]: fail can't read reg vmm_tbl_entry..\n");
 				break;
@@ -728,8 +730,9 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				break;
 			}
 
-			ret = wilc->hif_func->hif_write_reg(wilc, WILC_HOST_VMM_CTL,
-							0x2);
+			ret = wilc->hif_func->hif_write_reg(wilc,
+							    WILC_HOST_VMM_CTL,
+							    0x2);
 			if (!ret) {
 				wilc_debug(N_ERR, "[wilc txq]: fail can't write reg host_vmm_ctl..\n");
 				break;
@@ -1063,7 +1066,8 @@ void wilc_handle_isr(struct wilc *wilc)
 }
 EXPORT_SYMBOL_GPL(wilc_handle_isr);
 
-int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer, u32 buffer_size)
+int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
+				u32 buffer_size)
 {
 	u32 offset;
 	u32 addr, size, size2, blksz;
@@ -1096,8 +1100,8 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer, u32 buffer_
 				size2 = blksz;
 
 			memcpy(dma_buffer, &buffer[offset], size2);
-			ret = wilc->hif_func->hif_block_tx(wilc, addr, dma_buffer,
-						       size2);
+			ret = wilc->hif_func->hif_block_tx(wilc, addr,
+							   dma_buffer, size2);
 			if (!ret)
 				break;
 
@@ -1233,7 +1237,8 @@ int wilc_wlan_stop(struct wilc *wilc)
 	}
 
 	do {
-		ret = wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
+		ret = wilc->hif_func->hif_read_reg(wilc,
+						   WILC_GLB_RESET_0, &reg);
 		if (!ret) {
 			PRINT_ER("Error while reading reg\n");
 			release_bus(wilc, RELEASE_ALLOW_SLEEP);
@@ -1246,14 +1251,16 @@ int wilc_wlan_stop(struct wilc *wilc)
 			PRINT_D(GENERIC_DBG, "Bit 10 not reset : Retry %d\n",
 				timeout);
 			reg &= ~BIT(10);
-			ret = wilc->hif_func->hif_write_reg(wilc, WILC_GLB_RESET_0,
-							reg);
+			ret = wilc->hif_func->hif_write_reg(wilc,
+							    WILC_GLB_RESET_0,
+							    reg);
 			timeout--;
 		} else {
 			PRINT_D(GENERIC_DBG, "Bit 10 reset after : Retry %d\n",
 				timeout);
-			ret = wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0,
-						       &reg);
+			ret = wilc->hif_func->hif_read_reg(wilc,
+							   WILC_GLB_RESET_0,
+							   &reg);
 			if (!ret) {
 				PRINT_ER("Error while reading reg\n");
 				release_bus(wilc, RELEASE_ALLOW_SLEEP);
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index e913ae7..d362fa8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -270,7 +270,8 @@ struct wilc_cfg_rsp {
 struct wilc;
 struct wilc_vif;
 
-int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer, u32 buffer_size);
+int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
+				u32 buffer_size);
 int wilc_wlan_start(struct wilc *);
 int wilc_wlan_stop(struct wilc *);
 int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
-- 
1.9.1

