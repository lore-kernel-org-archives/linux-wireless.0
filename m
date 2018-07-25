Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:13791 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbeGYHLX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 03:11:23 -0400
From: "H. Nikolaus Schaller" <hns@goldelico.com>
To: Kalle Valo <kvalo@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "Reizer, Eyal" <eyalr@ti.com>, Kees Cook <keescook@chromium.org>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com
Subject: [PATCH] drivers: net: wlcore: remove duplicate \n for some warnings
Date: Wed, 25 Jul 2018 07:55:04 +0200
Message-Id: <af660348ade58fd33396d2dca432536d2ac85cf7.1532498079.git.hns@goldelico.com> (sfid-20180725_080122_896807_3CC6A290)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1271_warning() already appends a \n to the format,
so adding one to the warning string gives empty lines in the log.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3a51ab116e79..ab34d41487d3 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6065,16 +6065,16 @@ static int wl1271_register_hw(struct wl1271 *wl)
 	}
 
 	if (oui_addr == 0xdeadbe && nic_addr == 0xef0000) {
-		wl1271_warning("Detected unconfigured mac address in nvs, derive from fuse instead.\n");
+		wl1271_warning("Detected unconfigured mac address in nvs, derive from fuse instead.");
 		if (!strcmp(pdev_data->family->name, "wl18xx")) {
-			wl1271_warning("This default nvs file can be removed from the file system\n");
+			wl1271_warning("This default nvs file can be removed from the file system");
 		} else {
-			wl1271_warning("Your device performance is not optimized.\n");
-			wl1271_warning("Please use the calibrator tool to configure your device.\n");
+			wl1271_warning("Your device performance is not optimized.");
+			wl1271_warning("Please use the calibrator tool to configure your device.");
 		}
 
 		if (wl->fuse_oui_addr == 0 && wl->fuse_nic_addr == 0) {
-			wl1271_warning("Fuse mac address is zero. using random mac\n");
+			wl1271_warning("Fuse mac address is zero. using random mac");
 			/* Use TI oui and a random nic */
 			oui_addr = WLCORE_TI_OUI_ADDRESS;
 			nic_addr = get_random_int();
-- 
2.12.2
