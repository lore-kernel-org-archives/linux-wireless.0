Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:38996 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbYBJVx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:53:58 -0500
Received: by fk-out-0910.google.com with SMTP id z23so4239380fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:53:57 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 13/14] rt2x00: Kill guardian urb during disable_radio
Date: Sun, 10 Feb 2008 22:52:36 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102252.36990.IvDoorn@gmail.com> (sfid-20080210_215400_793078_A50500C8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the radio is being disabled we should also
kill the guardian urb which could still be pending
in the device.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 450043b..6cb4432 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -378,6 +378,7 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 {
 	struct queue_entry_priv_usb_rx *priv_rx;
 	struct queue_entry_priv_usb_tx *priv_tx;
+	struct queue_entry_priv_usb_bcn *priv_bcn;
 	struct data_queue *queue;
 	unsigned int i;
 
@@ -392,12 +393,28 @@ void rt2x00usb_disable_radio(struct rt2x00_dev *rt2x00dev)
 		usb_kill_urb(priv_rx->urb);
 	}
 
-	txall_queue_for_each(rt2x00dev, queue) {
+	tx_queue_for_each(rt2x00dev, queue) {
 		for (i = 0; i < queue->limit; i++) {
 			priv_tx = queue->entries[i].priv_data;
 			usb_kill_urb(priv_tx->urb);
 		}
 	}
+
+	for (i = 0; i < rt2x00dev->bcn->limit; i++) {
+		priv_bcn = rt2x00dev->bcn->entries[i].priv_data;
+		usb_kill_urb(priv_bcn->urb);
+
+		if (priv_bcn->guardian_urb)
+			usb_kill_urb(priv_bcn->guardian_urb);
+	}
+
+	if (!test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags))
+		return;
+
+	for (i = 0; i < rt2x00dev->bcn[1].limit; i++) {
+		priv_tx = rt2x00dev->bcn[1].entries[i].priv_data;
+		usb_kill_urb(priv_tx->urb);
+	}
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_disable_radio);
 
-- 
1.5.4

