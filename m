Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34237 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab1HKVYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 17:24:21 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so1948045fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 14:24:21 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: make forcing clock common (HT-PHY also uses that)
Date: Fri, 12 Aug 2011 00:03:26 +0200
Message-Id: <1313100206-25922-2-git-send-email-zajec5@gmail.com> (sfid-20110811_232424_438026_DC17AA9F)
In-Reply-To: <1313100206-25922-1-git-send-email-zajec5@gmail.com>
References: <1313100206-25922-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_common.c |   32 ++++++++++++++++++++++++++
 drivers/net/wireless/b43/phy_common.h |    2 +
 drivers/net/wireless/b43/phy_n.c      |   40 +++-----------------------------
 3 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 07f009f..3ea44bb 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -448,6 +448,38 @@ bool b43_channel_type_is_40mhz(enum nl80211_channel_type channel_type)
 		channel_type == NL80211_CHAN_HT40PLUS);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BmacPhyClkFgc */
+void b43_phy_force_clock(struct b43_wldev *dev, bool force)
+{
+	u32 tmp;
+
+	WARN_ON(dev->phy.type != B43_PHYTYPE_N &&
+		dev->phy.type != B43_PHYTYPE_HT);
+
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
+		if (force)
+			tmp |= BCMA_IOCTL_FGC;
+		else
+			tmp &= ~BCMA_IOCTL_FGC;
+		bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, tmp);
+		break;
+#endif
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
+		if (force)
+			tmp |= SSB_TMSLOW_FGC;
+		else
+			tmp &= ~SSB_TMSLOW_FGC;
+		ssb_write32(dev->dev->sdev, SSB_TMSLOW, tmp);
+		break;
+#endif
+	}
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/Cordic */
 struct b43_c32 b43_cordic(int theta)
 {
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index aa77ba6..9233b13 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -444,6 +444,8 @@ void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on);
 
 bool b43_channel_type_is_40mhz(enum nl80211_channel_type channel_type);
 
+void b43_phy_force_clock(struct b43_wldev *dev, bool force);
+
 struct b43_c32 b43_cordic(int theta);
 
 #endif /* LINUX_B43_PHY_COMMON_H_ */
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 3b46360..2eadadf 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -600,49 +600,17 @@ static void b43_nphy_tx_lp_fbw(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BmacPhyClkFgc */
-static void b43_nphy_bmac_clock_fgc(struct b43_wldev *dev, bool force)
-{
-	u32 tmp;
-
-	if (dev->phy.type != B43_PHYTYPE_N)
-		return;
-
-	switch (dev->dev->bus_type) {
-#ifdef CONFIG_B43_BCMA
-	case B43_BUS_BCMA:
-		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
-		if (force)
-			tmp |= BCMA_IOCTL_FGC;
-		else
-			tmp &= ~BCMA_IOCTL_FGC;
-		bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, tmp);
-		break;
-#endif
-#ifdef CONFIG_B43_SSB
-	case B43_BUS_SSB:
-		tmp = ssb_read32(dev->dev->sdev, SSB_TMSLOW);
-		if (force)
-			tmp |= SSB_TMSLOW_FGC;
-		else
-			tmp &= ~SSB_TMSLOW_FGC;
-		ssb_write32(dev->dev->sdev, SSB_TMSLOW, tmp);
-		break;
-#endif
-	}
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CCA */
 static void b43_nphy_reset_cca(struct b43_wldev *dev)
 {
 	u16 bbcfg;
 
-	b43_nphy_bmac_clock_fgc(dev, 1);
+	b43_phy_force_clock(dev, 1);
 	bbcfg = b43_phy_read(dev, B43_NPHY_BBCFG);
 	b43_phy_write(dev, B43_NPHY_BBCFG, bbcfg | B43_NPHY_BBCFG_RSTCCA);
 	udelay(1);
 	b43_phy_write(dev, B43_NPHY_BBCFG, bbcfg & ~B43_NPHY_BBCFG_RSTCCA);
-	b43_nphy_bmac_clock_fgc(dev, 0);
+	b43_phy_force_clock(dev, 0);
 	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
 }
 
@@ -3715,11 +3683,11 @@ int b43_phy_initn(struct b43_wldev *dev)
 	b43_nphy_workarounds(dev);
 
 	/* Reset CCA, in init code it differs a little from standard way */
-	b43_nphy_bmac_clock_fgc(dev, 1);
+	b43_phy_force_clock(dev, 1);
 	tmp = b43_phy_read(dev, B43_NPHY_BBCFG);
 	b43_phy_write(dev, B43_NPHY_BBCFG, tmp | B43_NPHY_BBCFG_RSTCCA);
 	b43_phy_write(dev, B43_NPHY_BBCFG, tmp & ~B43_NPHY_BBCFG_RSTCCA);
-	b43_nphy_bmac_clock_fgc(dev, 0);
+	b43_phy_force_clock(dev, 0);
 
 	b43_mac_phy_clock_set(dev, true);
 
-- 
1.7.3.4

