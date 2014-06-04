Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbaFDNUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:20:39 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org,
	Matthias Fend <Matthias.Fend@wolfvision.net>
Subject: [RFC/RFT 2/5] rt2x00: change beaconing setup on RT2800
Date: Wed,  4 Jun 2014 15:19:12 +0200
Message-Id: <1401887955-11361-2-git-send-email-sgruszka@redhat.com> (sfid-20140604_152043_964355_4783C7CF)
In-Reply-To: <1401887955-11361-1-git-send-email-sgruszka@redhat.com>
References: <1401887955-11361-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported by Matthias, on 5572 chip, even if we clear up TXWI
of corresponding beacon, hardware still try to send it or do other
action that increase power consumption peak up to 1A.

To avoid the issue, setup beaconing dynamically by configuring offsets
of currently active beacons and MAC_BSSID_DW1_BSS_BCN_NUM variable,
which limit number of beacons that hardware will try to send.

Reported-by: Matthias Fend <Matthias.Fend@wolfvision.net>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c   | 45 +++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.h |  1 +
 2 files changed, 46 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c17fcf2..c45b2d3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -947,6 +947,40 @@ static inline u8 rt2800_get_beacon_offset(struct rt2x00_dev *rt2x00dev,
 	return BEACON_BASE_TO_OFFSET(rt2800_hw_beacon_base(rt2x00dev, index));
 }
 
+static void rt2800_update_beacons_setup(struct rt2x00_dev *rt2x00dev)
+{
+	struct data_queue *queue = rt2x00dev->bcn;
+	struct queue_entry *entry;
+	int i, bcn_num = 0;
+	u64 off, reg = 0;
+	u32 bssid_dw1;
+
+	/*
+	 * Setup offsets of all active beacons in BCN_OFFSET{0,1} registers.
+	 */
+	for (i = 0; i < queue->limit; i++) {
+		entry = &queue->entries[i];
+		if (!test_bit(ENTRY_BCN_ENABLED, &entry->flags))
+			continue;
+		off = rt2800_get_beacon_offset(rt2x00dev, entry->entry_idx);
+		reg |= off << (8 * bcn_num);
+		bcn_num++;
+	}
+
+	WARN_ON_ONCE(bcn_num != rt2x00dev->intf_beaconing);
+
+	rt2800_register_write(rt2x00dev, BCN_OFFSET0, (u32) reg);
+	rt2800_register_write(rt2x00dev, BCN_OFFSET1, (u32) (reg >> 32));
+
+	/*
+	 * H/W sends up to MAC_BSSID_DW1_BSS_BCN_NUM + 1 consecutive beacons.
+	 */
+	rt2800_register_read(rt2x00dev, MAC_BSSID_DW1, &bssid_dw1);
+	rt2x00_set_field32(&bssid_dw1, MAC_BSSID_DW1_BSS_BCN_NUM,
+			   bcn_num > 0 ? bcn_num - 1 : 0);
+	rt2800_register_write(rt2x00dev, MAC_BSSID_DW1, bssid_dw1);
+}
+
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
@@ -1003,6 +1037,12 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 
 	rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
 				   entry->skb->len + padding_len);
+	__set_bit(ENTRY_BCN_ENABLED, &entry->flags);
+
+	/*
+	 * Change global beacons settings.
+	 */
+	rt2800_update_beacons_setup(rt2x00dev);
 
 	/*
 	 * Restore beaconing state.
@@ -1053,8 +1093,13 @@ void rt2800_clear_beacon(struct queue_entry *entry)
 	 * Clear beacon.
 	 */
 	rt2800_clear_beacon_register(rt2x00dev, entry->entry_idx);
+	__clear_bit(ENTRY_BCN_ENABLED, &entry->flags);
 
 	/*
+	 * Change global beacons settings.
+	 */
+	rt2800_update_beacons_setup(rt2x00dev);
+	/*
 	 * Restore beaconing state.
 	 */
 	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, orig_reg);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index c48125b..2233b91 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -353,6 +353,7 @@ struct txentry_desc {
  */
 enum queue_entry_flags {
 	ENTRY_BCN_ASSIGNED,
+	ENTRY_BCN_ENABLED,
 	ENTRY_OWNER_DEVICE_DATA,
 	ENTRY_DATA_PENDING,
 	ENTRY_DATA_IO_FAILED,
-- 
1.8.3.1

