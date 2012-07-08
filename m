Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43274 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2GHOkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 10:40:13 -0400
Received: by wgbdr13 with SMTP id dr13so10668376wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 07:40:11 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] wl18xx: alloc conf.phy memory to ensure alignemnt
Date: Sun,  8 Jul 2012 17:40:05 +0300
Message-Id: <1341758406-32759-1-git-send-email-arik@wizery.com> (sfid-20120708_164050_608500_F69946A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We get DMA alignment trouble if the beginning of the conf.phy struct is
not aligned to 4 bytes. Use kmemdup to ensure alignment.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v2: use kmemdup

 drivers/net/wireless/ti/wl18xx/main.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index b378b34..8bb21b6 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -772,16 +772,24 @@ out:
 static int wl18xx_set_mac_and_phy(struct wl1271 *wl)
 {
 	struct wl18xx_priv *priv = wl->priv;
+	struct wl18xx_mac_and_phy_params *params;
 	int ret;
 
+	params = kmemdup(&priv->conf.phy, sizeof(*params), GFP_KERNEL);
+	if (!params) {
+		ret = -ENOMEM;
+		goto out;
+	}
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
1.7.9.5

