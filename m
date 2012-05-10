Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758487Ab2EJJQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:34 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:33 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 56/78] wl18xx: change low_band_component_type value for COM8
Date: Thu, 10 May 2012 12:14:01 +0300
Message-Id: <1336641263-5761-57-git-send-email-arik@wizery.com> (sfid-20120510_111905_025605_83A571EE)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Like HDK, COM8 uses 0x06 for the low_band_component_type as well.
Hardcode the value for COM8 until this configuration can be done in
the external configuration binary (to be implemented).

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index aa227a1..6047a6d 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1086,6 +1086,8 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 		priv->board_type = BOARD_TYPE_EVB_18XX;
 	} else if (!strcmp(board_type_param, "com8")) {
 		priv->board_type = BOARD_TYPE_COM8_18XX;
+		/* HACK! Just for now we hardcode COM8 to 0x06 */
+		priv->conf.phy.low_band_component_type = 0x06;
 	} else {
 		wl1271_error("invalid board type '%s'", board_type_param);
 		wlcore_free_hw(wl);
-- 
1.7.9.5

