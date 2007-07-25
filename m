Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:54766 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362AbXGYUse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:48:34 -0400
Received: by ug-out-1314.google.com with SMTP id j3so420027ugf
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 13:48:33 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/11] [PATCH] rt2x00: Don't export unneeded symbols
Date: Wed, 25 Jul 2007 22:50:10 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707252250.10284.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From e26a10768af9be7b2dfe4cff4fd598647377b937 Mon Sep 17 00:00:00 2001
From: Adam Baker <linux@baker-net.org.uk>
Date: Sun, 22 Jul 2007 22:46:55 +0100
Subject: [PATCH 04/11] [PATCH] rt2x00: Don't export unneeded symbols

The methods rt2x00lib_uninitialize and rt2x00usb_beacondone aren't used
outside the files that define them. Make them static and move them earlier in
the file so they are defined before first use.

This fixes the only complaints "make namespacecheck" has with the rt2x00
drivers.

Signed-off-by: Adam Baker <linux@baker-net.org.uk>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c |   41 ++++++++-------
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.h |    1 -
 drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c |   60 +++++++++++-----------
 drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h |    1 -
 4 files changed, 51 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
index f4fedeb..b8c3f7b 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
@@ -749,6 +749,27 @@ static void rt2x00lib_free_ring_entries(struct rt2x00_dev *rt2x00dev)
 	}
 }
 
+static void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
+{
+	if (!__test_and_clear_bit(DEVICE_INITIALIZED, &rt2x00dev->flags))
+		return;
+
+	/*
+	 * Unregister rfkill.
+	 */
+	rt2x00lib_unregister_rfkill(rt2x00dev);
+
+	/*
+	 * Allow the HW to uninitialize.
+	 */
+	rt2x00dev->ops->lib->uninitialize(rt2x00dev);
+
+	/*
+	 * Free allocated ring entries.
+	 */
+	rt2x00lib_free_ring_entries(rt2x00dev);
+}
+
 int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 {
 	int status;
@@ -792,26 +813,6 @@ exit:
 	return status;
 }
 
-void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
-{
-	if (!__test_and_clear_bit(DEVICE_INITIALIZED, &rt2x00dev->flags))
-		return;
-
-	/*
-	 * Unregister rfkill.
-	 */
-	rt2x00lib_unregister_rfkill(rt2x00dev);
-
-	/*
-	 * Allow the HW to uninitialize.
-	 */
-	rt2x00dev->ops->lib->uninitialize(rt2x00dev);
-
-	/*
-	 * Free allocated ring entries.
-	 */
-	rt2x00lib_free_ring_entries(rt2x00dev);
-}
 
 /*
  * driver allocation handlers.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.h
index ee0bbfe..c6feee3 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.h
@@ -43,7 +43,6 @@ void rt2x00lib_toggle_rx(struct rt2x00_dev *rt2x00dev, int enable);
  * Initialization/uninitialization handlers.
  */
 int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev);
-void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev);
 
 /*
  * Config handlers.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c
index 02f8062..0fb2f04 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.c
@@ -72,6 +72,36 @@ EXPORT_SYMBOL_GPL(rt2x00usb_vendor_request);
 /*
  * Beacon handlers.
  */
+
+static void rt2x00usb_beacondone(struct urb *urb)
+{
+	struct data_entry *entry = (struct data_entry*)urb->context;
+	struct data_ring *ring = entry->ring;
+
+	if (!test_bit(DEVICE_ENABLED_RADIO, &ring->rt2x00dev->flags))
+		return;
+
+	/*
+	 * Check if this was the guardian beacon,
+	 * if that was the case we need to send the real beacon now.
+	 * Otherwise we should free the sk_buffer, the device
+	 * should be doing the rest of the work now.
+	 */
+	if (ring->index == 1) {
+		rt2x00_ring_index_done_inc(ring);
+		entry = rt2x00_get_data_entry(ring);
+		usb_submit_urb(entry->priv, GFP_ATOMIC);
+		rt2x00_ring_index_inc(ring);
+	} else if (ring->index_done == 1) {
+		entry = rt2x00_get_data_entry_done(ring);
+		if (entry->skb) {
+			dev_kfree_skb(entry->skb);
+			entry->skb = NULL;
+		}
+		rt2x00_ring_index_done_inc(ring);
+	}
+}
+
 int rt2x00usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_tx_control *control)
 {
@@ -157,36 +187,6 @@ int rt2x00usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_beacon_update);
 
-void rt2x00usb_beacondone(struct urb *urb)
-{
-	struct data_entry *entry = (struct data_entry*)urb->context;
-	struct data_ring *ring = entry->ring;
-
-	if (!test_bit(DEVICE_ENABLED_RADIO, &ring->rt2x00dev->flags))
-		return;
-
-	/*
-	 * Check if this was the guardian beacon,
-	 * if that was the case we need to send the real beacon now.
-	 * Otherwise we should free the sk_buffer, the device
-	 * should be doing the rest of the work now.
-	 */
-	if (ring->index == 1) {
-		rt2x00_ring_index_done_inc(ring);
-		entry = rt2x00_get_data_entry(ring);
-		usb_submit_urb(entry->priv, GFP_ATOMIC);
-		rt2x00_ring_index_inc(ring);
-	} else if (ring->index_done == 1) {
-		entry = rt2x00_get_data_entry_done(ring);
-		if (entry->skb) {
-			dev_kfree_skb(entry->skb);
-			entry->skb = NULL;
-		}
-		rt2x00_ring_index_done_inc(ring);
-	}
-}
-EXPORT_SYMBOL_GPL(rt2x00usb_beacondone);
-
 /*
  * TX data handlers.
  */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h
index 91627f2..c59d5db 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00usb.h
@@ -103,7 +103,6 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev);
  */
 int rt2x00usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_tx_control *control);
-void rt2x00usb_beacondone(struct urb *urb);
 
 /*
  * TX data handlers.
-- 
1.5.2.2

