Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39462 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab0DSJEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 05:04:39 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1O3muE-0003dB-J9
	for linux-wireless@vger.kernel.org; Mon, 19 Apr 2010 11:04:38 +0200
Subject: [RFC] mac80211: allow creating/destroying agg sessions from debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 11:04:38 +0200
Message-ID: <1271667878.3873.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is useful for debugging.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Not sure we want it in the tree?

drivers/net/wireless/mac80211_hwsim.c |    3 +
 net/mac80211/debugfs_sta.c            |   65 +++++++++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2010-04-19 10:53:52.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2010-04-19 10:54:37.000000000 +0200
@@ -1287,7 +1287,8 @@ static int __init init_mac80211_hwsim(vo
 		hw->flags = IEEE80211_HW_MFP_CAPABLE |
 			    IEEE80211_HW_SIGNAL_DBM |
 			    IEEE80211_HW_SUPPORTS_STATIC_SMPS |
-			    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS;
+			    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
+			    IEEE80211_HW_AMPDU_AGGREGATION;
 
 		/* ask mac80211 to reserve space for magic */
 		hw->vif_data_size = sizeof(struct hwsim_vif_priv);
--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2010-04-19 10:53:52.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_sta.c	2010-04-19 10:54:37.000000000 +0200
@@ -39,6 +39,13 @@ static const struct file_operations sta_
 	.open = mac80211_open_file_generic,				\
 }
 
+#define STA_OPS_RW(name)						\
+static const struct file_operations sta_ ##name## _ops = {		\
+	.read = sta_##name##_read,					\
+	.write = sta_##name##_write,					\
+	.open = mac80211_open_file_generic,				\
+}
+
 #define STA_FILE(name, field, format)					\
 		STA_READ_##format(name, field)				\
 		STA_OPS(name)
@@ -156,7 +163,63 @@ static ssize_t sta_agg_status_read(struc
 
 	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
 }
-STA_OPS(agg_status);
+
+static ssize_t sta_agg_status_write(struct file *file, const char __user *userbuf,
+				    size_t count, loff_t *ppos)
+{
+	char _buf[12], *buf = _buf;
+	struct sta_info *sta = file->private_data;
+	bool start, tx;
+	unsigned long tid;
+	int ret;
+
+	if (count > sizeof(_buf))
+		return -EINVAL;
+
+	if (copy_from_user(buf, userbuf, count))
+		return -EFAULT;
+
+	buf[sizeof(_buf) - 1] = '\0';
+
+	if (strncmp(buf, "tx ", 3) == 0) {
+		buf += 3;
+		tx = true;
+	} else if (strncmp(buf, "rx ", 3) == 0) {
+		buf += 3;
+		tx = false;
+	} else
+		return -EINVAL;
+
+	if (strncmp(buf, "start ", 6) == 0) {
+		buf += 6;
+		start = true;
+		if (!tx)
+			return -EINVAL;
+	} else if (strncmp(buf, "stop ", 5) == 0) {
+		buf += 5;
+		start = false;
+	} else
+		return -EINVAL;
+
+	tid = simple_strtoul(buf, NULL, 0);
+
+	if (tid >= STA_TID_NUM)
+		return -EINVAL;
+
+	if (tx) {
+		if (start)
+			ret = ieee80211_start_tx_ba_session(&sta->sta, tid);
+		else
+			ret = ieee80211_stop_tx_ba_session(&sta->sta, tid,
+							   WLAN_BACK_RECIPIENT);
+	} else {
+		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT, 3);
+		ret = 0;
+	}
+
+	return ret ?: count;
+}
+STA_OPS_RW(agg_status);
 
 static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
 				size_t count, loff_t *ppos)


