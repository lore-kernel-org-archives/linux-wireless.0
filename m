Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46006 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab1B1QwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 11:52:06 -0500
Received: by fxm17 with SMTP id 17so3919190fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 08:52:05 -0800 (PST)
From: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 9/9] [cfg80211] interference reporting
Date: Mon, 28 Feb 2011 17:51:46 +0100
Cc: lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
In-Reply-To: <201102281740.37036.bernhard.schmidt@saxnet.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201102281751.47250.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable drivers to report interference. Same functionality is
available through debugfs for testing purposes.

Signed-off-by: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
---
 include/net/cfg80211.h |    6 +++++
 net/wireless/core.c    |    2 +
 net/wireless/radar.c   |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5636c0a..909bae3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2723,6 +2723,12 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 void cfg80211_cqm_pktloss_notify(struct net_device *dev,
 				 const u8 *peer, u32 num_packets, gfp_t gfp);
 
+/**
+ * cfg80211_radar_interference - report radar interference.
+ * @freq: the affected channel frequency
+ */
+int cfg80211_radar_interference(u16 freq);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index eb517a2..e14fab4 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -491,6 +491,8 @@ int wiphy_register(struct wiphy *wiphy)
 	/* set up regulatory info */
 	wiphy_update_regulatory(wiphy, NL80211_REGDOM_SET_BY_CORE);
 
+	radar_set_interference_flag(rdev);
+
 	list_add_rcu(&rdev->list, &cfg80211_rdev_list);
 	cfg80211_rdev_list_generation++;
 
diff --git a/net/wireless/radar.c b/net/wireless/radar.c
index d8911d3..88080de 100644
--- a/net/wireless/radar.c
+++ b/net/wireless/radar.c
@@ -284,6 +284,21 @@ static void radar_nol(struct work_struct *work)
 }
 static DECLARE_WORK(nol_work, radar_nol);
 
+int cfg80211_radar_interference(u16 freq)
+{
+	int error;
+
+	error = nol_add_chan(freq);
+	if (error)
+		return error;
+	mod_timer(&radar.timer, jiffies + msecs_to_jiffies(100));
+	error = cc_add_chan(freq);
+	if (error)
+		return error;
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_radar_interference);
+
 void radar_set_interference_flag(struct cfg80211_registered_device *rdev)
 {
 	struct radar_nol_list *nol;
@@ -463,6 +478,41 @@ static const struct file_operations nol_ops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t radar_debugfs_bang(struct file *file,
+				  const char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	struct cfg80211_registered_device *rdev;
+	struct ieee80211_channel *chan = NULL;
+	unsigned long long freq;
+	char buf[100];
+	size_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = '\0';
+
+	freq = simple_strtoul(buf, NULL, 0);
+
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		chan = ieee80211_get_channel(&rdev->wiphy, freq);
+		if (chan != NULL)
+			break;
+	}
+
+	if (chan != NULL)
+		cfg80211_radar_interference(freq);
+
+	return count;
+}
+
+static const struct file_operations bang_ops = {
+	.write = radar_debugfs_bang,
+	.open = radar_open_file_generic,
+	.llseek = default_llseek,
+};
+
 static struct dentry *radar_debugfs_dir;
 
 #define DEBUGFS_ADD(name)						\
@@ -474,6 +524,7 @@ void radar_debugfs_add(struct dentry *ieee80211_debugfs_dir)
 	radar_debugfs_dir = debugfs_create_dir("radar", ieee80211_debugfs_dir);
 	DEBUGFS_ADD(cac);
 	DEBUGFS_ADD(nol);
+	DEBUGFS_ADD(bang);
 }
 
 void radar_debugfs_remove()
-- 
1.7.2.3
