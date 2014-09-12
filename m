Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46917 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaILQhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 12:37:36 -0400
Received: by mail-wi0-f170.google.com with SMTP id em10so1077005wid.5
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2014 09:37:34 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: Implement PHY PLL reset
Date: Fri, 12 Sep 2014 18:37:26 +0200
Message-Id: <1410539846-12806-1-git-send-email-zajec5@gmail.com> (sfid-20140912_183746_335894_60C934CE)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should reset PLL after changing MAC frequency.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c   | 30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/main.h   |  2 ++
 drivers/net/wireless/b43/phy_ht.c |  2 +-
 drivers/net/wireless/b43/phy_n.c  |  2 +-
 4 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 165dbc3..3adc13f 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1204,6 +1204,36 @@ void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags)
 	}
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacCorePllReset */
+void b43_wireless_core_phy_pll_reset(struct b43_wldev *dev)
+{
+	struct bcma_drv_cc *bcma_cc __maybe_unused;
+	struct ssb_chipcommon *ssb_cc __maybe_unused;
+
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		bcma_cc = &dev->dev->bdev->bus->drv_cc;
+
+		bcma_cc_write32(bcma_cc, BCMA_CC_CHIPCTL_ADDR, 0);
+		bcma_cc_mask32(bcma_cc, BCMA_CC_CHIPCTL_DATA, ~0x4);
+		bcma_cc_set32(bcma_cc, BCMA_CC_CHIPCTL_DATA, 0x4);
+		bcma_cc_mask32(bcma_cc, BCMA_CC_CHIPCTL_DATA, ~0x4);
+		break;
+#endif
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		ssb_cc = &dev->dev->sdev->bus->chipco;
+
+		chipco_write32(ssb_cc, SSB_CHIPCO_CHIPCTL_ADDR, 0);
+		chipco_mask32(ssb_cc, SSB_CHIPCO_CHIPCTL_DATA, ~0x4);
+		chipco_set32(ssb_cc, SSB_CHIPCO_CHIPCTL_DATA, 0x4);
+		chipco_mask32(ssb_cc, SSB_CHIPCO_CHIPCTL_DATA, ~0x4);
+		break;
+#endif
+	}
+}
+
 #ifdef CONFIG_B43_BCMA
 static void b43_bcma_phy_reset(struct b43_wldev *dev)
 {
diff --git a/drivers/net/wireless/b43/main.h b/drivers/net/wireless/b43/main.h
index 9f22e4b..c46430c 100644
--- a/drivers/net/wireless/b43/main.h
+++ b/drivers/net/wireless/b43/main.h
@@ -96,6 +96,8 @@ void b43_controller_restart(struct b43_wldev *dev, const char *reason);
 #define B43_PS_ASLEEP	(1 << 3)	/* Force device asleep */
 void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags);
 
+void b43_wireless_core_phy_pll_reset(struct b43_wldev *dev);
+
 void b43_mac_suspend(struct b43_wldev *dev);
 void b43_mac_enable(struct b43_wldev *dev);
 void b43_mac_phy_clock_set(struct b43_wldev *dev, bool on);
diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 6a0140a..bd68945 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -762,7 +762,7 @@ static void b43_phy_ht_spur_avoid(struct b43_wldev *dev,
 
 	b43_mac_switch_freq(dev, spuravoid);
 
-	/* TODO: reset PLL */
+	b43_wireless_core_phy_pll_reset(dev);
 
 	if (spuravoid)
 		b43_phy_set(dev, B43_PHY_HT_BBCFG, B43_PHY_HT_BBCFG_RSTRX);
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index cf625d8..9f0bcf3 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -6369,7 +6369,7 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 		b43_mac_switch_freq(dev, spuravoid);
 
 		if (dev->phy.rev == 3 || dev->phy.rev == 4)
-			; /* TODO: reset PLL */
+			b43_wireless_core_phy_pll_reset(dev);
 
 		if (spuravoid)
 			b43_phy_set(dev, B43_NPHY_BBCFG, B43_NPHY_BBCFG_RSTRX);
-- 
1.8.4.5

