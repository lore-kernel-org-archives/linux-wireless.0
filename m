Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47899 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab1HLXCI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 19:02:08 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so2590914fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 16:02:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: HT-PHY: init: add some AFE (Analog Frontend) operation
Date: Sat, 13 Aug 2011 01:41:12 +0200
Message-Id: <1313192472-12066-2-git-send-email-zajec5@gmail.com> (sfid-20110813_010212_973760_519DD702)
In-Reply-To: <1313192472-12066-1-git-send-email-zajec5@gmail.com>
References: <1313192472-12066-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 2b7507b..80c448d 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -169,6 +169,28 @@ static void b43_phy_ht_zero_extg(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_PHY_EXTG(base[i] + 0xc), 0);
 }
 
+/* Some unknown AFE (Analog Frondned) op */
+static void b43_phy_ht_afe_unk1(struct b43_wldev *dev)
+{
+	u8 i;
+
+	const u16 ctl_regs[3][2] = {
+		{ B43_PHY_HT_AFE_CTL1, B43_PHY_HT_AFE_CTL2 },
+		{ B43_PHY_HT_AFE_CTL3, B43_PHY_HT_AFE_CTL4 },
+		{ B43_PHY_HT_AFE_CTL5, B43_PHY_HT_AFE_CTL6},
+	};
+
+	for (i = 0; i < 3; i++) {
+		/* TODO: verify masks&sets */
+		b43_phy_set(dev, ctl_regs[i][1], 0x4);
+		b43_phy_set(dev, ctl_regs[i][0], 0x4);
+		b43_phy_mask(dev, ctl_regs[i][1], ~0x1);
+		b43_phy_set(dev, ctl_regs[i][0], 0x1);
+		b43_httab_write(dev, B43_HTTAB16(8, 5 + (i * 0x10)), 0);
+		b43_phy_mask(dev, ctl_regs[i][0], ~0x4);
+	}
+}
+
 static void b43_phy_ht_bphy_init(struct b43_wldev *dev)
 {
 	unsigned int i;
@@ -332,6 +354,10 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 
 	/* TODO: Some ops here */
 
+	b43_phy_ht_afe_unk1(dev);
+
+	/* TODO: Some ops here */
+
 	b43_phy_maskset(dev, 0x0280, 0xff00, 0x3e);
 	b43_phy_maskset(dev, 0x0283, 0xff00, 0x3e);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x0141), 0xff00, 0x46);
-- 
1.7.3.4

