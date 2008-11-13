Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:53339 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYKMPjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 10:39:09 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 1/3] rtl8187: fix 8187B throughput regression
Date: Thu, 13 Nov 2008 10:39:14 -0500
Message-Id: <1226590756-10743-2-git-send-email-herton@mandriva.com.br> (sfid-20081113_163915_673546_59345FE1)
In-Reply-To: <1226590756-10743-1-git-send-email-herton@mandriva.com.br>
References: <1226590756-10743-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung reported that after the change "rtl8187: add short slot
handling for 8187B" his RTL8187B started to give low throughput on
network transfers. Turns out that the SIFS setting used isn't ok, it
doesn't look to be the real aSIFSTime, using the "magical" 0x22 value
like on other 818x variants as the vendor does too fixes the issue.

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 9212cea..695e66d 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -927,7 +927,7 @@ static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot,
 			difs = 0x32;
 			eifs = 0x5b;
 		}
-		rtl818x_iowrite8(priv, &priv->map->SIFS, 0xa);
+		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
 		rtl818x_iowrite8(priv, &priv->map->SLOT, slot_time);
 		rtl818x_iowrite8(priv, &priv->map->DIFS, difs);
 
-- 
1.6.0.2

