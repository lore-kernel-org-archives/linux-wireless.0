Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38790 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab0JKTUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 15:20:45 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC] ath5k:  Move debugfs under ieee80211/[wiphy-name]
Date: Mon, 11 Oct 2010 12:20:41 -0700
Message-Id: <1286824841-30822-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This automatically keeps things proper when wiphy
is renamed.

Based on patch by Johannes Berg <johannes@sipsolutions.net>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 c9732a6... 032c2ee... M	drivers/net/wireless/ath/ath5k/base.c
:100644 100644 a342a9d... 673ab83... M	drivers/net/wireless/ath/ath5k/debug.c
 drivers/net/wireless/ath/ath5k/base.c  |    3 +--
 drivers/net/wireless/ath/ath5k/debug.c |    8 ++------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c9732a6..032c2ee 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3543,8 +3543,6 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	sc->hw = hw;
 	sc->pdev = pdev;
 
-	ath5k_debug_init_device(sc);
-
 	/*
 	 * Mark the device as detached to avoid processing
 	 * interrupts until setup is complete.
@@ -3652,6 +3650,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		}
 	}
 
+	ath5k_debug_init_device(sc);
 
 	/* ready to process interrupts */
 	__clear_bit(ATH_STAT_INVALID, sc->status);
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index a342a9d..673ab83 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -72,8 +72,6 @@ module_param_named(debug, ath5k_debug, uint, 0);
 #include "reg.h"
 #include "ani.h"
 
-static struct dentry *ath5k_global_debugfs;
-
 static int ath5k_debugfs_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
@@ -894,7 +892,6 @@ static const struct file_operations fops_queue = {
 void
 ath5k_debug_init(void)
 {
-	ath5k_global_debugfs = debugfs_create_dir("ath5k", NULL);
 }
 
 void
@@ -902,8 +899,8 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 {
 	sc->debug.level = ath5k_debug;
 
-	sc->debug.debugfs_phydir = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
-				ath5k_global_debugfs);
+	sc->debug.debugfs_phydir = debugfs_create_dir("ath5k",
+				sc->hw->wiphy->debugfsdir);
 
 	sc->debug.debugfs_debug = debugfs_create_file("debug",
 				S_IWUSR | S_IRUSR,
@@ -946,7 +943,6 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 void
 ath5k_debug_finish(void)
 {
-	debugfs_remove(ath5k_global_debugfs);
 }
 
 void
-- 
1.7.2.2

