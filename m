Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:58373 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306AbbGHMmJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 08:42:09 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/10] mac80211: TDLS: deny ch-switch req on disallowed channels
Date: Wed,  8 Jul 2015 15:41:46 +0300
Message-Id: <1436359312-26533-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144216_289288_2658F741)
In-Reply-To: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

If a TDLS station is not allowed to beacon on a channel, don't accept
a channel switch request to this channel.
Move channel building code up to avoid lockdep violations - reg_can_beacon
needs to take the wdev lock.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/tdls.c | 49 +++++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 91e86bf..aee701a 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1737,6 +1737,31 @@ ieee80211_process_tdls_channel_switch_req(struct ieee80211_sub_if_data *sdata,
 		return -EINVAL;
 	}
 
+	if (!elems.sec_chan_offs) {
+		chan_type = NL80211_CHAN_HT20;
+	} else {
+		switch (elems.sec_chan_offs->sec_chan_offs) {
+		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+			chan_type = NL80211_CHAN_HT40PLUS;
+			break;
+		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+			chan_type = NL80211_CHAN_HT40MINUS;
+			break;
+		default:
+			chan_type = NL80211_CHAN_HT20;
+			break;
+		}
+	}
+
+	cfg80211_chandef_create(&chandef, chan, chan_type);
+
+	/* we will be active on the TDLS link */
+	if (!cfg80211_reg_can_beacon_relax(sdata->local->hw.wiphy, &chandef,
+					   sdata->wdev.iftype)) {
+		tdls_dbg(sdata, "TDLS chan switch to forbidden channel\n");
+		return -EINVAL;
+	}
+
 	mutex_lock(&local->sta_mtx);
 	sta = sta_info_get(sdata, tf->sa);
 	if (!sta || !test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH)) {
@@ -1757,27 +1782,15 @@ ieee80211_process_tdls_channel_switch_req(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	if (!sta->sta.ht_cap.ht_supported) {
-		chan_type = NL80211_CHAN_NO_HT;
-	} else if (!elems.sec_chan_offs) {
-		chan_type = NL80211_CHAN_HT20;
-	} else {
-		switch (elems.sec_chan_offs->sec_chan_offs) {
-		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-			chan_type = NL80211_CHAN_HT40PLUS;
-			break;
-		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-			chan_type = NL80211_CHAN_HT40MINUS;
-			break;
-		default:
-			chan_type = NL80211_CHAN_HT20;
-			break;
-		}
+	/* peer should have known better */
+	if (!sta->sta.ht_cap.ht_supported && elems.sec_chan_offs &&
+	    elems.sec_chan_offs->sec_chan_offs) {
+		tdls_dbg(sdata, "TDLS chan switch - wide chan unsupported\n");
+		ret = -ENOTSUPP;
+		goto out;
 	}
 
-	cfg80211_chandef_create(&chandef, chan, chan_type);
 	params.chandef = &chandef;
-
 	params.switch_time = le16_to_cpu(elems.ch_sw_timing->switch_time);
 	params.switch_timeout = le16_to_cpu(elems.ch_sw_timing->switch_timeout);
 
-- 
2.1.4

