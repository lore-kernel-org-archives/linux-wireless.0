Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62796 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaGQRcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 13:32:54 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so8180166wib.9
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 10:32:52 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/6] b43: N-PHY: set band on every channel switch
Date: Thu, 17 Jul 2014 19:31:04 +0200
Message-Id: <1405618266-20200-4-git-send-email-zajec5@gmail.com> (sfid-20140717_193302_417676_CF51EE25)
In-Reply-To: <1405618266-20200-1-git-send-email-zajec5@gmail.com>
References: <1405618266-20200-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seems to be required by some hardware, wl does it every time.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 16 ++++++++--------
 drivers/net/wireless/b43/phy_n.h |  2 ++
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 2c55832..ef1acae 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -6058,23 +6058,23 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
 	int ch = new_channel->hw_value;
-
-	u16 old_band_5ghz;
 	u16 tmp16;
 
-	old_band_5ghz =
-		b43_phy_read(dev, B43_NPHY_BANDCTL) & B43_NPHY_BANDCTL_5GHZ;
-	if (new_channel->band == IEEE80211_BAND_5GHZ && !old_band_5ghz) {
+	if (new_channel->band == IEEE80211_BAND_5GHZ) {
 		tmp16 = b43_read16(dev, B43_MMIO_PSM_PHY_HDR);
 		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16 | 4);
-		b43_phy_set(dev, B43_PHY_B_BBCFG, 0xC000);
+		/* Put BPHY in the reset */
+		b43_phy_set(dev, B43_PHY_B_BBCFG,
+			    B43_PHY_B_BBCFG_RSTCCA | B43_PHY_B_BBCFG_RSTRX);
 		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16);
 		b43_phy_set(dev, B43_NPHY_BANDCTL, B43_NPHY_BANDCTL_5GHZ);
-	} else if (new_channel->band == IEEE80211_BAND_2GHZ && old_band_5ghz) {
+	} else if (new_channel->band == IEEE80211_BAND_2GHZ) {
 		b43_phy_mask(dev, B43_NPHY_BANDCTL, ~B43_NPHY_BANDCTL_5GHZ);
 		tmp16 = b43_read16(dev, B43_MMIO_PSM_PHY_HDR);
 		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16 | 4);
-		b43_phy_mask(dev, B43_PHY_B_BBCFG, 0x3FFF);
+		/* Take BPHY out of the reset */
+		b43_phy_mask(dev, B43_PHY_B_BBCFG,
+			     (u16)~(B43_PHY_B_BBCFG_RSTCCA | B43_PHY_B_BBCFG_RSTRX));
 		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16);
 	}
 
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 474bf75..30bec81 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -869,6 +869,8 @@
 #define B43_NPHY_REV7_RF_CTL_OVER6		B43_PHY_N(0x347)
 
 #define B43_PHY_B_BBCFG				B43_PHY_N_BMODE(0x001) /* BB config */
+#define  B43_PHY_B_BBCFG_RSTCCA			0x4000 /* Reset CCA */
+#define  B43_PHY_B_BBCFG_RSTRX			0x8000 /* Reset RX */
 #define B43_PHY_B_TEST				B43_PHY_N_BMODE(0x00A)
 
 struct b43_wldev;
-- 
1.8.4.5

