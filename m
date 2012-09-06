Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab2IFPKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 11:10:43 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: check power constraint IE size when parsing
Date: Thu,  6 Sep 2012 17:11:19 +0200
Message-Id: <1346944279-18196-1-git-send-email-johannes@sipsolutions.net> (sfid-20120906_171048_580446_BF2F27EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The power constraint IE is always a single byte
so check the size when parsing instead of later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/mlme.c        |   10 ++--------
 net/mac80211/util.c        |    5 ++++-
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e2ab03c..b95fa25 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1165,7 +1165,6 @@ struct ieee802_11_elems {
 	u8 prep_len;
 	u8 perr_len;
 	u8 country_elem_len;
-	u8 pwr_constr_elem_len;
 	u8 quiet_elem_len;
 	u8 num_of_quiet_elem;	/* can be more the one */
 	u8 timeout_int_len;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6e374cb..8746694 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -821,18 +821,13 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 }
 
 static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
-					u16 capab_info, u8 *pwr_constr_elem,
-					u8 pwr_constr_elem_len)
+					u16 capab_info, u8 *pwr_constr_elem)
 {
 	struct ieee80211_conf *conf = &sdata->local->hw.conf;
 
 	if (!(capab_info & WLAN_CAPABILITY_SPECTRUM_MGMT))
 		return;
 
-	/* Power constraint IE length should be 1 octet */
-	if (pwr_constr_elem_len != 1)
-		return;
-
 	if ((*pwr_constr_elem <= conf->channel->max_reg_power) &&
 	    (*pwr_constr_elem != sdata->local->power_constr_level)) {
 		sdata->local->power_constr_level = *pwr_constr_elem;
@@ -2552,8 +2547,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		if (elems.pwr_constr_elem)
 			ieee80211_handle_pwr_constr(sdata,
 				le16_to_cpu(mgmt->u.probe_resp.capab_info),
-				elems.pwr_constr_elem,
-				elems.pwr_constr_elem_len);
+				elems.pwr_constr_elem);
 	}
 
 	ieee80211_bss_info_change_notify(sdata, changed);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 471fb05..ed75439 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -792,8 +792,11 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			elems->country_elem_len = elen;
 			break;
 		case WLAN_EID_PWR_CONSTRAINT:
+			if (elen != 1) {
+				elem_parse_failed = true;
+				break;
+			}
 			elems->pwr_constr_elem = pos;
-			elems->pwr_constr_elem_len = elen;
 			break;
 		case WLAN_EID_TIMEOUT_INTERVAL:
 			elems->timeout_int = pos;
-- 
1.7.10.4

