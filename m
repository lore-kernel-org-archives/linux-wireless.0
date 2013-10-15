Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab3JONS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:18:58 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [PATCH 3.12 2/3] mac80211: respect rate mask in TX
Date: Tue, 15 Oct 2013 15:17:09 +0200
Message-Id: <1381843030-12260-2-git-send-email-johannes@sipsolutions.net> (sfid-20131015_151901_484331_5F7DE10E)
In-Reply-To: <1381843030-12260-1-git-send-email-johannes@sipsolutions.net>
References: <1381843030-12260-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Bitrate mask were not respected in transmissions, causing (for
example) P2P GO/client to use CCK rates for auth and assoc frames.
Fix it by considering the rate mask in __rate_control_send_low().

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rate.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 7f7ce11..22b223f 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -235,7 +235,8 @@ static void rc_send_low_basicrate(s8 *idx, u32 basic_rates,
 static void __rate_control_send_low(struct ieee80211_hw *hw,
 				    struct ieee80211_supported_band *sband,
 				    struct ieee80211_sta *sta,
-				    struct ieee80211_tx_info *info)
+				    struct ieee80211_tx_info *info,
+				    u32 rate_mask)
 {
 	int i;
 	u32 rate_flags =
@@ -247,6 +248,9 @@ static void __rate_control_send_low(struct ieee80211_hw *hw,
 
 	info->control.rates[0].idx = 0;
 	for (i = 0; i < sband->n_bitrates; i++) {
+		if (!(rate_mask & BIT(i)))
+			continue;
+
 		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
 			continue;
 
@@ -277,7 +281,8 @@ bool rate_control_send_low(struct ieee80211_sta *pubsta,
 	bool use_basicrate = false;
 
 	if (!pubsta || !priv_sta || rc_no_data_or_no_ack_use_min(txrc)) {
-		__rate_control_send_low(txrc->hw, sband, pubsta, info);
+		__rate_control_send_low(txrc->hw, sband, pubsta, info,
+					txrc->rate_idx_mask);
 
 		if (!pubsta && txrc->bss) {
 			mcast_rate = txrc->bss_conf->mcast_rate[sband->band];
@@ -659,7 +664,8 @@ void ieee80211_get_tx_rates(struct ieee80211_vif *vif,
 		rate_control_apply_mask(sdata, sta, sband, info, dest, max_rates);
 
 	if (dest[0].idx < 0)
-		__rate_control_send_low(&sdata->local->hw, sband, sta, info);
+		__rate_control_send_low(&sdata->local->hw, sband, sta, info,
+					sdata->rc_rateidx_mask[info->band]);
 
 	if (sta)
 		rate_fixup_ratelist(vif, sband, info, dest, max_rates);
-- 
1.8.4.rc3

