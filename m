Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2023 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYLODun (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2008 22:50:43 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mabbaswireless@gmail.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v2 1/3] cfg80211: add PM hooks
Date: Sun, 14 Dec 2008 22:50:37 -0500
Message-Id: <1229313039-5544-2-git-send-email-me@bobcopeland.com> (sfid-20081215_045052_167136_6B695C2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This should help implement suspend/resume in mac80211, these
hooks will be run before the device is suspended and after it
resumes. Therefore, they can touch the hardware as much as
they want to.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |    6 ++++++
 net/wireless/sysfs.c   |   30 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 23c0ab7..0432eb6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -450,6 +450,9 @@ struct ieee80211_channel;
  * wireless extensions but this is subject to reevaluation as soon as this
  * code is used more widely and we have a first user without wext.
  *
+ * @suspend: wiphy device needs to be suspended
+ * @resume: wiphy device needs to be resumed
+ *
  * @add_virtual_intf: create a new virtual interface with the given name,
  *	must set the struct wireless_dev's iftype.
  *
@@ -499,6 +502,9 @@ struct ieee80211_channel;
  * @set_channel: Set channel
  */
 struct cfg80211_ops {
+	int	(*suspend)(struct wiphy *wiphy);
+	int	(*resume)(struct wiphy *wiphy);
+
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
 				    enum nl80211_iftype type, u32 *flags,
 				    struct vif_params *params);
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 29f820e..021cda6 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -60,6 +60,34 @@ static int wiphy_uevent(struct device *dev, struct kobj_uevent_env *env)
 }
 #endif
 
+static int wiphy_suspend(struct device *dev, pm_message_t state)
+{
+	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
+	int ret = 0;
+
+	if (rdev->ops->suspend) {
+		rtnl_lock();
+		ret = rdev->ops->suspend(&rdev->wiphy);
+		rtnl_unlock();
+	}
+
+	return ret;
+}
+
+static int wiphy_resume(struct device *dev)
+{
+	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
+	int ret = 0;
+
+	if (rdev->ops->resume) {
+		rtnl_lock();
+		ret = rdev->ops->resume(&rdev->wiphy);
+		rtnl_unlock();
+	}
+
+	return ret;
+}
+
 struct class ieee80211_class = {
 	.name = "ieee80211",
 	.owner = THIS_MODULE,
@@ -68,6 +96,8 @@ struct class ieee80211_class = {
 #ifdef CONFIG_HOTPLUG
 	.dev_uevent = wiphy_uevent,
 #endif
+	.suspend = wiphy_suspend,
+	.resume = wiphy_resume,
 };
 
 int wiphy_sysfs_init(void)
-- 
1.6.0.4


