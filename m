Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60150 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2CHODP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 09:03:15 -0500
Message-Id: <20120308140226.857825320@sipsolutions.net> (sfid-20120308_150321_590543_712300B6)
Date: Thu, 08 Mar 2012 15:02:04 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] mac80211: simplify HT checks
References: <20120308140202.751490800@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Always set/use IEEE80211_STA_DISABLE_11N instead
of duplicating the queue, WMM and HT checks in
all places.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   57 +++++++++++++++++++++++-----------------------------
 1 file changed, 26 insertions(+), 31 deletions(-)

--- a/net/mac80211/mlme.c	2012-03-08 13:19:50.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-08 13:19:55.000000000 +0100
@@ -192,33 +192,27 @@ static u32 ieee80211_enable_ht(struct ie
 	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
 	prev_chantype = sdata->vif.bss_conf.channel_type;
 
-	/* HT is not supported */
-	if (!sband->ht_cap.ht_supported)
-		enable_ht = false;
 
-	if (enable_ht) {
-		hti_cfreq = ieee80211_channel_to_frequency(hti->control_chan,
-							   sband->band);
-		/* check that channel matches the right operating channel */
-		if (local->hw.conf.channel->center_freq != hti_cfreq) {
-			/* Some APs mess this up, evidently.
-			 * Netgear WNDR3700 sometimes reports 4 higher than
-			 * the actual channel, for instance.
-			 */
-			printk(KERN_DEBUG
-			       "%s: Wrong control channel in association"
-			       " response: configured center-freq: %d"
-			       " hti-cfreq: %d  hti->control_chan: %d"
-			       " band: %d.  Disabling HT.\n",
-			       sdata->name,
-			       local->hw.conf.channel->center_freq,
-			       hti_cfreq, hti->control_chan,
-			       sband->band);
-			enable_ht = false;
-		}
+	hti_cfreq = ieee80211_channel_to_frequency(hti->control_chan,
+						   sband->band);
+	/* check that channel matches the right operating channel */
+	if (local->hw.conf.channel->center_freq != hti_cfreq) {
+		/* Some APs mess this up, evidently.
+		 * Netgear WNDR3700 sometimes reports 4 higher than
+		 * the actual channel, for instance.
+		 */
+		printk(KERN_DEBUG
+		       "%s: Wrong control channel in association"
+		       " response: configured center-freq: %d"
+		       " hti-cfreq: %d  hti->control_chan: %d"
+		       " band: %d.  Disabling HT.\n",
+		       sdata->name,
+		       local->hw.conf.channel->center_freq,
+		       hti_cfreq, hti->control_chan,
+		       sband->band);
+		enable_ht = false;
 	}
 
 	if (enable_ht) {
@@ -335,9 +329,6 @@ static void ieee80211_add_ht_ie(struct i
 
 	BUILD_BUG_ON(sizeof(ht_cap) != sizeof(sband->ht_cap));
 
-	if (!sband->ht_cap.ht_supported)
-		return;
-
 	if (!ht_info_ie)
 		return;
 
@@ -405,7 +396,6 @@ static void ieee80211_send_assoc(struct
 	u16 capab;
 	struct ieee80211_supported_band *sband;
 	u32 rates = 0;
-	struct ieee80211_bss *bss = (void *)assoc_data->bss->priv;
 
 	lockdep_assert_held(&ifmgd->mtx);
 
@@ -566,8 +556,7 @@ static void ieee80211_send_assoc(struct
 		offset = noffset;
 	}
 
-	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N) &&
-	    bss->wmm_used && local->hw.queues >= 4)
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		ieee80211_add_ht_ie(sdata, skb, assoc_data->ht_information_ie,
 				    sband, local->oper_channel, ifmgd->ap_smps);
 
@@ -2162,7 +2151,6 @@ static bool ieee80211_assoc_success(stru
 	changed |= BSS_CHANGED_QOS;
 
 	if (elems.ht_info_elem && elems.wmm_param &&
-	    (sdata->local->hw.queues >= 4) &&
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
 					       cbss->bssid, ap_ht_cap_flags,
@@ -3274,6 +3262,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss *bss = (void *)req->bss->priv;
 	struct ieee80211_mgd_assoc_data *assoc_data;
+	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 	const u8 *ssidie;
 	int i, err;
@@ -3332,6 +3321,12 @@ int ieee80211_mgd_assoc(struct ieee80211
 	if (req->flags & ASSOC_REQ_DISABLE_HT)
 		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
+	/* Also disable HT if we don't support it or the AP doesn't use WMM */
+	sband = local->hw.wiphy->bands[req->bss->channel->band];
+	if (!sband->ht_cap.ht_supported ||
+	    local->hw.queues < 4 || !bss->wmm_used)
+		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+
 	memcpy(&ifmgd->ht_capa, &req->ht_capa, sizeof(ifmgd->ht_capa));
 	memcpy(&ifmgd->ht_capa_mask, &req->ht_capa_mask,
 	       sizeof(ifmgd->ht_capa_mask));


