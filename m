Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:55495 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaEaSuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 14:50:12 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so3352916wgh.23
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 11:50:10 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 7/9] b43: PHY: drop own channel_freq (get it from chandef when needed)
Date: Sat, 31 May 2014 20:49:39 +0200
Message-Id: <1401562181-14608-8-git-send-email-zajec5@gmail.com> (sfid-20140531_205026_424315_E73B1E3E)
In-Reply-To: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
References: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_common.h |  1 -
 drivers/net/wireless/b43/phy_ht.c     |  2 +-
 drivers/net/wireless/b43/phy_n.c      | 24 ++++++++++++++----------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 56dfe7a..3990820 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -269,7 +269,6 @@ struct b43_phy {
 	/* Current channel */
 	struct cfg80211_chan_def *chandef;
 	unsigned int channel;
-	u16 channel_freq;
 	enum nl80211_channel_type channel_type;
 
 	/* PHY TX errors counter. */
diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 5d6833f..f2974c6 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -596,7 +596,7 @@ static void b43_phy_ht_tx_power_ctl_setup(struct b43_wldev *dev)
 	u8 target[3];
 	s16 a1[3], b0[3], b1[3];
 
-	u16 freq = dev->phy.channel_freq;
+	u16 freq = dev->phy.chandef->chan->center_freq;
 	int i, c;
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 86569f6..dc62f02 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -798,6 +798,7 @@ static void b43_chantab_radio_2056_upload(struct b43_wldev *dev,
 static void b43_radio_2056_setup(struct b43_wldev *dev,
 				const struct b43_nphy_channeltab_entry_rev3 *e)
 {
+	struct b43_phy *phy = &dev->phy;
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	enum ieee80211_band band = b43_current_band(dev->wl);
 	u16 offset;
@@ -909,7 +910,7 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 			b43_radio_write(dev, offset | B2056_TX_PA_SPARE1, 0xee);
 		}
 	} else if (dev->phy.n->ipa5g_on && band == IEEE80211_BAND_5GHZ) {
-		u16 freq = dev->phy.channel_freq;
+		u16 freq = phy->chandef->chan->center_freq;
 		if (freq < 5100) {
 			paa_boost = 0xA;
 			pada_boost = 0x77;
@@ -1675,6 +1676,7 @@ static int b43_nphy_poll_rssi(struct b43_wldev *dev, enum n_rssi_type rssi_type,
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICalRev3 */
 static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 {
+	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
 
 	u16 saved_regs_phy_rfctl[2];
@@ -1897,9 +1899,9 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 
 	/* Remember for which channel we store configuration */
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-		nphy->rssical_chanspec_2G.center_freq = dev->phy.channel_freq;
+		nphy->rssical_chanspec_2G.center_freq = phy->chandef->chan->center_freq;
 	else
-		nphy->rssical_chanspec_5G.center_freq = dev->phy.channel_freq;
+		nphy->rssical_chanspec_5G.center_freq = phy->chandef->chan->center_freq;
 
 	/* End of calibration, restore configuration */
 	b43_nphy_classifier(dev, 7, class);
@@ -2528,7 +2530,7 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 				}
 			}
 		} else {
-			u16 freq = phy->channel_freq;
+			u16 freq = phy->chandef->chan->center_freq;
 			if ((freq >= 5180 && freq <= 5230) ||
 			    (freq >= 5745 && freq <= 5805)) {
 				b43_radio_write(dev, 0x7D, 0xFF);
@@ -3184,12 +3186,13 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrFix */
 static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 {
+	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 
 	u8 txpi[2], bbmult, i;
 	u16 tmp, radio_gain, dac_gain;
-	u16 freq = dev->phy.channel_freq;
+	u16 freq = phy->chandef->chan->center_freq;
 	u32 txgain;
 	/* u32 gaintbl; rev3+ */
 
@@ -3474,6 +3477,7 @@ static void b43_nphy_tx_prepare_adjusted_power_table(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlSetup */
 static void b43_nphy_tx_power_ctl_setup(struct b43_wldev *dev)
 {
+	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 
@@ -3483,7 +3487,7 @@ static void b43_nphy_tx_power_ctl_setup(struct b43_wldev *dev)
 	s32 num, den, pwr;
 	u32 regval[64];
 
-	u16 freq = dev->phy.channel_freq;
+	u16 freq = phy->chandef->chan->center_freq;
 	u16 tmp;
 	u16 r; /* routing */
 	u8 i, c;
@@ -4500,7 +4504,7 @@ static void b43_nphy_save_cal(struct b43_wldev *dev)
 		txcal_radio_regs[2] = b43_radio_read(dev, 0x8D);
 		txcal_radio_regs[3] = b43_radio_read(dev, 0xBC);
 	}
-	iqcal_chanspec->center_freq = dev->phy.channel_freq;
+	iqcal_chanspec->center_freq = dev->phy.chandef->chan->center_freq;
 	iqcal_chanspec->channel_type = dev->phy.channel_type;
 	b43_ntab_read_bulk(dev, B43_NTAB16(15, 80), 8, table);
 
@@ -4581,6 +4585,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 				struct nphy_txgains target,
 				bool full, bool mphase)
 {
+	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
 	int i;
 	int error = 0;
@@ -4773,7 +4778,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 						nphy->txiqlocal_bestc);
 			nphy->txiqlocal_coeffsvalid = true;
 			nphy->txiqlocal_chanspec.center_freq =
-							dev->phy.channel_freq;
+						phy->chandef->chan->center_freq;
 			nphy->txiqlocal_chanspec.channel_type =
 							dev->phy.channel_type;
 		} else {
@@ -4811,7 +4816,7 @@ static void b43_nphy_reapply_tx_cal_coeffs(struct b43_wldev *dev)
 	bool equal = true;
 
 	if (!nphy->txiqlocal_coeffsvalid ||
-	    nphy->txiqlocal_chanspec.center_freq != dev->phy.channel_freq ||
+	    nphy->txiqlocal_chanspec.center_freq != dev->phy.chandef->chan->center_freq ||
 	    nphy->txiqlocal_chanspec.channel_type != dev->phy.channel_type)
 		return;
 
@@ -5502,7 +5507,6 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 	/* Channel is set later in common code, but we need to set it on our
 	   own to let this function's subcalls work properly. */
 	phy->channel = channel->hw_value;
-	phy->channel_freq = channel->center_freq;
 
 	if (b43_channel_type_is_40mhz(phy->channel_type) !=
 		b43_channel_type_is_40mhz(channel_type))
-- 
1.8.4.5

