Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45613 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaGHNLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2014 09:11:41 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so959281wib.16
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2014 06:11:39 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 7/7] b43: enable radio 0x2057 rev 9 (AKA BCM43228) support
Date: Tue,  8 Jul 2014 15:11:10 +0200
Message-Id: <1404825070-5243-7-git-send-email-zajec5@gmail.com> (sfid-20140708_151145_614917_EFC67F8A)
In-Reply-To: <1404825070-5243-1-git-send-email-zajec5@gmail.com>
References: <1404825070-5243-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support for N-PHY rev 8 with 0x2057 rev 5 is almost ready, but we still
need to figure out how to handle rev 9 first.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 6a0c8b6..8aeef10 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -210,6 +210,9 @@ static struct ieee80211_channel b43_2ghz_chantable[] = {
 	CHAN2G(13, 2472, 0),
 	CHAN2G(14, 2484, 0),
 };
+
+/* No support for the last 3 channels (12, 13, 14) */
+#define b43_2ghz_chantable_limited_size		11
 #undef CHAN2G
 
 #define CHAN4G(_channel, _flags) {				\
@@ -335,6 +338,14 @@ static struct ieee80211_supported_band b43_band_2GHz = {
 	.n_bitrates	= b43_g_ratetable_size,
 };
 
+static struct ieee80211_supported_band b43_band_2ghz_limited = {
+	.band		= IEEE80211_BAND_2GHZ,
+	.channels	= b43_2ghz_chantable,
+	.n_channels	= b43_2ghz_chantable_limited_size,
+	.bitrates	= b43_g_ratetable,
+	.n_bitrates	= b43_g_ratetable_size,
+};
+
 static void b43_wireless_core_exit(struct b43_wldev *dev);
 static int b43_wireless_core_init(struct b43_wldev *dev);
 static struct b43_wldev * b43_wireless_core_stop(struct b43_wldev *dev);
@@ -4459,7 +4470,10 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_N:
-		if (radio_ver != 0x2055 && radio_ver != 0x2056)
+		if (radio_ver != 0x2055 && radio_ver != 0x2056 &&
+		    radio_ver != 0x2057)
+			unsupported = 1;
+		if (radio_ver == 0x2057 && !(radio_rev == 9))
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_LP:
@@ -5095,9 +5109,15 @@ static int b43_setup_bands(struct b43_wldev *dev,
 			   bool have_2ghz_phy, bool have_5ghz_phy)
 {
 	struct ieee80211_hw *hw = dev->wl->hw;
+	struct b43_phy *phy = &dev->phy;
+	bool limited_2g;
+
+	/* We don't support all 2 GHz channels on some devices */
+	limited_2g = phy->radio_ver == 0x2057 && phy->radio_rev == 9;
 
 	if (have_2ghz_phy)
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &b43_band_2GHz;
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = limited_2g ?
+			&b43_band_2ghz_limited : &b43_band_2GHz;
 	if (dev->phy.type == B43_PHYTYPE_N) {
 		if (have_5ghz_phy)
 			hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &b43_band_5GHz_nphy;
-- 
1.8.4.5

