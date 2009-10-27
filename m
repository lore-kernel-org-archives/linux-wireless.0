Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45158 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642AbZJ0TbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 15:31:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kalle.valo@iki.fi>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wl1251: re-disable PG10 chips
Date: Tue, 27 Oct 2009 15:17:05 -0400
Message-Id: <1256671025-26126-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"wl1251: add support for PG11 chips." accidentally enabled PG10 chips as
well...

Reported-by: Kalle Valo <kalle.valo@iki.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index ec01e9d..48b0bfd 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -183,11 +183,11 @@ static int wl1251_chip_wakeup(struct wl1251 *wl)
 		wl1251_debug(DEBUG_BOOT, "chip id 0x%x (1251 PG12)",
 			     wl->chip_id);
 		break;
-	case CHIP_ID_1251_PG10:
 	case CHIP_ID_1251_PG11:
 		wl1251_debug(DEBUG_BOOT, "chip id 0x%x (1251 PG11)",
 			     wl->chip_id);
 		break;
+	case CHIP_ID_1251_PG10:
 	default:
 		wl1251_error("unsupported chip id: 0x%x", wl->chip_id);
 		ret = -ENODEV;
-- 
1.6.2.5

