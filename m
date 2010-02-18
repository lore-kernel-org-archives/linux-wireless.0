Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24765 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab0BRL20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:26 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 10/22] wl1271: skip 3 unused bytes from the NVS
Date: Thu, 18 Feb 2010 13:25:45 +0200
Message-Id: <1266492357-462-11-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

Our NVS uploading mechanism had a bug that was causing it to pass three extra
zeros at the start of the NVS.  This may be a problem in the NVS generation
application, but for now we fix it in the driver.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 57ba78d..fb3090c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -277,9 +277,14 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
 
 	/* Copy the NVS tables to a new block to ensure alignment */
-	nvs_aligned = kmemdup(nvs_ptr, nvs_len, GFP_KERNEL);
-	if (!nvs_aligned)
-		return -ENOMEM;
+	/* FIXME: We jump 3 more bytes before uploading the NVS.  It seems
+	that our NVS files have three extra zeros here.  I'm not sure whether
+	the problem is in our NVS generation or we should really jumpt these
+	3 bytes here */
+	nvs_ptr += 3;
+
+	nvs_aligned = kmemdup(nvs_ptr, nvs_len, GFP_KERNEL); if
+	(!nvs_aligned) return -ENOMEM;
 
 	/* And finally we upload the NVS tables */
 	/* FIXME: In wl1271, we upload everything at once.
-- 
1.6.3.3

