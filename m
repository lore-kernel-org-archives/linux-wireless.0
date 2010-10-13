Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52543 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab0JMKH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 06:07:27 -0400
Message-Id: <20101013100657.853360719@sipsolutions.net>
Date: Wed, 13 Oct 2010 12:06:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: notify drivers about frame registrations
References: <20101013100622.939014559@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Drivers may need to adjust their filters according
to frame registrations, so notify them about them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    7 +++++++
 net/wireless/mlme.c    |   23 ++++++++++++++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2010-10-13 11:26:27.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-10-13 11:28:32.000000000 +0200
@@ -1147,6 +1147,9 @@ struct cfg80211_pmksa {
  *	allows the driver to adjust the dynamic ps timeout value.
  * @set_cqm_rssi_config: Configure connection quality monitor RSSI threshold.
  *
+ * @mgmt_frame_register: Notify driver that a management frame type was
+ *	registered. Note that this callback may not sleep, and cannot run
+ *	concurrently with itself.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);
@@ -1297,6 +1300,10 @@ struct cfg80211_ops {
 	int	(*set_cqm_rssi_config)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       s32 rssi_thold, u32 rssi_hyst);
+
+	void	(*mgmt_frame_register)(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       u16 frame_type, bool reg);
 };
 
 /*
--- wireless-testing.orig/net/wireless/mlme.c	2010-10-13 11:26:27.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2010-10-13 11:29:06.000000000 +0200
@@ -764,6 +764,8 @@ int cfg80211_mlme_register_mgmt(struct w
 				u16 frame_type, const u8 *match_data,
 				int match_len)
 {
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct cfg80211_mgmt_registration *reg, *nreg;
 	int err = 0;
 	u16 mgmt_type;
@@ -810,22 +812,37 @@ int cfg80211_mlme_register_mgmt(struct w
 	nreg->frame_type = cpu_to_le16(frame_type);
 	list_add(&nreg->list, &wdev->mgmt_registrations);
 
+	if (rdev->ops->mgmt_frame_register)
+		rdev->ops->mgmt_frame_register(wiphy, wdev->netdev,
+					       frame_type, true);
+
  out:
 	spin_unlock_bh(&wdev->mgmt_registrations_lock);
+
 	return err;
 }
 
 void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlpid)
 {
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct cfg80211_mgmt_registration *reg, *tmp;
 
 	spin_lock_bh(&wdev->mgmt_registrations_lock);
 
 	list_for_each_entry_safe(reg, tmp, &wdev->mgmt_registrations, list) {
-		if (reg->nlpid == nlpid) {
-			list_del(&reg->list);
-			kfree(reg);
+		if (reg->nlpid != nlpid)
+			continue;
+
+		if (rdev->ops->mgmt_frame_register) {
+			u16 frame_type = le16_to_cpu(reg->frame_type);
+
+			rdev->ops->mgmt_frame_register(wiphy, wdev->netdev,
+						       frame_type, false);
 		}
+
+		list_del(&reg->list);
+		kfree(reg);
 	}
 
 	spin_unlock_bh(&wdev->mgmt_registrations_lock);


