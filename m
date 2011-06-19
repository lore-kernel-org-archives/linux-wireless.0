Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33823 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab1FSJjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 05:39:10 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so247938eyx.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2011 02:39:09 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: HT-PHY: add place for implementing channel switching
Date: Sun, 19 Jun 2011 12:17:20 +0200
Message-Id: <1308478641-6207-2-git-send-email-zajec5@gmail.com> (sfid-20110619_113923_143474_2BBB61B3)
In-Reply-To: <1308478641-6207-1-git-send-email-zajec5@gmail.com>
References: <1308478641-6207-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   61 +++++++++++++++++++++++++++++++++++-
 1 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 763dbb0..12ad47f 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -27,6 +27,49 @@
 #include "radio_2059.h"
 #include "main.h"
 
+static void b43_radio_2059_channel_setup(struct b43_wldev *dev,
+			const struct b43_phy_ht_channeltab_e_radio2059 *e)
+{
+	/* TODO */
+}
+
+static void b43_phy_ht_channel_setup(struct b43_wldev *dev,
+				const struct b43_phy_ht_channeltab_e_phy *e,
+				struct ieee80211_channel *new_channel)
+{
+	/* TODO */
+}
+
+static int b43_phy_ht_set_channel(struct b43_wldev *dev,
+				  struct ieee80211_channel *channel,
+				  enum nl80211_channel_type channel_type)
+{
+	struct b43_phy *phy = &dev->phy;
+
+	const struct b43_phy_ht_channeltab_e_radio2059 *chent_r2059 = NULL;
+
+	if (phy->radio_ver == 0x2059) {
+		chent_r2059 = b43_phy_ht_get_channeltab_e_r2059(dev,
+							channel->center_freq);
+		if (!chent_r2059)
+			return -ESRCH;
+	} else {
+		return -ESRCH;
+	}
+
+	/* TODO: In case of N-PHY some bandwidth switching goes here */
+
+	if (phy->radio_ver == 0x2059) {
+		b43_radio_2059_channel_setup(dev, chent_r2059);
+		b43_phy_ht_channel_setup(dev, &(chent_r2059->phy_regs),
+					 channel);
+	} else {
+		return -ESRCH;
+	}
+
+	return 0;
+}
+
 /**************************************************
  * Basic PHY ops.
  **************************************************/
@@ -96,6 +139,22 @@ static void b43_phy_ht_op_switch_analog(struct b43_wldev *dev, bool on)
 	}
 }
 
+static int b43_phy_ht_op_switch_channel(struct b43_wldev *dev,
+					unsigned int new_channel)
+{
+	struct ieee80211_channel *channel = dev->wl->hw->conf.channel;
+	enum nl80211_channel_type channel_type = dev->wl->hw->conf.channel_type;
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if ((new_channel < 1) || (new_channel > 14))
+			return -EINVAL;
+	} else {
+		return -EINVAL;
+	}
+
+	return b43_phy_ht_set_channel(dev, channel, channel_type);
+}
+
 static unsigned int b43_phy_ht_op_get_default_chan(struct b43_wldev *dev)
 {
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
@@ -161,9 +220,7 @@ const struct b43_phy_operations b43_phyops_ht = {
 	.radio_write		= b43_phy_ht_op_radio_write,
 	.software_rfkill	= b43_phy_ht_op_software_rfkill,
 	.switch_analog		= b43_phy_ht_op_switch_analog,
-	/*
 	.switch_channel		= b43_phy_ht_op_switch_channel,
-	*/
 	.get_default_chan	= b43_phy_ht_op_get_default_chan,
 	/*
 	.recalc_txpower		= b43_phy_ht_op_recalc_txpower,
-- 
1.7.3.4

