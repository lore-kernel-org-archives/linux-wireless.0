Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2IKNZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 09:25:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 10/12] mac80211: fix power constraint patch for multi-channel
Date: Tue, 11 Sep 2012 15:26:21 +0200
Message-Id: <1347369983-12459-11-git-send-email-johannes@sipsolutions.net> (sfid-20120911_152559_792886_9CBEDEEB)
In-Reply-To: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
References: <1347369983-12459-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

TBD: need to combine with one of the two patches involved

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f359af1..a717392 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2411,7 +2411,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	struct ieee802_11_elems elems;
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *chanctx_conf;
-	enum ieee80211_band band;
+	struct ieee80211_channel *chan;
 	u32 changed = 0;
 	bool erp_valid, directed_tim = false;
 	u8 erp_value = 0;
@@ -2436,7 +2436,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		rcu_read_unlock();
 		return;
 	}
-	band = chanctx_conf->channel->band;
+	chan = chanctx_conf->channel;
 	rcu_read_unlock();
 
 	if (ifmgd->assoc_data && !ifmgd->assoc_data->have_beacon &&
@@ -2600,7 +2600,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N)) {
 		struct ieee80211_supported_band *sband;
 
-		sband = local->hw.wiphy->bands[band];
+		sband = local->hw.wiphy->bands[chan->band];
 
 		changed |= ieee80211_config_ht_tx(sdata, elems.ht_operation,
 						  bssid, true);
@@ -2609,7 +2609,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	if (elems.country_elem && elems.pwr_constr_elem &&
 	    mgmt->u.probe_resp.capab_info &
 				cpu_to_le16(WLAN_CAPABILITY_SPECTRUM_MGMT))
-		ieee80211_handle_pwr_constr(sdata, local->oper_channel,
+		ieee80211_handle_pwr_constr(sdata, chan,
 					    elems.country_elem,
 					    elems.country_elem_len,
 					    elems.pwr_constr_elem);
-- 
1.7.10.4

