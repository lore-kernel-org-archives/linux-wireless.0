Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbYHDMek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 08:34:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1KPzGo-0000cO-RJ
	for linux-wireless@vger.kernel.org; Mon, 04 Aug 2008 14:34:39 +0200
Subject: [RFC] cfg80211: add PM hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 14:33:56 +0200
Message-Id: <1217853236.4721.32.camel@johannes.berg> (sfid-20080804_143447_007277_5390AB33)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should help implement suspend/resume in mac80211, these
hooks will be run before the device is suspended and after it
resumes. Therefore, they can touch the hardware as much as
they want to.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This should help whoever wants to implement suspend/resume for mac80211.
I don't intend to, at the moment, but I think these hooks should be
used.

 include/net/cfg80211.h |    6 ++++++
 net/wireless/sysfs.c   |   30 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

--- everything.orig/include/net/cfg80211.h	2008-08-04 14:22:39.000000000 +0200
+++ everything/include/net/cfg80211.h	2008-08-04 14:26:31.000000000 +0200
@@ -285,6 +285,9 @@ struct wiphy;
  * wireless extensions but this is subject to reevaluation as soon as this
  * code is used more widely and we have a first user without wext.
  *
+ * @suspend: wiphy device needs to be suspended
+ * @resume: wiphy device needs to be resumed
+ *
  * @add_virtual_intf: create a new virtual interface with the given name
  *
  * @del_virtual_intf: remove the virtual interface determined by ifindex.
@@ -320,6 +323,9 @@ struct wiphy;
  * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
  */
 struct cfg80211_ops {
+	int	(*suspend)(struct wiphy *wiphy);
+	int	(*resume)(struct wiphy *wiphy);
+
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
 				    enum nl80211_iftype type, u32 *flags,
 				    struct vif_params *params);
--- everything.orig/net/wireless/sysfs.c	2008-08-04 14:22:39.000000000 +0200
+++ everything/net/wireless/sysfs.c	2008-08-04 14:31:58.000000000 +0200
@@ -60,6 +60,34 @@ static int wiphy_uevent(struct device *d
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
+		ret = rdev->ops->suspend(&rdev->wiphy);
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


