Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaFELxs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 07:53:48 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com,
	Matthias Fend <Matthias.Fend@wolfvision.net>
Subject: [PATCH 1/5] rt2x00: change beaconing locking
Date: Thu,  5 Jun 2014 13:52:23 +0200
Message-Id: <1401969147-3532-1-git-send-email-sgruszka@redhat.com> (sfid-20140605_135350_647355_BAAF6C5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is needed for further changes to keep global variables
consistent when changing beaconing on diffrent vif's.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |  7 +++++--
 drivers/net/wireless/rt2x00/rt2x00mac.c   |  6 ++----
 drivers/net/wireless/rt2x00/rt2x00queue.c | 21 ++-------------------
 3 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 2bde672..72e3e81 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -141,8 +141,11 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		return;
 
-	if (test_and_clear_bit(DELAYED_UPDATE_BEACON, &intf->delayed_flags))
+	if (test_and_clear_bit(DELAYED_UPDATE_BEACON, &intf->delayed_flags)) {
+		mutex_lock(&intf->beacon_skb_mutex);
 		rt2x00queue_update_beacon(rt2x00dev, vif);
+		mutex_unlock(&intf->beacon_skb_mutex);
+	}
 }
 
 static void rt2x00lib_intf_scheduled(struct work_struct *work)
@@ -216,7 +219,7 @@ static void rt2x00lib_beaconupdate_iter(void *data, u8 *mac,
 	 * never be called for USB devices.
 	 */
 	WARN_ON(rt2x00_is_usb(rt2x00dev));
-	rt2x00queue_update_beacon_locked(rt2x00dev, vif);
+	rt2x00queue_update_beacon(rt2x00dev, vif);
 }
 
 void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 212ac48..0aad22d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -624,6 +624,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	 * Start/stop beaconing.
 	 */
 	if (changes & BSS_CHANGED_BEACON_ENABLED) {
+		mutex_lock(&intf->beacon_skb_mutex);
 		if (!bss_conf->enable_beacon && intf->enable_beacon) {
 			rt2x00dev->intf_beaconing--;
 			intf->enable_beacon = false;
@@ -639,9 +640,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 				 * Last beaconing interface disabled
 				 * -> stop beacon queue.
 				 */
-				mutex_lock(&intf->beacon_skb_mutex);
 				rt2x00queue_stop_queue(rt2x00dev->bcn);
-				mutex_unlock(&intf->beacon_skb_mutex);
 			}
 		} else if (bss_conf->enable_beacon && !intf->enable_beacon) {
 			rt2x00dev->intf_beaconing++;
@@ -658,11 +657,10 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 				 * First beaconing interface enabled
 				 * -> start beacon queue.
 				 */
-				mutex_lock(&intf->beacon_skb_mutex);
 				rt2x00queue_start_queue(rt2x00dev->bcn);
-				mutex_unlock(&intf->beacon_skb_mutex);
 			}
 		}
+		mutex_unlock(&intf->beacon_skb_mutex);
 	}
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 5642ccc..8e68f87 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -754,8 +754,6 @@ int rt2x00queue_clear_beacon(struct rt2x00_dev *rt2x00dev,
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
 
-	mutex_lock(&intf->beacon_skb_mutex);
-
 	/*
 	 * Clean up the beacon skb.
 	 */
@@ -768,13 +766,11 @@ int rt2x00queue_clear_beacon(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00dev->ops->lib->clear_beacon)
 		rt2x00dev->ops->lib->clear_beacon(intf->beacon);
 
-	mutex_unlock(&intf->beacon_skb_mutex);
-
 	return 0;
 }
 
-int rt2x00queue_update_beacon_locked(struct rt2x00_dev *rt2x00dev,
-				     struct ieee80211_vif *vif)
+int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
+			      struct ieee80211_vif *vif)
 {
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 	struct skb_frame_desc *skbdesc;
@@ -815,19 +811,6 @@ int rt2x00queue_update_beacon_locked(struct rt2x00_dev *rt2x00dev,
 
 }
 
-int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
-			      struct ieee80211_vif *vif)
-{
-	struct rt2x00_intf *intf = vif_to_intf(vif);
-	int ret;
-
-	mutex_lock(&intf->beacon_skb_mutex);
-	ret = rt2x00queue_update_beacon_locked(rt2x00dev, vif);
-	mutex_unlock(&intf->beacon_skb_mutex);
-
-	return ret;
-}
-
 bool rt2x00queue_for_each_entry(struct data_queue *queue,
 				enum queue_index start,
 				enum queue_index end,
-- 
1.8.3.1

