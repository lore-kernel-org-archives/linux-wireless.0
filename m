Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab2GXPgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 11:36:10 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: arend@broadcom.com, brcm80211-dev-list@broadcom.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] brcmsmac: use ieee80211_channel_to_frequency
Date: Tue, 24 Jul 2012 17:35:57 +0200
Message-Id: <1343144157-8349-1-git-send-email-johannes@sipsolutions.net> (sfid-20120724_173614_692844_D7D2D8B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of hard-coding almost the same functionality,
just use ieee80211_channel_to_frequency() directly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c      |   13 ++++---------
 drivers/net/wireless/brcm80211/include/brcmu_wifi.h |    5 -----
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index f36dabc..32ef2ed 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7512,15 +7512,10 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 
 	channel = BRCMS_CHAN_CHANNEL(rxh->RxChan);
 
-	if (channel > 14) {
-		rx_status->band = IEEE80211_BAND_5GHZ;
-		rx_status->freq = ieee80211_ofdm_chan_to_freq(
-					WF_CHAN_FACTOR_5_G/2, channel);
-
-	} else {
-		rx_status->band = IEEE80211_BAND_2GHZ;
-		rx_status->freq = ieee80211_dsss_chan_to_freq(channel);
-	}
+	rx_status->band =
+		channel > 14 ? IEEE80211_BAND_5GHZ : IEEE80211_BAND_2GHZ;
+	rx_status->freq =
+		ieee80211_channel_to_frequency(channel, rx_status->band);
 
 	rx_status->signal = wlc_phy_rssi_compute(wlc->hw->band->pi, rxh);
 
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
index f10d302..c11a290 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
@@ -67,11 +67,6 @@
 #define WL_CHANSPEC_BAND_2G		0x2000
 #define INVCHANSPEC			255
 
-/* used to calculate the chan_freq = chan_factor * 500Mhz + 5 * chan_number */
-#define WF_CHAN_FACTOR_2_4_G		4814	/* 2.4 GHz band, 2407 MHz */
-#define WF_CHAN_FACTOR_5_G		10000	/* 5   GHz band, 5000 MHz */
-#define WF_CHAN_FACTOR_4_G		8000	/* 4.9 GHz band for Japan */
-
 #define CHSPEC_CHANNEL(chspec)	((u8)((chspec) & WL_CHANSPEC_CHAN_MASK))
 #define CHSPEC_BAND(chspec)	((chspec) & WL_CHANSPEC_BAND_MASK)
 
-- 
1.7.10.4

