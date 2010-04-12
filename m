Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38423 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab0DLW2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 18:28:23 -0400
Received: by bwz19 with SMTP id 19so4657bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 15:28:22 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH] wl1251: don't require NVS data when EEPROM is used
Date: Tue, 13 Apr 2010 01:21:40 +0300
Message-Id: <1271110900-18572-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If EEPROM is used, NVS data is now loaded but ignored.
Stop loading it to avoid need of dummy NVS file for modules with EEPROM.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 7bc109d..99a983f 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -202,8 +202,8 @@ static int wl1251_chip_wakeup(struct wl1251 *wl)
 			goto out;
 	}
 
-	/* No NVS from netlink, try to get it from the filesystem */
-	if (wl->nvs == NULL) {
+	if (wl->nvs == NULL && !wl->use_eeprom) {
+		/* No NVS from netlink, try to get it from the filesystem */
 		ret = wl1251_fetch_nvs(wl);
 		if (ret < 0)
 			goto out;
-- 
1.6.3.3

