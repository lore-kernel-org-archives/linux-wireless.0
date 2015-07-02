Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47200 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbbGBOZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 10:25:00 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 3/4] mac80211: treat bad WMM parameters more gracefully
Date: Thu,  2 Jul 2015 16:24:55 +0200
Message-Id: <1435847096-5750-3-git-send-email-johannes@sipsolutions.net> (sfid-20150702_162510_422304_FF07B5CD)
In-Reply-To: <1435847096-5750-1-git-send-email-johannes@sipsolutions.net>
References: <1435847096-5750-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As WMM is required for HT/VHT operation, treat bad WMM parameters
more gracefully by falling back to default parameters instead of
not using WMM assocation. This makes it possible to still use HT
or VHT, although potentially with reduced quality of service due
to unintended WMM parameters.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 142 ++++++++++++++++++----------------------------------
 1 file changed, 48 insertions(+), 94 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9c7ed4b38c83..72e1579d1226 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1762,10 +1762,10 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 				     struct ieee80211_sub_if_data *sdata,
 				     const u8 *wmm_param, size_t wmm_param_len)
 {
-	struct ieee80211_tx_queue_params params;
+	struct ieee80211_tx_queue_params params[IEEE80211_NUM_ACS];
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	size_t left;
-	int count;
+	int count, ac;
 	const u8 *pos;
 	u8 uapsd_queues = 0;
 
@@ -1799,25 +1799,24 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		int aci = (pos[0] >> 5) & 0x03;
 		int acm = (pos[0] >> 4) & 0x01;
 		bool uapsd = false;
-		int queue;
 
 		switch (aci) {
 		case 1: /* AC_BK */
-			queue = 3;
+			ac = IEEE80211_AC_BK;
 			if (acm)
 				sdata->wmm_acm |= BIT(1) | BIT(2); /* BK/- */
 			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BK)
 				uapsd = true;
 			break;
 		case 2: /* AC_VI */
-			queue = 1;
+			ac = IEEE80211_AC_VI;
 			if (acm)
 				sdata->wmm_acm |= BIT(4) | BIT(5); /* CL/VI */
 			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VI)
 				uapsd = true;
 			break;
 		case 3: /* AC_VO */
-			queue = 0;
+			ac = IEEE80211_AC_VO;
 			if (acm)
 				sdata->wmm_acm |= BIT(6) | BIT(7); /* VO/NC */
 			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
@@ -1825,7 +1824,7 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 			break;
 		case 0: /* AC_BE */
 		default:
-			queue = 2;
+			ac = IEEE80211_AC_BE;
 			if (acm)
 				sdata->wmm_acm |= BIT(0) | BIT(3); /* BE/EE */
 			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BE)
@@ -1833,32 +1832,41 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 			break;
 		}
 
-		params.aifs = pos[0] & 0x0f;
+		params[ac].aifs = pos[0] & 0x0f;
 
-		if (params.aifs < 2) {
+		if (params[ac].aifs < 2) {
 			sdata_info(sdata,
 				   "AP has invalid WMM params (AIFSN=%d for ACI %d), will use 2\n",
-				   params.aifs, aci);
-			params.aifs = 2;
+				   params[ac].aifs, aci);
+			params[ac].aifs = 2;
 		}
-		params.cw_max = ecw2cw((pos[1] & 0xf0) >> 4);
-		params.cw_min = ecw2cw(pos[1] & 0x0f);
-		params.txop = get_unaligned_le16(pos + 2);
-		params.acm = acm;
-		params.uapsd = uapsd;
+		params[ac].cw_max = ecw2cw((pos[1] & 0xf0) >> 4);
+		params[ac].cw_min = ecw2cw(pos[1] & 0x0f);
+		params[ac].txop = get_unaligned_le16(pos + 2);
+		params[ac].acm = acm;
+		params[ac].uapsd = uapsd;
 
+		if (params[ac].cw_min > params[ac].cw_max) {
+			sdata_info(sdata,
+				   "AP has invalid WMM params (CWmin/max=%d/%d for ACI %d), using defaults\n",
+				   params[ac].cw_min, params[ac].cw_max, aci);
+			return false;
+		}
+	}
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		mlme_dbg(sdata,
-			 "WMM queue=%d aci=%d acm=%d aifs=%d cWmin=%d cWmax=%d txop=%d uapsd=%d, downgraded=%d\n",
-			 queue, aci, acm,
-			 params.aifs, params.cw_min, params.cw_max,
-			 params.txop, params.uapsd,
-			 ifmgd->tx_tspec[queue].downgraded);
-		sdata->tx_conf[queue] = params;
-		if (!ifmgd->tx_tspec[queue].downgraded &&
-		    drv_conf_tx(local, sdata, queue, &params))
+			 "WMM AC=%d acm=%d aifs=%d cWmin=%d cWmax=%d txop=%d uapsd=%d, downgraded=%d\n",
+			 ac, params[ac].acm,
+			 params[ac].aifs, params[ac].cw_min, params[ac].cw_max,
+			 params[ac].txop, params[ac].uapsd,
+			 ifmgd->tx_tspec[ac].downgraded);
+		sdata->tx_conf[ac] = params[ac];
+		if (!ifmgd->tx_tspec[ac].downgraded &&
+		    drv_conf_tx(local, sdata, ac, &params[ac]))
 			sdata_err(sdata,
-				  "failed to set TX queue parameters for queue %d\n",
-				  queue);
+				  "failed to set TX queue parameters for AC %d\n",
+				  ac);
 	}
 
 	/* enable WMM or activate new settings */
@@ -3073,11 +3081,21 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	 */
 	ifmgd->wmm_last_param_set = -1;
 
-	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_WMM) && elems.wmm_param)
-		ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
-					 elems.wmm_param_len);
-	else
+	if (ifmgd->flags & IEEE80211_STA_DISABLE_WMM) {
 		ieee80211_set_wmm_default(sdata, false, false);
+	} else if (!ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
+					     elems.wmm_param_len)) {
+		/* still enable QoS since we might have HT/VHT */
+		ieee80211_set_wmm_default(sdata, false, true);
+		/* set the disable-WMM flag in this case to disable
+		 * tracking WMM parameter changes in the beacon if
+		 * the parameters weren't actually valid. Doing so
+		 * avoids changing parameters very strangely when
+		 * the AP is going back and forth between valid and
+		 * invalid parameters.
+		 */
+		ifmgd->flags |= IEEE80211_STA_DISABLE_WMM;
+	}
 	changed |= BSS_CHANGED_QOS;
 
 	/* set AID and assoc capability,
@@ -4613,37 +4631,6 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	return err;
 }
 
-static bool ieee80211_usable_wmm_params(struct ieee80211_sub_if_data *sdata,
-					const u8 *wmm_param, int len)
-{
-	const u8 *pos;
-	size_t left;
-
-	if (len < 8)
-		return false;
-
-	if (wmm_param[5] != 1 /* version */)
-		return false;
-
-	pos = wmm_param + 8;
-	left = len - 8;
-
-	for (; left >= 4; left -= 4, pos += 4) {
-		u8 ecwmin = pos[1] & 0x0f;
-		u8 ecwmax = (pos[1] & 0xf0) >> 4;
-		int aci = (pos[0] >> 5) & 0x03;
-
-		if (ecwmin > ecwmax) {
-			sdata_info(sdata,
-				   "AP has invalid WMM params (ECWmin/max=%d/%d for ACI %d), disabling WMM\n",
-				   ecwmin, ecwmax, aci);
-			return false;
-		}
-	}
-
-	return true;
-}
-
 int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_assoc_request *req)
 {
@@ -4708,39 +4695,6 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	assoc_data->wmm = bss->wmm_used &&
 			  (local->hw.queues >= IEEE80211_NUM_ACS);
-	if (assoc_data->wmm) {
-		/* try to check validity of WMM params IE */
-		const struct cfg80211_bss_ies *ies;
-		const u8 *wp, *start, *end;
-
-		rcu_read_lock();
-		ies = rcu_dereference(req->bss->ies);
-		start = ies->data;
-		end = start + ies->len;
-
-		while (true) {
-			wp = cfg80211_find_vendor_ie(
-				WLAN_OUI_MICROSOFT,
-				WLAN_OUI_TYPE_MICROSOFT_WMM,
-				start, end - start);
-			if (!wp)
-				break;
-			start = wp + wp[1] + 2;
-			/* if this IE is too short, try the next */
-			if (wp[1] <= 4)
-				continue;
-			/* if this IE is WMM params, we found what we wanted */
-			if (wp[6] == 1)
-				break;
-		}
-
-		if (!wp || !ieee80211_usable_wmm_params(sdata, wp + 2,
-							wp[1] - 2)) {
-			assoc_data->wmm = false;
-			ifmgd->flags |= IEEE80211_STA_DISABLE_WMM;
-		}
-		rcu_read_unlock();
-	}
 
 	/*
 	 * IEEE802.11n does not allow TKIP/WEP as pairwise ciphers in HT mode.
-- 
2.1.4

