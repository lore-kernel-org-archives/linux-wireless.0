Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab2EJJOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:14:55 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:14:55 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 11/78] wl18xx: set normal/GEM Tx spare block counts
Date: Thu, 10 May 2012 12:13:16 +0300
Message-Id: <1336641263-5761-12-git-send-email-arik@wizery.com> (sfid-20120510_111459_503459_50477FA7)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize the Tx spare block counts for all operating modes in the 18xx
card.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 68f5e09..70683ad 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -32,6 +32,9 @@
 #include "conf.h"
 #include "wl18xx.h"
 
+#define WL18XX_TX_HW_BLOCK_SPARE        1
+#define WL18XX_TX_HW_GEM_BLOCK_SPARE    2
+
 static struct wl18xx_conf wl18xx_default_conf = {
 	.phy = {
 		.phy_standalone			= 0x00,
@@ -326,6 +329,8 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->ptable = wl18xx_ptable;
 	wl->rtable = wl18xx_rtable;
 	wl->num_tx_desc = 32;
+	wl->normal_tx_spare = WL18XX_TX_HW_BLOCK_SPARE;
+	wl->gem_tx_spare = WL18XX_TX_HW_GEM_BLOCK_SPARE;
 
 	return wlcore_probe(wl, pdev);
 }
-- 
1.7.9.5

