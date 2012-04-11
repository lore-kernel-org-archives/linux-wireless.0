Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:60630 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933046Ab2DKTyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 15:54:03 -0400
Received: by lbbgm6 with SMTP id gm6so1398917lbb.33
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 12:53:59 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, coelho@ti.com
Subject: [PATCH 12/24] wlcore/wl12xx: turn no-Tx-align quirk into Tx-align
Date: Wed, 11 Apr 2012 22:53:28 +0300
Message-Id: <1334174020-18957-13-git-send-email-coelho@ti.com> (sfid-20120411_215447_564044_E3F9AABE)
In-Reply-To: <1334174020-18957-1-git-send-email-coelho@ti.com>
References: <1334174020-18957-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Inverting the quirk flag to indicate Tx-alignment. This aligns it with
the similar Rx-side quirk.

The call to wl1271_set_block_size() decides whether SDIO block size
alignment can be used or not.  In case we're using SPI, we can't use
the block size alignment, so the function returns false.  So we set
the quirk when wl1271_set_block_size() returns true and let the wl12xx
lower driver unset the bit for wl127x (since it doesn't support this
quirk).

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   13 ++++++++-----
 drivers/net/wireless/ti/wlcore/init.c   |    2 +-
 drivers/net/wireless/ti/wlcore/main.c   |    4 ++--
 drivers/net/wireless/ti/wlcore/tx.c     |    6 +++---
 drivers/net/wireless/ti/wlcore/wlcore.h |    2 +-
 5 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 6b187d0..00ecd2a 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -272,9 +272,10 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl1271_warning("chip id 0x%x (1271 PG10) support is obsolete",
 			       wl->chip.id);
 
-		wl->quirks |= WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT |
-			WLCORE_QUIRK_LEGACY_NVS;
-		wl->plt_fw_name = WL127X_PLT_FW_NAME;
+		/* clear the alignment quirk, since we don't support it */
+		wl->quirks &= ~WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN;
+
+		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
 
@@ -287,8 +288,10 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
 			     wl->chip.id);
 
-		wl->quirks |= WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT |
-			WLCORE_QUIRK_LEGACY_NVS;
+		/* clear the alignment quirk, since we don't support it */
+		wl->quirks &= ~WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN;
+
+		wl->quirks |= WLCORE_QUIRK_LEGACY_NVS;
 		wl->plt_fw_name = WL127X_PLT_FW_NAME;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index d8c2235..c332da2 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -500,7 +500,7 @@ int wl1271_chip_specific_init(struct wl1271 *wl)
 	if (wl->chip.id == CHIP_ID_1283_PG20) {
 		u32 host_cfg_bitmap = HOST_IF_CFG_RX_FIFO_ENABLE;
 
-		if (!(wl->quirks & WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT))
+		if (wl->quirks & WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN)
 			/* Enable SDIO padding */
 			host_cfg_bitmap |= HOST_IF_CFG_TX_PAD_TO_SDIO_BLK;
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 0392166..83be5be 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1345,8 +1345,8 @@ static int wl12xx_chip_wakeup(struct wl1271 *wl, bool plt)
 	 * negligible, we use the same block size for all different
 	 * chip types.
 	 */
-	if (!wl1271_set_block_size(wl))
-		wl->quirks |= WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
+	if (wl1271_set_block_size(wl))
+		wl->quirks |= WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN;
 
 	ret = wl->ops->identify_chip(wl);
 	if (ret < 0)
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index d1811b8..6893bc2 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -176,10 +176,10 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 unsigned int wlcore_calc_packet_alignment(struct wl1271 *wl,
 					  unsigned int packet_length)
 {
-	if (wl->quirks & WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT)
-		return ALIGN(packet_length, WL1271_TX_ALIGN_TO);
-	else
+	if (wl->quirks & WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN)
 		return ALIGN(packet_length, WL12XX_BUS_BLOCK_SIZE);
+	else
+		return ALIGN(packet_length, WL1271_TX_ALIGN_TO);
 }
 EXPORT_SYMBOL(wlcore_calc_packet_alignment);
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 29b39f9..db7ad71 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -353,7 +353,7 @@ int wlcore_free_hw(struct wl1271 *wl);
 #define WLCORE_QUIRK_END_OF_TRANSACTION		BIT(0)
 
 /* wl127x and SPI don't support SDIO block size alignment */
-#define WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT	BIT(2)
+#define WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN		BIT(2)
 
 /* means aggregated Rx packets are aligned to a SDIO block */
 #define WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN		BIT(3)
-- 
1.7.5.4

