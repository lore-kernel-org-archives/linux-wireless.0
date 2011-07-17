Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:57455 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1GQHv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 03:51:56 -0400
Received: by fxd18 with SMTP id 18so4861845fxd.11
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 00:51:55 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/4] b43: HT-PHY: fix masks in radio ctl
Date: Sun, 17 Jul 2011 10:30:31 +0200
Message-Id: <1310891434-3537-1-git-send-email-zajec5@gmail.com> (sfid-20110717_095159_858857_4BA3DB50)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Old masks were causing ugly, delayed lock ups.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 2982103..0cc293a 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -277,12 +277,12 @@ static void b43_phy_ht_op_software_rfkill(struct b43_wldev *dev,
 		b43err(dev->wl, "MAC not suspended\n");
 
 	if (blocked) {
-		b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, ~0);
+		b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, 0);
 	} else {
-		b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, ~0);
-		b43_phy_maskset(dev, B43_PHY_HT_RF_CTL1, ~0, 0x1);
-		b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, ~0);
-		b43_phy_maskset(dev, B43_PHY_HT_RF_CTL1, ~0, 0x2);
+		b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, 0);
+		b43_phy_maskset(dev, B43_PHY_HT_RF_CTL1, 0, 0x1);
+		b43_phy_mask(dev, B43_PHY_HT_RF_CTL1, 0);
+		b43_phy_maskset(dev, B43_PHY_HT_RF_CTL1, 0, 0x2);
 
 		if (dev->phy.radio_ver == 0x2059)
 			b43_radio_2059_init(dev);
-- 
1.7.3.4

