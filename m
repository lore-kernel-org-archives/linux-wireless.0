Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:50990 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaGVTbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:31:15 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so115514wgg.0
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:31:13 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: fix rev7+ typos at random places
Date: Tue, 22 Jul 2014 21:31:05 +0200
Message-Id: <1406057465-24264-1-git-send-email-zajec5@gmail.com> (sfid-20140722_213125_818798_C2C5E2EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c       | 19 ++++++++++---------
 drivers/net/wireless/b43/tables_nphy.c |  4 ++--
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 11d7543..44bb58b 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -225,13 +225,13 @@ static void b43_nphy_rf_ctl_override_one_to_many(struct b43_wldev *dev,
 		b43_nphy_rf_ctl_override_rev7(dev, 0x2, value, core, off, 1);
 		b43_nphy_rf_ctl_override_rev7(dev, 0x1, value, core, off, 1);
 		b43_nphy_rf_ctl_override_rev7(dev, 0x2, value, core, off, 2);
-		b43_nphy_rf_ctl_override_rev7(dev, 0x0800, value, core, off, 1);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x0800, 0, core, off, 1);
 		break;
 	case N_RF_CTL_OVER_CMD_TX_PU:
 		b43_nphy_rf_ctl_override_rev7(dev, 0x4, value, core, off, 0);
 		b43_nphy_rf_ctl_override_rev7(dev, 0x2, value, core, off, 1);
 		b43_nphy_rf_ctl_override_rev7(dev, 0x1, value, core, off, 2);
-		b43_nphy_rf_ctl_override_rev7(dev, 0x0800, value, core, off, 1);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x0800, 1, core, off, 1);
 		break;
 	case N_RF_CTL_OVER_CMD_RX_GAIN:
 		tmp = value & 0xFF;
@@ -343,6 +343,7 @@ static void b43_nphy_rf_ctl_intc_override_rev7(struct b43_wldev *dev,
 		switch (intc_override) {
 		case N_INTC_OVERRIDE_OFF:
 			b43_phy_write(dev, reg, 0);
+			b43_phy_mask(dev, 0x2ff, ~0x2000);
 			b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
 			break;
 		case N_INTC_OVERRIDE_TRSW:
@@ -1596,7 +1597,7 @@ static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 		bool lpf_bw3, lpf_bw4;
 
 		lpf_bw3 = b43_phy_read(dev, B43_NPHY_REV7_RF_CTL_OVER3) & 0x80;
-		lpf_bw4 = b43_phy_read(dev, B43_NPHY_REV7_RF_CTL_OVER3) & 0x80;
+		lpf_bw4 = b43_phy_read(dev, B43_NPHY_REV7_RF_CTL_OVER4) & 0x80;
 
 		if (lpf_bw3 || lpf_bw4) {
 			/* TODO */
@@ -2117,7 +2118,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 						     N_RF_CTL_OVER_CMD_RX_PU,
 						     1, 0, false);
 		b43_nphy_rf_ctl_override_rev7(dev, 0x80, 1, 0, false, 0);
-		b43_nphy_rf_ctl_override_rev7(dev, 0x80, 1, 0, false, 0);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x40, 1, 0, false, 0);
 		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
 			b43_nphy_rf_ctl_override_rev7(dev, 0x20, 0, 0, false,
 						      0);
@@ -3543,7 +3544,7 @@ static void b43_nphy_stop_playback(struct b43_wldev *dev)
 		nphy->bb_mult_save = 0;
 	}
 
-	if (phy->rev >= 7) {
+	if (phy->rev >= 7 && nphy->lpf_bw_overrode_for_sample_play) {
 		if (phy->rev >= 19)
 			b43_nphy_rf_ctl_override_rev19(dev, 0x80, 0, 0, true,
 						       1);
@@ -3962,9 +3963,9 @@ static void b43_nphy_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
 		b43_nphy_ipa_internal_tssi_setup(dev);
 
 	if (phy->rev >= 19)
-		b43_nphy_rf_ctl_override_rev19(dev, 0x2000, 0, 3, false, 0);
+		b43_nphy_rf_ctl_override_rev19(dev, 0x1000, 0, 3, false, 0);
 	else if (phy->rev >= 7)
-		b43_nphy_rf_ctl_override_rev7(dev, 0x2000, 0, 3, false, 0);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x1000, 0, 3, false, 0);
 	else if (phy->rev >= 3)
 		b43_nphy_rf_ctl_override(dev, 0x2000, 0, 3, false);
 
@@ -3977,9 +3978,9 @@ static void b43_nphy_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
 	b43_nphy_rssi_select(dev, 0, N_RSSI_W1);
 
 	if (phy->rev >= 19)
-		b43_nphy_rf_ctl_override_rev19(dev, 0x2000, 0, 3, true, 0);
+		b43_nphy_rf_ctl_override_rev19(dev, 0x1000, 0, 3, true, 0);
 	else if (phy->rev >= 7)
-		b43_nphy_rf_ctl_override_rev7(dev, 0x2000, 0, 3, true, 0);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x1000, 0, 3, true, 0);
 	else if (phy->rev >= 3)
 		b43_nphy_rf_ctl_override(dev, 0x2000, 0, 3, true);
 
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index ab27c2d..4b58850 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -3109,11 +3109,11 @@ static const struct nphy_rf_control_override_rev7
 	{ 0x0010, 0x07A, 0x07D, 0x0010, 4 },
 	{ 0x0020, 0x07A, 0x07D, 0x0020, 5 },
 	{ 0x0040, 0x07A, 0x07D, 0x0040, 6 },
-	{ 0x0080, 0x0F8, 0x0FA, 0x0080, 7 },
+	{ 0x0080, 0x07A, 0x07D, 0x0080, 7 },
 	{ 0x0400, 0x0F8, 0x0FA, 0x0070, 4 },
 	{ 0x0800, 0x07B, 0x07E, 0xFFFF, 0 },
 	{ 0x1000, 0x07C, 0x07F, 0xFFFF, 0 },
-	{ 0x6000, 0x348, 0x349, 0xFFFF, 0 },
+	{ 0x6000, 0x348, 0x349, 0x00FF, 0 },
 	{ 0x2000, 0x348, 0x349, 0x000F, 0 },
 };
 
-- 
1.8.4.5

