Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52526 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab0EAQx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 12:53:57 -0400
Subject: [PATCH] mac80211: allow controlling aggregation manually
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 May 2010 18:53:51 +0200
Message-ID: <1272732831.4628.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows enabling TX and disabling both TX and
RX aggregation sessions manually in debugfs. It is
very useful for debugging session initiation and
teardown problems since with this you don't have
to force a lot of traffic to get aggregation and
thus have less data to analyse.

Also, to debug mac80211 code itself, make hwsim
"support" aggregation sessions. It will still just
transfer the frame, but go through the setup and
teardown handshakes.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Ok so I do want it in the tree... had another
situation where I needed it and don't want to
have to patch all the time.

Unless anyone objects?

 drivers/net/wireless/mac80211_hwsim.c |    3 +
 net/mac80211/debugfs_sta.c            |   65 +++++++++++++++++++++++++++++++++-
 2 files changed, 66 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2010-05-01 08:47:54.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2010-05-01 08:47:56.000000000 +0200
@@ -1317,7 +1317,8 @@ static int __init init_mac80211_hwsim(vo
 		hw->flags = IEEE80211_HW_MFP_CAPABLE |
 			    IEEE80211_HW_SIGNAL_DBM |
 			    IEEE80211_HW_SUPPORTS_STATIC_SMPS |
-			    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS;
+			    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
+			    IEEE80211_HW_AMPDU_AGGREGATION;
 
 		/* ask mac80211 to reserve space for magic */
 		hw->vif_data_size = sizeof(struct hwsim_vif_priv);
--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2010-05-01 08:46:26.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_sta.c	2010-05-01 08:47:56.000000000 +0200
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



