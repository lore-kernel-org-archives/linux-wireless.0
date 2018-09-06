Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56710 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728039AbeIFNyZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:25 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 20/42] mt76x0: remove unused {tx/rx}_queue definitions
Date: Thu,  6 Sep 2018 11:18:36 +0200
Message-Id: <1536225538-16454-21-git-send-email-sgruszka@redhat.com> (sfid-20180906_111959_459370_4042E4E7)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Remove unused tx_queue and rx_queue definitions since
now mt76x0 driver uses mt76-usb {tx/rx}_queues

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  2 -
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 50 ----------------------
 2 files changed, 52 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 5be4c48936e4..a7d6e747f221 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -505,8 +505,6 @@ struct mt76x0_dev *mt76x0_alloc_device(struct device *pdev)
 	mutex_init(&dev->usb_ctrl_mtx);
 	mutex_init(&dev->reg_atomic_mutex);
 	mutex_init(&dev->hw_atomic_mutex);
-	spin_lock_init(&dev->tx_lock);
-	spin_lock_init(&dev->rx_lock);
 	spin_lock_init(&dev->mac_lock);
 	spin_lock_init(&dev->con_mon_lock);
 	atomic_set(&dev->avg_ampdu_len, 1);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index f63c44999bdd..6ba5e9ba2c7f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -40,13 +40,6 @@
 #define MT_USB_AGGR_SIZE_LIMIT		21 /* * 1024B */
 #define MT_USB_AGGR_TIMEOUT		0x80 /* * 33ns */
 
-struct mt76x0_dma_buf {
-	struct urb *urb;
-	void *buf;
-	dma_addr_t dma;
-	size_t len;
-};
-
 struct mac_stats {
 	u64 rx_stat[6];
 	u64 tx_stat[6];
@@ -55,38 +48,6 @@ struct mac_stats {
 	u64 zero_len_del[2];
 };
 
-#define N_RX_ENTRIES	16
-struct mt76x0_rx_queue {
-	struct mt76x0_dev *dev;
-
-	struct mt76x0_dma_buf_rx {
-		struct urb *urb;
-		struct page *p;
-	} e[N_RX_ENTRIES];
-
-	unsigned int start;
-	unsigned int end;
-	unsigned int entries;
-	unsigned int pending;
-};
-
-#define N_TX_ENTRIES	64
-
-struct mt76x0_tx_queue {
-	struct mt76x0_dev *dev;
-
-	struct mt76x0_dma_buf_tx {
-		struct urb *urb;
-		struct sk_buff *skb;
-	} e[N_TX_ENTRIES];
-
-	unsigned int start;
-	unsigned int end;
-	unsigned int entries;
-	unsigned int used;
-	unsigned int fifo_seq;
-};
-
 struct mt76x0_eeprom_params;
 
 #define MT_EE_TEMPERATURE_SLOPE		39
@@ -108,9 +69,6 @@ enum mt_bw {
  * struct mt76x0_dev - adapter structure
  * @lock:		protects @wcid->tx_rate.
  * @mac_lock:		locks out mac80211's tx status and rx paths.
- * @tx_lock:		protects @tx_q and changes of MT76_STATE_*_STATS
- *			flags in @state.
- * @rx_lock:		protects @rx_q.
  * @con_mon_lock:	protects @ap_bssid, @bcn_*, @avg_rssi.
  * @mutex:		ensures exclusive access from mac80211 callbacks.
  * @reg_atomic_mutex:	ensures atomicity of indirect register accesses
@@ -146,16 +104,8 @@ struct mt76x0_dev {
 
 	u32 debugfs_reg;
 
-	/* TX */
-	spinlock_t tx_lock;
-	struct mt76x0_tx_queue *tx_q;
-
 	atomic_t avg_ampdu_len;
 
-	/* RX */
-	spinlock_t rx_lock;
-	struct mt76x0_rx_queue rx_q;
-
 	/* Connection monitoring things */
 	spinlock_t con_mon_lock;
 	u8 ap_bssid[ETH_ALEN];
-- 
2.7.5
