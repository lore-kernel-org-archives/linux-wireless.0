Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2G0LIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:08:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/6] mac80211: use oper_channel in utils and config
Date: Fri, 27 Jul 2012 13:07:59 +0200
Message-Id: <1343387281-7252-5-git-send-email-johannes@sipsolutions.net> (sfid-20120727_130814_873761_37CF50D7)
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
 net/mac80211/cfg.c   |    6 +++---
 net/mac80211/iface.c |    2 +-
 net/mac80211/util.c  |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 726e76c..5596e37 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -342,7 +342,7 @@ static void rate_idx_to_bitrate(struct rate_info *rate, struct sta_info *sta, in
 	if (!(rate->flags & RATE_INFO_FLAGS_MCS)) {
 		struct ieee80211_supported_band *sband;
 		sband = sta->local->hw.wiphy->bands[
-				sta->local->hw.conf.channel->band];
+				sta->local->oper_channel->band];
 		rate->legacy = sband->bitrates[idx].bitrate;
 	} else
 		rate->mcs = idx;
@@ -1673,7 +1673,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	}
 
 	if (!sdata->vif.bss_conf.use_short_slot &&
-	    sdata->local->hw.conf.channel->band == IEEE80211_BAND_5GHZ) {
+	    sdata->local->oper_channel->band == IEEE80211_BAND_5GHZ) {
 		sdata->vif.bss_conf.use_short_slot = true;
 		changed |= BSS_CHANGED_ERP_SLOT;
 	}
@@ -1940,7 +1940,7 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 				  enum nl80211_tx_power_setting type, int mbm)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
-	struct ieee80211_channel *chan = local->hw.conf.channel;
+	struct ieee80211_channel *chan = local->oper_channel;
 	u32 changes = 0;
 
 	switch (type) {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index f280e1f..ced8c6c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1296,7 +1296,7 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 	/* reset some values that shouldn't be kept across type changes */
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(sdata->local,
-			sdata->local->hw.conf.channel->band);
+			sdata->local->oper_channel->band);
 	sdata->drop_unencrypted = 0;
 	if (type == NL80211_IFTYPE_STATION)
 		sdata->u.mgd.use_4addr = false;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9fbc431..933fa98 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -838,7 +838,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 
 	memset(&qparam, 0, sizeof(qparam));
 
-	use_11b = (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ) &&
+	use_11b = (local->oper_channel->band == IEEE80211_BAND_2GHZ) &&
 		 !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE);
 
 	/*
@@ -926,7 +926,7 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 		if ((supp_rates[i] & 0x7f) * 5 > 110)
 			have_higher_than_11mbit = 1;
 
-	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
+	if (local->oper_channel->band == IEEE80211_BAND_2GHZ &&
 	    have_higher_than_11mbit)
 		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 	else
-- 
1.7.10.4

