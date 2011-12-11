Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54431 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1LKBOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 20:14:52 -0500
Received: by mail-ey0-f174.google.com with SMTP id k14so2316533eaa.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 17:14:52 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/7] b43: N-PHY: determine various PHY params
Date: Sun, 11 Dec 2011 02:55:33 +0100
Message-Id: <1323568535-2816-6-git-send-email-zajec5@gmail.com> (sfid-20111211_021455_730628_B528A3D8)
In-Reply-To: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
References: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   35 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/phy_n.h |    8 ++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index f540e48..4bd94df 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4062,10 +4062,13 @@ static void b43_nphy_op_prepare_structs(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = phy->n;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 
 	memset(nphy, 0, sizeof(*nphy));
 
 	nphy->hang_avoid = (phy->rev == 3 || phy->rev == 4);
+	nphy->spur_avoid = (phy->rev >= 3) ?
+				B43_SPUR_AVOID_AUTO : B43_SPUR_AVOID_DISABLE;
 	nphy->gain_boost = true; /* this way we follow wl, assume it is true */
 	nphy->txrx_chain = 2; /* sth different than 0 and 1 for now */
 	nphy->phyrxchain = 3; /* to avoid b43_nphy_set_rx_core_state like wl */
@@ -4074,6 +4077,38 @@ static void b43_nphy_op_prepare_structs(struct b43_wldev *dev)
 	 * 0x7f == 127 and we check for 128 when restoring TX pwr ctl. */
 	nphy->tx_pwr_idx[0] = 128;
 	nphy->tx_pwr_idx[1] = 128;
+
+	/* Hardware TX power control and 5GHz power gain */
+	nphy->txpwrctrl = false;
+	nphy->pwg_gain_5ghz = false;
+	if (dev->phy.rev >= 3 ||
+	    (dev->dev->board_vendor == PCI_VENDOR_ID_APPLE &&
+	     (dev->dev->core_rev == 11 || dev->dev->core_rev == 12))) {
+		nphy->txpwrctrl = true;
+		nphy->pwg_gain_5ghz = true;
+	} else if (sprom->revision >= 4) {
+		if (dev->phy.rev >= 2 &&
+		    (sprom->boardflags2_lo & B43_BFL2_TXPWRCTRL_EN)) {
+			nphy->txpwrctrl = true;
+#ifdef CONFIG_B43_SSB
+			if (dev->dev->bus_type == B43_BUS_SSB &&
+			    dev->dev->sdev->bus->bustype == SSB_BUSTYPE_PCI) {
+				struct pci_dev *pdev =
+					dev->dev->sdev->bus->host_pci;
+				if (pdev->device == 0x4328 ||
+				    pdev->device == 0x432a)
+					nphy->pwg_gain_5ghz = true;
+			}
+#endif
+		} else if (sprom->boardflags2_lo & B43_BFL2_5G_PWRGAIN) {
+			nphy->pwg_gain_5ghz = true;
+		}
+	}
+
+	if (dev->phy.rev >= 3) {
+		nphy->ipa2g_on = sprom->fem.ghz2.extpa_gain == 2;
+		nphy->ipa5g_on = sprom->fem.ghz5.extpa_gain == 2;
+	}
 }
 
 static void b43_nphy_op_free(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index fbf5202..56ef97b 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -716,6 +716,12 @@
 
 struct b43_wldev;
 
+enum b43_nphy_spur_avoid {
+	B43_SPUR_AVOID_DISABLE,
+	B43_SPUR_AVOID_AUTO,
+	B43_SPUR_AVOID_FORCE,
+};
+
 struct b43_chanspec {
 	u16 center_freq;
 	enum nl80211_channel_type channel_type;
@@ -785,6 +791,7 @@ struct b43_phy_n {
 	u16 mphase_txcal_bestcoeffs[11];
 
 	bool txpwrctrl;
+	bool pwg_gain_5ghz;
 	u8 tx_pwr_idx[2];
 	u16 adj_pwr_tbl[84];
 	u16 txcal_bbmult;
@@ -803,6 +810,7 @@ struct b43_phy_n {
 	u16 classifier_state;
 	u16 clip_state[2];
 
+	enum b43_nphy_spur_avoid spur_avoid;
 	bool aband_spurwar_en;
 	bool gband_spurwar_en;
 
-- 
1.7.3.4

