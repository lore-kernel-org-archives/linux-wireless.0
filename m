Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37488 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab0LGU4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 15:56:39 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so336422wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 12:56:38 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/4] b43: N-PHY: silence warnings
Date: Tue,  7 Dec 2010 21:55:57 +0100
Message-Id: <1291755360-21570-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index f78f4e9..d41da7f 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -258,7 +258,8 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 
 	for (i = 0; i < 2; i++) {
 		if (dev->phy.rev >= 3) {
-			/* TODO */
+			/* FIXME: support 5GHz */
+			txgain = b43_ntab_tx_gain_rev3plus_2ghz[txpi[i]];
 			radio_gain = (txgain >> 16) & 0x1FFFF;
 		} else {
 			txgain = b43_ntab_tx_gain_rev0_1_2[txpi[i]];
@@ -613,6 +614,8 @@ static void b43_nphy_rx_iq_coeffs(struct b43_wldev *dev, bool write,
 	}
 }
 
+#if 0
+/* Ready but not used anywhere */
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxCalPhyCleanup */
 static void b43_nphy_rx_cal_phy_cleanup(struct b43_wldev *dev, u8 core)
 {
@@ -694,6 +697,7 @@ static void b43_nphy_rx_cal_phy_setup(struct b43_wldev *dev, u8 core)
 	b43_nphy_rf_control_intc_override(dev, 1, rxval, (core + 1));
 	b43_nphy_rf_control_intc_override(dev, 1, txval, (2 - core));
 }
+#endif
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalcRxIqComp */
 static void b43_nphy_calc_rx_iq_comp(struct b43_wldev *dev, u8 mask)
@@ -3088,7 +3092,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 	u8 rfctl[2];
 	u8 afectl_core;
 	u16 tmp[6];
-	u16 cur_hpf1, cur_hpf2, cur_lna;
+	u16 uninitialized_var(cur_hpf1), uninitialized_var(cur_hpf2), cur_lna;
 	u32 real, imag;
 	enum ieee80211_band band;
 
-- 
1.6.3.3

