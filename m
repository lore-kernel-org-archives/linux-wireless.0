Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32873 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab0ALIne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 03:43:34 -0500
Subject: [PATCH PATCH v6 2/7] mac80211: add debugfs interface for U-APSD queue
	configuration
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	a.young.jason@gmail.com
Date: Tue, 12 Jan 2010 10:42:39 +0200
Message-ID: <20100112084238.27492.8701.stgit@tikku>
In-Reply-To: <20100112084059.27492.86738.stgit@tikku>
References: <20100112084059.27492.86738.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Because it's not yet decided how to configure which queues are U-APSD
enabled, add a debugfs interface for testing purposes.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/debugfs.c     |   94 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |   14 +++++++
 net/mac80211/main.c        |    2 +
 net/mac80211/mlme.c        |    2 -
 net/mac80211/work.c        |    4 +-
 5 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index e4b5409..b3bc32b 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -158,6 +158,98 @@ static const struct file_operations noack_ops = {
 	.open = mac80211_open_file_generic
 };
 
+static ssize_t uapsd_queues_read(struct file *file, char __user *user_buf,
+				 size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	int res;
+	char buf[10];
+
+	res = scnprintf(buf, sizeof(buf), "0x%x\n", local->uapsd_queues);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
+}
+
+static ssize_t uapsd_queues_write(struct file *file,
+				  const char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	unsigned long val;
+	char buf[10];
+	size_t len;
+	int ret;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = '\0';
+
+	ret = strict_strtoul(buf, 0, &val);
+
+	if (ret)
+		return -EINVAL;
+
+	if (val & ~IEEE80211_WMM_IE_STA_QOSINFO_AC_MASK)
+		return -ERANGE;
+
+	local->uapsd_queues = val;
+
+	return count;
+}
+
+static const struct file_operations uapsd_queues_ops = {
+	.read = uapsd_queues_read,
+	.write = uapsd_queues_write,
+	.open = mac80211_open_file_generic
+};
+
+static ssize_t uapsd_max_sp_len_read(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	int res;
+	char buf[10];
+
+	res = scnprintf(buf, sizeof(buf), "0x%x\n", local->uapsd_max_sp_len);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
+}
+
+static ssize_t uapsd_max_sp_len_write(struct file *file,
+				      const char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	unsigned long val;
+	char buf[10];
+	size_t len;
+	int ret;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+	buf[len] = '\0';
+
+	ret = strict_strtoul(buf, 0, &val);
+
+	if (ret)
+		return -EINVAL;
+
+	if (val & ~IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK)
+		return -ERANGE;
+
+	local->uapsd_max_sp_len = val;
+
+	return count;
+}
+
+static const struct file_operations uapsd_max_sp_len_ops = {
+	.read = uapsd_max_sp_len_read,
+	.write = uapsd_max_sp_len_write,
+	.open = mac80211_open_file_generic
+};
+
 static ssize_t queues_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -314,6 +406,8 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(queues);
 	DEBUGFS_ADD_MODE(reset, 0200);
 	DEBUGFS_ADD(noack);
+	DEBUGFS_ADD(uapsd_queues);
+	DEBUGFS_ADD(uapsd_max_sp_len);
 
 	statsd = debugfs_create_dir("statistics", phyd);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 165de3d..52f6a05 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -808,6 +808,20 @@ struct ieee80211_local {
 	int wifi_wme_noack_test;
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
+	/*
+	 * Bitmask of enabled u-apsd queues,
+	 * IEEE80211_WMM_IE_STA_QOSINFO_AC_BE & co. Needs a new association
+	 * to take effect.
+	 */
+	unsigned int uapsd_queues;
+
+	/*
+	 * Maximum number of buffered frames AP can deliver during a
+	 * service period, IEEE80211_WMM_IE_STA_QOSINFO_SP_ALL or similar.
+	 * Needs a new association to take effect.
+	 */
+	unsigned int uapsd_max_sp_len;
+
 	bool pspolling;
 	bool offchannel_ps_enabled;
 	/*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0054bba..ec8f767 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -384,6 +384,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
 	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	local->user_power_level = -1;
+	local->uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
+	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
 
 	INIT_LIST_HEAD(&local->interfaces);
 	mutex_init(&local->iflist_mtx);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e52ee47..064f39b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -579,7 +579,7 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		return;
 
 	if (ifmgd->flags & IEEE80211_STA_UAPSD_ENABLED)
-		uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
+		uapsd_queues = local->uapsd_queues;
 
 	count = wmm_param[6] & 0x0f;
 	if (count == ifmgd->wmm_last_param_set)
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index ee6182d..efa6cde 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -376,8 +376,8 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 
 	if (wk->assoc.wmm_used && local->hw.queues >= 4) {
 		if (wk->assoc.uapsd_used) {
-			qos_info = IEEE80211_DEFAULT_UAPSD_QUEUES;
-			qos_info |= (IEEE80211_DEFAULT_MAX_SP_LEN <<
+			qos_info = local->uapsd_queues;
+			qos_info |= (local->uapsd_max_sp_len <<
 				     IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT);
 		} else {
 			qos_info = 0;

