Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33254 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbbCTFi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 01:38:27 -0400
Received: by lbbrr9 with SMTP id rr9so3468850lbb.0
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2015 22:38:25 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCHv3 1/2] mac80211: IBSS fix scan request
Date: Fri, 20 Mar 2015 06:37:00 +0100
Message-Id: <1426829821-5001-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150320_063831_604841_7F510A2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of wide bandwidth (wider than 20MHz) used by IBSS,
scan all channels in chandef to be able to find neighboring
IBSS netwqworks that use the same overall channels but a different
control channel.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ibss.c        | 81 ++++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/ieee80211_i.h |  3 +-
 net/mac80211/scan.c        | 25 ++++++++------
 3 files changed, 97 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index dec24d4..0d95a44 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1272,7 +1272,7 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 
 	scan_width = cfg80211_chandef_to_scan_width(&ifibss->chandef);
 	ieee80211_request_ibss_scan(sdata, ifibss->ssid, ifibss->ssid_len,
-				    NULL, scan_width);
+				    NULL, 0, scan_width);
 }
 
 static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
@@ -1311,6 +1311,76 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 				  capability, 0, true);
 }
 
+static unsigned ibss_setup_channels(struct wiphy *wiphy,
+				    struct ieee80211_channel **channels,
+				    unsigned int channels_max,
+				    u32 center_freq, u32 width)
+{
+	struct ieee80211_channel *chan = NULL;
+	unsigned int n_chan = 0;
+	u32 start_freq, end_freq, freq;
+
+	if (width <= 20) {
+		start_freq = center_freq;
+		end_freq = center_freq;
+	} else {
+		start_freq = center_freq - width / 2 + 10;
+		end_freq = center_freq + width / 2 - 10;
+	}
+
+	for (freq = start_freq; freq <= end_freq; freq += 20) {
+		chan = ieee80211_get_channel(wiphy, freq);
+		if (!chan)
+			continue;
+		if (n_chan >= channels_max)
+			return n_chan;
+
+		channels[n_chan] = chan;
+		n_chan++;
+	}
+
+	return n_chan;
+}
+
+static unsigned int
+ieee80211_ibss_setup_scan_channels(struct wiphy *wiphy,
+				   const struct cfg80211_chan_def *chandef,
+				   struct ieee80211_channel **channels,
+				   unsigned int channels_max)
+{
+	unsigned int n_chan = 0;
+	u32 width, cf1, cf2 = 0;
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_40:
+		width = 40;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+		cf2 = chandef->center_freq2;
+		/* fall through */
+	case NL80211_CHAN_WIDTH_80:
+		width = 80;
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		width = 160;
+		break;
+	default:
+		width = 20;
+		break;
+	}
+
+	cf1 = chandef->center_freq1;
+
+	n_chan = ibss_setup_channels(wiphy, channels, channels_max, cf1, width);
+
+	if (cf2)
+		n_chan += ibss_setup_channels(wiphy, &channels[n_chan],
+					      channels_max - n_chan, cf2,
+					      width);
+
+	return n_chan;
+}
+
 /*
  * This function is called with state == IEEE80211_IBSS_MLME_SEARCH
  */
@@ -1376,11 +1446,18 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	/* Selected IBSS not found in current scan results - try to scan */
 	if (time_after(jiffies, ifibss->last_scan_completed +
 					IEEE80211_SCAN_INTERVAL)) {
+		struct ieee80211_channel *channels[8];
+		unsigned int num;
+
 		sdata_info(sdata, "Trigger new scan to find an IBSS to join\n");
 
+		num = ieee80211_ibss_setup_scan_channels(local->hw.wiphy,
+							 &ifibss->chandef,
+							 channels,
+							 ARRAY_SIZE(channels));
 		scan_width = cfg80211_chandef_to_scan_width(&ifibss->chandef);
 		ieee80211_request_ibss_scan(sdata, ifibss->ssid,
-					    ifibss->ssid_len, chan,
+					    ifibss->ssid_len, channels, num,
 					    scan_width);
 	} else {
 		int interval = IEEE80211_SCAN_INTERVAL;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0266c57..627c701 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1532,7 +1532,8 @@ int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata);
 void ieee80211_scan_work(struct work_struct *work);
 int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 				const u8 *ssid, u8 ssid_len,
-				struct ieee80211_channel *chan,
+				struct ieee80211_channel **channels,
+				unsigned int n_channels,
 				enum nl80211_bss_scan_width scan_width);
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_scan_request *req);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 05f0d71..7bb6a93 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -928,11 +928,12 @@ int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 
 int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 				const u8 *ssid, u8 ssid_len,
-				struct ieee80211_channel *chan,
+				struct ieee80211_channel **channels,
+				unsigned int n_channels,
 				enum nl80211_bss_scan_width scan_width)
 {
 	struct ieee80211_local *local = sdata->local;
-	int ret = -EBUSY;
+	int ret = -EBUSY, i, n_ch = 0;
 	enum ieee80211_band band;
 
 	mutex_lock(&local->mtx);
@@ -942,9 +943,8 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 		goto unlock;
 
 	/* fill internal scan request */
-	if (!chan) {
-		int i, max_n;
-		int n_ch = 0;
+	if (!channels) {
+		int max_n;
 
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 			if (!local->hw.wiphy->bands[band])
@@ -969,12 +969,19 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 
 		local->int_scan_req->n_channels = n_ch;
 	} else {
-		if (WARN_ON_ONCE(chan->flags & (IEEE80211_CHAN_NO_IR |
-						IEEE80211_CHAN_DISABLED)))
+		for (i = 0; i < n_channels; i++) {
+			if (channels[i]->flags & (IEEE80211_CHAN_NO_IR |
+						  IEEE80211_CHAN_DISABLED))
+				continue;
+
+			local->int_scan_req->channels[n_ch] = channels[i];
+			n_ch++;
+		}
+
+		if (WARN_ON_ONCE(n_ch == 0))
 			goto unlock;
 
-		local->int_scan_req->channels[0] = chan;
-		local->int_scan_req->n_channels = 1;
+		local->int_scan_req->n_channels = n_ch;
 	}
 
 	local->int_scan_req->ssids = &local->scan_ssid;
-- 
1.9.1

