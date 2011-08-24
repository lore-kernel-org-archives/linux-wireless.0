Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58905 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab1HXOZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 10:25:26 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: [PATCH 1/3] ath6kl: Add initial debugfs changes
Date: Wed, 24 Aug 2011 19:55:34 +0530
Message-ID: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110824_162529_868701_E75F93B1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Kconfig |    6 ++++++
 drivers/net/wireless/ath/ath6kl/core.h  |    1 +
 drivers/net/wireless/ath/ath6kl/debug.c |   13 +++++++++++++
 drivers/net/wireless/ath/ath6kl/debug.h |    9 +++++++++
 drivers/net/wireless/ath/ath6kl/init.c  |    6 ++++++
 5 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
index 3d5f8be..ea9387b 100644
--- a/drivers/net/wireless/ath/ath6kl/Kconfig
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -13,3 +13,9 @@ config ATH6KL_DEBUG
 	depends on ATH6KL
 	---help---
 	  Enables debug support
+config ATH6KL_DEBUGFS
+	bool "ath6kl debugfs"
+	depends on ATH6KL_DEBUG && DEBUG_FS
+	---help---
+	  Debugfs file entries to dump various target and host stats, like tx, rx,
+	  credit disctribution, etc.
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
index 316136c..30888d1 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -148,3 +148,16 @@ void dump_cred_dist_stats(struct htc_target *target)
 }
 
 #endif
+
+#ifdef CONFIG_ATH6KL_DEBUGFS
+int ath6kl_init_debugfs(struct ath6kl *ar)
+{
+	ar->debugfs_phy = debugfs_create_dir("ath6kl",
+					     ar->wdev->wiphy->debugfsdir);
+	if (!ar->debugfs_phy)
+		return -ENOMEM;
+
+	/* TODO: Create debugfs file entries for various target/host stats */
+	return 0;
+}
+#endif
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 66b3999..ac03506 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -102,4 +102,13 @@ static inline void dump_cred_dist_stats(struct htc_target *target)
 }
 #endif
 
+#ifdef CONFIG_ATH6KL_DEBUGFS
+int ath6kl_init_debugfs(struct ath6kl *ar);
+#else
+static inline int ath6kl_init_debugfs(struct ath6kl *ar)
+{
+	return 0;
+}
+#endif
+
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 75230ac..b1d6fca 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -573,6 +573,12 @@ struct ath6kl *ath6kl_core_alloc(struct device *sdev)
 	ar->wdev = wdev;
 	wdev->iftype = NL80211_IFTYPE_STATION;
 
+	if (ath6kl_init_debugfs(ar)) {
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

