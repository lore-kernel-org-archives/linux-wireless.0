Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40667 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933838AbZKYChv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 21:37:51 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Kyungwan Nam <kyungwan.nam@atheros.com>,
	Bennyam Malavazi <bennyam.malavazi@atheros.com>,
	Stephen Chen <stephen.chen@atheros.com>,
	Shan Palanisamy <shan.palanisamy@atheros.com>,
	Paul Shaw <paul.shaw@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH] ath9k: Fix maximum tx fifo settings for single stream devices
Date: Tue, 24 Nov 2009 21:37:57 -0500
Message-Id: <1259116677-2249-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Atheros single stream AR9285 and AR9271 have half the PCU TX FIFO
buffer size of that of dual stream devices. Dual stream devices
have a max PCU TX FIFO size of 8 KB while single stream devices
have 4 KB. Single stream devices have an issue though and require
hardware only to use half of the amount of its capable PCU TX FIFO
size, 2 KB and this requires a change in software.

Technically a change would not have been required (except for frame
burst considerations of 128 bytes) if these devices would have been
able to use the full 4 KB of the PCU TX FIFO size but our systems
engineers recommend 2 KB to be used only. We enforce this through
software by reducing the max frame triggger level to 2 KB.

Fixing the max frame trigger level should then have a few benefits:

  * The PER will now be adjusted as designed for underruns when the
    max trigger level is reached. This should help alleviate the
    bus as the rate control algorithm chooses a slower rate which
    should ensure frames are transmitted properly under high system
    bus load.

  * The poll we use on our TX queues should now trigger and work
    as designed for single stream devices. The hardware passes
    data from each TX queue on the PCU TX FIFO queue respecting each
    queue's priority. The new trigger level ensures this seeding of
    the PCU TX FIFO queue occurs as designed which could mean avoiding
    false resets and actually reseting hw correctly when a TX queue
    is indeed stuck.

  * Some undocumented / unsupported behaviour could have been triggered
    when the max trigger level level was being set to 4 KB on single
    stream devices. Its not clear what this issue was to me yet.

Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
Cc: Bennyam Malavazi <bennyam.malavazi@atheros.com>
Cc: Stephen Chen <stephen.chen@atheros.com>
Cc: Shan Palanisamy <shan.palanisamy@atheros.com>
Cc: Paul Shaw <paul.shaw@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   11 ++++++++++-
 drivers/net/wireless/ath/ath9k/hw.h  |    1 +
 drivers/net/wireless/ath/ath9k/mac.c |   29 +++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/mac.h |    8 +++++++-
 drivers/net/wireless/ath/ath9k/rc.c  |   12 ++++++++----
 5 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 53a7b98..7235711 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -922,6 +922,11 @@ int ath9k_hw_init(struct ath_hw *ah)
 	ath_print(common, ATH_DBG_RESET, "serialize_regmode is %d\n",
 		ah->config.serialize_regmode);
 
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
+		ah->config.max_txtrig_level = MAX_TX_FIFO_THRESHOLD >> 1;
+	else
+		ah->config.max_txtrig_level = MAX_TX_FIFO_THRESHOLD;
+
 	if (!ath9k_hw_macversion_supported(ah->hw_version.macVersion)) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Mac Chip Rev 0x%02x.%x is not supported by "
@@ -3228,7 +3233,11 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->keycache_size = AR_KEYTABLE_SIZE;
 
 	pCap->hw_caps |= ATH9K_HW_CAP_FASTCC;
-	pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD;
+
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
+		pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD >> 1;
+	else
+		pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD;
 
 	if (AR_SREV_9285_10_OR_LATER(ah))
 		pCap->num_gpio_pins = AR9285_NUM_GPIO;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f8f5e99..b3f2d49 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -226,6 +226,7 @@ struct ath9k_ops_config {
 #define AR_SPUR_FEEQ_BOUND_HT20 10
 	int spurmode;
 	u16 spurchans[AR_EEPROM_MODAL_SPURS][2];
+	u8 max_txtrig_level;
 };
 
 enum ath9k_int {
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 09ed441..71b84d9 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -70,12 +70,37 @@ u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q)
 }
 EXPORT_SYMBOL(ath9k_hw_numtxpending);
 
+/**
+ * ath9k_hw_updatetxtriglevel - adjusts the frame trigger level
+ *
+ * @ah: atheros hardware struct
+ * @bIncTrigLevel: whether or not the frame trigger level should be updated
+ *
+ * The frame trigger level specifies the minimum number of bytes,
+ * in units of 64 bytes, that must be DMA'ed into the PCU TX FIFO
+ * before the PCU will initiate sending the frame on the air. This can
+ * mean we initiate transmit before a full frame is on the PCU TX FIFO.
+ * Resets to 0x1 (meaning 64 bytes or a full frame, whichever occurs
+ * first)
+ *
+ * Caution must be taken to ensure to set the frame trigger level based
+ * on the DMA request size. For example if the DMA request size is set to
+ * 128 bytes the trigger level cannot exceed 6 * 64 = 384. This is because
+ * there need to be enough space in the tx FIFO for the requested transfer
+ * size. Hence the tx FIFO will stop with 512 - 128 = 384 bytes. If we set
+ * the threshold to a value beyond 6, then the transmit will hang.
+ *
+ * Current dual   stream devices have a PCU TX FIFO size of 8 KB.
+ * Current single stream devices have a PCU TX FIFO size of 4 KB, however,
+ * there is a hardware issue which forces us to use 2 KB instead so the
+ * frame trigger level must not exceed 2 KB for these chipsets.
+ */
 bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
 {
 	u32 txcfg, curLevel, newLevel;
 	enum ath9k_int omask;
 
-	if (ah->tx_trig_level >= MAX_TX_FIFO_THRESHOLD)
+	if (ah->tx_trig_level >= ah->config.max_txtrig_level)
 		return false;
 
 	omask = ath9k_hw_set_interrupts(ah, ah->mask_reg & ~ATH9K_INT_GLOBAL);
@@ -84,7 +109,7 @@ bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
 	curLevel = MS(txcfg, AR_FTRIG);
 	newLevel = curLevel;
 	if (bIncTrigLevel) {
-		if (curLevel < MAX_TX_FIFO_THRESHOLD)
+		if (curLevel < ah->config.max_txtrig_level)
 			newLevel++;
 	} else if (curLevel > MIN_TX_FIFO_THRESHOLD)
 		newLevel--;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index bd602b8..d61aeb1 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -86,9 +86,15 @@
 #define ATH9K_TX_SW_ABORTED        0x40
 #define ATH9K_TX_SW_FILTERED       0x80
 
+/* 64 bytes */
 #define MIN_TX_FIFO_THRESHOLD   0x1
+
+/*
+ * Single stream device AR9285 and AR9271 require 2 KB
+ * to work around a hardware issue, all other devices
+ * have can use the max 4 KB limit.
+ */
 #define MAX_TX_FIFO_THRESHOLD   ((4096 / 64) - 1)
-#define INIT_TX_FIFO_THRESHOLD  MIN_TX_FIFO_THRESHOLD
 
 struct ath_tx_status {
 	u32 ts_tstamp;
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 1d96777..9d7f6c3 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1324,10 +1324,14 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		return;
 
 	/*
-	 * If underrun error is seen assume it as an excessive retry only
-	 * if prefetch trigger level have reached the max (0x3f for 5416)
-	 * Adjust the long retry as if the frame was tried hw->max_rate_tries
-	 * times. This affects how ratectrl updates PER for the failed rate.
+	 * If an underrun error is seen assume it as an excessive retry only
+	 * if max frame trigger level has been reached (2 KB for singel stream,
+	 * and 4 KB for dual stream). Adjust the long retry as if the frame was
+	 * tried hw->max_rate_tries times to affect how ratectrl updates PER for
+	 * the failed rate. In case of congestion on the bus penalizing these
+	 * type of underruns should help hardware actually transmit new frames
+	 * successfully by eventually preferring slower rates. This itself
+	 * should also alleviate congestion on the bus.
 	 */
 	if ((tx_info->pad[0] & ATH_TX_INFO_UNDERRUN) &&
 	    (sc->sc_ah->tx_trig_level >= ath_rc_priv->tx_triglevel_max)) {
-- 
1.6.5.2.155.gbb47

