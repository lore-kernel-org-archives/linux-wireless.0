Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:41093 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437Ab1LUUgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 15:36:43 -0500
Received: by lahl5 with SMTP id l5so4014863lah.41
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 12:36:40 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 1/3] wl1251: fix sparse warning
Date: Wed, 21 Dec 2011 22:36:27 +0200
Message-Id: <1324499789-13525-2-git-send-email-coelho@ti.com> (sfid-20111221_213646_166243_10B5FA32)
In-Reply-To: <1324499789-13525-1-git-send-email-coelho@ti.com>
References: <1324499789-13525-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl1251 driver was generating the following warning:

drivers/net/wireless/wl1251/boot.c:467:21: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl1251/boot.c:467:21:    expected unsigned int [unsigned] [assigned] [usertype] val
drivers/net/wireless/wl1251/boot.c:467:21:    got restricted __le32 [usertype] <noident>

Fix this by removing one cpu_to_le32() call in the wrong place.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl1251/boot.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl1251/boot.c b/drivers/net/wireless/wl1251/boot.c
index d729daf..a2e5241 100644
--- a/drivers/net/wireless/wl1251/boot.c
+++ b/drivers/net/wireless/wl1251/boot.c
@@ -464,8 +464,6 @@ static int wl1251_boot_upload_nvs(struct wl1251 *wl)
 		val = (nvs_ptr[0] | (nvs_ptr[1] << 8)
 		       | (nvs_ptr[2] << 16) | (nvs_ptr[3] << 24));
 
-		val = cpu_to_le32(val);
-
 		wl1251_debug(DEBUG_BOOT,
 			     "nvs write table 0x%x: 0x%x",
 			     nvs_start, val);
-- 
1.7.4.1

