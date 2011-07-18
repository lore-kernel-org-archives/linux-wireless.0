Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1GRQKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 12:10:24 -0400
Message-Id: <20110718160949.600675159@sipsolutions.net> (sfid-20110718_181027_879890_89340B99)
Date: Mon, 18 Jul 2011 18:08:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: implement scan supported rates
References: <20110718160834.876776560@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Scanning currently uses the TX rate mask to
restrict the rate set, which is bogus. Make
it use the new set of rates from userspace.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/mlme.c        |    5 +++--
 net/mac80211/scan.c        |    6 +++---
 net/mac80211/util.c        |   12 +++++-------
 net/mac80211/work.c        |    3 ++-
 5 files changed, 15 insertions(+), 15 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2011-07-18 17:50:39.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-07-18 17:52:50.000000000 +0200
@@ -1376,14 +1376,14 @@ int ieee80211_build_preq_ies(struct ieee
 			     enum ieee80211_band band, u32 rate_mask,
 			     u8 channel);
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
-					  u8 *dst,
+					  u8 *dst, u32 ratemask,
 					  const u8 *ssid, size_t ssid_len,
 					  const u8 *ie, size_t ie_len,
 					  bool directed);
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len,
-			      bool directed);
+			      u32 ratemask, bool directed);
 
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 				  const size_t supp_rates_len,
--- a/net/mac80211/mlme.c	2011-07-18 17:50:39.000000000 +0200
+++ b/net/mac80211/mlme.c	2011-07-18 17:52:50.000000000 +0200
@@ -1219,7 +1219,7 @@ static void ieee80211_mgd_probe_ap_send(
 	} else {
 		ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
 		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid[1], NULL, 0,
-					 true);
+					 (u32) -1, true);
 	}
 
 	ifmgd->probe_send_count++;
@@ -1304,7 +1304,8 @@ struct sk_buff *ieee80211_ap_probereq_ge
 
 	ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
 	skb = ieee80211_build_probe_req(sdata, ifmgd->associated->bssid,
-					ssid + 2, ssid[1], NULL, 0, true);
+					(u32) -1, ssid + 2, ssid[1],
+					NULL, 0, true);
 
 	return skb;
 }
--- a/net/mac80211/scan.c	2011-07-18 17:50:39.000000000 +0200
+++ b/net/mac80211/scan.c	2011-07-18 17:52:50.000000000 +0200
@@ -228,7 +228,6 @@ ieee80211_scan_rx(struct ieee80211_sub_i
 static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 {
 	struct cfg80211_scan_request *req = local->scan_req;
-	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 	enum ieee80211_band band;
 	int i, ielen, n_chans;
 
@@ -253,7 +252,7 @@ static bool ieee80211_prep_hw_scan(struc
 
 	ielen = ieee80211_build_preq_ies(local, (u8 *)local->hw_scan_req->ie,
 					 req->ie, req->ie_len, band,
-					 sdata->rc_rateidx_mask[band], 0);
+					 req->rates[band], 0);
 	local->hw_scan_req->ie_len = ielen;
 
 	return true;
@@ -653,6 +652,7 @@ static void ieee80211_scan_state_send_pr
 {
 	int i;
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+	enum ieee80211_band band = local->hw.conf.channel->band;
 
 	for (i = 0; i < local->scan_req->n_ssids; i++)
 		ieee80211_send_probe_req(
@@ -660,7 +660,7 @@ static void ieee80211_scan_state_send_pr
 			local->scan_req->ssids[i].ssid,
 			local->scan_req->ssids[i].ssid_len,
 			local->scan_req->ie, local->scan_req->ie_len,
-			false);
+			local->scan_req->rates[band], false);
 
 	/*
 	 * After sending probe requests, wait for probe responses
--- a/net/mac80211/util.c	2011-07-18 17:50:39.000000000 +0200
+++ b/net/mac80211/util.c	2011-07-18 17:52:50.000000000 +0200
@@ -1016,7 +1016,7 @@ int ieee80211_build_preq_ies(struct ieee
 }
 
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
-					  u8 *dst,
+					  u8 *dst, u32 ratemask,
 					  const u8 *ssid, size_t ssid_len,
 					  const u8 *ie, size_t ie_len,
 					  bool directed)
@@ -1049,9 +1049,7 @@ struct sk_buff *ieee80211_build_probe_re
 
 	buf_len = ieee80211_build_preq_ies(local, buf, ie, ie_len,
 					   local->hw.conf.channel->band,
-					   sdata->rc_rateidx_mask
-					   [local->hw.conf.channel->band],
-					   chan);
+					   ratemask, chan);
 
 	skb = ieee80211_probereq_get(&local->hw, &sdata->vif,
 				     ssid, ssid_len,
@@ -1072,12 +1070,12 @@ struct sk_buff *ieee80211_build_probe_re
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len,
-			      bool directed)
+			      u32 ratemask, bool directed)
 {
 	struct sk_buff *skb;
 
-	skb = ieee80211_build_probe_req(sdata, dst, ssid, ssid_len, ie, ie_len,
-					directed);
+	skb = ieee80211_build_probe_req(sdata, dst, ratemask, ssid, ssid_len,
+					ie, ie_len, directed);
 	if (skb)
 		ieee80211_tx_skb(sdata, skb);
 }
--- a/net/mac80211/work.c	2011-07-18 17:50:39.000000000 +0200
+++ b/net/mac80211/work.c	2011-07-18 17:52:50.000000000 +0200
@@ -450,7 +450,8 @@ ieee80211_direct_probe(struct ieee80211_
 	 * will not answer to direct packet in unassociated state.
 	 */
 	ieee80211_send_probe_req(sdata, NULL, wk->probe_auth.ssid,
-				 wk->probe_auth.ssid_len, NULL, 0, true);
+				 wk->probe_auth.ssid_len, NULL, 0,
+				 (u32) -1, true);
 
 	wk->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
 	run_again(local, wk->timeout);


