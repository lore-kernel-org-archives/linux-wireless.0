Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48228 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1IPKbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 06:31:21 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so1527867fxe.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 03:31:20 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 6/6] b43: LCN-PHY: add more init tweaks
Date: Fri, 16 Sep 2011 12:34:03 +0200
Message-Id: <1316169243-8808-6-git-send-email-zajec5@gmail.com> (sfid-20110916_123124_954605_6A332DEF)
In-Reply-To: <1316169243-8808-1-git-send-email-zajec5@gmail.com>
References: <1316169243-8808-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lcn.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 8810bc9..3ac2357 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -307,12 +307,30 @@ static void b43_phy_lcn_bu_tweaks(struct b43_wldev *dev)
 
 	b43_phy_write(dev, 0x7d6, 0x0902);
 
-	/* TODO: more ops */
+	b43_phy_maskset(dev, 0x429, ~0xf, 0x9);
+	b43_phy_maskset(dev, 0x429, ~(0x3f << 4), 0xe << 4);
 
 	if (dev->phy.rev == 1) {
-		/* TODO: more ops */
+		b43_phy_maskset(dev, 0x423, ~0xff, 0x46);
+		b43_phy_maskset(dev, 0x411, ~0xff, 1);
+		b43_phy_set(dev, 0x434, 0xff); /* FIXME: update to wl */
+
+		/* TODO: wl operates on PHY 0x416, brcmsmac is outdated here */
+
+		b43_phy_maskset(dev, 0x656, ~0xf, 2);
+		b43_phy_set(dev, 0x44d, 4);
+
+		b43_radio_set(dev, 0x0f7, 0x4);
+		b43_radio_mask(dev, 0x0f1, ~0x3);
+		b43_radio_maskset(dev, 0x0f2, ~0xf8, 0x90);
+		b43_radio_maskset(dev, 0x0f3, ~0x3, 0x2);
+		b43_radio_maskset(dev, 0x0f3, ~0xf0, 0xa0);
+
+		b43_radio_set(dev, 0x11f, 0x2);
 
 		b43_phy_lcn_clear_tx_power_offsets(dev);
+
+		/* TODO: something more? */
 	}
 }
 
-- 
1.7.3.4

