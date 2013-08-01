Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58134 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab3HAOnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 10:43:00 -0400
Received: by mail-wi0-f175.google.com with SMTP id hq12so5281377wib.14
        for <linux-wireless@vger.kernel.org>; Thu, 01 Aug 2013 07:42:59 -0700 (PDT)
From: Sylvain ROGER RIEUNIER <sylvain.roger.rieunier@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
Subject: [[PATCHv2]rt2800usb: ampdu len] rt2800usb: update aggregation len
Date: Thu,  1 Aug 2013 16:42:34 +0200
Message-Id: <1375368155-23566-1-git-send-email-sylvain.roger.rieunier@gmail.com> (sfid-20130801_164305_305858_3A3D1F1A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>

I tried to read periodically TX_AGG_CNT registers on the rt2800usb driver.
I'had made USB synchronous and asynchronous read. But it's only reduces the
bandwidth.
Does anyone have an idea?


Signed-off-by: Sylvain ROGER RIEUNIER <sylvain.roger.rieunier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c   |   69 ++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800usb.c   |   92 +++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00.h      |   28 +++++++++
 drivers/net/wireless/rt2x00/rt2x00debug.c |   66 +++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    2 +
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    2 +
 6 files changed, 259 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index dedc3d4..0db45fb 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1813,6 +1813,75 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 }
 EXPORT_SYMBOL_GPL(rt2800_config_ant);
 
+void rt2800_update_aggr_stats(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+	u32 all;
+	int i;
+
+	rt2800_register_read(rt2x00dev,TX_AGG_CNT, &reg);
+	rt2x00dev->aggr_stats.no_aggr =
+		rt2x00_get_field32(reg,TX_AGG_CNT_NON_AGG_TX_COUNT);
+	rt2x00dev->aggr_stats.all_aggr =
+		rt2x00_get_field32(reg,TX_AGG_CNT_AGG_TX_COUNT);
+
+	rt2800_register_read(rt2x00dev,TX_AGG_CNT0, &reg);
+	rt2x00dev->aggr_stats.ampduCount[0] =
+		rt2x00_get_field32(reg,TX_AGG_CNT0_AGG_SIZE_1_COUNT);
+	rt2x00dev->aggr_stats.ampduCount[1] =
+		rt2x00_get_field32(reg,TX_AGG_CNT0_AGG_SIZE_2_COUNT);
+
+	rt2800_register_read(rt2x00dev,TX_AGG_CNT1, &reg);
+	rt2x00dev->aggr_stats.ampduCount[2] =
+		rt2x00_get_field32(reg,TX_AGG_CNT1_AGG_SIZE_3_COUNT);
+	rt2x00dev->aggr_stats.ampduCount[3] =
+		rt2x00_get_field32(reg,TX_AGG_CNT1_AGG_SIZE_4_COUNT);
+
+	rt2800_register_read(rt2x00dev,TX_AGG_CNT2, &reg);
+	rt2x00dev->aggr_stats.ampduCount[4] =
+		rt2x00_get_field32(reg,TX_AGG_CNT2_AGG_SIZE_5_COUNT);
+	rt2x00dev->aggr_stats.ampduCount[5] =
+		rt2x00_get_field32(reg,TX_AGG_CNT2_AGG_SIZE_6_COUNT);
+
+	rt2800_register_read(rt2x00dev,TX_AGG_CNT3, &reg);
+	rt2x00dev->aggr_stats.ampduCount[6] =
+		rt2x00_get_field32(reg,TX_AGG_CNT3_AGG_SIZE_7_COUNT);
+	rt2x00dev->aggr_stats.ampduCount[7] =
+		rt2x00_get_field32(reg,TX_AGG_CNT3_AGG_SIZE_8_COUNT);
+
+	rt2800_register_read(rt2x00dev,TX_AGG_CNT4, &reg);
+	rt2x00dev->aggr_stats.ampduCount[8] =
+		rt2x00_get_field32(reg,TX_AGG_CNT4_AGG_SIZE_9_COUNT);
+	rt2x00dev->aggr_stats.ampduCount[9] =
+		rt2x00_get_field32(reg,TX_AGG_CNT4_AGG_SIZE_10_COUNT);
+
+	rt2800_register_read(rt2x00dev,TX_AGG_CNT5, &reg);
+	rt2x00dev->aggr_stats.ampduCount[10] =
+		rt2x00_get_field32(reg,TX_AGG_CNT5_AGG_SIZE_11_COUNT);
+	rt2x00dev->aggr_stats.ampduCount[11] =
+		rt2x00_get_field32(reg,TX_AGG_CNT5_AGG_SIZE_12_COUNT);
+
+	rt2800_register_read(rt2x00dev,TX_AGG_CNT6, &reg);
+	rt2x00dev->aggr_stats.ampduCount[12] =
+		rt2x00_get_field32(reg,TX_AGG_CNT6_AGG_SIZE_13_COUNT);
+	rt2x00dev->aggr_stats.ampduCount[13] =
+		rt2x00_get_field32(reg,TX_AGG_CNT6_AGG_SIZE_14_COUNT);
+
+	rt2800_register_read(rt2x00dev,TX_AGG_CNT7, &reg);
+	rt2x00dev->aggr_stats.ampduCount[14] =
+		rt2x00_get_field32(reg,TX_AGG_CNT7_AGG_SIZE_15_COUNT);
+	rt2x00dev->aggr_stats.ampduCount[15] =
+		rt2x00_get_field32(reg,TX_AGG_CNT7_AGG_SIZE_16_COUNT);
+
+	all = rt2x00dev->aggr_stats.no_aggr +
+		rt2x00dev->aggr_stats.all_aggr;
+
+	for( i = 0; i < 16 ; i++)
+		rt2x00dev->aggr_stats.ampduRatio[i] =
+			((rt2x00dev->aggr_stats.ampduCount[i] * 100) / all);
+}
+EXPORT_SYMBOL_GPL(rt2800_update_aggr_stats);
+
 static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 				   struct rt2x00lib_conf *libconf)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index fc9efdf..6ca9cdb 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -225,6 +225,79 @@ static enum hrtimer_restart rt2800usb_tx_sta_fifo_timeout(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
+
+
+static bool rt2800usb_tx_agg_cnt_read_completed(struct rt2x00_dev *rt2x00dev,
+					   int urb_status, u32 reg)
+{
+
+	if (urb_status) {
+		WARNING(rt2x00dev, "TX status read failed %d\n", urb_status);
+		return false;
+	}
+
+	if(rt2x00dev->aggr_stats.cnt == 0) {
+		rt2x00dev->aggr_stats.no_aggr =
+			rt2x00_get_field32(reg,TX_AGG_CNT_NON_AGG_TX_COUNT);
+		rt2x00dev->aggr_stats.all_aggr =
+			rt2x00_get_field32(reg,TX_AGG_CNT_AGG_TX_COUNT);
+	} else {
+		unsigned int tmp = (rt2x00dev->aggr_stats.cnt - 1)*2;
+
+		rt2x00dev->aggr_stats.ampduCount[tmp] =
+		rt2x00_get_field32(reg,TX_AGG_CNT0_AGG_SIZE_1_COUNT);
+		rt2x00dev->aggr_stats.ampduCount[tmp+1] =
+		rt2x00_get_field32(reg,TX_AGG_CNT0_AGG_SIZE_2_COUNT);
+	}
+
+	if(rt2x00dev->aggr_stats.cnt == 9) {
+		rt2x00dev->aggr_stats.cnt = 0;
+		clear_bit(TX_AGG_TIMER, &rt2x00dev->aggr_stats.flags);
+	} else {
+		rt2x00dev->aggr_stats.cnt++;
+		/* Read next TX_AGG_CNT register after 1 ms */
+		hrtimer_start(&rt2x00dev->txaggcnt_timer,
+			      ktime_set(0, 1000000), HRTIMER_MODE_REL);
+	}
+
+	 return true;
+}
+
+static enum hrtimer_restart rt2800usb_tx_agg_cnt_timeout(struct hrtimer *timer)
+{
+	struct rt2x00_dev *rt2x00dev =
+	    container_of(timer, struct rt2x00_dev, txaggcnt_timer);
+	unsigned int offset;
+
+	offset = TX_AGG_CNT + rt2x00dev->aggr_stats.cnt*4;
+	rt2x00usb_register_read_async(rt2x00dev,offset,
+				      rt2800usb_tx_agg_cnt_read_completed);
+
+	return HRTIMER_NORESTART;
+}
+
+static void rt2800usb_async_read_tx_agg_cnt(struct rt2x00_dev *rt2x00dev)
+{
+
+	if (test_and_set_bit(TX_AGG_TIMER, &rt2x00dev->aggr_stats.flags))
+		return;
+
+	/* Read TX_AGG_CNT register after 1 ms */
+	hrtimer_start(&rt2x00dev->txaggcnt_timer, ktime_set(0, 1000000),
+		      HRTIMER_MODE_REL);
+}
+
+static void rt2800usb_timer_txagg(unsigned long data)
+{
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+
+	if (!test_bit(TX_AGG_TIMER, &rt2x00dev->aggr_stats.flags))
+		rt2800usb_async_read_tx_agg_cnt(rt2x00dev);
+
+	rt2x00dev->txagg_timer.expires += 5000;
+	add_timer(&rt2x00dev->txagg_timer);
+}
+
 /*
  * Firmware functions
  */
@@ -750,6 +823,7 @@ static int rt2800usb_read_eeprom(struct rt2x00_dev *rt2x00dev)
 static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
+	unsigned long j = jiffies;
 
 	retval = rt2800_probe_hw(rt2x00dev);
 	if (retval)
@@ -765,6 +839,24 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	PREPARE_WORK(&rt2x00dev->txdone_work, rt2800usb_work_txdone);
 
+	/*
+	 * Set txaggcnt timer function. for usb async read
+	 */
+	rt2x00dev->txaggcnt_timer.function = rt2800usb_tx_agg_cnt_timeout;
+
+	/*
+	 * Set txagg timer function. periodic read
+	 */
+	clear_bit(TX_AGG_TIMER, &rt2x00dev->aggr_stats.flags);
+	rt2x00dev->aggr_stats.cnt = 0;
+	init_timer(&rt2x00dev->txagg_timer);
+	rt2x00dev->txagg_timer.function = rt2800usb_timer_txagg;
+	rt2x00dev->txagg_timer.data = (unsigned long)rt2x00dev;
+
+	j = jiffies;
+	rt2x00dev->txagg_timer.expires = j + 5000;
+	add_timer(&rt2x00dev->txagg_timer);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index fe4c572..b6ae9f3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -637,6 +637,7 @@ struct rt2x00lib_ops {
 			struct ieee80211_sta *sta);
 	int (*sta_remove) (struct rt2x00_dev *rt2x00dev,
 			   int wcid);
+	void (*update_aggr_stats) (struct rt2x00_dev *rt2x00dev);
 };
 
 /*
@@ -733,6 +734,24 @@ enum {
 	NUM_IF_COMB,
 };
 
+#define RT2X00_AGGR_CNT_MAX 16
+
+/*
+ * rt2x00 aggregation state flags
+ */
+enum rt2x00_agg_state_flags {
+	TX_AGG_TIMER,
+};
+struct rt2x00_aggr_stats {
+	unsigned long flags;
+	unsigned int cnt;
+	u32 all_aggr;
+	u32 no_aggr;
+	u32 ampduCount[RT2X00_AGGR_CNT_MAX];
+	u32 ampduRatio[RT2X00_AGGR_CNT_MAX];
+};
+
+
 /*
  * rt2x00 device structure.
  */
@@ -764,6 +783,8 @@ struct rt2x00_dev {
 	enum ieee80211_band curr_band;
 	int curr_freq;
 
+	struct rt2x00_aggr_stats aggr_stats;
+
 	/*
 	 * If enabled, the debugfs interface structures
 	 * required for deregistration of debugfs.
@@ -984,6 +1005,13 @@ struct rt2x00_dev {
 	struct hrtimer txstatus_timer;
 
 	/*
+	 * Timer to ensure tx aggregation counter reports are read (rt2800usb).
+	 */
+	struct hrtimer txaggcnt_timer;
+
+	struct timer_list txagg_timer;
+
+	/*
 	 * Tasklet for processing tx status reports (rt2800pci).
 	 */
 	struct tasklet_struct txstatus_tasklet;
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index fe7a7f6..c41d5a8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -75,6 +75,7 @@ struct rt2x00debug_intf {
 	 *     - frame dump file
 	 *     - queue stats file
 	 *     - crypto stats file
+	 *     - aggr stats file
 	 */
 	struct dentry *driver_folder;
 	struct dentry *driver_entry;
@@ -96,6 +97,7 @@ struct rt2x00debug_intf {
 	struct dentry *queue_frame_dump_entry;
 	struct dentry *queue_stats_entry;
 	struct dentry *crypto_stats_entry;
+	struct dentry *aggr_stats_entry;
 
 	/*
 	 * The frame dump file only allows a single reader,
@@ -589,6 +591,63 @@ static const struct file_operations rt2x00debug_fop_cap_flags = {
 	.llseek		= default_llseek,
 };
 
+
+static ssize_t rt2x00debug_read_aggr_stats(struct file *file,
+					  char __user *buf,
+					  size_t length,
+					  loff_t *offset)
+{
+	struct rt2x00debug_intf *intf =	file->private_data;
+	struct rt2x00_dev *rt2x00dev = intf->rt2x00dev;
+	size_t size;
+	char *data;
+	char *temp;
+	int i;
+
+	if (*offset)
+		return 0;
+
+	data = kzalloc(17 * MAX_LINE_LENGTH, GFP_KERNEL);
+	if (!data)
+		return 0;
+
+	temp = data;
+	temp += sprintf(temp, "all aggr(%u) no agg(%u) \n",
+		       rt2x00dev->aggr_stats.all_aggr,
+		       rt2x00dev->aggr_stats.no_aggr);
+
+	for (i = 0; i < 15 ; i++) {
+		temp += sprintf(temp, "%u AMPDU cnt(%u), ratio(%u)\n", (i+1),
+		       rt2x00dev->aggr_stats.ampduCount[i],
+		       rt2x00dev->aggr_stats.ampduRatio[i]);
+	}
+
+	temp += sprintf(temp, "16 or up AMPDU cnt(%u), ratio(%u)\n",
+			rt2x00dev->aggr_stats.ampduCount[i],
+			rt2x00dev->aggr_stats.ampduRatio[i]);
+
+	size = strlen(data);
+	size = min(size, length);
+
+	if (copy_to_user(buf, data, size)) {
+		kfree(data);
+		return -EFAULT;
+	}
+
+	kfree(data);
+
+	*offset += size;
+	return size;
+}
+
+static const struct file_operations rt2x00debug_fop_aggr_stats = {
+	.owner		= THIS_MODULE,
+	.read		= rt2x00debug_read_aggr_stats,
+	.open		= rt2x00debug_file_open,
+	.release	= rt2x00debug_file_release,
+	.llseek		= default_llseek,
+};
+
 static struct dentry *rt2x00debug_create_file_driver(const char *name,
 						     struct rt2x00debug_intf
 						     *intf,
@@ -694,6 +753,12 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	if (IS_ERR(intf->cap_flags) || !intf->cap_flags)
 		goto exit;
 
+	intf->aggr_stats_entry = debugfs_create_file("aggr_stats", S_IRUSR,
+					      intf->driver_folder, intf,
+					      &rt2x00debug_fop_aggr_stats);
+	if (IS_ERR(intf->aggr_stats_entry) || !intf->aggr_stats_entry)
+		goto exit;
+
 	intf->register_folder =
 	    debugfs_create_dir("register", intf->driver_folder);
 	if (IS_ERR(intf->register_folder) || !intf->register_folder)
@@ -794,6 +859,7 @@ void rt2x00debug_deregister(struct rt2x00_dev *rt2x00dev)
 	debugfs_remove(intf->chipset_entry);
 	debugfs_remove(intf->driver_entry);
 	debugfs_remove(intf->driver_folder);
+	debugfs_remove(intf->aggr_stats_entry);
 	kfree(intf->chipset_blob.data);
 	kfree(intf->driver_blob.data);
 	kfree(intf);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b16521e..935e8b1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1403,7 +1403,9 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
 	cancel_work_sync(&rt2x00dev->sleep_work);
 	if (rt2x00_is_usb(rt2x00dev)) {
+		hrtimer_cancel(&rt2x00dev->txaggcnt_timer);
 		hrtimer_cancel(&rt2x00dev->txstatus_timer);
+		del_timer(&rt2x00dev->txagg_timer);
 		cancel_work_sync(&rt2x00dev->rxdone_work);
 		cancel_work_sync(&rt2x00dev->txdone_work);
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 8828987..0529f69 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -813,6 +813,8 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	INIT_WORK(&rt2x00dev->txdone_work, rt2x00usb_work_txdone);
 	hrtimer_init(&rt2x00dev->txstatus_timer, CLOCK_MONOTONIC,
 		     HRTIMER_MODE_REL);
+	hrtimer_init(&rt2x00dev->txaggcnt_timer, CLOCK_MONOTONIC,
+		     HRTIMER_MODE_REL);
 
 	retval = rt2x00usb_alloc_reg(rt2x00dev);
 	if (retval)
-- 
1.7.10.4

