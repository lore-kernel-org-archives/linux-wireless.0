Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:30066 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbbBFGgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 01:36:09 -0500
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@qti.qualcomm.com>,
	<vthiagar@qti.qualcomm.com>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Subject: [PATCH] cfg80211: add debugfs VHT80 allow map
Date: Fri, 6 Feb 2015 12:05:46 +0530
Message-ID: <1423204546-22872-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20150206_073613_656969_90FE5963)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is a output of this debugfs entry

root@OpenWrt:/# cat /sys/kernel/debug/ieee80211/phy0/vht80allow_map
2412 VHT80 N
2417 VHT80 N
2422 VHT80 N
2427 VHT80 N
2432 VHT80 N
2437 VHT80 N
2442 VHT80 N
2447 VHT80 N
2452 VHT80 N
2457 VHT80 N
2462 VHT80 N
2467 Disabled
2472 Disabled
2484 Disabled
5180 VHT80 Y
5200 VHT80 Y
5220 VHT80 Y
5240 VHT80 Y
5260 VHT80 Y
5280 VHT80 Y
5300 VHT80 Y
5320 VHT80 Y
5500 VHT80 Y
5520 VHT80 Y
5540 VHT80 Y
5560 VHT80 Y
5580 VHT80 Y
5600 Disabled
5620 Disabled
5640 Disabled
5660 VHT80 Y
5680 VHT80 Y
5700 VHT80 Y
5745 VHT80 Y
5765 VHT80 Y
5785 VHT80 Y
5805 VHT80 Y
5825 VHT80 Y

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 net/wireless/debugfs.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 4541577..0349dcd 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -102,6 +102,66 @@ static const struct file_operations ht40allow_map_ops = {
 	.llseek = default_llseek,
 };
 
+static int vht80_print_chan(struct ieee80211_channel *chan,
+			    char *buf, int buf_size, int offset)
+{
+	if (WARN_ON(offset > buf_size))
+		return 0;
+
+	if (chan->flags & IEEE80211_CHAN_DISABLED)
+		return scnprintf(buf + offset,
+				 buf_size - offset,
+				 "%d Disabled\n",
+				 chan->center_freq);
+
+	return scnprintf(buf + offset,
+			 buf_size - offset,
+			 "%d VHT80 %c\n",
+			 chan->center_freq,
+			 (chan->flags & IEEE80211_CHAN_NO_80MHZ) ?
+				'N' : 'Y');
+}
+
+static ssize_t vht80allow_map_read(struct file *file,
+				   char __user *user_buf,
+				   size_t count, loff_t *ppos)
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
+	rtnl_lock();
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		sband = wiphy->bands[band];
+		if (!sband)
+			continue;
+		for (i = 0; i < sband->n_channels; i++)
+			offset += vht80_print_chan(&sband->channels[i],
+						   buf, buf_size, offset);
+	}
+
+	rtnl_unlock();
+
+	r = simple_read_from_buffer(user_buf, count, ppos, buf, offset);
+
+	kfree(buf);
+
+	return r;
+}
+
+static const struct file_operations vht80allow_map_ops = {
+	.read = vht80allow_map_read,
+	.open = simple_open,
+	.llseek = default_llseek,
+};
+
 #define DEBUGFS_ADD(name)						\
 	debugfs_create_file(#name, S_IRUGO, phyd, &rdev->wiphy, &name## _ops);
 
@@ -114,4 +174,5 @@ void cfg80211_debugfs_rdev_add(struct cfg80211_registered_device *rdev)
 	DEBUGFS_ADD(short_retry_limit);
 	DEBUGFS_ADD(long_retry_limit);
 	DEBUGFS_ADD(ht40allow_map);
+	DEBUGFS_ADD(vht80allow_map);
 }
-- 
1.7.9.5

