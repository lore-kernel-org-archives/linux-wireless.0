Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9239 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab1LWP5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 10:57:03 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH] ath9k_hw: increase tx status ring buffer size
Date: Fri, 23 Dec 2011 21:27:02 +0530
Message-ID: <1324655822-14923-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111223_165708_775939_D0C5D2CE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9003 chips read tx status from ring buffer whose max number of
status descriptor is mininal compared to max number of tx buffers.
On a stress condition, it can be easily overflown which might cause
false tx hung detection. Though increasing number of max status
descriptors consumes more memory, it helps to avoid false positive
chip resets.

Cc: Paul Stewart <pstew@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.h |    2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h      |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h         |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 4a31515..88c81c5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -583,7 +583,7 @@ void ath9k_hw_reset_txstatus_ring(struct ath_hw *ah)
 
 void ath9k_hw_setup_statusring(struct ath_hw *ah, void *ts_start,
 			       u32 ts_paddr_start,
-			       u8 size)
+			       u16 size)
 {
 
 	ah->ts_paddr_start = ts_paddr_start;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.h b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
index c504493..e203b51 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.h
@@ -118,5 +118,5 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah,
 void ath9k_hw_reset_txstatus_ring(struct ath_hw *ah);
 void ath9k_hw_setup_statusring(struct ath_hw *ah, void *ts_start,
 			       u32 ts_paddr_start,
-			       u8 size);
+			       u16 size);
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 95276e9..b30e9fc 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -97,7 +97,7 @@ enum buffer_type {
 #define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
 #define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
 
-#define ATH_TXSTATUS_RING_SIZE 64
+#define ATH_TXSTATUS_RING_SIZE 512
 
 #define	DS2PHYS(_dd, _ds)						\
 	((_dd)->dd_desc_paddr + ((caddr_t)(_ds) - (caddr_t)(_dd)->dd_desc))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 48205c2..6a29004 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1016,7 +1016,7 @@ struct ath_hw {
 	u32 ts_paddr_start;
 	u32 ts_paddr_end;
 	u16 ts_tail;
-	u8 ts_size;
+	u16 ts_size;
 
 	u32 bb_watchdog_last_status;
 	u32 bb_watchdog_timeout_ms; /* in ms, 0 to disable */
-- 
1.7.8.1

