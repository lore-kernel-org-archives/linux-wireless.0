Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f211.google.com ([209.85.220.211]:37681 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab0BDMLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 07:11:49 -0500
Received: by fxm3 with SMTP id 3so2496822fxm.39
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 04:11:48 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: handle allocation fail in samples generation
Date: Thu,  4 Feb 2010 13:11:54 +0100
Message-Id: <1265285514-28798-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 074b34c..795bb1e 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1069,6 +1069,10 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 	}
 
 	samples = kzalloc(len * sizeof(struct b43_c32), GFP_KERNEL);
+	if (!samples) {
+		b43err(dev->wl, "allocation for samples generation failed\n");
+		return 0;
+	}
 	rot = (((freq * 36) / bw) << 16) / 100;
 	angle = 0;
 
-- 
1.6.4.2

