Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:43835 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301Ab2GHHXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 03:23:50 -0400
Received: by lbbgj3 with SMTP id gj3so13028135lbb.25
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 00:23:47 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 7/8] wl18xx: don't send static global struct to FW
Date: Sun,  8 Jul 2012 10:23:30 +0300
Message-Id: <1341732211-25871-8-git-send-email-coelho@ti.com> (sfid-20120708_092401_300367_EF4BD9AD)
In-Reply-To: <1341732211-25871-1-git-send-email-coelho@ti.com>
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

We get DMA alignment trouble if the beginning of the struct is
unaligned. Allocate memory and send it to FW.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 23f100a3..aea2e32 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -772,16 +772,27 @@ out:
 static int wl18xx_set_mac_and_phy(struct wl1271 *wl)
 {
 	struct wl18xx_priv *priv = wl->priv;
+	struct wl18xx_mac_and_phy_params *params;
 	int ret;
 
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (!params) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* use aligned memory for the copy to FW */
+	memcpy(params, &priv->conf.phy, sizeof(*params));
+
 	ret = wlcore_set_partition(wl, &wl->ptable[PART_PHY_INIT]);
 	if (ret < 0)
 		goto out;
 
-	ret = wlcore_write(wl, WL18XX_PHY_INIT_MEM_ADDR, (u8 *)&priv->conf.phy,
-			   sizeof(struct wl18xx_mac_and_phy_params), false);
+	ret = wlcore_write(wl, WL18XX_PHY_INIT_MEM_ADDR, params,
+			   sizeof(*params), false);
 
 out:
+	kfree(params);
 	return ret;
 }
 
-- 
1.7.10

