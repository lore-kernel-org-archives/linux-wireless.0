Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:4926 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756660Ab0EMJhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 05:37:04 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 09/10] rt2x00: Reverse calling order of bus write_tx_desc and driver write_tx_desc.
Date: Thu, 13 May 2010 11:36:57 +0200
Message-Id: <1273743418-28383-10-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
References: <1273743418-28383-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For rt2800 reverse the calling order of rt2x00pci_write_data and
rt2800pci_write_data. Currently rt2800pci_write_data calls rt2x00pci_write_data
as there can be only 1 driver callback function specified by the driver.
Reverse this calling order by introducing a new driver callback function,
called write_tx_datadesc, which is called from the bus-specific write_tx_data
functions.
Preparation for futher cleanups in the skb data handling of rt2x00.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   15 ++++-----------
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 ++
 drivers/net/wireless/rt2x00/rt2x00pci.c |    6 ++++++
 drivers/net/wireless/rt2x00/rt2x00usb.c |    6 ++++++
 4 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 88dba7f..72e4f29 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -613,18 +613,10 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * TX descriptor initialization
  */
-static int rt2800pci_write_tx_data(struct queue_entry* entry,
-				   struct txentry_desc *txdesc)
+static void rt2800pci_write_tx_datadesc(struct queue_entry* entry,
+					 struct txentry_desc *txdesc)
 {
-	int ret;
-
-	ret = rt2x00pci_write_tx_data(entry, txdesc);
-	if (ret)
-		return ret;
-
 	rt2800_write_txwi(entry->skb, txdesc);
-
-	return 0;
 }
 
 
@@ -1079,7 +1071,8 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
 	.write_tx_desc		= rt2800pci_write_tx_desc,
-	.write_tx_data		= rt2800pci_write_tx_data,
+	.write_tx_data		= rt2x00pci_write_tx_data,
+	.write_tx_datadesc	= rt2800pci_write_tx_datadesc,
 	.write_beacon		= rt2800pci_write_beacon,
 	.kick_tx_queue		= rt2800pci_kick_tx_queue,
 	.kill_tx_queue		= rt2800pci_kill_tx_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 1329f6c..d27127a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -551,6 +551,8 @@ struct rt2x00lib_ops {
 			       struct txentry_desc *txdesc);
 	int (*write_tx_data) (struct queue_entry *entry,
 			      struct txentry_desc *txdesc);
+	void (*write_tx_datadesc) (struct queue_entry *entry,
+				   struct txentry_desc *txdesc);
 	void (*write_beacon) (struct queue_entry *entry,
 			      struct txentry_desc *txdesc);
 	int (*get_tx_data_len) (struct queue_entry *entry);
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index ff80ef7..714c982 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -80,6 +80,12 @@ int rt2x00pci_write_tx_data(struct queue_entry *entry,
 		return -EINVAL;
 	}
 
+	/*
+	 * Call the driver's write_tx_datadesc function, if it exists.
+	 */
+	if (rt2x00dev->ops->lib->write_tx_datadesc)
+		rt2x00dev->ops->lib->write_tx_datadesc(entry, txdesc);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_write_tx_data);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index a4f0551..bcc9483 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -247,6 +247,12 @@ int rt2x00usb_write_tx_data(struct queue_entry *entry,
 	 */
 	skb_pull(entry->skb, entry->queue->desc_size);
 
+	/*
+	 * Call the driver's write_tx_datadesc function, if it exists.
+	 */
+	if (rt2x00dev->ops->lib->write_tx_datadesc)
+		rt2x00dev->ops->lib->write_tx_datadesc(entry, txdesc);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_write_tx_data);
-- 
1.7.1

