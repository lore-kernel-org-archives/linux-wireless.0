Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:59501 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1FTLmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 07:42:40 -0400
Subject: [PATCH 3/6] zd1211rw: only update HW beacon if new beacon differs
	from currect
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 20 Jun 2011 14:42:39 +0300
Message-ID: <20110620114238.964.59892.stgit@localhost6.localdomain6> (sfid-20110620_134244_452436_4C1331AC)
In-Reply-To: <20110620114228.964.35459.stgit@localhost6.localdomain6>
References: <20110620114228.964.35459.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update HW beacon only when needed. This appears to make device work in AP-mode
(dtim_period=1) somewhat more stable.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   76 +++++++++++++++++++++++++++-----
 drivers/net/wireless/zd1211rw/zd_mac.h |    1 
 2 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 5de28bf..0828605 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -403,10 +403,8 @@ int zd_restore_settings(struct zd_mac *mac)
 	    mac->type == NL80211_IFTYPE_AP) {
 		if (mac->vif != NULL) {
 			beacon = ieee80211_beacon_get(mac->hw, mac->vif);
-			if (beacon) {
+			if (beacon)
 				zd_mac_config_beacon(mac->hw, beacon);
-				kfree_skb(beacon);
-			}
 		}
 
 		zd_set_beacon_interval(&mac->chip, beacon_interval,
@@ -680,6 +678,32 @@ static void cs_set_control(struct zd_mac *mac, struct zd_ctrlset *cs,
 	/* FIXME: Management frame? */
 }
 
+static bool zd_mac_match_cur_beacon(struct zd_mac *mac, struct sk_buff *beacon)
+{
+	if (!mac->beacon.cur_beacon)
+		return false;
+
+	if (mac->beacon.cur_beacon->len != beacon->len)
+		return false;
+
+	return !memcmp(beacon->data, mac->beacon.cur_beacon->data, beacon->len);
+}
+
+static void zd_mac_free_cur_beacon_locked(struct zd_mac *mac)
+{
+	ZD_ASSERT(mutex_is_locked(&mac->chip.mutex));
+
+	kfree_skb(mac->beacon.cur_beacon);
+	mac->beacon.cur_beacon = NULL;
+}
+
+static void zd_mac_free_cur_beacon(struct zd_mac *mac)
+{
+	mutex_lock(&mac->chip.mutex);
+	zd_mac_free_cur_beacon_locked(mac);
+	mutex_unlock(&mac->chip.mutex);
+}
+
 static int zd_mac_config_beacon(struct ieee80211_hw *hw, struct sk_buff *beacon)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
@@ -690,13 +714,21 @@ static int zd_mac_config_beacon(struct ieee80211_hw *hw, struct sk_buff *beacon)
 	unsigned long end_jiffies, message_jiffies;
 	struct zd_ioreq32 *ioreqs;
 
+	mutex_lock(&mac->chip.mutex);
+
+	/* Check if hw already has this beacon. */
+	if (zd_mac_match_cur_beacon(mac, beacon)) {
+		r = 0;
+		goto out_nofree;
+	}
+
 	/* Alloc memory for full beacon write at once. */
 	num_cmds = 1 + zd_chip_is_zd1211b(&mac->chip) + full_len;
 	ioreqs = kmalloc(num_cmds * sizeof(struct zd_ioreq32), GFP_KERNEL);
-	if (!ioreqs)
-		return -ENOMEM;
-
-	mutex_lock(&mac->chip.mutex);
+	if (!ioreqs) {
+		r = -ENOMEM;
+		goto out_nofree;
+	}
 
 	r = zd_iowrite32_locked(&mac->chip, 0, CR_BCN_FIFO_SEMAPHORE);
 	if (r < 0)
@@ -773,9 +805,19 @@ release_sema:
 	if (r < 0 || ret < 0) {
 		if (r >= 0)
 			r = ret;
+
+		/* We don't know if beacon was written successfully or not,
+		 * so clear current. */
+		zd_mac_free_cur_beacon_locked(mac);
+
 		goto out;
 	}
 
+	/* Beacon has now been written successfully, update current. */
+	zd_mac_free_cur_beacon_locked(mac);
+	mac->beacon.cur_beacon = beacon;
+	beacon = NULL;
+
 	/* 802.11b/g 2.4G CCK 1Mb
 	 * 802.11a, not yet implemented, uses different values (see GPL vendor
 	 * driver)
@@ -783,11 +825,17 @@ release_sema:
 	r = zd_iowrite32_locked(&mac->chip, 0x00000400 | (full_len << 19),
 				CR_BCN_PLCP_CFG);
 out:
-	mutex_unlock(&mac->chip.mutex);
 	kfree(ioreqs);
+out_nofree:
+	kfree_skb(beacon);
+	mutex_unlock(&mac->chip.mutex);
+
 	return r;
 
 reset_device:
+	zd_mac_free_cur_beacon_locked(mac);
+	kfree_skb(beacon);
+
 	mutex_unlock(&mac->chip.mutex);
 	kfree(ioreqs);
 
@@ -1073,6 +1121,8 @@ static void zd_op_remove_interface(struct ieee80211_hw *hw,
 	mac->vif = NULL;
 	zd_set_beacon_interval(&mac->chip, 0, 0, NL80211_IFTYPE_UNSPECIFIED);
 	zd_write_mac_addr(&mac->chip, NULL);
+
+	zd_mac_free_cur_beacon(mac);
 }
 
 static int zd_op_config(struct ieee80211_hw *hw, u32 changed)
@@ -1110,10 +1160,8 @@ static void zd_beacon_done(struct zd_mac *mac)
 	 * Fetch next beacon so that tim_count is updated.
 	 */
 	beacon = ieee80211_beacon_get(mac->hw, mac->vif);
-	if (beacon) {
+	if (beacon)
 		zd_mac_config_beacon(mac->hw, beacon);
-		kfree_skb(beacon);
-	}
 
 	spin_lock_irq(&mac->lock);
 	mac->beacon.last_update = jiffies;
@@ -1240,7 +1288,6 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 				zd_chip_disable_hwint(&mac->chip);
 				zd_mac_config_beacon(hw, beacon);
 				zd_chip_enable_hwint(&mac->chip);
-				kfree_skb(beacon);
 			}
 		}
 
@@ -1390,8 +1437,9 @@ static void beacon_watchdog_handler(struct work_struct *work)
 
 		beacon = ieee80211_beacon_get(mac->hw, mac->vif);
 		if (beacon) {
+			zd_mac_free_cur_beacon(mac);
+
 			zd_mac_config_beacon(mac->hw, beacon);
-			kfree_skb(beacon);
 		}
 
 		zd_set_beacon_interval(&mac->chip, interval, period, mac->type);
@@ -1426,6 +1474,8 @@ static void beacon_disable(struct zd_mac *mac)
 {
 	dev_dbg_f(zd_mac_dev(mac), "\n");
 	cancel_delayed_work_sync(&mac->beacon.watchdog_work);
+
+	zd_mac_free_cur_beacon(mac);
 }
 
 #define LINK_LED_WORK_DELAY HZ
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index f8c93c3..c01eca8 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -165,6 +165,7 @@ struct housekeeping {
 
 struct beacon {
 	struct delayed_work watchdog_work;
+	struct sk_buff *cur_beacon;
 	unsigned long last_update;
 	u16 interval;
 	u8 period;

