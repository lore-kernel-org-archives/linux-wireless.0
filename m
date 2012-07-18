Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:59929 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954Ab2GRMNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:13:48 -0400
Received: by bkcji2 with SMTP id ji2so1257133bkc.36
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:46 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 01/14] wl18xx: alloc conf.phy memory to ensure alignemnt
Date: Wed, 18 Jul 2012 15:13:20 +0300
Message-Id: <1342613613-917-2-git-send-email-coelho@ti.com> (sfid-20120718_141353_603698_DA6811B4)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

We get DMA alignment trouble if the beginning of the conf.phy struct is
not aligned to 4 bytes. Use kmemdup to ensure alignment.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
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
1.7.10.4

