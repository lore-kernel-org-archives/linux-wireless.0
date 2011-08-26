Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41799 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1HZHgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 03:36:40 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: [PATCH V3 1/3] ath6kl: Add initial debugfs changes
Date: Fri, 26 Aug 2011 13:06:31 +0530
Message-ID: <1314344193-8468-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110826_093643_362597_DF5D28B9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just initial debugfs changes. The debugfs directory would
be created at <debugfs_root>/ieee80211/phyX/ath6kl.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h  |    1 +
 drivers/net/wireless/ath/ath6kl/debug.c |   10 ++++++++++
 drivers/net/wireless/ath/ath6kl/debug.h |    6 +++++-
 drivers/net/wireless/ath/ath6kl/init.c  |    6 ++++++
 4 files changed, 22 insertions(+), 1 deletions(-)

V2 - Remove a separate config option for debugfs. Use CONFIG_ATH6KL_DEBUG
     to enable it.
V3 - Update commit log

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 4405ab5..c5537b3 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -467,6 +467,7 @@ struct ath6kl {
 	struct workqueue_struct *ath6kl_wq;
 
 	struct ath6kl_node_table scan_table;
+	struct dentry *debugfs_phy;
 };
 
 static inline void *ath6kl_priv(struct net_device *dev)
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 316136c..12775e8 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -147,4 +147,14 @@ void dump_cred_dist_stats(struct htc_target *target)
 		   target->cred_dist_cntxt->cur_free_credits);
 }
 
+int ath6kl_debug_init(struct ath6kl *ar)
+{
+	ar->debugfs_phy = debugfs_create_dir("ath6kl",
+					     ar->wdev->wiphy->debugfsdir);
+	if (!ar->debugfs_phy)
+		return -ENOMEM;
+
+	/* TODO: Create debugfs file entries for various target/host stats */
+	return 0;
+}
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 66b3999..e8c9ea9 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -78,6 +78,7 @@ void ath6kl_dump_registers(struct ath6kl_device *dev,
 			   struct ath6kl_irq_proc_registers *irq_proc_reg,
 			   struct ath6kl_irq_enable_reg *irq_en_reg);
 void dump_cred_dist_stats(struct htc_target *target);
+int ath6kl_debug_init(struct ath6kl *ar);
 #else
 static inline int ath6kl_dbg(enum ATH6K_DEBUG_MASK dbg_mask,
 			     const char *fmt, ...)
@@ -100,6 +101,9 @@ static inline void ath6kl_dump_registers(struct ath6kl_device *dev,
 static inline void dump_cred_dist_stats(struct htc_target *target)
 {
 }
+static inline int ath6kl_debug_init(struct ath6kl *ar)
+{
+	return 0;
+}
 #endif
-
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 75230ac..ad9716c 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -573,6 +573,12 @@ struct ath6kl *ath6kl_core_alloc(struct device *sdev)
 	ar->wdev = wdev;
 	wdev->iftype = NL80211_IFTYPE_STATION;
 
+	if (ath6kl_debug_init(ar)) {
+		ath6kl_err("Failed to initialize debugfs\n");
+		ath6kl_cfg80211_deinit(ar);
+		return NULL;
+	}
+
 	dev = alloc_netdev(0, "wlan%d", ether_setup);
 	if (!dev) {
 		ath6kl_err("no memory for network device instance\n");
-- 
1.7.0.4

