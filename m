Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:48660 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZHUAez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 20:34:55 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: always set MSR_LINK_ENEDCA flag with RTL8187B
Date: Thu, 20 Aug 2009 21:16:17 -0300
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200908202116.17847.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RTL8187B always needs MSR_LINK_ENEDCA flag to be set even when it is in
no link mode, otherwise it'll not be able to associate when this flag is
not set after the change "mac80211: fix managed mode BSSID handling"
(commit 9cef8737).

By accident, setting BSSID of AP before association makes 8187B to
successfuly associate even when ENEDCA flag isn't set, which was the
case before the mac80211 change. But now the BSSID of AP we are trying
to associate is only available after association is successful, and
any attempt to associate without the needed flag doesn't work.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

This is a bug fix that should be sent too for 2.6.31-rcX

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 90f3835..5830f6c 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -870,6 +870,9 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	priv->aifsn[3] = 3; /* AIFSN[AC_BE] */
 	rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0);
 
+	/* ENEDCA flag must always be set, transmit issues? */
+	rtl818x_iowrite8(priv, &priv->map->MSR, RTL818X_MSR_ENEDCA);
+
 	return 0;
 }
 
@@ -1174,13 +1177,16 @@ static void rtl8187_bss_info_changed(struct ieee80211_hw *dev,
 			rtl818x_iowrite8(priv, &priv->map->BSSID[i],
 					 info->bssid[i]);
 
+		if (priv->is_rtl8187b)
+			reg = RTL818X_MSR_ENEDCA;
+		else
+			reg = 0;
+
 		if (is_valid_ether_addr(info->bssid)) {
-			reg = RTL818X_MSR_INFRA;
-			if (priv->is_rtl8187b)
-				reg |= RTL818X_MSR_ENEDCA;
+			reg |= RTL818X_MSR_INFRA;
 			rtl818x_iowrite8(priv, &priv->map->MSR, reg);
 		} else {
-			reg = RTL818X_MSR_NO_LINK;
+			reg |= RTL818X_MSR_NO_LINK;
 			rtl818x_iowrite8(priv, &priv->map->MSR, reg);
 		}
 
-- 
1.6.4

