Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:35818 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbcKYLLJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 06:11:09 -0500
Received: by mail-pg0-f51.google.com with SMTP id p66so29018324pga.2
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2016 03:11:08 -0800 (PST)
From: Anthony Romano <anthony.romano@coreos.com>
To: linux-wireless@vger.kernel.org
Cc: kubakici@wp.pl
Subject: [PATCH] mt7601u: wait for clear rxq when stopping mac
Date: Fri, 25 Nov 2016 03:13:34 -0800
Message-Id: <20161125111334.31085-1-anthony.romano@coreos.com> (sfid-20161125_121114_446789_ABFA659F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mt7601u_mac_stop_hw should stop polling the rxq once it remains empty
but instead continues polling after the rxq status stays clear; bringing
down the interface takes about six seconds from this alone.

Speed up path by exiting rxq loop once status repeatedly polls empty.

Signed-off-by: Anthony Romano <anthony.romano@coreos.com>
---
 drivers/net/wireless/mediatek/mt7601u/init.c | 14 +++++++-------
 drivers/net/wireless/mediatek/mt7601u/regs.h |  3 +++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
index 44d46e25db80..a6e901766226 100644
--- a/drivers/net/wireless/mediatek/mt7601u/init.c
+++ b/drivers/net/wireless/mediatek/mt7601u/init.c
@@ -293,13 +293,13 @@ static void mt7601u_mac_stop_hw(struct mt7601u_dev *dev)
 	ok = 0;
 	i = 200;
 	while (i--) {
-		if ((mt76_rr(dev, 0x0430) & 0x00ff0000) ||
-		    (mt76_rr(dev, 0x0a30) & 0xffffffff) ||
-		    (mt76_rr(dev, 0x0a34) & 0xffffffff))
-			ok++;
-		if (ok > 6)
-			break;
-
+		if (!(mt76_rr(dev, MT_RXQ_STA) & 0x00ff0000) &&
+		    !mt76_rr(dev, 0x0a30) &&
+		    !mt76_rr(dev, 0x0a34)) {
+			if (ok++ > 5)
+				break;
+			continue;
+		}
 		msleep(1);
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt7601u/regs.h b/drivers/net/wireless/mediatek/mt7601u/regs.h
index 27a429d90cec..2a8837002f00 100644
--- a/drivers/net/wireless/mediatek/mt7601u/regs.h
+++ b/drivers/net/wireless/mediatek/mt7601u/regs.h
@@ -192,6 +192,9 @@
 #define MT_BCN_OFFSET_BASE		0x041c
 #define MT_BCN_OFFSET(_n)		(MT_BCN_OFFSET_BASE + ((_n) << 2))
 
+#define MT_RXQ_STA			0x0430
+#define MT_TXQ_STA			0x0434
+
 #define	MT_RF_CSR_CFG			0x0500
 #define MT_RF_CSR_CFG_DATA		GENMASK(7, 0)
 #define MT_RF_CSR_CFG_REG_ID		GENMASK(13, 8)
-- 
2.11.0.rc2
