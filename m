Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642Ab0DHPus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 11:50:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211_hwsim: add sw_scan sw_scan_complete
Date: Thu,  8 Apr 2010 11:50:47 -0400
Message-Id: <1270741847-14106-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simple pre-scan and scan complete callbacks, this at least shows
to me that mac80211 will issue two scans at the same time on the
same wiphy.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

We have been getting reports of ath9k issuing two scans at the same time,
I figured this was mac80211 related, so I tested this implementation as a
test and I do run into the case.

 drivers/net/wireless/mac80211_hwsim.c |   45 ++++++++++++++++++++++++++++++---
 1 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 6ea77e9..ec8b082 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -290,7 +290,8 @@ struct mac80211_hwsim_data {
 	struct ieee80211_channel *channel;
 	unsigned long beacon_int; /* in jiffies unit */
 	unsigned int rx_filter;
-	bool started, idle;
+	bool started, idle, scanning;
+	struct mutex mutex;
 	struct timer_list beacon_timer;
 	enum ps_mode {
 		PS_DISABLED, PS_ENABLED, PS_AUTO_POLL, PS_MANUAL_POLL
@@ -956,9 +957,9 @@ static int mac80211_hwsim_hw_scan(struct ieee80211_hw *hw,
 	hsd->hw = hw;
 	INIT_DELAYED_WORK(&hsd->w, hw_scan_done);
 
-	printk(KERN_DEBUG "hwsim scan request\n");
+	printk(KERN_DEBUG "hwsim hw_scan request\n");
 	for (i = 0; i < req->n_channels; i++)
-		printk(KERN_DEBUG "hwsim scan freq %d\n",
+		printk(KERN_DEBUG "hwsim hw_scan freq %d\n",
 			req->channels[i]->center_freq);
 
 	ieee80211_queue_delayed_work(hw, &hsd->w, 2 * HZ);
@@ -966,6 +967,36 @@ static int mac80211_hwsim_hw_scan(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static void mac80211_hwsim_sw_scan(struct ieee80211_hw *hw)
+{
+	struct mac80211_hwsim_data *hwsim = hw->priv;
+
+	mutex_lock(&hwsim->mutex);
+
+	if (hwsim->scanning) {
+		printk(KERN_DEBUG "two hwsim sw_scans detected!\n");
+		goto out;
+	}
+
+	printk(KERN_DEBUG "hwsim sw_scan request, prepping stuff\n");
+	hwsim->scanning = true;
+
+out:
+	mutex_unlock(&hwsim->mutex);
+}
+
+static void mac80211_hwsim_sw_scan_complete(struct ieee80211_hw *hw)
+{
+	struct mac80211_hwsim_data *hwsim = hw->priv;
+
+	mutex_lock(&hwsim->mutex);
+
+	printk(KERN_DEBUG "hwsim sw_scan_complete\n");
+	hwsim->scanning = true;
+
+	mutex_unlock(&hwsim->mutex);
+}
+
 static struct ieee80211_ops mac80211_hwsim_ops =
 {
 	.tx = mac80211_hwsim_tx,
@@ -983,6 +1014,8 @@ static struct ieee80211_ops mac80211_hwsim_ops =
 	.conf_tx = mac80211_hwsim_conf_tx,
 	CFG80211_TESTMODE_CMD(mac80211_hwsim_testmode_cmd)
 	.ampdu_action = mac80211_hwsim_ampdu_action,
+	.sw_scan_start = mac80211_hwsim_sw_scan,
+	.sw_scan_complete = mac80211_hwsim_sw_scan_complete,
 	.flush = mac80211_hwsim_flush,
 };
 
@@ -1178,8 +1211,11 @@ static int __init init_mac80211_hwsim(void)
 	if (radios < 1 || radios > 100)
 		return -EINVAL;
 
-	if (fake_hw_scan)
+	if (fake_hw_scan) {
 		mac80211_hwsim_ops.hw_scan = mac80211_hwsim_hw_scan;
+		mac80211_hwsim_ops.sw_scan_start = NULL;
+		mac80211_hwsim_ops.sw_scan_complete = NULL;
+	}
 
 	spin_lock_init(&hwsim_radio_lock);
 	INIT_LIST_HEAD(&hwsim_radios);
@@ -1284,6 +1320,7 @@ static int __init init_mac80211_hwsim(void)
 		}
 		/* By default all radios are belonging to the first group */
 		data->group = 1;
+		mutex_init(&data->mutex);
 
 		/* Work to be done prior to ieee80211_register_hw() */
 		switch (regtest) {
-- 
1.6.3.3

