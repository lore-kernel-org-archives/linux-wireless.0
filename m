Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34682 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab3CDPjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:39:19 -0500
Received: by mail-ee0-f53.google.com with SMTP id e53so4077085eek.40
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 07:39:18 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] b43: HT-PHY: make it BCMA-only
Date: Mon,  4 Mar 2013 16:39:10 +0100
Message-Id: <1362411550-3547-1-git-send-email-zajec5@gmail.com> (sfid-20130304_163921_987629_BD700B19)
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
V2: just rebase
---
 drivers/net/wireless/b43/Kconfig  |    2 +-
 drivers/net/wireless/b43/phy_ht.c |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 287c6b6..d406cec 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -131,7 +131,7 @@ config B43_PHY_LP
 
 config B43_PHY_HT
 	bool "Support for HT-PHY (high throughput) devices"
-	depends on B43
+	depends on B43 && B43_BCMA
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

