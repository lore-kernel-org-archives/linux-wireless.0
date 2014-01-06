Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42947 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaAFOsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 09:48:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: clean up netdev debugfs macros a bit
Date: Mon,  6 Jan 2014 15:48:00 +0100
Message-Id: <1389019680-29417-1-git-send-email-johannes@sipsolutions.net> (sfid-20140106_154810_216544_1CBBA69C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Clean up the file macros a bit and use that to remove the
unnecessary format function for the tkip MIC test file
that really is write-only.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_netdev.c | 60 ++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 04b5a14..b62cbe8 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -133,7 +133,15 @@ static ssize_t ieee80211_if_fmt_##name(					\
 			 jiffies_to_msecs(sdata->field));		\
 }
 
-#define __IEEE80211_IF_FILE(name, _write)				\
+#define _IEEE80211_IF_FILE_OPS(name, _read, _write)			\
+static const struct file_operations name##_ops = {			\
+	.read = (_read),						\
+	.write = (_write),						\
+	.open = simple_open,						\
+	.llseek = generic_file_llseek,					\
+}
+
+#define _IEEE80211_IF_FILE_R_FN(name)					\
 static ssize_t ieee80211_if_read_##name(struct file *file,		\
 					char __user *userbuf,		\
 					size_t count, loff_t *ppos)	\
@@ -141,28 +149,34 @@ static ssize_t ieee80211_if_read_##name(struct file *file,		\
 	return ieee80211_if_read(file->private_data,			\
 				 userbuf, count, ppos,			\
 				 ieee80211_if_fmt_##name);		\
-}									\
-static const struct file_operations name##_ops = {			\
-	.read = ieee80211_if_read_##name,				\
-	.write = (_write),						\
-	.open = simple_open,						\
-	.llseek = generic_file_llseek,					\
 }
 
-#define __IEEE80211_IF_FILE_W(name)					\
+#define _IEEE80211_IF_FILE_W_FN(name)					\
 static ssize_t ieee80211_if_write_##name(struct file *file,		\
 					 const char __user *userbuf,	\
 					 size_t count, loff_t *ppos)	\
 {									\
 	return ieee80211_if_write(file->private_data, userbuf, count,	\
 				  ppos, ieee80211_if_parse_##name);	\
-}									\
-__IEEE80211_IF_FILE(name, ieee80211_if_write_##name)
+}
+
+#define IEEE80211_IF_FILE_R(name)					\
+	_IEEE80211_IF_FILE_R_FN(name)					\
+	_IEEE80211_IF_FILE_OPS(name, ieee80211_if_read_##name, NULL)
+
+#define IEEE80211_IF_FILE_W(name)					\
+	_IEEE80211_IF_FILE_W_FN(name)					\
+	_IEEE80211_IF_FILE_OPS(name, NULL, ieee80211_if_write_##name)
 
+#define IEEE80211_IF_FILE_RW(name)					\
+	_IEEE80211_IF_FILE_R_FN(name)					\
+	_IEEE80211_IF_FILE_W_FN(name)					\
+	_IEEE80211_IF_FILE_OPS(name, ieee80211_if_read_##name,		\
+			       ieee80211_if_write_##name)
 
 #define IEEE80211_IF_FILE(name, field, format)				\
-		IEEE80211_IF_FMT_##format(name, field)			\
-		__IEEE80211_IF_FILE(name, NULL)
+	IEEE80211_IF_FMT_##format(name, field)				\
+	IEEE80211_IF_FILE_R(name)
 
 /* common attributes */
 IEEE80211_IF_FILE(drop_unencrypted, drop_unencrypted, DEC);
@@ -199,7 +213,7 @@ ieee80211_if_fmt_hw_queues(const struct ieee80211_sub_if_data *sdata,
 
 	return len;
 }
-__IEEE80211_IF_FILE(hw_queues, NULL);
+IEEE80211_IF_FILE_R(hw_queues);
 
 /* STA attributes */
 IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
@@ -275,14 +289,7 @@ static ssize_t ieee80211_if_parse_smps(struct ieee80211_sub_if_data *sdata,
 
 	return -EINVAL;
 }
-
-__IEEE80211_IF_FILE_W(smps);
-
-static ssize_t ieee80211_if_fmt_tkip_mic_test(
-	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
-{
-	return -EOPNOTSUPP;
-}
+IEEE80211_IF_FILE_RW(smps);
 
 static ssize_t ieee80211_if_parse_tkip_mic_test(
 	struct ieee80211_sub_if_data *sdata, const char *buf, int buflen)
@@ -349,8 +356,7 @@ static ssize_t ieee80211_if_parse_tkip_mic_test(
 
 	return buflen;
 }
-
-__IEEE80211_IF_FILE_W(tkip_mic_test);
+IEEE80211_IF_FILE_W(tkip_mic_test);
 
 static ssize_t ieee80211_if_fmt_uapsd_queues(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
@@ -378,7 +384,7 @@ static ssize_t ieee80211_if_parse_uapsd_queues(
 
 	return buflen;
 }
-__IEEE80211_IF_FILE_W(uapsd_queues);
+IEEE80211_IF_FILE_RW(uapsd_queues);
 
 static ssize_t ieee80211_if_fmt_uapsd_max_sp_len(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
@@ -406,7 +412,7 @@ static ssize_t ieee80211_if_parse_uapsd_max_sp_len(
 
 	return buflen;
 }
-__IEEE80211_IF_FILE_W(uapsd_max_sp_len);
+IEEE80211_IF_FILE_RW(uapsd_max_sp_len);
 
 /* AP attributes */
 IEEE80211_IF_FILE(num_mcast_sta, u.ap.num_mcast_sta, ATOMIC);
@@ -419,7 +425,7 @@ static ssize_t ieee80211_if_fmt_num_buffered_multicast(
 	return scnprintf(buf, buflen, "%u\n",
 			 skb_queue_len(&sdata->u.ap.ps.bc_buf));
 }
-__IEEE80211_IF_FILE(num_buffered_multicast, NULL);
+IEEE80211_IF_FILE_R(num_buffered_multicast);
 
 /* IBSS attributes */
 static ssize_t ieee80211_if_fmt_tsf(
@@ -470,7 +476,7 @@ static ssize_t ieee80211_if_parse_tsf(
 
 	return buflen;
 }
-__IEEE80211_IF_FILE_W(tsf);
+IEEE80211_IF_FILE_RW(tsf);
 
 
 /* WDS attributes */
-- 
1.8.5.1

