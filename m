Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2003 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab0CLEpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 23:45:44 -0500
From: Bob Copeland <me@bobcopeland.com>
To: jouni.malinen@atheros.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH/RFC 2/3] mac80211_hwsim: add a control device
Date: Thu, 11 Mar 2010 23:43:18 -0500
Message-Id: <1268368999-12734-3-git-send-email-me@bobcopeland.com>
In-Reply-To: <1268368999-12734-1-git-send-email-me@bobcopeland.com>
References: <1268368999-12734-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a new misc device called mac80211_hwsim_control which
will be used for managing hwsim devices.  Opening the device
creates a new radio.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   66 +++++++++++++++++++++++++++++++-
 1 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 107f748..0fbadca 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -23,6 +23,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/etherdevice.h>
 #include <linux/debugfs.h>
+#include <linux/miscdevice.h>
 
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Software simulator of 802.11 radio(s) for mac80211");
@@ -277,6 +278,8 @@ static spinlock_t hwsim_radio_lock;
 static struct list_head hwsim_radios;
 static int radio_count = 0;
 
+static struct miscdevice mac80211_hwsim_miscdev;
+
 struct mac80211_hwsim_data {
 	struct list_head list;
 	struct ieee80211_hw *hw;
@@ -1008,6 +1011,7 @@ static void mac80211_hwsim_free(void)
 		device_unregister(data->dev);
 		ieee80211_free_hw(data->hw);
 	}
+	misc_deregister(&mac80211_hwsim_miscdev);
 	class_destroy(hwsim_class);
 }
 
@@ -1418,6 +1422,55 @@ failed:
 	return ERR_PTR(err);
 }
 
+static void mac80211_hwsim_free_radio(struct mac80211_hwsim_data *data)
+{
+	spin_lock_bh(&hwsim_radio_lock);
+	list_del(&data->list);
+	spin_unlock_bh(&hwsim_radio_lock);
+
+	debugfs_remove(data->debugfs_group);
+	debugfs_remove(data->debugfs_ps);
+	debugfs_remove(data->debugfs);
+	ieee80211_unregister_hw(data->hw);
+	device_unregister(data->dev);
+	ieee80211_free_hw(data->hw);
+}
+
+/* hwsim control device file */
+static int mac80211_hwsim_control_open(struct inode *inode, struct file *file)
+{
+	/* create a new radio for this struct file */
+	struct mac80211_hwsim_data *radio;
+
+	radio = mac80211_hwsim_create_radio();
+	if (IS_ERR(radio))
+		return PTR_ERR(radio);
+
+	file->private_data = radio;
+	return 0;
+}
+
+static
+int mac80211_hwsim_control_release(struct inode *inode, struct file *file)
+{
+	struct mac80211_hwsim_data *radio = file->private_data;
+
+	mac80211_hwsim_free_radio(radio);
+	return 0;
+}
+
+static const struct file_operations mac80211_hwsim_control_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mac80211_hwsim_control_open,
+	.release	= mac80211_hwsim_control_release
+};
+
+static struct miscdevice mac80211_hwsim_miscdev = {
+	.name = "mac80211_hwsim_control",
+	.fops = &mac80211_hwsim_control_fops,
+	.minor = MISC_DYNAMIC_MINOR,
+};
+
 static int __init init_mac80211_hwsim(void)
 {
 	int i, err = 0;
@@ -1435,19 +1488,25 @@ static int __init init_mac80211_hwsim(void)
 	if (IS_ERR(hwsim_class))
 		return PTR_ERR(hwsim_class);
 
+	err = misc_register(&mac80211_hwsim_miscdev);
+	if (err) {
+		class_unregister(hwsim_class);
+		goto failed;
+	}
+
 	for (i = 0; i < radios; i++) {
 		struct mac80211_hwsim_data *data =
 			mac80211_hwsim_create_radio();
 
 		if (IS_ERR(data)) {
 			err = PTR_ERR(data);
-			goto failed;
+			goto failed_free;
 		}
 	}
 
 	hwsim_mon = alloc_netdev(0, "hwsim%d", hwsim_mon_setup);
 	if (hwsim_mon == NULL)
-		goto failed;
+		goto failed_free;
 
 	rtnl_lock();
 
@@ -1467,8 +1526,9 @@ static int __init init_mac80211_hwsim(void)
 failed_mon:
 	rtnl_unlock();
 	free_netdev(hwsim_mon);
-failed:
+failed_free:
 	mac80211_hwsim_free();
+failed:
 	return err;
 }
 
-- 
1.6.3.3


