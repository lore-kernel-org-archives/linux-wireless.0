Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:64572 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbZFLLP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:15:56 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 12/33] wl12xx: add support for new WL1271 chip revision
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:15:33 +0300
Message-ID: <20090612111533.8877.30215.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

This patch adds the code that recognizes the new WL1271 chip revision (PG 2.0).
Full support for this chip is not yet implemented and support for WL1271 PG 1.0
is not guaranteed anymore.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/main.c   |    7 +++++++
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 950c425..73232db 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -196,6 +196,13 @@ static int wl12xx_chip_wakeup(struct wl12xx *wl)
 
 		break;
 	case CHIP_ID_1271_PG10:
+		wl12xx_warning("chip id 0x%x (1271 PG10) support is obsolete",
+			       wl->chip.id);
+		break;
+	case CHIP_ID_1271_PG20:
+		wl12xx_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
+			     wl->chip.id);
+		break;
 	case CHIP_ID_1251_PG10:
 	case CHIP_ID_1251_PG11:
 	default:
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 32f62a6..c1d00c0 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -412,5 +412,6 @@ int wl12xx_plt_stop(struct wl12xx *wl);
 #define CHIP_ID_1251_PG11	           (0x7020101)
 #define CHIP_ID_1251_PG12	           (0x7030101)
 #define CHIP_ID_1271_PG10	           (0x4030101)
+#define CHIP_ID_1271_PG20	           (0x4030111)
 
 #endif

