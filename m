Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:65023 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbZFLLRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:17:39 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 27/33] wl1251: remove wl1271_setup()
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:17:12 +0300
Message-ID: <20090612111712.8877.98999.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

We don't want to have any 1271 code in wl1251.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
---

 drivers/net/wireless/wl12xx/main.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3fc48c7..dd75d3d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -195,14 +195,6 @@ static int wl12xx_chip_wakeup(struct wl12xx *wl)
 		wl1251_setup(wl);
 
 		break;
-	case CHIP_ID_1271_PG10:
-		wl12xx_warning("chip id 0x%x (1271 PG10) support is obsolete",
-			       wl->chip.id);
-		break;
-	case CHIP_ID_1271_PG20:
-		wl12xx_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
-			     wl->chip.id);
-		break;
 	case CHIP_ID_1251_PG10:
 	case CHIP_ID_1251_PG11:
 	default:

