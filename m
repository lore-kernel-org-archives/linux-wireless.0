Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:58467
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2KUMoA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 07:44:00 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] ath9k: Fill remove_sta_debugfs() callback
Date: Wed, 21 Nov 2012 18:13:13 +0530
Message-Id: <1353501795-10378-4-git-send-email-sujith@msujith.org> (sfid-20121121_134408_007763_170FC545)
In-Reply-To: <1353501795-10378-1-git-send-email-sujith@msujith.org>
References: <1353501795-10378-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Remove the rate control statistics debugfs file properly
via remove_sta_debugfs(). Also, check for both MAC80211_DEBUGFS
and ATH9K_DEBUGFS config options.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 17 +++++++++++++----
 drivers/net/wireless/ath/ath9k/rc.h |  2 ++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 27ed80b..004f016 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1350,7 +1350,7 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 	}
 }
 
-#ifdef CONFIG_ATH9K_DEBUGFS
+#if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_ATH9K_DEBUGFS)
 
 static ssize_t read_file_rcstat(struct file *file, char __user *user_buf,
 				size_t count, loff_t *ppos)
@@ -1428,10 +1428,17 @@ static void ath_rate_add_sta_debugfs(void *priv, void *priv_sta,
 				     struct dentry *dir)
 {
 	struct ath_rate_priv *rc = priv_sta;
-	debugfs_create_file("rc_stats", S_IRUGO, dir, rc, &fops_rcstat);
+	rc->debugfs_rcstats = debugfs_create_file("rc_stats", S_IRUGO,
+						  dir, rc, &fops_rcstat);
 }
 
-#endif /* CONFIG_ATH9K_DEBUGFS */
+static void ath_rate_remove_sta_debugfs(void *priv, void *priv_sta)
+{
+	struct ath_rate_priv *rc = priv_sta;
+	debugfs_remove(rc->debugfs_rcstats);
+}
+
+#endif /* CONFIG_MAC80211_DEBUGFS && CONFIG_ATH9K_DEBUGFS */
 
 static void *ath_rate_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
 {
@@ -1476,8 +1483,10 @@ static struct rate_control_ops ath_rate_ops = {
 	.free = ath_rate_free,
 	.alloc_sta = ath_rate_alloc_sta,
 	.free_sta = ath_rate_free_sta,
-#ifdef CONFIG_ATH9K_DEBUGFS
+
+#if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_ATH9K_DEBUGFS)
 	.add_sta_debugfs = ath_rate_add_sta_debugfs,
+	.remove_sta_debugfs = ath_rate_remove_sta_debugfs,
 #endif
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 268e67d..528c83c 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -211,7 +211,9 @@ struct ath_rate_priv {
 	struct ath_rateset neg_ht_rates;
 	const struct ath_rate_table *rate_table;
 
+#if defined(CONFIG_MAC80211_DEBUGFS) && defined(CONFIG_ATH9K_DEBUGFS)
 	struct dentry *debugfs_rcstats;
+#endif
 	struct ath_rc_stats rcstats[RATE_TABLE_SIZE];
 };
 
-- 
1.8.0

