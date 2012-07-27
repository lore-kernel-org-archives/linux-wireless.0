Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2G0LIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:08:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/6] mac80211: use oper_channel in managed mlme
Date: Fri, 27 Jul 2012 13:07:58 +0200
Message-Id: <1343387281-7252-4-git-send-email-johannes@sipsolutions.net> (sfid-20120727_130817_819456_AA1F889F)
In-Reply-To: <1343387281-7252-1-git-send-email-johannes@sipsolutions.net>
References: <1343387281-7252-1-git-send-email-johannes@sipsolutions.net>
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
 net/mac80211/mlme.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d068eea..e2c67cb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -185,15 +185,15 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
 	u16 ht_opmode;
 	bool disable_40 = false;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[local->oper_channel->band];
 
 	switch (sdata->vif.bss_conf.channel_type) {
 	case NL80211_CHAN_HT40PLUS:
-		if (local->hw.conf.channel->flags & IEEE80211_CHAN_NO_HT40PLUS)
+		if (local->oper_channel->flags & IEEE80211_CHAN_NO_HT40PLUS)
 			disable_40 = true;
 		break;
 	case NL80211_CHAN_HT40MINUS:
-		if (local->hw.conf.channel->flags & IEEE80211_CHAN_NO_HT40MINUS)
+		if (local->oper_channel->flags & IEEE80211_CHAN_NO_HT40MINUS)
 			disable_40 = true;
 		break;
 	default:
@@ -1264,7 +1264,7 @@ static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 	}
 
 	use_short_slot = !!(capab & WLAN_CAPABILITY_SHORT_SLOT_TIME);
-	if (sdata->local->hw.conf.channel->band == IEEE80211_BAND_5GHZ)
+	if (sdata->local->oper_channel->band == IEEE80211_BAND_5GHZ)
 		use_short_slot = true;
 
 	if (use_protection != bss_conf->use_cts_prot) {
@@ -2349,7 +2349,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	if (baselen > len)
 		return;
 
-	if (rx_status->freq != local->hw.conf.channel->center_freq)
+	if (rx_status->freq != local->oper_channel->center_freq)
 		return;
 
 	if (ifmgd->assoc_data && !ifmgd->assoc_data->have_beacon &&
@@ -2513,7 +2513,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N)) {
 		struct ieee80211_supported_band *sband;
 
-		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+		sband = local->hw.wiphy->bands[local->oper_channel->band];
 
 		changed |= ieee80211_config_ht_tx(sdata, elems.ht_operation,
 						  bssid, true);
-- 
1.7.10.4

