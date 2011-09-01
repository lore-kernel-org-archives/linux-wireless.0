Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59118 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab1IAUre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 16:47:34 -0400
Received: by fxh19 with SMTP id 19so1029458fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Sep 2011 13:47:33 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Henry Ptasinski <henryp@broadcom.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: implement enabling TX power control
Date: Thu,  1 Sep 2011 22:49:57 +0200
Message-Id: <1314910197-10995-1-git-send-email-zajec5@gmail.com> (sfid-20110901_224742_347815_25404EF4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   84 +++++++++++++++++++++++++++++++++++---
 drivers/net/wireless/b43/phy_n.h |    2 +
 2 files changed, 80 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 2eadadf..6e91680 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -248,15 +248,25 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
 	u8 i;
-	u16 tmp;
+	u16 bmask, val, tmp;
+	enum ieee80211_band band = b43_current_band(dev->wl);
 
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, 1);
 
 	nphy->txpwrctrl = enable;
 	if (!enable) {
-		if (dev->phy.rev >= 3)
-			; /* TODO */
+		if (dev->phy.rev >= 3 &&
+		    (b43_phy_read(dev, B43_NPHY_TXPCTL_CMD) &
+		     (B43_NPHY_TXPCTL_CMD_COEFF |
+		      B43_NPHY_TXPCTL_CMD_HWPCTLEN |
+		      B43_NPHY_TXPCTL_CMD_PCTLEN))) {
+			/* We disable enabled TX pwr ctl, save it's state */
+			nphy->tx_pwr_idx[0] = b43_phy_read(dev,
+						B43_NPHY_C1_TXPCTL_STAT) & 0x7f;
+			nphy->tx_pwr_idx[1] = b43_phy_read(dev,
+						B43_NPHY_C2_TXPCTL_STAT) & 0x7f;
+		}
 
 		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x6840);
 		for (i = 0; i < 84; i++)
@@ -285,10 +295,68 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 			b43_phy_maskset(dev, B43_NPHY_BPHY_CTL3,
 				~B43_NPHY_BPHY_CTL3_SCALE, 0x5A);
 
-		if (dev->phy.rev < 2 && 0)
-			; /* TODO */
+		if (dev->phy.rev < 2 && dev->phy.is_40mhz)
+			b43_hf_write(dev, b43_hf_read(dev) | B43_HF_TSSIRPSMW);
 	} else {
-		b43err(dev->wl, "enabling tx pwr ctrl not implemented yet\n");
+		b43_ntab_write_bulk(dev, B43_NTAB16(26, 64), 84,
+				    nphy->adj_pwr_tbl);
+		b43_ntab_write_bulk(dev, B43_NTAB16(27, 64), 84,
+				    nphy->adj_pwr_tbl);
+
+		bmask = B43_NPHY_TXPCTL_CMD_COEFF |
+			B43_NPHY_TXPCTL_CMD_HWPCTLEN;
+		/* wl does useless check for "enable" param here */
+		val = B43_NPHY_TXPCTL_CMD_COEFF | B43_NPHY_TXPCTL_CMD_HWPCTLEN;
+		if (dev->phy.rev >= 3) {
+			bmask |= B43_NPHY_TXPCTL_CMD_PCTLEN;
+			if (val)
+				val |= B43_NPHY_TXPCTL_CMD_PCTLEN;
+		}
+		b43_phy_maskset(dev, B43_NPHY_TXPCTL_CMD, ~(bmask), val);
+
+		if (band == IEEE80211_BAND_5GHZ) {
+			b43_phy_maskset(dev, B43_NPHY_TXPCTL_CMD,
+					~B43_NPHY_TXPCTL_CMD_INIT, 0x64);
+			if (dev->phy.rev > 1)
+				b43_phy_maskset(dev, B43_NPHY_TXPCTL_INIT,
+						~B43_NPHY_TXPCTL_INIT_PIDXI1,
+						0x64);
+		}
+
+		if (dev->phy.rev >= 3) {
+			if (nphy->tx_pwr_idx[0] != 128 &&
+			    nphy->tx_pwr_idx[1] != 128) {
+				/* Recover TX pwr ctl state */
+				b43_phy_maskset(dev, B43_NPHY_TXPCTL_CMD,
+						~B43_NPHY_TXPCTL_CMD_INIT,
+						nphy->tx_pwr_idx[0]);
+				if (dev->phy.rev > 1)
+					b43_phy_maskset(dev,
+						B43_NPHY_TXPCTL_INIT,
+						~0xff, nphy->tx_pwr_idx[1]);
+			}
+		}
+
+		if (dev->phy.rev >= 3) {
+			b43_phy_mask(dev, B43_NPHY_AFECTL_OVER1, ~0x100);
+			b43_phy_mask(dev, B43_NPHY_AFECTL_OVER, ~0x100);
+		} else {
+			b43_phy_mask(dev, B43_NPHY_AFECTL_OVER, ~0x4000);
+		}
+
+		if (dev->phy.rev == 2)
+			b43_phy_maskset(dev, B43_NPHY_BPHY_CTL3, ~0xFF, 0x3b);
+		else if (dev->phy.rev < 2)
+			b43_phy_maskset(dev, B43_NPHY_BPHY_CTL3, ~0xFF, 0x40);
+
+		if (dev->phy.rev < 2 && dev->phy.is_40mhz)
+			b43_hf_write(dev, b43_hf_read(dev) & ~B43_HF_TSSIRPSMW);
+
+		if ((nphy->ipa2g_on && band == IEEE80211_BAND_2GHZ) ||
+		    (nphy->ipa5g_on && band == IEEE80211_BAND_5GHZ)) {
+			b43_phy_mask(dev, B43_NPHY_PAPD_EN0, ~0x4);
+			b43_phy_mask(dev, B43_NPHY_PAPD_EN1, ~0x4);
+		}
 	}
 
 	if (nphy->hang_avoid)
@@ -3918,6 +3986,10 @@ static void b43_nphy_op_prepare_structs(struct b43_wldev *dev)
 	nphy->txrx_chain = 2; /* sth different than 0 and 1 for now */
 	nphy->phyrxchain = 3; /* to avoid b43_nphy_set_rx_core_state like wl */
 	nphy->perical = 2; /* avoid additional rssi cal on init (like wl) */
+	/* 128 can mean disabled-by-default state of TX pwr ctl. Max value is
+	 * 0x7f == 127 and we check for 128 when restoring TX pwr ctl. */
+	nphy->tx_pwr_idx[0] = 128;
+	nphy->tx_pwr_idx[1] = 128;
 }
 
 static void b43_nphy_op_free(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index e789a89..cd84989 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -783,6 +783,8 @@ struct b43_phy_n {
 	u16 mphase_txcal_bestcoeffs[11];
 
 	bool txpwrctrl;
+	u8 tx_pwr_idx[2];
+	u16 adj_pwr_tbl[84];
 	u16 txcal_bbmult;
 	u16 txiqlocal_bestc[11];
 	bool txiqlocal_coeffsvalid;
-- 
1.7.3.4

