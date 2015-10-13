Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51722 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbbJMJg4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 05:36:56 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use new cfg80211_inform_bss_frame_data() API
Date: Tue, 13 Oct 2015 11:36:53 +0200
Message-Id: <1444729013-3585-1-git-send-email-johannes@sipsolutions.net> (sfid-20151013_113659_576160_646C9BCB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The new API is more easily extensible with a metadata struct
passed to it, use it in mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c | 11 ++++++-----
 net/mac80211/scan.c | 19 +++++++++----------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 7f72bc9bae2e..bd853e7bde93 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -229,7 +229,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_chan_def chandef;
 	struct ieee80211_channel *chan;
 	struct beacon_data *presp;
-	enum nl80211_bss_scan_width scan_width;
+	struct cfg80211_inform_bss bss_meta = {};
 	bool have_higher_than_11mbit;
 	bool radar_required;
 	int err;
@@ -383,10 +383,11 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	mod_timer(&ifibss->timer,
 		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
 
-	scan_width = cfg80211_chandef_to_scan_width(&chandef);
-	bss = cfg80211_inform_bss_width_frame(local->hw.wiphy, chan,
-					      scan_width, mgmt,
-					      presp->head_len, 0, GFP_KERNEL);
+	bss_meta.chan = chan;
+	bss_meta.scan_width = cfg80211_chandef_to_scan_width(&chandef);
+	bss = cfg80211_inform_bss_frame_data(local->hw.wiphy, &bss_meta, mgmt,
+					     presp->head_len, GFP_KERNEL);
+
 	cfg80211_put_bss(local->hw.wiphy, bss);
 	netif_carrier_on(sdata->dev);
 	cfg80211_ibss_joined(sdata->dev, ifibss->bssid, chan, GFP_KERNEL);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 11d0901ebb7b..a368a1d6caff 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -67,24 +67,23 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	struct cfg80211_bss *cbss;
 	struct ieee80211_bss *bss;
 	int clen, srlen;
-	enum nl80211_bss_scan_width scan_width;
-	s32 signal = 0;
+	struct cfg80211_inform_bss bss_meta = {};
 	bool signal_valid;
 
 	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM))
-		signal = rx_status->signal * 100;
+		bss_meta.signal = rx_status->signal * 100;
 	else if (ieee80211_hw_check(&local->hw, SIGNAL_UNSPEC))
-		signal = (rx_status->signal * 100) / local->hw.max_signal;
+		bss_meta.signal = (rx_status->signal * 100) / local->hw.max_signal;
 
-	scan_width = NL80211_BSS_CHAN_WIDTH_20;
+	bss_meta.scan_width = NL80211_BSS_CHAN_WIDTH_20;
 	if (rx_status->flag & RX_FLAG_5MHZ)
-		scan_width = NL80211_BSS_CHAN_WIDTH_5;
+		bss_meta.scan_width = NL80211_BSS_CHAN_WIDTH_5;
 	if (rx_status->flag & RX_FLAG_10MHZ)
-		scan_width = NL80211_BSS_CHAN_WIDTH_10;
+		bss_meta.scan_width = NL80211_BSS_CHAN_WIDTH_10;
 
-	cbss = cfg80211_inform_bss_width_frame(local->hw.wiphy, channel,
-					       scan_width, mgmt, len, signal,
-					       GFP_ATOMIC);
+	bss_meta.chan = channel;
+	cbss = cfg80211_inform_bss_frame_data(local->hw.wiphy, &bss_meta,
+					      mgmt, len, GFP_ATOMIC);
 	if (!cbss)
 		return NULL;
 	/* In case the signal is invalid update the status */
-- 
2.5.1

