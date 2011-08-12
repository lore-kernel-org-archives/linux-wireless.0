Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38327 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab1HLKen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 06:34:43 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so2219714fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 03:34:42 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/4] b43: HT-PHY: init: implement few simple PHY writes
Date: Fri, 12 Aug 2011 13:13:45 +0200
Message-Id: <1313147627-8713-2-git-send-email-zajec5@gmail.com> (sfid-20110812_123455_331166_FD53EF2C)
In-Reply-To: <1313147627-8713-1-git-send-email-zajec5@gmail.com>
References: <1313147627-8713-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Not much magic, after zeroing EXTG regs, ndis does:

 phy_read(0x0800) -> 0x0003
phy_write(0x0800) <- 0x0000

phy_write(0x0910) <- 0x0000
phy_write(0x0914) <- 0x0000
phy_write(0x0918) <- 0x0000
phy_write(0x0903) <- 0x0020
phy_write(0x0901) <- 0x0020
phy_write(0x020d) <- 0x00b8
phy_write(0x094f) <- 0x00c8
phy_write(0x0070) <- 0x0050
phy_write(0x01ff) <- 0x0030
---
 drivers/net/wireless/b43/phy_ht.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 99b3035..969e86e 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -279,6 +279,28 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 
 	b43_phy_ht_zero_extg(dev);
 
+	/* TODO: PHY op on reg B43_PHY_EXTG(0) */
+
+	b43_phy_write(dev, B43_PHY_HT_AFE_CTL1, 0);
+	b43_phy_write(dev, B43_PHY_HT_AFE_CTL3, 0);
+	b43_phy_write(dev, B43_PHY_HT_AFE_CTL5, 0);
+
+	b43_phy_write(dev, B43_PHY_EXTG(0x103), 0x20);
+	b43_phy_write(dev, B43_PHY_EXTG(0x101), 0x20);
+	b43_phy_write(dev, 0x20d, 0xb8);
+	b43_phy_write(dev, B43_PHY_EXTG(0x14f), 0xc8);
+	b43_phy_write(dev, 0x70, 0x50);
+	b43_phy_write(dev, 0x1ff, 0x30);
+
+	if (0) /* TODO: condition */
+		; /* TODO: PHY op on reg 0x217 */
+
+	; /* TODO: PHY op on reg 0xb0 */
+
+	; /* TODO: PHY ops on regs 0xb1, 0x32f, 0x077, 0x0b4, 0x17e */
+
+	b43_phy_write(dev, 0x0b9, 0x0072);
+
 	return 0;
 }
 
-- 
1.7.3.4

