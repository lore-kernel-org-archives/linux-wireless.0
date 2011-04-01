Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:49526 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757218Ab1DAQl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 12:41:28 -0400
Received: by mail-ey0-f177.google.com with SMTP id 6so1175486eyh.8
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 09:41:27 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Subject: [PATCH 2.6.39 and stable] wl12xx: fix potential buffer overflow in testmode nvs push
Date: Fri,  1 Apr 2011 19:42:02 +0300
Message-Id: <1301676122-4745-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were allocating the size of the NVS file struct and not checking
whether the length of the buffer passed was correct before copying it
into the allocated memory.  This is a security hole because buffer
overflows can occur if the userspace passes a bigger file than what is
expected.

With this patch, we check if the size of the data passed from
userspace matches the size required.

This bug was introduced in 2.6.36.

Cc: stable@kernel.org
Reported-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/testmode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/testmode.c b/drivers/net/wireless/wl12xx/testmode.c
index e64403b..6ec06a4 100644
--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -204,7 +204,10 @@ static int wl1271_tm_cmd_nvs_push(struct wl1271 *wl, struct nlattr *tb[])
 
 	kfree(wl->nvs);
 
-	wl->nvs = kzalloc(sizeof(struct wl1271_nvs_file), GFP_KERNEL);
+	if (len != sizeof(struct wl1271_nvs_file))
+		return -EINVAL;
+
+	wl->nvs = kzalloc(len, GFP_KERNEL);
 	if (!wl->nvs) {
 		wl1271_error("could not allocate memory for the nvs file");
 		ret = -ENOMEM;
-- 
1.7.1

