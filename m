Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128E2C282D7
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCB3B217D8
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfBHNPs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:15:48 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48712 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbfBHNPr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:15:47 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs60O-0008Jb-QE; Fri, 08 Feb 2019 14:15:44 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH v8 09/15] cfg80211: save multi-bssid properties
Date:   Fri,  8 Feb 2019 14:15:33 +0100
Message-Id: <20190208131539.6813-9-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190208131539.6813-1-johannes@sipsolutions.net>
References: <20190208131539.6813-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

When the new IEs are generated, the multiple BSSID elements
are not saved. Save aside properties that are needed later
for PS.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |  5 +++
 net/wireless/scan.c    | 69 +++++++++++++++++++++++++++++-------------
 2 files changed, 53 insertions(+), 21 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c33ebc41d797..76efdc3a2200 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2038,6 +2038,8 @@ struct cfg80211_bss_ies {
  * @signal: signal strength value (type depends on the wiphy's signal_type)
  * @chains: bitmask for filled values in @chain_signal.
  * @chain_signal: per-chain signal strength of last received BSS in dBm.
+ * @bssid_index: index in the multiple BSS set
+ * @max_bssid_indicator: max number of members in the BSS set
  * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
  */
 struct cfg80211_bss {
@@ -2061,6 +2063,9 @@ struct cfg80211_bss {
 	u8 chains;
 	s8 chain_signal[IEEE80211_MAX_CHAINS];
 
+	u8 bssid_index;
+	u8 max_bssid_indicator;
+
 	u8 priv[0] __aligned(sizeof(void *));
 };
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index f1b06e9c1038..387e5f868684 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1022,11 +1022,16 @@ static bool cfg80211_combine_bsses(struct cfg80211_registered_device *rdev,
 	return true;
 }
 
+struct cfg80211_non_tx_bss {
+	struct cfg80211_bss *tx_bss;
+	u8 max_bssid_indicator;
+	u8 bssid_index;
+};
+
 /* Returned bss is reference counted and must be cleaned up appropriately. */
 static struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		    struct cfg80211_internal_bss *tmp,
-		    struct cfg80211_bss *trans_bss,
 		    bool signal_valid)
 {
 	struct cfg80211_internal_bss *found = NULL;
@@ -1126,6 +1131,8 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		memcpy(found->pub.chain_signal, tmp->pub.chain_signal,
 		       IEEE80211_MAX_CHAINS);
 		ether_addr_copy(found->parent_bssid, tmp->parent_bssid);
+		found->pub.max_bssid_indicator = tmp->pub.max_bssid_indicator;
+		found->pub.bssid_index = tmp->pub.bssid_index;
 	} else {
 		struct cfg80211_internal_bss *new;
 		struct cfg80211_internal_bss *hidden;
@@ -1185,13 +1192,13 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		}
 
 		/* This must be before the call to bss_ref_get */
-		if (trans_bss) {
+		if (tmp->pub.transmitted_bss) {
 			struct cfg80211_internal_bss *pbss =
-				container_of(trans_bss,
+				container_of(tmp->pub.transmitted_bss,
 					     struct cfg80211_internal_bss,
 					     pub);
 
-			new->pub.transmitted_bss = trans_bss;
+			new->pub.transmitted_bss = tmp->pub.transmitted_bss;
 			bss_ref_get(rdev, pbss);
 		}
 
@@ -1289,7 +1296,7 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 				enum cfg80211_bss_frame_type ftype,
 				const u8 *bssid, u64 tsf, u16 capability,
 				u16 beacon_interval, const u8 *ie, size_t ielen,
-				struct cfg80211_bss *trans_bss,
+				struct cfg80211_non_tx_bss *non_tx_data,
 				gfp_t gfp)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
@@ -1318,6 +1325,11 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 	tmp.pub.beacon_interval = beacon_interval;
 	tmp.pub.capability = capability;
 	tmp.ts_boottime = data->boottime_ns;
+	if (non_tx_data) {
+		tmp.pub.transmitted_bss = non_tx_data->tx_bss;
+		tmp.pub.bssid_index = non_tx_data->bssid_index;
+		tmp.pub.max_bssid_indicator = non_tx_data->max_bssid_indicator;
+	}
 
 	/*
 	 * If we do not know here whether the IEs are from a Beacon or Probe
@@ -1350,8 +1362,7 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 
 	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
-	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, trans_bss,
-				  signal_valid);
+	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid);
 	if (!res)
 		return NULL;
 
@@ -1365,11 +1376,12 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 			regulatory_hint_found_beacon(wiphy, channel, gfp);
 	}
 
-	if (trans_bss) {
+	if (non_tx_data && non_tx_data->tx_bss) {
 		/* this is a nontransmitting bss, we need to add it to
 		 * transmitting bss' list if it is not there
 		 */
-		if (cfg80211_add_nontrans_list(trans_bss, &res->pub)) {
+		if (cfg80211_add_nontrans_list(non_tx_data->tx_bss,
+					       &res->pub)) {
 			if (__cfg80211_unlink_bss(rdev, res))
 				rdev->bss_generation++;
 		}
@@ -1386,7 +1398,7 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 				       const u8 *bssid, u64 tsf,
 				       u16 beacon_interval, const u8 *ie,
 				       size_t ielen,
-				       struct cfg80211_bss *trans_bss,
+				       struct cfg80211_non_tx_bss *non_tx_data,
 				       gfp_t gfp)
 {
 	const u8 *mbssid_index_ie;
@@ -1397,7 +1409,7 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 	u16 capability;
 	struct cfg80211_bss *bss;
 
-	if (!trans_bss)
+	if (!non_tx_data)
 		return;
 	if (!cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
 		return;
@@ -1439,8 +1451,12 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 				continue;
 			}
 
-			cfg80211_gen_new_bssid(bssid, elem->data[0],
-					       mbssid_index_ie[2],
+			non_tx_data->bssid_index = mbssid_index_ie[2];
+			non_tx_data->max_bssid_indicator = elem->data[0];
+
+			cfg80211_gen_new_bssid(bssid,
+					       non_tx_data->max_bssid_indicator,
+					       non_tx_data->bssid_index,
 					       new_bssid);
 			memset(new_ie, 0, IEEE80211_MAX_DATA_LEN);
 			new_ie_len = cfg80211_gen_new_ie(ie, ielen, sub->data,
@@ -1457,7 +1473,8 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 							      beacon_interval,
 							      new_ie,
 							      new_ie_len,
-							      trans_bss, gfp);
+							      non_tx_data,
+							      gfp);
 			if (!bss)
 				break;
 			cfg80211_put_bss(wiphy, bss);
@@ -1476,12 +1493,15 @@ cfg80211_inform_bss_data(struct wiphy *wiphy,
 			 gfp_t gfp)
 {
 	struct cfg80211_bss *res;
+	struct cfg80211_non_tx_bss non_tx_data;
 
 	res = cfg80211_inform_single_bss_data(wiphy, data, ftype, bssid, tsf,
 					      capability, beacon_interval, ie,
 					      ielen, NULL, gfp);
+	non_tx_data.tx_bss = res;
 	cfg80211_parse_mbssid_data(wiphy, data, ftype, bssid, tsf,
-				   beacon_interval, ie, ielen, res, gfp);
+				   beacon_interval, ie, ielen, &non_tx_data,
+				   gfp);
 	return res;
 }
 EXPORT_SYMBOL(cfg80211_inform_bss_data);
@@ -1490,7 +1510,7 @@ static void
 cfg80211_parse_mbssid_frame_data(struct wiphy *wiphy,
 				 struct cfg80211_inform_bss *data,
 				 struct ieee80211_mgmt *mgmt, size_t len,
-				 struct cfg80211_bss *trans_bss,
+				 struct cfg80211_non_tx_bss *non_tx_data,
 				 gfp_t gfp)
 {
 	enum cfg80211_bss_frame_type ftype;
@@ -1504,7 +1524,7 @@ cfg80211_parse_mbssid_frame_data(struct wiphy *wiphy,
 	cfg80211_parse_mbssid_data(wiphy, data, ftype, mgmt->bssid,
 				   le64_to_cpu(mgmt->u.probe_resp.timestamp),
 				   le16_to_cpu(mgmt->u.probe_resp.beacon_int),
-				   ie, ielen, trans_bss, gfp);
+				   ie, ielen, non_tx_data, gfp);
 }
 
 static void
@@ -1594,7 +1614,7 @@ static struct cfg80211_bss *
 cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
 				      struct cfg80211_inform_bss *data,
 				      struct ieee80211_mgmt *mgmt, size_t len,
-				      struct cfg80211_bss *trans_bss,
+				      struct cfg80211_non_tx_bss *non_tx_data,
 				      gfp_t gfp)
 {
 	struct cfg80211_internal_bss tmp = {}, *res;
@@ -1653,11 +1673,15 @@ cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
 	tmp.pub.chains = data->chains;
 	memcpy(tmp.pub.chain_signal, data->chain_signal, IEEE80211_MAX_CHAINS);
 	ether_addr_copy(tmp.parent_bssid, data->parent_bssid);
+	if (non_tx_data) {
+		tmp.pub.transmitted_bss = non_tx_data->tx_bss;
+		tmp.pub.bssid_index = non_tx_data->bssid_index;
+		tmp.pub.max_bssid_indicator = non_tx_data->max_bssid_indicator;
+	}
 
 	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
-	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, trans_bss,
-				  signal_valid);
+	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid);
 	if (!res)
 		return NULL;
 
@@ -1687,6 +1711,7 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	const struct cfg80211_bss_ies *ies1, *ies2;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
+	struct cfg80211_non_tx_bss non_tx_data;
 
 	res = cfg80211_inform_single_bss_frame_data(wiphy, data, mgmt,
 						    len, NULL, gfp);
@@ -1697,8 +1722,10 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	    !cfg80211_find_ext_ie(WLAN_EID_EXT_HE_CAPABILITY, ie, ielen))
 		return res;
 
+	non_tx_data.tx_bss = res;
 	/* process each non-transmitting bss */
-	cfg80211_parse_mbssid_frame_data(wiphy, data, mgmt, len, res, gfp);
+	cfg80211_parse_mbssid_frame_data(wiphy, data, mgmt, len,
+					 &non_tx_data, gfp);
 
 	/* check if the res has other nontransmitting bss which is not
 	 * in MBSSID IE
-- 
2.17.2

