Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18453 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaCKOSE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 10:18:04 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com,
	eliad@wizery.com
Subject: [PATCH v10 4/5] cfg80211/mac80211: move combination check to mac80211 for ibss
Date: Tue, 11 Mar 2014 16:16:33 +0200
Message-Id: <1394547394-3910-5-git-send-email-luciano.coelho@intel.com> (sfid-20140311_151808_156940_AFCE0D15)
In-Reply-To: <1394547394-3910-1-git-send-email-luciano.coelho@intel.com>
References: <1394547394-3910-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that mac80211 can check the interface combinations itself, move
the combinations check from cfg80211 to mac80211 when joining an IBSS.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
In v2:

   * lock the chanctx mutex in ieee80211_ibss_join() before calling
     ieee80211_check_combinations(). (Thanks Michal);

   * pass the mode argument instead of IEEE80211_CHANCTX_SHARED to
     ieee80211_check_combinations() in ieee80211_vif_use_channel();

In v3:

   * moved the second change from v2 (pass the mode argument...) to
     the previous patch, where it should be;

In v4:

   * rebased on top of slightly modified applied patches

In v5:

   * use local and sdata in ibss when calling
     ieee80211_check_combinations()

In v7:

   * don't pass local in ieee80211_check_combinations() anymore;

In v8:

   * fix radar_detect_width before calling
     ieee80211_check_combinations() -- rebase bug;

In v9:

   * pass sdata->wdev.iftype instead of sdata->vif.type when calling
     cfg80211_chandef_dfs_required();
---
 net/mac80211/ibss.c | 32 +++++++++++++++++++++++++++++---
 net/wireless/ibss.c | 28 ----------------------------
 2 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 12057fd..72b9337 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1644,7 +1644,33 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	u32 changed = 0;
 	u32 rate_flags;
 	struct ieee80211_supported_band *sband;
+	enum ieee80211_chanctx_mode chanmode;
+	struct ieee80211_local *local = sdata->local;
+	int radar_detect_width = 0;
 	int i;
+	int ret;
+
+	ret = cfg80211_chandef_dfs_required(local->hw.wiphy,
+					    &params->chandef,
+					    sdata->wdev.iftype);
+	if (ret < 0)
+		return ret;
+
+	if (ret > 0) {
+		if (!params->userspace_handles_dfs)
+			return -EINVAL;
+		radar_detect_width = BIT(params->chandef.width);
+	}
+
+	chanmode = (params->channel_fixed && !ret) ?
+		IEEE80211_CHANCTX_SHARED : IEEE80211_CHANCTX_EXCLUSIVE;
+
+	mutex_lock(&local->chanctx_mtx);
+	ret = ieee80211_check_combinations(sdata, &params->chandef, chanmode,
+					   radar_detect_width);
+	mutex_unlock(&local->chanctx_mtx);
+	if (ret < 0)
+		return ret;
 
 	if (params->bssid) {
 		memcpy(sdata->u.ibss.bssid, params->bssid, ETH_ALEN);
@@ -1659,7 +1685,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 	/* fix basic_rates if channel does not support these rates */
 	rate_flags = ieee80211_chandef_rate_flags(&params->chandef);
-	sband = sdata->local->hw.wiphy->bands[params->chandef.chan->band];
+	sband = local->hw.wiphy->bands[params->chandef.chan->band];
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
 			sdata->u.ibss.basic_rates &= ~BIT(i);
@@ -1708,9 +1734,9 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
-	sdata->needed_rx_chains = sdata->local->rx_chains;
+	sdata->needed_rx_chains = local->rx_chains;
 
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 
 	return 0;
 }
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index d81cb68..8282de8 100644
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
@@ -126,32 +124,6 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.ibss.chandef = params->chandef;
 #endif
-	check_chan = params->chandef.chan;
-	if (params->userspace_handles_dfs) {
-		/* Check for radar even if the current channel is not
-		 * a radar channel - it might decide to change to DFS
-		 * channel later.
-		 */
-		radar_detect_width = BIT(params->chandef.width);
-	}
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
1.9.0

