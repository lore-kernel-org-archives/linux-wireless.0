Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55949 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933640Ab3E1JAE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 05:00:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: work around broken APs not including HT info
Date: Tue, 28 May 2013 10:59:54 +0200
Message-Id: <1369731594-16303-2-git-send-email-johannes@sipsolutions.net> (sfid-20130528_110012_309683_6131E905)
In-Reply-To: <1369731594-16303-1-git-send-email-johannes@sipsolutions.net>
References: <1369731594-16303-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are some APs, notably 2G/3G/4G Wifi routers, specifically
the "Onda PN51T", "Vodafone PocketWiFi 2" and a similar T-Mobile
branded device [1] that erroneously don't include all the needed
information in (re)association response frames. Work around this
by assuming the information is the same as it was in the beacon
or probe response and using the data from there instead.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=58881.

[1] https://bbs.archlinux.org/viewtopic.php?pid=1277305

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 80 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f44f4ca..8571294 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2486,8 +2486,11 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	u16 capab_info, aid;
 	struct ieee802_11_elems elems;
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
+	const struct cfg80211_bss_ies *bss_ies = NULL;
+	struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
 	u32 changed = 0;
 	int err;
+	bool ret;
 
 	/* AssocResp and ReassocResp have identical structure */
 
@@ -2519,21 +2522,86 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	ifmgd->aid = aid;
 
 	/*
+	 * Some APs are erroneously not including some information in their
+	 * (re)association response frames. Try to recover by using the data
+	 * from the beacon or probe response. This seems to afflict mobile
+	 * 2G/3G/4G wifi routers, reported models include the "Onda PN51T",
+	 * "Vodafone PocketWiFi 2" and a similar T-Mobile branded device.
+	 */
+	if ((assoc_data->wmm && !elems.wmm_param) ||
+	    (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT) &&
+	     (!elems.ht_cap_elem || !elems.ht_operation)) ||
+	    (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT) &&
+	     (!elems.vht_cap_elem || !elems.vht_operation))) {
+		const struct cfg80211_bss_ies *ies;
+		struct ieee802_11_elems bss_elems;
+
+		rcu_read_lock();
+		ies = rcu_dereference(cbss->ies);
+		if (ies)
+			bss_ies = kmemdup(ies, sizeof(*ies) + ies->len,
+					  GFP_ATOMIC);
+		rcu_read_unlock();
+		if (!bss_ies)
+			return false;
+
+		ieee802_11_parse_elems(bss_ies->data, bss_ies->len,
+				       false, &bss_elems);
+		if (assoc_data->wmm &&
+		    !elems.wmm_param && bss_elems.wmm_param) {
+			elems.wmm_param = bss_elems.wmm_param;
+			sdata_info(sdata,
+				   "AP bug: WMM param missing from AssocResp\n");
+		}
+
+		/*
+		 * Also check if we requested HT/VHT, otherwise the AP doesn't
+		 * have to include the IEs in the (re)association response.
+		 */
+		if (!elems.ht_cap_elem && bss_elems.ht_cap_elem &&
+		    !(ifmgd->flags & IEEE80211_STA_DISABLE_HT)) {
+			elems.ht_cap_elem = bss_elems.ht_cap_elem;
+			sdata_info(sdata,
+				   "AP bug: HT capability missing from AssocResp\n");
+		}
+		if (!elems.ht_operation && bss_elems.ht_operation &&
+		    !(ifmgd->flags & IEEE80211_STA_DISABLE_HT)) {
+			elems.ht_operation = bss_elems.ht_operation;
+			sdata_info(sdata,
+				   "AP bug: HT operation missing from AssocResp\n");
+		}
+		if (!elems.vht_cap_elem && bss_elems.vht_cap_elem &&
+		    !(ifmgd->flags & IEEE80211_STA_DISABLE_VHT)) {
+			elems.vht_cap_elem = bss_elems.vht_cap_elem;
+			sdata_info(sdata,
+				   "AP bug: VHT capa missing from AssocResp\n");
+		}
+		if (!elems.vht_operation && bss_elems.vht_operation &&
+		    !(ifmgd->flags & IEEE80211_STA_DISABLE_VHT)) {
+			elems.vht_operation = bss_elems.vht_operation;
+			sdata_info(sdata,
+				   "AP bug: VHT operation missing from AssocResp\n");
+		}
+	}
+
+	/*
 	 * We previously checked these in the beacon/probe response, so
 	 * they should be present here. This is just a safety net.
 	 */
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT) &&
 	    (!elems.wmm_param || !elems.ht_cap_elem || !elems.ht_operation)) {
 		sdata_info(sdata,
-			   "HT AP is missing WMM params or HT capability/operation in AssocResp\n");
-		return false;
+			   "HT AP is missing WMM params or HT capability/operation\n");
+		ret = false;
+		goto out;
 	}
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT) &&
 	    (!elems.vht_cap_elem || !elems.vht_operation)) {
 		sdata_info(sdata,
-			   "VHT AP is missing VHT capability/operation in AssocResp\n");
-		return false;
+			   "VHT AP is missing VHT capability/operation\n");
+		ret = false;
+		goto out;
 	}
 
 	mutex_lock(&sdata->local->sta_mtx);
@@ -2544,7 +2612,8 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	sta = sta_info_get(sdata, cbss->bssid);
 	if (WARN_ON(!sta)) {
 		mutex_unlock(&sdata->local->sta_mtx);
-		return false;
+		ret = false;
+		goto out;
 	}
 
 	sband = local->hw.wiphy->bands[ieee80211_get_sdata_band(sdata)];
@@ -2597,7 +2666,8 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 			   sta->sta.addr);
 		WARN_ON(__sta_info_destroy(sta));
 		mutex_unlock(&sdata->local->sta_mtx);
-		return false;
+		ret = false;
+		goto out;
 	}
 
 	mutex_unlock(&sdata->local->sta_mtx);
@@ -2637,7 +2707,10 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	ieee80211_sta_rx_notify(sdata, (struct ieee80211_hdr *)mgmt);
 	ieee80211_sta_reset_beacon_monitor(sdata);
 
-	return true;
+	ret = true;
+ out:
+	kfree(bss_ies);
+	return ret;
 }
 
 static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
-- 
1.8.0

