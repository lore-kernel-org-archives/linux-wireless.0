Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:37966 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1ADXtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 18:49:24 -0500
Subject: [RFC PATCH 11/17] zd1211rw: add beacon watchdog and setting HW beacon
	more failsafe
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Date: Wed, 05 Jan 2011 01:49:18 +0200
Message-ID: <20110104234918.25309.80393.stgit@fate.lan>
In-Reply-To: <20110104234745.25309.72030.stgit@fate.lan>
References: <20110104234745.25309.72030.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When doing tx/rx at high packet rate (for example simply using ping -f),
device starts to fail to respond to control messages. On non-AP modes
this only causes problems for LED updating code but when we are running
in AP-mode we are writing new beacon to HW usually every 100ms. Now if
control message fails in HW beacon setup, device lock is kept locked
and beacon data partially written. This can and usually does cause:

 1. HW beacon setup fail now on, as driver cannot acquire device lock.
 2. Beacon-done interrupt stop working as device has incomplete beacon.

Therefore make zd_mac_config_beacon() always try to release device lock
and add beacon watchdog to restart beaconing when stall is detected.

Also fix zd_mac_config_beacon() try acquiring device lock for max 500ms,
as what old code appeared to be trying to do using loop and msleep(1).

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |  189 +++++++++++++++++++++++++++-----
 drivers/net/wireless/zd1211rw/zd_mac.h |   13 ++
 2 files changed, 171 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index a3c7e8f..d4b4036 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -138,6 +138,9 @@ static const struct ieee80211_channel zd_channels[] = {
 static void housekeeping_init(struct zd_mac *mac);
 static void housekeeping_enable(struct zd_mac *mac);
 static void housekeeping_disable(struct zd_mac *mac);
+static void beacon_init(struct zd_mac *mac);
+static void beacon_enable(struct zd_mac *mac);
+static void beacon_disable(struct zd_mac *mac);
 
 static int zd_reg2alpha2(u8 regdomain, char *alpha2)
 {
@@ -295,6 +298,8 @@ static int zd_op_start(struct ieee80211_hw *hw)
 		goto disable_rxtx;
 
 	housekeeping_enable(mac);
+	beacon_enable(mac);
+	set_bit(ZD_DEVICE_RUNNING, &mac->flags);
 	return 0;
 disable_rxtx:
 	zd_chip_disable_rxtx(chip);
@@ -313,12 +318,15 @@ static void zd_op_stop(struct ieee80211_hw *hw)
 	struct sk_buff *skb;
 	struct sk_buff_head *ack_wait_queue = &mac->ack_wait_queue;
 
+	clear_bit(ZD_DEVICE_RUNNING, &mac->flags);
+
 	/* The order here deliberately is a little different from the open()
 	 * method, since we need to make sure there is no opportunity for RX
 	 * frames to be processed by mac80211 after we have stopped it.
 	 */
 
 	zd_chip_disable_rxtx(chip);
+	beacon_disable(mac);
 	housekeeping_disable(mac);
 	flush_workqueue(zd_workqueue);
 
@@ -594,64 +602,99 @@ static void cs_set_control(struct zd_mac *mac, struct zd_ctrlset *cs,
 static int zd_mac_config_beacon(struct ieee80211_hw *hw, struct sk_buff *beacon)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
-	int r;
+	int r, ret;
 	u32 tmp, j = 0;
 	/* 4 more bytes for tail CRC */
 	u32 full_len = beacon->len + 4;
+	unsigned long end_jiffies, message_jiffies;
+
+	mutex_lock(&mac->chip.mutex);
 
-	r = zd_iowrite32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, 0);
+	r = zd_iowrite32_locked(&mac->chip, 0, CR_BCN_FIFO_SEMAPHORE);
 	if (r < 0)
-		return r;
-	r = zd_ioread32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, &tmp);
+		goto out;
+	r = zd_ioread32_locked(&mac->chip, &tmp, CR_BCN_FIFO_SEMAPHORE);
 	if (r < 0)
-		return r;
+		goto release_sema;
 
+	end_jiffies = jiffies + HZ / 2; /*~500ms*/
+	message_jiffies = jiffies + HZ / 10; /*~100ms*/
 	while (tmp & 0x2) {
-		r = zd_ioread32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, &tmp);
+		r = zd_ioread32_locked(&mac->chip, &tmp, CR_BCN_FIFO_SEMAPHORE);
 		if (r < 0)
-			return r;
-		if ((++j % 100) == 0) {
-			printk(KERN_ERR "CR_BCN_FIFO_SEMAPHORE not ready\n");
-			if (j >= 500)  {
-				printk(KERN_ERR "Giving up beacon config.\n");
-				return -ETIMEDOUT;
+			goto release_sema;
+		if (time_is_before_eq_jiffies(message_jiffies)) {
+			message_jiffies = jiffies + HZ / 10;
+			dev_err(zd_mac_dev(mac),
+					"CR_BCN_FIFO_SEMAPHORE not ready\n");
+			if (time_is_before_eq_jiffies(end_jiffies))  {
+				dev_err(zd_mac_dev(mac),
+						"Giving up beacon config.\n");
+				r = -ETIMEDOUT;
+				goto release_sema;
 			}
 		}
-		msleep(1);
+		msleep(20);
 	}
 
-	r = zd_iowrite32(&mac->chip, CR_BCN_FIFO, full_len - 1);
+	r = zd_iowrite32_locked(&mac->chip, full_len - 1, CR_BCN_FIFO);
 	if (r < 0)
-		return r;
+		goto release_sema;
 	if (zd_chip_is_zd1211b(&mac->chip)) {
-		r = zd_iowrite32(&mac->chip, CR_BCN_LENGTH, full_len - 1);
+		r = zd_iowrite32_locked(&mac->chip, full_len - 1,
+					CR_BCN_LENGTH);
 		if (r < 0)
-			return r;
+			goto release_sema;
 	}
 
 	for (j = 0 ; j < beacon->len; j++) {
-		r = zd_iowrite32(&mac->chip, CR_BCN_FIFO,
-				*((u8 *)(beacon->data + j)));
+		r = zd_iowrite32_locked(&mac->chip, *((u8 *)(beacon->data + j)),
+					CR_BCN_FIFO);
 		if (r < 0)
-			return r;
+			goto release_sema;
 	}
 
 	for (j = 0; j < 4; j++) {
-		r = zd_iowrite32(&mac->chip, CR_BCN_FIFO, 0x0);
+		r = zd_iowrite32_locked(&mac->chip, 0x0, CR_BCN_FIFO);
 		if (r < 0)
-			return r;
+			goto release_sema;
 	}
 
-	r = zd_iowrite32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, 1);
-	if (r < 0)
-		return r;
+release_sema:
+	/*
+	 * Try very hard to release device beacon semaphore, as otherwise
+	 * device/driver can be left in unusable state.
+	 */
+	end_jiffies = jiffies + HZ / 2; /*~500ms*/
+	ret = zd_iowrite32_locked(&mac->chip, 1, CR_BCN_FIFO_SEMAPHORE);
+	while (ret < 0) {
+		if (time_is_before_eq_jiffies(end_jiffies)) {
+			ret = -ETIMEDOUT;
+			break;
+		}
+
+		msleep(20);
+		ret = zd_iowrite32_locked(&mac->chip, 1, CR_BCN_FIFO_SEMAPHORE);
+	}
+
+	if (ret < 0)
+		dev_err(zd_mac_dev(mac), "Could not release "
+					 "CR_BCN_FIFO_SEMAPHORE!\n");
+	if (r < 0 || ret < 0) {
+		if (r >= 0)
+			r = ret;
+		goto out;
+	}
 
 	/* 802.11b/g 2.4G CCK 1Mb
 	 * 802.11a, not yet implemented, uses different values (see GPL vendor
 	 * driver)
 	 */
-	return zd_iowrite32(&mac->chip, CR_BCN_PLCP_CFG, 0x00000400 |
-			(full_len << 19));
+	r = zd_iowrite32_locked(&mac->chip, 0x00000400 | (full_len << 19),
+				CR_BCN_PLCP_CFG);
+out:
+	mutex_unlock(&mac->chip.mutex);
+	return r;
 }
 
 static void create_tx_desc_seq(struct zd_mac *mac, struct ieee80211_hdr *hdr,
@@ -962,6 +1005,8 @@ static void zd_beacon_done(struct zd_mac *mac)
 {
 	struct sk_buff *skb, *beacon;
 
+	if (!test_bit(ZD_DEVICE_RUNNING, &mac->flags))
+		return;
 	if (!mac->vif || mac->vif->type != NL80211_IFTYPE_AP)
 		return;
 
@@ -979,11 +1024,14 @@ static void zd_beacon_done(struct zd_mac *mac)
 	 * Fetch next beacon so that tim_count is updated.
 	 */
 	beacon = ieee80211_beacon_get(mac->hw, mac->vif);
-	if (!beacon)
-		return;
+	if (beacon) {
+		zd_mac_config_beacon(mac->hw, beacon);
+		kfree_skb(beacon);
+	}
 
-	zd_mac_config_beacon(mac->hw, beacon);
-	kfree_skb(beacon);
+	spin_lock_irq(&mac->lock);
+	mac->beacon.last_update = jiffies;
+	spin_unlock_irq(&mac->lock);
 }
 
 static void zd_process_intr(struct work_struct *work)
@@ -1098,7 +1146,9 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 			struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 
 			if (beacon) {
+				zd_chip_disable_hwint(&mac->chip);
 				zd_mac_config_beacon(hw, beacon);
+				zd_chip_enable_hwint(&mac->chip);
 				kfree_skb(beacon);
 			}
 		}
@@ -1112,6 +1162,12 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 				interval = bss_conf->beacon_int;
 			}
 
+			spin_lock_irq(&mac->lock);
+			mac->beacon.period = period;
+			mac->beacon.interval = interval;
+			mac->beacon.last_update = jiffies;
+			spin_unlock_irq(&mac->lock);
+
 			zd_set_beacon_interval(&mac->chip, interval, period,
 					       mac->type);
 		}
@@ -1205,12 +1261,83 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 
 	zd_chip_init(&mac->chip, hw, intf);
 	housekeeping_init(mac);
+	beacon_init(mac);
 	INIT_WORK(&mac->process_intr, zd_process_intr);
 
 	SET_IEEE80211_DEV(hw, &intf->dev);
 	return hw;
 }
 
+#define BEACON_WATCHDOG_DELAY round_jiffies_relative(HZ)
+
+static void beacon_watchdog_handler(struct work_struct *work)
+{
+	struct zd_mac *mac =
+		container_of(work, struct zd_mac, beacon.watchdog_work.work);
+	struct sk_buff *beacon;
+	unsigned long timeout;
+	int interval, period;
+
+	if (!test_bit(ZD_DEVICE_RUNNING, &mac->flags))
+		goto rearm;
+	if (mac->type != NL80211_IFTYPE_AP || !mac->vif)
+		goto rearm;
+
+	spin_lock_irq(&mac->lock);
+	interval = mac->beacon.interval;
+	period = mac->beacon.period;
+	timeout = mac->beacon.last_update + msecs_to_jiffies(interval) + HZ;
+	spin_unlock_irq(&mac->lock);
+
+	if (interval > 0 && time_is_before_jiffies(timeout)) {
+		dev_dbg_f(zd_mac_dev(mac), "beacon interrupt stalled, "
+					   "restarting. "
+					   "(interval: %d, dtim: %d)\n",
+					   interval, period);
+
+		zd_chip_disable_hwint(&mac->chip);
+
+		beacon = ieee80211_beacon_get(mac->hw, mac->vif);
+		if (beacon) {
+			zd_mac_config_beacon(mac->hw, beacon);
+			kfree_skb(beacon);
+		}
+
+		zd_set_beacon_interval(&mac->chip, interval, period, mac->type);
+
+		zd_chip_enable_hwint(&mac->chip);
+
+		spin_lock_irq(&mac->lock);
+		mac->beacon.last_update = jiffies;
+		spin_unlock_irq(&mac->lock);
+	}
+
+rearm:
+	queue_delayed_work(zd_workqueue, &mac->beacon.watchdog_work,
+			   BEACON_WATCHDOG_DELAY);
+}
+
+static void beacon_init(struct zd_mac *mac)
+{
+	INIT_DELAYED_WORK(&mac->beacon.watchdog_work, beacon_watchdog_handler);
+}
+
+static void beacon_enable(struct zd_mac *mac)
+{
+	dev_dbg_f(zd_mac_dev(mac), "\n");
+
+	mac->beacon.last_update = jiffies;
+	queue_delayed_work(zd_workqueue, &mac->beacon.watchdog_work,
+			   BEACON_WATCHDOG_DELAY);
+}
+
+static void beacon_disable(struct zd_mac *mac)
+{
+	dev_dbg_f(zd_mac_dev(mac), "\n");
+	cancel_rearming_delayed_workqueue(zd_workqueue,
+						&mac->beacon.watchdog_work);
+}
+
 #define LINK_LED_WORK_DELAY HZ
 
 static void link_led_handler(struct work_struct *work)
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index e663451..4b1edb2 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -163,6 +163,17 @@ struct housekeeping {
 	struct delayed_work link_led_work;
 };
 
+struct beacon {
+	struct delayed_work watchdog_work;
+	unsigned long last_update;
+	u16 interval;
+	u8 period;
+};
+
+enum zd_device_flags {
+	ZD_DEVICE_RUNNING,
+};
+
 #define ZD_MAC_STATS_BUFFER_SIZE 16
 
 #define ZD_MAC_MAX_ACK_WAITERS 50
@@ -174,6 +185,7 @@ struct zd_mac {
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vif;
 	struct housekeeping housekeeping;
+	struct beacon beacon;
 	struct work_struct set_rts_cts_work;
 	struct work_struct process_intr;
 	struct zd_mc_hash multicast_hash;
@@ -182,6 +194,7 @@ struct zd_mac {
 	u8 default_regdomain;
 	int type;
 	int associated;
+	unsigned long flags;
 	struct sk_buff_head ack_wait_queue;
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];

