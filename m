Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:50590 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbaDTLGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 07:06:16 -0400
Received: by mail-ee0-f43.google.com with SMTP id e53so2925033eek.2
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 04:06:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 6/9] b43: N-PHY: prepare for rev 7+ RSSI calibration
Date: Sun, 20 Apr 2014 13:05:48 +0200
Message-Id: <1397991951-13478-7-git-send-email-zajec5@gmail.com> (sfid-20140420_130656_864398_614B234B)
In-Reply-To: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
References: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mostly just add place for future code

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Empty code of conditional blocks makes checkpatch suspect some mistake,
but this is intended to be that way. It gives a good hint on further
implementation.
---
 drivers/net/wireless/b43/phy_n.c | 72 ++++++++++++++++++++++++++++++----------
 1 file changed, 54 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 0d4067e..291b38c 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1660,8 +1660,8 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 	struct b43_phy_n *nphy = dev->phy.n;
 
 	u16 saved_regs_phy_rfctl[2];
-	u16 saved_regs_phy[13];
-	u16 regs_to_store[] = {
+	u16 saved_regs_phy[22];
+	u16 regs_to_store_rev3[] = {
 		B43_NPHY_AFECTL_OVER1, B43_NPHY_AFECTL_OVER,
 		B43_NPHY_AFECTL_C1, B43_NPHY_AFECTL_C2,
 		B43_NPHY_TXF_40CO_B1S1, B43_NPHY_RFCTL_OVER,
@@ -1670,6 +1670,20 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 		B43_NPHY_RFCTL_LUT_TRSW_UP1, B43_NPHY_RFCTL_LUT_TRSW_UP2,
 		B43_NPHY_RFCTL_RSSIO1, B43_NPHY_RFCTL_RSSIO2
 	};
+	u16 regs_to_store_rev7[] = {
+		B43_NPHY_AFECTL_OVER1, B43_NPHY_AFECTL_OVER,
+		B43_NPHY_AFECTL_C1, B43_NPHY_AFECTL_C2,
+		B43_NPHY_TXF_40CO_B1S1, B43_NPHY_RFCTL_OVER,
+		0x342, 0x343, 0x346, 0x347,
+		0x2ff,
+		B43_NPHY_TXF_40CO_B1S0, B43_NPHY_TXF_40CO_B32S1,
+		B43_NPHY_RFCTL_CMD,
+		B43_NPHY_RFCTL_LUT_TRSW_UP1, B43_NPHY_RFCTL_LUT_TRSW_UP2,
+		0x340, 0x341, 0x344, 0x345,
+		B43_NPHY_RFCTL_RSSIO1, B43_NPHY_RFCTL_RSSIO2
+	};
+	u16 *regs_to_store;
+	int regs_amount;
 
 	u16 class;
 
@@ -1689,6 +1703,15 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 	u8 rx_core_state;
 	int core, i, j, vcm;
 
+	if (dev->phy.rev >= 7) {
+		regs_to_store = regs_to_store_rev7;
+		regs_amount = ARRAY_SIZE(regs_to_store_rev7);
+	} else {
+		regs_to_store = regs_to_store_rev3;
+		regs_amount = ARRAY_SIZE(regs_to_store_rev3);
+	}
+	BUG_ON(regs_amount > ARRAY_SIZE(saved_regs_phy));
+
 	class = b43_nphy_classifier(dev, 0, 0);
 	b43_nphy_classifier(dev, 7, 4);
 	b43_nphy_read_clip_detection(dev, clip_state);
@@ -1696,22 +1719,29 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 
 	saved_regs_phy_rfctl[0] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC1);
 	saved_regs_phy_rfctl[1] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC2);
-	for (i = 0; i < ARRAY_SIZE(regs_to_store); i++)
+	for (i = 0; i < regs_amount; i++)
 		saved_regs_phy[i] = b43_phy_read(dev, regs_to_store[i]);
 
 	b43_nphy_rf_ctl_intc_override(dev, N_INTC_OVERRIDE_OFF, 0, 7);
 	b43_nphy_rf_ctl_intc_override(dev, N_INTC_OVERRIDE_TRSW, 1, 7);
-	b43_nphy_rf_ctl_override(dev, 0x1, 0, 0, false);
-	b43_nphy_rf_ctl_override(dev, 0x2, 1, 0, false);
-	b43_nphy_rf_ctl_override(dev, 0x80, 1, 0, false);
-	b43_nphy_rf_ctl_override(dev, 0x40, 1, 0, false);
-
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
-		b43_nphy_rf_ctl_override(dev, 0x20, 0, 0, false);
-		b43_nphy_rf_ctl_override(dev, 0x10, 1, 0, false);
+
+	if (dev->phy.rev >= 7) {
+		/* TODO */
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+		} else {
+		}
 	} else {
-		b43_nphy_rf_ctl_override(dev, 0x10, 0, 0, false);
-		b43_nphy_rf_ctl_override(dev, 0x20, 1, 0, false);
+		b43_nphy_rf_ctl_override(dev, 0x1, 0, 0, false);
+		b43_nphy_rf_ctl_override(dev, 0x2, 1, 0, false);
+		b43_nphy_rf_ctl_override(dev, 0x80, 1, 0, false);
+		b43_nphy_rf_ctl_override(dev, 0x40, 1, 0, false);
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+			b43_nphy_rf_ctl_override(dev, 0x20, 0, 0, false);
+			b43_nphy_rf_ctl_override(dev, 0x10, 1, 0, false);
+		} else {
+			b43_nphy_rf_ctl_override(dev, 0x10, 0, 0, false);
+			b43_nphy_rf_ctl_override(dev, 0x20, 1, 0, false);
+		}
 	}
 
 	rx_core_state = b43_nphy_get_rx_core_state(dev);
@@ -1726,8 +1756,11 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 
 		/* Grab RSSI results for every possible VCM */
 		for (vcm = 0; vcm < 8; vcm++) {
-			b43_radio_maskset(dev, r | B2056_RX_RSSI_MISC, 0xE3,
-					vcm << 2);
+			if (dev->phy.rev >= 7)
+				;
+			else
+				b43_radio_maskset(dev, r | B2056_RX_RSSI_MISC,
+						  0xE3, vcm << 2);
 			b43_nphy_poll_rssi(dev, N_RSSI_NB, results[vcm], 8);
 		}
 
@@ -1754,8 +1787,11 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 		}
 
 		/* Select the best VCM */
-		b43_radio_maskset(dev, r | B2056_RX_RSSI_MISC, 0xE3,
-				  vcm_final << 2);
+		if (dev->phy.rev >= 7)
+			;
+		else
+			b43_radio_maskset(dev, r | B2056_RX_RSSI_MISC,
+					  0xE3, vcm_final << 2);
 
 		for (i = 0; i < 4; i++) {
 			if (core != i / 2)
@@ -1810,7 +1846,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 	b43_phy_set(dev, B43_NPHY_RFCTL_CMD, B43_NPHY_RFCTL_CMD_RXTX);
 	b43_phy_mask(dev, B43_NPHY_RFCTL_OVER, ~0x1);
 
-	for (i = 0; i < ARRAY_SIZE(regs_to_store); i++)
+	for (i = 0; i < regs_amount; i++)
 		b43_phy_write(dev, regs_to_store[i], saved_regs_phy[i]);
 
 	/* Store for future configuration */
-- 
1.8.4.5

