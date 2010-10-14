Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54882 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0JNRdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 13:33:41 -0400
Received: by ewy20 with SMTP id 20so3690881ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 10:33:40 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/4 resend] b43: N-PHY: replace N-specific radio_chanspec with common code
Date: Thu, 14 Oct 2010 19:33:34 +0200
Message-Id: <1287077617-11319-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: this patch was included in 3-patches-set that was not commited yet. Third
patch from that set was canceled, but this one is OK.
---
 drivers/net/wireless/b43/phy_common.h |    1 +
 drivers/net/wireless/b43/phy_n.c      |   55 ++++++++++++++-------------------
 drivers/net/wireless/b43/phy_n.h      |    7 +---
 3 files changed, 26 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 6dcd033..0e61942 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -253,6 +253,7 @@ struct b43_phy {
 
 	/* Current channel */
 	unsigned int channel;
+	u16 channel_freq;
 	enum nl80211_channel_type channel_type;
 
 	/* PHY TX errors counter. */
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 814127e..13d7e3b 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -81,21 +81,6 @@ static inline bool b43_channel_type_is_40mhz(
 		channel_type == NL80211_CHAN_HT40PLUS);
 }
 
-static inline bool b43_empty_chanspec(struct b43_chanspec *chanspec)
-{
-	return !chanspec->channel && !chanspec->sideband &&
-		!chanspec->b_width && !chanspec->b_freq;
-}
-
-static inline bool b43_eq_chanspecs(struct b43_chanspec *chanspec1,
-					struct b43_chanspec *chanspec2)
-{
-	return (chanspec1->channel == chanspec2->channel &&
-		chanspec1->sideband == chanspec2->sideband &&
-		chanspec1->b_width == chanspec2->b_width &&
-		chanspec1->b_freq == chanspec2->b_freq);
-}
-
 void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
 {//TODO
 }
@@ -788,7 +773,7 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
 
-	u8 channel = nphy->radio_chanspec.channel;
+	u8 channel = dev->phy.channel;
 	int tone[2] = { 57, 58 };
 	u32 noise[2] = { 0x3FF, 0x3FF };
 
@@ -862,9 +847,9 @@ static void b43_nphy_adjust_lna_gain_table(struct b43_wldev *dev)
 			gain[0] = 6;
 			gain[1] = 6;
 		} else {
-			tmp = 40370 - 315 * nphy->radio_chanspec.channel;
+			tmp = 40370 - 315 * dev->phy.channel;
 			gain[0] = ((tmp >> 13) + ((tmp >> 12) & 1));
-			tmp = 23242 - 224 * nphy->radio_chanspec.channel;
+			tmp = 23242 - 224 * dev->phy.channel;
 			gain[1] = ((tmp >> 13) + ((tmp >> 12) & 1));
 		}
 	} else {
@@ -2090,12 +2075,12 @@ static void b43_nphy_restore_rssi_cal(struct b43_wldev *dev)
 	u16 *rssical_phy_regs = NULL;
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-		if (b43_empty_chanspec(&nphy->rssical_chanspec_2G))
+		if (!nphy->rssical_chanspec_2G.center_freq)
 			return;
 		rssical_radio_regs = nphy->rssical_cache.rssical_radio_regs_2G;
 		rssical_phy_regs = nphy->rssical_cache.rssical_phy_regs_2G;
 	} else {
-		if (b43_empty_chanspec(&nphy->rssical_chanspec_5G))
+		if (!nphy->rssical_chanspec_5G.center_freq)
 			return;
 		rssical_radio_regs = nphy->rssical_cache.rssical_radio_regs_5G;
 		rssical_phy_regs = nphy->rssical_cache.rssical_phy_regs_5G;
@@ -2551,7 +2536,8 @@ static void b43_nphy_save_cal(struct b43_wldev *dev)
 		txcal_radio_regs[2] = b43_radio_read(dev, 0x8D);
 		txcal_radio_regs[3] = b43_radio_read(dev, 0xBC);
 	}
-	*iqcal_chanspec = nphy->radio_chanspec;
+	iqcal_chanspec->center_freq = dev->phy.channel_freq;
+	iqcal_chanspec->channel_type = dev->phy.channel_type;
 	b43_ntab_write_bulk(dev, B43_NTAB16(15, 80), 8, table);
 
 	if (nphy->hang_avoid)
@@ -2572,12 +2558,12 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
 	struct b43_phy_n_iq_comp *rxcal_coeffs = NULL;
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-		if (b43_empty_chanspec(&nphy->iqcal_chanspec_2G))
+		if (!nphy->iqcal_chanspec_2G.center_freq)
 			return;
 		table = nphy->cal_cache.txcal_coeffs_2G;
 		loft = &nphy->cal_cache.txcal_coeffs_2G[5];
 	} else {
-		if (b43_empty_chanspec(&nphy->iqcal_chanspec_5G))
+		if (!nphy->iqcal_chanspec_5G.center_freq)
 			return;
 		table = nphy->cal_cache.txcal_coeffs_5G;
 		loft = &nphy->cal_cache.txcal_coeffs_5G[5];
@@ -2822,7 +2808,10 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 			b43_ntab_read_bulk(dev, B43_NTAB16(15, 96), length,
 						nphy->txiqlocal_bestc);
 			nphy->txiqlocal_coeffsvalid = true;
-			nphy->txiqlocal_chanspec = nphy->radio_chanspec;
+			nphy->txiqlocal_chanspec.center_freq =
+							dev->phy.channel_freq;
+			nphy->txiqlocal_chanspec.channel_type =
+							dev->phy.channel_type;
 		} else {
 			length = 11;
 			if (dev->phy.rev < 3)
@@ -2858,7 +2847,8 @@ static void b43_nphy_reapply_tx_cal_coeffs(struct b43_wldev *dev)
 	bool equal = true;
 
 	if (!nphy->txiqlocal_coeffsvalid ||
-	    b43_eq_chanspecs(&nphy->txiqlocal_chanspec, &nphy->radio_chanspec))
+	    nphy->txiqlocal_chanspec.center_freq != dev->phy.channel_freq ||
+	    nphy->txiqlocal_chanspec.channel_type != dev->phy.channel_type)
 		return;
 
 	b43_ntab_read_bulk(dev, B43_NTAB16(15, 80), 7, buffer);
@@ -3264,11 +3254,9 @@ int b43_phy_initn(struct b43_wldev *dev)
 	do_rssi_cal = false;
 	if (phy->rev >= 3) {
 		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-			do_rssi_cal =
-				b43_empty_chanspec(&nphy->rssical_chanspec_2G);
+			do_rssi_cal = !nphy->rssical_chanspec_2G.center_freq;
 		else
-			do_rssi_cal =
-				b43_empty_chanspec(&nphy->rssical_chanspec_5G);
+			do_rssi_cal = !nphy->rssical_chanspec_5G.center_freq;
 
 		if (do_rssi_cal)
 			b43_nphy_rssi_cal(dev);
@@ -3280,9 +3268,9 @@ int b43_phy_initn(struct b43_wldev *dev)
 
 	if (!((nphy->measure_hold & 0x6) != 0)) {
 		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-			do_cal = b43_empty_chanspec(&nphy->iqcal_chanspec_2G);
+			do_cal = !nphy->iqcal_chanspec_2G.center_freq;
 		else
-			do_cal = b43_empty_chanspec(&nphy->iqcal_chanspec_5G);
+			do_cal = !nphy->iqcal_chanspec_5G.center_freq;
 
 		if (nphy->mute)
 			do_cal = false;
@@ -3411,7 +3399,10 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 			return -ESRCH;
 	}
 
-	nphy->radio_chanspec.channel = channel->hw_value;
+	/* Channel is set later in common code, but we need to set it on our
+	   own to let this function's subcalls work properly. */
+	phy->channel = channel->hw_value;
+	phy->channel_freq = channel->center_freq;
 
 	if (b43_channel_type_is_40mhz(phy->channel_type) !=
 		b43_channel_type_is_40mhz(channel_type))
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index e7acae2..f915c83 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -927,10 +927,8 @@
 struct b43_wldev;
 
 struct b43_chanspec {
-	u8 channel;
-	u8 sideband;
-	u8 b_width;
-	u8 b_freq;
+	u16 center_freq;
+	enum nl80211_channel_type channel_type;
 };
 
 struct b43_phy_n_iq_comp {
@@ -984,7 +982,6 @@ struct b43_phy_n {
 	u16 papd_epsilon_offset[2];
 	s32 preamble_override;
 	u32 bb_mult_save;
-	struct b43_chanspec radio_chanspec;
 
 	bool gain_boost;
 	bool elna_gain_config;
-- 
1.7.1

