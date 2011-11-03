Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:51223 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788Ab1KCGpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 02:45:01 -0400
Received: by bkbc12 with SMTP id c12so845653bkb.25
        for <linux-wireless@vger.kernel.org>; Wed, 02 Nov 2011 23:44:58 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] wl12xx: change blocksize alignment quirk to negative
Date: Thu,  3 Nov 2011 08:44:41 +0200
Message-Id: <1320302683-23403-2-git-send-email-coelho@ti.com> (sfid-20111103_074506_460166_3714C835)
In-Reply-To: <1320302683-23403-1-git-send-email-coelho@ti.com>
References: <1320302683-23403-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SDIO blocksize alignment support is now the rule, not the exception.
To simplify the code in patches to come, invert the meaning of the
quirk to be negative (ie. the quirk is set if the device does _not_
support blocksize alignment).

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/init.c   |    2 +-
 drivers/net/wireless/wl12xx/main.c   |    8 ++++++--
 drivers/net/wireless/wl12xx/tx.c     |    6 +++---
 drivers/net/wireless/wl12xx/wl12xx.h |    4 ++--
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index c6084f8..6d06188 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -501,7 +501,7 @@ int wl1271_chip_specific_init(struct wl1271 *wl)
 	if (wl->chip.id == CHIP_ID_1283_PG20) {
 		u32 host_cfg_bitmap = HOST_IF_CFG_RX_FIFO_ENABLE;
 
-		if (wl->quirks & WL12XX_QUIRK_BLOCKSIZE_ALIGNMENT)
+		if (!(wl->quirks & WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT))
 			/* Enable SDIO padding */
 			host_cfg_bitmap |= HOST_IF_CFG_TX_PAD_TO_SDIO_BLK;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f76be5a..bddf289 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1323,7 +1323,9 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		ret = wl1271_setup(wl);
 		if (ret < 0)
 			goto out;
+		wl->quirks |= WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
 		break;
+
 	case CHIP_ID_1271_PG20:
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
 			     wl->chip.id);
@@ -1331,7 +1333,9 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		ret = wl1271_setup(wl);
 		if (ret < 0)
 			goto out;
+		wl->quirks |= WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
 		break;
+
 	case CHIP_ID_1283_PG20:
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1283 PG20)",
 			     wl->chip.id);
@@ -1340,8 +1344,8 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		if (ret < 0)
 			goto out;
 
-		if (wl1271_set_block_size(wl))
-			wl->quirks |= WL12XX_QUIRK_BLOCKSIZE_ALIGNMENT;
+		if (!wl1271_set_block_size(wl))
+			wl->quirks |= WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
 		break;
 	case CHIP_ID_1283_PG10:
 	default:
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index c7ad4f5..686c5e5 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -205,10 +205,10 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 static unsigned int wl12xx_calc_packet_alignment(struct wl1271 *wl,
 						unsigned int packet_length)
 {
-	if (wl->quirks & WL12XX_QUIRK_BLOCKSIZE_ALIGNMENT)
-		return ALIGN(packet_length, WL12XX_BUS_BLOCK_SIZE);
-	else
+	if (wl->quirks & WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT)
 		return ALIGN(packet_length, WL1271_TX_ALIGN_TO);
+	else
+		return ALIGN(packet_length, WL12XX_BUS_BLOCK_SIZE);
 }
 
 static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b7036df..e58e801 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -669,8 +669,8 @@ size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen);
 /* Each RX/TX transaction requires an end-of-transaction transfer */
 #define WL12XX_QUIRK_END_OF_TRANSACTION		BIT(0)
 
-/* WL128X requires aggregated packets to be aligned to the SDIO block size */
-#define WL12XX_QUIRK_BLOCKSIZE_ALIGNMENT	BIT(2)
+/* wl127x and SPI don't support SDIO block size alignment */
+#define WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT	BIT(2)
 
 /* Older firmwares did not implement the FW logger over bus feature */
 #define WL12XX_QUIRK_FWLOG_NOT_IMPLEMENTED	BIT(4)
-- 
1.7.4.1

