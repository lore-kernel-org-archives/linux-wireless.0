Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab2EJJQ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:27 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:26 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 53/78] wl18xx: copy the default configuration before checking the board_type
Date: Thu, 10 May 2012 12:13:58 +0300
Message-Id: <1336641263-5761-54-git-send-email-arik@wizery.com> (sfid-20120510_111924_645156_83085ED0)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

We were changing the low_band_component_type in the private
configuration structure before copying the default values to it, so
the change was overwritten and only took effect after HW recovery.

Reported-by: Dror Erez <drorer@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index d4e331f..f5ec6f6 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1072,6 +1072,8 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 		memcpy(&wl->ht_cap, &wl18xx_mimo_ht_cap,
 		       sizeof(wl18xx_mimo_ht_cap));
 
+	wl18xx_conf_init(wl);
+
 	if (!board_type_param) {
 		board_type_param = kstrdup("dvp", GFP_KERNEL);
 		priv->board_type = BOARD_TYPE_DVP_18XX;
@@ -1100,8 +1102,6 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 
 	wl->enable_11a = enable_11a_param;
 
-	wl18xx_conf_init(wl);
-
 	return wlcore_probe(wl, pdev);
 }
 
-- 
1.7.9.5

