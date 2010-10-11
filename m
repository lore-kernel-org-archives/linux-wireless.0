Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61688 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab0JKBLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 21:11:04 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so1403810bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Oct 2010 18:11:04 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: N-PHY: grab more info about new channel
Date: Mon, 11 Oct 2010 03:11:01 +0200
Message-Id: <1286759463-32221-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1286759463-32221-1-git-send-email-zajec5@gmail.com>
References: <1286759463-32221-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   61 ++++++++++++++++++--------------------
 1 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index f575e75..c596b46 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3323,9 +3323,9 @@ int b43_phy_initn(struct b43_wldev *dev)
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
@@ -3334,13 +3334,13 @@ static void b43_nphy_chanspec_setup(struct b43_wldev *dev,
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
@@ -3350,13 +3350,12 @@ static void b43_nphy_chanspec_setup(struct b43_wldev *dev,
 
 	b43_chantab_phy_upload(dev, e);
 
-
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
 
@@ -3379,16 +3378,17 @@ static void b43_nphy_chanspec_setup(struct b43_wldev *dev,
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetChanspec */
-static int b43_nphy_set_chanspec(struct b43_wldev *dev,
-					struct b43_chanspec chanspec)
+static int b43_nphy_set_channel(struct b43_wldev *dev,
+				struct ieee80211_channel *channel,
+				enum nl80211_channel_type channel_type)
 {
+	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
 
 	const struct b43_nphy_channeltab_entry_rev2 *tabent_r2;
 	const struct b43_nphy_channeltab_entry_rev3 *tabent_r3;
 
 	u8 tmp;
-	u8 channel = chanspec.channel;
 
 	if (dev->phy.rev >= 3) {
 		/* TODO */
@@ -3396,36 +3396,36 @@ static int b43_nphy_set_chanspec(struct b43_wldev *dev,
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
+	nphy->radio_chanspec.channel = channel->hw_value;
 
+	/*
 	if (chanspec.b_width != nphy->b_width)
-		; /* TODO: BMAC BW Set (chanspec.b_width) */
+		; TODO: BMAC BW Set (chanspec.b_width)
+	*/
 
-	/* TODO: use defines */
-	if (chanspec.b_width == 3) {
-		if (chanspec.sideband == 2)
-			b43_phy_set(dev, B43_NPHY_RXCTL,
-					B43_NPHY_RXCTL_BSELU20);
-		else
-			b43_phy_mask(dev, B43_NPHY_RXCTL,
-					~B43_NPHY_RXCTL_BSELU20);
-	}
+	if (channel_type == NL80211_CHAN_HT40PLUS)
+		b43_phy_set(dev, B43_NPHY_RXCTL,
+				B43_NPHY_RXCTL_BSELU20);
+	else if (channel_type == NL80211_CHAN_HT40MINUS)
+		b43_phy_mask(dev, B43_NPHY_RXCTL,
+				~B43_NPHY_RXCTL_BSELU20);
 
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
@@ -3567,8 +3567,8 @@ static void b43_nphy_op_switch_analog(struct b43_wldev *dev, bool on)
 static int b43_nphy_op_switch_channel(struct b43_wldev *dev,
 				      unsigned int new_channel)
 {
-	struct b43_phy_n *nphy = dev->phy.n;
-	struct b43_chanspec chanspec;
+	struct ieee80211_channel *channel = dev->wl->hw->conf.channel;
+	enum nl80211_channel_type channel_type = dev->wl->hw->conf.channel_type;
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		if ((new_channel < 1) || (new_channel > 14))
@@ -3578,10 +3578,7 @@ static int b43_nphy_op_switch_channel(struct b43_wldev *dev,
 			return -EINVAL;
 	}
 
-	chanspec = nphy->radio_chanspec;
-	chanspec.channel = new_channel;
-
-	return b43_nphy_set_chanspec(dev, chanspec);
+	return b43_nphy_set_channel(dev, channel, channel_type);
 }
 
 static unsigned int b43_nphy_op_get_default_chan(struct b43_wldev *dev)
-- 
1.7.1

