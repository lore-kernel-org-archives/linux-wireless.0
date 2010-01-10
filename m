Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:39669 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab0AJWMg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 17:12:36 -0500
Received: by mail-ew0-f214.google.com with SMTP id 6so21225297ewy.29
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jan 2010 14:12:35 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sun, 10 Jan 2010 23:14:05 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 6/6] b43: N-PHY: little fixes in init code
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6b71res9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com
---
  drivers/net/wireless/b43/phy_n.c |   16 ++++++++++------
  drivers/net/wireless/b43/phy_n.h |   15 +++++++++++++++
  2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 577c626..962a675 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1220,9 +1220,11 @@ int b43_phy_initn(struct b43_wldev *dev)
  	if ((nphy->ipa2g_on && tmp2 == IEEE80211_BAND_2GHZ) ||
  	    (nphy->ipa5g_on && tmp2 == IEEE80211_BAND_5GHZ)) {
  		b43_phy_set(dev, B43_NPHY_PAPD_EN0, 0x1);
-		//FIXME b43_phy_maskset(dev, B43_NPHY_EPS_TABLE_ADJ0, 0x007F, nphy->papd_epsilon_offset[0] << 7);
+		b43_phy_maskset(dev, B43_NPHY_EPS_TABLE_ADJ0, 0x007F,
+				nphy->papd_epsilon_offset[0] << 7);
  		b43_phy_set(dev, B43_NPHY_PAPD_EN1, 0x1);
-		//FIXME b43_phy_maskset(dev, B43_NPHY_EPS_TABLE_ADJ1, 0x007F, nphy->papd_epsilon_offset[1] << 7);
+		b43_phy_maskset(dev, B43_NPHY_EPS_TABLE_ADJ1, 0x007F,
+				nphy->papd_epsilon_offset[1] << 7);
  		//TODO N PHY IPA Set TX Dig Filters
  	} else if (phy->rev >= 5) {
  		//TODO N PHY Ext PA Set TX Dig Filters
@@ -1260,9 +1262,9 @@ int b43_phy_initn(struct b43_wldev *dev)
  	}

  	if (nphy->phyrxchain != 3)
-		//TODO N PHY RX Core Set State with phyrxchain as argument
+		;//TODO N PHY RX Core Set State with phyrxchain as argument
  	if (nphy->mphase_cal_phase_id > 0)
-		//TODO PHY Periodic Calibration Multi-Phase Restart
+		;//TODO PHY Periodic Calibration Multi-Phase Restart

  	do_rssi_cal = false;
  	if (phy->rev >= 3) {
@@ -1297,8 +1299,10 @@ int b43_phy_initn(struct b43_wldev *dev)
  			if (nphy->perical != 2) {
  				b43_nphy_rssi_cal(dev);
  				if (phy->rev >= 3) {
-					//FIXME: nphy->cal_orig_pwr_idx[0] = nphy->txpwrindex[0].index_internal;
-					//FIXME: nphy->cal_orig_pwr_idx[1] = nphy->txpwrindex[1].index_internal;
+					nphy->cal_orig_pwr_idx[0] =
+					    nphy->txpwrindex[0].index_internal;
+					nphy->cal_orig_pwr_idx[1] =
+					    nphy->txpwrindex[1].index_internal;
  					//TODO N PHY Pre Calibrate TX Gain
  					target = b43_nphy_get_tx_gains(dev);
  				}
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index b23987c..491ff88 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -949,14 +949,29 @@ struct b43_phy_n_cal_cache {
  	struct b43_phy_n_iq_comp rxcal_coeffs_5G;
  };

+struct b43_phy_n_txpwrindex {
+	s8 index;
+	s8 index_internal;
+	s8 index_internal_save;
+	u16 AfectrlOverride;
+	u16 AfeCtrlDacGain;
+	u16 rad_gain;
+	u8 bbmult;
+	u16 iqcomp_a;
+	u16 iqcomp_b;
+	u16 locomp;
+};
+
  struct b43_phy_n {
  	u8 txpwrctrl;
  	u8 cal_orig_pwr_idx[2];
+	struct b43_phy_n_txpwrindex txpwrindex[2];
  	u8 measure_hold;
  	u8 phyrxchain;
  	u8 perical;
  	u8 mphase_cal_phase_id;
  	u8 antsel_type;
+	u16 papd_epsilon_offset[2];
  	u32 deaf_count;
  	bool hang_avoid;
  	bool mute;
-- 
1.6.4.2

