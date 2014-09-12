Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51666 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaILIY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 04:24:56 -0400
Received: by mail-wg0-f44.google.com with SMTP id y10so344834wgg.27
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2014 01:24:54 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: HT-PHY: Implement band switching
Date: Fri, 12 Sep 2014 10:24:10 +0200
Message-Id: <1410510251-5645-1-git-send-email-zajec5@gmail.com> (sfid-20140912_102503_163974_ED8BCFC9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It works pretty much the same way as in N-PHY.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h    |  5 +++++
 drivers/net/wireless/b43/phy_ht.c | 38 ++++++++++++++++++++++++++++++++------
 drivers/net/wireless/b43/phy_ht.h |  3 +++
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 95a9433..a980595 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -476,6 +476,11 @@ enum {
 #define B43_MACCMD_CCA			0x00000008	/* Clear channel assessment */
 #define B43_MACCMD_BGNOISE		0x00000010	/* Background noise */
 
+/* B43_MMIO_PSM_PHY_HDR bits */
+#define B43_PSM_HDR_MAC_PHY_RESET	0x00000001
+#define B43_PSM_HDR_MAC_PHY_CLOCK_EN	0x00000002
+#define B43_PSM_HDR_MAC_PHY_FORCE_CLK	0x00000004
+
 /* See BCMA_CLKCTLST_EXTRESREQ and BCMA_CLKCTLST_EXTRESST */
 #define B43_BCMA_CLKCTLST_80211_PLL_REQ	0x00000100
 #define B43_BCMA_CLKCTLST_PHY_PLL_REQ	0x00000200
diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index a379602..6a0140a 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -321,6 +321,26 @@ static void b43_phy_ht_bphy_init(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_PHY_N_BMODE(0x38), 0x668);
 }
 
+static void b43_phy_ht_bphy_reset(struct b43_wldev *dev, bool reset)
+{
+	u16 tmp;
+
+	tmp = b43_read16(dev, B43_MMIO_PSM_PHY_HDR);
+	b43_write16(dev, B43_MMIO_PSM_PHY_HDR,
+		    tmp | B43_PSM_HDR_MAC_PHY_FORCE_CLK);
+
+	/* Put BPHY in or take it out of the reset */
+	if (reset)
+		b43_phy_set(dev, B43_PHY_B_BBCFG,
+			    B43_PHY_B_BBCFG_RSTCCA | B43_PHY_B_BBCFG_RSTRX);
+	else
+		b43_phy_mask(dev, B43_PHY_B_BBCFG,
+			     (u16)~(B43_PHY_B_BBCFG_RSTCCA |
+				    B43_PHY_B_BBCFG_RSTRX));
+
+	b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp);
+}
+
 /**************************************************
  * Samples
  **************************************************/
@@ -757,13 +777,19 @@ static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
 				const struct b43_phy_ht_channeltab_e_phy *e,
 				struct ieee80211_channel *new_channel)
 {
-	bool old_band_5ghz;
+	if (new_channel->band == IEEE80211_BAND_5GHZ) {
+		/* Switch to 2 GHz for a moment to access B-PHY regs */
+		b43_phy_mask(dev, B43_PHY_HT_BANDCTL, ~B43_PHY_HT_BANDCTL_5GHZ);
+
+		b43_phy_ht_bphy_reset(dev, true);
+
+		/* Switch to 5 GHz */
+		b43_phy_set(dev, B43_PHY_HT_BANDCTL, B43_PHY_HT_BANDCTL_5GHZ);
+	} else {
+		/* Switch to 2 GHz */
+		b43_phy_mask(dev, B43_PHY_HT_BANDCTL, ~B43_PHY_HT_BANDCTL_5GHZ);
 
-	old_band_5ghz = b43_phy_read(dev, B43_PHY_HT_BANDCTL) & 0; /* FIXME */
-	if (new_channel->band == IEEE80211_BAND_5GHZ && !old_band_5ghz) {
-		/* TODO */
-	} else if (new_channel->band == IEEE80211_BAND_2GHZ && old_band_5ghz) {
-		/* TODO */
+		b43_phy_ht_bphy_reset(dev, false);
 	}
 
 	b43_phy_write(dev, B43_PHY_HT_BW1, e->bw1);
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index 67b208e..c086f56 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -106,6 +106,9 @@
 #define  B43_PHY_HT_TXPCTL_TARG_PWR2_C3_SHIFT	0
 #define B43_PHY_HT_TX_PCTL_STATUS_C3		B43_PHY_EXTG(0x169)
 
+#define B43_PHY_B_BBCFG				B43_PHY_N_BMODE(0x001)
+#define  B43_PHY_B_BBCFG_RSTCCA			0x4000 /* Reset CCA */
+#define  B43_PHY_B_BBCFG_RSTRX			0x8000 /* Reset RX */
 #define B43_PHY_HT_TEST				B43_PHY_N_BMODE(0x00A)
 
 
-- 
1.8.4.5

