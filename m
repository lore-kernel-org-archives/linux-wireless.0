Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:58626 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904Ab1KCGpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 02:45:03 -0400
Received: by bkat2 with SMTP id t2so1162029bka.22
        for <linux-wireless@vger.kernel.org>; Wed, 02 Nov 2011 23:45:00 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] wl12xx: use the same SDIO block size for all different chips
Date: Thu,  3 Nov 2011 08:44:42 +0200
Message-Id: <1320302683-23403-3-git-send-email-coelho@ti.com> (sfid-20111103_074509_424395_47FF52BB)
In-Reply-To: <1320302683-23403-1-git-send-email-coelho@ti.com>
References: <1320302683-23403-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sdio driver uses a block size of 512 bytes by default.  With our
card, this doesn't work correctly because it sets the block size FBR
in the chip too early (ie. before the chip is powered on).  Thus, if
we don't set it explicitly, block mode remains disabled in the chip.
If we try to send more data than fits in one block, the sdio driver
will split it into separate blocks before sending to the chip.  This
causes problems because the chip is not expecting multiple blocks.

At the moment this is not a problem, because we use chunks of 512
bytes for firmware upload and the data is always sent in byte mode.
In the next patch, we will change the chunk size to a bigger value, so
this patch is a preparation for that.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index bddf289..0532630 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1313,7 +1313,16 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 	/* 0. read chip id from CHIP_ID */
 	wl->chip.id = wl1271_read32(wl, CHIP_ID_B);
 
-	/* 1. check if chip id is valid */
+	/*
+	 * For wl127x based devices we could use the default block
+	 * size (512 bytes), but due to a bug in the sdio driver, we
+	 * need to set it explicitly after the chip is powered on.  To
+	 * simplify the code and since the performance impact is
+	 * negligible, we use the same block size for all different
+	 * chip types.
+	 */
+	if (!wl1271_set_block_size(wl))
+		wl->quirks |= WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
 
 	switch (wl->chip.id) {
 	case CHIP_ID_1271_PG10:
@@ -1343,9 +1352,6 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		ret = wl1271_setup(wl);
 		if (ret < 0)
 			goto out;
-
-		if (!wl1271_set_block_size(wl))
-			wl->quirks |= WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
 		break;
 	case CHIP_ID_1283_PG10:
 	default:
-- 
1.7.4.1

