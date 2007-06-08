Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:65103 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938473AbXFHHfZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 03:35:25 -0400
Date: Fri, 8 Jun 2007 15:34:43 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] mac80211: remove global tsinfo debugfs variables
Message-ID: <20070608073443.GA4928@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove global tsinfo debugfs variables

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/debugfs_netdev.c  |   33 +++++++++++++++------------------
 net/mac80211/ieee80211_i.h     |    5 +++++
 net/mac80211/ieee80211_iface.c |    8 ++++++++
 3 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 7be0d90..a1c5fcc 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -87,16 +87,6 @@ static const struct file_operations name##_ops = {			\
 		IEEE80211_IF_FMT_##format(name, field)			\
 		__IEEE80211_IF_FILE(name)
 
-static struct ieee80211_elem_tspec _tspec = {
-	.nominal_msdu_size = 200,
-	.inactivity_interval = 40,
-	.mean_data_rate = 40000,
-	.min_phy_rate = 6000000,
-	.surplus_band_allow = 8192,
-	.medium_time = 30,
-};
-static u8 _dls_mac[ETH_ALEN];
-
 #define DEBUGFS_QOS_FILE(name, f)					\
 static ssize_t qos_ ##name## _write(struct file *file,			\
 				    const char __user *userbuf,		\
@@ -104,7 +94,7 @@ static ssize_t qos_ ##name## _write(struct file *file,			\
 {									\
 	struct ieee80211_sub_if_data *sdata = file->private_data;	\
 									\
-	f(sdata->dev, &sdata->u.sta, &_tspec);				\
+	f(sdata->dev, &sdata->u.sta, &sdata->u.sta.tspec);				\
 									\
 	return count;							\
 }									\
@@ -132,7 +122,8 @@ DEBUGFS_QOS_FILE(delts_wmm, wmm_send_delts);
 static ssize_t qos_if_dls_mac(const struct ieee80211_sub_if_data *sdata,
 			      char *buf, int buflen)
 {
-	return scnprintf(buf, buflen, MAC_FMT "\n", MAC_ARG(_dls_mac));
+	return scnprintf(buf, buflen, MAC_FMT "\n",
+			 MAC_ARG(sdata->u.sta.dls_mac));
 }
 
 static ssize_t qos_dls_mac_read(struct file *file,
@@ -163,7 +154,7 @@ static ssize_t qos_dls_mac_write(struct file *file, const char __user *userbuf,
 		printk(KERN_ERR "%s: sscanf input error\n", sdata->dev->name);
 		return -EINVAL;
 	}
-	memcpy(_dls_mac, m, ETH_ALEN);
+	memcpy(sdata->u.sta.dls_mac, m, ETH_ALEN);
 	return count;
 }
 
@@ -207,10 +198,12 @@ static ssize_t qos_dls_op_write(struct file *file, const char __user *userbuf,
 	}
 	switch (opt) {
 	case 1:
-		ieee80211_send_dls_req(sdata->dev, &sdata->u.sta, _dls_mac, 0);
+		ieee80211_send_dls_req(sdata->dev, &sdata->u.sta,
+				       sdata->u.sta.dls_mac, 0);
 		break;
 	case 2:
-		ieee80211_send_dls_teardown(sdata->dev, &sdata->u.sta, _dls_mac,
+		ieee80211_send_dls_teardown(sdata->dev, &sdata->u.sta,
+					    sdata->u.sta.dls_mac,
 					    WLAN_REASON_QSTA_NOT_USE);
 		break;
 	default:
@@ -232,8 +225,9 @@ static ssize_t tsinfo_ ##_name## _read(struct file *file,		\
 				       size_t count, loff_t *ppos)	\
 {									\
 	char buf[20];							\
+	struct ieee80211_sub_if_data *sdata = file->private_data;	\
 	int res = scnprintf(buf, count, "%u\n",				\
-			IEEE80211_TSINFO_## _name (_tspec.ts_info));	\
+		IEEE80211_TSINFO_## _name (sdata->u.sta.tspec.ts_info));\
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
 }									\
 									\
@@ -244,6 +238,7 @@ static ssize_t tsinfo_ ##_name## _write(struct file *file,		\
 	char buf[20];							\
 	size_t size;							\
 	int val;							\
+	struct ieee80211_sub_if_data *sdata = file->private_data;	\
 									\
 	size = min(sizeof(buf) - 1, count);				\
 	buf[size] = '\0';						\
@@ -298,7 +293,8 @@ static ssize_t tspec_ ##name## _read(struct file *file,			\
 				      size_t count, loff_t *ppos)	\
 {									\
 	char buf[20];							\
-	int res = scnprintf(buf, count, "%u\n", _tspec.name);		\
+	struct ieee80211_sub_if_data *sdata = file->private_data;	\
+	int res = scnprintf(buf, count, "%u\n", sdata->u.sta.tspec.name);\
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
 }									\
 									\
@@ -308,13 +304,14 @@ static ssize_t tspec_ ##name## _write(struct file *file,		\
 {									\
 	char buf[20];							\
 	size_t size;							\
+	struct ieee80211_sub_if_data *sdata = file->private_data;	\
 									\
 	size = min(sizeof(buf) - 1, count);				\
 	buf[size] = '\0';						\
 	if (copy_from_user(buf, userbuf, size))				\
 		return -EFAULT;						\
 									\
-	_tspec.name = simple_strtoul(buf, NULL, 0);			\
+	sdata->u.sta.tspec.name = simple_strtoul(buf, NULL, 0);		\
 	return count;							\
 }									\
 									\
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4968723..52a85c9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -21,6 +21,7 @@
 #include <linux/workqueue.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
+//#include <linux/ieee80211.h>
 #include <net/wireless.h>
 #include "ieee80211_key.h"
 #include "sta_info.h"
@@ -296,6 +297,10 @@ struct ieee80211_if_sta {
 #define STA_TSDIR_NUM  2
 	/* EDCA: 0~7, HCCA: 8~15 */
 	struct sta_ts_data ts_data[STA_TSID_NUM][STA_TSDIR_NUM];
+#ifdef CONFIG_MAC80211_DEBUGFS
+	struct ieee80211_elem_tspec tspec;
+	u8 dls_mac[ETH_ALEN];
+#endif
 };
 
 
diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
index c5c8bab..f4a6500 100644
--- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -198,6 +198,14 @@ void ieee80211_if_set_type(struct net_device *dev, int type)
 		/* Initialize non-AP QSTA QoS Params */
 		ifsta->dot11EDCAAveragingPeriod = 5;
 		ifsta->MPDUExchangeTime = 0;
+#ifdef CONFIG_MAC80211_DEBUGFS
+		ifsta->tspec.nominal_msdu_size = 200,
+		ifsta->tspec.inactivity_interval = 40,
+		ifsta->tspec.mean_data_rate = 40000,
+		ifsta->tspec.min_phy_rate = 6000000,
+		ifsta->tspec.surplus_band_allow = 8192,
+		ifsta->tspec.medium_time = 30,
+#endif
 
 		msdata = IEEE80211_DEV_TO_SUB_IF(sdata->local->mdev);
 		sdata->bss = &msdata->u.ap;
-- 
1.5.0.rc2.g73a2
