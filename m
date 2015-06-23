Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54677 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbbFWP7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 11:59:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] cfg80211: allow mgmt_frame_register callback to sleep
Date: Tue, 23 Jun 2015 17:59:01 +0200
Message-Id: <1435075141-18303-1-git-send-email-johannes@sipsolutions.net> (sfid-20150623_175909_279390_4E41F177)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This callback is currently not allowed to sleep, which makes it more
difficult to implement proper driver methods in mac80211 than it has
to be. Instead of doing asynchronous work here in mac80211, make it
possible for the callback to sleep by doing some asynchronous work
in cfg80211. This also enables improvements to other drivers, like
ath6kl, that would like to sleep in this callback.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h  |  3 +--
 net/wireless/core.c     |  5 ++++
 net/wireless/core.h     |  5 ++++
 net/wireless/mlme.c     | 68 ++++++++++++++++++++++++++++++++++++++++++-------
 net/wireless/rdev-ops.h |  2 ++
 5 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a741678f24a2..9a529c48f6ca 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2369,8 +2369,7 @@ struct cfg80211_qos_map {
  *	method returns 0.)
  *
  * @mgmt_frame_register: Notify driver that a management frame type was
- *	registered. Note that this callback may not sleep, and cannot run
- *	concurrently with itself.
+ *	registered. The callback is allowed to sleep.
  *
  * @set_antenna: Set antenna configuration (tx_ant, rx_ant) on the device.
  *	Parameters are bitmaps of allowed antennas to use for TX/RX. Drivers may
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 2a0bbd22854b..3893409dee95 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -407,6 +407,9 @@ use_default_name:
 	INIT_LIST_HEAD(&rdev->bss_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
 	INIT_WORK(&rdev->sched_scan_results_wk, __cfg80211_sched_scan_results);
+	INIT_LIST_HEAD(&rdev->mlme_unreg);
+	spin_lock_init(&rdev->mlme_unreg_lock);
+	INIT_WORK(&rdev->mlme_unreg_wk, cfg80211_mlme_unreg_wk);
 	INIT_DELAYED_WORK(&rdev->dfs_update_channels_wk,
 			  cfg80211_dfs_channels_update_work);
 #ifdef CONFIG_CFG80211_WEXT
@@ -802,6 +805,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
 	flush_work(&rdev->destroy_work);
 	flush_work(&rdev->sched_scan_stop_wk);
+	flush_work(&rdev->mlme_unreg_wk);
 
 #ifdef CONFIG_PM
 	if (rdev->wiphy.wowlan_config && rdev->ops->set_wakeup)
@@ -855,6 +859,7 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_P2P_DEVICE:
+		cfg80211_mlme_purge_registrations(wdev);
 		cfg80211_stop_p2p_device(rdev, wdev);
 		break;
 	default:
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 311eef26bf88..b9d5bc8c148d 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -59,6 +59,10 @@ struct cfg80211_registered_device {
 	struct list_head beacon_registrations;
 	spinlock_t beacon_registrations_lock;
 
+	struct list_head mlme_unreg;
+	spinlock_t mlme_unreg_lock;
+	struct work_struct mlme_unreg_wk;
+
 	/* protected by RTNL only */
 	int num_running_ifaces;
 	int num_running_monitor_ifaces;
@@ -348,6 +352,7 @@ void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
 int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_pid,
 				u16 frame_type, const u8 *match_data,
 				int match_len);
+void cfg80211_mlme_unreg_wk(struct work_struct *wk);
 void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlpid);
 void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev);
 int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 7aae329e2b4e..0a03eb274ec2 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -389,6 +389,7 @@ void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
 
 struct cfg80211_mgmt_registration {
 	struct list_head list;
+	struct wireless_dev *wdev;
 
 	u32 nlportid;
 
@@ -399,6 +400,45 @@ struct cfg80211_mgmt_registration {
 	u8 match[];
 };
 
+static void
+cfg80211_process_mlme_unregistrations(struct cfg80211_registered_device *rdev)
+{
+	struct cfg80211_mgmt_registration *reg;
+
+	ASSERT_RTNL();
+
+	spin_lock_bh(&rdev->mlme_unreg_lock);
+	while ((reg = list_first_entry_or_null(&rdev->mlme_unreg,
+					       struct cfg80211_mgmt_registration,
+					       list))) {
+		list_del(&reg->list);
+		spin_unlock_bh(&rdev->mlme_unreg_lock);
+
+		if (rdev->ops->mgmt_frame_register) {
+			u16 frame_type = le16_to_cpu(reg->frame_type);
+			rdev_mgmt_frame_register(rdev, reg->wdev,
+						 frame_type, false);
+		}
+
+		kfree(reg);
+
+		spin_lock_bh(&rdev->mlme_unreg_lock);
+	}
+	spin_unlock_bh(&rdev->mlme_unreg_lock);
+}
+
+void cfg80211_mlme_unreg_wk(struct work_struct *wk)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rdev = container_of(wk, struct cfg80211_registered_device,
+			    mlme_unreg_wk);
+
+	rtnl_lock();
+	cfg80211_process_mlme_unregistrations(rdev);
+	rtnl_unlock();
+}
+
 int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_portid,
 				u16 frame_type, const u8 *match_data,
 				int match_len)
@@ -449,11 +489,18 @@ int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_portid,
 	nreg->match_len = match_len;
 	nreg->nlportid = snd_portid;
 	nreg->frame_type = cpu_to_le16(frame_type);
+	nreg->wdev = wdev;
 	list_add(&nreg->list, &wdev->mgmt_registrations);
+	spin_unlock_bh(&wdev->mgmt_registrations_lock);
+
+	/* process all unregistrations to avoid driver confusion */
+	cfg80211_process_mlme_unregistrations(rdev);
 
 	if (rdev->ops->mgmt_frame_register)
 		rdev_mgmt_frame_register(rdev, wdev, frame_type, true);
 
+	return 0;
+
  out:
 	spin_unlock_bh(&wdev->mgmt_registrations_lock);
 
@@ -472,15 +519,12 @@ void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlportid)
 		if (reg->nlportid != nlportid)
 			continue;
 
-		if (rdev->ops->mgmt_frame_register) {
-			u16 frame_type = le16_to_cpu(reg->frame_type);
-
-			rdev_mgmt_frame_register(rdev, wdev,
-						 frame_type, false);
-		}
-
 		list_del(&reg->list);
-		kfree(reg);
+		spin_lock(&rdev->mlme_unreg_lock);
+		list_add_tail(&reg->list, &rdev->mlme_unreg);
+		spin_unlock(&rdev->mlme_unreg_lock);
+
+		schedule_work(&rdev->mlme_unreg_wk);
 	}
 
 	spin_unlock_bh(&wdev->mgmt_registrations_lock);
@@ -496,16 +540,22 @@ void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlportid)
 
 void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev)
 {
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_mgmt_registration *reg, *tmp;
 
 	spin_lock_bh(&wdev->mgmt_registrations_lock);
 
 	list_for_each_entry_safe(reg, tmp, &wdev->mgmt_registrations, list) {
 		list_del(&reg->list);
-		kfree(reg);
+
+		spin_lock(&rdev->mlme_unreg_lock);
+		list_add(&reg->list, &rdev->mlme_unreg);
+		spin_unlock(&rdev->mlme_unreg_lock);
 	}
 
 	spin_unlock_bh(&wdev->mgmt_registrations_lock);
+
+	cfg80211_process_mlme_unregistrations(rdev);
 }
 
 int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index c6e83a7468c0..c23516d0f807 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -733,6 +733,8 @@ static inline void
 rdev_mgmt_frame_register(struct cfg80211_registered_device *rdev,
 			 struct wireless_dev *wdev, u16 frame_type, bool reg)
 {
+	might_sleep();
+
 	trace_rdev_mgmt_frame_register(&rdev->wiphy, wdev , frame_type, reg);
 	rdev->ops->mgmt_frame_register(&rdev->wiphy, wdev , frame_type, reg);
 	trace_rdev_return_void(&rdev->wiphy);
-- 
2.1.4

