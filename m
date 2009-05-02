Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZEBEjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 00:39:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] cfg80211: add debugfs HT40 allow map
Date: Sat,  2 May 2009 00:39:30 -0400
Message-Id: <1241239170-11443-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1241239170-11443-1-git-send-email-lrodriguez@atheros.com>
References: <1241239170-11443-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a screenshot of what this looks like with ath9k:

mcgrof@pogo /debug/ieee80211/phy0 $ cat ht40allow_map
2412 HT40  +
2417 HT40  +
2422 HT40  +
2427 HT40  +
2432 HT40 -+
2437 HT40 -+
2442 HT40 -+
2447 HT40 -
2452 HT40 -
2457 HT40 -
2462 HT40 -
2467 Disabled
2472 Disabled
2484 Disabled
5180 HT40  +
5200 HT40 -+
5220 HT40 -+
5240 HT40 -+
5260 HT40 -+
5280 HT40 -+
5300 HT40 -+
5320 HT40 -
5500 HT40  +
5520 HT40 -+
5540 HT40 -+
5560 HT40 -+
5580 HT40 -+
5600 HT40 -+
5620 HT40 -+
5640 HT40 -+
5660 HT40 -+
5680 HT40 -+
5700 HT40 -
5745 HT40  +
5765 HT40 -+
5785 HT40 -+
5805 HT40 -+
5825 HT40 -

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/core.h    |    1 +
 net/wireless/debugfs.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5756e80..b705149 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -58,6 +58,7 @@ struct cfg80211_registered_device {
 		struct dentry *fragmentation_threshold;
 		struct dentry *short_retry_limit;
 		struct dentry *long_retry_limit;
+		struct dentry *ht40allow_map;
 	} debugfs;
 #endif
 
diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 3211e0e..679ddfc 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -44,6 +44,65 @@ DEBUGFS_READONLY_FILE(short_retry_limit, 20, "%d",
 DEBUGFS_READONLY_FILE(long_retry_limit, 20, "%d",
 		      wiphy->retry_long);
 
+static int ht_print_chan(struct ieee80211_channel *chan,
+			 char *buf, int buf_size, int offset)
+{
+	if (WARN_ON(offset > buf_size))
+		return 0;
+
+	if (chan->flags & IEEE80211_CHAN_DISABLED)
+		return snprintf(buf + offset,
+				buf_size - offset,
+				"%d Disabled\n",
+				chan->center_freq);
+
+	return snprintf(buf + offset,
+			buf_size - offset,
+			"%d HT40 %c%c\n",
+			chan->center_freq,
+			(chan->flags & IEEE80211_CHAN_NO_HT40MINUS) ? ' ' : '-',
+			(chan->flags & IEEE80211_CHAN_NO_HT40PLUS)  ? ' ' : '+');
+}
+
+static ssize_t ht40allow_map_read(struct file *file,
+				  char __user *user_buf,
+				  size_t count, loff_t *ppos)
+{
+	struct wiphy *wiphy = file->private_data;
+	char *buf;
+	unsigned int offset = 0, buf_size = PAGE_SIZE, i, r;
+	enum ieee80211_band band;
+	struct ieee80211_supported_band *sband;
+
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mutex_lock(&cfg80211_mutex);
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		sband = wiphy->bands[band];
+		if (!sband)
+			continue;
+		for (i = 0; i < sband->n_channels; i++)
+			offset += ht_print_chan(&sband->channels[i],
+						buf, buf_size, offset);
+	}
+
+	mutex_unlock(&cfg80211_mutex);
+
+	r = simple_read_from_buffer(user_buf, count, ppos, buf, offset);
+
+	kfree(buf);
+
+	return r;
+}
+
+static const struct file_operations ht40allow_map_ops = {
+	.read = ht40allow_map_read,
+	.open = cfg80211_open_file_generic,
+};
+
 #define DEBUGFS_ADD(name)						\
 	drv->debugfs.name = debugfs_create_file(#name, S_IRUGO, phyd,	\
 						  &drv->wiphy, &name## _ops);
@@ -59,6 +118,7 @@ void cfg80211_debugfs_drv_add(struct cfg80211_registered_device *drv)
 	DEBUGFS_ADD(fragmentation_threshold);
 	DEBUGFS_ADD(short_retry_limit);
 	DEBUGFS_ADD(long_retry_limit);
+	DEBUGFS_ADD(ht40allow_map);
 }
 
 void cfg80211_debugfs_drv_del(struct cfg80211_registered_device *drv)
@@ -67,4 +127,5 @@ void cfg80211_debugfs_drv_del(struct cfg80211_registered_device *drv)
 	DEBUGFS_DEL(fragmentation_threshold);
 	DEBUGFS_DEL(short_retry_limit);
 	DEBUGFS_DEL(long_retry_limit);
+	DEBUGFS_DEL(ht40allow_map);
 }
-- 
1.6.0.6

