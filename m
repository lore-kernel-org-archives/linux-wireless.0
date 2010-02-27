Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:57978 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966330Ab0B0MEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 07:04:13 -0500
Received: by mail-fx0-f219.google.com with SMTP id 19so915402fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 04:04:13 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 06/10] b43: N-PHY: switch to chanspec struct
Date: Sat, 27 Feb 2010 13:03:37 +0100
Message-Id: <1267272221-1873-7-git-send-email-zajec5@gmail.com>
In-Reply-To: <1267272221-1873-1-git-send-email-zajec5@gmail.com>
References: <1267272221-1873-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   45 +++++++++++++++++++++++++------------
 drivers/net/wireless/b43/phy_n.h |   11 +++++----
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 6774897..1952acc 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -73,6 +73,21 @@ static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
 static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
 						u16 value, u8 core);
 
+static inline bool b43_empty_chanspec(struct b43_chanspec *chanspec)
+{
+	return !chanspec->channel && !chanspec->sideband &&
+		!chanspec->b_width && !chanspec->b_freq;
+}
+
+static inline bool b43_eq_chanspecs(struct b43_chanspec *chanspec1,
+					struct b43_chanspec *chanspec2)
+{
+	return (chanspec1->channel == chanspec2->channel &&
+		chanspec1->sideband == chanspec2->sideband &&
+		chanspec1->b_width == chanspec2->b_width &&
+		chanspec1->b_freq == chanspec2->b_freq);
+}
+
 void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
 {//TODO
 }
@@ -768,7 +783,7 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
 
-	unsigned int channel;
+	u8 channel = nphy->radio_chanspec.channel;
 	int tone[2] = { 57, 58 };
 	u32 noise[2] = { 0x3FF, 0x3FF };
 
@@ -777,8 +792,6 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, 1);
 
-	/* FIXME: channel = radio_chanspec */
-
 	if (nphy->gband_spurwar_en) {
 		/* TODO: N PHY Adjust Analog Pfbw (7) */
 		if (channel == 11 && dev->phy.is_40mhz)
@@ -2015,12 +2028,12 @@ static void b43_nphy_restore_rssi_cal(struct b43_wldev *dev)
 	u16 *rssical_phy_regs = NULL;
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-		if (!nphy->rssical_chanspec_2G)
+		if (b43_empty_chanspec(&nphy->rssical_chanspec_2G))
 			return;
 		rssical_radio_regs = nphy->rssical_cache.rssical_radio_regs_2G;
 		rssical_phy_regs = nphy->rssical_cache.rssical_phy_regs_2G;
 	} else {
-		if (!nphy->rssical_chanspec_5G)
+		if (b43_empty_chanspec(&nphy->rssical_chanspec_5G))
 			return;
 		rssical_radio_regs = nphy->rssical_cache.rssical_radio_regs_5G;
 		rssical_phy_regs = nphy->rssical_cache.rssical_phy_regs_5G;
@@ -2440,7 +2453,7 @@ static void b43_nphy_save_cal(struct b43_wldev *dev)
 
 	struct b43_phy_n_iq_comp *rxcal_coeffs = NULL;
 	u16 *txcal_radio_regs = NULL;
-	u8 *iqcal_chanspec;
+	struct b43_chanspec *iqcal_chanspec;
 	u16 *table = NULL;
 
 	if (nphy->hang_avoid)
@@ -2496,12 +2509,12 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
 	struct b43_phy_n_iq_comp *rxcal_coeffs = NULL;
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-		if (nphy->iqcal_chanspec_2G == 0)
+		if (b43_empty_chanspec(&nphy->iqcal_chanspec_2G))
 			return;
 		table = nphy->cal_cache.txcal_coeffs_2G;
 		loft = &nphy->cal_cache.txcal_coeffs_2G[5];
 	} else {
-		if (nphy->iqcal_chanspec_5G == 0)
+		if (b43_empty_chanspec(&nphy->iqcal_chanspec_5G))
 			return;
 		table = nphy->cal_cache.txcal_coeffs_5G;
 		loft = &nphy->cal_cache.txcal_coeffs_5G[5];
@@ -2746,8 +2759,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 			b43_ntab_read_bulk(dev, B43_NTAB16(15, 96), length,
 						nphy->txiqlocal_bestc);
 			nphy->txiqlocal_coeffsvalid = true;
-			/* TODO: Set nphy->txiqlocal_chanspec to
-				the current channel */
+			nphy->txiqlocal_chanspec = nphy->radio_chanspec;
 		} else {
 			length = 11;
 			if (dev->phy.rev < 3)
@@ -2782,7 +2794,8 @@ static void b43_nphy_reapply_tx_cal_coeffs(struct b43_wldev *dev)
 	u16 buffer[7];
 	bool equal = true;
 
-	if (!nphy->txiqlocal_coeffsvalid || 1 /* FIXME */)
+	if (!nphy->txiqlocal_coeffsvalid ||
+	    b43_eq_chanspecs(&nphy->txiqlocal_chanspec, &nphy->radio_chanspec))
 		return;
 
 	b43_ntab_read_bulk(dev, B43_NTAB16(15, 80), 7, buffer);
@@ -3137,9 +3150,11 @@ int b43_phy_initn(struct b43_wldev *dev)
 	do_rssi_cal = false;
 	if (phy->rev >= 3) {
 		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-			do_rssi_cal = (nphy->rssical_chanspec_2G == 0);
+			do_rssi_cal =
+				b43_empty_chanspec(&nphy->rssical_chanspec_2G);
 		else
-			do_rssi_cal = (nphy->rssical_chanspec_5G == 0);
+			do_rssi_cal =
+				b43_empty_chanspec(&nphy->rssical_chanspec_5G);
 
 		if (do_rssi_cal)
 			b43_nphy_rssi_cal(dev);
@@ -3151,9 +3166,9 @@ int b43_phy_initn(struct b43_wldev *dev)
 
 	if (!((nphy->measure_hold & 0x6) != 0)) {
 		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-			do_cal = (nphy->iqcal_chanspec_2G == 0);
+			do_cal = b43_empty_chanspec(&nphy->iqcal_chanspec_2G);
 		else
-			do_cal = (nphy->iqcal_chanspec_5G == 0);
+			do_cal = b43_empty_chanspec(&nphy->iqcal_chanspec_5G);
 
 		if (nphy->mute)
 			do_cal = false;
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 47d20dc..e7acae2 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -984,7 +984,7 @@ struct b43_phy_n {
 	u16 papd_epsilon_offset[2];
 	s32 preamble_override;
 	u32 bb_mult_save;
-	u16 radio_chanspec;
+	struct b43_chanspec radio_chanspec;
 
 	bool gain_boost;
 	bool elna_gain_config;
@@ -1000,6 +1000,7 @@ struct b43_phy_n {
 	u16 txiqlocal_bestc[11];
 	bool txiqlocal_coeffsvalid;
 	struct b43_phy_n_txpwrindex txpwrindex[2];
+	struct b43_chanspec txiqlocal_chanspec;
 
 	u8 txrx_chain;
 	u16 tx_rx_cal_phy_saveregs[11];
@@ -1015,12 +1016,12 @@ struct b43_phy_n {
 	bool gband_spurwar_en;
 
 	bool ipa2g_on;
-	u8 iqcal_chanspec_2G;
-	u8 rssical_chanspec_2G;
+	struct b43_chanspec iqcal_chanspec_2G;
+	struct b43_chanspec rssical_chanspec_2G;
 
 	bool ipa5g_on;
-	u8 iqcal_chanspec_5G;
-	u8 rssical_chanspec_5G;
+	struct b43_chanspec iqcal_chanspec_5G;
+	struct b43_chanspec rssical_chanspec_5G;
 
 	struct b43_phy_n_rssical_cache rssical_cache;
 	struct b43_phy_n_cal_cache cal_cache;
-- 
1.6.4.2

