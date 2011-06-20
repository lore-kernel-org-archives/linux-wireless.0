Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:42301 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1FTLmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 07:42:50 -0400
Subject: [PATCH 5/6] zd1211rw: don't let zd_mac_config_beacon() run too long
	from beacon interrupt handler
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 20 Jun 2011 14:42:49 +0300
Message-ID: <20110620114249.964.31962.stgit@localhost6.localdomain6> (sfid-20110620_134254_541876_5C28E1AA)
In-Reply-To: <20110620114228.964.35459.stgit@localhost6.localdomain6>
References: <20110620114228.964.35459.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd_mac_config_beacon() has only limited time to set up beacon when called from
beacon interrupt handler/worker. So do not let it retry acquiring beacon fifo
semaphore in interrupt handler. Beacon fifo semaphore should not be locked by
firmware anyway at this time, it's only locked when device is using/txing
beacon.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 0828605..b67c52d 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -143,7 +143,7 @@ static void beacon_enable(struct zd_mac *mac);
 static void beacon_disable(struct zd_mac *mac);
 static void set_rts_cts(struct zd_mac *mac, unsigned int short_preamble);
 static int zd_mac_config_beacon(struct ieee80211_hw *hw,
-				struct sk_buff *beacon);
+				struct sk_buff *beacon, bool in_intr);
 
 static int zd_reg2alpha2(u8 regdomain, char *alpha2)
 {
@@ -404,7 +404,7 @@ int zd_restore_settings(struct zd_mac *mac)
 		if (mac->vif != NULL) {
 			beacon = ieee80211_beacon_get(mac->hw, mac->vif);
 			if (beacon)
-				zd_mac_config_beacon(mac->hw, beacon);
+				zd_mac_config_beacon(mac->hw, beacon, false);
 		}
 
 		zd_set_beacon_interval(&mac->chip, beacon_interval,
@@ -704,7 +704,8 @@ static void zd_mac_free_cur_beacon(struct zd_mac *mac)
 	mutex_unlock(&mac->chip.mutex);
 }
 
-static int zd_mac_config_beacon(struct ieee80211_hw *hw, struct sk_buff *beacon)
+static int zd_mac_config_beacon(struct ieee80211_hw *hw, struct sk_buff *beacon,
+				bool in_intr)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	int r, ret, num_cmds, req_pos = 0;
@@ -736,6 +737,10 @@ static int zd_mac_config_beacon(struct ieee80211_hw *hw, struct sk_buff *beacon)
 	r = zd_ioread32_locked(&mac->chip, &tmp, CR_BCN_FIFO_SEMAPHORE);
 	if (r < 0)
 		goto release_sema;
+	if (in_intr && tmp & 0x2) {
+		r = -EBUSY;
+		goto release_sema;
+	}
 
 	end_jiffies = jiffies + HZ / 2; /*~500ms*/
 	message_jiffies = jiffies + HZ / 10; /*~100ms*/
@@ -790,7 +795,7 @@ release_sema:
 	end_jiffies = jiffies + HZ / 2; /*~500ms*/
 	ret = zd_iowrite32_locked(&mac->chip, 1, CR_BCN_FIFO_SEMAPHORE);
 	while (ret < 0) {
-		if (time_is_before_eq_jiffies(end_jiffies)) {
+		if (in_intr || time_is_before_eq_jiffies(end_jiffies)) {
 			ret = -ETIMEDOUT;
 			break;
 		}
@@ -1161,7 +1166,7 @@ static void zd_beacon_done(struct zd_mac *mac)
 	 */
 	beacon = ieee80211_beacon_get(mac->hw, mac->vif);
 	if (beacon)
-		zd_mac_config_beacon(mac->hw, beacon);
+		zd_mac_config_beacon(mac->hw, beacon, true);
 
 	spin_lock_irq(&mac->lock);
 	mac->beacon.last_update = jiffies;
@@ -1286,7 +1291,7 @@ static void zd_op_bss_info_changed(struct ieee80211_hw *hw,
 
 			if (beacon) {
 				zd_chip_disable_hwint(&mac->chip);
-				zd_mac_config_beacon(hw, beacon);
+				zd_mac_config_beacon(hw, beacon, false);
 				zd_chip_enable_hwint(&mac->chip);
 			}
 		}
@@ -1439,7 +1444,7 @@ static void beacon_watchdog_handler(struct work_struct *work)
 		if (beacon) {
 			zd_mac_free_cur_beacon(mac);
 
-			zd_mac_config_beacon(mac->hw, beacon);
+			zd_mac_config_beacon(mac->hw, beacon, false);
 		}
 
 		zd_set_beacon_interval(&mac->chip, interval, period, mac->type);

