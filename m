Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39106 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab2GaLoH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:44:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/10] mac80211: pass channel to ieee80211_send_probe_req
Date: Tue, 31 Jul 2012 13:43:57 +0200
Message-Id: <1343735038-16030-10-git-send-email-johannes@sipsolutions.net> (sfid-20120731_134432_943139_7387BEB6)
In-Reply-To: <1343735038-16030-1-git-send-email-johannes@sipsolutions.net>
References: <1343735038-16030-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In multi-channel scenarios, the channel that we will
transmit a probe request on isn't always the current
channel (which will be NULL anyway) but will instead
be the channel that the AP is on. Pass the channel
to the ieee80211_send_probe_req() function so it can
be used in the different scenarios. The scan code
continues to pass the current channel, of course.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/mlme.c        |    6 ++++--
 net/mac80211/scan.c        |    3 ++-
 net/mac80211/util.c        |    6 +++---
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 412be9e..22d1e79 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1468,7 +1468,8 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len,
-			      u32 ratemask, bool directed, bool no_cck);
+			      u32 ratemask, bool directed, bool no_cck,
+			      struct ieee80211_channel *channel);
 
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 				  const size_t supp_rates_len,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c416a08..84d12e2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1580,7 +1580,8 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 			ssid_len = ssid[1];
 
 		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid_len, NULL,
-					 0, (u32) -1, true, false);
+					 0, (u32) -1, true, false,
+					 ifmgd->associated->channel);
 	}
 
 	ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
@@ -2713,7 +2714,8 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 		 * will not answer to direct packet in unassociated state.
 		 */
 		ieee80211_send_probe_req(sdata, NULL, ssidie + 2, ssidie[1],
-					 NULL, 0, (u32) -1, true, false);
+					 NULL, 0, (u32) -1, true, false,
+					 auth_data->bss->channel);
 	}
 
 	auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 0045869..14bf0b5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -417,7 +417,8 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 			local->scan_req->ssids[i].ssid_len,
 			local->scan_req->ie, local->scan_req->ie_len,
 			local->scan_req->rates[band], false,
-			local->scan_req->no_cck);
+			local->scan_req->no_cck,
+			local->hw.conf.channel);
 
 	/*
 	 * After sending probe requests, wait for probe responses
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a77ea17..73dc601 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1160,12 +1160,12 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len,
-			      u32 ratemask, bool directed, bool no_cck)
+			      u32 ratemask, bool directed, bool no_cck,
+			      struct ieee80211_channel *channel)
 {
 	struct sk_buff *skb;
 
-	skb = ieee80211_build_probe_req(sdata, dst, ratemask,
-					sdata->local->hw.conf.channel,
+	skb = ieee80211_build_probe_req(sdata, dst, ratemask, channel,
 					ssid, ssid_len,
 					ie, ie_len, directed);
 	if (skb) {
-- 
1.7.10.4

