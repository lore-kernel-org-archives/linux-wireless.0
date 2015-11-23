Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:54731 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbbKWS1y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 13:27:54 -0500
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	=?UTF-8?q?Jan=20Kaisrl=C3=ADk?= <kaisrja1@fel.cvut.cz>,
	Michal Sojka <sojkam1@fel.cvut.cz>
Subject: [PATCH v2 2/8] cfg80211: Remove unused cfg80211_can_use_iftype_chan()
Date: Mon, 23 Nov 2015 19:27:15 +0100
Message-Id: <1448303241-27747-3-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151123_192818_058797_3713F391)
In-Reply-To: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Last caller of this function was removed in 3.17 in commit
97dc94f1d933c9df2c0b327066ea130c0e92083f.

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
---
 net/wireless/core.h |   7 ----
 net/wireless/util.c | 114 ----------------------------------------------------
 2 files changed, 121 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index a618b4b..022ccad 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -416,13 +416,6 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
 void cfg80211_process_wdev_events(struct wireless_dev *wdev);
 
-int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
-				 struct wireless_dev *wdev,
-				 enum nl80211_iftype iftype,
-				 struct ieee80211_channel *chan,
-				 enum cfg80211_chan_mode chanmode,
-				 u8 radar_detect);
-
 /**
  * cfg80211_chandef_dfs_usable - checks if chandef is DFS usable
  * @wiphy: the wiphy to validate against
diff --git a/net/wireless/util.c b/net/wireless/util.c
index baf7218..44d30cc 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1620,120 +1620,6 @@ int cfg80211_check_combinations(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_check_combinations);
 
-int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
-				 struct wireless_dev *wdev,
-				 enum nl80211_iftype iftype,
-				 struct ieee80211_channel *chan,
-				 enum cfg80211_chan_mode chanmode,
-				 u8 radar_detect)
-{
-	struct wireless_dev *wdev_iter;
-	int num[NUM_NL80211_IFTYPES];
-	struct ieee80211_channel
-			*used_channels[CFG80211_MAX_NUM_DIFFERENT_CHANNELS];
-	struct ieee80211_channel *ch;
-	enum cfg80211_chan_mode chmode;
-	int num_different_channels = 0;
-	int total = 1;
-	int i;
-
-	ASSERT_RTNL();
-
-	if (WARN_ON(hweight32(radar_detect) > 1))
-		return -EINVAL;
-
-	if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
-		return -EINVAL;
-
-	/* Always allow software iftypes */
-	if (rdev->wiphy.software_iftypes & BIT(iftype)) {
-		if (radar_detect)
-			return -EINVAL;
-		return 0;
-	}
-
-	memset(num, 0, sizeof(num));
-	memset(used_channels, 0, sizeof(used_channels));
-
-	num[iftype] = 1;
-
-	/* TODO: We'll probably not need this anymore, since this
-	 * should only be called with CHAN_MODE_UNDEFINED. There are
-	 * still a couple of pending calls where other chanmodes are
-	 * used, but we should get rid of them.
-	 */
-	switch (chanmode) {
-	case CHAN_MODE_UNDEFINED:
-		break;
-	case CHAN_MODE_SHARED:
-		WARN_ON(!chan);
-		used_channels[0] = chan;
-		num_different_channels++;
-		break;
-	case CHAN_MODE_EXCLUSIVE:
-		num_different_channels++;
-		break;
-	}
-
-	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
-		if (wdev_iter == wdev)
-			continue;
-		if (wdev_iter->iftype == NL80211_IFTYPE_P2P_DEVICE) {
-			if (!wdev_iter->p2p_started)
-				continue;
-		} else if (wdev_iter->netdev) {
-			if (!netif_running(wdev_iter->netdev))
-				continue;
-		} else {
-			WARN_ON(1);
-		}
-
-		if (rdev->wiphy.software_iftypes & BIT(wdev_iter->iftype))
-			continue;
-
-		/*
-		 * We may be holding the "wdev" mutex, but now need to lock
-		 * wdev_iter. This is OK because once we get here wdev_iter
-		 * is not wdev (tested above), but we need to use the nested
-		 * locking for lockdep.
-		 */
-		mutex_lock_nested(&wdev_iter->mtx, 1);
-		__acquire(wdev_iter->mtx);
-		cfg80211_get_chan_state(wdev_iter, &ch, &chmode, &radar_detect);
-		wdev_unlock(wdev_iter);
-
-		switch (chmode) {
-		case CHAN_MODE_UNDEFINED:
-			break;
-		case CHAN_MODE_SHARED:
-			for (i = 0; i < CFG80211_MAX_NUM_DIFFERENT_CHANNELS; i++)
-				if (!used_channels[i] || used_channels[i] == ch)
-					break;
-
-			if (i == CFG80211_MAX_NUM_DIFFERENT_CHANNELS)
-				return -EBUSY;
-
-			if (used_channels[i] == NULL) {
-				used_channels[i] = ch;
-				num_different_channels++;
-			}
-			break;
-		case CHAN_MODE_EXCLUSIVE:
-			num_different_channels++;
-			break;
-		}
-
-		num[wdev_iter->iftype]++;
-		total++;
-	}
-
-	if (total == 1 && !radar_detect)
-		return 0;
-
-	return cfg80211_check_combinations(&rdev->wiphy, num_different_channels,
-					   radar_detect, num);
-}
-
 int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 			   const u8 *rates, unsigned int n_rates,
 			   u32 *mask)
-- 
2.5.3

