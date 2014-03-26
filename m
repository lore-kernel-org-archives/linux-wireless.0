Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60939 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbaCZUBx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 16:01:53 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so2073179eei.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 13:01:52 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 15/20] rtl8180: add ERP configuration for rtl8187se
Date: Wed, 26 Mar 2014 21:03:03 +0100
Message-Id: <1395864183-4988-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_210157_983690_A2788D76)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds ERP configuration support for rtl8187se to the
existing ERP configuration function.
It needs a different register offset and it must not apply
rtl8185 workaround.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 8061852..6f9da01 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -1336,13 +1336,17 @@ static void rtl8180_conf_erp(struct ieee80211_hw *dev,
 	/* from reference code. set ack timeout reg = eifs reg */
 	rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER, hw_eifs);
 
-	/* rtl8187/rtl8185 HW bug. After EIFS is elapsed,
-	 * the HW still wait for DIFS.
-	 * HW uses 4uS units for EIFS.
-	 */
-	hw_eifs = DIV_ROUND_UP(eifs - difs, 4);
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE)
+		rtl818x_iowrite8(priv, &priv->map->EIFS_8187SE, hw_eifs);
+	else if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185) {
+		/* rtl8187/rtl8185 HW bug. After EIFS is elapsed,
+		 * the HW still wait for DIFS.
+		 * HW uses 4uS units for EIFS.
+		 */
+		hw_eifs = DIV_ROUND_UP(eifs - difs, 4);
 
-	rtl818x_iowrite8(priv, &priv->map->EIFS, hw_eifs);
+		rtl818x_iowrite8(priv, &priv->map->EIFS, hw_eifs);
+	}
 }
 
 static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
-- 
1.8.3.2

