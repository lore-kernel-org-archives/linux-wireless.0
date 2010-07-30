Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40853 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab0G3CAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 22:00:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8187: consolidate MSR writes in rtl8187_bss_info_changed
Date: Thu, 29 Jul 2010 21:57:24 -0400
Message-Id: <1280455044-26073-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 5738a55..0801c1d 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1176,13 +1176,12 @@ static void rtl8187_bss_info_changed(struct ieee80211_hw *dev,
 		else
 			reg = 0;
 
-		if (is_valid_ether_addr(info->bssid)) {
+		if (is_valid_ether_addr(info->bssid))
 			reg |= RTL818X_MSR_INFRA;
-			rtl818x_iowrite8(priv, &priv->map->MSR, reg);
-		} else {
+		else
 			reg |= RTL818X_MSR_NO_LINK;
-			rtl818x_iowrite8(priv, &priv->map->MSR, reg);
-		}
+
+		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
 
 		mutex_unlock(&priv->conf_mutex);
 	}
-- 
1.7.1.1

