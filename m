Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58417 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab1JRHXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 03:23:50 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt19so452354bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 00:23:49 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>, stable@kernel.org
Subject: [PATCH 2/2] wl12xx: Check buffer bound when processing nvs data
Date: Tue, 18 Oct 2011 09:23:42 +0200
Message-Id: <1318922622-8356-3-git-send-email-pontus.fuchs@gmail.com> (sfid-20111018_092357_569545_99FA8EAD)
In-Reply-To: <1318922622-8356-1-git-send-email-pontus.fuchs@gmail.com>
References: <1318922622-8356-1-git-send-email-pontus.fuchs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An nvs with malformed contents could cause the processing of the
calibration data to read beyond the end of the buffer. Prevent this
from happening by adding bound checking.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: stable@kernel.org
Reviewed-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 4ce634b..c9c8b69 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -347,6 +347,9 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 		nvs_ptr += 3;
 
 		for (i = 0; i < burst_len; i++) {
+			if (nvs_ptr + 3 >= (u8 *) wl->nvs + nvs_len)
+				goto out_badnvs;
+
 			val = (nvs_ptr[0] | (nvs_ptr[1] << 8)
 			       | (nvs_ptr[2] << 16) | (nvs_ptr[3] << 24));
 
@@ -358,6 +361,9 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 			nvs_ptr += 4;
 			dest_addr += 4;
 		}
+
+		if (nvs_ptr >= (u8 *) wl->nvs + nvs_len)
+			goto out_badnvs;
 	}
 
 	/*
@@ -369,6 +375,10 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	 */
 	nvs_ptr = (u8 *)wl->nvs +
 			ALIGN(nvs_ptr - (u8 *)wl->nvs + 7, 4);
+
+	if (nvs_ptr >= (u8 *) wl->nvs + nvs_len)
+		goto out_badnvs;
+
 	nvs_len -= nvs_ptr - (u8 *)wl->nvs;
 
 	/* Now we must set the partition correctly */
@@ -384,6 +394,10 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 
 	kfree(nvs_aligned);
 	return 0;
+
+out_badnvs:
+	wl1271_error("nvs data is malformed");
+	return -EILSEQ;
 }
 
 static void wl1271_boot_enable_interrupts(struct wl1271 *wl)
-- 
1.7.4.1

