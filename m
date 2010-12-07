Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46990 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab0LGU4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 15:56:48 -0500
Received: by wwi17 with SMTP id 17so1365435wwi.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 12:56:46 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/4] b43: set TMS to work with current band width for N-PHY
Date: Tue,  7 Dec 2010 21:55:58 +0100
Message-Id: <1291755360-21570-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c       |    6 ++++++
 drivers/net/wireless/b43/phy_common.c |    7 +++++++
 drivers/net/wireless/b43/phy_common.h |    2 ++
 drivers/net/wireless/b43/phy_n.c      |    7 -------
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index fa48803..670fd7b 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1150,6 +1150,12 @@ void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags)
 
 	flags |= B43_TMSLOW_PHYCLKEN;
 	flags |= B43_TMSLOW_PHYRESET;
+	if (dev->phy.type == B43_PHYTYPE_N) {
+		if (b43_channel_type_is_40mhz(dev->phy.channel_type))
+			flags |= B43_TMSLOW_PHYCLKSPEED_160MHZ;
+		else
+			flags |= B43_TMSLOW_PHYCLKSPEED_80MHZ;
+	}
 	ssb_device_enable(dev->dev, flags);
 	msleep(2);		/* Wait for the PLL to turn on. */
 
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 0a91fc3..412f1b6 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -429,6 +429,13 @@ void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on)
 	b43_write16(dev, B43_MMIO_PHY0, on ? 0 : 0xF4);
 }
 
+
+bool b43_channel_type_is_40mhz(enum nl80211_channel_type channel_type)
+{
+	return (channel_type == NL80211_CHAN_HT40MINUS ||
+		channel_type == NL80211_CHAN_HT40PLUS);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/Cordic */
 struct b43_c32 b43_cordic(int theta)
 {
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 2ed60e5..2401bee 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -436,6 +436,8 @@ int b43_phy_shm_tssi_read(struct b43_wldev *dev, u16 shm_offset);
  */
 void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on);
 
+bool b43_channel_type_is_40mhz(enum nl80211_channel_type channel_type);
+
 struct b43_c32 b43_cordic(int theta);
 
 #endif /* LINUX_B43_PHY_COMMON_H_ */
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d41da7f..3517341 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -88,13 +88,6 @@ static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
 static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
 						u16 value, u8 core);
 
-static inline bool b43_channel_type_is_40mhz(
-					enum nl80211_channel_type channel_type)
-{
-	return (channel_type == NL80211_CHAN_HT40MINUS ||
-		channel_type == NL80211_CHAN_HT40PLUS);
-}
-
 void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
 {//TODO
 }
-- 
1.6.3.3

