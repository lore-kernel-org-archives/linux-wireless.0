Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:61747 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbZK0OIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 09:08:13 -0500
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nARE8FC1025836
	for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2009 08:08:19 -0600
Received: from [127.0.1.1] (essapo-nirac2521.europe.nokia.com [10.162.252.1])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nARE8HZM005123
	for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2009 16:08:17 +0200
Subject: [RFC PATCH v1 3/4] mac80211: add debugfs interface for U-APSD queue
	configuration
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 27 Nov 2009 16:08:16 +0200
Message-ID: <20091127140816.2847.89809.stgit@tikku>
In-Reply-To: <20091127140700.2847.42426.stgit@tikku>
References: <20091127140700.2847.42426.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Because it's not yet decided how to configure which queues are U-APSD
enabled, add a debugfs interface for testing purposes.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/debugfs.c     |   41 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/main.c        |    1 +
 net/mac80211/mlme.c        |    8 ++------
 4 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index e4b5409..780face 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -158,6 +158,47 @@ static const struct file_operations noack_ops = {
 	.open = mac80211_open_file_generic
 };
 
+static ssize_t uapsd_queues_read(struct file *file, char __user *user_buf,
+				 size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	int res;
+	char buf[10];
+
+	res = scnprintf(buf, sizeof(buf), "%d\n", local->uapsd_queues);
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
+	ret = strict_strtoul(buf, 10, &val);
+
+	if (ret == 0)
+		local->uapsd_queues = val;
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
 static ssize_t queues_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 94eaf21..f3cc7ce 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -58,6 +58,8 @@ struct ieee80211_local;
 
 #define TU_TO_EXP_TIME(x)	(jiffies + usecs_to_jiffies((x) * 1024))
 
+#define IEEE80211_DEFAULT_UAPSD_QUEUES IEEE80211_QOS_IE_AC_VO
+
 struct ieee80211_fragment_entry {
 	unsigned long first_frag_time;
 	unsigned int seq;
@@ -746,6 +748,7 @@ struct ieee80211_local {
 				*/
 	int wifi_wme_noack_test;
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
+	unsigned int uapsd_queues;
 
 	bool pspolling;
 	/*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index dd8ec8d..41b7cae 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -358,6 +358,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
 	local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	local->user_power_level = -1;
+	local->uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
 
 	INIT_LIST_HEAD(&local->interfaces);
 	mutex_init(&local->iflist_mtx);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4bf062b..667d1d6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -82,8 +82,6 @@ enum rx_mgmt_action {
 	RX_MGMT_CFG80211_ASSOC_TO,
 };
 
-#define IEEE80211_DEFAULT_UAPSD_QUEUES IEEE80211_QOS_IE_AC_VO
-
 /* utils */
 static inline void ASSERT_MGD_MTX(struct ieee80211_if_managed *ifmgd)
 {
@@ -373,8 +371,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 
 	if (wmm && (ifmgd->flags & IEEE80211_STA_WMM_ENABLED)) {
 		if (uapsd && (local->hw.flags & IEEE80211_HW_UAPSD)) {
-			/* FIXME: configure queues from debugfs */
-			qos_info = IEEE80211_DEFAULT_UAPSD_QUEUES;
+			qos_info = local->uapsd_queues;
 			ifmgd->flags |= IEEE80211_STA_UAPSD_ENABLED;
 		} else {
 			qos_info = 0;
@@ -811,8 +808,7 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		return;
 
 	if (ifmgd->flags & IEEE80211_STA_UAPSD_ENABLED)
-		/* FIXME: use debugfs */
-		uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
+		uapsd_queues = local->uapsd_queues;
 
 	count = wmm_param[6] & 0x0f;
 	if (count == ifmgd->wmm_last_param_set)

