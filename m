Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:50729 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab1FWR0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 13:26:34 -0400
Received: from hpaq11.eem.corp.google.com (hpaq11.eem.corp.google.com [172.25.149.11])
	by smtp-out.google.com with ESMTP id p5NHQWRB016958
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2011 10:26:33 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by hpaq11.eem.corp.google.com with ESMTP id p5NHQV01019944
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2011 10:26:31 -0700
From: Paul Stewart <pstew@chromium.org>
Date: Thu, 23 Jun 2011 09:00:11 -0800
Subject: [PATCH] mac80211: Drop DS Channel PARAM in directed probe
To: linux-wireless@vger.kernel.org
Message-Id: <20110623172630.F038820191@glenhelen.mtv.corp.google.com> (sfid-20110623_192641_605567_2DA48ECC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not send DS Channel parameter for directed probe requests
in order to maximize the chance that we get a response.  Some
badly-behaved APs don't respond when this parameter is included.

Signed-off-by: Paul Stewart <pstew@chromium.org>
---
 net/mac80211/ieee80211_i.h |    6 ++++--
 net/mac80211/mlme.c        |    5 +++--
 net/mac80211/scan.c        |    3 ++-
 net/mac80211/util.c        |   21 ++++++++++++++++-----
 net/mac80211/work.c        |    2 +-
 5 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 090b0ec..25c15cc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1350,10 +1350,12 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 					  u8 *dst,
 					  const u8 *ssid, size_t ssid_len,
-					  const u8 *ie, size_t ie_len);
+					  const u8 *ie, size_t ie_len,
+					  bool directed);
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
-			      const u8 *ie, size_t ie_len);
+			      const u8 *ie, size_t ie_len,
+			      bool directed);
 
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 				  const size_t supp_rates_len,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index faca503..0f6052f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1204,7 +1204,8 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 		ieee80211_send_nullfunc(sdata->local, sdata, 0);
 	} else {
 		ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
-		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid[1], NULL, 0);
+		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid[1], NULL, 0,
+					 true);
 	}
 
 	ifmgd->probe_send_count++;
@@ -1289,7 +1290,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 
 	ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
 	skb = ieee80211_build_probe_req(sdata, ifmgd->associated->bssid,
-					ssid + 2, ssid[1], NULL, 0);
+					ssid + 2, ssid[1], NULL, 0, true);
 
 	return skb;
 }
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 1758b46..a97eed0 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -658,7 +658,8 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 			sdata, NULL,
 			local->scan_req->ssids[i].ssid,
 			local->scan_req->ssids[i].ssid_len,
-			local->scan_req->ie, local->scan_req->ie_len);
+			local->scan_req->ie, local->scan_req->ie_len,
+			false);
 
 	/*
 	 * After sending probe requests, wait for probe responses
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 05e3fb8..652e569 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1018,7 +1018,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 					  u8 *dst,
 					  const u8 *ssid, size_t ssid_len,
-					  const u8 *ie, size_t ie_len)
+					  const u8 *ie, size_t ie_len,
+					  bool directed)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
@@ -1035,8 +1036,16 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 		return NULL;
 	}
 
-	chan = ieee80211_frequency_to_channel(
-		local->hw.conf.channel->center_freq);
+	/*
+	 * Do not send DS Channel parameter for directed probe requests
+	 * in order to maximize the chance that we get a response.  Some
+	 * badly-behaved APs don't respond when this parameter is included.
+	 */
+	if (directed)
+		chan = 0;
+	else
+		chan = ieee80211_frequency_to_channel(
+			local->hw.conf.channel->center_freq);
 
 	buf_len = ieee80211_build_preq_ies(local, buf, ie, ie_len,
 					   local->hw.conf.channel->band,
@@ -1062,11 +1071,13 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
-			      const u8 *ie, size_t ie_len)
+			      const u8 *ie, size_t ie_len,
+			      bool directed)
 {
 	struct sk_buff *skb;
 
-	skb = ieee80211_build_probe_req(sdata, dst, ssid, ssid_len, ie, ie_len);
+	skb = ieee80211_build_probe_req(sdata, dst, ssid, ssid_len, ie, ie_len,
+					directed);
 	if (skb)
 		ieee80211_tx_skb(sdata, skb);
 }
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index d2e7f0e..edf8583 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -450,7 +450,7 @@ ieee80211_direct_probe(struct ieee80211_work *wk)
 	 * will not answer to direct packet in unassociated state.
 	 */
 	ieee80211_send_probe_req(sdata, NULL, wk->probe_auth.ssid,
-				 wk->probe_auth.ssid_len, NULL, 0);
+				 wk->probe_auth.ssid_len, NULL, 0, true);
 
 	wk->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
 	run_again(local, wk->timeout);
-- 
1.7.3.1

