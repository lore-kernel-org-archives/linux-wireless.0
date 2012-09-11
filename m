Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40179 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2IKMp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 08:45:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: change locking around ieee80211_recalc_smps
Date: Tue, 11 Sep 2012 14:46:06 +0200
Message-Id: <1347367566-30660-1-git-send-email-johannes@sipsolutions.net> (sfid-20120911_144531_648560_39799CAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Make the function acquire the necessary mutex itself
to simplify the callers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c  |    2 --
 net/mac80211/main.c |    2 --
 net/mac80211/mlme.c |    2 +-
 net/mac80211/util.c |    7 ++++---
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 00e31b4..9bd56a7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2070,9 +2070,7 @@ int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (!sdata->u.mgd.associated ||
 	    sdata->vif.bss_conf.channel_type == NL80211_CHAN_NO_HT) {
-		mutex_lock(&sdata->local->iflist_mtx);
 		ieee80211_recalc_smps(sdata->local);
-		mutex_unlock(&sdata->local->iflist_mtx);
 		return 0;
 	}
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 416e85e..c80c449 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -364,9 +364,7 @@ static void ieee80211_recalc_smps_work(struct work_struct *work)
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, recalc_smps);
 
-	mutex_lock(&local->iflist_mtx);
 	ieee80211_recalc_smps(local);
-	mutex_unlock(&local->iflist_mtx);
 }
 
 #ifdef CONFIG_INET
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 45a9fa6..2dbd9e1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1348,9 +1348,9 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 
 	mutex_lock(&local->iflist_mtx);
 	ieee80211_recalc_ps(local, -1);
-	ieee80211_recalc_smps(local);
 	mutex_unlock(&local->iflist_mtx);
 
+	ieee80211_recalc_smps(local);
 	ieee80211_recalc_ps_vif(sdata);
 
 	netif_tx_start_all_queues(sdata->dev);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 2017904..22ca350 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1606,14 +1606,13 @@ static int check_mgd_smps(struct ieee80211_if_managed *ifmgd,
 	return 0;
 }
 
-/* must hold iflist_mtx */
 void ieee80211_recalc_smps(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 	enum ieee80211_smps_mode smps_mode = IEEE80211_SMPS_OFF;
 	int count = 0;
 
-	lockdep_assert_held(&local->iflist_mtx);
+	mutex_lock(&local->iflist_mtx);
 
 	/*
 	 * This function could be improved to handle multiple
@@ -1642,12 +1641,14 @@ void ieee80211_recalc_smps(struct ieee80211_local *local)
 	}
 
 	if (smps_mode == local->smps_mode)
-		return;
+		goto unlock;
 
  set:
 	local->smps_mode = smps_mode;
 	/* changed flag is auto-detected for this */
 	ieee80211_hw_config(local, 0);
+ unlock:
+	mutex_unlock(&local->iflist_mtx);
 }
 
 static bool ieee80211_id_in_list(const u8 *ids, int n_ids, u8 id)
-- 
1.7.10.4

