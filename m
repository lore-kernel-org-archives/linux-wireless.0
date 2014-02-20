Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60117 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaBTJeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 04:34:50 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14] mac80211: insert stations before adding to driver
Date: Thu, 20 Feb 2014 10:34:46 +0100
Message-Id: <1392888886-15496-1-git-send-email-johannes@sipsolutions.net> (sfid-20140220_103455_107966_00580947)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's a race condition in mac80211 because we add stations
to the internal lists after adding them to the driver, which
means that (for example) the following can happen:
 1. a station connects and is added
 2. first, it is added to the driver
 3. then, it is added to the mac80211 lists

If the station goes to sleep between steps 2 and 3, and the
firmware/hardware records it as being asleep, mac80211 will
never instruct the driver to wake it up again as it never
realized it went to sleep since the RX path discarded the
frame as a "spurious class 3 frame", no station entry was
present yet.

Fix this by adding the station in software first, and only
then adding it to the driver. That way, any state that the
driver changes will be reflected properly in mac80211's
station state. The problematic part is the roll-back if the
driver fails to add the station, in that case a bit more is
needed. To not make that overly complex prevent starting BA
sessions in the meantime.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 62a5f0889583..ffc1ee6a2ec1 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -91,7 +91,7 @@ static int sta_info_hash_del(struct ieee80211_local *local,
 	return -ENOENT;
 }
 
-static void cleanup_single_sta(struct sta_info *sta)
+static void __cleanup_single_sta(struct sta_info *sta)
 {
 	int ac, i;
 	struct tid_ampdu_tx *tid_tx;
@@ -139,7 +139,14 @@ static void cleanup_single_sta(struct sta_info *sta)
 		ieee80211_purge_tx_queue(&local->hw, &tid_tx->pending);
 		kfree(tid_tx);
 	}
+}
 
+static void cleanup_single_sta(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+
+	__cleanup_single_sta(sta);
 	sta_info_free(local, sta);
 }
 
@@ -488,21 +495,26 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 		goto out_err;
 	}
 
-	/* notify driver */
-	err = sta_info_insert_drv_state(local, sdata, sta);
-	if (err)
-		goto out_err;
-
 	local->num_sta++;
 	local->sta_generation++;
 	smp_mb();
 
+	/* simplify things and don't accept BA sessions yet */
+	set_sta_flag(sta, WLAN_STA_BLOCK_BA);
+
 	/* make the station visible */
 	sta_info_hash_add(local, sta);
 
 	list_add_rcu(&sta->list, &local->sta_list);
 
+	/* notify driver */
+	err = sta_info_insert_drv_state(local, sdata, sta);
+	if (err)
+		goto out_remove;
+
 	set_sta_flag(sta, WLAN_STA_INSERTED);
+	/* accept BA sessions now */
+	clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
 
 	ieee80211_recalc_min_chandef(sdata);
 	ieee80211_sta_debugfs_add(sta);
@@ -523,6 +535,12 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 		mesh_accept_plinks_update(sdata);
 
 	return 0;
+ out_remove:
+	sta_info_hash_del(local, sta);
+	list_del_rcu(&sta->list);
+	local->num_sta--;
+	synchronize_net();
+	__cleanup_single_sta(sta);
  out_err:
 	mutex_unlock(&local->sta_mtx);
 	rcu_read_lock();
-- 
1.8.5.3

