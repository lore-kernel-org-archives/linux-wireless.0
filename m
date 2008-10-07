Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYJGQ6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 12:58:05 -0400
Message-Id: <20081007100438.773792000@sipsolutions.net> (sfid-20081007_185811_940278_47F68167)
References: <20081007100428.868688000@sipsolutions.net>
Date: Tue, 07 Oct 2008 12:04:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/8] mac80211: remove aggregation status write support from
	debugfs
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code uses static variables and thus cannot be kept.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_sta.c |   73 ---------------------------------------------
 1 file changed, 1 insertion(+), 72 deletions(-)

--- everything.orig/net/mac80211/debugfs_sta.c	2008-10-07 11:26:58.000000000 +0200
+++ everything/net/mac80211/debugfs_sta.c	2008-10-07 11:26:59.000000000 +0200
@@ -39,13 +39,6 @@ static const struct file_operations sta_
 	.open = mac80211_open_file_generic,				\
 }
 
-#define STA_OPS_WR(name)						\
-static const struct file_operations sta_ ##name## _ops = {		\
-	.read = sta_##name##_read,					\
-	.write = sta_##name##_write,					\
-	.open = mac80211_open_file_generic,				\
-}
-
 #define STA_FILE(name, field, format)					\
 		STA_READ_##format(name, field)				\
 		STA_OPS(name)
@@ -168,71 +161,7 @@ static ssize_t sta_agg_status_read(struc
 
 	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
 }
-
-static ssize_t sta_agg_status_write(struct file *file,
-		const char __user *user_buf, size_t count, loff_t *ppos)
-{
-	struct sta_info *sta = file->private_data;
-	struct ieee80211_local *local = sta->sdata->local;
-	struct ieee80211_hw *hw = &local->hw;
-	u8 *da = sta->sta.addr;
-	static int tid_static_tx[16] = {0, 0, 0, 0, 0, 0, 0, 0,
-					0, 0, 0, 0, 0, 0, 0, 0};
-	static int tid_static_rx[16] = {1, 1, 1, 1, 1, 1, 1, 1,
-					1, 1, 1, 1, 1, 1, 1, 1};
-	char *endp;
-	char buf[32];
-	int buf_size, rs;
-	unsigned int tid_num;
-	char state[4];
-
-	memset(buf, 0x00, sizeof(buf));
-	buf_size = min(count, (sizeof(buf)-1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-
-	tid_num = simple_strtoul(buf, &endp, 0);
-	if (endp == buf)
-		return -EINVAL;
-
-	if ((tid_num >= 100) && (tid_num <= 115)) {
-		/* toggle Rx aggregation command */
-		tid_num = tid_num - 100;
-		if (tid_static_rx[tid_num] == 1) {
-			strcpy(state, "off ");
-			ieee80211_sta_stop_rx_ba_session(sta->sdata, da, tid_num, 0,
-					WLAN_REASON_QSTA_REQUIRE_SETUP);
-			sta->ampdu_mlme.tid_state_rx[tid_num] |=
-					HT_AGG_STATE_DEBUGFS_CTL;
-			tid_static_rx[tid_num] = 0;
-		} else {
-			strcpy(state, "on ");
-			sta->ampdu_mlme.tid_state_rx[tid_num] &=
-					~HT_AGG_STATE_DEBUGFS_CTL;
-			tid_static_rx[tid_num] = 1;
-		}
-		printk(KERN_DEBUG "debugfs - try switching tid %u %s\n",
-				tid_num, state);
-	} else if ((tid_num >= 0) && (tid_num <= 15)) {
-		/* toggle Tx aggregation command */
-		if (tid_static_tx[tid_num] == 0) {
-			strcpy(state, "on ");
-			rs =  ieee80211_start_tx_ba_session(hw, da, tid_num);
-			if (rs == 0)
-				tid_static_tx[tid_num] = 1;
-		} else {
-			strcpy(state, "off");
-			rs =  ieee80211_stop_tx_ba_session(hw, da, tid_num, 1);
-			if (rs == 0)
-				tid_static_tx[tid_num] = 0;
-		}
-		printk(KERN_DEBUG "debugfs - switching tid %u %s, return=%d\n",
-				tid_num, state, rs);
-	}
-
-	return count;
-}
-STA_OPS_WR(agg_status);
+STA_OPS(agg_status);
 
 #define DEBUGFS_ADD(name) \
 	sta->debugfs.name = debugfs_create_file(#name, 0400, \

-- 

