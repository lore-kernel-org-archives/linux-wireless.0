Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:64289 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbaCZUCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 16:02:15 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so2077964eek.34
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 13:02:14 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 16/20] rtl8180: make sure RTL818X_MSR_ENEDCA is set for rtl8187se
Date: Wed, 26 Mar 2014 21:03:17 +0100
Message-Id: <1395864197-5032-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_210218_820822_7E06FE16)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MSR register for rtl8187se must always have ENEDCA flag set.
Write it accordingly when updated on BSS change.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 6f9da01..eb678da 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -1373,6 +1373,10 @@ static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
 				reg = RTL818X_MSR_INFRA;
 		} else
 			reg = RTL818X_MSR_NO_LINK;
+
+		if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE)
+			reg |= RTL818X_MSR_ENEDCA;
+
 		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
 	}
 
-- 
1.8.3.2

