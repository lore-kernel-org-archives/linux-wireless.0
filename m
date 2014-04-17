Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaDQJ1E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 05:27:04 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com
Subject: [PATCH 2/2] rt2x00: restore original beaconing state
Date: Thu, 17 Apr 2014 11:08:48 +0200
Message-Id: <1397725728-2786-2-git-send-email-sgruszka@redhat.com> (sfid-20140417_112713_191847_A3A5F2CC)
In-Reply-To: <1397725728-2786-1-git-send-email-sgruszka@redhat.com>
References: <1397725728-2786-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After changing local per interface beacon setting restore original
global beaconing state.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c | 15 +++++++--------
 drivers/net/wireless/rt2x00/rt61pci.c   | 10 +++++-----
 drivers/net/wireless/rt2x00/rt73usb.c   | 10 +++++-----
 3 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 41d4a81..c17fcf2 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1005,10 +1005,9 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 				   entry->skb->len + padding_len);
 
 	/*
-	 * Enable beaconing again.
+	 * Restore beaconing state.
 	 */
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
-	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, orig_reg);
 
 	/*
 	 * Clean up beacon skb.
@@ -1039,13 +1038,14 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
 void rt2800_clear_beacon(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	u32 reg;
+	u32 orig_reg, reg;
 
 	/*
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
-	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
+	rt2800_register_read(rt2x00dev, BCN_TIME_CFG, &orig_reg);
+	reg = orig_reg;
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
@@ -1055,10 +1055,9 @@ void rt2800_clear_beacon(struct queue_entry *entry)
 	rt2800_clear_beacon_register(rt2x00dev, entry->entry_idx);
 
 	/*
-	 * Enabled beaconing again.
+	 * Restore beaconing state.
 	 */
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 1);
-	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, orig_reg);
 }
 EXPORT_SYMBOL_GPL(rt2800_clear_beacon);
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 2440298..9048a9c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2031,13 +2031,14 @@ static void rt61pci_write_beacon(struct queue_entry *entry,
 static void rt61pci_clear_beacon(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
-	u32 reg;
+	u32 orig_reg, reg;
 
 	/*
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
-	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00mmio_register_read(rt2x00dev, TXRX_CSR9, &orig_reg);
+	reg = orig_reg;
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
 	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, reg);
 
@@ -2048,10 +2049,9 @@ static void rt61pci_clear_beacon(struct queue_entry *entry)
 				  HW_BEACON_OFFSET(entry->entry_idx), 0);
 
 	/*
-	 * Enable beaconing again.
+	 * Restore global beaconing state.
 	 */
-	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
-	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, reg);
+	rt2x00mmio_register_write(rt2x00dev, TXRX_CSR9, orig_reg);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index a140170..95724ff 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1597,13 +1597,14 @@ static void rt73usb_clear_beacon(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	unsigned int beacon_base;
-	u32 reg;
+	u32 orig_reg, reg;
 
 	/*
 	 * Disable beaconing while we are reloading the beacon data,
 	 * otherwise we might be sending out invalid data.
 	 */
-	rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &orig_reg);
+	reg = orig_reg;
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 
@@ -1614,10 +1615,9 @@ static void rt73usb_clear_beacon(struct queue_entry *entry)
 	rt2x00usb_register_write(rt2x00dev, beacon_base, 0);
 
 	/*
-	 * Enable beaconing again.
+	 * Restore beaconing state.
 	 */
-	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
-	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, orig_reg);
 }
 
 static int rt73usb_get_tx_data_len(struct queue_entry *entry)
-- 
1.8.4.2

