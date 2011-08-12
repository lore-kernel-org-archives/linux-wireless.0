Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47899 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab1HLXCG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 19:02:06 -0400
Received: by fxh19 with SMTP id 19so2590914fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 16:02:04 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: HT-PHY: init: add missing PHY mask/set ops
Date: Sat, 13 Aug 2011 01:41:11 +0200
Message-Id: <1313192472-12066-1-git-send-email-zajec5@gmail.com> (sfid-20110813_010210_862184_E2EF7BE7)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MMIO hacks were used to trick ndis&wl. For example following:
 phy_read(0x0280) -> 0xffff
phy_write(0x0280) <- 0xff3e
***
 phy_read(0x0280) -> 0x0000
phy_write(0x0280) <- 0x003e
was translated to mask 0xff00 and set 0x3e.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   46 +++++++++++++++++++++++++++++++++----
 1 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 84811b0..2b7507b 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -291,15 +291,19 @@ static void b43_phy_ht_op_prepare_structs(struct b43_wldev *dev)
 
 static int b43_phy_ht_op_init(struct b43_wldev *dev)
 {
+	u8 i;
 	u16 tmp;
 
 	b43_phy_ht_tables_init(dev);
 
-	/* TODO: PHY ops on regs 0x0be, 0x23f 0x240 0x241 */
+	b43_phy_mask(dev, 0x0be, ~0x2);
+	b43_phy_set(dev, 0x23f, 0x7ff);
+	b43_phy_set(dev, 0x240, 0x7ff);
+	b43_phy_set(dev, 0x241, 0x7ff);
 
 	b43_phy_ht_zero_extg(dev);
 
-	/* TODO: PHY op on reg B43_PHY_EXTG(0) */
+	b43_phy_mask(dev, B43_PHY_EXTG(0), ~0x3);
 
 	b43_phy_write(dev, B43_PHY_HT_AFE_CTL1, 0);
 	b43_phy_write(dev, B43_PHY_HT_AFE_CTL3, 0);
@@ -315,14 +319,35 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 	if (0) /* TODO: condition */
 		; /* TODO: PHY op on reg 0x217 */
 
-	; /* TODO: PHY op on reg 0xb0 */
+	b43_phy_read(dev, 0xb0); /* TODO: what for? */
+	b43_phy_set(dev, 0xb0, 0x1);
 
-	; /* TODO: PHY ops on regs 0xb1, 0x32f, 0x077, 0x0b4, 0x17e */
+	b43_phy_set(dev, 0xb1, 0x91);
+	b43_phy_write(dev, 0x32f, 0x0003);
+	b43_phy_write(dev, 0x077, 0x0010);
+	b43_phy_write(dev, 0x0b4, 0x0258);
+	b43_phy_mask(dev, 0x17e, ~0x4000);
 
 	b43_phy_write(dev, 0x0b9, 0x0072);
 
 	/* TODO: Some ops here */
 
+	b43_phy_maskset(dev, 0x0280, 0xff00, 0x3e);
+	b43_phy_maskset(dev, 0x0283, 0xff00, 0x3e);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x0141), 0xff00, 0x46);
+	b43_phy_maskset(dev, 0x0283, 0xff00, 0x40);
+
+	/* TODO: Some ops here */
+
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x24), 0x3f, 0xd);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x64), 0x3f, 0xd);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0xa4), 0x3f, 0xd);
+
+	b43_phy_set(dev, B43_PHY_EXTG(0x060), 0x1);
+	b43_phy_set(dev, B43_PHY_EXTG(0x064), 0x1);
+	b43_phy_set(dev, B43_PHY_EXTG(0x080), 0x1);
+	b43_phy_set(dev, B43_PHY_EXTG(0x084), 0x1);
+
 	/* Copy some tables entries */
 	tmp = b43_httab_read(dev, B43_HTTAB16(7, 0x144));
 	b43_httab_write(dev, B43_HTTAB16(7, 0x14a), tmp);
@@ -340,7 +365,18 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 
 	b43_mac_phy_clock_set(dev, true);
 
-	/* TODO: Some ops here */
+	for (i = 0; i < 2; i++) {
+		tmp = b43_phy_read(dev, B43_PHY_EXTG(0));
+		b43_phy_set(dev, B43_PHY_EXTG(0), 0x3);
+		b43_phy_set(dev, B43_PHY_EXTG(3), i ? 0x20 : 0x1);
+		/* FIXME: wait for some bit to be cleared (find out which) */
+		b43_phy_read(dev, B43_PHY_EXTG(4));
+		b43_phy_write(dev, B43_PHY_EXTG(0), tmp);
+	}
+
+	/* TODO: PHY op on reg 0xb0 */
+
+	/* TODO: PHY ops on regs 0x40e, 0x44e, 0x48e */
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
 		b43_phy_ht_bphy_init(dev);
-- 
1.7.3.4

