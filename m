Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45735 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab2LKTRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 14:17:53 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac82011: use frame control to differentiate probe resp/beacon
Date: Tue, 11 Dec 2012 20:18:14 +0100
Message-Id: <1355253494-23118-1-git-send-email-johannes@sipsolutions.net> (sfid-20121211_201757_296159_60A776B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The probe response/beacon management frame RX code passes a
bool parameter to differentiate beacons and probe responses.
This is useless since we have the frame and can thus use its
frame control field. Moreover it is buggy since there is one
call to ieee80211_rx_bss_info with a beacon frame that is
indicated as a probe response, which is also fixed by using
the frame control field, so do that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c        | 50 ++++++++++++++++------------------------------
 net/mac80211/ieee80211_i.h |  3 +--
 net/mac80211/mlme.c        | 13 +++++-------
 net/mac80211/scan.c        |  9 ++++-----
 4 files changed, 27 insertions(+), 48 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 700d0ed..e84db1b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -425,11 +425,9 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
-				  struct ieee80211_mgmt *mgmt,
-				  size_t len,
+				  struct ieee80211_mgmt *mgmt, size_t len,
 				  struct ieee80211_rx_status *rx_status,
-				  struct ieee802_11_elems *elems,
-				  bool beacon)
+				  struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
 	int freq;
@@ -530,7 +528,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	}
 
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
-					channel, beacon);
+					channel);
 	if (!bss)
 		return;
 
@@ -878,14 +876,21 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_mgmt *mgmt,
-					 size_t len,
-					 struct ieee80211_rx_status *rx_status)
+static
+void ieee80211_rx_mgmt_probe_beacon(struct ieee80211_sub_if_data *sdata,
+				    struct ieee80211_mgmt *mgmt, size_t len,
+				    struct ieee80211_rx_status *rx_status)
 {
 	size_t baselen;
 	struct ieee802_11_elems elems;
 
+	BUILD_BUG_ON(offsetof(typeof(mgmt->u.probe_resp), variable) !=
+		     offsetof(typeof(mgmt->u.beacon), variable));
+
+	/*
+	 * either beacon or probe_resp but the variable field is at the
+	 * same offset
+	 */
 	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
 	if (baselen > len)
 		return;
@@ -893,25 +898,7 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
 				&elems);
 
-	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, false);
-}
-
-static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_mgmt *mgmt,
-				     size_t len,
-				     struct ieee80211_rx_status *rx_status)
-{
-	size_t baselen;
-	struct ieee802_11_elems elems;
-
-	/* Process beacon from the current BSS */
-	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
-	if (baselen > len)
-		return;
-
-	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
-
-	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, true);
+	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 }
 
 void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
@@ -935,12 +922,9 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 		ieee80211_rx_mgmt_probe_req(sdata, skb);
 		break;
 	case IEEE80211_STYPE_PROBE_RESP:
-		ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len,
-					     rx_status);
-		break;
 	case IEEE80211_STYPE_BEACON:
-		ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len,
-					 rx_status);
+		ieee80211_rx_mgmt_probe_beacon(sdata, mgmt, skb->len,
+					       rx_status);
 		break;
 	case IEEE80211_STYPE_AUTH:
 		ieee80211_rx_mgmt_auth_ibss(sdata, mgmt, skb->len);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6f36ab7..185973d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1344,8 +1344,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_mgmt *mgmt,
 			  size_t len,
 			  struct ieee802_11_elems *elems,
-			  struct ieee80211_channel *channel,
-			  bool beacon);
+			  struct ieee80211_channel *channel);
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_bss *bss);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 082d43e..a5a89ac 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2402,8 +2402,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt, size_t len,
 				  struct ieee80211_rx_status *rx_status,
-				  struct ieee802_11_elems *elems,
-				  bool beacon)
+				  struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -2434,7 +2433,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	bss = ieee80211_bss_info_update(local, rx_status, mgmt, len, elems,
-					channel, beacon);
+					channel);
 	if (bss)
 		ieee80211_rx_bss_put(local, bss);
 
@@ -2497,7 +2496,7 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
 				&elems);
 
-	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, false);
+	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 
 	if (ifmgd->associated &&
 	    ether_addr_equal(mgmt->bssid, ifmgd->associated->bssid))
@@ -2578,8 +2577,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ieee802_11_parse_elems(mgmt->u.beacon.variable,
 				       len - baselen, &elems);
 
-		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems,
-				      false);
+		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 		ifmgd->assoc_data->have_beacon = true;
 		ifmgd->assoc_data->sent_assoc = false;
 		/* continue assoc process */
@@ -2732,8 +2730,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	ifmgd->beacon_crc = ncrc;
 	ifmgd->beacon_crc_valid = true;
 
-	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems,
-			      true);
+	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 
 	if (ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
 				     elems.wmm_param_len))
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index cb3df39..f0b8072 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -65,12 +65,11 @@ static bool is_uapsd_supported(struct ieee802_11_elems *elems)
 struct ieee80211_bss *
 ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
-			  struct ieee80211_mgmt *mgmt,
-			  size_t len,
+			  struct ieee80211_mgmt *mgmt, size_t len,
 			  struct ieee802_11_elems *elems,
-			  struct ieee80211_channel *channel,
-			  bool beacon)
+			  struct ieee80211_channel *channel)
 {
+	bool beacon = ieee80211_is_beacon(mgmt->frame_control);
 	struct cfg80211_bss *cbss;
 	struct ieee80211_bss *bss;
 	int clen, srlen;
@@ -215,7 +214,7 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 
 	bss = ieee80211_bss_info_update(local, rx_status,
 					mgmt, skb->len, &elems,
-					channel, beacon);
+					channel);
 	if (bss)
 		ieee80211_rx_bss_put(local, bss);
 }
-- 
1.8.0

