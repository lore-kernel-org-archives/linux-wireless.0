Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751077AbdBOJaL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:30:11 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH v2 02/10] rt2800: identify station based on status WCID
Date: Wed, 15 Feb 2017 10:25:05 +0100
Message-Id: <1487150713-3510-3-git-send-email-sgruszka@redhat.com> (sfid-20170215_103015_423327_C3453BFA)
In-Reply-To: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
References: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add framework to identify sta based on tx status WCID. This is currently
not used, will start be utilized in the future patch.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c   | 5 +++++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h   | 1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.h | 3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 8223a15..46405cc 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -855,11 +855,13 @@ void rt2800_process_rxwi(struct queue_entry *entry,
 void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	struct txdone_entry_desc txdesc;
 	u32 word;
 	u16 mcs, real_mcs;
 	int aggr, ampdu;
+	int wcid;
 
 	/*
 	 * Obtain the status about this packet.
@@ -872,6 +874,7 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi)
 
 	real_mcs = rt2x00_get_field32(status, TX_STA_FIFO_MCS);
 	aggr = rt2x00_get_field32(status, TX_STA_FIFO_TX_AGGRE);
+	wcid = rt2x00_get_field32(status, TX_STA_FIFO_WCID);
 
 	/*
 	 * If a frame was meant to be sent as a single non-aggregated MPDU
@@ -1468,6 +1471,7 @@ int rt2800_sta_add(struct rt2x00_dev *rt2x00dev, struct ieee80211_vif *vif,
 		return 0;
 
 	__set_bit(wcid - WCID_START, drv_data->sta_ids);
+	drv_data->wcid_to_sta[wcid - WCID_START] = sta;
 
 	/*
 	 * Clean up WCID attributes and write STA address to the device.
@@ -1498,6 +1502,7 @@ int rt2800_sta_remove(struct rt2x00_dev *rt2x00dev, struct ieee80211_sta *sta)
 	 * get renewed when the WCID is reused.
 	 */
 	rt2800_config_wcid(rt2x00dev, NULL, wcid);
+	drv_data->wcid_to_sta[wcid - WCID_START] = NULL;
 	__clear_bit(wcid - WCID_START, drv_data->sta_ids);
 
 	return 0;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index 8e1ae13..6811d67 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -41,6 +41,7 @@ struct rt2800_drv_data {
 	unsigned int tbtt_tick;
 	unsigned int ampdu_factor_cnt[4];
 	DECLARE_BITMAP(sta_ids, STA_IDS_SIZE);
+	struct ieee80211_sta *wcid_to_sta[STA_IDS_SIZE];
 };
 
 struct rt2800_ops {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
index 22d1881..9b297fc 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.h
@@ -102,7 +102,7 @@ enum skb_frame_desc_flags {
  *	of the scope of the skb->data pointer.
  * @iv: IV/EIV data used during encryption/decryption.
  * @skb_dma: (PCI-only) the DMA address associated with the sk buffer.
- * @entry: The entry to which this sk buffer belongs.
+ * @sta: The station where sk buffer was sent.
  */
 struct skb_frame_desc {
 	u8 flags;
@@ -116,6 +116,7 @@ struct skb_frame_desc {
 	__le32 iv[2];
 
 	dma_addr_t skb_dma;
+	struct ieee80211_sta *sta;
 };
 
 /**
-- 
1.8.3.1
