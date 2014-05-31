Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60759 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaEaSuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 14:50:16 -0400
Received: by mail-wi0-f176.google.com with SMTP id n15so2690639wiw.3
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 11:50:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 9/9] b43: PHY: drop channel_type (we can get this info from chandef)
Date: Sat, 31 May 2014 20:49:41 +0200
Message-Id: <1401562181-14608-10-git-send-email-zajec5@gmail.com> (sfid-20140531_205029_400768_9E422740)
In-Reply-To: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
References: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_common.c  |  6 ------
 drivers/net/wireless/b43/phy_common.h  |  3 ---
 drivers/net/wireless/b43/phy_n.c       | 11 +++++++----
 drivers/net/wireless/b43/tables_nphy.c |  2 +-
 4 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index e7e8383..2d05b59 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -547,12 +547,6 @@ void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on)
 }
 
 
-bool b43_channel_type_is_40mhz(enum nl80211_channel_type channel_type)
-{
-	return (channel_type == NL80211_CHAN_HT40MINUS ||
-		channel_type == NL80211_CHAN_HT40PLUS);
-}
-
 bool b43_is_40mhz(struct b43_wldev *dev)
 {
 	return dev->phy.chandef->width == NL80211_CHAN_WIDTH_40;
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 674422f..3912274 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -266,7 +266,6 @@ struct b43_phy {
 	/* Current channel */
 	struct cfg80211_chan_def *chandef;
 	unsigned int channel;
-	enum nl80211_channel_type channel_type;
 
 	/* PHY TX errors counter. */
 	atomic_t txerr_cnt;
@@ -447,8 +446,6 @@ int b43_phy_shm_tssi_read(struct b43_wldev *dev, u16 shm_offset);
  */
 void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on);
 
-bool b43_channel_type_is_40mhz(enum nl80211_channel_type channel_type);
-
 bool b43_is_40mhz(struct b43_wldev *dev);
 
 void b43_phy_force_clock(struct b43_wldev *dev, bool force);
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index dc12493..6398c7e 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4504,7 +4504,8 @@ static void b43_nphy_save_cal(struct b43_wldev *dev)
 		txcal_radio_regs[3] = b43_radio_read(dev, 0xBC);
 	}
 	iqcal_chanspec->center_freq = dev->phy.chandef->chan->center_freq;
-	iqcal_chanspec->channel_type = dev->phy.channel_type;
+	iqcal_chanspec->channel_type =
+				cfg80211_get_chandef_type(dev->phy.chandef);
 	b43_ntab_read_bulk(dev, B43_NTAB16(15, 80), 8, table);
 
 	if (nphy->hang_avoid)
@@ -4779,7 +4780,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 			nphy->txiqlocal_chanspec.center_freq =
 						phy->chandef->chan->center_freq;
 			nphy->txiqlocal_chanspec.channel_type =
-							dev->phy.channel_type;
+					cfg80211_get_chandef_type(phy->chandef);
 		} else {
 			length = 11;
 			if (dev->phy.rev < 3)
@@ -4816,7 +4817,7 @@ static void b43_nphy_reapply_tx_cal_coeffs(struct b43_wldev *dev)
 
 	if (!nphy->txiqlocal_coeffsvalid ||
 	    nphy->txiqlocal_chanspec.center_freq != dev->phy.chandef->chan->center_freq ||
-	    nphy->txiqlocal_chanspec.channel_type != dev->phy.channel_type)
+	    nphy->txiqlocal_chanspec.channel_type != cfg80211_get_chandef_type(dev->phy.chandef))
 		return;
 
 	b43_ntab_read_bulk(dev, B43_NTAB16(15, 80), 7, buffer);
@@ -5441,7 +5442,7 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 		bool avoid = false;
 		if (dev->phy.n->spur_avoid == B43_SPUR_AVOID_FORCE) {
 			avoid = true;
-		} else if (!b43_channel_type_is_40mhz(phy->channel_type)) {
+		} else if (!b43_is_40mhz(dev)) {
 			if ((ch >= 5 && ch <= 8) || ch == 13 || ch == 14)
 				avoid = true;
 		} else { /* 40MHz */
@@ -5507,9 +5508,11 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 	   own to let this function's subcalls work properly. */
 	phy->channel = channel->hw_value;
 
+#if 0
 	if (b43_channel_type_is_40mhz(phy->channel_type) !=
 		b43_channel_type_is_40mhz(channel_type))
 		; /* TODO: BMAC BW Set (channel_type) */
+#endif
 
 	if (channel_type == NL80211_CHAN_HT40PLUS)
 		b43_phy_set(dev, B43_NPHY_RXCTL,
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 4047c05..b221715 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -3191,7 +3191,7 @@ struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
 	/* Some workarounds to the workarounds... */
 	if (ghz5 && dev->phy.rev >= 6) {
 		if (dev->phy.radio_rev == 11 &&
-		    !b43_channel_type_is_40mhz(dev->phy.channel_type))
+		    !b43_is_40mhz(dev))
 			e->cliplo_gain = 0x2d;
 	} else if (!ghz5 && dev->phy.rev >= 5) {
 		static const int gain_data[] = {0x0062, 0x0064, 0x006a, 0x106a,
-- 
1.8.4.5

