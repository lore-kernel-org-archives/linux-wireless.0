Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:37546 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaGHNL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2014 09:11:27 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so5958322wes.15
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2014 06:11:25 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/7] b43: N-PHY: drop reg 0x1 access restriction on new PHY revs
Date: Tue,  8 Jul 2014 15:11:04 +0200
Message-Id: <1404825070-5243-1-git-send-email-zajec5@gmail.com> (sfid-20140708_151130_367735_24B33096)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialization of N-PHY radio revs 5 and 7 requires writing to 0x1.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 50ca6f8..1dba640 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -5834,7 +5834,7 @@ static void b43_nphy_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
 static u16 b43_nphy_op_radio_read(struct b43_wldev *dev, u16 reg)
 {
 	/* Register 1 is a 32-bit register. */
-	B43_WARN_ON(reg == 1);
+	B43_WARN_ON(dev->phy.rev < 7 && reg == 1);
 
 	if (dev->phy.rev >= 7)
 		reg |= 0x200; /* Radio 0x2057 */
@@ -5848,7 +5848,7 @@ static u16 b43_nphy_op_radio_read(struct b43_wldev *dev, u16 reg)
 static void b43_nphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 {
 	/* Register 1 is a 32-bit register. */
-	B43_WARN_ON(reg == 1);
+	B43_WARN_ON(dev->phy.rev < 7 && reg == 1);
 
 	b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
 	b43_write16(dev, B43_MMIO_RADIO_DATA_LOW, value);
-- 
1.8.4.5

