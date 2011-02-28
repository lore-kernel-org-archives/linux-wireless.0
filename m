Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42984 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab1B1Qtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 11:49:41 -0500
Received: by fxm17 with SMTP id 17so3916695fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 08:49:40 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/9] [cfg80211] channel availability check (CAC) support
Date: Mon, 28 Feb 2011 17:49:23 +0100
Cc: lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
In-Reply-To: <201102281740.37036.bernhard.schmidt@saxnet.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201102281749.23606.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This includes 3 new commands. On to fire of a CAC, one to stop it
and a notification which is sent after the CAC period is over.
During a CAC we block any channel changes to ensure that the full
period is done while on the channel for which it has been started.
After the CAC the channel is marked as clear.

Note, I decided to do CACs per wiphy, because it is not possible to
ensure that the device doing the radar detection is able to detect
all interferences in the range of other devices (sector antennas,
..).

Signed-off-by: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
---
 include/linux/nl80211.h |    8 ++
 net/wireless/chan.c     |   10 +++
 net/wireless/core.c     |    2 +
 net/wireless/nl80211.c  |   75 +++++++++++++++++++++
 net/wireless/nl80211.h  |    2 +
 net/wireless/radar.c    |  164 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/radar.h    |   10 +++
 7 files changed, 271 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2282f56..e14b2dd 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -410,6 +410,10 @@
  *	notification. This event is used to indicate that an unprotected
  *	disassociation frame was dropped when MFP is in use.
  *
+ * @NL80211_CMD_RADAR_CAC_START: Request a CAC.
+ * @NL80211_CMD_RADAR_CAC_STOP: Stop a CAC early.
+ * @NL80211_CMD_RADAR_CAC_DONE: Notification sent if a CAC has completed.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -522,6 +526,10 @@ enum nl80211_commands {
 	NL80211_CMD_UNPROT_DEAUTHENTICATE,
 	NL80211_CMD_UNPROT_DISASSOCIATE,
 
+	NL80211_CMD_RADAR_CAC_START,
+	NL80211_CMD_RADAR_CAC_STOP,
+	NL80211_CMD_RADAR_CAC_DONE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 4e63e67..8ab9e96 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -8,6 +8,7 @@
 
 #include <net/cfg80211.h>
 #include "core.h"
+#include "radar.h"
 
 struct ieee80211_channel *
 rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
@@ -122,6 +123,15 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 		}
 	}
 
+	if (wdev && (wdev->iftype == NL80211_IFTYPE_ADHOC ||
+		     wdev->iftype == NL80211_IFTYPE_AP ||
+		     wdev->iftype == NL80211_IFTYPE_AP_VLAN ||
+		     wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
+		     wdev->iftype == NL80211_IFTYPE_P2P_GO) &&
+	    radar_cac_in_progress(rdev) &&
+	    rdev->ops->get_channel(&rdev->wiphy) != chan)
+		return -EINVAL;
+
 	result = rdev->ops->set_channel(&rdev->wiphy,
 					wdev ? wdev->netdev : NULL,
 					chan, channel_type);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 55984ca..eb517a2 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -554,6 +554,8 @@ void wiphy_unregister(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	radar_cac_stop(rdev);
+
 	rfkill_unregister(rdev->rfkill);
 
 	/* protect the device list */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 52b76e7..20a24f4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -22,6 +22,7 @@
 #include "core.h"
 #include "nl80211.h"
 #include "reg.h"
+#include "radar.h"
 
 static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 			    struct genl_info *info);
@@ -4775,6 +4776,20 @@ static int nl80211_leave_mesh(struct sk_buff *skb, struct genl_info *info)
 	return cfg80211_leave_mesh(rdev, dev);
 }
 
+static int nl80211_radar_start_cac(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+
+	return radar_cac_start(rdev);
+}
+
+static int nl80211_radar_stop_cac(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+
+	return radar_cac_stop(rdev);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -5273,6 +5288,22 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_RADAR_CAC_START,
+		.doit = nl80211_radar_start_cac,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_RADAR_CAC_STOP,
+		.doit = nl80211_radar_stop_cac,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -6130,6 +6161,50 @@ nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
+static void radar_cac_done_wdev(struct cfg80211_registered_device *rdev,
+				struct wireless_dev *wdev)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_RADAR_CAC_DONE);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, GFP_KERNEL);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
+void nl80211_radar_cac_done(struct cfg80211_registered_device *rdev)
+{
+	struct wireless_dev *wdev;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(wdev, &rdev->netdev_list, list)
+		radar_cac_done_wdev(rdev, wdev);
+
+	rcu_read_unlock();
+}
+
 static int nl80211_netlink_notify(struct notifier_block * nb,
 				  unsigned long state,
 				  void *_notify)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index e3f7fa8..aa3c926 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -98,4 +98,6 @@ nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev, const u8 *peer,
 				u32 num_packets, gfp_t gfp);
 
+void nl80211_radar_cac_done(struct cfg80211_registered_device *rdev);
+
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/radar.c b/net/wireless/radar.c
index 779fd8c..361070c 100644
--- a/net/wireless/radar.c
+++ b/net/wireless/radar.c
@@ -11,6 +11,7 @@
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include "radar.h"
+#include "nl80211.h"
 
 static struct radar_parameters regdomain_params[] = {
 	{ 60, 1800, 1000 },	/* FCC, correct? */
@@ -20,6 +21,113 @@ static struct radar_parameters regdomain_params[] = {
 
 static struct radar radar;
 
+/*
+ * radar_cac_in_progress - returns true if rdev is doing a CAC.
+ */
+bool radar_cac_in_progress(struct cfg80211_registered_device *rdev)
+{
+	struct radar_cac_list *cac;
+
+	mutex_lock(&radar.lock);
+	list_for_each_entry(cac, &radar.cac_list, list) {
+		if (cac->rdev == rdev) {
+			mutex_unlock(&radar.lock);
+			return true;
+		}
+	}
+	mutex_unlock(&radar.lock);
+	return false;
+}
+
+/*
+ * radar_cac_start - start CAC on the current channel
+ */
+int radar_cac_start(struct cfg80211_registered_device *rdev)
+{
+	struct radar_cac_list *cac;
+	struct ieee80211_channel *chan;
+
+	if (radar_cac_in_progress(rdev))
+		return 0;
+
+	if (!rdev->ops->get_channel)
+		return -EINVAL;
+
+	chan = rdev->ops->get_channel(&rdev->wiphy);
+	mutex_lock(&radar.lock);
+	if ((chan->flags & IEEE80211_CHAN_RADAR_INTERFERENCE)) {
+		mutex_unlock(&radar.lock);
+		return -EINVAL;
+	}
+	chan->flags &= ~IEEE80211_CHAN_RADAR_CLEAR;
+	mutex_unlock(&radar.lock);
+
+	printk(KERN_INFO "DFS: starting CAC (%p)\n", rdev);
+
+	cac = kmalloc(sizeof(struct radar_cac_list), GFP_KERNEL);
+	if (cac == NULL)
+		return -ENOMEM;
+
+	mutex_lock(&radar.lock);
+	cac->rdev = rdev;
+	cac->timeout = jiffies +
+		msecs_to_jiffies(radar.params->cac_period * 1000);
+	list_add_tail(&cac->list, &radar.cac_list);
+	mutex_unlock(&radar.lock);
+	mod_timer(&radar.timer, jiffies + msecs_to_jiffies(100));
+	return 0;
+}
+
+/*
+ * radar_cac_stop - stop CAC in one is in progess
+ */
+int radar_cac_stop(struct cfg80211_registered_device *rdev)
+{
+	struct radar_cac_list *cac, *tmp;
+
+	mutex_lock(&radar.lock);
+	list_for_each_entry_safe(cac, tmp, &radar.cac_list, list) {
+		if (cac->rdev == rdev) {
+			printk(KERN_INFO "DFS: stop CAC (%p)\n", rdev);
+
+			list_del(&cac->list);
+			mutex_unlock(&radar.lock);
+
+			kfree(cac);
+			nl80211_radar_cac_done(rdev);
+			return 0;
+		}
+	}
+	mutex_unlock(&radar.lock);
+	return 0;
+}
+
+static void radar_cac(struct work_struct *work)
+{
+	struct radar_cac_list *cac, *tmp;
+
+	mutex_lock(&radar.lock);
+	list_for_each_entry_safe(cac, tmp, &radar.cac_list, list) {
+		if (time_is_before_jiffies(cac->timeout)) {
+			struct cfg80211_registered_device *rdev = cac->rdev;
+			struct ieee80211_channel *chan;
+
+			printk(KERN_INFO "DFS: CAC done (%p)\n", rdev);
+
+			chan = rdev->ops->get_channel(&rdev->wiphy);
+			chan->flags |= IEEE80211_CHAN_RADAR_CLEAR;
+			list_del(&cac->list);
+			mutex_unlock(&radar.lock);
+
+			kfree(cac);
+			nl80211_radar_cac_done(rdev);
+			return;
+		}
+	}
+	mutex_unlock(&radar.lock);
+}
+static DECLARE_WORK(cac_work, radar_cac);
+
 void radar_update_params(u8 dfs_region)
 {
 	mutex_lock(&radar.lock);
@@ -39,6 +147,11 @@ void radar_update_params(u8 dfs_region)
 
 static void radar_timer(unsigned long data)
 {
+	if (!list_empty(&radar.cac_list))
+		schedule_work(&cac_work);
+
+	if (!list_empty(&radar.cac_list))
+		mod_timer(&radar.timer, jiffies + msecs_to_jiffies(100));
 }
 
 void radar_init(void)
@@ -50,12 +163,21 @@ void radar_init(void)
 	radar.params = &regdomain_params[0];
 
 	mutex_init(&radar.lock);
+	INIT_LIST_HEAD(&radar.cac_list);
 	setup_timer(&radar.timer, radar_timer, (unsigned long)0);
 }
 
 void radar_deinit(void)
 {
+	struct radar_cac_list *cac, *cactmp;
+
 	del_timer_sync(&radar.timer);
+	mutex_lock(&radar.lock);
+	list_for_each_entry_safe(cac, cactmp, &radar.cac_list, list) {
+		list_del(&cac->list);
+		kfree(cac);
+	}
+	mutex_unlock(&radar.lock);
 	mutex_destroy(&radar.lock);
 }
 
@@ -67,6 +189,47 @@ static int radar_open_file_generic(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static ssize_t radar_debugfs_cac_read(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct radar_cac_list *cac;
+	char *buf;
+	unsigned int offset = 0, buf_size = PAGE_SIZE, r;
+
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (!list_empty(&radar.cac_list)) {
+		mutex_lock(&radar.lock);
+		list_for_each_entry(cac, &radar.cac_list, list) {
+			int remaining;
+
+			remaining = jiffies_to_msecs(cac->timeout - jiffies);
+			remaining /= 1000;
+			offset += snprintf(buf + offset,
+					   buf_size - offset,
+					   "%s: %u secs remaining\n",
+					   wiphy_name(&cac->rdev->wiphy),
+					   remaining);
+		}
+		mutex_unlock(&radar.lock);
+	}
+
+	r = simple_read_from_buffer(user_buf, count, ppos, buf, offset);
+
+	kfree(buf);
+
+	return r;
+}
+
+static const struct file_operations cac_ops = {
+	.read = radar_debugfs_cac_read,
+	.open = radar_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static struct dentry *radar_debugfs_dir;
 
 #define DEBUGFS_ADD(name)						\
@@ -76,6 +239,7 @@ static struct dentry *radar_debugfs_dir;
 void radar_debugfs_add(struct dentry *ieee80211_debugfs_dir)
 {
 	radar_debugfs_dir = debugfs_create_dir("radar", ieee80211_debugfs_dir);
+	DEBUGFS_ADD(cac);
 }
 
 void radar_debugfs_remove()
diff --git a/net/wireless/radar.h b/net/wireless/radar.h
index 053ceb6..89cc73d 100644
--- a/net/wireless/radar.h
+++ b/net/wireless/radar.h
@@ -27,12 +27,22 @@ struct radar_parameters {
 	int close_time;
 };
 
+struct radar_cac_list {
+	struct cfg80211_registered_device *rdev;
+	unsigned long timeout;
+	struct list_head list;
+};
+
 struct radar {
 	struct radar_parameters *params;
 	struct mutex lock;
 	struct timer_list timer;
+	struct list_head cac_list;
 };
 
+bool radar_cac_in_progress(struct cfg80211_registered_device *rdev);
+int radar_cac_start(struct cfg80211_registered_device *rdev);
+int radar_cac_stop(struct cfg80211_registered_device *rdev);
 void radar_update_params(u8 dfs_region);
 void radar_init(void);
 void radar_deinit(void);
-- 
1.7.2.3
