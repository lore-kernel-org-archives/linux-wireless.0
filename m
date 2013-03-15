Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:63847 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3COI7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 04:59:13 -0400
Received: by mail-bk0-f53.google.com with SMTP id j10so1394626bkw.26
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2013 01:59:10 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linville@tuxdriver.com
Cc: IvDoorn@gmail.com, gwingerde@gmail.com, stf_xl@wp.pl,
	linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/2] rt2x00: Fix tx status reporting for reordered frames in rt2800pci
Date: Fri, 15 Mar 2013 09:57:57 +0100
Message-Id: <1363337877-20986-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20130315_095916_623870_737D0821)
In-Reply-To: <1363337877-20986-1-git-send-email-helmut.schaa@googlemail.com>
References: <1363337877-20986-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800 hardware sometimes reorders tx frames when transmitting to
multiple BA enabled STAs concurrently.

For example a tx queue
	[ STA1 | STA2 | STA1 | STA2 ]
can result in the tx status reports
	[ STA1 | STA1 | STA2 | STA2 ]
when the hw decides to put the frames for STA1 in one AMPDU.

To mitigate this effect associate the currently processed tx status
to the first frame in the tx queue with a matching wcid.

This patch fixes several problems related to incorrect tx status
reporting. Furthermore the tx rate selection is much more stable when
communicating with multiple STAs.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c   |  111 ++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00queue.h |    4 ++
 2 files changed, 112 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 48a01aa..da179ae 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -742,10 +742,90 @@ static void rt2800pci_wakeup(struct rt2x00_dev *rt2x00dev)
 	rt2800_config(rt2x00dev, &libconf, IEEE80211_CONF_CHANGE_PS);
 }
 
+static bool rt2800pci_txdone_entry_check(struct queue_entry *entry, u32 status)
+{
+	__le32 *txwi;
+	u32 word;
+	int wcid, tx_wcid;
+
+	wcid = rt2x00_get_field32(status, TX_STA_FIFO_WCID);
+
+	txwi = rt2800_drv_get_txwi(entry);
+	rt2x00_desc_read(txwi, 1, &word);
+	tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
+
+	return (tx_wcid == wcid);
+}
+
+static bool rt2800pci_txdone_find_entry(struct queue_entry *entry, void *data)
+{
+	u32 status = *(u32 *)data;
+
+	/*
+	 * rt2800pci hardware might reorder frames when exchanging traffic
+	 * with multiple BA enabled STAs.
+	 *
+	 * For example, a tx queue
+	 *    [ STA1 | STA2 | STA1 | STA2 ]
+	 * can result in tx status reports
+	 *    [ STA1 | STA1 | STA2 | STA2 ]
+	 * when the hw decides to aggregate the frames for STA1 into one AMPDU.
+	 *
+	 * To mitigate this effect, associate the tx status to the first frame
+	 * in the tx queue with a matching wcid.
+	 */
+	if (rt2800pci_txdone_entry_check(entry, status) &&
+	    !test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
+		/*
+		 * Got a matching frame, associate the tx status with
+		 * the frame
+		 */
+		entry->status = status;
+		set_bit(ENTRY_DATA_STATUS_SET, &entry->flags);
+		return true;
+	}
+
+	/* Check the next frame */
+	return false;
+}
+
+static bool rt2800pci_txdone_match_first(struct queue_entry *entry, void *data)
+{
+	u32 status = *(u32 *)data;
+
+	/*
+	 * Find the first frame without tx status and assign this status to it
+	 * regardless if it matches or not.
+	 */
+	if (!test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
+		/*
+		 * Got a matching frame, associate the tx status with
+		 * the frame
+		 */
+		entry->status = status;
+		set_bit(ENTRY_DATA_STATUS_SET, &entry->flags);
+		return true;
+	}
+
+	/* Check the next frame */
+	return false;
+}
+static bool rt2800pci_txdone_release_entries(struct queue_entry *entry,
+					     void *data)
+{
+	if (test_bit(ENTRY_DATA_STATUS_SET, &entry->flags)) {
+		rt2800_txdone_entry(entry, entry->status,
+				    rt2800pci_get_txwi(entry));
+		return false;
+	}
+
+	/* No more frames to release */
+	return true;
+}
+
 static bool rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
-	struct queue_entry *entry;
 	u32 status;
 	u8 qid;
 	int max_tx_done = 16;
@@ -783,8 +863,33 @@ static bool rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 			break;
 		}
 
-		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-		rt2800_txdone_entry(entry, status, rt2800pci_get_txwi(entry));
+		/*
+		 * Let's associate this tx status with the first
+		 * matching frame.
+		 */
+		if (!rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
+						Q_INDEX, &status,
+						rt2800pci_txdone_find_entry)) {
+			/*
+			 * We cannot match the tx status to any frame, so just
+			 * use the first one.
+			 */
+			if (!rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
+							Q_INDEX, &status,
+							rt2800pci_txdone_match_first)) {
+				WARNING(rt2x00dev, "No frame found for TX "
+						   "status on queue %u, dropping\n",
+						   qid);
+				break;
+			}
+		}
+
+		/*
+		 * Release all frames with a valid tx status.
+		 */
+		rt2x00queue_for_each_entry(queue, Q_INDEX_DONE,
+					   Q_INDEX, NULL,
+					   rt2800pci_txdone_release_entries);
 
 		if (--max_tx_done == 0)
 			break;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 5f1392c..3d01371 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -359,6 +359,7 @@ enum queue_entry_flags {
 	ENTRY_DATA_PENDING,
 	ENTRY_DATA_IO_FAILED,
 	ENTRY_DATA_STATUS_PENDING,
+	ENTRY_DATA_STATUS_SET,
 };
 
 /**
@@ -372,6 +373,7 @@ enum queue_entry_flags {
  * @entry_idx: The entry index number.
  * @priv_data: Private data belonging to this queue entry. The pointer
  *	points to data specific to a particular driver and queue type.
+ * @status: Device specific status
  */
 struct queue_entry {
 	unsigned long flags;
@@ -383,6 +385,8 @@ struct queue_entry {
 
 	unsigned int entry_idx;
 
+	u32 status;
+
 	void *priv_data;
 };
 
-- 
1.7.10.4

