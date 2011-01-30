Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41674 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1A3MYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:25 -0500
Received: by eye27 with SMTP id 27so2146783eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:23 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/21] rt2x00: Introduce beacon_update_locked that requires caller locking
Date: Sun, 30 Jan 2011 13:16:28 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com>
In-Reply-To: <201101301316.04044.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301316.29086.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Introduce a beacon_update_locked function that does not acquire the
according beacon mutex to allow beacon updates from atomic context. The
caller has to take care of synchronization.

No functional changes. Just preparation for beacon updates from tasklet
context.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00lib.h   |   12 +++++++++++-
 drivers/net/wireless/rt2x00/rt2x00queue.c |   24 ++++++++++++++++--------
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 6c6a8f1..2d94cba 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -157,7 +157,8 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 			       bool local);
 
 /**
- * rt2x00queue_update_beacon - Send new beacon from mac80211 to hardware
+ * rt2x00queue_update_beacon - Send new beacon from mac80211
+ *	to hardware. Handles locking by itself (mutex).
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  * @vif: Interface for which the beacon should be updated.
  */
@@ -165,6 +166,15 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 			      struct ieee80211_vif *vif);
 
 /**
+ * rt2x00queue_update_beacon_locked - Send new beacon from mac80211
+ *	to hardware. Caller needs to ensure locking.
+ * @rt2x00dev: Pointer to &struct rt2x00_dev.
+ * @vif: Interface for which the beacon should be updated.
+ */
+int rt2x00queue_update_beacon_locked(struct rt2x00_dev *rt2x00dev,
+				     struct ieee80211_vif *vif);
+
+/**
  * rt2x00queue_clear_beacon - Clear beacon in hardware
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  * @vif: Interface for which the beacon should be updated.
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 24bcdb4..7d7fbe0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -593,8 +593,8 @@ int rt2x00queue_clear_beacon(struct rt2x00_dev *rt2x00dev,
 	return 0;
 }
 
-int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
-			      struct ieee80211_vif *vif)
+int rt2x00queue_update_beacon_locked(struct rt2x00_dev *rt2x00dev,
+				     struct ieee80211_vif *vif)
 {
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 	struct skb_frame_desc *skbdesc;
@@ -603,18 +603,14 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
 
-	mutex_lock(&intf->beacon_skb_mutex);
-
 	/*
 	 * Clean up the beacon skb.
 	 */
 	rt2x00queue_free_skb(intf->beacon);
 
 	intf->beacon->skb = ieee80211_beacon_get(rt2x00dev->hw, vif);
-	if (!intf->beacon->skb) {
-		mutex_unlock(&intf->beacon_skb_mutex);
+	if (!intf->beacon->skb)
 		return -ENOMEM;
-	}
 
 	/*
 	 * Copy all TX descriptor information into txdesc,
@@ -635,9 +631,21 @@ int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00dev->ops->lib->write_beacon(intf->beacon, &txdesc);
 
+	return 0;
+
+}
+
+int rt2x00queue_update_beacon(struct rt2x00_dev *rt2x00dev,
+			      struct ieee80211_vif *vif)
+{
+	struct rt2x00_intf *intf = vif_to_intf(vif);
+	int ret;
+
+	mutex_lock(&intf->beacon_skb_mutex);
+	ret = rt2x00queue_update_beacon_locked(rt2x00dev, vif);
 	mutex_unlock(&intf->beacon_skb_mutex);
 
-	return 0;
+	return ret;
 }
 
 void rt2x00queue_for_each_entry(struct data_queue *queue,
-- 
1.7.2.3

