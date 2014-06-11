Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:59168 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaFKGzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 02:55:37 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so3935052wes.24
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 23:55:36 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 5/5] cfg80211: leave invalid channels on regdomain change
Date: Wed, 11 Jun 2014 09:55:24 +0300
Message-Id: <1402469724-22358-5-git-send-email-arik@wizery.com> (sfid-20140611_085540_895410_3C96CB94)
In-Reply-To: <1402469724-22358-1-git-send-email-arik@wizery.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the regulatory settings change, some channels might become invalid.
Disconnect interfaces acting on these channels, after giving userspace
code a grace period to leave them.

Because of cfg80211 channel tracking limitations, only disconnect
STA/P2P_CL interfaces if their current center channel became disabled.

Change-Id: I308cc02c06a11cfc30b206efaeabe64d67186228
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-on: https://gerrit.rds.intel.com/32422
Tested-by: IWL Jenkins
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 83 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d6b83f9..1d6afe6 100644
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
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
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
1.9.1

