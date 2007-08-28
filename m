Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47720 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbXH1P6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 11:58:52 -0400
Message-id: <2713029743177393055@pripojeni.net>
Subject: [PATCH 1/5] Net: ath5k, split hw into hw, phy and initvals
From: Jiri Slaby <jirislaby@gmail.com>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Date: Tue, 28 Aug 2007 11:58:52 -0400
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k, split hw into hw, phy and initvals

Separate the hw code into logical pieces hw, phy and initvals for better
readability and maintainability.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit f65aa1c7d680d1bcde1ae20749eeda6d3ec02652
tree d7bb663be32d81a32431d9d0e0c775ddb67bf6cf
parent 49fa12761f1fef6f0e6bf7d8ef7e599c5eef6871
author Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 16:23:29 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 28 Aug 2007 16:23:29 +0200

 drivers/net/wireless/Makefile           |    3 
 drivers/net/wireless/ath5k.h            |  221 ++--
 drivers/net/wireless/ath5k_hw.c         | 1306 ------------------------
 drivers/net/wireless/ath5k_hw.h         | 1513 ----------------------------
 drivers/net/wireless/ath5k_hw_inivals.c | 1090 ++++++++++++++++++++
 drivers/net/wireless/ath5k_hw_phy.c     | 1674 +++++++++++++++++++++++++++++++
 6 files changed, 2889 insertions(+), 2918 deletions(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index ded8c68..e808889 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -109,4 +109,5 @@ $(obj)/iwl-base-4965.o: $(src)/iwl-base.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
 obj-$(CONFIG_ATH5K)	+= ath5k.o
-ath5k-objs		= ath5k_base.o ath5k_hw.o ath5k_regdom.o
+ath5k-objs		= ath5k_base.o ath5k_hw.o ath5k_regdom.o \
+			  ath5k_hw_phy.o ath5k_hw_inivals.o
diff --git a/drivers/net/wireless/ath5k.h b/drivers/net/wireless/ath5k.h
index 78d7cb2..0bb62dc 100644
--- a/drivers/net/wireless/ath5k.h
+++ b/drivers/net/wireless/ath5k.h
@@ -28,6 +28,7 @@
 /* Uncomment this for debuging (warning that it results in TOO much output) */
 /*#define AR5K_DEBUG	1 */
 
+#include <linux/io.h>
 #include <linux/types.h>
 #include <net/mac80211.h>
 
@@ -125,42 +126,6 @@ enum ath5k_radio {
 /*
  * Common silicon revision/version values
  */
-enum ath5k_srev_type {
-	AR5K_VERSION_VER,
-	AR5K_VERSION_REV,
-	AR5K_VERSION_RAD,
-	AR5K_VERSION_DEV
-};
-
-struct ath5k_srev_name {
-	const char		*sr_name;
-	enum ath5k_srev_type	sr_type;
-	u_int			sr_val;
-};
-
-#define AR5K_SREV_NAME	{						\
-	{ "5210",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5210 },	\
-	{ "5311",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5311 },	\
-	{ "5311a",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5311A },\
-	{ "5311b",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5311B },\
-	{ "5211",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5211 },	\
-	{ "5212",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5212 },	\
-	{ "5213",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5213 },	\
-	{ "xxxx",	AR5K_VERSION_VER,	AR5K_SREV_UNKNOWN },	\
-	{ "5110",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5110 },	\
-	{ "5111",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5111 },	\
-	{ "2111",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2111 },	\
-	{ "5112",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5112 },	\
-	{ "5112a",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5112A },	\
-	{ "2112",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2112 },	\
-	{ "2112a",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2112A },	\
-	{ "xxxx",	AR5K_VERSION_RAD,	AR5K_SREV_UNKNOWN },	\
-	{ "2413",	AR5K_VERSION_DEV,	PCI_DEVICE_ID_ATHEROS_AR2413 },\
-	{ "5413",	AR5K_VERSION_DEV,	PCI_DEVICE_ID_ATHEROS_AR5413 },\
-	{ "5424",	AR5K_VERSION_DEV,	PCI_DEVICE_ID_ATHEROS_AR5424 },\
-	{ "xxxx",	AR5K_VERSION_DEV,	AR5K_SREV_UNKNOWN }	\
-}
-
 #define AR5K_SREV_UNKNOWN	0xffff
 
 #define AR5K_SREV_VER_AR5210	0x00
@@ -182,7 +147,6 @@ struct ath5k_srev_name {
 #define AR5K_SREV_RAD_2112A	0x45
 #define AR5K_SREV_RAD_UNSUPP	0x50
 
-
 /* IEEE defs */
 
 #define IEEE80211_MAX_LEN       2500
@@ -685,12 +649,6 @@ struct ath5k_rate_table {
 } while (0)
 
 
-struct ath5k_node_stats {
-	u32	ns_avgbrssi;	/* average beacon rssi */
-	u32	ns_avgrssi;	/* average data rssi */
-	u32	ns_avgtxrssi;	/* average tx rssi */
-};
-
 enum ath5k_ant_setting {
 	AR5K_ANT_VARIABLE	= 0,	/* variable by programming */
 	AR5K_ANT_FIXED_A	= 1,	/* fixed to 11a frequencies */
@@ -944,101 +902,128 @@ struct ath_hw {
 /*
  * Prototypes
  */
+
+/* General Functions */
+extern int ath5k_hw_register_timeout(struct ath_hw *hal, u32 reg, u32 flag, u32 val, bool is_set);
 /* Attach/Detach Functions */
-struct ath_hw *ath5k_hw_attach(u16 device, u8 macversion, void *sc, void __iomem *sh);
-const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath_hw *hal, unsigned int mode);
-void ath5k_hw_detach(struct ath_hw *hal);
+extern struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc, void __iomem *sh);
+extern const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath_hw *hal, unsigned int mode);
+extern void ath5k_hw_detach(struct ath_hw *hal);
 /* Reset Functions */
-int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode, struct ieee80211_channel *channel, bool change_channel);
+extern int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode, struct ieee80211_channel *channel, bool change_channel);
 /* Power management functions */
-int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode, bool set_chip, u16 sleep_duration);
-enum ath5k_power_mode ath5k_hw_get_power_mode(struct ath_hw *hal);
+extern int ath5k_hw_set_power(struct ath_hw *hal, enum ath5k_power_mode mode, bool set_chip, u16 sleep_duration);
 /* DMA Related Functions */
-void ath5k_hw_start_rx(struct ath_hw *hal);
-int ath5k_hw_stop_rx_dma(struct ath_hw *hal);
-u32 ath5k_hw_get_rx_buf(struct ath_hw *hal);
-void ath5k_hw_put_rx_buf(struct ath_hw *hal, u32 phys_addr);
-int ath5k_hw_tx_start(struct ath_hw *hal, unsigned int queue);
-bool ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue);
-u32 ath5k_hw_get_tx_buf(struct ath_hw *hal, unsigned int queue);
-int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr);
-bool ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase);
+extern void ath5k_hw_start_rx(struct ath_hw *hal);
+extern int ath5k_hw_stop_rx_dma(struct ath_hw *hal);
+extern u32 ath5k_hw_get_rx_buf(struct ath_hw *hal);
+extern void ath5k_hw_put_rx_buf(struct ath_hw *hal, u32 phys_addr);
+extern int ath5k_hw_tx_start(struct ath_hw *hal, unsigned int queue);
+extern bool ath5k_hw_stop_tx_dma(struct ath_hw *hal, unsigned int queue);
+extern u32 ath5k_hw_get_tx_buf(struct ath_hw *hal, unsigned int queue);
+extern int ath5k_hw_put_tx_buf(struct ath_hw *hal, unsigned int queue, u32 phys_addr);
+extern bool ath5k_hw_update_tx_triglevel(struct ath_hw *hal, bool increase);
 /* Interrupt handling */
-bool ath5k_hw_is_intr_pending(struct ath_hw *hal);
-int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask);
-enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask);
-void ath5k_hw_radar_alert(struct ath_hw *hal, bool enable);
+extern bool ath5k_hw_is_intr_pending(struct ath_hw *hal);
+extern int ath5k_hw_get_isr(struct ath_hw *hal, enum ath5k_int *interrupt_mask);
+extern enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask);
 /* EEPROM access functions */
-int ath5k_hw_set_regdomain(struct ath_hw *hal, u16 regdomain);
+extern int ath5k_hw_set_regdomain(struct ath_hw *hal, u16 regdomain);
 /* Protocol Control Unit Functions */
-void ath5k_hw_set_opmode(struct ath_hw *hal);
+extern void ath5k_hw_set_opmode(struct ath_hw *hal);
 /* BSSID Functions */
-void ath5k_hw_get_lladdr(struct ath_hw *hal, u8 *mac);
-bool ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac);
-void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id);
-bool ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask);
+extern void ath5k_hw_get_lladdr(struct ath_hw *hal, u8 *mac);
+extern bool ath5k_hw_set_lladdr(struct ath_hw *hal, const u8 *mac);
+extern void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id);
+extern bool ath5k_hw_set_bssid_mask(struct ath_hw *hal, const u8 *mask);
 /* Receive start/stop functions */
-void ath5k_hw_start_rx_pcu(struct ath_hw *hal);
-void ath5k_hw_stop_pcu_recv(struct ath_hw *hal);
+extern void ath5k_hw_start_rx_pcu(struct ath_hw *hal);
+extern void ath5k_hw_stop_pcu_recv(struct ath_hw *hal);
 /* RX Filter functions */
-void ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1);
-bool ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index);
-bool ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index);
-u32 ath5k_hw_get_rx_filter(struct ath_hw *hal);
-void ath5k_hw_set_rx_filter(struct ath_hw *hal, u32 filter);
+extern void ath5k_hw_set_mcast_filter(struct ath_hw *hal, u32 filter0, u32 filter1);
+extern bool ath5k_hw_set_mcast_filterindex(struct ath_hw *hal, u32 index);
+extern bool ath5k_hw_clear_mcast_filter_idx(struct ath_hw *hal, u32 index);
+extern u32 ath5k_hw_get_rx_filter(struct ath_hw *ah);
+extern void ath5k_hw_set_rx_filter(struct ath_hw *ah, u32 filter);
 /* Beacon related functions */
-u32 ath5k_hw_get_tsf32(struct ath_hw *hal);
-u64 ath5k_hw_get_tsf64(struct ath_hw *hal);
-void ath5k_hw_reset_tsf(struct ath_hw *hal);
-void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval);
-void ath5k_hw_set_beacon_timers(struct ath_hw *hal, const struct ath5k_beacon_state *state);
-void ath5k_hw_reset_beacon(struct ath_hw *hal);
-bool ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr);
-void ath5k_hw_update_mib_counters(struct ath_hw *hal, struct ath5k_mib_stats *statistics);
+extern u32 ath5k_hw_get_tsf32(struct ath_hw *hal);
+extern u64 ath5k_hw_get_tsf64(struct ath_hw *hal);
+extern void ath5k_hw_reset_tsf(struct ath_hw *hal);
+extern void ath5k_hw_init_beacon(struct ath_hw *hal, u32 next_beacon, u32 interval);
+extern void ath5k_hw_set_beacon_timers(struct ath_hw *hal, const struct ath5k_beacon_state *state);
+extern void ath5k_hw_reset_beacon(struct ath_hw *hal);
+extern bool ath5k_hw_wait_for_beacon(struct ath_hw *hal, unsigned long phys_addr);
+extern void ath5k_hw_update_mib_counters(struct ath_hw *hal, struct ath5k_mib_stats *statistics);
 /* ACK/CTS Timeouts */
-bool ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout);
-unsigned int ath5k_hw_get_ack_timeout(struct ath_hw *hal);
-bool ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout);
-unsigned int ath5k_hw_get_cts_timeout(struct ath_hw *hal);
+extern bool ath5k_hw_set_ack_timeout(struct ath_hw *hal, unsigned int timeout);
+extern unsigned int ath5k_hw_get_ack_timeout(struct ath_hw *hal);
+extern bool ath5k_hw_set_cts_timeout(struct ath_hw *hal, unsigned int timeout);
+extern unsigned int ath5k_hw_get_cts_timeout(struct ath_hw *hal);
 /* Key table (WEP) functions */
-int ath5k_hw_reset_key(struct ath_hw *hal, u16 entry);
-int ath5k_hw_is_key_valid(struct ath_hw *hal, u16 entry);
-int ath5k_hw_set_key(struct ath_hw *hal, u16 entry, const struct ieee80211_key_conf *key, const u8 *mac);
-int ath5k_hw_set_key_lladdr(struct ath_hw *hal, u16 entry, const u8 *mac);
+extern int ath5k_hw_reset_key(struct ath_hw *hal, u16 entry);
+extern int ath5k_hw_is_key_valid(struct ath_hw *hal, u16 entry);
+extern int ath5k_hw_set_key(struct ath_hw *hal, u16 entry, const struct ieee80211_key_conf *key, const u8 *mac);
+extern int ath5k_hw_set_key_lladdr(struct ath_hw *hal, u16 entry, const u8 *mac);
 /* Queue Control Unit, DFS Control Unit Functions */
-int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type, struct ath5k_txq_info *queue_info);
-int ath5k_hw_setup_tx_queueprops(struct ath_hw *hal, int queue, const struct ath5k_txq_info *queue_info);
-int ath5k_hw_get_tx_queueprops(struct ath_hw *hal, int queue, struct ath5k_txq_info *queue_info);
-void ath5k_hw_release_tx_queue(struct ath_hw *hal, unsigned int queue);
-int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue);
-u32 ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue);
-bool ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time);
-unsigned int ath5k_hw_get_slot_time(struct ath_hw *hal);
+extern int ath5k_hw_setup_tx_queue(struct ath_hw *hal, enum ath5k_tx_queue queue_type, struct ath5k_txq_info *queue_info);
+extern int ath5k_hw_setup_tx_queueprops(struct ath_hw *hal, int queue, const struct ath5k_txq_info *queue_info);
+extern int ath5k_hw_get_tx_queueprops(struct ath_hw *hal, int queue, struct ath5k_txq_info *queue_info);
+extern void ath5k_hw_release_tx_queue(struct ath_hw *hal, unsigned int queue);
+extern int ath5k_hw_reset_tx_queue(struct ath_hw *hal, unsigned int queue);
+extern u32 ath5k_hw_num_tx_pending(struct ath_hw *hal, unsigned int queue);
+extern bool ath5k_hw_set_slot_time(struct ath_hw *hal, unsigned int slot_time);
+extern unsigned int ath5k_hw_get_slot_time(struct ath_hw *hal);
 /* Hardware Descriptor Functions */
-/* RX Descriptor */
-int ath5k_hw_setup_rx_desc(struct ath_hw *hal, struct ath_desc *desc, u32 size, unsigned int flags);
+extern int ath5k_hw_setup_rx_desc(struct ath_hw *hal, struct ath_desc *desc, u32 size, unsigned int flags);
 /* GPIO Functions */
-void ath5k_hw_set_ledstate(struct ath_hw *hal, unsigned int state);
-int ath5k_hw_set_gpio_output(struct ath_hw *hal, u32 gpio);
-int ath5k_hw_set_gpio_input(struct ath_hw *hal, u32 gpio);
-u32 ath5k_hw_get_gpio(struct ath_hw *hal, u32 gpio);
-int ath5k_hw_set_gpio(struct ath_hw *hal, u32 gpio, u32 val);
-void ath5k_hw_set_gpio_intr(struct ath_hw *hal, unsigned int gpio, u32 interrupt_level);
+extern void ath5k_hw_set_ledstate(struct ath_hw *hal, unsigned int state);
+extern int ath5k_hw_set_gpio_output(struct ath_hw *hal, u32 gpio);
+extern int ath5k_hw_set_gpio_input(struct ath_hw *hal, u32 gpio);
+extern u32 ath5k_hw_get_gpio(struct ath_hw *hal, u32 gpio);
+extern int ath5k_hw_set_gpio(struct ath_hw *hal, u32 gpio, u32 val);
+extern void ath5k_hw_set_gpio_intr(struct ath_hw *hal, unsigned int gpio, u32 interrupt_level);
 /* Regulatory Domain/Channels Setup */
-bool ath5k_channel_ok(struct ath_hw *hal, u16 freq, unsigned int flags);
-u16 ath5k_get_regdomain(struct ath_hw *hal);
-/* PHY/RF access functions */
-int ath5k_hw_phy_calibrate(struct ath_hw *hal, struct ieee80211_channel *channel);
-bool ath5k_hw_phy_disable(struct ath_hw *hal);
-void ath5k_hw_set_def_antenna(struct ath_hw *hal, unsigned int ant);
-unsigned int ath5k_hw_get_def_antenna(struct ath_hw *hal);
-enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath_hw *hal);
+extern u16 ath5k_get_regdomain(struct ath_hw *hal);
 /* Misc functions */
-int ath5k_hw_set_txpower_limit(struct ath_hw *hal, unsigned int power);
-void ath5k_hw_dump_state(struct ath_hw *hal);
-int ath5k_hw_get_capability(struct ath_hw *hal, enum ath5k_capability_type cap_type, u32 capability, u32 *result);
+extern void ath5k_hw_dump_state(struct ath_hw *hal);
+extern int ath5k_hw_get_capability(struct ath_hw *hal, enum ath5k_capability_type cap_type, u32 capability, u32 *result);
 bool ath5k_hw_query_pspoll_support(struct ath_hw *hal);
 bool ath5k_hw_enable_pspoll(struct ath_hw *hal, u8 *bssid, u16 assoc_id);
 bool ath5k_hw_disable_pspoll(struct ath_hw *hal);
 
+
+/* Initial register settings functions */
+extern int ath5k_hw_write_initvals(struct ath_hw *hal, u8 mode, bool change_channel);
+/* Initialize RF */
+extern int ath5k_hw_rfregs(struct ath_hw *hal, struct ieee80211_channel *channel, unsigned int mode);
+extern int ath5k_hw_rfgain(struct ath_hw *hal, unsigned int freq);
+extern enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath_hw *hal);
+extern int ath5k_hw_set_rfgain_opt(struct ath_hw *hal);
+
+
+/* PHY/RF channel functions */
+extern bool ath5k_channel_ok(struct ath_hw *hal, u16 freq, unsigned int flags);
+extern int ath5k_hw_channel(struct ath_hw *hal, struct ieee80211_channel *channel);
+/* PHY calibration */
+extern int ath5k_hw_phy_calibrate(struct ath_hw *hal, struct ieee80211_channel *channel);
+extern int ath5k_hw_phy_disable(struct ath_hw *hal);
+/* Misc PHY functions */
+extern u16 ath5k_hw_radio_revision(struct ath_hw *hal, unsigned int chan);
+extern void ath5k_hw_set_def_antenna(struct ath_hw *hal, unsigned int ant);
+extern unsigned int ath5k_hw_get_def_antenna(struct ath_hw *hal);
+/* TX power setup */
+extern int ath5k_hw_txpower(struct ath_hw *hal, struct ieee80211_channel *channel, unsigned int txpower);
+extern int ath5k_hw_set_txpower_limit(struct ath_hw *hal, unsigned int power);
+
+
+static inline u32 ath5k_hw_reg_read(struct ath_hw *hal, u16 reg)
+{
+	return readl(hal->ah_sh + reg);
+}
+
+static inline void ath5k_hw_reg_write(struct ath_hw *hal, u32 val, u16 reg)
+{
+	writel(val, hal->ah_sh + reg);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath5k_hw.c b/drivers/net/wireless/ath5k_hw.c
index 3501b4c..d92da20 100644
--- a/drivers/net/wireless/ath5k_hw.c
+++ b/drivers/net/wireless/ath5k_hw.c
@@ -37,8 +37,6 @@ static const struct ath5k_rate_table ath5k_rt_xr = AR5K_RATES_XR;
 /*Prototypes*/
 static int ath5k_hw_nic_reset(struct ath_hw *, u32);
 static int ath5k_hw_nic_wakeup(struct ath_hw *, int, bool);
-static u16 ath5k_hw_radio_revision(struct ath_hw *, unsigned int);
-static int ath5k_hw_txpower(struct ath_hw *, struct ieee80211_channel *, unsigned int);
 static int ath5k_hw_setup_4word_tx_desc(struct ath_hw *, struct ath_desc *,
 	unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
 	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
@@ -63,51 +61,6 @@ static int ath5k_hw_get_capabilities(struct ath_hw *);
 static int ath5k_eeprom_init(struct ath_hw *);
 static int ath5k_eeprom_read_mac(struct ath_hw *, u8 *);
 
-static int ath5k_hw_channel(struct ath_hw *, struct ieee80211_channel *);
-static int ath5k_hw_rfregs(struct ath_hw *, struct ieee80211_channel *,
-		unsigned int);
-static int ath5k_hw_rf5111_rfregs(struct ath_hw *, struct ieee80211_channel *,
-		unsigned int);
-static int ath5k_hw_rf5112_rfregs(struct ath_hw *, struct ieee80211_channel *,
-		unsigned int);
-static int ath5k_hw_rfgain(struct ath_hw *, unsigned int);
-
-/*
- * Initial register dumps
- */
-
-/*
- * MAC/PHY Settings
- */
-/* Common for all modes */
-static const struct ath5k_ini ar5210_ini[] = AR5K_AR5210_INI;
-static const struct ath5k_ini ar5211_ini[] = AR5K_AR5211_INI;
-static const struct ath5k_ini ar5212_ini[] = AR5K_AR5212_INI;
-
-/* Mode-specific settings */
-static const struct ath5k_ini_mode ar5211_ini_mode[] = AR5K_AR5211_INI_MODE;
-static const struct ath5k_ini_mode ar5212_ini_mode[] = AR5K_AR5212_INI_MODE;
-static const struct ath5k_ini_mode ar5212_rf5111_ini_mode[] = AR5K_AR5212_RF5111_INI_MODE;
-static const struct ath5k_ini_mode ar5212_rf5112_ini_mode[] = AR5K_AR5212_RF5112_INI_MODE;
-
-/* RF Initial BB gain settings */
-static const struct ath5k_ini rf5111_ini_bbgain[] = AR5K_RF5111_INI_BBGAIN;
-static const struct ath5k_ini rf5112_ini_bbgain[] = AR5K_RF5112_INI_BBGAIN;
-
-/*
- * RF Settings
- */
-/* RF Banks */
-static const struct ath5k_ini_rf rf5111_rf[] = AR5K_RF5111_INI_RF;
-static const struct ath5k_ini_rf rf5112_rf[] = AR5K_RF5112_INI_RF;
-static const struct ath5k_ini_rf rf5112a_rf[] = AR5K_RF5112A_INI_RF;
-/* Initial mode-specific RF gain table for 5111/5112 */
-static const struct ath5k_ini_rfgain rf5111_ini_rfgain[] = AR5K_RF5111_INI_RFGAIN;
-static const struct ath5k_ini_rfgain rf5112_ini_rfgain[] = AR5K_RF5112_INI_RFGAIN;
-/* Initial gain optimization tables */
-static const struct ath5k_gain_opt rf5111_gain_opt = AR5K_RF5111_GAIN_OPT;
-static const struct ath5k_gain_opt rf5112_gain_opt = AR5K_RF5112_GAIN_OPT;
-
 /*
  * Enable to overwrite the country code (use "00" for debug)
  */
@@ -191,19 +144,6 @@ ath_hal_computetxtime(struct ath_hw *hal, const struct ath5k_rate_table *rates,
  * Functions used internaly
  */
 
-static u32
-ath5k_hw_bitswap(u32 val, unsigned int bits)
-{
-	u32 retval = 0, bit, i;
-
-	for (i = 0; i < bits; i++) {
-		bit = (val >> i) & 1;
-		retval = (retval << 1) | bit;
-	}
-
-	return retval;
-}
-
 static inline unsigned int ath5k_hw_htoclock(unsigned int usec, bool turbo)
 {
 	return turbo == true ? (usec * 80) : (usec * 40);
@@ -215,26 +155,10 @@ static inline unsigned int ath5k_hw_clocktoh(unsigned int clock, bool turbo)
 }
 
 /*
- * Read from a device register
- */
-static inline u32 ath5k_hw_reg_read(struct ath_hw *hal, u16 reg)
-{
-	return readl(hal->ah_sh + reg);
-}
-
-/*
- * Write to a device register
- */
-static inline void ath5k_hw_reg_write(struct ath_hw *hal, u32 val, u16 reg)
-{
-	writel(val, hal->ah_sh + reg);
-}
-
-/*
  * Check if a register write has been completed
  */
-static int ath5k_hw_register_timeout(struct ath_hw *hal, u32 reg, u32 flag,
-		u32 val, bool is_set)
+int ath5k_hw_register_timeout(struct ath_hw *hal, u32 reg, u32 flag, u32 val,
+		bool is_set)
 {
 	int i;
 	u32 data;
@@ -251,50 +175,6 @@ static int ath5k_hw_register_timeout(struct ath_hw *hal, u32 reg, u32 flag,
 	return (i <= 0) ? -EAGAIN : 0;
 }
 
-/*
- * Write initial register dump
- */
-static void ath5k_hw_ini_registers(struct ath_hw *hal, unsigned int size,
-		const struct ath5k_ini *ini_regs, bool change_channel)
-{
-	unsigned int i;
-
-	/* Write initial registers */
-	for (i = 0; i < size; i++) {
-		/* On channel change there is
-		 * no need to mess with PCU */
-		if (change_channel &&
-				ini_regs[i].ini_register >= AR5K_PCU_MIN &&
-				ini_regs[i].ini_register <= AR5K_PCU_MAX)
-			continue;
-
-		switch (ini_regs[i].ini_mode) {
-		case AR5K_INI_READ:
-			/* Cleared on read */
-			ath5k_hw_reg_read(hal, ini_regs[i].ini_register);
-			break;
-		case AR5K_INI_WRITE:
-		default:
-			AR5K_REG_WAIT(i);
-			ath5k_hw_reg_write(hal, ini_regs[i].ini_value,
-					ini_regs[i].ini_register);
-		}
-	}
-}
-
-static void ath5k_hw_ini_mode_registers(struct ath_hw *hal,
-		unsigned int size, const struct ath5k_ini_mode *ini_mode,
-		u8 mode)
-{
-	unsigned int i;
-
-	for (i = 0; i < size; i++) {
-		AR5K_REG_WAIT(i);
-		ath5k_hw_reg_write(hal, ini_mode[i].mode_value[mode],
-			(u32)ini_mode[i].mode_register);
-	}
-
-}
 
 /***************************************\
 	Attach/Detach Functions
@@ -462,24 +342,7 @@ struct ath_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 
 	ath5k_hw_set_lladdr(hal, mac);
 
-	/* Initialize the gain optimization values */
-	/*For RF5111*/
-	if (hal->ah_radio == AR5K_RF5111) {
-		hal->ah_gain.g_step_idx = rf5111_gain_opt.go_default;
-		hal->ah_gain.g_step =
-		    &rf5111_gain_opt.go_step[hal->ah_gain.g_step_idx];
-		hal->ah_gain.g_low = 20;
-		hal->ah_gain.g_high = 35;
-		hal->ah_gain.g_active = 1;
-	/*For RF5112*/
-	} else if (hal->ah_radio == AR5K_RF5112) {
-		hal->ah_gain.g_step_idx = rf5112_gain_opt.go_default;
-		hal->ah_gain.g_step =
-		    &rf5111_gain_opt.go_step[hal->ah_gain.g_step_idx];
-		hal->ah_gain.g_low = 20;
-		hal->ah_gain.g_high = 85;
-		hal->ah_gain.g_active = 1;
-	}
+	ath5k_hw_set_rfgain_opt(hal);
 
 	return hal;
 err_free:
@@ -621,54 +484,6 @@ static int ath5k_hw_nic_wakeup(struct ath_hw *hal, int flags, bool initial)
 }
 
 /*
- * Get the PHY Chip revision
- */
-static u16 ath5k_hw_radio_revision(struct ath_hw *hal, unsigned int chan)
-{
-	unsigned int i;
-	u32 srev;
-	u16 ret;
-
-	AR5K_TRACE;
-
-	/*
-	 * Set the radio chip access register
-	 */
-	switch (chan) {
-	case CHANNEL_2GHZ:
-		ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_2GHZ, AR5K_PHY(0));
-		break;
-	case CHANNEL_5GHZ:
-		ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
-		break;
-	default:
-		return 0;
-	}
-
-	mdelay(2);
-
-	/* ...wait until PHY is ready and read the selected radio revision */
-	ath5k_hw_reg_write(hal, 0x00001c16, AR5K_PHY(0x34));
-
-	for (i = 0; i < 8; i++)
-		ath5k_hw_reg_write(hal, 0x00010000, AR5K_PHY(0x20));
-
-	if (hal->ah_version == AR5K_AR5210) {
-		srev = ath5k_hw_reg_read(hal, AR5K_PHY(256) >> 28) & 0xf;
-		ret = (u16)ath5k_hw_bitswap(srev, 4) + 1;
-	} else {
-		srev = (ath5k_hw_reg_read(hal, AR5K_PHY(0x100)) >> 24) & 0xff;
-		ret = (u16)ath5k_hw_bitswap(((srev & 0xf0) >> 4) |
-				((srev & 0x0f) << 4), 8);
-	}
-
-	/* Reset to the 5GHz mode */
-	ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
-
-	return ret;
-}
-
-/*
  * Get the rate table for a specific operation mode
  */
 const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath_hw *hal,
@@ -826,60 +641,7 @@ int ath5k_hw_reset(struct ath_hw *hal, enum ieee80211_if_types op_mode,
 
 	}
 
-	/*
-	 * Write initial mode-specific settings
-	 */
-	/*For 5212*/
-	if (hal->ah_version == AR5K_AR5212) {
-		ath5k_hw_ini_mode_registers(hal, ARRAY_SIZE(ar5212_ini_mode),
-				ar5212_ini_mode, mode);
-		if (hal->ah_radio == AR5K_RF5111)
-			ath5k_hw_ini_mode_registers(hal,
-					ARRAY_SIZE(ar5212_rf5111_ini_mode),
-					ar5212_rf5111_ini_mode, mode);
-		else if (hal->ah_radio == AR5K_RF5112)
-			ath5k_hw_ini_mode_registers(hal,
-					ARRAY_SIZE(ar5212_rf5112_ini_mode),
-					ar5212_rf5112_ini_mode, mode);
-	}
-	/*For 5211*/
-	if (hal->ah_version == AR5K_AR5211)
-		ath5k_hw_ini_mode_registers(hal, ARRAY_SIZE(ar5211_ini_mode),
-				ar5211_ini_mode, mode);
-	/* For 5210 mode settings check out ath5k_hw_reset_tx_queue */
-
-	/*
-	 * Write initial settings common for all modes
-	 */
-	/*For 5212*/
-	if (hal->ah_version == AR5K_AR5212) {
-		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5212_ini),
-				ar5212_ini, change_channel);
-		if (hal->ah_radio == AR5K_RF5112) {
-			ath5k_hw_reg_write(hal, AR5K_PHY_PAPD_PROBE_INI_5112,
-					AR5K_PHY_PAPD_PROBE);
-			ath5k_hw_ini_registers(hal,
-					ARRAY_SIZE(rf5112_ini_bbgain),
-					rf5112_ini_bbgain, change_channel);
-		} else if (hal->ah_radio == AR5K_RF5111) {
-			ath5k_hw_reg_write(hal, AR5K_PHY_GAIN_2GHZ_INI_5111,
-					AR5K_PHY_GAIN_2GHZ);
-			ath5k_hw_reg_write(hal, AR5K_PHY_PAPD_PROBE_INI_5111,
-					AR5K_PHY_PAPD_PROBE);
-			ath5k_hw_ini_registers(hal,
-					ARRAY_SIZE(rf5111_ini_bbgain),
-					rf5111_ini_bbgain, change_channel);
-		}
-	} else if (hal->ah_version == AR5K_AR5211) {
-		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5211_ini),
-				ar5211_ini, change_channel);
-		/* AR5211 only comes with 5111 */
-		ath5k_hw_ini_registers(hal, ARRAY_SIZE(rf5111_ini_bbgain),
-				rf5111_ini_bbgain, change_channel);
-	} else if (hal->ah_version == AR5K_AR5210) {
-		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5210_ini),
-				ar5210_ini, change_channel);
-	}
+	ath5k_hw_write_initvals(hal, mode, change_channel);
 
 	/*
 	 * 5211/5212 Specific
@@ -1373,6 +1135,7 @@ commit:
 	return 0;
 }
 
+#if 0
 /*
  * Get power mode (sleep state)
  * TODO:Remove ?
@@ -1383,7 +1146,7 @@ ath5k_hw_get_power_mode(struct ath_hw *hal)
 	AR5K_TRACE;
 	return hal->ah_power_mode;
 }
-
+#endif
 
 /***********************\
   DMA Related Functions
@@ -1814,6 +1577,7 @@ enum ath5k_int ath5k_hw_set_intr(struct ath_hw *hal, enum ath5k_int new_mask)
 	return old_mask;
 }
 
+#if 0
 /*
  * Enable HW radar detection
  */
@@ -1856,7 +1620,7 @@ ath5k_hw_radar_alert(struct ath_hw *hal, bool enable)
 	/*Re-enable interrupts*/
 	ath5k_hw_reg_write(hal, AR5K_IER_ENABLE, AR5K_IER);
 }
-
+#endif
 
 
 
@@ -4417,24 +4181,6 @@ void ath5k_hw_set_gpio_intr(struct ath_hw *hal, unsigned int gpio,
  Regulatory Domain/Channels Setup
 \*********************************/
 
-/*
- * Check if a channel is supported
- */
-bool ath5k_channel_ok(struct ath_hw *hal, u16 freq, unsigned int flags)
-{
-	/* Check if the channel is in our supported range */
-	if (flags & CHANNEL_2GHZ) {
-		if ((freq >= hal->ah_capabilities.cap_range.range_2ghz_min) &&
-		    (freq <= hal->ah_capabilities.cap_range.range_2ghz_max))
-			return true;
-	} else if (flags & CHANNEL_5GHZ)
-		if ((freq >= hal->ah_capabilities.cap_range.range_5ghz_min) &&
-		    (freq <= hal->ah_capabilities.cap_range.range_5ghz_max))
-			return true;
-
-	return false;
-}
-
 u16 ath5k_get_regdomain(struct ath_hw *hal)
 {
 	u16 regdomain;
@@ -4461,1042 +4207,6 @@ u16 ath5k_get_regdomain(struct ath_hw *hal)
 	return regdomain;
 }
 
-/*************************\
-  PHY/RF access functions
-\*************************/
-
-/*
- * Convertion needed for RF5110
- */
-static u32 ath5k_hw_rf5110_chan2athchan(struct ieee80211_channel *channel)
-{
-	u32 athchan;
-
-	/*
-	 * Convert IEEE channel/MHz to an internal channel value used
-	 * by the AR5210 chipset. This has not been verified with
-	 * newer chipsets like the AR5212A who have a completely
-	 * different RF/PHY part.
-	 */
-	athchan = (ath5k_hw_bitswap((channel->chan - 24) / 2, 5) << 1) |
-		(1 << 6) | 0x1;
-
-	return athchan;
-}
-
-/*
- * Set channel on RF5110
- */
-static int ath5k_hw_rf5110_channel(struct ath_hw *hal,
-		struct ieee80211_channel *channel)
-{
-	u32 data;
-
-	/*
-	 * Set the channel and wait
-	 */
-	data = ath5k_hw_rf5110_chan2athchan(channel);
-	ath5k_hw_reg_write(hal, data, AR5K_RF_BUFFER);
-	ath5k_hw_reg_write(hal, 0, AR5K_RF_BUFFER_CONTROL_0);
-	mdelay(1);
-
-	return 0;
-}
-
-/*
- * Convertion needed for 5111
- */
-static int ath5k_hw_rf5111_chan2athchan(unsigned int ieee,
-		struct ath5k_athchan_2ghz *athchan)
-{
-	int channel;
-
-	/* Cast this value to catch negative channel numbers (>= -19) */
-	channel = (int)ieee;
-
-	/*
-	 * Map 2GHz IEEE channel to 5GHz Atheros channel
-	 */
-	if (channel <= 13) {
-		athchan->a2_athchan = 115 + channel;
-		athchan->a2_flags = 0x46;
-	} else if (channel == 14) {
-		athchan->a2_athchan = 124;
-		athchan->a2_flags = 0x44;
-	} else if (channel >= 15 && channel <= 26) {
-		athchan->a2_athchan = ((channel - 14) * 4) + 132;
-		athchan->a2_flags = 0x46;
-	} else
-		return -EINVAL;
-
-	return 0;
-}
-
-/*
- * Set channel on 5111
- */
-static int ath5k_hw_rf5111_channel(struct ath_hw *hal,
-		struct ieee80211_channel *channel)
-{
-	struct ath5k_athchan_2ghz ath_channel_2ghz;
-	unsigned int ath_channel = channel->chan;
-	u32 data0, data1, clock;
-	int ret;
-
-	/*
-	 * Set the channel on the RF5111 radio
-	 */
-	data0 = data1 = 0;
-
-	if (channel->val & CHANNEL_2GHZ) {
-		/* Map 2GHz channel to 5GHz Atheros channel ID */
-		ret = ath5k_hw_rf5111_chan2athchan(channel->chan,
-				&ath_channel_2ghz);
-		if (ret)
-			return ret;
-
-		ath_channel = ath_channel_2ghz.a2_athchan;
-		data0 = ((ath5k_hw_bitswap(ath_channel_2ghz.a2_flags, 8) & 0xff)
-		    << 5) | (1 << 4);
-	}
-
-	if (ath_channel < 145 || !(ath_channel & 1)) {
-		clock = 1;
-		data1 = ((ath5k_hw_bitswap(ath_channel - 24, 8) & 0xff) << 2) |
-			(clock << 1) | (1 << 10) | 1;
-	} else {
-		clock = 0;
-		data1 = ((ath5k_hw_bitswap((ath_channel - 24) / 2, 8) & 0xff)
-			<< 2) | (clock << 1) | (1 << 10) | 1;
-	}
-
-	ath5k_hw_reg_write(hal, (data1 & 0xff) | ((data0 & 0xff) << 8),
-			AR5K_RF_BUFFER);
-	ath5k_hw_reg_write(hal, ((data1 >> 8) & 0xff) | (data0 & 0xff00),
-			AR5K_RF_BUFFER_CONTROL_3);
-
-	return 0;
-}
-
-/*
- * Set channel on 5112
- */
-static int ath5k_hw_rf5112_channel(struct ath_hw *hal,
-		struct ieee80211_channel *channel)
-{
-	u32 data, data0, data1, data2;
-	u16 c;
-
-	data = data0 = data1 = data2 = 0;
-	c = channel->freq;
-
-	/*
-	 * Set the channel on the RF5112 or newer
-	 */
-	if (c < 4800) {
-		if (!((c - 2224) % 5)) {
-			data0 = ((2 * (c - 704)) - 3040) / 10;
-			data1 = 1;
-		} else if (!((c - 2192) % 5)) {
-			data0 = ((2 * (c - 672)) - 3040) / 10;
-			data1 = 0;
-		} else
-			return -EINVAL;
-
-		data0 = ath5k_hw_bitswap((data0 << 2) & 0xff, 8);
-	} else {
-		if (!(c % 20) && c >= 5120) {
-			data0 = ath5k_hw_bitswap(((c - 4800) / 20 << 2), 8);
-			data2 = ath5k_hw_bitswap(3, 2);
-		} else if (!(c % 10)) {
-			data0 = ath5k_hw_bitswap(((c - 4800) / 10 << 1), 8);
-			data2 = ath5k_hw_bitswap(2, 2);
-		} else if (!(c % 5)) {
-			data0 = ath5k_hw_bitswap((c - 4800) / 5, 8);
-			data2 = ath5k_hw_bitswap(1, 2);
-		} else
-			return -EINVAL;
-	}
-
-	data = (data0 << 4) | (data1 << 1) | (data2 << 2) | 0x1001;
-
-	ath5k_hw_reg_write(hal, data & 0xff, AR5K_RF_BUFFER);
-	ath5k_hw_reg_write(hal, (data >> 8) & 0x7f, AR5K_RF_BUFFER_CONTROL_5);
-
-	return 0;
-}
-
-/*
- * Set a channel on the radio chip
- */
-static int ath5k_hw_channel(struct ath_hw *hal,
-		struct ieee80211_channel *channel)
-{
-	int ret;
-
-	/*
-	 * Check bounds supported by the PHY
-	 * (don't care about regulation restrictions at this point)
-	 */
-	if ((channel->freq < hal->ah_capabilities.cap_range.range_2ghz_min ||
-	    channel->freq > hal->ah_capabilities.cap_range.range_2ghz_max) &&
-	    (channel->freq < hal->ah_capabilities.cap_range.range_5ghz_min ||
-	    channel->freq > hal->ah_capabilities.cap_range.range_5ghz_max)) {
-		AR5K_PRINTF("channel out of supported range (%u MHz)\n",
-			channel->freq);
-		return -EINVAL;
-	}
-
-	/*
-	 * Set the channel and wait
-	 */
-	switch (hal->ah_radio) {
-	case AR5K_RF5110:
-		ret = ath5k_hw_rf5110_channel(hal, channel);
-		break;
-	case AR5K_RF5111:
-		ret = ath5k_hw_rf5111_channel(hal, channel);
-		break;
-	default:
-		ret = ath5k_hw_rf5112_channel(hal, channel);
-		break;
-	}
-
-	if (ret)
-		return ret;
-
-	hal->ah_current_channel.freq = channel->freq;
-	hal->ah_current_channel.val = channel->val;
-	hal->ah_turbo = channel->val == CHANNEL_T ? true : false;
-
-	return 0;
-}
-
-/*
- * Perform a PHY calibration on RF5110
- * -Fix BPSK/QAM Constellation (I/Q correction)
- * -Calculate Noise Floor
- */
-static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
-		struct ieee80211_channel *channel)
-{
-	u32 phy_sig, phy_agc, phy_sat, beacon, noise_floor;
-	unsigned int i;
-	int ret;
-
-	/*
-	 * Disable beacons and RX/TX queues, wait
-	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_DIAG_SW_5210,
-		AR5K_DIAG_SW_DIS_TX | AR5K_DIAG_SW_DIS_RX_5210);
-	beacon = ath5k_hw_reg_read(hal, AR5K_BEACON_5210);
-	ath5k_hw_reg_write(hal, beacon & ~AR5K_BEACON_ENABLE, AR5K_BEACON_5210);
-
-	udelay(2300);
-
-	/*
-	 * Set the channel (with AGC turned off)
-	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
-	udelay(10);
-	ret = ath5k_hw_channel(hal, channel);
-
-	/*
-	 * Activate PHY and wait
-	 */
-	ath5k_hw_reg_write(hal, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
-	mdelay(1);
-
-	AR5K_REG_DISABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
-
-	if (ret)
-		return ret;
-
-	/*
-	 * Calibrate the radio chip
-	 */
-
-	/* Remember normal state */
-	phy_sig = ath5k_hw_reg_read(hal, AR5K_PHY_SIG);
-	phy_agc = ath5k_hw_reg_read(hal, AR5K_PHY_AGCCOARSE);
-	phy_sat = ath5k_hw_reg_read(hal, AR5K_PHY_ADCSAT);
-
-	/* Update radio registers */
-	ath5k_hw_reg_write(hal, (phy_sig & ~(AR5K_PHY_SIG_FIRPWR)) |
-		AR5K_REG_SM(-1, AR5K_PHY_SIG_FIRPWR), AR5K_PHY_SIG);
-
-	ath5k_hw_reg_write(hal, (phy_agc & ~(AR5K_PHY_AGCCOARSE_HI |
-			AR5K_PHY_AGCCOARSE_LO)) |
-		AR5K_REG_SM(-1, AR5K_PHY_AGCCOARSE_HI) |
-		AR5K_REG_SM(-127, AR5K_PHY_AGCCOARSE_LO), AR5K_PHY_AGCCOARSE);
-
-	ath5k_hw_reg_write(hal, (phy_sat & ~(AR5K_PHY_ADCSAT_ICNT |
-			AR5K_PHY_ADCSAT_THR)) |
-		AR5K_REG_SM(2, AR5K_PHY_ADCSAT_ICNT) |
-		AR5K_REG_SM(12, AR5K_PHY_ADCSAT_THR), AR5K_PHY_ADCSAT);
-
-	udelay(20);
-
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
-	udelay(10);
-	ath5k_hw_reg_write(hal, AR5K_PHY_RFSTG_DISABLE, AR5K_PHY_RFSTG);
-	AR5K_REG_DISABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
-
-	mdelay(1);
-
-	/*
-	 * Enable calibration and wait until completion
-	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_CAL);
-
-	ret = ath5k_hw_register_timeout(hal, AR5K_PHY_AGCCTL,
-			AR5K_PHY_AGCCTL_CAL, 0, false);
-
-	/* Reset to normal state */
-	ath5k_hw_reg_write(hal, phy_sig, AR5K_PHY_SIG);
-	ath5k_hw_reg_write(hal, phy_agc, AR5K_PHY_AGCCOARSE);
-	ath5k_hw_reg_write(hal, phy_sat, AR5K_PHY_ADCSAT);
-
-	if (ret) {
-		AR5K_PRINTF("calibration timeout (%uMHz)\n", channel->freq);
-		return ret;
-	}
-
-	/*
-	 * Enable noise floor calibration and wait until completion
-	 */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
-
-	ret = ath5k_hw_register_timeout(hal, AR5K_PHY_AGCCTL,
-			AR5K_PHY_AGCCTL_NF, 0, false);
-	if (ret) {
-		AR5K_PRINTF("noise floor calibration timeout (%uMHz)\n",
-				channel->freq);
-		return ret;
-	}
-
-	/* Wait until the noise floor is calibrated */
-	for (i = 20; i > 0; i--) {
-		mdelay(1);
-		noise_floor = ath5k_hw_reg_read(hal, AR5K_PHY_NF);
-
-		if (AR5K_PHY_NF_RVAL(noise_floor) & AR5K_PHY_NF_ACTIVE)
-			noise_floor = AR5K_PHY_NF_AVAL(noise_floor);
-
-		if (noise_floor <= AR5K_TUNE_NOISE_FLOOR)
-			break;
-	}
-
-	if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
-		AR5K_PRINTF("noise floor calibration failed (%uMHz)\n",
-			channel->freq);
-		return -EIO;
-	}
-
-	/*
-	 * Re-enable RX/TX and beacons
-	 */
-	AR5K_REG_DISABLE_BITS(hal, AR5K_DIAG_SW_5210,
-		AR5K_DIAG_SW_DIS_TX | AR5K_DIAG_SW_DIS_RX_5210);
-	ath5k_hw_reg_write(hal, beacon, AR5K_BEACON_5210);
-
-	return 0;
-}
-
-/*
- * Perform a PHY calibration on RF5111/5112
- */
-static int ath5k_hw_rf511x_calibrate(struct ath_hw *hal,
-		struct ieee80211_channel *channel)
-{
-	u32 i_pwr, q_pwr;
-	s32 iq_corr, i_coff, i_coffd, q_coff, q_coffd;
-	AR5K_TRACE;
-
-	if (hal->ah_calibration == false ||
-			ath5k_hw_reg_read(hal, AR5K_PHY_IQ) & AR5K_PHY_IQ_RUN)
-		goto done;
-
-	hal->ah_calibration = false;
-
-	iq_corr = ath5k_hw_reg_read(hal, AR5K_PHY_IQRES_CAL_CORR);
-	i_pwr = ath5k_hw_reg_read(hal, AR5K_PHY_IQRES_CAL_PWR_I);
-	q_pwr = ath5k_hw_reg_read(hal, AR5K_PHY_IQRES_CAL_PWR_Q);
-	i_coffd = ((i_pwr >> 1) + (q_pwr >> 1)) >> 7;
-	q_coffd = q_pwr >> 6;
-
-	if (i_coffd == 0 || q_coffd == 0)
-		goto done;
-
-	i_coff = ((-iq_corr) / i_coffd) & 0x3f;
-	q_coff = (((s32)i_pwr / q_coffd) - 64) & 0x1f;
-
-	/* Commit new IQ value */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_ENABLE |
-		((u32)q_coff) | ((u32)i_coff << AR5K_PHY_IQ_CORR_Q_I_COFF_S));
-
-done:
-	/* Start noise floor calibration */
-	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
-
-	/* Request RF gain */
-	if (channel->val & CHANNEL_5GHZ) {
-		ath5k_hw_reg_write(hal, AR5K_REG_SM(hal->ah_txpower.txp_max,
-			AR5K_PHY_PAPD_PROBE_TXPOWER) |
-			AR5K_PHY_PAPD_PROBE_TX_NEXT, AR5K_PHY_PAPD_PROBE);
-		hal->ah_rf_gain = AR5K_RFGAIN_READ_REQUESTED;
-	}
-
-	return 0;
-}
-
-/*
- * Perform a PHY calibration
- */
-int ath5k_hw_phy_calibrate(struct ath_hw *hal,
-		struct ieee80211_channel *channel)
-{
-	int ret;
-
-	if (hal->ah_radio == AR5K_RF5110)
-		ret = ath5k_hw_rf5110_calibrate(hal, channel);
-	else
-		ret = ath5k_hw_rf511x_calibrate(hal, channel);
-
-	return ret;
-}
-
-bool
-ath5k_hw_phy_disable(struct ath_hw *hal)
-{
-	AR5K_TRACE;
-	/*Just a try M.F.*/
-	ath5k_hw_reg_write(hal, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
-	return true;
-}
-
-void /*TODO:Boundary check*/
-ath5k_hw_set_def_antenna(struct ath_hw *hal, unsigned int ant)
-{
-	AR5K_TRACE;
-	/*Just a try M.F.*/
-	if (hal->ah_version != AR5K_AR5210)
-		ath5k_hw_reg_write(hal, ant, AR5K_DEFAULT_ANTENNA);
-}
-
-unsigned int
-ath5k_hw_get_def_antenna(struct ath_hw *hal)
-{
-	AR5K_TRACE;
-	/*Just a try M.F.*/
-	if (hal->ah_version != AR5K_AR5210)
-		return ath5k_hw_reg_read(hal, AR5K_DEFAULT_ANTENNA);
-
-	return false; /*XXX: What do we return for 5210 ?*/
-}
-
-/*
- * Used to modify RF Banks before writing them to AR5K_RF_BUFFER
- */
-static unsigned int ath5k_hw_rfregs_op(u32 *rf, u32 offset, u32 reg, u32 bits,
-		u32 first, u32 col, bool set)
-{
-	u32 mask, entry, last, data, shift, position;
-	s32 left;
-	int i;
-
-	data = 0;
-
-	if (rf == NULL)
-		/* should not happen */
-		return 0;
-
-	if (!(col <= 3 && bits <= 32 && first + bits <= 319)) {
-		AR5K_PRINTF("invalid values at offset %u\n", offset);
-		return 0;
-	}
-
-	entry = ((first - 1) / 8) + offset;
-	position = (first - 1) % 8;
-
-	if (set == true)
-		data = ath5k_hw_bitswap(reg, bits);
-
-	for (i = shift = 0, left = bits; left > 0; position = 0, entry++, i++) {
-		last = (position + left > 8) ? 8 : position + left;
-		mask = (((1 << last) - 1) ^ ((1 << position) - 1)) << (col * 8);
-
-		if (set == true) {
-			rf[entry] &= ~mask;
-			rf[entry] |= ((data << position) << (col * 8)) & mask;
-			data >>= (8 - position);
-		} else {
-			data = (((rf[entry] & mask) >> (col * 8)) >> position)
-				<< shift;
-			shift += last - position;
-		}
-
-		left -= 8 - position;
-	}
-
-	data = set == true ? 1 : ath5k_hw_bitswap(data, bits);
-
-	return data;
-}
-
-static u32 ath5k_hw_rfregs_gainf_corr(struct ath_hw *hal)
-{
-	u32 mix, step;
-	u32 *rf;
-
-	if (hal->ah_rf_banks == NULL)
-		return 0;
-
-	rf = hal->ah_rf_banks;
-	hal->ah_gain.g_f_corr = 0;
-
-	if (ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 1, 36, 0, false) != 1)
-		return 0;
-
-	step = ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 4, 32, 0, false);
-	mix = hal->ah_gain.g_step->gos_param[0];
-
-	switch (mix) {
-	case 3:
-		hal->ah_gain.g_f_corr = step * 2;
-		break;
-	case 2:
-		hal->ah_gain.g_f_corr = (step - 5) * 2;
-		break;
-	case 1:
-		hal->ah_gain.g_f_corr = step;
-		break;
-	default:
-		hal->ah_gain.g_f_corr = 0;
-		break;
-	}
-
-	return hal->ah_gain.g_f_corr;
-}
-
-static bool ath5k_hw_rfregs_gain_readback(struct ath_hw *hal)
-{
-	u32 step, mix, level[4];
-	u32 *rf;
-
-	if (hal->ah_rf_banks == NULL)
-		return false;
-
-	rf = hal->ah_rf_banks;
-
-	if (hal->ah_radio == AR5K_RF5111) {
-		step = ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 6, 37, 0,
-				false);
-		level[0] = 0;
-		level[1] = (step == 0x3f) ? 0x32 : step + 4;
-		level[2] = (step != 0x3f) ? 0x40 : level[0];
-		level[3] = level[2] + 0x32;
-
-		hal->ah_gain.g_high = level[3] -
-			(step == 0x3f ? AR5K_GAIN_DYN_ADJUST_HI_MARGIN : -5);
-		hal->ah_gain.g_low = level[0] +
-			(step == 0x3f ? AR5K_GAIN_DYN_ADJUST_LO_MARGIN : 0);
-	} else {
-		mix = ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 1, 36, 0,
-				false);
-		level[0] = level[2] = 0;
-
-		if (mix == 1) {
-			level[1] = level[3] = 83;
-		} else {
-			level[1] = level[3] = 107;
-			hal->ah_gain.g_high = 55;
-		}
-	}
-
-	return (hal->ah_gain.g_current >= level[0] &&
-			hal->ah_gain.g_current <= level[1]) ||
-		(hal->ah_gain.g_current >= level[2] &&
-			hal->ah_gain.g_current <= level[3]);
-}
-
-static s32 ath5k_hw_rfregs_gain_adjust(struct ath_hw *hal)
-{
-	const struct ath5k_gain_opt *go;
-	int ret = 0;
-
-	go = hal->ah_radio == AR5K_RF5111 ? &rf5111_gain_opt : &rf5112_gain_opt;
-
-	hal->ah_gain.g_step = &go->go_step[hal->ah_gain.g_step_idx];
-
-	if (hal->ah_gain.g_current >= hal->ah_gain.g_high) {
-		if (hal->ah_gain.g_step_idx == 0)
-			return -1;
-		for (hal->ah_gain.g_target = hal->ah_gain.g_current;
-				hal->ah_gain.g_target >=  hal->ah_gain.g_high &&
-				hal->ah_gain.g_step_idx > 0;
-				hal->ah_gain.g_step =
-					&go->go_step[hal->ah_gain.g_step_idx])
-			hal->ah_gain.g_target -= 2 *
-			    (go->go_step[--(hal->ah_gain.g_step_idx)].gos_gain -
-			    hal->ah_gain.g_step->gos_gain);
-
-		ret = 1;
-		goto done;
-	}
-
-	if (hal->ah_gain.g_current <= hal->ah_gain.g_low) {
-		if (hal->ah_gain.g_step_idx == (go->go_steps_count - 1))
-			return -2;
-		for (hal->ah_gain.g_target = hal->ah_gain.g_current;
-				hal->ah_gain.g_target <= hal->ah_gain.g_low &&
-				hal->ah_gain.g_step_idx < go->go_steps_count-1;
-				hal->ah_gain.g_step =
-					&go->go_step[hal->ah_gain.g_step_idx])
-			hal->ah_gain.g_target -= 2 *
-			    (go->go_step[++hal->ah_gain.g_step_idx].gos_gain -
-			    hal->ah_gain.g_step->gos_gain);
-
-		ret = 2;
-		goto done;
-	}
-
-done:
-#ifdef AR5K_DEBUG
-	AR5K_PRINTF("ret %d, gain step %u, current gain %u, target gain %u\n",
-		ret, hal->ah_gain.g_step_idx, hal->ah_gain.g_current,
-		hal->ah_gain.g_target);
-#endif
-
-	return ret;
-}
-
-/*
- * Initialize RF
- */
-static int ath5k_hw_rfregs(struct ath_hw *hal,
-		struct ieee80211_channel *channel, unsigned int mode)
-{
-	int (*func)(struct ath_hw *, struct ieee80211_channel *, unsigned int);
-	int ret;
-
-	switch (hal->ah_radio) {
-	case AR5K_RF5111:
-		hal->ah_rf_banks_size = sizeof(rf5111_rf);
-		func = ath5k_hw_rf5111_rfregs;
-		break;
-	case AR5K_RF5112:
-		if (hal->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A)
-			hal->ah_rf_banks_size = sizeof(rf5112a_rf);
-		else
-		hal->ah_rf_banks_size = sizeof(rf5112_rf);
-		func = ath5k_hw_rf5112_rfregs;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (hal->ah_rf_banks == NULL) {
-		/* XXX do extra checks? */
-		hal->ah_rf_banks = kmalloc(hal->ah_rf_banks_size, GFP_KERNEL);
-		if (hal->ah_rf_banks == NULL) {
-			AR5K_PRINT("out of memory\n");
-			return -ENOMEM;
-		}
-	}
-
-	ret = func(hal, channel, mode);
-	if (!ret)
-		hal->ah_rf_gain = AR5K_RFGAIN_INACTIVE;
-
-	return ret;
-}
-
-/*
- * Read EEPROM Calibration data, modify RF Banks and Initialize RF5111
- */
-static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
-		struct ieee80211_channel *channel, unsigned int mode)
-{
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
-	u32 *rf;
-	const unsigned int rf_size = ARRAY_SIZE(rf5111_rf);
-	unsigned int i;
-	int obdb = -1, bank = -1;
-	u32 ee_mode;
-
-	AR5K_ASSERT_ENTRY(mode, AR5K_INI_VAL_MAX);
-
-	rf = hal->ah_rf_banks;
-
-	/* Copy values to modify them */
-	for (i = 0; i < rf_size; i++) {
-		if (rf5111_rf[i].rf_bank >= AR5K_RF5111_INI_RF_MAX_BANKS) {
-			AR5K_PRINT("invalid bank\n");
-			return -EINVAL;
-		}
-
-		if (bank != rf5111_rf[i].rf_bank) {
-			bank = rf5111_rf[i].rf_bank;
-			hal->ah_offset[bank] = i;
-		}
-
-		rf[i] = rf5111_rf[i].rf_value[mode];
-	}
-
-	/* Modify bank 0 */
-	if (channel->val & CHANNEL_2GHZ) {
-		if (channel->val & CHANNEL_B)
-			ee_mode = AR5K_EEPROM_MODE_11B;
-		else
-			ee_mode = AR5K_EEPROM_MODE_11G;
-		obdb = 0;
-
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[0],
-				ee->ee_ob[ee_mode][obdb], 3, 119, 0, true))
-			return -EINVAL;
-
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[0],
-				ee->ee_ob[ee_mode][obdb], 3, 122, 0, true))
-			return -EINVAL;
-
-		obdb = 1;
-	/* Modify bank 6 */
-	} else {
-		/* For 11a, Turbo and XR */
-		ee_mode = AR5K_EEPROM_MODE_11A;
-		obdb =	 channel->freq >= 5725 ? 3 :
-			(channel->freq >= 5500 ? 2 :
-			(channel->freq >= 5260 ? 1 :
-			 (channel->freq > 4000 ? 0 : -1)));
-
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
-				ee->ee_pwd_84, 1, 51, 3, true))
-			return -EINVAL;
-
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
-				ee->ee_pwd_90, 1, 45, 3, true))
-			return -EINVAL;
-	}
-
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
-			!ee->ee_xpd[ee_mode], 1, 95, 0, true))
-		return -EINVAL;
-
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
-			ee->ee_x_gain[ee_mode], 4, 96, 0, true))
-		return -EINVAL;
-
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6], obdb >= 0 ?
-			ee->ee_ob[ee_mode][obdb] : 0, 3, 104, 0, true))
-		return -EINVAL;
-
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6], obdb >= 0 ?
-			ee->ee_db[ee_mode][obdb] : 0, 3, 107, 0, true))
-		return -EINVAL;
-
-	/* Modify bank 7 */
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[7],
-			ee->ee_i_gain[ee_mode], 6, 29, 0, true))
-		return -EINVAL;
-
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[7],
-			ee->ee_xpd[ee_mode], 1, 4, 0, true))
-		return -EINVAL;
-
-	/* Write RF values */
-	for (i = 0; i < rf_size; i++) {
-		AR5K_REG_WAIT(i);
-		ath5k_hw_reg_write(hal, rf[i], rf5111_rf[i].rf_register);
-	}
-
-	return 0;
-}
-
-/*
- * Read EEPROM Calibration data, modify RF Banks and Initialize RF5112
- */
-static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
-		struct ieee80211_channel *channel, unsigned int mode)
-{
-	const struct ath5k_ini_rf *rf_ini;
-	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
-	u32 *rf;
-	unsigned int rf_size, i;
-	int obdb = -1, bank = -1;
-	u32 ee_mode;
-
-	AR5K_ASSERT_ENTRY(mode, AR5K_INI_VAL_MAX);
-
-	rf = hal->ah_rf_banks;
-
-	if (hal->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A) {
-		rf_ini = rf5112a_rf;
-		rf_size = ARRAY_SIZE(rf5112a_rf);
-	} else {
-		rf_ini = rf5112_rf;
-		rf_size = ARRAY_SIZE(rf5112_rf);
-	}
-
-	/* Copy values to modify them */
-	for (i = 0; i < rf_size; i++) {
-		if (rf_ini[i].rf_bank >= AR5K_RF5112_INI_RF_MAX_BANKS) {
-			AR5K_PRINT("invalid bank\n");
-			return -EINVAL;
-		}
-
-		if (bank != rf_ini[i].rf_bank) {
-			bank = rf_ini[i].rf_bank;
-			hal->ah_offset[bank] = i;
-		}
-
-		rf[i] = rf_ini[i].rf_value[mode];
-	}
-
-	/* Modify bank 6 */
-	if (channel->val & CHANNEL_2GHZ) {
-		if (channel->val & CHANNEL_B)
-			ee_mode = AR5K_EEPROM_MODE_11B;
-		else
-			ee_mode = AR5K_EEPROM_MODE_11G;
-		obdb = 0;
-
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
-				ee->ee_ob[ee_mode][obdb], 3, 287, 0, true))
-			return -EINVAL;
-
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
-				ee->ee_ob[ee_mode][obdb], 3, 290, 0, true))
-			return -EINVAL;
-	} else {
-		/* For 11a, Turbo and XR */
-		ee_mode = AR5K_EEPROM_MODE_11A;
-		obdb = channel->freq >= 5725 ? 3 :
-		    (channel->freq >= 5500 ? 2 :
-			(channel->freq >= 5260 ? 1 :
-			    (channel->freq > 4000 ? 0 : -1)));
-
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
-				ee->ee_ob[ee_mode][obdb], 3, 279, 0, true))
-			return -EINVAL;
-
-		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
-				ee->ee_ob[ee_mode][obdb], 3, 282, 0, true))
-			return -EINVAL;
-	}
-
-#ifdef notyet
-	ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
-	    ee->ee_x_gain[ee_mode], 2, 270, 0, true);
-	ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
-	    ee->ee_x_gain[ee_mode], 2, 257, 0, true);
-#endif
-
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
-			ee->ee_xpd[ee_mode], 1, 302, 0, true))
-		return -EINVAL;
-
-	/* Modify bank 7 */
-	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[7],
-			ee->ee_i_gain[ee_mode], 6, 14, 0, true))
-		return -EINVAL;
-
-	/* Write RF values */
-	for (i = 0; i < rf_size; i++)
-		ath5k_hw_reg_write(hal, rf[i], rf_ini[i].rf_register);
-
-	return 0;
-}
-
-static int ath5k_hw_rfgain(struct ath_hw *hal, unsigned int freq)
-{
-	const struct ath5k_ini_rfgain *ath5k_rfg;
-	unsigned int i, size;
-
-	switch (hal->ah_radio) {
-	case AR5K_RF5111:
-		ath5k_rfg = rf5111_ini_rfgain;
-		size = ARRAY_SIZE(rf5111_ini_rfgain);
-		break;
-	case AR5K_RF5112:
-		ath5k_rfg = rf5112_ini_rfgain;
-		size = ARRAY_SIZE(rf5112_ini_rfgain);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	switch (freq) {
-	case AR5K_INI_RFGAIN_2GHZ:
-	case AR5K_INI_RFGAIN_5GHZ:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	for (i = 0; i < size; i++) {
-		AR5K_REG_WAIT(i);
-		ath5k_hw_reg_write(hal, ath5k_rfg[i].rfg_value[freq],
-			(u32)ath5k_rfg[i].rfg_register);
-	}
-
-	return 0;
-}
-
-enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath_hw *hal)
-{
-	u32 data, type;
-
-	AR5K_TRACE;
-
-	if (hal->ah_rf_banks == NULL || !hal->ah_gain.g_active ||
-			hal->ah_version <= AR5K_AR5211)
-		return AR5K_RFGAIN_INACTIVE;
-
-	if (hal->ah_rf_gain != AR5K_RFGAIN_READ_REQUESTED)
-		goto done;
-
-	data = ath5k_hw_reg_read(hal, AR5K_PHY_PAPD_PROBE);
-
-	if (!(data & AR5K_PHY_PAPD_PROBE_TX_NEXT)) {
-		hal->ah_gain.g_current = data >> AR5K_PHY_PAPD_PROBE_GAINF_S;
-		type = AR5K_REG_MS(data, AR5K_PHY_PAPD_PROBE_TYPE);
-
-		if (type == AR5K_PHY_PAPD_PROBE_TYPE_CCK)
-			hal->ah_gain.g_current += AR5K_GAIN_CCK_PROBE_CORR;
-
-		if (hal->ah_radio == AR5K_RF5112) {
-			ath5k_hw_rfregs_gainf_corr(hal);
-			hal->ah_gain.g_current =
-				hal->ah_gain.g_current>=hal->ah_gain.g_f_corr ?
-				(hal->ah_gain.g_current-hal->ah_gain.g_f_corr) :
-				0;
-		}
-
-		if (ath5k_hw_rfregs_gain_readback(hal) &&
-				AR5K_GAIN_CHECK_ADJUST(&hal->ah_gain) &&
-				ath5k_hw_rfregs_gain_adjust(hal))
-			hal->ah_rf_gain = AR5K_RFGAIN_NEED_CHANGE;
-	}
-
-done:
-	return hal->ah_rf_gain;
-}
-
-/*
- * TX power setup
- */
-
-/*
- * Initialize the tx power table (not fully implemented)
- */
-static void ath5k_txpower_table(struct ath_hw *hal,
-		struct ieee80211_channel *channel, s16 max_power)
-{
-	unsigned int i, min, max, n;
-	u16 txpower, *rates;
-
-	rates = hal->ah_txpower.txp_rates;
-
-	txpower = AR5K_TUNE_DEFAULT_TXPOWER * 2;
-	if (max_power > txpower)
-		txpower = max_power > AR5K_TUNE_MAX_TXPOWER ?
-		    AR5K_TUNE_MAX_TXPOWER : max_power;
-
-	for (i = 0; i < AR5K_MAX_RATES; i++)
-		rates[i] = txpower;
-
-	/* XXX setup target powers by rate */
-
-	hal->ah_txpower.txp_min = rates[7];
-	hal->ah_txpower.txp_max = rates[0];
-	hal->ah_txpower.txp_ofdm = rates[0];
-
-	/* Calculate the power table */
-	n = ARRAY_SIZE(hal->ah_txpower.txp_pcdac);
-	min = AR5K_EEPROM_PCDAC_START;
-	max = AR5K_EEPROM_PCDAC_STOP;
-	for (i = 0; i < n; i += AR5K_EEPROM_PCDAC_STEP)
-		hal->ah_txpower.txp_pcdac[i] =
-#ifdef notyet
-		min + ((i * (max - min)) / n);
-#else
-		min;
-#endif
-}
-
-/*
- * Set transmition power
- */
-static int /*O.K. - txpower_table is unimplemented so this doesn't work*/
-ath5k_hw_txpower(struct ath_hw *hal, struct ieee80211_channel *channel,
-		unsigned int txpower)
-{
-	bool tpc = hal->ah_txpower.txp_tpc;
-	unsigned int i;
-
-	AR5K_TRACE;
-	if (txpower > AR5K_TUNE_MAX_TXPOWER) {
-		AR5K_PRINTF("invalid tx power: %u\n", txpower);
-		return -EINVAL;
-	}
-
-	/* Reset TX power values */
-	memset(&hal->ah_txpower, 0, sizeof(hal->ah_txpower));
-	hal->ah_txpower.txp_tpc = tpc;
-
-	/* Initialize TX power table */
-	ath5k_txpower_table(hal, channel, txpower);
-
-	/*
-	 * Write TX power values
-	 */
-	for (i = 0; i < (AR5K_EEPROM_POWER_TABLE_SIZE / 2); i++) {
-		ath5k_hw_reg_write(hal,
-			((((hal->ah_txpower.txp_pcdac[(i << 1) + 1] << 8) | 0xff) & 0xffff) << 16) |
-			(((hal->ah_txpower.txp_pcdac[(i << 1)    ] << 8) | 0xff) & 0xffff),
-			AR5K_PHY_PCDAC_TXPOWER(i));
-	}
-
-	ath5k_hw_reg_write(hal, AR5K_TXPOWER_OFDM(3, 24) |
-		AR5K_TXPOWER_OFDM(2, 16) | AR5K_TXPOWER_OFDM(1, 8) |
-		AR5K_TXPOWER_OFDM(0, 0), AR5K_PHY_TXPOWER_RATE1);
-
-	ath5k_hw_reg_write(hal, AR5K_TXPOWER_OFDM(7, 24) |
-		AR5K_TXPOWER_OFDM(6, 16) | AR5K_TXPOWER_OFDM(5, 8) |
-		AR5K_TXPOWER_OFDM(4, 0), AR5K_PHY_TXPOWER_RATE2);
-
-	ath5k_hw_reg_write(hal, AR5K_TXPOWER_CCK(10, 24) |
-		AR5K_TXPOWER_CCK(9, 16) | AR5K_TXPOWER_CCK(15, 8) |
-		AR5K_TXPOWER_CCK(8, 0), AR5K_PHY_TXPOWER_RATE3);
-
-	ath5k_hw_reg_write(hal, AR5K_TXPOWER_CCK(14, 24) |
-		AR5K_TXPOWER_CCK(13, 16) | AR5K_TXPOWER_CCK(12, 8) |
-		AR5K_TXPOWER_CCK(11, 0), AR5K_PHY_TXPOWER_RATE4);
-
-	if (hal->ah_txpower.txp_tpc == true)
-		ath5k_hw_reg_write(hal, AR5K_PHY_TXPOWER_RATE_MAX_TPC_ENABLE |
-			AR5K_TUNE_MAX_TXPOWER, AR5K_PHY_TXPOWER_RATE_MAX);
-	else
-		ath5k_hw_reg_write(hal, AR5K_PHY_TXPOWER_RATE_MAX |
-			AR5K_TUNE_MAX_TXPOWER, AR5K_PHY_TXPOWER_RATE_MAX);
-
-	return 0;
-}
-
-int ath5k_hw_set_txpower_limit(struct ath_hw *hal, unsigned int power)
-{
-	/*Just a try M.F.*/
-	struct ieee80211_channel *channel = &hal->ah_current_channel;
-
-	AR5K_TRACE;
-#ifdef AR5K_DEBUG
-	AR5K_PRINTF("changing txpower to %d\n", power);
-#endif
-	return ath5k_hw_txpower(hal, channel, power);
-}
-
-
 
 
 /****************\
diff --git a/drivers/net/wireless/ath5k_hw.h b/drivers/net/wireless/ath5k_hw.h
index 5549135..55ae849 100644
--- a/drivers/net/wireless/ath5k_hw.h
+++ b/drivers/net/wireless/ath5k_hw.h
@@ -15,6 +15,8 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/delay.h>
+
 /*
  * Gain settings
  */
@@ -52,12 +54,6 @@ struct ath5k_gain_opt_step {
 	s32				gos_gain;
 };
 
-struct ath5k_gain_opt {
-	u32			go_default;
-	u32			go_steps_count;
-	const struct ath5k_gain_opt_step	go_step[AR5K_GAIN_STEP_COUNT];
-};
-
 struct ath5k_gain {
 	u32			g_step_idx;
 	u32			g_current;
@@ -69,39 +65,6 @@ struct ath5k_gain {
 	const struct ath5k_gain_opt_step	*g_step;
 };
 
-/*
- * Gain optimization tables...
- */
-#define AR5K_RF5111_GAIN_OPT	{		\
-	4,					\
-	9,					\
-	{					\
-		{ { 4, 1, 1, 1 }, 6 },		\
-		{ { 4, 0, 1, 1 }, 4 },		\
-		{ { 3, 1, 1, 1 }, 3 },		\
-		{ { 4, 0, 0, 1 }, 1 },		\
-		{ { 4, 1, 1, 0 }, 0 },		\
-		{ { 4, 0, 1, 0 }, -2 },		\
-		{ { 3, 1, 1, 0 }, -3 },		\
-		{ { 4, 0, 0, 0 }, -4 },		\
-		{ { 2, 1, 1, 0 }, -6 }		\
-	}					\
-}
-
-#define AR5K_RF5112_GAIN_OPT	{			\
-	1,						\
-	8,						\
-	{						\
-		{ { 3, 0, 0, 0, 0, 0, 0 }, 6 },		\
-		{ { 2, 0, 0, 0, 0, 0, 0 }, 0 },		\
-		{ { 1, 0, 0, 0, 0, 0, 0 }, -3 },	\
-		{ { 0, 0, 0, 0, 0, 0, 0 }, -6 },	\
-		{ { 0, 1, 1, 0, 0, 0, 0 }, -8 },	\
-		{ { 0, 1, 1, 0, 1, 1, 0 }, -10 },	\
-		{ { 0, 1, 0, 1, 1, 1, 0 }, -13 },	\
-		{ { 0, 1, 0, 1, 1, 0, 1 }, -16 },	\
-	}						\
-}
 
 /*
  * HW SPECIFIC STRUCTS
@@ -525,14 +488,6 @@ struct ath5k_hw_tx_status {
 	_reg &= ~(1 << _queue);						\
 } while (0)
 
-/*
- * Unaligned little endian access
- */
-#define AR5K_LE_READ_2	ath5k_hw_read_unaligned_16
-#define AR5K_LE_READ_4	ath5k_hw_read_unaligned_32
-#define AR5K_LE_WRITE_2	ath5k_hw_write_unaligned_16
-#define AR5K_LE_WRITE_4	ath5k_hw_write_unaligned_32
-
 #define AR5K_LOW_ID(_a)(				\
 (_a)[0] | (_a)[1] << 8 | (_a)[2] << 16 | (_a)[3] << 24	\
 )
@@ -604,6 +559,9 @@ struct ath5k_hw_tx_status {
  */
 
 /* Register dumps are done per operation mode */
+#define AR5K_INI_RFGAIN_5GHZ		0
+#define AR5K_INI_RFGAIN_2GHZ		1
+
 #define AR5K_INI_VAL_11A		0
 #define AR5K_INI_VAL_11A_TURBO		1
 #define AR5K_INI_VAL_11B		2
@@ -615,1461 +573,14 @@ struct ath5k_hw_tx_status {
 #define AR5K_RF5111_INI_RF_MAX_BANKS	AR5K_MAX_RF_BANKS
 #define AR5K_RF5112_INI_RF_MAX_BANKS	AR5K_MAX_RF_BANKS
 
-/* Struct to hold initial RF register values (RF Banks) */
-struct ath5k_ini_rf {
-	u8	rf_bank;	/* check out ath5k_reg.h */
-	u16	rf_register;	/* register address */
-	u32	rf_value[5];	/* register value for different modes (above) */
-};
-
-/* RF5111 mode-specific init registers */
-#define AR5K_RF5111_INI_RF	{					      \
-	{ 0, 0x989c,							      \
-	/*    mode a/XR   mode aTurbo mode b      mode g      mode gTurbo */  \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00380000, 0x00380000, 0x00380000, 0x00380000, 0x00380000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x000000c0, 0x00000080, 0x00000080 } }, \
-	{ 0, 0x989c,							      \
-	    { 0x000400f9, 0x000400f9, 0x000400ff, 0x000400fd, 0x000400fd } }, \
-	{ 0, 0x98d4,							      \
-	    { 0x00000000, 0x00000000, 0x00000004, 0x00000004, 0x00000004 } }, \
-	{ 1, 0x98d4,							      \
-	    { 0x00000020, 0x00000020, 0x00000020, 0x00000020, 0x00000020 } }, \
-	{ 2, 0x98d4,							      \
-	    { 0x00000010, 0x00000014, 0x00000010, 0x00000010, 0x00000014 } }, \
-	{ 3, 0x98d8,							      \
-	    { 0x00601068, 0x00601068, 0x00601068, 0x00601068, 0x00601068 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x10000000, 0x10000000, 0x10000000, 0x10000000, 0x10000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x04000000, 0x04000000, 0x04000000, 0x04000000, 0x04000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x0a000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x003800c0, 0x00380080, 0x023800c0, 0x003800c0, 0x003800c0 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00020006, 0x00020006, 0x00000006, 0x00020006, 0x00020006 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000089, 0x00000089, 0x00000089, 0x00000089, 0x00000089 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x000000a0, 0x000000a0, 0x000000a0, 0x000000a0, 0x000000a0 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00040007, 0x00040007, 0x00040007, 0x00040007, 0x00040007 } }, \
-	{ 6, 0x98d4,							      \
-	    { 0x0000001a, 0x0000001a, 0x0000001a, 0x0000001a, 0x0000001a } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000040, 0x00000048, 0x00000040, 0x00000040, 0x00000040 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000010, 0x00000010, 0x00000010, 0x00000010, 0x00000010 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000008, 0x00000008, 0x00000008, 0x00000008, 0x00000008 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x0000004f, 0x0000004f, 0x0000004f, 0x0000004f, 0x0000004f } }, \
-	{ 7, 0x989c,							      \
-	    { 0x000000f1, 0x000000f1, 0x00000061, 0x000000f1, 0x000000f1 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x0000904f, 0x0000904f, 0x0000904c, 0x0000904f, 0x0000904f } }, \
-	{ 7, 0x989c,							      \
-	    { 0x0000125a, 0x0000125a, 0x0000129a, 0x0000125a, 0x0000125a } }, \
-	{ 7, 0x98cc,							      \
-	    { 0x0000000e, 0x0000000e, 0x0000000f, 0x0000000e, 0x0000000e } }, \
-}
+static inline u32 ath5k_hw_bitswap(u32 val, unsigned int bits)
+{
+	u32 retval = 0, bit, i;
 
-/* RF5112 mode-specific init registers */
-#define AR5K_RF5112_INI_RF	{					      \
-	{ 1, 0x98d4,							      \
-	/*    mode a/XR   mode aTurbo mode b      mode g      mode gTurbo */  \
-	    { 0x00000020, 0x00000020, 0x00000020, 0x00000020, 0x00000020 } }, \
-	{ 2, 0x98d0,							      \
-	    { 0x03060408, 0x03070408, 0x03060408, 0x03060408, 0x03070408 } }, \
-	{ 3, 0x98dc,							      \
-	    { 0x00a0c0c0, 0x00a0c0c0, 0x00e0c0c0, 0x00e0c0c0, 0x00e0c0c0 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00a00000, 0x00a00000, 0x00a00000, 0x00a00000, 0x00a00000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x000a0000, 0x000a0000, 0x000a0000, 0x000a0000, 0x000a0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00660000, 0x00660000, 0x00660000, 0x00660000, 0x00660000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00db0000, 0x00db0000, 0x00db0000, 0x00db0000, 0x00db0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00f10000, 0x00f10000, 0x00f10000, 0x00f10000, 0x00f10000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00120000, 0x00120000, 0x00120000, 0x00120000, 0x00120000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00120000, 0x00120000, 0x00120000, 0x00120000, 0x00120000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00730000, 0x00730000, 0x00730000, 0x00730000, 0x00730000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x000c0000, 0x000c0000, 0x000c0000, 0x000c0000, 0x000c0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x008b0000, 0x008b0000, 0x008b0000, 0x008b0000, 0x008b0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00600000, 0x00600000, 0x00600000, 0x00600000, 0x00600000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x000c0000, 0x000c0000, 0x000c0000, 0x000c0000, 0x000c0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00840000, 0x00840000, 0x00840000, 0x00840000, 0x00840000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00640000, 0x00640000, 0x00640000, 0x00640000, 0x00640000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00200000, 0x00200000, 0x00200000, 0x00200000, 0x00200000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00240000, 0x00240000, 0x00240000, 0x00240000, 0x00240000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00250000, 0x00250000, 0x00250000, 0x00250000, 0x00250000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00110000, 0x00110000, 0x00110000, 0x00110000, 0x00110000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00110000, 0x00110000, 0x00110000, 0x00110000, 0x00110000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00510000, 0x00510000, 0x00510000, 0x00510000, 0x00510000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x1c040000, 0x1c040000, 0x1c040000, 0x1c040000, 0x1c040000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x000a0000, 0x000a0000, 0x000a0000, 0x000a0000, 0x000a0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00a10000, 0x00a10000, 0x00a10000, 0x00a10000, 0x00a10000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00400000, 0x00400000, 0x00400000, 0x00400000, 0x00400000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x03090000, 0x03090000, 0x03090000, 0x03090000, 0x03090000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x06000000, 0x06000000, 0x06000000, 0x06000000, 0x06000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x000000b0, 0x000000b0, 0x000000a8, 0x000000a8, 0x000000a8 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x0000002e, 0x0000002e, 0x0000002e, 0x0000002e, 0x0000002e } }, \
-	{ 6, 0x989c,							      \
-	    { 0x006c4a41, 0x006c4a41, 0x006c4af1, 0x006c4a61, 0x006c4a61 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x0050892a, 0x0050892a, 0x0050892b, 0x0050892b, 0x0050892b } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00842400, 0x00842400, 0x00842400, 0x00842400, 0x00842400 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00c69200, 0x00c69200, 0x00c69200, 0x00c69200, 0x00c69200 } }, \
-	{ 6, 0x98d0,							      \
-	    { 0x0002000c, 0x0002000c, 0x0002000c, 0x0002000c, 0x0002000c } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000094, 0x00000094, 0x00000094, 0x00000094, 0x00000094 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000091, 0x00000091, 0x00000091, 0x00000091, 0x00000091 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x0000000a, 0x0000000a, 0x00000012, 0x00000012, 0x00000012 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000080, 0x00000080, 0x00000080, 0x00000080, 0x00000080 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x000000c1, 0x000000c1, 0x000000c1, 0x000000c1, 0x000000c1 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000060, 0x00000060, 0x00000060, 0x00000060, 0x00000060 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x000000f0, 0x000000f0, 0x000000f0, 0x000000f0, 0x000000f0 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000022, 0x00000022, 0x00000022, 0x00000022, 0x00000022 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000092, 0x00000092, 0x00000092, 0x00000092, 0x00000092 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x000000d4, 0x000000d4, 0x000000d4, 0x000000d4, 0x000000d4 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x000014cc, 0x000014cc, 0x000014cc, 0x000014cc, 0x000014cc } }, \
-	{ 7, 0x989c,							      \
-	    { 0x0000048c, 0x0000048c, 0x0000048c, 0x0000048c, 0x0000048c } }, \
-	{ 7, 0x98c4,							      \
-	    { 0x00000003, 0x00000003, 0x00000003, 0x00000003, 0x00000003 } }, \
+	for (i = 0; i < bits; i++) {
+		bit = (val >> i) & 1;
+		retval = (retval << 1) | bit;
 	}
 
-/* RF5112A mode-specific init registers */
-#define AR5K_RF5112A_INI_RF     {					      \
-	{ 1, 0x98d4,							      \
-	/*    mode a/XR   mode aTurbo mode b      mode g      mode gTurbo */  \
-	    { 0x00000020, 0x00000020, 0x00000020, 0x00000020, 0x00000020 } }, \
-	{ 2, 0x98d0,							      \
-	    { 0x03060408, 0x03070408, 0x03060408, 0x03060408, 0x03070408 } }, \
-	{ 3, 0x98dc,							      \
-	    { 0x00a0c0c0, 0x00a0c0c0, 0x00e0c0c0, 0x00e0c0c0, 0x00e0c0c0 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x0f000000, 0x0f000000, 0x0f000000, 0x0f000000, 0x0f000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00800000, 0x00800000, 0x00800000, 0x00800000, 0x00800000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x002a0000, 0x002a0000, 0x002a0000, 0x002a0000, 0x002a0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00010000, 0x00010000, 0x00010000, 0x00010000, 0x00010000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00180000, 0x00180000, 0x00180000, 0x00180000, 0x00180000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00600000, 0x00600000, 0x006e0000, 0x006e0000, 0x006e0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00c70000, 0x00c70000, 0x00c70000, 0x00c70000, 0x00c70000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x004b0000, 0x004b0000, 0x004b0000, 0x004b0000, 0x004b0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x04480000, 0x04480000, 0x04480000, 0x04480000, 0x04480000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00220000, 0x00220000, 0x00220000, 0x00220000, 0x00220000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00e40000, 0x00e40000, 0x00e40000, 0x00e40000, 0x00e40000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00fc0000, 0x00fc0000, 0x00fc0000, 0x00fc0000, 0x00fc0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x043f0000, 0x043f0000, 0x043f0000, 0x043f0000, 0x043f0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x000c0000, 0x000c0000, 0x000c0000, 0x000c0000, 0x000c0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00190000, 0x00190000, 0x00190000, 0x00190000, 0x00190000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00240000, 0x00240000, 0x00240000, 0x00240000, 0x00240000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00b40000, 0x00b40000, 0x00b40000, 0x00b40000, 0x00b40000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00990000, 0x00990000, 0x00990000, 0x00990000, 0x00990000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00500000, 0x00500000, 0x00500000, 0x00500000, 0x00500000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x002a0000, 0x002a0000, 0x002a0000, 0x002a0000, 0x002a0000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00120000, 0x00120000, 0x00120000, 0x00120000, 0x00120000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0xc0320000, 0xc0320000, 0xc0320000, 0xc0320000, 0xc0320000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x01740000, 0x01740000, 0x01740000, 0x01740000, 0x01740000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00110000, 0x00110000, 0x00110000, 0x00110000, 0x00110000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x86280000, 0x86280000, 0x86280000, 0x86280000, 0x86280000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x31840000, 0x31840000, 0x31840000, 0x31840000, 0x31840000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00020080, 0x00020080, 0x00020080, 0x00020080, 0x00020080 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00080009, 0x00080009, 0x00080009, 0x00080009, 0x00080009 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000003, 0x00000003, 0x00000003, 0x00000003, 0x00000003 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x000000b2, 0x000000b2, 0x000000b2, 0x000000b2, 0x000000b2 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00b02084, 0x00b02084, 0x00b02084, 0x00b02084, 0x00b02084 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x004125a4, 0x004125a4, 0x004125a4, 0x004125a4, 0x004125a4 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x00119220, 0x00119220, 0x00119220, 0x00119220, 0x00119220 } }, \
-	{ 6, 0x989c,							      \
-	    { 0x001a4800, 0x001a4800, 0x001a4800, 0x001a4800, 0x001a4800 } }, \
-	{ 6, 0x98d8,							      \
-	    { 0x000b0230, 0x000b0230, 0x000b0230, 0x000b0230, 0x000b0230 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000094, 0x00000094, 0x00000094, 0x00000094, 0x00000094 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000091, 0x00000091, 0x00000091, 0x00000091, 0x00000091 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000012, 0x00000012, 0x00000012, 0x00000012, 0x00000012 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000080, 0x00000080, 0x00000080, 0x00000080, 0x00000080 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x000000d9, 0x000000d9, 0x000000d9, 0x000000d9, 0x000000d9 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000060, 0x00000060, 0x00000060, 0x00000060, 0x00000060 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x000000f0, 0x000000f0, 0x000000f0, 0x000000f0, 0x000000f0 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x000000a2, 0x000000a2, 0x000000a2, 0x000000a2, 0x000000a2 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x00000052, 0x00000052, 0x00000052, 0x00000052, 0x00000052 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x000000d4, 0x000000d4, 0x000000d4, 0x000000d4, 0x000000d4 } }, \
-	{ 7, 0x989c,							      \
-	    { 0x000014cc, 0x000014cc, 0x000014cc, 0x000014cc, 0x000014cc } }, \
-	{ 7, 0x989c,							      \
-	    { 0x0000048c, 0x0000048c, 0x0000048c, 0x0000048c, 0x0000048c } }, \
-	{ 7, 0x98c4,							      \
-	    { 0x00000003, 0x00000003, 0x00000003, 0x00000003, 0x00000003 } }, \
-}
-
-/*
- * Mode-specific RF Gain table (64bytes) for RF5111/5112
- * (RF5110 only comes with AR5210 and only supports a/turbo a mode so initial
- * RF Gain values are included in AR5K_AR5210_INI)
- */
-struct ath5k_ini_rfgain {
-	u16	rfg_register;	/* RF Gain register address */
-	u32	rfg_value[2];	/* [freq (see below)] */
-
-#define AR5K_INI_RFGAIN_5GHZ	0
-#define AR5K_INI_RFGAIN_2GHZ	1
-};
-
-/* Initial RF Gain settings for RF5111 */
-#define AR5K_RF5111_INI_RFGAIN	{				\
-	/*			      5Ghz	2Ghz	*/	\
-	{ AR5K_RF_GAIN(0),	{ 0x000001a9, 0x00000000 } },	\
-	{ AR5K_RF_GAIN(1),	{ 0x000001e9, 0x00000040 } },	\
-	{ AR5K_RF_GAIN(2),	{ 0x00000029, 0x00000080 } },	\
-	{ AR5K_RF_GAIN(3),	{ 0x00000069, 0x00000150 } },	\
-	{ AR5K_RF_GAIN(4),	{ 0x00000199, 0x00000190 } },	\
-	{ AR5K_RF_GAIN(5),	{ 0x000001d9, 0x000001d0 } },	\
-	{ AR5K_RF_GAIN(6),	{ 0x00000019, 0x00000010 } },	\
-	{ AR5K_RF_GAIN(7),	{ 0x00000059, 0x00000044 } },	\
-	{ AR5K_RF_GAIN(8),	{ 0x00000099, 0x00000084 } },	\
-	{ AR5K_RF_GAIN(9),	{ 0x000001a5, 0x00000148 } },	\
-	{ AR5K_RF_GAIN(10),	{ 0x000001e5, 0x00000188 } },	\
-	{ AR5K_RF_GAIN(11),	{ 0x00000025, 0x000001c8 } },	\
-	{ AR5K_RF_GAIN(12),	{ 0x000001c8, 0x00000014 } },	\
-	{ AR5K_RF_GAIN(13),	{ 0x00000008, 0x00000042 } },	\
-	{ AR5K_RF_GAIN(14),	{ 0x00000048, 0x00000082 } },	\
-	{ AR5K_RF_GAIN(15),	{ 0x00000088, 0x00000178 } },	\
-	{ AR5K_RF_GAIN(16),	{ 0x00000198, 0x000001b8 } },	\
-	{ AR5K_RF_GAIN(17),	{ 0x000001d8, 0x000001f8 } },	\
-	{ AR5K_RF_GAIN(18),	{ 0x00000018, 0x00000012 } },	\
-	{ AR5K_RF_GAIN(19),	{ 0x00000058, 0x00000052 } },	\
-	{ AR5K_RF_GAIN(20),	{ 0x00000098, 0x00000092 } },	\
-	{ AR5K_RF_GAIN(21),	{ 0x000001a4, 0x0000017c } },	\
-	{ AR5K_RF_GAIN(22),	{ 0x000001e4, 0x000001bc } },	\
-	{ AR5K_RF_GAIN(23),	{ 0x00000024, 0x000001fc } },	\
-	{ AR5K_RF_GAIN(24),	{ 0x00000064, 0x0000000a } },	\
-	{ AR5K_RF_GAIN(25),	{ 0x000000a4, 0x0000004a } },	\
-	{ AR5K_RF_GAIN(26),	{ 0x000000e4, 0x0000008a } },	\
-	{ AR5K_RF_GAIN(27),	{ 0x0000010a, 0x0000015a } },	\
-	{ AR5K_RF_GAIN(28),	{ 0x0000014a, 0x0000019a } },	\
-	{ AR5K_RF_GAIN(29),	{ 0x0000018a, 0x000001da } },	\
-	{ AR5K_RF_GAIN(30),	{ 0x000001ca, 0x0000000e } },	\
-	{ AR5K_RF_GAIN(31),	{ 0x0000000a, 0x0000004e } },	\
-	{ AR5K_RF_GAIN(32),	{ 0x0000004a, 0x0000008e } },	\
-	{ AR5K_RF_GAIN(33),	{ 0x0000008a, 0x0000015e } },	\
-	{ AR5K_RF_GAIN(34),	{ 0x000001ba, 0x0000019e } },	\
-	{ AR5K_RF_GAIN(35),	{ 0x000001fa, 0x000001de } },	\
-	{ AR5K_RF_GAIN(36),	{ 0x0000003a, 0x00000009 } },	\
-	{ AR5K_RF_GAIN(37),	{ 0x0000007a, 0x00000049 } },	\
-	{ AR5K_RF_GAIN(38),	{ 0x00000186, 0x00000089 } },	\
-	{ AR5K_RF_GAIN(39),	{ 0x000001c6, 0x00000179 } },	\
-	{ AR5K_RF_GAIN(40),	{ 0x00000006, 0x000001b9 } },	\
-	{ AR5K_RF_GAIN(41),	{ 0x00000046, 0x000001f9 } },	\
-	{ AR5K_RF_GAIN(42),	{ 0x00000086, 0x00000039 } },	\
-	{ AR5K_RF_GAIN(43),	{ 0x000000c6, 0x00000079 } },	\
-	{ AR5K_RF_GAIN(44),	{ 0x000000c6, 0x000000b9 } },	\
-	{ AR5K_RF_GAIN(45),	{ 0x000000c6, 0x000001bd } },	\
-	{ AR5K_RF_GAIN(46),	{ 0x000000c6, 0x000001fd } },	\
-	{ AR5K_RF_GAIN(47),	{ 0x000000c6, 0x0000003d } },	\
-	{ AR5K_RF_GAIN(48),	{ 0x000000c6, 0x0000007d } },	\
-	{ AR5K_RF_GAIN(49),	{ 0x000000c6, 0x000000bd } },	\
-	{ AR5K_RF_GAIN(50),	{ 0x000000c6, 0x000000fd } },	\
-	{ AR5K_RF_GAIN(51),	{ 0x000000c6, 0x000000fd } },	\
-	{ AR5K_RF_GAIN(52),	{ 0x000000c6, 0x000000fd } },	\
-	{ AR5K_RF_GAIN(53),	{ 0x000000c6, 0x000000fd } },	\
-	{ AR5K_RF_GAIN(54),	{ 0x000000c6, 0x000000fd } },	\
-	{ AR5K_RF_GAIN(55),	{ 0x000000c6, 0x000000fd } },	\
-	{ AR5K_RF_GAIN(56),	{ 0x000000c6, 0x000000fd } },	\
-	{ AR5K_RF_GAIN(57),	{ 0x000000c6, 0x000000fd } },	\
-	{ AR5K_RF_GAIN(58),	{ 0x000000c6, 0x000000fd } },	\
-	{ AR5K_RF_GAIN(59),	{ 0x000000c6, 0x000000fd } },	\
-	{ AR5K_RF_GAIN(60),	{ 0x000000c6, 0x000000fd } },	\
-	{ AR5K_RF_GAIN(61),	{ 0x000000c6, 0x000000fd } },	\
-	{ AR5K_RF_GAIN(62),	{ 0x000000c6, 0x000000fd } },	\
-	{ AR5K_RF_GAIN(63),	{ 0x000000c6, 0x000000fd } },	\
-}
-
-/* Initial RF Gain settings for RF5112 */
-#define AR5K_RF5112_INI_RFGAIN	{				\
-	/*			      5Ghz	2Ghz	*/	\
-	{ AR5K_RF_GAIN(0),	{ 0x00000007, 0x00000007 } },	\
-	{ AR5K_RF_GAIN(1),	{ 0x00000047, 0x00000047 } },	\
-	{ AR5K_RF_GAIN(2),	{ 0x00000087, 0x00000087 } },	\
-	{ AR5K_RF_GAIN(3),	{ 0x000001a0, 0x000001a0 } },	\
-	{ AR5K_RF_GAIN(4),	{ 0x000001e0, 0x000001e0 } },	\
-	{ AR5K_RF_GAIN(5),	{ 0x00000020, 0x00000020 } },	\
-	{ AR5K_RF_GAIN(6),	{ 0x00000060, 0x00000060 } },	\
-	{ AR5K_RF_GAIN(7),	{ 0x000001a1, 0x000001a1 } },	\
-	{ AR5K_RF_GAIN(8),	{ 0x000001e1, 0x000001e1 } },	\
-	{ AR5K_RF_GAIN(9),	{ 0x00000021, 0x00000021 } },	\
-	{ AR5K_RF_GAIN(10),	{ 0x00000061, 0x00000061 } },	\
-	{ AR5K_RF_GAIN(11),	{ 0x00000162, 0x00000162 } },	\
-	{ AR5K_RF_GAIN(12),	{ 0x000001a2, 0x000001a2 } },	\
-	{ AR5K_RF_GAIN(13),	{ 0x000001e2, 0x000001e2 } },	\
-	{ AR5K_RF_GAIN(14),	{ 0x00000022, 0x00000022 } },	\
-	{ AR5K_RF_GAIN(15),	{ 0x00000062, 0x00000062 } },	\
-	{ AR5K_RF_GAIN(16),	{ 0x00000163, 0x00000163 } },	\
-	{ AR5K_RF_GAIN(17),	{ 0x000001a3, 0x000001a3 } },	\
-	{ AR5K_RF_GAIN(18),	{ 0x000001e3, 0x000001e3 } },	\
-	{ AR5K_RF_GAIN(19),	{ 0x00000023, 0x00000023 } },	\
-	{ AR5K_RF_GAIN(20),	{ 0x00000063, 0x00000063 } },	\
-	{ AR5K_RF_GAIN(21),	{ 0x00000184, 0x00000184 } },	\
-	{ AR5K_RF_GAIN(22),	{ 0x000001c4, 0x000001c4 } },	\
-	{ AR5K_RF_GAIN(23),	{ 0x00000004, 0x00000004 } },	\
-	{ AR5K_RF_GAIN(24),	{ 0x000001ea, 0x0000000b } },	\
-	{ AR5K_RF_GAIN(25),	{ 0x0000002a, 0x0000004b } },	\
-	{ AR5K_RF_GAIN(26),	{ 0x0000006a, 0x0000008b } },	\
-	{ AR5K_RF_GAIN(27),	{ 0x000000aa, 0x000001ac } },	\
-	{ AR5K_RF_GAIN(28),	{ 0x000001ab, 0x000001ec } },	\
-	{ AR5K_RF_GAIN(29),	{ 0x000001eb, 0x0000002c } },	\
-	{ AR5K_RF_GAIN(30),	{ 0x0000002b, 0x00000012 } },	\
-	{ AR5K_RF_GAIN(31),	{ 0x0000006b, 0x00000052 } },	\
-	{ AR5K_RF_GAIN(32),	{ 0x000000ab, 0x00000092 } },	\
-	{ AR5K_RF_GAIN(33),	{ 0x000001ac, 0x00000193 } },	\
-	{ AR5K_RF_GAIN(34),	{ 0x000001ec, 0x000001d3 } },	\
-	{ AR5K_RF_GAIN(35),	{ 0x0000002c, 0x00000013 } },	\
-	{ AR5K_RF_GAIN(36),	{ 0x0000003a, 0x00000053 } },	\
-	{ AR5K_RF_GAIN(37),	{ 0x0000007a, 0x00000093 } },	\
-	{ AR5K_RF_GAIN(38),	{ 0x000000ba, 0x00000194 } },	\
-	{ AR5K_RF_GAIN(39),	{ 0x000001bb, 0x000001d4 } },	\
-	{ AR5K_RF_GAIN(40),	{ 0x000001fb, 0x00000014 } },	\
-	{ AR5K_RF_GAIN(41),	{ 0x0000003b, 0x0000003a } },	\
-	{ AR5K_RF_GAIN(42),	{ 0x0000007b, 0x0000007a } },	\
-	{ AR5K_RF_GAIN(43),	{ 0x000000bb, 0x000000ba } },	\
-	{ AR5K_RF_GAIN(44),	{ 0x000001bc, 0x000001bb } },	\
-	{ AR5K_RF_GAIN(45),	{ 0x000001fc, 0x000001fb } },	\
-	{ AR5K_RF_GAIN(46),	{ 0x0000003c, 0x0000003b } },	\
-	{ AR5K_RF_GAIN(47),	{ 0x0000007c, 0x0000007b } },	\
-	{ AR5K_RF_GAIN(48),	{ 0x000000bc, 0x000000bb } },	\
-	{ AR5K_RF_GAIN(49),	{ 0x000000fc, 0x000001bc } },	\
-	{ AR5K_RF_GAIN(50),	{ 0x000000fc, 0x000001fc } },	\
-	{ AR5K_RF_GAIN(51),	{ 0x000000fc, 0x0000003c } },	\
-	{ AR5K_RF_GAIN(52),	{ 0x000000fc, 0x0000007c } },	\
-	{ AR5K_RF_GAIN(53),	{ 0x000000fc, 0x000000bc } },	\
-	{ AR5K_RF_GAIN(54),	{ 0x000000fc, 0x000000fc } },	\
-	{ AR5K_RF_GAIN(55),	{ 0x000000fc, 0x000000fc } },	\
-	{ AR5K_RF_GAIN(56),	{ 0x000000fc, 0x000000fc } },	\
-	{ AR5K_RF_GAIN(57),	{ 0x000000fc, 0x000000fc } },	\
-	{ AR5K_RF_GAIN(58),	{ 0x000000fc, 0x000000fc } },	\
-	{ AR5K_RF_GAIN(59),	{ 0x000000fc, 0x000000fc } },	\
-	{ AR5K_RF_GAIN(60),	{ 0x000000fc, 0x000000fc } },	\
-	{ AR5K_RF_GAIN(61),	{ 0x000000fc, 0x000000fc } },	\
-	{ AR5K_RF_GAIN(62),	{ 0x000000fc, 0x000000fc } },	\
-	{ AR5K_RF_GAIN(63),	{ 0x000000fc, 0x000000fc } },	\
-}
-
-
-/*
- * MAC/PHY REGISTERS
- */
-
-
-/*
- * Mode-independent initial register writes
- */
-
-struct ath5k_ini {
-	u16	ini_register;
-	u32	ini_value;
-
-	enum {
-		AR5K_INI_WRITE = 0,	/* Default */
-		AR5K_INI_READ = 1,	/* Cleared on read */
-	} ini_mode;
-};
-
-/* Initial register settings for AR5210 */
-#define AR5K_AR5210_INI {		\
-	/* PCU and MAC registers */	\
-	{ AR5K_NOQCU_TXDP0,	0 },	\
-	{ AR5K_NOQCU_TXDP1,	0 },	\
-	{ AR5K_RXDP,		0 },	\
-	{ AR5K_CR,		0 },	\
-	{ AR5K_ISR,		0, AR5K_INI_READ },	\
-	{ AR5K_IMR,		0 },	\
-	{ AR5K_IER,		AR5K_IER_DISABLE },	\
-	{ AR5K_BSR,		0, AR5K_INI_READ },	\
-	{ AR5K_TXCFG,		AR5K_DMASIZE_128B },	\
-	{ AR5K_RXCFG,		AR5K_DMASIZE_128B },	\
-	{ AR5K_CFG,		AR5K_INIT_CFG },	\
-	{ AR5K_TOPS,		AR5K_INIT_TOPS },	\
-	{ AR5K_RXNOFRM,		AR5K_INIT_RXNOFRM },	\
-	{ AR5K_RPGTO,		AR5K_INIT_RPGTO },	\
-	{ AR5K_TXNOFRM,		AR5K_INIT_TXNOFRM },	\
-	{ AR5K_SFR,		0 },	\
-	{ AR5K_MIBC,		0 },	\
-	{ AR5K_MISC,		0 },	\
-	{ AR5K_RX_FILTER_5210,	0 },	\
-	{ AR5K_MCAST_FILTER0_5210, 0 },	\
-	{ AR5K_MCAST_FILTER1_5210, 0 },	\
-	{ AR5K_TX_MASK0,	0 },	\
-	{ AR5K_TX_MASK1,	0 },	\
-	{ AR5K_CLR_TMASK,	0 },	\
-	{ AR5K_TRIG_LVL,	AR5K_TUNE_MIN_TX_FIFO_THRES },	\
-	{ AR5K_DIAG_SW_5210,	0 },	\
-	{ AR5K_RSSI_THR,	AR5K_TUNE_RSSI_THRES },	\
-	{ AR5K_TSF_L32_5210,	0 },	\
-	{ AR5K_TIMER0_5210,	0 },	\
-	{ AR5K_TIMER1_5210,	0xffffffff },	\
-	{ AR5K_TIMER2_5210,	0xffffffff },	\
-	{ AR5K_TIMER3_5210,	1 },	\
-	{ AR5K_CFP_DUR_5210,	0 },	\
-	{ AR5K_CFP_PERIOD_5210,	0 },	\
-	/* PHY registers */		\
-	{ AR5K_PHY(0),	0x00000047 },	\
-	{ AR5K_PHY_AGC,	0x00000000 },	\
-	{ AR5K_PHY(3),	0x09848ea6 },	\
-	{ AR5K_PHY(4),	0x3d32e000 },	\
-	{ AR5K_PHY(5),	0x0000076b },	\
-	{ AR5K_PHY_ACT,	AR5K_PHY_ACT_DISABLE },	\
-	{ AR5K_PHY(8),	0x02020200 },	\
-	{ AR5K_PHY(9),	0x00000e0e },	\
-	{ AR5K_PHY(10),	0x0a020201 },	\
-	{ AR5K_PHY(11),	0x00036ffc },	\
-	{ AR5K_PHY(12),	0x00000000 },	\
-	{ AR5K_PHY(13),	0x00000e0e },	\
-	{ AR5K_PHY(14),	0x00000007 },	\
-	{ AR5K_PHY(15),	0x00020100 },	\
-	{ AR5K_PHY(16),	0x89630000 },	\
-	{ AR5K_PHY(17),	0x1372169c },	\
-	{ AR5K_PHY(18),	0x0018b633 },	\
-	{ AR5K_PHY(19),	0x1284613c },	\
-	{ AR5K_PHY(20),	0x0de8b8e0 },	\
-	{ AR5K_PHY(21),	0x00074859 },	\
-	{ AR5K_PHY(22),	0x7e80beba },	\
-	{ AR5K_PHY(23),	0x313a665e },	\
-	{ AR5K_PHY_AGCCTL, 0x00001d08 },\
-	{ AR5K_PHY(25),	0x0001ce00 },	\
-	{ AR5K_PHY(26),	0x409a4190 },	\
-	{ AR5K_PHY(28),	0x0000000f },	\
-	{ AR5K_PHY(29),	0x00000080 },	\
-	{ AR5K_PHY(30),	0x00000004 },	\
-	{ AR5K_PHY(31),	0x00000018 }, 	/* 0x987c */	\
-	{ AR5K_PHY(64),	0x00000000 }, 	/* 0x9900 */	\
-	{ AR5K_PHY(65),	0x00000000 },	\
-	{ AR5K_PHY(66),	0x00000000 },	\
-	{ AR5K_PHY(67),	0x00800000 },	\
-	{ AR5K_PHY(68),	0x00000003 },	\
-	/* BB gain table (64bytes) */	\
-	{ AR5K_BB_GAIN(0), 0x00000000 },	\
-	{ AR5K_BB_GAIN(1), 0x00000020 },	\
-	{ AR5K_BB_GAIN(2), 0x00000010 },	\
-	{ AR5K_BB_GAIN(3), 0x00000030 },	\
-	{ AR5K_BB_GAIN(4), 0x00000008 },	\
-	{ AR5K_BB_GAIN(5), 0x00000028 },	\
-	{ AR5K_BB_GAIN(6), 0x00000028 },	\
-	{ AR5K_BB_GAIN(7), 0x00000004 },	\
-	{ AR5K_BB_GAIN(8), 0x00000024 },	\
-	{ AR5K_BB_GAIN(9), 0x00000014 },	\
-	{ AR5K_BB_GAIN(10), 0x00000034 },	\
-	{ AR5K_BB_GAIN(11), 0x0000000c },	\
-	{ AR5K_BB_GAIN(12), 0x0000002c },	\
-	{ AR5K_BB_GAIN(13), 0x00000002 },	\
-	{ AR5K_BB_GAIN(14), 0x00000022 },	\
-	{ AR5K_BB_GAIN(15), 0x00000012 },	\
-	{ AR5K_BB_GAIN(16), 0x00000032 },	\
-	{ AR5K_BB_GAIN(17), 0x0000000a },	\
-	{ AR5K_BB_GAIN(18), 0x0000002a },	\
-	{ AR5K_BB_GAIN(19), 0x00000001 },	\
-	{ AR5K_BB_GAIN(20), 0x00000021 },	\
-	{ AR5K_BB_GAIN(21), 0x00000011 },	\
-	{ AR5K_BB_GAIN(22), 0x00000031 },	\
-	{ AR5K_BB_GAIN(23), 0x00000009 },	\
-	{ AR5K_BB_GAIN(24), 0x00000029 },	\
-	{ AR5K_BB_GAIN(25), 0x00000005 },	\
-	{ AR5K_BB_GAIN(26), 0x00000025 },	\
-	{ AR5K_BB_GAIN(27), 0x00000015 },	\
-	{ AR5K_BB_GAIN(28), 0x00000035 },	\
-	{ AR5K_BB_GAIN(29), 0x0000000d },	\
-	{ AR5K_BB_GAIN(30), 0x0000002d },	\
-	{ AR5K_BB_GAIN(31), 0x00000003 },	\
-	{ AR5K_BB_GAIN(32), 0x00000023 },	\
-	{ AR5K_BB_GAIN(33), 0x00000013 },	\
-	{ AR5K_BB_GAIN(34), 0x00000033 },	\
-	{ AR5K_BB_GAIN(35), 0x0000000b },	\
-	{ AR5K_BB_GAIN(36), 0x0000002b },	\
-	{ AR5K_BB_GAIN(37), 0x00000007 },	\
-	{ AR5K_BB_GAIN(38), 0x00000027 },	\
-	{ AR5K_BB_GAIN(39), 0x00000017 },	\
-	{ AR5K_BB_GAIN(40), 0x00000037 },	\
-	{ AR5K_BB_GAIN(41), 0x0000000f },	\
-	{ AR5K_BB_GAIN(42), 0x0000002f },	\
-	{ AR5K_BB_GAIN(43), 0x0000002f },	\
-	{ AR5K_BB_GAIN(44), 0x0000002f },	\
-	{ AR5K_BB_GAIN(45), 0x0000002f },	\
-	{ AR5K_BB_GAIN(46), 0x0000002f },	\
-	{ AR5K_BB_GAIN(47), 0x0000002f },	\
-	{ AR5K_BB_GAIN(48), 0x0000002f },	\
-	{ AR5K_BB_GAIN(49), 0x0000002f },	\
-	{ AR5K_BB_GAIN(50), 0x0000002f },	\
-	{ AR5K_BB_GAIN(51), 0x0000002f },	\
-	{ AR5K_BB_GAIN(52), 0x0000002f },	\
-	{ AR5K_BB_GAIN(53), 0x0000002f },	\
-	{ AR5K_BB_GAIN(54), 0x0000002f },	\
-	{ AR5K_BB_GAIN(55), 0x0000002f },	\
-	{ AR5K_BB_GAIN(56), 0x0000002f },	\
-	{ AR5K_BB_GAIN(57), 0x0000002f },	\
-	{ AR5K_BB_GAIN(58), 0x0000002f },	\
-	{ AR5K_BB_GAIN(59), 0x0000002f },	\
-	{ AR5K_BB_GAIN(60), 0x0000002f },	\
-	{ AR5K_BB_GAIN(61), 0x0000002f },	\
-	{ AR5K_BB_GAIN(62), 0x0000002f },	\
-	{ AR5K_BB_GAIN(63), 0x0000002f },	\
-	/* 5110 RF gain table (64btes) */	\
-	{ AR5K_RF_GAIN(0), 0x0000001d },	\
-	{ AR5K_RF_GAIN(1), 0x0000005d },	\
-	{ AR5K_RF_GAIN(2), 0x0000009d },	\
-	{ AR5K_RF_GAIN(3), 0x000000dd },	\
-	{ AR5K_RF_GAIN(4), 0x0000011d },	\
-	{ AR5K_RF_GAIN(5), 0x00000021 },	\
-	{ AR5K_RF_GAIN(6), 0x00000061 },	\
-	{ AR5K_RF_GAIN(7), 0x000000a1 },	\
-	{ AR5K_RF_GAIN(8), 0x000000e1 },	\
-	{ AR5K_RF_GAIN(9), 0x00000031 },	\
-	{ AR5K_RF_GAIN(10), 0x00000071 },	\
-	{ AR5K_RF_GAIN(11), 0x000000b1 },	\
-	{ AR5K_RF_GAIN(12), 0x0000001c },	\
-	{ AR5K_RF_GAIN(13), 0x0000005c },	\
-	{ AR5K_RF_GAIN(14), 0x00000029 },	\
-	{ AR5K_RF_GAIN(15), 0x00000069 },	\
-	{ AR5K_RF_GAIN(16), 0x000000a9 },	\
-	{ AR5K_RF_GAIN(17), 0x00000020 },	\
-	{ AR5K_RF_GAIN(18), 0x00000019 },	\
-	{ AR5K_RF_GAIN(19), 0x00000059 },	\
-	{ AR5K_RF_GAIN(20), 0x00000099 },	\
-	{ AR5K_RF_GAIN(21), 0x00000030 },	\
-	{ AR5K_RF_GAIN(22), 0x00000005 },	\
-	{ AR5K_RF_GAIN(23), 0x00000025 },	\
-	{ AR5K_RF_GAIN(24), 0x00000065 },	\
-	{ AR5K_RF_GAIN(25), 0x000000a5 },	\
-	{ AR5K_RF_GAIN(26), 0x00000028 },	\
-	{ AR5K_RF_GAIN(27), 0x00000068 },	\
-	{ AR5K_RF_GAIN(28), 0x0000001f },	\
-	{ AR5K_RF_GAIN(29), 0x0000001e },	\
-	{ AR5K_RF_GAIN(30), 0x00000018 },	\
-	{ AR5K_RF_GAIN(31), 0x00000058 },	\
-	{ AR5K_RF_GAIN(32), 0x00000098 },	\
-	{ AR5K_RF_GAIN(33), 0x00000003 },	\
-	{ AR5K_RF_GAIN(34), 0x00000004 },	\
-	{ AR5K_RF_GAIN(35), 0x00000044 },	\
-	{ AR5K_RF_GAIN(36), 0x00000084 },	\
-	{ AR5K_RF_GAIN(37), 0x00000013 },	\
-	{ AR5K_RF_GAIN(38), 0x00000012 },	\
-	{ AR5K_RF_GAIN(39), 0x00000052 },	\
-	{ AR5K_RF_GAIN(40), 0x00000092 },	\
-	{ AR5K_RF_GAIN(41), 0x000000d2 },	\
-	{ AR5K_RF_GAIN(42), 0x0000002b },	\
-	{ AR5K_RF_GAIN(43), 0x0000002a },	\
-	{ AR5K_RF_GAIN(44), 0x0000006a },	\
-	{ AR5K_RF_GAIN(45), 0x000000aa },	\
-	{ AR5K_RF_GAIN(46), 0x0000001b },	\
-	{ AR5K_RF_GAIN(47), 0x0000001a },	\
-	{ AR5K_RF_GAIN(48), 0x0000005a },	\
-	{ AR5K_RF_GAIN(49), 0x0000009a },	\
-	{ AR5K_RF_GAIN(50), 0x000000da },	\
-	{ AR5K_RF_GAIN(51), 0x00000006 },	\
-	{ AR5K_RF_GAIN(52), 0x00000006 },	\
-	{ AR5K_RF_GAIN(53), 0x00000006 },	\
-	{ AR5K_RF_GAIN(54), 0x00000006 },	\
-	{ AR5K_RF_GAIN(55), 0x00000006 },	\
-	{ AR5K_RF_GAIN(56), 0x00000006 },	\
-	{ AR5K_RF_GAIN(57), 0x00000006 },	\
-	{ AR5K_RF_GAIN(58), 0x00000006 },	\
-	{ AR5K_RF_GAIN(59), 0x00000006 },	\
-	{ AR5K_RF_GAIN(60), 0x00000006 },	\
-	{ AR5K_RF_GAIN(61), 0x00000006 },	\
-	{ AR5K_RF_GAIN(62), 0x00000006 },	\
-	{ AR5K_RF_GAIN(63), 0x00000006 },	\
-	/* PHY activation */			\
-	{ AR5K_PHY(53), 0x00000020 },		\
-	{ AR5K_PHY(51), 0x00000004 },		\
-	{ AR5K_PHY(50), 0x00060106 },		\
-	{ AR5K_PHY(39), 0x0000006d },		\
-	{ AR5K_PHY(48), 0x00000000 },		\
-	{ AR5K_PHY(52), 0x00000014 },		\
-	{ AR5K_PHY_ACT, AR5K_PHY_ACT_ENABLE },	\
-}
-
-
-/* Initial register settings for AR5211 */
-#define AR5K_AR5211_INI {			\
-	{ AR5K_RXDP,		0x00000000 },	\
-	{ AR5K_RTSD0,		0x84849c9c },	\
-	{ AR5K_RTSD1,		0x7c7c7c7c },	\
-	{ AR5K_RXCFG,		0x00000005 },	\
-	{ AR5K_MIBC,		0x00000000 },	\
-	{ AR5K_TOPS,		0x00000008 },	\
-	{ AR5K_RXNOFRM,		0x00000008 },	\
-	{ AR5K_TXNOFRM,		0x00000010 },	\
-	{ AR5K_RPGTO,		0x00000000 },	\
-	{ AR5K_RFCNT,		0x0000001f },	\
-	{ AR5K_QUEUE_TXDP(0),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(1),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(2),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(3),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(4),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(5),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(6),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(7),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(8),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(9),	0x00000000 },	\
-	{ AR5K_DCU_FP,		0x00000000 },	\
-	{ AR5K_STA_ID1,		0x00000000 },	\
-	{ AR5K_BSS_ID0,		0x00000000 },	\
-	{ AR5K_BSS_ID1,		0x00000000 },	\
-	{ AR5K_RSSI_THR,	0x00000000 },	\
-	{ AR5K_CFP_PERIOD_5211,	0x00000000 },	\
-	{ AR5K_TIMER0_5211,	0x00000030 },	\
-	{ AR5K_TIMER1_5211,	0x0007ffff },	\
-	{ AR5K_TIMER2_5211,	0x01ffffff },	\
-	{ AR5K_TIMER3_5211,	0x00000031 },	\
-	{ AR5K_CFP_DUR_5211,	0x00000000 },	\
-	{ AR5K_RX_FILTER_5211,	0x00000000 },	\
-	{ AR5K_MCAST_FILTER0_5211, 0x00000000 },\
-	{ AR5K_MCAST_FILTER1_5211, 0x00000002 },\
-	{ AR5K_DIAG_SW_5211,	0x00000000 },	\
-	{ AR5K_ADDAC_TEST,	0x00000000 },	\
-	{ AR5K_DEFAULT_ANTENNA,	0x00000000 },	\
-	/* PHY registers */			\
-	{ AR5K_PHY_AGC,	0x00000000 },		\
-	{ AR5K_PHY(3),	0x2d849093 },		\
-	{ AR5K_PHY(4),	0x7d32e000 },		\
-	{ AR5K_PHY(5),	0x00000f6b },		\
-	{ AR5K_PHY_ACT,	0x00000000 },		\
-	{ AR5K_PHY(11),	0x00026ffe },		\
-	{ AR5K_PHY(12),	0x00000000 },		\
-	{ AR5K_PHY(15),	0x00020100 },		\
-	{ AR5K_PHY(16),	0x206a017a },		\
-	{ AR5K_PHY(19),	0x1284613c },		\
-	{ AR5K_PHY(21),	0x00000859 },		\
-	{ AR5K_PHY(26),	0x409a4190 },	/* 0x9868 */	\
-	{ AR5K_PHY(27),	0x050cb081 },		\
-	{ AR5K_PHY(28),	0x0000000f },		\
-	{ AR5K_PHY(29),	0x00000080 },		\
-	{ AR5K_PHY(30),	0x0000000c },		\
-	{ AR5K_PHY(64),	0x00000000 },		\
-	{ AR5K_PHY(65),	0x00000000 },		\
-	{ AR5K_PHY(66),	0x00000000 },		\
-	{ AR5K_PHY(67),	0x00800000 },		\
-	{ AR5K_PHY(68),	0x00000001 },		\
-	{ AR5K_PHY(71),	0x0000092a },		\
-	{ AR5K_PHY_IQ,	0x00000000 },		\
-	{ AR5K_PHY(73),	0x00058a05 },		\
-	{ AR5K_PHY(74),	0x00000001 },		\
-	{ AR5K_PHY(75),	0x00000000 },		\
-	{ AR5K_PHY_PAPD_PROBE, 0x00000000 },	\
-	{ AR5K_PHY(77),	0x00000000 },	/* 0x9934 */	\
-	{ AR5K_PHY(78),	0x00000000 },	/* 0x9938 */	\
-	{ AR5K_PHY(79),	0x0000003f },	/* 0x993c */	\
-	{ AR5K_PHY(80),	0x00000004 },		\
-	{ AR5K_PHY(82),	0x00000000 },		\
-	{ AR5K_PHY(83),	0x00000000 },		\
-	{ AR5K_PHY(84),	0x00000000 },		\
-	{ AR5K_PHY_RADAR, 0x5d50f14c },		\
-	{ AR5K_PHY(86),	0x00000018 },		\
-	{ AR5K_PHY(87),	0x004b6a8e },		\
-	/* Power table (32bytes) */			\
-	{ AR5K_PHY_PCDAC_TXPOWER(1), 0x06ff05ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(2), 0x07ff07ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(3), 0x08ff08ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(4), 0x09ff09ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(5), 0x0aff0aff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(6), 0x0bff0bff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(7), 0x0cff0cff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(8), 0x0dff0dff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(9), 0x0fff0eff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(10), 0x12ff12ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(11), 0x14ff13ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(12), 0x16ff15ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(13), 0x19ff17ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(14), 0x1bff1aff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(15), 0x1eff1dff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(16), 0x23ff20ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(17), 0x27ff25ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(18), 0x2cff29ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(19), 0x31ff2fff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(20), 0x37ff34ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(21), 0x3aff3aff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(22), 0x3aff3aff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(23), 0x3aff3aff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(24), 0x3aff3aff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(25), 0x3aff3aff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(26), 0x3aff3aff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(27), 0x3aff3aff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(28), 0x3aff3aff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(29), 0x3aff3aff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(30), 0x3aff3aff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(31), 0x3aff3aff },	\
-	{ AR5K_PHY_CCKTXCTL, 0x00000000 },	\
-	{ AR5K_PHY(642), 0x503e4646 },		\
-	{ AR5K_PHY_GAIN_2GHZ, 0x6480416c },	\
-	{ AR5K_PHY(644), 0x0199a003 },		\
-	{ AR5K_PHY(645), 0x044cd610 },		\
-	{ AR5K_PHY(646), 0x13800040 },		\
-	{ AR5K_PHY(647), 0x1be00060 },		\
-	{ AR5K_PHY(648), 0x0c53800a },		\
-	{ AR5K_PHY(649), 0x0014df3b },		\
-	{ AR5K_PHY(650), 0x000001b5 },		\
-	{ AR5K_PHY(651), 0x00000020 },		\
-}
-
-/* Initial register settings for AR5212 */
-#define AR5K_AR5212_INI {			\
-	{ AR5K_RXDP,		0x00000000 },	\
-	{ AR5K_RXCFG,		0x00000005 },	\
-	{ AR5K_MIBC,		0x00000000 },	\
-	{ AR5K_TOPS,		0x00000008 },	\
-	{ AR5K_RXNOFRM,		0x00000008 },	\
-	{ AR5K_TXNOFRM,		0x00000010 },	\
-	{ AR5K_RPGTO,		0x00000000 },	\
-	{ AR5K_RFCNT,		0x0000001f },	\
-	{ AR5K_QUEUE_TXDP(0),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(1),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(2),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(3),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(4),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(5),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(6),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(7),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(8),	0x00000000 },	\
-	{ AR5K_QUEUE_TXDP(9),	0x00000000 },	\
-	{ AR5K_DCU_FP,		0x00000000 },	\
-	{ AR5K_DCU_TXP,		0x00000000 },	\
-	{ AR5K_DCU_TX_FILTER,	0x00000000 },	\
-	/* Unknown table */			\
-	{ 0x1078, 0x00000000 },			\
-	{ 0x10b8, 0x00000000 },			\
-	{ 0x10f8, 0x00000000 },			\
-	{ 0x1138, 0x00000000 },			\
-	{ 0x1178, 0x00000000 },			\
-	{ 0x11b8, 0x00000000 },			\
-	{ 0x11f8, 0x00000000 },			\
-	{ 0x1238, 0x00000000 },			\
-	{ 0x1278, 0x00000000 },			\
-	{ 0x12b8, 0x00000000 },			\
-	{ 0x12f8, 0x00000000 },			\
-	{ 0x1338, 0x00000000 },			\
-	{ 0x1378, 0x00000000 },			\
-	{ 0x13b8, 0x00000000 },			\
-	{ 0x13f8, 0x00000000 },			\
-	{ 0x1438, 0x00000000 },			\
-	{ 0x1478, 0x00000000 },			\
-	{ 0x14b8, 0x00000000 },			\
-	{ 0x14f8, 0x00000000 },			\
-	{ 0x1538, 0x00000000 },			\
-	{ 0x1578, 0x00000000 },			\
-	{ 0x15b8, 0x00000000 },			\
-	{ 0x15f8, 0x00000000 },			\
-	{ 0x1638, 0x00000000 },			\
-	{ 0x1678, 0x00000000 },			\
-	{ 0x16b8, 0x00000000 },			\
-	{ 0x16f8, 0x00000000 },			\
-	{ 0x1738, 0x00000000 },			\
-	{ 0x1778, 0x00000000 },			\
-	{ 0x17b8, 0x00000000 },			\
-	{ 0x17f8, 0x00000000 },			\
-	{ 0x103c, 0x00000000 },			\
-	{ 0x107c, 0x00000000 },			\
-	{ 0x10bc, 0x00000000 },			\
-	{ 0x10fc, 0x00000000 },			\
-	{ 0x113c, 0x00000000 },			\
-	{ 0x117c, 0x00000000 },			\
-	{ 0x11bc, 0x00000000 },			\
-	{ 0x11fc, 0x00000000 },			\
-	{ 0x123c, 0x00000000 },			\
-	{ 0x127c, 0x00000000 },			\
-	{ 0x12bc, 0x00000000 },			\
-	{ 0x12fc, 0x00000000 },			\
-	{ 0x133c, 0x00000000 },			\
-	{ 0x137c, 0x00000000 },			\
-	{ 0x13bc, 0x00000000 },			\
-	{ 0x13fc, 0x00000000 },			\
-	{ 0x143c, 0x00000000 },			\
-	{ 0x147c, 0x00000000 },			\
-	{ AR5K_STA_ID1,		0x00000000 },	\
-	{ AR5K_BSS_ID0,		0x00000000 },	\
-	{ AR5K_BSS_ID1,		0x00000000 },	\
-	{ AR5K_RSSI_THR,	0x00000000 },	\
-	{ AR5K_BEACON_5211,	0x00000000 },	\
-	{ AR5K_CFP_PERIOD_5211,	0x00000000 },	\
-	{ AR5K_TIMER0_5211,	0x00000030 },	\
-	{ AR5K_TIMER1_5211,	0x0007ffff },	\
-	{ AR5K_TIMER2_5211,	0x01ffffff },	\
-	{ AR5K_TIMER3_5211,	0x00000031 },	\
-	{ AR5K_CFP_DUR_5211,	0x00000000 },	\
-	{ AR5K_RX_FILTER_5211,	0x00000000 },	\
-	{ AR5K_DIAG_SW_5211,	0x00000000 },	\
-	{ AR5K_ADDAC_TEST,	0x00000000 },	\
-	{ AR5K_DEFAULT_ANTENNA,	0x00000000 },	\
-	{ 0x805c, 0xffffc7ff },			\
-	{ 0x8080, 0x00000000 },			\
-	{ AR5K_NAV_5211,	0x00000000 },	\
-	{ AR5K_RTS_OK_5211,	0x00000000 },	\
-	{ AR5K_RTS_FAIL_5211,	0x00000000 },	\
-	{ AR5K_ACK_FAIL_5211,	0x00000000 },	\
-	{ AR5K_FCS_FAIL_5211,	0x00000000 },	\
-	{ AR5K_BEACON_CNT_5211,	0x00000000 },	\
-	{ AR5K_XRMODE,		0x2a82301a },	\
-	{ AR5K_XRDELAY,		0x05dc01e0 },	\
-	{ AR5K_XRTIMEOUT,	0x1f402710 },	\
-	{ AR5K_XRCHIRP,		0x01f40000 },	\
-	{ AR5K_XRSTOMP,		0x00001e1c },	\
-	{ AR5K_SLEEP0,		0x0002aaaa },	\
-	{ AR5K_SLEEP1,		0x02005555 },	\
-	{ AR5K_SLEEP2,		0x00000000 },	\
-	{ AR5K_BSS_IDM0,	0xffffffff },	\
-	{ AR5K_BSS_IDM1,	0x0000ffff },	\
-	{ AR5K_TXPC,		0x00000000 },	\
-	{ AR5K_PROFCNT_TX,	0x00000000 },	\
-	{ AR5K_PROFCNT_RX,	0x00000000 },	\
-	{ AR5K_PROFCNT_RXCLR,	0x00000000 },	\
-	{ AR5K_PROFCNT_CYCLE,	0x00000000 },	\
-	{ 0x80fc, 0x00000088 },			\
-	{ AR5K_RATE_DUR(0),	0x00000000 },	\
-	{ AR5K_RATE_DUR(1),	0x0000008c },	\
-	{ AR5K_RATE_DUR(2),	0x000000e4 },	\
-	{ AR5K_RATE_DUR(3),	0x000002d5 },	\
-	{ AR5K_RATE_DUR(4),	0x00000000 },	\
-	{ AR5K_RATE_DUR(5),	0x00000000 },	\
-	{ AR5K_RATE_DUR(6),	0x000000a0 },	\
-	{ AR5K_RATE_DUR(7),	0x000001c9 },	\
-	{ AR5K_RATE_DUR(8),	0x0000002c },	\
-	{ AR5K_RATE_DUR(9),	0x0000002c },	\
-	{ AR5K_RATE_DUR(10),	0x00000030 },	\
-	{ AR5K_RATE_DUR(11),	0x0000003c },	\
-	{ AR5K_RATE_DUR(12),	0x0000002c },	\
-	{ AR5K_RATE_DUR(13),	0x0000002c },	\
-	{ AR5K_RATE_DUR(14),	0x00000030 },	\
-	{ AR5K_RATE_DUR(15),	0x0000003c },	\
-	{ AR5K_RATE_DUR(16),	0x00000000 },	\
-	{ AR5K_RATE_DUR(17),	0x00000000 },	\
-	{ AR5K_RATE_DUR(18),	0x00000000 },	\
-	{ AR5K_RATE_DUR(19),	0x00000000 },	\
-	{ AR5K_RATE_DUR(20),	0x00000000 },	\
-	{ AR5K_RATE_DUR(21),	0x00000000 },	\
-	{ AR5K_RATE_DUR(22),	0x00000000 },	\
-	{ AR5K_RATE_DUR(23),	0x00000000 },	\
-	{ AR5K_RATE_DUR(24),	0x000000d5 },	\
-	{ AR5K_RATE_DUR(25),	0x000000df },	\
-	{ AR5K_RATE_DUR(26),	0x00000102 },	\
-	{ AR5K_RATE_DUR(27),	0x0000013a },	\
-	{ AR5K_RATE_DUR(28),	0x00000075 },	\
-	{ AR5K_RATE_DUR(29),	0x0000007f },	\
-	{ AR5K_RATE_DUR(30),	0x000000a2 },	\
-	{ AR5K_RATE_DUR(31),	0x00000000 },	\
-	{ 0x8100, 0x00010002},			\
-	{ AR5K_TSF_PARM,	0x00000001 },	\
-	{ 0x8108, 0x000000c0 },			\
-	{ AR5K_PHY_ERR_FIL,	0x00000000 },	\
-	{ 0x8110, 0x00000168 },			\
-	{ 0x8114, 0x00000000 },			\
-	/* Some kind of table			\
-	 * also notice ...03<-02<-01<-00) */	\
-	{ 0x87c0, 0x03020100 },			\
-	{ 0x87c4, 0x07060504 },			\
-	{ 0x87c8, 0x0b0a0908 },			\
-	{ 0x87cc, 0x0f0e0d0c },			\
-	{ 0x87d0, 0x13121110 },			\
-	{ 0x87d4, 0x17161514 },			\
-	{ 0x87d8, 0x1b1a1918 },			\
-	{ 0x87dc, 0x1f1e1d1c },			\
-	/* loop ? */				\
-	{ 0x87e0, 0x03020100 },			\
-	{ 0x87e4, 0x07060504 },			\
-	{ 0x87e8, 0x0b0a0908 },			\
-	{ 0x87ec, 0x0f0e0d0c },			\
-	{ 0x87f0, 0x13121110 },			\
-	{ 0x87f4, 0x17161514 },			\
-	{ 0x87f8, 0x1b1a1918 },			\
-	{ 0x87fc, 0x1f1e1d1c },			\
-	/* PHY registers */			\
-	{ AR5K_PHY_AGC,	0x00000000 },		\
-	{ AR5K_PHY(3),	0xad848e19 },		\
-	{ AR5K_PHY(4),	0x7d28e000 },		\
-	{ AR5K_PHY_TIMING_3, 0x9c0a9f6b },	\
-	{ AR5K_PHY_ACT,	0x00000000 },		\
-	{ AR5K_PHY(11),	0x00022ffe },		\
-	{ AR5K_PHY(15),	0x00020100 },		\
-	{ AR5K_PHY(16),	0x206a017a },		\
-	{ AR5K_PHY(19),	0x1284613c },		\
-	{ AR5K_PHY(21),	0x00000859 },		\
-	{ AR5K_PHY(64),	0x00000000 },		\
-	{ AR5K_PHY(65),	0x00000000 },		\
-	{ AR5K_PHY(66),	0x00000000 },		\
-	{ AR5K_PHY(67),	0x00800000 },		\
-	{ AR5K_PHY(68),	0x00000001 },		\
-	{ AR5K_PHY(71),	0x0000092a },		\
-	{ AR5K_PHY_IQ,	0x05100000 },		\
-	{ AR5K_PHY(74), 0x00000001 },		\
-	{ AR5K_PHY(75), 0x00000004 },		\
-	{ AR5K_PHY_TXPOWER_RATE1, 0x1e1f2022 },	\
-	{ AR5K_PHY_TXPOWER_RATE2, 0x0a0b0c0d },	\
-	{ AR5K_PHY_TXPOWER_RATE_MAX, 0x0000003f },\
-	{ AR5K_PHY(80), 0x00000004 },		\
-	{ AR5K_PHY(82), 0x9280b212 },		\
-	{ AR5K_PHY_RADAR, 0x5d50e188 },		\
-	{ AR5K_PHY(86),	0x000000ff },		\
-	{ AR5K_PHY(87),	0x004b6a8e },		\
-	{ AR5K_PHY(90),	0x000003ce },		\
-	{ AR5K_PHY(92),	0x192fb515 },		\
-	{ AR5K_PHY(93),	0x00000000 },		\
-	{ AR5K_PHY(94),	0x00000001 },		\
-	{ AR5K_PHY(95),	0x00000000 },		\
-	/* Power table (32bytes) */		\
-	{ AR5K_PHY_PCDAC_TXPOWER(1), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(2), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(3), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(4), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(5), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(6), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(7), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(8), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(9), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(10), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(11), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(12), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(13), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(14), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(15), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(16), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(17), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(18), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(19), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(20), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(21), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(22), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(23), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(24), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(25), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(26), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(27), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(28), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(29), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(30), 0x10ff10ff },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(31), 0x10ff10ff },	\
-	{ AR5K_PHY(644), 0x0080a333 },		\
-	{ AR5K_PHY(645), 0x00206c10 },		\
-	{ AR5K_PHY(646), 0x009c4060 },		\
-	{ AR5K_PHY(647), 0x1483800a },		\
-	{ AR5K_PHY(648), 0x01831061 },		\
-	{ AR5K_PHY(649), 0x00000400 },		\
-	{ AR5K_PHY(650), 0x000001b5 },		\
-	{ AR5K_PHY(651), 0x00000000 },		\
-	{ AR5K_PHY_TXPOWER_RATE3, 0x20202020 },	\
-	{ AR5K_PHY_TXPOWER_RATE2, 0x20202020 },	\
-	{ AR5K_PHY(655), 0x13c889af },		\
-	{ AR5K_PHY(656), 0x38490a20 },		\
-	{ AR5K_PHY(657), 0x00007bb6 },		\
-	{ AR5K_PHY(658), 0x0fff3ffc },		\
-	{ AR5K_PHY_CCKTXCTL, 0x00000000 },	\
-}
-
-/*
- * Initial BaseBand Gain settings for RF5111/5112 (only AR5210 comes with
- * RF5110 so initial BB Gain settings are included in AR5K_AR5210_INI)
- */
-
-/* RF5111 Initial BaseBand Gain settings */
-#define AR5K_RF5111_INI_BBGAIN {		\
-	{ AR5K_BB_GAIN(0), 0x00000000 },	\
-	{ AR5K_BB_GAIN(1), 0x00000020 },	\
-	{ AR5K_BB_GAIN(2), 0x00000010 },	\
-	{ AR5K_BB_GAIN(3), 0x00000030 },	\
-	{ AR5K_BB_GAIN(4), 0x00000008 },	\
-	{ AR5K_BB_GAIN(5), 0x00000028 },	\
-	{ AR5K_BB_GAIN(6), 0x00000004 },	\
-	{ AR5K_BB_GAIN(7), 0x00000024 },	\
-	{ AR5K_BB_GAIN(8), 0x00000014 },	\
-	{ AR5K_BB_GAIN(9), 0x00000034 },	\
-	{ AR5K_BB_GAIN(10), 0x0000000c },	\
-	{ AR5K_BB_GAIN(11), 0x0000002c },	\
-	{ AR5K_BB_GAIN(12), 0x00000002 },	\
-	{ AR5K_BB_GAIN(13), 0x00000022 },	\
-	{ AR5K_BB_GAIN(14), 0x00000012 },	\
-	{ AR5K_BB_GAIN(15), 0x00000032 },	\
-	{ AR5K_BB_GAIN(16), 0x0000000a },	\
-	{ AR5K_BB_GAIN(17), 0x0000002a },	\
-	{ AR5K_BB_GAIN(18), 0x00000006 },	\
-	{ AR5K_BB_GAIN(19), 0x00000026 },	\
-	{ AR5K_BB_GAIN(20), 0x00000016 },	\
-	{ AR5K_BB_GAIN(21), 0x00000036 },	\
-	{ AR5K_BB_GAIN(22), 0x0000000e },	\
-	{ AR5K_BB_GAIN(23), 0x0000002e },	\
-	{ AR5K_BB_GAIN(24), 0x00000001 },	\
-	{ AR5K_BB_GAIN(25), 0x00000021 },	\
-	{ AR5K_BB_GAIN(26), 0x00000011 },	\
-	{ AR5K_BB_GAIN(27), 0x00000031 },	\
-	{ AR5K_BB_GAIN(28), 0x00000009 },	\
-	{ AR5K_BB_GAIN(29), 0x00000029 },	\
-	{ AR5K_BB_GAIN(30), 0x00000005 },	\
-	{ AR5K_BB_GAIN(31), 0x00000025 },	\
-	{ AR5K_BB_GAIN(32), 0x00000015 },	\
-	{ AR5K_BB_GAIN(33), 0x00000035 },	\
-	{ AR5K_BB_GAIN(34), 0x0000000d },	\
-	{ AR5K_BB_GAIN(35), 0x0000002d },	\
-	{ AR5K_BB_GAIN(36), 0x00000003 },	\
-	{ AR5K_BB_GAIN(37), 0x00000023 },	\
-	{ AR5K_BB_GAIN(38), 0x00000013 },	\
-	{ AR5K_BB_GAIN(39), 0x00000033 },	\
-	{ AR5K_BB_GAIN(40), 0x0000000b },	\
-	{ AR5K_BB_GAIN(41), 0x0000002b },	\
-	{ AR5K_BB_GAIN(42), 0x0000002b },	\
-	{ AR5K_BB_GAIN(43), 0x0000002b },	\
-	{ AR5K_BB_GAIN(44), 0x0000002b },	\
-	{ AR5K_BB_GAIN(45), 0x0000002b },	\
-	{ AR5K_BB_GAIN(46), 0x0000002b },	\
-	{ AR5K_BB_GAIN(47), 0x0000002b },	\
-	{ AR5K_BB_GAIN(48), 0x0000002b },	\
-	{ AR5K_BB_GAIN(49), 0x0000002b },	\
-	{ AR5K_BB_GAIN(50), 0x0000002b },	\
-	{ AR5K_BB_GAIN(51), 0x0000002b },	\
-	{ AR5K_BB_GAIN(52), 0x0000002b },	\
-	{ AR5K_BB_GAIN(53), 0x0000002b },	\
-	{ AR5K_BB_GAIN(54), 0x0000002b },	\
-	{ AR5K_BB_GAIN(55), 0x0000002b },	\
-	{ AR5K_BB_GAIN(56), 0x0000002b },	\
-	{ AR5K_BB_GAIN(57), 0x0000002b },	\
-	{ AR5K_BB_GAIN(58), 0x0000002b },	\
-	{ AR5K_BB_GAIN(59), 0x0000002b },	\
-	{ AR5K_BB_GAIN(60), 0x0000002b },	\
-	{ AR5K_BB_GAIN(61), 0x0000002b },	\
-	{ AR5K_BB_GAIN(62), 0x00000002 },	\
-	{ AR5K_BB_GAIN(63), 0x00000016 },	\
-}
-
-/* RF 5112 Initial BaseBand Gain settings */
-#define AR5K_RF5112_INI_BBGAIN {		\
-	{ AR5K_BB_GAIN(0), 0x00000000 },	\
-	{ AR5K_BB_GAIN(1), 0x00000001 },	\
-	{ AR5K_BB_GAIN(2), 0x00000002 },	\
-	{ AR5K_BB_GAIN(3), 0x00000003 },	\
-	{ AR5K_BB_GAIN(4), 0x00000004 },	\
-	{ AR5K_BB_GAIN(5), 0x00000005 },	\
-	{ AR5K_BB_GAIN(6), 0x00000008 },	\
-	{ AR5K_BB_GAIN(7), 0x00000009 },	\
-	{ AR5K_BB_GAIN(8), 0x0000000a },	\
-	{ AR5K_BB_GAIN(9), 0x0000000b },	\
-	{ AR5K_BB_GAIN(10), 0x0000000c },	\
-	{ AR5K_BB_GAIN(11), 0x0000000d },	\
-	{ AR5K_BB_GAIN(12), 0x00000010 },	\
-	{ AR5K_BB_GAIN(13), 0x00000011 },	\
-	{ AR5K_BB_GAIN(14), 0x00000012 },	\
-	{ AR5K_BB_GAIN(15), 0x00000013 },	\
-	{ AR5K_BB_GAIN(16), 0x00000014 },	\
-	{ AR5K_BB_GAIN(17), 0x00000015 },	\
-	{ AR5K_BB_GAIN(18), 0x00000018 },	\
-	{ AR5K_BB_GAIN(19), 0x00000019 },	\
-	{ AR5K_BB_GAIN(20), 0x0000001a },	\
-	{ AR5K_BB_GAIN(21), 0x0000001b },	\
-	{ AR5K_BB_GAIN(22), 0x0000001c },	\
-	{ AR5K_BB_GAIN(23), 0x0000001d },	\
-	{ AR5K_BB_GAIN(24), 0x00000020 },	\
-	{ AR5K_BB_GAIN(25), 0x00000021 },	\
-	{ AR5K_BB_GAIN(26), 0x00000022 },	\
-	{ AR5K_BB_GAIN(27), 0x00000023 },	\
-	{ AR5K_BB_GAIN(28), 0x00000024 },	\
-	{ AR5K_BB_GAIN(29), 0x00000025 },	\
-	{ AR5K_BB_GAIN(30), 0x00000028 },	\
-	{ AR5K_BB_GAIN(31), 0x00000029 },	\
-	{ AR5K_BB_GAIN(32), 0x0000002a },	\
-	{ AR5K_BB_GAIN(33), 0x0000002b },	\
-	{ AR5K_BB_GAIN(34), 0x0000002c },	\
-	{ AR5K_BB_GAIN(35), 0x0000002d },	\
-	{ AR5K_BB_GAIN(36), 0x00000030 },	\
-	{ AR5K_BB_GAIN(37), 0x00000031 },	\
-	{ AR5K_BB_GAIN(38), 0x00000032 },	\
-	{ AR5K_BB_GAIN(39), 0x00000033 },	\
-	{ AR5K_BB_GAIN(40), 0x00000034 },	\
-	{ AR5K_BB_GAIN(41), 0x00000035 },	\
-	{ AR5K_BB_GAIN(42), 0x00000035 },	\
-	{ AR5K_BB_GAIN(43), 0x00000035 },	\
-	{ AR5K_BB_GAIN(44), 0x00000035 },	\
-	{ AR5K_BB_GAIN(45), 0x00000035 },	\
-	{ AR5K_BB_GAIN(46), 0x00000035 },	\
-	{ AR5K_BB_GAIN(47), 0x00000035 },	\
-	{ AR5K_BB_GAIN(48), 0x00000035 },	\
-	{ AR5K_BB_GAIN(49), 0x00000035 },	\
-	{ AR5K_BB_GAIN(50), 0x00000035 },	\
-	{ AR5K_BB_GAIN(51), 0x00000035 },	\
-	{ AR5K_BB_GAIN(52), 0x00000035 },	\
-	{ AR5K_BB_GAIN(53), 0x00000035 },	\
-	{ AR5K_BB_GAIN(54), 0x00000035 },	\
-	{ AR5K_BB_GAIN(55), 0x00000035 },	\
-	{ AR5K_BB_GAIN(56), 0x00000035 },	\
-	{ AR5K_BB_GAIN(57), 0x00000035 },	\
-	{ AR5K_BB_GAIN(58), 0x00000035 },	\
-	{ AR5K_BB_GAIN(59), 0x00000035 },	\
-	{ AR5K_BB_GAIN(60), 0x00000035 },	\
-	{ AR5K_BB_GAIN(61), 0x00000035 },	\
-	{ AR5K_BB_GAIN(62), 0x00000010 },	\
-	{ AR5K_BB_GAIN(63), 0x0000001a },	\
-}
-
-/*
- * Mode specific initial register values
- */
-
-struct ath5k_ini_mode {
-	u16	mode_register;
-	u32	mode_value[5];
-};
-
-/* Initial mode-specific settings for AR5211
- * XXX: how about gTurbo ? RF5111 supports it, how about AR5211 ?
- */
-#define AR5K_AR5211_INI_MODE { \
-	{ AR5K_TXCFG,									\
-	/*	  a/XR	      aTurbo	  b	      g(OFDM?)	  gTurbo (N/A) */	\
- 		{ 0x00000017, 0x00000017, 0x00000017, 0x00000017, 0x00000017 } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(0),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(1),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(2),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(3),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(4),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(5),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(6),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(7),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(8),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(9),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_DCU_GBL_IFS_SLOT,							\
-		{ 0x00000168, 0x000001e0, 0x000001b8, 0x00000168, 0x00000168 } },	\
-	{ AR5K_DCU_GBL_IFS_SIFS,							\
-		{ 0x00000230, 0x000001e0, 0x000000b0, 0x00000230, 0x00000230 } },	\
-	{ AR5K_DCU_GBL_IFS_EIFS,							\
-		{ 0x00000d98, 0x00001180, 0x00001f48, 0x00000d98, 0x00000d98 } },	\
-	{ AR5K_DCU_GBL_IFS_MISC,							\
-		{ 0x0000a0e0, 0x00014068, 0x00005880, 0x0000a0e0, 0x0000a0e0 } },	\
-	{ AR5K_TIME_OUT,								\
-		{ 0x04000400, 0x08000800, 0x20003000, 0x04000400, 0x04000400 } },	\
-	{ AR5K_USEC_5211,								\
-		{ 0x0e8d8fa7, 0x0e8d8fcf, 0x01608f95, 0x0e8d8fa7, 0x0e8d8fa7 } },	\
-	{ AR5K_PHY_TURBO,								\
-		{ 0x00000000, 0x00000003, 0x00000000, 0x00000000, 0x00000000 } },	\
-	{ 0x9820,									\
-		{ 0x02020200, 0x02020200, 0x02010200, 0x02020200, 0x02020200 } },	\
-	{ 0x9824,									\
-		{ 0x00000e0e, 0x00000e0e, 0x00000707, 0x00000e0e, 0x00000e0e } },	\
-	{ 0x9828,									\
-		{ 0x0a020001, 0x0a020001, 0x05010000, 0x0a020001, 0x0a020001 } },	\
-	{ 0x9834,									\
-		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },	\
-	{ 0x9838,									\
-		{ 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },	\
-	{ 0x9844,									\
-		{ 0x1372169c, 0x137216a5, 0x137216a8, 0x1372169c, 0x1372169c } },	\
-	{ 0x9848,									\
-		{ 0x0018ba67, 0x0018ba67, 0x0018ba69, 0x0018ba69, 0x0018ba69 } },	\
-	{ 0x9850,									\
-		{ 0x0c28b4e0, 0x0c28b4e0, 0x0c28b4e0, 0x0c28b4e0, 0x0c28b4e0 } },	\
-	{ AR5K_PHY_SIG,									\
-		{ 0x7e800d2e, 0x7e800d2e, 0x7ec00d2e, 0x7e800d2e, 0x7e800d2e } },	\
-	{ AR5K_PHY_AGCCOARSE,								\
-		{ 0x31375d5e, 0x31375d5e, 0x313a5d5e, 0x31375d5e, 0x31375d5e } },	\
-	{ AR5K_PHY_AGCCTL,								\
-		{ 0x0000bd10, 0x0000bd10, 0x0000bd38, 0x0000bd10, 0x0000bd10 } },	\
-	{ AR5K_PHY_NF,									\
-		{ 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },	\
-	{ AR5K_PHY_RX_DELAY,								\
-		{ 0x00002710, 0x00002710, 0x0000157c, 0x00002710, 0x00002710 } },	\
-	{ 0x9918,									\
-		{ 0x00000190, 0x00000190, 0x00000084, 0x00000190, 0x00000190 } },	\
-	{ AR5K_PHY_FRAME_CTL_5211,							\
-		{ 0x6fe01020, 0x6fe01020, 0x6fe00920, 0x6fe01020, 0x6fe01020 } },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(0),							\
-		{ 0x05ff14ff, 0x05ff14ff, 0x05ff14ff, 0x05ff19ff, 0x05ff19ff } },	\
-	{ AR5K_RF_BUFFER_CONTROL_4,							\
-		{ 0x00000010, 0x00000014, 0x00000010, 0x00000010, 0x00000010 } },	\
-}
-
-/* Initial mode-specific settings for AR5212 */
-#define AR5K_AR5212_INI_MODE { \
-	{ AR5K_TXCFG,									\
-	/*	  a/XR	      aTurbo	  b	      g (DYN)	  gTurbo */		\
-		{ 0x00008107, 0x00008107, 0x00008107, 0x00008107, 0x00008107 } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(0),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(1),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(2),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(3),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(4),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(5),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(6),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(7),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(8),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_QUEUE_DFS_LOCAL_IFS(9),							\
-		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },	\
-	{ AR5K_DCU_GBL_IFS_SIFS,							\
-		{ 0x00000230, 0x000001e0, 0x000000b0, 0x00000160, 0x000001e0 } },	\
-	{ AR5K_DCU_GBL_IFS_SLOT,							\
-		{ 0x00000168, 0x000001e0, 0x000001b8, 0x0000018c, 0x000001e0 } },	\
-	{ AR5K_DCU_GBL_IFS_EIFS,							\
-		{ 0x00000e60, 0x00001180, 0x00001f1c, 0x00003e38, 0x00001180 } },	\
-	{ AR5K_DCU_GBL_IFS_MISC,							\
-		{ 0x0000a0e0, 0x00014068, 0x00005880, 0x0000b0e0, 0x00014068 } },	\
-	{ AR5K_TIME_OUT,								\
-		{ 0x03e803e8, 0x06e006e0, 0x04200420, 0x08400840, 0x06e006e0 } },	\
-}
-
-/* Initial mode-specific settings for AR5212 + RF5111 */
-#define AR5K_AR5212_RF5111_INI_MODE { \
-	{ AR5K_USEC_5211,								\
-	/*	  a/XR	      aTurbo	  b	      g		  gTurbo */		\
-		{ 0x128d8fa7, 0x09880fcf, 0x04e00f95, 0x128d8fab, 0x09880fcf } },	\
-	{ AR5K_PHY_TURBO,								\
-		{ 0x00000000, 0x00000003, 0x00000000, 0x00000000, 0x00000003 } },	\
-	{ 0x9820,									\
-		{ 0x02020200, 0x02020200, 0x02010200, 0x02020200, 0x02020200 } },	\
-	{ 0x9824,									\
-		{ 0x00000e0e, 0x00000e0e, 0x00000707, 0x00000e0e, 0x00000e0e } },	\
-	{ 0x9828,									\
-		{ 0x0a020001, 0x0a020001, 0x05010100, 0x0a020001, 0x0a020001 } },	\
-	{ 0x9834,									\
-		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },	\
-	{ 0x9838,									\
-		{ 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },	\
-	{ 0x9844,									\
-		{ 0x1372161c, 0x13721c25, 0x13721728, 0x137216a2, 0x13721c25 } },	\
-	{ 0x9848,									\
-		{ 0x0018da5a, 0x0018da5a, 0x0018ca69, 0x0018ca69, 0x0018ca69 } },	\
-	{ 0x9850,									\
-		{ 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0 } },	\
-	{ AR5K_PHY_SIG,									\
-		{ 0x7e800d2e, 0x7e800d2e, 0x7ee84d2e, 0x7ee84d2e, 0x7e800d2e } },	\
-	{ AR5K_PHY_AGCCOARSE,								\
-		{ 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e, 0x3137615e } },	\
-	{ AR5K_PHY_AGCCTL,								\
-		{ 0x00009d10, 0x00009d10, 0x00009d18, 0x00009d10, 0x00009d10 } },	\
-	{ AR5K_PHY_NF,									\
-		{ 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },	\
-	{ AR5K_PHY_ADCSAT,								\
-		{ 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190 } },	\
-	{ 0x986c,									\
-		{ 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb080, 0x050cb080 } },	\
-	{ AR5K_PHY_RX_DELAY,								\
-		{ 0x00002710, 0x00002710, 0x0000157c, 0x00002af8, 0x00002710 } },	\
-	{ 0x9918,									\
-		{ 0x000001b8, 0x000001b8, 0x00000084, 0x00000108, 0x000001b8 } },	\
-	{ 0x9924,									\
-		{ 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05 } },	\
-	{ AR5K_PHY_FRAME_CTL_5211,							\
-		{ 0xffb81020, 0xffb81020, 0xffb80d20, 0xffb81020, 0xffb81020 } },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(0),							\
-		{ 0x10ff14ff, 0x10ff14ff, 0x10ff10ff, 0x10ff19ff, 0x10ff19ff } },	\
-	{ 0xa230,									\
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000108, 0x00000000 } },	\
-	{ 0xa208,									\
-		{ 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },	\
-}
-
-/* Initial mode-specific settings for AR5212 + RF5112 */
-#define AR5K_AR5212_RF5112_INI_MODE { \
-	{ AR5K_USEC_5211,								\
-	/*	  a/XR	      aTurbo	  b	      g		  gTurbo */		\
-		{ 0x128d93a7, 0x098813cf, 0x04e01395, 0x128d93ab, 0x098813cf } },	\
-	{ AR5K_PHY_TURBO,								\
-		{ 0x00000000, 0x00000003, 0x00000000, 0x00000000, 0x00000003 } },	\
-	{ 0x9820,									\
-		{ 0x02020200, 0x02020200, 0x02010200, 0x02020200, 0x02020200 } },	\
-	{ 0x9824,									\
-		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },	\
-	{ 0x9828,									\
-		{ 0x0a020001, 0x0a020001, 0x05020100, 0x0a020001, 0x0a020001 } },	\
-	{ 0x9834,									\
-		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },	\
-	{ 0x9838,									\
-		{ 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },	\
-	{ 0x9844,									\
-		{ 0x1372161c, 0x13721c25, 0x13721728, 0x137216a2, 0x13721c25 } },	\
-	{ 0x9848,									\
-		{ 0x0018da6d, 0x0018da6d, 0x0018ca75, 0x0018ca75, 0x0018ca75 } },	\
-	{ 0x9850,									\
-		{ 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0 } },	\
-	{ AR5K_PHY_SIG,									\
-		{ 0x7e800d2e, 0x7e800d2e, 0x7ee84d2e, 0x7ee84d2e, 0x7e800d2e } },	\
-	{ AR5K_PHY_AGCCOARSE,								\
-		{ 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e } },	\
-	{ AR5K_PHY_AGCCTL,								\
-		{ 0x00009d10, 0x00009d10, 0x00009d18, 0x00009d10, 0x00009d10 } },	\
-	{ AR5K_PHY_NF,									\
-		{ 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },	\
-	{ AR5K_PHY_ADCSAT,								\
-		{ 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190 } },	\
-	{ 0x986c,									\
-		{ 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081 } },	\
-	{ AR5K_PHY_RX_DELAY,								\
-		{ 0x000007d0, 0x000007d0, 0x0000044c, 0x00000898, 0x000007d0 } },	\
-	{ 0x9918,									\
-		{ 0x000001b8, 0x000001b8, 0x00000084, 0x00000108, 0x000001b8 } },	\
-	{ 0x9924,									\
-		{ 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05 } },	\
-	{ AR5K_PHY_FRAME_CTL_5211,							\
-		{ 0xffb81020, 0xffb81020, 0xffb80d10, 0xffb81010, 0xffb81010 } },	\
-	{ AR5K_PHY_PCDAC_TXPOWER(0),							\
-		{ 0x10ff14ff, 0x10ff14ff, 0x10ff10ff, 0x10ff19ff, 0x10ff19ff } },	\
-	{ 0xa230,									\
-		{ 0x00000000, 0x00000000, 0x00000000, 0x00000108, 0x00000000 } },	\
-	{ AR5K_PHY_CCKTXCTL,								\
-		{ 0x00000000, 0x00000000, 0x00000004, 0x00000004, 0x00000004 } },	\
-	{ 0xa208,									\
-		{ 0xd6be6788, 0xd6be6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },	\
-	{ AR5K_PHY_GAIN_2GHZ,								\
-		{ 0x642c0140, 0x642c0140, 0x6442c160, 0x6442c160, 0x6442c160 } },	\
+	return retval;
 }
diff --git a/drivers/net/wireless/ath5k_hw_inivals.c b/drivers/net/wireless/ath5k_hw_inivals.c
new file mode 100644
index 0000000..062e03d
--- /dev/null
+++ b/drivers/net/wireless/ath5k_hw_inivals.c
@@ -0,0 +1,1090 @@
+/*
+ * Initial register settings functions
+ *
+ * Copyright (c) 2007 The MadWiFi Team <www.madwifi.org>
+ * Copyright (c) 2004, 2005 Reyk Floeter <reyk@vantronix.net>
+ *
+ * This file is released under GPLv2
+ */
+
+#include "ath5k.h"
+#include "ath5k_reg.h"
+
+/*
+ * MAC/PHY REGISTERS
+ */
+
+
+/*
+ * Mode-independent initial register writes
+ */
+
+struct ath5k_ini {
+	u16	ini_register;
+	u32	ini_value;
+
+	enum {
+		AR5K_INI_WRITE = 0,	/* Default */
+		AR5K_INI_READ = 1,	/* Cleared on read */
+	} ini_mode;
+};
+
+/*
+ * Mode specific initial register values
+ */
+
+struct ath5k_ini_mode {
+	u16	mode_register;
+	u32	mode_value[5];
+};
+
+/* Initial register settings for AR5210 */
+static const struct ath5k_ini ar5210_ini[] = {
+	/* PCU and MAC registers */
+	{ AR5K_NOQCU_TXDP0,	0 },
+	{ AR5K_NOQCU_TXDP1,	0 },
+	{ AR5K_RXDP,		0 },
+	{ AR5K_CR,		0 },
+	{ AR5K_ISR,		0, AR5K_INI_READ },
+	{ AR5K_IMR,		0 },
+	{ AR5K_IER,		AR5K_IER_DISABLE },
+	{ AR5K_BSR,		0, AR5K_INI_READ },
+	{ AR5K_TXCFG,		AR5K_DMASIZE_128B },
+	{ AR5K_RXCFG,		AR5K_DMASIZE_128B },
+	{ AR5K_CFG,		AR5K_INIT_CFG },
+	{ AR5K_TOPS,		AR5K_INIT_TOPS },
+	{ AR5K_RXNOFRM,		AR5K_INIT_RXNOFRM },
+	{ AR5K_RPGTO,		AR5K_INIT_RPGTO },
+	{ AR5K_TXNOFRM,		AR5K_INIT_TXNOFRM },
+	{ AR5K_SFR,		0 },
+	{ AR5K_MIBC,		0 },
+	{ AR5K_MISC,		0 },
+	{ AR5K_RX_FILTER_5210,	0 },
+	{ AR5K_MCAST_FILTER0_5210, 0 },
+	{ AR5K_MCAST_FILTER1_5210, 0 },
+	{ AR5K_TX_MASK0,	0 },
+	{ AR5K_TX_MASK1,	0 },
+	{ AR5K_CLR_TMASK,	0 },
+	{ AR5K_TRIG_LVL,	AR5K_TUNE_MIN_TX_FIFO_THRES },
+	{ AR5K_DIAG_SW_5210,	0 },
+	{ AR5K_RSSI_THR,	AR5K_TUNE_RSSI_THRES },
+	{ AR5K_TSF_L32_5210,	0 },
+	{ AR5K_TIMER0_5210,	0 },
+	{ AR5K_TIMER1_5210,	0xffffffff },
+	{ AR5K_TIMER2_5210,	0xffffffff },
+	{ AR5K_TIMER3_5210,	1 },
+	{ AR5K_CFP_DUR_5210,	0 },
+	{ AR5K_CFP_PERIOD_5210,	0 },
+	/* PHY registers */
+	{ AR5K_PHY(0),	0x00000047 },
+	{ AR5K_PHY_AGC,	0x00000000 },
+	{ AR5K_PHY(3),	0x09848ea6 },
+	{ AR5K_PHY(4),	0x3d32e000 },
+	{ AR5K_PHY(5),	0x0000076b },
+	{ AR5K_PHY_ACT,	AR5K_PHY_ACT_DISABLE },
+	{ AR5K_PHY(8),	0x02020200 },
+	{ AR5K_PHY(9),	0x00000e0e },
+	{ AR5K_PHY(10),	0x0a020201 },
+	{ AR5K_PHY(11),	0x00036ffc },
+	{ AR5K_PHY(12),	0x00000000 },
+	{ AR5K_PHY(13),	0x00000e0e },
+	{ AR5K_PHY(14),	0x00000007 },
+	{ AR5K_PHY(15),	0x00020100 },
+	{ AR5K_PHY(16),	0x89630000 },
+	{ AR5K_PHY(17),	0x1372169c },
+	{ AR5K_PHY(18),	0x0018b633 },
+	{ AR5K_PHY(19),	0x1284613c },
+	{ AR5K_PHY(20),	0x0de8b8e0 },
+	{ AR5K_PHY(21),	0x00074859 },
+	{ AR5K_PHY(22),	0x7e80beba },
+	{ AR5K_PHY(23),	0x313a665e },
+	{ AR5K_PHY_AGCCTL, 0x00001d08 },
+	{ AR5K_PHY(25),	0x0001ce00 },
+	{ AR5K_PHY(26),	0x409a4190 },
+	{ AR5K_PHY(28),	0x0000000f },
+	{ AR5K_PHY(29),	0x00000080 },
+	{ AR5K_PHY(30),	0x00000004 },
+	{ AR5K_PHY(31),	0x00000018 }, 	/* 0x987c */
+	{ AR5K_PHY(64),	0x00000000 }, 	/* 0x9900 */
+	{ AR5K_PHY(65),	0x00000000 },
+	{ AR5K_PHY(66),	0x00000000 },
+	{ AR5K_PHY(67),	0x00800000 },
+	{ AR5K_PHY(68),	0x00000003 },
+	/* BB gain table (64bytes) */
+	{ AR5K_BB_GAIN(0), 0x00000000 },
+	{ AR5K_BB_GAIN(1), 0x00000020 },
+	{ AR5K_BB_GAIN(2), 0x00000010 },
+	{ AR5K_BB_GAIN(3), 0x00000030 },
+	{ AR5K_BB_GAIN(4), 0x00000008 },
+	{ AR5K_BB_GAIN(5), 0x00000028 },
+	{ AR5K_BB_GAIN(6), 0x00000028 },
+	{ AR5K_BB_GAIN(7), 0x00000004 },
+	{ AR5K_BB_GAIN(8), 0x00000024 },
+	{ AR5K_BB_GAIN(9), 0x00000014 },
+	{ AR5K_BB_GAIN(10), 0x00000034 },
+	{ AR5K_BB_GAIN(11), 0x0000000c },
+	{ AR5K_BB_GAIN(12), 0x0000002c },
+	{ AR5K_BB_GAIN(13), 0x00000002 },
+	{ AR5K_BB_GAIN(14), 0x00000022 },
+	{ AR5K_BB_GAIN(15), 0x00000012 },
+	{ AR5K_BB_GAIN(16), 0x00000032 },
+	{ AR5K_BB_GAIN(17), 0x0000000a },
+	{ AR5K_BB_GAIN(18), 0x0000002a },
+	{ AR5K_BB_GAIN(19), 0x00000001 },
+	{ AR5K_BB_GAIN(20), 0x00000021 },
+	{ AR5K_BB_GAIN(21), 0x00000011 },
+	{ AR5K_BB_GAIN(22), 0x00000031 },
+	{ AR5K_BB_GAIN(23), 0x00000009 },
+	{ AR5K_BB_GAIN(24), 0x00000029 },
+	{ AR5K_BB_GAIN(25), 0x00000005 },
+	{ AR5K_BB_GAIN(26), 0x00000025 },
+	{ AR5K_BB_GAIN(27), 0x00000015 },
+	{ AR5K_BB_GAIN(28), 0x00000035 },
+	{ AR5K_BB_GAIN(29), 0x0000000d },
+	{ AR5K_BB_GAIN(30), 0x0000002d },
+	{ AR5K_BB_GAIN(31), 0x00000003 },
+	{ AR5K_BB_GAIN(32), 0x00000023 },
+	{ AR5K_BB_GAIN(33), 0x00000013 },
+	{ AR5K_BB_GAIN(34), 0x00000033 },
+	{ AR5K_BB_GAIN(35), 0x0000000b },
+	{ AR5K_BB_GAIN(36), 0x0000002b },
+	{ AR5K_BB_GAIN(37), 0x00000007 },
+	{ AR5K_BB_GAIN(38), 0x00000027 },
+	{ AR5K_BB_GAIN(39), 0x00000017 },
+	{ AR5K_BB_GAIN(40), 0x00000037 },
+	{ AR5K_BB_GAIN(41), 0x0000000f },
+	{ AR5K_BB_GAIN(42), 0x0000002f },
+	{ AR5K_BB_GAIN(43), 0x0000002f },
+	{ AR5K_BB_GAIN(44), 0x0000002f },
+	{ AR5K_BB_GAIN(45), 0x0000002f },
+	{ AR5K_BB_GAIN(46), 0x0000002f },
+	{ AR5K_BB_GAIN(47), 0x0000002f },
+	{ AR5K_BB_GAIN(48), 0x0000002f },
+	{ AR5K_BB_GAIN(49), 0x0000002f },
+	{ AR5K_BB_GAIN(50), 0x0000002f },
+	{ AR5K_BB_GAIN(51), 0x0000002f },
+	{ AR5K_BB_GAIN(52), 0x0000002f },
+	{ AR5K_BB_GAIN(53), 0x0000002f },
+	{ AR5K_BB_GAIN(54), 0x0000002f },
+	{ AR5K_BB_GAIN(55), 0x0000002f },
+	{ AR5K_BB_GAIN(56), 0x0000002f },
+	{ AR5K_BB_GAIN(57), 0x0000002f },
+	{ AR5K_BB_GAIN(58), 0x0000002f },
+	{ AR5K_BB_GAIN(59), 0x0000002f },
+	{ AR5K_BB_GAIN(60), 0x0000002f },
+	{ AR5K_BB_GAIN(61), 0x0000002f },
+	{ AR5K_BB_GAIN(62), 0x0000002f },
+	{ AR5K_BB_GAIN(63), 0x0000002f },
+	/* 5110 RF gain table (64btes) */
+	{ AR5K_RF_GAIN(0), 0x0000001d },
+	{ AR5K_RF_GAIN(1), 0x0000005d },
+	{ AR5K_RF_GAIN(2), 0x0000009d },
+	{ AR5K_RF_GAIN(3), 0x000000dd },
+	{ AR5K_RF_GAIN(4), 0x0000011d },
+	{ AR5K_RF_GAIN(5), 0x00000021 },
+	{ AR5K_RF_GAIN(6), 0x00000061 },
+	{ AR5K_RF_GAIN(7), 0x000000a1 },
+	{ AR5K_RF_GAIN(8), 0x000000e1 },
+	{ AR5K_RF_GAIN(9), 0x00000031 },
+	{ AR5K_RF_GAIN(10), 0x00000071 },
+	{ AR5K_RF_GAIN(11), 0x000000b1 },
+	{ AR5K_RF_GAIN(12), 0x0000001c },
+	{ AR5K_RF_GAIN(13), 0x0000005c },
+	{ AR5K_RF_GAIN(14), 0x00000029 },
+	{ AR5K_RF_GAIN(15), 0x00000069 },
+	{ AR5K_RF_GAIN(16), 0x000000a9 },
+	{ AR5K_RF_GAIN(17), 0x00000020 },
+	{ AR5K_RF_GAIN(18), 0x00000019 },
+	{ AR5K_RF_GAIN(19), 0x00000059 },
+	{ AR5K_RF_GAIN(20), 0x00000099 },
+	{ AR5K_RF_GAIN(21), 0x00000030 },
+	{ AR5K_RF_GAIN(22), 0x00000005 },
+	{ AR5K_RF_GAIN(23), 0x00000025 },
+	{ AR5K_RF_GAIN(24), 0x00000065 },
+	{ AR5K_RF_GAIN(25), 0x000000a5 },
+	{ AR5K_RF_GAIN(26), 0x00000028 },
+	{ AR5K_RF_GAIN(27), 0x00000068 },
+	{ AR5K_RF_GAIN(28), 0x0000001f },
+	{ AR5K_RF_GAIN(29), 0x0000001e },
+	{ AR5K_RF_GAIN(30), 0x00000018 },
+	{ AR5K_RF_GAIN(31), 0x00000058 },
+	{ AR5K_RF_GAIN(32), 0x00000098 },
+	{ AR5K_RF_GAIN(33), 0x00000003 },
+	{ AR5K_RF_GAIN(34), 0x00000004 },
+	{ AR5K_RF_GAIN(35), 0x00000044 },
+	{ AR5K_RF_GAIN(36), 0x00000084 },
+	{ AR5K_RF_GAIN(37), 0x00000013 },
+	{ AR5K_RF_GAIN(38), 0x00000012 },
+	{ AR5K_RF_GAIN(39), 0x00000052 },
+	{ AR5K_RF_GAIN(40), 0x00000092 },
+	{ AR5K_RF_GAIN(41), 0x000000d2 },
+	{ AR5K_RF_GAIN(42), 0x0000002b },
+	{ AR5K_RF_GAIN(43), 0x0000002a },
+	{ AR5K_RF_GAIN(44), 0x0000006a },
+	{ AR5K_RF_GAIN(45), 0x000000aa },
+	{ AR5K_RF_GAIN(46), 0x0000001b },
+	{ AR5K_RF_GAIN(47), 0x0000001a },
+	{ AR5K_RF_GAIN(48), 0x0000005a },
+	{ AR5K_RF_GAIN(49), 0x0000009a },
+	{ AR5K_RF_GAIN(50), 0x000000da },
+	{ AR5K_RF_GAIN(51), 0x00000006 },
+	{ AR5K_RF_GAIN(52), 0x00000006 },
+	{ AR5K_RF_GAIN(53), 0x00000006 },
+	{ AR5K_RF_GAIN(54), 0x00000006 },
+	{ AR5K_RF_GAIN(55), 0x00000006 },
+	{ AR5K_RF_GAIN(56), 0x00000006 },
+	{ AR5K_RF_GAIN(57), 0x00000006 },
+	{ AR5K_RF_GAIN(58), 0x00000006 },
+	{ AR5K_RF_GAIN(59), 0x00000006 },
+	{ AR5K_RF_GAIN(60), 0x00000006 },
+	{ AR5K_RF_GAIN(61), 0x00000006 },
+	{ AR5K_RF_GAIN(62), 0x00000006 },
+	{ AR5K_RF_GAIN(63), 0x00000006 },
+	/* PHY activation */
+	{ AR5K_PHY(53), 0x00000020 },
+	{ AR5K_PHY(51), 0x00000004 },
+	{ AR5K_PHY(50), 0x00060106 },
+	{ AR5K_PHY(39), 0x0000006d },
+	{ AR5K_PHY(48), 0x00000000 },
+	{ AR5K_PHY(52), 0x00000014 },
+	{ AR5K_PHY_ACT, AR5K_PHY_ACT_ENABLE },
+};
+
+/* Initial register settings for AR5211 */
+static const struct ath5k_ini ar5211_ini[] = {
+	{ AR5K_RXDP,		0x00000000 },
+	{ AR5K_RTSD0,		0x84849c9c },
+	{ AR5K_RTSD1,		0x7c7c7c7c },
+	{ AR5K_RXCFG,		0x00000005 },
+	{ AR5K_MIBC,		0x00000000 },
+	{ AR5K_TOPS,		0x00000008 },
+	{ AR5K_RXNOFRM,		0x00000008 },
+	{ AR5K_TXNOFRM,		0x00000010 },
+	{ AR5K_RPGTO,		0x00000000 },
+	{ AR5K_RFCNT,		0x0000001f },
+	{ AR5K_QUEUE_TXDP(0),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(1),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(2),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(3),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(4),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(5),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(6),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(7),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(8),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(9),	0x00000000 },
+	{ AR5K_DCU_FP,		0x00000000 },
+	{ AR5K_STA_ID1,		0x00000000 },
+	{ AR5K_BSS_ID0,		0x00000000 },
+	{ AR5K_BSS_ID1,		0x00000000 },
+	{ AR5K_RSSI_THR,	0x00000000 },
+	{ AR5K_CFP_PERIOD_5211,	0x00000000 },
+	{ AR5K_TIMER0_5211,	0x00000030 },
+	{ AR5K_TIMER1_5211,	0x0007ffff },
+	{ AR5K_TIMER2_5211,	0x01ffffff },
+	{ AR5K_TIMER3_5211,	0x00000031 },
+	{ AR5K_CFP_DUR_5211,	0x00000000 },
+	{ AR5K_RX_FILTER_5211,	0x00000000 },
+	{ AR5K_MCAST_FILTER0_5211, 0x00000000 },
+	{ AR5K_MCAST_FILTER1_5211, 0x00000002 },
+	{ AR5K_DIAG_SW_5211,	0x00000000 },
+	{ AR5K_ADDAC_TEST,	0x00000000 },
+	{ AR5K_DEFAULT_ANTENNA,	0x00000000 },
+	/* PHY registers */
+	{ AR5K_PHY_AGC,	0x00000000 },
+	{ AR5K_PHY(3),	0x2d849093 },
+	{ AR5K_PHY(4),	0x7d32e000 },
+	{ AR5K_PHY(5),	0x00000f6b },
+	{ AR5K_PHY_ACT,	0x00000000 },
+	{ AR5K_PHY(11),	0x00026ffe },
+	{ AR5K_PHY(12),	0x00000000 },
+	{ AR5K_PHY(15),	0x00020100 },
+	{ AR5K_PHY(16),	0x206a017a },
+	{ AR5K_PHY(19),	0x1284613c },
+	{ AR5K_PHY(21),	0x00000859 },
+	{ AR5K_PHY(26),	0x409a4190 },	/* 0x9868 */
+	{ AR5K_PHY(27),	0x050cb081 },
+	{ AR5K_PHY(28),	0x0000000f },
+	{ AR5K_PHY(29),	0x00000080 },
+	{ AR5K_PHY(30),	0x0000000c },
+	{ AR5K_PHY(64),	0x00000000 },
+	{ AR5K_PHY(65),	0x00000000 },
+	{ AR5K_PHY(66),	0x00000000 },
+	{ AR5K_PHY(67),	0x00800000 },
+	{ AR5K_PHY(68),	0x00000001 },
+	{ AR5K_PHY(71),	0x0000092a },
+	{ AR5K_PHY_IQ,	0x00000000 },
+	{ AR5K_PHY(73),	0x00058a05 },
+	{ AR5K_PHY(74),	0x00000001 },
+	{ AR5K_PHY(75),	0x00000000 },
+	{ AR5K_PHY_PAPD_PROBE, 0x00000000 },
+	{ AR5K_PHY(77),	0x00000000 },	/* 0x9934 */
+	{ AR5K_PHY(78),	0x00000000 },	/* 0x9938 */
+	{ AR5K_PHY(79),	0x0000003f },	/* 0x993c */
+	{ AR5K_PHY(80),	0x00000004 },
+	{ AR5K_PHY(82),	0x00000000 },
+	{ AR5K_PHY(83),	0x00000000 },
+	{ AR5K_PHY(84),	0x00000000 },
+	{ AR5K_PHY_RADAR, 0x5d50f14c },
+	{ AR5K_PHY(86),	0x00000018 },
+	{ AR5K_PHY(87),	0x004b6a8e },
+	/* Power table (32bytes) */
+	{ AR5K_PHY_PCDAC_TXPOWER(1), 0x06ff05ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(2), 0x07ff07ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(3), 0x08ff08ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(4), 0x09ff09ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(5), 0x0aff0aff },
+	{ AR5K_PHY_PCDAC_TXPOWER(6), 0x0bff0bff },
+	{ AR5K_PHY_PCDAC_TXPOWER(7), 0x0cff0cff },
+	{ AR5K_PHY_PCDAC_TXPOWER(8), 0x0dff0dff },
+	{ AR5K_PHY_PCDAC_TXPOWER(9), 0x0fff0eff },
+	{ AR5K_PHY_PCDAC_TXPOWER(10), 0x12ff12ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(11), 0x14ff13ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(12), 0x16ff15ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(13), 0x19ff17ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(14), 0x1bff1aff },
+	{ AR5K_PHY_PCDAC_TXPOWER(15), 0x1eff1dff },
+	{ AR5K_PHY_PCDAC_TXPOWER(16), 0x23ff20ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(17), 0x27ff25ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(18), 0x2cff29ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(19), 0x31ff2fff },
+	{ AR5K_PHY_PCDAC_TXPOWER(20), 0x37ff34ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(21), 0x3aff3aff },
+	{ AR5K_PHY_PCDAC_TXPOWER(22), 0x3aff3aff },
+	{ AR5K_PHY_PCDAC_TXPOWER(23), 0x3aff3aff },
+	{ AR5K_PHY_PCDAC_TXPOWER(24), 0x3aff3aff },
+	{ AR5K_PHY_PCDAC_TXPOWER(25), 0x3aff3aff },
+	{ AR5K_PHY_PCDAC_TXPOWER(26), 0x3aff3aff },
+	{ AR5K_PHY_PCDAC_TXPOWER(27), 0x3aff3aff },
+	{ AR5K_PHY_PCDAC_TXPOWER(28), 0x3aff3aff },
+	{ AR5K_PHY_PCDAC_TXPOWER(29), 0x3aff3aff },
+	{ AR5K_PHY_PCDAC_TXPOWER(30), 0x3aff3aff },
+	{ AR5K_PHY_PCDAC_TXPOWER(31), 0x3aff3aff },
+	{ AR5K_PHY_CCKTXCTL, 0x00000000 },
+	{ AR5K_PHY(642), 0x503e4646 },
+	{ AR5K_PHY_GAIN_2GHZ, 0x6480416c },
+	{ AR5K_PHY(644), 0x0199a003 },
+	{ AR5K_PHY(645), 0x044cd610 },
+	{ AR5K_PHY(646), 0x13800040 },
+	{ AR5K_PHY(647), 0x1be00060 },
+	{ AR5K_PHY(648), 0x0c53800a },
+	{ AR5K_PHY(649), 0x0014df3b },
+	{ AR5K_PHY(650), 0x000001b5 },
+	{ AR5K_PHY(651), 0x00000020 },
+};
+
+/* Initial mode-specific settings for AR5211
+ * XXX: how about gTurbo ? RF5111 supports it, how about AR5211 ?
+ */
+static const struct ath5k_ini_mode ar5211_ini_mode[] = {
+	{ AR5K_TXCFG,
+	/*	  a/XR	      aTurbo	  b	      g(OFDM?)	  gTurbo (N/A) */
+ 		{ 0x00000017, 0x00000017, 0x00000017, 0x00000017, 0x00000017 } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(0),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(1),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(2),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(3),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(4),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(5),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(6),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(7),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(8),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(9),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_DCU_GBL_IFS_SLOT,
+		{ 0x00000168, 0x000001e0, 0x000001b8, 0x00000168, 0x00000168 } },
+	{ AR5K_DCU_GBL_IFS_SIFS,
+		{ 0x00000230, 0x000001e0, 0x000000b0, 0x00000230, 0x00000230 } },
+	{ AR5K_DCU_GBL_IFS_EIFS,
+		{ 0x00000d98, 0x00001180, 0x00001f48, 0x00000d98, 0x00000d98 } },
+	{ AR5K_DCU_GBL_IFS_MISC,
+		{ 0x0000a0e0, 0x00014068, 0x00005880, 0x0000a0e0, 0x0000a0e0 } },
+	{ AR5K_TIME_OUT,
+		{ 0x04000400, 0x08000800, 0x20003000, 0x04000400, 0x04000400 } },
+	{ AR5K_USEC_5211,
+		{ 0x0e8d8fa7, 0x0e8d8fcf, 0x01608f95, 0x0e8d8fa7, 0x0e8d8fa7 } },
+	{ AR5K_PHY_TURBO,
+		{ 0x00000000, 0x00000003, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0x9820,
+		{ 0x02020200, 0x02020200, 0x02010200, 0x02020200, 0x02020200 } },
+	{ 0x9824,
+		{ 0x00000e0e, 0x00000e0e, 0x00000707, 0x00000e0e, 0x00000e0e } },
+	{ 0x9828,
+		{ 0x0a020001, 0x0a020001, 0x05010000, 0x0a020001, 0x0a020001 } },
+	{ 0x9834,
+		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
+	{ 0x9838,
+		{ 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },
+	{ 0x9844,
+		{ 0x1372169c, 0x137216a5, 0x137216a8, 0x1372169c, 0x1372169c } },
+	{ 0x9848,
+		{ 0x0018ba67, 0x0018ba67, 0x0018ba69, 0x0018ba69, 0x0018ba69 } },
+	{ 0x9850,
+		{ 0x0c28b4e0, 0x0c28b4e0, 0x0c28b4e0, 0x0c28b4e0, 0x0c28b4e0 } },
+	{ AR5K_PHY_SIG,
+		{ 0x7e800d2e, 0x7e800d2e, 0x7ec00d2e, 0x7e800d2e, 0x7e800d2e } },
+	{ AR5K_PHY_AGCCOARSE,
+		{ 0x31375d5e, 0x31375d5e, 0x313a5d5e, 0x31375d5e, 0x31375d5e } },
+	{ AR5K_PHY_AGCCTL,
+		{ 0x0000bd10, 0x0000bd10, 0x0000bd38, 0x0000bd10, 0x0000bd10 } },
+	{ AR5K_PHY_NF,
+		{ 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
+	{ AR5K_PHY_RX_DELAY,
+		{ 0x00002710, 0x00002710, 0x0000157c, 0x00002710, 0x00002710 } },
+	{ 0x9918,
+		{ 0x00000190, 0x00000190, 0x00000084, 0x00000190, 0x00000190 } },
+	{ AR5K_PHY_FRAME_CTL_5211,
+		{ 0x6fe01020, 0x6fe01020, 0x6fe00920, 0x6fe01020, 0x6fe01020 } },
+	{ AR5K_PHY_PCDAC_TXPOWER(0),
+		{ 0x05ff14ff, 0x05ff14ff, 0x05ff14ff, 0x05ff19ff, 0x05ff19ff } },
+	{ AR5K_RF_BUFFER_CONTROL_4,
+		{ 0x00000010, 0x00000014, 0x00000010, 0x00000010, 0x00000010 } },
+};
+
+/* Initial register settings for AR5212 */
+static const struct ath5k_ini ar5212_ini[] = {
+	{ AR5K_RXDP,		0x00000000 },
+	{ AR5K_RXCFG,		0x00000005 },
+	{ AR5K_MIBC,		0x00000000 },
+	{ AR5K_TOPS,		0x00000008 },
+	{ AR5K_RXNOFRM,		0x00000008 },
+	{ AR5K_TXNOFRM,		0x00000010 },
+	{ AR5K_RPGTO,		0x00000000 },
+	{ AR5K_RFCNT,		0x0000001f },
+	{ AR5K_QUEUE_TXDP(0),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(1),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(2),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(3),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(4),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(5),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(6),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(7),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(8),	0x00000000 },
+	{ AR5K_QUEUE_TXDP(9),	0x00000000 },
+	{ AR5K_DCU_FP,		0x00000000 },
+	{ AR5K_DCU_TXP,		0x00000000 },
+	{ AR5K_DCU_TX_FILTER,	0x00000000 },
+	/* Unknown table */
+	{ 0x1078, 0x00000000 },
+	{ 0x10b8, 0x00000000 },
+	{ 0x10f8, 0x00000000 },
+	{ 0x1138, 0x00000000 },
+	{ 0x1178, 0x00000000 },
+	{ 0x11b8, 0x00000000 },
+	{ 0x11f8, 0x00000000 },
+	{ 0x1238, 0x00000000 },
+	{ 0x1278, 0x00000000 },
+	{ 0x12b8, 0x00000000 },
+	{ 0x12f8, 0x00000000 },
+	{ 0x1338, 0x00000000 },
+	{ 0x1378, 0x00000000 },
+	{ 0x13b8, 0x00000000 },
+	{ 0x13f8, 0x00000000 },
+	{ 0x1438, 0x00000000 },
+	{ 0x1478, 0x00000000 },
+	{ 0x14b8, 0x00000000 },
+	{ 0x14f8, 0x00000000 },
+	{ 0x1538, 0x00000000 },
+	{ 0x1578, 0x00000000 },
+	{ 0x15b8, 0x00000000 },
+	{ 0x15f8, 0x00000000 },
+	{ 0x1638, 0x00000000 },
+	{ 0x1678, 0x00000000 },
+	{ 0x16b8, 0x00000000 },
+	{ 0x16f8, 0x00000000 },
+	{ 0x1738, 0x00000000 },
+	{ 0x1778, 0x00000000 },
+	{ 0x17b8, 0x00000000 },
+	{ 0x17f8, 0x00000000 },
+	{ 0x103c, 0x00000000 },
+	{ 0x107c, 0x00000000 },
+	{ 0x10bc, 0x00000000 },
+	{ 0x10fc, 0x00000000 },
+	{ 0x113c, 0x00000000 },
+	{ 0x117c, 0x00000000 },
+	{ 0x11bc, 0x00000000 },
+	{ 0x11fc, 0x00000000 },
+	{ 0x123c, 0x00000000 },
+	{ 0x127c, 0x00000000 },
+	{ 0x12bc, 0x00000000 },
+	{ 0x12fc, 0x00000000 },
+	{ 0x133c, 0x00000000 },
+	{ 0x137c, 0x00000000 },
+	{ 0x13bc, 0x00000000 },
+	{ 0x13fc, 0x00000000 },
+	{ 0x143c, 0x00000000 },
+	{ 0x147c, 0x00000000 },
+	{ AR5K_STA_ID1,		0x00000000 },
+	{ AR5K_BSS_ID0,		0x00000000 },
+	{ AR5K_BSS_ID1,		0x00000000 },
+	{ AR5K_RSSI_THR,	0x00000000 },
+	{ AR5K_BEACON_5211,	0x00000000 },
+	{ AR5K_CFP_PERIOD_5211,	0x00000000 },
+	{ AR5K_TIMER0_5211,	0x00000030 },
+	{ AR5K_TIMER1_5211,	0x0007ffff },
+	{ AR5K_TIMER2_5211,	0x01ffffff },
+	{ AR5K_TIMER3_5211,	0x00000031 },
+	{ AR5K_CFP_DUR_5211,	0x00000000 },
+	{ AR5K_RX_FILTER_5211,	0x00000000 },
+	{ AR5K_DIAG_SW_5211,	0x00000000 },
+	{ AR5K_ADDAC_TEST,	0x00000000 },
+	{ AR5K_DEFAULT_ANTENNA,	0x00000000 },
+	{ 0x805c, 0xffffc7ff },
+	{ 0x8080, 0x00000000 },
+	{ AR5K_NAV_5211,	0x00000000 },
+	{ AR5K_RTS_OK_5211,	0x00000000 },
+	{ AR5K_RTS_FAIL_5211,	0x00000000 },
+	{ AR5K_ACK_FAIL_5211,	0x00000000 },
+	{ AR5K_FCS_FAIL_5211,	0x00000000 },
+	{ AR5K_BEACON_CNT_5211,	0x00000000 },
+	{ AR5K_XRMODE,		0x2a82301a },
+	{ AR5K_XRDELAY,		0x05dc01e0 },
+	{ AR5K_XRTIMEOUT,	0x1f402710 },
+	{ AR5K_XRCHIRP,		0x01f40000 },
+	{ AR5K_XRSTOMP,		0x00001e1c },
+	{ AR5K_SLEEP0,		0x0002aaaa },
+	{ AR5K_SLEEP1,		0x02005555 },
+	{ AR5K_SLEEP2,		0x00000000 },
+	{ AR5K_BSS_IDM0,	0xffffffff },
+	{ AR5K_BSS_IDM1,	0x0000ffff },
+	{ AR5K_TXPC,		0x00000000 },
+	{ AR5K_PROFCNT_TX,	0x00000000 },
+	{ AR5K_PROFCNT_RX,	0x00000000 },
+	{ AR5K_PROFCNT_RXCLR,	0x00000000 },
+	{ AR5K_PROFCNT_CYCLE,	0x00000000 },
+	{ 0x80fc, 0x00000088 },
+	{ AR5K_RATE_DUR(0),	0x00000000 },
+	{ AR5K_RATE_DUR(1),	0x0000008c },
+	{ AR5K_RATE_DUR(2),	0x000000e4 },
+	{ AR5K_RATE_DUR(3),	0x000002d5 },
+	{ AR5K_RATE_DUR(4),	0x00000000 },
+	{ AR5K_RATE_DUR(5),	0x00000000 },
+	{ AR5K_RATE_DUR(6),	0x000000a0 },
+	{ AR5K_RATE_DUR(7),	0x000001c9 },
+	{ AR5K_RATE_DUR(8),	0x0000002c },
+	{ AR5K_RATE_DUR(9),	0x0000002c },
+	{ AR5K_RATE_DUR(10),	0x00000030 },
+	{ AR5K_RATE_DUR(11),	0x0000003c },
+	{ AR5K_RATE_DUR(12),	0x0000002c },
+	{ AR5K_RATE_DUR(13),	0x0000002c },
+	{ AR5K_RATE_DUR(14),	0x00000030 },
+	{ AR5K_RATE_DUR(15),	0x0000003c },
+	{ AR5K_RATE_DUR(16),	0x00000000 },
+	{ AR5K_RATE_DUR(17),	0x00000000 },
+	{ AR5K_RATE_DUR(18),	0x00000000 },
+	{ AR5K_RATE_DUR(19),	0x00000000 },
+	{ AR5K_RATE_DUR(20),	0x00000000 },
+	{ AR5K_RATE_DUR(21),	0x00000000 },
+	{ AR5K_RATE_DUR(22),	0x00000000 },
+	{ AR5K_RATE_DUR(23),	0x00000000 },
+	{ AR5K_RATE_DUR(24),	0x000000d5 },
+	{ AR5K_RATE_DUR(25),	0x000000df },
+	{ AR5K_RATE_DUR(26),	0x00000102 },
+	{ AR5K_RATE_DUR(27),	0x0000013a },
+	{ AR5K_RATE_DUR(28),	0x00000075 },
+	{ AR5K_RATE_DUR(29),	0x0000007f },
+	{ AR5K_RATE_DUR(30),	0x000000a2 },
+	{ AR5K_RATE_DUR(31),	0x00000000 },
+	{ 0x8100, 0x00010002},
+	{ AR5K_TSF_PARM,	0x00000001 },
+	{ 0x8108, 0x000000c0 },
+	{ AR5K_PHY_ERR_FIL,	0x00000000 },
+	{ 0x8110, 0x00000168 },
+	{ 0x8114, 0x00000000 },
+	/* Some kind of table
+	 * also notice ...03<-02<-01<-00) */
+	{ 0x87c0, 0x03020100 },
+	{ 0x87c4, 0x07060504 },
+	{ 0x87c8, 0x0b0a0908 },
+	{ 0x87cc, 0x0f0e0d0c },
+	{ 0x87d0, 0x13121110 },
+	{ 0x87d4, 0x17161514 },
+	{ 0x87d8, 0x1b1a1918 },
+	{ 0x87dc, 0x1f1e1d1c },
+	/* loop ? */
+	{ 0x87e0, 0x03020100 },
+	{ 0x87e4, 0x07060504 },
+	{ 0x87e8, 0x0b0a0908 },
+	{ 0x87ec, 0x0f0e0d0c },
+	{ 0x87f0, 0x13121110 },
+	{ 0x87f4, 0x17161514 },
+	{ 0x87f8, 0x1b1a1918 },
+	{ 0x87fc, 0x1f1e1d1c },
+	/* PHY registers */
+	{ AR5K_PHY_AGC,	0x00000000 },
+	{ AR5K_PHY(3),	0xad848e19 },
+	{ AR5K_PHY(4),	0x7d28e000 },
+	{ AR5K_PHY_TIMING_3, 0x9c0a9f6b },
+	{ AR5K_PHY_ACT,	0x00000000 },
+	{ AR5K_PHY(11),	0x00022ffe },
+	{ AR5K_PHY(15),	0x00020100 },
+	{ AR5K_PHY(16),	0x206a017a },
+	{ AR5K_PHY(19),	0x1284613c },
+	{ AR5K_PHY(21),	0x00000859 },
+	{ AR5K_PHY(64),	0x00000000 },
+	{ AR5K_PHY(65),	0x00000000 },
+	{ AR5K_PHY(66),	0x00000000 },
+	{ AR5K_PHY(67),	0x00800000 },
+	{ AR5K_PHY(68),	0x00000001 },
+	{ AR5K_PHY(71),	0x0000092a },
+	{ AR5K_PHY_IQ,	0x05100000 },
+	{ AR5K_PHY(74), 0x00000001 },
+	{ AR5K_PHY(75), 0x00000004 },
+	{ AR5K_PHY_TXPOWER_RATE1, 0x1e1f2022 },
+	{ AR5K_PHY_TXPOWER_RATE2, 0x0a0b0c0d },
+	{ AR5K_PHY_TXPOWER_RATE_MAX, 0x0000003f },
+	{ AR5K_PHY(80), 0x00000004 },
+	{ AR5K_PHY(82), 0x9280b212 },
+	{ AR5K_PHY_RADAR, 0x5d50e188 },
+	{ AR5K_PHY(86),	0x000000ff },
+	{ AR5K_PHY(87),	0x004b6a8e },
+	{ AR5K_PHY(90),	0x000003ce },
+	{ AR5K_PHY(92),	0x192fb515 },
+	{ AR5K_PHY(93),	0x00000000 },
+	{ AR5K_PHY(94),	0x00000001 },
+	{ AR5K_PHY(95),	0x00000000 },
+	/* Power table (32bytes) */
+	{ AR5K_PHY_PCDAC_TXPOWER(1), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(2), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(3), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(4), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(5), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(6), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(7), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(8), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(9), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(10), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(11), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(12), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(13), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(14), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(15), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(16), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(17), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(18), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(19), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(20), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(21), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(22), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(23), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(24), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(25), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(26), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(27), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(28), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(29), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(30), 0x10ff10ff },
+	{ AR5K_PHY_PCDAC_TXPOWER(31), 0x10ff10ff },
+	{ AR5K_PHY(644), 0x0080a333 },
+	{ AR5K_PHY(645), 0x00206c10 },
+	{ AR5K_PHY(646), 0x009c4060 },
+	{ AR5K_PHY(647), 0x1483800a },
+	{ AR5K_PHY(648), 0x01831061 },
+	{ AR5K_PHY(649), 0x00000400 },
+	{ AR5K_PHY(650), 0x000001b5 },
+	{ AR5K_PHY(651), 0x00000000 },
+	{ AR5K_PHY_TXPOWER_RATE3, 0x20202020 },
+	{ AR5K_PHY_TXPOWER_RATE2, 0x20202020 },
+	{ AR5K_PHY(655), 0x13c889af },
+	{ AR5K_PHY(656), 0x38490a20 },
+	{ AR5K_PHY(657), 0x00007bb6 },
+	{ AR5K_PHY(658), 0x0fff3ffc },
+	{ AR5K_PHY_CCKTXCTL, 0x00000000 },
+};
+
+/* Initial mode-specific settings for AR5212 */
+static const struct ath5k_ini_mode ar5212_ini_mode[] = {
+	{ AR5K_TXCFG,
+	/*	  a/XR	      aTurbo	  b	      g (DYN)	  gTurbo */
+		{ 0x00008107, 0x00008107, 0x00008107, 0x00008107, 0x00008107 } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(0),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(1),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(2),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(3),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(4),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(5),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(6),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(7),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(8),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_QUEUE_DFS_LOCAL_IFS(9),
+		{ 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	{ AR5K_DCU_GBL_IFS_SIFS,
+		{ 0x00000230, 0x000001e0, 0x000000b0, 0x00000160, 0x000001e0 } },
+	{ AR5K_DCU_GBL_IFS_SLOT,
+		{ 0x00000168, 0x000001e0, 0x000001b8, 0x0000018c, 0x000001e0 } },
+	{ AR5K_DCU_GBL_IFS_EIFS,
+		{ 0x00000e60, 0x00001180, 0x00001f1c, 0x00003e38, 0x00001180 } },
+	{ AR5K_DCU_GBL_IFS_MISC,
+		{ 0x0000a0e0, 0x00014068, 0x00005880, 0x0000b0e0, 0x00014068 } },
+	{ AR5K_TIME_OUT,
+		{ 0x03e803e8, 0x06e006e0, 0x04200420, 0x08400840, 0x06e006e0 } },
+};
+
+/* Initial mode-specific settings for AR5212 + RF5111 */
+static const struct ath5k_ini_mode ar5212_rf5111_ini_mode[] = {
+	{ AR5K_USEC_5211,
+	/*	  a/XR	      aTurbo	  b	      g		  gTurbo */
+		{ 0x128d8fa7, 0x09880fcf, 0x04e00f95, 0x128d8fab, 0x09880fcf } },
+	{ AR5K_PHY_TURBO,
+		{ 0x00000000, 0x00000003, 0x00000000, 0x00000000, 0x00000003 } },
+	{ 0x9820,
+		{ 0x02020200, 0x02020200, 0x02010200, 0x02020200, 0x02020200 } },
+	{ 0x9824,
+		{ 0x00000e0e, 0x00000e0e, 0x00000707, 0x00000e0e, 0x00000e0e } },
+	{ 0x9828,
+		{ 0x0a020001, 0x0a020001, 0x05010100, 0x0a020001, 0x0a020001 } },
+	{ 0x9834,
+		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
+	{ 0x9838,
+		{ 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },
+	{ 0x9844,
+		{ 0x1372161c, 0x13721c25, 0x13721728, 0x137216a2, 0x13721c25 } },
+	{ 0x9848,
+		{ 0x0018da5a, 0x0018da5a, 0x0018ca69, 0x0018ca69, 0x0018ca69 } },
+	{ 0x9850,
+		{ 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0 } },
+	{ AR5K_PHY_SIG,
+		{ 0x7e800d2e, 0x7e800d2e, 0x7ee84d2e, 0x7ee84d2e, 0x7e800d2e } },
+	{ AR5K_PHY_AGCCOARSE,
+		{ 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e, 0x3137615e } },
+	{ AR5K_PHY_AGCCTL,
+		{ 0x00009d10, 0x00009d10, 0x00009d18, 0x00009d10, 0x00009d10 } },
+	{ AR5K_PHY_NF,
+		{ 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
+	{ AR5K_PHY_ADCSAT,
+		{ 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190 } },
+	{ 0x986c,
+		{ 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb080, 0x050cb080 } },
+	{ AR5K_PHY_RX_DELAY,
+		{ 0x00002710, 0x00002710, 0x0000157c, 0x00002af8, 0x00002710 } },
+	{ 0x9918,
+		{ 0x000001b8, 0x000001b8, 0x00000084, 0x00000108, 0x000001b8 } },
+	{ 0x9924,
+		{ 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05 } },
+	{ AR5K_PHY_FRAME_CTL_5211,
+		{ 0xffb81020, 0xffb81020, 0xffb80d20, 0xffb81020, 0xffb81020 } },
+	{ AR5K_PHY_PCDAC_TXPOWER(0),
+		{ 0x10ff14ff, 0x10ff14ff, 0x10ff10ff, 0x10ff19ff, 0x10ff19ff } },
+	{ 0xa230,
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000108, 0x00000000 } },
+	{ 0xa208,
+		{ 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
+};
+
+/* Initial mode-specific settings for AR5212 + RF5112 */
+static const struct ath5k_ini_mode ar5212_rf5112_ini_mode[] = {
+	{ AR5K_USEC_5211,
+	/*	  a/XR	      aTurbo	  b	      g		  gTurbo */
+		{ 0x128d93a7, 0x098813cf, 0x04e01395, 0x128d93ab, 0x098813cf } },
+	{ AR5K_PHY_TURBO,
+		{ 0x00000000, 0x00000003, 0x00000000, 0x00000000, 0x00000003 } },
+	{ 0x9820,
+		{ 0x02020200, 0x02020200, 0x02010200, 0x02020200, 0x02020200 } },
+	{ 0x9824,
+		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
+	{ 0x9828,
+		{ 0x0a020001, 0x0a020001, 0x05020100, 0x0a020001, 0x0a020001 } },
+	{ 0x9834,
+		{ 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
+	{ 0x9838,
+		{ 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },
+	{ 0x9844,
+		{ 0x1372161c, 0x13721c25, 0x13721728, 0x137216a2, 0x13721c25 } },
+	{ 0x9848,
+		{ 0x0018da6d, 0x0018da6d, 0x0018ca75, 0x0018ca75, 0x0018ca75 } },
+	{ 0x9850,
+		{ 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0 } },
+	{ AR5K_PHY_SIG,
+		{ 0x7e800d2e, 0x7e800d2e, 0x7ee84d2e, 0x7ee84d2e, 0x7e800d2e } },
+	{ AR5K_PHY_AGCCOARSE,
+		{ 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e } },
+	{ AR5K_PHY_AGCCTL,
+		{ 0x00009d10, 0x00009d10, 0x00009d18, 0x00009d10, 0x00009d10 } },
+	{ AR5K_PHY_NF,
+		{ 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
+	{ AR5K_PHY_ADCSAT,
+		{ 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190 } },
+	{ 0x986c,
+		{ 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081 } },
+	{ AR5K_PHY_RX_DELAY,
+		{ 0x000007d0, 0x000007d0, 0x0000044c, 0x00000898, 0x000007d0 } },
+	{ 0x9918,
+		{ 0x000001b8, 0x000001b8, 0x00000084, 0x00000108, 0x000001b8 } },
+	{ 0x9924,
+		{ 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05 } },
+	{ AR5K_PHY_FRAME_CTL_5211,
+		{ 0xffb81020, 0xffb81020, 0xffb80d10, 0xffb81010, 0xffb81010 } },
+	{ AR5K_PHY_PCDAC_TXPOWER(0),
+		{ 0x10ff14ff, 0x10ff14ff, 0x10ff10ff, 0x10ff19ff, 0x10ff19ff } },
+	{ 0xa230,
+		{ 0x00000000, 0x00000000, 0x00000000, 0x00000108, 0x00000000 } },
+	{ AR5K_PHY_CCKTXCTL,
+		{ 0x00000000, 0x00000000, 0x00000004, 0x00000004, 0x00000004 } },
+	{ 0xa208,
+		{ 0xd6be6788, 0xd6be6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
+	{ AR5K_PHY_GAIN_2GHZ,
+		{ 0x642c0140, 0x642c0140, 0x6442c160, 0x6442c160, 0x6442c160 } },
+};
+
+/*
+ * Initial BaseBand Gain settings for RF5111/5112 (only AR5210 comes with
+ * RF5110 so initial BB Gain settings are included in AR5K_AR5210_INI)
+ */
+
+/* RF5111 Initial BaseBand Gain settings */
+static const struct ath5k_ini rf5111_ini_bbgain[] = {
+	{ AR5K_BB_GAIN(0), 0x00000000 },
+	{ AR5K_BB_GAIN(1), 0x00000020 },
+	{ AR5K_BB_GAIN(2), 0x00000010 },
+	{ AR5K_BB_GAIN(3), 0x00000030 },
+	{ AR5K_BB_GAIN(4), 0x00000008 },
+	{ AR5K_BB_GAIN(5), 0x00000028 },
+	{ AR5K_BB_GAIN(6), 0x00000004 },
+	{ AR5K_BB_GAIN(7), 0x00000024 },
+	{ AR5K_BB_GAIN(8), 0x00000014 },
+	{ AR5K_BB_GAIN(9), 0x00000034 },
+	{ AR5K_BB_GAIN(10), 0x0000000c },
+	{ AR5K_BB_GAIN(11), 0x0000002c },
+	{ AR5K_BB_GAIN(12), 0x00000002 },
+	{ AR5K_BB_GAIN(13), 0x00000022 },
+	{ AR5K_BB_GAIN(14), 0x00000012 },
+	{ AR5K_BB_GAIN(15), 0x00000032 },
+	{ AR5K_BB_GAIN(16), 0x0000000a },
+	{ AR5K_BB_GAIN(17), 0x0000002a },
+	{ AR5K_BB_GAIN(18), 0x00000006 },
+	{ AR5K_BB_GAIN(19), 0x00000026 },
+	{ AR5K_BB_GAIN(20), 0x00000016 },
+	{ AR5K_BB_GAIN(21), 0x00000036 },
+	{ AR5K_BB_GAIN(22), 0x0000000e },
+	{ AR5K_BB_GAIN(23), 0x0000002e },
+	{ AR5K_BB_GAIN(24), 0x00000001 },
+	{ AR5K_BB_GAIN(25), 0x00000021 },
+	{ AR5K_BB_GAIN(26), 0x00000011 },
+	{ AR5K_BB_GAIN(27), 0x00000031 },
+	{ AR5K_BB_GAIN(28), 0x00000009 },
+	{ AR5K_BB_GAIN(29), 0x00000029 },
+	{ AR5K_BB_GAIN(30), 0x00000005 },
+	{ AR5K_BB_GAIN(31), 0x00000025 },
+	{ AR5K_BB_GAIN(32), 0x00000015 },
+	{ AR5K_BB_GAIN(33), 0x00000035 },
+	{ AR5K_BB_GAIN(34), 0x0000000d },
+	{ AR5K_BB_GAIN(35), 0x0000002d },
+	{ AR5K_BB_GAIN(36), 0x00000003 },
+	{ AR5K_BB_GAIN(37), 0x00000023 },
+	{ AR5K_BB_GAIN(38), 0x00000013 },
+	{ AR5K_BB_GAIN(39), 0x00000033 },
+	{ AR5K_BB_GAIN(40), 0x0000000b },
+	{ AR5K_BB_GAIN(41), 0x0000002b },
+	{ AR5K_BB_GAIN(42), 0x0000002b },
+	{ AR5K_BB_GAIN(43), 0x0000002b },
+	{ AR5K_BB_GAIN(44), 0x0000002b },
+	{ AR5K_BB_GAIN(45), 0x0000002b },
+	{ AR5K_BB_GAIN(46), 0x0000002b },
+	{ AR5K_BB_GAIN(47), 0x0000002b },
+	{ AR5K_BB_GAIN(48), 0x0000002b },
+	{ AR5K_BB_GAIN(49), 0x0000002b },
+	{ AR5K_BB_GAIN(50), 0x0000002b },
+	{ AR5K_BB_GAIN(51), 0x0000002b },
+	{ AR5K_BB_GAIN(52), 0x0000002b },
+	{ AR5K_BB_GAIN(53), 0x0000002b },
+	{ AR5K_BB_GAIN(54), 0x0000002b },
+	{ AR5K_BB_GAIN(55), 0x0000002b },
+	{ AR5K_BB_GAIN(56), 0x0000002b },
+	{ AR5K_BB_GAIN(57), 0x0000002b },
+	{ AR5K_BB_GAIN(58), 0x0000002b },
+	{ AR5K_BB_GAIN(59), 0x0000002b },
+	{ AR5K_BB_GAIN(60), 0x0000002b },
+	{ AR5K_BB_GAIN(61), 0x0000002b },
+	{ AR5K_BB_GAIN(62), 0x00000002 },
+	{ AR5K_BB_GAIN(63), 0x00000016 },
+};
+
+/* RF 5112 Initial BaseBand Gain settings */
+static const struct ath5k_ini rf5112_ini_bbgain[] = {
+	{ AR5K_BB_GAIN(0), 0x00000000 },
+	{ AR5K_BB_GAIN(1), 0x00000001 },
+	{ AR5K_BB_GAIN(2), 0x00000002 },
+	{ AR5K_BB_GAIN(3), 0x00000003 },
+	{ AR5K_BB_GAIN(4), 0x00000004 },
+	{ AR5K_BB_GAIN(5), 0x00000005 },
+	{ AR5K_BB_GAIN(6), 0x00000008 },
+	{ AR5K_BB_GAIN(7), 0x00000009 },
+	{ AR5K_BB_GAIN(8), 0x0000000a },
+	{ AR5K_BB_GAIN(9), 0x0000000b },
+	{ AR5K_BB_GAIN(10), 0x0000000c },
+	{ AR5K_BB_GAIN(11), 0x0000000d },
+	{ AR5K_BB_GAIN(12), 0x00000010 },
+	{ AR5K_BB_GAIN(13), 0x00000011 },
+	{ AR5K_BB_GAIN(14), 0x00000012 },
+	{ AR5K_BB_GAIN(15), 0x00000013 },
+	{ AR5K_BB_GAIN(16), 0x00000014 },
+	{ AR5K_BB_GAIN(17), 0x00000015 },
+	{ AR5K_BB_GAIN(18), 0x00000018 },
+	{ AR5K_BB_GAIN(19), 0x00000019 },
+	{ AR5K_BB_GAIN(20), 0x0000001a },
+	{ AR5K_BB_GAIN(21), 0x0000001b },
+	{ AR5K_BB_GAIN(22), 0x0000001c },
+	{ AR5K_BB_GAIN(23), 0x0000001d },
+	{ AR5K_BB_GAIN(24), 0x00000020 },
+	{ AR5K_BB_GAIN(25), 0x00000021 },
+	{ AR5K_BB_GAIN(26), 0x00000022 },
+	{ AR5K_BB_GAIN(27), 0x00000023 },
+	{ AR5K_BB_GAIN(28), 0x00000024 },
+	{ AR5K_BB_GAIN(29), 0x00000025 },
+	{ AR5K_BB_GAIN(30), 0x00000028 },
+	{ AR5K_BB_GAIN(31), 0x00000029 },
+	{ AR5K_BB_GAIN(32), 0x0000002a },
+	{ AR5K_BB_GAIN(33), 0x0000002b },
+	{ AR5K_BB_GAIN(34), 0x0000002c },
+	{ AR5K_BB_GAIN(35), 0x0000002d },
+	{ AR5K_BB_GAIN(36), 0x00000030 },
+	{ AR5K_BB_GAIN(37), 0x00000031 },
+	{ AR5K_BB_GAIN(38), 0x00000032 },
+	{ AR5K_BB_GAIN(39), 0x00000033 },
+	{ AR5K_BB_GAIN(40), 0x00000034 },
+	{ AR5K_BB_GAIN(41), 0x00000035 },
+	{ AR5K_BB_GAIN(42), 0x00000035 },
+	{ AR5K_BB_GAIN(43), 0x00000035 },
+	{ AR5K_BB_GAIN(44), 0x00000035 },
+	{ AR5K_BB_GAIN(45), 0x00000035 },
+	{ AR5K_BB_GAIN(46), 0x00000035 },
+	{ AR5K_BB_GAIN(47), 0x00000035 },
+	{ AR5K_BB_GAIN(48), 0x00000035 },
+	{ AR5K_BB_GAIN(49), 0x00000035 },
+	{ AR5K_BB_GAIN(50), 0x00000035 },
+	{ AR5K_BB_GAIN(51), 0x00000035 },
+	{ AR5K_BB_GAIN(52), 0x00000035 },
+	{ AR5K_BB_GAIN(53), 0x00000035 },
+	{ AR5K_BB_GAIN(54), 0x00000035 },
+	{ AR5K_BB_GAIN(55), 0x00000035 },
+	{ AR5K_BB_GAIN(56), 0x00000035 },
+	{ AR5K_BB_GAIN(57), 0x00000035 },
+	{ AR5K_BB_GAIN(58), 0x00000035 },
+	{ AR5K_BB_GAIN(59), 0x00000035 },
+	{ AR5K_BB_GAIN(60), 0x00000035 },
+	{ AR5K_BB_GAIN(61), 0x00000035 },
+	{ AR5K_BB_GAIN(62), 0x00000010 },
+	{ AR5K_BB_GAIN(63), 0x0000001a },
+};
+
+/*
+ * Write initial register dump
+ */
+static void ath5k_hw_ini_registers(struct ath_hw *hal, unsigned int size,
+		const struct ath5k_ini *ini_regs, bool change_channel)
+{
+	unsigned int i;
+
+	/* Write initial registers */
+	for (i = 0; i < size; i++) {
+		/* On channel change there is
+		 * no need to mess with PCU */
+		if (change_channel &&
+				ini_regs[i].ini_register >= AR5K_PCU_MIN &&
+				ini_regs[i].ini_register <= AR5K_PCU_MAX)
+			continue;
+
+		switch (ini_regs[i].ini_mode) {
+		case AR5K_INI_READ:
+			/* Cleared on read */
+			ath5k_hw_reg_read(hal, ini_regs[i].ini_register);
+			break;
+		case AR5K_INI_WRITE:
+		default:
+			AR5K_REG_WAIT(i);
+			ath5k_hw_reg_write(hal, ini_regs[i].ini_value,
+					ini_regs[i].ini_register);
+		}
+	}
+}
+
+static void ath5k_hw_ini_mode_registers(struct ath_hw *hal,
+		unsigned int size, const struct ath5k_ini_mode *ini_mode,
+		u8 mode)
+{
+	unsigned int i;
+
+	for (i = 0; i < size; i++) {
+		AR5K_REG_WAIT(i);
+		ath5k_hw_reg_write(hal, ini_mode[i].mode_value[mode],
+			(u32)ini_mode[i].mode_register);
+	}
+
+}
+
+int ath5k_hw_write_initvals(struct ath_hw *hal, u8 mode, bool change_channel)
+{
+	/*
+	 * Write initial mode-specific settings
+	 */
+	/*For 5212*/
+	if (hal->ah_version == AR5K_AR5212) {
+		ath5k_hw_ini_mode_registers(hal, ARRAY_SIZE(ar5212_ini_mode),
+				ar5212_ini_mode, mode);
+		if (hal->ah_radio == AR5K_RF5111)
+			ath5k_hw_ini_mode_registers(hal,
+					ARRAY_SIZE(ar5212_rf5111_ini_mode),
+					ar5212_rf5111_ini_mode, mode);
+		else if (hal->ah_radio == AR5K_RF5112)
+			ath5k_hw_ini_mode_registers(hal,
+					ARRAY_SIZE(ar5212_rf5112_ini_mode),
+					ar5212_rf5112_ini_mode, mode);
+	}
+	/*For 5211*/
+	if (hal->ah_version == AR5K_AR5211)
+		ath5k_hw_ini_mode_registers(hal, ARRAY_SIZE(ar5211_ini_mode),
+				ar5211_ini_mode, mode);
+	/* For 5210 mode settings check out ath5k_hw_reset_tx_queue */
+
+	/*
+	 * Write initial settings common for all modes
+	 */
+	/*For 5212*/
+	if (hal->ah_version == AR5K_AR5212) {
+		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5212_ini),
+				ar5212_ini, change_channel);
+		if (hal->ah_radio == AR5K_RF5112) {
+			ath5k_hw_reg_write(hal, AR5K_PHY_PAPD_PROBE_INI_5112,
+					AR5K_PHY_PAPD_PROBE);
+			ath5k_hw_ini_registers(hal,
+					ARRAY_SIZE(rf5112_ini_bbgain),
+					rf5112_ini_bbgain, change_channel);
+		} else if (hal->ah_radio == AR5K_RF5111) {
+			ath5k_hw_reg_write(hal, AR5K_PHY_GAIN_2GHZ_INI_5111,
+					AR5K_PHY_GAIN_2GHZ);
+			ath5k_hw_reg_write(hal, AR5K_PHY_PAPD_PROBE_INI_5111,
+					AR5K_PHY_PAPD_PROBE);
+			ath5k_hw_ini_registers(hal,
+					ARRAY_SIZE(rf5111_ini_bbgain),
+					rf5111_ini_bbgain, change_channel);
+		}
+	} else if (hal->ah_version == AR5K_AR5211) {
+		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5211_ini),
+				ar5211_ini, change_channel);
+		/* AR5211 only comes with 5111 */
+		ath5k_hw_ini_registers(hal, ARRAY_SIZE(rf5111_ini_bbgain),
+				rf5111_ini_bbgain, change_channel);
+	} else if (hal->ah_version == AR5K_AR5210) {
+		ath5k_hw_ini_registers(hal, ARRAY_SIZE(ar5210_ini),
+				ar5210_ini, change_channel);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath5k_hw_phy.c b/drivers/net/wireless/ath5k_hw_phy.c
new file mode 100644
index 0000000..899b79e
--- /dev/null
+++ b/drivers/net/wireless/ath5k_hw_phy.c
@@ -0,0 +1,1674 @@
+/*
+ * PHY functions
+ *
+ * Copyright (c) 2007 The MadWiFi Team <www.madwifi.org>
+ * Copyright (c) 2004, 2005 Reyk Floeter <reyk@vantronix.net>
+ *
+ * This file is released under GPLv2
+ */
+
+#include <linux/delay.h>
+
+#include "ath5k.h"
+#include "ath5k_reg.h"
+
+/* Struct to hold initial RF register values (RF Banks) */
+struct ath5k_ini_rf {
+	u8	rf_bank;	/* check out ath5k_reg.h */
+	u16	rf_register;	/* register address */
+	u32	rf_value[5];	/* register value for different modes (above) */
+};
+
+/*
+ * Mode-specific RF Gain table (64bytes) for RF5111/5112
+ * (RF5110 only comes with AR5210 and only supports a/turbo a mode so initial
+ * RF Gain values are included in AR5K_AR5210_INI)
+ */
+struct ath5k_ini_rfgain {
+	u16	rfg_register;	/* RF Gain register address */
+	u32	rfg_value[2];	/* [freq (see below)] */
+};
+
+struct ath5k_gain_opt {
+	u32			go_default;
+	u32			go_steps_count;
+	const struct ath5k_gain_opt_step	go_step[AR5K_GAIN_STEP_COUNT];
+};
+
+/* RF5111 mode-specific init registers */
+static const struct ath5k_ini_rf rfregs_5111[] = {
+	{ 0, 0x989c,
+	/*    mode a/XR   mode aTurbo mode b      mode g      mode gTurbo */
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0, 0x989c,
+	    { 0x00380000, 0x00380000, 0x00380000, 0x00380000, 0x00380000 } },
+	{ 0, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 0, 0x989c,
+	    { 0x00000000, 0x00000000, 0x000000c0, 0x00000080, 0x00000080 } },
+	{ 0, 0x989c,
+	    { 0x000400f9, 0x000400f9, 0x000400ff, 0x000400fd, 0x000400fd } },
+	{ 0, 0x98d4,
+	    { 0x00000000, 0x00000000, 0x00000004, 0x00000004, 0x00000004 } },
+	{ 1, 0x98d4,
+	    { 0x00000020, 0x00000020, 0x00000020, 0x00000020, 0x00000020 } },
+	{ 2, 0x98d4,
+	    { 0x00000010, 0x00000014, 0x00000010, 0x00000010, 0x00000014 } },
+	{ 3, 0x98d8,
+	    { 0x00601068, 0x00601068, 0x00601068, 0x00601068, 0x00601068 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x10000000, 0x10000000, 0x10000000, 0x10000000, 0x10000000 } },
+	{ 6, 0x989c,
+	    { 0x04000000, 0x04000000, 0x04000000, 0x04000000, 0x04000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x0a000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x003800c0, 0x00380080, 0x023800c0, 0x003800c0, 0x003800c0 } },
+	{ 6, 0x989c,
+	    { 0x00020006, 0x00020006, 0x00000006, 0x00020006, 0x00020006 } },
+	{ 6, 0x989c,
+	    { 0x00000089, 0x00000089, 0x00000089, 0x00000089, 0x00000089 } },
+	{ 6, 0x989c,
+	    { 0x000000a0, 0x000000a0, 0x000000a0, 0x000000a0, 0x000000a0 } },
+	{ 6, 0x989c,
+	    { 0x00040007, 0x00040007, 0x00040007, 0x00040007, 0x00040007 } },
+	{ 6, 0x98d4,
+	    { 0x0000001a, 0x0000001a, 0x0000001a, 0x0000001a, 0x0000001a } },
+	{ 7, 0x989c,
+	    { 0x00000040, 0x00000048, 0x00000040, 0x00000040, 0x00000040 } },
+	{ 7, 0x989c,
+	    { 0x00000010, 0x00000010, 0x00000010, 0x00000010, 0x00000010 } },
+	{ 7, 0x989c,
+	    { 0x00000008, 0x00000008, 0x00000008, 0x00000008, 0x00000008 } },
+	{ 7, 0x989c,
+	    { 0x0000004f, 0x0000004f, 0x0000004f, 0x0000004f, 0x0000004f } },
+	{ 7, 0x989c,
+	    { 0x000000f1, 0x000000f1, 0x00000061, 0x000000f1, 0x000000f1 } },
+	{ 7, 0x989c,
+	    { 0x0000904f, 0x0000904f, 0x0000904c, 0x0000904f, 0x0000904f } },
+	{ 7, 0x989c,
+	    { 0x0000125a, 0x0000125a, 0x0000129a, 0x0000125a, 0x0000125a } },
+	{ 7, 0x98cc,
+	    { 0x0000000e, 0x0000000e, 0x0000000f, 0x0000000e, 0x0000000e } },
+};
+
+/* Initial RF Gain settings for RF5111 */
+static const struct ath5k_ini_rfgain rfgain_5111[] = {
+	/*			      5Ghz	2Ghz	*/
+	{ AR5K_RF_GAIN(0),	{ 0x000001a9, 0x00000000 } },
+	{ AR5K_RF_GAIN(1),	{ 0x000001e9, 0x00000040 } },
+	{ AR5K_RF_GAIN(2),	{ 0x00000029, 0x00000080 } },
+	{ AR5K_RF_GAIN(3),	{ 0x00000069, 0x00000150 } },
+	{ AR5K_RF_GAIN(4),	{ 0x00000199, 0x00000190 } },
+	{ AR5K_RF_GAIN(5),	{ 0x000001d9, 0x000001d0 } },
+	{ AR5K_RF_GAIN(6),	{ 0x00000019, 0x00000010 } },
+	{ AR5K_RF_GAIN(7),	{ 0x00000059, 0x00000044 } },
+	{ AR5K_RF_GAIN(8),	{ 0x00000099, 0x00000084 } },
+	{ AR5K_RF_GAIN(9),	{ 0x000001a5, 0x00000148 } },
+	{ AR5K_RF_GAIN(10),	{ 0x000001e5, 0x00000188 } },
+	{ AR5K_RF_GAIN(11),	{ 0x00000025, 0x000001c8 } },
+	{ AR5K_RF_GAIN(12),	{ 0x000001c8, 0x00000014 } },
+	{ AR5K_RF_GAIN(13),	{ 0x00000008, 0x00000042 } },
+	{ AR5K_RF_GAIN(14),	{ 0x00000048, 0x00000082 } },
+	{ AR5K_RF_GAIN(15),	{ 0x00000088, 0x00000178 } },
+	{ AR5K_RF_GAIN(16),	{ 0x00000198, 0x000001b8 } },
+	{ AR5K_RF_GAIN(17),	{ 0x000001d8, 0x000001f8 } },
+	{ AR5K_RF_GAIN(18),	{ 0x00000018, 0x00000012 } },
+	{ AR5K_RF_GAIN(19),	{ 0x00000058, 0x00000052 } },
+	{ AR5K_RF_GAIN(20),	{ 0x00000098, 0x00000092 } },
+	{ AR5K_RF_GAIN(21),	{ 0x000001a4, 0x0000017c } },
+	{ AR5K_RF_GAIN(22),	{ 0x000001e4, 0x000001bc } },
+	{ AR5K_RF_GAIN(23),	{ 0x00000024, 0x000001fc } },
+	{ AR5K_RF_GAIN(24),	{ 0x00000064, 0x0000000a } },
+	{ AR5K_RF_GAIN(25),	{ 0x000000a4, 0x0000004a } },
+	{ AR5K_RF_GAIN(26),	{ 0x000000e4, 0x0000008a } },
+	{ AR5K_RF_GAIN(27),	{ 0x0000010a, 0x0000015a } },
+	{ AR5K_RF_GAIN(28),	{ 0x0000014a, 0x0000019a } },
+	{ AR5K_RF_GAIN(29),	{ 0x0000018a, 0x000001da } },
+	{ AR5K_RF_GAIN(30),	{ 0x000001ca, 0x0000000e } },
+	{ AR5K_RF_GAIN(31),	{ 0x0000000a, 0x0000004e } },
+	{ AR5K_RF_GAIN(32),	{ 0x0000004a, 0x0000008e } },
+	{ AR5K_RF_GAIN(33),	{ 0x0000008a, 0x0000015e } },
+	{ AR5K_RF_GAIN(34),	{ 0x000001ba, 0x0000019e } },
+	{ AR5K_RF_GAIN(35),	{ 0x000001fa, 0x000001de } },
+	{ AR5K_RF_GAIN(36),	{ 0x0000003a, 0x00000009 } },
+	{ AR5K_RF_GAIN(37),	{ 0x0000007a, 0x00000049 } },
+	{ AR5K_RF_GAIN(38),	{ 0x00000186, 0x00000089 } },
+	{ AR5K_RF_GAIN(39),	{ 0x000001c6, 0x00000179 } },
+	{ AR5K_RF_GAIN(40),	{ 0x00000006, 0x000001b9 } },
+	{ AR5K_RF_GAIN(41),	{ 0x00000046, 0x000001f9 } },
+	{ AR5K_RF_GAIN(42),	{ 0x00000086, 0x00000039 } },
+	{ AR5K_RF_GAIN(43),	{ 0x000000c6, 0x00000079 } },
+	{ AR5K_RF_GAIN(44),	{ 0x000000c6, 0x000000b9 } },
+	{ AR5K_RF_GAIN(45),	{ 0x000000c6, 0x000001bd } },
+	{ AR5K_RF_GAIN(46),	{ 0x000000c6, 0x000001fd } },
+	{ AR5K_RF_GAIN(47),	{ 0x000000c6, 0x0000003d } },
+	{ AR5K_RF_GAIN(48),	{ 0x000000c6, 0x0000007d } },
+	{ AR5K_RF_GAIN(49),	{ 0x000000c6, 0x000000bd } },
+	{ AR5K_RF_GAIN(50),	{ 0x000000c6, 0x000000fd } },
+	{ AR5K_RF_GAIN(51),	{ 0x000000c6, 0x000000fd } },
+	{ AR5K_RF_GAIN(52),	{ 0x000000c6, 0x000000fd } },
+	{ AR5K_RF_GAIN(53),	{ 0x000000c6, 0x000000fd } },
+	{ AR5K_RF_GAIN(54),	{ 0x000000c6, 0x000000fd } },
+	{ AR5K_RF_GAIN(55),	{ 0x000000c6, 0x000000fd } },
+	{ AR5K_RF_GAIN(56),	{ 0x000000c6, 0x000000fd } },
+	{ AR5K_RF_GAIN(57),	{ 0x000000c6, 0x000000fd } },
+	{ AR5K_RF_GAIN(58),	{ 0x000000c6, 0x000000fd } },
+	{ AR5K_RF_GAIN(59),	{ 0x000000c6, 0x000000fd } },
+	{ AR5K_RF_GAIN(60),	{ 0x000000c6, 0x000000fd } },
+	{ AR5K_RF_GAIN(61),	{ 0x000000c6, 0x000000fd } },
+	{ AR5K_RF_GAIN(62),	{ 0x000000c6, 0x000000fd } },
+	{ AR5K_RF_GAIN(63),	{ 0x000000c6, 0x000000fd } },
+};
+
+static const struct ath5k_gain_opt rfgain_opt_5111 = {
+	4,
+	9,
+	{
+		{ { 4, 1, 1, 1 }, 6 },
+		{ { 4, 0, 1, 1 }, 4 },
+		{ { 3, 1, 1, 1 }, 3 },
+		{ { 4, 0, 0, 1 }, 1 },
+		{ { 4, 1, 1, 0 }, 0 },
+		{ { 4, 0, 1, 0 }, -2 },
+		{ { 3, 1, 1, 0 }, -3 },
+		{ { 4, 0, 0, 0 }, -4 },
+		{ { 2, 1, 1, 0 }, -6 }
+	}
+};
+
+/* RF5112 mode-specific init registers */
+static const struct ath5k_ini_rf rfregs_5112[] = {
+	{ 1, 0x98d4,
+	/*    mode a/XR   mode aTurbo mode b      mode g      mode gTurbo */
+	    { 0x00000020, 0x00000020, 0x00000020, 0x00000020, 0x00000020 } },
+	{ 2, 0x98d0,
+	    { 0x03060408, 0x03070408, 0x03060408, 0x03060408, 0x03070408 } },
+	{ 3, 0x98dc,
+	    { 0x00a0c0c0, 0x00a0c0c0, 0x00e0c0c0, 0x00e0c0c0, 0x00e0c0c0 } },
+	{ 6, 0x989c,
+	    { 0x00a00000, 0x00a00000, 0x00a00000, 0x00a00000, 0x00a00000 } },
+	{ 6, 0x989c,
+	    { 0x000a0000, 0x000a0000, 0x000a0000, 0x000a0000, 0x000a0000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00660000, 0x00660000, 0x00660000, 0x00660000, 0x00660000 } },
+	{ 6, 0x989c,
+	    { 0x00db0000, 0x00db0000, 0x00db0000, 0x00db0000, 0x00db0000 } },
+	{ 6, 0x989c,
+	    { 0x00f10000, 0x00f10000, 0x00f10000, 0x00f10000, 0x00f10000 } },
+	{ 6, 0x989c,
+	    { 0x00120000, 0x00120000, 0x00120000, 0x00120000, 0x00120000 } },
+	{ 6, 0x989c,
+	    { 0x00120000, 0x00120000, 0x00120000, 0x00120000, 0x00120000 } },
+	{ 6, 0x989c,
+	    { 0x00730000, 0x00730000, 0x00730000, 0x00730000, 0x00730000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x000c0000, 0x000c0000, 0x000c0000, 0x000c0000, 0x000c0000 } },
+	{ 6, 0x989c,
+	    { 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000 } },
+	{ 6, 0x989c,
+	    { 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000 } },
+	{ 6, 0x989c,
+	    { 0x008b0000, 0x008b0000, 0x008b0000, 0x008b0000, 0x008b0000 } },
+	{ 6, 0x989c,
+	    { 0x00600000, 0x00600000, 0x00600000, 0x00600000, 0x00600000 } },
+	{ 6, 0x989c,
+	    { 0x000c0000, 0x000c0000, 0x000c0000, 0x000c0000, 0x000c0000 } },
+	{ 6, 0x989c,
+	    { 0x00840000, 0x00840000, 0x00840000, 0x00840000, 0x00840000 } },
+	{ 6, 0x989c,
+	    { 0x00640000, 0x00640000, 0x00640000, 0x00640000, 0x00640000 } },
+	{ 6, 0x989c,
+	    { 0x00200000, 0x00200000, 0x00200000, 0x00200000, 0x00200000 } },
+	{ 6, 0x989c,
+	    { 0x00240000, 0x00240000, 0x00240000, 0x00240000, 0x00240000 } },
+	{ 6, 0x989c,
+	    { 0x00250000, 0x00250000, 0x00250000, 0x00250000, 0x00250000 } },
+	{ 6, 0x989c,
+	    { 0x00110000, 0x00110000, 0x00110000, 0x00110000, 0x00110000 } },
+	{ 6, 0x989c,
+	    { 0x00110000, 0x00110000, 0x00110000, 0x00110000, 0x00110000 } },
+	{ 6, 0x989c,
+	    { 0x00510000, 0x00510000, 0x00510000, 0x00510000, 0x00510000 } },
+	{ 6, 0x989c,
+	    { 0x1c040000, 0x1c040000, 0x1c040000, 0x1c040000, 0x1c040000 } },
+	{ 6, 0x989c,
+	    { 0x000a0000, 0x000a0000, 0x000a0000, 0x000a0000, 0x000a0000 } },
+	{ 6, 0x989c,
+	    { 0x00a10000, 0x00a10000, 0x00a10000, 0x00a10000, 0x00a10000 } },
+	{ 6, 0x989c,
+	    { 0x00400000, 0x00400000, 0x00400000, 0x00400000, 0x00400000 } },
+	{ 6, 0x989c,
+	    { 0x03090000, 0x03090000, 0x03090000, 0x03090000, 0x03090000 } },
+	{ 6, 0x989c,
+	    { 0x06000000, 0x06000000, 0x06000000, 0x06000000, 0x06000000 } },
+	{ 6, 0x989c,
+	    { 0x000000b0, 0x000000b0, 0x000000a8, 0x000000a8, 0x000000a8 } },
+	{ 6, 0x989c,
+	    { 0x0000002e, 0x0000002e, 0x0000002e, 0x0000002e, 0x0000002e } },
+	{ 6, 0x989c,
+	    { 0x006c4a41, 0x006c4a41, 0x006c4af1, 0x006c4a61, 0x006c4a61 } },
+	{ 6, 0x989c,
+	    { 0x0050892a, 0x0050892a, 0x0050892b, 0x0050892b, 0x0050892b } },
+	{ 6, 0x989c,
+	    { 0x00842400, 0x00842400, 0x00842400, 0x00842400, 0x00842400 } },
+	{ 6, 0x989c,
+	    { 0x00c69200, 0x00c69200, 0x00c69200, 0x00c69200, 0x00c69200 } },
+	{ 6, 0x98d0,
+	    { 0x0002000c, 0x0002000c, 0x0002000c, 0x0002000c, 0x0002000c } },
+	{ 7, 0x989c,
+	    { 0x00000094, 0x00000094, 0x00000094, 0x00000094, 0x00000094 } },
+	{ 7, 0x989c,
+	    { 0x00000091, 0x00000091, 0x00000091, 0x00000091, 0x00000091 } },
+	{ 7, 0x989c,
+	    { 0x0000000a, 0x0000000a, 0x00000012, 0x00000012, 0x00000012 } },
+	{ 7, 0x989c,
+	    { 0x00000080, 0x00000080, 0x00000080, 0x00000080, 0x00000080 } },
+	{ 7, 0x989c,
+	    { 0x000000c1, 0x000000c1, 0x000000c1, 0x000000c1, 0x000000c1 } },
+	{ 7, 0x989c,
+	    { 0x00000060, 0x00000060, 0x00000060, 0x00000060, 0x00000060 } },
+	{ 7, 0x989c,
+	    { 0x000000f0, 0x000000f0, 0x000000f0, 0x000000f0, 0x000000f0 } },
+	{ 7, 0x989c,
+	    { 0x00000022, 0x00000022, 0x00000022, 0x00000022, 0x00000022 } },
+	{ 7, 0x989c,
+	    { 0x00000092, 0x00000092, 0x00000092, 0x00000092, 0x00000092 } },
+	{ 7, 0x989c,
+	    { 0x000000d4, 0x000000d4, 0x000000d4, 0x000000d4, 0x000000d4 } },
+	{ 7, 0x989c,
+	    { 0x000014cc, 0x000014cc, 0x000014cc, 0x000014cc, 0x000014cc } },
+	{ 7, 0x989c,
+	    { 0x0000048c, 0x0000048c, 0x0000048c, 0x0000048c, 0x0000048c } },
+	{ 7, 0x98c4,
+	    { 0x00000003, 0x00000003, 0x00000003, 0x00000003, 0x00000003 } },
+};
+
+/* RF5112A mode-specific init registers */
+static const struct ath5k_ini_rf rfregs_5112a[] = {
+	{ 1, 0x98d4,
+	/*    mode a/XR   mode aTurbo mode b      mode g      mode gTurbo */
+	    { 0x00000020, 0x00000020, 0x00000020, 0x00000020, 0x00000020 } },
+	{ 2, 0x98d0,
+	    { 0x03060408, 0x03070408, 0x03060408, 0x03060408, 0x03070408 } },
+	{ 3, 0x98dc,
+	    { 0x00a0c0c0, 0x00a0c0c0, 0x00e0c0c0, 0x00e0c0c0, 0x00e0c0c0 } },
+	{ 6, 0x989c,
+	    { 0x0f000000, 0x0f000000, 0x0f000000, 0x0f000000, 0x0f000000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00800000, 0x00800000, 0x00800000, 0x00800000, 0x00800000 } },
+	{ 6, 0x989c,
+	    { 0x002a0000, 0x002a0000, 0x002a0000, 0x002a0000, 0x002a0000 } },
+	{ 6, 0x989c,
+	    { 0x00010000, 0x00010000, 0x00010000, 0x00010000, 0x00010000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00180000, 0x00180000, 0x00180000, 0x00180000, 0x00180000 } },
+	{ 6, 0x989c,
+	    { 0x00600000, 0x00600000, 0x006e0000, 0x006e0000, 0x006e0000 } },
+	{ 6, 0x989c,
+	    { 0x00c70000, 0x00c70000, 0x00c70000, 0x00c70000, 0x00c70000 } },
+	{ 6, 0x989c,
+	    { 0x004b0000, 0x004b0000, 0x004b0000, 0x004b0000, 0x004b0000 } },
+	{ 6, 0x989c,
+	    { 0x04480000, 0x04480000, 0x04480000, 0x04480000, 0x04480000 } },
+	{ 6, 0x989c,
+	    { 0x00220000, 0x00220000, 0x00220000, 0x00220000, 0x00220000 } },
+	{ 6, 0x989c,
+	    { 0x00e40000, 0x00e40000, 0x00e40000, 0x00e40000, 0x00e40000 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x00fc0000, 0x00fc0000, 0x00fc0000, 0x00fc0000, 0x00fc0000 } },
+	{ 6, 0x989c,
+	    { 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000, 0x00ff0000 } },
+	{ 6, 0x989c,
+	    { 0x043f0000, 0x043f0000, 0x043f0000, 0x043f0000, 0x043f0000 } },
+	{ 6, 0x989c,
+	    { 0x000c0000, 0x000c0000, 0x000c0000, 0x000c0000, 0x000c0000 } },
+	{ 6, 0x989c,
+	    { 0x00190000, 0x00190000, 0x00190000, 0x00190000, 0x00190000 } },
+	{ 6, 0x989c,
+	    { 0x00240000, 0x00240000, 0x00240000, 0x00240000, 0x00240000 } },
+	{ 6, 0x989c,
+	    { 0x00b40000, 0x00b40000, 0x00b40000, 0x00b40000, 0x00b40000 } },
+	{ 6, 0x989c,
+	    { 0x00990000, 0x00990000, 0x00990000, 0x00990000, 0x00990000 } },
+	{ 6, 0x989c,
+	    { 0x00500000, 0x00500000, 0x00500000, 0x00500000, 0x00500000 } },
+	{ 6, 0x989c,
+	    { 0x002a0000, 0x002a0000, 0x002a0000, 0x002a0000, 0x002a0000 } },
+	{ 6, 0x989c,
+	    { 0x00120000, 0x00120000, 0x00120000, 0x00120000, 0x00120000 } },
+	{ 6, 0x989c,
+	    { 0xc0320000, 0xc0320000, 0xc0320000, 0xc0320000, 0xc0320000 } },
+	{ 6, 0x989c,
+	    { 0x01740000, 0x01740000, 0x01740000, 0x01740000, 0x01740000 } },
+	{ 6, 0x989c,
+	    { 0x00110000, 0x00110000, 0x00110000, 0x00110000, 0x00110000 } },
+	{ 6, 0x989c,
+	    { 0x86280000, 0x86280000, 0x86280000, 0x86280000, 0x86280000 } },
+	{ 6, 0x989c,
+	    { 0x31840000, 0x31840000, 0x31840000, 0x31840000, 0x31840000 } },
+	{ 6, 0x989c,
+	    { 0x00020080, 0x00020080, 0x00020080, 0x00020080, 0x00020080 } },
+	{ 6, 0x989c,
+	    { 0x00080009, 0x00080009, 0x00080009, 0x00080009, 0x00080009 } },
+	{ 6, 0x989c,
+	    { 0x00000003, 0x00000003, 0x00000003, 0x00000003, 0x00000003 } },
+	{ 6, 0x989c,
+	    { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	{ 6, 0x989c,
+	    { 0x000000b2, 0x000000b2, 0x000000b2, 0x000000b2, 0x000000b2 } },
+	{ 6, 0x989c,
+	    { 0x00b02084, 0x00b02084, 0x00b02084, 0x00b02084, 0x00b02084 } },
+	{ 6, 0x989c,
+	    { 0x004125a4, 0x004125a4, 0x004125a4, 0x004125a4, 0x004125a4 } },
+	{ 6, 0x989c,
+	    { 0x00119220, 0x00119220, 0x00119220, 0x00119220, 0x00119220 } },
+	{ 6, 0x989c,
+	    { 0x001a4800, 0x001a4800, 0x001a4800, 0x001a4800, 0x001a4800 } },
+	{ 6, 0x98d8,
+	    { 0x000b0230, 0x000b0230, 0x000b0230, 0x000b0230, 0x000b0230 } },
+	{ 7, 0x989c,
+	    { 0x00000094, 0x00000094, 0x00000094, 0x00000094, 0x00000094 } },
+	{ 7, 0x989c,
+	    { 0x00000091, 0x00000091, 0x00000091, 0x00000091, 0x00000091 } },
+	{ 7, 0x989c,
+	    { 0x00000012, 0x00000012, 0x00000012, 0x00000012, 0x00000012 } },
+	{ 7, 0x989c,
+	    { 0x00000080, 0x00000080, 0x00000080, 0x00000080, 0x00000080 } },
+	{ 7, 0x989c,
+	    { 0x000000d9, 0x000000d9, 0x000000d9, 0x000000d9, 0x000000d9 } },
+	{ 7, 0x989c,
+	    { 0x00000060, 0x00000060, 0x00000060, 0x00000060, 0x00000060 } },
+	{ 7, 0x989c,
+	    { 0x000000f0, 0x000000f0, 0x000000f0, 0x000000f0, 0x000000f0 } },
+	{ 7, 0x989c,
+	    { 0x000000a2, 0x000000a2, 0x000000a2, 0x000000a2, 0x000000a2 } },
+	{ 7, 0x989c,
+	    { 0x00000052, 0x00000052, 0x00000052, 0x00000052, 0x00000052 } },
+	{ 7, 0x989c,
+	    { 0x000000d4, 0x000000d4, 0x000000d4, 0x000000d4, 0x000000d4 } },
+	{ 7, 0x989c,
+	    { 0x000014cc, 0x000014cc, 0x000014cc, 0x000014cc, 0x000014cc } },
+	{ 7, 0x989c,
+	    { 0x0000048c, 0x0000048c, 0x0000048c, 0x0000048c, 0x0000048c } },
+	{ 7, 0x98c4,
+	    { 0x00000003, 0x00000003, 0x00000003, 0x00000003, 0x00000003 } },
+};
+
+
+/* Initial RF Gain settings for RF5112 */
+static const struct ath5k_ini_rfgain rfgain_5112[] = {
+	/*			      5Ghz	2Ghz	*/
+	{ AR5K_RF_GAIN(0),	{ 0x00000007, 0x00000007 } },
+	{ AR5K_RF_GAIN(1),	{ 0x00000047, 0x00000047 } },
+	{ AR5K_RF_GAIN(2),	{ 0x00000087, 0x00000087 } },
+	{ AR5K_RF_GAIN(3),	{ 0x000001a0, 0x000001a0 } },
+	{ AR5K_RF_GAIN(4),	{ 0x000001e0, 0x000001e0 } },
+	{ AR5K_RF_GAIN(5),	{ 0x00000020, 0x00000020 } },
+	{ AR5K_RF_GAIN(6),	{ 0x00000060, 0x00000060 } },
+	{ AR5K_RF_GAIN(7),	{ 0x000001a1, 0x000001a1 } },
+	{ AR5K_RF_GAIN(8),	{ 0x000001e1, 0x000001e1 } },
+	{ AR5K_RF_GAIN(9),	{ 0x00000021, 0x00000021 } },
+	{ AR5K_RF_GAIN(10),	{ 0x00000061, 0x00000061 } },
+	{ AR5K_RF_GAIN(11),	{ 0x00000162, 0x00000162 } },
+	{ AR5K_RF_GAIN(12),	{ 0x000001a2, 0x000001a2 } },
+	{ AR5K_RF_GAIN(13),	{ 0x000001e2, 0x000001e2 } },
+	{ AR5K_RF_GAIN(14),	{ 0x00000022, 0x00000022 } },
+	{ AR5K_RF_GAIN(15),	{ 0x00000062, 0x00000062 } },
+	{ AR5K_RF_GAIN(16),	{ 0x00000163, 0x00000163 } },
+	{ AR5K_RF_GAIN(17),	{ 0x000001a3, 0x000001a3 } },
+	{ AR5K_RF_GAIN(18),	{ 0x000001e3, 0x000001e3 } },
+	{ AR5K_RF_GAIN(19),	{ 0x00000023, 0x00000023 } },
+	{ AR5K_RF_GAIN(20),	{ 0x00000063, 0x00000063 } },
+	{ AR5K_RF_GAIN(21),	{ 0x00000184, 0x00000184 } },
+	{ AR5K_RF_GAIN(22),	{ 0x000001c4, 0x000001c4 } },
+	{ AR5K_RF_GAIN(23),	{ 0x00000004, 0x00000004 } },
+	{ AR5K_RF_GAIN(24),	{ 0x000001ea, 0x0000000b } },
+	{ AR5K_RF_GAIN(25),	{ 0x0000002a, 0x0000004b } },
+	{ AR5K_RF_GAIN(26),	{ 0x0000006a, 0x0000008b } },
+	{ AR5K_RF_GAIN(27),	{ 0x000000aa, 0x000001ac } },
+	{ AR5K_RF_GAIN(28),	{ 0x000001ab, 0x000001ec } },
+	{ AR5K_RF_GAIN(29),	{ 0x000001eb, 0x0000002c } },
+	{ AR5K_RF_GAIN(30),	{ 0x0000002b, 0x00000012 } },
+	{ AR5K_RF_GAIN(31),	{ 0x0000006b, 0x00000052 } },
+	{ AR5K_RF_GAIN(32),	{ 0x000000ab, 0x00000092 } },
+	{ AR5K_RF_GAIN(33),	{ 0x000001ac, 0x00000193 } },
+	{ AR5K_RF_GAIN(34),	{ 0x000001ec, 0x000001d3 } },
+	{ AR5K_RF_GAIN(35),	{ 0x0000002c, 0x00000013 } },
+	{ AR5K_RF_GAIN(36),	{ 0x0000003a, 0x00000053 } },
+	{ AR5K_RF_GAIN(37),	{ 0x0000007a, 0x00000093 } },
+	{ AR5K_RF_GAIN(38),	{ 0x000000ba, 0x00000194 } },
+	{ AR5K_RF_GAIN(39),	{ 0x000001bb, 0x000001d4 } },
+	{ AR5K_RF_GAIN(40),	{ 0x000001fb, 0x00000014 } },
+	{ AR5K_RF_GAIN(41),	{ 0x0000003b, 0x0000003a } },
+	{ AR5K_RF_GAIN(42),	{ 0x0000007b, 0x0000007a } },
+	{ AR5K_RF_GAIN(43),	{ 0x000000bb, 0x000000ba } },
+	{ AR5K_RF_GAIN(44),	{ 0x000001bc, 0x000001bb } },
+	{ AR5K_RF_GAIN(45),	{ 0x000001fc, 0x000001fb } },
+	{ AR5K_RF_GAIN(46),	{ 0x0000003c, 0x0000003b } },
+	{ AR5K_RF_GAIN(47),	{ 0x0000007c, 0x0000007b } },
+	{ AR5K_RF_GAIN(48),	{ 0x000000bc, 0x000000bb } },
+	{ AR5K_RF_GAIN(49),	{ 0x000000fc, 0x000001bc } },
+	{ AR5K_RF_GAIN(50),	{ 0x000000fc, 0x000001fc } },
+	{ AR5K_RF_GAIN(51),	{ 0x000000fc, 0x0000003c } },
+	{ AR5K_RF_GAIN(52),	{ 0x000000fc, 0x0000007c } },
+	{ AR5K_RF_GAIN(53),	{ 0x000000fc, 0x000000bc } },
+	{ AR5K_RF_GAIN(54),	{ 0x000000fc, 0x000000fc } },
+	{ AR5K_RF_GAIN(55),	{ 0x000000fc, 0x000000fc } },
+	{ AR5K_RF_GAIN(56),	{ 0x000000fc, 0x000000fc } },
+	{ AR5K_RF_GAIN(57),	{ 0x000000fc, 0x000000fc } },
+	{ AR5K_RF_GAIN(58),	{ 0x000000fc, 0x000000fc } },
+	{ AR5K_RF_GAIN(59),	{ 0x000000fc, 0x000000fc } },
+	{ AR5K_RF_GAIN(60),	{ 0x000000fc, 0x000000fc } },
+	{ AR5K_RF_GAIN(61),	{ 0x000000fc, 0x000000fc } },
+	{ AR5K_RF_GAIN(62),	{ 0x000000fc, 0x000000fc } },
+	{ AR5K_RF_GAIN(63),	{ 0x000000fc, 0x000000fc } },
+};
+
+static const struct ath5k_gain_opt rfgain_opt_5112 = {
+	1,
+	8,
+	{
+		{ { 3, 0, 0, 0, 0, 0, 0 }, 6 },
+		{ { 2, 0, 0, 0, 0, 0, 0 }, 0 },
+		{ { 1, 0, 0, 0, 0, 0, 0 }, -3 },
+		{ { 0, 0, 0, 0, 0, 0, 0 }, -6 },
+		{ { 0, 1, 1, 0, 0, 0, 0 }, -8 },
+		{ { 0, 1, 1, 0, 1, 1, 0 }, -10 },
+		{ { 0, 1, 0, 1, 1, 1, 0 }, -13 },
+		{ { 0, 1, 0, 1, 1, 0, 1 }, -16 },
+	}
+};
+
+/*
+ * Used to modify RF Banks before writing them to AR5K_RF_BUFFER
+ */
+static unsigned int ath5k_hw_rfregs_op(u32 *rf, u32 offset, u32 reg, u32 bits,
+		u32 first, u32 col, bool set)
+{
+	u32 mask, entry, last, data, shift, position;
+	s32 left;
+	int i;
+
+	data = 0;
+
+	if (rf == NULL)
+		/* should not happen */
+		return 0;
+
+	if (!(col <= 3 && bits <= 32 && first + bits <= 319)) {
+		AR5K_PRINTF("invalid values at offset %u\n", offset);
+		return 0;
+	}
+
+	entry = ((first - 1) / 8) + offset;
+	position = (first - 1) % 8;
+
+	if (set == true)
+		data = ath5k_hw_bitswap(reg, bits);
+
+	for (i = shift = 0, left = bits; left > 0; position = 0, entry++, i++) {
+		last = (position + left > 8) ? 8 : position + left;
+		mask = (((1 << last) - 1) ^ ((1 << position) - 1)) << (col * 8);
+
+		if (set == true) {
+			rf[entry] &= ~mask;
+			rf[entry] |= ((data << position) << (col * 8)) & mask;
+			data >>= (8 - position);
+		} else {
+			data = (((rf[entry] & mask) >> (col * 8)) >> position)
+				<< shift;
+			shift += last - position;
+		}
+
+		left -= 8 - position;
+	}
+
+	data = set == true ? 1 : ath5k_hw_bitswap(data, bits);
+
+	return data;
+}
+
+static u32 ath5k_hw_rfregs_gainf_corr(struct ath_hw *hal)
+{
+	u32 mix, step;
+	u32 *rf;
+
+	if (hal->ah_rf_banks == NULL)
+		return 0;
+
+	rf = hal->ah_rf_banks;
+	hal->ah_gain.g_f_corr = 0;
+
+	if (ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 1, 36, 0, false) != 1)
+		return 0;
+
+	step = ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 4, 32, 0, false);
+	mix = hal->ah_gain.g_step->gos_param[0];
+
+	switch (mix) {
+	case 3:
+		hal->ah_gain.g_f_corr = step * 2;
+		break;
+	case 2:
+		hal->ah_gain.g_f_corr = (step - 5) * 2;
+		break;
+	case 1:
+		hal->ah_gain.g_f_corr = step;
+		break;
+	default:
+		hal->ah_gain.g_f_corr = 0;
+		break;
+	}
+
+	return hal->ah_gain.g_f_corr;
+}
+
+static bool ath5k_hw_rfregs_gain_readback(struct ath_hw *hal)
+{
+	u32 step, mix, level[4];
+	u32 *rf;
+
+	if (hal->ah_rf_banks == NULL)
+		return false;
+
+	rf = hal->ah_rf_banks;
+
+	if (hal->ah_radio == AR5K_RF5111) {
+		step = ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 6, 37, 0,
+				false);
+		level[0] = 0;
+		level[1] = (step == 0x3f) ? 0x32 : step + 4;
+		level[2] = (step != 0x3f) ? 0x40 : level[0];
+		level[3] = level[2] + 0x32;
+
+		hal->ah_gain.g_high = level[3] -
+			(step == 0x3f ? AR5K_GAIN_DYN_ADJUST_HI_MARGIN : -5);
+		hal->ah_gain.g_low = level[0] +
+			(step == 0x3f ? AR5K_GAIN_DYN_ADJUST_LO_MARGIN : 0);
+	} else {
+		mix = ath5k_hw_rfregs_op(rf, hal->ah_offset[7], 0, 1, 36, 0,
+				false);
+		level[0] = level[2] = 0;
+
+		if (mix == 1) {
+			level[1] = level[3] = 83;
+		} else {
+			level[1] = level[3] = 107;
+			hal->ah_gain.g_high = 55;
+		}
+	}
+
+	return (hal->ah_gain.g_current >= level[0] &&
+			hal->ah_gain.g_current <= level[1]) ||
+		(hal->ah_gain.g_current >= level[2] &&
+			hal->ah_gain.g_current <= level[3]);
+}
+
+static s32 ath5k_hw_rfregs_gain_adjust(struct ath_hw *hal)
+{
+	const struct ath5k_gain_opt *go;
+	int ret = 0;
+
+	switch (hal->ah_radio) {
+	case AR5K_RF5111:
+		go = &rfgain_opt_5111;
+		break;
+	case AR5K_RF5112:
+		go = &rfgain_opt_5112;
+		break;
+	default:
+		return 0;
+	}
+
+	hal->ah_gain.g_step = &go->go_step[hal->ah_gain.g_step_idx];
+
+	if (hal->ah_gain.g_current >= hal->ah_gain.g_high) {
+		if (hal->ah_gain.g_step_idx == 0)
+			return -1;
+		for (hal->ah_gain.g_target = hal->ah_gain.g_current;
+				hal->ah_gain.g_target >=  hal->ah_gain.g_high &&
+				hal->ah_gain.g_step_idx > 0;
+				hal->ah_gain.g_step =
+					&go->go_step[hal->ah_gain.g_step_idx])
+			hal->ah_gain.g_target -= 2 *
+			    (go->go_step[--(hal->ah_gain.g_step_idx)].gos_gain -
+			    hal->ah_gain.g_step->gos_gain);
+
+		ret = 1;
+		goto done;
+	}
+
+	if (hal->ah_gain.g_current <= hal->ah_gain.g_low) {
+		if (hal->ah_gain.g_step_idx == (go->go_steps_count - 1))
+			return -2;
+		for (hal->ah_gain.g_target = hal->ah_gain.g_current;
+				hal->ah_gain.g_target <= hal->ah_gain.g_low &&
+				hal->ah_gain.g_step_idx < go->go_steps_count-1;
+				hal->ah_gain.g_step =
+					&go->go_step[hal->ah_gain.g_step_idx])
+			hal->ah_gain.g_target -= 2 *
+			    (go->go_step[++hal->ah_gain.g_step_idx].gos_gain -
+			    hal->ah_gain.g_step->gos_gain);
+
+		ret = 2;
+		goto done;
+	}
+
+done:
+#ifdef AR5K_DEBUG
+	AR5K_PRINTF("ret %d, gain step %u, current gain %u, target gain %u\n",
+		ret, hal->ah_gain.g_step_idx, hal->ah_gain.g_current,
+		hal->ah_gain.g_target);
+#endif
+
+	return ret;
+}
+
+/*
+ * Read EEPROM Calibration data, modify RF Banks and Initialize RF5111
+ */
+static int ath5k_hw_rf5111_rfregs(struct ath_hw *hal,
+		struct ieee80211_channel *channel, unsigned int mode)
+{
+	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	u32 *rf;
+	const unsigned int rf_size = ARRAY_SIZE(rfregs_5111);
+	unsigned int i;
+	int obdb = -1, bank = -1;
+	u32 ee_mode;
+
+	AR5K_ASSERT_ENTRY(mode, AR5K_INI_VAL_MAX);
+
+	rf = hal->ah_rf_banks;
+
+	/* Copy values to modify them */
+	for (i = 0; i < rf_size; i++) {
+		if (rfregs_5111[i].rf_bank >= AR5K_RF5111_INI_RF_MAX_BANKS) {
+			AR5K_PRINT("invalid bank\n");
+			return -EINVAL;
+		}
+
+		if (bank != rfregs_5111[i].rf_bank) {
+			bank = rfregs_5111[i].rf_bank;
+			hal->ah_offset[bank] = i;
+		}
+
+		rf[i] = rfregs_5111[i].rf_value[mode];
+	}
+
+	/* Modify bank 0 */
+	if (channel->val & CHANNEL_2GHZ) {
+		if (channel->val & CHANNEL_B)
+			ee_mode = AR5K_EEPROM_MODE_11B;
+		else
+			ee_mode = AR5K_EEPROM_MODE_11G;
+		obdb = 0;
+
+		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[0],
+				ee->ee_ob[ee_mode][obdb], 3, 119, 0, true))
+			return -EINVAL;
+
+		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[0],
+				ee->ee_ob[ee_mode][obdb], 3, 122, 0, true))
+			return -EINVAL;
+
+		obdb = 1;
+	/* Modify bank 6 */
+	} else {
+		/* For 11a, Turbo and XR */
+		ee_mode = AR5K_EEPROM_MODE_11A;
+		obdb =	 channel->freq >= 5725 ? 3 :
+			(channel->freq >= 5500 ? 2 :
+			(channel->freq >= 5260 ? 1 :
+			 (channel->freq > 4000 ? 0 : -1)));
+
+		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+				ee->ee_pwd_84, 1, 51, 3, true))
+			return -EINVAL;
+
+		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+				ee->ee_pwd_90, 1, 45, 3, true))
+			return -EINVAL;
+	}
+
+	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+			!ee->ee_xpd[ee_mode], 1, 95, 0, true))
+		return -EINVAL;
+
+	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+			ee->ee_x_gain[ee_mode], 4, 96, 0, true))
+		return -EINVAL;
+
+	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6], obdb >= 0 ?
+			ee->ee_ob[ee_mode][obdb] : 0, 3, 104, 0, true))
+		return -EINVAL;
+
+	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6], obdb >= 0 ?
+			ee->ee_db[ee_mode][obdb] : 0, 3, 107, 0, true))
+		return -EINVAL;
+
+	/* Modify bank 7 */
+	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[7],
+			ee->ee_i_gain[ee_mode], 6, 29, 0, true))
+		return -EINVAL;
+
+	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[7],
+			ee->ee_xpd[ee_mode], 1, 4, 0, true))
+		return -EINVAL;
+
+	/* Write RF values */
+	for (i = 0; i < rf_size; i++) {
+		AR5K_REG_WAIT(i);
+		ath5k_hw_reg_write(hal, rf[i], rfregs_5111[i].rf_register);
+	}
+
+	return 0;
+}
+
+/*
+ * Read EEPROM Calibration data, modify RF Banks and Initialize RF5112
+ */
+static int ath5k_hw_rf5112_rfregs(struct ath_hw *hal,
+		struct ieee80211_channel *channel, unsigned int mode)
+{
+	const struct ath5k_ini_rf *rf_ini;
+	struct ath5k_eeprom_info *ee = &hal->ah_capabilities.cap_eeprom;
+	u32 *rf;
+	unsigned int rf_size, i;
+	int obdb = -1, bank = -1;
+	u32 ee_mode;
+
+	AR5K_ASSERT_ENTRY(mode, AR5K_INI_VAL_MAX);
+
+	rf = hal->ah_rf_banks;
+
+	if (hal->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A) {
+		rf_ini = rfregs_5112a;
+		rf_size = ARRAY_SIZE(rfregs_5112a);
+	} else {
+		rf_ini = rfregs_5112;
+		rf_size = ARRAY_SIZE(rfregs_5112);
+	}
+
+	/* Copy values to modify them */
+	for (i = 0; i < rf_size; i++) {
+		if (rf_ini[i].rf_bank >= AR5K_RF5112_INI_RF_MAX_BANKS) {
+			AR5K_PRINT("invalid bank\n");
+			return -EINVAL;
+		}
+
+		if (bank != rf_ini[i].rf_bank) {
+			bank = rf_ini[i].rf_bank;
+			hal->ah_offset[bank] = i;
+		}
+
+		rf[i] = rf_ini[i].rf_value[mode];
+	}
+
+	/* Modify bank 6 */
+	if (channel->val & CHANNEL_2GHZ) {
+		if (channel->val & CHANNEL_B)
+			ee_mode = AR5K_EEPROM_MODE_11B;
+		else
+			ee_mode = AR5K_EEPROM_MODE_11G;
+		obdb = 0;
+
+		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+				ee->ee_ob[ee_mode][obdb], 3, 287, 0, true))
+			return -EINVAL;
+
+		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+				ee->ee_ob[ee_mode][obdb], 3, 290, 0, true))
+			return -EINVAL;
+	} else {
+		/* For 11a, Turbo and XR */
+		ee_mode = AR5K_EEPROM_MODE_11A;
+		obdb = channel->freq >= 5725 ? 3 :
+		    (channel->freq >= 5500 ? 2 :
+			(channel->freq >= 5260 ? 1 :
+			    (channel->freq > 4000 ? 0 : -1)));
+
+		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+				ee->ee_ob[ee_mode][obdb], 3, 279, 0, true))
+			return -EINVAL;
+
+		if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+				ee->ee_ob[ee_mode][obdb], 3, 282, 0, true))
+			return -EINVAL;
+	}
+
+#ifdef notyet
+	ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+	    ee->ee_x_gain[ee_mode], 2, 270, 0, true);
+	ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+	    ee->ee_x_gain[ee_mode], 2, 257, 0, true);
+#endif
+
+	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[6],
+			ee->ee_xpd[ee_mode], 1, 302, 0, true))
+		return -EINVAL;
+
+	/* Modify bank 7 */
+	if (!ath5k_hw_rfregs_op(rf, hal->ah_offset[7],
+			ee->ee_i_gain[ee_mode], 6, 14, 0, true))
+		return -EINVAL;
+
+	/* Write RF values */
+	for (i = 0; i < rf_size; i++)
+		ath5k_hw_reg_write(hal, rf[i], rf_ini[i].rf_register);
+
+	return 0;
+}
+
+/*
+ * Initialize RF
+ */
+int ath5k_hw_rfregs(struct ath_hw *hal, struct ieee80211_channel *channel,
+		unsigned int mode)
+{
+	int (*func)(struct ath_hw *, struct ieee80211_channel *, unsigned int);
+	int ret;
+
+	switch (hal->ah_radio) {
+	case AR5K_RF5111:
+		hal->ah_rf_banks_size = sizeof(rfregs_5111);
+		func = ath5k_hw_rf5111_rfregs;
+		break;
+	case AR5K_RF5112:
+		if (hal->ah_radio_5ghz_revision >= AR5K_SREV_RAD_5112A)
+			hal->ah_rf_banks_size = sizeof(rfregs_5112a);
+		else
+			hal->ah_rf_banks_size = sizeof(rfregs_5112);
+		func = ath5k_hw_rf5112_rfregs;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (hal->ah_rf_banks == NULL) {
+		/* XXX do extra checks? */
+		hal->ah_rf_banks = kmalloc(hal->ah_rf_banks_size, GFP_KERNEL);
+		if (hal->ah_rf_banks == NULL) {
+			AR5K_PRINT("out of memory\n");
+			return -ENOMEM;
+		}
+	}
+
+	ret = func(hal, channel, mode);
+	if (!ret)
+		hal->ah_rf_gain = AR5K_RFGAIN_INACTIVE;
+
+	return ret;
+}
+
+int ath5k_hw_rfgain(struct ath_hw *hal, unsigned int freq)
+{
+	const struct ath5k_ini_rfgain *ath5k_rfg;
+	unsigned int i, size;
+
+	switch (hal->ah_radio) {
+	case AR5K_RF5111:
+		ath5k_rfg = rfgain_5111;
+		size = ARRAY_SIZE(rfgain_5111);
+		break;
+	case AR5K_RF5112:
+		ath5k_rfg = rfgain_5112;
+		size = ARRAY_SIZE(rfgain_5112);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (freq) {
+	case AR5K_INI_RFGAIN_2GHZ:
+	case AR5K_INI_RFGAIN_5GHZ:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	for (i = 0; i < size; i++) {
+		AR5K_REG_WAIT(i);
+		ath5k_hw_reg_write(hal, ath5k_rfg[i].rfg_value[freq],
+			(u32)ath5k_rfg[i].rfg_register);
+	}
+
+	return 0;
+}
+
+enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath_hw *hal)
+{
+	u32 data, type;
+
+	AR5K_TRACE;
+
+	if (hal->ah_rf_banks == NULL || !hal->ah_gain.g_active ||
+			hal->ah_version <= AR5K_AR5211)
+		return AR5K_RFGAIN_INACTIVE;
+
+	if (hal->ah_rf_gain != AR5K_RFGAIN_READ_REQUESTED)
+		goto done;
+
+	data = ath5k_hw_reg_read(hal, AR5K_PHY_PAPD_PROBE);
+
+	if (!(data & AR5K_PHY_PAPD_PROBE_TX_NEXT)) {
+		hal->ah_gain.g_current = data >> AR5K_PHY_PAPD_PROBE_GAINF_S;
+		type = AR5K_REG_MS(data, AR5K_PHY_PAPD_PROBE_TYPE);
+
+		if (type == AR5K_PHY_PAPD_PROBE_TYPE_CCK)
+			hal->ah_gain.g_current += AR5K_GAIN_CCK_PROBE_CORR;
+
+		if (hal->ah_radio == AR5K_RF5112) {
+			ath5k_hw_rfregs_gainf_corr(hal);
+			hal->ah_gain.g_current =
+				hal->ah_gain.g_current>=hal->ah_gain.g_f_corr ?
+				(hal->ah_gain.g_current-hal->ah_gain.g_f_corr) :
+				0;
+		}
+
+		if (ath5k_hw_rfregs_gain_readback(hal) &&
+				AR5K_GAIN_CHECK_ADJUST(&hal->ah_gain) &&
+				ath5k_hw_rfregs_gain_adjust(hal))
+			hal->ah_rf_gain = AR5K_RFGAIN_NEED_CHANGE;
+	}
+
+done:
+	return hal->ah_rf_gain;
+}
+
+int ath5k_hw_set_rfgain_opt(struct ath_hw *hal)
+{
+	/* Initialize the gain optimization values */
+	switch (hal->ah_radio) {
+	case AR5K_RF5111:
+		hal->ah_gain.g_step_idx = rfgain_opt_5111.go_default;
+		hal->ah_gain.g_step =
+		    &rfgain_opt_5111.go_step[hal->ah_gain.g_step_idx];
+		hal->ah_gain.g_low = 20;
+		hal->ah_gain.g_high = 35;
+		hal->ah_gain.g_active = 1;
+		break;
+	case AR5K_RF5112:
+		hal->ah_gain.g_step_idx = rfgain_opt_5112.go_default;
+		hal->ah_gain.g_step =
+		    &rfgain_opt_5112.go_step[hal->ah_gain.g_step_idx];
+		hal->ah_gain.g_low = 20;
+		hal->ah_gain.g_high = 85;
+		hal->ah_gain.g_active = 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**************************\
+  PHY/RF channel functions
+\**************************/
+
+/*
+ * Check if a channel is supported
+ */
+bool ath5k_channel_ok(struct ath_hw *hal, u16 freq, unsigned int flags)
+{
+	/* Check if the channel is in our supported range */
+	if (flags & CHANNEL_2GHZ) {
+		if ((freq >= hal->ah_capabilities.cap_range.range_2ghz_min) &&
+		    (freq <= hal->ah_capabilities.cap_range.range_2ghz_max))
+			return true;
+	} else if (flags & CHANNEL_5GHZ)
+		if ((freq >= hal->ah_capabilities.cap_range.range_5ghz_min) &&
+		    (freq <= hal->ah_capabilities.cap_range.range_5ghz_max))
+			return true;
+
+	return false;
+}
+
+/*
+ * Convertion needed for RF5110
+ */
+static u32 ath5k_hw_rf5110_chan2athchan(struct ieee80211_channel *channel)
+{
+	u32 athchan;
+
+	/*
+	 * Convert IEEE channel/MHz to an internal channel value used
+	 * by the AR5210 chipset. This has not been verified with
+	 * newer chipsets like the AR5212A who have a completely
+	 * different RF/PHY part.
+	 */
+	athchan = (ath5k_hw_bitswap((channel->chan - 24) / 2, 5) << 1) |
+		(1 << 6) | 0x1;
+
+	return athchan;
+}
+
+/*
+ * Set channel on RF5110
+ */
+static int ath5k_hw_rf5110_channel(struct ath_hw *hal,
+		struct ieee80211_channel *channel)
+{
+	u32 data;
+
+	/*
+	 * Set the channel and wait
+	 */
+	data = ath5k_hw_rf5110_chan2athchan(channel);
+	ath5k_hw_reg_write(hal, data, AR5K_RF_BUFFER);
+	ath5k_hw_reg_write(hal, 0, AR5K_RF_BUFFER_CONTROL_0);
+	mdelay(1);
+
+	return 0;
+}
+
+/*
+ * Convertion needed for 5111
+ */
+static int ath5k_hw_rf5111_chan2athchan(unsigned int ieee,
+		struct ath5k_athchan_2ghz *athchan)
+{
+	int channel;
+
+	/* Cast this value to catch negative channel numbers (>= -19) */
+	channel = (int)ieee;
+
+	/*
+	 * Map 2GHz IEEE channel to 5GHz Atheros channel
+	 */
+	if (channel <= 13) {
+		athchan->a2_athchan = 115 + channel;
+		athchan->a2_flags = 0x46;
+	} else if (channel == 14) {
+		athchan->a2_athchan = 124;
+		athchan->a2_flags = 0x44;
+	} else if (channel >= 15 && channel <= 26) {
+		athchan->a2_athchan = ((channel - 14) * 4) + 132;
+		athchan->a2_flags = 0x46;
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Set channel on 5111
+ */
+static int ath5k_hw_rf5111_channel(struct ath_hw *hal,
+		struct ieee80211_channel *channel)
+{
+	struct ath5k_athchan_2ghz ath_channel_2ghz;
+	unsigned int ath_channel = channel->chan;
+	u32 data0, data1, clock;
+	int ret;
+
+	/*
+	 * Set the channel on the RF5111 radio
+	 */
+	data0 = data1 = 0;
+
+	if (channel->val & CHANNEL_2GHZ) {
+		/* Map 2GHz channel to 5GHz Atheros channel ID */
+		ret = ath5k_hw_rf5111_chan2athchan(channel->chan,
+				&ath_channel_2ghz);
+		if (ret)
+			return ret;
+
+		ath_channel = ath_channel_2ghz.a2_athchan;
+		data0 = ((ath5k_hw_bitswap(ath_channel_2ghz.a2_flags, 8) & 0xff)
+		    << 5) | (1 << 4);
+	}
+
+	if (ath_channel < 145 || !(ath_channel & 1)) {
+		clock = 1;
+		data1 = ((ath5k_hw_bitswap(ath_channel - 24, 8) & 0xff) << 2) |
+			(clock << 1) | (1 << 10) | 1;
+	} else {
+		clock = 0;
+		data1 = ((ath5k_hw_bitswap((ath_channel - 24) / 2, 8) & 0xff)
+			<< 2) | (clock << 1) | (1 << 10) | 1;
+	}
+
+	ath5k_hw_reg_write(hal, (data1 & 0xff) | ((data0 & 0xff) << 8),
+			AR5K_RF_BUFFER);
+	ath5k_hw_reg_write(hal, ((data1 >> 8) & 0xff) | (data0 & 0xff00),
+			AR5K_RF_BUFFER_CONTROL_3);
+
+	return 0;
+}
+
+/*
+ * Set channel on 5112
+ */
+static int ath5k_hw_rf5112_channel(struct ath_hw *hal,
+		struct ieee80211_channel *channel)
+{
+	u32 data, data0, data1, data2;
+	u16 c;
+
+	data = data0 = data1 = data2 = 0;
+	c = channel->freq;
+
+	/*
+	 * Set the channel on the RF5112 or newer
+	 */
+	if (c < 4800) {
+		if (!((c - 2224) % 5)) {
+			data0 = ((2 * (c - 704)) - 3040) / 10;
+			data1 = 1;
+		} else if (!((c - 2192) % 5)) {
+			data0 = ((2 * (c - 672)) - 3040) / 10;
+			data1 = 0;
+		} else
+			return -EINVAL;
+
+		data0 = ath5k_hw_bitswap((data0 << 2) & 0xff, 8);
+	} else {
+		if (!(c % 20) && c >= 5120) {
+			data0 = ath5k_hw_bitswap(((c - 4800) / 20 << 2), 8);
+			data2 = ath5k_hw_bitswap(3, 2);
+		} else if (!(c % 10)) {
+			data0 = ath5k_hw_bitswap(((c - 4800) / 10 << 1), 8);
+			data2 = ath5k_hw_bitswap(2, 2);
+		} else if (!(c % 5)) {
+			data0 = ath5k_hw_bitswap((c - 4800) / 5, 8);
+			data2 = ath5k_hw_bitswap(1, 2);
+		} else
+			return -EINVAL;
+	}
+
+	data = (data0 << 4) | (data1 << 1) | (data2 << 2) | 0x1001;
+
+	ath5k_hw_reg_write(hal, data & 0xff, AR5K_RF_BUFFER);
+	ath5k_hw_reg_write(hal, (data >> 8) & 0x7f, AR5K_RF_BUFFER_CONTROL_5);
+
+	return 0;
+}
+
+/*
+ * Set a channel on the radio chip
+ */
+int ath5k_hw_channel(struct ath_hw *hal, struct ieee80211_channel *channel)
+{
+	int ret;
+
+	/*
+	 * Check bounds supported by the PHY
+	 * (don't care about regulation restrictions at this point)
+	 */
+	if ((channel->freq < hal->ah_capabilities.cap_range.range_2ghz_min ||
+	    channel->freq > hal->ah_capabilities.cap_range.range_2ghz_max) &&
+	    (channel->freq < hal->ah_capabilities.cap_range.range_5ghz_min ||
+	    channel->freq > hal->ah_capabilities.cap_range.range_5ghz_max)) {
+		AR5K_PRINTF("channel out of supported range (%u MHz)\n",
+			channel->freq);
+		return -EINVAL;
+	}
+
+	/*
+	 * Set the channel and wait
+	 */
+	switch (hal->ah_radio) {
+	case AR5K_RF5110:
+		ret = ath5k_hw_rf5110_channel(hal, channel);
+		break;
+	case AR5K_RF5111:
+		ret = ath5k_hw_rf5111_channel(hal, channel);
+		break;
+	default:
+		ret = ath5k_hw_rf5112_channel(hal, channel);
+		break;
+	}
+
+	if (ret)
+		return ret;
+
+	hal->ah_current_channel.freq = channel->freq;
+	hal->ah_current_channel.val = channel->val;
+	hal->ah_turbo = channel->val == CHANNEL_T ? true : false;
+
+	return 0;
+}
+
+/*****************\
+  PHY calibration
+\*****************/
+
+/*
+ * Perform a PHY calibration on RF5110
+ * -Fix BPSK/QAM Constellation (I/Q correction)
+ * -Calculate Noise Floor
+ */
+static int ath5k_hw_rf5110_calibrate(struct ath_hw *hal,
+		struct ieee80211_channel *channel)
+{
+	u32 phy_sig, phy_agc, phy_sat, beacon, noise_floor;
+	unsigned int i;
+	int ret;
+
+	/*
+	 * Disable beacons and RX/TX queues, wait
+	 */
+	AR5K_REG_ENABLE_BITS(hal, AR5K_DIAG_SW_5210,
+		AR5K_DIAG_SW_DIS_TX | AR5K_DIAG_SW_DIS_RX_5210);
+	beacon = ath5k_hw_reg_read(hal, AR5K_BEACON_5210);
+	ath5k_hw_reg_write(hal, beacon & ~AR5K_BEACON_ENABLE, AR5K_BEACON_5210);
+
+	udelay(2300);
+
+	/*
+	 * Set the channel (with AGC turned off)
+	 */
+	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
+	udelay(10);
+	ret = ath5k_hw_channel(hal, channel);
+
+	/*
+	 * Activate PHY and wait
+	 */
+	ath5k_hw_reg_write(hal, AR5K_PHY_ACT_ENABLE, AR5K_PHY_ACT);
+	mdelay(1);
+
+	AR5K_REG_DISABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
+
+	if (ret)
+		return ret;
+
+	/*
+	 * Calibrate the radio chip
+	 */
+
+	/* Remember normal state */
+	phy_sig = ath5k_hw_reg_read(hal, AR5K_PHY_SIG);
+	phy_agc = ath5k_hw_reg_read(hal, AR5K_PHY_AGCCOARSE);
+	phy_sat = ath5k_hw_reg_read(hal, AR5K_PHY_ADCSAT);
+
+	/* Update radio registers */
+	ath5k_hw_reg_write(hal, (phy_sig & ~(AR5K_PHY_SIG_FIRPWR)) |
+		AR5K_REG_SM(-1, AR5K_PHY_SIG_FIRPWR), AR5K_PHY_SIG);
+
+	ath5k_hw_reg_write(hal, (phy_agc & ~(AR5K_PHY_AGCCOARSE_HI |
+			AR5K_PHY_AGCCOARSE_LO)) |
+		AR5K_REG_SM(-1, AR5K_PHY_AGCCOARSE_HI) |
+		AR5K_REG_SM(-127, AR5K_PHY_AGCCOARSE_LO), AR5K_PHY_AGCCOARSE);
+
+	ath5k_hw_reg_write(hal, (phy_sat & ~(AR5K_PHY_ADCSAT_ICNT |
+			AR5K_PHY_ADCSAT_THR)) |
+		AR5K_REG_SM(2, AR5K_PHY_ADCSAT_ICNT) |
+		AR5K_REG_SM(12, AR5K_PHY_ADCSAT_THR), AR5K_PHY_ADCSAT);
+
+	udelay(20);
+
+	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
+	udelay(10);
+	ath5k_hw_reg_write(hal, AR5K_PHY_RFSTG_DISABLE, AR5K_PHY_RFSTG);
+	AR5K_REG_DISABLE_BITS(hal, AR5K_PHY_AGC, AR5K_PHY_AGC_DISABLE);
+
+	mdelay(1);
+
+	/*
+	 * Enable calibration and wait until completion
+	 */
+	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_CAL);
+
+	ret = ath5k_hw_register_timeout(hal, AR5K_PHY_AGCCTL,
+			AR5K_PHY_AGCCTL_CAL, 0, false);
+
+	/* Reset to normal state */
+	ath5k_hw_reg_write(hal, phy_sig, AR5K_PHY_SIG);
+	ath5k_hw_reg_write(hal, phy_agc, AR5K_PHY_AGCCOARSE);
+	ath5k_hw_reg_write(hal, phy_sat, AR5K_PHY_ADCSAT);
+
+	if (ret) {
+		AR5K_PRINTF("calibration timeout (%uMHz)\n", channel->freq);
+		return ret;
+	}
+
+	/*
+	 * Enable noise floor calibration and wait until completion
+	 */
+	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
+
+	ret = ath5k_hw_register_timeout(hal, AR5K_PHY_AGCCTL,
+			AR5K_PHY_AGCCTL_NF, 0, false);
+	if (ret) {
+		AR5K_PRINTF("noise floor calibration timeout (%uMHz)\n",
+				channel->freq);
+		return ret;
+	}
+
+	/* Wait until the noise floor is calibrated */
+	for (i = 20; i > 0; i--) {
+		mdelay(1);
+		noise_floor = ath5k_hw_reg_read(hal, AR5K_PHY_NF);
+
+		if (AR5K_PHY_NF_RVAL(noise_floor) & AR5K_PHY_NF_ACTIVE)
+			noise_floor = AR5K_PHY_NF_AVAL(noise_floor);
+
+		if (noise_floor <= AR5K_TUNE_NOISE_FLOOR)
+			break;
+	}
+
+	if (noise_floor > AR5K_TUNE_NOISE_FLOOR) {
+		AR5K_PRINTF("noise floor calibration failed (%uMHz)\n",
+			channel->freq);
+		return -EIO;
+	}
+
+	/*
+	 * Re-enable RX/TX and beacons
+	 */
+	AR5K_REG_DISABLE_BITS(hal, AR5K_DIAG_SW_5210,
+		AR5K_DIAG_SW_DIS_TX | AR5K_DIAG_SW_DIS_RX_5210);
+	ath5k_hw_reg_write(hal, beacon, AR5K_BEACON_5210);
+
+	return 0;
+}
+
+/*
+ * Perform a PHY calibration on RF5111/5112
+ */
+static int ath5k_hw_rf511x_calibrate(struct ath_hw *hal,
+		struct ieee80211_channel *channel)
+{
+	u32 i_pwr, q_pwr;
+	s32 iq_corr, i_coff, i_coffd, q_coff, q_coffd;
+	AR5K_TRACE;
+
+	if (hal->ah_calibration == false ||
+			ath5k_hw_reg_read(hal, AR5K_PHY_IQ) & AR5K_PHY_IQ_RUN)
+		goto done;
+
+	hal->ah_calibration = false;
+
+	iq_corr = ath5k_hw_reg_read(hal, AR5K_PHY_IQRES_CAL_CORR);
+	i_pwr = ath5k_hw_reg_read(hal, AR5K_PHY_IQRES_CAL_PWR_I);
+	q_pwr = ath5k_hw_reg_read(hal, AR5K_PHY_IQRES_CAL_PWR_Q);
+	i_coffd = ((i_pwr >> 1) + (q_pwr >> 1)) >> 7;
+	q_coffd = q_pwr >> 6;
+
+	if (i_coffd == 0 || q_coffd == 0)
+		goto done;
+
+	i_coff = ((-iq_corr) / i_coffd) & 0x3f;
+	q_coff = (((s32)i_pwr / q_coffd) - 64) & 0x1f;
+
+	/* Commit new IQ value */
+	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_IQ, AR5K_PHY_IQ_CORR_ENABLE |
+		((u32)q_coff) | ((u32)i_coff << AR5K_PHY_IQ_CORR_Q_I_COFF_S));
+
+done:
+	/* Start noise floor calibration */
+	AR5K_REG_ENABLE_BITS(hal, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
+
+	/* Request RF gain */
+	if (channel->val & CHANNEL_5GHZ) {
+		ath5k_hw_reg_write(hal, AR5K_REG_SM(hal->ah_txpower.txp_max,
+			AR5K_PHY_PAPD_PROBE_TXPOWER) |
+			AR5K_PHY_PAPD_PROBE_TX_NEXT, AR5K_PHY_PAPD_PROBE);
+		hal->ah_rf_gain = AR5K_RFGAIN_READ_REQUESTED;
+	}
+
+	return 0;
+}
+
+/*
+ * Perform a PHY calibration
+ */
+int ath5k_hw_phy_calibrate(struct ath_hw *hal,
+		struct ieee80211_channel *channel)
+{
+	int ret;
+
+	if (hal->ah_radio == AR5K_RF5110)
+		ret = ath5k_hw_rf5110_calibrate(hal, channel);
+	else
+		ret = ath5k_hw_rf511x_calibrate(hal, channel);
+
+	return ret;
+}
+
+int ath5k_hw_phy_disable(struct ath_hw *hal)
+{
+	AR5K_TRACE;
+	/*Just a try M.F.*/
+	ath5k_hw_reg_write(hal, AR5K_PHY_ACT_DISABLE, AR5K_PHY_ACT);
+
+	return 0;
+}
+
+/********************\
+  Misc PHY functions
+\********************/
+
+/*
+ * Get the PHY Chip revision
+ */
+u16 ath5k_hw_radio_revision(struct ath_hw *hal, unsigned int chan)
+{
+	unsigned int i;
+	u32 srev;
+	u16 ret;
+
+	AR5K_TRACE;
+
+	/*
+	 * Set the radio chip access register
+	 */
+	switch (chan) {
+	case CHANNEL_2GHZ:
+		ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_2GHZ, AR5K_PHY(0));
+		break;
+	case CHANNEL_5GHZ:
+		ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
+		break;
+	default:
+		return 0;
+	}
+
+	mdelay(2);
+
+	/* ...wait until PHY is ready and read the selected radio revision */
+	ath5k_hw_reg_write(hal, 0x00001c16, AR5K_PHY(0x34));
+
+	for (i = 0; i < 8; i++)
+		ath5k_hw_reg_write(hal, 0x00010000, AR5K_PHY(0x20));
+
+	if (hal->ah_version == AR5K_AR5210) {
+		srev = ath5k_hw_reg_read(hal, AR5K_PHY(256) >> 28) & 0xf;
+		ret = (u16)ath5k_hw_bitswap(srev, 4) + 1;
+	} else {
+		srev = (ath5k_hw_reg_read(hal, AR5K_PHY(0x100)) >> 24) & 0xff;
+		ret = (u16)ath5k_hw_bitswap(((srev & 0xf0) >> 4) |
+				((srev & 0x0f) << 4), 8);
+	}
+
+	/* Reset to the 5GHz mode */
+	ath5k_hw_reg_write(hal, AR5K_PHY_SHIFT_5GHZ, AR5K_PHY(0));
+
+	return ret;
+}
+
+void /*TODO:Boundary check*/
+ath5k_hw_set_def_antenna(struct ath_hw *hal, unsigned int ant)
+{
+	AR5K_TRACE;
+	/*Just a try M.F.*/
+	if (hal->ah_version != AR5K_AR5210)
+		ath5k_hw_reg_write(hal, ant, AR5K_DEFAULT_ANTENNA);
+}
+
+unsigned int ath5k_hw_get_def_antenna(struct ath_hw *hal)
+{
+	AR5K_TRACE;
+	/*Just a try M.F.*/
+	if (hal->ah_version != AR5K_AR5210)
+		return ath5k_hw_reg_read(hal, AR5K_DEFAULT_ANTENNA);
+
+	return false; /*XXX: What do we return for 5210 ?*/
+}
+
+/*
+ * TX power setup
+ */
+
+/*
+ * Initialize the tx power table (not fully implemented)
+ */
+static void ath5k_txpower_table(struct ath_hw *hal,
+		struct ieee80211_channel *channel, s16 max_power)
+{
+	unsigned int i, min, max, n;
+	u16 txpower, *rates;
+
+	rates = hal->ah_txpower.txp_rates;
+
+	txpower = AR5K_TUNE_DEFAULT_TXPOWER * 2;
+	if (max_power > txpower)
+		txpower = max_power > AR5K_TUNE_MAX_TXPOWER ?
+		    AR5K_TUNE_MAX_TXPOWER : max_power;
+
+	for (i = 0; i < AR5K_MAX_RATES; i++)
+		rates[i] = txpower;
+
+	/* XXX setup target powers by rate */
+
+	hal->ah_txpower.txp_min = rates[7];
+	hal->ah_txpower.txp_max = rates[0];
+	hal->ah_txpower.txp_ofdm = rates[0];
+
+	/* Calculate the power table */
+	n = ARRAY_SIZE(hal->ah_txpower.txp_pcdac);
+	min = AR5K_EEPROM_PCDAC_START;
+	max = AR5K_EEPROM_PCDAC_STOP;
+	for (i = 0; i < n; i += AR5K_EEPROM_PCDAC_STEP)
+		hal->ah_txpower.txp_pcdac[i] =
+#ifdef notyet
+		min + ((i * (max - min)) / n);
+#else
+		min;
+#endif
+}
+
+/*
+ * Set transmition power
+ */
+int /*O.K. - txpower_table is unimplemented so this doesn't work*/
+ath5k_hw_txpower(struct ath_hw *hal, struct ieee80211_channel *channel,
+		unsigned int txpower)
+{
+	bool tpc = hal->ah_txpower.txp_tpc;
+	unsigned int i;
+
+	AR5K_TRACE;
+	if (txpower > AR5K_TUNE_MAX_TXPOWER) {
+		AR5K_PRINTF("invalid tx power: %u\n", txpower);
+		return -EINVAL;
+	}
+
+	/* Reset TX power values */
+	memset(&hal->ah_txpower, 0, sizeof(hal->ah_txpower));
+	hal->ah_txpower.txp_tpc = tpc;
+
+	/* Initialize TX power table */
+	ath5k_txpower_table(hal, channel, txpower);
+
+	/*
+	 * Write TX power values
+	 */
+	for (i = 0; i < (AR5K_EEPROM_POWER_TABLE_SIZE / 2); i++) {
+		ath5k_hw_reg_write(hal,
+			((((hal->ah_txpower.txp_pcdac[(i << 1) + 1] << 8) | 0xff) & 0xffff) << 16) |
+			(((hal->ah_txpower.txp_pcdac[(i << 1)    ] << 8) | 0xff) & 0xffff),
+			AR5K_PHY_PCDAC_TXPOWER(i));
+	}
+
+	ath5k_hw_reg_write(hal, AR5K_TXPOWER_OFDM(3, 24) |
+		AR5K_TXPOWER_OFDM(2, 16) | AR5K_TXPOWER_OFDM(1, 8) |
+		AR5K_TXPOWER_OFDM(0, 0), AR5K_PHY_TXPOWER_RATE1);
+
+	ath5k_hw_reg_write(hal, AR5K_TXPOWER_OFDM(7, 24) |
+		AR5K_TXPOWER_OFDM(6, 16) | AR5K_TXPOWER_OFDM(5, 8) |
+		AR5K_TXPOWER_OFDM(4, 0), AR5K_PHY_TXPOWER_RATE2);
+
+	ath5k_hw_reg_write(hal, AR5K_TXPOWER_CCK(10, 24) |
+		AR5K_TXPOWER_CCK(9, 16) | AR5K_TXPOWER_CCK(15, 8) |
+		AR5K_TXPOWER_CCK(8, 0), AR5K_PHY_TXPOWER_RATE3);
+
+	ath5k_hw_reg_write(hal, AR5K_TXPOWER_CCK(14, 24) |
+		AR5K_TXPOWER_CCK(13, 16) | AR5K_TXPOWER_CCK(12, 8) |
+		AR5K_TXPOWER_CCK(11, 0), AR5K_PHY_TXPOWER_RATE4);
+
+	if (hal->ah_txpower.txp_tpc == true)
+		ath5k_hw_reg_write(hal, AR5K_PHY_TXPOWER_RATE_MAX_TPC_ENABLE |
+			AR5K_TUNE_MAX_TXPOWER, AR5K_PHY_TXPOWER_RATE_MAX);
+	else
+		ath5k_hw_reg_write(hal, AR5K_PHY_TXPOWER_RATE_MAX |
+			AR5K_TUNE_MAX_TXPOWER, AR5K_PHY_TXPOWER_RATE_MAX);
+
+	return 0;
+}
+
+int ath5k_hw_set_txpower_limit(struct ath_hw *hal, unsigned int power)
+{
+	/*Just a try M.F.*/
+	struct ieee80211_channel *channel = &hal->ah_current_channel;
+
+	AR5K_TRACE;
+#ifdef AR5K_DEBUG
+	AR5K_PRINTF("changing txpower to %d\n", power);
+#endif
+	return ath5k_hw_txpower(hal, channel, power);
+}
