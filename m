Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:60302 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591AbZLKNle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:34 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 14/31] wl1271: upload only the first 468 bytes from the NVS file
Date: Fri, 11 Dec 2009 15:40:53 +0200
Message-Id: <1260538870-32297-15-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were uploading the whole NVS file, but that is wrong, because the same
file also contains the initialization values.  For the latest firmwares, we
should upload only the initial 468 bytes from the file.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_boot.c |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 3bec6f3..8dfc9ec 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -111,6 +111,7 @@ enum {
 
 #define WL1271_FW_NAME "wl1271-fw.bin"
 #define WL1271_NVS_NAME "wl1271-nvs.bin"
+#define WL1271_NVS_LEN  468
 
 /*
  * Enable/disable 802.11a support for WL1273
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index b7c9645..e803b87 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -225,9 +225,15 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	if (nvs == NULL)
 		return -ENODEV;
 
+	if (wl->nvs_len < WL1271_NVS_LEN)
+		return -EINVAL;
+
 	nvs_ptr = nvs;
 
-	nvs_len = wl->nvs_len;
+	/* only the first part of the NVS needs to be uploaded */
+	nvs_len = WL1271_NVS_LEN;
+
+	/* FIXME: read init settings from the remaining part of the NVS */
 
 	/* Update the device MAC address into the nvs */
 	nvs[11] = wl->mac_addr[0];
-- 
1.6.3.3

