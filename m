Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62826 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760201Ab0KRULA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 15:11:00 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2259732eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 12:11:00 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: N-PHY: little cleanups
Date: Thu, 18 Nov 2010 21:11:43 +0100
Message-Id: <1290111103-19308-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1290111103-19308-1-git-send-email-zajec5@gmail.com>
References: <1290111103-19308-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove some typos, warnings, initialize some values to follow wl's code path.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 1354228..6c6c872 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -573,7 +573,6 @@ static void b43_nphy_calc_rx_iq_comp(struct b43_wldev *dev, u8 mask)
 			ii = est.i1_pwr;
 			qq = est.q1_pwr;
 		} else {
-			B43_WARN_ON(1);
 			continue;
 		}
 
@@ -2028,7 +2027,7 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
 	}
 
 	b43_radio_maskset(dev, B2055_C1_PD_RSSIMISC, 0xF8, state[0]);
-	b43_radio_maskset(dev, B2055_C1_PD_RSSIMISC, 0xF8, state[1]);
+	b43_radio_maskset(dev, B2055_C2_PD_RSSIMISC, 0xF8, state[1]);
 
 	switch (state[2]) {
 	case 1:
@@ -3112,7 +3111,7 @@ static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = phy->n;
-	u16 buf[16];
+	/* u16 buf[16]; it's rev3+ */
 
 	nphy->phyrxchain = mask;
 
@@ -3408,7 +3407,6 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 				enum nl80211_channel_type channel_type)
 {
 	struct b43_phy *phy = &dev->phy;
-	struct b43_phy_n *nphy = dev->phy.n;
 
 	const struct b43_nphy_channeltab_entry_rev2 *tabent_r2;
 	const struct b43_nphy_channeltab_entry_rev3 *tabent_r3;
@@ -3478,8 +3476,9 @@ static void b43_nphy_op_prepare_structs(struct b43_wldev *dev)
 
 	memset(nphy, 0, sizeof(*nphy));
 
-	/* wl goes path which is executed for gain_boost, assume it is true */
-	nphy->gain_boost = true;
+	nphy->gain_boost = true; /* this way we follow wl, assume it is true */
+	nphy->txrx_chain = 2; /* sth different than 0 and 1 for now */
+	nphy->phyrxchain = 3; /* to avoid b43_nphy_set_rx_core_state like wl */
 }
 
 static void b43_nphy_op_free(struct b43_wldev *dev)
@@ -3552,8 +3551,6 @@ static void b43_nphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 					bool blocked)
 {
-	struct b43_phy_n *nphy = dev->phy.n;
-
 	if (b43_read32(dev, B43_MMIO_MACCTL) & B43_MACCTL_ENABLED)
 		b43err(dev->wl, "MAC not suspended\n");
 
-- 
1.7.1

