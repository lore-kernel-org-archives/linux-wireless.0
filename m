Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.246]:32775 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754544AbYBDVYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 16:24:50 -0500
Received: by hs-out-2122.google.com with SMTP id 54so2007359hsz.5
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 13:24:50 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 4 Feb 2008 12:01:56 -0800
Subject: [PATCH 13/13] o11s: mesh statistics and config through debugfs
Message-ID: <47a7829f.1f538c0a.4bf4.ffff85ec@mx.google.com> (sfid-20080204_213832_892351_4108FB54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch contains the debugfs code for mesh statistics and configuration
parameters. Please note that generic support for r/w debugfs attributes has been
added.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/debugfs_netdev.c |  182 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 182 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 29f7b98..0f32d7f 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -39,6 +39,27 @@ static ssize_t ieee80211_if_read(
 	return ret;
 }
 
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
+
 #define IEEE80211_IF_FMT(name, field, format_string)			\
 static ssize_t ieee80211_if_fmt_##name(					\
 	const struct ieee80211_sub_if_data *sdata, char *buf,		\
@@ -46,6 +67,19 @@ static ssize_t ieee80211_if_fmt_##name(					\
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
@@ -88,6 +122,34 @@ static const struct file_operations name##_ops = {			\
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
@@ -139,6 +201,40 @@ __IEEE80211_IF_FILE(num_buffered_multicast);
 /* WDS attributes */
 IEEE80211_IF_FILE(peer, u.wds.remote_addr, MAC);
 
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
+
+
 #define DEBUGFS_ADD(name, type)\
 	sdata->debugfs.type.name = debugfs_create_file(#name, 0444,\
 		sdata->debugfsdir, sdata, &name##_ops);
@@ -192,12 +288,53 @@ static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
 {
 }
 
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
+
 static void add_files(struct ieee80211_sub_if_data *sdata)
 {
 	if (!sdata->debugfsdir)
 		return;
 
 	switch (sdata->vif.type) {
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		add_mesh_stats(sdata);
+		add_mesh_config(sdata);
+		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		add_sta_files(sdata);
@@ -274,12 +411,57 @@ static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
 {
 }
 
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
+
 static void del_files(struct ieee80211_sub_if_data *sdata, int type)
 {
 	if (!sdata->debugfsdir)
 		return;
 
 	switch (type) {
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		del_mesh_stats(sdata);
+		del_mesh_config(sdata);
+		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		del_sta_files(sdata);
-- 
1.5.2.5



