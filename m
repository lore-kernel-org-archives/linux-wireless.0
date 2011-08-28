Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58645 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1H1MY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 08:24:26 -0400
Received: by fxh19 with SMTP id 19so3680946fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 05:24:25 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 3/3] b43: LCN-PHY: prepare functions for channel switching
Date: Sun, 28 Aug 2011 14:59:58 +0200
Message-Id: <1314536398-3056-3-git-send-email-zajec5@gmail.com> (sfid-20110828_142431_618023_CFFCFCD2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Switching is not fully implemented yet, prepare place for the code.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: s/2059/2064/ (correct radio ID)
---
 drivers/net/wireless/b43/phy_lcn.c |   86 +++++++++++++++++++++++++++++++++++-
 1 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 9707a2b..7b20a47 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -31,6 +31,48 @@
  * Radio 2064.
  **************************************************/
 
+static void b43_radio_2064_channel_setup(struct b43_wldev *dev)
+{
+	u16 save[2];
+
+	b43_radio_set(dev, 0x09d, 0x4);
+	b43_radio_write(dev, 0x09e, 0xf);
+
+	b43_radio_write(dev, 0x02a, 0xb);
+	b43_radio_maskset(dev, 0x030, ~0x3, 0xa);
+	b43_radio_maskset(dev, 0x091, ~0x3, 0);
+	b43_radio_maskset(dev, 0x038, ~0xf, 0x7);
+	b43_radio_maskset(dev, 0x030, ~0xc, 0x8);
+	b43_radio_maskset(dev, 0x05e, ~0xf, 0x8);
+	b43_radio_maskset(dev, 0x05e, ~0xf0, 0x80);
+	b43_radio_write(dev, 0x06c, 0x80);
+
+	save[0] = b43_radio_read(dev, 0x044);
+	save[1] = b43_radio_read(dev, 0x12b);
+
+	b43_radio_set(dev, 0x044, 0x7);
+	b43_radio_set(dev, 0x12b, 0xe);
+
+	/* TODO */
+
+	b43_radio_write(dev, 0x040, 0xfb);
+
+	b43_radio_write(dev, 0x041, 0x9a);
+	b43_radio_write(dev, 0x042, 0xa3);
+	b43_radio_write(dev, 0x043, 0x0c);
+
+	/* TODO */
+
+	b43_radio_set(dev, 0x044, 0x0c);
+	udelay(1);
+
+	b43_radio_write(dev, 0x044, save[0]);
+	b43_radio_write(dev, 0x12b, save[1]);
+
+	b43_radio_write(dev, 0x038, 0x0);
+	b43_radio_write(dev, 0x091, 0x7);
+}
+
 static void b43_radio_2064_init(struct b43_wldev *dev)
 {
 	b43_radio_write(dev, 0x09c, 0x0020);
@@ -172,6 +214,32 @@ static void b43_phy_lcn_pre_radio_init(struct b43_wldev *dev)
 }
 
 /**************************************************
+ * Channel switching ops.
+ **************************************************/
+
+static int b43_phy_lcn_set_channel(struct b43_wldev *dev,
+				   struct ieee80211_channel *channel,
+				   enum nl80211_channel_type channel_type)
+{
+	/* TODO: PLL and PHY ops */
+
+	b43_phy_set(dev, 0x44a, 0x44);
+	b43_phy_write(dev, 0x44a, 0x80);
+
+	b43_phy_set(dev, 0x44a, 0x44);
+	b43_phy_write(dev, 0x44a, 0x80);
+
+	b43_radio_2064_channel_setup(dev);
+	mdelay(1);
+
+	b43_phy_lcn_afe_set_unset(dev);
+
+	/* TODO */
+
+	return 0;
+}
+
+/**************************************************
  * Basic PHY ops.
  **************************************************/
 
@@ -265,6 +333,22 @@ static void b43_phy_lcn_op_switch_analog(struct b43_wldev *dev, bool on)
 	}
 }
 
+static int b43_phy_lcn_op_switch_channel(struct b43_wldev *dev,
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
+	return b43_phy_lcn_set_channel(dev, channel, channel_type);
+}
+
 static unsigned int b43_phy_lcn_op_get_default_chan(struct b43_wldev *dev)
 {
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
@@ -338,9 +422,7 @@ const struct b43_phy_operations b43_phyops_lcn = {
 	.radio_write		= b43_phy_lcn_op_radio_write,
 	.software_rfkill	= b43_phy_lcn_op_software_rfkill,
 	.switch_analog		= b43_phy_lcn_op_switch_analog,
-	/*
 	.switch_channel		= b43_phy_lcn_op_switch_channel,
-	*/
 	.get_default_chan	= b43_phy_lcn_op_get_default_chan,
 	.recalc_txpower		= b43_phy_lcn_op_recalc_txpower,
 	.adjust_txpower		= b43_phy_lcn_op_adjust_txpower,
-- 
1.7.3.4

