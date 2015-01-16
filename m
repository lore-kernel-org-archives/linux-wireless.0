Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:56477 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbbAPKqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 05:46:48 -0500
Received: by mail-we0-f178.google.com with SMTP id p10so19508217wes.9
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 02:46:47 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFCv2 4/6] mac80211: IBSS fix scan request
Date: Fri, 16 Jan 2015 11:38:42 +0100
Message-Id: <1421404724-32326-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150116_114702_750704_EC691337)
In-Reply-To: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of wide bandwidth (HT40/VHT80/VHT160) scan
all channels we have in chandef, not only control one.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/ibss.c        | 61 ++++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/ieee80211_i.h |  3 ++-
 net/mac80211/scan.c        | 25 ++++++++++++-------
 3 files changed, 77 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 1ffcfab..b1e9e9b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1289,7 +1289,7 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 
 	scan_width = cfg80211_chandef_to_scan_width(&ifibss->chandef);
 	ieee80211_request_ibss_scan(sdata, ifibss->ssid, ifibss->ssid_len,
-				    NULL, scan_width);
+				    NULL, 0, scan_width);
 }
 
 static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
@@ -1328,6 +1328,56 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 				  capability, 0, true);
 }
 
+static unsigned int
+ieee80211_ibss_setup_scan_channels(struct wiphy *wiphy,
+				   const struct cfg80211_chan_def *chandef,
+				   struct ieee80211_channel **channels,
+				   unsigned int channels_max)
+{
+	struct ieee80211_channel *chan = NULL;
+	unsigned int n_chan = 0;
+	u32 start_freq, end_freq, width, center_freq, freq;
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_40:
+		width = 40;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
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
+	center_freq = chandef->center_freq1;
+
+	if (width <= 20) {
+		start_freq = center_freq;
+		end_freq = center_freq;
+	} else {
+		start_freq = center_freq - width/2 + 10;
+		end_freq = center_freq + width/2 - 10;
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
 /*
  * This function is called with state == IEEE80211_IBSS_MLME_SEARCH
  */
@@ -1397,11 +1447,18 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	/* Selected IBSS not found in current scan results - try to scan */
 	if (time_after(jiffies, ifibss->last_scan_completed +
 					IEEE80211_SCAN_INTERVAL)) {
+		struct ieee80211_channel *channels[8];
+		unsigned int num = 0;
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
index 95ce152..05d3af5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1556,7 +1556,8 @@ int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata);
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
index 7807fa4..18730b97 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -923,11 +923,12 @@ int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 
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
@@ -937,9 +938,8 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 		goto unlock;
 
 	/* fill internal scan request */
-	if (!chan) {
-		int i, max_n;
-		int n_ch = 0;
+	if (!channels) {
+		int max_n;
 
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 			if (!local->hw.wiphy->bands[band])
@@ -964,12 +964,19 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 
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

