Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:54322 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1D1CIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 22:08:51 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: check firmware capabilities while initialising 5GHz band parameters
Date: Wed, 27 Apr 2011 19:13:11 -0700
Message-Id: <1303956793-17982-1-git-send-email-bzhao@marvell.com> (sfid-20110428_040854_908299_A8A4D4BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

There are some SD8787 cards which don't support 5GHz band.
Therefore initialise 5GHz band parameters only if hardware
supports the band.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b99ae26..5855755 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1235,20 +1235,23 @@ int mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 	wdev->wiphy->max_scan_ssids = 10;
 	wdev->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
+
 	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &mwifiex_band_2ghz;
-	wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = &mwifiex_band_5ghz;
+	mwifiex_setup_ht_caps(
+		&wdev->wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap, priv);
+
+	if (priv->adapter->config_bands & BAND_A) {
+		wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = &mwifiex_band_5ghz;
+		mwifiex_setup_ht_caps(
+			&wdev->wiphy->bands[IEEE80211_BAND_5GHZ]->ht_cap, priv);
+	} else {
+		wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
+	}
 
 	/* Initialize cipher suits */
 	wdev->wiphy->cipher_suites = mwifiex_cipher_suites;
 	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(mwifiex_cipher_suites);
 
-	/* Initialize parameters for 2GHz band */
-
-	mwifiex_setup_ht_caps(&wdev->wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap,
-									priv);
-	mwifiex_setup_ht_caps(&wdev->wiphy->bands[IEEE80211_BAND_5GHZ]->ht_cap,
-									priv);
-
 	memcpy(wdev->wiphy->perm_addr, mac, 6);
 	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
-- 
1.7.0.2

