Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47180 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbXFKJB3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 05:01:29 -0400
Date: Mon, 11 Jun 2007 17:00:30 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 5/6] mac80211: Fix sparse error for the IEEE802.11e/WMM code
Message-ID: <20070611090030.GA5592@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix sparse error for the IEEE802.11e/WMM code

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/debugfs_netdev.c  |   40 ++++++++++++++++++++--------------------
 net/mac80211/ieee80211_i.h     |    2 +-
 net/mac80211/ieee80211_iface.c |   12 ++++++------
 net/mac80211/ieee80211_sta.c   |   10 +++++-----
 4 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index a1c5fcc..5e50817 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -94,7 +94,7 @@ static ssize_t qos_ ##name## _write(struct file *file,			\
 {									\
 	struct ieee80211_sub_if_data *sdata = file->private_data;	\
 									\
-	f(sdata->dev, &sdata->u.sta, &sdata->u.sta.tspec);				\
+	f(sdata->dev, &sdata->u.sta, &sdata->u.sta.tspec);		\
 									\
 	return count;							\
 }									\
@@ -247,7 +247,6 @@ static ssize_t tsinfo_ ##_name## _write(struct file *file,		\
 									\
 	val = simple_strtoul(buf, NULL, 0);				\
 	if ((val < min_val) || (val > max_val)) {			\
-		struct ieee80211_sub_if_data *sdata = file->private_data;\
 		printk(KERN_ERR "%s: set value (%u) out of range "	\
 		       "[%u, %u]\n",sdata->dev->name,val,min_val,max_val);\
 		return -EINVAL;						\
@@ -287,14 +286,15 @@ DEBUGFS_TSINFO_FILE(TSID, 8, 15);
 DEBUGFS_TSINFO_FILE(DIR, 0, 3);
 DEBUGFS_TSINFO_FILE(UP, 0, 7);
 
-#define DEBUGFS_TSPEC_FILE(name)					\
+#define DEBUGFS_TSPEC_FILE(name, format_string, endian_f1, endian_f2)	\
 static ssize_t tspec_ ##name## _read(struct file *file,			\
 				      char __user *userbuf,		\
 				      size_t count, loff_t *ppos)	\
 {									\
 	char buf[20];							\
 	struct ieee80211_sub_if_data *sdata = file->private_data;	\
-	int res = scnprintf(buf, count, "%u\n", sdata->u.sta.tspec.name);\
+	int res = scnprintf(buf, count, format_string "\n",		\
+			    endian_f1(sdata->u.sta.tspec.name));	\
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
 }									\
 									\
@@ -311,7 +311,7 @@ static ssize_t tspec_ ##name## _write(struct file *file,		\
 	if (copy_from_user(buf, userbuf, size))				\
 		return -EFAULT;						\
 									\
-	sdata->u.sta.tspec.name = simple_strtoul(buf, NULL, 0);		\
+	sdata->u.sta.tspec.name = endian_f2(simple_strtoul(buf, NULL, 0));\
 	return count;							\
 }									\
 									\
@@ -331,21 +331,21 @@ static const struct file_operations tspec_ ##name## _ops = {		\
 		sdata->debugfs.sta.tspec.name = NULL;			\
 	} while (0)
 
-DEBUGFS_TSPEC_FILE(nominal_msdu_size);
-DEBUGFS_TSPEC_FILE(max_msdu_size);
-DEBUGFS_TSPEC_FILE(min_service_interval);
-DEBUGFS_TSPEC_FILE(max_service_interval);
-DEBUGFS_TSPEC_FILE(inactivity_interval);
-DEBUGFS_TSPEC_FILE(suspension_interval);
-DEBUGFS_TSPEC_FILE(service_start_time);
-DEBUGFS_TSPEC_FILE(min_data_rate);
-DEBUGFS_TSPEC_FILE(mean_data_rate);
-DEBUGFS_TSPEC_FILE(peak_data_rate);
-DEBUGFS_TSPEC_FILE(burst_size);
-DEBUGFS_TSPEC_FILE(delay_bound);
-DEBUGFS_TSPEC_FILE(min_phy_rate);
-DEBUGFS_TSPEC_FILE(surplus_band_allow);
-DEBUGFS_TSPEC_FILE(medium_time);
+DEBUGFS_TSPEC_FILE(nominal_msdu_size, "%hu", le16_to_cpu, cpu_to_le16);
+DEBUGFS_TSPEC_FILE(max_msdu_size, "%hu", le16_to_cpu, cpu_to_le16);
+DEBUGFS_TSPEC_FILE(min_service_interval, "%u", le32_to_cpu, cpu_to_le32);
+DEBUGFS_TSPEC_FILE(max_service_interval, "%u", le32_to_cpu, cpu_to_le32);
+DEBUGFS_TSPEC_FILE(inactivity_interval, "%u", le32_to_cpu, cpu_to_le32);
+DEBUGFS_TSPEC_FILE(suspension_interval, "%u", le32_to_cpu, cpu_to_le32);
+DEBUGFS_TSPEC_FILE(service_start_time, "%u", le32_to_cpu, cpu_to_le32);
+DEBUGFS_TSPEC_FILE(min_data_rate, "%u", le32_to_cpu, cpu_to_le32);
+DEBUGFS_TSPEC_FILE(mean_data_rate, "%u", le32_to_cpu, cpu_to_le32);
+DEBUGFS_TSPEC_FILE(peak_data_rate, "%u", le32_to_cpu, cpu_to_le32);
+DEBUGFS_TSPEC_FILE(burst_size, "%u", le32_to_cpu, cpu_to_le32);
+DEBUGFS_TSPEC_FILE(delay_bound, "%u", le32_to_cpu, cpu_to_le32);
+DEBUGFS_TSPEC_FILE(min_phy_rate, "%u", le32_to_cpu, cpu_to_le32);
+DEBUGFS_TSPEC_FILE(surplus_band_allow, "%hu", le16_to_cpu, cpu_to_le16);
+DEBUGFS_TSPEC_FILE(medium_time, "%hu", le16_to_cpu, cpu_to_le16);
 
 
 /* common attributes */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cba1114..fe56519 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -877,7 +877,7 @@ void wmm_send_delts(struct net_device *dev,
 		    struct ieee80211_elem_tspec *tp);
 void ieee80211_send_dls_req(struct net_device *dev,
 			    struct ieee80211_if_sta *ifsta,
-			    u8 *addr, u32 timeout);
+			    u8 *addr, u16 timeout);
 void ieee80211_send_dls_teardown(struct net_device *dev,
 				 struct ieee80211_if_sta *ifsta,
 				 u8 *mac, u16 reason);
diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
index f4a6500..683d275 100644
--- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -199,12 +199,12 @@ void ieee80211_if_set_type(struct net_device *dev, int type)
 		ifsta->dot11EDCAAveragingPeriod = 5;
 		ifsta->MPDUExchangeTime = 0;
 #ifdef CONFIG_MAC80211_DEBUGFS
-		ifsta->tspec.nominal_msdu_size = 200,
-		ifsta->tspec.inactivity_interval = 40,
-		ifsta->tspec.mean_data_rate = 40000,
-		ifsta->tspec.min_phy_rate = 6000000,
-		ifsta->tspec.surplus_band_allow = 8192,
-		ifsta->tspec.medium_time = 30,
+		ifsta->tspec.nominal_msdu_size = cpu_to_le16(200),
+		ifsta->tspec.inactivity_interval = cpu_to_le32(40),
+		ifsta->tspec.mean_data_rate = cpu_to_le32(40000),
+		ifsta->tspec.min_phy_rate = cpu_to_le32(6000000),
+		ifsta->tspec.surplus_band_allow = cpu_to_le16(8192),
+		ifsta->tspec.medium_time = cpu_to_le16(30),
 #endif
 
 		msdata = IEEE80211_DEV_TO_SUB_IF(sdata->local->mdev);
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index af9419e..0e4501d 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -714,7 +714,7 @@ static void ieee80211_send_disassoc(struct net_device *dev,
 }
 
 
-int ieee80211_ts_index(u8 direction)
+static int ieee80211_ts_index(u8 direction)
 {
 	if (direction == WLAN_TSINFO_DOWNLINK ||
 	    direction == WLAN_TSINFO_DIRECTLINK)
@@ -822,7 +822,7 @@ void ieee80211_send_delts(struct net_device *dev,
 	struct sk_buff *skb;
 	u8 tsid = IEEE80211_TSINFO_TSID(tp->ts_info);
 	u8 direction = IEEE80211_TSINFO_DIR(tp->ts_info);
-	u32 medium_time = tp->medium_time;
+	u16 medium_time = le16_to_cpu(tp->medium_time);
 	u8 index = ieee80211_ts_index(direction);
 
 	if (ifsta->ts_data[tsid][index].status == TS_STATUS_UNUSED) {
@@ -878,7 +878,7 @@ void wmm_send_delts(struct net_device *dev,
 	struct sk_buff *skb;
 	u8 tsid = IEEE80211_TSINFO_TSID(tp->ts_info);
 	u8 direction = IEEE80211_TSINFO_DIR(tp->ts_info);
-	u32 medium_time = tp->medium_time;
+	u16 medium_time = le16_to_cpu(tp->medium_time);
 	u8 index = ieee80211_ts_index(direction);
 	u8 *pos;
 
@@ -942,7 +942,7 @@ void wmm_send_delts(struct net_device *dev,
 
 void ieee80211_send_dls_req(struct net_device *dev,
 			    struct ieee80211_if_sta *ifsta,
-			    u8 *addr, u32 timeout)
+			    u8 *addr, u16 timeout)
 {
 	struct ieee80211_hw_mode *mode;
 	struct sk_buff *skb;
@@ -972,7 +972,7 @@ void ieee80211_send_dls_req(struct net_device *dev,
 	memcpy(mgmt->u.action.u.dls_req.dest, addr, ETH_ALEN);
 	memcpy(mgmt->u.action.u.dls_req.src, dev->dev_addr, ETH_ALEN);
 	mgmt->u.action.u.dls_req.capab_info = cpu_to_le16(ifsta->ap_capab);
-	mgmt->u.action.u.dls_req.timeout = timeout;
+	mgmt->u.action.u.dls_req.timeout = cpu_to_le16(timeout);
 
 	/* Add supported rates and extended supported rates */
 	supp_rates = skb_put(skb, 2);
-- 
1.5.0.rc2.g73a2
