Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:1250 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010Ab0EKVvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 17:51:54 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 8/9] rt2x00: Reverse calling order of bus write_tx_desc and driver write_tx_desc.
Date: Tue, 11 May 2010 23:51:44 +0200
Message-Id: <1273614705-25118-9-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For rt2800 reverse the calling order of rt2x00pci_write_data and
rt2800pci_write_data. Currently rt2800pci_write_data calls rt2x00pci_write_data
as there can be only 1 driver callback function specified by the driver.
Reverse this calling order by introducing a new driver callback function,
called add_tx_datadesc, which is called from the bus-specific write_tx_data
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
index fcca30c..bbd6481 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -614,18 +614,10 @@ static int rt2800pci_set_device_state(struct rt2x00_dev *rt2x00dev,
 /*
  * TX descriptor initialization
  */
-static int rt2800pci_write_tx_data(struct queue_entry* entry,
-				   struct txentry_desc *txdesc)
+static void rt2800pci_add_tx_datadesc(struct queue_entry* entry,
+				      struct txentry_desc *txdesc)
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
 
 
@@ -1080,7 +1072,8 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.reset_tuner		= rt2800_reset_tuner,
 	.link_tuner		= rt2800_link_tuner,
 	.write_tx_desc		= rt2800pci_write_tx_desc,
-	.write_tx_data		= rt2800pci_write_tx_data,
+	.write_tx_data		= rt2x00pci_write_tx_data,
+	.add_tx_datadesc	= rt2800pci_add_tx_datadesc,
 	.write_beacon		= rt2800pci_write_beacon,
 	.kick_tx_queue		= rt2800pci_kick_tx_queue,
 	.kill_tx_queue		= rt2800pci_kill_tx_queue,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 6c1ff4c..5f2531f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -551,6 +551,8 @@ struct rt2x00lib_ops {
 			       struct txentry_desc *txdesc);
 	int (*write_tx_data) (struct queue_entry *entry,
 			      struct txentry_desc *txdesc);
+	void (*add_tx_datadesc) (struct queue_entry *entry,
+				 struct txentry_desc *txdesc);
 	void (*write_beacon) (struct queue_entry *entry,
 			      struct txentry_desc *txdesc);
 	int (*get_tx_data_len) (struct queue_entry *entry);
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index ff80ef7..cd61d6f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -80,6 +80,12 @@ int rt2x00pci_write_tx_data(struct queue_entry *entry,
 		return -EINVAL;
 	}
 
+	/*
+	 * Call the driver's add_tx_datadesc function, if it exists.
+	 */
+	if (rt2x00dev->ops->lib->add_tx_datadesc)
+		rt2x00dev->ops->lib->add_tx_datadesc(entry, txdesc);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_write_tx_data);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index a4f0551..e731389 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -247,6 +247,12 @@ int rt2x00usb_write_tx_data(struct queue_entry *entry,
 	 */
 	skb_pull(entry->skb, entry->queue->desc_size);
 
+	/*
+	 * Call the driver's add_tx_datadesc function, if it exists.
+	 */
+	if (rt2x00dev->ops->lib->add_tx_datadesc)
+		rt2x00dev->ops->lib->add_tx_datadesc(entry, txdesc);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_write_tx_data);
-- 
1.7.1

