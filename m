Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from celine.tisys.org ([85.25.117.166]:57022 "EHLO celine.tisys.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750792AbdBSBfn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Feb 2017 20:35:43 -0500
Received: from tisys.org (ip1f1368d2.dynamic.kabel-deutschland.de [31.19.104.210])
        by celine.tisys.org (Postfix) with ESMTPSA id 999C75141500
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2017 02:35:38 +0100 (CET)
Date: Sun, 19 Feb 2017 02:35:32 +0100
From: Nils Holland <nholland@tisys.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] Fix rtl8187 multicast reception
Message-ID: <20170219013520.GA3190@tisys.org> (sfid-20170219_023604_590463_F55C5EAE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rtl8187 doesn't seem to receive multicast data, which, among other
thinks, make it fail to receive RAs in IPv6 networks.

The cause seems to be that the RTL818X_RX_CONF_MULTICAST flag doesn't
have any effect at all. Fix this issue by setting
RTL818X_RX_CONF_MONITOR instead, which puts the card into monitor mode,
and fixes the problem.

Signed-off-by: Nils Holland <nholland@tisys.org>
---
The problem and solution have been tested on an rtl8187b (0bda:8197), but
the fix changes behavior on other cards supported by the driver as well
(like non-b 8187's). Due to lack of hardware, I unfortunately cannot say
if the issue exists on these cards in the first place, or if the fix has
any unwanted consequences there.

If people consider it a bad idea to just always put the card into monitor
mode (for example, for performance reasons), I could imagine rewriting this
patch so that a module parameter controls this behavior instead.

 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
index 231f84db9ab0..56a8686cd367 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -946,8 +946,7 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 		      (7 << 13 /* RX FIFO threshold NONE */) |
 		      (7 << 10 /* MAX RX DMA */) |
 		      RTL818X_RX_CONF_RX_AUTORESETPHY |
-		      RTL818X_RX_CONF_ONLYERLPKT |
-		      RTL818X_RX_CONF_MULTICAST;
+		      RTL818X_RX_CONF_ONLYERLPKT;
 		priv->rx_conf = reg;
 		rtl818x_iowrite32(priv, &priv->map->RX_CONF, reg);
 
@@ -1319,12 +1318,11 @@ static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 		priv->rx_conf ^= RTL818X_RX_CONF_FCS;
 	if (changed_flags & FIF_CONTROL)
 		priv->rx_conf ^= RTL818X_RX_CONF_CTRL;
-	if (changed_flags & FIF_OTHER_BSS)
-		priv->rx_conf ^= RTL818X_RX_CONF_MONITOR;
-	if (*total_flags & FIF_ALLMULTI || multicast > 0)
-		priv->rx_conf |= RTL818X_RX_CONF_MULTICAST;
+	if (*total_flags & FIF_OTHER_BSS ||
+	    *total_flags & FIF_ALLMULTI || multicast > 0)
+		priv->rx_conf |= RTL818X_RX_CONF_MONITOR;
 	else
-		priv->rx_conf &= ~RTL818X_RX_CONF_MULTICAST;
+		priv->rx_conf &= ~RTL818X_RX_CONF_MONITOR;
 
 	*total_flags = 0;
 
@@ -1332,10 +1330,10 @@ static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 		*total_flags |= FIF_FCSFAIL;
 	if (priv->rx_conf & RTL818X_RX_CONF_CTRL)
 		*total_flags |= FIF_CONTROL;
-	if (priv->rx_conf & RTL818X_RX_CONF_MONITOR)
+	if (priv->rx_conf & RTL818X_RX_CONF_MONITOR) {
 		*total_flags |= FIF_OTHER_BSS;
-	if (priv->rx_conf & RTL818X_RX_CONF_MULTICAST)
 		*total_flags |= FIF_ALLMULTI;
+	}
 
 	rtl818x_iowrite32_async(priv, &priv->map->RX_CONF, priv->rx_conf);
 }
-- 
2.11.1
