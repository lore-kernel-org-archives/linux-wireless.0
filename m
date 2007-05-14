Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61507 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbXENFPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2007 01:15:52 -0400
Date: Mon, 14 May 2007 13:15:35 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/3] mac80211: debugfs support for TSM and DLS
Message-ID: <20070514051535.GA25591@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the debugfs support for the TSM and DLS features. All
the stuff will be in the new directory
/sys/kernel/debug/ieee80211/phy0/netdev:wlan0/qos/ in STA mode.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
--
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8b939d0..c273afe 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -59,6 +60,10 @@ struct ieee80211_local;
  * increased memory use (about 2 kB of RAM per entry). */
 #define IEEE80211_FRAGMENT_MAX 4
 
+/* Minimum and Maximum TSID used by EDCA. EDCA uses 0~7; HCCA uses 8~15 */
+#define EDCA_TSID_MIN 0
+#define EDCA_TSID_MAX 7
+
 struct ieee80211_fragment_entry {
 	unsigned long first_frag_time;
 	unsigned int seq;
@@ -178,6 +183,31 @@ struct ieee80211_tx_stored_packet {
 	unsigned int last_frag_rate_ctrl_probe:1;
 };
 
+struct sta_ts_data {
+	enum {
+		TS_STATUS_UNUSED	= 0,
+		TS_STATUS_ACTIVE	= 1,
+		TS_STATUS_INACTIVE	= 2,
+		TS_STATUS_THROTTLING	= 3,
+	} status;
+	u8 dialog_token;
+	u8 up;
+	u32 admitted_time_usec;
+	u32 used_time_usec;
+};
+
+#define DLS_STATUS_OK		0
+#define DLS_STATUS_NOLINK	1
+#define DLS_STATUS_SETUP	2
+struct dls_info {
+	atomic_t refcnt;
+	int status;
+	u8 addr[ETH_ALEN];
+	struct dls_info *hnext; /* next entry in hash table list */
+	u32 timeout;
+	u32 supp_rates;
+};
+
 typedef ieee80211_txrx_result (*ieee80211_tx_handler)
 (struct ieee80211_txrx_data *tx);
 
@@ -222,6 +252,7 @@ struct ieee80211_if_sta {
 	} state;
 	struct timer_list timer;
 	struct work_struct work;
+	struct timer_list admit_timer; /* Recompute EDCA admitted time */
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
@@ -271,6 +302,16 @@ struct ieee80211_if_sta {
 	u32 supp_rates_bits;
 
 	int wmm_last_param_set;
+
+	u32 dot11EDCAAveragingPeriod;
+	u32 MPDUExchangeTime;
+#define STA_TSID_NUM   16
+#define STA_TSDIR_NUM  2
+	/* EDCA: 0~7, HCCA: 8~15 */
+	struct sta_ts_data ts_data[STA_TSID_NUM][STA_TSDIR_NUM];
+
+	struct dls_info *dls_hash[STA_HASH_SIZE];
+	spinlock_t dls_lock;
 };
 
 
@@ -338,6 +379,39 @@ struct ieee80211_sub_if_data {
 			struct dentry *auth_alg;
 			struct dentry *auth_transaction;
 			struct dentry *flags;
+			struct dentry *qos_dir;
+			struct {
+				struct dentry *addts_11e;
+				struct dentry *addts_wmm;
+				struct dentry *delts_11e;
+				struct dentry *delts_wmm;
+				struct dentry *dls_mac;
+				struct dentry *dls_op;
+			} qos;
+			struct dentry *tsinfo_dir;
+			struct {
+				struct dentry *tsid;
+				struct dentry *direction;
+				struct dentry *up;
+			} tsinfo;
+			struct dentry *tspec_dir;
+			struct {
+				struct dentry *nominal_msdu_size;
+				struct dentry *max_msdu_size;
+				struct dentry *min_service_interval;
+				struct dentry *max_service_interval;
+				struct dentry *inactivity_interval;
+				struct dentry *suspension_interval;
+				struct dentry *service_start_time;
+				struct dentry *min_data_rate;
+				struct dentry *mean_data_rate;
+				struct dentry *peak_data_rate;
+				struct dentry *burst_size;
+				struct dentry *delay_bound;
+				struct dentry *min_phy_rate;
+				struct dentry *surplus_band_allow;
+				struct dentry *medium_time;
+			} tspec;
 		} sta;
 		struct {
 			struct dentry *channel_use;
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 9e39646..5e0101e 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -87,6 +87,275 @@ static const struct file_operations name##_ops = {			\
 		IEEE80211_IF_FMT_##format(name, field)			\
 		__IEEE80211_IF_FILE(name)
 
+static struct ieee80211_elem_tspec _tspec = {
+	.nominal_msdu_size = 200,
+	.inactivity_interval = 40,
+	.mean_data_rate = 40000,
+	.min_phy_rate = 6000000,
+	.surplus_band_allow = 8192,
+	.medium_time = 30,
+};
+static u8 _dls_mac[ETH_ALEN];
+
+#define DEBUGFS_QOS_FILE(name, f)					\
+static ssize_t qos_ ##name## _write(struct file *file,			\
+				    const char __user *userbuf,		\
+				    size_t count, loff_t *ppos)		\
+{									\
+	struct ieee80211_sub_if_data *sdata = file->private_data;	\
+									\
+	f(sdata->dev, &sdata->u.sta, &_tspec);				\
+									\
+	return count;							\
+}									\
+									\
+static const struct file_operations qos_ ##name## _ops = {		\
+	.write = qos_ ##name## _write,					\
+	.open = mac80211_open_file_generic,				\
+};
+
+#define DEBUGFS_QOS_ADD(name)						\
+	sdata->debugfs.sta.qos.name = debugfs_create_file(#name, 0444, qosd,\
+		sdata, &qos_ ##name## _ops);
+
+#define DEBUGFS_QOS_DEL(name)						\
+	debugfs_remove(sdata->debugfs.sta.qos.name);			\
+	sdata->debugfs.sta.qos.name = NULL;
+
+DEBUGFS_QOS_FILE(addts_11e, ieee80211_send_addts);
+DEBUGFS_QOS_FILE(addts_wmm, wmm_send_addts);
+DEBUGFS_QOS_FILE(delts_11e, ieee80211_send_delts);
+DEBUGFS_QOS_FILE(delts_wmm, wmm_send_delts);
+
+static ssize_t qos_if_dls_mac(const struct ieee80211_sub_if_data *sdata,
+			      char *buf, int buflen)
+{
+	return scnprintf(buf, buflen, MAC_FMT "\n", MAC_ARG(_dls_mac));
+}
+
+static ssize_t qos_dls_mac_read(struct file *file,
+				char __user *userbuf,
+				size_t count, loff_t *ppos)
+{
+	return ieee80211_if_read(file->private_data,
+				 userbuf, count, ppos,
+				 qos_if_dls_mac);
+}
+
+static ssize_t qos_dls_mac_write(struct file *file, const char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct ieee80211_sub_if_data *sdata = file->private_data;
+	char buf[20];
+	size_t size;
+	u8 m[ETH_ALEN];
+
+	size = min(sizeof(buf) - 1, count);
+	buf[size] = '\0';
+	if (copy_from_user(buf, userbuf, size))
+		return -EFAULT;
+
+	if (sscanf(buf, "%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx",
+		   &((u8*)(m))[0], &((u8*)(m))[1], &((u8*)(m))[2],
+		   &((u8*)(m))[3], &((u8*)(m))[4], &((u8*)(m))[5]) != ETH_ALEN){
+		printk(KERN_ERR "%s: sscanf input error\n", sdata->dev->name);
+		return -EINVAL;
+	}
+	memcpy(_dls_mac, m, ETH_ALEN);
+	return count;
+}
+
+static const struct file_operations qos_dls_mac_ops = {
+	.read = qos_dls_mac_read,
+	.write = qos_dls_mac_write,
+	.open = mac80211_open_file_generic,
+};
+
+static ssize_t qos_if_dls_op(const struct ieee80211_sub_if_data *sdata,
+			     char *buf, int buflen)
+{
+	return scnprintf(buf, buflen,
+			 "DLS Operation: Setup = 1; Teardown = 2\n");
+}
+
+static ssize_t qos_dls_op_read(struct file *file, char __user *userbuf,
+			       size_t count, loff_t *ppos)
+{
+	return ieee80211_if_read(file->private_data,
+				 userbuf, count, ppos,
+				 qos_if_dls_op);
+}
+
+static ssize_t qos_dls_op_write(struct file *file, const char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct ieee80211_sub_if_data *sdata = file->private_data;
+	char buf[20];
+	size_t size;
+	unsigned int opt;
+	struct dls_info *dls;
+
+	size = min(sizeof(buf) - 1, count);
+	buf[size] = '\0';
+	if (copy_from_user(buf, userbuf, size))
+		return -EFAULT;
+
+	if (sscanf(buf, "%u", &opt) != 1) {
+		printk(KERN_ERR "%s: sscanf input error\n", sdata->dev->name);
+		return -EINVAL;
+	}
+	switch (opt) {
+	case 1:
+		dls = kzalloc(sizeof(struct dls_info), GFP_KERNEL);
+	        if (!dls) {
+			printk(KERN_ERR "No memory to allocate dls_info\n");
+			return -ENOMEM;
+		}
+		atomic_set(&dls->refcnt, 1);
+		dls->status = DLS_STATUS_SETUP;
+		dls->timeout = 0;
+		memcpy(dls->addr, _dls_mac, ETH_ALEN);
+		dls_info_add(&sdata->u.sta, dls);
+		ieee80211_send_dls_req(sdata->dev, &sdata->u.sta, dls);
+		break;
+	case 2:
+		ieee80211_send_dls_teardown(sdata->dev, &sdata->u.sta, _dls_mac,
+					    WLAN_REASON_QSTA_NOT_USE);
+		break;
+	default:
+		printk(KERN_ERR "Unknown DLS Operation: %d\n", opt);
+		break;
+	}
+	return count;
+}
+
+static const struct file_operations qos_dls_op_ops = {
+	.read = qos_dls_op_read,
+	.write = qos_dls_op_write,
+	.open = mac80211_open_file_generic,
+};
+
+#define DEBUGFS_TSINFO_FILE(_name, min_val, max_val)			\
+static ssize_t tsinfo_ ##_name## _read(struct file *file,		\
+				       char __user *userbuf,		\
+				       size_t count, loff_t *ppos)	\
+{									\
+	char buf[20];							\
+	int res = scnprintf(buf, count, "%u\n",				\
+			IEEE80211_TSINFO_## _name (_tspec.ts_info));	\
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+}									\
+									\
+static ssize_t tsinfo_ ##_name## _write(struct file *file,		\
+				        const char __user *userbuf,	\
+				        size_t count, loff_t *ppos)	\
+{									\
+	char buf[20];							\
+	size_t size;							\
+	int val;							\
+									\
+	size = min(sizeof(buf) - 1, count);				\
+	buf[size] = '\0';						\
+	if (copy_from_user(buf, userbuf, size))				\
+		return -EFAULT;						\
+									\
+	val = simple_strtoul(buf, NULL, 0);				\
+	if ((val < min_val) || (val > max_val)) {			\
+		struct ieee80211_sub_if_data *sdata = file->private_data;\
+		printk(KERN_ERR "%s: set value (%u) out of range "	\
+		       "[%u, %u]\n",sdata->dev->name,val,min_val,max_val);\
+		return -EINVAL;						\
+	}								\
+	SET_TSINFO_ ##_name (_tspec.ts_info, val);			\
+	return count;							\
+}									\
+									\
+static const struct file_operations tsinfo_ ##_name## _ops = {		\
+	.read = tsinfo_ ##_name## _read,				\
+	.write = tsinfo_ ##_name## _write,				\
+	.open = mac80211_open_file_generic,				\
+};
+
+#define DEBUGFS_TSINFO_ADD_TSID						\
+	sdata->debugfs.sta.tsinfo.tsid =				\
+		debugfs_create_file("tsid", 0444, tsinfod,		\
+				    sdata, &tsinfo_TSID_ops);
+
+#define DEBUGFS_TSINFO_ADD_DIR						\
+	sdata->debugfs.sta.tsinfo.direction =				\
+		debugfs_create_file("direction", 0444, tsinfod,		\
+				    sdata, &tsinfo_DIR_ops);
+
+#define DEBUGFS_TSINFO_ADD_UP						\
+	sdata->debugfs.sta.tsinfo.up =					\
+		debugfs_create_file("up", 0444, tsinfod,		\
+				    sdata, &tsinfo_UP_ops);
+
+#define DEBUGFS_TSINFO_DEL(name)					\
+	debugfs_remove(sdata->debugfs.sta.tsinfo.name);			\
+	sdata->debugfs.sta.tsinfo.name = NULL;
+
+DEBUGFS_TSINFO_FILE(TSID, 8, 15);
+DEBUGFS_TSINFO_FILE(DIR, 0, 3);
+DEBUGFS_TSINFO_FILE(UP, 0, 7);
+
+#define DEBUGFS_TSPEC_FILE(name)					\
+static ssize_t tspec_ ##name## _read(struct file *file,			\
+				      char __user *userbuf,		\
+				      size_t count, loff_t *ppos)	\
+{									\
+	char buf[20];							\
+	int res = scnprintf(buf, count, "%u\n", _tspec.name);		\
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+}									\
+									\
+static ssize_t tspec_ ##name## _write(struct file *file,		\
+				       const char __user *userbuf,	\
+				       size_t count, loff_t *ppos)	\
+{									\
+	char buf[20];							\
+	size_t size;							\
+									\
+	size = min(sizeof(buf) - 1, count);				\
+	buf[size] = '\0';						\
+	if (copy_from_user(buf, userbuf, size))				\
+		return -EFAULT;						\
+									\
+	_tspec.name = simple_strtoul(buf, NULL, 0);			\
+	return count;							\
+}									\
+									\
+static const struct file_operations tspec_ ##name## _ops = {		\
+	.read = tspec_ ##name## _read,					\
+	.write = tspec_ ##name## _write,				\
+	.open = mac80211_open_file_generic,				\
+};
+
+#define DEBUGFS_TSPEC_ADD(name)						\
+	sdata->debugfs.sta.tspec.name = debugfs_create_file(#name,	\
+		0444, tspecd, sdata, &tspec_ ##name## _ops);
+
+#define DEBUGFS_TSPEC_DEL(name)						\
+	debugfs_remove(sdata->debugfs.sta.tspec.name);			\
+	sdata->debugfs.sta.tspec.name = NULL;
+
+DEBUGFS_TSPEC_FILE(nominal_msdu_size);
+DEBUGFS_TSPEC_FILE(max_msdu_size);
+DEBUGFS_TSPEC_FILE(min_service_interval);
+DEBUGFS_TSPEC_FILE(max_service_interval);
+DEBUGFS_TSPEC_FILE(inactivity_interval);
+DEBUGFS_TSPEC_FILE(suspension_interval);
+DEBUGFS_TSPEC_FILE(service_start_time);
+DEBUGFS_TSPEC_FILE(min_data_rate);
+DEBUGFS_TSPEC_FILE(mean_data_rate);
+DEBUGFS_TSPEC_FILE(peak_data_rate);
+DEBUGFS_TSPEC_FILE(burst_size);
+DEBUGFS_TSPEC_FILE(delay_bound);
+DEBUGFS_TSPEC_FILE(min_phy_rate);
+DEBUGFS_TSPEC_FILE(surplus_band_allow);
+DEBUGFS_TSPEC_FILE(medium_time);
+
+
 /* common attributes */
 IEEE80211_IF_FILE(channel_use, channel_use, DEC);
 IEEE80211_IF_FILE(drop_unencrypted, drop_unencrypted, DEC);
@@ -184,6 +453,10 @@ __IEEE80211_IF_FILE(mode);
 
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 {
+	struct dentry *qosd;
+	struct dentry *tsinfod;
+	struct dentry *tspecd;
+
 	DEBUGFS_ADD(channel_use, sta);
 	DEBUGFS_ADD(drop_unencrypted, sta);
 	DEBUGFS_ADD(eapol, sta);
@@ -202,6 +475,42 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(auth_alg, sta);
 	DEBUGFS_ADD(auth_transaction, sta);
 	DEBUGFS_ADD(flags, sta);
+
+	qosd = debugfs_create_dir("qos", sdata->debugfsdir);
+	sdata->debugfs.sta.qos_dir = qosd;
+
+	DEBUGFS_QOS_ADD(addts_11e);
+	DEBUGFS_QOS_ADD(addts_wmm);
+	DEBUGFS_QOS_ADD(delts_11e);
+	DEBUGFS_QOS_ADD(delts_wmm);
+	DEBUGFS_QOS_ADD(dls_mac);
+	DEBUGFS_QOS_ADD(dls_op);
+
+	tsinfod = debugfs_create_dir("ts_info", qosd);
+	sdata->debugfs.sta.tsinfo_dir = tsinfod;
+
+	DEBUGFS_TSINFO_ADD_TSID;
+	DEBUGFS_TSINFO_ADD_DIR;
+	DEBUGFS_TSINFO_ADD_UP;
+
+	tspecd = debugfs_create_dir("tspec", qosd);
+	sdata->debugfs.sta.tspec_dir = tspecd;
+
+	DEBUGFS_TSPEC_ADD(nominal_msdu_size);
+	DEBUGFS_TSPEC_ADD(max_msdu_size);
+	DEBUGFS_TSPEC_ADD(min_service_interval);
+	DEBUGFS_TSPEC_ADD(max_service_interval);
+	DEBUGFS_TSPEC_ADD(inactivity_interval);
+	DEBUGFS_TSPEC_ADD(suspension_interval);
+	DEBUGFS_TSPEC_ADD(service_start_time);
+	DEBUGFS_TSPEC_ADD(min_data_rate);
+	DEBUGFS_TSPEC_ADD(mean_data_rate);
+	DEBUGFS_TSPEC_ADD(peak_data_rate);
+	DEBUGFS_TSPEC_ADD(burst_size);
+	DEBUGFS_TSPEC_ADD(delay_bound);
+	DEBUGFS_TSPEC_ADD(min_phy_rate);
+	DEBUGFS_TSPEC_ADD(surplus_band_allow);
+	DEBUGFS_TSPEC_ADD(medium_time);
 }
 
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
@@ -295,6 +604,40 @@ static void del_sta_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_DEL(auth_alg, sta);
 	DEBUGFS_DEL(auth_transaction, sta);
 	DEBUGFS_DEL(flags, sta);
+
+	DEBUGFS_TSINFO_DEL(tsid);
+	DEBUGFS_TSINFO_DEL(direction);
+	DEBUGFS_TSINFO_DEL(up);
+
+	DEBUGFS_TSPEC_DEL(nominal_msdu_size);
+	DEBUGFS_TSPEC_DEL(max_msdu_size);
+	DEBUGFS_TSPEC_DEL(min_service_interval);
+	DEBUGFS_TSPEC_DEL(max_service_interval);
+	DEBUGFS_TSPEC_DEL(inactivity_interval);
+	DEBUGFS_TSPEC_DEL(suspension_interval);
+	DEBUGFS_TSPEC_DEL(service_start_time);
+	DEBUGFS_TSPEC_DEL(min_data_rate);
+	DEBUGFS_TSPEC_DEL(mean_data_rate);
+	DEBUGFS_TSPEC_DEL(peak_data_rate);
+	DEBUGFS_TSPEC_DEL(burst_size);
+	DEBUGFS_TSPEC_DEL(delay_bound);
+	DEBUGFS_TSPEC_DEL(min_phy_rate);
+	DEBUGFS_TSPEC_DEL(surplus_band_allow);
+	DEBUGFS_TSPEC_DEL(medium_time);
+
+	DEBUGFS_QOS_DEL(addts_11e);
+	DEBUGFS_QOS_DEL(addts_wmm);
+	DEBUGFS_QOS_DEL(delts_11e);
+	DEBUGFS_QOS_DEL(delts_wmm);
+	DEBUGFS_QOS_DEL(dls_mac);
+	DEBUGFS_QOS_DEL(dls_op);
+
+	debugfs_remove(sdata->debugfs.sta.tspec_dir);
+	sdata->debugfs.sta.tspec_dir = NULL;
+	debugfs_remove(sdata->debugfs.sta.tsinfo_dir);
+	sdata->debugfs.sta.tsinfo_dir = NULL;
+	debugfs_remove(sdata->debugfs.sta.qos_dir);
+	sdata->debugfs.sta.qos_dir = NULL;
 }
 
 static void del_ap_files(struct ieee80211_sub_if_data *sdata)
