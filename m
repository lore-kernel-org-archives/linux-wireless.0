Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39010 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760121Ab3ECHkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 03:40:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: c_manoha@qca.qualcomm.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix HT beacon-based channel switch handling
Date: Fri,  3 May 2013 09:39:56 +0200
Message-Id: <1367566796-12195-1-git-send-email-johannes@sipsolutions.net> (sfid-20130503_094010_387310_68695A71)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an HT AP is advertising channel switch in a beacon, it
doesn't (and shouldn't, according to 802.11-2012 Table 8-20)
include a secondary channel offset element. The only possible
interpretation is that the previous secondary channel offset
remains valid, so use that when switching channel based only
on beacon information.

VHT requires the Wide Bandwidth Channel Switch subelement to
be present in the Channel Switch Wrapper element, so the code
for that is probably ok (see 802.11ac Draft 4, 8.4.2.165.)

Reported-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e8ef6dc..2bfcdda 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1015,7 +1015,8 @@ static void ieee80211_chswitch_timer(unsigned long data)
 
 static void
 ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
-				 u64 timestamp, struct ieee802_11_elems *elems)
+				 u64 timestamp, struct ieee802_11_elems *elems,
+				 bool beacon)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -1032,6 +1033,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_chan_def new_vht_chandef = {};
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
 	const struct ieee80211_wide_bw_chansw_ie *wide_bw_chansw_ie;
+	const struct ieee80211_ht_operation *ht_oper;
 	int secondary_channel_offset = -1;
 
 	ASSERT_MGD_MTX(ifmgd);
@@ -1048,11 +1050,14 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	sec_chan_offs = elems->sec_chan_offs;
 	wide_bw_chansw_ie = elems->wide_bw_chansw_ie;
+	ht_oper = elems->ht_operation;
 
 	if (ifmgd->flags & (IEEE80211_STA_DISABLE_HT |
 			    IEEE80211_STA_DISABLE_40MHZ)) {
 		sec_chan_offs = NULL;
 		wide_bw_chansw_ie = NULL;
+		/* only used for bandwidth here */
+		ht_oper = NULL;
 	}
 
 	if (ifmgd->flags & IEEE80211_STA_DISABLE_VHT)
@@ -1094,10 +1099,20 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
-	if (sec_chan_offs) {
+	if (!beacon && sec_chan_offs) {
 		secondary_channel_offset = sec_chan_offs->sec_chan_offs;
+	} else if (beacon && ht_oper) {
+		secondary_channel_offset =
+			ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET;
 	} else if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT)) {
-		/* if HT is enabled and the IE not present, it's still HT */
+		/*
+		 * If it's not a beacon, HT is enabled and the IE not present,
+		 * it's 20 MHz, 802.11-2012 8.5.2.6:
+		 *	This element [the Secondary Channel Offset Element] is
+		 *	present when switching to a 40 MHz channel. It may be
+		 *	present when switching to a 20 MHz channel (in which
+		 *	case the secondary channel offset is set to SCN).
+		 */
 		secondary_channel_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
 	}
 
@@ -2796,7 +2811,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		mutex_unlock(&local->iflist_mtx);
 	}
 
-	ieee80211_sta_process_chanswitch(sdata, rx_status->mactime, elems);
+	ieee80211_sta_process_chanswitch(sdata, rx_status->mactime,
+					 elems, true);
 
 }
 
@@ -3210,7 +3226,7 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 			ieee80211_sta_process_chanswitch(sdata,
 							 rx_status->mactime,
-							 &elems);
+							 &elems, false);
 		} else if (mgmt->u.action.category == WLAN_CATEGORY_PUBLIC) {
 			ies_len = skb->len -
 				  offsetof(struct ieee80211_mgmt,
@@ -3232,7 +3248,7 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 			ieee80211_sta_process_chanswitch(sdata,
 							 rx_status->mactime,
-							 &elems);
+							 &elems, false);
 		}
 		break;
 	}
-- 
1.8.0

