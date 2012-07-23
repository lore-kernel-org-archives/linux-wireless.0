Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab2GWNaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 09:30:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC/RFT 1/6] mac80211: use oper_channel in mesh
Date: Mon, 23 Jul 2012 15:30:06 +0200
Message-Id: <1343050211-499-2-git-send-email-johannes@sipsolutions.net> (sfid-20120723_153037_792218_D964A535)
In-Reply-To: <1343050211-499-1-git-send-email-johannes@sipsolutions.net>
References: <1343050211-499-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using hw.conf.channel is wrong as it could be the
temporary channel if any function like the beacon
get function is called while scanning or during
other temporary out-of-channel activities.

Use oper_channel instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 764593d..e6d1788 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -349,17 +349,18 @@ int mesh_add_ds_params_ie(struct sk_buff *skb,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *chan = local->oper_channel;
 	u8 *pos;
 
 	if (skb_tailroom(skb) < 3)
 		return -ENOMEM;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[chan->band];
 	if (sband->band == IEEE80211_BAND_2GHZ) {
 		pos = skb_put(skb, 2 + 1);
 		*pos++ = WLAN_EID_DS_PARAMS;
 		*pos++ = 1;
-		*pos++ = ieee80211_frequency_to_channel(local->hw.conf.channel->center_freq);
+		*pos++ = ieee80211_frequency_to_channel(chan->center_freq);
 	}
 
 	return 0;
@@ -603,7 +604,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(sdata->local,
-					  sdata->local->hw.conf.channel->band);
+					  sdata->local->oper_channel->band);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_HT |
-- 
1.7.10.4

