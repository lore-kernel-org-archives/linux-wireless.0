Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59404 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab1CWVEh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 17:04:37 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] wifi:  Add hwflags to debugfs.
Date: Wed, 23 Mar 2011 14:04:31 -0700
Message-Id: <1300914271-15305-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Aids debugging wifi behaviour.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Use macro to generate ops structure, use newlines
for flag separators.

:100644 100644 51f0d78... 0a602db... M	net/mac80211/debugfs.c
 net/mac80211/debugfs.c |   89 +++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 76 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 51f0d78..0a602db 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -37,7 +37,7 @@ int mac80211_format_buffer(char __user *userbuf, size_t count,
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 
-#define DEBUGFS_READONLY_FILE(name, fmt, value...)			\
+#define DEBUGFS_READONLY_FILE_FN(name, fmt, value...)			\
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
 {									\
@@ -45,14 +45,19 @@ static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 									\
 	return mac80211_format_buffer(userbuf, count, ppos, 		\
 				      fmt "\n", ##value);		\
-}									\
-									\
+}
+
+#define DEBUGFS_READONLY_FILE_OPS(name)			\
 static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
 	.open = mac80211_open_file_generic,				\
 	.llseek = generic_file_llseek,					\
 };
 
+#define DEBUGFS_READONLY_FILE(name, fmt, value...)		\
+	DEBUGFS_READONLY_FILE_FN(name, fmt, value)		\
+	DEBUGFS_READONLY_FILE_OPS(name)
+
 #define DEBUGFS_ADD(name)						\
 	debugfs_create_file(#name, 0400, phyd, local, &name## _ops);
 
@@ -291,11 +296,70 @@ static ssize_t channel_type_read(struct file *file, char __user *user_buf,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
 }
 
-static const struct file_operations channel_type_ops = {
-	.read = channel_type_read,
-	.open = mac80211_open_file_generic,
-	.llseek = default_llseek,
-};
+static ssize_t hwflags_read(struct file *file, char __user *user_buf,
+			    size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	int mxln = 500;
+	ssize_t rv;
+	char *buf = kzalloc(mxln, GFP_KERNEL);
+	int sf = 0; /* how many written so far */
+
+	sf += snprintf(buf, mxln - sf, "0x%x\n", local->hw.flags);
+	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
+		sf += snprintf(buf + sf, mxln - sf, "HAS_RATE_CONTROL\n");
+	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
+		sf += snprintf(buf + sf, mxln - sf, "RX_INCLUDES_FCS\n");
+	if (local->hw.flags & IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING)
+		sf += snprintf(buf + sf, mxln - sf,
+			       "HOST_BCAST_PS_BUFFERING\n");
+	if (local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE)
+		sf += snprintf(buf + sf, mxln - sf,
+			       "2GHZ_SHORT_SLOT_INCAPABLE\n");
+	if (local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE)
+		sf += snprintf(buf + sf, mxln - sf,
+			       "2GHZ_SHORT_PREAMBLE_INCAPABLE\n");
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
+		sf += snprintf(buf + sf, mxln - sf, "SIGNAL_UNSPEC\n");
+	if (local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
+		sf += snprintf(buf + sf, mxln - sf, "SIGNAL_DBM\n");
+	if (local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD)
+		sf += snprintf(buf + sf, mxln - sf, "NEED_DTIM_PERIOD\n");
+	if (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT)
+		sf += snprintf(buf + sf, mxln - sf, "SPECTRUM_MGMT\n");
+	if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)
+		sf += snprintf(buf + sf, mxln - sf, "AMPDU_AGGREGATION\n");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_PS)
+		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_PS\n");
+	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+		sf += snprintf(buf + sf, mxln - sf, "PS_NULLFUNC_STACK\n");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
+		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_DYNAMIC_PS\n");
+	if (local->hw.flags & IEEE80211_HW_MFP_CAPABLE)
+		sf += snprintf(buf + sf, mxln - sf, "MFP_CAPABLE\n");
+	if (local->hw.flags & IEEE80211_HW_BEACON_FILTER)
+		sf += snprintf(buf + sf, mxln - sf, "BEACON_FILTER\n");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_STATIC_SMPS)
+		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_STATIC_SMPS\n");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS)
+		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_DYNAMIC_SMPS\n");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)
+		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_UAPSD\n");
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		sf += snprintf(buf + sf, mxln - sf, "REPORTS_TX_ACK_STATUS\n");
+	if (local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
+		sf += snprintf(buf + sf, mxln - sf, "CONNECTION_MONITOR\n");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI)
+		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_CQM_RSSI\n");
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_PER_STA_GTK)
+		sf += snprintf(buf + sf, mxln - sf, "SUPPORTS_PER_STA_GTK\n");
+	if (local->hw.flags & IEEE80211_HW_AP_LINK_PS)
+		sf += snprintf(buf + sf, mxln - sf, "AP_LINK_PS\n");
+
+	rv = simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
+	kfree(buf);
+	return rv;
+}
 
 static ssize_t queues_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
@@ -315,11 +379,9 @@ static ssize_t queues_read(struct file *file, char __user *user_buf,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
 }
 
-static const struct file_operations queues_ops = {
-	.read = queues_read,
-	.open = mac80211_open_file_generic,
-	.llseek = default_llseek,
-};
+DEBUGFS_READONLY_FILE_OPS(hwflags);
+DEBUGFS_READONLY_FILE_OPS(channel_type);
+DEBUGFS_READONLY_FILE_OPS(queues);
 
 /* statistics stuff */
 
@@ -395,6 +457,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(uapsd_queues);
 	DEBUGFS_ADD(uapsd_max_sp_len);
 	DEBUGFS_ADD(channel_type);
+	DEBUGFS_ADD(hwflags);
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
 
-- 
1.7.3.4

