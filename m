Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42021 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759526Ab0JFSNG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:13:06 -0400
Received: by ewy23 with SMTP id 23so3017233ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 11:13:04 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] b43: N-PHY: store current channel info in PHY common
Date: Wed,  6 Oct 2010 20:13:07 +0200
Message-Id: <1286388787-11342-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
As for now I simply implemented code strictly from specs without much analyzing
it. This introduced mess as we keep current channel info in few places.

This patch starts moving it to commong place. Is this OK to put
nl80211_channel_type in this common code? Are you find with this?

Finally I'm going to remove radio_chanspec totally.

Some kind of struct b43_chanspec may be still useful to allow easy storing
info about channel we have cached data for.

 drivers/net/wireless/b43/phy_common.h |    4 ++-
 drivers/net/wireless/b43/phy_n.c      |   65 +++++++++++++++++----------------
 drivers/net/wireless/b43/phy_n.h      |    1 -
 3 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index bd480b4..6dcd033 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -2,6 +2,7 @@
 #define LINUX_B43_PHY_COMMON_H_
 
 #include <linux/types.h>
+#include <linux/nl80211.h>
 
 struct b43_wldev;
 
@@ -250,8 +251,9 @@ struct b43_phy {
 	 * check is needed. */
 	unsigned long next_txpwr_check_time;
 
-	/* current channel */
+	/* Current channel */
 	unsigned int channel;
+	enum nl80211_channel_type channel_type;
 
 	/* PHY TX errors counter. */
 	atomic_t txerr_cnt;
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 9eae708..9b057f0 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -74,6 +74,13 @@ static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
 static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
 						u16 value, u8 core);
 
+static inline bool b43_channel_type_is_40mhz(
+					enum nl80211_channel_type channel_type)
+{
+	return (channel_type == NL80211_CHAN_HT40MINUS ||
+		channel_type == NL80211_CHAN_HT40PLUS);
+}
+
 static inline bool b43_empty_chanspec(struct b43_chanspec *chanspec)
 {
 	return !chanspec->channel && !chanspec->sideband &&
@@ -3323,9 +3330,9 @@ int b43_phy_initn(struct b43_wldev *dev)
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ChanspecSetup */
-static void b43_nphy_chanspec_setup(struct b43_wldev *dev,
+static void b43_nphy_channel_setup(struct b43_wldev *dev,
 				const struct b43_phy_n_sfo_cfg *e,
-				struct b43_chanspec chanspec)
+				struct ieee80211_channel *new_channel)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
@@ -3334,13 +3341,13 @@ static void b43_nphy_chanspec_setup(struct b43_wldev *dev,
 	u32 tmp32;
 
 	tmp = b43_phy_read(dev, B43_NPHY_BANDCTL) & B43_NPHY_BANDCTL_5GHZ;
-	if (chanspec.b_freq == 1 && tmp == 0) {
+	if (new_channel->band == IEEE80211_BAND_5GHZ && tmp == 0) {
 		tmp32 = b43_read32(dev, B43_MMIO_PSM_PHY_HDR);
 		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32 | 4);
 		b43_phy_set(dev, B43_PHY_B_BBCFG, 0xC000);
 		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32);
 		b43_phy_set(dev, B43_NPHY_BANDCTL, B43_NPHY_BANDCTL_5GHZ);
-	} else if (chanspec.b_freq == 1) {
+	} else if (new_channel->band == IEEE80211_BAND_5GHZ) {
 		b43_phy_mask(dev, B43_NPHY_BANDCTL, ~B43_NPHY_BANDCTL_5GHZ);
 		tmp32 = b43_read32(dev, B43_MMIO_PSM_PHY_HDR);
 		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32 | 4);
@@ -3352,12 +3359,12 @@ static void b43_nphy_chanspec_setup(struct b43_wldev *dev,
 
 	/* Don't follow specs, B43_SHM_SH_CHAN is set by b43_switch_channel */
 
-	if (nphy->radio_chanspec.channel == 14) {
+	if (new_channel->hw_value == 14) {
 		b43_nphy_classifier(dev, 2, 0);
 		b43_phy_set(dev, B43_PHY_B_TEST, 0x0800);
 	} else {
 		b43_nphy_classifier(dev, 2, 2);
-		if (chanspec.b_freq == 2)
+		if (new_channel->band == IEEE80211_BAND_2GHZ)
 			b43_phy_mask(dev, B43_PHY_B_TEST, ~0x840);
 	}
 
@@ -3380,16 +3387,16 @@ static void b43_nphy_chanspec_setup(struct b43_wldev *dev,
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetChanspec */
-static int b43_nphy_set_chanspec(struct b43_wldev *dev,
-					struct b43_chanspec chanspec)
+static int b43_nphy_set_channel(struct b43_wldev *dev,
+				struct ieee80211_channel *channel,
+				enum nl80211_channel_type channel_type)
 {
-	struct b43_phy_n *nphy = dev->phy.n;
+	struct b43_phy *phy = &dev->phy;
 
 	const struct b43_nphy_channeltab_entry_rev2 *tabent_r2;
 	const struct b43_nphy_channeltab_entry_rev3 *tabent_r3;
 
 	u8 tmp;
-	u8 channel = chanspec.channel;
 
 	if (dev->phy.rev >= 3) {
 		/* TODO */
@@ -3397,36 +3404,33 @@ static int b43_nphy_set_chanspec(struct b43_wldev *dev,
 		if (!tabent_r3)
 			return -ESRCH;
 	} else {
-		tabent_r2 = b43_nphy_get_chantabent_rev2(dev, channel);
+		tabent_r2 = b43_nphy_get_chantabent_rev2(dev,
+							channel->hw_value);
 		if (!tabent_r2)
 			return -ESRCH;
 	}
 
-	nphy->radio_chanspec = chanspec;
+	if (b43_channel_type_is_40mhz(phy->channel_type) !=
+		b43_channel_type_is_40mhz(channel_type))
+		; /* TODO: BMAC BW Set (channel_type) */
 
-	if (chanspec.b_width != nphy->b_width)
-		; /* TODO: BMAC BW Set (chanspec.b_width) */
-
-	/* TODO: use defines */
-	if (chanspec.b_width == 3) {
-		if (chanspec.sideband == 2)
-			b43_phy_set(dev, B43_NPHY_RXCTL,
-					B43_NPHY_RXCTL_BSELU20);
-		else
+	if (channel_type == NL80211_CHAN_HT40PLUS)
+		b43_phy_set(dev, B43_NPHY_RXCTL,
+				B43_NPHY_RXCTL_BSELU20);
+	else if (channel_type == NL80211_CHAN_HT40MINUS)
 			b43_phy_mask(dev, B43_NPHY_RXCTL,
 					~B43_NPHY_RXCTL_BSELU20);
-	}
 
 	if (dev->phy.rev >= 3) {
-		tmp = (chanspec.b_freq == 1) ? 4 : 0;
+		tmp = (channel->band == IEEE80211_BAND_5GHZ) ? 4 : 0;
 		b43_radio_maskset(dev, 0x08, 0xFFFB, tmp);
 		/* TODO: PHY Radio2056 Setup (dev, tabent_r3); */
-		b43_nphy_chanspec_setup(dev, &(tabent_r3->phy_regs), chanspec);
+		b43_nphy_channel_setup(dev, &(tabent_r3->phy_regs), channel);
 	} else {
-		tmp = (chanspec.b_freq == 1) ? 0x0020 : 0x0050;
+		tmp = (channel->band == IEEE80211_BAND_5GHZ) ? 0x0020 : 0x0050;
 		b43_radio_maskset(dev, B2055_MASTER1, 0xFF8F, tmp);
 		b43_radio_2055_setup(dev, tabent_r2);
-		b43_nphy_chanspec_setup(dev, &(tabent_r2->phy_regs), chanspec);
+		b43_nphy_channel_setup(dev, &(tabent_r2->phy_regs), channel);
 	}
 
 	return 0;
@@ -3568,8 +3572,8 @@ static void b43_nphy_op_switch_analog(struct b43_wldev *dev, bool on)
 static int b43_nphy_op_switch_channel(struct b43_wldev *dev,
 				      unsigned int new_channel)
 {
-	struct b43_phy_n *nphy = dev->phy.n;
-	struct b43_chanspec chanspec;
+	struct ieee80211_channel *channel = dev->wl->hw->conf.channel;
+	enum nl80211_channel_type channel_type = dev->wl->hw->conf.channel_type;
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		if ((new_channel < 1) || (new_channel > 14))
@@ -3579,10 +3583,7 @@ static int b43_nphy_op_switch_channel(struct b43_wldev *dev,
 			return -EINVAL;
 	}
 
-	chanspec = nphy->radio_chanspec;
-	chanspec.channel = new_channel;
-
-	return b43_nphy_set_chanspec(dev, chanspec);
+	return b43_nphy_set_channel(dev, channel, channel_type);
 }
 
 static unsigned int b43_nphy_op_get_default_chan(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 8b6d570..e7acae2 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -984,7 +984,6 @@ struct b43_phy_n {
 	u16 papd_epsilon_offset[2];
 	s32 preamble_override;
 	u32 bb_mult_save;
-	u8 b_width;
 	struct b43_chanspec radio_chanspec;
 
 	bool gain_boost;
-- 
1.7.1

