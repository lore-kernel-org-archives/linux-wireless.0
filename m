Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63422 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2GDP7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 11:59:00 -0400
Received: by mail-we0-f174.google.com with SMTP id b14so4517616wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2012 08:59:00 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [RFC 2/4] cfg80211: support unused HT-cap-per-band configuration
Date: Wed,  4 Jul 2012 18:58:48 +0300
Message-Id: <1341417530-9062-3-git-send-email-arik@wizery.com> (sfid-20120704_175906_891967_EF052DFB)
In-Reply-To: <1341417530-9062-1-git-send-email-arik@wizery.com>
References: <1341417530-9062-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow drivers not to use the HT capabilities given per band in struct
wiphy. This can be indicated by setting ht_cap_invalid to true for the
wiphy.

In any case the band will contain a boolean value indicating if HT is
supported.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/cfg80211.h     |   14 ++++++++++++--
 net/wireless/chan.c        |   10 +++++++---
 net/wireless/core.c        |    3 ++-
 net/wireless/wext-compat.c |    4 ++--
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0b564e8..7b24d88 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -205,8 +205,8 @@ struct ieee80211_rate {
  * @mcs: Supported MCS rates
  */
 struct ieee80211_sta_ht_cap {
+	bool ht_supported; /* this must be first */
 	u16 cap; /* use IEEE80211_HT_CAP_ */
-	bool ht_supported;
 	u8 ampdu_factor;
 	u8 ampdu_density;
 	struct ieee80211_mcs_info mcs;
@@ -243,6 +243,12 @@ struct ieee80211_sta_vht_cap {
  *	rates" IE, i.e. CCK rates first, then OFDM.
  * @n_bitrates: Number of bitrates in @bitrates
  * @ht_cap: HT capabilities in this band
+ * @ht_supported: Gives general HT support status in case HT capabilities
+ *	are set per &struct net_device, and @ht_cap is not used.
+ * @ht_cap_invalid: Indicates the @ht_cap field of the band is not used.
+ *	This should be set for devices implementing the get_ht_cap() op
+ *	for changing the HT capabilities per interface.
+ * @vht_cap: VHT capabilities in this band
  */
 struct ieee80211_supported_band {
 	struct ieee80211_channel *channels;
@@ -250,7 +256,11 @@ struct ieee80211_supported_band {
 	enum ieee80211_band band;
 	int n_channels;
 	int n_bitrates;
-	struct ieee80211_sta_ht_cap ht_cap;
+	union {
+		struct ieee80211_sta_ht_cap ht_cap;
+		bool ht_supported;
+	};
+	bool ht_cap_invalid;
 	struct ieee80211_sta_vht_cap vht_cap;
 };
 
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 434c56b..09b0012 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -16,6 +16,7 @@ rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 {
 	struct ieee80211_channel *chan;
 	struct ieee80211_sta_ht_cap *ht_cap;
+	struct ieee80211_supported_band *sband;
 
 	chan = ieee80211_get_channel(&rdev->wiphy, freq);
 
@@ -30,13 +31,16 @@ rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 		 chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
 		return NULL;
 
-	ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
+	sband = rdev->wiphy.bands[chan->band];
+	ht_cap = &sband->ht_cap;
 
 	if (channel_type != NL80211_CHAN_NO_HT) {
-		if (!ht_cap->ht_supported)
+		if (!sband->ht_supported)
 			return NULL;
 
-		if (channel_type != NL80211_CHAN_HT20 &&
+		/* this check is ignored when per-band HT caps are not used */
+		if (!sband->ht_cap_invalid &&
+		    channel_type != NL80211_CHAN_HT20 &&
 		    (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
 		    ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT))
 			return NULL;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index e13365f..f8c48e6 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -482,10 +482,11 @@ int wiphy_register(struct wiphy *wiphy)
 		 * Since cfg80211_disable_40mhz_24ghz is global, we can
 		 * modify the sband's ht data even if the driver uses a
 		 * global structure for that.
+		 * Don't do anything if the driver uses per-vif HT caps.
 		 */
 		if (cfg80211_disable_40mhz_24ghz &&
 		    band == IEEE80211_BAND_2GHZ &&
-		    sband->ht_cap.ht_supported) {
+		    sband->ht_cap.ht_supported && !sband->ht_cap_invalid) {
 			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
 		}
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 7df42f5..f3781ef 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -34,7 +34,7 @@ int cfg80211_wext_giwname(struct net_device *dev,
 	sband = wdev->wiphy->bands[IEEE80211_BAND_5GHZ];
 	if (sband) {
 		is_a = true;
-		is_ht |= sband->ht_cap.ht_supported;
+		is_ht |= sband->ht_supported;
 	}
 
 	sband = wdev->wiphy->bands[IEEE80211_BAND_2GHZ];
@@ -47,7 +47,7 @@ int cfg80211_wext_giwname(struct net_device *dev,
 			if (sband->bitrates[i].bitrate == 60)
 				is_g = true;
 		}
-		is_ht |= sband->ht_cap.ht_supported;
+		is_ht |= sband->ht_supported;
 	}
 
 	strcpy(name, "IEEE 802.11");
-- 
1.7.9.5

