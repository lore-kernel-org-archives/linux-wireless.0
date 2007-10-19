Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:39350 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbXJSOWs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 10:22:48 -0400
Date: Fri, 19 Oct 2007 13:56:19 +0000
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com
Subject: RE: [PATCH 4/4] ath5k: Maintain naming scheme
Message-ID: <20071019135619.GA25036@localhost.domain.invalid> (sfid-20071019_152300_516759_B4B3480C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This time i used mutt ;-)

---
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index de4a53a..795d7dd 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -26,7 +26,7 @@
 #define CHAN_DEBUG	0
 
 /* Uncomment this for debuging (warning that it results in TOO much output) */
-/*#define AR5K_DEBUG	1 */
+/* #define AR5K_DEBUG	1 */
 
 #include <linux/io.h>
 #include <linux/types.h>
@@ -206,6 +206,7 @@ enum ath5k_radio {
  *     algorithm. This is done transparently. Once this feature is enabled,
  *     compression and decompression takes place inside the chipset, without
  *     putting additional load on the host CPU.
+ *
  */
 #define MODULATION_TURBO	0x00000080
 
@@ -230,7 +231,7 @@ enum ath5k_vendor_mode {
 /*
  * Tx Descriptor
  */
-struct ath_tx_status {
+struct ath5k_tx_status {
 	u16	ts_seqnum;
 	u16	ts_tstamp;
 	u8	ts_status;
@@ -277,7 +278,7 @@ enum ath5k_tx_queue_subtype {
 };
 
 /*
- * Queue ID numbers as returned by the HAL, each number
+ * Queue ID numbers as returned by the hw functions, each number
  * represents a hw queue. If hw does not support hw queues
  * (eg 5210) all data goes in one queue. These match
  * d80211 definitions (net80211/MadWiFi don't use them).
@@ -297,6 +298,8 @@ enum ath5k_tx_queue_id {
 
 /*
  * Flags to set hw queue's parameters...
+ * TODO: Implement missing stuff (almost there,
+ * probably have to tweak with SISR).
  */
 #define AR5K_TXQ_FLAG_TXINT_ENABLE		0x0001	/* Enable TXOK and TXERR interrupts -not used- */
 #define AR5K_TXQ_FLAG_TXDESCINT_ENABLE		0x0002	/* Enable TXDESC interrupt -not implemented- */
@@ -321,7 +324,6 @@ struct ath5k_txq_info {
 	u32	tqi_cbr_overflow_limit;
 	u32	tqi_burst_time;
 	u32	tqi_ready_time; /* Not used */
-	u32	tqi_comp_buffer;/* Compression Buffer's phys addr */
 };
 
 /*
@@ -342,11 +344,11 @@ enum ath5k_pkt_type {
  */
 #define AR5K_TXPOWER_OFDM(_r, _v)	(			\
 	((0 & 1) << ((_v) + 6)) |				\
-	(((hal->ah_txpower.txp_rates[(_r)]) & 0x3f) << (_v))	\
+	(((ah->ah_txpower.txp_rates[(_r)]) & 0x3f) << (_v))	\
 )
 
 #define AR5K_TXPOWER_CCK(_r, _v)	(			\
-	(hal->ah_txpower.txp_rates[(_r)] & 0x3f) << (_v)	\
+	(ah->ah_txpower.txp_rates[(_r)] & 0x3f) << (_v)	\
 )
 
 /*
@@ -451,7 +453,7 @@ enum ath5k_dmasize {
 /*
  * Rx Descriptor
  */
-struct ath_rx_status {
+struct ath5k_rx_status {
 	u16	rs_datalen;
 	u16	rs_tstamp;
 	u8	rs_status;
@@ -519,7 +521,7 @@ struct ath5k_beacon_state {
 /*
  * Atheros descriptor
  */
-struct ath_desc {
+struct ath5k_desc {
 	u32	ds_link;
 	u32	ds_data;
 	u32	ds_ctl0;
@@ -527,8 +529,8 @@ struct ath_desc {
 	u32	ds_hw[4];
 
 	union {
-		struct ath_rx_status rx;
-		struct ath_tx_status tx;
+		struct ath5k_rx_status rx;
+		struct ath5k_tx_status tx;
 	} ds_us;
 
 #define ds_rxstat ds_us.rx
@@ -593,6 +595,8 @@ struct ath5k_athchan_2ghz {
 
 /*
  * Rate definitions
+ * TODO: Clean them up or move them on mac80211 -most of these infos are
+ * 	 used by the rate control algorytm on MadWiFi.
  */
 
 #define AR5K_MAX_RATES	32 /*max number of rates on the rate table*/
@@ -600,14 +604,15 @@ struct ath5k_athchan_2ghz {
 struct ath5k_rate {
 	u8	valid;		/* Valid for rate control */
 	u32	modulation;
-	u16	rate_kbps;
+	u16	rate_kbps;	/* Rate in kbps used in computetxtime */
 	u8	rate_code;	/* Rate mapping for h/w descriptors */
 	u8	dot11_rate;
-	u8	control_rate;
-	u16	lp_ack_duration;/* long preamble ACK duration */
-	u16	sp_ack_duration;/* short preamble ACK duration*/
+	u8	control_rate;	/* Rate for management frames -not used */
+	u16	lp_ack_duration;/* long preamble ACK duration -not used */
+	u16	sp_ack_duration;/* short preamble ACK duration -not used */
 };
 
+/* XXX: GRR all this stuff to get leds blinking ??? (check out setcurmode) */
 struct ath5k_rate_table {
 	u16	rate_count;
 	u8	rate_code_to_index[AR5K_MAX_RATES];	/* Back-mapping */
@@ -720,7 +725,7 @@ enum ath5k_ant_setting {
 };
 
 /*
- * HAL interrupt abstraction
+ * Hardware interrupt abstraction
  */
 
 /**
@@ -734,7 +739,7 @@ enum ath5k_ant_setting {
  * 	Queue Control Unit (QCU) signals an EOL interrupt only if a descriptor's
  * 	LinkPtr is NULL. For more details, refer to:
  * 	http://www.freepatentsonline.com/20030225739.html
- * @AR5K_INT_RXORN: indicates a hardware reset is required on certain hardware.
+ * @AR5K_INT_RXORN: Indicates we got RX overrun (eg. no more descriptors).
  * 	Note that Rx overrun is not always fatal, on some chips we can continue
  * 	operation without reseting the card, that's why int_fatal is not
  * 	common for all chips.
@@ -836,7 +841,7 @@ enum ath5k_power_mode {
 #define AR5K_SOFTLED_OFF	1
 
 /*
- * Chipset capabilities -see ath_hal_getcapability-
+ * Chipset capabilities -see ath5k_hw_get_capability-
  * get_capability function is not yet fully implemented
  * in OpenHAL so most of these don't work yet...
  */
@@ -913,7 +918,7 @@ struct ath5k_capabilities {
 #define AR5K_MAX_GPIO		10
 #define AR5K_MAX_RF_BANKS	8
 
-struct ath_hw {
+struct ath5k_hw {
 	u32			ah_magic;
 
 	void			*ah_sc;
@@ -997,17 +1002,17 @@ struct ath_hw {
 	/*
 	 * Function pointers
 	 */
-	int (*ah_setup_tx_desc)(struct ath_hw *, struct ath_desc *,
+	int (*ah_setup_tx_desc)(struct ath5k_hw *, struct ath5k_desc *,
 		unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
 		unsigned int, unsigned int, unsigned int, unsigned int,
 		unsigned int, unsigned int, unsigned int);
-	bool (*ah_setup_xtx_desc)(struct ath_hw *, struct ath_desc *,
+	bool (*ah_setup_xtx_desc)(struct ath5k_hw *, struct ath5k_desc *,
 		unsigned int, unsigned int, unsigned int, unsigned int,
 		unsigned int, unsigned int);
-	int (*ah_fill_tx_desc)(struct ath_hw *, struct ath_desc *,
+	int (*ah_fill_tx_desc)(struct ath5k_hw *, struct ath5k_desc *,
 		unsigned int, bool, bool);
-	int (*ah_proc_tx_desc)(struct ath_hw *, struct ath_desc *);
-	int (*ah_proc_rx_desc)(struct ath_hw *, struct ath_desc *);
+	int (*ah_proc_tx_desc)(struct ath5k_hw *, struct ath5k_desc *);
+	int (*ah_proc_rx_desc)(struct ath5k_hw *, struct ath5k_desc *);
 };
 
 /*
@@ -1015,123 +1020,123 @@ struct ath_hw {
  */
 
 /* General Functions */
-extern int ath5k_hw_register_timeout(struct ath_hw *hal, u32 reg, u32 flag, u32 val, bool is_set);
+extern int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val, bool is_set);
 /* Attach/Detach Functions */
-extern struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc, void __iomem *sh);
-extern const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath_hw *hal, unsigned int mode);
-extern void ath5k_hw_detach(struct ath_hw *hal);
+extern struct ath5k_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc, void __iomem *sh);
+extern const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath5k_hw *ah, unsigned int mode);
+extern void ath5k_hw_detach(struct ath5k_hw *ah);
 /* Reset Functions */
-extern int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode, struct ieee80211_channel *channel, bool change_channel);
+extern int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode, struct ieee80211_channel *channel, bool change_channel);
 /* Power management functions */
-extern int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode, bool set_chip, u16 sleep_duration);
+extern int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode, bool set_chip, u16 sleep_duration);
 /* DMA Related Functions */
-extern void ath5k_hw_start_rx(struct ath_hw *hal);
-extern int ath5k_hw_stop_rx_dma(struct ath_hw *hal);
-extern u32 ath5k_hw_get_rx_buf(struct ath_hw *hal);
-extern void ath5k_hw_put_rx_buf(struct ath_hw *hal, u32 phys_addr);
-extern int ath5k_hw_tx_start(struct ath_hw *hal, unsigned int queue);
-extern int ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue);
-extern u32 ath5k_hw_get_tx_buf(struct ath_hw *hal, unsigned int queue);
-extern int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr);
-extern int ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase);
+extern void ath5k_hw_start_rx(struct ath5k_hw *ah);
+extern int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah);
+extern u32 ath5k_hw_get_rx_buf(struct ath5k_hw *ah);
+extern void ath5k_hw_put_rx_buf(struct ath5k_hw *ah, u32 phys_addr);
+extern int ath5k_hw_tx_start(struct ath5k_hw *ah, unsigned int queue);
+extern int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue);
+extern u32 ath5k_hw_get_tx_buf(struct ath5k_hw *ah, unsigned int queue);
+extern int ath5k_hw_put_tx_buf(struct ath5k_hw *ah, unsigned int queue, u32 phys_addr);
+extern int ath5k_hw_update_tx_triglevel(struct ath5k_hw *ah, bool increase);
 /* Interrupt handling */
-extern bool ath5k_hw_is_intr_pending(struct ath_hw *hal);
-extern int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask);
-extern enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask);
+extern bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah);
+extern int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask);
+extern enum ath5k_int ath5k_hw_set_intr(struct ath5k_hw *ah, enum ath5k_int new_mask);
 /* EEPROM access functions */
-extern int ath5k_hw_set_regdomain(struct ath_hw *hal, u16 regdomain);
+extern int ath5k_hw_set_regdomain(struct ath5k_hw *ah, u16 regdomain);
 /* Protocol Control Unit Functions */
-extern int ath5k_hw_set_opmode(struct ath_hw *hal);
+extern int ath5k_hw_set_opmode(struct ath5k_hw *ah);
 /* BSSID Functions */
-extern void ath5k_hw_get_lladdr(struct ath_hw *hal, u8 *mac);
-extern int ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac);
-extern void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id);
-extern int ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask);
+extern void ath5k_hw_get_lladdr(struct ath5k_hw *ah, u8 *mac);
+extern int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac);
+extern void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id);
+extern int ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask);
 /* Receive start/stop functions */
-extern void ath5k_hw_start_rx_pcu(struct ath_hw *hal);
-extern void ath5k_hw_stop_pcu_recv(struct ath_hw *hal);
+extern void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah);
+extern void ath5k_hw_stop_pcu_recv(struct ath5k_hw *ah);
 /* RX Filter functions */
-extern void ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1);
-extern int ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index);
-extern int ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index);
-extern u32 ath5k_hw_get_rx_filter(struct ath_hw *ah);
-extern void ath5k_hw_set_rx_filter(struct ath_hw *ah, u32 filter);
+extern void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1);
+extern int ath5k_hw_set_mcast_filterindex(struct ath5k_hw *ah, u32 index);
+extern int ath5k_hw_clear_mcast_filter_idx(struct ath5k_hw *ah, u32 index);
+extern u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah);
+extern void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter);
 /* Beacon related functions */
-extern u32 ath5k_hw_get_tsf32(struct ath_hw *hal);
-extern u64 ath5k_hw_get_tsf64(struct ath_hw *hal);
-extern void ath5k_hw_reset_tsf(struct ath_hw *hal);
-extern void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval);
-extern int ath5k_hw_set_beacon_timers(struct ath_hw *hal, const struct ath5k_beacon_state *state);
-extern void ath5k_hw_reset_beacon(struct ath_hw *hal);
-extern int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr);
-extern void ath5k_hw_update_mib_counters(struct ath_hw *hal, struct ath5k_mib_stats *statistics);
+extern u32 ath5k_hw_get_tsf32(struct ath5k_hw *ah);
+extern u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah);
+extern void ath5k_hw_reset_tsf(struct ath5k_hw *ah);
+extern void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval);
+extern int ath5k_hw_set_beacon_timers(struct ath5k_hw *ah, const struct ath5k_beacon_state *state);
+extern void ath5k_hw_reset_beacon(struct ath5k_hw *ah);
+extern int ath5k_hw_wait_for_beacon(struct ath5k_hw *ah, unsigned long phys_addr);
+extern void ath5k_hw_update_mib_counters(struct ath5k_hw *ah, struct ath5k_mib_stats *statistics);
 /* ACK/CTS Timeouts */
-extern int ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout);
-extern unsigned int ath5k_hw_get_ack_timeout(struct ath_hw *hal);
-extern int ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout);
-extern unsigned int ath5k_hw_get_cts_timeout(struct ath_hw *hal);
+extern int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout);
+extern unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah);
+extern int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout);
+extern unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah);
 /* Key table (WEP) functions */
-extern int ath5k_hw_reset_key(struct ath_hw *hal, u16 entry);
-extern int ath5k_hw_is_key_valid(struct ath_hw *hal, u16 entry);
-extern int ath5k_hw_set_key(struct ath_hw *hal, u16 entry, const struct ieee80211_key_conf *key, const u8 *mac);
-extern int ath5k_hw_set_key_lladdr(struct ath_hw *hal, u16 entry, const u8 *mac);
+extern int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry);
+extern int ath5k_hw_is_key_valid(struct ath5k_hw *ah, u16 entry);
+extern int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry, const struct ieee80211_key_conf *key, const u8 *mac);
+extern int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac);
 /* Queue Control Unit, DFS Control Unit Functions */
-extern int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type, struct ath5k_txq_info *queue_info);
-extern int ath5k_hw_setup_tx_queueprops(struct ath_hw *hal, int queue, const struct ath5k_txq_info *queue_info);
-extern int ath5k_hw_get_tx_queueprops(struct ath_hw *hal, int queue, struct ath5k_txq_info *queue_info);
-extern void ath5k_hw_release_tx_queue(struct ath_hw *hal, unsigned int queue);
-extern int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue);
-extern u32 ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue);
-extern int ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time);
-extern unsigned int ath5k_hw_get_slot_time(struct ath_hw *hal);
+extern int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type, struct ath5k_txq_info *queue_info);
+extern int ath5k_hw_setup_tx_queueprops(struct ath5k_hw *ah, int queue, const struct ath5k_txq_info *queue_info);
+extern int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue, struct ath5k_txq_info *queue_info);
+extern void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue);
+extern int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue);
+extern u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue);
+extern int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time);
+extern unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah);
 /* Hardware Descriptor Functions */
-extern int ath5k_hw_setup_rx_desc(struct ath_hw *hal, struct ath_desc *desc, u32 size, unsigned int flags);
+extern int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc, u32 size, unsigned int flags);
 /* GPIO Functions */
-extern void ath5k_hw_set_ledstate(struct ath_hw *hal, unsigned int state);
-extern int ath5k_hw_set_gpio_output(struct ath_hw *hal, u32 gpio);
-extern int ath5k_hw_set_gpio_input(struct ath_hw *hal, u32 gpio);
-extern u32 ath5k_hw_get_gpio(struct ath_hw *hal, u32 gpio);
-extern int ath5k_hw_set_gpio(struct ath_hw *hal, u32 gpio, u32 val);
-extern void ath5k_hw_set_gpio_intr(struct ath_hw *hal, unsigned int gpio, u32 interrupt_level);
+extern void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state);
+extern int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio);
+extern int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio);
+extern u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio);
+extern int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val);
+extern void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio, u32 interrupt_level);
 /* Regulatory Domain/Channels Setup */
-extern u16 ath5k_get_regdomain(struct ath_hw *hal);
+extern u16 ath5k_get_regdomain(struct ath5k_hw *ah);
 /* Misc functions */
-extern void ath5k_hw_dump_state(struct ath_hw *hal);
-extern int ath5k_hw_get_capability(struct ath_hw *hal, enum ath5k_capability_type cap_type, u32 capability, u32 *result);
+extern void ath5k_hw_dump_state(struct ath5k_hw *ah);
+extern int ath5k_hw_get_capability(struct ath5k_hw *ah, enum ath5k_capability_type cap_type, u32 capability, u32 *result);
 
 
 /* Initial register settings functions */
-extern int ath5k_hw_write_initvals(struct ath_hw *hal, u8 mode, bool change_channel);
+extern int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel);
 /* Initialize RF */
-extern int ath5k_hw_rfregs(struct ath_hw *hal, struct ieee80211_channel *channel, unsigned int mode);
-extern int ath5k_hw_rfgain(struct ath_hw *hal, unsigned int freq);
-extern enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath_hw *hal);
-extern int ath5k_hw_set_rfgain_opt(struct ath_hw *hal);
+extern int ath5k_hw_rfregs(struct ath5k_hw *ah, struct ieee80211_channel *channel, unsigned int mode);
+extern int ath5k_hw_rfgain(struct ath5k_hw *ah, unsigned int freq);
+extern enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath5k_hw *ah);
+extern int ath5k_hw_set_rfgain_opt(struct ath5k_hw *ah);
 
 
 /* PHY/RF channel functions */
-extern bool ath5k_channel_ok(struct ath_hw *hal, u16 freq, unsigned int flags);
-extern int ath5k_hw_channel(struct ath_hw *hal, struct ieee80211_channel *channel);
+extern bool ath5k_channel_ok(struct ath5k_hw *ah, u16 freq, unsigned int flags);
+extern int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel);
 /* PHY calibration */
-extern int ath5k_hw_phy_calibrate(struct ath_hw *hal, struct ieee80211_channel *channel);
-extern int ath5k_hw_phy_disable(struct ath_hw *hal);
+extern int ath5k_hw_phy_calibrate(struct ath5k_hw *ah, struct ieee80211_channel *channel);
+extern int ath5k_hw_phy_disable(struct ath5k_hw *ah);
 /* Misc PHY functions */
-extern u16 ath5k_hw_radio_revision(struct ath_hw *hal, unsigned int chan);
-extern void ath5k_hw_set_def_antenna(struct ath_hw *hal, unsigned int ant);
-extern unsigned int ath5k_hw_get_def_antenna(struct ath_hw *hal);
+extern u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan);
+extern void ath5k_hw_set_def_antenna(struct ath5k_hw *ah, unsigned int ant);
+extern unsigned int ath5k_hw_get_def_antenna(struct ath5k_hw *ah);
 /* TX power setup */
-extern int ath5k_hw_txpower(struct ath_hw *hal, struct ieee80211_channel *channel, unsigned int txpower);
-extern int ath5k_hw_set_txpower_limit(struct ath_hw *hal, unsigned int power);
+extern int ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel, unsigned int txpower);
+extern int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, unsigned int power);
 
 
-static inline u32 ath5k_hw_reg_read(struct ath_hw *hal, u16 reg)
+static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
 {
-	return ioread32(hal->ah_sh + reg);
+	return ioread32(ah->ah_sh + reg);
 }
 
-static inline void ath5k_hw_reg_write(struct ath_hw *hal, u32 val, u16 reg)
+static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
 {
-	iowrite32(val, hal->ah_sh + reg);
+	iowrite32(val, ah->ah_sh + reg);
 }
 
 #endif
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 86606ce..2596153 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -73,7 +73,7 @@
 } while (0)
 #else
 static inline int __attribute__ ((format (printf, 3, 4)))
-DPRINTF(struct ath_softc *sc, unsigned int m, const char *fmt, ...)
+DPRINTF(struct ath5k_softc *sc, unsigned int m, const char *fmt, ...)
 {
 	return 0;
 }
@@ -96,19 +96,17 @@ enum {
 	ATH_LED_RX,
 };
 
-static int ath_calinterval = 1; /* Calibrate PHY every 1 sec (TODO: Fixme) */
+static int ath5k_calinterval = 1; /* Calibrate PHY every 1 sec (TODO: Fixme) */
 
 #if AR_DEBUG
-static unsigned int ath_debug;
-module_param_named(debug, ath_debug, uint, 0);
+static unsigned int ath5k_debug;
+module_param_named(debug, ath5k_debug, uint, 0);
 #endif
 
 /*
- * User a static table of PCI id's for now.  While this is the
- * "new way" to do things, we may want to switch back to having
- * the HAL check them by defining a probe method.
+ * Static table of PCI id's.
  */
-static struct pci_device_id ath_pci_id_table[] __devinitdata = {
+static struct pci_device_id ath5k_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x0207), .driver_data = AR5K_AR5210 }, /* 5210 early */
 	{ PCI_VDEVICE(ATHEROS, 0x0007), .driver_data = AR5K_AR5210 }, /* 5210 */
 	{ PCI_VDEVICE(ATHEROS, 0x0011), .driver_data = AR5K_AR5211 }, /* 5311 */
@@ -128,15 +126,15 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x001c), .driver_data = AR5K_AR5212 }, /* 5424 Condor (PCI-E)*/
 	{ 0 }
 };
-MODULE_DEVICE_TABLE(pci, ath_pci_id_table);
+MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
 
-static void ath_led_event(struct ath_softc *, int);
-static int ath_reset(struct ieee80211_hw *);
+static void ath5k_led_event(struct ath5k_softc *, int);
+static int ath5k_reset(struct ieee80211_hw *);
 
 #if AR_DEBUG
-static void ath_printrxbuf(struct ath_buf *bf, int done)
+static void ath5k_printrxbuf(struct ath5k_buf *bf, int done)
 {
-	struct ath_desc *ds = bf->desc;
+	struct ath5k_desc *ds = bf->desc;
 
 	printk(KERN_DEBUG "R (%p %llx) %08x %08x %08x %08x %08x %08x %c\n",
 		ds, (unsigned long long)bf->daddr,
@@ -145,9 +143,9 @@ static void ath_printrxbuf(struct ath_buf *bf, int done)
 		!done ? ' ' : (ds->ds_rxstat.rs_status == 0) ? '*' : '!');
 }
 
-static void ath_printtxbuf(struct ath_buf *bf, int done)
+static void ath5k_printtxbuf(struct ath5k_buf *bf, int done)
 {
-	struct ath_desc *ds = bf->desc;
+	struct ath5k_desc *ds = bf->desc;
 
 	printk(KERN_DEBUG "T (%p %llx) %08x %08x %08x %08x %08x %08x %08x "
 		"%08x %c\n", ds, (unsigned long long)bf->daddr, ds->ds_link,
@@ -158,16 +156,16 @@ static void ath_printtxbuf(struct ath_buf *bf, int done)
 #endif
 
 #if ATH_DUMP_SKB
-static inline void ath_dump_skb(struct sk_buff *skb, const char *prefix)
+static inline void ath5k_dump_skb(struct sk_buff *skb, const char *prefix)
 {
 	print_hex_dump_bytes(prefix, DUMP_PREFIX_NONE, skb->data,
 			min(200U, skb->len));
 }
 #else
-static inline void ath_dump_skb(struct sk_buff *skb, const char *prefix) {}
+static inline void ath5k_dump_skb(struct sk_buff *skb, const char *prefix) {}
 #endif
 
-static inline void ath_cleanup_txbuf(struct ath_softc *sc, struct ath_buf *bf)
+static inline void ath5k_cleanup_txbuf(struct ath5k_softc *sc, struct ath5k_buf *bf)
 {
 	BUG_ON(!bf);
 	if (!bf->skb)
@@ -178,18 +176,18 @@ static inline void ath_cleanup_txbuf(struct ath_softc *sc, struct ath_buf *bf)
 	bf->skb = NULL;
 }
 
-static void ath_tasklet_reset(unsigned long data)
+static void ath5k_tasklet_reset(unsigned long data)
 {
-	struct ath_softc *sc = (void *)data;
+	struct ath5k_softc *sc = (void *)data;
 
-	ath_reset(sc->hw);
+	ath5k_reset(sc->hw);
 }
 
-static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
+static void ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 {
 	struct ieee80211_tx_status txs = {};
-	struct ath_buf *bf, *bf0;
-	struct ath_desc *ds;
+	struct ath5k_buf *bf, *bf0;
+	struct ath5k_desc *ds;
 	struct sk_buff *skb;
 	int ret;
 
@@ -244,20 +242,20 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		ieee80211_wake_queues(sc->hw);
 }
 
-static void ath_tasklet_tx(unsigned long data)
+static void ath5k_tasklet_tx(unsigned long data)
 {
-	struct ath_softc *sc = (void *)data;
+	struct ath5k_softc *sc = (void *)data;
 
-	ath_tx_processq(sc, sc->txq);
+	ath5k_tx_processq(sc, sc->txq);
 
-	ath_led_event(sc, ATH_LED_TX);
+	ath5k_led_event(sc, ATH_LED_TX);
 }
 
-static int ath_rxbuf_init(struct ath_softc *sc, struct ath_buf *bf)
+static int ath5k_rxbuf_init(struct ath5k_softc *sc, struct ath5k_buf *bf)
 {
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_hw *ah = sc->ah;
 	struct sk_buff *skb = bf->skb;
-	struct ath_desc *ds;
+	struct ath5k_desc *ds;
 
 	if (likely(skb == NULL)) {
 		unsigned int off;
@@ -320,8 +318,8 @@ static int ath_rxbuf_init(struct ath_softc *sc, struct ath_buf *bf)
 	return 0;
 }
 
-static unsigned int ath_rx_decrypted(struct ath_softc *sc,
-		struct ath_desc *ds, struct sk_buff *skb)
+static unsigned int ath5k_rx_decrypted(struct ath5k_softc *sc,
+		struct ath5k_desc *ds, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int keyix, hlen = ieee80211_get_hdrlen_from_skb(skb);
@@ -331,7 +329,7 @@ static unsigned int ath_rx_decrypted(struct ath_softc *sc,
 		return RX_FLAG_DECRYPTED;
 
 	/* Apparently when a default key is used to decrypt the packet
-	   the hal does not set the index used to decrypt.  In such cases
+	   the hw does not set the index used to decrypt.  In such cases
 	   get the index from the packet. */
 	if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_PROTECTED) &&
 			!(ds->ds_rxstat.rs_status & AR5K_RXERR_DECRYPT) &&
@@ -345,7 +343,7 @@ static unsigned int ath_rx_decrypted(struct ath_softc *sc,
 	return 0;
 }
 
-static inline u64 ath_extend_tsf(struct ath_hw *ah, u32 rstamp)
+static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
 {
 	u64 tsf = ath5k_hw_get_tsf64(ah);
 
@@ -355,13 +353,13 @@ static inline u64 ath_extend_tsf(struct ath_hw *ah, u32 rstamp)
 	return (tsf & ~0x7fff) | rstamp;
 }
 
-static void ath_tasklet_rx(unsigned long data)
+static void ath5k_tasklet_rx(unsigned long data)
 {
 	struct ieee80211_rx_status rxs = {};
 	struct sk_buff *skb;
-	struct ath_softc *sc = (void *)data;
-	struct ath_buf *bf;
-	struct ath_desc *ds;
+	struct ath5k_softc *sc = (void *)data;
+	struct ath5k_buf *bf;
+	struct ath5k_desc *ds;
 	u16 len;
 	u8 stat;
 	int ret;
@@ -375,7 +373,7 @@ static void ath_tasklet_rx(unsigned long data)
 				printk(KERN_WARNING "ath: empty rx buf pool\n");
 			break;
 		}
-		bf = list_first_entry(&sc->rxbuf, struct ath_buf, list);
+		bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
 		BUG_ON(bf->skb == NULL);
 		skb = bf->skb;
 		ds = bf->desc;
@@ -456,7 +454,7 @@ accept:
 		}
 
 		if (sc->opmode == IEEE80211_IF_TYPE_MNTR)
-			rxs.mactime = ath_extend_tsf(sc->ah,
+			rxs.mactime = ath5k_extend_tsf(sc->ah,
 					ds->ds_rxstat.rs_tstamp);
 		else
 			rxs.mactime = ds->ds_rxstat.rs_tstamp;
@@ -466,28 +464,28 @@ accept:
 		rxs.ssi = ds->ds_rxstat.rs_rssi;
 		rxs.antenna = ds->ds_rxstat.rs_antenna;
 		rxs.rate = ds->ds_rxstat.rs_rate;
-		rxs.flag |= ath_rx_decrypted(sc, ds, skb);
+		rxs.flag |= ath5k_rx_decrypted(sc, ds, skb);
 
-		ath_dump_skb(skb, "r");
+		ath5k_dump_skb(skb, "r");
 
 		__ieee80211_rx(sc->hw, skb, &rxs);
 		sc->led_rxrate = ds->ds_rxstat.rs_rate;
-		ath_led_event(sc, ATH_LED_RX);
+		ath5k_led_event(sc, ATH_LED_RX);
 next:
 		list_move_tail(&bf->list, &sc->rxbuf);
-	} while (ath_rxbuf_init(sc, bf) == 0);
+	} while (ath5k_rxbuf_init(sc, bf) == 0);
 	spin_unlock(&sc->rxbuflock);
 }
 
 /*
  * Setup the beacon frame for transmit.
  */
-static int ath_beacon_setup(struct ath_softc *sc, struct ath_buf *bf,
+static int ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 		struct ieee80211_tx_control *ctl)
 {
 	struct sk_buff *skb = bf->skb;
-	struct ath_hw *ah = sc->ah;
-	struct ath_desc *ds;
+	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_desc *ds;
 	int ret, antenna = 0;
 	u32 flags;
 
@@ -543,14 +541,14 @@ err_unmap:
  * frame contents are done as needed and the slot time is
  * also adjusted based on current state.
  *
- * this is usually called from interrupt context (ath_intr())
- * but also from ath_beacon_config() in IBSS mode which in turn
+ * this is usually called from interrupt context (ath5k_intr())
+ * but also from ath5k_beacon_config() in IBSS mode which in turn
  * can be called from a tasklet and user context
  */
-static void ath_beacon_send(struct ath_softc *sc)
+static void ath5k_beacon_send(struct ath5k_softc *sc)
 {
-	struct ath_buf *bf = sc->bbuf;
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_buf *bf = sc->bbuf;
+	struct ath5k_hw *ah = sc->ah;
 
 	DPRINTF(sc, ATH_DEBUG_BEACON_PROC, "%s\n", __func__);
 
@@ -595,7 +593,7 @@ static void ath_beacon_send(struct ath_softc *sc)
 	if (unlikely(ath5k_hw_stop_tx_dma(ah, sc->bhalq))) {
 		printk(KERN_WARNING "ath: beacon queue %u didn't stop?\n",
 				sc->bhalq);
-		/* NB: the HAL still stops DMA, so proceed */
+		/* NB: hw still stops DMA, so proceed */
 	}
 	pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr, bf->skb->len,
 			PCI_DMA_TODEVICE);
@@ -608,9 +606,9 @@ static void ath_beacon_send(struct ath_softc *sc)
 	sc->bsent++;
 }
 
-static int ath_beaconq_config(struct ath_softc *sc)
+static int ath5k_beaconq_config(struct ath5k_softc *sc)
 {
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_hw *ah = sc->ah;
 	struct ath5k_txq_info qi;
 	int ret;
 
@@ -653,10 +651,10 @@ static int ath_beaconq_config(struct ath_softc *sc)
  * interrupt when we stop seeing beacons from the AP
  * we've associated with.
  */
-static void ath_beacon_config(struct ath_softc *sc)
+static void ath5k_beacon_config(struct ath5k_softc *sc)
 {
 #define TSF_TO_TU(_h, _l)	(((_h) << 22) | ((_l) >> 10))
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_hw *ah = sc->ah;
 	u32 uninitialized_var(nexttbtt), intval, tsftu;
 	u64 tsf;
 
@@ -704,7 +702,7 @@ static void ath_beacon_config(struct ath_softc *sc)
 
 		intval |= AR5K_BEACON_ENA;
 
-		ath_beaconq_config(sc);
+		ath5k_beaconq_config(sc);
 		ath5k_hw_init_beacon(ah, nexttbtt, intval);
 
 		sc->bmisscount = 0;
@@ -715,14 +713,14 @@ static void ath_beacon_config(struct ath_softc *sc)
 		 */
 		if (sc->opmode == IEEE80211_IF_TYPE_IBSS &&
 				ath5k_hw_hasveol(ah))
-			ath_beacon_send(sc);
+			ath5k_beacon_send(sc);
 	}
 #undef TSF_TO_TU
 }
 
-static void ath_mode_init(struct ath_softc *sc)
+static void ath5k_mode_init(struct ath5k_softc *sc)
 {
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_hw *ah = sc->ah;
 	u32 rfilt;
 
 	/* configure rx filter */
@@ -742,10 +740,10 @@ static void ath_mode_init(struct ath_softc *sc)
 /*
  * Enable the receive h/w following a reset.
  */
-static int ath_startrecv(struct ath_softc *sc)
+static int ath5k_startrecv(struct ath5k_softc *sc)
 {
-	struct ath_hw *ah = sc->ah;
-	struct ath_buf *bf;
+	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_buf *bf;
 	int ret;
 
 	sc->rxbufsize = roundup(IEEE80211_MAX_LEN, sc->cachelsz);
@@ -757,18 +755,18 @@ static int ath_startrecv(struct ath_softc *sc)
 
 	spin_lock_bh(&sc->rxbuflock);
 	list_for_each_entry(bf, &sc->rxbuf, list) {
-		ret = ath_rxbuf_init(sc, bf);
+		ret = ath5k_rxbuf_init(sc, bf);
 		if (ret != 0) {
 			spin_unlock_bh(&sc->rxbuflock);
 			goto err;
 		}
 	}
-	bf = list_first_entry(&sc->rxbuf, struct ath_buf, list);
+	bf = list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
 	spin_unlock_bh(&sc->rxbuflock);
 
 	ath5k_hw_put_rx_buf(ah, bf->daddr);
 	ath5k_hw_start_rx(ah);		/* enable recv descriptors */
-	ath_mode_init(sc);		/* set filters, etc. */
+	ath5k_mode_init(sc);		/* set filters, etc. */
 	ath5k_hw_start_rx_pcu(ah);	/* re-enable PCU/DMA engine */
 
 	return 0;
@@ -776,14 +774,14 @@ err:
 	return ret;
 }
 
-static inline void ath_update_txpow(struct ath_softc *sc)
+static inline void ath5k_update_txpow(struct ath5k_softc *sc)
 {
 	ath5k_hw_set_txpower_limit(sc->ah, 0);
 }
 
-static int ath_stop_locked(struct ath_softc *);
+static int ath5k_stop_locked(struct ath5k_softc *);
 
-static int ath_init(struct ath_softc *sc)
+static int ath5k_init(struct ath5k_softc *sc)
 {
 	int ret;
 
@@ -795,7 +793,7 @@ static int ath_init(struct ath_softc *sc)
 	 * Stop anything previously setup.  This is safe
 	 * no matter this is the first time through or not.
 	 */
-	ath_stop_locked(sc);
+	ath5k_stop_locked(sc);
 
 	/*
 	 * The basic interface to setting the hardware in a good
@@ -814,7 +812,7 @@ static int ath_init(struct ath_softc *sc)
 	 * This is needed only to setup initial state
 	 * but it's best done after a reset.
 	 */
-	ath_update_txpow(sc);
+	ath5k_update_txpow(sc);
 
 	/*
 	 * Setup the hardware after reset: the key cache
@@ -823,7 +821,7 @@ static int ath_init(struct ath_softc *sc)
 	 * in the frame output path; there's nothing to do
 	 * here except setup the interrupt mask.
 	 */
-	ret = ath_startrecv(sc);
+	ret = ath5k_startrecv(sc);
 	if (ret)
 		goto done;
 
@@ -836,7 +834,7 @@ static int ath_init(struct ath_softc *sc)
 	ath5k_hw_set_intr(sc->ah, sc->imask);
 
 	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
-			msecs_to_jiffies(ath_calinterval * 1000)));
+			msecs_to_jiffies(ath5k_calinterval * 1000)));
 
 	ret = 0;
 done:
@@ -847,9 +845,9 @@ done:
 /*
  * Disable the receive h/w in preparation for a reset.
  */
-static void ath_stoprecv(struct ath_softc *sc)
+static void ath5k_stoprecv(struct ath5k_softc *sc)
 {
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_hw *ah = sc->ah;
 
 	ath5k_hw_stop_pcu_recv(ah);	/* disable PCU */
 	ath5k_hw_set_rx_filter(ah, 0);	/* clear recv filter */
@@ -857,8 +855,8 @@ static void ath_stoprecv(struct ath_softc *sc)
 	mdelay(3);			/* 3ms is long enough for 1 frame */
 #if AR_DEBUG
 	if (unlikely(sc->debug & (ATH_DEBUG_RESET | ATH_DEBUG_FATAL))) {
-		struct ath_desc *ds;
-		struct ath_buf *bf;
+		struct ath5k_desc *ds;
+		struct ath5k_buf *bf;
 		int status;
 
 		printk(KERN_DEBUG "%s: rx queue %x, link %p\n", __func__,
@@ -869,7 +867,7 @@ static void ath_stoprecv(struct ath_softc *sc)
 			ds = bf->desc;
 			status = ah->ah_proc_rx_desc(ah, ds);
 			if (!status || (sc->debug & ATH_DEBUG_FATAL))
-				ath_printrxbuf(bf, status == 0);
+				ath5k_printrxbuf(bf, status == 0);
 		}
 		spin_unlock_bh(&sc->rxbuflock);
 	}
@@ -877,22 +875,22 @@ static void ath_stoprecv(struct ath_softc *sc)
 	sc->rxlink = NULL;		/* just in case */
 }
 
-static void ath_tx_draintxq(struct ath_softc *sc, struct ath_txq *txq)
+static void ath5k_tx_draintxq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 {
-	struct ath_buf *bf, *bf0;
+	struct ath5k_buf *bf, *bf0;
 
 	/*
 	 * NB: this assumes output has been stopped and
-	 *     we do not need to block ath_tx_tasklet
+	 *     we do not need to block ath5k_tx_tasklet
 	 */
 	spin_lock_bh(&txq->lock);
 	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
 #if AR_DEBUG
 		if (sc->debug & ATH_DEBUG_RESET)
-			ath_printtxbuf(bf, !sc->ah->ah_proc_tx_desc(sc->ah,
+			ath5k_printtxbuf(bf, !sc->ah->ah_proc_tx_desc(sc->ah,
 						bf->desc));
 #endif
-		ath_cleanup_txbuf(sc, bf);
+		ath5k_cleanup_txbuf(sc, bf);
 
 		spin_lock_bh(&sc->txbuflock);
 		sc->tx_stats.data[txq->qnum].len--;
@@ -907,9 +905,9 @@ static void ath_tx_draintxq(struct ath_softc *sc, struct ath_txq *txq)
 /*
  * Drain the transmit queues and reclaim resources.
  */
-static void ath_draintxq(struct ath_softc *sc)
+static void ath5k_draintxq(struct ath5k_softc *sc)
 {
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_hw *ah = sc->ah;
 	int i;
 
 	/* XXX return value */
@@ -933,12 +931,12 @@ static void ath_draintxq(struct ath_softc *sc)
 
 	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
 		if (sc->txqs[i].setup)
-			ath_tx_draintxq(sc, &sc->txqs[i]);
+			ath5k_tx_draintxq(sc, &sc->txqs[i]);
 }
 
-static int ath_stop_locked(struct ath_softc *sc)
+static int ath5k_stop_locked(struct ath5k_softc *sc)
 {
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_hw *ah = sc->ah;
 
 	DPRINTF(sc, ATH_DEBUG_RESET, "%s: invalid %u\n", __func__,
 			test_bit(ATH_STAT_INVALID, sc->status));
@@ -968,9 +966,9 @@ static int ath_stop_locked(struct ath_softc *sc)
 		}
 		ath5k_hw_set_intr(ah, 0);
 	}
-	ath_draintxq(sc);
+	ath5k_draintxq(sc);
 	if (!test_bit(ATH_STAT_INVALID, sc->status)) {
-		ath_stoprecv(sc);
+		ath5k_stoprecv(sc);
 		ath5k_hw_phy_disable(ah);
 	} else
 		sc->rxlink = NULL;
@@ -980,16 +978,16 @@ static int ath_stop_locked(struct ath_softc *sc)
 
 /*
  * Stop the device, grabbing the top-level lock to protect
- * against concurrent entry through ath_init (which can happen
+ * against concurrent entry through ath5k_init (which can happen
  * if another thread does a system call and the thread doing the
  * stop is preempted).
  */
-static int ath_stop_hw(struct ath_softc *sc)
+static int ath5k_stop_hw(struct ath5k_softc *sc)
 {
 	int ret;
 
 	mutex_lock(&sc->lock);
-	ret = ath_stop_locked(sc);
+	ret = ath5k_stop_locked(sc);
 	if (ret == 0 && !test_bit(ATH_STAT_INVALID, sc->status)) {
 		/*
 		 * Set the chip in full sleep mode.  Note that we are
@@ -1015,7 +1013,7 @@ static int ath_stop_hw(struct ath_softc *sc)
 			ath5k_hw_set_power(sc->ah, AR5K_PM_FULL_SLEEP, true, 0);
 		}
 	}
-	ath_cleanup_txbuf(sc, sc->bbuf);
+	ath5k_cleanup_txbuf(sc, sc->bbuf);
 	mutex_unlock(&sc->lock);
 
 	del_timer_sync(&sc->calib_tim);
@@ -1023,7 +1021,7 @@ static int ath_stop_hw(struct ath_softc *sc)
 	return ret;
 }
 
-static void ath_setcurmode(struct ath_softc *sc, unsigned int mode)
+static void ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
 {
 	if (unlikely(test_bit(ATH_STAT_LEDSOFT, sc->status))) {
 		/* from Atheros NDIS driver, w/ permission */
@@ -1089,11 +1087,11 @@ static void ath_setcurmode(struct ath_softc *sc, unsigned int mode)
  * Set/change channels.  If the channel is really being changed,
  * it's done by reseting the chip.  To accomplish this we must
  * first cleanup any pending DMA, then restart stuff after a la
- * ath_init.
+ * ath5k_init.
  */
-static int ath_chan_set(struct ath_softc *sc, struct ieee80211_channel *chan)
+static int ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 {
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_hw *ah = sc->ah;
 	int ret;
 
 	DPRINTF(sc, ATH_DEBUG_RESET, "%s: %u (%u MHz) -> %u (%u MHz)\n",
@@ -1108,8 +1106,8 @@ static int ath_chan_set(struct ath_softc *sc, struct ieee80211_channel *chan)
 		 * the relevant bits of the h/w.
 		 */
 		ath5k_hw_set_intr(ah, 0);	/* disable interrupts */
-		ath_draintxq(sc);		/* clear pending tx frames */
-		ath_stoprecv(sc);		/* turn off frame recv */
+		ath5k_draintxq(sc);		/* clear pending tx frames */
+		ath5k_stoprecv(sc);		/* turn off frame recv */
 		ret = ath5k_hw_reset(ah, sc->opmode, chan, true);
 		if (ret) {
 			printk(KERN_ERR "%s: unable to reset channel %u "
@@ -1117,12 +1115,12 @@ static int ath_chan_set(struct ath_softc *sc, struct ieee80211_channel *chan)
 			return ret;
 		}
 		sc->curchan = chan;
-		ath_update_txpow(sc);
+		ath5k_update_txpow(sc);
 
 		/*
 		 * Re-enable rx framework.
 		 */
-		ret = ath_startrecv(sc);
+		ret = ath5k_startrecv(sc);
 		if (ret) {
 			printk(KERN_ERR "%s: unable to restart recv logic\n",
 					__func__);
@@ -1135,7 +1133,7 @@ static int ath_chan_set(struct ath_softc *sc, struct ieee80211_channel *chan)
 		 *
 		 * XXX needed?
 		 */
-/*		ath_chan_change(sc, chan); */
+/*		ath5k_chan_change(sc, chan); */
 
 		/*
 		 * Re-enable interrupts.
@@ -1146,12 +1144,12 @@ static int ath_chan_set(struct ath_softc *sc, struct ieee80211_channel *chan)
 	return 0;
 }
 
-static int ath_tx_bf(struct ath_softc *sc, struct ath_buf *bf,
+static int ath5k_tx_bf(struct ath5k_softc *sc, struct ath5k_buf *bf,
 		struct ieee80211_tx_control *ctl)
 {
-	struct ath_hw *ah = sc->ah;
-	struct ath_txq *txq = sc->txq;
-	struct ath_desc *ds = bf->desc;
+	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_txq *txq = sc->txq;
+	struct ath5k_desc *ds = bf->desc;
 	struct sk_buff *skb = bf->skb;
 	unsigned int pktlen, flags, keyidx = AR5K_TXKEYIX_INVALID;
 	int ret;
@@ -1203,16 +1201,16 @@ err_unmap:
 	return ret;
 }
 
-static int ath_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		struct ieee80211_tx_control *ctl)
 {
-	struct ath_softc *sc = hw->priv;
-	struct ath_buf *bf;
+	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_buf *bf;
 	unsigned long flags;
 	int hdrlen;
 	int pad;
 
-	ath_dump_skb(skb, "t");
+	ath5k_dump_skb(skb, "t");
 
 	if (sc->opmode == IEEE80211_IF_TYPE_MNTR)
 		DPRINTF(sc, ATH_DEBUG_XMIT, "tx in monitor (scan?)\n");
@@ -1246,7 +1244,7 @@ static int ath_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		ieee80211_stop_queue(hw, ctl->queue);
 		return -1;
 	}
-	bf = list_first_entry(&sc->txbuf, struct ath_buf, list);
+	bf = list_first_entry(&sc->txbuf, struct ath5k_buf, list);
 	list_del(&bf->list);
 	sc->txbuf_len--;
 	if (list_empty(&sc->txbuf))
@@ -1255,7 +1253,7 @@ static int ath_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	bf->skb = skb;
 
-	if (ath_tx_bf(sc, bf, ctl)) {
+	if (ath5k_tx_bf(sc, bf, ctl)) {
 		bf->skb = NULL;
 		spin_lock_irqsave(&sc->txbuflock, flags);
 		list_add_tail(&bf->list, &sc->txbuf);
@@ -1268,31 +1266,31 @@ static int ath_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	return 0;
 }
 
-static int ath_reset(struct ieee80211_hw *hw)
+static int ath5k_reset(struct ieee80211_hw *hw)
 {
-	struct ath_softc *sc = hw->priv;
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = sc->ah;
 	int ret;
 
 	DPRINTF(sc, ATH_DEBUG_RESET, "resetting\n");
 	/*
-	 * Convert to a HAL channel description with the flags
+	 * Convert to a hw channel description with the flags
 	 * constrained to reflect the current operating mode.
 	 */
 	sc->curchan = hw->conf.chan;
 
 	ath5k_hw_set_intr(ah, 0);
-	ath_draintxq(sc);
-	ath_stoprecv(sc);
+	ath5k_draintxq(sc);
+	ath5k_stoprecv(sc);
 
 	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
 	if (unlikely(ret)) {
 		printk(KERN_ERR "ath: can't reset hardware (%d)\n", ret);
 		goto err;
 	}
-	ath_update_txpow(sc);
+	ath5k_update_txpow(sc);
 
-	ret = ath_startrecv(sc);
+	ret = ath5k_startrecv(sc);
 	if (unlikely(ret)) {
 		printk(KERN_ERR "ath: can't start recv logic\n");
 		goto err;
@@ -1304,9 +1302,9 @@ static int ath_reset(struct ieee80211_hw *hw)
 	 *
 	 * XXX needed?
 	 */
-/*	ath_chan_change(sc, c); */
-	ath_beacon_config(sc);
-	/* intrs are started by ath_beacon_config */
+/*	ath5k_chan_change(sc, c); */
+	ath5k_beacon_config(sc);
+	/* intrs are started by ath5k_beacon_config */
 
 	ieee80211_wake_queues(hw);
 
@@ -1315,20 +1313,20 @@ err:
 	return ret;
 }
 
-static int ath_start(struct ieee80211_hw *hw)
+static int ath5k_start(struct ieee80211_hw *hw)
 {
-	return ath_init(hw->priv);
+	return ath5k_init(hw->priv);
 }
 
-void ath_stop(struct ieee80211_hw *hw)
+void ath5k_stop(struct ieee80211_hw *hw)
 {
-	ath_stop_hw(hw->priv);
+	ath5k_stop_hw(hw->priv);
 }
 
-static int ath_add_interface(struct ieee80211_hw *hw,
+static int ath5k_add_interface(struct ieee80211_hw *hw,
 		struct ieee80211_if_init_conf *conf)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 	int ret;
 
 	mutex_lock(&sc->lock);
@@ -1355,10 +1353,10 @@ end:
 	return ret;
 }
 
-static void ath_remove_interface(struct ieee80211_hw *hw,
+static void ath5k_remove_interface(struct ieee80211_hw *hw,
 		struct ieee80211_if_init_conf *conf)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 
 	mutex_lock(&sc->lock);
 	if (sc->iface_id != conf->if_id)
@@ -1369,25 +1367,25 @@ end:
 	mutex_unlock(&sc->lock);
 }
 
-static int ath_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
+static int ath5k_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 
 	sc->bintval = conf->beacon_int * 1000 / 1024;
-	ath_setcurmode(sc, conf->phymode);
+	ath5k_setcurmode(sc, conf->phymode);
 
-	return ath_chan_set(sc, conf->chan);
+	return ath5k_chan_set(sc, conf->chan);
 }
 
-static int ath_config_interface(struct ieee80211_hw *hw, int if_id,
+static int ath5k_config_interface(struct ieee80211_hw *hw, int if_id,
 		struct ieee80211_if_conf *conf)
 {
-	struct ath_softc *sc = hw->priv;
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = sc->ah;
 	int ret;
 
 	/* Set to a reasonable value. Note that this will
-	 * be set to mac80211's value at ath_config(). */
+	 * be set to mac80211's value at ath5k_config(). */
 	sc->bintval = 1000 * 1000 / 1024;
 	mutex_lock(&sc->lock);
 	if (sc->iface_id != if_id) {
@@ -1403,7 +1401,7 @@ static int ath_config_interface(struct ieee80211_hw *hw, int if_id,
 	}
 	mutex_unlock(&sc->lock);
 
-	return ath_reset(hw);
+	return ath5k_reset(hw);
 unlock:
 	mutex_unlock(&sc->lock);
 	return ret;
@@ -1431,13 +1429,13 @@ unlock:
  *     the station is otherwise quiet, or
  *   - when scanning
  */
-static void ath_configure_filter(struct ieee80211_hw *hw,
+static void ath5k_configure_filter(struct ieee80211_hw *hw,
                unsigned int changed_flags,
                unsigned int *new_flags,
                int mc_count, struct dev_mc_list *mclist)
 {
-	struct ath_softc *sc = hw->priv;
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = sc->ah;
 	u32 mfilt[2], val, rfilt;
 	u8 pos;
 	int i;
@@ -1530,11 +1528,11 @@ static void ath_configure_filter(struct ieee80211_hw *hw,
 	sc->filter_flags = rfilt;
 }
 
-static int ath_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+static int ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		const u8 *local_addr, const u8 *addr,
 		struct ieee80211_key_conf *key)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 	int ret = 0;
 
 	switch(key->alg) {
@@ -1574,47 +1572,47 @@ unlock:
 	return ret;
 }
 
-static int ath_get_stats(struct ieee80211_hw *hw,
+static int ath5k_get_stats(struct ieee80211_hw *hw,
 		struct ieee80211_low_level_stats *stats)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 
 	memcpy(stats, &sc->ll_stats, sizeof(sc->ll_stats));
 
 	return 0;
 }
 
-static int ath_get_tx_stats(struct ieee80211_hw *hw,
+static int ath5k_get_tx_stats(struct ieee80211_hw *hw,
 		struct ieee80211_tx_queue_stats *stats)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 
 	memcpy(stats, &sc->tx_stats, sizeof(sc->tx_stats));
 
 	return 0;
 }
 
-static u64 ath_get_tsf(struct ieee80211_hw *hw)
+static u64 ath5k_get_tsf(struct ieee80211_hw *hw)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 
 	return ath5k_hw_get_tsf64(sc->ah);
 }
 
-static void ath_reset_tsf(struct ieee80211_hw *hw)
+static void ath5k_reset_tsf(struct ieee80211_hw *hw)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 
 	ath5k_hw_reset_tsf(sc->ah);
 }
 
-static int ath_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
+static int ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 		struct ieee80211_tx_control *ctl)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 	int ret;
 
-	ath_dump_skb(skb, "b");
+	ath5k_dump_skb(skb, "b");
 
 	mutex_lock(&sc->lock);
 
@@ -1623,9 +1621,9 @@ static int ath_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 		goto end;
 	}
 
-	ath_cleanup_txbuf(sc, sc->bbuf);
+	ath5k_cleanup_txbuf(sc, sc->bbuf);
 	sc->bbuf->skb = skb;
-	ret = ath_beacon_setup(sc, sc->bbuf, ctl);
+	ret = ath5k_beacon_setup(sc, sc->bbuf, ctl);
 	if (ret)
 		sc->bbuf->skb = NULL;
 
@@ -1634,32 +1632,32 @@ end:
 	return ret;
 }
 
-static struct ieee80211_ops ath_hw_ops = {
-	.tx = ath_tx,
-	.start = ath_start,
-	.stop = ath_stop,
-	.add_interface = ath_add_interface,
-	.remove_interface = ath_remove_interface,
-	.config = ath_config,
-	.config_interface = ath_config_interface,
-	.configure_filter = ath_configure_filter,
-	.set_key = ath_set_key,
-	.get_stats = ath_get_stats,
+static struct ieee80211_ops ath5k_hw_ops = {
+	.tx = ath5k_tx,
+	.start = ath5k_start,
+	.stop = ath5k_stop,
+	.add_interface = ath5k_add_interface,
+	.remove_interface = ath5k_remove_interface,
+	.config = ath5k_config,
+	.config_interface = ath5k_config_interface,
+	.configure_filter = ath5k_configure_filter,
+	.set_key = ath5k_set_key,
+	.get_stats = ath5k_get_stats,
 	.conf_tx = NULL,
-	.get_tx_stats = ath_get_tx_stats,
-	.get_tsf = ath_get_tsf,
-	.reset_tsf = ath_reset_tsf,
-	.beacon_update = ath_beacon_update,
+	.get_tx_stats = ath5k_get_tx_stats,
+	.get_tsf = ath5k_get_tsf,
+	.reset_tsf = ath5k_reset_tsf,
+	.beacon_update = ath5k_beacon_update,
 };
 
 /*
  * Periodically recalibrate the PHY to account
  * for temperature/environment changes.
  */
-static void ath_calibrate(unsigned long data)
+static void ath5k_calibrate(unsigned long data)
 {
-	struct ath_softc *sc = (void *)data;
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_softc *sc = (void *)data;
+	struct ath5k_hw *ah = sc->ah;
 
 	DPRINTF(sc, ATH_DEBUG_CALIBRATE, "ath: channel %u/%x\n",
 		sc->curchan->chan, sc->curchan->val);
@@ -1670,19 +1668,19 @@ static void ath_calibrate(unsigned long data)
 		 * to load new gain values.
 		 */
 		DPRINTF(sc, ATH_DEBUG_RESET, "calibration, resetting\n");
-		ath_reset(sc->hw);
+		ath5k_reset(sc->hw);
 	}
 	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
 		printk(KERN_ERR "ath: calibration of channel %u failed\n",
 				sc->curchan->chan);
 
 	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
-			msecs_to_jiffies(ath_calinterval * 1000)));
+			msecs_to_jiffies(ath5k_calinterval * 1000)));
 }
 
-static void ath_led_off(unsigned long data)
+static void ath5k_led_off(unsigned long data)
 {
-	struct ath_softc *sc = (void *)data;
+	struct ath5k_softc *sc = (void *)data;
 
 	if (test_bit(ATH_STAT_LEDENDBLINK, sc->status))
 		__clear_bit(ATH_STAT_LEDBLINKING, sc->status);
@@ -1696,7 +1694,7 @@ static void ath_led_off(unsigned long data)
 /*
  * Blink the LED according to the specified on/off times.
  */
-static void ath_led_blink(struct ath_softc *sc, unsigned int on,
+static void ath5k_led_blink(struct ath5k_softc *sc, unsigned int on,
 		unsigned int off)
 {
 	DPRINTF(sc, ATH_DEBUG_LED, "%s: on %u off %u\n", __func__, on, off);
@@ -1707,7 +1705,7 @@ static void ath_led_blink(struct ath_softc *sc, unsigned int on,
 	mod_timer(&sc->led_tim, jiffies + on);
 }
 
-static void ath_led_event(struct ath_softc *sc, int event)
+static void ath5k_led_event(struct ath5k_softc *sc, int event)
 {
 	if (likely(!test_bit(ATH_STAT_LEDSOFT, sc->status)))
 		return;
@@ -1715,20 +1713,20 @@ static void ath_led_event(struct ath_softc *sc, int event)
 		return; /* don't interrupt active blink */
 	switch (event) {
 	case ATH_LED_TX:
-		ath_led_blink(sc, sc->hwmap[sc->led_txrate].ledon,
+		ath5k_led_blink(sc, sc->hwmap[sc->led_txrate].ledon,
 			sc->hwmap[sc->led_txrate].ledoff);
 		break;
 	case ATH_LED_RX:
-		ath_led_blink(sc, sc->hwmap[sc->led_rxrate].ledon,
+		ath5k_led_blink(sc, sc->hwmap[sc->led_rxrate].ledon,
 			sc->hwmap[sc->led_rxrate].ledoff);
 		break;
 	}
 }
 
-static irqreturn_t ath_intr(int irq, void *dev_id)
+static irqreturn_t ath5k_intr(int irq, void *dev_id)
 {
-	struct ath_softc *sc = dev_id;
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_softc *sc = dev_id;
+	struct ath5k_hw *ah = sc->ah;
 	enum ath5k_int status;
 	unsigned int counter = 1000;
 
@@ -1738,22 +1736,20 @@ static irqreturn_t ath_intr(int irq, void *dev_id)
 
 	do {
 		/*
-		* Figure out the reason(s) for the interrupt.  Note
-		* that the hal returns a pseudo-ISR that may include
-		* bits we haven't explicitly enabled so we mask the
-		* value to insure we only process bits we requested.
-		*/
+		 * Figure out the reason(s) for the interrupt.  Note
+		 * that get_isr returns a pseudo-ISR that may include
+		 * bits we haven't explicitly enabled so we mask the
+		 * value to insure we only process bits we requested.
+		 */
 		ath5k_hw_get_isr(ah, &status);		/* NB: clears IRQ too */
 		DPRINTF(sc, ATH_DEBUG_INTR, "%s: status 0x%x/0x%x\n", __func__,
 				status, sc->imask);
 		status &= sc->imask; /* discard unasked for bits */
 		if (unlikely(status & AR5K_INT_FATAL)) {
 			/*
-			* Fatal errors are unrecoverable.  Typically
-			* these are caused by DMA errors.  Unfortunately
-			* the exact reason is not (presently) returned
-			* by the hal.
-			*/
+			 * Fatal errors are unrecoverable. 
+			 * Typically these are caused by DMA errors.
+			 */
 			tasklet_schedule(&sc->restq);
 		} else if (unlikely(status & AR5K_INT_RXORN)) {
 			tasklet_schedule(&sc->restq);
@@ -1765,7 +1761,7 @@ static irqreturn_t ath_intr(int irq, void *dev_id)
 				* this is too slow to meet timing constraints
 				* under load.
 				*/
-				ath_beacon_send(sc);
+				ath5k_beacon_send(sc);
 			}
 			if (status & AR5K_INT_RXEOL) {
 				/*
@@ -1801,7 +1797,7 @@ static irqreturn_t ath_intr(int irq, void *dev_id)
 /*
  * Convert IEEE channel number to MHz frequency.
  */
-static inline short ath_ieee2mhz(short chan)
+static inline short ath5k_ieee2mhz(short chan)
 {
 	if (chan <= 14 || chan >= 27)
 		return ieee80211chan2mhz(chan);
@@ -1809,7 +1805,7 @@ static inline short ath_ieee2mhz(short chan)
 		return 2212 + chan * 20;
 }
 
-static unsigned int ath_copy_rates(struct ieee80211_rate *rates,
+static unsigned int ath5k_copy_rates(struct ieee80211_rate *rates,
 		const struct ath5k_rate_table *rt, unsigned int max)
 {
 	unsigned int i, count;
@@ -1831,7 +1827,7 @@ static unsigned int ath_copy_rates(struct ieee80211_rate *rates,
 	return count;
 }
 
-static unsigned int ath_copy_channels(struct ath_hw *ah,
+static unsigned int ath5k_copy_channels(struct ath5k_hw *ah,
 		struct ieee80211_channel *channels, unsigned int mode,
 		unsigned int max)
 {
@@ -1881,7 +1877,7 @@ static unsigned int ath_copy_channels(struct ath_hw *ah,
 
 	for (i = 0, count = 0; i < size && max > 0; i++) {
 		ch = all ? i + 1 : chans[i].chan;
-		f = ath_ieee2mhz(ch);
+		f = ath5k_ieee2mhz(ch);
 		/* Check if channel is supported by the chipset */
 		if (!ath5k_channel_ok(ah, f, chfreq))
 			continue;
@@ -1907,7 +1903,7 @@ static unsigned int ath_copy_channels(struct ath_hw *ah,
 }
 
 #if ATH_DEBUG_MODES
-static void ath_dump_modes(struct ieee80211_hw_mode *modes)
+static void ath5k_dump_modes(struct ieee80211_hw_mode *modes)
 {
 	unsigned int m, i;
 
@@ -1931,12 +1927,12 @@ static void ath_dump_modes(struct ieee80211_hw_mode *modes)
 	}
 }
 #else
-static inline void ath_dump_modes(struct ieee80211_hw_mode *modes) {}
+static inline void ath5k_dump_modes(struct ieee80211_hw_mode *modes) {}
 #endif
 
 static inline int ath5k_register_mode(struct ieee80211_hw *hw, u8 m)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 	struct ieee80211_hw_mode *modes = sc->modes;
 	int i, ret;
 
@@ -1962,10 +1958,10 @@ static inline int ath5k_register_mode(struct ieee80211_hw *hw, u8 m)
 	} \
 } while (0) \
 
-static int ath_getchannels(struct ieee80211_hw *hw)
+static int ath5k_getchannels(struct ieee80211_hw *hw)
 {
-	struct ath_softc *sc = hw->priv;
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = sc->ah;
 	struct ieee80211_hw_mode *modes = sc->modes;
 	unsigned int i, max_r, max_c;
 	int ret;
@@ -1996,9 +1992,9 @@ static int ath_getchannels(struct ieee80211_hw *hw)
 		}
 
 		hw_rates = ath5k_hw_get_rate_table(ah, mode->mode);
-		mode->num_rates    = ath_copy_rates(mode->rates, hw_rates,
+		mode->num_rates    = ath5k_copy_rates(mode->rates, hw_rates,
 			max_r);
-		mode->num_channels = ath_copy_channels(ah, mode->channels,
+		mode->num_channels = ath5k_copy_channels(ah, mode->channels,
 			mode->mode, max_c);
 		max_r -= mode->num_rates;
 		max_c -= mode->num_channels;
@@ -2016,21 +2012,21 @@ static int ath_getchannels(struct ieee80211_hw *hw)
 		REGISTER_MODE(MODE_IEEE80211B);
 	REGISTER_MODE(MODE_IEEE80211A);
 
-	ath_dump_modes(modes);
+	ath5k_dump_modes(modes);
 
 	return ret;
 }
 
-static int ath_desc_alloc(struct ath_softc *sc, struct pci_dev *pdev)
+static int ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
 {
-	struct ath_desc *ds;
-	struct ath_buf *bf;
+	struct ath5k_desc *ds;
+	struct ath5k_buf *bf;
 	dma_addr_t da;
 	unsigned int i;
 	int ret;
 
 	/* allocate descriptors */
-	sc->desc_len = sizeof(struct ath_desc) *
+	sc->desc_len = sizeof(struct ath5k_desc) *
 			(ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
 	sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
 	if (sc->desc == NULL) {
@@ -2044,7 +2040,7 @@ static int ath_desc_alloc(struct ath_softc *sc, struct pci_dev *pdev)
 		__func__, ds, sc->desc_len, (unsigned long long)sc->desc_daddr);
 
 	bf = kcalloc(1 + ATH_TXBUF + ATH_RXBUF + ATH_BCBUF,
-			sizeof(struct ath_buf), GFP_KERNEL);
+			sizeof(struct ath5k_buf), GFP_KERNEL);
 	if (bf == NULL) {
 		dev_err(&pdev->dev, "can't allocate bufptr\n");
 		ret = -ENOMEM;
@@ -2081,15 +2077,15 @@ err:
 	return ret;
 }
 
-static void ath_desc_free(struct ath_softc *sc, struct pci_dev *pdev)
+static void ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
 {
-	struct ath_buf *bf;
+	struct ath5k_buf *bf;
 
-	ath_cleanup_txbuf(sc, sc->bbuf);
+	ath5k_cleanup_txbuf(sc, sc->bbuf);
 	list_for_each_entry(bf, &sc->txbuf, list)
-		ath_cleanup_txbuf(sc, bf);
+		ath5k_cleanup_txbuf(sc, bf);
 	list_for_each_entry(bf, &sc->rxbuf, list)
-		ath_cleanup_txbuf(sc, bf);
+		ath5k_cleanup_txbuf(sc, bf);
 
 	/* Free memory associated with all descriptors */
 	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
@@ -2098,7 +2094,7 @@ static void ath_desc_free(struct ath_softc *sc, struct pci_dev *pdev)
 	sc->bufptr = NULL;
 }
 
-static int ath_beaconq_setup(struct ath_hw *ah)
+static int ath5k_beaconq_setup(struct ath5k_hw *ah)
 {
 	struct ath5k_txq_info qi = {
 		.tqi_aifs = AR5K_TXQ_USEDEFAULT,
@@ -2111,11 +2107,11 @@ static int ath_beaconq_setup(struct ath_hw *ah)
 	return ath5k_hw_setup_tx_queue(ah, AR5K_TX_QUEUE_BEACON, &qi);
 }
 
-static struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype,
+static struct ath5k_txq *ath5k_txq_setup(struct ath5k_softc *sc, int qtype,
 		int subtype)
 {
-	struct ath_hw *ah = sc->ah;
-	struct ath_txq *txq;
+	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_txq *txq;
 	struct ath5k_txq_info qi = {
 		.tqi_subtype = subtype,
 		.tqi_aifs = AR5K_TXQ_USEDEFAULT,
@@ -2147,7 +2143,7 @@ static struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype,
 		return ERR_PTR(qnum);
 	}
 	if (qnum >= ARRAY_SIZE(sc->txqs)) {
-		printk(KERN_ERR "hal qnum %u out of range, max %tu!\n",
+		printk(KERN_ERR "hw qnum %u out of range, max %tu!\n",
 			qnum, ARRAY_SIZE(sc->txqs));
 		ath5k_hw_release_tx_queue(ah, qnum);
 		return ERR_PTR(-EINVAL);
@@ -2163,9 +2159,9 @@ static struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype,
 	return &sc->txqs[qnum];
 }
 
-static void ath_tx_cleanup(struct ath_softc *sc)
+static void ath5k_tx_cleanup(struct ath5k_softc *sc)
 {
-	struct ath_txq *txq = sc->txqs;
+	struct ath5k_txq *txq = sc->txqs;
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++, txq++)
@@ -2175,10 +2171,10 @@ static void ath_tx_cleanup(struct ath_softc *sc)
 		}
 }
 
-static int ath_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
+static int ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 {
-	struct ath_softc *sc = hw->priv;
-	struct ath_hw *ah = sc->ah;
+	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = sc->ah;
 	u8 mac[ETH_ALEN];
 	unsigned int i;
 	int ret;
@@ -2208,22 +2204,22 @@ static int ath_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 * on settings like the phy mode and regulatory
 	 * domain restrictions.
 	 */
-	ret = ath_getchannels(hw);
+	ret = ath5k_getchannels(hw);
 	if (ret) {
 		dev_err(&pdev->dev, "can't get channels\n");
 		goto err;
 	}
 
-	/* NB: setup here so ath_rate_update is happy */
+	/* NB: setup here so ath5k_rate_update is happy */
 	if (test_bit(MODE_IEEE80211A, ah->ah_modes))
-		ath_setcurmode(sc, MODE_IEEE80211A);
+		ath5k_setcurmode(sc, MODE_IEEE80211A);
 	else
-		ath_setcurmode(sc, MODE_IEEE80211B);
+		ath5k_setcurmode(sc, MODE_IEEE80211B);
 
 	/*
 	 * Allocate tx+rx descriptors and populate the lists.
 	 */
-	ret = ath_desc_alloc(sc, pdev);
+	ret = ath5k_desc_alloc(sc, pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "can't allocate descriptors\n");
 		goto err;
@@ -2232,28 +2228,28 @@ static int ath_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	/*
 	 * Allocate hardware transmit queues: one queue for
 	 * beacon frames and one data queue for each QoS
-	 * priority.  Note that the hal handles reseting
+	 * priority.  Note that hw functions handle reseting
 	 * these queues at the needed time.
 	 */
-	ret = ath_beaconq_setup(ah);
+	ret = ath5k_beaconq_setup(ah);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't setup a beacon xmit queue\n");
 		goto err_desc;
 	}
 	sc->bhalq = ret;
 
-	sc->txq = ath_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
+	sc->txq = ath5k_txq_setup(sc, AR5K_TX_QUEUE_DATA, AR5K_WME_AC_BK);
 	if (IS_ERR(sc->txq)) {
 		dev_err(&pdev->dev, "can't setup xmit queue\n");
 		ret = PTR_ERR(sc->txq);
 		goto err_bhal;
 	}
 
-	tasklet_init(&sc->rxtq, ath_tasklet_rx, (unsigned long)sc);
-	tasklet_init(&sc->txtq, ath_tasklet_tx, (unsigned long)sc);
-	tasklet_init(&sc->restq, ath_tasklet_reset, (unsigned long)sc);
-	setup_timer(&sc->calib_tim, ath_calibrate, (unsigned long)sc);
-	setup_timer(&sc->led_tim, ath_led_off, (unsigned long)sc);
+	tasklet_init(&sc->rxtq, ath5k_tasklet_rx, (unsigned long)sc);
+	tasklet_init(&sc->txtq, ath5k_tasklet_tx, (unsigned long)sc);
+	tasklet_init(&sc->restq, ath5k_tasklet_reset, (unsigned long)sc);
+	setup_timer(&sc->calib_tim, ath5k_calibrate, (unsigned long)sc);
+	setup_timer(&sc->led_tim, ath5k_led_off, (unsigned long)sc);
 
 	sc->led_on = 0; /* low true */
 	/*
@@ -2290,22 +2286,22 @@ static int ath_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 
 	return 0;
 err_queues:
-	ath_tx_cleanup(sc);
+	ath5k_tx_cleanup(sc);
 err_bhal:
 	ath5k_hw_release_tx_queue(ah, sc->bhalq);
 err_desc:
-	ath_desc_free(sc, pdev);
+	ath5k_desc_free(sc, pdev);
 err:
 	return ret;
 }
 
-static void ath_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
+static void ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 
 	/*
 	 * NB: the order of these is important:
-	 * o call the 802.11 layer before detaching the hal to
+	 * o call the 802.11 layer before detaching ath5k_hw to
 	 *   insure callbacks into the driver to delete global
 	 *   key cache entries can be handled
 	 * o reclaim the tx queue data structures after calling
@@ -2313,11 +2309,12 @@ static void ath_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 *   node state and potentially want to use them
 	 * o to cleanup the tx queues the hal is called, so detach
 	 *   it last
+	 * XXX: ??? detach ath5k_hw ???
 	 * Other than that, it's straightforward...
 	 */
 	ieee80211_unregister_hw(hw);
-	ath_desc_free(sc, pdev);
-	ath_tx_cleanup(sc);
+	ath5k_desc_free(sc, pdev);
+	ath5k_tx_cleanup(sc);
 	ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
 
 	/*
@@ -2327,7 +2324,7 @@ static void ath_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 */
 }
 
-static const char *ath_chip_name(u8 mac_version)
+static const char *ath5k_chip_name(u8 mac_version)
 {
 	switch (mac_version) {
 	case AR5K_AR5210:
@@ -2340,11 +2337,11 @@ static const char *ath_chip_name(u8 mac_version)
 	return "Unknown";
 }
 
-static int __devinit ath_pci_probe(struct pci_dev *pdev,
+static int __devinit ath5k_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *id)
 {
 	void __iomem *mem;
-	struct ath_softc *sc;
+	struct ath5k_softc *sc;
 	struct ieee80211_hw *hw;
 	int ret;
 	u8 csz;
@@ -2406,7 +2403,7 @@ static int __devinit ath_pci_probe(struct pci_dev *pdev,
 		goto err_reg;
 	}
 
-	hw = ieee80211_alloc_hw(sizeof(*sc), &ath_hw_ops);
+	hw = ieee80211_alloc_hw(sizeof(*sc), &ath5k_hw_ops);
 	if (hw == NULL) {
 		dev_err(&pdev->dev, "cannot allocate ieee80211_hw\n");
 		ret = -ENOMEM;
@@ -2427,7 +2424,7 @@ static int __devinit ath_pci_probe(struct pci_dev *pdev,
 	 * interrupts until setup is complete.
 	 */
 #if AR_DEBUG
-	sc->debug = ath_debug;
+	sc->debug = ath5k_debug;
 #endif
 	__set_bit(ATH_STAT_INVALID, sc->status);
 	sc->iobase = mem;
@@ -2441,7 +2438,7 @@ static int __devinit ath_pci_probe(struct pci_dev *pdev,
 
 	pci_enable_msi(pdev);
 
-	ret = request_irq(pdev->irq, ath_intr, IRQF_SHARED, "ath", sc);
+	ret = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
 	if (ret) {
 		dev_err(&pdev->dev, "request_irq failed\n");
 		goto err_free;
@@ -2453,12 +2450,12 @@ static int __devinit ath_pci_probe(struct pci_dev *pdev,
 		goto err_irq;
 	}
 
-	ret = ath_attach(pdev, hw);
+	ret = ath5k_attach(pdev, hw);
 	if (ret)
 		goto err_ah;
 
 	dev_info(&pdev->dev, "%s chip found: mac %d.%d phy %d.%d\n",
-			ath_chip_name(id->driver_data), sc->ah->ah_mac_version,
+			ath5k_chip_name(id->driver_data), sc->ah->ah_mac_version,
 			sc->ah->ah_mac_version, sc->ah->ah_phy_revision >> 4,
 			sc->ah->ah_phy_revision & 0xf);
 
@@ -2483,12 +2480,12 @@ err:
 	return ret;
 }
 
-static void __devexit ath_pci_remove(struct pci_dev *pdev)
+static void __devexit ath5k_pci_remove(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 
-	ath_detach(pdev, hw);
+	ath5k_detach(pdev, hw);
 	ath5k_hw_detach(sc->ah);
 	free_irq(pdev->irq, sc);
 	pci_disable_msi(pdev);
@@ -2499,15 +2496,15 @@ static void __devexit ath_pci_remove(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PM
-static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 
 	if (test_bit(ATH_STAT_LEDSOFT, sc->status))
 		ath5k_hw_set_gpio(sc->ah, sc->led_pin, 1);
 
-	ath_stop_hw(sc);
+	ath5k_stop_hw(sc);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
@@ -2515,10 +2512,10 @@ static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-static int ath_pci_resume(struct pci_dev *pdev)
+static int ath5k_pci_resume(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath_softc *sc = hw->priv;
+	struct ath5k_softc *sc = hw->priv;
 	int err;
 
 	err = pci_set_power_state(pdev, PCI_D0);
@@ -2537,7 +2534,7 @@ static int ath_pci_resume(struct pci_dev *pdev)
 	 */
 	pci_write_config_byte(pdev, 0x41, 0);
 
-	ath_init(sc);
+	ath5k_init(sc);
 	if (test_bit(ATH_STAT_LEDSOFT, sc->status)) {
 		ath5k_hw_set_gpio_output(sc->ah, sc->led_pin);
 		ath5k_hw_set_gpio(sc->ah, sc->led_pin, 0);
@@ -2546,84 +2543,84 @@ static int ath_pci_resume(struct pci_dev *pdev)
 	return 0;
 }
 #else
-#define ath_pci_suspend NULL
-#define ath_pci_resume NULL
+#define ath5k_pci_suspend NULL
+#define ath5k_pci_resume NULL
 #endif /* CONFIG_PM */
 
-static struct pci_driver ath_pci_drv_id = {
-	.name		= "ath_pci",
-	.id_table	= ath_pci_id_table,
-	.probe		= ath_pci_probe,
-	.remove		= __devexit_p(ath_pci_remove),
-	.suspend	= ath_pci_suspend,
-	.resume		= ath_pci_resume,
+static struct pci_driver ath5k_pci_drv_id = {
+	.name		= "ath5k_pci",
+	.id_table	= ath5k_pci_id_table,
+	.probe		= ath5k_pci_probe,
+	.remove		= __devexit_p(ath5k_pci_remove),
+	.suspend	= ath5k_pci_suspend,
+	.resume		= ath5k_pci_resume,
 };
 
 static int mincalibrate = 1;
 static int maxcalibrate = INT_MAX / 1000;
 #define	CTL_AUTO	-2	/* cannot be CTL_ANY or CTL_NONE */
 
-static ctl_table ath_static_sysctls[] = {
+static ctl_table ath5k_static_sysctls[] = {
 #if AR_DEBUG
 	{
 	  .procname	= "debug",
 	  .mode		= 0644,
-	  .data		= &ath_debug,
-	  .maxlen	= sizeof(ath_debug),
+	  .data		= &ath5k_debug,
+	  .maxlen	= sizeof(ath5k_debug),
 	  .proc_handler	= proc_dointvec
 	},
 #endif
 	{
 	  .procname	= "calibrate",
 	  .mode		= 0644,
-	  .data		= &ath_calinterval,
-	  .maxlen	= sizeof(ath_calinterval),
+	  .data		= &ath5k_calinterval,
+	  .maxlen	= sizeof(ath5k_calinterval),
 	  .extra1	= &mincalibrate,
 	  .extra2	= &maxcalibrate,
 	  .proc_handler	= proc_dointvec_minmax
 	},
 	{ 0 }
 };
-static ctl_table ath_ath_table[] = {
+static ctl_table ath5k_ath5k_table[] = {
 	{
 	  .procname	= "ath",
 	  .mode		= 0555,
-	  .child	= ath_static_sysctls
+	  .child	= ath5k_static_sysctls
 	}, { 0 }
 };
-static ctl_table ath_root_table[] = {
+static ctl_table ath5k_root_table[] = {
 	{
 	  .ctl_name	= CTL_DEV,
 	  .procname	= "dev",
 	  .mode		= 0555,
-	  .child	= ath_ath_table
+	  .child	= ath5k_ath5k_table
 	}, { 0 }
 };
-static struct ctl_table_header *ath_sysctl_header;
+static struct ctl_table_header *ath5k_sysctl_header;
 
-static int __init init_ath_pci(void)
+static int __init init_ath5k_pci(void)
 {
 	int ret;
 
-	ret = pci_register_driver(&ath_pci_drv_id);
+	ret = pci_register_driver(&ath5k_pci_drv_id);
 	if (ret) {
-		printk(KERN_ERR "ath_pci: can't register pci driver\n");
+		printk(KERN_ERR "ath5k_pci: can't register pci driver\n");
 		return ret;
 	}
-	ath_sysctl_header = register_sysctl_table(ath_root_table);
+	ath5k_sysctl_header = register_sysctl_table(ath5k_root_table);
 
 	return 0;
 }
 
-static void __exit exit_ath_pci(void)
+static void __exit exit_ath5k_pci(void)
 {
-	if (ath_sysctl_header)
-		unregister_sysctl_table(ath_sysctl_header);
-	pci_unregister_driver(&ath_pci_drv_id);
+	if (ath5k_sysctl_header)
+		unregister_sysctl_table(ath5k_sysctl_header);
+	pci_unregister_driver(&ath5k_pci_drv_id);
 }
 
-module_init(init_ath_pci);
-module_exit(exit_ath_pci);
+module_init(init_ath5k_pci);
+module_exit(exit_ath5k_pci);
 
 MODULE_AUTHOR("Jiri Slaby");
 MODULE_DESCRIPTION("Support for Atheros 802.11 wireless LAN cards.");
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index ad22712..7ff8b28 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -52,10 +52,10 @@
 #define	ATH_TXBUF	200		/* number of TX buffers */
 #define ATH_BCBUF	1		/* number of beacon buffers */
 
-struct ath_buf {
+struct ath5k_buf {
 	struct list_head	list;
 	unsigned int		flags;	/* tx descriptor flags */
-	struct ath_desc		*desc;	/* virtual addr of desc */
+	struct ath5k_desc		*desc;	/* virtual addr of desc */
 	dma_addr_t		daddr;	/* physical addr of desc */
 	struct sk_buff		*skb;	/* skbuff for buf */
 	dma_addr_t		skbaddr;/* physical addr of skb data */
@@ -71,7 +71,7 @@ struct ath_buf {
  * priorities to fewer hardware queues (typically all to one
  * hardware queue).
  */
-struct ath_txq {
+struct ath5k_txq {
 	unsigned int	qnum;		/* hardware q number */
 	u32		*link;		/* link ptr in last TX desc */
 	struct list_head q;		/* transmit queue */
@@ -87,7 +87,7 @@ struct ath_txq {
 
 /* Software Carrier, keeps track of the driver state
  * associated with an instance of a device */
-struct ath_softc {
+struct ath5k_softc {
 	struct pci_dev		*pdev;		/* for dma mapping */
 	void __iomem		*iobase;	/* address of the device */
 	struct mutex		lock;		/* dev-level lock */
@@ -98,12 +98,12 @@ struct ath_softc {
 	struct ieee80211_channel channels[ATH_CHAN_MAX];
 	struct ieee80211_rate	rates[AR5K_MAX_RATES * NUM_DRIVER_MODES];
 	enum ieee80211_if_types	opmode;
-	struct ath_hw		*ah;		/* Atheros HW */
+	struct ath5k_hw		*ah;		/* Atheros HW */
 
 	int			debug;
 
-	struct ath_buf		*bufptr;	/* allocated buffer ptr */
-	struct ath_desc		*desc;		/* TX/RX descriptors */
+	struct ath5k_buf	*bufptr;	/* allocated buffer ptr */
+	struct ath5k_desc	*desc;		/* TX/RX descriptors */
 	dma_addr_t		desc_daddr;	/* DMA (physical) address */
 	size_t			desc_len;	/* size of TX/RX descriptors */
 	u16			cachelsz;	/* cache line size */
@@ -153,13 +153,13 @@ struct ath_softc {
 	struct list_head	txbuf;		/* transmit buffer */
 	spinlock_t		txbuflock;
 	unsigned int		txbuf_len;	/* buf count in txbuf list */
-	struct ath_txq		txqs[2];	/* beacon and tx */
+	struct ath5k_txq	txqs[2];	/* beacon and tx */
 
-	struct ath_txq		*txq;		/* beacon and tx*/
+	struct ath5k_txq	*txq;		/* beacon and tx*/
 	struct tasklet_struct	txtq;		/* tx intr tasklet */
 
-	struct ath_buf		*bbuf;		/* beacon buffer */
-	unsigned int		bhalq,		/* HAL q for outgoing beacons */
+	struct ath5k_buf	*bbuf;		/* beacon buffer */
+	unsigned int		bhalq,		/* SW q for outgoing beacons */
 				bmisscount,	/* missed beacon transmits */
 				bintval,	/* beacon interval */
 				bsent;
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 8b22416..68ff994 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -21,7 +21,7 @@
  */
 
 /*
- * HAL interface for Atheros Wireless LAN devices.
+ * HW related functions for Atheros Wireless LAN devices.
  */
 
 #include <linux/pci.h>
@@ -38,34 +38,34 @@ static const struct ath5k_rate_table ath5k_rt_turbo = AR5K_RATES_TURBO;
 static const struct ath5k_rate_table ath5k_rt_xr = AR5K_RATES_XR;
 
 /*Prototypes*/
-static int ath5k_hw_nic_reset(struct ath_hw *, u32);
-static int ath5k_hw_nic_wakeup(struct ath_hw *, int, bool);
-static int ath5k_hw_setup_4word_tx_desc(struct ath_hw *, struct ath_desc *,
+static int ath5k_hw_nic_reset(struct ath5k_hw *, u32);
+static int ath5k_hw_nic_wakeup(struct ath5k_hw *, int, bool);
+static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 	unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
 	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
 	unsigned int, unsigned int);
-static bool ath5k_hw_setup_xr_tx_desc(struct ath_hw *, struct ath_desc *,
+static bool ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
 	unsigned int);
-static int ath5k_hw_fill_4word_tx_desc(struct ath_hw *, struct ath_desc *,
+static int ath5k_hw_fill_4word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 	unsigned int, bool, bool);
-static int ath5k_hw_proc_4word_tx_status(struct ath_hw *, struct ath_desc *);
-static int ath5k_hw_setup_2word_tx_desc(struct ath_hw *, struct ath_desc *,
+static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *, struct ath5k_desc *);
+static int ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 	unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
 	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
 	unsigned int, unsigned int);
-static int ath5k_hw_fill_2word_tx_desc(struct ath_hw *, struct ath_desc *,
+static int ath5k_hw_fill_2word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 	unsigned int, bool, bool);
-static int ath5k_hw_proc_2word_tx_status(struct ath_hw *, struct ath_desc *);
-static int ath5k_hw_proc_new_rx_status(struct ath_hw *, struct ath_desc *);
-static int ath5k_hw_proc_old_rx_status(struct ath_hw *, struct ath_desc *);
-static int ath5k_hw_get_capabilities(struct ath_hw *);
+static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *, struct ath5k_desc *);
+static int ath5k_hw_proc_new_rx_status(struct ath5k_hw *, struct ath5k_desc *);
+static int ath5k_hw_proc_old_rx_status(struct ath5k_hw *, struct ath5k_desc *);
+static int ath5k_hw_get_capabilities(struct ath5k_hw *);
 
-static int ath5k_eeprom_init(struct ath_hw *);
-static int ath5k_eeprom_read_mac(struct ath_hw *, u8 *);
+static int ath5k_eeprom_init(struct ath5k_hw *);
+static int ath5k_eeprom_read_mac(struct ath5k_hw *, u8 *);
 
-static int ath5k_hw_enable_pspoll(struct ath_hw *, u8 *, u16);
-static int ath5k_hw_disable_pspoll(struct ath_hw *);
+static int ath5k_hw_enable_pspoll(struct ath5k_hw *, u8 *, u16);
+static int ath5k_hw_disable_pspoll(struct ath5k_hw *);
 
 /*
  * Enable to overwrite the country code (use "00" for debug)
@@ -84,7 +84,7 @@ static int ath5k_hw_disable_pspoll(struct ath_hw *);
  * TODO: Left here for combatibility, change it in ath5k
  */
 static u16 /*TODO: Is this really hardware dependent ?*/
-ath_hal_computetxtime(struct ath_hw *hal, const struct ath5k_rate_table *rates,
+ath5k_computetxtime(struct ath5k_hw *ah, const struct ath5k_rate_table *rates,
 		u32 frame_length, u16 rate_index, bool short_preamble)
 {
 	const struct ath5k_rate *rate;
@@ -165,14 +165,14 @@ static inline unsigned int ath5k_hw_clocktoh(unsigned int clock, bool turbo)
 /*
  * Check if a register write has been completed
  */
-int ath5k_hw_register_timeout(struct ath_hw *hal, u32 reg, u32 flag, u32 val,
+int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val,
 		bool is_set)
 {
 	int i;
 	u32 data;
 
 	for (i = AR5K_TUNE_REGISTER_TIMEOUT; i > 0; i--) {
-		data = ath5k_hw_reg_read(hal, reg);
+		data = ath5k_hw_reg_read(ah, reg);
 		if ((is_set == true) && (data & flag))
 			break;
 		else if ((data & flag) == val)
@@ -191,43 +191,43 @@ int ath5k_hw_register_timeout(struct ath_hw *hal, u32 reg, u32 flag, u32 val,
 /*
  * Check if the device is supported and initialize the needed structs
  */
-struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
+struct ath5k_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 		void __iomem *sh)
 {
-	struct ath_hw *hal;
+	struct ath5k_hw *ah;
 	u8 mac[ETH_ALEN];
 	int ret;
 	u32 srev;
 
-	/*If we passed the test malloc a hal struct*/
-	hal = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
-	if (hal == NULL) {
+	/*If we passed the test malloc a ath5k_hw struct*/
+	ah = kzalloc(sizeof(struct ath5k_hw), GFP_KERNEL);
+	if (ah == NULL) {
 		ret = -ENOMEM;
 		AR5K_PRINT("out of memory\n");
 		goto err;
 	}
 
-	hal->ah_sc = sc;
-	hal->ah_sh = sh;
+	ah->ah_sc = sc;
+	ah->ah_sh = sh;
 
 	/*
-	 * HAL information
+	 * HW information
 	 */
 
 	/* Get reg domain from eeprom */
-	ath5k_get_regdomain(hal);
-
-	hal->ah_op_mode = IEEE80211_IF_TYPE_STA;
-	hal->ah_radar.r_enabled = AR5K_TUNE_RADAR_ALERT;
-	hal->ah_turbo = false;
-	hal->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
-	hal->ah_imr = 0;
-	hal->ah_atim_window = 0;
-	hal->ah_aifs = AR5K_TUNE_AIFS;
-	hal->ah_cw_min = AR5K_TUNE_CWMIN;
-	hal->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
-	hal->ah_software_retry = false;
-	hal->ah_ant_diversity = AR5K_TUNE_ANT_DIVERSITY;
+	ath5k_get_regdomain(ah);
+
+	ah->ah_op_mode = IEEE80211_IF_TYPE_STA;
+	ah->ah_radar.r_enabled = AR5K_TUNE_RADAR_ALERT;
+	ah->ah_turbo = false;
+	ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
+	ah->ah_imr = 0;
+	ah->ah_atim_window = 0;
+	ah->ah_aifs = AR5K_TUNE_AIFS;
+	ah->ah_cw_min = AR5K_TUNE_CWMIN;
+	ah->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
+	ah->ah_software_retry = false;
+	ah->ah_ant_diversity = AR5K_TUNE_ANT_DIVERSITY;
 
 	switch (device) {
 	case PCI_DEVICE_ID_ATHEROS_AR2413:
@@ -236,94 +236,94 @@ struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 		/*
 		 * Known single chip solutions
 		 */
-		hal->ah_single_chip = true;
+		ah->ah_single_chip = true;
 		break;
 	default:
 		/*
 		 * Multi chip solutions
 		 */
-		hal->ah_single_chip = false;
+		ah->ah_single_chip = false;
 		break;
 	}
 
 	/*
 	 * Set the mac revision based on the pci id
 	 */
-	hal->ah_version = mac_version;
-
-	/*Fill the hal struct with the needed functions*/
-	if (hal->ah_version == AR5K_AR5212)
-		hal->ah_magic = AR5K_EEPROM_MAGIC_5212;
-	else if (hal->ah_version == AR5K_AR5211)
-		hal->ah_magic = AR5K_EEPROM_MAGIC_5211;
-
-	if (hal->ah_version == AR5K_AR5212) {
-		hal->ah_setup_tx_desc = ath5k_hw_setup_4word_tx_desc;
-		hal->ah_setup_xtx_desc = ath5k_hw_setup_xr_tx_desc;
-		hal->ah_fill_tx_desc = ath5k_hw_fill_4word_tx_desc;
-		hal->ah_proc_tx_desc = ath5k_hw_proc_4word_tx_status;
+	ah->ah_version = mac_version;
+
+	/*Fill the ath5k_hw struct with the needed functions*/
+	if (ah->ah_version == AR5K_AR5212)
+		ah->ah_magic = AR5K_EEPROM_MAGIC_5212;
+	else if (ah->ah_version == AR5K_AR5211)
+		ah->ah_magic = AR5K_EEPROM_MAGIC_5211;
+
+	if (ah->ah_version == AR5K_AR5212) {
+		ah->ah_setup_tx_desc = ath5k_hw_setup_4word_tx_desc;
+		ah->ah_setup_xtx_desc = ath5k_hw_setup_xr_tx_desc;
+		ah->ah_fill_tx_desc = ath5k_hw_fill_4word_tx_desc;
+		ah->ah_proc_tx_desc = ath5k_hw_proc_4word_tx_status;
 	} else {
-		hal->ah_setup_tx_desc = ath5k_hw_setup_2word_tx_desc;
-		hal->ah_setup_xtx_desc = ath5k_hw_setup_xr_tx_desc;
-		hal->ah_fill_tx_desc = ath5k_hw_fill_2word_tx_desc;
-		hal->ah_proc_tx_desc = ath5k_hw_proc_2word_tx_status;
+		ah->ah_setup_tx_desc = ath5k_hw_setup_2word_tx_desc;
+		ah->ah_setup_xtx_desc = ath5k_hw_setup_xr_tx_desc;
+		ah->ah_fill_tx_desc = ath5k_hw_fill_2word_tx_desc;
+		ah->ah_proc_tx_desc = ath5k_hw_proc_2word_tx_status;
 	}
 
-	if (hal->ah_version == AR5K_AR5212)
-		hal->ah_proc_rx_desc = ath5k_hw_proc_new_rx_status;
-	else if (hal->ah_version <= AR5K_AR5211)
-		hal->ah_proc_rx_desc = ath5k_hw_proc_old_rx_status;
+	if (ah->ah_version == AR5K_AR5212)
+		ah->ah_proc_rx_desc = ath5k_hw_proc_new_rx_status;
+	else if (ah->ah_version <= AR5K_AR5211)
+		ah->ah_proc_rx_desc = ath5k_hw_proc_old_rx_status;
 
 	/* Bring device out of sleep and reset it's units */
-	ret = ath5k_hw_nic_wakeup(hal, AR5K_INIT_MODE, true);
+	ret = ath5k_hw_nic_wakeup(ah, AR5K_INIT_MODE, true);
 	if (ret)
 		goto err_free;
 
 	/* Get MAC, PHY and RADIO revisions */
-	srev = ath5k_hw_reg_read(hal, AR5K_SREV);
-	hal->ah_mac_srev = srev;
-	hal->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
-	hal->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
-	hal->ah_phy_revision = ath5k_hw_reg_read(hal, AR5K_PHY_CHIP_ID) &
+	srev = ath5k_hw_reg_read(ah, AR5K_SREV);
+	ah->ah_mac_srev = srev;
+	ah->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
+	ah->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
+	ah->ah_phy_revision = ath5k_hw_reg_read(ah, AR5K_PHY_CHIP_ID) &
 			0xffffffff;
-	hal->ah_radio_5ghz_revision = ath5k_hw_radio_revision(hal,
+	ah->ah_radio_5ghz_revision = ath5k_hw_radio_revision(ah,
 			CHANNEL_5GHZ);
 
-	if (hal->ah_version == AR5K_AR5210)
-		hal->ah_radio_2ghz_revision = 0;
+	if (ah->ah_version == AR5K_AR5210)
+		ah->ah_radio_2ghz_revision = 0;
 	else
-		hal->ah_radio_2ghz_revision = ath5k_hw_radio_revision(hal,
+		ah->ah_radio_2ghz_revision = ath5k_hw_radio_revision(ah,
 				CHANNEL_2GHZ);
 
 	/* Single chip radio */
-	if (hal->ah_radio_2ghz_revision == hal->ah_radio_5ghz_revision)
-		hal->ah_radio_2ghz_revision = 0;
+	if (ah->ah_radio_2ghz_revision == ah->ah_radio_5ghz_revision)
+		ah->ah_radio_2ghz_revision = 0;
 
 	/* Identify the radio chip*/
-	if (hal->ah_version == AR5K_AR5210)
-		hal->ah_radio = AR5K_RF5110;
+	if (ah->ah_version == AR5K_AR5210)
+		ah->ah_radio = AR5K_RF5110;
 	else
-		hal->ah_radio = hal->ah_radio_5ghz_revision <
+		ah->ah_radio = ah->ah_radio_5ghz_revision <
 			AR5K_SREV_RAD_5112 ? AR5K_RF5111 : AR5K_RF5112;
 
-	hal->ah_phy = AR5K_PHY(0);
+	ah->ah_phy = AR5K_PHY(0);
 
 #ifdef AR5K_DEBUG
-	ath5k_hw_dump_state(hal);
+	ath5k_hw_dump_state(ah);
 #endif
 
 	/*
 	 * Get card capabilities, values, ...
 	 */
 
-	ret = ath5k_eeprom_init(hal);
+	ret = ath5k_eeprom_init(ah);
 	if (ret) {
 		AR5K_PRINT("unable to init EEPROM\n");
 		goto err_free;
 	}
 
 	/* Get misc capabilities */
-	ret = ath5k_hw_get_capabilities(hal);
+	ret = ath5k_hw_get_capabilities(ah);
 	if (ret) {
 		AR5K_PRINTF("unable to get device capabilities: 0x%04x\n",
 			device);
@@ -331,24 +331,24 @@ struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 	}
 
 	/* Get MAC address */
-	ret = ath5k_eeprom_read_mac(hal, mac);
+	ret = ath5k_eeprom_read_mac(ah, mac);
 	if (ret) {
 		AR5K_PRINTF("unable to read address from EEPROM: 0x%04x\n",
 			device);
 		goto err_free;
 	}
 
-	ath5k_hw_set_lladdr(hal, mac);
+	ath5k_hw_set_lladdr(ah, mac);
 	/* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
-	memset(hal->bssid, 0xff, ETH_ALEN);
-	ath5k_hw_set_associd(hal, hal->bssid, 0);
-	ath5k_hw_set_opmode(hal);
+	memset(ah->bssid, 0xff, ETH_ALEN);
+	ath5k_hw_set_associd(ah, ah->bssid, 0);
+	ath5k_hw_set_opmode(ah);
 
-	ath5k_hw_set_rfgain_opt(hal);
+	ath5k_hw_set_rfgain_opt(ah);
 
-	return hal;
+	return ah;
 err_free:
-	kfree(hal);
+	kfree(ah);
 err:
 	return ERR_PTR(ret);
 }
@@ -356,7 +356,7 @@ err:
 /*
  * Bring up MAC + PHY Chips
  */
-static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
+static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 {
 	u32 turbo, mode, clock;
 	int ret;
@@ -367,12 +367,12 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 
 	AR5K_TRACE;
 
-	if (hal->ah_version != AR5K_AR5210) {
+	if (ah->ah_version != AR5K_AR5210) {
 		/*
 		 * Get channel mode flags
 		 */
 
-		if (hal->ah_radio >= AR5K_RF5112) {
+		if (ah->ah_radio >= AR5K_RF5112) {
 			mode = AR5K_PHY_MODE_RAD_RF5112;
 			clock = AR5K_PHY_PLL_RF5112;
 		} else {
@@ -393,7 +393,7 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 				 * this, 5211 might support ofdm-only g after
 				 * all, there are also initial register values
 				 * in the code for g mode (see ath5k_hw.h). */
-				if (hal->ah_version == AR5K_AR5211)
+				if (ah->ah_version == AR5K_AR5211)
 					mode |= AR5K_PHY_MODE_MOD_OFDM;
 				else
 					mode |= AR5K_PHY_MODE_MOD_DYN;
@@ -421,7 +421,7 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 	} else { /* Reset and wakeup the device */
 		if (initial == true) {
 			/* ...reset hardware */
-			if (ath5k_hw_nic_reset(hal, AR5K_RESET_CTL_PCI)) {
+			if (ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCI)) {
 				AR5K_PRINT("failed to reset the PCI chipset\n");
 				return -EIO;
 			}
@@ -430,7 +430,7 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 		}
 
 		/* ...wakeup */
-		ret = ath5k_hw_set_power(hal, AR5K_PM_AWAKE, true, 0);
+		ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
 		if (ret) {
 			AR5K_PRINT("failed to resume the MAC Chip\n");
 			return ret;
@@ -438,11 +438,11 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 
 		/* ...enable Atheros turbo mode if requested */
 		if (flags & CHANNEL_TURBO)
-			ath5k_hw_reg_write(hal, AR5K_PHY_TURBO_MODE,
+			ath5k_hw_reg_write(ah, AR5K_PHY_TURBO_MODE,
 					AR5K_PHY_TURBO);
 
 		/* ...reset chipset */
-		if (ath5k_hw_nic_reset(hal, AR5K_RESET_CTL_CHIP)) {
+		if (ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_CHIP)) {
 			AR5K_PRINT("failed to reset the AR5210 chipset\n");
 			return -EIO;
 		}
@@ -451,35 +451,35 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 	}
 
 	/* ...reset chipset and PCI device */
-	if (hal->ah_single_chip == false && ath5k_hw_nic_reset(hal,
+	if (ah->ah_single_chip == false && ath5k_hw_nic_reset(ah,
 				AR5K_RESET_CTL_CHIP | AR5K_RESET_CTL_PCI)) {
 		AR5K_PRINT("failed to reset the MAC Chip + PCI\n");
 		return -EIO;
 	}
 
-	if (hal->ah_version == AR5K_AR5210)
+	if (ah->ah_version == AR5K_AR5210)
 		udelay(2300);
 
 	/* ...wakeup */
-	ret = ath5k_hw_set_power(hal, AR5K_PM_AWAKE, true, 0);
+	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
 	if (ret) {
 		AR5K_PRINT("failed to resume the MAC Chip\n");
 		return ret;
 	}
 
 	/* ...final warm reset */
-	if (ath5k_hw_nic_reset(hal, 0)) {
+	if (ath5k_hw_nic_reset(ah, 0)) {
 		AR5K_PRINT("failed to warm reset the MAC Chip\n");
 		return -EIO;
 	}
 
-	if (hal->ah_version != AR5K_AR5210) {
+	if (ah->ah_version != AR5K_AR5210) {
 		/* ...set the PHY operating mode */
-		ath5k_hw_reg_write(hal, clock, AR5K_PHY_PLL);
+		ath5k_hw_reg_write(ah, clock, AR5K_PHY_PLL);
 		udelay(300);
 
-		ath5k_hw_reg_write(hal, mode, AR5K_PHY_MODE);
-		ath5k_hw_reg_write(hal, turbo, AR5K_PHY_TURBO);
+		ath5k_hw_reg_write(ah, mode, AR5K_PHY_MODE);
+		ath5k_hw_reg_write(ah, turbo, AR5K_PHY_TURBO);
 	}
 
 	return 0;
@@ -488,12 +488,12 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 /*
  * Get the rate table for a specific operation mode
  */
-const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath_hw *hal,
+const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath5k_hw *ah,
 		unsigned int mode)
 {
 	AR5K_TRACE;
 
-	if (!test_bit(mode, hal->ah_capabilities.cap_mode))
+	if (!test_bit(mode, ah->ah_capabilities.cap_mode))
 		return NULL;
 
 	/* Get rate tables */
@@ -514,17 +514,17 @@ const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath_hw *hal,
 }
 
 /*
- * Free the hal struct
+ * Free the ath5k_hw struct
  */
-void ath5k_hw_detach(struct ath_hw *hal)
+void ath5k_hw_detach(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
 
-	if (hal->ah_rf_banks != NULL)
-		kfree(hal->ah_rf_banks);
+	if (ah->ah_rf_banks != NULL)
+		kfree(ah->ah_rf_banks);
 
 	/* assume interrupts are down */
-	kfree(hal);
+	kfree(ah);
 }
 
 /*******************************\
@@ -534,11 +534,11 @@ void ath5k_hw_detach(struct ath_hw *hal)
 /*
  * Main reset function
  */
-int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
+int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 	struct ieee80211_channel *channel, bool change_channel)
 {
 	const struct ath5k_rate_table *rt;
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 data, noise_floor, s_seq, s_ant, s_led[3];
 	unsigned int i, mode, freq, ee_mode, ant[2];
 	int ret;
@@ -555,43 +555,43 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	 * Save some registers before a reset
 	 */
 	/*DCU/Antenna selection not available on 5210*/
-	if (hal->ah_version != AR5K_AR5210) {
+	if (ah->ah_version != AR5K_AR5210) {
 		if (change_channel == true) {
 			/* Seq number for queue 0 -do this for all queues ? */
-			s_seq = ath5k_hw_reg_read(hal,
+			s_seq = ath5k_hw_reg_read(ah,
 					AR5K_QUEUE_DFS_SEQNUM(0));
 			/*Default antenna*/
-			s_ant = ath5k_hw_reg_read(hal, AR5K_DEFAULT_ANTENNA);
+			s_ant = ath5k_hw_reg_read(ah, AR5K_DEFAULT_ANTENNA);
 		}
 	}
 
 	/*GPIOs*/
-	s_led[0] = ath5k_hw_reg_read(hal, AR5K_PCICFG) & AR5K_PCICFG_LEDSTATE;
-	s_led[1] = ath5k_hw_reg_read(hal, AR5K_GPIOCR);
-	s_led[2] = ath5k_hw_reg_read(hal, AR5K_GPIODO);
+	s_led[0] = ath5k_hw_reg_read(ah, AR5K_PCICFG) & AR5K_PCICFG_LEDSTATE;
+	s_led[1] = ath5k_hw_reg_read(ah, AR5K_GPIOCR);
+	s_led[2] = ath5k_hw_reg_read(ah, AR5K_GPIODO);
 
-	if (change_channel == true && hal->ah_rf_banks != NULL)
-		ath5k_hw_get_rf_gain(hal);
+	if (change_channel == true && ah->ah_rf_banks != NULL)
+		ath5k_hw_get_rf_gain(ah);
 
 
 	/*Wakeup the device*/
-	ret = ath5k_hw_nic_wakeup(hal, channel->val, false);
+	ret = ath5k_hw_nic_wakeup(ah, channel->val, false);
 	if (ret)
 		return ret;
 
 	/*
 	 * Initialize operating mode
 	 */
-	hal->ah_op_mode = op_mode;
+	ah->ah_op_mode = op_mode;
 
 	/*
 	 * 5111/5112 Settings
 	 * 5210 only comes with RF5110
 	 */
-	if (hal->ah_version != AR5K_AR5210) {
-		if (hal->ah_radio != AR5K_RF5111 &&
-				hal->ah_radio != AR5K_RF5112) {
-			AR5K_PRINTF("invalid phy radio: %u\n", hal->ah_radio);
+	if (ah->ah_version != AR5K_AR5210) {
+		if (ah->ah_radio != AR5K_RF5111 &&
+				ah->ah_radio != AR5K_RF5112) {
+			AR5K_PRINTF("invalid phy radio: %u\n", ah->ah_radio);
 			return -EINVAL;
 		}
 
@@ -624,7 +624,7 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 			ee_mode = AR5K_EEPROM_MODE_11G;
 			break;
 		case CHANNEL_XR:
-			if (hal->ah_version == AR5K_AR5211) {
+			if (ah->ah_version == AR5K_AR5211) {
 				AR5K_PRINTF("XR mode not available on 5211");
 				return -EINVAL;
 			}
@@ -638,21 +638,21 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 		}
 
 		/* PHY access enable */
-		ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
+		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
 
 	}
 
-	ath5k_hw_write_initvals(hal, mode, change_channel);
+	ath5k_hw_write_initvals(ah, mode, change_channel);
 
 	/*
 	 * 5211/5212 Specific
 	 */
-	if (hal->ah_version != AR5K_AR5210) {
+	if (ah->ah_version != AR5K_AR5210) {
 		/*
 		 * Write initial RF gain settings
 		 * This should work for both 5111/5112
 		 */
-		ret = ath5k_hw_rfgain(hal, freq);
+		ret = ath5k_hw_rfgain(ah, freq);
 		if (ret)
 			return ret;
 
@@ -661,25 +661,25 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 		/*
 		 * Set rate duration table on 5212
 		 */
-		if (hal->ah_version == AR5K_AR5212) {
+		if (ah->ah_version == AR5K_AR5212) {
 
 			/*For 802.11b*/
 			if (!(channel->val & CHANNEL_B)) {
 
 				/*Get rate table for this operation mode*/
-				rt = ath5k_hw_get_rate_table(hal,
+				rt = ath5k_hw_get_rate_table(ah,
 						MODE_IEEE80211B);
 
 				/*Write rate duration table*/
 				for (i = 0; i < rt->rate_count; i++) {
 					data = AR5K_RATE_DUR(rt->rates[i].rate_code);
-					ath5k_hw_reg_write(hal,
-						ath_hal_computetxtime(hal, rt,
+					ath5k_hw_reg_write(ah,
+						ath5k_computetxtime(ah, rt,
 						14, rt->rates[i].control_rate,
 						false), data);
 					if (HAS_SHPREAMBLE(i))
-						ath5k_hw_reg_write(hal,
-						    ath_hal_computetxtime(hal,
+						ath5k_hw_reg_write(ah,
+						    ath5k_computetxtime(ah,
 						    rt, 14,
 						    rt->rates[i].control_rate,
 						    false), data +
@@ -691,14 +691,14 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 			 * O.K. for both a/g - OFDM) */
 
 				/* Get rate table for this operation mode */
-				rt = ath5k_hw_get_rate_table(hal,
+				rt = ath5k_hw_get_rate_table(ah,
 				    channel->val & CHANNEL_TURBO ?
 				    MODE_ATHEROS_TURBO : MODE_ATHEROS_TURBOG);
 
 				/* Write rate duration table */
 				for (i = 0; i < rt->rate_count; i++)
-					ath5k_hw_reg_write(hal,
-						ath_hal_computetxtime(hal, rt,
+					ath5k_hw_reg_write(ah,
+						ath5k_computetxtime(ah, rt,
 						14, rt->rates[i].control_rate,
 						false),
 						AR5K_RATE_DUR(rt->rates[i].rate_code));
@@ -707,22 +707,22 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 		}
 
 		/* Fix for first revision of the RF5112 RF chipset */
-		if (hal->ah_radio >= AR5K_RF5112 &&
-				hal->ah_radio_5ghz_revision <
+		if (ah->ah_radio >= AR5K_RF5112 &&
+				ah->ah_radio_5ghz_revision <
 				AR5K_SREV_RAD_5112A) {
-			ath5k_hw_reg_write(hal, AR5K_PHY_CCKTXCTL_WORLD,
+			ath5k_hw_reg_write(ah, AR5K_PHY_CCKTXCTL_WORLD,
 					AR5K_PHY_CCKTXCTL);
 			if (channel->val & CHANNEL_A)
 				data = 0xffb81020;
 			else
 				data = 0xffb80d20;
-			ath5k_hw_reg_write(hal, data, AR5K_PHY_FRAME_CTL);
+			ath5k_hw_reg_write(ah, data, AR5K_PHY_FRAME_CTL);
 		}
 
 		/*
 		 * Set TX power (XXX use txpower from net80211)
 		 */
-		ret = ath5k_hw_txpower(hal, channel, AR5K_TUNE_DEFAULT_TXPOWER);
+		ret = ath5k_hw_txpower(ah, channel, AR5K_TUNE_DEFAULT_TXPOWER);
 		if (ret)
 			return ret;
 
@@ -730,7 +730,7 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 		 * Write RF registers
 		 * TODO:Does this work on 5211 (5111) ?
 		 */
-		ret = ath5k_hw_rfregs(hal, channel, mode);
+		ret = ath5k_hw_rfregs(ah, channel, mode);
 		if (ret)
 			return ret;
 
@@ -739,7 +739,7 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 		 */
 
 		/* Write OFDM timings on 5212*/
-		if (hal->ah_version == AR5K_AR5212) {
+		if (ah->ah_version == AR5K_AR5212) {
 			if (channel->val & CHANNEL_OFDM) {
 				u32 coef_scaled, coef_exp, coef_man,
 					ds_coef_exp, ds_coef_man, clock;
@@ -761,84 +761,84 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 				ds_coef_man = coef_man >> (24 - coef_exp);
 				ds_coef_exp = coef_exp - 16;
 
-				AR5K_REG_WRITE_BITS(hal, AR5K_PHY_TIMING_3,
+				AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
 				    AR5K_PHY_TIMING_3_DSC_MAN, ds_coef_man);
-				AR5K_REG_WRITE_BITS(hal, AR5K_PHY_TIMING_3,
+				AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TIMING_3,
 				    AR5K_PHY_TIMING_3_DSC_EXP, ds_coef_exp);
 			}
 		}
 
 		/*Enable/disable 802.11b mode on 5111
 		(enable 2111 frequency converter + CCK)*/
-		if (hal->ah_radio == AR5K_RF5111) {
+		if (ah->ah_radio == AR5K_RF5111) {
 			if (channel->val & CHANNEL_B)
-				AR5K_REG_ENABLE_BITS(hal, AR5K_TXCFG,
+				AR5K_REG_ENABLE_BITS(ah, AR5K_TXCFG,
 				    AR5K_TXCFG_B_MODE);
 			else
-				AR5K_REG_DISABLE_BITS(hal, AR5K_TXCFG,
+				AR5K_REG_DISABLE_BITS(ah, AR5K_TXCFG,
 				    AR5K_TXCFG_B_MODE);
 		}
 
 		/* Set antenna mode */
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x44),
-			hal->ah_antenna[ee_mode][0], 0xfffffc06);
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY(0x44),
+			ah->ah_antenna[ee_mode][0], 0xfffffc06);
 
 		if (freq == AR5K_INI_RFGAIN_2GHZ)
 			ant[0] = ant[1] = AR5K_ANT_FIXED_B;
 		else
 			ant[0] = ant[1] = AR5K_ANT_FIXED_A;
 
-		ath5k_hw_reg_write(hal, hal->ah_antenna[ee_mode][ant[0]],
+		ath5k_hw_reg_write(ah, ah->ah_antenna[ee_mode][ant[0]],
 			AR5K_PHY_ANT_SWITCH_TABLE_0);
-		ath5k_hw_reg_write(hal, hal->ah_antenna[ee_mode][ant[1]],
+		ath5k_hw_reg_write(ah, ah->ah_antenna[ee_mode][ant[1]],
 			AR5K_PHY_ANT_SWITCH_TABLE_1);
 
 		/* Commit values from EEPROM */
-		if (hal->ah_radio == AR5K_RF5111)
-			AR5K_REG_WRITE_BITS(hal, AR5K_PHY_FRAME_CTL,
+		if (ah->ah_radio == AR5K_RF5111)
+			AR5K_REG_WRITE_BITS(ah, AR5K_PHY_FRAME_CTL,
 			    AR5K_PHY_FRAME_CTL_TX_CLIP, ee->ee_tx_clip);
 
-		ath5k_hw_reg_write(hal,
+		ath5k_hw_reg_write(ah,
 			AR5K_PHY_NF_SVAL(ee->ee_noise_floor_thr[ee_mode]),
 			AR5K_PHY(0x5a));
 
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x11),
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY(0x11),
 			(ee->ee_switch_settling[ee_mode] << 7) & 0x3f80,
 			0xffffc07f);
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x12),
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY(0x12),
 			(ee->ee_ant_tx_rx[ee_mode] << 12) & 0x3f000,
 			0xfffc0fff);
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x14),
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY(0x14),
 			(ee->ee_adc_desired_size[ee_mode] & 0x00ff) |
 			((ee->ee_pga_desired_size[ee_mode] << 8) & 0xff00),
 			0xffff0000);
 
-		ath5k_hw_reg_write(hal,
+		ath5k_hw_reg_write(ah,
 			(ee->ee_tx_end2xpa_disable[ee_mode] << 24) |
 			(ee->ee_tx_end2xpa_disable[ee_mode] << 16) |
 			(ee->ee_tx_frm2xpa_enable[ee_mode] << 8) |
 			(ee->ee_tx_frm2xpa_enable[ee_mode]), AR5K_PHY(0x0d));
 
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x0a),
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY(0x0a),
 			ee->ee_tx_end2xlna_enable[ee_mode] << 8, 0xffff00ff);
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x19),
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY(0x19),
 			(ee->ee_thr_62[ee_mode] << 12) & 0x7f000, 0xfff80fff);
-		AR5K_REG_MASKED_BITS(hal, AR5K_PHY(0x49), 4, 0xffffff01);
+		AR5K_REG_MASKED_BITS(ah, AR5K_PHY(0x49), 4, 0xffffff01);
 
-		AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_IQ,
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ,
 		    AR5K_PHY_IQ_CORR_ENABLE |
 		    (ee->ee_i_cal[ee_mode] << AR5K_PHY_IQ_CORR_Q_I_COFF_S) |
 		    ee->ee_q_cal[ee_mode]);
 
-		if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
-			AR5K_REG_WRITE_BITS(hal, AR5K_PHY_GAIN_2GHZ,
+		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
+			AR5K_REG_WRITE_BITS(ah, AR5K_PHY_GAIN_2GHZ,
 				AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX,
 				ee->ee_margin_tx_rx[ee_mode]);
 
 	} else {
 		mdelay(1);
 		/* Disable phy and wait */
-		ath5k_hw_reg_write(hal, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
+		ath5k_hw_reg_write(ah, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
 		mdelay(1);
 	}
 
@@ -846,61 +846,61 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	 * Restore saved values
 	 */
 	/*DCU/Antenna selection not available on 5210*/
-	if (hal->ah_version != AR5K_AR5210) {
-		ath5k_hw_reg_write(hal, s_seq, AR5K_QUEUE_DFS_SEQNUM(0));
-		ath5k_hw_reg_write(hal, s_ant, AR5K_DEFAULT_ANTENNA);
+	if (ah->ah_version != AR5K_AR5210) {
+		ath5k_hw_reg_write(ah, s_seq, AR5K_QUEUE_DFS_SEQNUM(0));
+		ath5k_hw_reg_write(ah, s_ant, AR5K_DEFAULT_ANTENNA);
 	}
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PCICFG, s_led[0]);
-	ath5k_hw_reg_write(hal, s_led[1], AR5K_GPIOCR);
-	ath5k_hw_reg_write(hal, s_led[2], AR5K_GPIODO);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, s_led[0]);
+	ath5k_hw_reg_write(ah, s_led[1], AR5K_GPIOCR);
+	ath5k_hw_reg_write(ah, s_led[2], AR5K_GPIODO);
 
 	/*
 	 * Misc
 	 */
-	/* XXX: add hal->aid once mac80211 gives this to us */
-	ath5k_hw_set_associd(hal, hal->bssid, 0);
+	/* XXX: add ah->aid once mac80211 gives this to us */
+	ath5k_hw_set_associd(ah, ah->bssid, 0);
 
-	ath5k_hw_set_opmode(hal);
+	ath5k_hw_set_opmode(ah);
 	/*PISR/SISR Not available on 5210*/
-	if (hal->ah_version != AR5K_AR5210) {
-		ath5k_hw_reg_write(hal, 0xffffffff, AR5K_PISR);
+	if (ah->ah_version != AR5K_AR5210) {
+		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_PISR);
 		/* XXX: AR5K_RSSI_THR has masks and shifts defined for it, so
 		 * direct write using ath5k_hw_reg_write seems wrong. Test with:
-		 * AR5K_REG_WRITE_BITS(hal, AR5K_RSSI_THR,
+		 * AR5K_REG_WRITE_BITS(ah, AR5K_RSSI_THR,
 		 *   AR5K_RSSI_THR_BMISS, AR5K_TUNE_RSSI_THRES);
 		 * with different variables and check results compared
-		 * to ath5k_hw_reg_write(hal, )  */
-		ath5k_hw_reg_write(hal, AR5K_TUNE_RSSI_THRES, AR5K_RSSI_THR);
+		 * to ath5k_hw_reg_write(ah, )  */
+		ath5k_hw_reg_write(ah, AR5K_TUNE_RSSI_THRES, AR5K_RSSI_THR);
 	}
 
 	/*
 	 * Set Rx/Tx DMA Configuration
 	 *(passing dma size not available on 5210)
 	 */
-	if (hal->ah_version != AR5K_AR5210) {
-		AR5K_REG_WRITE_BITS(hal, AR5K_TXCFG, AR5K_TXCFG_SDMAMR,
+	if (ah->ah_version != AR5K_AR5210) {
+		AR5K_REG_WRITE_BITS(ah, AR5K_TXCFG, AR5K_TXCFG_SDMAMR,
 				AR5K_DMASIZE_512B | AR5K_TXCFG_DMASIZE);
-		AR5K_REG_WRITE_BITS(hal, AR5K_RXCFG, AR5K_RXCFG_SDMAMW,
+		AR5K_REG_WRITE_BITS(ah, AR5K_RXCFG, AR5K_RXCFG_SDMAMW,
 				AR5K_DMASIZE_512B);
 	}
 
 	/*
 	 * Set channel and calibrate the PHY
 	 */
-	ret = ath5k_hw_channel(hal, channel);
+	ret = ath5k_hw_channel(ah, channel);
 	if (ret)
 		return ret;
 
 	/*
 	 * Enable the PHY and wait until completion
 	 */
-	ath5k_hw_reg_write(hal, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
+	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
 
 	/*
 	 * 5111/5112 Specific
 	 */
-	if (hal->ah_version != AR5K_AR5210) {
-		data = ath5k_hw_reg_read(hal, AR5K_PHY_RX_DELAY) &
+	if (ah->ah_version != AR5K_AR5210) {
+		data = ath5k_hw_reg_read(ah, AR5K_PHY_RX_DELAY) &
 			AR5K_PHY_RX_DELAY_M;
 		data = (channel->val & CHANNEL_CCK) ?
 			((data << 2) / 22) : (data / 10);
@@ -913,10 +913,10 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	/*
 	 * Enable calibration and wait until completion
 	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL,
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
 				AR5K_PHY_AGCCTL_CAL);
 
-	if (ath5k_hw_register_timeout(hal, AR5K_PHY_AGCCTL,
+	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
 			AR5K_PHY_AGCCTL_CAL, 0, false)) {
 		AR5K_PRINTF("calibration timeout (%uMHz)\n", channel->freq);
 		return -EAGAIN;
@@ -925,10 +925,10 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	/*
 	 * Enable noise floor calibration and wait until completion
 	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL,
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
 				AR5K_PHY_AGCCTL_NF);
 
-	if (ath5k_hw_register_timeout(hal, AR5K_PHY_AGCCTL,
+	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
 			AR5K_PHY_AGCCTL_NF, 0, false)) {
 		AR5K_PRINTF("noise floor calibration timeout (%uMHz)\n",
 				channel->freq);
@@ -938,7 +938,7 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	/* Wait until the noise floor is calibrated and read the value */
 	for (i = 20; i > 0; i--) {
 		mdelay(1);
-		noise_floor = ath5k_hw_reg_read(hal, AR5K_PHY_NF);
+		noise_floor = ath5k_hw_reg_read(ah, AR5K_PHY_NF);
 
 		if (AR5K_PHY_NF_RVAL(noise_floor) &
 		AR5K_PHY_NF_ACTIVE)
@@ -954,25 +954,25 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 		return -EIO;
 	}
 
-	hal->ah_calibration = false;
+	ah->ah_calibration = false;
 
 	if (!(channel->val & CHANNEL_B)) {
-		hal->ah_calibration = true;
-		AR5K_REG_WRITE_BITS(hal, AR5K_PHY_IQ,
+		ah->ah_calibration = true;
+		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_IQ,
 				AR5K_PHY_IQ_CAL_NUM_LOG_MAX, 15);
-		AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_IQ,
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ,
 				AR5K_PHY_IQ_RUN);
 	}
 
 	/*
 	 * Reset queues and start beacon timers at the end of the reset routine
 	 */
-	for (i = 0; i < hal->ah_capabilities.cap_queues.q_tx_num; i++) {
+	for (i = 0; i < ah->ah_capabilities.cap_queues.q_tx_num; i++) {
 		/*No QCU on 5210*/
-		if (hal->ah_version != AR5K_AR5210)
-			AR5K_REG_WRITE_Q(hal, AR5K_QUEUE_QCUMASK(i), i);
+		if (ah->ah_version != AR5K_AR5210)
+			AR5K_REG_WRITE_Q(ah, AR5K_QUEUE_QCUMASK(i), i);
 
-		ret = ath5k_hw_reset_tx_queue(hal, i);
+		ret = ath5k_hw_reset_tx_queue(ah, i);
 		if (ret) {
 			AR5K_PRINTF("failed to reset TX queue #%d\n", i);
 			return ret;
@@ -980,36 +980,36 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	}
 
 	/* Pre-enable interrupts on 5211/5212*/
-	if (hal->ah_version != AR5K_AR5210)
-		ath5k_hw_set_intr(hal, AR5K_INT_RX | AR5K_INT_TX |
+	if (ah->ah_version != AR5K_AR5210)
+		ath5k_hw_set_intr(ah, AR5K_INT_RX | AR5K_INT_TX |
 				AR5K_INT_FATAL);
 
 	/*
 	 * Set RF kill flags if supported by the device (read from the EEPROM)
 	 * Disable gpio_intr for now since it results system hang.
-	 * TODO: Handle this in ath_intr
+	 * TODO: Handle this in ath5k_intr
 	 */
 #if 0
-	if (AR5K_EEPROM_HDR_RFKILL(hal->ah_capabilities.cap_eeprom.ee_header)) {
-		ath5k_hw_set_gpio_input(hal, 0);
-		hal->ah_gpio[0] = ath5k_hw_get_gpio(hal, 0);
-		if (hal->ah_gpio[0] == 0)
-			ath5k_hw_set_gpio_intr(hal, 0, 1);
+	if (AR5K_EEPROM_HDR_RFKILL(ah->ah_capabilities.cap_eeprom.ee_header)) {
+		ath5k_hw_set_gpio_input(ah, 0);
+		ah->ah_gpio[0] = ath5k_hw_get_gpio(ah, 0);
+		if (ah->ah_gpio[0] == 0)
+			ath5k_hw_set_gpio_intr(ah, 0, 1);
 		else
-			ath5k_hw_set_gpio_intr(hal, 0, 0);
+			ath5k_hw_set_gpio_intr(ah, 0, 0);
 	}
 #endif
 
 	/*
 	 * Set the 32MHz reference clock on 5212 phy clock sleep register
 	 */
-	if (hal->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(hal, AR5K_PHY_SCR_32MHZ, AR5K_PHY_SCR);
-		ath5k_hw_reg_write(hal, AR5K_PHY_SLMT_32MHZ, AR5K_PHY_SLMT);
-		ath5k_hw_reg_write(hal, AR5K_PHY_SCAL_32MHZ, AR5K_PHY_SCAL);
-		ath5k_hw_reg_write(hal, AR5K_PHY_SCLOCK_32MHZ, AR5K_PHY_SCLOCK);
-		ath5k_hw_reg_write(hal, AR5K_PHY_SDELAY_32MHZ, AR5K_PHY_SDELAY);
-		ath5k_hw_reg_write(hal, hal->ah_radio == AR5K_RF5111 ?
+	if (ah->ah_version == AR5K_AR5212) {
+		ath5k_hw_reg_write(ah, AR5K_PHY_SCR_32MHZ, AR5K_PHY_SCR);
+		ath5k_hw_reg_write(ah, AR5K_PHY_SLMT_32MHZ, AR5K_PHY_SLMT);
+		ath5k_hw_reg_write(ah, AR5K_PHY_SCAL_32MHZ, AR5K_PHY_SCAL);
+		ath5k_hw_reg_write(ah, AR5K_PHY_SCLOCK_32MHZ, AR5K_PHY_SCLOCK);
+		ath5k_hw_reg_write(ah, AR5K_PHY_SDELAY_32MHZ, AR5K_PHY_SDELAY);
+		ath5k_hw_reg_write(ah, ah->ah_radio == AR5K_RF5111 ?
 			AR5K_PHY_SPENDING_RF5111 : AR5K_PHY_SPENDING_RF5112,
 			AR5K_PHY_SPENDING);
 	}
@@ -1017,7 +1017,7 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 	/*
 	 * Disable beacons and reset the register
 	 */
-	AR5K_REG_DISABLE_BITS(hal, AR5K_BEACON, AR5K_BEACON_ENABLE |
+	AR5K_REG_DISABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_ENABLE |
 			AR5K_BEACON_RESET_TSF);
 
 	return 0;
@@ -1026,7 +1026,7 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 /*
  * Reset chipset
  */
-static int ath5k_hw_nic_reset(struct ath_hw *hal, u32 val)
+static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
 {
 	int ret;
 	u32 mask = val ? val : ~0;
@@ -1034,17 +1034,17 @@ static int ath5k_hw_nic_reset(struct ath_hw *hal, u32 val)
 	AR5K_TRACE;
 
 	/* Read-and-clear RX Descriptor Pointer*/
-	ath5k_hw_reg_read(hal, AR5K_RXDP);
+	ath5k_hw_reg_read(ah, AR5K_RXDP);
 
 	/*
 	 * Reset the device and wait until success
 	 */
-	ath5k_hw_reg_write(hal, val, AR5K_RESET_CTL);
+	ath5k_hw_reg_write(ah, val, AR5K_RESET_CTL);
 
 	/* Wait at least 128 PCI clocks */
 	udelay(15);
 
-	if (hal->ah_version == AR5K_AR5210) {
+	if (ah->ah_version == AR5K_AR5210) {
 		val &= AR5K_RESET_CTL_CHIP;
 		mask &= AR5K_RESET_CTL_CHIP;
 	} else {
@@ -1052,7 +1052,7 @@ static int ath5k_hw_nic_reset(struct ath_hw *hal, u32 val)
 		mask &= AR5K_RESET_CTL_PCU | AR5K_RESET_CTL_BASEBAND;
 	}
 
-	ret = ath5k_hw_register_timeout(hal, AR5K_RESET_CTL, mask, val, false);
+	ret = ath5k_hw_register_timeout(ah, AR5K_RESET_CTL, mask, val, false);
 
 	/*
 	 * Reset configuration register (for hw byte-swap). Note that this
@@ -1060,7 +1060,7 @@ static int ath5k_hw_nic_reset(struct ath_hw *hal, u32 val)
 	 * AR5K_INIT_CFG.
 	 */
 	if ((val & AR5K_RESET_CTL_PCU) == 0)
-		ath5k_hw_reg_write(hal, AR5K_INIT_CFG, AR5K_CFG);
+		ath5k_hw_reg_write(ah, AR5K_INIT_CFG, AR5K_CFG);
 
 	return ret;
 }
@@ -1072,14 +1072,14 @@ static int ath5k_hw_nic_reset(struct ath_hw *hal, u32 val)
 /*
  * Sleep control
  */
-int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode,
+int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
 		bool set_chip, u16 sleep_duration)
 {
 	unsigned int i;
 	u32 staid;
 
 	AR5K_TRACE;
-	staid = ath5k_hw_reg_read(hal, AR5K_STA_ID1);
+	staid = ath5k_hw_reg_read(ah, AR5K_STA_ID1);
 
 	switch (mode) {
 	case AR5K_PM_AUTO:
@@ -1087,7 +1087,7 @@ int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode,
 		/* fallthrough */
 	case AR5K_PM_NETWORK_SLEEP:
 		if (set_chip == true)
-			ath5k_hw_reg_write(hal,
+			ath5k_hw_reg_write(ah,
 				AR5K_SLEEP_CTL_SLE | sleep_duration,
 				AR5K_SLEEP_CTL);
 
@@ -1096,7 +1096,7 @@ int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode,
 
 	case AR5K_PM_FULL_SLEEP:
 		if (set_chip == true)
-			ath5k_hw_reg_write(hal, AR5K_SLEEP_CTL_SLE_SLP,
+			ath5k_hw_reg_write(ah, AR5K_SLEEP_CTL_SLE_SLP,
 				AR5K_SLEEP_CTL);
 
 		staid |= AR5K_STA_ID1_PWR_SV;
@@ -1106,18 +1106,18 @@ int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode,
 		if (set_chip == false)
 			goto commit;
 
-		ath5k_hw_reg_write(hal, AR5K_SLEEP_CTL_SLE_WAKE,
+		ath5k_hw_reg_write(ah, AR5K_SLEEP_CTL_SLE_WAKE,
 				AR5K_SLEEP_CTL);
 
 		for (i = 5000; i > 0; i--) {
 			/* Check if the chip did wake up */
-			if ((ath5k_hw_reg_read(hal, AR5K_PCICFG) &
+			if ((ath5k_hw_reg_read(ah, AR5K_PCICFG) &
 					AR5K_PCICFG_SPWR_DN) == 0)
 				break;
 
 			/* Wait a bit and retry */
 			udelay(200);
-			ath5k_hw_reg_write(hal, AR5K_SLEEP_CTL_SLE_WAKE,
+			ath5k_hw_reg_write(ah, AR5K_SLEEP_CTL_SLE_WAKE,
 				AR5K_SLEEP_CTL);
 		}
 
@@ -1133,8 +1133,8 @@ int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode,
 	}
 
 commit:
-	hal->ah_power_mode = mode;
-	ath5k_hw_reg_write(hal, staid, AR5K_STA_ID1);
+	ah->ah_power_mode = mode;
+	ath5k_hw_reg_write(ah, staid, AR5K_STA_ID1);
 
 	return 0;
 }
@@ -1150,27 +1150,27 @@ commit:
 /*
  * Start DMA receive
  */
-void ath5k_hw_start_rx(struct ath_hw *hal)
+void ath5k_hw_start_rx(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
-	ath5k_hw_reg_write(hal, AR5K_CR_RXE, AR5K_CR);
+	ath5k_hw_reg_write(ah, AR5K_CR_RXE, AR5K_CR);
 }
 
 /*
  * Stop DMA receive
  */
-int ath5k_hw_stop_rx_dma(struct ath_hw *hal)
+int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
 {
 	unsigned int i;
 
 	AR5K_TRACE;
-	ath5k_hw_reg_write(hal, AR5K_CR_RXD, AR5K_CR);
+	ath5k_hw_reg_write(ah, AR5K_CR_RXD, AR5K_CR);
 
 	/*
 	 * It may take some time to disable the DMA receive unit
 	 */
 	for (i = 2000; i > 0 &&
-			(ath5k_hw_reg_read(hal, AR5K_CR) & AR5K_CR_RXE) != 0;
+			(ath5k_hw_reg_read(ah, AR5K_CR) & AR5K_CR_RXE) != 0;
 			i--)
 		udelay(10);
 
@@ -1180,20 +1180,20 @@ int ath5k_hw_stop_rx_dma(struct ath_hw *hal)
 /*
  * Get the address of the RX Descriptor
  */
-u32 ath5k_hw_get_rx_buf(struct ath_hw *hal)
+u32 ath5k_hw_get_rx_buf(struct ath5k_hw *ah)
 {
-	return ath5k_hw_reg_read(hal, AR5K_RXDP);
+	return ath5k_hw_reg_read(ah, AR5K_RXDP);
 }
 
 /*
  * Set the address of the RX Descriptor
  */
-void ath5k_hw_put_rx_buf(struct ath_hw *hal, u32 phys_addr)
+void ath5k_hw_put_rx_buf(struct ath5k_hw *ah, u32 phys_addr)
 {
 	AR5K_TRACE;
 
 	/*TODO:Shouldn't we check if RX is enabled first ?*/
-	ath5k_hw_reg_write(hal, phys_addr, AR5K_RXDP);
+	ath5k_hw_reg_write(ah, phys_addr, AR5K_RXDP);
 }
 
 /*
@@ -1204,49 +1204,49 @@ void ath5k_hw_put_rx_buf(struct ath_hw *hal, u32 phys_addr)
  * Start DMA transmit for a specific queue
  * (see also QCU/DCU functions)
  */
-int ath5k_hw_tx_start(struct ath_hw *hal, unsigned int queue)
+int ath5k_hw_tx_start(struct ath5k_hw *ah, unsigned int queue)
 {
 	u32 tx_queue;
 
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/* Return if queue is declared inactive */
-	if (hal->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
 		return -EIO;
 
-	if (hal->ah_version == AR5K_AR5210) {
-		tx_queue = ath5k_hw_reg_read(hal, AR5K_CR);
+	if (ah->ah_version == AR5K_AR5210) {
+		tx_queue = ath5k_hw_reg_read(ah, AR5K_CR);
 
 		/*
 		 * Set the queue by type on 5210
 		 */
-		switch (hal->ah_txq[queue].tqi_type) {
+		switch (ah->ah_txq[queue].tqi_type) {
 		case AR5K_TX_QUEUE_DATA:
 			tx_queue |= AR5K_CR_TXE0 & ~AR5K_CR_TXD0;
 			break;
 		case AR5K_TX_QUEUE_BEACON:
 			tx_queue |= AR5K_CR_TXE1 & ~AR5K_CR_TXD1;
-			ath5k_hw_reg_write(hal, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
+			ath5k_hw_reg_write(ah, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
 					AR5K_BSR);
 			break;
 		case AR5K_TX_QUEUE_CAB:
 			tx_queue |= AR5K_CR_TXE1 & ~AR5K_CR_TXD1;
-			ath5k_hw_reg_write(hal, AR5K_BCR_TQ1FV | AR5K_BCR_TQ1V |
+			ath5k_hw_reg_write(ah, AR5K_BCR_TQ1FV | AR5K_BCR_TQ1V |
 				AR5K_BCR_BDMAE, AR5K_BSR);
 			break;
 		default:
 			return -EINVAL;
 		}
 		/* Start queue */
-		ath5k_hw_reg_write(hal, tx_queue, AR5K_CR);
+		ath5k_hw_reg_write(ah, tx_queue, AR5K_CR);
 	} else {
 		/* Return if queue is disabled */
-		if (AR5K_REG_READ_Q(hal, AR5K_QCU_TXD, queue))
+		if (AR5K_REG_READ_Q(ah, AR5K_QCU_TXD, queue))
 			return -EIO;
 
 		/* Start queue */
-		AR5K_REG_WRITE_Q(hal, AR5K_QCU_TXE, queue);
+		AR5K_REG_WRITE_Q(ah, AR5K_QCU_TXE, queue);
 	}
 
 	return 0;
@@ -1256,25 +1256,25 @@ int ath5k_hw_tx_start(struct ath_hw *hal, unsigned int queue)
  * Stop DMA transmit for a specific queue
  * (see also QCU/DCU functions)
  */
-int ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
+int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 {
 	unsigned int i = 100;
 	u32 tx_queue, pending;
 
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/* Return if queue is declared inactive */
-	if (hal->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
 		return -EIO;
 
-	if (hal->ah_version == AR5K_AR5210) {
-		tx_queue = ath5k_hw_reg_read(hal, AR5K_CR);
+	if (ah->ah_version == AR5K_AR5210) {
+		tx_queue = ath5k_hw_reg_read(ah, AR5K_CR);
 
 		/*
 		 * Set by queue type
 		 */
-		switch (hal->ah_txq[queue].tqi_type) {
+		switch (ah->ah_txq[queue].tqi_type) {
 		case AR5K_TX_QUEUE_DATA:
 			tx_queue |= AR5K_CR_TXD0 & ~AR5K_CR_TXE0;
 			break;
@@ -1282,30 +1282,30 @@ int ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
 		case AR5K_TX_QUEUE_CAB:
 			/* XXX Fix me... */
 			tx_queue |= AR5K_CR_TXD1 & ~AR5K_CR_TXD1;
-			ath5k_hw_reg_write(hal, 0, AR5K_BSR);
+			ath5k_hw_reg_write(ah, 0, AR5K_BSR);
 			break;
 		default:
 			return -EINVAL;
 		}
 
 		/* Stop queue */
-		ath5k_hw_reg_write(hal, tx_queue, AR5K_CR);
+		ath5k_hw_reg_write(ah, tx_queue, AR5K_CR);
 	} else {
 		/*
 		 * Schedule TX disable and wait until queue is empty
 		 */
-		AR5K_REG_WRITE_Q(hal, AR5K_QCU_TXD, queue);
+		AR5K_REG_WRITE_Q(ah, AR5K_QCU_TXD, queue);
 
 		/*Check for pending frames*/
 		do {
-			pending = ath5k_hw_reg_read(hal,
+			pending = ath5k_hw_reg_read(ah,
 				AR5K_QUEUE_STATUS(queue)) &
 				AR5K_QCU_STS_FRMPENDCNT;
 			udelay(100);
 		} while (--i && pending);
 
 		/* Clear register */
-		ath5k_hw_reg_write(hal, 0, AR5K_QCU_TXD);
+		ath5k_hw_reg_write(ah, 0, AR5K_QCU_TXD);
 	}
 
 	/* TODO: Check for success else return error */
@@ -1316,19 +1316,19 @@ int ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue)
  * Get the address of the TX Descriptor for a specific queue
  * (see also QCU/DCU functions)
  */
-u32 ath5k_hw_get_tx_buf(struct ath_hw *hal, unsigned int queue)
+u32 ath5k_hw_get_tx_buf(struct ath5k_hw *ah, unsigned int queue)
 {
 	u16 tx_reg;
 
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/*
 	 * Get the transmit queue descriptor pointer from the selected queue
 	 */
 	/*5210 doesn't have QCU*/
-	if (hal->ah_version == AR5K_AR5210) {
-		switch (hal->ah_txq[queue].tqi_type) {
+	if (ah->ah_version == AR5K_AR5210) {
+		switch (ah->ah_txq[queue].tqi_type) {
 		case AR5K_TX_QUEUE_DATA:
 			tx_reg = AR5K_NOQCU_TXDP0;
 			break;
@@ -1343,26 +1343,26 @@ u32 ath5k_hw_get_tx_buf(struct ath_hw *hal, unsigned int queue)
 		tx_reg = AR5K_QUEUE_TXDP(queue);
 	}
 
-	return ath5k_hw_reg_read(hal, tx_reg);
+	return ath5k_hw_reg_read(ah, tx_reg);
 }
 
 /*
  * Set the address of the TX Descriptor for a specific queue
  * (see also QCU/DCU functions)
  */
-int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr)
+int ath5k_hw_put_tx_buf(struct ath5k_hw *ah, unsigned int queue, u32 phys_addr)
 {
 	u16 tx_reg;
 
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/*
 	 * Set the transmit queue descriptor pointer register by type
 	 * on 5210
 	 */
-	if (hal->ah_version == AR5K_AR5210) {
-		switch (hal->ah_txq[queue].tqi_type) {
+	if (ah->ah_version == AR5K_AR5210) {
+		switch (ah->ah_txq[queue].tqi_type) {
 		case AR5K_TX_QUEUE_DATA:
 			tx_reg = AR5K_NOQCU_TXDP0;
 			break;
@@ -1379,14 +1379,14 @@ int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr)
 		 * the selected queue on QCU for 5211+
 		 * (this won't work if the queue is still active)
 		 */
-		if (AR5K_REG_READ_Q(hal, AR5K_QCU_TXE, queue))
+		if (AR5K_REG_READ_Q(ah, AR5K_QCU_TXE, queue))
 			return -EIO;
 
 		tx_reg = AR5K_QUEUE_TXDP(queue);
 	}
 
 	/* Set descriptor pointer */
-	ath5k_hw_reg_write(hal, phys_addr, tx_reg);
+	ath5k_hw_reg_write(ah, phys_addr, tx_reg);
 
 	return 0;
 }
@@ -1394,7 +1394,7 @@ int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr)
 /*
  * Update tx trigger level
  */
-int ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase)
+int ath5k_hw_update_tx_triglevel(struct ath5k_hw *ah, bool increase)
 {
 	u32 trigger_level, imr;
 	int ret = -EIO;
@@ -1404,10 +1404,10 @@ int ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase)
 	/*
 	 * Disable interrupts by setting the mask
 	 */
-	imr = ath5k_hw_set_intr(hal, hal->ah_imr & ~AR5K_INT_GLOBAL);
+	imr = ath5k_hw_set_intr(ah, ah->ah_imr & ~AR5K_INT_GLOBAL);
 
 	/*TODO: Boundary check on trigger_level*/
-	trigger_level = AR5K_REG_MS(ath5k_hw_reg_read(hal, AR5K_TXCFG),
+	trigger_level = AR5K_REG_MS(ath5k_hw_reg_read(ah, AR5K_TXCFG),
 			AR5K_TXCFG_TXFULL);
 
 	if (increase == false) {
@@ -1420,10 +1420,10 @@ int ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase)
 	/*
 	 * Update trigger level on success
 	 */
-	if (hal->ah_version == AR5K_AR5210)
-		ath5k_hw_reg_write(hal, trigger_level, AR5K_TRIG_LVL);
+	if (ah->ah_version == AR5K_AR5210)
+		ath5k_hw_reg_write(ah, trigger_level, AR5K_TRIG_LVL);
 	else
-		AR5K_REG_WRITE_BITS(hal, AR5K_TXCFG,
+		AR5K_REG_WRITE_BITS(ah, AR5K_TXCFG,
 				AR5K_TXCFG_TXFULL, trigger_level);
 
 	ret = 0;
@@ -1432,7 +1432,7 @@ done:
 	/*
 	 * Restore interrupt mask
 	 */
-	ath5k_hw_set_intr(hal, imr);
+	ath5k_hw_set_intr(ah, imr);
 
 	return ret;
 }
@@ -1444,16 +1444,16 @@ done:
 /*
  * Check if we have pending interrupts
  */
-bool ath5k_hw_is_intr_pending(struct ath_hw *hal)
+bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
-	return ath5k_hw_reg_read(hal, AR5K_INTPEND);
+	return ath5k_hw_reg_read(ah, AR5K_INTPEND);
 }
 
 /*
  * Get interrupt mask (ISR)
  */
-int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
+int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 {
 	u32 data;
 
@@ -1463,8 +1463,8 @@ int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
 	 * Read interrupt status from the Interrupt Status register
 	 * on 5210
 	 */
-	if (hal->ah_version == AR5K_AR5210) {
-		data = ath5k_hw_reg_read(hal, AR5K_ISR);
+	if (ah->ah_version == AR5K_AR5210) {
+		data = ath5k_hw_reg_read(ah, AR5K_ISR);
 		if (unlikely(data == AR5K_INT_NOCARD)) {
 			*interrupt_mask = data;
 			return -ENODEV;
@@ -1474,13 +1474,13 @@ int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
 		 * Read interrupt status from the Read-And-Clear shadow register
 		 * Note: PISR/SISR Not available on 5210
 		 */
-		data = ath5k_hw_reg_read(hal, AR5K_RAC_PISR);
+		data = ath5k_hw_reg_read(ah, AR5K_RAC_PISR);
 	}
 
 	/*
-	 * Get abstract interrupt mask (HAL-compatible)
+	 * Get abstract interrupt mask (driver-compatible)
 	 */
-	*interrupt_mask = (data & AR5K_INT_COMMON) & hal->ah_imr;
+	*interrupt_mask = (data & AR5K_INT_COMMON) & ah->ah_imr;
 
 	if (unlikely(data == AR5K_INT_NOCARD))
 		return -ENODEV;
@@ -1491,7 +1491,7 @@ int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
 	if (data & (AR5K_ISR_TXOK | AR5K_ISR_TXERR))
 		*interrupt_mask |= AR5K_INT_TX;
 
-	if (hal->ah_version != AR5K_AR5210) {
+	if (ah->ah_version != AR5K_AR5210) {
 		/*HIU = Host Interface Unit (PCI etc)*/
 		if (unlikely(data & (AR5K_ISR_HIUERR)))
 			*interrupt_mask |= AR5K_INT_FATAL;
@@ -1524,7 +1524,7 @@ int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask)
 /*
  * Set interrupt mask
  */
-enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask)
+enum ath5k_int ath5k_hw_set_intr(struct ath5k_hw *ah, enum ath5k_int new_mask)
 {
 	enum ath5k_int old_mask, int_mask;
 
@@ -1532,9 +1532,9 @@ enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask)
 	 * Disable card interrupts to prevent any race conditions
 	 * (they will be re-enabled afterwards).
 	 */
-	ath5k_hw_reg_write(hal, AR5K_IER_DISABLE, AR5K_IER);
+	ath5k_hw_reg_write(ah, AR5K_IER_DISABLE, AR5K_IER);
 
-	old_mask = hal->ah_imr;
+	old_mask = ah->ah_imr;
 
 	/*
 	 * Add additional, chipset-dependent interrupt mask flags
@@ -1550,21 +1550,21 @@ enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask)
 		int_mask |= AR5K_IMR_TXOK | AR5K_IMR_TXERR | AR5K_IMR_TXDESC |
 			AR5K_IMR_TXURN;
 
-	if (hal->ah_version != AR5K_AR5210) {
+	if (ah->ah_version != AR5K_AR5210) {
 		if (new_mask & AR5K_INT_FATAL) {
 			int_mask |= AR5K_IMR_HIUERR;
-			AR5K_REG_ENABLE_BITS(hal, AR5K_SIMR2, AR5K_SIMR2_MCABT |
+			AR5K_REG_ENABLE_BITS(ah, AR5K_SIMR2, AR5K_SIMR2_MCABT |
 					AR5K_SIMR2_SSERR | AR5K_SIMR2_DPERR);
 		}
 	}
 
-	ath5k_hw_reg_write(hal, int_mask, AR5K_PIMR);
+	ath5k_hw_reg_write(ah, int_mask, AR5K_PIMR);
 
 	/* Store new interrupt mask */
-	hal->ah_imr = new_mask;
+	ah->ah_imr = new_mask;
 
 	/* ..re-enable interrupts */
-	ath5k_hw_reg_write(hal, AR5K_IER_ENABLE, AR5K_IER);
+	ath5k_hw_reg_write(ah, AR5K_IER_ENABLE, AR5K_IER);
 
 	return old_mask;
 }
@@ -1577,7 +1577,7 @@ enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask)
 /*
  * Read from eeprom
  */
-static int ath5k_hw_eeprom_read(struct ath_hw *hal, u32 offset, u16 *data)
+static int ath5k_hw_eeprom_read(struct ath5k_hw *ah, u32 offset, u16 *data)
 {
 	u32 status, timeout;
 
@@ -1585,21 +1585,21 @@ static int ath5k_hw_eeprom_read(struct ath_hw *hal, u32 offset, u16 *data)
 	/*
 	 * Initialize EEPROM access
 	 */
-	if (hal->ah_version == AR5K_AR5210) {
-		AR5K_REG_ENABLE_BITS(hal, AR5K_PCICFG, AR5K_PCICFG_EEAE);
-		(void)ath5k_hw_reg_read(hal, AR5K_EEPROM_BASE + (4 * offset));
+	if (ah->ah_version == AR5K_AR5210) {
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, AR5K_PCICFG_EEAE);
+		(void)ath5k_hw_reg_read(ah, AR5K_EEPROM_BASE + (4 * offset));
 	} else {
-		ath5k_hw_reg_write(hal, offset, AR5K_EEPROM_BASE);
-		AR5K_REG_ENABLE_BITS(hal, AR5K_EEPROM_CMD,
+		ath5k_hw_reg_write(ah, offset, AR5K_EEPROM_BASE);
+		AR5K_REG_ENABLE_BITS(ah, AR5K_EEPROM_CMD,
 				AR5K_EEPROM_CMD_READ);
 	}
 
 	for (timeout = AR5K_TUNE_REGISTER_TIMEOUT; timeout > 0; timeout--) {
-		status = ath5k_hw_reg_read(hal, AR5K_EEPROM_STATUS);
+		status = ath5k_hw_reg_read(ah, AR5K_EEPROM_STATUS);
 		if (status & AR5K_EEPROM_STAT_RDDONE) {
 			if (status & AR5K_EEPROM_STAT_RDERR)
 				return -EIO;
-			*data = (u16)(ath5k_hw_reg_read(hal, AR5K_EEPROM_DATA) &
+			*data = (u16)(ath5k_hw_reg_read(ah, AR5K_EEPROM_DATA) &
 					0xffff);
 			return 0;
 		}
@@ -1612,7 +1612,7 @@ static int ath5k_hw_eeprom_read(struct ath_hw *hal, u32 offset, u16 *data)
 /*
  * Write to eeprom - currently disabled, use at your own risk
  */
-static int ath5k_hw_eeprom_write(struct ath_hw *hal, u32 offset, u16 data)
+static int ath5k_hw_eeprom_write(struct ath5k_hw *ah, u32 offset, u16 data)
 {
 #if 0
 	u32 status, timeout;
@@ -1623,10 +1623,10 @@ static int ath5k_hw_eeprom_write(struct ath_hw *hal, u32 offset, u16 data)
 	 * Initialize eeprom access
 	 */
 
-	if (hal->ah_version == AR5K_AR5210) {
-		AR5K_REG_ENABLE_BITS(hal, AR5K_PCICFG, AR5K_PCICFG_EEAE);
+	if (ah->ah_version == AR5K_AR5210) {
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, AR5K_PCICFG_EEAE);
 	} else {
-		AR5K_REG_ENABLE_BITS(hal, AR5K_EEPROM_CMD,
+		AR5K_REG_ENABLE_BITS(ah, AR5K_EEPROM_CMD,
 				AR5K_EEPROM_CMD_RESET);
 	}
 
@@ -1634,12 +1634,12 @@ static int ath5k_hw_eeprom_write(struct ath_hw *hal, u32 offset, u16 data)
 	 * Write data to data register
 	 */
 
-	if (hal->ah_version == AR5K_AR5210) {
-		ath5k_hw_reg_write(hal, data, AR5K_EEPROM_BASE + (4 * offset));
+	if (ah->ah_version == AR5K_AR5210) {
+		ath5k_hw_reg_write(ah, data, AR5K_EEPROM_BASE + (4 * offset));
 	} else {
-		ath5k_hw_reg_write(hal, offset, AR5K_EEPROM_BASE);
-		ath5k_hw_reg_write(hal, data, AR5K_EEPROM_DATA);
-		AR5K_REG_ENABLE_BITS(hal, AR5K_EEPROM_CMD,
+		ath5k_hw_reg_write(ah, offset, AR5K_EEPROM_BASE);
+		ath5k_hw_reg_write(ah, data, AR5K_EEPROM_DATA);
+		AR5K_REG_ENABLE_BITS(ah, AR5K_EEPROM_CMD,
 				AR5K_EEPROM_CMD_WRITE);
 	}
 
@@ -1648,7 +1648,7 @@ static int ath5k_hw_eeprom_write(struct ath_hw *hal, u32 offset, u16 data)
 	 */
 
 	for (timeout = AR5K_TUNE_REGISTER_TIMEOUT; timeout > 0; timeout--) {
-		status = ath5k_hw_reg_read(hal, AR5K_EEPROM_STATUS);
+		status = ath5k_hw_reg_read(ah, AR5K_EEPROM_STATUS);
 		if (status & AR5K_EEPROM_STAT_WRDONE) {
 			if (status & AR5K_EEPROM_STAT_WRERR)
 				return EIO;
@@ -1664,7 +1664,7 @@ static int ath5k_hw_eeprom_write(struct ath_hw *hal, u32 offset, u16 data)
 /*
  * Translate binary channel representation in EEPROM to frequency
  */
-static u16 ath5k_eeprom_bin2freq(struct ath_hw *hal, u16 bin, unsigned int mode)
+static u16 ath5k_eeprom_bin2freq(struct ath5k_hw *ah, u16 bin, unsigned int mode)
 {
 	u16 val;
 
@@ -1672,13 +1672,13 @@ static u16 ath5k_eeprom_bin2freq(struct ath_hw *hal, u16 bin, unsigned int mode)
 		return bin;
 
 	if (mode == AR5K_EEPROM_MODE_11A) {
-		if (hal->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
+		if (ah->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
 			val = (5 * bin) + 4800;
 		else
 			val = bin > 62 ? (10 * 62) + (5 * (bin - 62)) + 5100 :
 				(bin * 10) + 5100;
 	} else {
-		if (hal->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
+		if (ah->ah_ee_version > AR5K_EEPROM_VERSION_3_2)
 			val = bin + 2300;
 		else
 			val = bin + 2400;
@@ -1690,10 +1690,10 @@ static u16 ath5k_eeprom_bin2freq(struct ath_hw *hal, u16 bin, unsigned int mode)
 /*
  * Read antenna infos from eeprom
  */
-static int ath5k_eeprom_read_ants(struct ath_hw *hal, u32 *offset,
+static int ath5k_eeprom_read_ants(struct ath5k_hw *ah, u32 *offset,
 		unsigned int mode)
 {
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 o = *offset;
 	u16 val;
 	int ret, i = 0;
@@ -1725,15 +1725,15 @@ static int ath5k_eeprom_read_ants(struct ath_hw *hal, u32 *offset,
 	ee->ee_ant_control[mode][i++]	= val & 0x3f;
 
 	/* Get antenna modes */
-	hal->ah_antenna[mode][0] =
+	ah->ah_antenna[mode][0] =
 	    (ee->ee_ant_control[mode][0] << 4) | 0x1;
-	hal->ah_antenna[mode][AR5K_ANT_FIXED_A] =
+	ah->ah_antenna[mode][AR5K_ANT_FIXED_A] =
 	     ee->ee_ant_control[mode][1] 	|
 	    (ee->ee_ant_control[mode][2] << 6) 	|
 	    (ee->ee_ant_control[mode][3] << 12) |
 	    (ee->ee_ant_control[mode][4] << 18) |
 	    (ee->ee_ant_control[mode][5] << 24);
-	hal->ah_antenna[mode][AR5K_ANT_FIXED_B] =
+	ah->ah_antenna[mode][AR5K_ANT_FIXED_B] =
 	     ee->ee_ant_control[mode][6] 	|
 	    (ee->ee_ant_control[mode][7] << 6) 	|
 	    (ee->ee_ant_control[mode][8] << 12) |
@@ -1749,10 +1749,10 @@ static int ath5k_eeprom_read_ants(struct ath_hw *hal, u32 *offset,
 /*
  * Read supported modes from eeprom
  */
-static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
+static int ath5k_eeprom_read_modes(struct ath5k_hw *ah, u32 *offset,
 		unsigned int mode)
 {
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 o = *offset;
 	u16 val;
 	int ret;
@@ -1761,7 +1761,7 @@ static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
 	ee->ee_tx_end2xlna_enable[mode]	= (val >> 8) & 0xff;
 	ee->ee_thr_62[mode]		= val & 0xff;
 
-	if (hal->ah_ee_version <= AR5K_EEPROM_VERSION_3_2)
+	if (ah->ah_ee_version <= AR5K_EEPROM_VERSION_3_2)
 		ee->ee_thr_62[mode] = mode == AR5K_EEPROM_MODE_11A ? 15 : 28;
 
 	AR5K_EEPROM_READ(o++, val);
@@ -1776,7 +1776,7 @@ static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
 	else
 		ee->ee_noise_floor_thr[mode] = val & 0xff;
 
-	if (hal->ah_ee_version <= AR5K_EEPROM_VERSION_3_2)
+	if (ah->ah_ee_version <= AR5K_EEPROM_VERSION_3_2)
 		ee->ee_noise_floor_thr[mode] =
 		    mode == AR5K_EEPROM_MODE_11A ? -54 : -1;
 
@@ -1785,10 +1785,10 @@ static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
 	ee->ee_x_gain[mode]		= (val >> 1) & 0xf;
 	ee->ee_xpd[mode]		= val & 0x1;
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_0)
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0)
 		ee->ee_fixed_bias[mode] = (val >> 13) & 0x1;
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_3_3) {
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_3_3) {
 		AR5K_EEPROM_READ(o++, val);
 		ee->ee_false_detect[mode] = (val >> 6) & 0x7f;
 
@@ -1800,7 +1800,7 @@ static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
 		}
 	}
 
-	if (hal->ah_ee_version < AR5K_EEPROM_VERSION_3_4) {
+	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_4) {
 		ee->ee_i_gain[mode] = AR5K_EEPROM_I_GAIN;
 		ee->ee_cck_ofdm_power_delta = AR5K_EEPROM_CCK_OFDM_DELTA;
 	} else {
@@ -1813,13 +1813,13 @@ static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
 			ee->ee_cck_ofdm_power_delta = (val >> 3) & 0xff;
 	}
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_0 &&
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0 &&
 			mode == AR5K_EEPROM_MODE_11A) {
 		ee->ee_i_cal[mode] = (val >> 8) & 0x3f;
 		ee->ee_q_cal[mode] = (val >> 3) & 0x1f;
 	}
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_6 &&
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_6 &&
 	    mode == AR5K_EEPROM_MODE_11G)
 		ee->ee_scaled_cck_delta = (val >> 11) & 0x1f;
 
@@ -1832,9 +1832,9 @@ static int ath5k_eeprom_read_modes(struct ath_hw *hal, u32 *offset,
 /*
  * Initialize eeprom & capabilities structs
  */
-static int ath5k_eeprom_init(struct ath_hw *hal)
+static int ath5k_eeprom_init(struct ath5k_hw *ah)
 {
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	unsigned int mode, i;
 	int ret;
 	u32 offset;
@@ -1855,7 +1855,7 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_HDR, ee_header);
 
 	/* Return if we have an old EEPROM */
-	if (hal->ah_ee_version < AR5K_EEPROM_VERSION_3_0)
+	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_0)
 		return 0;
 
 #ifdef notyet
@@ -1873,15 +1873,15 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	}
 #endif
 
-	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_ANT_GAIN(hal->ah_ee_version),
+	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_ANT_GAIN(ah->ah_ee_version),
 	    ee_ant_gain);
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
 		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC0, ee_misc0);
 		AR5K_EEPROM_READ_HDR(AR5K_EEPROM_MISC1, ee_misc1);
 	}
 
-	if (hal->ah_ee_version < AR5K_EEPROM_VERSION_3_3) {
+	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_3) {
 		AR5K_EEPROM_READ(AR5K_EEPROM_OBDB0_2GHZ, val);
 		ee->ee_ob[AR5K_EEPROM_MODE_11B][0] = val & 0x7;
 		ee->ee_db[AR5K_EEPROM_MODE_11B][0] = (val >> 3) & 0x7;
@@ -1894,8 +1894,8 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	/*
 	 * Get conformance test limit values
 	 */
-	offset = AR5K_EEPROM_CTL(hal->ah_ee_version);
-	ee->ee_ctls = AR5K_EEPROM_N_CTLS(hal->ah_ee_version);
+	offset = AR5K_EEPROM_CTL(ah->ah_ee_version);
+	ee->ee_ctls = AR5K_EEPROM_N_CTLS(ah->ah_ee_version);
 
 	for (i = 0; i < ee->ee_ctls; i++) {
 		AR5K_EEPROM_READ(offset++, val);
@@ -1911,9 +1911,9 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	ee->ee_turbo_max_power[mode] =
 			AR5K_EEPROM_HDR_T_5GHZ_DBM(ee->ee_header);
 
-	offset = AR5K_EEPROM_MODES_11A(hal->ah_ee_version);
+	offset = AR5K_EEPROM_MODES_11A(ah->ah_ee_version);
 
-	ret = ath5k_eeprom_read_ants(hal, &offset, mode);
+	ret = ath5k_eeprom_read_ants(ah, &offset, mode);
 	if (ret)
 		return ret;
 
@@ -1931,11 +1931,11 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	ee->ee_ob[mode][0]		= (val >> 3) & 0x7;
 	ee->ee_db[mode][0]		= val & 0x7;
 
-	ret = ath5k_eeprom_read_modes(hal, &offset, mode);
+	ret = ath5k_eeprom_read_modes(ah, &offset, mode);
 	if (ret)
 		return ret;
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_1) {
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1) {
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_margin_tx_rx[mode] = val & 0x3f;
 	}
@@ -1944,9 +1944,9 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	 * Get values for 802.11b (2.4GHz)
 	 */
 	mode = AR5K_EEPROM_MODE_11B;
-	offset = AR5K_EEPROM_MODES_11B(hal->ah_ee_version);
+	offset = AR5K_EEPROM_MODES_11B(ah->ah_ee_version);
 
-	ret = ath5k_eeprom_read_ants(hal, &offset, mode);
+	ret = ath5k_eeprom_read_ants(ah, &offset, mode);
 	if (ret)
 		return ret;
 
@@ -1955,32 +1955,32 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	ee->ee_ob[mode][1]		= (val >> 4) & 0x7;
 	ee->ee_db[mode][1]		= val & 0x7;
 
-	ret = ath5k_eeprom_read_modes(hal, &offset, mode);
+	ret = ath5k_eeprom_read_modes(ah, &offset, mode);
 	if (ret)
 		return ret;
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_cal_pier[mode][0] =
-			ath5k_eeprom_bin2freq(hal, val & 0xff, mode);
+			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
 		ee->ee_cal_pier[mode][1] =
-			ath5k_eeprom_bin2freq(hal, (val >> 8) & 0xff, mode);
+			ath5k_eeprom_bin2freq(ah, (val >> 8) & 0xff, mode);
 
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_cal_pier[mode][2] =
-			ath5k_eeprom_bin2freq(hal, val & 0xff, mode);
+			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
 	}
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
 		ee->ee_margin_tx_rx[mode] = (val >> 8) & 0x3f;
 
 	/*
 	 * Get values for 802.11g (2.4GHz)
 	 */
 	mode = AR5K_EEPROM_MODE_11G;
-	offset = AR5K_EEPROM_MODES_11G(hal->ah_ee_version);
+	offset = AR5K_EEPROM_MODES_11G(ah->ah_ee_version);
 
-	ret = ath5k_eeprom_read_ants(hal, &offset, mode);
+	ret = ath5k_eeprom_read_ants(ah, &offset, mode);
 	if (ret)
 		return ret;
 
@@ -1989,16 +1989,16 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 	ee->ee_ob[mode][1]		= (val >> 4) & 0x7;
 	ee->ee_db[mode][1]		= val & 0x7;
 
-	ret = ath5k_eeprom_read_modes(hal, &offset, mode);
+	ret = ath5k_eeprom_read_modes(ah, &offset, mode);
 	if (ret)
 		return ret;
 
-	if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0) {
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_cal_pier[mode][0] =
-			ath5k_eeprom_bin2freq(hal, val & 0xff, mode);
+			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
 		ee->ee_cal_pier[mode][1] =
-			ath5k_eeprom_bin2freq(hal, (val >> 8) & 0xff, mode);
+			ath5k_eeprom_bin2freq(ah, (val >> 8) & 0xff, mode);
 
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_turbo_max_power[mode] = val & 0x7f;
@@ -2006,16 +2006,16 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_cal_pier[mode][2] =
-			ath5k_eeprom_bin2freq(hal, val & 0xff, mode);
+			ath5k_eeprom_bin2freq(ah, val & 0xff, mode);
 
-		if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
+		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
 			ee->ee_margin_tx_rx[mode] = (val >> 8) & 0x3f;
 
 		AR5K_EEPROM_READ(offset++, val);
 		ee->ee_i_cal[mode] = (val >> 8) & 0x3f;
 		ee->ee_q_cal[mode] = (val >> 3) & 0x1f;
 
-		if (hal->ah_ee_version >= AR5K_EEPROM_VERSION_4_2) {
+		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_2) {
 			AR5K_EEPROM_READ(offset++, val);
 			ee->ee_cck_ofdm_gain_delta = val & 0xff;
 		}
@@ -2031,7 +2031,7 @@ static int ath5k_eeprom_init(struct ath_hw *hal)
 /*
  * Read the MAC address from eeprom
  */
-static int ath5k_eeprom_read_mac(struct ath_hw *hal, u8 *mac)
+static int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
 {
 	u8 mac_d[ETH_ALEN];
 	u32 total, offset;
@@ -2041,12 +2041,12 @@ static int ath5k_eeprom_read_mac(struct ath_hw *hal, u8 *mac)
 	memset(mac, 0, ETH_ALEN);
 	memset(mac_d, 0, ETH_ALEN);
 
-	ret = ath5k_hw_eeprom_read(hal, 0x20, &data);
+	ret = ath5k_hw_eeprom_read(ah, 0x20, &data);
 	if (ret)
 		return ret;
 
 	for (offset = 0x1f, octet = 0, total = 0; offset >= 0x1d; offset--) {
-		ret = ath5k_hw_eeprom_read(hal, offset, &data);
+		ret = ath5k_hw_eeprom_read(ah, offset, &data);
 		if (ret)
 			return ret;
 
@@ -2067,14 +2067,14 @@ static int ath5k_eeprom_read_mac(struct ath_hw *hal, u8 *mac)
 /*
  * Read/Write regulatory domain
  */
-static bool ath5k_eeprom_regulation_domain(struct ath_hw *hal, bool write,
+static bool ath5k_eeprom_regulation_domain(struct ath5k_hw *ah, bool write,
 	enum ath5k_regdom *regdomain)
 {
 	u16 ee_regdomain;
 
 	/* Read current value */
 	if (write != true) {
-		ee_regdomain = hal->ah_capabilities.cap_eeprom.ee_regdomain;
+		ee_regdomain = ah->ah_capabilities.cap_eeprom.ee_regdomain;
 		*regdomain = ath5k_regdom_to_ieee(ee_regdomain);
 		return true;
 	}
@@ -2082,13 +2082,13 @@ static bool ath5k_eeprom_regulation_domain(struct ath_hw *hal, bool write,
 	ee_regdomain = ath5k_regdom_from_ieee(*regdomain);
 
 	/* Try to write a new value */
-	if (hal->ah_capabilities.cap_eeprom.ee_protect &
+	if (ah->ah_capabilities.cap_eeprom.ee_protect &
 			AR5K_EEPROM_PROTECT_WR_128_191)
 		return false;
-	if (ath5k_hw_eeprom_write(hal, AR5K_EEPROM_REG_DOMAIN, ee_regdomain)!=0)
+	if (ath5k_hw_eeprom_write(ah, AR5K_EEPROM_REG_DOMAIN, ee_regdomain)!=0)
 		return false;
 
-	hal->ah_capabilities.cap_eeprom.ee_regdomain = ee_regdomain;
+	ah->ah_capabilities.cap_eeprom.ee_regdomain = ee_regdomain;
 
 	return true;
 }
@@ -2096,13 +2096,13 @@ static bool ath5k_eeprom_regulation_domain(struct ath_hw *hal, bool write,
 /*
  * Use the above to write a new regulatory domain
  */
-int ath5k_hw_set_regdomain(struct ath_hw *hal, u16 regdomain)
+int ath5k_hw_set_regdomain(struct ath5k_hw *ah, u16 regdomain)
 {
 	enum ath5k_regdom ieee_regdomain;
 
 	ieee_regdomain = ath5k_regdom_to_ieee(regdomain);
 
-	if (ath5k_eeprom_regulation_domain(hal, true, &ieee_regdomain) == true)
+	if (ath5k_eeprom_regulation_domain(ah, true, &ieee_regdomain) == true)
 		return 0;
 
 	return -EIO;
@@ -2111,27 +2111,27 @@ int ath5k_hw_set_regdomain(struct ath_hw *hal, u16 regdomain)
 /*
  * Fill the capabilities struct
  */
-static int ath5k_hw_get_capabilities(struct ath_hw *hal)
+static int ath5k_hw_get_capabilities(struct ath5k_hw *ah)
 {
 	u16 ee_header;
 
 	AR5K_TRACE;
 	/* Capabilities stored in the EEPROM */
-	ee_header = hal->ah_capabilities.cap_eeprom.ee_header;
+	ee_header = ah->ah_capabilities.cap_eeprom.ee_header;
 
-	if (hal->ah_version == AR5K_AR5210) {
+	if (ah->ah_version == AR5K_AR5210) {
 		/*
 		 * Set radio capabilities
 		 * (The AR5110 only supports the middle 5GHz band)
 		 */
-		hal->ah_capabilities.cap_range.range_5ghz_min = 5120;
-		hal->ah_capabilities.cap_range.range_5ghz_max = 5430;
-		hal->ah_capabilities.cap_range.range_2ghz_min = 0;
-		hal->ah_capabilities.cap_range.range_2ghz_max = 0;
+		ah->ah_capabilities.cap_range.range_5ghz_min = 5120;
+		ah->ah_capabilities.cap_range.range_5ghz_max = 5430;
+		ah->ah_capabilities.cap_range.range_2ghz_min = 0;
+		ah->ah_capabilities.cap_range.range_2ghz_max = 0;
 
 		/* Set supported modes */
-		__set_bit(MODE_IEEE80211A, hal->ah_capabilities.cap_mode);
-		__set_bit(MODE_ATHEROS_TURBO, hal->ah_capabilities.cap_mode);
+		__set_bit(MODE_IEEE80211A, ah->ah_capabilities.cap_mode);
+		__set_bit(MODE_ATHEROS_TURBO, ah->ah_capabilities.cap_mode);
 	} else {
 		/*
 		 * XXX The tranceiver supports frequencies from 4920 to 6100GHz
@@ -2149,45 +2149,45 @@ static int ath5k_hw_get_capabilities(struct ath_hw *hal)
 		 */
 
 		if (AR5K_EEPROM_HDR_11A(ee_header)) {
-			hal->ah_capabilities.cap_range.range_5ghz_min = 5005; /* 4920 */
-			hal->ah_capabilities.cap_range.range_5ghz_max = 6100;
+			ah->ah_capabilities.cap_range.range_5ghz_min = 5005; /* 4920 */
+			ah->ah_capabilities.cap_range.range_5ghz_max = 6100;
 
 			/* Set supported modes */
 			__set_bit(MODE_IEEE80211A,
-					hal->ah_capabilities.cap_mode);
+					ah->ah_capabilities.cap_mode);
 			__set_bit(MODE_ATHEROS_TURBO,
-					hal->ah_capabilities.cap_mode);
-			if (hal->ah_version == AR5K_AR5212)
+					ah->ah_capabilities.cap_mode);
+			if (ah->ah_version == AR5K_AR5212)
 				__set_bit(MODE_ATHEROS_TURBOG,
-						hal->ah_capabilities.cap_mode);
+						ah->ah_capabilities.cap_mode);
 		}
 
 		/* Enable  802.11b if a 2GHz capable radio (2111/5112) is
 		 * connected */
 		if (AR5K_EEPROM_HDR_11B(ee_header) ||
 				AR5K_EEPROM_HDR_11G(ee_header)) {
-			hal->ah_capabilities.cap_range.range_2ghz_min = 2412; /* 2312 */
-			hal->ah_capabilities.cap_range.range_2ghz_max = 2732;
+			ah->ah_capabilities.cap_range.range_2ghz_min = 2412; /* 2312 */
+			ah->ah_capabilities.cap_range.range_2ghz_max = 2732;
 
 			if (AR5K_EEPROM_HDR_11B(ee_header))
 				__set_bit(MODE_IEEE80211B,
-						hal->ah_capabilities.cap_mode);
+						ah->ah_capabilities.cap_mode);
 
 			if (AR5K_EEPROM_HDR_11G(ee_header))
 				__set_bit(MODE_IEEE80211G,
-						hal->ah_capabilities.cap_mode);
+						ah->ah_capabilities.cap_mode);
 		}
 	}
 
 	/* GPIO */
-	hal->ah_gpio_npins = AR5K_NUM_GPIO;
+	ah->ah_gpio_npins = AR5K_NUM_GPIO;
 
 	/* Set number of supported TX queues */
-	if (hal->ah_version == AR5K_AR5210)
-		hal->ah_capabilities.cap_queues.q_tx_num =
+	if (ah->ah_version == AR5K_AR5210)
+		ah->ah_capabilities.cap_queues.q_tx_num =
 			AR5K_NUM_TX_QUEUES_NOQCU;
 	else
-		hal->ah_capabilities.cap_queues.q_tx_num = AR5K_NUM_TX_QUEUES;
+		ah->ah_capabilities.cap_queues.q_tx_num = AR5K_NUM_TX_QUEUES;
 
 	return 0;
 }
@@ -2199,7 +2199,7 @@ static int ath5k_hw_get_capabilities(struct ath_hw *hal)
 /*
  * Set Operation mode
  */
-int ath5k_hw_set_opmode(struct ath_hw *hal)
+int ath5k_hw_set_opmode(struct ath5k_hw *ah)
 {
 	u32 pcu_reg, beacon_reg, low_id, high_id;
 
@@ -2208,28 +2208,28 @@ int ath5k_hw_set_opmode(struct ath_hw *hal)
 
 	AR5K_TRACE;
 
-	switch (hal->ah_op_mode) {
+	switch (ah->ah_op_mode) {
 	case IEEE80211_IF_TYPE_IBSS:
 		pcu_reg |= AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_DESC_ANTENNA |
-			(hal->ah_version == AR5K_AR5210 ?
+			(ah->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_NO_PSPOLL : 0);
 		beacon_reg |= AR5K_BCR_ADHOC;
 		break;
 
 	case IEEE80211_IF_TYPE_AP:
 		pcu_reg |= AR5K_STA_ID1_AP | AR5K_STA_ID1_RTS_DEF_ANTENNA |
-			(hal->ah_version == AR5K_AR5210 ?
+			(ah->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_NO_PSPOLL : 0);
 		beacon_reg |= AR5K_BCR_AP;
 		break;
 
 	case IEEE80211_IF_TYPE_STA:
 		pcu_reg |= AR5K_STA_ID1_DEFAULT_ANTENNA |
-			(hal->ah_version == AR5K_AR5210 ?
+			(ah->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_PWR_SV : 0);
 	case IEEE80211_IF_TYPE_MNTR:
 		pcu_reg |= AR5K_STA_ID1_DEFAULT_ANTENNA |
-			(hal->ah_version == AR5K_AR5210 ?
+			(ah->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_NO_PSPOLL : 0);
 		break;
 
@@ -2240,16 +2240,16 @@ int ath5k_hw_set_opmode(struct ath_hw *hal)
 	/*
 	 * Set PCU registers
 	 */
-	low_id = AR5K_LOW_ID(hal->ah_sta_id);
-	high_id = AR5K_HIGH_ID(hal->ah_sta_id);
-	ath5k_hw_reg_write(hal, low_id, AR5K_STA_ID0);
-	ath5k_hw_reg_write(hal, pcu_reg | high_id, AR5K_STA_ID1);
+	low_id = AR5K_LOW_ID(ah->ah_sta_id);
+	high_id = AR5K_HIGH_ID(ah->ah_sta_id);
+	ath5k_hw_reg_write(ah, low_id, AR5K_STA_ID0);
+	ath5k_hw_reg_write(ah, pcu_reg | high_id, AR5K_STA_ID1);
 
 	/*
 	 * Set Beacon Control Register on 5210
 	 */
-	if (hal->ah_version == AR5K_AR5210)
-		ath5k_hw_reg_write(hal, beacon_reg, AR5K_BCR);
+	if (ah->ah_version == AR5K_AR5210)
+		ath5k_hw_reg_write(ah, beacon_reg, AR5K_BCR);
 
 	return 0;
 }
@@ -2261,28 +2261,28 @@ int ath5k_hw_set_opmode(struct ath_hw *hal)
 /*
  * Get station id
  */
-void ath5k_hw_get_lladdr(struct ath_hw *hal, u8 *mac)
+void ath5k_hw_get_lladdr(struct ath5k_hw *ah, u8 *mac)
 {
 	AR5K_TRACE;
-	memcpy(mac, hal->ah_sta_id, ETH_ALEN);
+	memcpy(mac, ah->ah_sta_id, ETH_ALEN);
 }
 
 /*
  * Set station id
  */
-int ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac)
+int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
 {
 	u32 low_id, high_id;
 
 	AR5K_TRACE;
 	/* Set new station ID */
-	memcpy(hal->ah_sta_id, mac, ETH_ALEN);
+	memcpy(ah->ah_sta_id, mac, ETH_ALEN);
 
 	low_id = AR5K_LOW_ID(mac);
 	high_id = AR5K_HIGH_ID(mac);
 
-	ath5k_hw_reg_write(hal, low_id, AR5K_STA_ID0);
-	ath5k_hw_reg_write(hal, high_id, AR5K_STA_ID1);
+	ath5k_hw_reg_write(ah, low_id, AR5K_STA_ID0);
+	ath5k_hw_reg_write(ah, high_id, AR5K_STA_ID1);
 
 	return 0;
 }
@@ -2290,7 +2290,7 @@ int ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac)
 /*
  * Set BSSID
  */
-void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
+void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 {
 	u32 low_id, high_id;
 	u16 tim_offset = 0;
@@ -2298,9 +2298,9 @@ void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
 	/*
 	 * Set simple BSSID mask on 5212
 	 */
-	if (hal->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(hal, 0xfffffff, AR5K_BSS_IDM0);
-		ath5k_hw_reg_write(hal, 0xfffffff, AR5K_BSS_IDM1);
+	if (ah->ah_version == AR5K_AR5212) {
+		ath5k_hw_reg_write(ah, 0xfffffff, AR5K_BSS_IDM0);
+		ath5k_hw_reg_write(ah, 0xfffffff, AR5K_BSS_IDM1);
 	}
 
 	/*
@@ -2308,20 +2308,20 @@ void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
 	 */
 	low_id = AR5K_LOW_ID(bssid);
 	high_id = AR5K_HIGH_ID(bssid);
-	ath5k_hw_reg_write(hal, low_id, AR5K_BSS_ID0);
-	ath5k_hw_reg_write(hal, high_id | ((assoc_id & 0x3fff) <<
+	ath5k_hw_reg_write(ah, low_id, AR5K_BSS_ID0);
+	ath5k_hw_reg_write(ah, high_id | ((assoc_id & 0x3fff) <<
 				AR5K_BSS_ID1_AID_S), AR5K_BSS_ID1);
-	memcpy(&hal->ah_bssid, bssid, ETH_ALEN);
+	memcpy(&ah->ah_bssid, bssid, ETH_ALEN);
 
 	if (assoc_id == 0) {
-		ath5k_hw_disable_pspoll(hal);
+		ath5k_hw_disable_pspoll(ah);
 		return;
 	}
 
-	AR5K_REG_WRITE_BITS(hal, AR5K_BEACON, AR5K_BEACON_TIM,
+	AR5K_REG_WRITE_BITS(ah, AR5K_BEACON, AR5K_BEACON_TIM,
 			tim_offset ? tim_offset + 4 : 0);
 
-	ath5k_hw_enable_pspoll(hal, NULL, 0);
+	ath5k_hw_enable_pspoll(ah, NULL, 0);
 }
 /**
  * ath5k_hw_set_bssid_mask - set common bits we should listen to
@@ -2332,7 +2332,7 @@ void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
  * mode with a single BSS every bit matters as well. In AP mode with
  * multiple BSSes not every bit matters.
  *
- * @hal: the &struct ath_hw
+ * @ah: the &struct ath5k_hw
  * @mask: the bssid_mask, a u8 array of size ETH_ALEN
  *
  * Note that this is a simple filter and *does* not filter out all
@@ -2417,17 +2417,17 @@ void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
  * IFRAME-05:  1101 --> allowed but its not for us!!!
  *
  */
-int ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask)
+int ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
 {
 	u32 low_id, high_id;
 	AR5K_TRACE;
 
-	if (hal->ah_version == AR5K_AR5212) {
+	if (ah->ah_version == AR5K_AR5212) {
 		low_id = AR5K_LOW_ID(mask);
 		high_id = AR5K_HIGH_ID(mask);
 
-		ath5k_hw_reg_write(hal, low_id, AR5K_BSS_IDM0);
-		ath5k_hw_reg_write(hal, high_id, AR5K_BSS_IDM1);
+		ath5k_hw_reg_write(ah, low_id, AR5K_BSS_IDM0);
+		ath5k_hw_reg_write(ah, high_id, AR5K_BSS_IDM1);
 
 		return 0;
 	}
@@ -2442,19 +2442,19 @@ int ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask)
 /*
  * Start receive on PCU
  */
-void ath5k_hw_start_rx_pcu(struct ath_hw *hal)
+void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
-	AR5K_REG_DISABLE_BITS(hal, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
+	AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
 }
 
 /*
  * Stop receive on PCU
  */
-void ath5k_hw_stop_pcu_recv(struct ath_hw *hal)
+void ath5k_hw_stop_pcu_recv(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
-	AR5K_REG_ENABLE_BITS(hal, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
 }
 
 /*
@@ -2464,28 +2464,28 @@ void ath5k_hw_stop_pcu_recv(struct ath_hw *hal)
 /*
  * Set multicast filter
  */
-void ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1)
+void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1)
 {
 	AR5K_TRACE;
 	/* Set the multicat filter */
-	ath5k_hw_reg_write(hal, filter0, AR5K_MCAST_FILTER0);
-	ath5k_hw_reg_write(hal, filter1, AR5K_MCAST_FILTER1);
+	ath5k_hw_reg_write(ah, filter0, AR5K_MCAST_FILTER0);
+	ath5k_hw_reg_write(ah, filter1, AR5K_MCAST_FILTER1);
 }
 
 /*
  * Set multicast filter by index
  */
-int ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index)
+int ath5k_hw_set_mcast_filterindex(struct ath5k_hw *ah, u32 index)
 {
 
 	AR5K_TRACE;
 	if (index >= 64)
 		return -EINVAL;
 	else if (index >= 32)
-		AR5K_REG_ENABLE_BITS(hal, AR5K_MCAST_FILTER1,
+		AR5K_REG_ENABLE_BITS(ah, AR5K_MCAST_FILTER1,
 				(1 << (index - 32)));
 	else
-		AR5K_REG_ENABLE_BITS(hal, AR5K_MCAST_FILTER0, (1 << index));
+		AR5K_REG_ENABLE_BITS(ah, AR5K_MCAST_FILTER0, (1 << index));
 
 	return 0;
 }
@@ -2493,17 +2493,17 @@ int ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index)
 /*
  * Clear Multicast filter by index
  */
-int ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index)
+int ath5k_hw_clear_mcast_filter_idx(struct ath5k_hw *ah, u32 index)
 {
 
 	AR5K_TRACE;
 	if (index >= 64)
 		return -EINVAL;
 	else if (index >= 32)
-		AR5K_REG_DISABLE_BITS(hal, AR5K_MCAST_FILTER1,
+		AR5K_REG_DISABLE_BITS(ah, AR5K_MCAST_FILTER1,
 				(1 << (index - 32)));
 	else
-		AR5K_REG_DISABLE_BITS(hal, AR5K_MCAST_FILTER0, (1 << index));
+		AR5K_REG_DISABLE_BITS(ah, AR5K_MCAST_FILTER0, (1 << index));
 
 	return 0;
 }
@@ -2511,7 +2511,7 @@ int ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index)
 /*
  * Get current rx filter
  */
-u32 ath5k_hw_get_rx_filter(struct ath_hw *ah)
+u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah)
 {
 	u32 data, filter = 0;
 
@@ -2534,7 +2534,7 @@ u32 ath5k_hw_get_rx_filter(struct ath_hw *ah)
 /*
  * Set rx filter
  */
-void ath5k_hw_set_rx_filter(struct ath_hw *ah, u32 filter)
+void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter)
 {
 	u32 data = 0;
 
@@ -2579,36 +2579,36 @@ void ath5k_hw_set_rx_filter(struct ath_hw *ah, u32 filter)
 /*
  * Get a 32bit TSF
  */
-u32 ath5k_hw_get_tsf32(struct ath_hw *hal)
+u32 ath5k_hw_get_tsf32(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
-	return ath5k_hw_reg_read(hal, AR5K_TSF_L32);
+	return ath5k_hw_reg_read(ah, AR5K_TSF_L32);
 }
 
 /*
  * Get the full 64bit TSF
  */
-u64 ath5k_hw_get_tsf64(struct ath_hw *hal)
+u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
 {
-	u64 tsf = ath5k_hw_reg_read(hal, AR5K_TSF_U32);
+	u64 tsf = ath5k_hw_reg_read(ah, AR5K_TSF_U32);
 	AR5K_TRACE;
 
-	return ath5k_hw_reg_read(hal, AR5K_TSF_L32) | (tsf << 32);
+	return ath5k_hw_reg_read(ah, AR5K_TSF_L32) | (tsf << 32);
 }
 
 /*
  * Force a TSF reset
  */
-void ath5k_hw_reset_tsf(struct ath_hw *hal)
+void ath5k_hw_reset_tsf(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
-	AR5K_REG_ENABLE_BITS(hal, AR5K_BEACON, AR5K_BEACON_RESET_TSF);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_RESET_TSF);
 }
 
 /*
  * Initialize beacon timers
  */
-void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval)
+void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 {
 	u32 timer1, timer2, timer3;
 
@@ -2616,9 +2616,9 @@ void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval)
 	/*
 	 * Set the additional timers by mode
 	 */
-	switch (hal->ah_op_mode) {
+	switch (ah->ah_op_mode) {
 	case IEEE80211_IF_TYPE_STA:
-		if (hal->ah_version == AR5K_AR5210) {
+		if (ah->ah_version == AR5K_AR5210) {
 			timer1 = 0xffffffff;
 			timer2 = 0xffffffff;
 		} else {
@@ -2634,18 +2634,18 @@ void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval)
 		    0x00000003;
 	}
 
-	timer3 = next_beacon + (hal->ah_atim_window ? hal->ah_atim_window : 1);
+	timer3 = next_beacon + (ah->ah_atim_window ? ah->ah_atim_window : 1);
 
 	/*
 	 * Set the beacon register and enable all timers.
 	 * (next beacon, DMA beacon, software beacon, ATIM window time)
 	 */
-	ath5k_hw_reg_write(hal, next_beacon, AR5K_TIMER0);
-	ath5k_hw_reg_write(hal, timer1, AR5K_TIMER1);
-	ath5k_hw_reg_write(hal, timer2, AR5K_TIMER2);
-	ath5k_hw_reg_write(hal, timer3, AR5K_TIMER3);
+	ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
+	ath5k_hw_reg_write(ah, timer1, AR5K_TIMER1);
+	ath5k_hw_reg_write(ah, timer2, AR5K_TIMER2);
+	ath5k_hw_reg_write(ah, timer3, AR5K_TIMER3);
 
-	ath5k_hw_reg_write(hal, interval & (AR5K_BEACON_PERIOD |
+	ath5k_hw_reg_write(ah, interval & (AR5K_BEACON_PERIOD |
 			AR5K_BEACON_RESET_TSF | AR5K_BEACON_ENABLE),
 		AR5K_BEACON);
 }
@@ -2653,7 +2653,7 @@ void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval)
 /*
  * Set beacon timers
  */
-int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
+int ath5k_hw_set_beacon_timers(struct ath5k_hw *ah,
 		const struct ath5k_beacon_state *state)
 {
 	u32 cfp_period, next_cfp, dtim, interval, next_beacon;
@@ -2691,17 +2691,17 @@ int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 		next_cfp = (cfp_count * state->bs_dtim_period + dtim_count) *
 			state->bs_interval;
 
-		AR5K_REG_ENABLE_BITS(hal, AR5K_STA_ID1,
+		AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1,
 				AR5K_STA_ID1_DEFAULT_ANTENNA |
 				AR5K_STA_ID1_PCF);
-		ath5k_hw_reg_write(hal, cfp_period, AR5K_CFP_PERIOD);
-		ath5k_hw_reg_write(hal, state->bs_cfp_max_duration,
+		ath5k_hw_reg_write(ah, cfp_period, AR5K_CFP_PERIOD);
+		ath5k_hw_reg_write(ah, state->bs_cfp_max_duration,
 				AR5K_CFP_DUR);
-		ath5k_hw_reg_write(hal, (tsf + (next_cfp == 0 ? cfp_period :
+		ath5k_hw_reg_write(ah, (tsf + (next_cfp == 0 ? cfp_period :
 						next_cfp)) << 3, AR5K_TIMER2);
 	} else {
 		/* Disable PCF mode */
-		AR5K_REG_DISABLE_BITS(hal, AR5K_STA_ID1,
+		AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
 				AR5K_STA_ID1_DEFAULT_ANTENNA |
 				AR5K_STA_ID1_PCF);
 	}
@@ -2709,12 +2709,12 @@ int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 	/*
 	 * Enable the beacon timer register
 	 */
-	ath5k_hw_reg_write(hal, state->bs_next_beacon, AR5K_TIMER0);
+	ath5k_hw_reg_write(ah, state->bs_next_beacon, AR5K_TIMER0);
 
 	/*
 	 * Start the beacon timers
 	 */
-	ath5k_hw_reg_write(hal, (ath5k_hw_reg_read(hal, AR5K_BEACON) &~
+	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, AR5K_BEACON) &~
 		(AR5K_BEACON_PERIOD | AR5K_BEACON_TIM)) |
 		AR5K_REG_SM(state->bs_tim_offset ? state->bs_tim_offset + 4 : 0,
 		AR5K_BEACON_TIM) | AR5K_REG_SM(state->bs_interval,
@@ -2727,7 +2727,7 @@ int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 	 * setting value to a largest value and seeing which values register.
 	 */
 
-	AR5K_REG_WRITE_BITS(hal, AR5K_RSSI_THR, AR5K_RSSI_THR_BMISS,
+	AR5K_REG_WRITE_BITS(ah, AR5K_RSSI_THR, AR5K_RSSI_THR_BMISS,
 			state->bs_bmiss_threshold);
 
 	/*
@@ -2735,13 +2735,13 @@ int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 	 * XXX: Didn't find this in 5210 code but since this register
 	 * exists also in ar5k's 5210 headers i leave it as common code.
 	 */
-	AR5K_REG_WRITE_BITS(hal, AR5K_SLEEP_CTL, AR5K_SLEEP_CTL_SLDUR,
+	AR5K_REG_WRITE_BITS(ah, AR5K_SLEEP_CTL, AR5K_SLEEP_CTL_SLDUR,
 			(state->bs_sleep_duration - 3) << 3);
 
 	/*
 	 * Set enhanced sleep registers on 5212
 	 */
-	if (hal->ah_version == AR5K_AR5212) {
+	if (ah->ah_version == AR5K_AR5212) {
 		if (state->bs_sleep_duration > state->bs_interval &&
 				roundup(state->bs_sleep_duration, interval) ==
 				state->bs_sleep_duration)
@@ -2758,18 +2758,18 @@ int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 		next_beacon = interval == dtim ? state->bs_next_dtim :
 			state->bs_next_beacon;
 
-		ath5k_hw_reg_write(hal,
+		ath5k_hw_reg_write(ah,
 			AR5K_REG_SM((state->bs_next_dtim - 3) << 3,
 			AR5K_SLEEP0_NEXT_DTIM) |
 			AR5K_REG_SM(10, AR5K_SLEEP0_CABTO) |
 			AR5K_SLEEP0_ENH_SLEEP_EN |
 			AR5K_SLEEP0_ASSUME_DTIM, AR5K_SLEEP0);
 
-		ath5k_hw_reg_write(hal, AR5K_REG_SM((next_beacon - 3) << 3,
+		ath5k_hw_reg_write(ah, AR5K_REG_SM((next_beacon - 3) << 3,
 			AR5K_SLEEP1_NEXT_TIM) |
 			AR5K_REG_SM(10, AR5K_SLEEP1_BEACON_TO), AR5K_SLEEP1);
 
-		ath5k_hw_reg_write(hal,
+		ath5k_hw_reg_write(ah,
 			AR5K_REG_SM(interval, AR5K_SLEEP2_TIM_PER) |
 			AR5K_REG_SM(dtim, AR5K_SLEEP2_DTIM_PER), AR5K_SLEEP2);
 	}
@@ -2780,27 +2780,27 @@ int ath5k_hw_set_beacon_timers(struct ath_hw *hal,
 /*
  * Reset beacon timers
  */
-void ath5k_hw_reset_beacon(struct ath_hw *hal)
+void ath5k_hw_reset_beacon(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
 	/*
 	 * Disable beacon timer
 	 */
-	ath5k_hw_reg_write(hal, 0, AR5K_TIMER0);
+	ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
 
 	/*
 	 * Disable some beacon register values
 	 */
-	AR5K_REG_DISABLE_BITS(hal, AR5K_STA_ID1,
+	AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
 			AR5K_STA_ID1_DEFAULT_ANTENNA | AR5K_STA_ID1_PCF);
-	ath5k_hw_reg_write(hal, AR5K_BEACON_PERIOD, AR5K_BEACON);
+	ath5k_hw_reg_write(ah, AR5K_BEACON_PERIOD, AR5K_BEACON);
 }
 
 /*
  * Wait for beacon queue to finish
  * TODO: This function's name is misleading, rename
  */
-int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
+int ath5k_hw_wait_for_beacon(struct ath5k_hw *ah, unsigned long phys_addr)
 {
 	unsigned int i;
 	int ret;
@@ -2808,15 +2808,15 @@ int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 	AR5K_TRACE;
 
 	/* 5210 doesn't have QCU*/
-	if (hal->ah_version == AR5K_AR5210) {
+	if (ah->ah_version == AR5K_AR5210) {
 		/*
 		 * Wait for beaconn queue to finish by checking
 		 * Control Register and Beacon Status Register.
 		 */
 		for (i = AR5K_TUNE_BEACON_INTERVAL / 2; i > 0; i--) {
-			if (!(ath5k_hw_reg_read(hal, AR5K_BSR) & AR5K_BSR_TXQ1F)
+			if (!(ath5k_hw_reg_read(ah, AR5K_BSR) & AR5K_BSR_TXQ1F)
 					||
-			    !(ath5k_hw_reg_read(hal, AR5K_CR) & AR5K_BSR_TXQ1F))
+			    !(ath5k_hw_reg_read(ah, AR5K_CR) & AR5K_BSR_TXQ1F))
 				break;
 			udelay(10);
 		}
@@ -2826,8 +2826,8 @@ int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 			/*
 			 * Re-schedule the beacon queue
 			 */
-			ath5k_hw_reg_write(hal, phys_addr, AR5K_NOQCU_TXDP1);
-			ath5k_hw_reg_write(hal, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
+			ath5k_hw_reg_write(ah, phys_addr, AR5K_NOQCU_TXDP1);
+			ath5k_hw_reg_write(ah, AR5K_BCR_TQ1V | AR5K_BCR_BDMAE,
 					AR5K_BCR);
 
 			return -EIO;
@@ -2835,11 +2835,11 @@ int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 		ret = 0;
 	} else {
 	/*5211/5212*/
-		ret = ath5k_hw_register_timeout(hal,
+		ret = ath5k_hw_register_timeout(ah,
 			AR5K_QUEUE_STATUS(AR5K_TX_QUEUE_ID_BEACON),
 			AR5K_QCU_STS_FRMPENDCNT, 0, false);
 
-		if (AR5K_REG_READ_Q(hal, AR5K_QCU_TXE, AR5K_TX_QUEUE_ID_BEACON))
+		if (AR5K_REG_READ_Q(ah, AR5K_QCU_TXE, AR5K_TX_QUEUE_ID_BEACON))
 			return -EIO;
 	}
 
@@ -2849,23 +2849,23 @@ int ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr)
 /*
  * Update mib counters (statistics)
  */
-void ath5k_hw_update_mib_counters(struct ath_hw *hal,
+void ath5k_hw_update_mib_counters(struct ath5k_hw *ah,
 		struct ath5k_mib_stats *statistics)
 {
 	AR5K_TRACE;
 	/* Read-And-Clear */
-	statistics->ackrcv_bad += ath5k_hw_reg_read(hal, AR5K_ACK_FAIL);
-	statistics->rts_bad += ath5k_hw_reg_read(hal, AR5K_RTS_FAIL);
-	statistics->rts_good += ath5k_hw_reg_read(hal, AR5K_RTS_OK);
-	statistics->fcs_bad += ath5k_hw_reg_read(hal, AR5K_FCS_FAIL);
-	statistics->beacons += ath5k_hw_reg_read(hal, AR5K_BEACON_CNT);
+	statistics->ackrcv_bad += ath5k_hw_reg_read(ah, AR5K_ACK_FAIL);
+	statistics->rts_bad += ath5k_hw_reg_read(ah, AR5K_RTS_FAIL);
+	statistics->rts_good += ath5k_hw_reg_read(ah, AR5K_RTS_OK);
+	statistics->fcs_bad += ath5k_hw_reg_read(ah, AR5K_FCS_FAIL);
+	statistics->beacons += ath5k_hw_reg_read(ah, AR5K_BEACON_CNT);
 
 	/* Reset profile count registers on 5212*/
-	if (hal->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(hal, 0, AR5K_PROFCNT_TX);
-		ath5k_hw_reg_write(hal, 0, AR5K_PROFCNT_RX);
-		ath5k_hw_reg_write(hal, 0, AR5K_PROFCNT_RXCLR);
-		ath5k_hw_reg_write(hal, 0, AR5K_PROFCNT_CYCLE);
+	if (ah->ah_version == AR5K_AR5212) {
+		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_TX);
+		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_RX);
+		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_RXCLR);
+		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_CYCLE);
 	}
 }
 
@@ -2876,15 +2876,15 @@ void ath5k_hw_update_mib_counters(struct ath_hw *hal,
 /*
  * Set ACK timeout on PCU
  */
-int ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout)
+int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
 	AR5K_TRACE;
 	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK),
-			hal->ah_turbo) <= timeout)
+			ah->ah_turbo) <= timeout)
 		return -EINVAL;
 
-	AR5K_REG_WRITE_BITS(hal, AR5K_TIME_OUT, AR5K_TIME_OUT_ACK,
-		ath5k_hw_htoclock(timeout, hal->ah_turbo));
+	AR5K_REG_WRITE_BITS(ah, AR5K_TIME_OUT, AR5K_TIME_OUT_ACK,
+		ath5k_hw_htoclock(timeout, ah->ah_turbo));
 
 	return 0;
 }
@@ -2892,26 +2892,26 @@ int ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout)
 /*
  * Read the ACK timeout from PCU
  */
-unsigned int ath5k_hw_get_ack_timeout(struct ath_hw *hal)
+unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
 
-	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hal,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK), hal->ah_turbo);
+	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(ah,
+			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK), ah->ah_turbo);
 }
 
 /*
  * Set CTS timeout on PCU
  */
-int ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout)
+int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
 	AR5K_TRACE;
 	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS),
-			hal->ah_turbo) <= timeout)
+			ah->ah_turbo) <= timeout)
 		return -EINVAL;
 
-	AR5K_REG_WRITE_BITS(hal, AR5K_TIME_OUT, AR5K_TIME_OUT_CTS,
-			ath5k_hw_htoclock(timeout, hal->ah_turbo));
+	AR5K_REG_WRITE_BITS(ah, AR5K_TIME_OUT, AR5K_TIME_OUT_CTS,
+			ath5k_hw_htoclock(timeout, ah->ah_turbo));
 
 	return 0;
 }
@@ -2919,18 +2919,18 @@ int ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout)
 /*
  * Read CTS timeout from PCU
  */
-unsigned int ath5k_hw_get_cts_timeout(struct ath_hw *hal)
+unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
-	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(hal,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS), hal->ah_turbo);
+	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(ah,
+			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS), ah->ah_turbo);
 }
 
 /*
  * Key table (WEP) functions
  */
 
-int ath5k_hw_reset_key(struct ath_hw *hal, u16 entry)
+int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
 {
 	unsigned int i;
 
@@ -2938,27 +2938,27 @@ int ath5k_hw_reset_key(struct ath_hw *hal, u16 entry)
 	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
 
 	for (i = 0; i < AR5K_KEYCACHE_SIZE; i++)
-		ath5k_hw_reg_write(hal, 0, AR5K_KEYTABLE_OFF(entry, i));
+		ath5k_hw_reg_write(ah, 0, AR5K_KEYTABLE_OFF(entry, i));
 
 	/* Set NULL encryption on non-5210*/
-	if (hal->ah_version != AR5K_AR5210)
-		ath5k_hw_reg_write(hal, AR5K_KEYTABLE_TYPE_NULL,
+	if (ah->ah_version != AR5K_AR5210)
+		ath5k_hw_reg_write(ah, AR5K_KEYTABLE_TYPE_NULL,
 				AR5K_KEYTABLE_TYPE(entry));
 
 	return 0;
 }
 
-int ath5k_hw_is_key_valid(struct ath_hw *hal, u16 entry)
+int ath5k_hw_is_key_valid(struct ath5k_hw *ah, u16 entry)
 {
 	AR5K_TRACE;
 	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
 
 	/* Check the validation flag at the end of the entry */
-	return ath5k_hw_reg_read(hal, AR5K_KEYTABLE_MAC1(entry)) &
+	return ath5k_hw_reg_read(ah, AR5K_KEYTABLE_MAC1(entry)) &
 		AR5K_KEYTABLE_VALID;
 }
 
-int ath5k_hw_set_key(struct ath_hw *hal, u16 entry,
+int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
 		const struct ieee80211_key_conf *key, const u8 *mac)
 {
 	unsigned int i;
@@ -2999,15 +2999,15 @@ int ath5k_hw_set_key(struct ath_hw *hal, u16 entry,
 	}
 
 	for (i = 0; i < ARRAY_SIZE(key_v); i++)
-		ath5k_hw_reg_write(hal, le32_to_cpu(key_v[i]),
+		ath5k_hw_reg_write(ah, le32_to_cpu(key_v[i]),
 				AR5K_KEYTABLE_OFF(entry, i));
 
-	ath5k_hw_reg_write(hal, keytype, AR5K_KEYTABLE_TYPE(entry));
+	ath5k_hw_reg_write(ah, keytype, AR5K_KEYTABLE_TYPE(entry));
 
-	return ath5k_hw_set_key_lladdr(hal, entry, mac);
+	return ath5k_hw_set_key_lladdr(ah, entry, mac);
 }
 
-int ath5k_hw_set_key_lladdr(struct ath_hw *hal, u16 entry, const u8 *mac)
+int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac)
 {
 	u32 low_id, high_id;
 
@@ -3025,8 +3025,8 @@ int ath5k_hw_set_key_lladdr(struct ath_hw *hal, u16 entry, const u8 *mac)
 		high_id = AR5K_HIGH_ID(mac) | AR5K_KEYTABLE_VALID;
 	}
 
-	ath5k_hw_reg_write(hal, low_id, AR5K_KEYTABLE_MAC0(entry));
-	ath5k_hw_reg_write(hal, high_id, AR5K_KEYTABLE_MAC1(entry));
+	ath5k_hw_reg_write(ah, low_id, AR5K_KEYTABLE_MAC0(entry));
+	ath5k_hw_reg_write(ah, high_id, AR5K_KEYTABLE_MAC1(entry));
 
 	return 0;
 }
@@ -3039,7 +3039,7 @@ Queue Control Unit, DFS Control Unit Functions
 /*
  * Initialize a transmit queue
  */
-int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
+int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 		struct ath5k_txq_info *queue_info)
 {
 	unsigned int queue;
@@ -3051,7 +3051,7 @@ int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
 	 * Get queue by type
 	 */
 	/*5210 only has 2 queues*/
-	if (hal->ah_version == AR5K_AR5210) {
+	if (ah->ah_version == AR5K_AR5210) {
 		switch (queue_type) {
 		case AR5K_TX_QUEUE_DATA:
 			queue = AR5K_TX_QUEUE_ID_NOQCU_DATA;
@@ -3067,7 +3067,7 @@ int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
 		switch (queue_type) {
 		case AR5K_TX_QUEUE_DATA:
 			for (queue = AR5K_TX_QUEUE_ID_DATA_MIN;
-				hal->ah_txq[queue].tqi_type !=
+				ah->ah_txq[queue].tqi_type !=
 				AR5K_TX_QUEUE_INACTIVE; queue++) {
 
 				if (queue > AR5K_TX_QUEUE_ID_DATA_MAX)
@@ -3084,7 +3084,7 @@ int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
 			queue = AR5K_TX_QUEUE_ID_CAB;
 			break;
 		case AR5K_TX_QUEUE_XR_DATA:
-			if (hal->ah_version != AR5K_AR5212)
+			if (ah->ah_version != AR5K_AR5212)
 				AR5K_PRINTF("XR data queues only supported in "
 						"5212!\n");
 			queue = AR5K_TX_QUEUE_ID_XR_DATA;
@@ -3097,12 +3097,12 @@ int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
 	/*
 	 * Setup internal queue structure
 	 */
-	memset(&hal->ah_txq[queue], 0, sizeof(struct ath5k_txq_info));
-	hal->ah_txq[queue].tqi_type = queue_type;
+	memset(&ah->ah_txq[queue], 0, sizeof(struct ath5k_txq_info));
+	ah->ah_txq[queue].tqi_type = queue_type;
 
 	if (queue_info != NULL) {
 		queue_info->tqi_type = queue_type;
-		ret = ath5k_hw_setup_tx_queueprops(hal, queue, queue_info);
+		ret = ath5k_hw_setup_tx_queueprops(ah, queue, queue_info);
 		if (ret)
 			return ret;
 	}
@@ -3111,7 +3111,7 @@ int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
 	 * the Secondary interrupt mask registers on 5211+
 	 * check out ath5k_hw_reset_tx_queue
 	 */
-	AR5K_Q_ENABLE_BITS(hal->ah_txq_interrupts, queue);
+	AR5K_Q_ENABLE_BITS(ah->ah_txq_interrupts, queue);
 
 	return queue;
 }
@@ -3119,23 +3119,23 @@ int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type,
 /*
  * Setup a transmit queue
  */
-int ath5k_hw_setup_tx_queueprops(struct ath_hw *hal, int queue,
+int ath5k_hw_setup_tx_queueprops(struct ath5k_hw *ah, int queue,
 				const struct ath5k_txq_info *queue_info)
 {
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
-	if (hal->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
 		return -EIO;
 
-	memcpy(&hal->ah_txq[queue], queue_info, sizeof(struct ath5k_txq_info));
+	memcpy(&ah->ah_txq[queue], queue_info, sizeof(struct ath5k_txq_info));
 
 	/*XXX: Is this supported on 5210 ?*/
 	if ((queue_info->tqi_type == AR5K_TX_QUEUE_DATA &&
 			((queue_info->tqi_subtype == AR5K_WME_AC_VI) ||
 			(queue_info->tqi_subtype == AR5K_WME_AC_VO))) ||
 			queue_info->tqi_type == AR5K_TX_QUEUE_UAPSD)
-		hal->ah_txq[queue].tqi_flags |= AR5K_TXQ_FLAG_POST_FR_BKOFF_DIS;
+		ah->ah_txq[queue].tqi_flags |= AR5K_TXQ_FLAG_POST_FR_BKOFF_DIS;
 
 	return 0;
 }
@@ -3143,86 +3143,86 @@ int ath5k_hw_setup_tx_queueprops(struct ath_hw *hal, int queue,
 /*
  * Get properties for a specific transmit queue
  */
-int ath5k_hw_get_tx_queueprops(struct ath_hw *hal, int queue,
+int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
 		struct ath5k_txq_info *queue_info)
 {
 	AR5K_TRACE;
-	memcpy(queue_info, &hal->ah_txq[queue], sizeof(struct ath5k_txq_info));
+	memcpy(queue_info, &ah->ah_txq[queue], sizeof(struct ath5k_txq_info));
 	return 0;
 }
 
 /*
  * Set a transmit queue inactive
  */
-void ath5k_hw_release_tx_queue(struct ath_hw *hal, unsigned int queue)
+void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 {
 	AR5K_TRACE;
-	if (WARN_ON(queue >= hal->ah_capabilities.cap_queues.q_tx_num))
+	if (WARN_ON(queue >= ah->ah_capabilities.cap_queues.q_tx_num))
 		return;
 
 	/* This queue will be skipped in further operations */
-	hal->ah_txq[queue].tqi_type = AR5K_TX_QUEUE_INACTIVE;
+	ah->ah_txq[queue].tqi_type = AR5K_TX_QUEUE_INACTIVE;
 	/*For SIMR setup*/
-	AR5K_Q_DISABLE_BITS(hal->ah_txq_interrupts, queue);
+	AR5K_Q_DISABLE_BITS(ah->ah_txq_interrupts, queue);
 }
 
 /*
  * Set DFS params for a transmit queue
  */
-int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
+int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 {
 	u32 cw_min, cw_max, retry_lg, retry_sh;
-	struct ath5k_txq_info *tq = &hal->ah_txq[queue];
+	struct ath5k_txq_info *tq = &ah->ah_txq[queue];
 
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
-	tq = &hal->ah_txq[queue];
+	tq = &ah->ah_txq[queue];
 
 	if (tq->tqi_type == AR5K_TX_QUEUE_INACTIVE)
 		return 0;
 
-	if (hal->ah_version == AR5K_AR5210) {
+	if (ah->ah_version == AR5K_AR5210) {
 		/* Only handle data queues, others will be ignored */
 		if (tq->tqi_type != AR5K_TX_QUEUE_DATA)
 			return -EINVAL;
 
 		/* Set Slot time */
-		ath5k_hw_reg_write(hal, hal->ah_turbo == true ?
+		ath5k_hw_reg_write(ah, ah->ah_turbo == true ?
 			AR5K_INIT_SLOT_TIME_TURBO : AR5K_INIT_SLOT_TIME,
 			AR5K_SLOT_TIME);
 		/* Set ACK_CTS timeout */
-		ath5k_hw_reg_write(hal, hal->ah_turbo == true ?
+		ath5k_hw_reg_write(ah, ah->ah_turbo == true ?
 			AR5K_INIT_ACK_CTS_TIMEOUT_TURBO :
 			AR5K_INIT_ACK_CTS_TIMEOUT, AR5K_SLOT_TIME);
 		/* Set Transmit Latency */
-		ath5k_hw_reg_write(hal, hal->ah_turbo == true ?
+		ath5k_hw_reg_write(ah, ah->ah_turbo == true ?
 			AR5K_INIT_TRANSMIT_LATENCY_TURBO :
 			AR5K_INIT_TRANSMIT_LATENCY, AR5K_USEC_5210);
 		/* Set IFS0 */
-		if (hal->ah_turbo == true)
-			 ath5k_hw_reg_write(hal, ((AR5K_INIT_SIFS_TURBO +
-				(hal->ah_aifs + tq->tqi_aifs) *
+		if (ah->ah_turbo == true)
+			 ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_TURBO +
+				(ah->ah_aifs + tq->tqi_aifs) *
 				AR5K_INIT_SLOT_TIME_TURBO) <<
 				AR5K_IFS0_DIFS_S) | AR5K_INIT_SIFS_TURBO,
 				AR5K_IFS0);
 		else
-			ath5k_hw_reg_write(hal, ((AR5K_INIT_SIFS +
-				(hal->ah_aifs + tq->tqi_aifs) *
+			ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS +
+				(ah->ah_aifs + tq->tqi_aifs) *
 				AR5K_INIT_SLOT_TIME) << AR5K_IFS0_DIFS_S) |
 				AR5K_INIT_SIFS, AR5K_IFS0);
 
 		/* Set IFS1 */
-		ath5k_hw_reg_write(hal, hal->ah_turbo == true ?
+		ath5k_hw_reg_write(ah, ah->ah_turbo == true ?
 			AR5K_INIT_PROTO_TIME_CNTRL_TURBO :
 			AR5K_INIT_PROTO_TIME_CNTRL, AR5K_IFS1);
 		/* Set PHY register 0x9844 (??) */
-		ath5k_hw_reg_write(hal, hal->ah_turbo == true ?
-			(ath5k_hw_reg_read(hal, AR5K_PHY(17)) & ~0x7F) | 0x38 :
-			(ath5k_hw_reg_read(hal, AR5K_PHY(17)) & ~0x7F) | 0x1C,
+		ath5k_hw_reg_write(ah, ah->ah_turbo == true ?
+			(ath5k_hw_reg_read(ah, AR5K_PHY(17)) & ~0x7F) | 0x38 :
+			(ath5k_hw_reg_read(ah, AR5K_PHY(17)) & ~0x7F) | 0x1C,
 			AR5K_PHY(17));
 		/* Set Frame Control Register */
-		ath5k_hw_reg_write(hal, hal->ah_turbo == true ?
+		ath5k_hw_reg_write(ah, ah->ah_turbo == true ?
 			(AR5K_PHY_FRAME_CTL_INI | AR5K_PHY_TURBO_MODE |
 			AR5K_PHY_TURBO_SHORT | 0x2020) :
 			(AR5K_PHY_FRAME_CTL_INI | 0x1020),
@@ -3232,25 +3232,25 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 	/*
 	 * Calculate cwmin/max by channel mode
 	 */
-	cw_min = hal->ah_cw_min = AR5K_TUNE_CWMIN;
-	cw_max = hal->ah_cw_max = AR5K_TUNE_CWMAX;
-	hal->ah_aifs = AR5K_TUNE_AIFS;
+	cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN;
+	cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX;
+	ah->ah_aifs = AR5K_TUNE_AIFS;
 	/*XR is only supported on 5212*/
-	if (IS_CHAN_XR(hal->ah_current_channel) &&
-			hal->ah_version == AR5K_AR5212) {
-		cw_min = hal->ah_cw_min = AR5K_TUNE_CWMIN_XR;
-		cw_max = hal->ah_cw_max = AR5K_TUNE_CWMAX_XR;
-		hal->ah_aifs = AR5K_TUNE_AIFS_XR;
+	if (IS_CHAN_XR(ah->ah_current_channel) &&
+			ah->ah_version == AR5K_AR5212) {
+		cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN_XR;
+		cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX_XR;
+		ah->ah_aifs = AR5K_TUNE_AIFS_XR;
 	/*B mode is not supported on 5210*/
-	} else if (IS_CHAN_B(hal->ah_current_channel) &&
-			hal->ah_version != AR5K_AR5210) {
-		cw_min = hal->ah_cw_min = AR5K_TUNE_CWMIN_11B;
-		cw_max = hal->ah_cw_max = AR5K_TUNE_CWMAX_11B;
-		hal->ah_aifs = AR5K_TUNE_AIFS_11B;
+	} else if (IS_CHAN_B(ah->ah_current_channel) &&
+			ah->ah_version != AR5K_AR5210) {
+		cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN_11B;
+		cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX_11B;
+		ah->ah_aifs = AR5K_TUNE_AIFS_11B;
 	}
 
 	cw_min = 1;
-	while (cw_min < hal->ah_cw_min)
+	while (cw_min < ah->ah_cw_min)
 		cw_min = (cw_min << 1) | 1;
 
 	cw_min = tq->tqi_cw_min < 0 ? (cw_min >> (-tq->tqi_cw_min)) :
@@ -3261,9 +3261,9 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 	/*
 	 * Calculate and set retry limits
 	 */
-	if (hal->ah_software_retry == true) {
+	if (ah->ah_software_retry == true) {
 		/* XXX Need to test this */
-		retry_lg = hal->ah_limit_tx_retries;
+		retry_lg = ah->ah_limit_tx_retries;
 		retry_sh = retry_lg = retry_lg > AR5K_DCU_RETRY_LMT_SH_RETRY ?
 			AR5K_DCU_RETRY_LMT_SH_RETRY : retry_lg;
 	} else {
@@ -3272,8 +3272,8 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 	}
 
 	/*No QCU/DCU [5210]*/
-	if (hal->ah_version == AR5K_AR5210) {
-		ath5k_hw_reg_write(hal,
+	if (ah->ah_version == AR5K_AR5210) {
+		ath5k_hw_reg_write(ah,
 			(cw_min << AR5K_NODCU_RETRY_LMT_CW_MIN_S)
 			| AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
 				AR5K_NODCU_RETRY_LMT_SLG_RETRY)
@@ -3284,7 +3284,7 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 			AR5K_NODCU_RETRY_LMT);
 	} else {
 		/*QCU/DCU [5211+]*/
-		ath5k_hw_reg_write(hal,
+		ath5k_hw_reg_write(ah,
 			AR5K_REG_SM(AR5K_INIT_SLG_RETRY,
 				AR5K_DCU_RETRY_LMT_SLG_RETRY) |
 			AR5K_REG_SM(AR5K_INIT_SSH_RETRY,
@@ -3299,57 +3299,57 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 		 * Set initial content window (cw_min/cw_max)
 		 * and arbitrated interframe space (aifs)...
 		 */
-		ath5k_hw_reg_write(hal,
+		ath5k_hw_reg_write(ah,
 			AR5K_REG_SM(cw_min, AR5K_DCU_LCL_IFS_CW_MIN) |
 			AR5K_REG_SM(cw_max, AR5K_DCU_LCL_IFS_CW_MAX) |
-			AR5K_REG_SM(hal->ah_aifs + tq->tqi_aifs,
+			AR5K_REG_SM(ah->ah_aifs + tq->tqi_aifs,
 				AR5K_DCU_LCL_IFS_AIFS),
 			AR5K_QUEUE_DFS_LOCAL_IFS(queue));
 
 		/*
 		 * Set misc registers
 		 */
-		ath5k_hw_reg_write(hal, AR5K_QCU_MISC_DCU_EARLY,
+		ath5k_hw_reg_write(ah, AR5K_QCU_MISC_DCU_EARLY,
 			AR5K_QUEUE_MISC(queue));
 
 		if (tq->tqi_cbr_period) {
-			ath5k_hw_reg_write(hal, AR5K_REG_SM(tq->tqi_cbr_period,
+			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_cbr_period,
 				AR5K_QCU_CBRCFG_INTVAL) |
 				AR5K_REG_SM(tq->tqi_cbr_overflow_limit,
 				AR5K_QCU_CBRCFG_ORN_THRES),
 				AR5K_QUEUE_CBRCFG(queue));
-			AR5K_REG_ENABLE_BITS(hal, AR5K_QUEUE_MISC(queue),
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
 				AR5K_QCU_MISC_FRSHED_CBR);
 			if (tq->tqi_cbr_overflow_limit)
-				AR5K_REG_ENABLE_BITS(hal,
+				AR5K_REG_ENABLE_BITS(ah,
 					AR5K_QUEUE_MISC(queue),
 					AR5K_QCU_MISC_CBR_THRES_ENABLE);
 		}
 
 		if (tq->tqi_ready_time)
-			ath5k_hw_reg_write(hal, AR5K_REG_SM(tq->tqi_ready_time,
+			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_ready_time,
 				AR5K_QCU_RDYTIMECFG_INTVAL) |
 				AR5K_QCU_RDYTIMECFG_ENABLE,
 				AR5K_QUEUE_RDYTIMECFG(queue));
 
 		if (tq->tqi_burst_time) {
-			ath5k_hw_reg_write(hal, AR5K_REG_SM(tq->tqi_burst_time,
+			ath5k_hw_reg_write(ah, AR5K_REG_SM(tq->tqi_burst_time,
 				AR5K_DCU_CHAN_TIME_DUR) |
 				AR5K_DCU_CHAN_TIME_ENABLE,
 				AR5K_QUEUE_DFS_CHANNEL_TIME(queue));
 
 			if (tq->tqi_flags & AR5K_TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE)
-				AR5K_REG_ENABLE_BITS(hal,
+				AR5K_REG_ENABLE_BITS(ah,
 					AR5K_QUEUE_MISC(queue),
 					AR5K_QCU_MISC_TXE);
 		}
 
 		if (tq->tqi_flags & AR5K_TXQ_FLAG_BACKOFF_DISABLE)
-			ath5k_hw_reg_write(hal, AR5K_DCU_MISC_POST_FR_BKOFF_DIS,
+			ath5k_hw_reg_write(ah, AR5K_DCU_MISC_POST_FR_BKOFF_DIS,
 				AR5K_QUEUE_DFS_MISC(queue));
 
 		if (tq->tqi_flags & AR5K_TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE)
-			ath5k_hw_reg_write(hal, AR5K_DCU_MISC_BACKOFF_FRAG,
+			ath5k_hw_reg_write(ah, AR5K_DCU_MISC_BACKOFF_FRAG,
 				AR5K_QUEUE_DFS_MISC(queue));
 
 		/*
@@ -3357,18 +3357,18 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 		 */
 		switch (tq->tqi_type) {
 		case AR5K_TX_QUEUE_BEACON:
-			AR5K_REG_ENABLE_BITS(hal, AR5K_QUEUE_MISC(queue),
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
 				AR5K_QCU_MISC_FRSHED_DBA_GT |
 				AR5K_QCU_MISC_CBREXP_BCN |
 				AR5K_QCU_MISC_BCN_ENABLE);
 
-			AR5K_REG_ENABLE_BITS(hal, AR5K_QUEUE_DFS_MISC(queue),
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
 				(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
 				AR5K_DCU_MISC_ARBLOCK_CTL_S) |
 				AR5K_DCU_MISC_POST_FR_BKOFF_DIS |
 				AR5K_DCU_MISC_BCN_ENABLE);
 
-			ath5k_hw_reg_write(hal, ((AR5K_TUNE_BEACON_INTERVAL -
+			ath5k_hw_reg_write(ah, ((AR5K_TUNE_BEACON_INTERVAL -
 				(AR5K_TUNE_SW_BEACON_RESP -
 				AR5K_TUNE_DMA_BEACON_RESP) -
 				AR5K_TUNE_ADDITIONAL_SWBA_BACKOFF) * 1024) |
@@ -3377,18 +3377,18 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 			break;
 
 		case AR5K_TX_QUEUE_CAB:
-			AR5K_REG_ENABLE_BITS(hal, AR5K_QUEUE_MISC(queue),
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
 				AR5K_QCU_MISC_FRSHED_DBA_GT |
 				AR5K_QCU_MISC_CBREXP |
 				AR5K_QCU_MISC_CBREXP_BCN);
 
-			AR5K_REG_ENABLE_BITS(hal, AR5K_QUEUE_DFS_MISC(queue),
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
 				(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
 				AR5K_DCU_MISC_ARBLOCK_CTL_S));
 			break;
 
 		case AR5K_TX_QUEUE_UAPSD:
-			AR5K_REG_ENABLE_BITS(hal, AR5K_QUEUE_MISC(queue),
+			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
 				AR5K_QCU_MISC_CBREXP);
 			break;
 
@@ -3400,13 +3400,13 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
 		/*
 		 * Enable tx queue in the secondary interrupt mask registers
 		 */
-		ath5k_hw_reg_write(hal, AR5K_REG_SM(hal->ah_txq_interrupts,
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_interrupts,
 			AR5K_SIMR0_QCU_TXOK) |
-			AR5K_REG_SM(hal->ah_txq_interrupts,
+			AR5K_REG_SM(ah->ah_txq_interrupts,
 			AR5K_SIMR0_QCU_TXDESC), AR5K_SIMR0);
-		ath5k_hw_reg_write(hal, AR5K_REG_SM(hal->ah_txq_interrupts,
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_interrupts,
 			AR5K_SIMR1_QCU_TXERR), AR5K_SIMR1);
-		ath5k_hw_reg_write(hal, AR5K_REG_SM(hal->ah_txq_interrupts,
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txq_interrupts,
 			AR5K_SIMR2_QCU_TXURN), AR5K_SIMR2);
 	}
 
@@ -3417,16 +3417,16 @@ int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue)
  * Get number of pending frames
  * for a specific queue [5211+]
  */
-u32 ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue) {
+u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue) {
 	AR5K_TRACE;
-	AR5K_ASSERT_ENTRY(queue, hal->ah_capabilities.cap_queues.q_tx_num);
+	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
 
 	/* Return if queue is declared inactive */
-	if (hal->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
+	if (ah->ah_txq[queue].tqi_type == AR5K_TX_QUEUE_INACTIVE)
 		return false;
 
 	/* XXX: How about AR5K_CFG_TXCNT ? */
-	if (hal->ah_version == AR5K_AR5210)
+	if (ah->ah_version == AR5K_AR5210)
 		return false;
 
 	return AR5K_QUEUE_STATUS(queue) & AR5K_QCU_STS_FRMPENDCNT;
@@ -3435,17 +3435,17 @@ u32 ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue) {
 /*
  * Set slot time
  */
-int ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time)
+int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time)
 {
 	AR5K_TRACE;
 	if (slot_time < AR5K_SLOT_TIME_9 || slot_time > AR5K_SLOT_TIME_MAX)
 		return -EINVAL;
 
-	if (hal->ah_version == AR5K_AR5210)
-		ath5k_hw_reg_write(hal, ath5k_hw_htoclock(slot_time,
-				hal->ah_turbo), AR5K_SLOT_TIME);
+	if (ah->ah_version == AR5K_AR5210)
+		ath5k_hw_reg_write(ah, ath5k_hw_htoclock(slot_time,
+				ah->ah_turbo), AR5K_SLOT_TIME);
 	else
-		ath5k_hw_reg_write(hal, slot_time, AR5K_DCU_GBL_IFS_SLOT);
+		ath5k_hw_reg_write(ah, slot_time, AR5K_DCU_GBL_IFS_SLOT);
 
 	return 0;
 }
@@ -3453,14 +3453,14 @@ int ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time)
 /*
  * Get slot time
  */
-unsigned int ath5k_hw_get_slot_time(struct ath_hw *hal)
+unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
-	if (hal->ah_version == AR5K_AR5210)
-		return ath5k_hw_clocktoh(ath5k_hw_reg_read(hal,
-				AR5K_SLOT_TIME) & 0xffff, hal->ah_turbo);
+	if (ah->ah_version == AR5K_AR5210)
+		return ath5k_hw_clocktoh(ath5k_hw_reg_read(ah,
+				AR5K_SLOT_TIME) & 0xffff, ah->ah_turbo);
 	else
-		return ath5k_hw_reg_read(hal, AR5K_DCU_GBL_IFS_SLOT) & 0xffff;
+		return ath5k_hw_reg_read(ah, AR5K_DCU_GBL_IFS_SLOT) & 0xffff;
 }
 
 
@@ -3476,7 +3476,7 @@ unsigned int ath5k_hw_get_slot_time(struct ath_hw *hal)
  * Initialize the 2-word tx descriptor on 5210/5211
  */
 static int
-ath5k_hw_setup_2word_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
+ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	unsigned int pkt_len, unsigned int hdr_len, enum ath5k_pkt_type type,
 	unsigned int tx_power, unsigned int tx_rate0, unsigned int tx_tries0,
 	unsigned int key_index, unsigned int antenna_mode, unsigned int flags,
@@ -3504,7 +3504,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
 	 * Verify header length
 	 * XXX: I only found that on 5210 code, does it work on 5211 ?
 	 */
-	if (hal->ah_version == AR5K_AR5210) {
+	if (ah->ah_version == AR5K_AR5210) {
 		tx_desc->tx_control_0 = hdr_len &
 				AR5K_2W_TX_DESC_CTL0_HEADER_LEN;
 		if (tx_desc->tx_control_0 != hdr_len)
@@ -3512,7 +3512,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
 	}
 
 	/*Diferences between 5210-5211*/
-	if (hal->ah_version == AR5K_AR5210) {
+	if (ah->ah_version == AR5K_AR5210) {
 		switch (type) {
 		case AR5K_PKT_TYPE_BEACON:
 		case AR5K_PKT_TYPE_PROBE_RESP:
@@ -3560,7 +3560,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
 	/*
 	 * RTS/CTS Duration [5210 ?]
 	 */
-	if ((hal->ah_version == AR5K_AR5210) &&
+	if ((ah->ah_version == AR5K_AR5210) &&
 			(flags & (AR5K_TXDESC_RTSENA | AR5K_TXDESC_CTSENA)))
 		tx_desc->tx_control_1 |= rtscts_duration &
 				AR5K_2W_TX_DESC_CTL1_RTS_DURATION;
@@ -3571,8 +3571,8 @@ ath5k_hw_setup_2word_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
 /*
  * Initialize the 4-word tx descriptor on 5212
  */
-static int ath5k_hw_setup_4word_tx_desc(struct ath_hw *hal,
-	struct ath_desc *desc, unsigned int pkt_len, unsigned int hdr_len,
+static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
+	struct ath5k_desc *desc, unsigned int pkt_len, unsigned int hdr_len,
 	enum ath5k_pkt_type type, unsigned int tx_power, unsigned int tx_rate0,
 	unsigned int tx_tries0, unsigned int key_index,
 	unsigned int antenna_mode, unsigned int flags, unsigned int rtscts_rate,
@@ -3653,13 +3653,13 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath_hw *hal,
  * Initialize a 4-word XR tx descriptor on 5212
  */
 static bool
-ath5k_hw_setup_xr_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
+ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2, u_int tx_tries2,
 	unsigned int tx_rate3, u_int tx_tries3)
 {
 	struct ath5k_hw_4w_tx_desc *tx_desc;
 
-	if (hal->ah_version == AR5K_AR5212) {
+	if (ah->ah_version == AR5K_AR5212) {
 		tx_desc = (struct ath5k_hw_4w_tx_desc *)&desc->ds_ctl0;
 
 #define _XTX_TRIES(_n)							\
@@ -3687,8 +3687,8 @@ ath5k_hw_setup_xr_tx_desc(struct ath_hw *hal, struct ath_desc *desc,
 /*
  * Fill the 2-word tx descriptor on 5210/5211
  */
-static int ath5k_hw_fill_2word_tx_desc(struct ath_hw *hal,
-	struct ath_desc *desc, unsigned int segment_length,
+static int ath5k_hw_fill_2word_tx_desc(struct ath5k_hw *ah,
+	struct ath5k_desc *desc, unsigned int segment_length,
 	bool first_segment, bool last_segment)
 {
 	struct ath5k_hw_2w_tx_desc *tx_desc;
@@ -3716,8 +3716,8 @@ static int ath5k_hw_fill_2word_tx_desc(struct ath_hw *hal,
  * Fill the 4-word tx descriptor on 5212
  * XXX: Added an argument *last_desc -need revision
  */
-static int ath5k_hw_fill_4word_tx_desc(struct ath_hw *hal,
-	struct ath_desc *desc, unsigned int segment_length,
+static int ath5k_hw_fill_4word_tx_desc(struct ath5k_hw *ah,
+	struct ath5k_desc *desc, unsigned int segment_length,
 	bool first_segment, bool last_segment)
 {
 	struct ath5k_hw_4w_tx_desc *tx_desc;
@@ -3747,8 +3747,8 @@ static int ath5k_hw_fill_4word_tx_desc(struct ath_hw *hal,
 /*
  * Proccess the tx status descriptor on 5210/5211
  */
-static int ath5k_hw_proc_2word_tx_status(struct ath_hw *hal,
-		struct ath_desc *desc)
+static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
+		struct ath5k_desc *desc)
 {
 	struct ath5k_hw_tx_status *tx_status;
 	struct ath5k_hw_2w_tx_desc *tx_desc;
@@ -3797,8 +3797,8 @@ static int ath5k_hw_proc_2word_tx_status(struct ath_hw *hal,
 /*
  * Proccess a tx descriptor on 5212
  */
-static int ath5k_hw_proc_4word_tx_status(struct ath_hw *hal,
-		struct ath_desc *desc)
+static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
+		struct ath5k_desc *desc)
 {
 	struct ath5k_hw_tx_status *tx_status;
 	struct ath5k_hw_4w_tx_desc *tx_desc;
@@ -3876,7 +3876,7 @@ static int ath5k_hw_proc_4word_tx_status(struct ath_hw *hal,
 /*
  * Initialize an rx descriptor
  */
-int ath5k_hw_setup_rx_desc(struct ath_hw *hal, struct ath_desc *desc,
+int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 			u32 size, unsigned int flags)
 {
 	struct ath5k_rx_desc *rx_desc;
@@ -3911,8 +3911,8 @@ int ath5k_hw_setup_rx_desc(struct ath_hw *hal, struct ath_desc *desc,
 /*
  * Proccess the rx status descriptor on 5210/5211
  */
-static int ath5k_hw_proc_old_rx_status(struct ath_hw *hal,
-		struct ath_desc *desc)
+static int ath5k_hw_proc_old_rx_status(struct ath5k_hw *ah,
+		struct ath5k_desc *desc)
 {
 	struct ath5k_hw_old_rx_status *rx_status;
 
@@ -3980,8 +3980,8 @@ static int ath5k_hw_proc_old_rx_status(struct ath_hw *hal,
 /*
  * Proccess the rx status descriptor on 5212
  */
-static int ath5k_hw_proc_new_rx_status(struct ath_hw *hal,
-		struct ath_desc *desc)
+static int ath5k_hw_proc_new_rx_status(struct ath5k_hw *ah,
+		struct ath5k_desc *desc)
 {
 	struct ath5k_hw_new_rx_status *rx_status;
 	struct ath5k_hw_rx_error *rx_err;
@@ -4058,7 +4058,7 @@ static int ath5k_hw_proc_new_rx_status(struct ath_hw *hal,
 /*
  * Set led state
  */
-void ath5k_hw_set_ledstate(struct ath_hw *hal, unsigned int state)
+void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state)
 {
 	u32 led;
 	/*5210 has different led mode handling*/
@@ -4067,11 +4067,11 @@ void ath5k_hw_set_ledstate(struct ath_hw *hal, unsigned int state)
 	AR5K_TRACE;
 
 	/*Reset led status*/
-	if (hal->ah_version != AR5K_AR5210)
-		AR5K_REG_DISABLE_BITS(hal, AR5K_PCICFG,
+	if (ah->ah_version != AR5K_AR5210)
+		AR5K_REG_DISABLE_BITS(ah, AR5K_PCICFG,
 			AR5K_PCICFG_LEDMODE |  AR5K_PCICFG_LED);
 	else
-		AR5K_REG_DISABLE_BITS(hal, AR5K_PCICFG, AR5K_PCICFG_LED);
+		AR5K_REG_DISABLE_BITS(ah, AR5K_PCICFG, AR5K_PCICFG_LED);
 
 	/*
 	 * Some blinking values, define at your wish
@@ -4101,22 +4101,22 @@ void ath5k_hw_set_ledstate(struct ath_hw *hal, unsigned int state)
 	}
 
 	/*Write new status to the register*/
-	if (hal->ah_version != AR5K_AR5210)
-		AR5K_REG_ENABLE_BITS(hal, AR5K_PCICFG, led);
+	if (ah->ah_version != AR5K_AR5210)
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, led);
 	else
-		AR5K_REG_ENABLE_BITS(hal, AR5K_PCICFG, led_5210);
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, led_5210);
 }
 
 /*
  * Set GPIO outputs
  */
-int ath5k_hw_set_gpio_output(struct ath_hw *hal, u32 gpio)
+int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio)
 {
 	AR5K_TRACE;
 	if (gpio > AR5K_NUM_GPIO)
 		return -EINVAL;
 
-	ath5k_hw_reg_write(hal, (ath5k_hw_reg_read(hal, AR5K_GPIOCR) &~
+	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, AR5K_GPIOCR) &~
 		AR5K_GPIOCR_OUT(gpio)) | AR5K_GPIOCR_OUT(gpio), AR5K_GPIOCR);
 
 	return 0;
@@ -4125,13 +4125,13 @@ int ath5k_hw_set_gpio_output(struct ath_hw *hal, u32 gpio)
 /*
  * Set GPIO inputs
  */
-int ath5k_hw_set_gpio_input(struct ath_hw *hal, u32 gpio)
+int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio)
 {
 	AR5K_TRACE;
 	if (gpio > AR5K_NUM_GPIO)
 		return -EINVAL;
 
-	ath5k_hw_reg_write(hal, (ath5k_hw_reg_read(hal, AR5K_GPIOCR) &~
+	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, AR5K_GPIOCR) &~
 		AR5K_GPIOCR_OUT(gpio)) | AR5K_GPIOCR_IN(gpio), AR5K_GPIOCR);
 
 	return 0;
@@ -4140,21 +4140,21 @@ int ath5k_hw_set_gpio_input(struct ath_hw *hal, u32 gpio)
 /*
  * Get GPIO state
  */
-u32 ath5k_hw_get_gpio(struct ath_hw *hal, u32 gpio)
+u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio)
 {
 	AR5K_TRACE;
 	if (gpio > AR5K_NUM_GPIO)
 		return 0xffffffff;
 
 	/* GPIO input magic */
-	return ((ath5k_hw_reg_read(hal, AR5K_GPIODI) & AR5K_GPIODI_M) >> gpio) &
+	return ((ath5k_hw_reg_read(ah, AR5K_GPIODI) & AR5K_GPIODI_M) >> gpio) &
 		0x1;
 }
 
 /*
  * Set GPIO state
  */
-int ath5k_hw_set_gpio(struct ath_hw *hal, u32 gpio, u32 val)
+int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val)
 {
 	u32 data;
 	AR5K_TRACE;
@@ -4163,12 +4163,12 @@ int ath5k_hw_set_gpio(struct ath_hw *hal, u32 gpio, u32 val)
 		return -EINVAL;
 
 	/* GPIO output magic */
-	data = ath5k_hw_reg_read(hal, AR5K_GPIODO);
+	data = ath5k_hw_reg_read(ah, AR5K_GPIODO);
 
 	data &= ~(1 << gpio);
 	data |= (val & 1) << gpio;
 
-	ath5k_hw_reg_write(hal, data, AR5K_GPIODO);
+	ath5k_hw_reg_write(ah, data, AR5K_GPIODO);
 
 	return 0;
 }
@@ -4176,7 +4176,7 @@ int ath5k_hw_set_gpio(struct ath_hw *hal, u32 gpio, u32 val)
 /*
  * Initialize the GPIO interrupt (RFKill switch)
  */
-void ath5k_hw_set_gpio_intr(struct ath_hw *hal, unsigned int gpio,
+void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio,
 		u32 interrupt_level)
 {
 	u32 data;
@@ -4188,18 +4188,18 @@ void ath5k_hw_set_gpio_intr(struct ath_hw *hal, unsigned int gpio,
 	/*
 	 * Set the GPIO interrupt
 	 */
-	data = (ath5k_hw_reg_read(hal, AR5K_GPIOCR) &
+	data = (ath5k_hw_reg_read(ah, AR5K_GPIOCR) &
 		~(AR5K_GPIOCR_INT_SEL(gpio) | AR5K_GPIOCR_INT_SELH |
 		AR5K_GPIOCR_INT_ENA | AR5K_GPIOCR_OUT(gpio))) |
 		(AR5K_GPIOCR_INT_SEL(gpio) | AR5K_GPIOCR_INT_ENA);
 
-	ath5k_hw_reg_write(hal, interrupt_level ? data :
+	ath5k_hw_reg_write(ah, interrupt_level ? data :
 		(data | AR5K_GPIOCR_INT_SELH), AR5K_GPIOCR);
 
-	hal->ah_imr |= AR5K_IMR_GPIO;
+	ah->ah_imr |= AR5K_IMR_GPIO;
 
 	/* Enable GPIO interrupts */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PIMR, AR5K_IMR_GPIO);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PIMR, AR5K_IMR_GPIO);
 }
 
 
@@ -4207,7 +4207,7 @@ void ath5k_hw_set_gpio_intr(struct ath_hw *hal, unsigned int gpio,
  Regulatory Domain/Channels Setup
 \*********************************/
 
-u16 ath5k_get_regdomain(struct ath_hw *hal)
+u16 ath5k_get_regdomain(struct ath5k_hw *ah)
 {
 	u16 regdomain;
 	enum ath5k_regdom ieee_regdomain;
@@ -4215,8 +4215,8 @@ u16 ath5k_get_regdomain(struct ath_hw *hal)
 	u16 code;
 #endif
 
-	ath5k_eeprom_regulation_domain(hal, false, &ieee_regdomain);
-	hal->ah_capabilities.cap_regdomain.reg_hw = ieee_regdomain;
+	ath5k_eeprom_regulation_domain(ah, false, &ieee_regdomain);
+	ah->ah_capabilities.cap_regdomain.reg_hw = ieee_regdomain;
 
 #ifdef COUNTRYCODE
 	/*
@@ -4228,7 +4228,7 @@ u16 ath5k_get_regdomain(struct ath_hw *hal)
 #endif
 
 	regdomain = ath5k_regdom_from_ieee(ieee_regdomain);
-	hal->ah_capabilities.cap_regdomain.reg_current = regdomain;
+	ah->ah_capabilities.cap_regdomain.reg_current = regdomain;
 
 	return regdomain;
 }
@@ -4240,11 +4240,11 @@ u16 ath5k_get_regdomain(struct ath_hw *hal)
 \****************/
 
 void /*O.K.*/
-ath5k_hw_dump_state(struct ath_hw *hal)
+ath5k_hw_dump_state(struct ath5k_hw *ah)
 {
 #ifdef AR5K_DEBUG
 #define AR5K_PRINT_REGISTER(_x)						\
-	AR5K_PRINTF("(%s: %08x) ", #_x, ath5k_hw_reg_read(hal, AR5K_##_x));
+	AR5K_PRINTF("(%s: %08x) ", #_x, ath5k_hw_reg_read(ah, AR5K_##_x));
 
 	AR5K_PRINT("MAC registers:\n");
 	AR5K_PRINT_REGISTER(CR);
@@ -4338,7 +4338,7 @@ ath5k_hw_dump_state(struct ath_hw *hal)
 #endif
 }
 
-int ath5k_hw_get_capability(struct ath_hw *hal,
+int ath5k_hw_get_capability(struct ath5k_hw *ah,
 		enum ath5k_capability_type cap_type,
 		u32 capability, u32 *result)
 {
@@ -4347,7 +4347,7 @@ int ath5k_hw_get_capability(struct ath_hw *hal,
 	switch (cap_type) {
 	case AR5K_CAP_NUM_TXQUEUES:
 		if (result) {
-			if (hal->ah_version == AR5K_AR5210)
+			if (ah->ah_version == AR5K_AR5210)
 				*result = AR5K_NUM_TX_QUEUES_NOQCU;
 			else
 				*result = AR5K_NUM_TX_QUEUES;
@@ -4356,7 +4356,7 @@ int ath5k_hw_get_capability(struct ath_hw *hal,
 	case AR5K_CAP_VEOL:
 		goto yes;
 	case AR5K_CAP_COMPRESSION:
-		if (hal->ah_version == AR5K_AR5212)
+		if (ah->ah_version == AR5K_AR5212)
 			goto yes;
 		else
 			goto no;
@@ -4365,12 +4365,12 @@ int ath5k_hw_get_capability(struct ath_hw *hal,
 	case AR5K_CAP_TPC:
 		goto yes;
 	case AR5K_CAP_BSSIDMASK:
-		if (hal->ah_version == AR5K_AR5212)
+		if (ah->ah_version == AR5K_AR5212)
 			goto yes;
 		else
 			goto no;
 	case AR5K_CAP_XR:
-		if (hal->ah_version == AR5K_AR5212)
+		if (ah->ah_version == AR5K_AR5212)
 			goto yes;
 		else
 			goto no;
@@ -4384,13 +4384,13 @@ yes:
 	return 0;
 }
 
-static int ath5k_hw_enable_pspoll(struct ath_hw *hal, u8 *bssid,
+static int ath5k_hw_enable_pspoll(struct ath5k_hw *ah, u8 *bssid,
 		u16 assoc_id)
 {
 	AR5K_TRACE;
 
-	if (hal->ah_version == AR5K_AR5210) {
-		AR5K_REG_DISABLE_BITS(hal, AR5K_STA_ID1,
+	if (ah->ah_version == AR5K_AR5210) {
+		AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1,
 			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
 		return 0;
 	}
@@ -4398,12 +4398,12 @@ static int ath5k_hw_enable_pspoll(struct ath_hw *hal, u8 *bssid,
 	return -EIO;
 }
 
-static int ath5k_hw_disable_pspoll(struct ath_hw *hal)
+static int ath5k_hw_disable_pspoll(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
 
-	if (hal->ah_version == AR5K_AR5210) {
-		AR5K_REG_ENABLE_BITS(hal, AR5K_STA_ID1,
+	if (ah->ah_version == AR5K_AR5210) {
+		AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1,
 			AR5K_STA_ID1_NO_PSPOLL | AR5K_STA_ID1_DEFAULT_ANTENNA);
 		return 0;
 	}
diff --git a/drivers/net/wireless/ath5k/hw.h b/drivers/net/wireless/ath5k/hw.h
index d48754c..d9a7c09 100644
--- a/drivers/net/wireless/ath5k/hw.h
+++ b/drivers/net/wireless/ath5k/hw.h
@@ -284,7 +284,7 @@ struct ath5k_hw_2w_tx_desc {
 #define AR5K_2W_TX_DESC_CTL0_FRAME_TYPE_S	26
 #define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5210	0x02000000
 #define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5211	0x1e000000
-#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT	(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT	(ah->ah_version == AR5K_AR5210 ? \
 						AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5210 : \
 						AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_5211)
 #define AR5K_2W_TX_DESC_CTL0_ANT_MODE_XMIT_S	25
@@ -297,7 +297,7 @@ struct ath5k_hw_2w_tx_desc {
 #define AR5K_2W_TX_DESC_CTL1_MORE		0x00001000
 #define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5210	0x0007e000
 #define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5211	0x000fe000
-#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX	(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX	(ah->ah_version == AR5K_AR5210 ? \
 						AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5210 : \
 						AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_5211)
 #define AR5K_2W_TX_DESC_CTL1_ENCRYPT_KEY_INDEX_S	13
@@ -427,9 +427,9 @@ struct ath5k_hw_tx_status {
 #define AR5K_INIT_CFG	0x00000000
 #endif
 
-/*#define AR5K_REG_READ(_reg)	ath5k_hw_reg_read(hal, _reg)
+/*#define AR5K_REG_READ(_reg)	ath5k_hw_reg_read(ah, _reg)
 
-#define AR5K_REG_WRITE(_reg, _val)	ath5k_hw_reg_write(hal, _val, _reg)*/
+#define AR5K_REG_WRITE(_reg, _val)	ath5k_hw_reg_write(ah, _val, _reg)*/
 
 #define AR5K_REG_SM(_val, _flags)					\
 	(((_val) << _flags##_S) & (_flags))
@@ -442,25 +442,25 @@ struct ath5k_hw_tx_status {
  * retrieve the values which we do not want to clear (lets call this
  * old_data) and then set the register with this and our new_value:
  * ( old_data | new_value) */
-#define AR5K_REG_WRITE_BITS(hal, _reg, _flags, _val)			\
-	ath5k_hw_reg_write(hal, (ath5k_hw_reg_read(hal, _reg) & ~(_flags)) | \
+#define AR5K_REG_WRITE_BITS(ah, _reg, _flags, _val)			\
+	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, _reg) & ~(_flags)) | \
 	    (((_val) << _flags##_S) & (_flags)), _reg)
 
-#define AR5K_REG_MASKED_BITS(hal, _reg, _flags, _mask)			\
-	ath5k_hw_reg_write(hal, (ath5k_hw_reg_read(hal, _reg) &		\
+#define AR5K_REG_MASKED_BITS(ah, _reg, _flags, _mask)			\
+	ath5k_hw_reg_write(ah, (ath5k_hw_reg_read(ah, _reg) &		\
 			(_mask)) | (_flags), _reg)
 
-#define AR5K_REG_ENABLE_BITS(hal, _reg, _flags)				\
-	ath5k_hw_reg_write(hal, ath5k_hw_reg_read(hal, _reg) | (_flags), _reg)
+#define AR5K_REG_ENABLE_BITS(ah, _reg, _flags)				\
+	ath5k_hw_reg_write(ah, ath5k_hw_reg_read(ah, _reg) | (_flags), _reg)
 
-#define AR5K_REG_DISABLE_BITS(hal, _reg, _flags)			\
-	ath5k_hw_reg_write(hal, ath5k_hw_reg_read(hal, _reg) & ~(_flags), _reg)
+#define AR5K_REG_DISABLE_BITS(ah, _reg, _flags)			\
+	ath5k_hw_reg_write(ah, ath5k_hw_reg_read(ah, _reg) & ~(_flags), _reg)
 
-#define AR5K_PHY_WRITE(hal, _reg, _val)					\
-	ath5k_hw_reg_write(hal, _val, (hal)->ah_phy + ((_reg) << 2))
+#define AR5K_PHY_WRITE(ah, _reg, _val)					\
+	ath5k_hw_reg_write(ah, _val, (ah)->ah_phy + ((_reg) << 2))
 
-#define AR5K_PHY_READ(hal, _reg)					\
-	ath5k_hw_reg_read(hal, (hal)->ah_phy + ((_reg) << 2))
+#define AR5K_PHY_READ(ah, _reg)					\
+	ath5k_hw_reg_read(ah, (ah)->ah_phy + ((_reg) << 2))
 
 #define AR5K_REG_WAIT(_i) do {						\
 	if (_i % 64)							\
@@ -468,19 +468,19 @@ struct ath5k_hw_tx_status {
 } while (0)
 
 #define AR5K_EEPROM_READ(_o, _v) do {					\
-	if ((ret = ath5k_hw_eeprom_read(hal, (_o), &(_v))) != 0)	\
+	if ((ret = ath5k_hw_eeprom_read(ah, (_o), &(_v))) != 0)	\
 		return (ret);						\
 } while (0)
 
 #define AR5K_EEPROM_READ_HDR(_o, _v)					\
-	AR5K_EEPROM_READ(_o, hal->ah_capabilities.cap_eeprom._v);	\
+	AR5K_EEPROM_READ(_o, ah->ah_capabilities.cap_eeprom._v);	\
 
 /* Read status of selected queue */
-#define AR5K_REG_READ_Q(hal, _reg, _queue)				\
-	(ath5k_hw_reg_read(hal, _reg) & (1 << _queue))			\
+#define AR5K_REG_READ_Q(ah, _reg, _queue)				\
+	(ath5k_hw_reg_read(ah, _reg) & (1 << _queue))			\
 
-#define AR5K_REG_WRITE_Q(hal, _reg, _queue)				\
-	ath5k_hw_reg_write(hal, (1 << _queue), _reg)
+#define AR5K_REG_WRITE_Q(ah, _reg, _queue)				\
+	ath5k_hw_reg_write(ah, (1 << _queue), _reg)
 
 #define AR5K_Q_ENABLE_BITS(_reg, _queue) do {				\
 	_reg |= 1 << _queue;						\
diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index 11aeacc..ca12964 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -999,7 +999,7 @@ static const struct ath5k_ini rf5112_ini_bbgain[] = {
 /*
  * Write initial register dump
  */
-static void ath5k_hw_ini_registers(struct ath_hw *hal, unsigned int size,
+static void ath5k_hw_ini_registers(struct ath5k_hw *ah, unsigned int size,
 		const struct ath5k_ini *ini_regs, bool change_channel)
 {
 	unsigned int i;
@@ -1016,18 +1016,18 @@ static void ath5k_hw_ini_registers(struct ath_hw *hal, unsigned int size,
 		switch (ini_regs[i].ini_mode) {
 		case AR5K_INI_READ:
 			/* Cleared on read */
-			ath5k_hw_reg_read(hal, ini_regs[i].ini_register);
+			ath5k_hw_reg_read(ah, ini_regs[i].ini_register);
 			break;
 		case AR5K_INI_WRITE:
 		default:
 			AR5K_REG_WAIT(i);
-			ath5k_hw_reg_write(hal, ini_regs[i].ini_value,
+			ath5k_hw_reg_write(ah, ini_regs[i].ini_value,
 					ini_regs[i].ini_register);
 		}
 	}
 }
 
-static void ath5k_hw_ini_mode_registers(struct ath_hw *hal,
+static void ath5k_hw_ini_mode_registers(struct ath5k_hw *ah,
 		unsigned int size, const struct ath5k_ini_mode *ini_mode,
 		u8 mode)
 {
@@ -1035,33 +1035,33 @@ static void ath5k_hw_ini_mode_registers(struct ath_hw *hal,
 
 	for (i = 0; i < size; i++) {
 		AR5K_REG_WAIT(i);
-		ath5k_hw_reg_write(hal, ini_mode[i].mode_value[mode],
+		ath5k_hw_reg_write(ah, ini_mode[i].mode_value[mode],
 			(u32)ini_mode[i].mode_register);
 	}
 
 }
 
-int ath5k_hw_write_initvals(struct ath_hw *hal, u8 mode, bool change_channel)
+int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 {
 	/*
 	 * Write initial mode-specific settings
 	 */
 	/*For 5212*/
-	if (hal->ah_version == AR5K_AR5212) {
-		ath5k_hw_ini_mode_registers(hal, ARRAY_SIZE(ar5212_ini_mode),
+	if (ah->ah_version == AR5K_AR5212) {
+		ath5k_hw_ini_mode_registers(ah, ARRAY_SIZE(ar5212_ini_mode),
 				ar5212_ini_mode, mode);
-		if (hal->ah_radio == AR5K_RF5111)
-			ath5k_hw_ini_mode_registers(hal,
+		if (ah->ah_radio == AR5K_RF5111)
+			ath5k_hw_ini_mode_registers(ah,
 					ARRAY_SIZE(ar5212_rf5111_ini_mode),
 					ar5212_rf5111_ini_mode, mode);
-		else if (hal->ah_radio == AR5K_RF5112)
-			ath5k_hw_ini_mode_registers(hal,
+		else if (ah->ah_radio == AR5K_RF5112)
+			ath5k_hw_ini_mode_registers(ah,
 					ARRAY_SIZE(ar5212_rf5112_ini_mode),
 					ar5212_rf5112_ini_mode, mode);
 	}
 	/*For 5211*/
-	if (hal->ah_version == AR5K_AR5211)
-		ath5k_hw_ini_mode_registers(hal, ARRAY_SIZE(ar5211_ini_mode),
+	if (ah->ah_version == AR5K_AR5211)
+		ath5k_hw_ini_mode_registers(ah, ARRAY_SIZE(ar5211_ini_mode),
 				ar5211_ini_mode, mode);
 	/* For 5210 mode settings check out ath5k_hw_reset_tx_queue */
 
@@ -1069,32 +1069,32 @@ int ath5k_hw_write_initvals(struct ath_hw *hal, u8 mode, bool change_channel)
 	 * Write initial settings common for all modes
 	 */
 	/*For 5212*/
-	if (hal->ah_version == AR5K_AR5212) {
-		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5212_ini),
+	if (ah->ah_version == AR5K_AR5212) {
+		ath5k_hw_ini_registers(ah, ARRAY_SIZE(ar5212_ini),
 				ar5212_ini, change_channel);
-		if (hal->ah_radio == AR5K_RF5112) {
-			ath5k_hw_reg_write(hal, AR5K_PHY_PAPD_PROBE_INI_5112,
+		if (ah->ah_radio == AR5K_RF5112) {
+			ath5k_hw_reg_write(ah, AR5K_PHY_PAPD_PROBE_INI_5112,
 					AR5K_PHY_PAPD_PROBE);
-			ath5k_hw_ini_registers(hal,
+			ath5k_hw_ini_registers(ah,
 					ARRAY_SIZE(rf5112_ini_bbgain),
 					rf5112_ini_bbgain, change_channel);
-		} else if (hal->ah_radio == AR5K_RF5111) {
-			ath5k_hw_reg_write(hal, AR5K_PHY_GAIN_2GHZ_INI_5111,
+		} else if (ah->ah_radio == AR5K_RF5111) {
+			ath5k_hw_reg_write(ah, AR5K_PHY_GAIN_2GHZ_INI_5111,
 					AR5K_PHY_GAIN_2GHZ);
-			ath5k_hw_reg_write(hal, AR5K_PHY_PAPD_PROBE_INI_5111,
+			ath5k_hw_reg_write(ah, AR5K_PHY_PAPD_PROBE_INI_5111,
 					AR5K_PHY_PAPD_PROBE);
-			ath5k_hw_ini_registers(hal,
+			ath5k_hw_ini_registers(ah,
 					ARRAY_SIZE(rf5111_ini_bbgain),
 					rf5111_ini_bbgain, change_channel);
 		}
-	} else if (hal->ah_version == AR5K_AR5211) {
-		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5211_ini),
+	} else if (ah->ah_version == AR5K_AR5211) {
+		ath5k_hw_ini_registers(ah, ARRAY_SIZE(ar5211_ini),
 				ar5211_ini, change_channel);
 		/* AR5211 only comes with 5111 */
-		ath5k_hw_ini_registers(hal, ARRAY_SIZE(rf5111_ini_bbgain),
+		ath5k_hw_ini_registers(ah, ARRAY_SIZE(rf5111_ini_bbgain),
 				rf5111_ini_bbgain, change_channel);
-	} else if (hal->ah_version == AR5K_AR5210) {
-		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5210_ini),
+	} else if (ah->ah_version == AR5K_AR5210) {
+		ath5k_hw_ini_registers(ah, ARRAY_SIZE(ar5210_ini),
 				ar5210_ini, change_channel);
 	}
 
diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
index 2b5f8fb..83cff49 100644
--- a/drivers/net/wireless/ath5k/phy.c
+++ b/drivers/net/wireless/ath5k/phy.c
@@ -591,65 +591,65 @@ static unsigned int ath5k_hw_rfregs_op(u32 *rf, u32 offset, u32 reg, u32 bits,
 	return data;
 }
 
-static u32 ath5k_hw_rfregs_gainf_corr(struct ath_hw *hal)
+static u32 ath5k_hw_rfregs_gainf_corr(struct ath5k_hw *ah)
 {
 	u32 mix, step;
 	u32 *rf;
 
-	if (hal->ah_rf_banks == NULL)
+	if (ah->ah_rf_banks == NULL)
 		return 0;
 
-	rf = hal->ah_rf_banks;
-	hal->ah_gain.g_f_corr = 0;
+	rf = ah->ah_rf_banks;
+	ah->ah_gain.g_f_corr = 0;
 
-	if (ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 1, 36, 0, false) != 1)
+	if (ath5k_hw_rfregs_op(rf, ah->ah_offset[7], 0, 1, 36, 0, false) != 1)
 		return 0;
 
-	step = ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 4, 32, 0, false);
-	mix = hal->ah_gain.g_step->gos_param[0];
+	step = ath5k_hw_rfregs_op(rf, ah->ah_offset[7], 0, 4, 32, 0, false);
+	mix = ah->ah_gain.g_step->gos_param[0];
 
 	switch (mix) {
 	case 3:
-		hal->ah_gain.g_f_corr = step * 2;
+		ah->ah_gain.g_f_corr = step * 2;
 		break;
 	case 2:
-		hal->ah_gain.g_f_corr = (step - 5) * 2;
+		ah->ah_gain.g_f_corr = (step - 5) * 2;
 		break;
 	case 1:
-		hal->ah_gain.g_f_corr = step;
+		ah->ah_gain.g_f_corr = step;
 		break;
 	default:
-		hal->ah_gain.g_f_corr = 0;
+		ah->ah_gain.g_f_corr = 0;
 		break;
 	}
 
-	return hal->ah_gain.g_f_corr;
+	return ah->ah_gain.g_f_corr;
 }
 
-static bool ath5k_hw_rfregs_gain_readback(struct ath_hw *hal)
+static bool ath5k_hw_rfregs_gain_readback(struct ath5k_hw *ah)
 {
 	u32 step, mix, level[4];
 	u32 *rf;
 
-	if (hal->ah_rf_banks == NULL)
+	if (ah->ah_rf_banks == NULL)
 		return false;
 
-	rf = hal->ah_rf_banks;
+	rf = ah->ah_rf_banks;
 
-	if (hal->ah_radio == AR5K_RF5111) {
-		step = ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 6, 37, 0,
+	if (ah->ah_radio == AR5K_RF5111) {
+		step = ath5k_hw_rfregs_op(rf, ah->ah_offset[7], 0, 6, 37, 0,
 				false);
 		level[0] = 0;
 		level[1] = (step == 0x3f) ? 0x32 : step + 4;
 		level[2] = (step != 0x3f) ? 0x40 : level[0];
 		level[3] = level[2] + 0x32;
 
-		hal->ah_gain.g_high = level[3] -
+		ah->ah_gain.g_high = level[3] -
 			(step == 0x3f ? AR5K_GAIN_DYN_ADJUST_HI_MARGIN : -5);
-		hal->ah_gain.g_low = level[0] +
+		ah->ah_gain.g_low = level[0] +
 			(step == 0x3f ? AR5K_GAIN_DYN_ADJUST_LO_MARGIN : 0);
 	} else {
-		mix = ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 1, 36, 0,
+		mix = ath5k_hw_rfregs_op(rf, ah->ah_offset[7], 0, 1, 36, 0,
 				false);
 		level[0] = level[2] = 0;
 
@@ -657,22 +657,22 @@ static bool ath5k_hw_rfregs_gain_readback(struct ath_hw *hal)
 			level[1] = level[3] = 83;
 		} else {
 			level[1] = level[3] = 107;
-			hal->ah_gain.g_high = 55;
+			ah->ah_gain.g_high = 55;
 		}
 	}
 
-	return (hal->ah_gain.g_current >= level[0] &&
-			hal->ah_gain.g_current <= level[1]) ||
-		(hal->ah_gain.g_current >= level[2] &&
-			hal->ah_gain.g_current <= level[3]);
+	return (ah->ah_gain.g_current >= level[0] &&
+			ah->ah_gain.g_current <= level[1]) ||
+		(ah->ah_gain.g_current >= level[2] &&
+			ah->ah_gain.g_current <= level[3]);
 }
 
-static s32 ath5k_hw_rfregs_gain_adjust(struct ath_hw *hal)
+static s32 ath5k_hw_rfregs_gain_adjust(struct ath5k_hw *ah)
 {
 	const struct ath5k_gain_opt *go;
 	int ret = 0;
 
-	switch (hal->ah_radio) {
+	switch (ah->ah_radio) {
 	case AR5K_RF5111:
 		go = &rfgain_opt_5111;
 		break;
@@ -683,35 +683,35 @@ static s32 ath5k_hw_rfregs_gain_adjust(struct ath_hw *hal)
 		return 0;
 	}
 
-	hal->ah_gain.g_step = &go->go_step[hal->ah_gain.g_step_idx];
+	ah->ah_gain.g_step = &go->go_step[ah->ah_gain.g_step_idx];
 
-	if (hal->ah_gain.g_current >= hal->ah_gain.g_high) {
-		if (hal->ah_gain.g_step_idx == 0)
+	if (ah->ah_gain.g_current >= ah->ah_gain.g_high) {
+		if (ah->ah_gain.g_step_idx == 0)
 			return -1;
-		for (hal->ah_gain.g_target = hal->ah_gain.g_current;
-				hal->ah_gain.g_target >=  hal->ah_gain.g_high &&
-				hal->ah_gain.g_step_idx > 0;
-				hal->ah_gain.g_step =
-					&go->go_step[hal->ah_gain.g_step_idx])
-			hal->ah_gain.g_target -= 2 *
-			    (go->go_step[--(hal->ah_gain.g_step_idx)].gos_gain -
-			    hal->ah_gain.g_step->gos_gain);
+		for (ah->ah_gain.g_target = ah->ah_gain.g_current;
+				ah->ah_gain.g_target >=  ah->ah_gain.g_high &&
+				ah->ah_gain.g_step_idx > 0;
+				ah->ah_gain.g_step =
+					&go->go_step[ah->ah_gain.g_step_idx])
+			ah->ah_gain.g_target -= 2 *
+			    (go->go_step[--(ah->ah_gain.g_step_idx)].gos_gain -
+			    ah->ah_gain.g_step->gos_gain);
 
 		ret = 1;
 		goto done;
 	}
 
-	if (hal->ah_gain.g_current <= hal->ah_gain.g_low) {
-		if (hal->ah_gain.g_step_idx == (go->go_steps_count - 1))
+	if (ah->ah_gain.g_current <= ah->ah_gain.g_low) {
+		if (ah->ah_gain.g_step_idx == (go->go_steps_count - 1))
 			return -2;
-		for (hal->ah_gain.g_target = hal->ah_gain.g_current;
-				hal->ah_gain.g_target <= hal->ah_gain.g_low &&
-				hal->ah_gain.g_step_idx < go->go_steps_count-1;
-				hal->ah_gain.g_step =
-					&go->go_step[hal->ah_gain.g_step_idx])
-			hal->ah_gain.g_target -= 2 *
-			    (go->go_step[++hal->ah_gain.g_step_idx].gos_gain -
-			    hal->ah_gain.g_step->gos_gain);
+		for (ah->ah_gain.g_target = ah->ah_gain.g_current;
+				ah->ah_gain.g_target <= ah->ah_gain.g_low &&
+				ah->ah_gain.g_step_idx < go->go_steps_count-1;
+				ah->ah_gain.g_step =
+					&go->go_step[ah->ah_gain.g_step_idx])
+			ah->ah_gain.g_target -= 2 *
+			    (go->go_step[++ah->ah_gain.g_step_idx].gos_gain -
+			    ah->ah_gain.g_step->gos_gain);
 
 		ret = 2;
 		goto done;
@@ -720,8 +720,8 @@ static s32 ath5k_hw_rfregs_gain_adjust(struct ath_hw *hal)
 done:
 #ifdef AR5K_DEBUG
 	AR5K_PRINTF("ret %d, gain step %u, current gain %u, target gain %u\n",
-		ret, hal->ah_gain.g_step_idx, hal->ah_gain.g_current,
-		hal->ah_gain.g_target);
+		ret, ah->ah_gain.g_step_idx, ah->ah_gain.g_current,
+		ah->ah_gain.g_target);
 #endif
 
 	return ret;
@@ -730,10 +730,10 @@ done:
 /*
  * Read EEPROM Calibration data, modify RF Banks and Initialize RF5111
  */
-static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
+static int ath5k_hw_rf5111_rfregs(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel, unsigned int mode)
 {
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 *rf;
 	const unsigned int rf_size = ARRAY_SIZE(rfregs_5111);
 	unsigned int i;
@@ -742,7 +742,7 @@ static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
 
 	AR5K_ASSERT_ENTRY(mode, AR5K_INI_VAL_MAX);
 
-	rf = hal->ah_rf_banks;
+	rf = ah->ah_rf_banks;
 
 	/* Copy values to modify them */
 	for (i = 0; i < rf_size; i++) {
@@ -753,7 +753,7 @@ static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
 
 		if (bank != rfregs_5111[i].rf_bank) {
 			bank = rfregs_5111[i].rf_bank;
-			hal->ah_offset[bank] = i;
+			ah->ah_offset[bank] = i;
 		}
 
 		rf[i] = rfregs_5111[i].rf_value[mode];
@@ -767,11 +767,11 @@ static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
 			ee_mode = AR5K_EEPROM_MODE_11G;
 		obdb = 0;
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[0],
+		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[0],
 				ee->ee_ob[ee_mode][obdb], 3, 119, 0, true))
 			return -EINVAL;
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[0],
+		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[0],
 				ee->ee_ob[ee_mode][obdb], 3, 122, 0, true))
 			return -EINVAL;
 
@@ -785,44 +785,44 @@ static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
 			(channel->freq >= 5260 ? 1 :
 			 (channel->freq > 4000 ? 0 : -1)));
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 				ee->ee_pwd_84, 1, 51, 3, true))
 			return -EINVAL;
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 				ee->ee_pwd_90, 1, 45, 3, true))
 			return -EINVAL;
 	}
 
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+	if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 			!ee->ee_xpd[ee_mode], 1, 95, 0, true))
 		return -EINVAL;
 
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+	if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 			ee->ee_x_gain[ee_mode], 4, 96, 0, true))
 		return -EINVAL;
 
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6], obdb >= 0 ?
+	if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6], obdb >= 0 ?
 			ee->ee_ob[ee_mode][obdb] : 0, 3, 104, 0, true))
 		return -EINVAL;
 
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6], obdb >= 0 ?
+	if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6], obdb >= 0 ?
 			ee->ee_db[ee_mode][obdb] : 0, 3, 107, 0, true))
 		return -EINVAL;
 
 	/* Modify bank 7 */
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[7],
+	if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[7],
 			ee->ee_i_gain[ee_mode], 6, 29, 0, true))
 		return -EINVAL;
 
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[7],
+	if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[7],
 			ee->ee_xpd[ee_mode], 1, 4, 0, true))
 		return -EINVAL;
 
 	/* Write RF values */
 	for (i = 0; i < rf_size; i++) {
 		AR5K_REG_WAIT(i);
-		ath5k_hw_reg_write(hal, rf[i], rfregs_5111[i].rf_register);
+		ath5k_hw_reg_write(ah, rf[i], rfregs_5111[i].rf_register);
 	}
 
 	return 0;
@@ -831,11 +831,11 @@ static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
 /*
  * Read EEPROM Calibration data, modify RF Banks and Initialize RF5112
  */
-static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
+static int ath5k_hw_rf5112_rfregs(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel, unsigned int mode)
 {
 	const struct ath5k_ini_rf *rf_ini;
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 *rf;
 	unsigned int rf_size, i;
 	int obdb = -1, bank = -1;
@@ -843,9 +843,9 @@ static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
 
 	AR5K_ASSERT_ENTRY(mode, AR5K_INI_VAL_MAX);
 
-	rf = hal->ah_rf_banks;
+	rf = ah->ah_rf_banks;
 
-	if (hal->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A) {
+	if (ah->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A) {
 		rf_ini = rfregs_5112a;
 		rf_size = ARRAY_SIZE(rfregs_5112a);
 	} else {
@@ -862,7 +862,7 @@ static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
 
 		if (bank != rf_ini[i].rf_bank) {
 			bank = rf_ini[i].rf_bank;
-			hal->ah_offset[bank] = i;
+			ah->ah_offset[bank] = i;
 		}
 
 		rf[i] = rf_ini[i].rf_value[mode];
@@ -876,11 +876,11 @@ static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
 			ee_mode = AR5K_EEPROM_MODE_11G;
 		obdb = 0;
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 				ee->ee_ob[ee_mode][obdb], 3, 287, 0, true))
 			return -EINVAL;
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 				ee->ee_ob[ee_mode][obdb], 3, 290, 0, true))
 			return -EINVAL;
 	} else {
@@ -891,34 +891,34 @@ static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
 			(channel->freq >= 5260 ? 1 :
 			    (channel->freq > 4000 ? 0 : -1)));
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 				ee->ee_ob[ee_mode][obdb], 3, 279, 0, true))
 			return -EINVAL;
 
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+		if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 				ee->ee_ob[ee_mode][obdb], 3, 282, 0, true))
 			return -EINVAL;
 	}
 
 #ifdef notyet
-	ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+	ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 	    ee->ee_x_gain[ee_mode], 2, 270, 0, true);
-	ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+	ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 	    ee->ee_x_gain[ee_mode], 2, 257, 0, true);
 #endif
 
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+	if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[6],
 			ee->ee_xpd[ee_mode], 1, 302, 0, true))
 		return -EINVAL;
 
 	/* Modify bank 7 */
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[7],
+	if (!ath5k_hw_rfregs_op(rf, ah->ah_offset[7],
 			ee->ee_i_gain[ee_mode], 6, 14, 0, true))
 		return -EINVAL;
 
 	/* Write RF values */
 	for (i = 0; i < rf_size; i++)
-		ath5k_hw_reg_write(hal, rf[i], rf_ini[i].rf_register);
+		ath5k_hw_reg_write(ah, rf[i], rf_ini[i].rf_register);
 
 	return 0;
 }
@@ -926,50 +926,50 @@ static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
 /*
  * Initialize RF
  */
-int ath5k_hw_rfregs(struct ath_hw *hal, struct ieee80211_channel *channel,
+int ath5k_hw_rfregs(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		unsigned int mode)
 {
-	int (*func)(struct ath_hw *, struct ieee80211_channel *, unsigned int);
+	int (*func)(struct ath5k_hw *, struct ieee80211_channel *, unsigned int);
 	int ret;
 
-	switch (hal->ah_radio) {
+	switch (ah->ah_radio) {
 	case AR5K_RF5111:
-		hal->ah_rf_banks_size = sizeof(rfregs_5111);
+		ah->ah_rf_banks_size = sizeof(rfregs_5111);
 		func = ath5k_hw_rf5111_rfregs;
 		break;
 	case AR5K_RF5112:
-		if (hal->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A)
-			hal->ah_rf_banks_size = sizeof(rfregs_5112a);
+		if (ah->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A)
+			ah->ah_rf_banks_size = sizeof(rfregs_5112a);
 		else
-			hal->ah_rf_banks_size = sizeof(rfregs_5112);
+			ah->ah_rf_banks_size = sizeof(rfregs_5112);
 		func = ath5k_hw_rf5112_rfregs;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (hal->ah_rf_banks == NULL) {
+	if (ah->ah_rf_banks == NULL) {
 		/* XXX do extra checks? */
-		hal->ah_rf_banks = kmalloc(hal->ah_rf_banks_size, GFP_KERNEL);
-		if (hal->ah_rf_banks == NULL) {
+		ah->ah_rf_banks = kmalloc(ah->ah_rf_banks_size, GFP_KERNEL);
+		if (ah->ah_rf_banks == NULL) {
 			AR5K_PRINT("out of memory\n");
 			return -ENOMEM;
 		}
 	}
 
-	ret = func(hal, channel, mode);
+	ret = func(ah, channel, mode);
 	if (!ret)
-		hal->ah_rf_gain = AR5K_RFGAIN_INACTIVE;
+		ah->ah_rf_gain = AR5K_RFGAIN_INACTIVE;
 
 	return ret;
 }
 
-int ath5k_hw_rfgain(struct ath_hw *hal, unsigned int freq)
+int ath5k_hw_rfgain(struct ath5k_hw *ah, unsigned int freq)
 {
 	const struct ath5k_ini_rfgain *ath5k_rfg;
 	unsigned int i, size;
 
-	switch (hal->ah_radio) {
+	switch (ah->ah_radio) {
 	case AR5K_RF5111:
 		ath5k_rfg = rfgain_5111;
 		size = ARRAY_SIZE(rfgain_5111);
@@ -992,72 +992,72 @@ int ath5k_hw_rfgain(struct ath_hw *hal, unsigned int freq)
 
 	for (i = 0; i < size; i++) {
 		AR5K_REG_WAIT(i);
-		ath5k_hw_reg_write(hal, ath5k_rfg[i].rfg_value[freq],
+		ath5k_hw_reg_write(ah, ath5k_rfg[i].rfg_value[freq],
 			(u32)ath5k_rfg[i].rfg_register);
 	}
 
 	return 0;
 }
 
-enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath_hw *hal)
+enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath5k_hw *ah)
 {
 	u32 data, type;
 
 	AR5K_TRACE;
 
-	if (hal->ah_rf_banks == NULL || !hal->ah_gain.g_active ||
-			hal->ah_version <= AR5K_AR5211)
+	if (ah->ah_rf_banks == NULL || !ah->ah_gain.g_active ||
+			ah->ah_version <= AR5K_AR5211)
 		return AR5K_RFGAIN_INACTIVE;
 
-	if (hal->ah_rf_gain != AR5K_RFGAIN_READ_REQUESTED)
+	if (ah->ah_rf_gain != AR5K_RFGAIN_READ_REQUESTED)
 		goto done;
 
-	data = ath5k_hw_reg_read(hal, AR5K_PHY_PAPD_PROBE);
+	data = ath5k_hw_reg_read(ah, AR5K_PHY_PAPD_PROBE);
 
 	if (!(data & AR5K_PHY_PAPD_PROBE_TX_NEXT)) {
-		hal->ah_gain.g_current = data >> AR5K_PHY_PAPD_PROBE_GAINF_S;
+		ah->ah_gain.g_current = data >> AR5K_PHY_PAPD_PROBE_GAINF_S;
 		type = AR5K_REG_MS(data, AR5K_PHY_PAPD_PROBE_TYPE);
 
 		if (type == AR5K_PHY_PAPD_PROBE_TYPE_CCK)
-			hal->ah_gain.g_current += AR5K_GAIN_CCK_PROBE_CORR;
+			ah->ah_gain.g_current += AR5K_GAIN_CCK_PROBE_CORR;
 
-		if (hal->ah_radio == AR5K_RF5112) {
-			ath5k_hw_rfregs_gainf_corr(hal);
-			hal->ah_gain.g_current =
-				hal->ah_gain.g_current>=hal->ah_gain.g_f_corr ?
-				(hal->ah_gain.g_current-hal->ah_gain.g_f_corr) :
+		if (ah->ah_radio == AR5K_RF5112) {
+			ath5k_hw_rfregs_gainf_corr(ah);
+			ah->ah_gain.g_current =
+				ah->ah_gain.g_current>=ah->ah_gain.g_f_corr ?
+				(ah->ah_gain.g_current-ah->ah_gain.g_f_corr) :
 				0;
 		}
 
-		if (ath5k_hw_rfregs_gain_readback(hal) &&
-				AR5K_GAIN_CHECK_ADJUST(&hal->ah_gain) &&
-				ath5k_hw_rfregs_gain_adjust(hal))
-			hal->ah_rf_gain = AR5K_RFGAIN_NEED_CHANGE;
+		if (ath5k_hw_rfregs_gain_readback(ah) &&
+				AR5K_GAIN_CHECK_ADJUST(&ah->ah_gain) &&
+				ath5k_hw_rfregs_gain_adjust(ah))
+			ah->ah_rf_gain = AR5K_RFGAIN_NEED_CHANGE;
 	}
 
 done:
-	return hal->ah_rf_gain;
+	return ah->ah_rf_gain;
 }
 
-int ath5k_hw_set_rfgain_opt(struct ath_hw *hal)
+int ath5k_hw_set_rfgain_opt(struct ath5k_hw *ah)
 {
 	/* Initialize the gain optimization values */
-	switch (hal->ah_radio) {
+	switch (ah->ah_radio) {
 	case AR5K_RF5111:
-		hal->ah_gain.g_step_idx = rfgain_opt_5111.go_default;
-		hal->ah_gain.g_step =
-		    &rfgain_opt_5111.go_step[hal->ah_gain.g_step_idx];
-		hal->ah_gain.g_low = 20;
-		hal->ah_gain.g_high = 35;
-		hal->ah_gain.g_active = 1;
+		ah->ah_gain.g_step_idx = rfgain_opt_5111.go_default;
+		ah->ah_gain.g_step =
+		    &rfgain_opt_5111.go_step[ah->ah_gain.g_step_idx];
+		ah->ah_gain.g_low = 20;
+		ah->ah_gain.g_high = 35;
+		ah->ah_gain.g_active = 1;
 		break;
 	case AR5K_RF5112:
-		hal->ah_gain.g_step_idx = rfgain_opt_5112.go_default;
-		hal->ah_gain.g_step =
-		    &rfgain_opt_5112.go_step[hal->ah_gain.g_step_idx];
-		hal->ah_gain.g_low = 20;
-		hal->ah_gain.g_high = 85;
-		hal->ah_gain.g_active = 1;
+		ah->ah_gain.g_step_idx = rfgain_opt_5112.go_default;
+		ah->ah_gain.g_step =
+		    &rfgain_opt_5112.go_step[ah->ah_gain.g_step_idx];
+		ah->ah_gain.g_low = 20;
+		ah->ah_gain.g_high = 85;
+		ah->ah_gain.g_active = 1;
 		break;
 	default:
 		return -EINVAL;
@@ -1073,16 +1073,16 @@ int ath5k_hw_set_rfgain_opt(struct ath_hw *hal)
 /*
  * Check if a channel is supported
  */
-bool ath5k_channel_ok(struct ath_hw *hal, u16 freq, unsigned int flags)
+bool ath5k_channel_ok(struct ath5k_hw *ah, u16 freq, unsigned int flags)
 {
 	/* Check if the channel is in our supported range */
 	if (flags & CHANNEL_2GHZ) {
-		if ((freq >= hal->ah_capabilities.cap_range.range_2ghz_min) &&
-		    (freq <= hal->ah_capabilities.cap_range.range_2ghz_max))
+		if ((freq >= ah->ah_capabilities.cap_range.range_2ghz_min) &&
+		    (freq <= ah->ah_capabilities.cap_range.range_2ghz_max))
 			return true;
 	} else if (flags & CHANNEL_5GHZ)
-		if ((freq >= hal->ah_capabilities.cap_range.range_5ghz_min) &&
-		    (freq <= hal->ah_capabilities.cap_range.range_5ghz_max))
+		if ((freq >= ah->ah_capabilities.cap_range.range_5ghz_min) &&
+		    (freq <= ah->ah_capabilities.cap_range.range_5ghz_max))
 			return true;
 
 	return false;
@@ -1110,7 +1110,7 @@ static u32 ath5k_hw_rf5110_chan2athchan(struct ieee80211_channel *channel)
 /*
  * Set channel on RF5110
  */
-static int ath5k_hw_rf5110_channel(struct ath_hw *hal,
+static int ath5k_hw_rf5110_channel(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	u32 data;
@@ -1119,8 +1119,8 @@ static int ath5k_hw_rf5110_channel(struct ath_hw *hal,
 	 * Set the channel and wait
 	 */
 	data = ath5k_hw_rf5110_chan2athchan(channel);
-	ath5k_hw_reg_write(hal, data, AR5K_RF_BUFFER);
-	ath5k_hw_reg_write(hal, 0, AR5K_RF_BUFFER_CONTROL_0);
+	ath5k_hw_reg_write(ah, data, AR5K_RF_BUFFER);
+	ath5k_hw_reg_write(ah, 0, AR5K_RF_BUFFER_CONTROL_0);
 	mdelay(1);
 
 	return 0;
@@ -1158,11 +1158,11 @@ static int ath5k_hw_rf5111_chan2athchan(unsigned int ieee,
 /*
  * Set channel on 5111
  */
-static int ath5k_hw_rf5111_channel(struct ath_hw *hal,
+static int ath5k_hw_rf5111_channel(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
-	struct ath5k_athchan_2ghz ath_channel_2ghz;
-	unsigned int ath_channel = channel->chan;
+	struct ath5k_athchan_2ghz ath5k_channel_2ghz;
+	unsigned int ath5k_channel = channel->chan;
 	u32 data0, data1, clock;
 	int ret;
 
@@ -1174,28 +1174,28 @@ static int ath5k_hw_rf5111_channel(struct ath_hw *hal,
 	if (channel->val & CHANNEL_2GHZ) {
 		/* Map 2GHz channel to 5GHz Atheros channel ID */
 		ret = ath5k_hw_rf5111_chan2athchan(channel->chan,
-				&ath_channel_2ghz);
+				&ath5k_channel_2ghz);
 		if (ret)
 			return ret;
 
-		ath_channel = ath_channel_2ghz.a2_athchan;
-		data0 = ((ath5k_hw_bitswap(ath_channel_2ghz.a2_flags, 8) & 0xff)
+		ath5k_channel = ath5k_channel_2ghz.a2_athchan;
+		data0 = ((ath5k_hw_bitswap(ath5k_channel_2ghz.a2_flags, 8) & 0xff)
 		    << 5) | (1 << 4);
 	}
 
-	if (ath_channel < 145 || !(ath_channel & 1)) {
+	if (ath5k_channel < 145 || !(ath5k_channel & 1)) {
 		clock = 1;
-		data1 = ((ath5k_hw_bitswap(ath_channel - 24, 8) & 0xff) << 2) |
+		data1 = ((ath5k_hw_bitswap(ath5k_channel - 24, 8) & 0xff) << 2) |
 			(clock << 1) | (1 << 10) | 1;
 	} else {
 		clock = 0;
-		data1 = ((ath5k_hw_bitswap((ath_channel - 24) / 2, 8) & 0xff)
+		data1 = ((ath5k_hw_bitswap((ath5k_channel - 24) / 2, 8) & 0xff)
 			<< 2) | (clock << 1) | (1 << 10) | 1;
 	}
 
-	ath5k_hw_reg_write(hal, (data1 & 0xff) | ((data0 & 0xff) << 8),
+	ath5k_hw_reg_write(ah, (data1 & 0xff) | ((data0 & 0xff) << 8),
 			AR5K_RF_BUFFER);
-	ath5k_hw_reg_write(hal, ((data1 >> 8) & 0xff) | (data0 & 0xff00),
+	ath5k_hw_reg_write(ah, ((data1 >> 8) & 0xff) | (data0 & 0xff00),
 			AR5K_RF_BUFFER_CONTROL_3);
 
 	return 0;
@@ -1204,7 +1204,7 @@ static int ath5k_hw_rf5111_channel(struct ath_hw *hal,
 /*
  * Set channel on 5112
  */
-static int ath5k_hw_rf5112_channel(struct ath_hw *hal,
+static int ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	u32 data, data0, data1, data2;
@@ -1243,8 +1243,8 @@ static int ath5k_hw_rf5112_channel(struct ath_hw *hal,
 
 	data = (data0 << 4) | (data1 << 1) | (data2 << 2) | 0x1001;
 
-	ath5k_hw_reg_write(hal, data & 0xff, AR5K_RF_BUFFER);
-	ath5k_hw_reg_write(hal, (data >> 8) & 0x7f, AR5K_RF_BUFFER_CONTROL_5);
+	ath5k_hw_reg_write(ah, data & 0xff, AR5K_RF_BUFFER);
+	ath5k_hw_reg_write(ah, (data >> 8) & 0x7f, AR5K_RF_BUFFER_CONTROL_5);
 
 	return 0;
 }
@@ -1252,7 +1252,7 @@ static int ath5k_hw_rf5112_channel(struct ath_hw *hal,
 /*
  * Set a channel on the radio chip
  */
-int ath5k_hw_channel(struct ath_hw *hal, struct ieee80211_channel *channel)
+int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 {
 	int ret;
 
@@ -1260,10 +1260,10 @@ int ath5k_hw_channel(struct ath_hw *hal, struct ieee80211_channel *channel)
 	 * Check bounds supported by the PHY
 	 * (don't care about regulation restrictions at this point)
 	 */
-	if ((channel->freq < hal->ah_capabilities.cap_range.range_2ghz_min ||
-	    channel->freq > hal->ah_capabilities.cap_range.range_2ghz_max) &&
-	    (channel->freq < hal->ah_capabilities.cap_range.range_5ghz_min ||
-	    channel->freq > hal->ah_capabilities.cap_range.range_5ghz_max)) {
+	if ((channel->freq < ah->ah_capabilities.cap_range.range_2ghz_min ||
+	    channel->freq > ah->ah_capabilities.cap_range.range_2ghz_max) &&
+	    (channel->freq < ah->ah_capabilities.cap_range.range_5ghz_min ||
+	    channel->freq > ah->ah_capabilities.cap_range.range_5ghz_max)) {
 		AR5K_PRINTF("channel out of supported range (%u MHz)\n",
 			channel->freq);
 		return -EINVAL;
@@ -1272,24 +1272,24 @@ int ath5k_hw_channel(struct ath_hw *hal, struct ieee80211_channel *channel)
 	/*
 	 * Set the channel and wait
 	 */
-	switch (hal->ah_radio) {
+	switch (ah->ah_radio) {
 	case AR5K_RF5110:
-		ret = ath5k_hw_rf5110_channel(hal, channel);
+		ret = ath5k_hw_rf5110_channel(ah, channel);
 		break;
 	case AR5K_RF5111:
-		ret = ath5k_hw_rf5111_channel(hal, channel);
+		ret = ath5k_hw_rf5111_channel(ah, channel);
 		break;
 	default:
-		ret = ath5k_hw_rf5112_channel(hal, channel);
+		ret = ath5k_hw_rf5112_channel(ah, channel);
 		break;
 	}
 
 	if (ret)
 		return ret;
 
-	hal->ah_current_channel.freq = channel->freq;
-	hal->ah_current_channel.val = channel->val;
-	hal->ah_turbo = channel->val == CHANNEL_T ? true : false;
+	ah->ah_current_channel.freq = channel->freq;
+	ah->ah_current_channel.val = channel->val;
+	ah->ah_turbo = channel->val == CHANNEL_T ? true : false;
 
 	return 0;
 }
@@ -1303,7 +1303,7 @@ int ath5k_hw_channel(struct ath_hw *hal, struct ieee80211_channel *channel)
  * -Fix BPSK/QAM Constellation (I/Q correction)
  * -Calculate Noise Floor
  */
-static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
+static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	u32 phy_sig, phy_agc, phy_sat, beacon, noise_floor;
@@ -1313,27 +1313,27 @@ static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
 	/*
 	 * Disable beacons and RX/TX queues, wait
 	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_DIAG_SW_5210,
+	AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW_5210,
 		AR5K_DIAG_SW_DIS_TX | AR5K_DIAG_SW_DIS_RX_5210);
-	beacon = ath5k_hw_reg_read(hal, AR5K_BEACON_5210);
-	ath5k_hw_reg_write(hal, beacon & ~AR5K_BEACON_ENABLE, AR5K_BEACON_5210);
+	beacon = ath5k_hw_reg_read(ah, AR5K_BEACON_5210);
+	ath5k_hw_reg_write(ah, beacon & ~AR5K_BEACON_ENABLE, AR5K_BEACON_5210);
 
 	udelay(2300);
 
 	/*
 	 * Set the channel (with AGC turned off)
 	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
 	udelay(10);
-	ret = ath5k_hw_channel(hal, channel);
+	ret = ath5k_hw_channel(ah, channel);
 
 	/*
 	 * Activate PHY and wait
 	 */
-	ath5k_hw_reg_write(hal, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
+	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
 	mdelay(1);
 
-	AR5K_REG_DISABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
+	AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
 
 	if (ret)
 		return ret;
@@ -1343,45 +1343,45 @@ static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
 	 */
 
 	/* Remember normal state */
-	phy_sig = ath5k_hw_reg_read(hal, AR5K_PHY_SIG);
-	phy_agc = ath5k_hw_reg_read(hal, AR5K_PHY_AGCCOARSE);
-	phy_sat = ath5k_hw_reg_read(hal, AR5K_PHY_ADCSAT);
+	phy_sig = ath5k_hw_reg_read(ah, AR5K_PHY_SIG);
+	phy_agc = ath5k_hw_reg_read(ah, AR5K_PHY_AGCCOARSE);
+	phy_sat = ath5k_hw_reg_read(ah, AR5K_PHY_ADCSAT);
 
 	/* Update radio registers */
-	ath5k_hw_reg_write(hal, (phy_sig & ~(AR5K_PHY_SIG_FIRPWR)) |
+	ath5k_hw_reg_write(ah, (phy_sig & ~(AR5K_PHY_SIG_FIRPWR)) |
 		AR5K_REG_SM(-1, AR5K_PHY_SIG_FIRPWR), AR5K_PHY_SIG);
 
-	ath5k_hw_reg_write(hal, (phy_agc & ~(AR5K_PHY_AGCCOARSE_HI |
+	ath5k_hw_reg_write(ah, (phy_agc & ~(AR5K_PHY_AGCCOARSE_HI |
 			AR5K_PHY_AGCCOARSE_LO)) |
 		AR5K_REG_SM(-1, AR5K_PHY_AGCCOARSE_HI) |
 		AR5K_REG_SM(-127, AR5K_PHY_AGCCOARSE_LO), AR5K_PHY_AGCCOARSE);
 
-	ath5k_hw_reg_write(hal, (phy_sat & ~(AR5K_PHY_ADCSAT_ICNT |
+	ath5k_hw_reg_write(ah, (phy_sat & ~(AR5K_PHY_ADCSAT_ICNT |
 			AR5K_PHY_ADCSAT_THR)) |
 		AR5K_REG_SM(2, AR5K_PHY_ADCSAT_ICNT) |
 		AR5K_REG_SM(12, AR5K_PHY_ADCSAT_THR), AR5K_PHY_ADCSAT);
 
 	udelay(20);
 
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
 	udelay(10);
-	ath5k_hw_reg_write(hal, AR5K_PHY_RFSTG_DISABLE, AR5K_PHY_RFSTG);
-	AR5K_REG_DISABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
+	ath5k_hw_reg_write(ah, AR5K_PHY_RFSTG_DISABLE, AR5K_PHY_RFSTG);
+	AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
 
 	mdelay(1);
 
 	/*
 	 * Enable calibration and wait until completion
 	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_CAL);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_CAL);
 
-	ret = ath5k_hw_register_timeout(hal, AR5K_PHY_AGCCTL,
+	ret = ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
 			AR5K_PHY_AGCCTL_CAL, 0, false);
 
 	/* Reset to normal state */
-	ath5k_hw_reg_write(hal, phy_sig, AR5K_PHY_SIG);
-	ath5k_hw_reg_write(hal, phy_agc, AR5K_PHY_AGCCOARSE);
-	ath5k_hw_reg_write(hal, phy_sat, AR5K_PHY_ADCSAT);
+	ath5k_hw_reg_write(ah, phy_sig, AR5K_PHY_SIG);
+	ath5k_hw_reg_write(ah, phy_agc, AR5K_PHY_AGCCOARSE);
+	ath5k_hw_reg_write(ah, phy_sat, AR5K_PHY_ADCSAT);
 
 	if (ret) {
 		AR5K_PRINTF("calibration timeout (%uMHz)\n", channel->freq);
@@ -1391,9 +1391,9 @@ static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
 	/*
 	 * Enable noise floor calibration and wait until completion
 	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
 
-	ret = ath5k_hw_register_timeout(hal, AR5K_PHY_AGCCTL,
+	ret = ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
 			AR5K_PHY_AGCCTL_NF, 0, false);
 	if (ret) {
 		AR5K_PRINTF("noise floor calibration timeout (%uMHz)\n",
@@ -1404,7 +1404,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
 	/* Wait until the noise floor is calibrated */
 	for (i = 20; i > 0; i--) {
 		mdelay(1);
-		noise_floor = ath5k_hw_reg_read(hal, AR5K_PHY_NF);
+		noise_floor = ath5k_hw_reg_read(ah, AR5K_PHY_NF);
 
 		if (AR5K_PHY_NF_RVAL(noise_floor) & AR5K_PHY_NF_ACTIVE)
 			noise_floor = AR5K_PHY_NF_AVAL(noise_floor);
@@ -1422,9 +1422,9 @@ static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
 	/*
 	 * Re-enable RX/TX and beacons
 	 */
-	AR5K_REG_DISABLE_BITS(hal, AR5K_DIAG_SW_5210,
+	AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW_5210,
 		AR5K_DIAG_SW_DIS_TX | AR5K_DIAG_SW_DIS_RX_5210);
-	ath5k_hw_reg_write(hal, beacon, AR5K_BEACON_5210);
+	ath5k_hw_reg_write(ah, beacon, AR5K_BEACON_5210);
 
 	return 0;
 }
@@ -1432,22 +1432,22 @@ static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
 /*
  * Perform a PHY calibration on RF5111/5112
  */
-static int ath5k_hw_rf511x_calibrate(struct ath_hw *hal,
+static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	u32 i_pwr, q_pwr;
 	s32 iq_corr, i_coff, i_coffd, q_coff, q_coffd;
 	AR5K_TRACE;
 
-	if (hal->ah_calibration == false ||
-			ath5k_hw_reg_read(hal, AR5K_PHY_IQ) & AR5K_PHY_IQ_RUN)
+	if (ah->ah_calibration == false ||
+			ath5k_hw_reg_read(ah, AR5K_PHY_IQ) & AR5K_PHY_IQ_RUN)
 		goto done;
 
-	hal->ah_calibration = false;
+	ah->ah_calibration = false;
 
-	iq_corr = ath5k_hw_reg_read(hal, AR5K_PHY_IQRES_CAL_CORR);
-	i_pwr = ath5k_hw_reg_read(hal, AR5K_PHY_IQRES_CAL_PWR_I);
-	q_pwr = ath5k_hw_reg_read(hal, AR5K_PHY_IQRES_CAL_PWR_Q);
+	iq_corr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_CORR);
+	i_pwr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_PWR_I);
+	q_pwr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_PWR_Q);
 	i_coffd = ((i_pwr >> 1) + (q_pwr >> 1)) >> 7;
 	q_coffd = q_pwr >> 6;
 
@@ -1458,19 +1458,19 @@ static int ath5k_hw_rf511x_calibrate(struct ath_hw *hal,
 	q_coff = (((s32)i_pwr / q_coffd) - 64) & 0x1f;
 
 	/* Commit new IQ value */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_ENABLE |
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_ENABLE |
 		((u32)q_coff) | ((u32)i_coff << AR5K_PHY_IQ_CORR_Q_I_COFF_S));
 
 done:
 	/* Start noise floor calibration */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
+	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
 
 	/* Request RF gain */
 	if (channel->val & CHANNEL_5GHZ) {
-		ath5k_hw_reg_write(hal, AR5K_REG_SM(hal->ah_txpower.txp_max,
+		ath5k_hw_reg_write(ah, AR5K_REG_SM(ah->ah_txpower.txp_max,
 			AR5K_PHY_PAPD_PROBE_TXPOWER) |
 			AR5K_PHY_PAPD_PROBE_TX_NEXT, AR5K_PHY_PAPD_PROBE);
-		hal->ah_rf_gain = AR5K_RFGAIN_READ_REQUESTED;
+		ah->ah_rf_gain = AR5K_RFGAIN_READ_REQUESTED;
 	}
 
 	return 0;
@@ -1479,24 +1479,24 @@ done:
 /*
  * Perform a PHY calibration
  */
-int ath5k_hw_phy_calibrate(struct ath_hw *hal,
+int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	int ret;
 
-	if (hal->ah_radio == AR5K_RF5110)
-		ret = ath5k_hw_rf5110_calibrate(hal, channel);
+	if (ah->ah_radio == AR5K_RF5110)
+		ret = ath5k_hw_rf5110_calibrate(ah, channel);
 	else
-		ret = ath5k_hw_rf511x_calibrate(hal, channel);
+		ret = ath5k_hw_rf511x_calibrate(ah, channel);
 
 	return ret;
 }
 
-int ath5k_hw_phy_disable(struct ath_hw *hal)
+int ath5k_hw_phy_disable(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
 	/*Just a try M.F.*/
-	ath5k_hw_reg_write(hal, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
+	ath5k_hw_reg_write(ah, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
 
 	return 0;
 }
@@ -1508,7 +1508,7 @@ int ath5k_hw_phy_disable(struct ath_hw *hal)
 /*
  * Get the PHY Chip revision
  */
-u16 ath5k_hw_radio_revision(struct ath_hw *hal, unsigned int chan)
+u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan)
 {
 	unsigned int i;
 	u32 srev;
@@ -1521,10 +1521,10 @@ u16 ath5k_hw_radio_revision(struct ath_hw *hal, unsigned int chan)
 	 */
 	switch (chan) {
 	case CHANNEL_2GHZ:
-		ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_2GHZ, AR5K_PHY(0));
+		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_2GHZ, AR5K_PHY(0));
 		break;
 	case CHANNEL_5GHZ:
-		ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
+		ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
 		break;
 	default:
 		return 0;
@@ -1533,41 +1533,41 @@ u16 ath5k_hw_radio_revision(struct ath_hw *hal, unsigned int chan)
 	mdelay(2);
 
 	/* ...wait until PHY is ready and read the selected radio revision */
-	ath5k_hw_reg_write(hal, 0x00001c16, AR5K_PHY(0x34));
+	ath5k_hw_reg_write(ah, 0x00001c16, AR5K_PHY(0x34));
 
 	for (i = 0; i < 8; i++)
-		ath5k_hw_reg_write(hal, 0x00010000, AR5K_PHY(0x20));
+		ath5k_hw_reg_write(ah, 0x00010000, AR5K_PHY(0x20));
 
-	if (hal->ah_version == AR5K_AR5210) {
-		srev = ath5k_hw_reg_read(hal, AR5K_PHY(256) >> 28) & 0xf;
+	if (ah->ah_version == AR5K_AR5210) {
+		srev = ath5k_hw_reg_read(ah, AR5K_PHY(256) >> 28) & 0xf;
 		ret = (u16)ath5k_hw_bitswap(srev, 4) + 1;
 	} else {
-		srev = (ath5k_hw_reg_read(hal, AR5K_PHY(0x100)) >> 24) & 0xff;
+		srev = (ath5k_hw_reg_read(ah, AR5K_PHY(0x100)) >> 24) & 0xff;
 		ret = (u16)ath5k_hw_bitswap(((srev & 0xf0) >> 4) |
 				((srev & 0x0f) << 4), 8);
 	}
 
 	/* Reset to the 5GHz mode */
-	ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
+	ath5k_hw_reg_write(ah, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
 
 	return ret;
 }
 
 void /*TODO:Boundary check*/
-ath5k_hw_set_def_antenna(struct ath_hw *hal, unsigned int ant)
+ath5k_hw_set_def_antenna(struct ath5k_hw *ah, unsigned int ant)
 {
 	AR5K_TRACE;
 	/*Just a try M.F.*/
-	if (hal->ah_version != AR5K_AR5210)
-		ath5k_hw_reg_write(hal, ant, AR5K_DEFAULT_ANTENNA);
+	if (ah->ah_version != AR5K_AR5210)
+		ath5k_hw_reg_write(ah, ant, AR5K_DEFAULT_ANTENNA);
 }
 
-unsigned int ath5k_hw_get_def_antenna(struct ath_hw *hal)
+unsigned int ath5k_hw_get_def_antenna(struct ath5k_hw *ah)
 {
 	AR5K_TRACE;
 	/*Just a try M.F.*/
-	if (hal->ah_version != AR5K_AR5210)
-		return ath5k_hw_reg_read(hal, AR5K_DEFAULT_ANTENNA);
+	if (ah->ah_version != AR5K_AR5210)
+		return ath5k_hw_reg_read(ah, AR5K_DEFAULT_ANTENNA);
 
 	return false; /*XXX: What do we return for 5210 ?*/
 }
@@ -1579,13 +1579,13 @@ unsigned int ath5k_hw_get_def_antenna(struct ath_hw *hal)
 /*
  * Initialize the tx power table (not fully implemented)
  */
-static void ath5k_txpower_table(struct ath_hw *hal,
+static void ath5k_txpower_table(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel, s16 max_power)
 {
 	unsigned int i, min, max, n;
 	u16 txpower, *rates;
 
-	rates = hal->ah_txpower.txp_rates;
+	rates = ah->ah_txpower.txp_rates;
 
 	txpower = AR5K_TUNE_DEFAULT_TXPOWER * 2;
 	if (max_power > txpower)
@@ -1597,16 +1597,16 @@ static void ath5k_txpower_table(struct ath_hw *hal,
 
 	/* XXX setup target powers by rate */
 
-	hal->ah_txpower.txp_min = rates[7];
-	hal->ah_txpower.txp_max = rates[0];
-	hal->ah_txpower.txp_ofdm = rates[0];
+	ah->ah_txpower.txp_min = rates[7];
+	ah->ah_txpower.txp_max = rates[0];
+	ah->ah_txpower.txp_ofdm = rates[0];
 
 	/* Calculate the power table */
-	n = ARRAY_SIZE(hal->ah_txpower.txp_pcdac);
+	n = ARRAY_SIZE(ah->ah_txpower.txp_pcdac);
 	min = AR5K_EEPROM_PCDAC_START;
 	max = AR5K_EEPROM_PCDAC_STOP;
 	for (i = 0; i < n; i += AR5K_EEPROM_PCDAC_STEP)
-		hal->ah_txpower.txp_pcdac[i] =
+		ah->ah_txpower.txp_pcdac[i] =
 #ifdef notyet
 		min + ((i * (max - min)) / n);
 #else
@@ -1618,10 +1618,10 @@ static void ath5k_txpower_table(struct ath_hw *hal,
  * Set transmition power
  */
 int /*O.K. - txpower_table is unimplemented so this doesn't work*/
-ath5k_hw_txpower(struct ath_hw *hal, struct ieee80211_channel *channel,
+ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		unsigned int txpower)
 {
-	bool tpc = hal->ah_txpower.txp_tpc;
+	bool tpc = ah->ah_txpower.txp_tpc;
 	unsigned int i;
 
 	AR5K_TRACE;
@@ -1631,56 +1631,56 @@ ath5k_hw_txpower(struct ath_hw *hal, struct ieee80211_channel *channel,
 	}
 
 	/* Reset TX power values */
-	memset(&hal->ah_txpower, 0, sizeof(hal->ah_txpower));
-	hal->ah_txpower.txp_tpc = tpc;
+	memset(&ah->ah_txpower, 0, sizeof(ah->ah_txpower));
+	ah->ah_txpower.txp_tpc = tpc;
 
 	/* Initialize TX power table */
-	ath5k_txpower_table(hal, channel, txpower);
+	ath5k_txpower_table(ah, channel, txpower);
 
 	/*
 	 * Write TX power values
 	 */
 	for (i = 0; i < (AR5K_EEPROM_POWER_TABLE_SIZE / 2); i++) {
-		ath5k_hw_reg_write(hal,
-			((((hal->ah_txpower.txp_pcdac[(i << 1) + 1] << 8) | 0xff) & 0xffff) << 16) |
-			(((hal->ah_txpower.txp_pcdac[(i << 1)    ] << 8) | 0xff) & 0xffff),
+		ath5k_hw_reg_write(ah,
+			((((ah->ah_txpower.txp_pcdac[(i << 1) + 1] << 8) | 0xff) & 0xffff) << 16) |
+			(((ah->ah_txpower.txp_pcdac[(i << 1)    ] << 8) | 0xff) & 0xffff),
 			AR5K_PHY_PCDAC_TXPOWER(i));
 	}
 
-	ath5k_hw_reg_write(hal, AR5K_TXPOWER_OFDM(3, 24) |
+	ath5k_hw_reg_write(ah, AR5K_TXPOWER_OFDM(3, 24) |
 		AR5K_TXPOWER_OFDM(2, 16) | AR5K_TXPOWER_OFDM(1, 8) |
 		AR5K_TXPOWER_OFDM(0, 0), AR5K_PHY_TXPOWER_RATE1);
 
-	ath5k_hw_reg_write(hal, AR5K_TXPOWER_OFDM(7, 24) |
+	ath5k_hw_reg_write(ah, AR5K_TXPOWER_OFDM(7, 24) |
 		AR5K_TXPOWER_OFDM(6, 16) | AR5K_TXPOWER_OFDM(5, 8) |
 		AR5K_TXPOWER_OFDM(4, 0), AR5K_PHY_TXPOWER_RATE2);
 
-	ath5k_hw_reg_write(hal, AR5K_TXPOWER_CCK(10, 24) |
+	ath5k_hw_reg_write(ah, AR5K_TXPOWER_CCK(10, 24) |
 		AR5K_TXPOWER_CCK(9, 16) | AR5K_TXPOWER_CCK(15, 8) |
 		AR5K_TXPOWER_CCK(8, 0), AR5K_PHY_TXPOWER_RATE3);
 
-	ath5k_hw_reg_write(hal, AR5K_TXPOWER_CCK(14, 24) |
+	ath5k_hw_reg_write(ah, AR5K_TXPOWER_CCK(14, 24) |
 		AR5K_TXPOWER_CCK(13, 16) | AR5K_TXPOWER_CCK(12, 8) |
 		AR5K_TXPOWER_CCK(11, 0), AR5K_PHY_TXPOWER_RATE4);
 
-	if (hal->ah_txpower.txp_tpc == true)
-		ath5k_hw_reg_write(hal, AR5K_PHY_TXPOWER_RATE_MAX_TPC_ENABLE |
+	if (ah->ah_txpower.txp_tpc == true)
+		ath5k_hw_reg_write(ah, AR5K_PHY_TXPOWER_RATE_MAX_TPC_ENABLE |
 			AR5K_TUNE_MAX_TXPOWER, AR5K_PHY_TXPOWER_RATE_MAX);
 	else
-		ath5k_hw_reg_write(hal, AR5K_PHY_TXPOWER_RATE_MAX |
+		ath5k_hw_reg_write(ah, AR5K_PHY_TXPOWER_RATE_MAX |
 			AR5K_TUNE_MAX_TXPOWER, AR5K_PHY_TXPOWER_RATE_MAX);
 
 	return 0;
 }
 
-int ath5k_hw_set_txpower_limit(struct ath_hw *hal, unsigned int power)
+int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, unsigned int power)
 {
 	/*Just a try M.F.*/
-	struct ieee80211_channel *channel = &hal->ah_current_channel;
+	struct ieee80211_channel *channel = &ah->ah_current_channel;
 
 	AR5K_TRACE;
 #ifdef AR5K_DEBUG
 	AR5K_PRINTF("changing txpower to %d\n", power);
 #endif
-	return ath5k_hw_txpower(hal, channel, power);
+	return ath5k_hw_txpower(ah, channel, power);
 }
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index 1537517..7b75f14 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -999,7 +999,7 @@
  */
 #define AR5K_EEPROM_DATA_5211	0x6004
 #define AR5K_EEPROM_DATA_5210	0x6800
-#define	AR5K_EEPROM_DATA	(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_EEPROM_DATA	(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_EEPROM_DATA_5210 : AR5K_EEPROM_DATA_5211)
 
 /*
@@ -1015,7 +1015,7 @@
  */
 #define AR5K_EEPROM_STAT_5210	0x6c00			/* Register Address [5210] */
 #define AR5K_EEPROM_STAT_5211	0x600c			/* Register Address [5211+] */
-#define	AR5K_EEPROM_STATUS	(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_EEPROM_STATUS	(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_EEPROM_STAT_5210 : AR5K_EEPROM_STAT_5211)
 #define AR5K_EEPROM_STAT_RDERR	0x00000001	/* EEPROM read failed */
 #define AR5K_EEPROM_STAT_RDDONE	0x00000002	/* EEPROM read successful */
@@ -1055,7 +1055,7 @@
 #define AR5K_STA_ID1_NO_PSPOLL		0x00100000	/* No power save polling [5210] */
 #define AR5K_STA_ID1_PCF_5211		0x00100000	/* Enable PCF on [5211+] */
 #define AR5K_STA_ID1_PCF_5210		0x00200000	/* Enable PCF on [5210]*/
-#define	AR5K_STA_ID1_PCF		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_STA_ID1_PCF		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_STA_ID1_PCF_5210 : AR5K_STA_ID1_PCF_5211)
 #define AR5K_STA_ID1_DEFAULT_ANTENNA	0x00200000	/* Use default antenna */
 #define AR5K_STA_ID1_DESC_ANTENNA	0x00400000	/* Update antenna from descriptor */
@@ -1100,7 +1100,7 @@
 #define AR5K_RSSI_THR_BMISS_5210_S	8
 #define AR5K_RSSI_THR_BMISS_5211	0x0000ff00	/* Mask for Beacon Missed threshold [5211+] */
 #define AR5K_RSSI_THR_BMISS_5211_S	8
-#define	AR5K_RSSI_THR_BMISS		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_RSSI_THR_BMISS		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_RSSI_THR_BMISS_5210 : AR5K_RSSI_THR_BMISS_5211)
 #define	AR5K_RSSI_THR_BMISS_S		8
 
@@ -1108,7 +1108,7 @@
  * 5210 has more PCU registers because there is no QCU/DCU
  * so queue parameters are set here, this way a lot common
  * registers have different address for 5210. To make things
- * easier we define a macro based on hal->ah_version for common
+ * easier we define a macro based on ah->ah_version for common
  * registers with different addresses and common flags.
  */
 
@@ -1134,7 +1134,7 @@
  */
 #define AR5K_USEC_5210			0x8020			/* Register Address [5210] */
 #define AR5K_USEC_5211			0x801c			/* Register Address [5211+] */
-#define AR5K_USEC			(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_USEC			(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_USEC_5210 : AR5K_USEC_5211)
 #define AR5K_USEC_1			0x0000007f
 #define AR5K_USEC_1_S			0
@@ -1154,7 +1154,7 @@
  */
 #define AR5K_BEACON_5210	0x8024
 #define AR5K_BEACON_5211	0x8020
-#define AR5K_BEACON		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_BEACON		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_BEACON_5210 : AR5K_BEACON_5211)
 #define AR5K_BEACON_PERIOD	0x0000ffff
 #define AR5K_BEACON_PERIOD_S	0
@@ -1168,7 +1168,7 @@
  */
 #define AR5K_CFP_PERIOD_5210	0x8028
 #define AR5K_CFP_PERIOD_5211	0x8024
-#define AR5K_CFP_PERIOD		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_CFP_PERIOD		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_CFP_PERIOD_5210 : AR5K_CFP_PERIOD_5211)
 
 /*
@@ -1176,7 +1176,7 @@
  */
 #define AR5K_TIMER0_5210	0x802c
 #define AR5K_TIMER0_5211	0x8028
-#define AR5K_TIMER0		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_TIMER0		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_TIMER0_5210 : AR5K_TIMER0_5211)
 
 /*
@@ -1184,7 +1184,7 @@
  */
 #define AR5K_TIMER1_5210	0x8030
 #define AR5K_TIMER1_5211	0x802c
-#define AR5K_TIMER1		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_TIMER1		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_TIMER1_5210 : AR5K_TIMER1_5211)
 
 /*
@@ -1192,7 +1192,7 @@
  */
 #define AR5K_TIMER2_5210	0x8034
 #define AR5K_TIMER2_5211	0x8030
-#define AR5K_TIMER2		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_TIMER2		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_TIMER2_5210 : AR5K_TIMER2_5211)
 
 /*
@@ -1200,7 +1200,7 @@
  */
 #define AR5K_TIMER3_5210	0x8038
 #define AR5K_TIMER3_5211	0x8034
-#define AR5K_TIMER3		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_TIMER3		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_TIMER3_5210 : AR5K_TIMER3_5211)
 
 
@@ -1229,7 +1229,7 @@
  */
 #define AR5K_CFP_DUR_5210	0x8048
 #define AR5K_CFP_DUR_5211	0x8038
-#define AR5K_CFP_DUR		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_CFP_DUR		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_CFP_DUR_5210 : AR5K_CFP_DUR_5211)
 
 /*
@@ -1264,7 +1264,7 @@
  */
 #define AR5K_MCAST_FILTER0_5210	0x8050
 #define AR5K_MCAST_FILTER0_5211	0x8040
-#define AR5K_MCAST_FILTER0	(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_MCAST_FILTER0	(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_MCAST_FILTER0_5210 : AR5K_MCAST_FILTER0_5211)
 
 /*
@@ -1272,7 +1272,7 @@
  */
 #define AR5K_MCAST_FILTER1_5210	0x8054
 #define AR5K_MCAST_FILTER1_5211	0x8044
-#define AR5K_MCAST_FILTER1	(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_MCAST_FILTER1	(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_MCAST_FILTER1_5210 : AR5K_MCAST_FILTER1_5211)
 
 
@@ -1305,7 +1305,7 @@
  */
 #define AR5K_DIAG_SW_5210		0x8068			/* Register Address [5210] */
 #define AR5K_DIAG_SW_5211		0x8048			/* Register Address [5211+] */
-#define AR5K_DIAG_SW			(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_DIAG_SW			(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_5210 : AR5K_DIAG_SW_5211)
 #define AR5K_DIAG_SW_DIS_WEP_ACK	0x00000001
 #define AR5K_DIAG_SW_DIS_ACK		0x00000002	/* Disable ACKs (?) */
@@ -1315,23 +1315,23 @@
 #define AR5K_DIAG_SW_DIS_TX		0x00000020	/* Disable transmit [5210] */
 #define AR5K_DIAG_SW_DIS_RX_5210	0x00000040	/* Disable recieve */
 #define AR5K_DIAG_SW_DIS_RX_5211	0x00000020
-#define	AR5K_DIAG_SW_DIS_RX		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_DIAG_SW_DIS_RX		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_DIS_RX_5210 : AR5K_DIAG_SW_DIS_RX_5211)
 #define AR5K_DIAG_SW_LOOP_BACK_5210	0x00000080	/* Loopback (i guess it goes with DIS_TX) [5210] */
 #define AR5K_DIAG_SW_LOOP_BACK_5211	0x00000040
-#define AR5K_DIAG_SW_LOOP_BACK		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_DIAG_SW_LOOP_BACK		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_LOOP_BACK_5210 : AR5K_DIAG_SW_LOOP_BACK_5211)
 #define AR5K_DIAG_SW_CORR_FCS_5210	0x00000100
 #define AR5K_DIAG_SW_CORR_FCS_5211	0x00000080
-#define AR5K_DIAG_SW_CORR_FCS		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_DIAG_SW_CORR_FCS		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_CORR_FCS_5210 : AR5K_DIAG_SW_CORR_FCS_5211)
 #define AR5K_DIAG_SW_CHAN_INFO_5210	0x00000200
 #define AR5K_DIAG_SW_CHAN_INFO_5211	0x00000100
-#define AR5K_DIAG_SW_CHAN_INFO		(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_DIAG_SW_CHAN_INFO		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_CHAN_INFO_5210 : AR5K_DIAG_SW_CHAN_INFO_5211)
 #define AR5K_DIAG_SW_EN_SCRAM_SEED_5211	0x00000200	/* Scrambler seed (?) */
 #define AR5K_DIAG_SW_EN_SCRAM_SEED_5210	0x00000400
-#define AR5K_DIAG_SW_EN_SCRAM_SEED	(hal->ah_version == AR5K_AR5210 ? \
+#define AR5K_DIAG_SW_EN_SCRAM_SEED	(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_EN_SCRAM_SEED_5210 : AR5K_DIAG_SW_EN_SCRAM_SEED_5211)
 #define AR5K_DIAG_SW_ECO_ENABLE		0x00000400	/* [5211+] */
 #define AR5K_DIAG_SW_SCVRAM_SEED	0x0003f800	/* [5210] */
@@ -1340,7 +1340,7 @@
 #define AR5K_DIAG_SW_DIS_SEQ_INC	0x00040000	/* Disable seqnum increment (?)[5210] */
 #define AR5K_DIAG_SW_FRAME_NV0_5210	0x00080000
 #define AR5K_DIAG_SW_FRAME_NV0_5211	0x00020000
-#define	AR5K_DIAG_SW_FRAME_NV0		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_DIAG_SW_FRAME_NV0		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_FRAME_NV0_5210 : AR5K_DIAG_SW_FRAME_NV0_5211)
 #define AR5K_DIAG_SW_OBSPT_M		0x000c0000
 #define AR5K_DIAG_SW_OBSPT_S		18
@@ -1350,7 +1350,7 @@
  */
 #define AR5K_TSF_L32_5210	0x806c
 #define AR5K_TSF_L32_5211	0x804c
-#define	AR5K_TSF_L32		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_TSF_L32		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_TSF_L32_5210 : AR5K_TSF_L32_5211)
 
 /*
@@ -1358,7 +1358,7 @@
  */
 #define AR5K_TSF_U32_5210	0x8070
 #define AR5K_TSF_U32_5211	0x8050
-#define	AR5K_TSF_U32		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_TSF_U32		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_TSF_U32_5210 : AR5K_TSF_U32_5211)
 
 /*
@@ -1400,7 +1400,7 @@
  */
 #define AR5K_NAV_5210		0x808c
 #define AR5K_NAV_5211		0x8084
-#define	AR5K_NAV		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_NAV		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_NAV_5210 : AR5K_NAV_5211)
 
 /*
@@ -1408,7 +1408,7 @@
  */
 #define AR5K_RTS_OK_5210	0x8090
 #define AR5K_RTS_OK_5211	0x8088
-#define	AR5K_RTS_OK		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_RTS_OK		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_RTS_OK_5210 : AR5K_RTS_OK_5211)
 
 /*
@@ -1416,7 +1416,7 @@
  */
 #define AR5K_RTS_FAIL_5210	0x8094
 #define AR5K_RTS_FAIL_5211	0x808c
-#define	AR5K_RTS_FAIL		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_RTS_FAIL		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_RTS_FAIL_5210 : AR5K_RTS_FAIL_5211)
 
 /*
@@ -1424,7 +1424,7 @@
  */
 #define AR5K_ACK_FAIL_5210	0x8098
 #define AR5K_ACK_FAIL_5211	0x8090
-#define	AR5K_ACK_FAIL		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_ACK_FAIL		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_ACK_FAIL_5210 : AR5K_ACK_FAIL_5211)
 
 /*
@@ -1432,7 +1432,7 @@
  */
 #define AR5K_FCS_FAIL_5210	0x809c
 #define AR5K_FCS_FAIL_5211	0x8094
-#define	AR5K_FCS_FAIL		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_FCS_FAIL		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_FCS_FAIL_5210 : AR5K_FCS_FAIL_5211)
 
 /*
@@ -1440,7 +1440,7 @@
  */
 #define AR5K_BEACON_CNT_5210	0x80a0
 #define AR5K_BEACON_CNT_5211	0x8098
-#define	AR5K_BEACON_CNT		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_BEACON_CNT		(ah->ah_version == AR5K_AR5210 ? \
 				AR5K_BEACON_CNT_5210 : AR5K_BEACON_CNT_5211)
 
 
@@ -1576,7 +1576,7 @@
 #define AR5K_KEYTABLE_0_5211		0x8800
 #define AR5K_KEYTABLE_5210(_n)		(AR5K_KEYTABLE_0_5210 + ((_n) << 5))
 #define AR5K_KEYTABLE_5211(_n)		(AR5K_KEYTABLE_0_5211 + ((_n) << 5))
-#define	AR5K_KEYTABLE(_n)		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_KEYTABLE(_n)		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_KEYTABLE_5210(_n) : AR5K_KEYTABLE_5211(_n))
 #define AR5K_KEYTABLE_OFF(_n, x)	(AR5K_KEYTABLE(_n) + (x << 2))
 #define AR5K_KEYTABLE_TYPE(_n)		AR5K_KEYTABLE_OFF(_n, 5)
@@ -1606,7 +1606,7 @@
  */
 #define AR5K_KEYTABLE_SIZE_5210		64
 #define AR5K_KEYTABLE_SIZE_5211		128
-#define	AR5K_KEYTABLE_SIZE		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_KEYTABLE_SIZE		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_KEYTABLE_SIZE_5210 : AR5K_KEYTABLE_SIZE_5211)
 
 
@@ -1722,11 +1722,11 @@
 #define	AR5K_PHY_PLL_20MHZ		0x13	/* For half rate (?) [5111+] */
 #define	AR5K_PHY_PLL_40MHZ_5211		0x18	/* For 802.11a */
 #define	AR5K_PHY_PLL_40MHZ_5212		0x000000aa
-#define	AR5K_PHY_PLL_40MHZ		(hal->ah_version == AR5K_AR5211 ? \
+#define	AR5K_PHY_PLL_40MHZ		(ah->ah_version == AR5K_AR5211 ? \
 					AR5K_PHY_PLL_40MHZ_5211 : AR5K_PHY_PLL_40MHZ_5212)
 #define	AR5K_PHY_PLL_44MHZ_5211		0x19	/* For 802.11b/g */
 #define	AR5K_PHY_PLL_44MHZ_5212		0x000000ab
-#define	AR5K_PHY_PLL_44MHZ		(hal->ah_version == AR5K_AR5211 ? \
+#define	AR5K_PHY_PLL_44MHZ		(ah->ah_version == AR5K_AR5211 ? \
 					AR5K_PHY_PLL_44MHZ_5211 : AR5K_PHY_PLL_44MHZ_5212)
 #define AR5K_PHY_PLL_RF5111		0x00000000
 #define AR5K_PHY_PLL_RF5112		0x00000040
@@ -1845,7 +1845,7 @@
  */
 #define	AR5K_PHY_FRAME_CTL_5210		0x9804
 #define	AR5K_PHY_FRAME_CTL_5211		0x9944
-#define	AR5K_PHY_FRAME_CTL		(hal->ah_version == AR5K_AR5210 ? \
+#define	AR5K_PHY_FRAME_CTL		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_PHY_FRAME_CTL_5210 : AR5K_PHY_FRAME_CTL_5211)
 /*---[5111+]---*/
 #define	AR5K_PHY_FRAME_CTL_TX_CLIP	0x00000038


