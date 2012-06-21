Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:38016 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755113Ab2FUONa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:13:30 -0400
Received: by lbbgo11 with SMTP id go11so2103595lbb.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:13:27 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 06/12] wl18xx: set Tx align quirk for PG2
Date: Thu, 21 Jun 2012 17:13:05 +0300
Message-Id: <1340287991-15241-7-git-send-email-coelho@ti.com> (sfid-20120621_161543_348557_A8CBA6F2)
In-Reply-To: <1340287991-15241-1-git-send-email-coelho@ti.com>
References: <1340287991-15241-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Before patch b5d6d9b (wlcore/wl12xx/wl18xx: don't use TX align quirk
for wl127x), this was automatically set for all platforms. As this
should now be set explicitly, set it for PG2 as well.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 18cf19c..066e8e5 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -608,8 +608,8 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 		wl->plt_fw_name = WL18XX_FW_NAME;
 		wl->quirks |= WLCORE_QUIRK_NO_ELP |
 			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN |
+			      WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN |
 			      WLCORE_QUIRK_TX_PAD_LAST_FRAME;
-
 		break;
 	case CHIP_ID_185x_PG10:
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (185x PG10)",
-- 
1.7.10

