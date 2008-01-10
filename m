Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12000 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbYAJRGR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 12:06:17 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [RFC PATCH 05/11] mac80211: A-MPDU add debugfs support
Date: Thu, 10 Jan 2008 19:02:20 +0200
Message-Id: <11999845544181-git-send-email-ron.rindjunsky@intel.com> (sfid-20080110_170621_532300_ED634361)
In-Reply-To: <1199984547375-git-send-email-ron.rindjunsky@intel.com>
References: <1199984547375-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds A-MPDU status report per STA to the debugfs.
Remark:
=======
The option to activate A-MPDU through debugfs is temporary, only
until A-MPDU manager will be added to the code, and for RFC purposes.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/debugfs_sta.c |  116 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h    |    1 +
 2 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 8f5944c..0878146 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -55,6 +55,13 @@ static const struct file_operations sta_ ##name## _ops = {		\
 	.open = mac80211_open_file_generic,				\
 }
 
+#define STA_OPS_WR(name)						\
+static const struct file_operations sta_ ##name## _ops = {		\
+	.read = sta_##name##_read,					\
+	.write = sta_##name##_write,					\
+	.open = mac80211_open_file_generic,				\
+}
+
 #define STA_FILE(name, field, format)					\
 		STA_READ_##format(name, field)				\
 		STA_OPS(name)
@@ -191,6 +198,113 @@ static ssize_t sta_wme_tx_queue_read(struct file *file, char __user *userbuf,
 STA_OPS(wme_tx_queue);
 #endif
 
+static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
+					size_t count, loff_t *ppos)
+{
+	char buf[768], *p = buf;
+	int i;
+	struct sta_info *sta = file->private_data;
+	p += scnprintf(p, sizeof(buf)+buf-p, "Agg state for STA is:\n");
+	p += scnprintf(p, sizeof(buf)+buf-p, " STA next dialog_token is %d \n "
+			"TIDs info is: \n TID :",
+			(sta->ampdu_mlme.dialog_token_allocator + 1));
+	for (i = 0; i < STA_TID_NUM; i++)
+		p += scnprintf(p, sizeof(buf)+buf-p, "%5d", i);
+
+	p += scnprintf(p, sizeof(buf)+buf-p, "\n RX  :");
+	for (i = 0; i < STA_TID_NUM; i++)
+		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
+	sta->ampdu_mlme.tid_rx[i].state);
+
+	p += scnprintf(p, sizeof(buf)+buf-p, "\n DTKN:");
+	for (i = 0; i < STA_TID_NUM; i++)
+		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
+			sta->ampdu_mlme.tid_rx[i].dialog_token);
+
+	p += scnprintf(p, sizeof(buf)+buf-p, "\n TX  :");
+	for (i = 0; i < STA_TID_NUM; i++)
+		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
+			sta->ampdu_mlme.tid_tx[i].state);
+
+	p += scnprintf(p, sizeof(buf)+buf-p, "\n DTKN:");
+	for (i = 0; i < STA_TID_NUM; i++)
+		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
+			sta->ampdu_mlme.tid_tx[i].dialog_token);
+
+	p += scnprintf(p, sizeof(buf)+buf-p, "\n SSN :");
+	for (i = 0; i < STA_TID_NUM; i++)
+		p += scnprintf(p, sizeof(buf)+buf-p, "%5d",
+			sta->ampdu_mlme.tid_tx[i].ssn);
+
+	p += scnprintf(p, sizeof(buf)+buf-p, "\n");
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+}
+
+static ssize_t sta_agg_status_write(struct file *file,
+		const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct sta_info *sta = file->private_data;
+	struct net_device *dev = sta->dev;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw *hw = &local->hw;
+	u8 *da = sta->addr;
+	static int tid_static_tx[16] = {0, 0, 0, 0, 0, 0, 0, 0,
+					0, 0, 0, 0, 0, 0, 0, 0};
+	static int tid_static_rx[16] = {1, 1, 1, 1, 1, 1, 1, 1,
+					1, 1, 1, 1, 1, 1, 1, 1};
+	char *endp;
+	char buf[32];
+	int buf_size, rs;
+	unsigned int tid_num;
+	char state[4];
+
+	memset(buf, 0x00, sizeof(buf));
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	tid_num = simple_strtoul(buf, &endp, 0);
+	if (endp == buf)
+		return -EINVAL;
+
+	if ((tid_num >= 100) && (tid_num <= 115)) {
+		/* toggle Rx aggregation command */
+		tid_num = tid_num - 100;
+		if (tid_static_rx[tid_num] == 1) {
+			strcpy(state, "off ");
+			ieee80211_sta_stop_rx_ba_session(dev, da, tid_num, 0,
+					WLAN_REASON_QSTA_REQUIRE_SETUP);
+			sta->ampdu_mlme.tid_rx[tid_num].buf_size = 0xFF;
+			tid_static_rx[tid_num] = 0;
+		} else {
+			strcpy(state, "on ");
+			sta->ampdu_mlme.tid_rx[tid_num].buf_size = 0x00;
+			tid_static_rx[tid_num] = 1;
+		}
+		printk(KERN_ERR "%s tried switching tid=%u %s\n", __func__,
+				tid_num, state);
+	} else if ((tid_num >= 0) && (tid_num <= 15)) {
+		/* toggle Tx aggregation command */
+		if (tid_static_tx[tid_num] == 0) {
+			strcpy(state, "on ");
+			rs =  ieee80211_start_tx_ba_session(hw, da, tid_num);
+			if (rs == 0)
+				tid_static_tx[tid_num] = 1;
+		} else {
+			strcpy(state, "off");
+			rs =  ieee80211_stop_tx_ba_session(hw, da, tid_num, 1);
+			if (rs == 0)
+				tid_static_tx[tid_num] = 0;
+		}
+		printk(KERN_ERR "%s tried switching tid=%u %s, return=%d\n",
+				__func__, tid_num, state, rs);
+	}
+
+	return count;
+}
+STA_OPS_WR(agg_status);
+
 #define DEBUGFS_ADD(name) \
 	sta->debugfs.name = debugfs_create_file(#name, 0444, \
 		sta->debugfs.dir, sta, &sta_ ##name## _ops);
@@ -224,6 +338,7 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	DEBUGFS_ADD(wme_rx_queue);
 	DEBUGFS_ADD(wme_tx_queue);
 #endif
+	DEBUGFS_ADD(agg_status);
 }
 
 void ieee80211_sta_debugfs_remove(struct sta_info *sta)
@@ -238,6 +353,7 @@ void ieee80211_sta_debugfs_remove(struct sta_info *sta)
 	DEBUGFS_DEL(wme_rx_queue);
 	DEBUGFS_DEL(wme_tx_queue);
 #endif
+	DEBUGFS_DEL(agg_status);
 
 	debugfs_remove(sta->debugfs.dir);
 	sta->debugfs.dir = NULL;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 48f25f2..1e4410f 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -190,6 +190,7 @@ struct sta_info {
 		struct dentry *wme_rx_queue;
 		struct dentry *wme_tx_queue;
 #endif
+		struct dentry *agg_status;
 	} debugfs;
 #endif
 };
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

