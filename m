Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:38598 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZHHV4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 17:56:12 -0400
Received: by mail-ew0-f211.google.com with SMTP id 7so1937875ewy.18
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 14:56:13 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 6/7] rt2x00: Fix for race condition while update beacon
Date: Sat, 8 Aug 2009 23:55:18 +0200
Cc: users@rt2x00.serialmonkey.com,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Igor Perminov <igor.perminov@inbox.ru>
References: <200908082353.04274.IvDoorn@gmail.com> <200908082354.24733.IvDoorn@gmail.com> <200908082354.51745.IvDoorn@gmail.com>
In-Reply-To: <200908082354.51745.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908082355.19233.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Perminov <igor.perminov@inbox.ru>

The patch "Implement set_tim callback for all drivers" can cause kernel
oops in rt73usb_write_beacon. The oops is caused by one of the following
race conditions:
* In case of two near calls to set_tim: rt2x00lib_beacondone_iter is
cleaning the beacon skb, whereas rt73usb_write_beacon is still using it.
* In case of two near updates of beacon: first as the result of set_tim
and second as the result of a call from an application (e.g. hostapd).
This patch fixes the race condition by rearranging the update logic and
guarding rt2x00_intf->beacon->skb with a mutex.

Signed-off-by: Igor Perminov <igor.perminov@inbox.ru>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h      |    5 +++++
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    7 -------
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    1 +
 drivers/net/wireless/rt2x00/rt2x00queue.c |   15 ++++++++++++++-
 4 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 19ca146..806ef60 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -334,6 +334,11 @@ struct rt2x00_intf {
 	u8 bssid[ETH_ALEN];
 
 	/*
+	 * beacon->skb must be protected with the mutex.
+	 */
+	struct mutex beacon_skb_mutex;
+
+	/*
 	 * Entry in the beacon queue which belongs to
 	 * this interface. Each interface has its own
 	 * dedicated beacon entry.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index e0348cc..b6676c6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -186,7 +186,6 @@ static void rt2x00lib_intf_scheduled(struct work_struct *work)
 static void rt2x00lib_beacondone_iter(void *data, u8 *mac,
 				      struct ieee80211_vif *vif)
 {
-	struct rt2x00_dev *rt2x00dev = data;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 
 	if (vif->type != NL80211_IFTYPE_AP &&
@@ -195,12 +194,6 @@ static void rt2x00lib_beacondone_iter(void *data, u8 *mac,
 	    vif->type != NL80211_IFTYPE_WDS)
 		return;
 
-	/*
-	 * Clean up the beacon skb.
-	 */
-	rt2x00queue_free_skb(rt2x00dev, intf->beacon->skb);
-	intf->beacon->skb = NULL;
-
 	spin_lock(&intf->lock);
 	intf->delayed_flags |= DELAYED_UPDATE_BEACON;
 	spin_unlock(&intf->lock);
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 4164fce..74451f9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -274,6 +274,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 
 	spin_lock_init(&intf->lock);
 	spin_lock_init(&intf->seqlock);
+	mutex_init(&intf->beacon_skb_mutex);
 	intf->beacon = entry;
 
 	if (conf->type == NL80211_IFTYPE_AP)
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index e67e339..06af823 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -503,14 +503,25 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
 
+	mutex_lock(&intf->beacon_skb_mutex);
+
+	/*
+	 * Clean up the beacon skb.
+	 */
+	rt2x00queue_free_skb(rt2x00dev, intf->beacon->skb);
+	intf->beacon->skb = NULL;
+
 	if (!enable_beacon) {
 		rt2x00dev->ops->lib->kill_tx_queue(rt2x00dev, QID_BEACON);
+		mutex_unlock(&intf->beacon_skb_mutex);
 		return 0;
 	}
 
 	intf->beacon->skb = ieee80211_beacon_get(rt2x00dev->hw, vif);
-	if (!intf->beacon->skb)
+	if (!intf->beacon->skb) {
+		mutex_unlock(&intf->beacon_skb_mutex);
 		return -ENOMEM;
+	}
 
 	/*
 	 * Copy all TX descriptor information into txdesc,
@@ -548,6 +559,8 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->ops->lib->write_beacon(intf->beacon);
 	rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, QID_BEACON);
 
+	mutex_unlock(&intf->beacon_skb_mutex);
+
 	return 0;
 }
 
-- 
1.6.3.3

