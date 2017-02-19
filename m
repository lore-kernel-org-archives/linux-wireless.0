Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from celine.tisys.org ([85.25.117.166]:49644 "EHLO celine.tisys.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751042AbdBTAAo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 19:00:44 -0500
Date: Mon, 20 Feb 2017 00:59:28 +0100
From: Nils Holland <nholland@tisys.org>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2] rtl8187: Enable monitor mode to fix multicast reception
Message-ID: <20170219235919.GA15763@tisys.org> (sfid-20170220_010047_715141_30C08BF6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rtl8187 cards don't seem to receive multicast frames, which,
among other things, makes them fail to receive RAs in IPv6 networks.
The cause seems to be that the RTL818X_RX_CONF_MULTICAST flag doesn't
have the desired effect.

Fix the issue by setting RTL818X_RX_CONF_MONITOR instead, which puts the
card into monitor mode and resolves the problem so that multicast frames
are sucessfully passed to the kernel.

The existence of the problem and the effectiveness of the solution has
originally been confirmed on an 8187B based card with the USB id of
0bda:8197. Subsequent testing by Larry Finger on an 8187L based card,
which follows the second (8187, i.e. "non-b") code path in the driver,
has confirmed that the fix does not cause any noticeable regresssions
there either.

Signed-off-by: Nils Holland <nholland@tisys.org>
---
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
