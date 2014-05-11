Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57928 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758074AbaEKIxs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:53:48 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 6/7] cfg80211: leave invalid channels on regdomain change
Date: Sun, 11 May 2014 11:50:49 +0300
Message-Id: <1399798250-20987-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140511_105353_147183_72B1B4AD)
In-Reply-To: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When the regulatory settings change, some channels might become invalid.
Disconnect interfaces acting on these channels, after giving userspace
code a grace period to leave them.

Because of cfg80211 channel tracking limitations, only disconnect
STA/P2P_CL interfaces if their current center channel became disabled.

Change-Id: I366a6172b4f3982412e2b47b32fe8cd7ec7d93f4
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/reg.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 83 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d6b83f9..db942f2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -221,6 +221,9 @@ struct reg_beacon {
 	struct ieee80211_channel chan;
 };
 
+static void reg_check_chans_work(struct work_struct *work);
+static DECLARE_DELAYED_WORK(reg_check_chans, reg_check_chans_work);
+
 static void reg_todo(struct work_struct *work);
 static DECLARE_WORK(reg_work, reg_todo);
 
@@ -1520,6 +1523,80 @@ static void reg_call_notifier(struct wiphy *wiphy,
 		wiphy->reg_notifier(wiphy, request);
 }
 
+static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
+{
+	struct ieee80211_channel *ch;
+	bool ret = true;
+
+	wdev_lock(wdev);
+
+	if (!wdev->netdev || !netif_running(wdev->netdev))
+		goto out;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		if (!wdev->beacon_interval)
+			goto out;
+
+		ret = cfg80211_reg_can_beacon(wiphy,
+					      &wdev->chandef, wdev->iftype);
+		break;
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		if (!wdev->current_bss ||
+		    !wdev->current_bss->pub.channel)
+			goto out;
+
+		/* TODO: more elaborate tracking for wide channels */
+		ch = wdev->current_bss->pub.channel;
+		ret = !(ch->flags & IEEE80211_CHAN_DISABLED);
+		break;
+	default:
+		/* others not implemented for now */
+		break;
+	}
+
+out:
+	wdev_unlock(wdev);
+	return ret;
+}
+
+static void reg_leave_invalid_chans(struct wiphy *wiphy)
+{
+	struct wireless_dev *wdev;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+
+	ASSERT_RTNL();
+
+	list_for_each_entry(wdev, &rdev->wdev_list, list)
+		if (!reg_wdev_chan_valid(wiphy, wdev))
+			cfg80211_leave(rdev, wdev);
+}
+
+static void reg_check_chans_work(struct work_struct *work)
+{
+	struct cfg80211_registered_device *rdev;
+
+	REG_DBG_PRINT("Verifying active interfaces after reg change\n");
+	rtnl_lock();
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list)
+		reg_leave_invalid_chans(&rdev->wiphy);
+
+	rtnl_unlock();
+}
+
+static void reg_check_channels(void)
+{
+	/*
+	 * Give usermode a chance to do something nicer (move to another
+	 * channel, orderly disconnection), before forcing a disconnection.
+	 */
+	mod_delayed_work(system_power_efficient_wq,
+			 &reg_check_chans, msecs_to_jiffies(60000));
+}
+
 static void wiphy_update_regulatory(struct wiphy *wiphy,
 				    enum nl80211_reg_initiator initiator)
 {
@@ -1559,6 +1636,8 @@ static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 		wiphy = &rdev->wiphy;
 		wiphy_update_regulatory(wiphy, initiator);
 	}
+
+	reg_check_channels();
 }
 
 static void handle_channel_custom(struct wiphy *wiphy,
@@ -1972,8 +2051,10 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 
 	/* This is required so that the orig_* parameters are saved */
 	if (treatment == REG_REQ_ALREADY_SET && wiphy &&
-	    wiphy->regulatory_flags & REGULATORY_STRICT_REG)
+	    wiphy->regulatory_flags & REGULATORY_STRICT_REG) {
 		wiphy_update_regulatory(wiphy, reg_request->initiator);
+		reg_check_channels();
+	}
 
 	return;
 
@@ -2853,6 +2934,7 @@ void regulatory_exit(void)
 
 	cancel_work_sync(&reg_work);
 	cancel_delayed_work_sync(&reg_timeout);
+	cancel_delayed_work_sync(&reg_check_chans);
 
 	/* Lock to suppress warnings */
 	rtnl_lock();
-- 
1.8.3.2

