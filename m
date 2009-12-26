Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34976 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZLZT3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Dec 2009 14:29:14 -0500
Message-ID: <4B3664AF.6090302@gmail.com>
Date: Sat, 26 Dec 2009 20:31:59 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] wl1251: timeout one too soon in wl1251_boot_run_firmware()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

`loop' reaches INIT_LOOP + 1 after the loop. so if ACX_INTR_INIT_COMPLETE
occurs in the last iteration the write occurs but also the error out as if a
timeout occurred. This is probably very unlikely to ever occur.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/wireless/wl12xx/wl1251_boot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index 2e733e7..28a8086 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -256,7 +256,7 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 		}
 	}
 
-	if (loop >= INIT_LOOP) {
+	if (loop > INIT_LOOP) {
 		wl1251_error("timeout waiting for the hardware to "
 			     "complete initialization");
 		return -EIO;
