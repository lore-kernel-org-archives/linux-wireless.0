Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0JKSqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 14:46:14 -0400
Subject: Re: [PATCH 1/2] wireless:  Support wiphy_renamed hook for drivers.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1286822639.3634.84.camel@jlt3.sipsolutions.net>
References: <1286822537-28756-1-git-send-email-greearb@candelatech.com>
	 <1286822639.3634.84.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 20:46:11 +0200
Message-ID: <1286822771.3634.85.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think you should just do this (untested):

--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/debug.c	2010-10-11 20:44:26.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath5k/debug.c	2010-10-11 20:45:26.000000000 +0200
@@ -71,8 +71,6 @@ module_param_named(debug, ath5k_debug, u
 #include "reg.h"
 #include "ani.h"
 
-static struct dentry *ath5k_global_debugfs;
-
 static int ath5k_debugfs_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
@@ -884,7 +882,6 @@ static const struct file_operations fops
 void
 ath5k_debug_init(void)
 {
-	ath5k_global_debugfs = debugfs_create_dir("ath5k", NULL);
 }
 
 void
@@ -892,8 +889,8 @@ ath5k_debug_init_device(struct ath5k_sof
 {
 	sc->debug.level = ath5k_debug;
 
-	sc->debug.debugfs_phydir = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
-				ath5k_global_debugfs);
+	sc->debug.debugfs_phydir = debugfs_create_dir("ath5k",
+				sc->hw->wiphy->debugfsdir);
 
 	sc->debug.debugfs_debug = debugfs_create_file("debug",
 				S_IWUSR | S_IRUSR,
@@ -936,7 +933,6 @@ ath5k_debug_init_device(struct ath5k_sof
 void
 ath5k_debug_finish(void)
 {
-	debugfs_remove(ath5k_global_debugfs);
 }
 
 void


