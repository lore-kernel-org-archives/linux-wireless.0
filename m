Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48228 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1IPKbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 06:31:08 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so1527867fxe.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 03:31:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/6] b43: LCN-PHY: tweaks for channel switching
Date: Fri, 16 Sep 2011 12:33:59 +0200
Message-Id: <1316169243-8808-2-git-send-email-zajec5@gmail.com> (sfid-20110916_123117_992993_455C903A)
In-Reply-To: <1316169243-8808-1-git-send-email-zajec5@gmail.com>
References: <1316169243-8808-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They have been taken from brcmsmac, add Broadcom's copyright.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lcn.c |   67 +++++++++++++++++++++++++++++++++--
 1 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index d1dfeec..06d8efc 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -20,6 +20,14 @@
   the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
   Boston, MA 02110-1301, USA.
 
+  This file incorporates work covered by the following copyright and
+  permission notice:
+
+      Copyright (c) 2010 Broadcom Corporation
+
+      Permission to use, copy, modify, and/or distribute this software for any
+      purpose with or without fee is hereby granted, provided that the above
+      copyright notice and this permission notice appear in all copies.
 */
 
 #include <linux/slab.h>
@@ -278,14 +286,50 @@ static void b43_phy_lcn_sense_setup(struct b43_wldev *dev)
  * Channel switching ops.
  **************************************************/
 
-static int b43_phy_lcn_set_channel(struct b43_wldev *dev,
-				   struct ieee80211_channel *channel,
-				   enum nl80211_channel_type channel_type)
+/* wlc_lcnphy_set_chanspec_tweaks */
+static void b43_phy_lcn_set_channel_tweaks(struct b43_wldev *dev, int channel)
 {
-	/* TODO: PLL and PHY ops */
+	struct bcma_drv_cc *cc = &dev->dev->bdev->bus->drv_cc;
+
+	b43_phy_maskset(dev, 0x448, ~0x300, (channel == 14) ? 0x200 : 0x100);
+
+	if (channel == 1 || channel == 2 || channel == 3 || channel == 4 ||
+	    channel == 9 || channel == 10 || channel == 11 || channel == 12) {
+		bcma_chipco_pll_write(cc, 0x2, 0x03000c04);
+		bcma_chipco_pll_maskset(cc, 0x3, 0x00ffffff, 0x0);
+		bcma_chipco_pll_write(cc, 0x4, 0x200005c0);
+
+		bcma_cc_set32(cc, BCMA_CC_PMU_CTL, 0x400);
+
+		b43_phy_write(dev, 0x942, 0);
+
+		/* b43_phy_lcn_txrx_spur_avoidance_mode(dev, false); */
+		b43_phy_maskset(dev, 0x424, (u16) ~0xff00, 0x1b00);
+		b43_phy_write(dev, 0x425, 0x5907);
+	} else {
+		bcma_chipco_pll_write(cc, 0x2, 0x03140c04);
+		bcma_chipco_pll_maskset(cc, 0x3, 0x00ffffff, 0x333333);
+		bcma_chipco_pll_write(cc, 0x4, 0x202c2820);
+
+		bcma_cc_set32(cc, BCMA_CC_PMU_CTL, 0x400);
+
+		b43_phy_write(dev, 0x942, 0);
+
+		/* b43_phy_lcn_txrx_spur_avoidance_mode(dev, true); */
+		b43_phy_maskset(dev, 0x424, (u16) ~0xff00, 0x1f00);
+		b43_phy_write(dev, 0x425, 0x590a);
+	}
 
 	b43_phy_set(dev, 0x44a, 0x44);
 	b43_phy_write(dev, 0x44a, 0x80);
+}
+
+/* wlc_phy_chanspec_set_lcnphy */
+static int b43_phy_lcn_set_channel(struct b43_wldev *dev,
+				   struct ieee80211_channel *channel,
+				   enum nl80211_channel_type channel_type)
+{
+	b43_phy_lcn_set_channel_tweaks(dev, channel->hw_value);
 
 	b43_phy_set(dev, 0x44a, 0x44);
 	b43_phy_write(dev, 0x44a, 0x80);
@@ -336,6 +380,8 @@ static void b43_phy_lcn_op_prepare_structs(struct b43_wldev *dev)
 /* wlc_phy_init_lcnphy */
 static int b43_phy_lcn_op_init(struct b43_wldev *dev)
 {
+	struct bcma_drv_cc *cc = &dev->dev->bdev->bus->drv_cc;
+
 	b43_phy_set(dev, 0x44a, 0x80);
 	b43_phy_mask(dev, 0x44a, 0x7f);
 	b43_phy_set(dev, 0x6d1, 0x80);
@@ -359,6 +405,19 @@ static int b43_phy_lcn_op_init(struct b43_wldev *dev)
 
 	b43_phy_lcn_sense_setup(dev);
 
+	b43_switch_channel(dev, dev->phy.channel);
+
+	bcma_chipco_regctl_maskset(cc, 0, 0xf, 0x9);
+	bcma_chipco_chipctl_maskset(cc, 0, 0, 0x03cddddd);
+
+	/* TODO */
+
+	b43_phy_set(dev, 0x448, 0x4000);
+	udelay(100);
+	b43_phy_mask(dev, 0x448, ~0x4000);
+
+	/* TODO */
+
 	return 0;
 }
 
-- 
1.7.3.4

