Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:62551 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbaCZT7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 15:59:33 -0400
Received: by mail-ee0-f43.google.com with SMTP id e53so2075679eek.2
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 12:59:32 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 08/20] rtl8180: don't write MAR registers for rtl8187se
Date: Wed, 26 Mar 2014 21:00:42 +0100
Message-Id: <1395864042-4658-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_205938_646570_D5E25AE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MAR registers are not present in rtl8187se, and attempting to
write to them must be avoided

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 92b6d53..cce972d 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -779,8 +779,13 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 
 	rtl8180_int_enable(dev);
 
-	rtl818x_iowrite32(priv, &priv->map->MAR[0], ~0);
-	rtl818x_iowrite32(priv, &priv->map->MAR[1], ~0);
+	/* in rtl8187se at MAR regs offset there is the management
+	 * TX descriptor DMA addres..
+	 */
+	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8187SE) {
+		rtl818x_iowrite32(priv, &priv->map->MAR[0], ~0);
+		rtl818x_iowrite32(priv, &priv->map->MAR[1], ~0);
+	}
 
 	reg = RTL818X_RX_CONF_ONLYERLPKT |
 	      RTL818X_RX_CONF_RX_AUTORESETPHY |
-- 
1.8.3.2

