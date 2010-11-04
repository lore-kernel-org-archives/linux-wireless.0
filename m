Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36386 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0KDTnw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:43:52 -0400
Received: by mail-ew0-f46.google.com with SMTP id 7so1281902ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:43:51 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 09/13] rt2x00: Implement flush callback
Date: Thu, 4 Nov 2010 20:40:11 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
References: <201011042037.00178.IvDoorn@gmail.com> <201011042039.24768.IvDoorn@gmail.com> <201011042039.49521.IvDoorn@gmail.com>
In-Reply-To: <201011042039.49521.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011042040.12419.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement a basic flush callback function, which simply loops
over all TX queues and waits until all frames have been transmitted
and the status reports have been gathered.

At this moment we don't support dropping any frames during the
flush, but mac80211 will only send 'false' for this argument anyway,
so this is not important at this time.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c |    1 +
 drivers/net/wireless/rt2x00/rt2500usb.c |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 drivers/net/wireless/rt2x00/rt2x00mac.c |   38 +++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt61pci.c   |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c   |    1 +
 9 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index c94aa1e..bc1ae1e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1612,6 +1612,7 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.get_tsf		= rt2400pci_get_tsf,
 	.tx_last_beacon		= rt2400pci_tx_last_beacon,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
+	.flush			= rt2x00mac_flush,
 };
 
 static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index b69e55f..5475415 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1909,6 +1909,7 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.get_tsf		= rt2500pci_get_tsf,
 	.tx_last_beacon		= rt2500pci_tx_last_beacon,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
+	.flush			= rt2x00mac_flush,
 };
 
 static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index f20ab79..478c4f1 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1801,6 +1801,7 @@ static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2x00mac_conf_tx,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
+	.flush			= rt2x00mac_flush,
 };
 
 static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 2c12b59..6dc61b7 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -943,6 +943,7 @@ static const struct ieee80211_ops rt2800pci_mac80211_ops = {
 	.get_tsf		= rt2800_get_tsf,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.ampdu_action		= rt2800_ampdu_action,
+	.flush			= rt2x00mac_flush,
 };
 
 static const struct rt2800_ops rt2800pci_rt2800_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 3f44131..04dfedc 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -508,6 +508,7 @@ static const struct ieee80211_ops rt2800usb_mac80211_ops = {
 	.get_tsf		= rt2800_get_tsf,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.ampdu_action		= rt2800_ampdu_action,
+	.flush			= rt2x00mac_flush,
 };
 
 static const struct rt2800_ops rt2800usb_rt2800_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 94fe589..42bd3a9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1133,6 +1133,7 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		      const struct ieee80211_tx_queue_params *params);
 void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw);
+void rt2x00mac_flush(struct ieee80211_hw *hw, bool drop);
 
 /*
  * Driver allocation handlers.
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index c3c206a..283a8d9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -719,3 +719,41 @@ void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw)
 	wiphy_rfkill_set_hw_state(hw->wiphy, !active);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_rfkill_poll);
+
+void rt2x00mac_flush(struct ieee80211_hw *hw, bool drop)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct data_queue *queue;
+	unsigned int i = 0;
+
+	ieee80211_stop_queues(hw);
+
+	/*
+	 * Run over all queues to kick them, this will force
+	 * any pending frames to be transmitted.
+	 */
+	tx_queue_for_each(rt2x00dev, queue) {
+		rt2x00dev->ops->lib->kick_tx_queue(queue);
+	}
+
+	/**
+	 * All queues have been kicked, now wait for each queue
+	 * to become empty. With a bit of luck, we only have to wait
+	 * for the first queue to become empty, because while waiting
+	 * for the that queue, the other queues will have transmitted
+	 * all their frames as well (since they were already kicked).
+	 */
+	tx_queue_for_each(rt2x00dev, queue) {
+		for (i = 0; i < 10; i++) {
+			if (rt2x00queue_empty(queue))
+				break;
+			msleep(100);
+		}
+
+		if (!rt2x00queue_empty(queue))
+			WARNING(rt2x00dev, "Failed to flush queue %d", queue->qid);
+	}
+
+	ieee80211_wake_queues(hw);
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_flush);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index fba9ee1..f01bff7 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2824,6 +2824,7 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.conf_tx		= rt61pci_conf_tx,
 	.get_tsf		= rt61pci_get_tsf,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
+	.flush			= rt2x00mac_flush,
 };
 
 static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 3c86f00..dcb9211 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2264,6 +2264,7 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.conf_tx		= rt73usb_conf_tx,
 	.get_tsf		= rt73usb_get_tsf,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
+	.flush			= rt2x00mac_flush,
 };
 
 static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
-- 
1.7.2.3

