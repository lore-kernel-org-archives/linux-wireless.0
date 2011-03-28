Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58041 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1C1Lgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 07:36:46 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so3686803wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 04:36:46 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/13] rt2x00: Limit rt2800pci txdone processing to 16 entries at once
Date: Mon, 28 Mar 2011 13:30:09 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103281329.45470.IvDoorn@gmail.com>
In-Reply-To: <201103281329.45470.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103281330.10560.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Instead of reporting an unlimited number of tx status reports to
mac80211 stop after 16 frames and reschedule the tx status tasklet.
This allows other tasklets to be run inbetween.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 4672dc9..d305514 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -717,12 +717,13 @@ static void rt2800pci_wakeup(struct rt2x00_dev *rt2x00dev)
 	rt2800_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
 }
 
-static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
+static bool rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 	struct queue_entry *entry;
 	u32 status;
 	u8 qid;
+	int max_tx_done = 16;
 
 	while (kfifo_get(&rt2x00dev->txstatus_fifo, &status)) {
 		qid = rt2x00_get_field32(status, TX_STA_FIFO_PID_QUEUE);
@@ -759,7 +760,12 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 
 		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 		rt2800_txdone_entry(entry, status);
+
+		if (--max_tx_done == 0)
+			break;
 	}
+
+	return !max_tx_done;
 }
 
 static void rt2800pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
@@ -780,7 +786,9 @@ static void rt2800pci_enable_interrupt(struct rt2x00_dev *rt2x00dev,
 
 static void rt2800pci_txstatus_tasklet(unsigned long data)
 {
-	rt2800pci_txdone((struct rt2x00_dev *)data);
+	struct rt2x00_dev *rt2x00dev = (struct rt2x00_dev *)data;
+	if (rt2800pci_txdone(rt2x00dev))
+		tasklet_schedule(&rt2x00dev->txstatus_tasklet);
 
 	/*
 	 * No need to enable the tx status interrupt here as we always
-- 
1.7.2.3

