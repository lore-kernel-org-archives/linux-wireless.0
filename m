Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42984 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab1B1QuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 11:50:10 -0500
Received: by mail-fx0-f46.google.com with SMTP id 17so3916695fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 08:50:09 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 6/9] [cfg80211] no operation list (NOL) support
Date: Mon, 28 Feb 2011 17:49:54 +0100
Cc: lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
In-Reply-To: <201102281740.37036.bernhard.schmidt@saxnet.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201102281749.55214.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Every channel on which interference is detected has to be added
to a list which indicates that those channels are not to be used.
A channel has to stay for at least the no operation period (NOP)
on that list before it will again become available channel.

Signed-off-by: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
---
 net/wireless/radar.c |  140 +++++++++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/radar.h |    8 +++
 2 files changed, 147 insertions(+), 1 deletions(-)

diff --git a/net/wireless/radar.c b/net/wireless/radar.c
index 361070c..5a1ceab 100644
--- a/net/wireless/radar.c
+++ b/net/wireless/radar.c
@@ -10,6 +10,7 @@
 
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
+#include "core.h"
 #include "radar.h"
 #include "nl80211.h"
 
@@ -128,6 +129,93 @@ static void radar_cac(struct work_struct *work)
 }
 static DECLARE_WORK(cac_work, radar_cac);
 
+static void update_all_interference_flags(u16 freq, bool set)
+{
+	struct cfg80211_registered_device *rdev;
+	struct ieee80211_channel *chan;
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		chan = ieee80211_get_channel(&rdev->wiphy, freq);
+		if (chan == NULL)
+			continue;
+		chan->flags &= ~IEEE80211_CHAN_RADAR_INTERFERENCE;
+		if (set)
+			chan->flags |= IEEE80211_CHAN_RADAR_INTERFERENCE;
+	}
+}
+
+static int nol_add_chan(u16 freq)
+{
+	struct radar_nol_list *nol;
+
+	printk(KERN_INFO "DFS: add freq %u MHz to the NOL list\n", freq);
+
+	list_for_each_entry(nol, &radar.nol_list, list) {
+		if (nol->freq == freq) {
+			mutex_lock(&radar.lock);
+			nol->timeout = jiffies + msecs_to_jiffies(
+				radar.params->nol_period * 1000);
+			mutex_unlock(&radar.lock);
+			return 0;
+		}
+	}
+
+	nol = kmalloc(sizeof(struct radar_nol_list), GFP_KERNEL);
+	if (nol == NULL)
+		return -ENOMEM;
+
+	mutex_lock(&radar.lock);
+	nol->freq = freq;
+	nol->timeout = jiffies +
+		msecs_to_jiffies(radar.params->nol_period * 1000);
+	list_add_tail(&nol->list, &radar.nol_list);
+	update_all_interference_flags(freq, true);
+	mutex_unlock(&radar.lock);
+	return 0;
+}
+
+static void radar_nol(struct work_struct *work)
+{
+	struct radar_nol_list *nol, *tmp;
+
+	mutex_lock(&radar.lock);
+	list_for_each_entry_safe(nol, tmp, &radar.nol_list, list) {
+		if (!time_is_before_jiffies(nol->timeout))
+			continue;
+
+		printk(KERN_INFO "DFS: remove freq %u from the NOL list\n",
+		       nol->freq);
+
+		update_all_interference_flags(nol->freq, false);
+		list_del(&nol->list);
+		mutex_unlock(&radar.lock);
+
+		kfree(nol);
+		return;
+	}
+	mutex_unlock(&radar.lock);
+}
+static DECLARE_WORK(nol_work, radar_nol);
+
+void radar_set_interference_flag(struct cfg80211_registered_device *rdev)
+{
+	struct radar_nol_list *nol;
+
+	if (list_empty(&radar.nol_list))
+		return;
+
+	mutex_lock(&radar.lock);
+	list_for_each_entry(nol, &radar.nol_list, list) {
+		struct ieee80211_channel *chan;
+
+		chan = ieee80211_get_channel(&rdev->wiphy, nol->freq);
+		if (chan == NULL)
+			continue;
+		chan->flags |= IEEE80211_CHAN_RADAR_INTERFERENCE;
+	}
+	mutex_unlock(&radar.lock);
+}
+
 void radar_update_params(u8 dfs_region)
 {
 	mutex_lock(&radar.lock);
@@ -149,8 +237,11 @@ static void radar_timer(unsigned long data)
 {
 	if (!list_empty(&radar.cac_list))
 		schedule_work(&cac_work);
+	if (!list_empty(&radar.nol_list))
+		schedule_work(&nol_work);
 
-	if (!list_empty(&radar.cac_list))
+	if (!list_empty(&radar.cac_list) ||
+	    !list_empty(&radar.nol_list))
 		mod_timer(&radar.timer, jiffies + msecs_to_jiffies(100));
 }
 
@@ -164,12 +255,14 @@ void radar_init(void)
 
 	mutex_init(&radar.lock);
 	INIT_LIST_HEAD(&radar.cac_list);
+	INIT_LIST_HEAD(&radar.nol_list);
 	setup_timer(&radar.timer, radar_timer, (unsigned long)0);
 }
 
 void radar_deinit(void)
 {
 	struct radar_cac_list *cac, *cactmp;
+	struct radar_nol_list *nol, *noltmp;
 
 	del_timer_sync(&radar.timer);
 	mutex_lock(&radar.lock);
@@ -177,6 +270,10 @@ void radar_deinit(void)
 		list_del(&cac->list);
 		kfree(cac);
 	}
+	list_for_each_entry_safe(nol, noltmp, &radar.nol_list, list) {
+		list_del(&nol->list);
+		kfree(nol);
+	}
 	mutex_unlock(&radar.lock);
 	mutex_destroy(&radar.lock);
 }
@@ -230,6 +327,46 @@ static const struct file_operations cac_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t radar_debugfs_nol_read(struct file *file,
+				      char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct radar_nol_list *nol;
+	char *buf;
+	unsigned int offset = 0, buf_size = PAGE_SIZE, r;
+
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (!list_empty(&radar.nol_list)) {
+		mutex_lock(&radar.lock);
+		list_for_each_entry(nol, &radar.nol_list, list) {
+			int remaining;
+
+			remaining = jiffies_to_msecs(nol->timeout - jiffies);
+			remaining /= 1000;
+			offset += snprintf(buf + offset,
+					   buf_size - offset,
+					   "%u MHz: %u secs remaining\n",
+					   nol->freq, remaining);
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
+static const struct file_operations nol_ops = {
+	.read = radar_debugfs_nol_read,
+	.open = radar_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static struct dentry *radar_debugfs_dir;
 
 #define DEBUGFS_ADD(name)						\
@@ -240,6 +377,7 @@ void radar_debugfs_add(struct dentry *ieee80211_debugfs_dir)
 {
 	radar_debugfs_dir = debugfs_create_dir("radar", ieee80211_debugfs_dir);
 	DEBUGFS_ADD(cac);
+	DEBUGFS_ADD(nol);
 }
 
 void radar_debugfs_remove()
diff --git a/net/wireless/radar.h b/net/wireless/radar.h
index 89cc73d..4ec1aae 100644
--- a/net/wireless/radar.h
+++ b/net/wireless/radar.h
@@ -33,16 +33,24 @@ struct radar_cac_list {
 	struct list_head list;
 };
 
+struct radar_nol_list {
+	u16 freq;
+	unsigned long timeout;
+	struct list_head list;
+};
+
 struct radar {
 	struct radar_parameters *params;
 	struct mutex lock;
 	struct timer_list timer;
 	struct list_head cac_list;
+	struct list_head nol_list;
 };
 
 bool radar_cac_in_progress(struct cfg80211_registered_device *rdev);
 int radar_cac_start(struct cfg80211_registered_device *rdev);
 int radar_cac_stop(struct cfg80211_registered_device *rdev);
+void radar_set_interference_flag(struct cfg80211_registered_device *rdev);
 void radar_update_params(u8 dfs_region);
 void radar_init(void);
 void radar_deinit(void);
-- 
1.7.2.3
