Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:2667 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750915Ab0LXHnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Dec 2010 02:43:16 -0500
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0450376592
	for <linux-wireless@vger.kernel.org>; Fri, 24 Dec 2010 16:43:14 +0900 (JST)
Subject: [PATCH RFC] mac80211: Extend channel to frequency mapping for 802.11j
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 24 Dec 2010 16:44:10 +0900
Message-ID: <20101224074410.16337.90008.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extend channel to frequency mapping for 802.11j Japan 4.9GHz band, according to
IEEE802.11 section 17.3.8.3.2 and Annex J. Because there are now overlapping
channel numbers in the 2GHz and 5GHz band we can't map from channel to
frequency without knowing the band. This is no problem as in most contexts we
know the band. In places where we don't know the band (and WEXT compatibility)
we assume the 2GHz band for channels below 14.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 include/net/cfg80211.h     |    3 ++-
 net/mac80211/ibss.c        |    2 +-
 net/mac80211/mesh.c        |    2 +-
 net/mac80211/mlme.c        |    8 +++++---
 net/mac80211/scan.c        |    3 ++-
 net/wireless/reg.c         |    6 +++---
 net/wireless/util.c        |   36 ++++++++++++++++++++++--------------
 net/wireless/wext-compat.c |    5 ++++-
 8 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bcc9f44..cfaac36 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1788,8 +1788,9 @@ static inline void *wdev_priv(struct wireless_dev *wdev)
 /**
  * ieee80211_channel_to_frequency - convert channel number to frequency
  * @chan: channel number
+ * @band: band, necessary due to channel number overlap
  */
-extern int ieee80211_channel_to_frequency(int chan);
+extern int ieee80211_channel_to_frequency(int chan, enum ieee80211_band band);
 
 /**
  * ieee80211_frequency_to_channel - convert frequency to channel number
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 53c7077..b9d8df1 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -270,7 +270,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	enum ieee80211_band band = rx_status->band;
 
 	if (elems->ds_params && elems->ds_params_len == 1)
-		freq = ieee80211_channel_to_frequency(elems->ds_params[0]);
+		freq = ieee80211_channel_to_frequency(elems->ds_params[0], band);
 	else
 		freq = rx_status->freq;
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index ca3af46..1430cdc 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -574,7 +574,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			       &elems);
 
 	if (elems.ds_params && elems.ds_params_len == 1)
-		freq = ieee80211_channel_to_frequency(elems.ds_params[0]);
+		freq = ieee80211_channel_to_frequency(elems.ds_params[0], band);
 	else
 		freq = rx_status->freq;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 45fbb9e..33bd6d4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -176,7 +176,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 
 	/* check that channel matches the right operating channel */
 	if (local->hw.conf.channel->center_freq !=
-	    ieee80211_channel_to_frequency(hti->control_chan))
+	    ieee80211_channel_to_frequency(hti->control_chan, sband->band))
 		enable_ht = false;
 
 	if (enable_ht) {
@@ -429,7 +429,8 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		container_of((void *)bss, struct cfg80211_bss, priv);
 	struct ieee80211_channel *new_ch;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num);
+	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num,
+						      cbss->channel->band);
 
 	ASSERT_MGD_MTX(ifmgd);
 
@@ -1519,7 +1520,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (elems->ds_params && elems->ds_params_len == 1)
-		freq = ieee80211_channel_to_frequency(elems->ds_params[0]);
+		freq = ieee80211_channel_to_frequency(elems->ds_params[0],
+						      rx_status->band);
 	else
 		freq = rx_status->freq;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index fb274db..1ef73be 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -196,7 +196,8 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	ieee802_11_parse_elems(elements, skb->len - baselen, &elems);
 
 	if (elems.ds_params && elems.ds_params_len == 1)
-		freq = ieee80211_channel_to_frequency(elems.ds_params[0]);
+		freq = ieee80211_channel_to_frequency(elems.ds_params[0],
+						      rx_status->band);
 	else
 		freq = rx_status->freq;
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 99d4183..add7c81 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1801,9 +1801,9 @@ void regulatory_hint_disconnect(void)
 
 static bool freq_is_chan_12_13_14(u16 freq)
 {
-	if (freq == ieee80211_channel_to_frequency(12) ||
-	    freq == ieee80211_channel_to_frequency(13) ||
-	    freq == ieee80211_channel_to_frequency(14))
+	if (freq == ieee80211_channel_to_frequency(12, IEEE80211_BAND_2GHZ) ||
+	    freq == ieee80211_channel_to_frequency(13, IEEE80211_BAND_2GHZ) ||
+	    freq == ieee80211_channel_to_frequency(14, IEEE80211_BAND_2GHZ))
 		return true;
 	return false;
 }
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 7620ae2..4ed065d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -29,29 +29,37 @@ ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
 }
 EXPORT_SYMBOL(ieee80211_get_response_rate);
 
-int ieee80211_channel_to_frequency(int chan)
+int ieee80211_channel_to_frequency(int chan, enum ieee80211_band band)
 {
-	if (chan < 14)
-		return 2407 + chan * 5;
-
-	if (chan == 14)
-		return 2484;
-
-	/* FIXME: 802.11j 17.3.8.3.2 */
-	return (chan + 1000) * 5;
+	/* see 802.11 17.3.8.3.2 and Annex J
+	 * there are overlapping channel numbers in 5GHz and 2GHz bands */
+	if (band == IEEE80211_BAND_5GHZ) {
+		if (chan >= 182 && chan <= 196)
+			return 4000 + chan * 5;
+		else
+			return 5000 + chan * 5;
+	} else { /* IEEE80211_BAND_2GHZ */
+		if (chan == 14)
+			return 2484;
+		else if (chan < 14)
+			return 2407 + chan * 5;
+		else
+			return 0; /* not supported */
+	}
 }
 EXPORT_SYMBOL(ieee80211_channel_to_frequency);
 
 int ieee80211_frequency_to_channel(int freq)
 {
+	/* see 802.11 17.3.8.3.2 and Annex J */
 	if (freq == 2484)
 		return 14;
-
-	if (freq < 2484)
+	else if (freq < 2484)
 		return (freq - 2407) / 5;
-
-	/* FIXME: 802.11j 17.3.8.3.2 */
-	return freq/5 - 1000;
+	else if (freq >= 4910 && freq <= 4980)
+		return (freq - 4000) / 5;
+	else
+		return (freq - 5000) / 5;
 }
 EXPORT_SYMBOL(ieee80211_frequency_to_channel);
 
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 3e5dbd4..b0e18f0 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -267,9 +267,12 @@ int cfg80211_wext_freq(struct wiphy *wiphy, struct iw_freq *freq)
 	 * -EINVAL for impossible things.
 	 */
 	if (freq->e == 0) {
+		int band = IEEE80211_BAND_2GHZ;
 		if (freq->m < 0)
 			return 0;
-		return ieee80211_channel_to_frequency(freq->m);
+		if (freq->m > 14)
+			band = IEEE80211_BAND_5GHZ;
+		return ieee80211_channel_to_frequency(freq->m, band);
 	} else {
 		int i, div = 1000000;
 		for (i = 0; i < freq->e; i++)

