Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:47830 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab0KBBAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 21:00:12 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 1/9] rtl8187: remove redundant initialization of ARFR
Date: Mon,  1 Nov 2010 22:59:31 -0200
Message-Id: <1288659579-4986-2-git-send-email-herton@mandriva.com.br>
In-Reply-To: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
References: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes redundant write to Auto Rate Fallback Register on RTL8187B.
The same value was being written twice in the same function. Avoid this
removing the duplicate initialization on rtl8187b_reg_table, and also
add comment for this write (information from Realtek source).

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 6e26149..3dbf305 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -712,10 +712,9 @@ static const u8 rtl8187b_reg_table[][3] = {
 
 	{0x58, 0x4B, 1}, {0x59, 0x00, 1}, {0x5A, 0x4B, 1}, {0x5B, 0x00, 1},
 	{0x60, 0x4B, 1}, {0x61, 0x09, 1}, {0x62, 0x4B, 1}, {0x63, 0x09, 1},
-	{0xCE, 0x0F, 1}, {0xCF, 0x00, 1}, {0xE0, 0xFF, 1}, {0xE1, 0x0F, 1},
-	{0xE2, 0x00, 1}, {0xF0, 0x4E, 1}, {0xF1, 0x01, 1}, {0xF2, 0x02, 1},
-	{0xF3, 0x03, 1}, {0xF4, 0x04, 1}, {0xF5, 0x05, 1}, {0xF6, 0x06, 1},
-	{0xF7, 0x07, 1}, {0xF8, 0x08, 1},
+	{0xCE, 0x0F, 1}, {0xCF, 0x00, 1}, {0xF0, 0x4E, 1}, {0xF1, 0x01, 1},
+	{0xF2, 0x02, 1}, {0xF3, 0x03, 1}, {0xF4, 0x04, 1}, {0xF5, 0x05, 1},
+	{0xF6, 0x06, 1}, {0xF7, 0x07, 1}, {0xF8, 0x08, 1},
 
 	{0x4E, 0x00, 2}, {0x0C, 0x04, 2}, {0x21, 0x61, 2}, {0x22, 0x68, 2},
 	{0x23, 0x6F, 2}, {0x24, 0x76, 2}, {0x25, 0x7D, 2}, {0x26, 0x84, 2},
@@ -776,7 +775,9 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
 	rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
 
+	/* Auto Rate Fallback Register (ARFR): 1M-54M setting */
 	rtl818x_iowrite16_idx(priv, (__le16 *)0xFFE0, 0x0FFF, 1);
+	rtl818x_iowrite8_idx(priv, (u8 *)0xFFE2, 0x00, 1);
 
 	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL, 100);
 	rtl818x_iowrite16(priv, &priv->map->ATIM_WND, 2);
-- 
1.7.3.2

