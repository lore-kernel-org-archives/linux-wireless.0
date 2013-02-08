Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60275 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3BHR2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:28:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 11/14] mac80211: clean up channel use in ieee80211_config_ht_tx
Date: Fri,  8 Feb 2013 18:25:41 +0100
Message-Id: <1360344344-15742-12-git-send-email-johannes@sipsolutions.net> (sfid-20130208_190812_885353_2DCE361E)
In-Reply-To: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
References: <1360344344-15742-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The channel use is confusing, some uses the channel
context and some the bss_conf.chandef. The latter is
fine, so get rid of the channel context part.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 440e448..8af59f8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -181,7 +181,6 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *chan;
 	u32 changed = 0;
 	u16 ht_opmode;
@@ -190,23 +189,16 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
 	if (WARN_ON_ONCE(!sta))
 		return 0;
 
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-	if (WARN_ON(!chanctx_conf)) {
-		rcu_read_unlock();
-		return 0;
-	}
-	chan = chanctx_conf->def.chan;
-	rcu_read_unlock();
+	chan = sdata->vif.bss_conf.chandef.chan;
 	sband = local->hw.wiphy->bands[chan->band];
 
 	switch (sdata->vif.bss_conf.chandef.width) {
 	case NL80211_CHAN_WIDTH_40:
-		if (sdata->vif.bss_conf.chandef.chan->center_freq >
+		if (chan->center_freq >
 				sdata->vif.bss_conf.chandef.center_freq1 &&
 		    chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
 			disable_40 = true;
-		if (sdata->vif.bss_conf.chandef.chan->center_freq <
+		if (chan->center_freq <
 				sdata->vif.bss_conf.chandef.center_freq1 &&
 		    chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
 			disable_40 = true;
-- 
1.8.0

