Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:34124 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab0BIUFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 15:05:07 -0500
Received: by mail-ew0-f228.google.com with SMTP id 28so4264852ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2010 12:05:06 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 05/11] b43: N-PHY: update post init of 2055 radio
Date: Tue,  9 Feb 2010 21:04:37 +0100
Message-Id: <1265745883-3392-6-git-send-email-zajec5@gmail.com>
In-Reply-To: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   61 +++++++++++++++++++++----------------
 1 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index ebb9632..2f45817 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -183,49 +183,58 @@ static void b43_radio_init2055_pre(struct b43_wldev *dev)
 
 static void b43_radio_init2055_post(struct b43_wldev *dev)
 {
+	struct b43_phy_n *nphy = dev->phy.n;
 	struct ssb_sprom *sprom = &(dev->dev->bus->sprom);
 	struct ssb_boardinfo *binfo = &(dev->dev->bus->boardinfo);
 	int i;
 	u16 val;
+	bool workaround = false;
+
+	if (sprom->revision < 4)
+		workaround = (binfo->vendor != PCI_VENDOR_ID_BROADCOM ||
+				binfo->type != 0x46D ||
+				binfo->rev < 0x41);
+	else
+		workaround = ((sprom->boardflags_hi & B43_BFH_NOPA) == 0);
 
 	b43_radio_mask(dev, B2055_MASTER1, 0xFFF3);
-	msleep(1);
-	if ((sprom->revision != 4) ||
-	   !(sprom->boardflags_hi & B43_BFH_RSSIINV)) {
-		if ((binfo->vendor != PCI_VENDOR_ID_BROADCOM) ||
-		    (binfo->type != 0x46D) ||
-		    (binfo->rev < 0x41)) {
-			b43_radio_mask(dev, B2055_C1_RX_BB_REG, 0x7F);
-			b43_radio_mask(dev, B2055_C1_RX_BB_REG, 0x7F);
-			msleep(1);
-		}
+	if (workaround) {
+		b43_radio_mask(dev, B2055_C1_RX_BB_REG, 0x7F);
+		b43_radio_mask(dev, B2055_C2_RX_BB_REG, 0x7F);
 	}
-	b43_radio_maskset(dev, B2055_RRCCAL_NOPTSEL, 0x3F, 0x2C);
-	msleep(1);
-	b43_radio_write16(dev, B2055_CAL_MISC, 0x3C);
-	msleep(1);
+	b43_radio_maskset(dev, B2055_RRCCAL_NOPTSEL, 0xFFC0, 0x2C);
+	b43_radio_write(dev, B2055_CAL_MISC, 0x3C);
 	b43_radio_mask(dev, B2055_CAL_MISC, 0xFFBE);
-	msleep(1);
 	b43_radio_set(dev, B2055_CAL_LPOCTL, 0x80);
-	msleep(1);
 	b43_radio_set(dev, B2055_CAL_MISC, 0x1);
 	msleep(1);
 	b43_radio_set(dev, B2055_CAL_MISC, 0x40);
-	msleep(1);
-	for (i = 0; i < 100; i++) {
-		val = b43_radio_read16(dev, B2055_CAL_COUT2);
-		if (val & 0x80)
+	for (i = 0; i < 200; i++) {
+		val = b43_radio_read(dev, B2055_CAL_COUT2);
+		if (val & 0x80) {
+			i = 0;
 			break;
+		}
 		udelay(10);
 	}
-	msleep(1);
+	if (i)
+		b43err(dev->wl, "radio post init timeout\n");
 	b43_radio_mask(dev, B2055_CAL_LPOCTL, 0xFF7F);
-	msleep(1);
 	nphy_channel_switch(dev, dev->phy.channel);
-	b43_radio_write16(dev, B2055_C1_RX_BB_LPF, 0x9);
-	b43_radio_write16(dev, B2055_C2_RX_BB_LPF, 0x9);
-	b43_radio_write16(dev, B2055_C1_RX_BB_MIDACHP, 0x83);
-	b43_radio_write16(dev, B2055_C2_RX_BB_MIDACHP, 0x83);
+	b43_radio_write(dev, B2055_C1_RX_BB_LPF, 0x9);
+	b43_radio_write(dev, B2055_C2_RX_BB_LPF, 0x9);
+	b43_radio_write(dev, B2055_C1_RX_BB_MIDACHP, 0x83);
+	b43_radio_write(dev, B2055_C2_RX_BB_MIDACHP, 0x83);
+	b43_radio_maskset(dev, B2055_C1_LNA_GAINBST, 0xFFF8, 0x6);
+	b43_radio_maskset(dev, B2055_C2_LNA_GAINBST, 0xFFF8, 0x6);
+	if (!nphy->gain_boost) {
+		b43_radio_set(dev, B2055_C1_RX_RFSPC1, 0x2);
+		b43_radio_set(dev, B2055_C2_RX_RFSPC1, 0x2);
+	} else {
+		b43_radio_mask(dev, B2055_C1_RX_RFSPC1, 0xFFFD);
+		b43_radio_mask(dev, B2055_C2_RX_RFSPC1, 0xFFFD);
+	}
+	udelay(2);
 }
 
 /*
-- 
1.6.4.2

