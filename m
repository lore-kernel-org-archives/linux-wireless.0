Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35358 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab1EMVMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 17:12:54 -0400
Received: by ewy4 with SMTP id 4so812543ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 14:12:52 -0700 (PDT)
Date: Sat, 14 May 2011 00:12:48 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] airo: correct proc entry creation interfaces
Message-ID: <20110513211248.GE29261@p183> (sfid-20110513_231257_747031_28918ED1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* use proc_mkdir_mode() instead of create_proc_entry(S_IFDIR|...),
  export proc_mkdir_mode() for that, oh well.
* don't supply S_IFREG to proc_create_data(), it's unnecessary

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/net/wireless/airo.c |   33 +++++++++++----------------------
 fs/proc/generic.c           |    1 +
 2 files changed, 12 insertions(+), 22 deletions(-)

--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -4500,17 +4500,15 @@ static int setup_proc_entry( struct net_device *dev,
 	struct proc_dir_entry *entry;
 	/* First setup the device directory */
 	strcpy(apriv->proc_name,dev->name);
-	apriv->proc_entry = create_proc_entry(apriv->proc_name,
-					      S_IFDIR|airo_perm,
-					      airo_entry);
+	apriv->proc_entry = proc_mkdir_mode(apriv->proc_name, airo_perm,
+					    airo_entry);
 	if (!apriv->proc_entry)
 		goto fail;
 	apriv->proc_entry->uid = proc_uid;
 	apriv->proc_entry->gid = proc_gid;
 
 	/* Setup the StatsDelta */
-	entry = proc_create_data("StatsDelta",
-				 S_IFREG | (S_IRUGO&proc_perm),
+	entry = proc_create_data("StatsDelta", S_IRUGO & proc_perm,
 				 apriv->proc_entry, &proc_statsdelta_ops, dev);
 	if (!entry)
 		goto fail_stats_delta;
@@ -4518,8 +4516,7 @@ static int setup_proc_entry( struct net_device *dev,
 	entry->gid = proc_gid;
 
 	/* Setup the Stats */
-	entry = proc_create_data("Stats",
-				 S_IFREG | (S_IRUGO&proc_perm),
+	entry = proc_create_data("Stats", S_IRUGO & proc_perm,
 				 apriv->proc_entry, &proc_stats_ops, dev);
 	if (!entry)
 		goto fail_stats;
@@ -4527,8 +4524,7 @@ static int setup_proc_entry( struct net_device *dev,
 	entry->gid = proc_gid;
 
 	/* Setup the Status */
-	entry = proc_create_data("Status",
-				 S_IFREG | (S_IRUGO&proc_perm),
+	entry = proc_create_data("Status", S_IRUGO & proc_perm,
 				 apriv->proc_entry, &proc_status_ops, dev);
 	if (!entry)
 		goto fail_status;
@@ -4536,8 +4532,7 @@ static int setup_proc_entry( struct net_device *dev,
 	entry->gid = proc_gid;
 
 	/* Setup the Config */
-	entry = proc_create_data("Config",
-				 S_IFREG | proc_perm,
+	entry = proc_create_data("Config", proc_perm,
 				 apriv->proc_entry, &proc_config_ops, dev);
 	if (!entry)
 		goto fail_config;
@@ -4545,8 +4540,7 @@ static int setup_proc_entry( struct net_device *dev,
 	entry->gid = proc_gid;
 
 	/* Setup the SSID */
-	entry = proc_create_data("SSID",
-				 S_IFREG | proc_perm,
+	entry = proc_create_data("SSID", proc_perm,
 				 apriv->proc_entry, &proc_SSID_ops, dev);
 	if (!entry)
 		goto fail_ssid;
@@ -4554,8 +4548,7 @@ static int setup_proc_entry( struct net_device *dev,
 	entry->gid = proc_gid;
 
 	/* Setup the APList */
-	entry = proc_create_data("APList",
-				 S_IFREG | proc_perm,
+	entry = proc_create_data("APList", proc_perm,
 				 apriv->proc_entry, &proc_APList_ops, dev);
 	if (!entry)
 		goto fail_aplist;
@@ -4563,8 +4556,7 @@ static int setup_proc_entry( struct net_device *dev,
 	entry->gid = proc_gid;
 
 	/* Setup the BSSList */
-	entry = proc_create_data("BSSList",
-				 S_IFREG | proc_perm,
+	entry = proc_create_data("BSSList", proc_perm,
 				 apriv->proc_entry, &proc_BSSList_ops, dev);
 	if (!entry)
 		goto fail_bsslist;
@@ -4572,8 +4564,7 @@ static int setup_proc_entry( struct net_device *dev,
 	entry->gid = proc_gid;
 
 	/* Setup the WepKey */
-	entry = proc_create_data("WepKey",
-				 S_IFREG | proc_perm,
+	entry = proc_create_data("WepKey", proc_perm,
 				 apriv->proc_entry, &proc_wepkey_ops, dev);
 	if (!entry)
 		goto fail_wepkey;
@@ -5705,9 +5696,7 @@ static int __init airo_init_module( void )
 {
 	int i;
 
-	airo_entry = create_proc_entry("driver/aironet",
-				       S_IFDIR | airo_perm,
-				       NULL);
+	airo_entry = proc_mkdir_mode("driver/aironet", airo_perm, NULL);
 
 	if (airo_entry) {
 		airo_entry->uid = proc_uid;
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -674,6 +674,7 @@ struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode,
 	}
 	return ent;
 }
+EXPORT_SYMBOL(proc_mkdir_mode);
 
 struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
 		struct proc_dir_entry *parent)
