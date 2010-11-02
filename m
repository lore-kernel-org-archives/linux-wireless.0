Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:47820 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab0KBBAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 21:00:11 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 2/9] rtl8187: remove setting of beacon/atim registers from initialization
Date: Mon,  1 Nov 2010 22:59:32 -0200
Message-Id: <1288659579-4986-3-git-send-email-herton@mandriva.com.br>
In-Reply-To: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
References: <1288659579-4986-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8187B path, we set a initial value for beacon interval and atim
window on initialization. But this isn't needed, since same setup is
done on rtl8187_config.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 3dbf305..30c2120 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -779,8 +779,6 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	rtl818x_iowrite16_idx(priv, (__le16 *)0xFFE0, 0x0FFF, 1);
 	rtl818x_iowrite8_idx(priv, (u8 *)0xFFE2, 0x00, 1);
 
-	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL, 100);
-	rtl818x_iowrite16(priv, &priv->map->ATIM_WND, 2);
 	rtl818x_iowrite16_idx(priv, (__le16 *)0xFFD4, 0xFFFF, 1);
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
-- 
1.7.3.2

