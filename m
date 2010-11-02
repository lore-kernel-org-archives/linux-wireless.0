Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:47851 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab0KBBAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 21:00:15 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 5/9] rtl8187: move pll reset at start out of ANAPARAM write
Date: Mon,  1 Nov 2010 22:59:35 -0200
Message-Id: <1288659579-4986-6-git-send-email-herton@mandriva.com.br>
In-Reply-To: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
References: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8187B start, comment about pll reset, and move it out of ANAPARAM
write sequence, so that code is more readable.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 063374a..2b4ee26 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -742,7 +742,6 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
 			 RTL818X_EEPROM_CMD_CONFIG);
-
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE | RTL818X_CONFIG3_GNT_SELECT;
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
@@ -752,19 +751,19 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 			  RTL8187B_RTL8225_ANAPARAM_ON);
 	rtl818x_iowrite8(priv, &priv->map->ANAPARAM3,
 			 RTL8187B_RTL8225_ANAPARAM3_ON);
-
-	rtl818x_iowrite8(priv, (u8 *)0xFF61, 0x10);
-	reg = rtl818x_ioread8(priv, (u8 *)0xFF62);
-	rtl818x_iowrite8(priv, (u8 *)0xFF62, reg & ~(1 << 5));
-	rtl818x_iowrite8(priv, (u8 *)0xFF62, reg | (1 << 5));
-
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 	reg &= ~RTL818X_CONFIG3_ANAPARAM_WRITE;
 	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
-
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
 			 RTL818X_EEPROM_CMD_NORMAL);
 
+	/* Reset PLL sequence on 8187B. Realtek note: reduces power
+	 * consumption about 30 mA */
+	rtl818x_iowrite8(priv, (u8 *)0xFF61, 0x10);
+	reg = rtl818x_ioread8(priv, (u8 *)0xFF62);
+	rtl818x_iowrite8(priv, (u8 *)0xFF62, reg & ~(1 << 5));
+	rtl818x_iowrite8(priv, (u8 *)0xFF62, reg | (1 << 5));
+
 	res = rtl8187_cmd_reset(dev);
 	if (res)
 		return res;
-- 
1.7.3.2

