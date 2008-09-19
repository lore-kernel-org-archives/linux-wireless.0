Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:62897 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbYISAWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 20:22:33 -0400
Received: by rv-out-0506.google.com with SMTP id k40so162087rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 17:22:32 -0700 (PDT)
Message-ID: <48D2F0C6.9080409@gmail.com> (sfid-20080919_022240_481472_0B8DE4DC)
Date: Thu, 18 Sep 2008 17:22:30 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	daikerjohn@gmail.com
Subject: Resend: [PATCH] rt2x00: Consolidate definition of CSR_OFFSET
Content-Type: multipart/mixed;
 boundary="------------020503050408080605020102"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020503050408080605020102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Resend: Premature send to Linville only... this version copies 
linux-wireless and rt2400-devel.

This consolidates the definition of CSR_OFFSET when 
CONFIG_RT2X00_LIB_DEBUG is also set.
The original definition appeared in 5 files, but was moved to a common
.h file instead.

Compile-tested only, as I don't have any rt2x00 HW in a working machine.

Signed-off-by: John Daiker <daikerjohn@gmail.com>

---



--------------020503050408080605020102
Content-Type: text/x-diff;
 name="rt2x00.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rt2x00.patch"

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 08cb9ee..ac4ae00 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -188,7 +188,6 @@ static void rt2400pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
 static void rt2400pci_read_csr(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, u32 *data)
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index ef42cc0..2efcfd3 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -188,7 +188,6 @@ static void rt2500pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
 static void rt2500pci_read_csr(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, u32 *data)
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index d3bf7bb..6883632 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -245,7 +245,6 @@ rf_write:
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u16)) )
 
 static void rt2500usb_read_csr(struct rt2x00_dev *rt2x00dev,
 			       const unsigned int word, u32 *data)
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 1359a37..3d0ad2b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -67,6 +67,10 @@
 	do { } while (0)
 #endif /* CONFIG_RT2X00_DEBUG */
 
+#ifdef CONFIG_RT2X00_LIB_DEBUGFS
+#define CSR_OFFSET(__word)     (CSR_REG_BASE + ((__word) * sizeof(u32)))
+#endif /* CONFIG_RT2X00_LIB_DEBUGFS */
+
 /*
  * Various debug levels.
  * The debug levels PANIC and ERROR both indicate serious problems,
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index b7f4fe8..c0ec25a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -552,7 +552,7 @@ void rt2x00queue_index_inc(struct data_queue *queue, enum queue_index index)
 		queue->length++;
 	} else if (index == Q_INDEX_DONE) {
 		queue->length--;
-		queue->count ++;
+		queue->count++;
 	}
 
 	spin_unlock_irqrestore(&queue->lock, irqflags);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 2c36b91..2ce3f2c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -228,7 +228,6 @@ static void rt61pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
 static void rt61pci_read_csr(struct rt2x00_dev *rt2x00dev,
 			     const unsigned int word, u32 *data)
@@ -1934,7 +1933,7 @@ static int rt61pci_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 }
 
 static void rt61pci_fill_rxdone(struct queue_entry *entry,
-			        struct rxdone_entry_desc *rxdesc)
+				struct rxdone_entry_desc *rxdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 27dde3e..28a5cdf 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -249,7 +249,6 @@ rf_write:
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
-#define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
 static void rt73usb_read_csr(struct rt2x00_dev *rt2x00dev,
 			     const unsigned int word, u32 *data)
@@ -1685,7 +1684,7 @@ static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 }
 
 static void rt73usb_fill_rxdone(struct queue_entry *entry,
-			        struct rxdone_entry_desc *rxdesc)
+				struct rxdone_entry_desc *rxdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);


--------------020503050408080605020102--
