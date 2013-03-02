Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59883 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3CBBOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 20:14:34 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so2731170eek.15
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2013 17:14:33 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: HT-PHY: make it BCMA-only
Date: Sat,  2 Mar 2013 02:14:25 +0100
Message-Id: <1362186865-20539-1-git-send-email-zajec5@gmail.com> (sfid-20130302_021438_328036_9F7760C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HT-PHY was found only on BCM4331 which is a BCMA-based chipset. This is
reallly unlikely we will ever see HT-PHY on SSB thus make the whole code
BCMA specific. This will allow us to call various BCMA-specific
functions directly (without extra checks).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Kconfig  |    2 +-
 drivers/net/wireless/b43/phy_ht.c |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 7a28d21..09d315d 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -131,7 +131,7 @@ config B43_PHY_LP
 
 config B43_PHY_HT
 	bool "Support for HT-PHY (high throughput) devices (EXPERIMENTAL)"
-	depends on B43 && EXPERIMENTAL
+	depends on B43 && B43_BCMA && EXPERIMENTAL
 	---help---
 	  Support for the HT-PHY.
 
diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 7416c5e..3719a88 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -346,6 +346,11 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 	u16 tmp;
 	u16 clip_state[3];
 
+	if (dev->dev->bus_type != B43_BUS_BCMA) {
+		b43err(dev->wl, "HT-PHY is supported only on BCMA bus!\n");
+		return -EOPNOTSUPP;
+	}
+
 	b43_phy_ht_tables_init(dev);
 
 	b43_phy_mask(dev, 0x0be, ~0x2);
-- 
1.7.10.4

