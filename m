Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59513 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab1HYPJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:44 -0400
Received: by wwf5 with SMTP id 5so2488325wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 08:09:43 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] wl12xx: print acx id
Date: Thu, 25 Aug 2011 18:10:57 +0300
Message-Id: <1314285060-5088-1-git-send-email-eliad@wizery.com> (sfid-20110825_172239_483326_06520B09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add id param to the acx debug print (on wl1271_cmd_configure)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index d5a0ebe..084262f 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -895,7 +895,7 @@ int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len)
 	struct acx_header *acx = buf;
 	int ret;
 
-	wl1271_debug(DEBUG_CMD, "cmd configure");
+	wl1271_debug(DEBUG_CMD, "cmd configure (%d)", id);
 
 	acx->id = cpu_to_le16(id);
 
-- 
1.7.6.401.g6a319

