Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35234 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbcCHUlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 15:41:10 -0500
Received: by mail-wm0-f54.google.com with SMTP id l68so149514692wml.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2016 12:41:08 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC 5/7] wlcore: avoid fragile snprintf use
Date: Tue,  8 Mar 2016 21:40:52 +0100
Message-Id: <1457469654-17059-6-git-send-email-linux@rasmusvillemoes.dk> (sfid-20160308_214137_490888_044BD4BE)
In-Reply-To: <1457469654-17059-1-git-send-email-linux@rasmusvillemoes.dk>
References: <CAGXu5jJ-NApCpANjfz+bAEfwZJ8xizkM-jDHVhOPCzhxV-aqdA@mail.gmail.com>
 <1457469654-17059-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Appending to a buffer like this is not guaranteed to work (passing
overlapping src and dst buffers to snprintf is undefined
behaviour). The standard and safe idiom is to keep track of the
current string length.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/wireless/ti/wlcore/boot.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 19b7ec7b69c2..401d75c02bf4 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -86,7 +86,7 @@ static int wlcore_validate_fw_ver(struct wl1271 *wl)
 	unsigned int *min_ver = (wl->fw_type == WL12XX_FW_TYPE_MULTI) ?
 		wl->min_mr_fw_ver : wl->min_sr_fw_ver;
 	char min_fw_str[32] = "";
-	int i;
+	int i, len;
 
 	/* the chip must be exactly equal */
 	if ((min_ver[FW_VER_CHIP] != WLCORE_FW_VER_IGNORE) &&
@@ -119,13 +119,15 @@ static int wlcore_validate_fw_ver(struct wl1271 *wl)
 	return 0;
 
 fail:
+	len = 0;
 	for (i = 0; i < NUM_FW_VER; i++)
 		if (min_ver[i] == WLCORE_FW_VER_IGNORE)
-			snprintf(min_fw_str, sizeof(min_fw_str),
-				  "%s*.", min_fw_str);
+			len += scnprintf(min_fw_str + len,
+					 sizeof(min_fw_str) - len, "*.");
 		else
-			snprintf(min_fw_str, sizeof(min_fw_str),
-				  "%s%u.", min_fw_str, min_ver[i]);
+			len += scnprintf(min_fw_str + len,
+					 sizeof(min_fw_str) - len,
+					 "%u.", min_ver[i]);
 
 	wl1271_error("Your WiFi FW version (%u.%u.%u.%u.%u) is invalid.\n"
 		     "Please use at least FW %s\n"
-- 
2.1.4

