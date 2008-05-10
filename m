Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:20731 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYEJMKE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:04 -0400
Received: by nf-out-0910.google.com with SMTP id d3so883151nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:02 -0700 (PDT)
To: linville@tuxdriver.com
Subject: [PATCH 07/16] rt2x00: Fix TX status reporting
Date: Sat, 10 May 2008 13:42:06 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101337.14536.IvDoorn@gmail.com>
In-Reply-To: <200805101337.14536.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805101342.07044.IvDoorn@gmail.com> (sfid-20080510_141019_562629_3EB5F33A)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tx_status enumeration was broken since the introduction
of rt61pci. That driver uses different values to report the
status of the tx action.
This would lead to frames that were reported as success but
actually failed to be send out, or frames that were neither
successfull or failure which were reported as failure.

Fix this by change the TX status reporting and more explicitely
check for failure or success. Note that a third possibility is
added "unknown". Not all hardware (USB) can report the actual
TX status, for rt61pci some frames will receive this status
because the TXdone handler is never called for those frames.
This unknown will now be handled as neither success or failure,
so we no longer increment the failure counter while this conclusion
could not be determined from the real status of the frame.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |   13 ++++++++++++-
 drivers/net/wireless/rt2x00/rt2500pci.c   |   13 ++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c   |   24 +++++++++++-------------
 drivers/net/wireless/rt2x00/rt2x00queue.h |   20 ++++++++++++++++++--
 drivers/net/wireless/rt2x00/rt2x00reg.h   |   11 -----------
 drivers/net/wireless/rt2x00/rt2x00usb.c   |   11 ++++++++++-
 drivers/net/wireless/rt2x00/rt61pci.c     |   15 +++++++++++++--
 7 files changed, 76 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 247fbbf..15cf224 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1137,7 +1137,18 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * Obtain the status about this packet.
 		 */
-		txdesc.status = rt2x00_get_field32(word, TXD_W0_RESULT);
+		txdesc.flags = 0;
+		switch (rt2x00_get_field32(word, TXD_W0_RESULT)) {
+		case 0: /* Success */
+		case 1: /* Success with retry */
+			__set_bit(TXDONE_SUCCESS, &txdesc.flags);
+			break;
+		case 2: /* Failure, excessive retries */
+			__set_bit(TXDONE_EXCESSIVE_RETRY, &txdesc.flags);
+			/* Don't break, this is a failed frame! */
+		default: /* Failure */
+			__set_bit(TXDONE_FAILURE, &txdesc.flags);
+		}
 		txdesc.retry = rt2x00_get_field32(word, TXD_W0_RETRY_COUNT);
 
 		rt2x00pci_txdone(rt2x00dev, entry, &txdesc);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 0d53c75..234b5b7 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1292,7 +1292,18 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * Obtain the status about this packet.
 		 */
-		txdesc.status = rt2x00_get_field32(word, TXD_W0_RESULT);
+		txdesc.flags = 0;
+		switch (rt2x00_get_field32(word, TXD_W0_RESULT)) {
+		case 0: /* Success */
+		case 1: /* Success with retry */
+			__set_bit(TXDONE_SUCCESS, &txdesc.flags);
+			break;
+		case 2: /* Failure, excessive retries */
+			__set_bit(TXDONE_EXCESSIVE_RETRY, &txdesc.flags);
+			/* Don't break, this is a failed frame! */
+		default: /* Failure */
+			__set_bit(TXDONE_FAILURE, &txdesc.flags);
+		}
 		txdesc.retry = rt2x00_get_field32(word, TXD_W0_RETRY_COUNT);
 
 		rt2x00pci_txdone(rt2x00dev, entry, &txdesc);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 1e7fefd..acc22df 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -496,38 +496,36 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct skb_frame_desc *skbdesc;
 	struct ieee80211_tx_status tx_status;
-	int success = !!(txdesc->status == TX_SUCCESS ||
-			 txdesc->status == TX_SUCCESS_RETRY);
-	int fail = !!(txdesc->status == TX_FAIL_RETRY ||
-		      txdesc->status == TX_FAIL_INVALID ||
-		      txdesc->status == TX_FAIL_OTHER);
 
 	/*
 	 * Update TX statistics.
 	 */
-	rt2x00dev->link.qual.tx_success += success;
-	rt2x00dev->link.qual.tx_failed += txdesc->retry + fail;
+	rt2x00dev->link.qual.tx_success +=
+	    test_bit(TXDONE_SUCCESS, &txdesc->flags);
+	rt2x00dev->link.qual.tx_failed +=
+	    txdesc->retry + !!test_bit(TXDONE_FAILURE, &txdesc->flags);
 
 	/*
 	 * Initialize TX status
 	 */
 	tx_status.flags = 0;
 	tx_status.ack_signal = 0;
-	tx_status.excessive_retries = (txdesc->status == TX_FAIL_RETRY);
+	tx_status.excessive_retries =
+	    test_bit(TXDONE_EXCESSIVE_RETRY, &txdesc->flags);
 	tx_status.retry_count = txdesc->retry;
 	memcpy(&tx_status.control, txdesc->control, sizeof(*txdesc->control));
 
 	if (!(tx_status.control.flags & IEEE80211_TXCTL_NO_ACK)) {
-		if (success)
+		if (test_bit(TXDONE_SUCCESS, &txdesc->flags))
 			tx_status.flags |= IEEE80211_TX_STATUS_ACK;
-		else
+		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
 			rt2x00dev->low_level_stats.dot11ACKFailureCount++;
 	}
 
 	if (tx_status.control.flags & IEEE80211_TXCTL_USE_RTS_CTS) {
-		if (success)
+		if (test_bit(TXDONE_SUCCESS, &txdesc->flags))
 			rt2x00dev->low_level_stats.dot11RTSSuccessCount++;
-		else
+		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
 			rt2x00dev->low_level_stats.dot11RTSFailureCount++;
 	}
 
@@ -546,7 +544,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 		ieee80211_tx_status_irqsafe(rt2x00dev->hw,
 					    entry->skb, &tx_status);
 	else
-		dev_kfree_skb(entry->skb);
+		dev_kfree_skb_irq(entry->skb);
 	entry->skb = NULL;
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index c3493ed..f361f78 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -168,18 +168,34 @@ struct rxdone_entry_desc {
 };
 
 /**
+ * enum txdone_entry_desc_flags: Flags for &struct txdone_entry_desc
+ *
+ * @TXDONE_UNKNOWN: Hardware could not determine success of transmission.
+ * @TXDONE_SUCCESS: Frame was successfully send
+ * @TXDONE_FAILURE: Frame was not successfully send
+ * @TXDONE_EXCESSIVE_RETRY: In addition to &TXDONE_FAILURE, the
+ *	frame transmission failed due to excessive retries.
+ */
+enum txdone_entry_desc_flags {
+	TXDONE_UNKNOWN = 1 << 0,
+	TXDONE_SUCCESS = 1 << 1,
+	TXDONE_FAILURE = 1 << 2,
+	TXDONE_EXCESSIVE_RETRY = 1 << 3,
+};
+
+/**
  * struct txdone_entry_desc: TX done entry descriptor
  *
  * Summary of information that has been read from the TX frame descriptor
  * after the device is done with transmission.
  *
  * @control: Control structure which was used to transmit the frame.
- * @status: TX status (See &enum tx_status).
+ * @flags: TX done flags (See &enum txdone_entry_desc_flags).
  * @retry: Retry count.
  */
 struct txdone_entry_desc {
 	struct ieee80211_tx_control *control;
-	int status;
+	unsigned long flags;
 	int retry;
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 0325bed..3f255df 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -27,17 +27,6 @@
 #define RT2X00REG_H
 
 /*
- * TX result flags.
- */
-enum tx_status {
-	TX_SUCCESS = 0,
-	TX_SUCCESS_RETRY = 1,
-	TX_FAIL_RETRY = 2,
-	TX_FAIL_INVALID = 3,
-	TX_FAIL_OTHER = 4,
-};
-
-/*
  * Antenna values
  */
 enum antenna {
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 98aafc2..caee65e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -147,8 +147,17 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 
 	/*
 	 * Obtain the status about this packet.
+	 * Note that when the status is 0 it does not mean the
+	 * frame was send out correctly. It only means the frame
+	 * was succesfully pushed to the hardware, we have no
+	 * way to determine the transmission status right now.
+	 * (Only indirectly by looking at the failed TX counters
+	 * in the register).
 	 */
-	txdesc.status = !urb->status ? TX_SUCCESS : TX_FAIL_RETRY;
+	if (!urb->status)
+		__set_bit(TXDONE_UNKNOWN, &txdesc.flags);
+	else
+		__set_bit(TXDONE_FAILURE, &txdesc.flags);
 	txdesc.retry = 0;
 	txdesc.control = &priv_tx->control;
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index b64f2f5..907e67b 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1764,7 +1764,8 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 				"TX status report missed for entry %d\n",
 				entry_done->entry_idx);
 
-			txdesc.status = TX_FAIL_OTHER;
+			txdesc.flags = 0;
+			__set_bit(TXDONE_UNKNOWN, &txdesc.flags);
 			txdesc.retry = 0;
 
 			rt2x00pci_txdone(rt2x00dev, entry_done, &txdesc);
@@ -1774,7 +1775,17 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 		/*
 		 * Obtain the status about this packet.
 		 */
-		txdesc.status = rt2x00_get_field32(reg, STA_CSR4_TX_RESULT);
+		txdesc.flags = 0;
+		switch (rt2x00_get_field32(reg, STA_CSR4_TX_RESULT)) {
+		case 0: /* Success, maybe with retry */
+			__set_bit(TXDONE_SUCCESS, &txdesc.flags);
+			break;
+		case 6: /* Failure, excessive retries */
+			__set_bit(TXDONE_EXCESSIVE_RETRY, &txdesc.flags);
+			/* Don't break, this is a failed frame! */
+		default: /* Failure */
+			__set_bit(TXDONE_FAILURE, &txdesc.flags);
+		}
 		txdesc.retry = rt2x00_get_field32(reg, STA_CSR4_RETRY_COUNT);
 
 		rt2x00pci_txdone(rt2x00dev, entry, &txdesc);
-- 
1.5.5.1

