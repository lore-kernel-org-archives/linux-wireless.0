Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:47852 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab0KBBAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 21:00:15 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	seno <senada@t-online.de>
Subject: [PATCH 8/9] rtl8187: remove uneeded setting of anaparam write
Date: Mon,  1 Nov 2010 22:59:38 -0200
Message-Id: <1288659579-4986-9-git-send-email-herton@mandriva.com.br>
In-Reply-To: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
References: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Usually you set RTL818X_CONFIG3_ANAPARAM_WRITE when you are going to
change/write ANAPARAM registers. But in current initialization of
RTL8187B there is a place where ANAPARAM_WRITE bit is set without any
ANAPARAM register being written, without reason, so remove it.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: seno <senada@t-online.de>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index c0c75aa..4448647 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -814,14 +814,6 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	/* RFSW_CTRL register */
 	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF72, 0x569A, 2);
 
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
-			 RTL818X_EEPROM_CMD_CONFIG);
-	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
-	reg |= RTL818X_CONFIG3_ANAPARAM_WRITE;
-	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
-	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
-			 RTL818X_EEPROM_CMD_NORMAL);
-
 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x2488);
 	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
-- 
1.7.3.2

