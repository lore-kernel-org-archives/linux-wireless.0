Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbXITQFC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 12:05:02 -0400
Subject: [PATCH] mac80211: remove DLS code again
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 18:06:04 +0200
Message-Id: <1190304364.18521.84.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The DLS code cannot possibly
 (1) work correctly nor
 (2) have any users.

This is because
 (1) the WLAN_STA_DLS flag is never set so we can't ever look
     up a DLS peer when we receive action frames about it
 (2) debugfs files with mode 0444 aren't really writable, yet
     the only way to trigger DLS.

Remove it all again until we figure out if we *really* need it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>

---
Applies after the sta info flags fix.

 include/linux/ieee80211.h      |  174 ---------
 net/mac80211/debugfs_netdev.c  |  335 -----------------
 net/mac80211/ieee80211.c       |    1 
 net/mac80211/ieee80211_i.h     |   90 ----
 net/mac80211/ieee80211_iface.c |   16 
 net/mac80211/ieee80211_sta.c   |  782 -----------------------------------------
 net/mac80211/sta_info.c        |   30 -
 net/mac80211/sta_info.h        |    9 
 net/mac80211/tx.c              |   17 
 net/mac80211/wme.c             |   33 -
 10 files changed, 18 insertions(+), 1469 deletions(-)

--- wireless-dev.orig/include/linux/ieee80211.h	2007-09-20 17:31:05.961571832 +0200
+++ wireless-dev/include/linux/ieee80211.h	2007-09-20 17:35:39.711571615 +0200
@@ -124,58 +124,6 @@ struct ieee80211_ht_additional_info {
 	u8 basic_set[16];
 }__attribute__ ((packed));
 
-
-#define IEEE80211_TSINFO_TYPE(a)	((a.byte1 & 0x01) >> 0)
-#define IEEE80211_TSINFO_TSID(a)	((a.byte1 & 0x1E) >> 1)
-#define IEEE80211_TSINFO_DIR(a)		((a.byte1 & 0x60) >> 5)
-#define IEEE80211_TSINFO_POLICY(a)	((a.byte1 & 0x80) >> 7 + \
-					 (a.byte2 & 0x01) << 1)
-#define IEEE80211_TSINFO_AGG(a)		((a.byte2 & 0x02) >> 1)
-#define IEEE80211_TSINFO_APSD(a)	((a.byte2 & 0x04) >> 2)
-#define IEEE80211_TSINFO_UP(a)		((a.byte2 & 0x38) >> 3)
-#define IEEE80211_TSINFO_ACK(a)		((a.byte2 & 0xC0) >> 6)
-#define IEEE80211_TSINFO_SCHEDULE(a)	((a.byte3 & 0x01) >> 0)
-
-#define IEEE80211_SET_TSINFO_TYPE(i, d)		(i.byte1 |= (d << 0) & 0x01)
-#define IEEE80211_SET_TSINFO_TSID(i, d)		(i.byte1 |= (d << 1) & 0x1E)
-#define IEEE80211_SET_TSINFO_DIR(i, d)		(i.byte1 |= (d << 5) & 0x60)
-#define IEEE80211_SET_TSINFO_POLICY(i, d)	\
-do {						\
-						i.byte1 |= (d & 0x01) << 7; \
-						i.byte2 |= (d & 0x02) >> 1; \
-} while(0)
-#define IEEE80211_SET_TSINFO_AGG(i, d)		(i.byte2 |= (d << 1) & 0x02)
-#define IEEE80211_SET_TSINFO_APSD(i, d)		(i.byte2 |= (d << 2) & 0x04)
-#define IEEE80211_SET_TSINFO_UP(i, d)		(i.byte2 |= (d << 3) & 0x38)
-#define IEEE80211_SET_TSINFO_ACK(i, d)		(i.byte2 |= (d << 6) & 0xC0)
-#define IEEE80211_SET_TSINFO_SCHEDULE(i, d)	(i.byte3 |= (d << 0) & 0x01)
-
-struct ieee80211_ts_info {
-	u8 byte1;
-	u8 byte2;
-	u8 byte3;
-} __attribute__ ((packed));
-
-struct ieee80211_elem_tspec {
-	struct ieee80211_ts_info ts_info;
-	__le16 nominal_msdu_size;
-	__le16 max_msdu_size;
-	__le32 min_service_interval;
-	__le32 max_service_interval;
-	__le32 inactivity_interval;
-	__le32 suspension_interval;
-	__le32 service_start_time;
-	__le32 min_data_rate;
-	__le32 mean_data_rate;
-	__le32 peak_data_rate;
-	__le32 burst_size;
-	__le32 delay_bound;
-	__le32 min_phy_rate;
-	__le16 surplus_band_allow;
-	__le16 medium_time;
-} __attribute__ ((packed));
-
-
 struct ieee80211_mgmt {
 	__le16 frame_control;
 	__le16 duration;
@@ -243,51 +191,9 @@ struct ieee80211_mgmt {
 				struct {
 					u8 action_code;
 					u8 dialog_token;
-					u8 variable[0];
-				} __attribute__ ((packed)) addts_req;
-				struct {
-					u8 action_code;
-					u8 dialog_token;
-					__le16 status_code;
-					u8 variable[0];
-				} __attribute__ ((packed)) addts_resp;
-				struct {
-					u8 action_code;
-					struct ieee80211_ts_info ts_info;
-					__le16 reason_code;
-				} __attribute__ ((packed)) delts;
-				struct {
-					u8 action_code;
-					u8 dialog_token;
 					u8 status_code;
 					u8 variable[0];
 				} __attribute__ ((packed)) wme_action;
-				struct {
-					u8 action_code;
-					u8 dest[6];
-					u8 src[6];
-					__le16 capab_info;
-					__le16 timeout;
-					/* Followed by Supported Rates and
-					 * Extended Supported Rates */
-					u8 variable[0];
-				} __attribute__ ((packed)) dls_req;
-				struct {
-					u8 action_code;
-					__le16 status_code;
-					u8 dest[6];
-					u8 src[6];
-					/* Followed by Capability Information,
-					 * Supported Rates and Extended
-					 * Supported Rates */
-					u8 variable[0];
-				} __attribute__ ((packed)) dls_resp;
-				struct {
-					u8 action_code;
-					u8 dest[6];
-					u8 src[6];
-					__le16 reason_code;
-				} __attribute__ ((packed)) dls_teardown;
 				struct{
 					u8 action_code;
 					u8 element_id;
@@ -393,6 +299,8 @@ enum ieee80211_statuscode {
 	/* 802.11g */
 	WLAN_STATUS_ASSOC_DENIED_NOSHORTTIME = 25,
 	WLAN_STATUS_ASSOC_DENIED_NODSSSOFDM = 26,
+	/* 802.11e */
+	WLAN_STATUS_REQUEST_DECLINED = 37,
 	/* 802.11i */
 	WLAN_STATUS_INVALID_IE = 40,
 	WLAN_STATUS_INVALID_GROUP_CIPHER = 41,
@@ -401,18 +309,6 @@ enum ieee80211_statuscode {
 	WLAN_STATUS_UNSUPP_RSN_VERSION = 44,
 	WLAN_STATUS_INVALID_RSN_IE_CAP = 45,
 	WLAN_STATUS_CIPHER_SUITE_REJECTED = 46,
-	/* 802.11e */
-	WLAN_STATUS_UNSPECIFIED_QOS = 32,
-	WLAN_STATUS_ASSOC_DENIED_NOBANDWIDTH = 33,
-	WLAN_STATUS_ASSOC_DENIED_LOWACK = 34,
-	WLAN_STATUS_ASSOC_DENIED_UNSUPP_QOS = 35,
-	WLAN_STATUS_REQUEST_DECLINED = 37,
-	WLAN_STATUS_INVALID_QOS_PARAM = 38,
-	WLAN_STATUS_CHANGE_TSPEC = 39,
-	WLAN_STATUS_WAIT_TS_DELAY = 47,
-	WLAN_STATUS_NO_DIRECT_LINK = 48,
-	WLAN_STATUS_STA_NOT_PRESENT = 49,
-	WLAN_STATUS_STA_NOT_QSTA = 50,
 };
 
 
@@ -443,16 +339,6 @@ enum ieee80211_reasoncode {
 	WLAN_REASON_INVALID_RSN_IE_CAP = 22,
 	WLAN_REASON_IEEE8021X_FAILED = 23,
 	WLAN_REASON_CIPHER_SUITE_REJECTED = 24,
-	/* 802.11e */
-	WLAN_REASON_DISASSOC_UNSPECIFIED_QOS = 32,
-	WLAN_REASON_DISASSOC_QAP_NO_BANDWIDTH = 33,
-	WLAN_REASON_DISASSOC_LOW_ACK = 34,
-	WLAN_REASON_DISASSOC_QAP_EXCEED_TXOP = 35,
-	WLAN_REASON_QSTA_LEAVE_QBSS = 36,
-	WLAN_REASON_QSTA_NOT_USE = 37,
-	WLAN_REASON_QSTA_REQUIRE_SETUP = 38,
-	WLAN_REASON_QSTA_TIMEOUT = 39,
-	WLAN_REASON_QSTA_CIPHER_NOT_SUPP = 45,
 };
 
 
@@ -465,20 +351,6 @@ enum ieee80211_category {
 	WLAN_CATEGORY_WMM = 17,
 };
 
-/* QoS Action Code */
-enum ieee80211_qos_actioncode {
-	WLAN_ACTION_QOS_ADDTS_REQ = 0,
-	WLAN_ACTION_QOS_ADDTS_RESP = 1,
-	WLAN_ACTION_QOS_DELTS = 2,
-	WLAN_ACTION_QOS_SCHEDULE = 3,
-};
-
-/* DLS Action Code */
-enum ieee80211_dls_actioncode {
-	WLAN_ACTION_DLS_REQ = 0,
-	WLAN_ACTION_DLS_RESP = 1,
-	WLAN_ACTION_DLS_TEARDOWN = 2,
-};
 
 /* BACK Action Code */
 enum ieee80211_back_actioncode {
@@ -502,15 +374,6 @@ enum ieee80211_eid {
 	WLAN_EID_HP_PARAMS = 8,
 	WLAN_EID_HP_TABLE = 9,
 	WLAN_EID_REQUEST = 10,
-	/* 802.11e */
-	WLAN_EID_QBSS_LOAD = 11,
-	WLAN_EID_EDCA_PARAM_SET = 12,
-	WLAN_EID_TSPEC = 13,
-	WLAN_EID_TCLAS = 14,
-	WLAN_EID_SCHEDULE = 15,
-	WLAN_EID_TS_DELAY = 43,
-	WLAN_EID_TCLAS_PROCESSING = 44,
-	WLAN_EID_QOS_CAPA = 46,
 	/* 802.11h */
 	WLAN_EID_PWR_CONSTRAINT = 32,
 	WLAN_EID_PWR_CAPABILITY = 33,
@@ -549,39 +412,6 @@ enum ieee80211_eid {
 
 #define WLAN_MAX_KEY_LEN		32
 
-enum ieee80211_tsinfo_direction {
-	WLAN_TSINFO_UPLINK = 0,
-	WLAN_TSINFO_DOWNLINK = 1,
-	WLAN_TSINFO_DIRECTLINK = 2,
-	WLAN_TSINFO_BIDIRECTIONAL = 3,
-};
-
-enum ieee80211_tsinfo_access {
-	WLAN_TSINFO_EDCA = 1,
-	WLAN_TSINFO_HCCA = 2,
-	WLAN_TSINFO_HEMM = 3,
-};
-
-enum ieee80211_tsinfo_psb {
-	WLAN_TSINFO_PSB_LEGACY = 0,
-	WLAN_TSINFO_PSB_APSD = 1,
-};
-
-
-/* WI-FI Alliance OUI Type and Subtype */
-enum wifi_oui_type {
-	WIFI_OUI_TYPE_WPA = 1,
-	WIFI_OUI_TYPE_WMM = 2,
-	WIFI_OUI_TYPE_WSC = 4,
-	WIFI_OUI_TYPE_PSD = 6,
-};
-
-enum wifi_oui_stype_wmm {
-	WIFI_OUI_STYPE_WMM_INFO = 0,
-	WIFI_OUI_STYPE_WMM_PARAM = 1,
-	WIFI_OUI_STYPE_WMM_TSPEC = 2,
-};
-
 /**
  * ieee80211_get_SA - get pointer to SA
  *
--- wireless-dev.orig/net/mac80211/debugfs_netdev.c	2007-09-20 17:31:05.981584093 +0200
+++ wireless-dev/net/mac80211/debugfs_netdev.c	2007-09-20 17:35:39.711571615 +0200
@@ -87,267 +87,6 @@ static const struct file_operations name
 		IEEE80211_IF_FMT_##format(name, field)			\
 		__IEEE80211_IF_FILE(name)
 
-#define DEBUGFS_QOS_FILE(name, f)					\
-static ssize_t qos_ ##name## _write(struct file *file,			\
-				    const char __user *userbuf,		\
-				    size_t count, loff_t *ppos)		\
-{									\
-	struct ieee80211_sub_if_data *sdata = file->private_data;	\
-									\
-	f(sdata->dev, &sdata->u.sta, &sdata->u.sta.tspec);		\
-									\
-	return count;							\
-}									\
-									\
-static const struct file_operations qos_ ##name## _ops = {		\
-	.write = qos_ ##name## _write,					\
-	.open = mac80211_open_file_generic,				\
-};
-
-#define DEBUGFS_QOS_ADD(name)						\
-	sdata->debugfs.sta.qos.name = debugfs_create_file(#name, 0444, qosd,\
-		sdata, &qos_ ##name## _ops);
-
-#define DEBUGFS_QOS_DEL(name)						\
-	do {								\
-		debugfs_remove(sdata->debugfs.sta.qos.name);		\
-		sdata->debugfs.sta.qos.name = NULL;			\
-	} while (0)
-
-DEBUGFS_QOS_FILE(addts_11e, ieee80211_send_addts);
-DEBUGFS_QOS_FILE(addts_wmm, wmm_send_addts);
-DEBUGFS_QOS_FILE(delts_11e, ieee80211_send_delts);
-DEBUGFS_QOS_FILE(delts_wmm, wmm_send_delts);
-
-static ssize_t qos_if_dls_mac(const struct ieee80211_sub_if_data *sdata,
-			      char *buf, int buflen)
-{
-	return scnprintf(buf, buflen, MAC_FMT "\n",
-			 MAC_ARG(sdata->u.sta.dls_mac));
-}
-
-static ssize_t qos_dls_mac_read(struct file *file,
-				char __user *userbuf,
-				size_t count, loff_t *ppos)
-{
-	return ieee80211_if_read(file->private_data,
-				 userbuf, count, ppos,
-				 qos_if_dls_mac);
-}
-
-static ssize_t qos_dls_mac_write(struct file *file, const char __user *userbuf,
-				 size_t count, loff_t *ppos)
-{
-	struct ieee80211_sub_if_data *sdata = file->private_data;
-	char buf[20];
-	size_t size;
-	u8 m[ETH_ALEN];
-
-	size = min(sizeof(buf) - 1, count);
-	buf[size] = '\0';
-	if (copy_from_user(buf, userbuf, size))
-		return -EFAULT;
-
-	if (sscanf(buf, "%02hhx:%02hhx:%02hhx:%02hhx:%02hhx:%02hhx",
-		   &((u8*)(m))[0], &((u8*)(m))[1], &((u8*)(m))[2],
-		   &((u8*)(m))[3], &((u8*)(m))[4], &((u8*)(m))[5]) != ETH_ALEN){
-		printk(KERN_ERR "%s: sscanf input error\n", sdata->dev->name);
-		return -EINVAL;
-	}
-	memcpy(sdata->u.sta.dls_mac, m, ETH_ALEN);
-	return count;
-}
-
-static const struct file_operations qos_dls_mac_ops = {
-	.read = qos_dls_mac_read,
-	.write = qos_dls_mac_write,
-	.open = mac80211_open_file_generic,
-};
-
-static ssize_t qos_if_dls_op(const struct ieee80211_sub_if_data *sdata,
-			     char *buf, int buflen)
-{
-	return scnprintf(buf, buflen,
-			 "DLS Operation: Setup = 1; Teardown = 2\n");
-}
-
-static ssize_t qos_dls_op_read(struct file *file, char __user *userbuf,
-			       size_t count, loff_t *ppos)
-{
-	return ieee80211_if_read(file->private_data,
-				 userbuf, count, ppos,
-				 qos_if_dls_op);
-}
-
-static ssize_t qos_dls_op_write(struct file *file, const char __user *userbuf,
-				 size_t count, loff_t *ppos)
-{
-	struct ieee80211_sub_if_data *sdata = file->private_data;
-	char buf[20];
-	size_t size;
-	unsigned int opt;
-
-	size = min(sizeof(buf) - 1, count);
-	buf[size] = '\0';
-	if (copy_from_user(buf, userbuf, size))
-		return -EFAULT;
-
-	if (sscanf(buf, "%u", &opt) != 1) {
-		printk(KERN_ERR "%s: sscanf input error\n", sdata->dev->name);
-		return -EINVAL;
-	}
-	switch (opt) {
-	case 1:
-		ieee80211_send_dls_req(sdata->dev, &sdata->u.sta,
-				       sdata->u.sta.dls_mac, 0);
-		break;
-	case 2:
-		ieee80211_send_dls_teardown(sdata->dev, &sdata->u.sta,
-					    sdata->u.sta.dls_mac,
-					    WLAN_REASON_QSTA_NOT_USE);
-		break;
-	default:
-		printk(KERN_ERR "Unknown DLS Operation: %d\n", opt);
-		break;
-	}
-	return count;
-}
-
-static const struct file_operations qos_dls_op_ops = {
-	.read = qos_dls_op_read,
-	.write = qos_dls_op_write,
-	.open = mac80211_open_file_generic,
-};
-
-#define DEBUGFS_TSINFO_FILE(_name, min_val, max_val)			\
-static ssize_t tsinfo_ ##_name## _read(struct file *file,		\
-				       char __user *userbuf,		\
-				       size_t count, loff_t *ppos)	\
-{									\
-	char buf[20];							\
-	struct ieee80211_sub_if_data *sdata = file->private_data;	\
-	int res = scnprintf(buf, count, "%u\n",				\
-		IEEE80211_TSINFO_## _name (sdata->u.sta.tspec.ts_info));\
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
-}									\
-									\
-static ssize_t tsinfo_ ##_name## _write(struct file *file,		\
-				        const char __user *userbuf,	\
-				        size_t count, loff_t *ppos)	\
-{									\
-	char buf[20];							\
-	size_t size;							\
-	int val;							\
-	struct ieee80211_sub_if_data *sdata = file->private_data;	\
-									\
-	size = min(sizeof(buf) - 1, count);				\
-	buf[size] = '\0';						\
-	if (copy_from_user(buf, userbuf, size))				\
-		return -EFAULT;						\
-									\
-	val = simple_strtoul(buf, NULL, 0);				\
-	if ((val < min_val) || (val > max_val)) {			\
-		printk(KERN_ERR "%s: set value (%u) out of range "	\
-		       "[%u, %u]\n",sdata->dev->name,val,min_val,max_val);\
-		return -EINVAL;						\
-	}								\
-	IEEE80211_SET_TSINFO_ ##_name (sdata->u.sta.tspec.ts_info, val);\
-	return count;							\
-}									\
-									\
-static const struct file_operations tsinfo_ ##_name## _ops = {		\
-	.read = tsinfo_ ##_name## _read,				\
-	.write = tsinfo_ ##_name## _write,				\
-	.open = mac80211_open_file_generic,				\
-};
-
-#define DEBUGFS_TSINFO_ADD_TSID						\
-	sdata->debugfs.sta.tsinfo.tsid =				\
-		debugfs_create_file("tsid", 0444, tsinfod,		\
-				    sdata, &tsinfo_TSID_ops);
-
-#define DEBUGFS_TSINFO_ADD_DIR						\
-	sdata->debugfs.sta.tsinfo.direction =				\
-		debugfs_create_file("direction", 0444, tsinfod,		\
-				    sdata, &tsinfo_DIR_ops);
-
-#define DEBUGFS_TSINFO_ADD_UP						\
-	sdata->debugfs.sta.tsinfo.up =					\
-		debugfs_create_file("up", 0444, tsinfod,		\
-				    sdata, &tsinfo_UP_ops);
-
-#define DEBUGFS_TSINFO_DEL(name)					\
-	do {								\
-		debugfs_remove(sdata->debugfs.sta.tsinfo.name);		\
-		sdata->debugfs.sta.tsinfo.name = NULL;			\
-	} while (0)
-
-DEBUGFS_TSINFO_FILE(TSID, 8, 15);
-DEBUGFS_TSINFO_FILE(DIR, 0, 3);
-DEBUGFS_TSINFO_FILE(UP, 0, 7);
-
-#define DEBUGFS_TSPEC_FILE(name, format_string, endian_f1, endian_f2)	\
-static ssize_t tspec_ ##name## _read(struct file *file,			\
-				      char __user *userbuf,		\
-				      size_t count, loff_t *ppos)	\
-{									\
-	char buf[20];							\
-	struct ieee80211_sub_if_data *sdata = file->private_data;	\
-	int res = scnprintf(buf, count, format_string "\n",		\
-			    endian_f1(sdata->u.sta.tspec.name));	\
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
-}									\
-									\
-static ssize_t tspec_ ##name## _write(struct file *file,		\
-				       const char __user *userbuf,	\
-				       size_t count, loff_t *ppos)	\
-{									\
-	char buf[20];							\
-	size_t size;							\
-	struct ieee80211_sub_if_data *sdata = file->private_data;	\
-									\
-	size = min(sizeof(buf) - 1, count);				\
-	buf[size] = '\0';						\
-	if (copy_from_user(buf, userbuf, size))				\
-		return -EFAULT;						\
-									\
-	sdata->u.sta.tspec.name = endian_f2(simple_strtoul(buf, NULL, 0));\
-	return count;							\
-}									\
-									\
-static const struct file_operations tspec_ ##name## _ops = {		\
-	.read = tspec_ ##name## _read,					\
-	.write = tspec_ ##name## _write,				\
-	.open = mac80211_open_file_generic,				\
-};
-
-#define DEBUGFS_TSPEC_ADD(name)						\
-	sdata->debugfs.sta.tspec.name = debugfs_create_file(#name,	\
-		0444, tspecd, sdata, &tspec_ ##name## _ops);
-
-#define DEBUGFS_TSPEC_DEL(name)						\
-	do {								\
-		debugfs_remove(sdata->debugfs.sta.tspec.name);		\
-		sdata->debugfs.sta.tspec.name = NULL;			\
-	} while (0)
-
-DEBUGFS_TSPEC_FILE(nominal_msdu_size, "%hu", le16_to_cpu, cpu_to_le16);
-DEBUGFS_TSPEC_FILE(max_msdu_size, "%hu", le16_to_cpu, cpu_to_le16);
-DEBUGFS_TSPEC_FILE(min_service_interval, "%u", le32_to_cpu, cpu_to_le32);
-DEBUGFS_TSPEC_FILE(max_service_interval, "%u", le32_to_cpu, cpu_to_le32);
-DEBUGFS_TSPEC_FILE(inactivity_interval, "%u", le32_to_cpu, cpu_to_le32);
-DEBUGFS_TSPEC_FILE(suspension_interval, "%u", le32_to_cpu, cpu_to_le32);
-DEBUGFS_TSPEC_FILE(service_start_time, "%u", le32_to_cpu, cpu_to_le32);
-DEBUGFS_TSPEC_FILE(min_data_rate, "%u", le32_to_cpu, cpu_to_le32);
-DEBUGFS_TSPEC_FILE(mean_data_rate, "%u", le32_to_cpu, cpu_to_le32);
-DEBUGFS_TSPEC_FILE(peak_data_rate, "%u", le32_to_cpu, cpu_to_le32);
-DEBUGFS_TSPEC_FILE(burst_size, "%u", le32_to_cpu, cpu_to_le32);
-DEBUGFS_TSPEC_FILE(delay_bound, "%u", le32_to_cpu, cpu_to_le32);
-DEBUGFS_TSPEC_FILE(min_phy_rate, "%u", le32_to_cpu, cpu_to_le32);
-DEBUGFS_TSPEC_FILE(surplus_band_allow, "%hu", le16_to_cpu, cpu_to_le16);
-DEBUGFS_TSPEC_FILE(medium_time, "%hu", le16_to_cpu, cpu_to_le16);
-
-
 /* common attributes */
 IEEE80211_IF_FILE(channel_use, channel_use, DEC);
 IEEE80211_IF_FILE(drop_unencrypted, drop_unencrypted, DEC);
@@ -428,10 +167,6 @@ IEEE80211_IF_FILE(peer, u.wds.remote_add
 
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 {
-	struct dentry *qosd;
-	struct dentry *tsinfod;
-	struct dentry *tspecd;
-
 	DEBUGFS_ADD(channel_use, sta);
 	DEBUGFS_ADD(drop_unencrypted, sta);
 	DEBUGFS_ADD(eapol, sta);
@@ -450,42 +185,6 @@ static void add_sta_files(struct ieee802
 	DEBUGFS_ADD(auth_alg, sta);
 	DEBUGFS_ADD(auth_transaction, sta);
 	DEBUGFS_ADD(flags, sta);
-
-	qosd = debugfs_create_dir("qos", sdata->debugfsdir);
-	sdata->debugfs.sta.qos_dir = qosd;
-
-	DEBUGFS_QOS_ADD(addts_11e);
-	DEBUGFS_QOS_ADD(addts_wmm);
-	DEBUGFS_QOS_ADD(delts_11e);
-	DEBUGFS_QOS_ADD(delts_wmm);
-	DEBUGFS_QOS_ADD(dls_mac);
-	DEBUGFS_QOS_ADD(dls_op);
-
-	tsinfod = debugfs_create_dir("ts_info", qosd);
-	sdata->debugfs.sta.tsinfo_dir = tsinfod;
-
-	DEBUGFS_TSINFO_ADD_TSID;
-	DEBUGFS_TSINFO_ADD_DIR;
-	DEBUGFS_TSINFO_ADD_UP;
-
-	tspecd = debugfs_create_dir("tspec", qosd);
-	sdata->debugfs.sta.tspec_dir = tspecd;
-
-	DEBUGFS_TSPEC_ADD(nominal_msdu_size);
-	DEBUGFS_TSPEC_ADD(max_msdu_size);
-	DEBUGFS_TSPEC_ADD(min_service_interval);
-	DEBUGFS_TSPEC_ADD(max_service_interval);
-	DEBUGFS_TSPEC_ADD(inactivity_interval);
-	DEBUGFS_TSPEC_ADD(suspension_interval);
-	DEBUGFS_TSPEC_ADD(service_start_time);
-	DEBUGFS_TSPEC_ADD(min_data_rate);
-	DEBUGFS_TSPEC_ADD(mean_data_rate);
-	DEBUGFS_TSPEC_ADD(peak_data_rate);
-	DEBUGFS_TSPEC_ADD(burst_size);
-	DEBUGFS_TSPEC_ADD(delay_bound);
-	DEBUGFS_TSPEC_ADD(min_phy_rate);
-	DEBUGFS_TSPEC_ADD(surplus_band_allow);
-	DEBUGFS_TSPEC_ADD(medium_time);
 }
 
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
@@ -579,40 +278,6 @@ static void del_sta_files(struct ieee802
 	DEBUGFS_DEL(auth_alg, sta);
 	DEBUGFS_DEL(auth_transaction, sta);
 	DEBUGFS_DEL(flags, sta);
-
-	DEBUGFS_TSINFO_DEL(tsid);
-	DEBUGFS_TSINFO_DEL(direction);
-	DEBUGFS_TSINFO_DEL(up);
-
-	DEBUGFS_TSPEC_DEL(nominal_msdu_size);
-	DEBUGFS_TSPEC_DEL(max_msdu_size);
-	DEBUGFS_TSPEC_DEL(min_service_interval);
-	DEBUGFS_TSPEC_DEL(max_service_interval);
-	DEBUGFS_TSPEC_DEL(inactivity_interval);
-	DEBUGFS_TSPEC_DEL(suspension_interval);
-	DEBUGFS_TSPEC_DEL(service_start_time);
-	DEBUGFS_TSPEC_DEL(min_data_rate);
-	DEBUGFS_TSPEC_DEL(mean_data_rate);
-	DEBUGFS_TSPEC_DEL(peak_data_rate);
-	DEBUGFS_TSPEC_DEL(burst_size);
-	DEBUGFS_TSPEC_DEL(delay_bound);
-	DEBUGFS_TSPEC_DEL(min_phy_rate);
-	DEBUGFS_TSPEC_DEL(surplus_band_allow);
-	DEBUGFS_TSPEC_DEL(medium_time);
-
-	DEBUGFS_QOS_DEL(addts_11e);
-	DEBUGFS_QOS_DEL(addts_wmm);
-	DEBUGFS_QOS_DEL(delts_11e);
-	DEBUGFS_QOS_DEL(delts_wmm);
-	DEBUGFS_QOS_DEL(dls_mac);
-	DEBUGFS_QOS_DEL(dls_op);
-
-	debugfs_remove(sdata->debugfs.sta.tspec_dir);
-	sdata->debugfs.sta.tspec_dir = NULL;
-	debugfs_remove(sdata->debugfs.sta.tsinfo_dir);
-	sdata->debugfs.sta.tsinfo_dir = NULL;
-	debugfs_remove(sdata->debugfs.sta.qos_dir);
-	sdata->debugfs.sta.qos_dir = NULL;
 }
 
 static void del_ap_files(struct ieee80211_sub_if_data *sdata)
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-09-20 17:31:06.001571561 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-09-20 17:35:39.711571615 +0200
@@ -60,10 +60,6 @@ struct ieee80211_local;
  * increased memory use (about 2 kB of RAM per entry). */
 #define IEEE80211_FRAGMENT_MAX 4
 
-/* Minimum and Maximum TSID used by EDCA. EDCA uses 0~7; HCCA uses 8~15 */
-#define EDCA_TSID_MIN 0
-#define EDCA_TSID_MAX 7
-
 struct ieee80211_fragment_entry {
 	unsigned long first_frag_time;
 	unsigned int seq;
@@ -194,19 +190,6 @@ struct ieee80211_tx_stored_packet {
 	unsigned int last_frag_rate_ctrl_probe;
 };
 
-struct sta_ts_data {
-	enum {
-		TS_STATUS_UNUSED	= 0,
-		TS_STATUS_ACTIVE	= 1,
-		TS_STATUS_INACTIVE	= 2,
-		TS_STATUS_THROTTLING	= 3,
-	} status;
-	u8 dialog_token;
-	u8 up;
-	u32 admitted_time_usec;
-	u32 used_time_usec;
-};
-
 typedef ieee80211_txrx_result (*ieee80211_tx_handler)
 (struct ieee80211_txrx_data *tx);
 
@@ -268,7 +251,6 @@ struct ieee80211_if_sta {
 	} state;
 	struct timer_list timer;
 	struct work_struct work;
-	struct timer_list admit_timer; /* Recompute EDCA admitted time */
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
@@ -305,17 +287,6 @@ struct ieee80211_if_sta {
 	u32 supp_rates_bits;
 
 	int wmm_last_param_set;
-
-	u32 dot11EDCAAveragingPeriod;
-	u32 MPDUExchangeTime;
-#define STA_TSID_NUM   16
-#define STA_TSDIR_NUM  2
-	/* EDCA: 0~7, HCCA: 8~15 */
-	struct sta_ts_data ts_data[STA_TSID_NUM][STA_TSDIR_NUM];
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct ieee80211_elem_tspec tspec;
-	u8 dls_mac[ETH_ALEN];
-#endif
 };
 
 
@@ -391,39 +362,6 @@ struct ieee80211_sub_if_data {
 			struct dentry *auth_alg;
 			struct dentry *auth_transaction;
 			struct dentry *flags;
-			struct dentry *qos_dir;
-			struct {
-				struct dentry *addts_11e;
-				struct dentry *addts_wmm;
-				struct dentry *delts_11e;
-				struct dentry *delts_wmm;
-				struct dentry *dls_mac;
-				struct dentry *dls_op;
-			} qos;
-			struct dentry *tsinfo_dir;
-			struct {
-				struct dentry *tsid;
-				struct dentry *direction;
-				struct dentry *up;
-			} tsinfo;
-			struct dentry *tspec_dir;
-			struct {
-				struct dentry *nominal_msdu_size;
-				struct dentry *max_msdu_size;
-				struct dentry *min_service_interval;
-				struct dentry *max_service_interval;
-				struct dentry *inactivity_interval;
-				struct dentry *suspension_interval;
-				struct dentry *service_start_time;
-				struct dentry *min_data_rate;
-				struct dentry *mean_data_rate;
-				struct dentry *peak_data_rate;
-				struct dentry *burst_size;
-				struct dentry *delay_bound;
-				struct dentry *min_phy_rate;
-				struct dentry *surplus_band_allow;
-				struct dentry *medium_time;
-			} tspec;
 		} sta;
 		struct {
 			struct dentry *channel_use;
@@ -708,11 +646,6 @@ struct ieee80211_local {
 #endif
 };
 
-enum sta_link_direction {
-	STA_TS_UPLINK = 0,
-	STA_TS_DOWNLINK = 1,
-};
-
 static inline struct ieee80211_local *hw_to_local(
 	struct ieee80211_hw *hw)
 {
@@ -840,7 +773,6 @@ int ieee80211_set_channel(struct ieee802
 /* ieee80211_sta.c */
 void ieee80211_sta_timer(unsigned long data);
 void ieee80211_sta_work(struct work_struct *work);
-void ieee80211_admit_refresh(unsigned long ptr);
 void ieee80211_sta_scan_work(struct work_struct *work);
 void ieee80211_sta_rx_mgmt(struct net_device *dev, struct sk_buff *skb,
 			   struct ieee80211_rx_status *rx_status);
@@ -861,28 +793,6 @@ struct sta_info * ieee80211_ibss_add_sta
 					 u8 *addr);
 int ieee80211_sta_deauthenticate(struct net_device *dev, u16 reason);
 int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
-void ieee80211_send_addts(struct net_device *dev,
-			  struct ieee80211_if_sta *ifsta,
-			  struct ieee80211_elem_tspec *tspec);
-void wmm_send_addts(struct net_device *dev,
-		    struct ieee80211_if_sta *ifsta,
-		    struct ieee80211_elem_tspec *tspec);
-void ieee80211_send_delts(struct net_device *dev,
-			  struct ieee80211_if_sta *ifsta,
-			  struct ieee80211_elem_tspec *tp);
-void wmm_send_delts(struct net_device *dev,
-		    struct ieee80211_if_sta *ifsta,
-		    struct ieee80211_elem_tspec *tp);
-void ieee80211_send_dls_req(struct net_device *dev,
-			    struct ieee80211_if_sta *ifsta,
-			    u8 *addr, u16 timeout);
-void ieee80211_send_dls_teardown(struct net_device *dev,
-				 struct ieee80211_if_sta *ifsta,
-				 u8 *mac, u16 reason);
-struct sta_info *dls_info_get(struct ieee80211_local *local, u8 *addr);
-void dls_info_add(struct ieee80211_if_sta *ifsta, struct sta_info *dls);
-void dls_info_stop(struct ieee80211_if_sta *ifsta);
-int dls_link_status(struct ieee80211_local *local, u8 *addr);
 void ieee80211_erp_info_change_notify(struct net_device *dev, u8 changes);
 void ieee80211_reset_erp_info(struct net_device *dev);
 
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-09-20 17:31:06.031570042 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-09-20 17:35:39.771575413 +0200
@@ -184,10 +184,6 @@ void ieee80211_if_set_type(struct net_de
 			    (unsigned long) sdata);
 		skb_queue_head_init(&ifsta->skb_queue);
 
-		init_timer(&ifsta->admit_timer);
-		ifsta->admit_timer.data = (unsigned long) dev;
-		ifsta->admit_timer.function = ieee80211_admit_refresh;
-
 		ifsta->capab = WLAN_CAPABILITY_ESS;
 		ifsta->auth_algs = IEEE80211_AUTH_ALG_OPEN |
 			IEEE80211_AUTH_ALG_SHARED_KEY;
@@ -196,18 +192,6 @@ void ieee80211_if_set_type(struct net_de
 			IEEE80211_STA_AUTO_BSSID_SEL |
 			IEEE80211_STA_AUTO_CHANNEL_SEL;
 
-		/* Initialize non-AP QSTA QoS Params */
-		ifsta->dot11EDCAAveragingPeriod = 5;
-		ifsta->MPDUExchangeTime = 0;
-#ifdef CONFIG_MAC80211_DEBUGFS
-		ifsta->tspec.nominal_msdu_size = cpu_to_le16(200),
-		ifsta->tspec.inactivity_interval = cpu_to_le32(40),
-		ifsta->tspec.mean_data_rate = cpu_to_le32(40000),
-		ifsta->tspec.min_phy_rate = cpu_to_le32(6000000),
-		ifsta->tspec.surplus_band_allow = cpu_to_le16(8192),
-		ifsta->tspec.medium_time = cpu_to_le16(30),
-#endif
-
 		msdata = IEEE80211_DEV_TO_SUB_IF(sdata->local->mdev);
 		sdata->bss = &msdata->u.ap;
 		break;
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-09-20 17:31:06.051571886 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-09-20 17:35:39.771575413 +0200
@@ -467,7 +467,6 @@ static int ieee80211_stop(struct net_dev
 	case IEEE80211_IF_TYPE_IBSS:
 		sdata->u.sta.state = IEEE80211_DISABLED;
 		del_timer_sync(&sdata->u.sta.timer);
-		del_timer_sync(&sdata->u.sta.admit_timer);
 		/*
 		 * When we get here, the interface is marked down.
 		 * Call synchronize_rcu() to wait for the RX path
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-09-20 17:31:06.071570367 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-09-20 17:35:39.801572266 +0200
@@ -95,7 +95,6 @@ struct ieee802_11_elems {
 	u8 *ext_supp_rates;
 	u8 *wmm_info;
 	u8 *wmm_param;
-	u8 *tspec;
 
 	/* length of them, respectively */
 	u8 ssid_len;
@@ -114,7 +113,6 @@ struct ieee802_11_elems {
 	u8 ext_supp_rates_len;
 	u8 wmm_info_len;
 	u8 wmm_param_len;
-	u8 tspec_len;
 };
 
 enum ParseRes { ParseOK = 0, ParseUnknown = 1, ParseFailed = -1 };
@@ -182,34 +180,17 @@ static enum ParseRes ieee802_11_parse_el
 			if (elen >= 4 && pos[0] == 0x00 && pos[1] == 0x50 &&
 			    pos[2] == 0xf2) {
 				/* Microsoft OUI (00:50:F2) */
-				if (pos[3] == WIFI_OUI_TYPE_WPA) {
+				if (pos[3] == 1) {
 					/* OUI Type 1 - WPA IE */
 					elems->wpa = pos;
 					elems->wpa_len = elen;
-				} else if (elen >= 5 &&
-					   pos[3] == WIFI_OUI_TYPE_WMM) {
-					switch (pos[4]) {
-					case WIFI_OUI_STYPE_WMM_INFO:
+				} else if (elen >= 5 && pos[3] == 2) {
+					if (pos[4] == 0) {
 						elems->wmm_info = pos;
 						elems->wmm_info_len = elen;
-						break;
-					case WIFI_OUI_STYPE_WMM_PARAM:
+					} else if (pos[4] == 1) {
 						elems->wmm_param = pos;
 						elems->wmm_param_len = elen;
-						break;
-					case WIFI_OUI_STYPE_WMM_TSPEC:
-						if (elen != 61) {
-							printk(KERN_ERR "Wrong "
-							       "TSPEC size.\n");
-							break;
-						}
-						elems->tspec = pos + 6;
-						elems->tspec_len = elen - 6;
-						break;
-					default:
-						//printk(KERN_ERR "Unsupported "
-						//       "WiFi OUI %d\n", pos[4]);
-						break;
 					}
 				}
 			}
@@ -234,14 +215,6 @@ static enum ParseRes ieee802_11_parse_el
 			elems->ht_extra_param = pos;
 			elems->ht_extra_param_len = elen;
 			break;
-		case WLAN_EID_TSPEC:
-			if (elen != 55) {
-				printk(KERN_ERR "Wrong TSPEC size.\n");
-				break;
-			}
-			elems->tspec = pos;
-			elems->tspec_len = elen;
-			break;
 		default:
 #if 0
 			printk(KERN_DEBUG "IEEE 802.11 element parse ignored "
@@ -774,396 +747,6 @@ static void ieee80211_send_disassoc(stru
 }
 
 
-static int ieee80211_ts_index(u8 direction)
-{
-	if (direction == WLAN_TSINFO_DOWNLINK ||
-	    direction == WLAN_TSINFO_DIRECTLINK)
-		return STA_TS_DOWNLINK;
-	return STA_TS_UPLINK; /* UP and Bidirectional LINK */
-}
-
-
-void ieee80211_send_addts(struct net_device *dev,
-			  struct ieee80211_if_sta *ifsta,
-			  struct ieee80211_elem_tspec *tspec)
-{
-	struct ieee80211_mgmt *mgmt;
-	struct sk_buff *skb;
-	static u8 token;
-	struct ieee80211_elem_tspec *ptspec;
-	u8 *pos;
-
-	skb = dev_alloc_skb(sizeof(*mgmt) + sizeof(*tspec));
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for addts "
-		       "frame\n", dev->name);
-		return;
-	}
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_ACTION);
-
-	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addts_req));
-	mgmt->u.action.category = WLAN_CATEGORY_QOS;
-	mgmt->u.action.u.addts_req.action_code = WLAN_ACTION_QOS_ADDTS_REQ;
-	mgmt->u.action.u.addts_req.dialog_token = ++token % 127;
-
-	skb_put(skb, 2 + sizeof(*tspec));
-	pos = mgmt->u.action.u.addts_req.variable;
-	pos[0] = WLAN_EID_TSPEC;
-	pos[1] = sizeof(*tspec);
-	pos += 2;
-	ptspec = (struct ieee80211_elem_tspec *)pos;
-	memcpy(ptspec, tspec, sizeof(*tspec));
-
-	ieee80211_sta_tx(dev, skb, 0);
-}
-
-
-void wmm_send_addts(struct net_device *dev,
-		    struct ieee80211_if_sta *ifsta,
-		    struct ieee80211_elem_tspec *tspec)
-{
-	struct ieee80211_mgmt *mgmt;
-	struct sk_buff *skb;
-	static u8 token;
-	struct ieee80211_elem_tspec *ptspec;
-	u8 *pos;
-
-	skb = dev_alloc_skb(sizeof(*mgmt) + 2 + 6 + sizeof(*tspec));
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for addts "
-		       "frame\n", dev->name);
-		return;
-	}
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_ACTION);
-
-	skb_put(skb, 1 + sizeof(mgmt->u.action.u.wme_action));
-	mgmt->u.action.category = WLAN_CATEGORY_WMM;
-	mgmt->u.action.u.wme_action.action_code = WLAN_ACTION_QOS_ADDTS_REQ;
-	mgmt->u.action.u.wme_action.dialog_token = ++token % 127;
-	mgmt->u.action.u.wme_action.status_code = 0;
-
-	skb_put(skb, 2 + 6 + sizeof(*tspec));
-	pos = mgmt->u.action.u.wme_action.variable;
-	pos[0] = WLAN_EID_GENERIC;
-	pos[1] = 61;
-	pos += 2;
-	pos[0] = 0x00; pos[1] = 0x50; pos[2] = 0xf2; /* Wi-Fi OUI (00:50:F2)*/
-	pos += 3;
-	pos[0] = WIFI_OUI_TYPE_WMM;
-	pos[1] = WIFI_OUI_STYPE_WMM_TSPEC;
-	pos[2] = 1; /* Version */
-	pos += 3;
-	ptspec = (struct ieee80211_elem_tspec *)pos;
-	memcpy(ptspec, tspec, sizeof(*tspec));
-
-	ieee80211_sta_tx(dev, skb, 0);
-}
-
-
-void ieee80211_send_delts(struct net_device *dev,
-			  struct ieee80211_if_sta *ifsta,
-			  struct ieee80211_elem_tspec *tp)
-{
-	struct ieee80211_mgmt *mgmt;
-	struct sk_buff *skb;
-	u8 tsid = IEEE80211_TSINFO_TSID(tp->ts_info);
-	u8 direction = IEEE80211_TSINFO_DIR(tp->ts_info);
-	u16 medium_time = le16_to_cpu(tp->medium_time);
-	u8 index = ieee80211_ts_index(direction);
-
-	if (ifsta->ts_data[tsid][index].status == TS_STATUS_UNUSED) {
-		printk(KERN_DEBUG "%s: Trying to delete an ACM disabled TS "
-		       "(%u:%u)\n", dev->name, tsid, direction);
-		return;
-	}
-	skb = dev_alloc_skb(sizeof(*mgmt));
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for delts "
-		       "frame\n", dev->name);
-		return;
-	}
-
-	/* recompute admitted time */
-	ifsta->ts_data[tsid][index].admitted_time_usec -=
-		ifsta->dot11EDCAAveragingPeriod * medium_time * 32;
-	if ((s32)(ifsta->ts_data[tsid][index].admitted_time_usec) < 0)
-		ifsta->ts_data[tsid][index].admitted_time_usec = 0;
-
-	ifsta->ts_data[tsid][index].status = TS_STATUS_INACTIVE;
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_ACTION);
-	skb_put(skb, 1 + sizeof(mgmt->u.action.u.delts));
-	mgmt->u.action.category = WLAN_CATEGORY_QOS;
-	mgmt->u.action.u.delts.action_code = WLAN_ACTION_QOS_DELTS;
-	mgmt->u.action.u.delts.reason_code = 0;
-	memset(&mgmt->u.action.u.delts.ts_info, 0,
-			sizeof(struct ieee80211_ts_info));
-
-	IEEE80211_SET_TSINFO_TSID(tp->ts_info, tsid);
-	IEEE80211_SET_TSINFO_DIR(tp->ts_info, direction);
-	IEEE80211_SET_TSINFO_POLICY(tp->ts_info, WLAN_TSINFO_EDCA);
-	IEEE80211_SET_TSINFO_APSD(tp->ts_info, WLAN_TSINFO_PSB_LEGACY);
-	IEEE80211_SET_TSINFO_UP(tp->ts_info, ifsta->ts_data[tsid][index].up);
-
-	ieee80211_sta_tx(dev, skb, 0);
-}
-
-
-void wmm_send_delts(struct net_device *dev,
-		    struct ieee80211_if_sta *ifsta,
-		    struct ieee80211_elem_tspec *tp)
-{
-	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_elem_tspec *tspec;
-	struct sk_buff *skb;
-	u8 tsid = IEEE80211_TSINFO_TSID(tp->ts_info);
-	u8 direction = IEEE80211_TSINFO_DIR(tp->ts_info);
-	u16 medium_time = le16_to_cpu(tp->medium_time);
-	u8 index = ieee80211_ts_index(direction);
-	u8 *pos;
-
-	if (ifsta->ts_data[tsid][index].status == TS_STATUS_UNUSED) {
-		printk(KERN_DEBUG "%s: Tring to delete a non-Actived TS "
-		       "(%u %u)\n", dev->name, tsid, direction);
-		return;
-	}
-	skb = dev_alloc_skb(sizeof(*mgmt) + 2 + 6 + sizeof(*tspec));
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for delts "
-		       "frame\n", dev->name);
-		return;
-	}
-
-	/* recompute admitted time */
-	ifsta->ts_data[tsid][index].admitted_time_usec -=
-		ifsta->dot11EDCAAveragingPeriod * medium_time * 32;
-	if ((s32)(ifsta->ts_data[tsid][index].admitted_time_usec < 0))
-		ifsta->ts_data[tsid][index].admitted_time_usec = 0;
-
-	ifsta->ts_data[tsid][index].status = TS_STATUS_INACTIVE;
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_ACTION);
-
-	skb_put(skb, 1 + sizeof(mgmt->u.action.u.wme_action));
-	mgmt->u.action.category = WLAN_CATEGORY_WMM;
-	mgmt->u.action.u.wme_action.action_code = WLAN_ACTION_QOS_DELTS;
-	mgmt->u.action.u.wme_action.dialog_token = 0;
-	mgmt->u.action.u.wme_action.status_code = 0;
-
-	skb_put(skb, 2 + 6 + sizeof(*tspec));
-	pos = mgmt->u.action.u.wme_action.variable;
-	pos[0] = WLAN_EID_GENERIC;
-	pos[1] = 61;
-	pos += 2;
-	pos[0] = 0x00; pos[1] = 0x50; pos[2] = 0xf2; /* Wi-Fi OUI (00:50:F2)*/
-	pos += 3;
-	pos[0] = WIFI_OUI_TYPE_WMM;
-	pos[1] = WIFI_OUI_STYPE_WMM_TSPEC;
-	pos[2] = 1; /* Version */
-	pos += 3;
-	tspec = (struct ieee80211_elem_tspec *)pos;
-	memset(tspec, 0, sizeof(*tspec));
-
-	IEEE80211_SET_TSINFO_TSID(tspec->ts_info, tsid);
-	IEEE80211_SET_TSINFO_DIR(tspec->ts_info, direction);
-	IEEE80211_SET_TSINFO_POLICY(tspec->ts_info, WLAN_TSINFO_EDCA);
-	IEEE80211_SET_TSINFO_APSD(tspec->ts_info, WLAN_TSINFO_PSB_LEGACY);
-	IEEE80211_SET_TSINFO_UP(tspec->ts_info, ifsta->ts_data[tsid][index].up);
-
-	ieee80211_sta_tx(dev, skb, 0);
-}
-
-
-void ieee80211_send_dls_req(struct net_device *dev,
-			    struct ieee80211_if_sta *ifsta,
-			    u8 *addr, u16 timeout)
-{
-	struct ieee80211_hw_mode *mode;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	u8 *pos, *supp_rates, *esupp_rates = NULL;
-	int i;
-
-	skb = dev_alloc_skb(sizeof(*mgmt) + 200 /* rates + ext_rates Size */);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for DLS REQ "
-		       "frame\n", dev->name);
-		return;
-	}
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_ACTION);
-
-	skb_put(skb, 1 + sizeof(mgmt->u.action.u.dls_req));
-	mgmt->u.action.category = WLAN_CATEGORY_DLS;
-	mgmt->u.action.u.dls_req.action_code = WLAN_ACTION_DLS_REQ;
-	memcpy(mgmt->u.action.u.dls_req.dest, addr, ETH_ALEN);
-	memcpy(mgmt->u.action.u.dls_req.src, dev->dev_addr, ETH_ALEN);
-	mgmt->u.action.u.dls_req.capab_info = cpu_to_le16(ifsta->ap_capab);
-	mgmt->u.action.u.dls_req.timeout = cpu_to_le16(timeout);
-
-	/* Add supported rates and extended supported rates */
-	supp_rates = skb_put(skb, 2);
-	supp_rates[0] = WLAN_EID_SUPP_RATES;
-	supp_rates[1] = 0;
-	mode = local->oper_hw_mode;
-	for (i = 0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *rate = &mode->rates[i];
-		if (!(rate->flags & IEEE80211_RATE_SUPPORTED))
-			continue;
-		if (esupp_rates) {
-			pos = skb_put(skb, 1);
-			esupp_rates[1]++;
-		} else if (supp_rates[1] == 8) {
-			esupp_rates = skb_put(skb, 3);
-			esupp_rates[0] = WLAN_EID_EXT_SUPP_RATES;
-			esupp_rates[1] = 1;
-			pos = &esupp_rates[2];
-		} else {
-			pos = skb_put(skb, 1);
-			supp_rates[1]++;
-		}
-		*pos = rate->rate / 5;
-	}
-
-	ieee80211_sta_tx(dev, skb, 0);
-}
-
-
-static void ieee80211_send_dls_resp(struct net_device *dev,
-				    struct ieee80211_if_sta *ifsta,
-				    u8 *mac_addr, u16 status)
-{
-	struct ieee80211_hw_mode *mode;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	u8 *pos, *supp_rates, *esupp_rates = NULL;
-	int i;
-
-	skb = dev_alloc_skb(sizeof(*mgmt) + 200 /* rates + ext_rates Size */);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for dls resp "
-		       "frame\n", dev->name);
-		return;
-	}
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_ACTION);
-
-	skb_put(skb, 1 + sizeof(mgmt->u.action.u.dls_resp));
-	mgmt->u.action.category = WLAN_CATEGORY_DLS;
-	mgmt->u.action.u.dls_resp.action_code = WLAN_ACTION_DLS_RESP;
-	memcpy(mgmt->u.action.u.dls_resp.dest, dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->u.action.u.dls_resp.src, mac_addr, ETH_ALEN);
-	mgmt->u.action.u.dls_resp.status_code = cpu_to_le16(status);
-
-	if (!mgmt->u.action.u.dls_resp.status_code) {
-		ieee80211_sta_tx(dev, skb, 0);
-		return;
-	}
-
-	/* Add capability information */
-	pos = skb_put(skb, 2);
-	*(__le16 *)pos = cpu_to_le16(ifsta->ap_capab);
-
-	/* Add supported rates and extended supported rates */
-	supp_rates = skb_put(skb, 2);
-	supp_rates[0] = WLAN_EID_SUPP_RATES;
-	supp_rates[1] = 0;
-	mode = local->oper_hw_mode;
-	for (i = 0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *rate = &mode->rates[i];
-		if (!(rate->flags & IEEE80211_RATE_SUPPORTED))
-			continue;
-		if (esupp_rates) {
-			pos = skb_put(skb, 1);
-			esupp_rates[1]++;
-		} else if (supp_rates[1] == 8) {
-			esupp_rates = skb_put(skb, 3);
-			esupp_rates[0] = WLAN_EID_EXT_SUPP_RATES;
-			esupp_rates[1] = 1;
-			pos = &esupp_rates[2];
-		} else {
-			pos = skb_put(skb, 1);
-			supp_rates[1]++;
-		}
-		*pos = rate->rate / 5;
-	}
-
-	ieee80211_sta_tx(dev, skb, 0);
-}
-
-
-void ieee80211_send_dls_teardown(struct net_device *dev,
-				 struct ieee80211_if_sta *ifsta,
-				 u8 *mac_addr, u16 reason)
-{
-	struct ieee80211_mgmt *mgmt;
-	struct sk_buff *skb;
-
-	skb = dev_alloc_skb(sizeof(*mgmt));
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for DLS "
-		       "Teardown frame\n", dev->name);
-		return;
-	}
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_ACTION);
-	skb_put(skb, 1 + sizeof(mgmt->u.action.u.dls_teardown));
-	mgmt->u.action.category = WLAN_CATEGORY_DLS;
-	mgmt->u.action.u.dls_teardown.action_code = WLAN_ACTION_DLS_TEARDOWN;
-	memcpy(mgmt->u.action.u.dls_teardown.dest, mac_addr, ETH_ALEN);
-	memcpy(mgmt->u.action.u.dls_teardown.src, dev->dev_addr, ETH_ALEN);
-	mgmt->u.action.u.dls_teardown.reason_code = cpu_to_le16(reason);
-
-	ieee80211_sta_tx(dev, skb, 0);
-}
-
-
 static int ieee80211_privacy_mismatch(struct net_device *dev,
 				      struct ieee80211_if_sta *ifsta)
 {
@@ -1766,254 +1349,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 	ieee80211_associated(dev, ifsta);
 }
 
-static u32 calculate_mpdu_exchange_time(struct ieee80211_local *local,
-					struct ieee80211_elem_tspec *tspec)
-{
-	/*
-	 * FIXME: MPDUExchangeTime = duration(Nominal MSDU Size, Min PHY Rate) +
-	 *			     SIFS + ACK duration
-	 */
-	int extra = 0; /* SIFS + ACK */
-
-	switch (local->hw.conf.phymode) {
-	case MODE_IEEE80211A:
-		extra = 16 + 24;
-		break;
-	case MODE_IEEE80211B:
-		extra = 10 + 203;
-		break;
-	case MODE_IEEE80211G:
-	default:
-		extra = 10 + 30;
-		break;
-	}
-	return (tspec->nominal_msdu_size * 8) /
-		(tspec->min_phy_rate / 1000000) + extra;
-}
-
-static void sta_update_tspec(struct ieee80211_local *local,
-			     struct ieee80211_if_sta *ifsta,
-			     int action, struct ieee80211_elem_tspec *tspec)
-{
-	u8 tsid = IEEE80211_TSINFO_TSID(tspec->ts_info);
-	u8 index = ieee80211_ts_index(IEEE80211_TSINFO_DIR(tspec->ts_info));
-
-	switch (action) {
-	case WLAN_ACTION_QOS_ADDTS_RESP:
-		ifsta->ts_data[tsid][index].status = TS_STATUS_ACTIVE;
-		ifsta->ts_data[tsid][index].up =
-			IEEE80211_TSINFO_UP(tspec->ts_info);
-		ifsta->ts_data[tsid][index].used_time_usec = 0;
-		ifsta->ts_data[tsid][index].admitted_time_usec +=
-		    ifsta->dot11EDCAAveragingPeriod * tspec->medium_time * 32;
-		ifsta->MPDUExchangeTime =
-			calculate_mpdu_exchange_time(local, tspec);
-		break;
-	case WLAN_ACTION_QOS_DELTS:
-		ifsta->ts_data[tsid][index].status = TS_STATUS_INACTIVE;
-		ifsta->ts_data[tsid][index].used_time_usec = 0;
-		ifsta->ts_data[tsid][index].admitted_time_usec -=
-		    ifsta->dot11EDCAAveragingPeriod * tspec->medium_time * 32;
-		if (ifsta->ts_data[tsid][index].admitted_time_usec < 0)
-			ifsta->ts_data[tsid][index].admitted_time_usec = 0;
-		ifsta->MPDUExchangeTime = 0;
-		break;
-	default:
-		printk(KERN_ERR "%s: invalid action type %d\n", __FUNCTION__,
-		       action);
-		break;
-	}
-}
-
-static void sta_parse_tspec(struct net_device *dev,
-			    struct ieee80211_if_sta *ifsta,
-			    struct ieee80211_mgmt *mgmt, size_t len, u8 prefix,
-			    struct ieee80211_elem_tspec *tspec)
-{
-	struct ieee802_11_elems elems;
-	u8 *pos;
-
-	/*
-	printk(KERN_DEBUG "Dialog_token: %d, TID: %u, Direction: %u, PSB: %d, "
-	       "UP: %d\n", mgmt->u.action.u.wme_action.dialog_token,
-	       IEEE80211_TSINFO_TSID(tspec->ts_info),
-	       IEEE80211_TSINFO_DIR(tspec->ts_info),
-	       IEEE80211_TSINFO_APSD(tspec->ts_info),
-	       IEEE80211_TSINFO_UP(tspec->ts_info));
-	*/
-
-	if (mgmt->u.action.category == WLAN_CATEGORY_QOS)
-		pos = mgmt->u.action.u.addts_resp.variable + prefix;
-	else
-		pos = mgmt->u.action.u.wme_action.variable + prefix;
-
-	if (ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems)
-	    == ParseFailed) {
-		printk(KERN_DEBUG "%s: failed to parse TSPEC\n", dev->name);
-		return;
-	}
-	memcpy(tspec, elems.tspec, sizeof(*tspec));
-}
-
-int dls_link_status(struct ieee80211_local *local, u8 *addr)
-{
-	struct sta_info *dls;
-	int ret = DLS_STATUS_NOLINK;
-
-	if ((dls = dls_info_get(local, addr)) != NULL) {
-		ret = dls->dls_status;
-		sta_info_put(dls);
-	}
-	return ret;
-}
-
-static void sta_process_dls_req(struct net_device *dev,
-				struct ieee80211_if_sta *ifsta,
-				struct ieee80211_mgmt *mgmt, size_t len)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct sta_info *dls;
-	u8 *src = mgmt->u.action.u.dls_req.src;
-	struct ieee802_11_elems elems;
-	struct ieee80211_rate *rates;
-	size_t baselen, num_rates;
-	int i, j;
-	struct ieee80211_hw_mode *mode;
-	u32 supp_rates = 0;
-
-	printk(KERN_DEBUG "Receive DLS request from "
-	       "%02X:%02X:%02X:%02X:%02X:%02X\n",
-	       src[0], src[1], src[2], src[3], src[4], src[5]);
-
-	baselen = (u8 *)mgmt->u.action.u.dls_req.variable - (u8 *)mgmt;
-	if (baselen > len)
-		return;
-
-	if (ieee802_11_parse_elems(mgmt->u.action.u.dls_req.variable,
-				   len - baselen, &elems) == ParseFailed) {
-		printk(KERN_ERR "DLS Parse support rates failed.\n");
-		return;
-	}
-	mode = local->sta_scanning ?
-	       local->scan_hw_mode : local->oper_hw_mode;
-	rates = mode->rates;
-	num_rates = mode->num_rates;
-
-	for (i = 0; i < elems.supp_rates_len + elems.ext_supp_rates_len; i++) {
-		u8 rate = 0;
-		if (i < elems.supp_rates_len)
-			rate = elems.supp_rates[i];
-		else if (elems.ext_supp_rates)
-			rate = elems.ext_supp_rates[i - elems.supp_rates_len];
-		rate = 5 * (rate & 0x7f);
-		for (j = 0; j < num_rates; j++)
-			if (rates[j].rate == rate)
-				supp_rates |= BIT(j);
-	}
-	if (supp_rates == 0) {
-		/* Send DLS failed Response to the peer because
-		 * the supported rates are mismatch */
-		ieee80211_send_dls_resp(dev, ifsta, src,
-					WLAN_REASON_QSTA_NOT_USE);
-		return;
-	}
-
-	dls = dls_info_get(local, src);
-	if (!dls)
-		dls = sta_info_add(local, dev, src, GFP_ATOMIC);
-	if (!dls)
-		return;
-
-	dls->dls_status = DLS_STATUS_OK;
-	dls->dls_timeout = le16_to_cpu(mgmt->u.action.u.dls_req.timeout);
-	dls->supp_rates = supp_rates;
-
-	/* Send DLS successful Response to the peer */
-	ieee80211_send_dls_resp(dev, ifsta, src, 0);
-}
-
-
-static void sta_process_dls_resp(struct net_device *dev,
-				 struct ieee80211_if_sta *ifsta,
-				 struct ieee80211_mgmt *mgmt, size_t len)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct sta_info *dls;
-	u8 *src = mgmt->u.action.u.dls_resp.src;
-	struct ieee802_11_elems elems;
-	struct ieee80211_rate *rates;
-	size_t baselen, num_rates;
-	int i, j;
-	struct ieee80211_hw_mode *mode;
-	u32 supp_rates = 0;
-
-	printk(KERN_DEBUG "Receive DLS response from "
-	       "%02X:%02X:%02X:%02X:%02X:%02X\n",
-	       src[0], src[1], src[2], src[3], src[4], src[5]);
-
-	if (mgmt->u.action.u.dls_resp.status_code) {
-		printk(KERN_ERR "DLS setup refused by peer. Reason %d\n",
-		       mgmt->u.action.u.dls_resp.status_code);
-		return;
-	}
-
-	baselen = (u8 *)mgmt->u.action.u.dls_resp.variable - (u8 *)mgmt;
-	if (baselen > len)
-		return;
-
-	if (ieee802_11_parse_elems(mgmt->u.action.u.dls_resp.variable,
-				   len - baselen, &elems) == ParseFailed) {
-		printk(KERN_ERR "DLS Parse support rates failed.\n");
-		return;
-	}
-	mode = local->sta_scanning ?
-	       local->scan_hw_mode : local->oper_hw_mode;
-	rates = mode->rates;
-	num_rates = mode->num_rates;
-
-	for (i = 0; i < elems.supp_rates_len + elems.ext_supp_rates_len; i++) {
-		u8 rate = 0;
-		if (i < elems.supp_rates_len)
-			rate = elems.supp_rates[i];
-		else if (elems.ext_supp_rates)
-			rate = elems.ext_supp_rates[i - elems.supp_rates_len];
-		rate = 5 * (rate & 0x7f);
-		for (j = 0; j < num_rates; j++)
-			if (rates[j].rate == rate)
-				supp_rates |= BIT(j);
-	}
-
-	dls = dls_info_get(local, src);
-	if (!dls)
-		dls = sta_info_add(local, dev, src, GFP_ATOMIC);
-	if (!dls)
-		return;
-
-	dls->supp_rates = supp_rates;
-	dls->dls_status = DLS_STATUS_OK;
-	sta_info_put(dls);
-}
-
-
-static void sta_process_dls_teardown(struct net_device *dev,
-				     struct ieee80211_if_sta *ifsta,
-				     struct ieee80211_mgmt *mgmt, size_t len)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	u8 *src = mgmt->u.action.u.dls_teardown.src;
-	struct sta_info *dls;
-
-	printk(KERN_DEBUG "DLS Teardown received from "
-	       "%02X:%02X:%02X:%02X:%02X:%02X. Reason %d\n",
-	       src[0], src[1], src[2], src[3], src[4], src[5],
-	       mgmt->u.action.u.dls_teardown.reason_code);
-
-	dls = dls_info_get(local, src);
-	if (dls)
-		sta_info_free(dls);
-	return;
-}
-
 
 /* Caller must hold local->sta_bss_lock */
 static void __ieee80211_rx_bss_hash_add(struct net_device *dev,
@@ -2522,7 +1857,7 @@ static void ieee80211_send_addba_resp(st
 	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
 	if (!skb) {
 		printk(KERN_DEBUG "%s: failed to allocate buffer "
-		       "for addba resp frame\n", dev->name);
+		       "for addts frame\n", dev->name);
 		return;
 	}
 
@@ -2557,82 +1892,12 @@ static void ieee80211_rx_mgmt_action(str
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
 {
-	u8 prefix = 0;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_elem_tspec tspec;
 
 	if (len < IEEE80211_MIN_ACTION_SIZE)
 		return;
 
 	switch (mgmt->u.action.category) {
-	case WLAN_CATEGORY_QOS:
-	case WLAN_CATEGORY_WMM:
-		if (len < 24 + 4) {
-			printk(KERN_DEBUG "%s: too short (%zd) QoS category "
-			       "frame received from " MAC_FMT " - ignored\n",
-			       dev->name, len, MAC_ARG(mgmt->sa));
-			return;
-		}
-		switch (mgmt->u.action.u.wme_action.action_code) {
-		case WLAN_ACTION_QOS_ADDTS_REQ:
-			printk(KERN_DEBUG "%s: WLAN_ACTION_QOS_ADDTS_REQ "
-			       "received in Non-AP STA mode!\n", dev->name);
-			return;
-		case WLAN_ACTION_QOS_ADDTS_RESP:
-			if (mgmt->u.action.u.wme_action.status_code == 47) {
-				/* TODO: handle TS Delay */
-				prefix = 6;
-			}
-			/* TODO: handle TCLAS, TCLAS Porcessing here */
-
-			if (mgmt->u.action.u.wme_action.status_code == 0) {
-				/* TODO: handle Schedule */
-				sta_parse_tspec(dev, ifsta, mgmt, len,
-						prefix, &tspec);
-				sta_update_tspec(local, ifsta,
-						 WLAN_ACTION_QOS_ADDTS_RESP,
-						 &tspec);
-				mod_timer(&ifsta->admit_timer, jiffies +
-					  ifsta->dot11EDCAAveragingPeriod * HZ);
-			}
-			break;
-		case WLAN_ACTION_QOS_DELTS:
-			sta_parse_tspec(dev, ifsta, mgmt, len, prefix, &tspec);
-			sta_update_tspec(local, ifsta,
-					 WLAN_ACTION_QOS_DELTS, &tspec);
-			break;
-		default:
-			printk(KERN_ERR "%s: unsupported QoS action code %d\n",
-			       dev->name,
-			       mgmt->u.action.u.wme_action.action_code);
-			break;
-		}
-		break;
-
-	case WLAN_CATEGORY_DLS:
-		if (len < 24 + 16) {
-			printk(KERN_DEBUG "%s: too short (%zd) DLS category "
-			       "frame received from " MAC_FMT " - ignored\n",
-			       dev->name, len, MAC_ARG(mgmt->sa));
-			return;
-		}
-		switch (mgmt->u.action.u.dls_req.action_code) {
-		case WLAN_ACTION_DLS_REQ:
-			sta_process_dls_req(dev, ifsta, mgmt, len);
-			break;
-		case WLAN_ACTION_DLS_RESP:
-			sta_process_dls_resp(dev, ifsta, mgmt, len);
-			break;
-		case WLAN_ACTION_DLS_TEARDOWN:
-			sta_process_dls_teardown(dev, ifsta, mgmt, len);
-			break;
-		default:
-			printk(KERN_ERR "%s: unsupported DLS action code %d\n",
-			       dev->name, mgmt->u.action.u.dls_req.action_code);
-			break;
-		}
-		break;
-
 #ifdef CONFIG_MAC80211_HT
 	case WLAN_CATEGORY_BACK:
 		switch (mgmt->u.action.u.addba_req.action_code) {
@@ -2947,43 +2212,6 @@ void ieee80211_sta_work(struct work_stru
 }
 
 
-void ieee80211_admit_refresh(unsigned long ptr)
-{
-	struct net_device *dev;
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_if_sta *ifsta;
-	int i, j, find = 0;
-
-	dev = (struct net_device *) ptr;
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	ifsta = &sdata->u.sta;
-
-	for (i = 0; i < STA_TSID_NUM; i++) {
-		for (j = 0; j < STA_TSDIR_NUM; j++) {
-			if ((ifsta->ts_data[i][j].status != TS_STATUS_ACTIVE) &&
-			    (ifsta->ts_data[i][j].status != TS_STATUS_THROTTLING))
-				continue;
-			find = 1;
-
-			ifsta->ts_data[i][j].used_time_usec -=
-				ifsta->ts_data[i][j].admitted_time_usec;
-			if ((s32)(ifsta->ts_data[i][j].used_time_usec) < 0)
-				ifsta->ts_data[i][j].used_time_usec = 0;
-
-			ifsta->ts_data[i][j].status =
-				(ifsta->ts_data[i][j].used_time_usec >=
-			         ifsta->ts_data[i][j].admitted_time_usec) ?
-				TS_STATUS_THROTTLING :
-				TS_STATUS_ACTIVE;
-		}
-	}
-
-	if (find)
-		mod_timer(&ifsta->admit_timer, jiffies +
-			  ifsta->dot11EDCAAveragingPeriod * HZ);
-}
-
-
 static void ieee80211_sta_reset_auth(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta)
 {
--- wireless-dev.orig/net/mac80211/sta_info.c	2007-09-20 17:31:06.091571235 +0200
+++ wireless-dev/net/mac80211/sta_info.c	2007-09-20 17:35:39.801572266 +0200
@@ -32,7 +32,7 @@ static void sta_info_hash_add(struct iee
 
 /* Caller must hold local->sta_lock */
 static int sta_info_hash_del(struct ieee80211_local *local,
-			     struct sta_info *sta, int dls)
+			     struct sta_info *sta)
 {
 	struct sta_info *s;
 
@@ -40,8 +40,6 @@ static int sta_info_hash_del(struct ieee
 	if (!s)
 		return -ENOENT;
 	if (s == sta) {
-		if (dls && !(s->flags & WLAN_STA_DLS))
-			return -ENOENT;
 		local->sta_hash[STA_HASH(sta->addr)] = s->hnext;
 		return 0;
 	}
@@ -49,8 +47,6 @@ static int sta_info_hash_del(struct ieee
 	while (s->hnext && s->hnext != sta)
 		s = s->hnext;
 	if (s->hnext) {
-		if (dls && !(s->hnext->flags & WLAN_STA_DLS))
-			return -ENOENT;
 		s->hnext = sta->hnext;
 		return 0;
 	}
@@ -77,28 +73,6 @@ struct sta_info *sta_info_get(struct iee
 }
 EXPORT_SYMBOL(sta_info_get);
 
-struct sta_info *dls_info_get(struct ieee80211_local *local, u8 *addr)
-{
-	struct sta_info *sta;
-
-	read_lock_bh(&local->sta_lock);
-	sta = local->sta_hash[STA_HASH(addr)];
-	while (sta) {
-		if (memcmp(sta->addr, addr, ETH_ALEN) == 0) {
-			if (!(sta->flags & WLAN_STA_DLS)) {
-				sta = NULL;
-				break;
-			}
-			__sta_info_get(sta);
-			break;
-		}
-		sta = sta->hnext;
-	}
-	read_unlock_bh(&local->sta_lock);
-
-	return sta;
-}
-
 int sta_info_min_txrate_get(struct ieee80211_local *local)
 {
 	struct sta_info *sta;
@@ -211,7 +185,7 @@ void sta_info_remove(struct sta_info *st
 	struct ieee80211_sub_if_data *sdata;
 
 	/* don't do anything if we've been removed already */
-	if (sta_info_hash_del(local, sta, 0))
+	if (sta_info_hash_del(local, sta))
 		return;
 
 	list_del(&sta->list);
--- wireless-dev.orig/net/mac80211/sta_info.h	2007-09-20 17:35:09.011572103 +0200
+++ wireless-dev/net/mac80211/sta_info.h	2007-09-20 17:35:51.721572645 +0200
@@ -29,7 +29,6 @@
  * @WLAN_STA_ASSOC_AP: STA is an AP we are associated with as a client
  * @WLAN_STA_WME: STA is QoS capable
  * @WLAN_STA_HT: STA is HT capable
- * @WLAN_STA_DLS: STA is a DLS peer
  * @WLAN_STA_WDS: STA is a WDS peer
  */
 enum sta_flags {
@@ -42,8 +41,7 @@ enum sta_flags {
 	WLAN_STA_ASSOC_AP	= 1<<6,
 	WLAN_STA_WME		= 1<<7,
 	WLAN_STA_HT		= 1<<8,
-	WLAN_STA_DLS		= 1<<9,
-	WLAN_STA_WDS		= 1<<10,
+	WLAN_STA_WDS		= 1<<9,
 };
 
 
@@ -107,11 +105,6 @@ struct sta_info {
 	int channel_use;
 	int channel_use_raw;
 
-#define DLS_STATUS_OK		0
-#define DLS_STATUS_NOLINK	1
-	int dls_status;
-	u32 dls_timeout;
-
 #ifdef CONFIG_HOSTAPD_WPA_TESTING
 	u32 wpa_trigger;
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
--- wireless-dev.orig/net/mac80211/tx.c	2007-09-20 17:31:06.141570856 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-09-20 17:35:39.941563314 +0200
@@ -1374,18 +1374,11 @@ int ieee80211_subif_start_xmit(struct sk
 		hdrlen = 30;
 		break;
 	case IEEE80211_IF_TYPE_STA:
-		if (dls_link_status(local, skb->data) == DLS_STATUS_OK) {
-			/* DA SA BSSID */
-			memcpy(hdr.addr1, skb->data, ETH_ALEN);
-			memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
-			memcpy(hdr.addr3, sdata->u.sta.bssid, ETH_ALEN);
-		} else {
-			fc |= IEEE80211_FCTL_TODS;
-			/* BSSID SA DA */
-			memcpy(hdr.addr1, sdata->u.sta.bssid, ETH_ALEN);
-			memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
-			memcpy(hdr.addr3, skb->data, ETH_ALEN);
-		}
+		fc |= IEEE80211_FCTL_TODS;
+		/* BSSID SA DA */
+		memcpy(hdr.addr1, sdata->u.sta.bssid, ETH_ALEN);
+		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
+		memcpy(hdr.addr3, skb->data, ETH_ALEN);
 		hdrlen = 24;
 		break;
 	case IEEE80211_IF_TYPE_IBSS:
--- wireless-dev.orig/net/mac80211/wme.c	2007-09-20 17:31:06.171570368 +0200
+++ wireless-dev/net/mac80211/wme.c	2007-09-20 17:35:39.941563314 +0200
@@ -94,13 +94,11 @@ static inline int wme_downgrade_ac(struc
 static inline int classify80211(struct sk_buff *skb, struct Qdisc *qd)
 {
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(qd->dev);
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct ieee80211_tx_packet_data *pkt_data =
 		(struct ieee80211_tx_packet_data *) skb->cb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	unsigned short fc = le16_to_cpu(hdr->frame_control);
-	int qos, tsid, dir;
+	int qos;
 	const int ieee802_1d_to_ac[8] = { 2, 3, 3, 2, 1, 1, 0, 0 };
 
 	/* see if frame is data or non data frame */
@@ -127,36 +125,11 @@ static inline int classify80211(struct s
 	}
 
 	/* use the data classifier to determine what 802.1d tag the
-	 * data frame has */
+	* data frame has */
 	skb->priority = classify_1d(skb, qd);
-	tsid = 8 + skb->priority;
-
-	/* FIXME: only uplink needs to be checked for Tx */
-	dir = STA_TS_UPLINK;
-
-	if ((sdata->type == IEEE80211_IF_TYPE_STA) &&
-	    (local->wmm_acm & BIT(skb->priority))) {
-		switch (ifsta->ts_data[tsid][dir].status) {
-		case TS_STATUS_ACTIVE:
-			/* if TS Management is enabled, update used_time */
-			ifsta->ts_data[tsid][dir].used_time_usec +=
-				ifsta->MPDUExchangeTime;
-			break;
-		case TS_STATUS_THROTTLING:
-			/* if admitted time is used up, refuse to send more */
-			if (net_ratelimit())
-				printk(KERN_DEBUG "QoS packet throttling\n");
-			break;
-		default:
-			break;
-		}
-	}
 
 	/* in case we are a client verify acm is not set for this ac */
-	while ((local->wmm_acm & BIT(skb->priority)) &&
-	       !((sdata->type == IEEE80211_IF_TYPE_STA) &&
-		 (ifsta->ts_data[skb->priority + EDCA_TSID_MIN][dir].status
-			== TS_STATUS_ACTIVE))) {
+	while (unlikely(local->wmm_acm & BIT(skb->priority))) {
 		if (wme_downgrade_ac(skb)) {
 			/* No AC with lower priority has acm=0, drop packet. */
 			return -1;


