Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26209 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaESGOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 02:14:09 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath9k_hw: Abort transmission for sleeping station
Date: Mon, 19 May 2014 11:44:37 +0530
Message-ID: <1400480077-18619-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140519_081414_013386_3C1C3380)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The data transmission to the power save station should be aborted
immediately, whenever the station informs sleep state. Right now
the frames queued into into hardware are being transmitted until
the hardware detects the power save station based excessive retries
of the data frames due to unacknowlegdement. Then remaining frames
are returned with filetered status and might be retried later by
driver or mac80211.

Per WFA certification testing, AP should not send out more than two
frames after processing nullfunc with PM bit set from associated
station. To speed up tx filtering, the pending frames in hardware
queues for given station will be aborted immediately via tx filter
registers. This transmit filters can be ignored if the descriptor
is having invalid destination index or clear destination mask set.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mac.c  | 22 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/mac.h  |  1 +
 drivers/net/wireless/ath/ath9k/main.c |  8 ++++++++
 drivers/net/wireless/ath/ath9k/reg.h  |  3 ---
 4 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 51ce36f..275205a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -958,3 +958,25 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah)
 	return;
 }
 EXPORT_SYMBOL(ath9k_hw_set_interrupts);
+
+#define ATH9K_HW_MAX_DCU       10
+#define ATH9K_HW_SLICE_PER_DCU 16
+#define ATH9K_HW_BIT_IN_SLICE  16
+void ath9k_hw_set_tx_filter(struct ath_hw *ah, u8 destidx, bool set)
+{
+	int dcu_idx;
+	u32 filter;
+
+	for (dcu_idx = 0; dcu_idx < 10; dcu_idx++) {
+		filter = SM(set, AR_D_TXBLK_WRITE_COMMAND);
+		filter |= SM(dcu_idx, AR_D_TXBLK_WRITE_DCU);
+		filter |= SM((destidx / ATH9K_HW_SLICE_PER_DCU),
+			     AR_D_TXBLK_WRITE_SLICE);
+		filter |= BIT(destidx % ATH9K_HW_BIT_IN_SLICE);
+		ath_dbg(ath9k_hw_common(ah), PS,
+			"DCU%d staid %d set %d txfilter %08x\n",
+			dcu_idx, destidx, set, filter);
+		REG_WRITE(ah, AR_D_TXBLK_BASE, filter);
+	}
+}
+EXPORT_SYMBOL(ath9k_hw_set_tx_filter);
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 89df634..da76867 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -729,6 +729,7 @@ void ath9k_hw_startpcureceive(struct ath_hw *ah, bool is_scanning);
 void ath9k_hw_abortpcurecv(struct ath_hw *ah);
 bool ath9k_hw_stopdmarecv(struct ath_hw *ah, bool *reset);
 int ath9k_hw_beaconq_setup(struct ath_hw *ah);
+void ath9k_hw_set_tx_filter(struct ath_hw *ah, u8 destidx, bool set);
 
 /* Interrupt Handling */
 bool ath9k_hw_intrpend(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8d7b9b6..47d442a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1506,8 +1506,12 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
 	case STA_NOTIFY_SLEEP:
 		an->sleeping = true;
 		ath_tx_aggr_sleep(sta, sc, an);
+		if (an->ps_key > 0)
+			ath9k_hw_set_tx_filter(sc->sc_ah, an->ps_key, true);
 		break;
 	case STA_NOTIFY_AWAKE:
+		if (an->ps_key > 0)
+			ath9k_hw_set_tx_filter(sc->sc_ah, an->ps_key, false);
 		an->sleeping = false;
 		ath_tx_aggr_wakeup(sc, an);
 		break;
@@ -1593,6 +1597,8 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 			ath9k_del_ps_key(sc, vif, sta);
 
 		ret = ath_key_config(common, vif, sta, key);
+		if (sta && (ret > 0))
+			((struct ath_node *)sta->drv_priv)->ps_key = ret;
 		if (ret >= 0) {
 			key->hw_key_idx = ret;
 			/* push IV and Michael MIC generation to stack */
@@ -1607,6 +1613,8 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 		break;
 	case DISABLE_KEY:
 		ath_key_delete(common, key);
+		if (sta)
+			((struct ath_node *)sta->drv_priv)->ps_key = 0;
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index b1fd3fa..f1bbce3 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -505,9 +505,6 @@
 #define AR_D_QCUMASK         0x000003FF
 #define AR_D_QCUMASK_RESV0   0xFFFFFC00
 
-#define AR_D_TXBLK_CMD  0x1038
-#define AR_D_TXBLK_DATA(i) (AR_D_TXBLK_CMD+(i))
-
 #define AR_D0_LCL_IFS     0x1040
 #define AR_D1_LCL_IFS     0x1044
 #define AR_D2_LCL_IFS     0x1048
-- 
1.9.2

