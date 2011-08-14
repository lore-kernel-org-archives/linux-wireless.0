Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65029 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1HNKRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:09 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so2967085wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:08 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 03/40] wl12xx: use 1 spare block in all cases
Date: Sun, 14 Aug 2011 13:17:02 +0300
Message-Id: <1313317059-16567-4-git-send-email-eliad@wizery.com> (sfid-20110814_121716_543029_B13485D9)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Remove support for firmwares that require 2 spare blocks for packet TX
(and delete the WL12XX_QUIRK_USE_2_SPARE_BLOCKS quirk definition)

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: delete WL12XX_QUIRK_USE_2_SPARE_BLOCKS

 drivers/net/wireless/wl12xx/boot.c   |   10 ----------
 drivers/net/wireless/wl12xx/tx.c     |    7 ++-----
 drivers/net/wireless/wl12xx/wl12xx.h |    6 ------
 3 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index a816f2f..930a638 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -104,22 +104,12 @@ static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 
 static unsigned int wl12xx_get_fw_ver_quirks(struct wl1271 *wl)
 {
 	unsigned int quirks = 0;
 	unsigned int *fw_ver = wl->chip.fw_ver;
 
-	/* Only for wl127x */
-	if ((fw_ver[FW_VER_CHIP] == FW_VER_CHIP_WL127X) &&
-	    /* Check STA version */
-	    (((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_STA) &&
-	      (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_1_SPARE_STA_MIN)) ||
-	     /* Check AP version */
-	     ((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_AP) &&
-	      (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_1_SPARE_AP_MIN))))
-		quirks |= WL12XX_QUIRK_USE_2_SPARE_BLOCKS;
-
 	/* Only new station firmwares support routing fw logs to the host */
 	if ((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_STA) &&
 	    (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_FWLOG_STA_MIN))
 		quirks |= WL12XX_QUIRK_FWLOG_NOT_IMPLEMENTED;
 
 	/* This feature is not yet supported for AP mode */
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 0696aed..c67340f 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -166,18 +166,15 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra,
 {
 	struct wl1271_tx_hw_descr *desc;
 	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
 	u32 len;
 	u32 total_blocks;
 	int id, ret = -EBUSY;
-	u32 spare_blocks;
 
-	if (unlikely(wl->quirks & WL12XX_QUIRK_USE_2_SPARE_BLOCKS))
-		spare_blocks = 2;
-	else
-		spare_blocks = 1;
+	/* we use 1 spare block */
+	u32 spare_blocks = 1;
 
 	if (buf_offset + total_len > WL1271_AGGR_BUFFER_SIZE)
 		return -EAGAIN;
 
 	/* allocate free identifier for the packet */
 	id = wl1271_alloc_tx_id(wl, skb);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index dc0013e..0bdeae5 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -653,18 +653,12 @@ size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen);
 
 /* Quirks */
 
 /* Each RX/TX transaction requires an end-of-transaction transfer */
 #define WL12XX_QUIRK_END_OF_TRANSACTION		BIT(0)
 
-/*
- * Older firmwares use 2 spare TX blocks
- * (for STA < 6.1.3.50.58 or for AP < 6.2.0.0.47)
- */
-#define WL12XX_QUIRK_USE_2_SPARE_BLOCKS		BIT(1)
-
 /* WL128X requires aggregated packets to be aligned to the SDIO block size */
 #define WL12XX_QUIRK_BLOCKSIZE_ALIGNMENT	BIT(2)
 
 /*
  * WL127X AP mode requires Low Power DRPw (LPD) enable to reduce power
  * consumption
-- 
1.7.6.401.g6a319

