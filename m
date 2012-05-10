Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823Ab2EJJOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:14:36 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:14:36 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 03/78] wl18xx: add empty operations struct
Date: Thu, 10 May 2012 12:13:08 +0300
Message-Id: <1336641263-5761-4-git-send-email-arik@wizery.com> (sfid-20120510_111441_262652_376FB4DE)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

We don't have any chip-specific operations yet, but now wlcore has
defined an operations structure and requires the pointer to be set.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index cb835d9..3fa9298 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -25,6 +25,9 @@
 #include "../wlcore/wlcore.h"
 #include "../wlcore/debug.h"
 
+static struct wlcore_ops wl18xx_ops = {
+};
+
 int __devinit wl18xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
@@ -37,6 +40,7 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	}
 
 	wl = hw->priv;
+	wl->ops = &wl18xx_ops;
 
 	return wlcore_probe(wl, pdev);
 }
-- 
1.7.9.5

