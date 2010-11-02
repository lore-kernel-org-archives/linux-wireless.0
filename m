Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:47850 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab0KBBAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 21:00:15 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 4/9] rtl8187: avoid redundant write to register FF72 (RFSW_CTRL)
Date: Mon,  1 Nov 2010 22:59:34 -0200
Message-Id: <1288659579-4986-5-git-send-email-herton@mandriva.com.br>
In-Reply-To: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
References: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The table with misc register initialization was setting it, and later
on we would set it again with a explicity call to rtl818x_iowrite16_idx.

Remove duplicate initialization from the register table.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index b9ce2a8..063374a 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -722,8 +722,7 @@ static const u8 rtl8187b_reg_table[][3] = {
 	{0x52, 0x04, 2}, {0x53, 0xA0, 2}, {0x54, 0x1F, 2}, {0x55, 0x23, 2},
 	{0x56, 0x45, 2}, {0x57, 0x67, 2}, {0x58, 0x08, 2}, {0x59, 0x08, 2},
 	{0x5A, 0x08, 2}, {0x5B, 0x08, 2}, {0x60, 0x08, 2}, {0x61, 0x08, 2},
-	{0x62, 0x08, 2}, {0x63, 0x08, 2}, {0x64, 0xCF, 2}, {0x72, 0x56, 2},
-	{0x73, 0x9A, 2},
+	{0x62, 0x08, 2}, {0x63, 0x08, 2}, {0x64, 0xCF, 2},
 
 	{0x5B, 0x40, 0}, {0x84, 0x88, 0}, {0x85, 0x24, 0}, {0x88, 0x54, 0},
 	{0x8B, 0xB8, 0}, {0x8C, 0x07, 0}, {0x8D, 0x00, 0}, {0x94, 0x1B, 0},
@@ -810,6 +809,7 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 
 	rtl818x_iowrite32(priv, &priv->map->RF_TIMING, 0x00004001);
 
+	/* RFSW_CTRL register */
 	rtl818x_iowrite16_idx(priv, (__le16 *)0xFF72, 0x569A, 2);
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
-- 
1.7.3.2

