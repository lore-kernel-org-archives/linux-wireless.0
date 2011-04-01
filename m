Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:46911 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757606Ab1DAQqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 12:46:08 -0400
Received: by mail-ew0-f53.google.com with SMTP id 8so1164077ewy.26
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 09:46:05 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.40] wl12xx: fix potential buffer overflow in testmode nvs push
Date: Fri,  1 Apr 2011 19:46:40 +0300
Message-Id: <1301676400-4912-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were allocating the size of the NVS file according to the chip ID
and not checking whether the length of the buffer passed was correct
before copying it into the allocated memory.  This is a security hole
because buffer overflows can occur if the userspace passes a bigger
file than what is expected.

With this patch, we check if the size of the data passed from
userspace matches the size required by the chip.

Reported-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/testmode.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/testmode.c b/drivers/net/wireless/wl12xx/testmode.c
index 0863859..9b9f6c9 100644
--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -205,11 +205,13 @@ static int wl1271_tm_cmd_nvs_push(struct wl1271 *wl, struct nlattr *tb[])
 
 	kfree(wl->nvs);
 
-	if (wl->chip.id == CHIP_ID_1283_PG20)
-		wl->nvs = kzalloc(sizeof(struct wl128x_nvs_file), GFP_KERNEL);
-	else
-		wl->nvs = kzalloc(sizeof(struct wl1271_nvs_file), GFP_KERNEL);
+	if ((wl->chip.id == CHIP_ID_1283_PG20) &&
+	    (len != sizeof(struct wl128x_nvs_file)))
+		return -EINVAL;
+	else if (len != sizeof(struct wl1271_nvs_file))
+		return -EINVAL;
 
+	wl->nvs = kzalloc(len, GFP_KERNEL);
 	if (!wl->nvs) {
 		wl1271_error("could not allocate memory for the nvs "
 			     "file");
-- 
1.7.1

