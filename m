Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58648 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935127AbeCGTvg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Mar 2018 14:51:36 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, netdev@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>
Subject: [RFC] ethtool:  Support ETHTOOL_GSTATS2 command.
Date: Wed,  7 Mar 2018 11:51:29 -0800
Message-Id: <1520452289-14172-1-git-send-email-greearb@candelatech.com> (sfid-20180307_205204_577214_82BF346D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This is similar to ETHTOOL_GSTATS, but it allows you to specify
a 'level'.  This level can be used by the driver to decrease the
amount of stats refreshed.  In particular, this helps with ath10k
since getting the firmware stats can be slow.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

NOTE:  I know to make it upstream I would need to split the patch and
remove the #define for 'backporting' that I added.  But, is the
feature in general wanted?  If so, I'll do the patch split and
other tweaks that might be suggested.

 drivers/net/wireless/ath/ath10k/debug.c | 18 ++++++++++--
 drivers/net/wireless/ath/ath10k/debug.h |  3 ++
 drivers/net/wireless/ath/ath10k/mac.c   |  3 ++
 include/linux/ethtool.h                 | 10 +++++++
 include/net/mac80211.h                  |  6 ++++
 include/uapi/linux/ethtool.h            |  4 +++
 net/core/ethtool.c                      | 52 +++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h               |  9 ++++--
 net/mac80211/ethtool.c                  | 16 +++++++---
 9 files changed, 112 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 65e0a33..2545c24 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2389,9 +2389,9 @@ int ath10k_debug_get_et_sset_count(struct ieee80211_hw *hw,
 	return 0;
 }
 
-void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       struct ethtool_stats *stats, u64 *data)
+void ath10k_debug_get_et_stats2(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ethtool_stats *stats, u64 *data, u32 level)
 {
 	struct ath10k *ar = hw->priv;
 	static const struct ath10k_fw_stats_pdev zero_stats = {};
@@ -2401,6 +2401,9 @@ void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 
 	mutex_lock(&ar->conf_mutex);
 
+	if (level && level < 5)
+		goto skip_query_fw_stats;
+
 	if (ar->state == ATH10K_STATE_ON) {
 		ath10k_refresh_target_regs(ar); /* Request some CT FW stats. */
 		ret = ath10k_debug_fw_stats_request(ar);
@@ -2412,6 +2415,7 @@ void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 		}
 	}
 
+skip_query_fw_stats:
 	pdev_stats = list_first_entry_or_null(&ar->debug.fw_stats.pdevs,
 					      struct ath10k_fw_stats_pdev,
 					      list);
@@ -2497,6 +2501,14 @@ void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 	WARN_ON(i != ATH10K_SSTATS_LEN);
 }
 
+void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
+                              struct ieee80211_vif *vif,
+                              struct ethtool_stats *stats, u64 *data)
+{
+       ath10k_debug_get_et_stats2(hw, vif, stats, data, 0);
+}
+
+
 static const struct file_operations fops_fw_dbglog = {
 	.read = ath10k_read_fw_dbglog,
 	.write = ath10k_write_fw_dbglog,
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 74d1728..f33c88f 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -108,6 +108,9 @@ int ath10k_debug_get_et_sset_count(struct ieee80211_hw *hw,
 void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct ethtool_stats *stats, u64 *data);
+void ath10k_debug_get_et_stats2(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ethtool_stats *stats, u64 *data, u32 level);
 
 static inline u64 ath10k_debug_get_fw_dbglog_mask(struct ath10k *ar)
 {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e962c0e..eed0a9f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8472,6 +8472,9 @@ static const struct ieee80211_ops ath10k_ops = {
 	.ampdu_action			= ath10k_ampdu_action,
 	.get_et_sset_count		= ath10k_debug_get_et_sset_count,
 	.get_et_stats			= ath10k_debug_get_et_stats,
+#ifdef MAC80211_HAS_ET_STATS2
+	.get_et_stats2			= ath10k_debug_get_et_stats2,
+#endif
 	.get_et_strings			= ath10k_debug_get_et_strings,
 	.add_chanctx			= ath10k_mac_op_add_chanctx,
 	.remove_chanctx			= ath10k_mac_op_remove_chanctx,
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 83cc986..9745175 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -221,6 +221,14 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
  * @get_ethtool_stats: Return extended statistics about the device.
  *	This is only useful if the device maintains statistics not
  *	included in &struct rtnl_link_stats64.
+ * @get_ethtool_stats2: Return extended statistics about the device.
+ *	This is only useful if the device maintains statistics not
+ *	included in &struct rtnl_link_stats64.
+ *      Takes a 'level' argument:  0 means all (same as get_ethtool_stats),
+ *      otherwise 1 is less than 10 (driver specific).
+ *      Same number of stats will be returned, but some of them might
+ *      not be as accurate/refreshed.  This is to allow not querying
+ *      firmware or other expensive-to-read stats, for instance.
  * @begin: Function to be called before any other operation.  Returns a
  *	negative error code or zero.
  * @complete: Function to be called after any other operation except
@@ -333,6 +341,8 @@ struct ethtool_ops {
 	int	(*set_phys_id)(struct net_device *, enum ethtool_phys_id_state);
 	void	(*get_ethtool_stats)(struct net_device *,
 				     struct ethtool_stats *, u64 *);
+	void	(*get_ethtool_stats2)(struct net_device *,
+				      struct ethtool_stats *, u64 *, u32 level);
 	int	(*begin)(struct net_device *);
 	void	(*complete)(struct net_device *);
 	u32	(*get_priv_flags)(struct net_device *);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index bd6b723..5e99ece 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3336,6 +3336,8 @@ enum ieee80211_reconfig_type {
  *
  * @get_et_stats:  Ethtool API to get a set of u64 stats.
  *
+ * @get_et_stats2:  Ethtool API to get a set of u64 stats, with level specified.
+ *
  * @get_et_strings:  Ethtool API to get a set of strings to describe stats
  *	and perhaps other supported types of ethtool data-sets.
  *
@@ -3664,6 +3666,10 @@ struct ieee80211_ops {
 	void	(*get_et_stats)(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ethtool_stats *stats, u64 *data);
+#define MAC80211_HAS_ET_STATS2 /* Make it easier for backporting drivers. */
+	void	(*get_et_stats2)(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 struct ethtool_stats *stats, u64 *data, u32 level);
 	void	(*get_et_strings)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  u32 sset, u8 *data);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index f6da73a..cf1b86f 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1331,6 +1331,10 @@ struct ethtool_per_queue_op {
 #define ETHTOOL_PHY_GTUNABLE	0x0000004e /* Get PHY tunable configuration */
 #define ETHTOOL_PHY_STUNABLE	0x0000004f /* Set PHY tunable configuration */
 
+#define ETHTOOL_GSTATS2		0x0000ff01 /* get NIC-specific statistics
+					    * with ability to specify level
+					    */
+
 /* compatibility with older code */
 #define SPARC_ETH_GSET		ETHTOOL_GSET
 #define SPARC_ETH_SSET		ETHTOOL_SSET
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 674b6c9..d3b709f 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1947,6 +1947,54 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
 	return ret;
 }
 
+static int ethtool_get_stats2(struct net_device *dev, void __user *useraddr)
+{
+	struct ethtool_stats stats;
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	u64 *data;
+	int ret, n_stats;
+	u32 stats_level = 0;
+
+	if (!ops->get_ethtool_stats2 || !ops->get_sset_count)
+		return -EOPNOTSUPP;
+
+	n_stats = ops->get_sset_count(dev, ETH_SS_STATS);
+	if (n_stats < 0)
+		return n_stats;
+	if (n_stats > S32_MAX / sizeof(u64))
+		return -ENOMEM;
+	WARN_ON_ONCE(!n_stats);
+	if (copy_from_user(&stats, useraddr, sizeof(stats)))
+		return -EFAULT;
+
+	/* User can specify the level of stats to query.  How the
+	 * level value is used is up to the driver, but in general,
+	 * 0 means 'all', 1 means least, and higher means more.
+	 * The idea is that some stats may be expensive to query, so user
+	 * space could just ask for the cheap ones...
+	 */
+	stats_level = stats.n_stats;
+
+	stats.n_stats = n_stats;
+	data = vzalloc(n_stats * sizeof(u64));
+	if (n_stats && !data)
+		return -ENOMEM;
+
+	ops->get_ethtool_stats2(dev, &stats, data, stats_level);
+
+	ret = -EFAULT;
+	if (copy_to_user(useraddr, &stats, sizeof(stats)))
+		goto out;
+	useraddr += sizeof(stats);
+	if (n_stats && copy_to_user(useraddr, data, n_stats * sizeof(u64)))
+		goto out;
+	ret = 0;
+
+ out:
+	vfree(data);
+	return ret;
+}
+
 static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_stats stats;
@@ -2552,6 +2600,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	case ETHTOOL_GSSET_INFO:
 	case ETHTOOL_GSTRINGS:
 	case ETHTOOL_GSTATS:
+	case ETHTOOL_GSTATS2:
 	case ETHTOOL_GPHYSTATS:
 	case ETHTOOL_GTSO:
 	case ETHTOOL_GPERMADDR:
@@ -2662,6 +2711,9 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	case ETHTOOL_GSTATS:
 		rc = ethtool_get_stats(dev, useraddr);
 		break;
+	case ETHTOOL_GSTATS2:
+		rc = ethtool_get_stats2(dev, useraddr);
+		break;
 	case ETHTOOL_GPERMADDR:
 		rc = ethtool_get_perm_addr(dev, useraddr);
 		break;
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index c0a52a0..55dbdc7 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -79,10 +79,15 @@ static inline void drv_get_et_strings(struct ieee80211_sub_if_data *sdata,
 
 static inline void drv_get_et_stats(struct ieee80211_sub_if_data *sdata,
 				    struct ethtool_stats *stats,
-				    u64 *data)
+				    u64 *data, u32 level)
 {
 	struct ieee80211_local *local = sdata->local;
-	if (local->ops->get_et_stats) {
+	if (local->ops->get_et_stats2) {
+		trace_drv_get_et_stats(local);
+		local->ops->get_et_stats2(&local->hw, &sdata->vif, stats, data, level);
+		trace_drv_return_void(local);
+	}
+	else if (local->ops->get_et_stats) {
 		trace_drv_get_et_stats(local);
 		local->ops->get_et_stats(&local->hw, &sdata->vif, stats, data);
 		trace_drv_return_void(local);
diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index dc6f76f..e7b012a 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -80,9 +80,9 @@ static int ieee80211_get_sset_count(struct net_device *dev, int sset)
 	return rv;
 }
 
-static void ieee80211_get_stats(struct net_device *dev,
-				struct ethtool_stats *stats,
-				u64 *data)
+static void ieee80211_get_stats2(struct net_device *dev,
+				 struct ethtool_stats *stats,
+				 u64 *data, u32 level)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_chanctx_conf *chanctx_conf;
@@ -259,7 +259,14 @@ static void ieee80211_get_stats(struct net_device *dev,
 	if (WARN_ON(i != STA_STATS_LEN))
 		return;
 
-	drv_get_et_stats(sdata, stats, &(data[STA_STATS_LEN]));
+	drv_get_et_stats(sdata, stats, &(data[STA_STATS_LEN]), level);
+}
+
+static void ieee80211_get_stats(struct net_device *dev,
+				struct ethtool_stats *stats,
+				u64 *data)
+{
+	ieee80211_get_stats2(dev, stats, data, 0);
 }
 
 static void ieee80211_get_strings(struct net_device *dev, u32 sset, u8 *data)
@@ -298,5 +305,6 @@ const struct ethtool_ops ieee80211_ethtool_ops = {
 	.set_ringparam = ieee80211_set_ringparam,
 	.get_strings = ieee80211_get_strings,
 	.get_ethtool_stats = ieee80211_get_stats,
+	.get_ethtool_stats2 = ieee80211_get_stats2,
 	.get_sset_count = ieee80211_get_sset_count,
 };
-- 
2.4.11
