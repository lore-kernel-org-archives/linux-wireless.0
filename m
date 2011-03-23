Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44609 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894Ab1CWT5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:57:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 05/10] ath9k_hw: remove pCap->total_queues
Date: Wed, 23 Mar 2011 20:57:28 +0100
Message-Id: <1300910253-28189-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300910253-28189-4-git-send-email-nbd@openwrt.org>
References: <1300910253-28189-1-git-send-email-nbd@openwrt.org>
 <1300910253-28189-2-git-send-email-nbd@openwrt.org>
 <1300910253-28189-3-git-send-email-nbd@openwrt.org>
 <1300910253-28189-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The EEPROM contains a field that can restrict the number of hardware queues,
however this is not only useless (all the known chips contain the same
number of hardware queues), but also potentially dangerous in case of a
misprogrammed EEPROM (could trigger driver crashes), so let's just ignore
it completely.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    8 +------
 drivers/net/wireless/ath/ath9k/hw.h  |    1 -
 drivers/net/wireless/ath/ath9k/mac.c |   38 ++++-----------------------------
 3 files changed, 6 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index bb9a3f3..de0d218 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1437,7 +1437,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	REGWRITE_BUFFER_FLUSH(ah);
 
 	ah->intr_txqs = 0;
-	for (i = 0; i < ah->caps.total_queues; i++)
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		ath9k_hw_resettxqueue(ah, i);
 
 	ath9k_hw_init_interrupt_masks(ah, ah->opmode);
@@ -1885,12 +1885,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	else
 		pCap->hw_caps &= ~ATH9K_HW_CAP_HT;
 
-	if (capField & AR_EEPROM_EEPCAP_MAXQCU)
-		pCap->total_queues =
-			MS(capField, AR_EEPROM_EEPCAP_MAXQCU);
-	else
-		pCap->total_queues = ATH9K_NUM_TX_QUEUES;
-
 	if (capField & AR_EEPROM_EEPCAP_KC_ENTRIES)
 		pCap->keycache_size =
 			1 << MS(capField, AR_EEPROM_EEPCAP_KC_ENTRIES);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index dafbe97..4e62ad8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -191,7 +191,6 @@ enum ath9k_hw_caps {
 
 struct ath9k_hw_capabilities {
 	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */
-	u16 total_queues;
 	u16 keycache_size;
 	u16 low_5ghz_chan, high_5ghz_chan;
 	u16 low_2ghz_chan, high_2ghz_chan;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index db496f2..05efcfb 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -209,15 +209,8 @@ bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 {
 	u32 cw;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath9k_tx_queue_info *qi;
 
-	if (q >= pCap->total_queues) {
-		ath_dbg(common, ATH_DBG_QUEUE,
-			"Set TXQ properties, invalid queue: %u\n", q);
-		return false;
-	}
-
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		ath_dbg(common, ATH_DBG_QUEUE,
@@ -280,15 +273,8 @@ bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 			    struct ath9k_tx_queue_info *qinfo)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath9k_tx_queue_info *qi;
 
-	if (q >= pCap->total_queues) {
-		ath_dbg(common, ATH_DBG_QUEUE,
-			"Get TXQ properties, invalid queue: %u\n", q);
-		return false;
-	}
-
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		ath_dbg(common, ATH_DBG_QUEUE,
@@ -320,28 +306,27 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_tx_queue_info *qi;
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	int q;
 
 	switch (type) {
 	case ATH9K_TX_QUEUE_BEACON:
-		q = pCap->total_queues - 1;
+		q = ATH9K_NUM_TX_QUEUES - 1;
 		break;
 	case ATH9K_TX_QUEUE_CAB:
-		q = pCap->total_queues - 2;
+		q = ATH9K_NUM_TX_QUEUES - 2;
 		break;
 	case ATH9K_TX_QUEUE_PSPOLL:
 		q = 1;
 		break;
 	case ATH9K_TX_QUEUE_UAPSD:
-		q = pCap->total_queues - 3;
+		q = ATH9K_NUM_TX_QUEUES - 3;
 		break;
 	case ATH9K_TX_QUEUE_DATA:
-		for (q = 0; q < pCap->total_queues; q++)
+		for (q = 0; q < ATH9K_NUM_TX_QUEUES; q++)
 			if (ah->txq[q].tqi_type ==
 			    ATH9K_TX_QUEUE_INACTIVE)
 				break;
-		if (q == pCap->total_queues) {
+		if (q == ATH9K_NUM_TX_QUEUES) {
 			ath_err(common, "No available TX queue\n");
 			return -1;
 		}
@@ -382,15 +367,9 @@ EXPORT_SYMBOL(ath9k_hw_setuptxqueue);
 
 bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 {
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_tx_queue_info *qi;
 
-	if (q >= pCap->total_queues) {
-		ath_dbg(common, ATH_DBG_QUEUE,
-			"Release TXQ, invalid queue: %u\n", q);
-		return false;
-	}
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		ath_dbg(common, ATH_DBG_QUEUE,
@@ -414,18 +393,11 @@ EXPORT_SYMBOL(ath9k_hw_releasetxqueue);
 
 bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 {
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_channel *chan = ah->curchan;
 	struct ath9k_tx_queue_info *qi;
 	u32 cwMin, chanCwMin, value;
 
-	if (q >= pCap->total_queues) {
-		ath_dbg(common, ATH_DBG_QUEUE,
-			"Reset TXQ, invalid queue: %u\n", q);
-		return false;
-	}
-
 	qi = &ah->txq[q];
 	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
 		ath_dbg(common, ATH_DBG_QUEUE,
-- 
1.7.3.2

