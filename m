Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:41407 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaDDQ0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2014 12:26:22 -0400
Received: by mail-we0-f179.google.com with SMTP id x48so3666905wes.38
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2014 09:26:21 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	andrea.merello@gmail.com
Subject: [PATCH 4/4] rtl8180: be paranoid in stopping unused queues.
Date: Fri,  4 Apr 2014 18:25:51 +0200
Message-Id: <1396628751-14564-1-git-send-email-andrea.merello@gmail.com> (sfid-20140404_182628_736113_421DFCB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HW should never attempt to perform DMA for unused queues.
For rtl8187se this is ensured by setting a dedicated register at
init time, before enabling TX.

In rtl8180/5 the register is only written at the first TX (because
in rtl8180/5 it serves also to kick DMA for used queues).
This should be enough, but it's worth to add a register write at
init time, before enabling TX.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index cb8275f..50d69b1 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -910,7 +910,10 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 		reg32 &= 0x00ffff00;
 		reg32 |= 0xb8000054;
 		rtl818x_iowrite32(priv, &priv->map->RF_PARA, reg32);
-	}
+	} else
+		/* stop unused queus (no dma alloc) */
+		rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING,
+			    (1<<1) | (1<<2));
 
 	priv->rf->init(dev);
 
-- 
1.8.3.2

