Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:46664 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3KATg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 15:36:28 -0400
Received: by mail-ea0-f180.google.com with SMTP id l9so1850986eaj.25
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 12:36:27 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 1/3] mac80211_hwsim: use debugfs_remove_recursive
Date: Fri,  1 Nov 2013 20:35:58 +0100
Message-Id: <1383334560-10672-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131101_203631_980992_A3FB9A2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use debugfs_remove_recursive. That avoids the need
for the new dentry pointers and extra debugfs_remove
calls.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 1f49330..cb6b98e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -352,7 +352,6 @@ struct mac80211_hwsim_data {
 	} ps;
 	bool ps_poll_pending;
 	struct dentry *debugfs;
-	struct dentry *debugfs_ps;
 
 	struct sk_buff_head pending;	/* packets pending */
 	/*
@@ -361,7 +360,6 @@ struct mac80211_hwsim_data {
 	 * radio can be in more then one group.
 	 */
 	u64 group;
-	struct dentry *debugfs_group;
 
 	int power_level;
 
@@ -1713,9 +1711,7 @@ static void mac80211_hwsim_free(void)
 	spin_unlock_bh(&hwsim_radio_lock);
 
 	list_for_each_entry_safe(data, tmpdata, &tmplist, list) {
-		debugfs_remove(data->debugfs_group);
-		debugfs_remove(data->debugfs_ps);
-		debugfs_remove(data->debugfs);
+		debugfs_remove_recursive(data->debugfs);
 		ieee80211_unregister_hw(data->hw);
 		device_release_driver(data->dev);
 		device_unregister(data->dev);
@@ -2511,12 +2507,10 @@ static int __init init_mac80211_hwsim(void)
 
 		data->debugfs = debugfs_create_dir("hwsim",
 						   hw->wiphy->debugfsdir);
-		data->debugfs_ps = debugfs_create_file("ps", 0666,
-						       data->debugfs, data,
-						       &hwsim_fops_ps);
-		data->debugfs_group = debugfs_create_file("group", 0666,
-							data->debugfs, data,
-							&hwsim_fops_group);
+		debugfs_create_file("ps", 0666, data->debugfs, data,
+				    &hwsim_fops_ps);
+		debugfs_create_file("group", 0666, data->debugfs, data,
+				    &hwsim_fops_group);
 
 		tasklet_hrtimer_init(&data->beacon_timer,
 				     mac80211_hwsim_beacon,
-- 
1.7.9.5

