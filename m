Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:35447 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754387Ab0ELJkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 05:40:18 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0917907217
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 18:40:17 +0900 (JST)
Subject: [PATCH 07/12] ath5k: remove ATH_TRACE macro
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 12 May 2010 18:40:18 +0900
Message-ID: <20100512094018.6575.93712.stgit@tt-desk>
In-Reply-To: <20100512093947.6575.99595.stgit@tt-desk>
References: <20100512093947.6575.99595.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that we have ftrace, it is not needed any more.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/attach.c |    2 --
 drivers/net/wireless/ath/ath5k/caps.c   |    7 -------
 drivers/net/wireless/ath/ath5k/debug.c  |    1 -
 drivers/net/wireless/ath/ath5k/debug.h  |    8 --------
 drivers/net/wireless/ath/ath5k/desc.c   |    7 -------
 drivers/net/wireless/ath/ath5k/dma.c    |   13 -------------
 drivers/net/wireless/ath/ath5k/eeprom.c |    1 -
 drivers/net/wireless/ath/ath5k/gpio.c   |    7 -------
 drivers/net/wireless/ath/ath5k/pcu.c    |   24 ------------------------
 drivers/net/wireless/ath/ath5k/phy.c    |   13 -------------
 drivers/net/wireless/ath/ath5k/qcu.c    |    9 ---------
 drivers/net/wireless/ath/ath5k/reset.c  |    7 -------
 12 files changed, 0 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index e0c244b..ef2dc1d 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -351,8 +351,6 @@ err_free:
  */
 void ath5k_hw_detach(struct ath5k_hw *ah)
 {
-	ATH5K_TRACE(ah->ah_sc);
-
 	__set_bit(ATH_STAT_INVALID, ah->ah_sc->status);
 
 	if (ah->ah_rf_banks != NULL)
diff --git a/drivers/net/wireless/ath/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
index 74f0071..beae519 100644
--- a/drivers/net/wireless/ath/ath5k/caps.c
+++ b/drivers/net/wireless/ath/ath5k/caps.c
@@ -34,7 +34,6 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 {
 	u16 ee_header;
 
-	ATH5K_TRACE(ah->ah_sc);
 	/* Capabilities stored in the EEPROM */
 	ee_header = ah->ah_capabilities.cap_eeprom.ee_header;
 
@@ -123,8 +122,6 @@ int ath5k_hw_get_capability(struct ath5k_hw *ah,
 		enum ath5k_capability_type cap_type,
 		u32 capability, u32 *result)
 {
-	ATH5K_TRACE(ah->ah_sc);
-
 	switch (cap_type) {
 	case AR5K_CAP_NUM_TXQUEUES:
 		if (result) {
@@ -173,8 +170,6 @@ yes:
 int ath5k_hw_enable_pspoll(struct ath5k_hw *ah, u8 *bssid,
 		u16 assoc_id)
 {
-	ATH5K_TRACE(ah->ah_sc);
-
 	if (ah->ah_version == AR5K_AR5210) {
 		AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
 			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
@@ -186,8 +181,6 @@ int ath5k_hw_enable_pspoll(struct ath5k_hw *ah, u8 *bssid,
 
 int ath5k_hw_disable_pspoll(struct ath5k_hw *ah)
 {
-	ATH5K_TRACE(ah->ah_sc);
-
 	if (ah->ah_version == AR5K_AR5210) {
 		AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1,
 			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index c77a6ad..97c5ada 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -307,7 +307,6 @@ static const struct {
 	{ ATH5K_DEBUG_DUMP_RX,	"dumprx",	"print received skb content" },
 	{ ATH5K_DEBUG_DUMP_TX,	"dumptx",	"print transmit skb content" },
 	{ ATH5K_DEBUG_DUMPBANDS, "dumpbands",	"dump bands" },
-	{ ATH5K_DEBUG_TRACE,	"trace",	"trace function calls" },
 	{ ATH5K_DEBUG_ANI,	"ani",		"adaptive noise immunity" },
 	{ ATH5K_DEBUG_ANY,	"all",		"show all debug levels" },
 };
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index c7a0769..606ae94 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -116,18 +116,12 @@ enum ath5k_debug_level {
 	ATH5K_DEBUG_DUMP_RX	= 0x00000100,
 	ATH5K_DEBUG_DUMP_TX	= 0x00000200,
 	ATH5K_DEBUG_DUMPBANDS	= 0x00000400,
-	ATH5K_DEBUG_TRACE	= 0x00001000,
 	ATH5K_DEBUG_ANI		= 0x00002000,
 	ATH5K_DEBUG_ANY		= 0xffffffff
 };
 
 #ifdef CONFIG_ATH5K_DEBUG
 
-#define ATH5K_TRACE(_sc) do { \
-	if (unlikely((_sc)->debug.level & ATH5K_DEBUG_TRACE)) \
-		printk(KERN_DEBUG "ath5k trace %s:%d\n", __func__, __LINE__); \
-	} while (0)
-
 #define ATH5K_DBG(_sc, _m, _fmt, ...) do { \
 	if (unlikely((_sc)->debug.level & (_m) && net_ratelimit())) \
 		ATH5K_PRINTK(_sc, KERN_DEBUG, "(%s:%d): " _fmt, \
@@ -169,8 +163,6 @@ ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf);
 
 #include <linux/compiler.h>
 
-#define ATH5K_TRACE(_sc) typecheck(struct ath5k_softc *, (_sc))
-
 static inline void __attribute__ ((format (printf, 3, 4)))
 ATH5K_DBG(struct ath5k_softc *sc, unsigned int m, const char *fmt, ...) {}
 
diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index 7d7b646..da5dbb6 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -176,7 +176,6 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	struct ath5k_hw_4w_tx_ctl *tx_ctl;
 	unsigned int frame_len;
 
-	ATH5K_TRACE(ah->ah_sc);
 	tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
 
 	/*
@@ -342,8 +341,6 @@ static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
 	struct ath5k_hw_2w_tx_ctl *tx_ctl;
 	struct ath5k_hw_tx_status *tx_status;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	tx_ctl = &desc->ud.ds_tx5210.tx_ctl;
 	tx_status = &desc->ud.ds_tx5210.tx_stat;
 
@@ -396,8 +393,6 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 	struct ath5k_hw_4w_tx_ctl *tx_ctl;
 	struct ath5k_hw_tx_status *tx_status;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
 	tx_status = &desc->ud.ds_tx5212.tx_stat;
 
@@ -490,7 +485,6 @@ static int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 {
 	struct ath5k_hw_rx_ctl *rx_ctl;
 
-	ATH5K_TRACE(ah->ah_sc);
 	rx_ctl = &desc->ud.ds_rx.rx_ctl;
 
 	/*
@@ -593,7 +587,6 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 	struct ath5k_hw_rx_status *rx_status;
 	struct ath5k_hw_rx_error *rx_err;
 
-	ATH5K_TRACE(ah->ah_sc);
 	rx_status = &desc->ud.ds_rx.u.rx_stat;
 
 	/* Overlay on error */
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index 941b511..484f318 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -48,7 +48,6 @@
  */
 void ath5k_hw_start_rx_dma(struct ath5k_hw *ah)
 {
-	ATH5K_TRACE(ah->ah_sc);
 	ath5k_hw_reg_write(ah, AR5K_CR_RXE, AR5K_CR);
 	ath5k_hw_reg_read(ah, AR5K_CR);
 }
@@ -62,7 +61,6 @@ int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
 {
 	unsigned int i;
 
-	ATH5K_TRACE(ah->ah_sc);
 	ath5k_hw_reg_write(ah, AR5K_CR_RXD, AR5K_CR);
 
 	/*
@@ -96,8 +94,6 @@ u32 ath5k_hw_get_rxdp(struct ath5k_hw *ah)
  */
 void ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr)
 {
-	ATH5K_TRACE(ah->ah_sc);
-
 	ath5k_hw_reg_write(ah, phys_addr, AR5K_RXDP);
 }
 
@@ -125,7 +121,6 @@ int ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 {
 	u32 tx_queue;
 
-	ATH5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/* Return if queue is declared inactive */
@@ -186,7 +181,6 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 	unsigned int i = 40;
 	u32 tx_queue, pending;
 
-	ATH5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/* Return if queue is declared inactive */
@@ -297,7 +291,6 @@ u32 ath5k_hw_get_txdp(struct ath5k_hw *ah, unsigned int queue)
 {
 	u16 tx_reg;
 
-	ATH5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/*
@@ -340,7 +333,6 @@ int ath5k_hw_set_txdp(struct ath5k_hw *ah, unsigned int queue, u32 phys_addr)
 {
 	u16 tx_reg;
 
-	ATH5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/*
@@ -400,8 +392,6 @@ int ath5k_hw_update_tx_triglevel(struct ath5k_hw *ah, bool increase)
 	u32 trigger_level, imr;
 	int ret = -EIO;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	/*
 	 * Disable interrupts by setting the mask
 	 */
@@ -451,7 +441,6 @@ done:
  */
 bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah)
 {
-	ATH5K_TRACE(ah->ah_sc);
 	return ath5k_hw_reg_read(ah, AR5K_INTPEND) == 1 ? 1 : 0;
 }
 
@@ -475,8 +464,6 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 {
 	u32 data;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	/*
 	 * Read interrupt status from the Interrupt Status register
 	 * on 5210
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index ed02636..155a82c 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -35,7 +35,6 @@ static int ath5k_hw_eeprom_read(struct ath5k_hw *ah, u32 offset, u16 *data)
 {
 	u32 status, timeout;
 
-	ATH5K_TRACE(ah->ah_sc);
 	/*
 	 * Initialize EEPROM access
 	 */
diff --git a/drivers/net/wireless/ath/ath5k/gpio.c b/drivers/net/wireless/ath/ath5k/gpio.c
index 64a27e7..bc90503 100644
--- a/drivers/net/wireless/ath/ath5k/gpio.c
+++ b/drivers/net/wireless/ath/ath5k/gpio.c
@@ -34,8 +34,6 @@ void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state)
 	/*5210 has different led mode handling*/
 	u32 led_5210;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	/*Reset led status*/
 	if (ah->ah_version != AR5K_AR5210)
 		AR5K_REG_DISABLE_BITS(ah, AR5K_PCICFG,
@@ -82,7 +80,6 @@ void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state)
  */
 int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio)
 {
-	ATH5K_TRACE(ah->ah_sc);
 	if (gpio >= AR5K_NUM_GPIO)
 		return -EINVAL;
 
@@ -98,7 +95,6 @@ int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio)
  */
 int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio)
 {
-	ATH5K_TRACE(ah->ah_sc);
 	if (gpio >= AR5K_NUM_GPIO)
 		return -EINVAL;
 
@@ -114,7 +110,6 @@ int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio)
  */
 u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio)
 {
-	ATH5K_TRACE(ah->ah_sc);
 	if (gpio >= AR5K_NUM_GPIO)
 		return 0xffffffff;
 
@@ -129,7 +124,6 @@ u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio)
 int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val)
 {
 	u32 data;
-	ATH5K_TRACE(ah->ah_sc);
 
 	if (gpio >= AR5K_NUM_GPIO)
 		return -EINVAL;
@@ -153,7 +147,6 @@ void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio,
 {
 	u32 data;
 
-	ATH5K_TRACE(ah->ah_sc);
 	if (gpio >= AR5K_NUM_GPIO)
 		return;
 
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 5212e27..86fdb6d 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -59,8 +59,6 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
 
 	beacon_reg = 0;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	switch (op_mode) {
 	case NL80211_IFTYPE_ADHOC:
 		pcu_reg |= AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_KEYSRCH_MODE;
@@ -173,7 +171,6 @@ void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high)
  */
 static int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
-	ATH5K_TRACE(ah->ah_sc);
 	if (ath5k_hw_clocktoh(ah, AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK))
 			<= timeout)
 		return -EINVAL;
@@ -192,7 +189,6 @@ static int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
  */
 static int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
-	ATH5K_TRACE(ah->ah_sc);
 	if (ath5k_hw_clocktoh(ah, AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS))
 			<= timeout)
 		return -EINVAL;
@@ -297,7 +293,6 @@ int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
 	u32 low_id, high_id;
 	u32 pcu_reg;
 
-	ATH5K_TRACE(ah->ah_sc);
 	/* Set new station ID */
 	memcpy(common->macaddr, mac, ETH_ALEN);
 
@@ -357,7 +352,6 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah)
 void ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
-	ATH5K_TRACE(ah->ah_sc);
 
 	/* Cache bssid mask so that we can restore it
 	 * on reset */
@@ -382,7 +376,6 @@ void ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
  */
 void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
 {
-	ATH5K_TRACE(ah->ah_sc);
 	AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
 }
 
@@ -397,7 +390,6 @@ void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
  */
 void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah)
 {
-	ATH5K_TRACE(ah->ah_sc);
 	AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
 }
 
@@ -406,8 +398,6 @@ void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah)
  */
 void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1)
 {
-	ATH5K_TRACE(ah->ah_sc);
-	/* Set the multicat filter */
 	ath5k_hw_reg_write(ah, filter0, AR5K_MCAST_FILTER0);
 	ath5k_hw_reg_write(ah, filter1, AR5K_MCAST_FILTER1);
 }
@@ -427,7 +417,6 @@ u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah)
 {
 	u32 data, filter = 0;
 
-	ATH5K_TRACE(ah->ah_sc);
 	filter = ath5k_hw_reg_read(ah, AR5K_RX_FILTER);
 
 	/*Radar detection for 5212*/
@@ -457,8 +446,6 @@ void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter)
 {
 	u32 data = 0;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	/* Set PHY error filter register on 5212*/
 	if (ah->ah_version == AR5K_AR5212) {
 		if (filter & AR5K_RX_FILTER_RADARERR)
@@ -533,8 +520,6 @@ u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
 
 	WARN_ON( i == ATH5K_MAX_TSF_READ );
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	return (((u64)tsf_upper1 << 32) | tsf_lower);
 }
 
@@ -548,8 +533,6 @@ u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
  */
 void ath5k_hw_set_tsf64(struct ath5k_hw *ah, u64 tsf64)
 {
-	ATH5K_TRACE(ah->ah_sc);
-
 	ath5k_hw_reg_write(ah, tsf64 & 0xffffffff, AR5K_TSF_L32);
 	ath5k_hw_reg_write(ah, (tsf64 >> 32) & 0xffffffff, AR5K_TSF_U32);
 }
@@ -565,8 +548,6 @@ void ath5k_hw_reset_tsf(struct ath5k_hw *ah)
 {
 	u32 val;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	val = ath5k_hw_reg_read(ah, AR5K_BEACON) | AR5K_BEACON_RESET_TSF;
 
 	/*
@@ -586,7 +567,6 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 {
 	u32 timer1, timer2, timer3;
 
-	ATH5K_TRACE(ah->ah_sc);
 	/*
 	 * Set the additional timers by mode
 	 */
@@ -674,7 +654,6 @@ int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
 	unsigned int i, type;
 	u16 micentry = entry + AR5K_KEYTABLE_MIC_OFFSET;
 
-	ATH5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
 
 	type = ath5k_hw_reg_read(ah, AR5K_KEYTABLE_TYPE(entry));
@@ -749,8 +728,6 @@ int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
 	bool is_tkip;
 	const u8 *key_ptr;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	is_tkip = (key->alg == ALG_TKIP);
 
 	/*
@@ -836,7 +813,6 @@ int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac)
 {
 	u32 low_id, high_id;
 
-	ATH5K_TRACE(ah->ah_sc);
 	 /* Invalid entry (key table overflow) */
 	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
 
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 0b24081..f369e7e 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -378,8 +378,6 @@ enum ath5k_rfgain ath5k_hw_gainf_calibrate(struct ath5k_hw *ah)
 	u32 data, type;
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	if (ah->ah_rf_banks == NULL ||
 	ah->ah_gain.g_state == AR5K_RFGAIN_INACTIVE)
 		return AR5K_RFGAIN_INACTIVE;
@@ -1353,7 +1351,6 @@ ath5k_hw_rf511x_iq_calibrate(struct ath5k_hw *ah)
 	u32 i_pwr, q_pwr;
 	s32 iq_corr, i_coff, i_coffd, q_coff, q_coffd;
 	int i;
-	ATH5K_TRACE(ah->ah_sc);
 
 	if (!ah->ah_calibration ||
 		ath5k_hw_reg_read(ah, AR5K_PHY_IQ) & AR5K_PHY_IQ_RUN)
@@ -1680,7 +1677,6 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 
 int ath5k_hw_phy_disable(struct ath5k_hw *ah)
 {
-	ATH5K_TRACE(ah->ah_sc);
 	/*Just a try M.F.*/
 	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
 
@@ -1696,8 +1692,6 @@ u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan)
 	u32 srev;
 	u16 ret;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	/*
 	 * Set the radio chip access register
 	 */
@@ -1742,8 +1736,6 @@ u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan)
 static void /*TODO:Boundary check*/
 ath5k_hw_set_def_antenna(struct ath5k_hw *ah, u8 ant)
 {
-	ATH5K_TRACE(ah->ah_sc);
-
 	if (ah->ah_version != AR5K_AR5210)
 		ath5k_hw_reg_write(ah, ant & 0x7, AR5K_DEFAULT_ANTENNA);
 }
@@ -1803,8 +1795,6 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
 
 	def_ant = ah->ah_def_ant;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	switch (channel->hw_value & CHANNEL_MODES) {
 	case CHANNEL_A:
 	case CHANNEL_T:
@@ -2970,7 +2960,6 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	u8 type;
 	int ret;
 
-	ATH5K_TRACE(ah->ah_sc);
 	if (txpower > AR5K_TUNE_MAX_TXPOWER) {
 		ATH5K_ERR(ah->ah_sc, "invalid tx power: %u\n", txpower);
 		return -EINVAL;
@@ -3066,8 +3055,6 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 	struct ieee80211_channel *channel = ah->ah_current_channel;
 	u8 ee_mode;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	switch (channel->hw_value & CHANNEL_MODES) {
 	case CHANNEL_A:
 	case CHANNEL_T:
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index f5831da..4186ff4 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -31,7 +31,6 @@ Queue Control Unit, DFS Control Unit Functions
 int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
 		struct ath5k_txq_info *queue_info)
 {
-	ATH5K_TRACE(ah->ah_sc);
 	memcpy(queue_info, &ah->ah_txq[queue], sizeof(struct ath5k_txq_info));
 	return 0;
 }
@@ -42,7 +41,6 @@ int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
 int ath5k_hw_set_tx_queueprops(struct ath5k_hw *ah, int queue,
 				const struct ath5k_txq_info *queue_info)
 {
-	ATH5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
@@ -69,8 +67,6 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 	unsigned int queue;
 	int ret;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	/*
 	 * Get queue by type
 	 */
@@ -149,7 +145,6 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue)
 {
 	u32 pending;
-	ATH5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/* Return if queue is declared inactive */
@@ -177,7 +172,6 @@ u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue)
  */
 void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 {
-	ATH5K_TRACE(ah->ah_sc);
 	if (WARN_ON(queue >= ah->ah_capabilities.cap_queues.q_tx_num))
 		return;
 
@@ -195,7 +189,6 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 	u32 cw_min, cw_max, retry_lg, retry_sh;
 	struct ath5k_txq_info *tq = &ah->ah_txq[queue];
 
-	ATH5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	tq = &ah->ah_txq[queue];
@@ -523,8 +516,6 @@ int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time)
 {
 	u32 slot_time_clock = ath5k_hw_htoclock(ah, slot_time);
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	if (slot_time < 6 || slot_time_clock > AR5K_SLOT_TIME_MAX)
 		return -EINVAL;
 
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 44bbbf2..5e23e61 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -201,8 +201,6 @@ static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
 	int ret;
 	u32 mask = val ? val : ~0U;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	/* Read-and-clear RX Descriptor Pointer*/
 	ath5k_hw_reg_read(ah, AR5K_RXDP);
 
@@ -246,7 +244,6 @@ static int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
 	unsigned int i;
 	u32 staid, data;
 
-	ATH5K_TRACE(ah->ah_sc);
 	staid = ath5k_hw_reg_read(ah, AR5K_STA_ID1);
 
 	switch (mode) {
@@ -393,8 +390,6 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	mode = 0;
 	clock = 0;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	/* Wakeup the device */
 	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
 	if (ret) {
@@ -899,8 +894,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	u8 mode, freq, ee_mode, ant[2];
 	int i, ret;
 
-	ATH5K_TRACE(ah->ah_sc);
-
 	s_ant = 0;
 	ee_mode = 0;
 	staid1_flags = 0;

