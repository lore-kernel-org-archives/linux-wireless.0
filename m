Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43878 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab2HAPVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 11:21:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 4/8] mac80211: check size of channel switch IE when parsing
Date: Wed,  1 Aug 2012 17:21:23 +0200
Message-Id: <1343834487-23737-5-git-send-email-johannes@sipsolutions.net> (sfid-20120801_172154_224877_D259B8B1)
In-Reply-To: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
References: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The channel switch IE has a fixed size, so we can
discard it in parsing if it's not the right size
and use the right struct pointer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    3 +--
 net/mac80211/mlme.c        |   10 +++-------
 net/mac80211/util.c        |    7 +++++--
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d1a7c58..a906cc0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1130,7 +1130,7 @@ struct ieee802_11_elems {
 	u8 *prep;
 	u8 *perr;
 	struct ieee80211_rann_ie *rann;
-	u8 *ch_switch_elem;
+	struct ieee80211_channel_sw_ie *ch_switch_ie;
 	u8 *country_elem;
 	u8 *pwr_constr_elem;
 	u8 *quiet_elem;	/* first quite element */
@@ -1156,7 +1156,6 @@ struct ieee802_11_elems {
 	u8 preq_len;
 	u8 prep_len;
 	u8 perr_len;
-	u8 ch_switch_elem_len;
 	u8 country_elem_len;
 	u8 pwr_constr_elem_len;
 	u8 quiet_elem_len;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5eef6bd..d963017 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2267,14 +2267,10 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		mutex_unlock(&local->iflist_mtx);
 	}
 
-	if (elems->ch_switch_elem && (elems->ch_switch_elem_len == 3) &&
-	    (memcmp(mgmt->bssid, sdata->u.mgd.associated->bssid,
-							ETH_ALEN) == 0)) {
-		struct ieee80211_channel_sw_ie *sw_elem =
-			(struct ieee80211_channel_sw_ie *)elems->ch_switch_elem;
-		ieee80211_sta_process_chanswitch(sdata, sw_elem,
+	if (elems->ch_switch_ie &&
+	    memcmp(mgmt->bssid, sdata->u.mgd.associated->bssid, ETH_ALEN) == 0)
+		ieee80211_sta_process_chanswitch(sdata, elems->ch_switch_ie,
 						 bss, rx_status->mactime);
-	}
 }
 
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 99e4258..7dff94e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -768,8 +768,11 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 				elem_parse_failed = true;
 			break;
 		case WLAN_EID_CHANNEL_SWITCH:
-			elems->ch_switch_elem = pos;
-			elems->ch_switch_elem_len = elen;
+			if (elen != sizeof(struct ieee80211_channel_sw_ie)) {
+				elem_parse_failed = true;
+				break;
+			}
+			elems->ch_switch_ie = (void *)pos;
 			break;
 		case WLAN_EID_QUIET:
 			if (!elems->quiet_elem) {
-- 
1.7.10.4

