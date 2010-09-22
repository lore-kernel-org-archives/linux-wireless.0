Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33487 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0IVHxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 03:53:20 -0400
Received: by wwi17 with SMTP id 17so376525wwi.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 00:53:19 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Ido Yariv <ido@wizery.com>
Subject: [PATCH] wl1271: Fix overflow in wl1271_boot_upload_nvs
Date: Wed, 22 Sep 2010 09:53:13 +0200
Message-Id: <1285141993-3772-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to miscalculation of nvs_len, excessive data was sent to the
firmware.
Fix this by first setting nvs_ptr to point to the first NVS table,
and computing the total size of all NVS tables accordingly.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index fc21db8..e5a7f04 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -274,11 +274,11 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 
 	/*
 	 * We've reached the first zero length, the first NVS table
-	 * is 7 bytes further.
+	 * is located at an aligned offset which is at least 7 bytes further.
 	 */
-	nvs_ptr += 7;
+	nvs_ptr = (u8 *)wl->nvs->nvs +
+			ALIGN(nvs_ptr - (u8 *)wl->nvs->nvs + 7, 4);
 	nvs_len -= nvs_ptr - (u8 *)wl->nvs->nvs;
-	nvs_len = ALIGN(nvs_len, 4);
 
 	/* FIXME: The driver sets the partition here, but this is not needed,
 	   since it sets to the same one as currently in use */
@@ -286,14 +286,9 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
 
 	/* Copy the NVS tables to a new block to ensure alignment */
-	/* FIXME: We jump 3 more bytes before uploading the NVS.  It seems
-	that our NVS files have three extra zeros here.  I'm not sure whether
-	the problem is in our NVS generation or we should really jumpt these
-	3 bytes here */
-	nvs_ptr += 3;
-
-	nvs_aligned = kmemdup(nvs_ptr, nvs_len, GFP_KERNEL); if
-	(!nvs_aligned) return -ENOMEM;
+	nvs_aligned = kmemdup(nvs_ptr, nvs_len, GFP_KERNEL);
+	if (!nvs_aligned)
+		return -ENOMEM;
 
 	/* And finally we upload the NVS tables */
 	/* FIXME: In wl1271, we upload everything at once.
-- 
1.7.0.4

