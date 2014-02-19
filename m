Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:34699 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaBSKAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 05:00:54 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Subject: [PATCH 7/7] cfg80211/mac80211: move combination check to mac80211 for ibss
Date: Wed, 19 Feb 2014 12:00:45 +0200
Message-Id: <1392804045-11258-8-git-send-email-luca@coelho.fi> (sfid-20140219_110109_390652_3B011F75)
In-Reply-To: <1392804045-11258-1-git-send-email-luca@coelho.fi>
References: <1392804045-11258-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Now that mac80211 can check the interface combinations itself, move
the combinations check from cfg80211 to mac80211 when joining an IBSS.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ibss.c | 28 +++++++++++++++++++++++++---
 net/wireless/ibss.c | 27 ---------------------------
 2 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 56b0dce..49a25aa 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1646,7 +1646,29 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	u32 changed = 0;
 	u32 rate_flags;
 	struct ieee80211_supported_band *sband;
+	enum ieee80211_chanctx_mode chanmode;
+	struct ieee80211_local *local = sdata->local;
+	int radar_detect_width;
 	int i;
+	int ret;
+
+	radar_detect_width = cfg80211_chandef_dfs_required(local->hw.wiphy,
+							   &params->chandef,
+							   sdata->vif.type);
+	if (radar_detect_width < 0)
+		return radar_detect_width;
+
+	if (radar_detect_width > 0 && !params->userspace_handles_dfs)
+		return -EINVAL;
+
+	chanmode = (params->channel_fixed && !radar_detect_width) ?
+		IEEE80211_CHANCTX_SHARED : IEEE80211_CHANCTX_EXCLUSIVE;
+
+	ret = ieee80211_check_combinations(local->hw.wiphy, &sdata->wdev,
+					   &params->chandef, chanmode,
+					   radar_detect_width);
+	if (ret < 0)
+		return ret;
 
 	if (params->bssid) {
 		memcpy(sdata->u.ibss.bssid, params->bssid, ETH_ALEN);
@@ -1661,7 +1683,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 	/* fix basic_rates if channel does not support these rates */
 	rate_flags = ieee80211_chandef_rate_flags(&params->chandef);
-	sband = sdata->local->hw.wiphy->bands[params->chandef.chan->band];
+	sband = local->hw.wiphy->bands[params->chandef.chan->band];
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
 			sdata->u.ibss.basic_rates &= ~BIT(i);
@@ -1710,9 +1732,9 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
-	sdata->needed_rx_chains = sdata->local->rx_chains;
+	sdata->needed_rx_chains = local->rx_chains;
 
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 
 	return 0;
 }
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 6e98e49..8282de8 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -88,8 +88,6 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 			 struct cfg80211_cached_keys *connkeys)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct ieee80211_channel *check_chan;
-	u8 radar_detect_width = 0;
 	int err;
 
 	ASSERT_WDEV_LOCK(wdev);
@@ -126,31 +124,6 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.ibss.chandef = params->chandef;
 #endif
-	check_chan = params->chandef.chan;
-	if (params->userspace_handles_dfs)
-		/* Check for radar even if the current channel is not
-		 * a radar channel - it might decide to change to DFS
-		 * channel later.
-		 */
-		radar_detect_width = BIT(params->chandef.width);
-
-	/* TODO: We need to check the combinations at this point, we
-	 * probably must move this call down to join_ibss() in
-	 * mac80211.
-	 */
-	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
-					   check_chan,
-					   (params->channel_fixed &&
-					    !radar_detect_width)
-					   ? CHAN_MODE_SHARED
-					   : CHAN_MODE_EXCLUSIVE,
-					   radar_detect_width);
-
-	if (err) {
-		wdev->connect_keys = NULL;
-		return err;
-	}
-
 	err = rdev_join_ibss(rdev, dev, params);
 	if (err) {
 		wdev->connect_keys = NULL;
-- 
1.8.5.3

