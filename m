Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:62841 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab1F0M6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 08:58:15 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so1789140fxd.11
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 05:58:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/5] b43: HT-PHY: implement lacking 0x908 PHY reg op
Date: Mon, 27 Jun 2011 14:58:53 +0200
Message-Id: <1309179534-8081-4-git-send-email-zajec5@gmail.com> (sfid-20110627_150218_926666_77E18A61)
In-Reply-To: <1309179534-8081-1-git-send-email-zajec5@gmail.com>
References: <1309179534-8081-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
As always, I've hacked MMIO ops to return 0xFFFF for 0x908 PHY reg.
This allowed finding masks used by closed source driver.

At the beginning 0x908 PHY reg ops are following:
 phy_read(0x0908) -> 0xffff
phy_write(0x0908) <- 0x0002
(...)
 phy_read(0x0908) -> 0xffff
phy_write(0x0908) <- 0x0020
(...)
 phy_read(0x0908) -> 0xffff
phy_write(0x0908) <- 0x0200

Later this is always like this:
 phy_read(0x0908) -> 0xffff
phy_write(0x0908) <- 0x0000

We do not know the proper condition yet, let's use FIXME for it.
---
 drivers/net/wireless/b43/phy_ht.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 42bea30..3bc1fe7 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -104,9 +104,14 @@ static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
 
 	/* TODO: separated function? */
 	for (i = 0; i < 3; i++) {
+		u16 mask;
 		u32 tmp = b43_httab_read(dev, B43_HTTAB32(26, 0xE8));
 
-		/* TODO: some op on PHY reg 0x908 */
+		if (0) /* FIXME */
+			mask = ~(0x2 << (i * 4));
+		else
+			mask = ~0;
+		b43_phy_mask(dev, B43_PHY_EXTG(0x108), mask);
 
 		b43_httab_write(dev, B43_HTTAB16(7, 0x110 + i), tmp >> 16);
 		b43_httab_write(dev, B43_HTTAB8(13, 0x63 + (i * 4)),
-- 
1.7.1

