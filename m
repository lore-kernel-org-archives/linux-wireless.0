Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:59174 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaGWQzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 12:55:01 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so1440600wes.7
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2014 09:54:58 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: register limited amount of 5G channels for BCM43228
Date: Wed, 23 Jul 2014 18:54:49 +0200
Message-Id: <1406134490-6880-2-git-send-email-zajec5@gmail.com> (sfid-20140723_185506_442278_8A25F7D0)
In-Reply-To: <1406134490-6880-1-git-send-email-zajec5@gmail.com>
References: <1406134490-6880-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't have all needed channel tables due to RE process for this
device.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 47b6fa5..3b4b192 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -290,6 +290,14 @@ static struct ieee80211_channel b43_5ghz_nphy_chantable[] = {
 	CHAN5G(182, 0),
 };
 
+static struct ieee80211_channel b43_5ghz_nphy_chantable_limited[] = {
+	CHAN5G(36, 0),		CHAN5G(40, 0),
+	CHAN5G(44, 0),		CHAN5G(48, 0),
+	CHAN5G(149, 0),		CHAN5G(153, 0),
+	CHAN5G(157, 0),		CHAN5G(161, 0),
+	CHAN5G(165, 0),
+};
+
 static struct ieee80211_channel b43_5ghz_aphy_chantable[] = {
 	CHAN5G(34, 0),		CHAN5G(36, 0),
 	CHAN5G(38, 0),		CHAN5G(40, 0),
@@ -322,6 +330,14 @@ static struct ieee80211_supported_band b43_band_5GHz_nphy = {
 	.n_bitrates	= b43_a_ratetable_size,
 };
 
+static struct ieee80211_supported_band b43_band_5GHz_nphy_limited = {
+	.band		= IEEE80211_BAND_5GHZ,
+	.channels	= b43_5ghz_nphy_chantable_limited,
+	.n_channels	= ARRAY_SIZE(b43_5ghz_nphy_chantable_limited),
+	.bitrates	= b43_a_ratetable,
+	.n_bitrates	= b43_a_ratetable_size,
+};
+
 static struct ieee80211_supported_band b43_band_5GHz_aphy = {
 	.band		= IEEE80211_BAND_5GHZ,
 	.channels	= b43_5ghz_aphy_chantable,
@@ -5155,17 +5171,22 @@ static int b43_setup_bands(struct b43_wldev *dev,
 	struct ieee80211_hw *hw = dev->wl->hw;
 	struct b43_phy *phy = &dev->phy;
 	bool limited_2g;
+	bool limited_5g;
 
 	/* We don't support all 2 GHz channels on some devices */
 	limited_2g = phy->radio_ver == 0x2057 &&
 		     (phy->radio_rev == 9 || phy->radio_rev == 14);
+	limited_5g = phy->radio_ver == 0x2057 &&
+		     phy->radio_rev == 9;
 
 	if (have_2ghz_phy)
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = limited_2g ?
 			&b43_band_2ghz_limited : &b43_band_2GHz;
 	if (dev->phy.type == B43_PHYTYPE_N) {
 		if (have_5ghz_phy)
-			hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &b43_band_5GHz_nphy;
+			hw->wiphy->bands[IEEE80211_BAND_5GHZ] = limited_5g ?
+				&b43_band_5GHz_nphy_limited :
+				&b43_band_5GHz_nphy;
 	} else {
 		if (have_5ghz_phy)
 			hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &b43_band_5GHz_aphy;
-- 
1.8.4.5

