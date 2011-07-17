Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23198 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1GQGIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 02:08:49 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/2] ath9k: Fix sparse warnings
Date: Sun, 17 Jul 2011 11:38:48 +0530
Message-ID: <1310882929-10528-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110717_080858_515974_C6CE10B1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath/ath9k/init.c:199:21: warning: context imbalance
in 'ath9k_reg_rmw' - different lock contexts for basic block
drivers/net/wireless/ath/ath9k/xmit.c:1175:31: warning: context
imbalance in 'ath_drain_txq_list' - unexpected unlock
drivers/net/wireless/ath/ath9k/xmit.c:2047:23: warning: context
imbalance in 'ath_tx_process_buffer' - unexpected unlock
drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3041:24: warning: cast to
restricted __le32

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 drivers/net/wireless/ath/ath9k/init.c          |   24 ++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/xmit.c          |    4 ++++
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 1d09f22..d576080 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3038,7 +3038,7 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 	case EEP_CHAIN_MASK_REDUCE:
 		return (pBase->miscConfiguration >> 0x3) & 0x1;
 	case EEP_ANT_DIV_CTL1:
-		return le32_to_cpu(eep->base_ext1.ant_div_control);
+		return eep->base_ext1.ant_div_control;
 	default:
 		return 0;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index ce29717..7815dbe 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -196,6 +196,18 @@ static unsigned int ath9k_ioread32(void *hw_priv, u32 reg_offset)
 	return val;
 }
 
+static unsigned int __ath9k_reg_rmw(struct ath_softc *sc, u32 reg_offset, u32 set, u32 clr)
+{
+	u32 val;
+
+	val = ioread32(sc->mem + reg_offset);
+	val &= ~clr;
+	val |= set;
+	iowrite32(val, sc->mem + reg_offset);
+
+	return val;
+}
+
 static unsigned int ath9k_reg_rmw(void *hw_priv, u32 reg_offset, u32 set, u32 clr)
 {
 	struct ath_hw *ah = (struct ath_hw *) hw_priv;
@@ -204,16 +216,12 @@ static unsigned int ath9k_reg_rmw(void *hw_priv, u32 reg_offset, u32 set, u32 cl
 	unsigned long uninitialized_var(flags);
 	u32 val;
 
-	if (ah->config.serialize_regmode == SER_REG_MODE_ON)
+	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
 		spin_lock_irqsave(&sc->sc_serial_rw, flags);
-
-	val = ioread32(sc->mem + reg_offset);
-	val &= ~clr;
-	val |= set;
-	iowrite32(val, sc->mem + reg_offset);
-
-	if (ah->config.serialize_regmode == SER_REG_MODE_ON)
+		val = __ath9k_reg_rmw(sc, reg_offset, set, clr);
 		spin_unlock_irqrestore(&sc->sc_serial_rw, flags);
+	} else
+		val = __ath9k_reg_rmw(sc, reg_offset, set, clr);
 
 	return val;
 }
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 9283440..7810b92 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1147,6 +1147,8 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
 
 static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
 			       struct list_head *list, bool retry_tx)
+	__releases(txq->axq_lock)
+	__acquires(txq->axq_lock)
 {
 	struct ath_buf *bf, *lastbf;
 	struct list_head bf_head;
@@ -2035,6 +2037,8 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 				  struct ath_tx_status *ts, struct ath_buf *bf,
 				  struct list_head *bf_head)
+	__releases(txq->axq_lock)
+	__acquires(txq->axq_lock)
 {
 	int txok;
 
-- 
1.7.6

