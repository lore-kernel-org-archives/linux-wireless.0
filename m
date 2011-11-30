Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60200 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500Ab1K3Ofq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 09:35:46 -0500
Received: by lagw12 with SMTP id w12so122016lag.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Nov 2011 06:35:44 -0800 (PST)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: Print nvs/fw file name if loading fails.
Date: Wed, 30 Nov 2011 15:35:09 +0100
Message-Id: <1322663709-28128-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20111130_153549_624240_4ECA2812)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print the name of nvs/fw if request_firmware fails. This will make
troubleshooting a bit easier.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/wl12xx/main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dbb088e..392dba4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1055,7 +1055,7 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 	ret = request_firmware(&fw, fw_name, wl->dev);
 
 	if (ret < 0) {
-		wl1271_error("could not get firmware: %d", ret);
+		wl1271_error("could not get firmware %s: %d", fw_name, ret);
 		return ret;
 	}
 
@@ -1093,7 +1093,8 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 	ret = request_firmware(&fw, WL12XX_NVS_NAME, wl->dev);
 
 	if (ret < 0) {
-		wl1271_error("could not get nvs file: %d", ret);
+		wl1271_error("could not get nvs file %s: %d", WL12XX_NVS_NAME,
+			     ret);
 		return ret;
 	}
 
-- 
1.7.5.4

