Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:39343 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab0C1Wxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 18:53:36 -0400
Received: by mail-fx0-f223.google.com with SMTP id 23so424568fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Mar 2010 15:53:35 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/5] b43: N-PHY: fix value written on 2055 radio setup
Date: Mon, 29 Mar 2010 00:53:16 +0200
Message-Id: <1269816796-26820-6-git-send-email-zajec5@gmail.com>
In-Reply-To: <1269816796-26820-2-git-send-email-zajec5@gmail.com>
References: <1269816796-26820-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 34f80c4..1ae232c 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -165,10 +165,10 @@ static void b43_radio_2055_setup(struct b43_wldev *dev,
 
 	b43_chantab_radio_upload(dev, e);
 	udelay(50);
-	b43_radio_write(dev, B2055_VCO_CAL10, 5);
-	b43_radio_write(dev, B2055_VCO_CAL10, 45);
+	b43_radio_write(dev, B2055_VCO_CAL10, 0x05);
+	b43_radio_write(dev, B2055_VCO_CAL10, 0x45);
 	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
-	b43_radio_write(dev, B2055_VCO_CAL10, 65);
+	b43_radio_write(dev, B2055_VCO_CAL10, 0x65);
 	udelay(300);
 }
 
-- 
1.6.4.2

