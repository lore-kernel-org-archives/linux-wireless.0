Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47921 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840AbZGPJdP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:33:15 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 08/10] iwmc3200wifi: remove key caches in driver
Date: Thu, 16 Jul 2009 17:34:13 +0800
Message-Id: <1247736854-6760-9-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1247736854-6760-8-git-send-email-yi.zhu@intel.com>
References: <1247736854-6760-1-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-2-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-3-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-4-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-5-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-6-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-7-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 now guarantees keys are set after connecting. We can remove
the key cache code from the driver now.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   43 +-------------------------
 drivers/net/wireless/iwmc3200wifi/commands.c |   29 +-----------------
 2 files changed, 2 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 0372658..3f5a08f 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -158,34 +158,6 @@ static int iwm_key_init(struct iwm_key *key, u8 key_index,
 	return 0;
 }
 
-static int iwm_reset_profile(struct iwm_priv *iwm)
-{
-	int ret;
-
-	if (!iwm->umac_profile_active)
-		return 0;
-
-	/*
-	 * If there is a current active profile, but no
-	 * default key, it's not worth trying to associate again.
-	 */
-	if (iwm->default_key < 0)
-		return 0;
-
-	/*
-	 * Here we have an active profile, but a key setting changed.
-	 * We thus have to invalidate the current profile, and push the
-	 * new one. Keys will be pushed when association takes place.
-	 */
-	ret = iwm_invalidate_mlme_profile(iwm);
-	if (ret < 0) {
-		IWM_ERR(iwm, "Couldn't invalidate profile\n");
-		return ret;
-	}
-
-	return iwm_send_mlme_profile(iwm);
-}
-
 static int iwm_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 				u8 key_index, const u8 *mac_addr,
 				struct key_params *params)
@@ -245,10 +217,6 @@ static int iwm_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (key_index == iwm->default_key)
 		iwm->default_key = -1;
 
-	/* If the interface is down, we just cache this */
-	if (!test_bit(IWM_STATUS_READY, &iwm->status))
-		return 0;
-
 	return iwm_set_key(iwm, 1, key);
 }
 
@@ -257,7 +225,6 @@ static int iwm_cfg80211_set_default_key(struct wiphy *wiphy,
 					u8 key_index)
 {
 	struct iwm_priv *iwm = ndev_to_iwm(ndev);
-	int ret;
 
 	IWM_DBG_WEXT(iwm, DBG, "Default key index is: %d\n", key_index);
 
@@ -268,15 +235,7 @@ static int iwm_cfg80211_set_default_key(struct wiphy *wiphy,
 
 	iwm->default_key = key_index;
 
-	/* If the interface is down, we just cache this */
-	if (!test_bit(IWM_STATUS_READY, &iwm->status))
-		return 0;
-
-	ret = iwm_set_tx_key(iwm, key_index);
-	if (ret < 0)
-		return ret;
-
-	return iwm_reset_profile(iwm);
+	return iwm_set_tx_key(iwm, key_index);
 }
 
 int iwm_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index e6be297..0d66370 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -584,12 +584,6 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, struct iwm_key *key)
 	struct iwm_umac_key_tkip *tkip = (struct iwm_umac_key_tkip *)cmd;
 	struct iwm_umac_key_ccmp *ccmp = (struct iwm_umac_key_ccmp *)cmd;
 
-	/*
-	 * We check if our current profile is valid.
-	 * If not, we dont push the key, we just cache them,
-	 * so that with the next siwsessid call, the keys
-	 * will be actually pushed.
-	 */
 	if (!remove) {
 		ret = iwm_check_profile(iwm);
 		if (ret < 0)
@@ -727,7 +721,7 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, struct iwm_key *key)
 
 int iwm_send_mlme_profile(struct iwm_priv *iwm)
 {
-	int ret, i;
+	int ret;
 	struct iwm_umac_profile profile;
 
 	memcpy(&profile, iwm->umac_profile, sizeof(profile));
@@ -742,27 +736,6 @@ int iwm_send_mlme_profile(struct iwm_priv *iwm)
 		return ret;
 	}
 
-	for (i = 0; i < IWM_NUM_KEYS; i++)
-		if (iwm->keys[i].key_len) {
-			struct iwm_key *key = &iwm->keys[i];
-
-			/* Wait for the profile before sending the keys */
-			wait_event_interruptible_timeout(iwm->mlme_queue,
-			     (test_bit(IWM_STATUS_ASSOCIATING, &iwm->status) ||
-			      test_bit(IWM_STATUS_ASSOCIATED, &iwm->status)),
-							 3 * HZ);
-
-			ret = iwm_set_key(iwm, 0, key);
-			if (ret)
-				return ret;
-
-			if (iwm->default_key == i) {
-				ret = iwm_set_tx_key(iwm, i);
-				if (ret)
-					return ret;
-			}
-		}
-
 	return 0;
 }
 
-- 
1.6.0.4

