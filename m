Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33350 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbcCJSI7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 13:08:59 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH-v2] mac80211:  Let VHT work on 2.4Ghz
Date: Thu, 10 Mar 2016 10:08:56 -0800
Message-Id: <1457633336-27898-1-git-send-email-greearb@candelatech.com> (sfid-20160310_190902_829467_89940599)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

ath10k supports VHT on 2.4Ghz band.
If supplicant and hostapd and radio think
VHT should be allowed, then kernel should let them
try, as long as at least one band can do 80Mhz.

If no bands can do 80Mhz, then that is an indication that
VHT is not enabled in this regulatory domain.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v2:  Only allow VHT on 2.4 if 80Mhz is available on at least one band.

 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 15 +--------------
 net/mac80211/util.c        | 33 +++++++++++++++++++++++----------
 net/mac80211/vht.c         | 15 ++-------------
 4 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 19de36f..c0dc0e2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1800,6 +1800,7 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 }
 
 /* utility functions/constants */
+bool ieee80211_any_band_supports_80mhz(struct ieee80211_local *local);
 extern const void *const mac80211_wiphy_privid; /* for wiphy privid */
 int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
 			     int rate, int erp, int short_preamble,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b63cd7d..d6e9bdc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4228,8 +4228,6 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband;
 	struct cfg80211_chan_def chandef;
 	int ret;
-	u32 i;
-	bool have_80mhz;
 
 	sband = local->hw.wiphy->bands[cbss->channel->band];
 
@@ -4280,18 +4278,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	/* Allow VHT if at least one channel on the sband supports 80 MHz */
-	have_80mhz = false;
-	for (i = 0; i < sband->n_channels; i++) {
-		if (sband->channels[i].flags & (IEEE80211_CHAN_DISABLED |
-						IEEE80211_CHAN_NO_80MHZ))
-			continue;
-
-		have_80mhz = true;
-		break;
-	}
-
-	if (!have_80mhz)
+	if (!ieee80211_any_band_supports_80mhz(local))
 		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
 
 	ifmgd->flags |= ieee80211_determine_chantype(sdata, sband,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 56b2c27..ae90c4f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -762,6 +762,27 @@ void ieee80211_queue_delayed_work(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_queue_delayed_work);
 
+bool ieee80211_any_band_supports_80mhz(struct ieee80211_local *local)
+{
+	int i;
+	struct ieee80211_supported_band *sband;
+
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		int q;
+		sband = local->hw.wiphy->bands[i];
+		if (!sband)
+			continue;
+		for (q = 0; q < sband->n_channels; q++) {
+			if (sband->channels[q].flags &
+			    (IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_NO_80MHZ))
+				continue;
+
+			return true;
+		}
+	}
+	return false;
+}
+
 u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc)
@@ -1375,7 +1396,7 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 	int ext_rates_len;
 	int shift;
 	u32 rate_flags;
-	bool have_80mhz = false;
+	bool have_80mhz;
 
 	*offset = 0;
 
@@ -1504,15 +1525,7 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
 		*offset = noffset;
 	}
 
-	/* Check if any channel in this sband supports at least 80 MHz */
-	for (i = 0; i < sband->n_channels; i++) {
-		if (sband->channels[i].flags & (IEEE80211_CHAN_DISABLED |
-						IEEE80211_CHAN_NO_80MHZ))
-			continue;
-
-		have_80mhz = true;
-		break;
-	}
+	have_80mhz = ieee80211_any_band_supports_80mhz(local);
 
 	if (sband->vht_cap.vht_supported && have_80mhz) {
 		if (end - pos < 2 + sizeof(struct ieee80211_vht_cap))
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index c38b2f0..a08a77f 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -120,7 +120,7 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->sta.vht_cap;
 	struct ieee80211_sta_vht_cap own_cap;
 	u32 cap_info, i;
-	bool have_80mhz;
+	struct ieee80211_local *local = sdata->local;
 
 	memset(vht_cap, 0, sizeof(*vht_cap));
 
@@ -130,18 +130,7 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	if (!vht_cap_ie || !sband->vht_cap.vht_supported)
 		return;
 
-	/* Allow VHT if at least one channel on the sband supports 80 MHz */
-	have_80mhz = false;
-	for (i = 0; i < sband->n_channels; i++) {
-		if (sband->channels[i].flags & (IEEE80211_CHAN_DISABLED |
-						IEEE80211_CHAN_NO_80MHZ))
-			continue;
-
-		have_80mhz = true;
-		break;
-	}
-
-	if (!have_80mhz)
+	if (!ieee80211_any_band_supports_80mhz(local))
 		return;
 
 	/*
-- 
2.4.3

