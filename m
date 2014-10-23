Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57675 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaJWGhi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 02:37:38 -0400
Received: by mail-wg0-f43.google.com with SMTP id m15so375196wgh.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 23:37:36 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/5] cfg80211: leave invalid channels on regdomain change
Date: Thu, 23 Oct 2014 09:37:34 +0300
Message-Id: <1414046257-22184-3-git-send-email-arik@wizery.com> (sfid-20141023_083744_354880_74BD6474)
In-Reply-To: <1414046257-22184-1-git-send-email-arik@wizery.com>
References: <1414046257-22184-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the regulatory settings change, some channels might become invalid.
Disconnect interfaces acting on these channels, after giving userspace
code a grace period to leave them.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 include/net/regulatory.h |  6 +++
 net/wireless/reg.c       | 99 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index dad7ab2..701177c 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -136,6 +136,11 @@ struct regulatory_request {
  *      otherwise initiating radiation is not allowed. This will enable the
  *      relaxations enabled under the CFG80211_REG_RELAX_NO_IR configuration
  *      option
+ * @REGULATORY_ENFORCE_CHANNELS: the regulatory core will make sure all
+ *	interfaces on this wiphy reside on allowed channels. Upon a regdomain
+ *	change, the interfaces are given a grace period to disconnect or move
+ *	to an allowed channels. Interfaces on forbidden channels are forcibly
+ *	disconnected.
  */
 enum ieee80211_regulatory_flags {
 	REGULATORY_CUSTOM_REG			= BIT(0),
@@ -144,6 +149,7 @@ enum ieee80211_regulatory_flags {
 	REGULATORY_COUNTRY_IE_FOLLOW_POWER	= BIT(3),
 	REGULATORY_COUNTRY_IE_IGNORE		= BIT(4),
 	REGULATORY_ENABLE_RELAX_NO_IR           = BIT(5),
+	REGULATORY_ENFORCE_CHANNELS             = BIT(6),
 };
 
 struct ieee80211_freq_range {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7449a8c..efbdff0 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -56,6 +56,7 @@
 #include <net/cfg80211.h>
 #include "core.h"
 #include "reg.h"
+#include "rdev-ops.h"
 #include "regdb.h"
 #include "nl80211.h"
 
@@ -66,6 +67,12 @@
 #define REG_DBG_PRINT(args...)
 #endif
 
+/*
+ * Grace period we give before making sure all current interfaces reside on
+ * channels allowed by the current regulatory domain.
+ */
+#define REG_ENFORCE_GRACE_MS 60000
+
 /**
  * enum reg_request_treatment - regulatory request treatment
  *
@@ -210,6 +217,9 @@ struct reg_beacon {
 	struct ieee80211_channel chan;
 };
 
+static void reg_check_chans_work(struct work_struct *work);
+static DECLARE_DELAYED_WORK(reg_check_chans, reg_check_chans_work);
+
 static void reg_todo(struct work_struct *work);
 static DECLARE_WORK(reg_work, reg_todo);
 
@@ -1518,6 +1528,88 @@ static void reg_call_notifier(struct wiphy *wiphy,
 		wiphy->reg_notifier(wiphy, request);
 }
 
+static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
+{
+	struct ieee80211_channel *ch;
+	struct cfg80211_chan_def chandef;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
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
+		ch = wdev->current_bss->pub.channel;
+		if (rdev->ops->get_channel &&
+		    !rdev_get_channel(rdev, wdev, &chandef))
+			ret = cfg80211_chandef_usable(wiphy, &chandef,
+						      IEEE80211_CHAN_DISABLED);
+		else
+			ret = !(ch->flags & IEEE80211_CHAN_DISABLED);
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
+		if (rdev->wiphy.regulatory_flags & REGULATORY_ENFORCE_CHANNELS)
+			reg_leave_invalid_chans(&rdev->wiphy);
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
+			 &reg_check_chans,
+			 msecs_to_jiffies(REG_ENFORCE_GRACE_MS));
+}
+
 static void wiphy_update_regulatory(struct wiphy *wiphy,
 				    enum nl80211_reg_initiator initiator)
 {
@@ -1557,6 +1649,8 @@ static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 		wiphy = &rdev->wiphy;
 		wiphy_update_regulatory(wiphy, initiator);
 	}
+
+	reg_check_channels();
 }
 
 static void handle_channel_custom(struct wiphy *wiphy,
@@ -1963,8 +2057,10 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 
 	/* This is required so that the orig_* parameters are saved */
 	if (treatment == REG_REQ_ALREADY_SET && wiphy &&
-	    wiphy->regulatory_flags & REGULATORY_STRICT_REG)
+	    wiphy->regulatory_flags & REGULATORY_STRICT_REG) {
 		wiphy_update_regulatory(wiphy, reg_request->initiator);
+		reg_check_channels();
+	}
 
 	return;
 
@@ -2845,6 +2941,7 @@ void regulatory_exit(void)
 
 	cancel_work_sync(&reg_work);
 	cancel_delayed_work_sync(&reg_timeout);
+	cancel_delayed_work_sync(&reg_check_chans);
 
 	/* Lock to suppress warnings */
 	rtnl_lock();
-- 
1.9.1

