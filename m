Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:11477 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbbBPIMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 03:12:41 -0500
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@qti.qualcomm.com>,
	<vthiagar@qti.qualcomm.com>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Subject: [PATCH] cfg80211: remove ht40allow_map debugfs entry
Date: Mon, 16 Feb 2015 13:42:19 +0530
Message-ID: <1424074339-21427-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20150216_091244_539645_9CD4610B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We provide these information to userspace. So let us print there

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 net/wireless/debugfs.c | 63 --------------------------------------------------
 1 file changed, 63 deletions(-)

diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 4541577..680a8a2 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -40,68 +40,6 @@ DEBUGFS_READONLY_FILE(short_retry_limit, 20, "%d",
 DEBUGFS_READONLY_FILE(long_retry_limit, 20, "%d",
 		      wiphy->retry_long);
 
-static int ht_print_chan(struct ieee80211_channel *chan,
-			 char *buf, int buf_size, int offset)
-{
-	if (WARN_ON(offset > buf_size))
-		return 0;
-
-	if (chan->flags & IEEE80211_CHAN_DISABLED)
-		return scnprintf(buf + offset,
-				 buf_size - offset,
-				 "%d Disabled\n",
-				 chan->center_freq);
-
-	return scnprintf(buf + offset,
-			 buf_size - offset,
-			 "%d HT40 %c%c\n",
-			 chan->center_freq,
-			 (chan->flags & IEEE80211_CHAN_NO_HT40MINUS) ?
-				' ' : '-',
-			 (chan->flags & IEEE80211_CHAN_NO_HT40PLUS) ?
-				' ' : '+');
-}
-
-static ssize_t ht40allow_map_read(struct file *file,
-				  char __user *user_buf,
-				  size_t count, loff_t *ppos)
-{
-	struct wiphy *wiphy = file->private_data;
-	char *buf;
-	unsigned int offset = 0, buf_size = PAGE_SIZE, i, r;
-	enum ieee80211_band band;
-	struct ieee80211_supported_band *sband;
-
-	buf = kzalloc(buf_size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	rtnl_lock();
-
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
-		sband = wiphy->bands[band];
-		if (!sband)
-			continue;
-		for (i = 0; i < sband->n_channels; i++)
-			offset += ht_print_chan(&sband->channels[i],
-						buf, buf_size, offset);
-	}
-
-	rtnl_unlock();
-
-	r = simple_read_from_buffer(user_buf, count, ppos, buf, offset);
-
-	kfree(buf);
-
-	return r;
-}
-
-static const struct file_operations ht40allow_map_ops = {
-	.read = ht40allow_map_read,
-	.open = simple_open,
-	.llseek = default_llseek,
-};
-
 #define DEBUGFS_ADD(name)						\
 	debugfs_create_file(#name, S_IRUGO, phyd, &rdev->wiphy, &name## _ops);
 
@@ -113,5 +51,4 @@ void cfg80211_debugfs_rdev_add(struct cfg80211_registered_device *rdev)
 	DEBUGFS_ADD(fragmentation_threshold);
 	DEBUGFS_ADD(short_retry_limit);
 	DEBUGFS_ADD(long_retry_limit);
-	DEBUGFS_ADD(ht40allow_map);
 }
-- 
1.9.1

