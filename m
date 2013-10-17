Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3JQHov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:44:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Antonio Quartulli <antonio@meshcoding.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.12] mac80211: disable WMM with invalid parameters
Date: Thu, 17 Oct 2013 09:44:41 +0200
Message-Id: <1381995881-16935-1-git-send-email-johannes@sipsolutions.net> (sfid-20131017_100807_627538_36C9C531)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some APs (notably a Sitecom WL-153 v1 with firmware 1.45) are sending
invalid WMM parameters setting AIFSN, ECWmin and ECWmax to zero. The
spec mandates that the value of AIFSN is at least 2, and some cards
(e.g. Intel with the iwldvm driver) can't transmit when the invalid
QoS parameters are actually uploaded to the firmware.

Since there's little chance of being able to guess the values that
the AP actually meant, disable WMM if such an invalid case is found.
Since ECWmin/ECWmax are allowed to be zero, only verify AIFSN >= 2
and ECWmin <= ECWmax.

Reported-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 86 +++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 78 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 611abfc..0764095 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -335,6 +335,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_DISABLE_VHT	= BIT(11),
 	IEEE80211_STA_DISABLE_80P80MHZ	= BIT(12),
 	IEEE80211_STA_DISABLE_160MHZ	= BIT(13),
+	IEEE80211_STA_DISABLE_WMM	= BIT(14),
 };
 
 struct ieee80211_mgd_auth_data {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 86e4ad5..9c47060 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2717,7 +2717,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	 */
 	ifmgd->wmm_last_param_set = -1;
 
-	if (elems.wmm_param)
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_WMM) && elems.wmm_param)
 		ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
 					 elems.wmm_param_len);
 	else
@@ -3152,7 +3152,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	ieee80211_sta_process_chanswitch(sdata, rx_status->mactime,
 					 &elems, true);
 
-	if (ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_WMM) &&
+	    ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
 				     elems.wmm_param_len))
 		changed |= BSS_CHANGED_QOS;
 
@@ -4135,6 +4136,44 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	return err;
 }
 
+static bool ieee80211_usable_wmm_params(struct ieee80211_sub_if_data *sdata,
+					const u8 *wmm_param, int len)
+{
+	const u8 *pos;
+	size_t left;
+
+	if (len < 8)
+		return false;
+
+	if (wmm_param[5] != 1 /* version */)
+		return false;
+
+	pos = wmm_param + 8;
+	left = len - 8;
+
+	for (; left >= 4; left -= 4, pos += 4) {
+		u8 aifsn = pos[0] & 0x0f;
+		u8 ecwmin = pos[1] & 0x0f;
+		u8 ecwmax = (pos[1] & 0xf0) >> 4;
+		int aci = (pos[0] >> 5) & 0x03;
+
+		if (aifsn < 2) {
+			sdata_info(sdata,
+				   "AP has invalid WMM params (AIFSN=%d for ACI %d), disabling WMM\n",
+				   aifsn, aci);
+			return false;
+		}
+		if (ecwmin > ecwmax) {
+			sdata_info(sdata,
+				   "AP has invalid WMM params (ECWmin/max=%d/%d for ACI %d), disabling WMM\n",
+				   ecwmin, ecwmax, aci);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_assoc_request *req)
 {
@@ -4192,9 +4231,36 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* prepare assoc data */
-	
+
 	ifmgd->beacon_crc_valid = false;
 
+	assoc_data->wmm = bss->wmm_used &&
+			  (local->hw.queues >= IEEE80211_NUM_ACS);
+	if (assoc_data->wmm) {
+		/* try to check validity of WMM params IE */
+		const struct cfg80211_bss_ies *ies;
+		const u8 *wp, *start;
+		int len;
+
+		rcu_read_lock();
+		ies = rcu_dereference(req->bss->ies);
+		start = ies->data;
+		len = ies->len;
+
+		do {
+			wp = cfg80211_find_vendor_ie(0x0050F2, 2, start, len);
+			start = wp;
+			len -= wp[1];
+		} while (wp && wp[1] > 6 && wp[6] != 1);
+
+		if (!wp || !ieee80211_usable_wmm_params(sdata, wp + 2,
+							wp[1] - 2)) {
+			assoc_data->wmm = false;
+			ifmgd->flags |= IEEE80211_STA_DISABLE_WMM;
+		}
+		rcu_read_unlock();
+	}
+
 	/*
 	 * IEEE802.11n does not allow TKIP/WEP as pairwise ciphers in HT mode.
 	 * We still associate in non-HT mode (11a/b/g) if any one of these
@@ -4224,18 +4290,22 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	/* Also disable HT if we don't support it or the AP doesn't use WMM */
 	sband = local->hw.wiphy->bands[req->bss->channel->band];
 	if (!sband->ht_cap.ht_supported ||
-	    local->hw.queues < IEEE80211_NUM_ACS || !bss->wmm_used) {
+	    local->hw.queues < IEEE80211_NUM_ACS || !bss->wmm_used ||
+	    ifmgd->flags & IEEE80211_STA_DISABLE_WMM) {
 		ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
-		if (!bss->wmm_used)
+		if (!bss->wmm_used &&
+		    !(ifmgd->flags & IEEE80211_STA_DISABLE_WMM))
 			netdev_info(sdata->dev,
 				    "disabling HT as WMM/QoS is not supported by the AP\n");
 	}
 
 	/* disable VHT if we don't support it or the AP doesn't use WMM */
 	if (!sband->vht_cap.vht_supported ||
-	    local->hw.queues < IEEE80211_NUM_ACS || !bss->wmm_used) {
+	    local->hw.queues < IEEE80211_NUM_ACS || !bss->wmm_used ||
+	    ifmgd->flags & IEEE80211_STA_DISABLE_WMM) {
 		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
-		if (!bss->wmm_used)
+		if (!bss->wmm_used &&
+		    !(ifmgd->flags & IEEE80211_STA_DISABLE_WMM))
 			netdev_info(sdata->dev,
 				    "disabling VHT as WMM/QoS is not supported by the AP\n");
 	}
@@ -4264,8 +4334,6 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		sdata->smps_mode = ifmgd->req_smps;
 
 	assoc_data->capability = req->bss->capability;
-	assoc_data->wmm = bss->wmm_used &&
-			  (local->hw.queues >= IEEE80211_NUM_ACS);
 	assoc_data->supp_rates = bss->supp_rates;
 	assoc_data->supp_rates_len = bss->supp_rates_len;
 
-- 
1.8.4.rc3

