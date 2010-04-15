Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab0DODa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:57 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v2 82/97] ath9k_hw: Add function to configure tx status ring buffer
Date: Wed, 14 Apr 2010 23:30:36 -0400
Message-Id: <1271302251-9075-83-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Also reset tx status ring suring chip reset.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   30 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_mac.h |   17 ++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.c         |    3 ++
 drivers/net/wireless/ath/ath9k/hw.h         |    7 ++++++
 drivers/net/wireless/ath/ath9k/reg.h        |    3 ++
 5 files changed, 59 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index c270bbe..81ad09a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -347,3 +347,33 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 	return 0;
 }
 EXPORT_SYMBOL(ath9k_hw_process_rxdesc_edma);
+
+void ath9k_hw_reset_txstatus_ring(struct ath_hw *ah)
+{
+	ah->ts_tail = 0;
+
+	memset((void *) ah->ts_ring, 0,
+		ah->ts_size * sizeof(struct ar9003_txs));
+
+	ath_print(ath9k_hw_common(ah), ATH_DBG_XMIT,
+		  "TS Start 0x%x End 0x%x Virt %p, Size %d\n",
+		   ah->ts_paddr_start, ah->ts_paddr_end,
+		   ah->ts_ring, ah->ts_size);
+
+	REG_WRITE(ah, AR_Q_STATUS_RING_START, ah->ts_paddr_start);
+	REG_WRITE(ah, AR_Q_STATUS_RING_END, ah->ts_paddr_end);
+}
+
+void ath9k_hw_setup_statusring(struct ath_hw *ah, void *ts_start,
+			       u32 ts_paddr_start,
+			       u8 size)
+{
+
+	ah->ts_paddr_start = ts_paddr_start;
+	ah->ts_paddr_end = ts_paddr_start + (size * sizeof(struct ar9003_txs));
+	ah->ts_size = size;
+	ah->ts_ring = (struct ar9003_txs *) ts_start;
+
+	ath9k_hw_reset_txstatus_ring(ah);
+}
+EXPORT_SYMBOL(ath9k_hw_setup_statusring);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.h b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
index b78d009..636ad07 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
@@ -79,6 +79,18 @@ struct ar9003_txc {
 	u32 pad[9]; /* pad to cache line (128 bytes/32 dwords) */
 } __packed;
 
+struct ar9003_txs {
+	u32 ds_info;
+	u32 status1;
+	u32 status2;
+	u32 status3;
+	u32 status4;
+	u32 status5;
+	u32 status6;
+	u32 status7;
+	u32 status8;
+} __packed;
+
 void ar9003_hw_attach_mac_ops(struct ath_hw *hw);
 void ath9k_hw_set_rx_bufsize(struct ath_hw *ah, u16 buf_size);
 void ath9k_hw_addrxbuf_edma(struct ath_hw *ah, u32 rxdp,
@@ -87,5 +99,8 @@ void ath9k_hw_addrxbuf_edma(struct ath_hw *ah, u32 rxdp,
 int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah,
 				 struct ath_rx_status *rxs,
 				 void *buf_addr);
-
+void ath9k_hw_reset_txstatus_ring(struct ath_hw *ah);
+void ath9k_hw_setup_statusring(struct ath_hw *ah, void *ts_start,
+			       u32 ts_paddr_start,
+			       u8 size);
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8155e23..bd45d4b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -896,6 +896,9 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 		REG_WRITE(ah, AR_PCU_TXBUF_CTRL,
 			  AR_PCU_TXBUF_CTRL_USABLE_SIZE);
 	}
+
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		ath9k_hw_reset_txstatus_ring(ah);
 }
 
 static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c494236..6b0ab5d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -755,6 +755,13 @@ struct ath_hw {
 	u32 intr_gen_timer_trigger;
 	u32 intr_gen_timer_thresh;
 	struct ath_gen_timer_table hw_gen_timers;
+
+	struct ar9003_txs *ts_ring;
+	void *ts_start;
+	u32 ts_paddr_start;
+	u32 ts_paddr_end;
+	u16 ts_tail;
+	u8 ts_size;
 };
 
 static inline struct ath_common *ath9k_hw_common(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 2ca478c..ff89140 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -383,6 +383,9 @@
 #define AR_Q9_TXDP           0x0824
 #define AR_QTXDP(_i)    (AR_Q0_TXDP + ((_i)<<2))
 
+#define AR_Q_STATUS_RING_START	0x830
+#define AR_Q_STATUS_RING_END	0x834
+
 #define AR_Q_TXE             0x0840
 #define AR_Q_TXE_M           0x000003FF
 
-- 
1.6.3.3

