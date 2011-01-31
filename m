Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:46161 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab1AaKHU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 05:07:20 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 02:07:00 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [RFC] mac80211: deauthenticate STAs before suspend
Date: Mon, 31 Jan 2011 15:36:31 +0530
Message-ID: <1296468391-12268-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The STA is not deauthenticated before the system goes to sleep,
when the vif was configured by iw/iwconfig. This holds the AP
resources unnecessarily, till the STA entry got expired in AP.
So before going to sleep ensure that all stations
got deauthenticated.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 include/net/cfg80211.h |    2 ++
 net/mac80211/cfg.c     |   21 +++++++++++++++++++++
 net/wireless/sysfs.c   |    6 ++++++
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 679a049..c50345f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1056,6 +1056,7 @@ struct cfg80211_pmksa {
  * wireless extensions but this is subject to reevaluation as soon as this
  * code is used more widely and we have a first user without wext.
  *
+ * @pre_suspend: dissociate STAs before suspending the wiphy device
  * @suspend: wiphy device needs to be suspended
  * @resume: wiphy device needs to be resumed
  *
@@ -1196,6 +1197,7 @@ struct cfg80211_pmksa {
  * @get_antenna: Get current antenna configuration from device (tx_ant, rx_ant).
  */
 struct cfg80211_ops {
+	int	(*pre_suspend)(struct wiphy *wiphy);
 	int	(*suspend)(struct wiphy *wiphy);
 	int	(*resume)(struct wiphy *wiphy);
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4bc8a92..2daadf1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1245,6 +1245,25 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 }
 
 #ifdef CONFIG_PM
+static int ieee80211_pre_suspend(struct wiphy *wiphy)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = NULL;
+	struct ieee80211_if_managed *ifmgd = NULL;
+	struct cfg80211_deauth_request req;
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		ifmgd = &sdata->u.mgd;
+		if (ifmgd->associated) {
+			req.bss = ifmgd->associated;
+			req.reason_code = WLAN_REASON_DEAUTH_LEAVING;
+			req.local_state_change = false;
+			ieee80211_mgd_deauth(sdata, &req, NULL);
+		}
+	}
+	return 0;
+}
+
 static int ieee80211_suspend(struct wiphy *wiphy)
 {
 	return __ieee80211_suspend(wiphy_priv(wiphy));
@@ -1255,6 +1274,7 @@ static int ieee80211_resume(struct wiphy *wiphy)
 	return __ieee80211_resume(wiphy_priv(wiphy));
 }
 #else
+#define ieee80211_pre_suspend NULL
 #define ieee80211_suspend NULL
 #define ieee80211_resume NULL
 #endif
@@ -1969,6 +1989,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
 	.set_channel = ieee80211_set_channel,
+	.pre_suspend = ieee80211_pre_suspend,
 	.suspend = ieee80211_suspend,
 	.resume = ieee80211_resume,
 	.scan = ieee80211_scan,
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 4294fa2..944d589 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -91,6 +91,12 @@ static int wiphy_suspend(struct device *dev, pm_message_t state)
 
 	rdev->suspend_at = get_seconds();
 
+	if (rdev->ops->pre_suspend) {
+		rtnl_lock();
+		ret = rdev->ops->pre_suspend(&rdev->wiphy);
+		rtnl_unlock();
+	}
+
 	if (rdev->ops->suspend) {
 		rtnl_lock();
 		ret = rdev->ops->suspend(&rdev->wiphy);
-- 
1.7.3.5

