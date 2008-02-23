Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbYBWOWC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2008 09:22:02 -0500
Message-Id: <20080223142015.478371000@sipsolutions.net> (sfid-20080223_142342_150329_91F19136)
References: <20080223141703.194775000@sipsolutions.net>
Date: Sat, 23 Feb 2008 15:17:16 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 13/18] mac80211: mesh statistics and config through debugfs
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis Carlos Cobo <luisca@cozybit.com>

This patch contains the debugfs code for mesh statistics and configuration
parameters. Please note that generic support for r/w debugfs attributes has been
added.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_netdev.c |  197 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 197 insertions(+)

--- everything.orig/net/mac80211/debugfs_netdev.c	2008-02-23 13:55:35.000000000 +0100
+++ everything/net/mac80211/debugfs_netdev.c	2008-02-23 14:39:11.000000000 +0100
@@ -39,6 +39,29 @@ static ssize_t ieee80211_if_read(
 	return ret;
 }
 
+#ifdef CONFIG_MAC80211_MESH
+static ssize_t ieee80211_if_write(
+	struct ieee80211_sub_if_data *sdata,
+	char const __user *userbuf,
+	size_t count, loff_t *ppos,
+	int (*format)(struct ieee80211_sub_if_data *, char *))
+{
+	char buf[10];
+	int buf_size;
+
+	memset(buf, 0x00, sizeof(buf));
+	buf_size = min(count, (sizeof(buf)-1));
+	read_lock(&dev_base_lock);
+	if (copy_from_user(buf, userbuf, buf_size))
+		goto endwrite;
+	if (sdata->dev->reg_state == NETREG_REGISTERED)
+		(*format)(sdata, buf);
+endwrite:
+	read_unlock(&dev_base_lock);
+	return count;
+}
+#endif
+
 #define IEEE80211_IF_FMT(name, field, format_string)			\
 static ssize_t ieee80211_if_fmt_##name(					\
 	const struct ieee80211_sub_if_data *sdata, char *buf,		\
@@ -46,6 +69,19 @@ static ssize_t ieee80211_if_fmt_##name(	
 {									\
 	return scnprintf(buf, buflen, format_string, sdata->field);	\
 }
+#define IEEE80211_IF_WFMT(name, field, type)				\
+static int ieee80211_if_wfmt_##name(					\
+	struct ieee80211_sub_if_data *sdata, char *buf)			\
+{									\
+	unsigned long tmp;						\
+	char *endp;							\
+									\
+	tmp = simple_strtoul(buf, &endp, 0);				\
+	if ((endp == buf) || ((type)tmp != tmp))			\
+		return -EINVAL;						\
+	sdata->field = tmp;						\
+	return 0;							\
+}
 #define IEEE80211_IF_FMT_DEC(name, field)				\
 		IEEE80211_IF_FMT(name, field, "%d\n")
 #define IEEE80211_IF_FMT_HEX(name, field)				\
@@ -88,6 +124,34 @@ static const struct file_operations name
 		IEEE80211_IF_FMT_##format(name, field)			\
 		__IEEE80211_IF_FILE(name)
 
+#define __IEEE80211_IF_WFILE(name)					\
+static ssize_t ieee80211_if_read_##name(struct file *file,		\
+					char __user *userbuf,		\
+					size_t count, loff_t *ppos)	\
+{									\
+	return ieee80211_if_read(file->private_data,			\
+				 userbuf, count, ppos,			\
+				 ieee80211_if_fmt_##name);		\
+}									\
+static ssize_t ieee80211_if_write_##name(struct file *file,		\
+					const char __user *userbuf,	\
+					size_t count, loff_t *ppos)	\
+{									\
+	return ieee80211_if_write(file->private_data,			\
+				 userbuf, count, ppos,			\
+				 ieee80211_if_wfmt_##name);		\
+}									\
+static const struct file_operations name##_ops = {			\
+	.read = ieee80211_if_read_##name,				\
+	.write = ieee80211_if_write_##name,				\
+	.open = mac80211_open_file_generic,				\
+}
+
+#define IEEE80211_IF_WFILE(name, field, format, type)			\
+		IEEE80211_IF_FMT_##format(name, field)			\
+		IEEE80211_IF_WFMT(name, field, type)			\
+		__IEEE80211_IF_WFILE(name)
+
 /* common attributes */
 IEEE80211_IF_FILE(channel_use, channel_use, DEC);
 IEEE80211_IF_FILE(drop_unencrypted, drop_unencrypted, DEC);
@@ -106,6 +170,7 @@ IEEE80211_IF_FILE(assoc_tries, u.sta.ass
 IEEE80211_IF_FILE(auth_algs, u.sta.auth_algs, HEX);
 IEEE80211_IF_FILE(auth_alg, u.sta.auth_alg, DEC);
 IEEE80211_IF_FILE(auth_transaction, u.sta.auth_transaction, DEC);
+IEEE80211_IF_FILE(num_beacons_sta, u.sta.num_beacons, DEC);
 
 static ssize_t ieee80211_if_fmt_flags(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
@@ -139,6 +204,42 @@ __IEEE80211_IF_FILE(num_buffered_multica
 /* WDS attributes */
 IEEE80211_IF_FILE(peer, u.wds.remote_addr, MAC);
 
+#ifdef CONFIG_MAC80211_MESH
+/* Mesh stats attributes */
+IEEE80211_IF_FILE(fwded_frames, u.sta.mshstats.fwded_frames, DEC);
+IEEE80211_IF_FILE(dropped_frames_ttl, u.sta.mshstats.dropped_frames_ttl, DEC);
+IEEE80211_IF_FILE(dropped_frames_no_route,
+		u.sta.mshstats.dropped_frames_no_route, DEC);
+IEEE80211_IF_FILE(estab_plinks, u.sta.mshstats.estab_plinks, ATOMIC);
+
+/* Mesh parameters */
+IEEE80211_IF_WFILE(dot11MeshMaxRetries,
+		u.sta.mshcfg.dot11MeshMaxRetries, DEC, u8);
+IEEE80211_IF_WFILE(dot11MeshRetryTimeout,
+		u.sta.mshcfg.dot11MeshRetryTimeout, DEC, u16);
+IEEE80211_IF_WFILE(dot11MeshConfirmTimeout,
+		u.sta.mshcfg.dot11MeshConfirmTimeout, DEC, u16);
+IEEE80211_IF_WFILE(dot11MeshHoldingTimeout,
+		u.sta.mshcfg.dot11MeshHoldingTimeout, DEC, u16);
+IEEE80211_IF_WFILE(dot11MeshTTL, u.sta.mshcfg.dot11MeshTTL, DEC, u8);
+IEEE80211_IF_WFILE(auto_open_plinks, u.sta.mshcfg.auto_open_plinks, DEC, bool);
+IEEE80211_IF_WFILE(dot11MeshMaxPeerLinks,
+		u.sta.mshcfg.dot11MeshMaxPeerLinks, DEC, u16);
+IEEE80211_IF_WFILE(dot11MeshHWMPactivePathTimeout,
+		u.sta.mshcfg.dot11MeshHWMPactivePathTimeout, DEC, u32);
+IEEE80211_IF_WFILE(dot11MeshHWMPpreqMinInterval,
+		u.sta.mshcfg.dot11MeshHWMPpreqMinInterval, DEC, u16);
+IEEE80211_IF_WFILE(dot11MeshHWMPnetDiameterTraversalTime,
+		u.sta.mshcfg.dot11MeshHWMPnetDiameterTraversalTime, DEC, u16);
+IEEE80211_IF_WFILE(dot11MeshHWMPmaxPREQretries,
+		u.sta.mshcfg.dot11MeshHWMPmaxPREQretries, DEC, u8);
+IEEE80211_IF_WFILE(path_refresh_time,
+		u.sta.mshcfg.path_refresh_time, DEC, u32);
+IEEE80211_IF_WFILE(min_discovery_timeout,
+		u.sta.mshcfg.min_discovery_timeout, DEC, u16);
+#endif
+
+
 #define DEBUGFS_ADD(name, type)\
 	sdata->debugfs.type.name = debugfs_create_file(#name, 0444,\
 		sdata->debugfsdir, sdata, &name##_ops);
@@ -161,6 +262,7 @@ static void add_sta_files(struct ieee802
 	DEBUGFS_ADD(auth_alg, sta);
 	DEBUGFS_ADD(auth_transaction, sta);
 	DEBUGFS_ADD(flags, sta);
+	DEBUGFS_ADD(num_beacons_sta, sta);
 }
 
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
@@ -192,12 +294,57 @@ static void add_monitor_files(struct iee
 {
 }
 
+#ifdef CONFIG_MAC80211_MESH
+#define MESHSTATS_ADD(name)\
+	sdata->mesh_stats.name = debugfs_create_file(#name, 0444,\
+		sdata->mesh_stats_dir, sdata, &name##_ops);
+
+static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
+{
+	sdata->mesh_stats_dir = debugfs_create_dir("mesh_stats",
+				sdata->debugfsdir);
+	MESHSTATS_ADD(fwded_frames);
+	MESHSTATS_ADD(dropped_frames_ttl);
+	MESHSTATS_ADD(dropped_frames_no_route);
+	MESHSTATS_ADD(estab_plinks);
+}
+
+#define MESHPARAMS_ADD(name)\
+	sdata->mesh_config.name = debugfs_create_file(#name, 0644,\
+		sdata->mesh_config_dir, sdata, &name##_ops);
+
+static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
+{
+	sdata->mesh_config_dir = debugfs_create_dir("mesh_config",
+				sdata->debugfsdir);
+	MESHPARAMS_ADD(dot11MeshMaxRetries);
+	MESHPARAMS_ADD(dot11MeshRetryTimeout);
+	MESHPARAMS_ADD(dot11MeshConfirmTimeout);
+	MESHPARAMS_ADD(dot11MeshHoldingTimeout);
+	MESHPARAMS_ADD(dot11MeshTTL);
+	MESHPARAMS_ADD(auto_open_plinks);
+	MESHPARAMS_ADD(dot11MeshMaxPeerLinks);
+	MESHPARAMS_ADD(dot11MeshHWMPactivePathTimeout);
+	MESHPARAMS_ADD(dot11MeshHWMPpreqMinInterval);
+	MESHPARAMS_ADD(dot11MeshHWMPnetDiameterTraversalTime);
+	MESHPARAMS_ADD(dot11MeshHWMPmaxPREQretries);
+	MESHPARAMS_ADD(path_refresh_time);
+	MESHPARAMS_ADD(min_discovery_timeout);
+}
+#endif
+
 static void add_files(struct ieee80211_sub_if_data *sdata)
 {
 	if (!sdata->debugfsdir)
 		return;
 
 	switch (sdata->vif.type) {
+	case IEEE80211_IF_TYPE_MESH_POINT:
+#ifdef CONFIG_MAC80211_MESH
+		add_mesh_stats(sdata);
+		add_mesh_config(sdata);
+#endif
+		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		add_sta_files(sdata);
@@ -243,6 +390,7 @@ static void del_sta_files(struct ieee802
 	DEBUGFS_DEL(auth_alg, sta);
 	DEBUGFS_DEL(auth_transaction, sta);
 	DEBUGFS_DEL(flags, sta);
+	DEBUGFS_DEL(num_beacons_sta, sta);
 }
 
 static void del_ap_files(struct ieee80211_sub_if_data *sdata)
@@ -274,12 +422,61 @@ static void del_monitor_files(struct iee
 {
 }
 
+#ifdef CONFIG_MAC80211_MESH
+#define MESHSTATS_DEL(name)			\
+	do {						\
+		debugfs_remove(sdata->mesh_stats.name);	\
+		sdata->mesh_stats.name = NULL;		\
+	} while (0)
+
+static void del_mesh_stats(struct ieee80211_sub_if_data *sdata)
+{
+	MESHSTATS_DEL(fwded_frames);
+	MESHSTATS_DEL(dropped_frames_ttl);
+	MESHSTATS_DEL(dropped_frames_no_route);
+	MESHSTATS_DEL(estab_plinks);
+	debugfs_remove(sdata->mesh_stats_dir);
+	sdata->mesh_stats_dir = NULL;
+}
+
+#define MESHPARAMS_DEL(name)			\
+	do {						\
+		debugfs_remove(sdata->mesh_config.name);	\
+		sdata->mesh_config.name = NULL;		\
+	} while (0)
+
+static void del_mesh_config(struct ieee80211_sub_if_data *sdata)
+{
+	MESHPARAMS_DEL(dot11MeshMaxRetries);
+	MESHPARAMS_DEL(dot11MeshRetryTimeout);
+	MESHPARAMS_DEL(dot11MeshConfirmTimeout);
+	MESHPARAMS_DEL(dot11MeshHoldingTimeout);
+	MESHPARAMS_DEL(dot11MeshTTL);
+	MESHPARAMS_DEL(auto_open_plinks);
+	MESHPARAMS_DEL(dot11MeshMaxPeerLinks);
+	MESHPARAMS_DEL(dot11MeshHWMPactivePathTimeout);
+	MESHPARAMS_DEL(dot11MeshHWMPpreqMinInterval);
+	MESHPARAMS_DEL(dot11MeshHWMPnetDiameterTraversalTime);
+	MESHPARAMS_DEL(dot11MeshHWMPmaxPREQretries);
+	MESHPARAMS_DEL(path_refresh_time);
+	MESHPARAMS_DEL(min_discovery_timeout);
+	debugfs_remove(sdata->mesh_config_dir);
+	sdata->mesh_config_dir = NULL;
+}
+#endif
+
 static void del_files(struct ieee80211_sub_if_data *sdata, int type)
 {
 	if (!sdata->debugfsdir)
 		return;
 
 	switch (type) {
+	case IEEE80211_IF_TYPE_MESH_POINT:
+#ifdef CONFIG_MAC80211_MESH
+		del_mesh_stats(sdata);
+		del_mesh_config(sdata);
+#endif
+		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		del_sta_files(sdata);

-- 

