Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38012 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab0F2TvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:03 -0400
Received: by mail-wy0-f174.google.com with SMTP id 38so2999610wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:03 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/21] rt2x00: Rename driver write_tx_datadesc callback function.
Date: Tue, 29 Jun 2010 21:42:23 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292141.07070.IvDoorn@gmail.com> <201006292141.41708.IvDoorn@gmail.com>
In-Reply-To: <201006292141.41708.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292142.24144.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Now that the {usb,pci} specific write_tx_data functions are no longer
present we can rename the write_tx_datadesc callback function back to
its old name.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c   |    6 +++---
 drivers/net/wireless/rt2x00/rt2x00.h      |    6 ++----
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 +++---
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 894a43a..7bec15f 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -645,8 +645,8 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * TX descriptor initialization
  */
-static void rt2800pci_write_tx_datadesc(struct queue_entry* entry,
-					 struct txentry_desc *txdesc)
+static void rt2800pci_write_tx_data(struct queue_entry* entry,
+				    struct txentry_desc *txdesc)
 {
 	rt2800_write_txwi((__le32 *) entry->skb->data, txdesc);
 }
@@ -1044,7 +1044,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
 	.write_tx_desc		= rt2800pci_write_tx_desc,
-	.write_tx_datadesc	= rt2800pci_write_tx_datadesc,
+	.write_tx_data		= rt2800pci_write_tx_data,
 	.write_beacon		= rt2800_write_beacon,
 	.kick_tx_queue		= rt2800pci_kick_tx_queue,
 	.kill_tx_queue		= rt2800pci_kill_tx_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index e7acc6a..788b0e4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -550,10 +550,8 @@ struct rt2x00lib_ops {
 	void (*write_tx_desc) (struct rt2x00_dev *rt2x00dev,
 			       struct sk_buff *skb,
 			       struct txentry_desc *txdesc);
-	int (*write_tx_data) (struct queue_entry *entry,
-			      struct txentry_desc *txdesc);
-	void (*write_tx_datadesc) (struct queue_entry *entry,
-				   struct txentry_desc *txdesc);
+	void (*write_tx_data) (struct queue_entry *entry,
+			       struct txentry_desc *txdesc);
 	void (*write_beacon) (struct queue_entry *entry,
 			      struct txentry_desc *txdesc);
 	int (*get_tx_data_len) (struct queue_entry *entry);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index b9cc253..5097fe0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -430,10 +430,10 @@ static int rt2x00queue_write_tx_data(struct queue_entry *entry,
 	memset(entry->skb->data, 0, rt2x00dev->ops->extra_tx_headroom);
 
 	/*
-	 * Call the driver's write_tx_datadesc function, if it exists.
+	 * Call the driver's write_tx_data function, if it exists.
 	 */
-	if (rt2x00dev->ops->lib->write_tx_datadesc)
-		rt2x00dev->ops->lib->write_tx_datadesc(entry, txdesc);
+	if (rt2x00dev->ops->lib->write_tx_data)
+		rt2x00dev->ops->lib->write_tx_data(entry, txdesc);
 
 	/*
 	 * Map the skb to DMA.
-- 
1.6.6.1

