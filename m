Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64843 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbaCZT6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 15:58:16 -0400
Received: by mail-ee0-f43.google.com with SMTP id e53so2074465eek.2
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 12:58:15 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 04/20] rtl8180: add basic rate configuration support for rtl8187se
Date: Wed, 26 Mar 2014 20:59:25 +0100
Message-Id: <1395863965-4487-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_205827_731092_A8374158)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Basic rate configuration is a bit different for rtl8187se.
Adding this also fixes the gcc warning introduced in last patch
about unhandled case in switch.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 767e104..6b237ed 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -412,7 +412,6 @@ static void rtl8180_conf_basic_rates(struct ieee80211_hw *dev,
 		reg &= ~3;
 		reg |= max;
 		rtl818x_iowrite16(priv, &priv->map->BRSR, reg);
-
 		break;
 
 	case RTL818X_CHIP_FAMILY_RTL8185:
@@ -420,6 +419,11 @@ static void rtl8180_conf_basic_rates(struct ieee80211_hw *dev,
 		rtl818x_iowrite16(priv, &priv->map->BRSR, rates_mask);
 		rtl818x_iowrite8(priv, &priv->map->RESP_RATE, (max << 4) | min);
 		break;
+
+	case RTL818X_CHIP_FAMILY_RTL8187SE:
+		/* in 8187se this is a BITMAP */
+		rtl818x_iowrite16(priv, &priv->map->BRSR_8187SE, rates_mask);
+		break;
 	}
 }
 
-- 
1.8.3.2

