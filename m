Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57352 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751248AbeDRBtl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 21:49:41 -0400
From: greearb@candelatech.com
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/3] ethtool: Support ETHTOOL_GSTATS2 command.
Date: Tue, 17 Apr 2018 18:49:34 -0700
Message-Id: <1524016176-3881-1-git-send-email-greearb@candelatech.com> (sfid-20180418_034951_095176_E2F46A6C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This is similar to ETHTOOL_GSTATS, but it allows you to specify
flags.  These flags can be used by the driver to decrease the
amount of stats refreshed.  In particular, this helps with ath10k
since getting the firmware stats can be slow.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 include/linux/ethtool.h      | 12 ++++++++++++
 include/uapi/linux/ethtool.h | 10 ++++++++++
 net/core/ethtool.c           | 40 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index ebe4181..a4aa11f 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -243,6 +243,15 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
  * @get_ethtool_stats: Return extended statistics about the device.
  *	This is only useful if the device maintains statistics not
  *	included in &struct rtnl_link_stats64.
+ * @get_ethtool_stats2: Return extended statistics about the device.
+ *	This is only useful if the device maintains statistics not
+ *	included in &struct rtnl_link_stats64.
+ *      Takes a flags argument:  0 means all (same as get_ethtool_stats),
+ *      0x1 (ETHTOOL_GS2_SKIP_FW) means skip firmware stats.
+ *      Other flags are reserved for now.
+ *      Same number of stats will be returned, but some of them might
+ *      not be as accurate/refreshed.  This is to allow not querying
+ *      firmware or other expensive-to-read stats, for instance.
  * @begin: Function to be called before any other operation.  Returns a
  *	negative error code or zero.
  * @complete: Function to be called after any other operation except
@@ -355,6 +364,9 @@ struct ethtool_ops {
 	int	(*set_phys_id)(struct net_device *, enum ethtool_phys_id_state);
 	void	(*get_ethtool_stats)(struct net_device *,
 				     struct ethtool_stats *, u64 *);
+	void	(*get_ethtool_stats2)(struct net_device *dev,
+				      struct ethtool_stats *gstats, u64 *data,
+				      u32 flags);
 	int	(*begin)(struct net_device *);
 	void	(*complete)(struct net_device *);
 	u32	(*get_priv_flags)(struct net_device *);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 4ca65b5..1c74f3e 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1396,11 +1396,21 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_PHY_STUNABLE	0x0000004f /* Set PHY tunable configuration */
 #define ETHTOOL_GFECPARAM	0x00000050 /* Get FEC settings */
 #define ETHTOOL_SFECPARAM	0x00000051 /* Set FEC settings */
+#define ETHTOOL_GSTATS2		0x00000052 /* get NIC-specific statistics
+					    * with ability to specify flags.
+					    * See ETHTOOL_GS2* below.
+					    */
 
 /* compatibility with older code */
 #define SPARC_ETH_GSET		ETHTOOL_GSET
 #define SPARC_ETH_SSET		ETHTOOL_SSET
 
+/* GSTATS2 flags */
+#define ETHTOOL_GS2_SKIP_NONE (0)    /* default is to update all stats */
+#define ETHTOOL_GS2_SKIP_FW   (1<<0) /* Skip reading stats that probe firmware,
+				      * and thus are slow/expensive.
+				      */
+
 /* Link mode bit indices */
 enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_10baseT_Half_BIT	= 0,
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 03416e6..6ec3413 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1952,16 +1952,14 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 	return rc;
 }
 
-static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
+static int _ethtool_get_stats(struct net_device *dev, void __user *useraddr,
+			      u32 flags)
 {
 	struct ethtool_stats stats;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	u64 *data;
 	int ret, n_stats;
 
-	if (!ops->get_ethtool_stats || !ops->get_sset_count)
-		return -EOPNOTSUPP;
-
 	n_stats = ops->get_sset_count(dev, ETH_SS_STATS);
 	if (n_stats < 0)
 		return n_stats;
@@ -1976,7 +1974,10 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
 	if (n_stats && !data)
 		return -ENOMEM;
 
-	ops->get_ethtool_stats(dev, &stats, data);
+	if (flags != ETHTOOL_GS2_SKIP_NONE)
+		ops->get_ethtool_stats2(dev, &stats, data, flags);
+	else
+		ops->get_ethtool_stats(dev, &stats, data);
 
 	ret = -EFAULT;
 	if (copy_to_user(useraddr, &stats, sizeof(stats)))
@@ -1991,6 +1992,31 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
 	return ret;
 }
 
+static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+
+	if (!ops->get_ethtool_stats || !ops->get_sset_count)
+		return -EOPNOTSUPP;
+	return _ethtool_get_stats(dev, useraddr, ETHTOOL_GS2_SKIP_NONE);
+}
+
+static int ethtool_get_stats2(struct net_device *dev, void __user *useraddr)
+{
+	struct ethtool_stats stats;
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	u32 flags = 0;
+
+	if (!ops->get_ethtool_stats2 || !ops->get_sset_count)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&stats, useraddr, sizeof(stats)))
+		return -EFAULT;
+
+	flags = stats.n_stats;
+	return _ethtool_get_stats(dev, useraddr, flags);
+}
+
 static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_stats stats;
@@ -2632,6 +2658,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	case ETHTOOL_GSSET_INFO:
 	case ETHTOOL_GSTRINGS:
 	case ETHTOOL_GSTATS:
+	case ETHTOOL_GSTATS2:
 	case ETHTOOL_GPHYSTATS:
 	case ETHTOOL_GTSO:
 	case ETHTOOL_GPERMADDR:
@@ -2742,6 +2769,9 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	case ETHTOOL_GSTATS:
 		rc = ethtool_get_stats(dev, useraddr);
 		break;
+	case ETHTOOL_GSTATS2:
+		rc = ethtool_get_stats2(dev, useraddr);
+		break;
 	case ETHTOOL_GPERMADDR:
 		rc = ethtool_get_perm_addr(dev, useraddr);
 		break;
-- 
2.4.11
