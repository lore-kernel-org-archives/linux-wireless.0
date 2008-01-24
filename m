Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbYAXSrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 13:47:43 -0500
Message-Id: <20080124184357.839387000@sipsolutions.net> (sfid-20080124_184806_980945_594E7453)
References: <20080124183837.577631000@sipsolutions.net>
Date: Thu, 24 Jan 2008 19:38:38 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] cfg80211 API for channels/bitrates, mac80211 and
	driver conversion
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch creates new cfg80211 wiphy API for channel and bitrate
registration and converts mac80211 and drivers to the new API. The
old mac80211 API is completely ripped out. All drivers (except ath5k)
are updated to the new API, in many cases I expect that optimisations
can be done.

Along with the regulatory code I've also ripped out the
IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED flag, I believe it to be
unnecessary if the hardware simply gives us whatever channels it wants
to support and we then enable/disable them as required, which is pretty
much required for travelling.

Additionally, the patch adds proper "basic" rate handling for STA
mode interface, AP mode interface will have to have new API added
to allow userspace to set the basic rate set, currently it'll be
empty... However, the basic rate handling will need to be moved to
the BSS conf stuff.

I do expect there to be bugs in this, especially wrt. transmit
power handling where I'm basically clueless about how it should work.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Changes:
v1..v3:	<untracked>
v4:	fix bugs in iwl4965
v5:	rebase on top of new Intel patches
v6:	rebase on top of new Intel patches (again)

 drivers/net/wireless/adm8211.c               |   80 ++--
 drivers/net/wireless/adm8211.h               |   65 ---
 drivers/net/wireless/b43/b43.h               |    5 
 drivers/net/wireless/b43/main.c              |  119 +++----
 drivers/net/wireless/b43/sysfs.c             |   89 -----
 drivers/net/wireless/b43/xmit.c              |   81 ++--
 drivers/net/wireless/b43legacy/b43legacy.h   |    4 
 drivers/net/wireless/b43legacy/main.c        |  161 ++++-----
 drivers/net/wireless/b43legacy/xmit.c        |   64 +--
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c   |   80 ++--
 drivers/net/wireless/iwlwifi/iwl-3945.c      |   35 --
 drivers/net/wireless/iwlwifi/iwl-3945.h      |   13 
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c   |   82 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c      |   43 +-
 drivers/net/wireless/iwlwifi/iwl-4965.h      |   16 
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |  445 +++++++--------------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c  |  438 ++++++--------------------
 drivers/net/wireless/p54.h                   |    4 
 drivers/net/wireless/p54common.c             |   74 ++--
 drivers/net/wireless/p54common.h             |   75 ----
 drivers/net/wireless/rt2x00/rt2x00.h         |   11 
 drivers/net/wireless/rt2x00/rt2x00config.c   |   33 --
 drivers/net/wireless/rt2x00/rt2x00dev.c      |  151 +++------
 drivers/net/wireless/rt2x00/rt61pci.c        |   23 -
 drivers/net/wireless/rt2x00/rt73usb.c        |   23 -
 drivers/net/wireless/rtl8180.h               |    2 
 drivers/net/wireless/rtl8180_dev.c           |   93 +++--
 drivers/net/wireless/rtl8180_grf5101.c       |    5 
 drivers/net/wireless/rtl8180_max2820.c       |    5 
 drivers/net/wireless/rtl8180_rtl8225.c       |   15 
 drivers/net/wireless/rtl8180_sa2400.c        |    5 
 drivers/net/wireless/rtl8187.h               |    2 
 drivers/net/wireless/rtl8187_dev.c           |   82 +++-
 drivers/net/wireless/rtl8187_rtl8225.c       |   15 
 drivers/net/wireless/rtl818x.h               |   70 ----
 drivers/net/wireless/zd1211rw/zd_chip.c      |   15 
 drivers/net/wireless/zd1211rw/zd_ieee80211.c |   11 
 drivers/net/wireless/zd1211rw/zd_mac.c       |  168 ++++------
 drivers/net/wireless/zd1211rw/zd_mac.h       |    2 
 include/net/mac80211.h                       |  197 ++---------
 include/net/wireless.h                       |  168 ++++++++++
 net/mac80211/Makefile                        |    1 
 net/mac80211/cfg.c                           |   11 
 net/mac80211/debugfs.c                       |   47 --
 net/mac80211/debugfs_sta.c                   |   18 -
 net/mac80211/ieee80211.c                     |  112 ++----
 net/mac80211/ieee80211_i.h                   |   63 ---
 net/mac80211/ieee80211_iface.c               |    2 
 net/mac80211/ieee80211_ioctl.c               |  127 ++++---
 net/mac80211/ieee80211_rate.c                |   15 
 net/mac80211/ieee80211_rate.h                |   28 -
 net/mac80211/ieee80211_sta.c                 |  384 ++++++++++++-----------
 net/mac80211/rc80211_pid_algo.c              |   76 ++--
 net/mac80211/rc80211_simple.c                |   66 +---
 net/mac80211/regdomain.c                     |  152 ---------
 net/mac80211/rx.c                            |   82 ++--
 net/mac80211/sta_info.c                      |   24 -
 net/mac80211/sta_info.h                      |   10 
 net/mac80211/tx.c                            |  162 ++++++---
 net/mac80211/util.c                          |  142 +-------
 net/wireless/Makefile                        |    2 
 net/wireless/core.c                          |   41 ++
 net/wireless/core.h                          |    3 
 net/wireless/reg.c                           |  153 +++++++++
 net/wireless/util.c                          |   98 +++++
 65 files changed, 2115 insertions(+), 2773 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-01-24 19:34:48.783587566 +0100
+++ everything/include/net/mac80211.h	2008-01-24 19:35:11.593587077 +0100
@@ -69,95 +69,6 @@
  * not do so then mac80211 may add this under certain circumstances.
  */
 
-#define IEEE80211_CHAN_W_SCAN 0x00000001
-#define IEEE80211_CHAN_W_ACTIVE_SCAN 0x00000002
-#define IEEE80211_CHAN_W_IBSS 0x00000004
-
-/* Channel information structure. Low-level driver is expected to fill in chan,
- * freq, and val fields. Other fields will be filled in by 80211.o based on
- * hostapd information and low-level driver does not need to use them. The
- * limits for each channel will be provided in 'struct ieee80211_conf' when
- * configuring the low-level driver with hw->config callback. If a device has
- * a default regulatory domain, IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED
- * can be set to let the driver configure all fields */
-struct ieee80211_channel {
-	short chan; /* channel number (IEEE 802.11) */
-	short freq; /* frequency in MHz */
-	int val; /* hw specific value for the channel */
-	int flag; /* flag for hostapd use (IEEE80211_CHAN_*) */
-	unsigned char power_level;
-	unsigned char antenna_max;
-};
-
-#define IEEE80211_RATE_ERP 0x00000001
-#define IEEE80211_RATE_BASIC 0x00000002
-#define IEEE80211_RATE_PREAMBLE2 0x00000004
-#define IEEE80211_RATE_SUPPORTED 0x00000010
-#define IEEE80211_RATE_OFDM 0x00000020
-#define IEEE80211_RATE_CCK 0x00000040
-#define IEEE80211_RATE_MANDATORY 0x00000100
-
-#define IEEE80211_RATE_CCK_2 (IEEE80211_RATE_CCK | IEEE80211_RATE_PREAMBLE2)
-#define IEEE80211_RATE_MODULATION(f) \
-	(f & (IEEE80211_RATE_CCK | IEEE80211_RATE_OFDM))
-
-/* Low-level driver should set PREAMBLE2, OFDM and CCK flags.
- * BASIC, SUPPORTED, ERP, and MANDATORY flags are set in 80211.o based on the
- * configuration. */
-struct ieee80211_rate {
-	int rate; /* rate in 100 kbps */
-	int val; /* hw specific value for the rate */
-	int flags; /* IEEE80211_RATE_ flags */
-	int val2; /* hw specific value for the rate when using short preamble
-		   * (only when IEEE80211_RATE_PREAMBLE2 flag is set, i.e., for
-		   * 2, 5.5, and 11 Mbps) */
-	signed char min_rssi_ack;
-	unsigned char min_rssi_ack_delta;
-
-	/* following fields are set by 80211.o and need not be filled by the
-	 * low-level driver */
-	int rate_inv; /* inverse of the rate (LCM(all rates) / rate) for
-		       * optimizing channel utilization estimates */
-};
-
-/**
- * enum ieee80211_phymode - PHY modes
- *
- * @MODE_IEEE80211A: 5GHz as defined by 802.11a/802.11h
- * @MODE_IEEE80211B: 2.4 GHz as defined by 802.11b
- * @MODE_IEEE80211G: 2.4 GHz as defined by 802.11g (with OFDM),
- *	backwards compatible with 11b mode
- * @NUM_IEEE80211_MODES: internal
- */
-enum ieee80211_phymode {
-	MODE_IEEE80211A,
-	MODE_IEEE80211B,
-	MODE_IEEE80211G,
-
-	/* keep last */
-	NUM_IEEE80211_MODES
-};
-
-/**
- * struct ieee80211_ht_info - describing STA's HT capabilities
- *
- * This structure describes most essential parameters needed
- * to describe 802.11n HT capabilities for an STA.
- *
- * @ht_supported: is HT supported by STA, 0: no, 1: yes
- * @cap: HT capabilities map as described in 802.11n spec
- * @ampdu_factor: Maximum A-MPDU length factor
- * @ampdu_density: Minimum A-MPDU spacing
- * @supp_mcs_set: Supported MCS set as described in 802.11n spec
- */
-struct ieee80211_ht_info {
-	u8 ht_supported;
-	u16 cap; /* use IEEE80211_HT_CAP_ */
-	u8 ampdu_factor;
-	u8 ampdu_density;
-	u8 supp_mcs_set[16];
-};
-
 /**
  * struct ieee80211_ht_bss_info - describing BSS's HT characteristics
  *
@@ -175,30 +86,6 @@ struct ieee80211_ht_bss_info {
 };
 
 /**
- * struct ieee80211_hw_mode - PHY mode definition
- *
- * This structure describes the capabilities supported by the device
- * in a single PHY mode.
- *
- * @list: internal
- * @channels: pointer to array of supported channels
- * @rates: pointer to array of supported bitrates
- * @mode: the PHY mode for this definition
- * @num_channels: number of supported channels
- * @num_rates: number of supported bitrates
- * @ht_info: PHY's 802.11n HT abilities for this mode
- */
-struct ieee80211_hw_mode {
-	struct list_head list;
-	struct ieee80211_channel *channels;
-	struct ieee80211_rate *rates;
-	enum ieee80211_phymode mode;
-	int num_channels;
-	int num_rates;
-	struct ieee80211_ht_info ht_info;
-};
-
-/**
  * struct ieee80211_tx_queue_params - transmit queue configuration
  *
  * The information provided in this structure is required for QoS
@@ -318,11 +205,13 @@ struct ieee80211_bss_conf {
 
 struct ieee80211_tx_control {
 	struct ieee80211_vif *vif;
-	int tx_rate; /* Transmit rate, given as the hw specific value for the
-		      * rate (from struct ieee80211_rate) */
-	int rts_cts_rate; /* Transmit rate for RTS/CTS frame, given as the hw
-			   * specific value for the rate (from
-			   * struct ieee80211_rate) */
+	struct ieee80211_rate *tx_rate;
+
+	/* Transmit rate for RTS/CTS frame */
+	struct ieee80211_rate *rts_cts_rate;
+
+	/* retry rate for the last retries */
+	struct ieee80211_rate *alt_retry_rate;
 
 #define IEEE80211_TXCTL_REQ_TX_STATUS	(1<<0)/* request TX status callback for
 						* this frame */
@@ -341,6 +230,7 @@ struct ieee80211_tx_control {
 #define IEEE80211_TXCTL_REQUEUE		(1<<7)
 #define IEEE80211_TXCTL_FIRST_FRAGMENT	(1<<8) /* this is a first fragment of
 						* the frame */
+#define IEEE80211_TXCTL_SHORT_PREAMBLE	(1<<9)
 #define IEEE80211_TXCTL_LONG_RETRY_LIMIT (1<<10) /* this frame should be send
 						  * using the through
 						  * set_retry_limit configured
@@ -355,20 +245,11 @@ struct ieee80211_tx_control {
 	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, ..
 				 * This could be used when set_retry_limit
 				 * is not implemented by the driver */
-	u8 power_level;		/* per-packet transmit power level, in dBm */
 	u8 antenna_sel_tx; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
 	u8 icv_len;		/* length of the ICV/MIC field in octets */
 	u8 iv_len;		/* length of the IV field in octets */
 	u8 queue;		/* hardware queue to use for this frame;
 				 * 0 = highest, hw->queues-1 = lowest */
-	struct ieee80211_rate *rate;		/* internal 80211.o rate */
-	struct ieee80211_rate *rts_rate;	/* internal 80211.o rate
-						 * for RTS/CTS */
-	int alt_retry_rate; /* retry rate for the last retries, given as the
-			     * hw specific value for the rate (from
-			     * struct ieee80211_rate). To be used to limit
-			     * packet dropping when probing higher rates, if hw
-			     * supports multiple retry rates. -1 = not used */
 	int type;	/* internal */
 };
 
@@ -411,26 +292,24 @@ enum mac80211_rx_flags {
  * supported by hardware) to the 802.11 code with each received
  * frame.
  * @mactime: MAC timestamp as defined by 802.11
+ * @band: the active band when this frame was received
  * @freq: frequency the radio was tuned to when receiving this frame, in MHz
- * @channel: channel the radio was tuned to
- * @phymode: active PHY mode
  * @ssi: signal strength when receiving this frame
  * @signal: used as 'qual' in statistics reporting
  * @noise: PHY noise when receiving this frame
  * @antenna: antenna used
- * @rate: data rate
+ * @rate_idx: index of data rate into band's supported rates
  * @flag: %RX_FLAG_*
  */
 struct ieee80211_rx_status {
 	u64 mactime;
+	enum ieee80211_band band;
 	int freq;
-	int channel;
-	enum ieee80211_phymode phymode;
 	int ssi;
 	int signal;
 	int noise;
 	int antenna;
-	int rate;
+	int rate_idx;
 	int flag;
 };
 
@@ -502,41 +381,30 @@ enum ieee80211_conf_flags {
  *
  * @radio_enabled: when zero, driver is required to switch off the radio.
  *	TODO make a flag
- * @channel: IEEE 802.11 channel number
- * @freq: frequency in MHz
- * @channel_val: hardware specific channel value for the channel
- * @phymode: PHY mode to activate (REMOVE)
- * @chan: channel to switch to, pointer to the channel information
- * @mode: pointer to mode definition
- * @regulatory_domain: ??
  * @beacon_int: beacon interval (TODO make interface config)
  * @flags: configuration flags defined above
- * @power_level: transmit power limit for current regulatory domain in dBm
- * @antenna_max: maximum antenna gain
+ * @power_level: requested transmit power (in dBm)
+ * @max_antenna_gain: maximum antenna gain (in dBi)
  * @antenna_sel_tx: transmit antenna selection, 0: default/diversity,
  *	1/2: antenna 0/1
  * @antenna_sel_rx: receive antenna selection, like @antenna_sel_tx
  * @ht_conf: describes current self configuration of 802.11n HT capabilies
  * @ht_bss_conf: describes current BSS configuration of 802.11n HT parameters
+ * @channel: the channel to tune to
  */
 struct ieee80211_conf {
-	int channel;			/* IEEE 802.11 channel number */
-	int freq;			/* MHz */
-	int channel_val;		/* hw specific value for the channel */
-
-	enum ieee80211_phymode phymode;
-	struct ieee80211_channel *chan;
-	struct ieee80211_hw_mode *mode;
 	unsigned int regulatory_domain;
 	int radio_enabled;
 
 	int beacon_int;
 	u32 flags;
-	u8 power_level;
-	u8 antenna_max;
+	int power_level;
+	int max_antenna_gain;
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
 
+	struct ieee80211_channel *channel;
+
 	struct ieee80211_ht_info ht_conf;
 	struct ieee80211_ht_bss_info ht_bss_conf;
 };
@@ -757,15 +625,19 @@ enum sta_notify_cmd {
  *	%IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE is also not set because
  *	otherwise the stack will not know when the DTIM beacon was sent.
  *
- * @IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED:
- *	Channels are already configured to the default regulatory domain
- *	specified in the device's EEPROM
+ * @IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE:
+ *	Hardware is not capable of short slot operation on the 2.4 GHz band.
+ *
+ * @IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE:
+ *	Hardware is not capable of receiving frames with short preamble on
+ *	the 2.4 GHz band.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE		= 1<<0,
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
 	IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING	= 1<<2,
-	IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED	= 1<<3,
+	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE		= 1<<3,
+	IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE	= 1<<4,
 };
 
 /**
@@ -777,7 +649,8 @@ enum ieee80211_hw_flags {
  * @wiphy: This points to the &struct wiphy allocated for this
  *	802.11 PHY. You must fill in the @perm_addr and @dev
  *	members of this structure using SET_IEEE80211_DEV()
- *	and SET_IEEE80211_PERM_ADDR().
+ *	and SET_IEEE80211_PERM_ADDR(). Additionally, all supported
+ *	bands (with channels, bitrates) are registered here.
  *
  * @conf: &struct ieee80211_conf, device configuration, don't use.
  *
@@ -1051,7 +924,9 @@ enum ieee80211_ampdu_mlme_action {
  *	given local_address is enabled.
  *
  * @hw_scan: Ask the hardware to service the scan request, no need to start
- *	the scan state machine in stack.
+ *	the scan state machine in stack. The scan must honour the channel
+ *	configuration done by the regulatory agent in the wiphy's registered
+ *	bands.
  *
  * @get_stats: return low-level statistics
  *
@@ -1272,10 +1147,6 @@ static inline char *ieee80211_get_radio_
 #endif
 }
 
-/* Register a new hardware PHYMODE capability to the stack. */
-int ieee80211_register_hwmode(struct ieee80211_hw *hw,
-			      struct ieee80211_hw_mode *mode);
-
 /**
  * ieee80211_unregister_hw - Unregister a hardware device
  *
@@ -1449,7 +1320,7 @@ __le16 ieee80211_ctstoself_duration(stru
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @frame_len: the length of the frame.
- * @rate: the rate (in 100kbps) at which the frame is going to be transmitted.
+ * @rate: the rate at which the frame is going to be transmitted.
  *
  * Calculate the duration field of some generic frame, given its
  * length and transmission rate (in 100kbps).
@@ -1457,7 +1328,7 @@ __le16 ieee80211_ctstoself_duration(stru
 __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 					size_t frame_len,
-					int rate);
+					struct ieee80211_rate *rate);
 
 /**
  * ieee80211_get_buffered_bc - accessing buffered broadcast and multicast frames
--- everything.orig/include/net/wireless.h	2008-01-24 19:34:48.883587783 +0100
+++ everything/include/net/wireless.h	2008-01-24 19:35:11.593587077 +0100
@@ -13,6 +13,162 @@
 #include <net/cfg80211.h>
 
 /**
+ * enum ieee80211_band - supported frequency bands
+ *
+ * The bands are assigned this way because the supported
+ * bitrates differ in these bands.
+ *
+ * @IEEE80211_BAND_2GHZ: 2.4GHz ISM band
+ * @IEEE80211_BAND_5GHZ: around 5GHz band (4.9-5.7)
+ */
+enum ieee80211_band {
+	IEEE80211_BAND_2GHZ,
+	IEEE80211_BAND_5GHZ,
+
+	/* keep last */
+	IEEE80211_NUM_BANDS
+};
+
+/**
+ * enum ieee80211_channel_flags - channel flags
+ *
+ * Channel flags set by the regulatory control code.
+ *
+ * @IEEE80211_CHAN_DISABLED: This channel is disabled.
+ * @IEEE80211_CHAN_PASSIVE_SCAN: Only passive scanning is permitted
+ *	on this channel.
+ * @IEEE80211_CHAN_NO_IBSS: IBSS is not allowed on this channel.
+ * @IEEE80211_CHAN_RADAR: Radar detection is required on this channel.
+ */
+enum ieee80211_channel_flags {
+	IEEE80211_CHAN_DISABLED		= 1<<0,
+	IEEE80211_CHAN_PASSIVE_SCAN	= 1<<1,
+	IEEE80211_CHAN_NO_IBSS		= 1<<2,
+	IEEE80211_CHAN_RADAR		= 1<<3,
+};
+
+/**
+ * struct ieee80211_channel - channel definition
+ *
+ * This structure describes a single channel for use
+ * with cfg80211.
+ *
+ * @center_freq: center frequency in MHz
+ * @hw_value: hardware-specific value for the channel
+ * @flags: channel flags from &enum ieee80211_channel_flags.
+ * @orig_flags: channel flags at registration time, used by regulatory
+ *	code to support devices with additional restrictions
+ * @band: band this channel belongs to.
+ * @max_antenna_gain: maximum antenna gain in dBi
+ * @max_power: maximum transmission power (in dBm)
+ * @orig_mag: internal use
+ * @orig_mpwr: internal use
+ */
+struct ieee80211_channel {
+	enum ieee80211_band band;
+	u16 center_freq;
+	u16 hw_value;
+	u32 flags;
+	int max_antenna_gain;
+	int max_power;
+	u32 orig_flags;
+	int orig_mag, orig_mpwr;
+};
+
+/**
+ * enum ieee80211_rate_flags - rate flags
+ *
+ * Hardware/specification flags for rates. These are structured
+ * in a way that allows using the same bitrate structure for
+ * different bands/PHY modes.
+ *
+ * @IEEE80211_RATE_SHORT_PREAMBLE: Hardware can send with short
+ *	preamble on this bitrate; only relevant in 2.4GHz band and
+ *	with CCK rates.
+ * @IEEE80211_RATE_MANDATORY_A: This bitrate is a mandatory rate
+ *	when used with 802.11a (on the 5 GHz band); filled by the
+ *	core code when registering the wiphy.
+ * @IEEE80211_RATE_MANDATORY_B: This bitrate is a mandatory rate
+ *	when used with 802.11b (on the 2.4 GHz band); filled by the
+ *	core code when registering the wiphy.
+ * @IEEE80211_RATE_MANDATORY_G: This bitrate is a mandatory rate
+ *	when used with 802.11g (on the 2.4 GHz band); filled by the
+ *	core code when registering the wiphy.
+ * @IEEE80211_RATE_ERP_G: This is an ERP rate in 802.11g mode.
+ */
+enum ieee80211_rate_flags {
+	IEEE80211_RATE_SHORT_PREAMBLE	= 1<<0,
+	IEEE80211_RATE_MANDATORY_A	= 1<<1,
+	IEEE80211_RATE_MANDATORY_B	= 1<<2,
+	IEEE80211_RATE_MANDATORY_G	= 1<<3,
+	IEEE80211_RATE_ERP_G		= 1<<4,
+};
+
+/**
+ * struct ieee80211_rate - bitrate definition
+ *
+ * This structure describes a bitrate that an 802.11 PHY can
+ * operate with. The two values @hw_value and @hw_value_short
+ * are only for driver use when pointers to this structure are
+ * passed around.
+ *
+ * @flags: rate-specific flags
+ * @bitrate: bitrate in units of 100 Kbps
+ * @hw_value: driver/hardware value for this rate
+ * @hw_value_short: driver/hardware value for this rate when
+ *	short preamble is used
+ */
+struct ieee80211_rate {
+	u32 flags;
+	u16 bitrate;
+	u16 hw_value, hw_value_short;
+};
+
+/**
+ * struct ieee80211_ht_info - describing STA's HT capabilities
+ *
+ * This structure describes most essential parameters needed
+ * to describe 802.11n HT capabilities for an STA.
+ *
+ * @ht_supported: is HT supported by STA, 0: no, 1: yes
+ * @cap: HT capabilities map as described in 802.11n spec
+ * @ampdu_factor: Maximum A-MPDU length factor
+ * @ampdu_density: Minimum A-MPDU spacing
+ * @supp_mcs_set: Supported MCS set as described in 802.11n spec
+ */
+struct ieee80211_ht_info {
+	u16 cap; /* use IEEE80211_HT_CAP_ */
+	u8 ht_supported;
+	u8 ampdu_factor;
+	u8 ampdu_density;
+	u8 supp_mcs_set[16];
+};
+
+/**
+ * struct ieee80211_supported_band - frequency band definition
+ *
+ * This structure describes a frequency band a wiphy
+ * is able to operate in.
+ *
+ * @channels: Array of channels the hardware can operate in
+ *	in this band.
+ * @band: the band this structure represents
+ * @n_channels: Number of channels in @channels
+ * @bitrates: Array of bitrates the hardware can operate with
+ *	in this band. Must be sorted to give a valid "supported
+ *	rates" IE, i.e. CCK rates first, then OFDM.
+ * @n_bitrates: Number of bitrates in @bitrates
+ */
+struct ieee80211_supported_band {
+	struct ieee80211_channel *channels;
+	struct ieee80211_rate *bitrates;
+	enum ieee80211_band band;
+	int n_channels;
+	int n_bitrates;
+	struct ieee80211_ht_info ht_info;
+};
+
+/**
  * struct wiphy - wireless hardware description
  * @idx: the wiphy index assigned to this item
  * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
@@ -30,6 +186,8 @@ struct wiphy {
 	 * help determine whether you own this wiphy or not. */
 	void *privid;
 
+	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
+
 	/* fields below are read-only, assigned by cfg80211 */
 
 	/* the item in /sys/class/ieee80211/ points to this,
@@ -136,4 +294,14 @@ extern void wiphy_unregister(struct wiph
  */
 extern void wiphy_free(struct wiphy *wiphy);
 
+/**
+ * ieee80211_channel_to_frequency - convert channel number to frequency
+ */
+extern int ieee80211_channel_to_frequency(int chan);
+
+/**
+ * ieee80211_frequency_to_channel - convert frequency to channel number
+ */
+extern int ieee80211_frequency_to_channel(int freq);
+
 #endif /* __NET_WIRELESS_H */
--- everything.orig/net/mac80211/ieee80211_i.h	2008-01-24 19:34:49.033586697 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-01-24 19:35:11.593587077 +0100
@@ -79,8 +79,7 @@ struct ieee80211_sta_bss {
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
 	u16 capability; /* host byte order */
-	int hw_mode;
-	int channel;
+	enum ieee80211_band band;
 	int freq;
 	int rssi, signal, noise;
 	u8 *wpa_ie;
@@ -136,13 +135,12 @@ struct ieee80211_txrx_data {
 	union {
 		struct {
 			struct ieee80211_tx_control *control;
-			struct ieee80211_hw_mode *mode;
+			struct ieee80211_channel *channel;
 			struct ieee80211_rate *rate;
 			/* use this rate (if set) for last fragment; rate can
 			 * be set to lower rate for the first fragments, e.g.,
 			 * when using CTS protection with IEEE 802.11g. */
 			struct ieee80211_rate *last_frag_rate;
-			int last_frag_hwrate;
 
 			/* Extra fragments (in addition to the first fragment
 			 * in skb) */
@@ -151,6 +149,7 @@ struct ieee80211_txrx_data {
 		} tx;
 		struct {
 			struct ieee80211_rx_status *status;
+			struct ieee80211_rate *rate;
 			int sent_ps_buffered;
 			int queue;
 			int load;
@@ -178,8 +177,6 @@ struct ieee80211_tx_stored_packet {
 	struct sk_buff *skb;
 	int num_extra_frag;
 	struct sk_buff **extra_frag;
-	int last_frag_rateidx;
-	int last_frag_hwrate;
 	struct ieee80211_rate *last_frag_rate;
 	unsigned int last_frag_rate_ctrl_probe;
 };
@@ -282,7 +279,7 @@ struct ieee80211_if_sta {
 
 	unsigned long ibss_join_req;
 	struct sk_buff *probe_resp; /* ProbeResp template for IBSS */
-	u32 supp_rates_bits;
+	u32 supp_rates_bits[IEEE80211_NUM_BANDS];
 
 	int wmm_last_param_set;
 };
@@ -292,6 +289,7 @@ struct ieee80211_if_sta {
 #define IEEE80211_SDATA_ALLMULTI	BIT(0)
 #define IEEE80211_SDATA_PROMISC		BIT(1)
 #define IEEE80211_SDATA_USERSPACE_MLME	BIT(2)
+#define IEEE80211_SDATA_OPERATING_GMODE	BIT(3)
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
@@ -312,6 +310,11 @@ struct ieee80211_sub_if_data {
 	 */
 	int ieee802_1x_pac;
 
+	/*
+	 * basic rates of this AP or the AP we're associated to
+	 */
+	u64 basic_rates;
+
 	u16 sequence;
 
 	/* Fragment table for host-based reassembly */
@@ -417,9 +420,6 @@ struct ieee80211_local {
 
 	const struct ieee80211_ops *ops;
 
-	/* List of registered struct ieee80211_hw_mode */
-	struct list_head modes_list;
-
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
 	int open_count;
 	int monitors;
@@ -459,11 +459,6 @@ struct ieee80211_local {
 
 	struct rate_control_ref *rate_ctrl;
 
-	/* Supported and basic rate filters for different modes. These are
-	 * pointers to -1 terminated lists and rates in 100 kbps units. */
-	int *supp_rates[NUM_IEEE80211_MODES];
-	int *basic_rates[NUM_IEEE80211_MODES];
-
 	int rts_threshold;
 	int fragmentation_threshold;
 	int short_retry_limit; /* dot11ShortRetryLimit */
@@ -486,12 +481,13 @@ struct ieee80211_local {
 	bool sta_sw_scanning;
 	bool sta_hw_scanning;
 	int scan_channel_idx;
+	enum ieee80211_band scan_band;
+
 	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
 	unsigned long last_scan_completed;
 	struct delayed_work scan_work;
 	struct net_device *scan_dev;
 	struct ieee80211_channel *oper_channel, *scan_channel;
-	struct ieee80211_hw_mode *oper_hw_mode, *scan_hw_mode;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
 	struct list_head sta_bss_list;
@@ -560,14 +556,8 @@ struct ieee80211_local {
 	int wifi_wme_noack_test;
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
-	unsigned int enabled_modes; /* bitfield of allowed modes;
-				      * (1 << MODE_*) */
-	unsigned int hw_modes; /* bitfield of supported hardware modes;
-				* (1 << MODE_*) */
-
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct local_debugfsdentries {
-		struct dentry *channel;
 		struct dentry *frequency;
 		struct dentry *antenna_sel_tx;
 		struct dentry *antenna_sel_rx;
@@ -577,9 +567,7 @@ struct ieee80211_local {
 		struct dentry *short_retry_limit;
 		struct dentry *long_retry_limit;
 		struct dentry *total_ps_buffered;
-		struct dentry *mode;
 		struct dentry *wep_iv;
-		struct dentry *modes;
 		struct dentry *statistics;
 		struct local_debugfsdentries_statsdentries {
 			struct dentry *transmitted_fragment_count;
@@ -684,23 +672,6 @@ static inline void bss_tim_clear(struct 
 	read_unlock_bh(&local->sta_lock);
 }
 
-/**
- * ieee80211_is_erp_rate - Check if a rate is an ERP rate
- * @phymode: The PHY-mode for this rate (MODE_IEEE80211...)
- * @rate: Transmission rate to check, in 100 kbps
- *
- * Check if a given rate is an Extended Rate PHY (ERP) rate.
- */
-static inline int ieee80211_is_erp_rate(int phymode, int rate)
-{
-	if (phymode == MODE_IEEE80211G) {
-		if (rate != 10 && rate != 20 &&
-		    rate != 55 && rate != 110)
-			return 1;
-	}
-	return 0;
-}
-
 static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
 {
 	return compare_ether_addr(raddr, addr) == 0 ||
@@ -712,13 +683,9 @@ static inline int ieee80211_bssid_match(
 int ieee80211_hw_config(struct ieee80211_local *local);
 int ieee80211_if_config(struct net_device *dev);
 int ieee80211_if_config_beacon(struct net_device *dev);
-void ieee80211_prepare_rates(struct ieee80211_local *local,
-			     struct ieee80211_hw_mode *mode);
 void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx);
 int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr);
 void ieee80211_if_setup(struct net_device *dev);
-struct ieee80211_rate *ieee80211_get_rate(struct ieee80211_local *local,
-					  int phymode, int hwrate);
 int ieee80211_hw_config_ht(struct ieee80211_local *local, int enable_ht,
 			   struct ieee80211_ht_info *req_ht_cap,
 			   struct ieee80211_ht_bss_info *req_bss_cap);
@@ -749,7 +716,7 @@ extern const struct iw_handler_def ieee8
 /* ieee80211_ioctl.c */
 int ieee80211_set_compression(struct ieee80211_local *local,
 			      struct net_device *dev, struct sta_info *sta);
-int ieee80211_set_channel(struct ieee80211_local *local, int channel, int freq);
+int ieee80211_set_freq(struct ieee80211_local *local, int freq);
 /* ieee80211_sta.c */
 void ieee80211_sta_timer(unsigned long data);
 void ieee80211_sta_work(struct work_struct *work);
@@ -796,10 +763,6 @@ int ieee80211_if_remove(struct net_devic
 void ieee80211_if_free(struct net_device *dev);
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata);
 
-/* regdomain.c */
-void ieee80211_regdomain_init(void);
-void ieee80211_set_default_regdomain(struct ieee80211_hw_mode *mode);
-
 /* rx handling */
 extern ieee80211_rx_handler ieee80211_rx_pre_handlers[];
 extern ieee80211_rx_handler ieee80211_rx_handlers[];
--- everything.orig/net/mac80211/util.c	2008-01-24 19:34:49.123594618 +0100
+++ everything/net/mac80211/util.c	2008-01-24 19:35:11.593587077 +0100
@@ -41,92 +41,6 @@ const unsigned char bridge_tunnel_header
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 
 
-static int rate_list_match(const int *rate_list, int rate)
-{
-	int i;
-
-	if (!rate_list)
-		return 0;
-
-	for (i = 0; rate_list[i] >= 0; i++)
-		if (rate_list[i] == rate)
-			return 1;
-
-	return 0;
-}
-
-void ieee80211_prepare_rates(struct ieee80211_local *local,
-			     struct ieee80211_hw_mode *mode)
-{
-	int i;
-
-	for (i = 0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *rate = &mode->rates[i];
-
-		rate->flags &= ~(IEEE80211_RATE_SUPPORTED |
-				 IEEE80211_RATE_BASIC);
-
-		if (local->supp_rates[mode->mode]) {
-			if (!rate_list_match(local->supp_rates[mode->mode],
-					     rate->rate))
-				continue;
-		}
-
-		rate->flags |= IEEE80211_RATE_SUPPORTED;
-
-		/* Use configured basic rate set if it is available. If not,
-		 * use defaults that are sane for most cases. */
-		if (local->basic_rates[mode->mode]) {
-			if (rate_list_match(local->basic_rates[mode->mode],
-					    rate->rate))
-				rate->flags |= IEEE80211_RATE_BASIC;
-		} else switch (mode->mode) {
-		case MODE_IEEE80211A:
-			if (rate->rate == 60 || rate->rate == 120 ||
-			    rate->rate == 240)
-				rate->flags |= IEEE80211_RATE_BASIC;
-			break;
-		case MODE_IEEE80211B:
-			if (rate->rate == 10 || rate->rate == 20)
-				rate->flags |= IEEE80211_RATE_BASIC;
-			break;
-		case MODE_IEEE80211G:
-			if (rate->rate == 10 || rate->rate == 20 ||
-			    rate->rate == 55 || rate->rate == 110)
-				rate->flags |= IEEE80211_RATE_BASIC;
-			break;
-		case NUM_IEEE80211_MODES:
-			/* not useful */
-			break;
-		}
-
-		/* Set ERP and MANDATORY flags based on phymode */
-		switch (mode->mode) {
-		case MODE_IEEE80211A:
-			if (rate->rate == 60 || rate->rate == 120 ||
-			    rate->rate == 240)
-				rate->flags |= IEEE80211_RATE_MANDATORY;
-			break;
-		case MODE_IEEE80211B:
-			if (rate->rate == 10)
-				rate->flags |= IEEE80211_RATE_MANDATORY;
-			break;
-		case MODE_IEEE80211G:
-			if (rate->rate == 10 || rate->rate == 20 ||
-			    rate->rate == 55 || rate->rate == 110 ||
-			    rate->rate == 60 || rate->rate == 120 ||
-			    rate->rate == 240)
-				rate->flags |= IEEE80211_RATE_MANDATORY;
-			break;
-		case NUM_IEEE80211_MODES:
-			/* not useful */
-			break;
-		}
-		if (ieee80211_is_erp_rate(mode->mode, rate->rate))
-			rate->flags |= IEEE80211_RATE_ERP;
-	}
-}
-
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum ieee80211_if_types type)
 {
@@ -262,7 +176,7 @@ int ieee80211_frame_duration(struct ieee
 	 * DIV_ROUND_UP() operations.
 	 */
 
-	if (local->hw.conf.phymode == MODE_IEEE80211A || erp) {
+	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ || erp) {
 		/*
 		 * OFDM:
 		 *
@@ -304,15 +218,19 @@ int ieee80211_frame_duration(struct ieee
 /* Exported duration function for driver use */
 __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
-					size_t frame_len, int rate)
+					size_t frame_len,
+					struct ieee80211_rate *rate)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	u16 dur;
 	int erp;
 
-	erp = ieee80211_is_erp_rate(hw->conf.phymode, rate);
-	dur = ieee80211_frame_duration(local, frame_len, rate, erp,
+	erp = 0;
+	if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+		erp = rate->flags & IEEE80211_RATE_ERP_G;
+
+	dur = ieee80211_frame_duration(local, frame_len, rate->bitrate, erp,
 				       sdata->bss_conf.use_short_preamble);
 
 	return cpu_to_le16(dur);
@@ -332,17 +250,20 @@ __le16 ieee80211_rts_duration(struct iee
 
 	short_preamble = sdata->bss_conf.use_short_preamble;
 
-	rate = frame_txctl->rts_rate;
-	erp = !!(rate->flags & IEEE80211_RATE_ERP);
+	rate = frame_txctl->rts_cts_rate;
+
+	erp = 0;
+	if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+		erp = rate->flags & IEEE80211_RATE_ERP_G;
 
 	/* CTS duration */
-	dur = ieee80211_frame_duration(local, 10, rate->rate,
+	dur = ieee80211_frame_duration(local, 10, rate->bitrate,
 				       erp, short_preamble);
 	/* Data frame duration */
-	dur += ieee80211_frame_duration(local, frame_len, rate->rate,
+	dur += ieee80211_frame_duration(local, frame_len, rate->bitrate,
 					erp, short_preamble);
 	/* ACK duration */
-	dur += ieee80211_frame_duration(local, 10, rate->rate,
+	dur += ieee80211_frame_duration(local, 10, rate->bitrate,
 					erp, short_preamble);
 
 	return cpu_to_le16(dur);
@@ -363,15 +284,17 @@ __le16 ieee80211_ctstoself_duration(stru
 
 	short_preamble = sdata->bss_conf.use_short_preamble;
 
-	rate = frame_txctl->rts_rate;
-	erp = !!(rate->flags & IEEE80211_RATE_ERP);
+	rate = frame_txctl->rts_cts_rate;
+	erp = 0;
+	if (sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+		erp = rate->flags & IEEE80211_RATE_ERP_G;
 
 	/* Data frame duration */
-	dur = ieee80211_frame_duration(local, frame_len, rate->rate,
+	dur = ieee80211_frame_duration(local, frame_len, rate->bitrate,
 				       erp, short_preamble);
 	if (!(frame_txctl->flags & IEEE80211_TXCTL_NO_ACK)) {
 		/* ACK duration */
-		dur += ieee80211_frame_duration(local, 10, rate->rate,
+		dur += ieee80211_frame_duration(local, 10, rate->bitrate,
 						erp, short_preamble);
 	}
 
@@ -379,27 +302,6 @@ __le16 ieee80211_ctstoself_duration(stru
 }
 EXPORT_SYMBOL(ieee80211_ctstoself_duration);
 
-struct ieee80211_rate *
-ieee80211_get_rate(struct ieee80211_local *local, int phymode, int hw_rate)
-{
-	struct ieee80211_hw_mode *mode;
-	int r;
-
-	list_for_each_entry(mode, &local->modes_list, list) {
-		if (mode->mode != phymode)
-			continue;
-		for (r = 0; r < mode->num_rates; r++) {
-			struct ieee80211_rate *rate = &mode->rates[r];
-			if (rate->val == hw_rate ||
-			    (rate->flags & IEEE80211_RATE_PREAMBLE2 &&
-			     rate->val2 == hw_rate))
-				return rate;
-		}
-	}
-
-	return NULL;
-}
-
 void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
--- everything.orig/net/mac80211/ieee80211.c	2008-01-24 19:34:49.233587945 +0100
+++ everything/net/mac80211/ieee80211.c	2008-01-24 19:35:11.603586752 +0100
@@ -550,37 +550,28 @@ int ieee80211_if_config_beacon(struct ne
 
 int ieee80211_hw_config(struct ieee80211_local *local)
 {
-	struct ieee80211_hw_mode *mode;
 	struct ieee80211_channel *chan;
 	int ret = 0;
 
-	if (local->sta_sw_scanning) {
+	if (local->sta_sw_scanning)
 		chan = local->scan_channel;
-		mode = local->scan_hw_mode;
-	} else {
+	else
 		chan = local->oper_channel;
-		mode = local->oper_hw_mode;
-	}
 
-	local->hw.conf.channel = chan->chan;
-	local->hw.conf.channel_val = chan->val;
-	if (!local->hw.conf.power_level) {
-		local->hw.conf.power_level = chan->power_level;
-	} else {
-		local->hw.conf.power_level = min(chan->power_level,
-						 local->hw.conf.power_level);
-	}
-	local->hw.conf.freq = chan->freq;
-	local->hw.conf.phymode = mode->mode;
-	local->hw.conf.antenna_max = chan->antenna_max;
-	local->hw.conf.chan = chan;
-	local->hw.conf.mode = mode;
+	local->hw.conf.channel = chan;
+
+	if (!local->hw.conf.power_level)
+		local->hw.conf.power_level = chan->max_power;
+	else
+		local->hw.conf.power_level = min(chan->max_power,
+					       local->hw.conf.power_level);
+
+	local->hw.conf.max_antenna_gain = chan->max_antenna_gain;
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "HW CONFIG: channel=%d freq=%d "
-	       "phymode=%d\n", local->hw.conf.channel, local->hw.conf.freq,
-	       local->hw.conf.phymode);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+	printk(KERN_DEBUG "%s: HW CONFIG: freq=%d\n",
+	       wiphy_name(local->hw.wiphy), chan->center_freq);
+#endif
 
 	if (local->open_count)
 		ret = local->ops->config(local_to_hw(local), &local->hw.conf);
@@ -598,11 +589,13 @@ int ieee80211_hw_config_ht(struct ieee80
 			   struct ieee80211_ht_bss_info *req_bss_cap)
 {
 	struct ieee80211_conf *conf = &local->hw.conf;
-	struct ieee80211_hw_mode *mode = conf->mode;
+	struct ieee80211_supported_band *sband;
 	int i;
 
+	sband = local->hw.wiphy->bands[conf->channel->band];
+
 	/* HT is not supported */
-	if (!mode->ht_info.ht_supported) {
+	if (!sband->ht_info.ht_supported) {
 		conf->flags &= ~IEEE80211_CONF_SUPPORT_HT_MODE;
 		return -EOPNOTSUPP;
 	}
@@ -612,17 +605,17 @@ int ieee80211_hw_config_ht(struct ieee80
 		conf->flags &= ~IEEE80211_CONF_SUPPORT_HT_MODE;
 	} else {
 		conf->flags |= IEEE80211_CONF_SUPPORT_HT_MODE;
-		conf->ht_conf.cap = req_ht_cap->cap & mode->ht_info.cap;
+		conf->ht_conf.cap = req_ht_cap->cap & sband->ht_info.cap;
 		conf->ht_conf.cap &= ~(IEEE80211_HT_CAP_MIMO_PS);
 		conf->ht_conf.cap |=
-			mode->ht_info.cap & IEEE80211_HT_CAP_MIMO_PS;
+			sband->ht_info.cap & IEEE80211_HT_CAP_MIMO_PS;
 		conf->ht_bss_conf.primary_channel =
 			req_bss_cap->primary_channel;
 		conf->ht_bss_conf.bss_cap = req_bss_cap->bss_cap;
 		conf->ht_bss_conf.bss_op_mode = req_bss_cap->bss_op_mode;
 		for (i = 0; i < SUPP_MCS_SET_LEN; i++)
 			conf->ht_conf.supp_mcs_set[i] =
-				mode->ht_info.supp_mcs_set[i] &
+				sband->ht_info.supp_mcs_set[i] &
 				  req_ht_cap->supp_mcs_set[i];
 
 		/* In STA mode, this gives us indication
@@ -1080,10 +1073,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->long_retry_limit = 4;
 	local->hw.conf.radio_enabled = 1;
 
-	local->enabled_modes = ~0;
-
-	INIT_LIST_HEAD(&local->modes_list);
-
 	INIT_LIST_HEAD(&local->interfaces);
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
@@ -1128,6 +1117,25 @@ int ieee80211_register_hw(struct ieee802
 	struct ieee80211_local *local = hw_to_local(hw);
 	const char *name;
 	int result;
+	enum ieee80211_band band;
+
+	/*
+	 * generic code guarantees at least one band,
+	 * set this very early because much code assumes
+	 * that hw.conf.channel is assigned
+	 */
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		struct ieee80211_supported_band *sband;
+
+		sband = local->hw.wiphy->bands[band];
+		if (sband) {
+			/* init channel we're on */
+			local->hw.conf.channel =
+			local->oper_channel =
+			local->scan_channel = &sband->channels[0];
+			break;
+		}
+	}
 
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
@@ -1229,44 +1237,10 @@ fail_workqueue:
 }
 EXPORT_SYMBOL(ieee80211_register_hw);
 
-int ieee80211_register_hwmode(struct ieee80211_hw *hw,
-			      struct ieee80211_hw_mode *mode)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_rate *rate;
-	int i;
-
-	INIT_LIST_HEAD(&mode->list);
-	list_add_tail(&mode->list, &local->modes_list);
-
-	local->hw_modes |= (1 << mode->mode);
-	for (i = 0; i < mode->num_rates; i++) {
-		rate = &(mode->rates[i]);
-		rate->rate_inv = CHAN_UTIL_RATE_LCM / rate->rate;
-	}
-	ieee80211_prepare_rates(local, mode);
-
-	if (!local->oper_hw_mode) {
-		/* Default to this mode */
-		local->hw.conf.phymode = mode->mode;
-		local->oper_hw_mode = local->scan_hw_mode = mode;
-		local->oper_channel = local->scan_channel = &mode->channels[0];
-		local->hw.conf.mode = local->oper_hw_mode;
-		local->hw.conf.chan = local->oper_channel;
-	}
-
-	if (!(hw->flags & IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED))
-		ieee80211_set_default_regdomain(mode);
-
-	return 0;
-}
-EXPORT_SYMBOL(ieee80211_register_hwmode);
-
 void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata, *tmp;
-	int i;
 
 	tasklet_kill(&local->tx_pending_tasklet);
 	tasklet_kill(&local->tasklet);
@@ -1307,11 +1281,6 @@ void ieee80211_unregister_hw(struct ieee
 	rate_control_deinitialize(local);
 	debugfs_hw_del(local);
 
-	for (i = 0; i < NUM_IEEE80211_MODES; i++) {
-		kfree(local->supp_rates[i]);
-		kfree(local->basic_rates[i]);
-	}
-
 	if (skb_queue_len(&local->skb_queue)
 			|| skb_queue_len(&local->skb_queue_unreliable))
 		printk(KERN_WARNING "%s: skb_queue not empty\n",
@@ -1358,7 +1327,6 @@ static int __init ieee80211_init(void)
 	}
 
 	ieee80211_debugfs_netdev_init();
-	ieee80211_regdomain_init();
 
 	return 0;
 
--- everything.orig/net/mac80211/ieee80211_ioctl.c	2008-01-24 19:34:56.953586101 +0100
+++ everything/net/mac80211/ieee80211_ioctl.c	2008-01-24 19:35:11.603586752 +0100
@@ -129,22 +129,7 @@ static int ieee80211_ioctl_giwname(struc
 				   struct iw_request_info *info,
 				   char *name, char *extra)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	switch (local->hw.conf.phymode) {
-	case MODE_IEEE80211A:
-		strcpy(name, "IEEE 802.11a");
-		break;
-	case MODE_IEEE80211B:
-		strcpy(name, "IEEE 802.11b");
-		break;
-	case MODE_IEEE80211G:
-		strcpy(name, "IEEE 802.11g");
-		break;
-	default:
-		strcpy(name, "IEEE 802.11");
-		break;
-	}
+	strcpy(name, "IEEE 802.11");
 
 	return 0;
 }
@@ -156,7 +141,7 @@ static int ieee80211_ioctl_giwrange(stru
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct iw_range *range = (struct iw_range *) extra;
-	struct ieee80211_hw_mode *mode = NULL;
+	enum ieee80211_band band;
 	int c = 0;
 
 	data->length = sizeof(struct iw_range);
@@ -191,24 +176,27 @@ static int ieee80211_ioctl_giwrange(stru
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
-	list_for_each_entry(mode, &local->modes_list, list) {
-		int i = 0;
 
-		if (!(local->enabled_modes & (1 << mode->mode)) ||
-		    (local->hw_modes & local->enabled_modes &
-		     (1 << MODE_IEEE80211G) && mode->mode == MODE_IEEE80211B))
+	for (band = 0; band < IEEE80211_NUM_BANDS; band ++) {
+		int i;
+		struct ieee80211_supported_band *sband;
+
+		sband = local->hw.wiphy->bands[band];
+
+		if (!sband)
 			continue;
 
-		while (i < mode->num_channels && c < IW_MAX_FREQUENCIES) {
-			struct ieee80211_channel *chan = &mode->channels[i];
+		for (i = 0; i < sband->n_channels && c < IW_MAX_FREQUENCIES; i++) {
+			struct ieee80211_channel *chan = &sband->channels[i];
 
-			if (chan->flag & IEEE80211_CHAN_W_SCAN) {
-				range->freq[c].i = chan->chan;
-				range->freq[c].m = chan->freq * 100000;
-				range->freq[c].e = 1;
+			if (!(chan->flags & IEEE80211_CHAN_DISABLED)) {
+				range->freq[c].i =
+					ieee80211_frequency_to_channel(
+						chan->center_freq);
+				range->freq[c].m = chan->center_freq;
+				range->freq[c].e = 6;
 				c++;
 			}
-			i++;
 		}
 	}
 	range->num_channels = c;
@@ -294,22 +282,29 @@ static int ieee80211_ioctl_giwmode(struc
 	return 0;
 }
 
-int ieee80211_set_channel(struct ieee80211_local *local, int channel, int freq)
+int ieee80211_set_freq(struct ieee80211_local *local, int freqMHz)
 {
-	struct ieee80211_hw_mode *mode;
-	int c, set = 0;
+	int set = 0;
 	int ret = -EINVAL;
+	enum ieee80211_band band;
+	struct ieee80211_supported_band *sband;
+	int i;
 
-	list_for_each_entry(mode, &local->modes_list, list) {
-		if (!(local->enabled_modes & (1 << mode->mode)))
+	for (band = 0; band < IEEE80211_NUM_BANDS; band ++) {
+		sband = local->hw.wiphy->bands[band];
+
+		if (!sband)
 			continue;
-		for (c = 0; c < mode->num_channels; c++) {
-			struct ieee80211_channel *chan = &mode->channels[c];
-			if (chan->flag & IEEE80211_CHAN_W_SCAN &&
-			    ((chan->chan == channel) || (chan->freq == freq))) {
-				local->oper_channel = chan;
-				local->oper_hw_mode = mode;
+
+		for (i = 0; i < sband->n_channels; i++) {
+			struct ieee80211_channel *chan = &sband->channels[i];
+
+			if (chan->flags & IEEE80211_CHAN_DISABLED)
+				continue;
+
+			if (chan->center_freq == freqMHz) {
 				set = 1;
+				local->oper_channel = chan;
 				break;
 			}
 		}
@@ -347,13 +342,14 @@ static int ieee80211_ioctl_siwfreq(struc
 					IEEE80211_STA_AUTO_CHANNEL_SEL;
 			return 0;
 		} else
-			return ieee80211_set_channel(local, freq->m, -1);
+			return ieee80211_set_freq(local,
+				ieee80211_channel_to_frequency(freq->m));
 	} else {
 		int i, div = 1000000;
 		for (i = 0; i < freq->e; i++)
 			div /= 10;
 		if (div > 0)
-			return ieee80211_set_channel(local, -1, freq->m / div);
+			return ieee80211_set_freq(local, freq->m / div);
 		else
 			return -EINVAL;
 	}
@@ -366,10 +362,7 @@ static int ieee80211_ioctl_giwfreq(struc
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
-	/* TODO: in station mode (Managed/Ad-hoc) might need to poll low-level
-	 * driver for the current channel with firmware-based management */
-
-	freq->m = local->hw.conf.freq;
+	freq->m = local->hw.conf.channel->center_freq;
 	freq->e = 6;
 
 	return 0;
@@ -566,15 +559,17 @@ static int ieee80211_ioctl_siwrate(struc
 				  struct iw_param *rate, char *extra)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hw_mode *mode;
-	int i;
+	int i, err = -EINVAL;
 	u32 target_rate = rate->value / 100000;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_supported_band *sband;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (!sdata->bss)
 		return -ENODEV;
-	mode = local->oper_hw_mode;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
 	/* target_rate = -1, rate->fixed = 0 means auto only, so use all rates
 	 * target_rate = X, rate->fixed = 1 means only rate X
 	 * target_rate = X, rate->fixed = 0 means all rates <= X */
@@ -582,18 +577,20 @@ static int ieee80211_ioctl_siwrate(struc
 	sdata->bss->force_unicast_rateidx = -1;
 	if (rate->value < 0)
 		return 0;
-	for (i=0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *rates = &mode->rates[i];
-		int this_rate = rates->rate;
+
+	for (i=0; i< sband->n_bitrates; i++) {
+		struct ieee80211_rate *brate = &sband->bitrates[i];
+		int this_rate = brate->bitrate;
 
 		if (target_rate == this_rate) {
 			sdata->bss->max_ratectrl_rateidx = i;
 			if (rate->fixed)
 				sdata->bss->force_unicast_rateidx = i;
-			return 0;
+			err = 0;
+			break;
 		}
 	}
-	return -EINVAL;
+	return err;
 }
 
 static int ieee80211_ioctl_giwrate(struct net_device *dev,
@@ -603,18 +600,24 @@ static int ieee80211_ioctl_giwrate(struc
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_supported_band *sband;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type == IEEE80211_IF_TYPE_STA)
 		sta = sta_info_get(local, sdata->u.sta.bssid);
 	else
 		return -EOPNOTSUPP;
 	if (!sta)
 		return -ENODEV;
-	if (sta->txrate < local->oper_hw_mode->num_rates)
-		rate->value = local->oper_hw_mode->rates[sta->txrate].rate * 100000;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	if (sta->txrate_idx < sband->n_bitrates)
+		rate->value = sband->bitrates[sta->txrate_idx].bitrate;
 	else
 		rate->value = 0;
+	rate->value *= 100000;
 	sta_info_put(sta);
 	return 0;
 }
@@ -625,7 +628,7 @@ static int ieee80211_ioctl_siwtxpower(st
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	bool need_reconfig = 0;
-	u8 new_power_level;
+	int new_power_level;
 
 	if ((data->txpower.flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM)
 		return -EINVAL;
@@ -635,13 +638,15 @@ static int ieee80211_ioctl_siwtxpower(st
 	if (data->txpower.fixed) {
 		new_power_level = data->txpower.value;
 	} else {
-		/* Automatic power level. Get the px power from the current
-		 * channel. */
-		struct ieee80211_channel* chan = local->oper_channel;
+		/*
+		 * Automatic power level. Use maximum power for the current
+		 * channel. Should be part of rate control.
+		 */
+		struct ieee80211_channel* chan = local->hw.conf.channel;
 		if (!chan)
 			return -EINVAL;
 
-		new_power_level = chan->power_level;
+		new_power_level = chan->max_power;
 	}
 
 	if (local->hw.conf.power_level != new_power_level) {
--- everything.orig/net/mac80211/ieee80211_rate.h	2008-01-24 19:34:49.443586535 +0100
+++ everything/net/mac80211/ieee80211_rate.h	2008-01-24 19:35:11.603586752 +0100
@@ -18,6 +18,7 @@
 #include "ieee80211_i.h"
 #include "sta_info.h"
 
+/* TODO: kdoc */
 struct rate_selection {
 	/* Selected transmission rate */
 	struct ieee80211_rate *rate;
@@ -34,7 +35,8 @@ struct rate_control_ops {
 			  struct sk_buff *skb,
 			  struct ieee80211_tx_status *status);
 	void (*get_rate)(void *priv, struct net_device *dev,
-			 struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			 struct ieee80211_supported_band *band,
+			 struct sk_buff *skb,
 			 struct rate_selection *sel);
 	void (*rate_init)(void *priv, void *priv_sta,
 			  struct ieee80211_local *local, struct sta_info *sta);
@@ -66,7 +68,8 @@ void ieee80211_rate_control_unregister(s
 struct rate_control_ref *rate_control_alloc(const char *name,
 					    struct ieee80211_local *local);
 void rate_control_get_rate(struct net_device *dev,
-			   struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			   struct ieee80211_supported_band *sband,
+			   struct sk_buff *skb,
 			   struct rate_selection *sel);
 struct rate_control_ref *rate_control_get(struct rate_control_ref *ref);
 void rate_control_put(struct rate_control_ref *ref);
@@ -127,23 +130,23 @@ static inline void rate_control_remove_s
 #endif
 }
 
-static inline int
-rate_supported(struct sta_info *sta, struct ieee80211_hw_mode *mode, int index)
+static inline int rate_supported(struct sta_info *sta,
+				 enum ieee80211_band band,
+				 int index)
 {
-	return (sta == NULL || sta->supp_rates & BIT(index)) &&
-	       (mode->rates[index].flags & IEEE80211_RATE_SUPPORTED);
+	return (sta == NULL || sta->supp_rates[band] & BIT(index));
 }
 
 static inline int
-rate_lowest_index(struct ieee80211_local *local, struct ieee80211_hw_mode *mode,
+rate_lowest_index(struct ieee80211_local *local,
+		  struct ieee80211_supported_band *sband,
 		  struct sta_info *sta)
 {
 	int i;
 
-	for (i = 0; i < mode->num_rates; i++) {
-		if (rate_supported(sta, mode, i))
+	for (i = 0; i < sband->n_bitrates; i++)
+		if (rate_supported(sta, sband->band, i))
 			return i;
-	}
 
 	/* warn when we cannot find a rate. */
 	WARN_ON(1);
@@ -152,10 +155,11 @@ rate_lowest_index(struct ieee80211_local
 }
 
 static inline struct ieee80211_rate *
-rate_lowest(struct ieee80211_local *local, struct ieee80211_hw_mode *mode,
+rate_lowest(struct ieee80211_local *local,
+	    struct ieee80211_supported_band *sband,
 	    struct sta_info *sta)
 {
-	return &mode->rates[rate_lowest_index(local, mode, sta)];
+	return &sband->bitrates[rate_lowest_index(local, sband, sta)];
 }
 
 
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-01-24 19:34:49.563586752 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-01-24 19:35:11.613586209 +0100
@@ -74,7 +74,7 @@
 static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
 				     u8 *ssid, size_t ssid_len);
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel,
+ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len);
 static void ieee80211_rx_bss_put(struct net_device *dev,
 				 struct ieee80211_sta_bss *bss);
@@ -466,7 +466,7 @@ static void ieee80211_set_associated(str
 			return;
 
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
-					   local->hw.conf.channel,
+					   local->hw.conf.channel->center_freq,
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
 			if (bss->has_erp_value)
@@ -592,7 +592,6 @@ static void ieee80211_send_assoc(struct 
 				 struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hw_mode *mode;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, *ies;
@@ -600,6 +599,7 @@ static void ieee80211_send_assoc(struct 
 	u16 capab;
 	struct ieee80211_sta_bss *bss;
 	int wmm = 0;
+	struct ieee80211_supported_band *sband;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
 			    sizeof(*mgmt) + 200 + ifsta->extra_ie_len +
@@ -611,13 +611,19 @@ static void ieee80211_send_assoc(struct 
 	}
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 
-	mode = local->oper_hw_mode;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
 	capab = ifsta->capab;
-	if (mode->mode == MODE_IEEE80211G) {
-		capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME |
-			WLAN_CAPABILITY_SHORT_PREAMBLE;
+
+	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ) {
+		if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
+			capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
+		if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE))
+			capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
 	}
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel,
+
+	bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+				   local->hw.conf.channel->center_freq,
 				   ifsta->ssid, ifsta->ssid_len);
 	if (bss) {
 		if (bss->capability & WLAN_CAPABILITY_PRIVACY)
@@ -656,23 +662,23 @@ static void ieee80211_send_assoc(struct 
 	*pos++ = ifsta->ssid_len;
 	memcpy(pos, ifsta->ssid, ifsta->ssid_len);
 
-	len = mode->num_rates;
+	len = sband->n_bitrates;
 	if (len > 8)
 		len = 8;
 	pos = skb_put(skb, len + 2);
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos++ = len;
 	for (i = 0; i < len; i++) {
-		int rate = mode->rates[i].rate;
+		int rate = sband->bitrates[i].bitrate;
 		*pos++ = (u8) (rate / 5);
 	}
 
-	if (mode->num_rates > len) {
-		pos = skb_put(skb, mode->num_rates - len + 2);
+	if (sband->n_bitrates > len) {
+		pos = skb_put(skb, sband->n_bitrates - len + 2);
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
-		*pos++ = mode->num_rates - len;
-		for (i = len; i < mode->num_rates; i++) {
-			int rate = mode->rates[i].rate;
+		*pos++ = sband->n_bitrates - len;
+		for (i = len; i < sband->n_bitrates; i++) {
+			int rate = sband->bitrates[i].bitrate;
 			*pos++ = (u8) (rate / 5);
 		}
 	}
@@ -695,17 +701,18 @@ static void ieee80211_send_assoc(struct 
 		*pos++ = 0;
 	}
 	/* wmm support is a must to HT */
-	if (wmm && mode->ht_info.ht_supported) {
-		__le16 tmp = cpu_to_le16(mode->ht_info.cap);
+	if (wmm && sband->ht_info.ht_supported) {
+		__le16 tmp = cpu_to_le16(sband->ht_info.cap);
 		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap)+2);
 		*pos++ = WLAN_EID_HT_CAPABILITY;
 		*pos++ = sizeof(struct ieee80211_ht_cap);
 		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
 		memcpy(pos, &tmp, sizeof(u16));
 		pos += sizeof(u16);
-		*pos++ = (mode->ht_info.ampdu_factor |
-				(mode->ht_info.ampdu_density << 2));
-		memcpy(pos, mode->ht_info.supp_mcs_set, 16);
+		/* TODO: needs a define here for << 2 */
+		*pos++ = sband->ht_info.ampdu_factor |
+			 (sband->ht_info.ampdu_density << 2);
+		memcpy(pos, sband->ht_info.supp_mcs_set, 16);
 	}
 
 	kfree(ifsta->assocreq_ies);
@@ -788,7 +795,8 @@ static int ieee80211_privacy_mismatch(st
 	if (!ifsta || (ifsta->flags & IEEE80211_STA_MIXED_CELL))
 		return 0;
 
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel,
+	bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+				   local->hw.conf.channel->center_freq,
 				   ifsta->ssid, ifsta->ssid_len);
 	if (!bss)
 		return 0;
@@ -898,7 +906,7 @@ static void ieee80211_send_probe_req(str
 				     u8 *ssid, size_t ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, *supp_rates, *esupp_rates = NULL;
@@ -932,11 +940,10 @@ static void ieee80211_send_probe_req(str
 	supp_rates = skb_put(skb, 2);
 	supp_rates[0] = WLAN_EID_SUPP_RATES;
 	supp_rates[1] = 0;
-	mode = local->oper_hw_mode;
-	for (i = 0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *rate = &mode->rates[i];
-		if (!(rate->flags & IEEE80211_RATE_SUPPORTED))
-			continue;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		struct ieee80211_rate *rate = &sband->bitrates[i];
 		if (esupp_rates) {
 			pos = skb_put(skb, 1);
 			esupp_rates[1]++;
@@ -949,7 +956,7 @@ static void ieee80211_send_probe_req(str
 			pos = skb_put(skb, 1);
 			supp_rates[1]++;
 		}
-		*pos = rate->rate / 5;
+		*pos = rate->bitrate / 5;
 	}
 
 	ieee80211_sta_tx(dev, skb, 0);
@@ -1093,9 +1100,11 @@ static void ieee80211_sta_process_addba_
 	}
 	/* determine default buffer size */
 	if (buf_size == 0) {
-		struct ieee80211_hw_mode *mode = conf->mode;
+		struct ieee80211_supported_band *sband;
+
+		sband = local->hw.wiphy->bands[conf->channel->band];
 		buf_size = IEEE80211_MIN_AMPDU_BUF;
-		buf_size = buf_size << mode->ht_info.ampdu_factor;
+		buf_size = buf_size << sband->ht_info.ampdu_factor;
 	}
 
 	tid_agg_rx = &sta->ampdu_mlme.tid_rx[tid];
@@ -1535,15 +1544,16 @@ static void ieee80211_rx_mgmt_assoc_resp
 {
 	struct ieee80211_local *local = sdata->local;
 	struct net_device *dev = sdata->dev;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
-	u32 rates;
+	u64 rates, basic_rates;
 	u16 capab_info, status_code, aid;
 	struct ieee802_11_elems elems;
 	struct ieee80211_bss_conf *bss_conf = &sdata->bss_conf;
 	u8 *pos;
 	int i, j;
 	DECLARE_MAC_BUF(mac);
+	bool have_higher_than_11mbit = false;
 
 	/* AssocResp and ReassocResp have identical structure, so process both
 	 * of them in this function. */
@@ -1613,10 +1623,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 	if (ifsta->assocresp_ies)
 		memcpy(ifsta->assocresp_ies, pos, ifsta->assocresp_ies_len);
 
-	/* set AID, ieee80211_set_associated() will tell the driver */
-	bss_conf->aid = aid;
-	ieee80211_set_associated(dev, ifsta, 1);
-
 	/* Add STA entry for the AP */
 	sta = sta_info_get(local, ifsta->bssid);
 	if (!sta) {
@@ -1628,7 +1634,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 			return;
 		}
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
-					   local->hw.conf.channel,
+					   local->hw.conf.channel->center_freq,
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
 			sta->last_rssi = bss->rssi;
@@ -1642,20 +1648,46 @@ static void ieee80211_rx_mgmt_assoc_resp
 	sta->flags |= WLAN_STA_AUTH | WLAN_STA_ASSOC | WLAN_STA_ASSOC_AP;
 
 	rates = 0;
-	mode = local->oper_hw_mode;
+	basic_rates = 0;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
 	for (i = 0; i < elems.supp_rates_len; i++) {
 		int rate = (elems.supp_rates[i] & 0x7f) * 5;
-		for (j = 0; j < mode->num_rates; j++)
-			if (mode->rates[j].rate == rate)
+
+		if (rate > 110)
+			have_higher_than_11mbit = true;
+
+		for (j = 0; j < sband->n_bitrates; j++) {
+			if (sband->bitrates[j].bitrate == rate)
 				rates |= BIT(j);
+			if (elems.supp_rates[i] & 0x80)
+				basic_rates |= BIT(j);
+		}
 	}
+
 	for (i = 0; i < elems.ext_supp_rates_len; i++) {
 		int rate = (elems.ext_supp_rates[i] & 0x7f) * 5;
-		for (j = 0; j < mode->num_rates; j++)
-			if (mode->rates[j].rate == rate)
+
+		if (rate > 110)
+			have_higher_than_11mbit = true;
+
+		for (j = 0; j < sband->n_bitrates; j++) {
+			if (sband->bitrates[j].bitrate == rate)
 				rates |= BIT(j);
+			if (elems.ext_supp_rates[i] & 0x80)
+				basic_rates |= BIT(j);
+		}
 	}
-	sta->supp_rates = rates;
+
+	sta->supp_rates[local->hw.conf.channel->band] = rates;
+	sdata->basic_rates = basic_rates;
+
+	/* cf. IEEE 802.11 9.2.12 */
+	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
+	    have_higher_than_11mbit)
+		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
+	else
+		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
 	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param &&
 	    local->ops->conf_ht) {
@@ -1678,6 +1710,9 @@ static void ieee80211_rx_mgmt_assoc_resp
 					 elems.wmm_param_len);
 	}
 
+	/* set AID, ieee80211_set_associated() will tell the driver */
+	bss_conf->aid = aid;
+	ieee80211_set_associated(dev, ifsta, 1);
 
 	sta_info_put(sta);
 
@@ -1718,7 +1753,7 @@ static void __ieee80211_rx_bss_hash_del(
 
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid, int channel,
+ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -1730,7 +1765,7 @@ ieee80211_rx_bss_add(struct net_device *
 	atomic_inc(&bss->users);
 	atomic_inc(&bss->users);
 	memcpy(bss->bssid, bssid, ETH_ALEN);
-	bss->channel = channel;
+	bss->freq = freq;
 	if (ssid && ssid_len <= IEEE80211_MAX_SSID_LEN) {
 		memcpy(bss->ssid, ssid, ssid_len);
 		bss->ssid_len = ssid_len;
@@ -1746,7 +1781,7 @@ ieee80211_rx_bss_add(struct net_device *
 
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel,
+ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -1756,7 +1791,7 @@ ieee80211_rx_bss_get(struct net_device *
 	bss = local->sta_bss_hash[STA_HASH(bssid)];
 	while (bss) {
 		if (!memcmp(bss->bssid, bssid, ETH_ALEN) &&
-		    bss->channel == channel &&
+		    bss->freq == freq &&
 		    bss->ssid_len == ssid_len &&
 		    (ssid_len == 0 || !memcmp(bss->ssid, ssid, ssid_len))) {
 			atomic_inc(&bss->users);
@@ -1821,7 +1856,7 @@ static void ieee80211_rx_bss_info(struct
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee802_11_elems elems;
 	size_t baselen;
-	int channel, clen;
+	int freq, clen;
 	struct ieee80211_sta_bss *bss;
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1872,26 +1907,22 @@ static void ieee80211_rx_bss_info(struct
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0 &&
 	    (sta = sta_info_get(local, mgmt->sa))) {
-		struct ieee80211_hw_mode *mode;
-		struct ieee80211_rate *rates;
+		struct ieee80211_supported_band *sband;
+		struct ieee80211_rate *bitrates;
 		size_t num_rates;
-		u32 supp_rates, prev_rates;
+		u64 supp_rates, prev_rates;
 		int i, j;
 
-		mode = local->sta_sw_scanning ?
-		       local->scan_hw_mode : local->oper_hw_mode;
-
-		if (local->sta_hw_scanning) {
-			/* search for the correct mode matches the beacon */
-			list_for_each_entry(mode, &local->modes_list, list)
-				if (mode->mode == rx_status->phymode)
-					break;
+		sband = local->hw.wiphy->bands[rx_status->band];
 
-			if (mode == NULL)
-				mode = local->oper_hw_mode;
+		if (!sband) {
+			WARN_ON(1);
+			sband = local->hw.wiphy->bands[
+					local->hw.conf.channel->band];
 		}
-		rates = mode->rates;
-		num_rates = mode->num_rates;
+
+		bitrates = sband->bitrates;
+		num_rates = sband->n_bitrates;
 
 		supp_rates = 0;
 		for (i = 0; i < elems.supp_rates_len +
@@ -1905,24 +1936,27 @@ static void ieee80211_rx_bss_info(struct
 					[i - elems.supp_rates_len];
 			own_rate = 5 * (rate & 0x7f);
 			for (j = 0; j < num_rates; j++)
-				if (rates[j].rate == own_rate)
+				if (bitrates[j].bitrate == own_rate)
 					supp_rates |= BIT(j);
 		}
 
-		prev_rates = sta->supp_rates;
-		sta->supp_rates &= supp_rates;
-		if (sta->supp_rates == 0) {
+		prev_rates = sta->supp_rates[rx_status->band];
+		sta->supp_rates[rx_status->band] &= supp_rates;
+		if (sta->supp_rates[rx_status->band] == 0) {
 			/* No matching rates - this should not really happen.
 			 * Make sure that at least one rate is marked
 			 * supported to avoid issues with TX rate ctrl. */
-			sta->supp_rates = sdata->u.sta.supp_rates_bits;
+			sta->supp_rates[rx_status->band] =
+				sdata->u.sta.supp_rates_bits[rx_status->band];
 		}
-		if (sta->supp_rates != prev_rates) {
+		if (sta->supp_rates[rx_status->band] != prev_rates) {
 			printk(KERN_DEBUG "%s: updated supp_rates set for "
-			       "%s based on beacon info (0x%x & 0x%x -> "
-			       "0x%x)\n",
-			       dev->name, print_mac(mac, sta->addr), prev_rates,
-			       supp_rates, sta->supp_rates);
+			       "%s based on beacon info (0x%llx & 0x%llx -> "
+			       "0x%llx)\n",
+			       dev->name, print_mac(mac, sta->addr),
+			       (unsigned long long) prev_rates,
+			       (unsigned long long) supp_rates,
+			       (unsigned long long) sta->supp_rates[rx_status->band]);
 		}
 		sta_info_put(sta);
 	}
@@ -1931,14 +1965,14 @@ static void ieee80211_rx_bss_info(struct
 		return;
 
 	if (elems.ds_params && elems.ds_params_len == 1)
-		channel = elems.ds_params[0];
+		freq = ieee80211_channel_to_frequency(elems.ds_params[0]);
 	else
-		channel = rx_status->channel;
+		freq = rx_status->freq;
 
-	bss = ieee80211_rx_bss_get(dev, mgmt->bssid, channel,
+	bss = ieee80211_rx_bss_get(dev, mgmt->bssid, freq,
 				   elems.ssid, elems.ssid_len);
 	if (!bss) {
-		bss = ieee80211_rx_bss_add(dev, mgmt->bssid, channel,
+		bss = ieee80211_rx_bss_add(dev, mgmt->bssid, freq,
 					   elems.ssid, elems.ssid_len);
 		if (!bss)
 			return;
@@ -1951,6 +1985,8 @@ static void ieee80211_rx_bss_info(struct
 #endif
 	}
 
+	bss->band = rx_status->band;
+
 	if (bss->probe_resp && beacon) {
 		/* Do not allow beacon to override data from Probe Response. */
 		ieee80211_rx_bss_put(dev, bss);
@@ -2049,20 +2085,6 @@ static void ieee80211_rx_bss_info(struct
 		bss->ht_ie_len = 0;
 	}
 
-	bss->hw_mode = rx_status->phymode;
-	bss->freq = rx_status->freq;
-	if (channel != rx_status->channel &&
-	    (bss->hw_mode == MODE_IEEE80211G ||
-	     bss->hw_mode == MODE_IEEE80211B) &&
-	    channel >= 1 && channel <= 14) {
-		static const int freq_list[] = {
-			2412, 2417, 2422, 2427, 2432, 2437, 2442,
-			2447, 2452, 2457, 2462, 2467, 2472, 2484
-		};
-		/* IEEE 802.11g/b mode can receive packets from neighboring
-		 * channels, so map the channel into frequency. */
-		bss->freq = freq_list[channel - 1];
-	}
 	bss->timestamp = timestamp;
 	bss->last_update = jiffies;
 	bss->rssi = rx_status->ssi;
@@ -2628,7 +2650,7 @@ static int ieee80211_sta_config_auth(str
 	}
 
 	spin_lock_bh(&local->sta_bss_lock);
-	freq = local->oper_channel->freq;
+	freq = local->oper_channel->center_freq;
 	list_for_each_entry(bss, &local->sta_bss_list, list) {
 		if (!(bss->capability & WLAN_CAPABILITY_ESS))
 			continue;
@@ -2659,7 +2681,7 @@ static int ieee80211_sta_config_auth(str
 	spin_unlock_bh(&local->sta_bss_lock);
 
 	if (selected) {
-		ieee80211_set_channel(local, -1, selected->freq);
+		ieee80211_set_freq(local, selected->freq);
 		if (!(ifsta->flags & IEEE80211_STA_SSID_SET))
 			ieee80211_sta_set_ssid(dev, selected->ssid,
 					       selected->ssid_len);
@@ -2692,10 +2714,12 @@ static int ieee80211_sta_join_ibss(struc
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_tx_control control;
-	struct ieee80211_hw_mode *mode;
 	struct rate_selection ratesel;
 	u8 *pos;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_supported_band *sband;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	/* Remove possible STA entries from other IBSS networks. */
 	sta_info_flush(local, NULL);
@@ -2715,12 +2739,11 @@ static int ieee80211_sta_join_ibss(struc
 	sdata->drop_unencrypted = bss->capability &
 		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	res = ieee80211_set_channel(local, -1, bss->freq);
+	res = ieee80211_set_freq(local, bss->freq);
 
-	if (!(local->oper_channel->flag & IEEE80211_CHAN_W_IBSS)) {
-		printk(KERN_DEBUG "%s: IBSS not allowed on channel %d "
-		       "(%d MHz)\n", dev->name, local->hw.conf.channel,
-		       local->hw.conf.freq);
+	if (local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS) {
+		printk(KERN_DEBUG "%s: IBSS not allowed on frequency "
+		       "%d MHz\n", dev->name, local->oper_channel->center_freq);
 		return -1;
 	}
 
@@ -2757,10 +2780,12 @@ static int ieee80211_sta_join_ibss(struc
 		*pos++ = rates;
 		memcpy(pos, bss->supp_rates, rates);
 
-		pos = skb_put(skb, 2 + 1);
-		*pos++ = WLAN_EID_DS_PARAMS;
-		*pos++ = 1;
-		*pos++ = bss->channel;
+		if (bss->band == IEEE80211_BAND_2GHZ) {
+			pos = skb_put(skb, 2 + 1);
+			*pos++ = WLAN_EID_DS_PARAMS;
+			*pos++ = 1;
+			*pos++ = ieee80211_frequency_to_channel(bss->freq);
+		}
 
 		pos = skb_put(skb, 2 + 2);
 		*pos++ = WLAN_EID_IBSS_PARAMS;
@@ -2778,19 +2803,18 @@ static int ieee80211_sta_join_ibss(struc
 		}
 
 		memset(&control, 0, sizeof(control));
-		rate_control_get_rate(dev, local->oper_hw_mode, skb, &ratesel);
+		rate_control_get_rate(dev, sband, skb, &ratesel);
 		if (!ratesel.rate) {
 			printk(KERN_DEBUG "%s: Failed to determine TX rate "
 			       "for IBSS beacon\n", dev->name);
 			break;
 		}
 		control.vif = &sdata->vif;
-		control.tx_rate =
-			(sdata->bss_conf.use_short_preamble &&
-			(ratesel.rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
-			ratesel.rate->val2 : ratesel.rate->val;
+		control.tx_rate = ratesel.rate;
+		if (sdata->bss_conf.use_short_preamble &&
+		    ratesel.rate->flags & IEEE80211_RATE_SHORT_PREAMBLE)
+			control.flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
 		control.antenna_sel_tx = local->hw.conf.antenna_sel_tx;
-		control.power_level = local->hw.conf.power_level;
 		control.flags |= IEEE80211_TXCTL_NO_ACK;
 		control.retry_limit = 1;
 
@@ -2815,14 +2839,14 @@ static int ieee80211_sta_join_ibss(struc
 		}
 
 		rates = 0;
-		mode = local->oper_hw_mode;
+		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 		for (i = 0; i < bss->supp_rates_len; i++) {
 			int bitrate = (bss->supp_rates[i] & 0x7f) * 5;
-			for (j = 0; j < mode->num_rates; j++)
-				if (mode->rates[j].rate == bitrate)
+			for (j = 0; j < sband->n_bitrates; j++)
+				if (sband->bitrates[j].bitrate == bitrate)
 					rates |= BIT(j);
 		}
-		ifsta->supp_rates_bits = rates;
+		ifsta->supp_rates_bits[local->hw.conf.channel->band] = rates;
 	} while (0);
 
 	if (skb) {
@@ -2846,7 +2870,7 @@ static int ieee80211_sta_create_ibss(str
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	u8 bssid[ETH_ALEN], *pos;
 	int i;
 	DECLARE_MAC_BUF(mac);
@@ -2868,28 +2892,28 @@ static int ieee80211_sta_create_ibss(str
 	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID %s\n",
 	       dev->name, print_mac(mac, bssid));
 
-	bss = ieee80211_rx_bss_add(dev, bssid, local->hw.conf.channel,
+	bss = ieee80211_rx_bss_add(dev, bssid,
+				   local->hw.conf.channel->center_freq,
 				   sdata->u.sta.ssid, sdata->u.sta.ssid_len);
 	if (!bss)
 		return -ENOMEM;
 
-	mode = local->oper_hw_mode;
+	bss->band = local->hw.conf.channel->band;
+	sband = local->hw.wiphy->bands[bss->band];
 
 	if (local->hw.conf.beacon_int == 0)
 		local->hw.conf.beacon_int = 100;
 	bss->beacon_int = local->hw.conf.beacon_int;
-	bss->hw_mode = local->hw.conf.phymode;
-	bss->freq = local->hw.conf.freq;
 	bss->last_update = jiffies;
 	bss->capability = WLAN_CAPABILITY_IBSS;
 	if (sdata->default_key) {
 		bss->capability |= WLAN_CAPABILITY_PRIVACY;
 	} else
 		sdata->drop_unencrypted = 0;
-	bss->supp_rates_len = mode->num_rates;
+	bss->supp_rates_len = sband->n_bitrates;
 	pos = bss->supp_rates;
-	for (i = 0; i < mode->num_rates; i++) {
-		int rate = mode->rates[i].rate;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		int rate = sband->bitrates[i].bitrate;
 		*pos++ = (u8) (rate / 5);
 	}
 
@@ -2938,7 +2962,8 @@ static int ieee80211_sta_find_ibss(struc
 	       "%s\n", print_mac(mac, bssid), print_mac(mac2, ifsta->bssid));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0 &&
-	    (bss = ieee80211_rx_bss_get(dev, bssid, local->hw.conf.channel,
+	    (bss = ieee80211_rx_bss_get(dev, bssid,
+	    				local->hw.conf.channel->center_freq,
 					ifsta->ssid, ifsta->ssid_len))) {
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID %s"
 		       " based on configured SSID\n",
@@ -2966,13 +2991,13 @@ static int ieee80211_sta_find_ibss(struc
 		if (time_after(jiffies, ifsta->ibss_join_req +
 			       IEEE80211_IBSS_JOIN_TIMEOUT)) {
 			if ((ifsta->flags & IEEE80211_STA_CREATE_IBSS) &&
-			    local->oper_channel->flag & IEEE80211_CHAN_W_IBSS)
+			    (!(local->oper_channel->flags &
+			    		IEEE80211_CHAN_NO_IBSS)))
 				return ieee80211_sta_create_ibss(dev, ifsta);
 			if (ifsta->flags & IEEE80211_STA_CREATE_IBSS) {
-				printk(KERN_DEBUG "%s: IBSS not allowed on the"
-				       " configured channel %d (%d MHz)\n",
-				       dev->name, local->hw.conf.channel,
-				       local->hw.conf.freq);
+				printk(KERN_DEBUG "%s: IBSS not allowed on"
+				       " %d MHz\n", dev->name,
+				       local->hw.conf.channel->center_freq);
 			}
 
 			/* No IBSS found - decrease scan interval and continue
@@ -2991,7 +3016,7 @@ static int ieee80211_sta_find_ibss(struc
 
 int ieee80211_sta_set_ssid(struct net_device *dev, char *ssid, size_t len)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
@@ -3005,18 +3030,23 @@ int ieee80211_sta_set_ssid(struct net_de
 		int i;
 
 		memset(&qparam, 0, sizeof(qparam));
-		/* TODO: are these ok defaults for all hw_modes? */
+
 		qparam.aifs = 2;
-		qparam.cw_min =
-			local->hw.conf.phymode == MODE_IEEE80211B ? 31 : 15;
+
+		if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
+		    !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE))
+			qparam.cw_min = 31;
+		else
+			qparam.cw_min = 15;
+
 		qparam.cw_max = 1023;
 		qparam.burst_time = 0;
+
 		for (i = IEEE80211_TX_QUEUE_DATA0; i < NUM_TX_DATA_QUEUES; i++)
-		{
 			local->ops->conf_tx(local_to_hw(local),
 					   i + IEEE80211_TX_QUEUE_DATA0,
 					   &qparam);
-		}
+
 		/* IBSS uses different parameters for Beacon sending */
 		qparam.cw_min++;
 		qparam.cw_min *= 2;
@@ -3025,7 +3055,6 @@ int ieee80211_sta_set_ssid(struct net_de
 				   IEEE80211_TX_QUEUE_BEACON, &qparam);
 	}
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	ifsta = &sdata->u.sta;
 
 	if (ifsta->ssid_len != len || memcmp(ifsta->ssid, ssid, len) != 0)
@@ -3184,7 +3213,7 @@ void ieee80211_sta_scan_work(struct work
 		container_of(work, struct ieee80211_local, scan_work.work);
 	struct net_device *dev = local->scan_dev;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 	int skip;
 	unsigned long next_delay = 0;
@@ -3194,44 +3223,47 @@ void ieee80211_sta_scan_work(struct work
 
 	switch (local->scan_state) {
 	case SCAN_SET_CHANNEL:
-		mode = local->scan_hw_mode;
-		if (local->scan_hw_mode->list.next == &local->modes_list &&
-		    local->scan_channel_idx >= mode->num_channels) {
+		/* get current scan band */
+		if (local->scan_band < IEEE80211_NUM_BANDS)
+			sband = local->hw.wiphy->bands[local->scan_band];
+		else
+			sband = NULL;
+
+		/* if we started at an unsupported one, advance */
+		while (!sband && local->scan_band < IEEE80211_NUM_BANDS) {
+			local->scan_band++;
+			sband = local->hw.wiphy->bands[local->scan_band];
+			local->scan_channel_idx = 0;
+		}
+
+		if (!sband ||
+		    (local->scan_channel_idx >= sband->n_channels &&
+		     local->scan_band >= IEEE80211_NUM_BANDS)) {
 			ieee80211_scan_completed(local_to_hw(local));
 			return;
 		}
-		skip = !(local->enabled_modes & (1 << mode->mode));
-		chan = &mode->channels[local->scan_channel_idx];
-		if (!(chan->flag & IEEE80211_CHAN_W_SCAN) ||
+		skip = 0;
+		chan = &sband->channels[local->scan_channel_idx];
+
+		if (chan->flags & IEEE80211_CHAN_DISABLED ||
 		    (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
-		     !(chan->flag & IEEE80211_CHAN_W_IBSS)) ||
-		    (local->hw_modes & local->enabled_modes &
-		     (1 << MODE_IEEE80211G) && mode->mode == MODE_IEEE80211B))
+		     chan->flags & IEEE80211_CHAN_NO_IBSS))
 			skip = 1;
 
 		if (!skip) {
-#if 0
-			printk(KERN_DEBUG "%s: scan channel %d (%d MHz)\n",
-			       dev->name, chan->chan, chan->freq);
-#endif
-
 			local->scan_channel = chan;
 			if (ieee80211_hw_config(local)) {
-				printk(KERN_DEBUG "%s: failed to set channel "
-				       "%d (%d MHz) for scan\n", dev->name,
-				       chan->chan, chan->freq);
+				printk(KERN_DEBUG "%s: failed to set freq to "
+				       "%d MHz for scan\n", dev->name,
+				       chan->center_freq);
 				skip = 1;
 			}
 		}
 
 		local->scan_channel_idx++;
-		if (local->scan_channel_idx >= local->scan_hw_mode->num_channels) {
-			if (local->scan_hw_mode->list.next != &local->modes_list) {
-				local->scan_hw_mode = list_entry(local->scan_hw_mode->list.next,
-								 struct ieee80211_hw_mode,
-								 list);
-				local->scan_channel_idx = 0;
-			}
+		if (local->scan_channel_idx >= sband->n_channels) {
+			local->scan_band++;
+			local->scan_channel_idx = 0;
 		}
 
 		if (skip)
@@ -3242,13 +3274,14 @@ void ieee80211_sta_scan_work(struct work
 		local->scan_state = SCAN_SEND_PROBE;
 		break;
 	case SCAN_SEND_PROBE:
-		if (local->scan_channel->flag & IEEE80211_CHAN_W_ACTIVE_SCAN) {
-			ieee80211_send_probe_req(dev, NULL, local->scan_ssid,
-						 local->scan_ssid_len);
-			next_delay = IEEE80211_CHANNEL_TIME;
-		} else
-			next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
+		next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
 		local->scan_state = SCAN_SET_CHANNEL;
+
+		if (local->scan_channel->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+			break;
+		ieee80211_send_probe_req(dev, NULL, local->scan_ssid,
+					 local->scan_ssid_len);
+		next_delay = IEEE80211_CHANNEL_TIME;
 		break;
 	}
 
@@ -3323,10 +3356,8 @@ static int ieee80211_sta_start_scan(stru
 	} else
 		local->scan_ssid_len = 0;
 	local->scan_state = SCAN_SET_CHANNEL;
-	local->scan_hw_mode = list_entry(local->modes_list.next,
-					 struct ieee80211_hw_mode,
-					 list);
 	local->scan_channel_idx = 0;
+	local->scan_band = IEEE80211_BAND_2GHZ;
 	local->scan_dev = dev;
 
 	netif_tx_lock_bh(local->mdev);
@@ -3381,9 +3412,6 @@ ieee80211_sta_scan_result(struct net_dev
 		       bss->last_update + IEEE80211_SCAN_RESULT_EXPIRE))
 		return current_ev;
 
-	if (!(local->enabled_modes & (1 << bss->hw_mode)))
-		return current_ev;
-
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWAP;
 	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
@@ -3411,12 +3439,15 @@ ieee80211_sta_scan_result(struct net_dev
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = bss->channel;
-	iwe.u.freq.e = 0;
+	iwe.u.freq.m = bss->freq;
+	iwe.u.freq.e = 6;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
-	iwe.u.freq.m = bss->freq * 100000;
-	iwe.u.freq.e = 1;
+
+	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = SIOCGIWFREQ;
+	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
+	iwe.u.freq.e = 0;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
 
@@ -3559,7 +3590,8 @@ struct sta_info * ieee80211_ibss_add_sta
 	if (!sta)
 		return NULL;
 
-	sta->supp_rates = sdata->u.sta.supp_rates_bits;
+	sta->supp_rates[local->hw.conf.channel->band] =
+		sdata->u.sta.supp_rates_bits[local->hw.conf.channel->band];
 
 	rate_control_rate_init(sta, local);
 
--- everything.orig/net/mac80211/sta_info.c	2008-01-24 19:34:49.653586860 +0100
+++ everything/net/mac80211/sta_info.c	2008-01-24 19:35:11.613586209 +0100
@@ -74,30 +74,6 @@ struct sta_info *sta_info_get(struct iee
 }
 EXPORT_SYMBOL(sta_info_get);
 
-int sta_info_min_txrate_get(struct ieee80211_local *local)
-{
-	struct sta_info *sta;
-	struct ieee80211_hw_mode *mode;
-	int min_txrate = 9999999;
-	int i;
-
-	read_lock_bh(&local->sta_lock);
-	mode = local->oper_hw_mode;
-	for (i = 0; i < STA_HASH_SIZE; i++) {
-		sta = local->sta_hash[i];
-		while (sta) {
-			if (sta->txrate < min_txrate)
-				min_txrate = sta->txrate;
-			sta = sta->hnext;
-		}
-	}
-	read_unlock_bh(&local->sta_lock);
-	if (min_txrate == 9999999)
-		min_txrate = 0;
-
-	return mode->rates[min_txrate].rate;
-}
-
 
 static void sta_info_release(struct kref *kref)
 {
--- everything.orig/net/mac80211/Makefile	2008-01-24 19:34:49.763587511 +0100
+++ everything/net/mac80211/Makefile	2008-01-24 19:35:11.613586209 +0100
@@ -19,7 +19,6 @@ mac80211-y := \
 	ieee80211_iface.o \
 	ieee80211_rate.o \
 	michael.o \
-	regdomain.o \
 	tkip.o \
 	aes_ccm.o \
 	cfg.o \
--- everything.orig/net/mac80211/regdomain.c	2008-01-24 19:34:49.853587132 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,152 +0,0 @@
-/*
- * Copyright 2002-2005, Instant802 Networks, Inc.
- * Copyright 2005-2006, Devicescape Software, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-/*
- * This regulatory domain control implementation is known to be incomplete
- * and confusing. mac80211 regulatory domain control will be significantly
- * reworked in the not-too-distant future.
- *
- * For now, drivers wishing to control which channels are and aren't available
- * are advised as follows:
- *  - set the IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED flag
- *  - continue to include *ALL* possible channels in the modes registered
- *    through ieee80211_register_hwmode()
- *  - for each allowable ieee80211_channel structure registered in the above
- *    call, set the flag member to some meaningful value such as
- *    IEEE80211_CHAN_W_SCAN | IEEE80211_CHAN_W_ACTIVE_SCAN |
- *    IEEE80211_CHAN_W_IBSS.
- *  - leave flag as 0 for non-allowable channels
- *
- * The usual implementation is for a driver to read a device EEPROM to
- * determine which regulatory domain it should be operating under, then
- * looking up the allowable channels in a driver-local table, then performing
- * the above.
- */
-
-#include <linux/module.h>
-#include <linux/netdevice.h>
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
-
-static int ieee80211_regdom = 0x10; /* FCC */
-module_param(ieee80211_regdom, int, 0444);
-MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain; 64=MKK");
-
-/*
- * If firmware is upgraded by the vendor, additional channels can be used based
- * on the new Japanese regulatory rules. This is indicated by setting
- * ieee80211_japan_5ghz module parameter to one when loading the 80211 kernel
- * module.
- */
-static int ieee80211_japan_5ghz /* = 0 */;
-module_param(ieee80211_japan_5ghz, int, 0444);
-MODULE_PARM_DESC(ieee80211_japan_5ghz, "Vendor-updated firmware for 5 GHz");
-
-
-struct ieee80211_channel_range {
-	short start_freq;
-	short end_freq;
-	unsigned char power_level;
-	unsigned char antenna_max;
-};
-
-static const struct ieee80211_channel_range ieee80211_fcc_channels[] = {
-	{ 2412, 2462, 27, 6 } /* IEEE 802.11b/g, channels 1..11 */,
-	{ 5180, 5240, 17, 6 } /* IEEE 802.11a, channels 36..48 */,
-	{ 5260, 5320, 23, 6 } /* IEEE 802.11a, channels 52..64 */,
-	{ 5745, 5825, 30, 6 } /* IEEE 802.11a, channels 149..165, outdoor */,
-	{ 0 }
-};
-
-static const struct ieee80211_channel_range ieee80211_mkk_channels[] = {
-	{ 2412, 2472, 20, 6 } /* IEEE 802.11b/g, channels 1..13 */,
-	{ 5170, 5240, 20, 6 } /* IEEE 802.11a, channels 34..48 */,
-	{ 5260, 5320, 20, 6 } /* IEEE 802.11a, channels 52..64 */,
-	{ 0 }
-};
-
-
-static const struct ieee80211_channel_range *channel_range =
-	ieee80211_fcc_channels;
-
-
-static void ieee80211_unmask_channel(int mode, struct ieee80211_channel *chan)
-{
-	int i;
-
-	chan->flag = 0;
-
-	for (i = 0; channel_range[i].start_freq; i++) {
-		const struct ieee80211_channel_range *r = &channel_range[i];
-		if (r->start_freq <= chan->freq && r->end_freq >= chan->freq) {
-			if (ieee80211_regdom == 64 && !ieee80211_japan_5ghz &&
-			    chan->freq >= 5260 && chan->freq <= 5320) {
-				/*
-				 * Skip new channels in Japan since the
-				 * firmware was not marked having been upgraded
-				 * by the vendor.
-				 */
-				continue;
-			}
-
-			if (ieee80211_regdom == 0x10 &&
-			    (chan->freq == 5190 || chan->freq == 5210 ||
-			     chan->freq == 5230)) {
-				    /* Skip MKK channels when in FCC domain. */
-				    continue;
-			}
-
-			chan->flag |= IEEE80211_CHAN_W_SCAN |
-				IEEE80211_CHAN_W_ACTIVE_SCAN |
-				IEEE80211_CHAN_W_IBSS;
-			chan->power_level = r->power_level;
-			chan->antenna_max = r->antenna_max;
-
-			if (ieee80211_regdom == 64 &&
-			    (chan->freq == 5170 || chan->freq == 5190 ||
-			     chan->freq == 5210 || chan->freq == 5230)) {
-				/*
-				 * New regulatory rules in Japan have backwards
-				 * compatibility with old channels in 5.15-5.25
-				 * GHz band, but the station is not allowed to
-				 * use active scan on these old channels.
-				 */
-				chan->flag &= ~IEEE80211_CHAN_W_ACTIVE_SCAN;
-			}
-
-			if (ieee80211_regdom == 64 &&
-			    (chan->freq == 5260 || chan->freq == 5280 ||
-			     chan->freq == 5300 || chan->freq == 5320)) {
-				/*
-				 * IBSS is not allowed on 5.25-5.35 GHz band
-				 * due to radar detection requirements.
-				 */
-				chan->flag &= ~IEEE80211_CHAN_W_IBSS;
-			}
-
-			break;
-		}
-	}
-}
-
-
-void ieee80211_set_default_regdomain(struct ieee80211_hw_mode *mode)
-{
-	int c;
-	for (c = 0; c < mode->num_channels; c++)
-		ieee80211_unmask_channel(mode->mode, &mode->channels[c]);
-}
-
-
-void ieee80211_regdomain_init(void)
-{
-	if (ieee80211_regdom == 0x40)
-		channel_range = ieee80211_mkk_channels;
-}
-
--- everything.orig/net/mac80211/rx.c	2008-01-24 19:35:10.923586969 +0100
+++ everything/net/mac80211/rx.c	2008-01-24 19:35:11.623586209 +0100
@@ -82,10 +82,10 @@ static inline int should_drop_frame(stru
  */
 static struct sk_buff *
 ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
-		     struct ieee80211_rx_status *status)
+		     struct ieee80211_rx_status *status,
+		     struct ieee80211_rate *rate)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_rate *rate;
 	int needed_headroom = 0;
 	struct ieee80211_radiotap_header *rthdr;
 	__le64 *rttsft = NULL;
@@ -194,14 +194,11 @@ ieee80211_rx_monitor(struct ieee80211_lo
 			rtfixed->rx_flags |=
 				cpu_to_le16(IEEE80211_RADIOTAP_F_RX_BADFCS);
 
-		rate = ieee80211_get_rate(local, status->phymode,
-					  status->rate);
-		if (rate)
-			rtfixed->rate = rate->rate / 5;
+		rtfixed->rate = rate->bitrate / 5;
 
 		rtfixed->chan_freq = cpu_to_le16(status->freq);
 
-		if (status->phymode == MODE_IEEE80211A)
+		if (status->band == IEEE80211_BAND_5GHZ)
 			rtfixed->chan_flags =
 				cpu_to_le16(IEEE80211_CHAN_OFDM |
 					    IEEE80211_CHAN_5GHZ);
@@ -296,34 +293,21 @@ ieee80211_rx_h_parse_qos(struct ieee8021
 
 
 static u32 ieee80211_rx_load_stats(struct ieee80211_local *local,
-			      struct sk_buff *skb,
-			      struct ieee80211_rx_status *status)
+				   struct sk_buff *skb,
+				   struct ieee80211_rx_status *status,
+				   struct ieee80211_rate *rate)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u32 load = 0, hdrtime;
-	struct ieee80211_rate *rate;
-	struct ieee80211_hw_mode *mode = local->hw.conf.mode;
-	int i;
 
 	/* Estimate total channel use caused by this frame */
 
-	if (unlikely(mode->num_rates < 0))
-		return TXRX_CONTINUE;
-
-	rate = &mode->rates[0];
-	for (i = 0; i < mode->num_rates; i++) {
-		if (mode->rates[i].val == status->rate) {
-			rate = &mode->rates[i];
-			break;
-		}
-	}
-
 	/* 1 bit at 1 Mbit/s takes 1 usec; in channel_use values,
 	 * 1 usec = 1/8 * (1080 / 10) = 13.5 */
 
-	if (mode->mode == MODE_IEEE80211A ||
-	    (mode->mode == MODE_IEEE80211G &&
-	     rate->flags & IEEE80211_RATE_ERP))
+	if (status->band == IEEE80211_BAND_5GHZ ||
+	    (status->band == IEEE80211_BAND_5GHZ &&
+	     rate->flags & IEEE80211_RATE_ERP_G))
 		hdrtime = CHAN_UTIL_HDR_SHORT;
 	else
 		hdrtime = CHAN_UTIL_HDR_LONG;
@@ -332,7 +316,8 @@ static u32 ieee80211_rx_load_stats(struc
 	if (!is_multicast_ether_addr(hdr->addr1))
 		load += hdrtime;
 
-	load += skb->len * rate->rate_inv;
+	/* TODO: optimise again */
+	load += skb->len * CHAN_UTIL_RATE_LCM / rate->bitrate;
 
 	/* Divide channel_use by 8 to avoid wrapping around the counter */
 	load >>= CHAN_UTIL_SHIFT;
@@ -1700,7 +1685,8 @@ static int prepare_for_handlers(struct i
 static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					 struct sk_buff *skb,
 					 struct ieee80211_rx_status *status,
-					 u32 load)
+					 u32 load,
+					 struct ieee80211_rate *rate)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -1720,6 +1706,7 @@ static void __ieee80211_rx_handle_packet
 
 	rx.u.rx.status = status;
 	rx.u.rx.load = load;
+	rx.u.rx.rate = rate;
 	rx.fc = le16_to_cpu(hdr->frame_control);
 	type = rx.fc & IEEE80211_FCTL_FTYPE;
 
@@ -1852,6 +1839,8 @@ u8 ieee80211_sta_manage_reorder_buf(stru
 	u16 head_seq_num, buf_size;
 	int index;
 	u32 pkt_load;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *rate;
 
 	buf_size = tid_agg_rx->buf_size;
 	head_seq_num = tid_agg_rx->head_seq_num;
@@ -1882,12 +1871,14 @@ u8 ieee80211_sta_manage_reorder_buf(stru
 				memcpy(&status,
 					tid_agg_rx->reorder_buf[index]->cb,
 					sizeof(status));
+				sband = local->hw.wiphy->bands[status.band];
+				rate = &sband->bitrates[status.rate_idx];
 				pkt_load = ieee80211_rx_load_stats(local,
 						tid_agg_rx->reorder_buf[index],
-						&status);
+						&status, rate);
 				__ieee80211_rx_handle_packet(hw,
 					tid_agg_rx->reorder_buf[index],
-					&status, pkt_load);
+					&status, pkt_load, rate);
 				tid_agg_rx->stored_mpdu_num--;
 				tid_agg_rx->reorder_buf[index] = NULL;
 			}
@@ -1927,11 +1918,13 @@ u8 ieee80211_sta_manage_reorder_buf(stru
 		/* release the reordered frame back to stack */
 		memcpy(&status, tid_agg_rx->reorder_buf[index]->cb,
 			sizeof(status));
+		sband = local->hw.wiphy->bands[status.band];
+		rate = &sband->bitrates[status.rate_idx];
 		pkt_load = ieee80211_rx_load_stats(local,
 					tid_agg_rx->reorder_buf[index],
-					&status);
+					&status, rate);
 		__ieee80211_rx_handle_packet(hw, tid_agg_rx->reorder_buf[index],
-						&status, pkt_load);
+					     &status, pkt_load, rate);
 		tid_agg_rx->stored_mpdu_num--;
 		tid_agg_rx->reorder_buf[index] = NULL;
 		tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
@@ -2012,6 +2005,25 @@ void __ieee80211_rx(struct ieee80211_hw 
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	u32 pkt_load;
+	struct ieee80211_rate *rate = NULL;
+	struct ieee80211_supported_band *sband;
+
+	if (status->band < 0 ||
+	    status->band > IEEE80211_NUM_BANDS) {
+		WARN_ON(1);
+		return;
+	}
+
+	sband = local->hw.wiphy->bands[status->band];
+
+	if (!sband ||
+	    status->rate_idx < 0 ||
+	    status->rate_idx >= sband->n_bitrates) {
+		WARN_ON(1);
+		return;
+	}
+
+	rate = &sband->bitrates[status->rate_idx];
 
 	/*
 	 * key references and virtual interfaces are protected using RCU
@@ -2026,17 +2038,17 @@ void __ieee80211_rx(struct ieee80211_hw 
 	 * if it was previously present.
 	 * Also, frames with less than 16 bytes are dropped.
 	 */
-	skb = ieee80211_rx_monitor(local, skb, status);
+	skb = ieee80211_rx_monitor(local, skb, status, rate);
 	if (!skb) {
 		rcu_read_unlock();
 		return;
 	}
 
-	pkt_load = ieee80211_rx_load_stats(local, skb, status);
+	pkt_load = ieee80211_rx_load_stats(local, skb, status, rate);
 	local->channel_use_raw += pkt_load;
 
 	if (!ieee80211_rx_reorder_ampdu(local, skb))
-		__ieee80211_rx_handle_packet(hw, skb, status, pkt_load);
+		__ieee80211_rx_handle_packet(hw, skb, status, pkt_load, rate);
 
 	rcu_read_unlock();
 }
--- everything.orig/net/mac80211/tx.c	2008-01-24 19:34:50.063588000 +0100
+++ everything/net/mac80211/tx.c	2008-01-24 19:35:11.633591255 +0100
@@ -92,9 +92,13 @@ static u16 ieee80211_duration(struct iee
 	int rate, mrate, erp, dur, i;
 	struct ieee80211_rate *txrate = tx->u.tx.rate;
 	struct ieee80211_local *local = tx->local;
-	struct ieee80211_hw_mode *mode = tx->u.tx.mode;
+	struct ieee80211_supported_band *sband;
 
-	erp = txrate->flags & IEEE80211_RATE_ERP;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	erp = 0;
+	if (tx->sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+		erp = txrate->flags & IEEE80211_RATE_ERP_G;
 
 	/*
 	 * data and mgmt (except PS Poll):
@@ -150,20 +154,36 @@ static u16 ieee80211_duration(struct iee
 	 * Mandatory rates for IEEE 802.11g PHY: 1, 2, 5.5, 11, 6, 12, 24 Mbps
 	 */
 	rate = -1;
-	mrate = 10; /* use 1 Mbps if everything fails */
-	for (i = 0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *r = &mode->rates[i];
-		if (r->rate > txrate->rate)
+	/* use lowest available if everything fails */
+	mrate = sband->bitrates[0].bitrate;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		struct ieee80211_rate *r = &sband->bitrates[i];
+
+		if (r->bitrate > txrate->bitrate)
 			break;
 
-		if (IEEE80211_RATE_MODULATION(txrate->flags) !=
-		    IEEE80211_RATE_MODULATION(r->flags))
-			continue;
+		if (tx->sdata->basic_rates & BIT(i))
+			rate = r->bitrate;
 
-		if (r->flags & IEEE80211_RATE_BASIC)
-			rate = r->rate;
-		else if (r->flags & IEEE80211_RATE_MANDATORY)
-			mrate = r->rate;
+		switch (sband->band) {
+		case IEEE80211_BAND_2GHZ: {
+			u32 flag;
+			if (tx->sdata->flags & IEEE80211_SDATA_OPERATING_GMODE)
+				flag = IEEE80211_RATE_MANDATORY_G;
+			else
+				flag = IEEE80211_RATE_MANDATORY_B;
+			if (r->flags & flag)
+				mrate = r->bitrate;
+			break;
+		}
+		case IEEE80211_BAND_5GHZ:
+			if (r->flags & IEEE80211_RATE_MANDATORY_A)
+				mrate = r->bitrate;
+			break;
+		case IEEE80211_NUM_BANDS:
+			WARN_ON(1);
+			break;
+		}
 	}
 	if (rate == -1) {
 		/* No matching basic rate found; use highest suitable mandatory
@@ -184,7 +204,7 @@ static u16 ieee80211_duration(struct iee
 		dur *= 2; /* ACK + SIFS */
 		/* next fragment */
 		dur += ieee80211_frame_duration(local, next_frag_len,
-				txrate->rate, erp,
+				txrate->bitrate, erp,
 				tx->sdata->bss_conf.use_short_preamble);
 	}
 
@@ -585,26 +605,28 @@ static ieee80211_txrx_result
 ieee80211_tx_h_rate_ctrl(struct ieee80211_txrx_data *tx)
 {
 	struct rate_selection rsel;
+	struct ieee80211_supported_band *sband;
+
+	sband = tx->local->hw.wiphy->bands[tx->local->hw.conf.channel->band];
 
 	if (likely(!tx->u.tx.rate)) {
-		rate_control_get_rate(tx->dev, tx->u.tx.mode, tx->skb, &rsel);
+		rate_control_get_rate(tx->dev, sband, tx->skb, &rsel);
 		tx->u.tx.rate = rsel.rate;
-		if (unlikely(rsel.probe != NULL)) {
+		if (unlikely(rsel.probe)) {
 			tx->u.tx.control->flags |=
 				IEEE80211_TXCTL_RATE_CTRL_PROBE;
 			tx->flags |= IEEE80211_TXRXD_TXPROBE_LAST_FRAG;
-			tx->u.tx.control->alt_retry_rate = tx->u.tx.rate->val;
+			tx->u.tx.control->alt_retry_rate = tx->u.tx.rate;
 			tx->u.tx.rate = rsel.probe;
 		} else
-			tx->u.tx.control->alt_retry_rate = -1;
+			tx->u.tx.control->alt_retry_rate = NULL;
 
 		if (!tx->u.tx.rate)
 			return TXRX_DROP;
 	} else
-		tx->u.tx.control->alt_retry_rate = -1;
+		tx->u.tx.control->alt_retry_rate = NULL;
 
-	if (tx->u.tx.mode->mode == MODE_IEEE80211G &&
-	    tx->sdata->bss_conf.use_cts_prot &&
+	if (tx->sdata->bss_conf.use_cts_prot &&
 	    (tx->flags & IEEE80211_TXRXD_FRAGMENTED) && rsel.nonerp) {
 		tx->u.tx.last_frag_rate = tx->u.tx.rate;
 		if (rsel.probe)
@@ -612,13 +634,13 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 		else
 			tx->flags |= IEEE80211_TXRXD_TXPROBE_LAST_FRAG;
 		tx->u.tx.rate = rsel.nonerp;
-		tx->u.tx.control->rate = rsel.nonerp;
+		tx->u.tx.control->tx_rate = rsel.nonerp;
 		tx->u.tx.control->flags &= ~IEEE80211_TXCTL_RATE_CTRL_PROBE;
 	} else {
 		tx->u.tx.last_frag_rate = tx->u.tx.rate;
-		tx->u.tx.control->rate = tx->u.tx.rate;
+		tx->u.tx.control->tx_rate = tx->u.tx.rate;
 	}
-	tx->u.tx.control->tx_rate = tx->u.tx.rate->val;
+	tx->u.tx.control->tx_rate = tx->u.tx.rate;
 
 	return TXRX_CONTINUE;
 }
@@ -630,7 +652,6 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 	u16 fc = le16_to_cpu(hdr->frame_control);
 	u16 dur;
 	struct ieee80211_tx_control *control = tx->u.tx.control;
-	struct ieee80211_hw_mode *mode = tx->u.tx.mode;
 
 	if (!control->retry_limit) {
 		if (!is_multicast_ether_addr(hdr->addr1)) {
@@ -657,14 +678,14 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 		 * frames.
 		 * TODO: The last fragment could still use multiple retry
 		 * rates. */
-		control->alt_retry_rate = -1;
+		control->alt_retry_rate = NULL;
 	}
 
 	/* Use CTS protection for unicast frames sent using extended rates if
 	 * there are associated non-ERP stations and RTS/CTS is not configured
 	 * for the frame. */
-	if (mode->mode == MODE_IEEE80211G &&
-	    (tx->u.tx.rate->flags & IEEE80211_RATE_ERP) &&
+	if ((tx->sdata->flags & IEEE80211_SDATA_OPERATING_GMODE) &&
+	    (tx->u.tx.rate->flags & IEEE80211_RATE_ERP_G) &&
 	    (tx->flags & IEEE80211_TXRXD_TXUNICAST) &&
 	    tx->sdata->bss_conf.use_cts_prot &&
 	    !(control->flags & IEEE80211_TXCTL_USE_RTS_CTS))
@@ -674,10 +695,10 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 	 * short preambles at the selected rate and short preambles are
 	 * available on the network at the current point in time. */
 	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
-	    (tx->u.tx.rate->flags & IEEE80211_RATE_PREAMBLE2) &&
+	    (tx->u.tx.rate->flags & IEEE80211_RATE_SHORT_PREAMBLE) &&
 	    tx->sdata->bss_conf.use_short_preamble &&
 	    (!tx->sta || (tx->sta->flags & WLAN_STA_SHORT_PREAMBLE))) {
-		tx->u.tx.control->tx_rate = tx->u.tx.rate->val2;
+		tx->u.tx.control->flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
 	}
 
 	/* Setup duration field for the first fragment of the frame. Duration
@@ -690,19 +711,33 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 
 	if ((control->flags & IEEE80211_TXCTL_USE_RTS_CTS) ||
 	    (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)) {
-		struct ieee80211_rate *rate;
+		struct ieee80211_supported_band *sband;
+		struct ieee80211_rate *rate, *baserate;
+		int idx;
+
+		sband = tx->local->hw.wiphy->bands[
+				tx->local->hw.conf.channel->band];
 
 		/* Do not use multiple retry rates when using RTS/CTS */
-		control->alt_retry_rate = -1;
+		control->alt_retry_rate = NULL;
 
 		/* Use min(data rate, max base rate) as CTS/RTS rate */
 		rate = tx->u.tx.rate;
-		while (rate > mode->rates &&
-		       !(rate->flags & IEEE80211_RATE_BASIC))
-			rate--;
+		baserate = NULL;
 
-		control->rts_cts_rate = rate->val;
-		control->rts_rate = rate;
+		for (idx = 0; idx < sband->n_bitrates; idx++) {
+			if (sband->bitrates[idx].bitrate > rate->bitrate)
+				continue;
+			if (tx->sdata->basic_rates & BIT(idx) &&
+			    (!baserate ||
+			     (baserate->bitrate < sband->bitrates[idx].bitrate)))
+				baserate = &sband->bitrates[idx];
+		}
+
+		if (baserate)
+			control->rts_cts_rate = baserate;
+		else
+			control->rts_cts_rate = &sband->bitrates[0];
 	}
 
 	if (tx->sta) {
@@ -726,10 +761,10 @@ static ieee80211_txrx_result
 ieee80211_tx_h_load_stats(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_local *local = tx->local;
-	struct ieee80211_hw_mode *mode = tx->u.tx.mode;
 	struct sk_buff *skb = tx->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u32 load = 0, hdrtime;
+	struct ieee80211_rate *rate = tx->u.tx.rate;
 
 	/* TODO: this could be part of tx_status handling, so that the number
 	 * of retries would be known; TX rate should in that case be stored
@@ -740,9 +775,9 @@ ieee80211_tx_h_load_stats(struct ieee802
 	/* 1 bit at 1 Mbit/s takes 1 usec; in channel_use values,
 	 * 1 usec = 1/8 * (1080 / 10) = 13.5 */
 
-	if (mode->mode == MODE_IEEE80211A ||
-	    (mode->mode == MODE_IEEE80211G &&
-	     tx->u.tx.rate->flags & IEEE80211_RATE_ERP))
+	if (tx->u.tx.channel->band == IEEE80211_BAND_5GHZ ||
+	    (tx->u.tx.channel->band == IEEE80211_BAND_2GHZ &&
+	     rate->flags & IEEE80211_RATE_ERP_G))
 		hdrtime = CHAN_UTIL_HDR_SHORT;
 	else
 		hdrtime = CHAN_UTIL_HDR_LONG;
@@ -756,14 +791,15 @@ ieee80211_tx_h_load_stats(struct ieee802
 	else if (tx->u.tx.control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
 		load += hdrtime;
 
-	load += skb->len * tx->u.tx.rate->rate_inv;
+	/* TODO: optimise again */
+	load += skb->len * CHAN_UTIL_RATE_LCM / rate->bitrate;
 
 	if (tx->u.tx.extra_frag) {
 		int i;
 		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
 			load += 2 * hdrtime;
 			load += tx->u.tx.extra_frag[i]->len *
-				tx->u.tx.rate->rate;
+				tx->u.tx.rate->bitrate;
 		}
 	}
 
@@ -816,10 +852,12 @@ __ieee80211_parse_tx_radiotap(struct iee
 	struct ieee80211_radiotap_iterator iterator;
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
-	struct ieee80211_hw_mode *mode = tx->local->hw.conf.mode;
+	struct ieee80211_supported_band *sband;
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len);
 	struct ieee80211_tx_control *control = tx->u.tx.control;
 
+	sband = tx->local->hw.wiphy->bands[tx->local->hw.conf.channel->band];
+
 	control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 	tx->flags |= IEEE80211_TXRXD_TX_INJECTED;
 	tx->flags &= ~IEEE80211_TXRXD_FRAGMENTED;
@@ -852,10 +890,12 @@ __ieee80211_parse_tx_radiotap(struct iee
 			 * ieee80211 rate int is in 100kbps units eg, 0x0a=1Mbps
 			 */
 			target_rate = (*iterator.this_arg) * 5;
-			for (i = 0; i < mode->num_rates; i++) {
-				struct ieee80211_rate *r = &mode->rates[i];
+			for (i = 0; i < sband->n_bitrates; i++) {
+				struct ieee80211_rate *r;
 
-				if (r->rate == target_rate) {
+				r = &sband->bitrates[i];
+
+				if (r->bitrate == target_rate) {
 					tx->u.tx.rate = r;
 					break;
 				}
@@ -870,9 +910,11 @@ __ieee80211_parse_tx_radiotap(struct iee
 			control->antenna_sel_tx = (*iterator.this_arg) + 1;
 			break;
 
+#if 0
 		case IEEE80211_RADIOTAP_DBM_TX_POWER:
 			control->power_level = *iterator.this_arg;
 			break;
+#endif
 
 		case IEEE80211_RADIOTAP_FLAGS:
 			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FCS) {
@@ -1054,8 +1096,8 @@ static int __ieee80211_tx(struct ieee802
 			if (__ieee80211_queue_stopped(local, control->queue))
 				return IEEE80211_TX_FRAG_AGAIN;
 			if (i == tx->u.tx.num_extra_frag) {
-				control->tx_rate = tx->u.tx.last_frag_hwrate;
-				control->rate = tx->u.tx.last_frag_rate;
+				control->tx_rate = tx->u.tx.last_frag_rate;
+
 				if (tx->flags & IEEE80211_TXRXD_TXPROBE_LAST_FRAG)
 					control->flags |=
 						IEEE80211_TXCTL_RATE_CTRL_PROBE;
@@ -1114,7 +1156,7 @@ static int ieee80211_tx(struct net_devic
 	rcu_read_lock();
 
 	sta = tx.sta;
-	tx.u.tx.mode = local->hw.conf.mode;
+	tx.u.tx.channel = local->hw.conf.channel;
 
 	for (handler = local->tx_handlers; *handler != NULL;
 	     handler++) {
@@ -1151,7 +1193,6 @@ static int ieee80211_tx(struct net_devic
 			} else {
 				next_len = 0;
 				tx.u.tx.rate = tx.u.tx.last_frag_rate;
-				tx.u.tx.last_frag_hwrate = tx.u.tx.rate->val;
 			}
 			dur = ieee80211_duration(&tx, 0, next_len);
 			hdr->duration_id = cpu_to_le16(dur);
@@ -1188,7 +1229,6 @@ retry:
 		store->skb = skb;
 		store->extra_frag = tx.u.tx.extra_frag;
 		store->num_extra_frag = tx.u.tx.num_extra_frag;
-		store->last_frag_hwrate = tx.u.tx.last_frag_hwrate;
 		store->last_frag_rate = tx.u.tx.last_frag_rate;
 		store->last_frag_rate_ctrl_probe =
 			!!(tx.flags & IEEE80211_TXRXD_TXPROBE_LAST_FRAG);
@@ -1598,7 +1638,6 @@ void ieee80211_tx_pending(unsigned long 
 		tx.u.tx.control = &store->control;
 		tx.u.tx.extra_frag = store->extra_frag;
 		tx.u.tx.num_extra_frag = store->num_extra_frag;
-		tx.u.tx.last_frag_hwrate = store->last_frag_hwrate;
 		tx.u.tx.last_frag_rate = store->last_frag_rate;
 		tx.flags = 0;
 		if (store->last_frag_rate_ctrl_probe)
@@ -1701,6 +1740,9 @@ struct sk_buff *ieee80211_beacon_get(str
 	struct ieee80211_if_ap *ap = NULL;
 	struct rate_selection rsel;
 	struct beacon_data *beacon;
+	struct ieee80211_supported_band *sband;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	rcu_read_lock();
 
@@ -1739,8 +1781,7 @@ struct sk_buff *ieee80211_beacon_get(str
 		       beacon->tail_len);
 
 	if (control) {
-		rate_control_get_rate(local->mdev, local->oper_hw_mode, skb,
-				      &rsel);
+		rate_control_get_rate(local->mdev, sband, skb, &rsel);
 		if (!rsel.rate) {
 			if (net_ratelimit()) {
 				printk(KERN_DEBUG "%s: ieee80211_beacon_get: "
@@ -1753,12 +1794,11 @@ struct sk_buff *ieee80211_beacon_get(str
 		}
 
 		control->vif = vif;
-		control->tx_rate =
-			(sdata->bss_conf.use_short_preamble &&
-			(rsel.rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
-			rsel.rate->val2 : rsel.rate->val;
+		control->tx_rate = rsel.rate;
+		if (sdata->bss_conf.use_short_preamble &&
+		    rsel.rate->flags & IEEE80211_RATE_SHORT_PREAMBLE)
+			control->flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
 		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
-		control->power_level = local->hw.conf.power_level;
 		control->flags |= IEEE80211_TXCTL_NO_ACK;
 		control->retry_limit = 1;
 		control->flags |= IEEE80211_TXCTL_CLEAR_DST_MASK;
@@ -1863,7 +1903,7 @@ ieee80211_get_buffered_bc(struct ieee802
 	}
 	sta = tx.sta;
 	tx.flags |= IEEE80211_TXRXD_TXPS_BUFFERED;
-	tx.u.tx.mode = local->hw.conf.mode;
+	tx.u.tx.channel = local->hw.conf.channel;
 
 	for (handler = local->tx_handlers; *handler != NULL; handler++) {
 		res = (*handler)(&tx);
--- everything.orig/net/mac80211/debugfs.c	2008-01-24 19:34:50.113587566 +0100
+++ everything/net/mac80211/debugfs.c	2008-01-24 19:35:11.633591255 +0100
@@ -19,41 +19,6 @@ int mac80211_open_file_generic(struct in
 	return 0;
 }
 
-static const char *ieee80211_mode_str(int mode)
-{
-	switch (mode) {
-	case MODE_IEEE80211A:
-		return "IEEE 802.11a";
-	case MODE_IEEE80211B:
-		return "IEEE 802.11b";
-	case MODE_IEEE80211G:
-		return "IEEE 802.11g";
-	default:
-		return "UNKNOWN";
-	}
-}
-
-static ssize_t modes_read(struct file *file, char __user *userbuf,
-			  size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-	struct ieee80211_hw_mode *mode;
-	char buf[150], *p = buf;
-
-	/* FIXME: locking! */
-	list_for_each_entry(mode, &local->modes_list, list) {
-		p += scnprintf(p, sizeof(buf)+buf-p,
-			       "%s\n", ieee80211_mode_str(mode->mode));
-	}
-
-	return simple_read_from_buffer(userbuf, count, ppos, buf, p-buf);
-}
-
-static const struct file_operations modes_ops = {
-	.read = modes_read,
-	.open = mac80211_open_file_generic,
-};
-
 #define DEBUGFS_READONLY_FILE(name, buflen, fmt, value...)		\
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
@@ -80,10 +45,8 @@ static const struct file_operations name
 	local->debugfs.name = NULL;
 
 
-DEBUGFS_READONLY_FILE(channel, 20, "%d",
-		      local->hw.conf.channel);
 DEBUGFS_READONLY_FILE(frequency, 20, "%d",
-		      local->hw.conf.freq);
+		      local->hw.conf.channel->center_freq);
 DEBUGFS_READONLY_FILE(antenna_sel_tx, 20, "%d",
 		      local->hw.conf.antenna_sel_tx);
 DEBUGFS_READONLY_FILE(antenna_sel_rx, 20, "%d",
@@ -100,8 +63,6 @@ DEBUGFS_READONLY_FILE(long_retry_limit, 
 		      local->long_retry_limit);
 DEBUGFS_READONLY_FILE(total_ps_buffered, 20, "%d",
 		      local->total_ps_buffered);
-DEBUGFS_READONLY_FILE(mode, 20, "%s",
-		      ieee80211_mode_str(local->hw.conf.phymode));
 DEBUGFS_READONLY_FILE(wep_iv, 20, "%#06x",
 		      local->wep_iv & 0xffffff);
 DEBUGFS_READONLY_FILE(rate_ctrl_alg, 100, "%s",
@@ -294,7 +255,6 @@ void debugfs_hw_add(struct ieee80211_loc
 	local->debugfs.stations = debugfs_create_dir("stations", phyd);
 	local->debugfs.keys = debugfs_create_dir("keys", phyd);
 
-	DEBUGFS_ADD(channel);
 	DEBUGFS_ADD(frequency);
 	DEBUGFS_ADD(antenna_sel_tx);
 	DEBUGFS_ADD(antenna_sel_rx);
@@ -304,9 +264,7 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_ADD(short_retry_limit);
 	DEBUGFS_ADD(long_retry_limit);
 	DEBUGFS_ADD(total_ps_buffered);
-	DEBUGFS_ADD(mode);
 	DEBUGFS_ADD(wep_iv);
-	DEBUGFS_ADD(modes);
 
 	statsd = debugfs_create_dir("statistics", phyd);
 	local->debugfs.statistics = statsd;
@@ -356,7 +314,6 @@ void debugfs_hw_add(struct ieee80211_loc
 
 void debugfs_hw_del(struct ieee80211_local *local)
 {
-	DEBUGFS_DEL(channel);
 	DEBUGFS_DEL(frequency);
 	DEBUGFS_DEL(antenna_sel_tx);
 	DEBUGFS_DEL(antenna_sel_rx);
@@ -366,9 +323,7 @@ void debugfs_hw_del(struct ieee80211_loc
 	DEBUGFS_DEL(short_retry_limit);
 	DEBUGFS_DEL(long_retry_limit);
 	DEBUGFS_DEL(total_ps_buffered);
-	DEBUGFS_DEL(mode);
 	DEBUGFS_DEL(wep_iv);
-	DEBUGFS_DEL(modes);
 
 	DEBUGFS_STATS_DEL(transmitted_fragment_count);
 	DEBUGFS_STATS_DEL(multicast_transmitted_frame_count);
--- everything.orig/net/mac80211/debugfs_sta.c	2008-01-24 19:34:50.163586209 +0100
+++ everything/net/mac80211/debugfs_sta.c	2008-01-24 19:35:11.633591255 +0100
@@ -33,22 +33,6 @@ static ssize_t sta_ ##name## _read(struc
 #define STA_READ_LU(name, field) STA_READ(name, 20, field, "%lu\n")
 #define STA_READ_S(name, field) STA_READ(name, 20, field, "%s\n")
 
-#define STA_READ_RATE(name, field)					\
-static ssize_t sta_##name##_read(struct file *file,			\
-				 char __user *userbuf,			\
-				 size_t count, loff_t *ppos)		\
-{									\
-	struct sta_info *sta = file->private_data;			\
-	struct ieee80211_local *local = wdev_priv(sta->dev->ieee80211_ptr);\
-	struct ieee80211_hw_mode *mode = local->oper_hw_mode;		\
-	char buf[20];							\
-	int res = scnprintf(buf, sizeof(buf), "%d\n",			\
-			    (sta->field >= 0 &&				\
-			    sta->field < mode->num_rates) ?		\
-			    mode->rates[sta->field].rate : -1);		\
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
-}
-
 #define STA_OPS(name)							\
 static const struct file_operations sta_ ##name## _ops = {		\
 	.read = sta_##name##_read,					\
@@ -70,8 +54,6 @@ STA_FILE(rx_fragments, rx_fragments, LU)
 STA_FILE(rx_dropped, rx_dropped, LU);
 STA_FILE(tx_fragments, tx_fragments, LU);
 STA_FILE(tx_filtered, tx_filtered_count, LU);
-STA_FILE(txrate, txrate, RATE);
-STA_FILE(last_txrate, last_txrate, RATE);
 STA_FILE(tx_retry_failed, tx_retry_failed, LU);
 STA_FILE(tx_retry_count, tx_retry_count, LU);
 STA_FILE(last_rssi, last_rssi, D);
--- everything.orig/net/mac80211/rc80211_simple.c	2008-01-24 19:34:50.183587674 +0100
+++ everything/net/mac80211/rc80211_simple.c	2008-01-24 19:35:11.643585721 +0100
@@ -35,8 +35,8 @@ static void rate_control_rate_inc(struct
 				  struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_hw_mode *mode;
-	int i = sta->txrate;
+	struct ieee80211_supported_band *sband;
+	int i = sta->txrate_idx;
 	int maxrate;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
@@ -45,18 +45,17 @@ static void rate_control_rate_inc(struct
 		return;
 	}
 
-	mode = local->oper_hw_mode;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	maxrate = sdata->bss ? sdata->bss->max_ratectrl_rateidx : -1;
 
-	if (i > mode->num_rates)
-		i = mode->num_rates - 2;
+	if (i > sband->n_bitrates)
+		i = sband->n_bitrates - 2;
 
-	while (i + 1 < mode->num_rates) {
+	while (i + 1 < sband->n_bitrates) {
 		i++;
-		if (sta->supp_rates & BIT(i) &&
-		    mode->rates[i].flags & IEEE80211_RATE_SUPPORTED &&
+		if (rate_supported(sta, sband->band, i) &&
 		    (maxrate < 0 || i <= maxrate)) {
-			sta->txrate = i;
+			sta->txrate_idx = i;
 			break;
 		}
 	}
@@ -67,8 +66,8 @@ static void rate_control_rate_dec(struct
 				  struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_hw_mode *mode;
-	int i = sta->txrate;
+	struct ieee80211_supported_band *sband;
+	int i = sta->txrate_idx;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
@@ -76,15 +75,14 @@ static void rate_control_rate_dec(struct
 		return;
 	}
 
-	mode = local->oper_hw_mode;
-	if (i > mode->num_rates)
-		i = mode->num_rates;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	if (i > sband->n_bitrates)
+		i = sband->n_bitrates;
 
 	while (i > 0) {
 		i--;
-		if (sta->supp_rates & BIT(i) &&
-		    mode->rates[i].flags & IEEE80211_RATE_SUPPORTED) {
-			sta->txrate = i;
+		if (rate_supported(sta, sband->band, i)) {
+			sta->txrate_idx = i;
 			break;
 		}
 	}
@@ -168,7 +166,7 @@ static void rate_control_simple_tx_statu
 		} else if (per_failed < RATE_CONTROL_NUM_UP) {
 			rate_control_rate_inc(local, sta);
 		}
-		srctrl->tx_avg_rate_sum += status->control.rate->rate;
+		srctrl->tx_avg_rate_sum += status->control.tx_rate->bitrate;
 		srctrl->tx_avg_rate_num++;
 		srctrl->tx_num_failures = 0;
 		srctrl->tx_num_xmit = 0;
@@ -201,7 +199,7 @@ static void rate_control_simple_tx_statu
 
 static void
 rate_control_simple_get_rate(void *priv, struct net_device *dev,
-			     struct ieee80211_hw_mode *mode,
+			     struct ieee80211_supported_band *sband,
 			     struct sk_buff *skb,
 			     struct rate_selection *sel)
 {
@@ -219,7 +217,7 @@ rate_control_simple_get_rate(void *priv,
 	fc = le16_to_cpu(hdr->frame_control);
 	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
 	    is_multicast_ether_addr(hdr->addr1) || !sta) {
-		sel->rate = rate_lowest(local, mode, sta);
+		sel->rate = rate_lowest(local, sband, sta);
 		if (sta)
 			sta_info_put(sta);
 		return;
@@ -228,18 +226,18 @@ rate_control_simple_get_rate(void *priv,
 	/* If a forced rate is in effect, select it. */
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
-		sta->txrate = sdata->bss->force_unicast_rateidx;
+		sta->txrate_idx = sdata->bss->force_unicast_rateidx;
 
-	rateidx = sta->txrate;
+	rateidx = sta->txrate_idx;
 
-	if (rateidx >= mode->num_rates)
-		rateidx = mode->num_rates - 1;
+	if (rateidx >= sband->n_bitrates)
+		rateidx = sband->n_bitrates - 1;
 
-	sta->last_txrate = rateidx;
+	sta->last_txrate_idx = rateidx;
 
 	sta_info_put(sta);
 
-	sel->rate = &mode->rates[rateidx];
+	sel->rate = &sband->bitrates[rateidx];
 }
 
 
@@ -247,21 +245,15 @@ static void rate_control_simple_rate_ini
 					  struct ieee80211_local *local,
 					  struct sta_info *sta)
 {
-	struct ieee80211_hw_mode *mode;
-	int i;
-	sta->txrate = 0;
-	mode = local->oper_hw_mode;
+	struct ieee80211_supported_band *sband;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
 	/* TODO: This routine should consider using RSSI from previous packets
 	 * as we need to have IEEE 802.1X auth succeed immediately after assoc..
 	 * Until that method is implemented, we will use the lowest supported rate
 	 * as a workaround, */
-	for (i = 0; i < mode->num_rates; i++) {
-		if ((sta->supp_rates & BIT(i)) &&
-		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED)) {
-			sta->txrate = i;
-			break;
-		}
-	}
+	sta->txrate_idx = rate_lowest_index(local, sband, sta);
 }
 
 
--- everything.orig/net/wireless/core.c	2008-01-24 19:34:50.443586209 +0100
+++ everything/net/wireless/core.c	2008-01-24 19:35:11.643585721 +0100
@@ -232,6 +232,47 @@ int wiphy_register(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *drv = wiphy_to_dev(wiphy);
 	int res;
+	enum ieee80211_band band;
+	struct ieee80211_supported_band *sband;
+	bool have_band = false;
+	int i;
+
+	/* sanity check supported bands/channels */
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		sband = wiphy->bands[band];
+		if (!sband)
+			continue;
+
+		sband->band = band;
+
+		if (!sband->n_channels || !sband->n_bitrates) {
+			WARN_ON(1);
+			return -EINVAL;
+		}
+
+		for (i = 0; i < sband->n_channels; i++) {
+			sband->channels[i].orig_flags =
+				sband->channels[i].flags;
+			sband->channels[i].orig_mag =
+				sband->channels[i].max_antenna_gain;
+			sband->channels[i].orig_mpwr =
+				sband->channels[i].max_power;
+			sband->channels[i].band = band;
+		}
+
+		have_band = true;
+	}
+
+	if (!have_band) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	/* check and set up bitrates */
+	ieee80211_set_bitrate_flags(wiphy);
+
+	/* set up regulatory info */
+	wiphy_update_regulatory(wiphy);
 
 	mutex_lock(&cfg80211_drv_mutex);
 
--- everything.orig/drivers/net/wireless/b43/b43.h	2008-01-24 19:34:50.673586589 +0100
+++ everything/drivers/net/wireless/b43/b43.h	2008-01-24 19:35:11.643585721 +0100
@@ -462,10 +462,6 @@ struct b43_phy {
 	u8 possible_phymodes;
 	/* GMODE bit enabled? */
 	bool gmode;
-	/* Possible ieee80211 subsystem hwmodes for this PHY.
-	 * Which mode is selected, depends on thr GMODE enabled bit */
-#define B43_MAX_PHYHWMODES	2
-	struct ieee80211_hw_mode hwmodes[B43_MAX_PHYHWMODES];
 
 	/* Analog Type */
 	u8 analog;
@@ -721,7 +717,6 @@ struct b43_wldev {
 
 	bool bad_frames_preempt;	/* Use "Bad Frames Preemption" (default off) */
 	bool dfq_valid;		/* Directed frame queue valid (IBSS PS mode, ATIM) */
-	bool short_preamble;	/* TRUE, if short preamble is enabled. */
 	bool short_slot;	/* TRUE, if short slot timing is enabled. */
 	bool radio_hw_enable;	/* saved state of radio hardware enabled state */
 
--- everything.orig/drivers/net/wireless/b43/main.c	2008-01-24 19:34:50.713587728 +0100
+++ everything/drivers/net/wireless/b43/main.c	2008-01-24 19:35:11.653602268 +0100
@@ -93,25 +93,29 @@ MODULE_DEVICE_TABLE(ssb, b43_ssb_tbl);
  * data in there. This data is the same for all devices, so we don't
  * get concurrency issues */
 #define RATETAB_ENT(_rateid, _flags) \
-	{							\
-		.rate	= B43_RATE_TO_BASE100KBPS(_rateid),	\
-		.val	= (_rateid),				\
-		.val2	= (_rateid),				\
-		.flags	= (_flags),				\
+	{								\
+		.bitrate	= B43_RATE_TO_BASE100KBPS(_rateid),	\
+		.hw_value	= (_rateid),				\
+		.flags		= (_flags),				\
 	}
+
+/*
+ * NOTE: When changing this, sync with xmit.c's
+ *	 b43_plcp_get_bitrate_idx_* functions!
+ */
 static struct ieee80211_rate __b43_ratetable[] = {
-	RATETAB_ENT(B43_CCK_RATE_1MB, IEEE80211_RATE_CCK),
-	RATETAB_ENT(B43_CCK_RATE_2MB, IEEE80211_RATE_CCK_2),
-	RATETAB_ENT(B43_CCK_RATE_5MB, IEEE80211_RATE_CCK_2),
-	RATETAB_ENT(B43_CCK_RATE_11MB, IEEE80211_RATE_CCK_2),
-	RATETAB_ENT(B43_OFDM_RATE_6MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43_OFDM_RATE_9MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43_OFDM_RATE_12MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43_OFDM_RATE_18MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43_OFDM_RATE_24MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43_OFDM_RATE_36MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43_OFDM_RATE_48MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43_OFDM_RATE_54MB, IEEE80211_RATE_OFDM),
+	RATETAB_ENT(B43_CCK_RATE_1MB, 0),
+	RATETAB_ENT(B43_CCK_RATE_2MB, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATETAB_ENT(B43_CCK_RATE_5MB, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATETAB_ENT(B43_CCK_RATE_11MB, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATETAB_ENT(B43_OFDM_RATE_6MB, 0),
+	RATETAB_ENT(B43_OFDM_RATE_9MB, 0),
+	RATETAB_ENT(B43_OFDM_RATE_12MB, 0),
+	RATETAB_ENT(B43_OFDM_RATE_18MB, 0),
+	RATETAB_ENT(B43_OFDM_RATE_24MB, 0),
+	RATETAB_ENT(B43_OFDM_RATE_36MB, 0),
+	RATETAB_ENT(B43_OFDM_RATE_48MB, 0),
+	RATETAB_ENT(B43_OFDM_RATE_54MB, 0),
 };
 
 #define b43_a_ratetable		(__b43_ratetable + 4)
@@ -123,14 +127,8 @@ static struct ieee80211_rate __b43_ratet
 
 #define CHANTAB_ENT(_chanid, _freq) \
 	{							\
-		.chan	= (_chanid),				\
-		.freq	= (_freq),				\
-		.val	= (_chanid),				\
-		.flag	= IEEE80211_CHAN_W_SCAN |		\
-			  IEEE80211_CHAN_W_ACTIVE_SCAN |	\
-			  IEEE80211_CHAN_W_IBSS,		\
-		.power_level	= 0xFF,				\
-		.antenna_max	= 0xFF,				\
+		.center_freq	= (_freq),			\
+		.hw_value	= (_chanid),			\
 	}
 static struct ieee80211_channel b43_2ghz_chantable[] = {
 	CHANTAB_ENT(1, 2412),
@@ -148,9 +146,8 @@ static struct ieee80211_channel b43_2ghz
 	CHANTAB_ENT(13, 2472),
 	CHANTAB_ENT(14, 2484),
 };
-#define b43_2ghz_chantable_size	ARRAY_SIZE(b43_2ghz_chantable)
 
-#if 0
+#ifdef NOTYET
 static struct ieee80211_channel b43_5ghz_chantable[] = {
 	CHANTAB_ENT(36, 5180),
 	CHANTAB_ENT(40, 5200),
@@ -166,9 +163,22 @@ static struct ieee80211_channel b43_5ghz
 	CHANTAB_ENT(161, 5805),
 	CHANTAB_ENT(165, 5825),
 };
-#define b43_5ghz_chantable_size	ARRAY_SIZE(b43_5ghz_chantable)
+
+static struct ieee80211_supported_band b43_band_5GHz = {
+	.channels = b43_5ghz_chantable,
+	.n_channels = ARRAY_SIZE(b43_5ghz_chantable),
+	.bitrates = b43_a_ratetable,
+	.n_bitrates = b43_a_ratetable_size,
+};
 #endif
 
+static struct ieee80211_supported_band b43_band_2GHz = {
+	.channels = b43_2ghz_chantable,
+	.n_channels = ARRAY_SIZE(b43_2ghz_chantable),
+	.bitrates = b43_g_ratetable,
+	.n_bitrates = b43_g_ratetable_size,
+};
+
 static void b43_wireless_core_exit(struct b43_wldev *dev);
 static int b43_wireless_core_init(struct b43_wldev *dev);
 static void b43_wireless_core_stop(struct b43_wldev *dev);
@@ -1219,17 +1229,18 @@ static void b43_write_beacon_template(st
 }
 
 static void b43_write_probe_resp_plcp(struct b43_wldev *dev,
-				      u16 shm_offset, u16 size, u8 rate)
+				      u16 shm_offset, u16 size,
+				      struct ieee80211_rate *rate)
 {
 	struct b43_plcp_hdr4 plcp;
 	u32 tmp;
 	__le16 dur;
 
 	plcp.data = 0;
-	b43_generate_plcp_hdr(&plcp, size + FCS_LEN, rate);
+	b43_generate_plcp_hdr(&plcp, size + FCS_LEN, rate->hw_value);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
 					       dev->wl->vif, size,
-					       B43_RATE_TO_BASE100KBPS(rate));
+					       rate);
 	/* Write PLCP in two parts and timing for packet transfer */
 	tmp = le32_to_cpu(plcp.data);
 	b43_shm_write16(dev, B43_SHM_SHARED, shm_offset, tmp & 0xFFFF);
@@ -1244,7 +1255,8 @@ static void b43_write_probe_resp_plcp(st
  * 3) Stripping TIM
  */
 static const u8 * b43_generate_probe_resp(struct b43_wldev *dev,
-					  u16 *dest_size, u8 rate)
+					  u16 *dest_size,
+					  struct ieee80211_rate *rate)
 {
 	const u8 *src_data;
 	u8 *dest_data;
@@ -1289,7 +1301,7 @@ static const u8 * b43_generate_probe_res
 					 IEEE80211_STYPE_PROBE_RESP);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
 					       dev->wl->vif, *dest_size,
-					       B43_RATE_TO_BASE100KBPS(rate));
+					       rate);
 	hdr->duration_id = dur;
 
 	return dest_data;
@@ -1297,7 +1309,8 @@ static const u8 * b43_generate_probe_res
 
 static void b43_write_probe_resp_template(struct b43_wldev *dev,
 					  u16 ram_offset,
-					  u16 shm_size_offset, u8 rate)
+					  u16 shm_size_offset,
+					  struct ieee80211_rate *rate)
 {
 	const u8 *probe_resp_data;
 	u16 size;
@@ -1310,14 +1323,15 @@ static void b43_write_probe_resp_templat
 	/* Looks like PLCP headers plus packet timings are stored for
 	 * all possible basic rates
 	 */
-	b43_write_probe_resp_plcp(dev, 0x31A, size, B43_CCK_RATE_1MB);
-	b43_write_probe_resp_plcp(dev, 0x32C, size, B43_CCK_RATE_2MB);
-	b43_write_probe_resp_plcp(dev, 0x33E, size, B43_CCK_RATE_5MB);
-	b43_write_probe_resp_plcp(dev, 0x350, size, B43_CCK_RATE_11MB);
+	b43_write_probe_resp_plcp(dev, 0x31A, size, &b43_b_ratetable[0]);
+	b43_write_probe_resp_plcp(dev, 0x32C, size, &b43_b_ratetable[1]);
+	b43_write_probe_resp_plcp(dev, 0x33E, size, &b43_b_ratetable[2]);
+	b43_write_probe_resp_plcp(dev, 0x350, size, &b43_b_ratetable[3]);
 
 	size = min((size_t) size, 0x200 - sizeof(struct b43_plcp_hdr6));
 	b43_write_template_common(dev, probe_resp_data,
-				  size, ram_offset, shm_size_offset, rate);
+				  size, ram_offset, shm_size_offset,
+				  rate->hw_value);
 	kfree(probe_resp_data);
 }
 
@@ -1385,7 +1399,7 @@ static void handle_irq_beacon(struct b43
 			b43_write_beacon_template(dev, 0x68, 0x18,
 						  B43_CCK_RATE_1MB);
 			b43_write_probe_resp_template(dev, 0x268, 0x4A,
-						      B43_CCK_RATE_11MB);
+						      &__b43_ratetable[3]);
 			wl->beacon0_uploaded = 1;
 		}
 		cmd |= B43_MACCMD_BEACON0_VALID;
@@ -2827,14 +2841,11 @@ static int b43_op_config(struct ieee8021
 	mutex_lock(&wl->mutex);
 
 	/* Switch the PHY mode (if necessary). */
-	switch (conf->phymode) {
-	case MODE_IEEE80211A:
+	switch (conf->channel->band) {
+	case IEEE80211_BAND_5GHZ:
 		new_phymode = B43_PHYMODE_A;
 		break;
-	case MODE_IEEE80211B:
-		new_phymode = B43_PHYMODE_B;
-		break;
-	case MODE_IEEE80211G:
+	case IEEE80211_BAND_2GHZ:
 		new_phymode = B43_PHYMODE_G;
 		break;
 	default:
@@ -2860,8 +2871,8 @@ static int b43_op_config(struct ieee8021
 
 	/* Switch to the requested channel.
 	 * The firmware takes care of races with the TX handler. */
-	if (conf->channel_val != phy->channel)
-		b43_radio_selectchannel(dev, conf->channel_val, 0);
+	if (conf->channel->hw_value != phy->channel)
+		b43_radio_selectchannel(dev, conf->channel->hw_value, 0);
 
 	/* Enable/Disable ShortSlot timing. */
 	if ((!!(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME)) !=
@@ -3790,9 +3801,7 @@ static int b43_setup_modes(struct b43_wl
 			   bool have_2ghz_phy, bool have_5ghz_phy)
 {
 	struct ieee80211_hw *hw = dev->wl->hw;
-	struct ieee80211_hw_mode *mode;
 	struct b43_phy *phy = &dev->phy;
-	int err;
 
 	/* XXX: This function will go away soon, when mac80211
 	 *      band stuff is rewritten. So this is just a hack.
@@ -3801,15 +3810,7 @@ static int b43_setup_modes(struct b43_wl
 	 *      This assumption is OK, as any B, N or A PHY will already
 	 *      have died a horrible sanity check death earlier. */
 
-	mode = &phy->hwmodes[0];
-	mode->mode = MODE_IEEE80211G;
-	mode->num_channels = b43_2ghz_chantable_size;
-	mode->channels = b43_2ghz_chantable;
-	mode->num_rates = b43_g_ratetable_size;
-	mode->rates = b43_g_ratetable;
-	err = ieee80211_register_hwmode(hw, mode);
-	if (err)
-		return err;
+	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &b43_band_2GHz;
 	phy->possible_phymodes |= B43_PHYMODE_G;
 
 	return 0;
--- everything.orig/drivers/net/wireless/b43/xmit.c	2008-01-24 19:34:50.763586209 +0100
+++ everything/drivers/net/wireless/b43/xmit.c	2008-01-24 19:35:11.683587403 +0100
@@ -32,46 +32,48 @@
 #include "dma.h"
 
 
-/* Extract the bitrate out of a CCK PLCP header. */
-static u8 b43_plcp_get_bitrate_cck(struct b43_plcp_hdr6 *plcp)
+/* Extract the bitrate index out of a CCK PLCP header. */
+static int b43_plcp_get_bitrate_idx_cck(struct b43_plcp_hdr6 *plcp)
 {
 	switch (plcp->raw[0]) {
 	case 0x0A:
-		return B43_CCK_RATE_1MB;
+		return 0;
 	case 0x14:
-		return B43_CCK_RATE_2MB;
+		return 1;
 	case 0x37:
-		return B43_CCK_RATE_5MB;
+		return 2;
 	case 0x6E:
-		return B43_CCK_RATE_11MB;
+		return 3;
 	}
 	B43_WARN_ON(1);
-	return 0;
+	return -1;
 }
 
-/* Extract the bitrate out of an OFDM PLCP header. */
-static u8 b43_plcp_get_bitrate_ofdm(struct b43_plcp_hdr6 *plcp)
+/* Extract the bitrate index out of an OFDM PLCP header. */
+static u8 b43_plcp_get_bitrate_idx_ofdm(struct b43_plcp_hdr6 *plcp, bool aphy)
 {
+	int base = aphy ? 0 : 4;
+
 	switch (plcp->raw[0] & 0xF) {
 	case 0xB:
-		return B43_OFDM_RATE_6MB;
+		return base + 0;
 	case 0xF:
-		return B43_OFDM_RATE_9MB;
+		return base + 1;
 	case 0xA:
-		return B43_OFDM_RATE_12MB;
+		return base + 2;
 	case 0xE:
-		return B43_OFDM_RATE_18MB;
+		return base + 3;
 	case 0x9:
-		return B43_OFDM_RATE_24MB;
+		return base + 4;
 	case 0xD:
-		return B43_OFDM_RATE_36MB;
+		return base + 5;
 	case 0x8:
-		return B43_OFDM_RATE_48MB;
+		return base + 6;
 	case 0xC:
-		return B43_OFDM_RATE_54MB;
+		return base + 7;
 	}
 	B43_WARN_ON(1);
-	return 0;
+	return -1;
 }
 
 u8 b43_plcp_get_ratecode_cck(const u8 bitrate)
@@ -191,6 +193,7 @@ void b43_generate_txhdr(struct b43_wldev
 	    (const struct ieee80211_hdr *)fragment_data;
 	int use_encryption = (!(txctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT));
 	u16 fctl = le16_to_cpu(wlhdr->frame_control);
+	struct ieee80211_rate *fbrate;
 	u8 rate, rate_fb;
 	int rate_ofdm, rate_fb_ofdm;
 	unsigned int plcp_fragment_len;
@@ -200,9 +203,11 @@ void b43_generate_txhdr(struct b43_wldev
 
 	memset(txhdr, 0, sizeof(*txhdr));
 
-	rate = txctl->tx_rate;
+	WARN_ON(!txctl->tx_rate);
+	rate = txctl->tx_rate ? txctl->tx_rate->hw_value : B43_CCK_RATE_1MB;
 	rate_ofdm = b43_is_ofdm_rate(rate);
-	rate_fb = (txctl->alt_retry_rate == -1) ? rate : txctl->alt_retry_rate;
+	fbrate = txctl->alt_retry_rate ? : txctl->tx_rate;
+	rate_fb = fbrate->hw_value;
 	rate_fb_ofdm = b43_is_ofdm_rate(rate_fb);
 
 	if (rate_ofdm)
@@ -221,11 +226,10 @@ void b43_generate_txhdr(struct b43_wldev
 		 * use the original dur_id field. */
 		txhdr->dur_fb = wlhdr->duration_id;
 	} else {
-		int fbrate_base100kbps = B43_RATE_TO_BASE100KBPS(rate_fb);
 		txhdr->dur_fb = ieee80211_generic_frame_duration(dev->wl->hw,
 								 txctl->vif,
 								 fragment_len,
-								 fbrate_base100kbps);
+								 fbrate);
 	}
 
 	plcp_fragment_len = fragment_len + FCS_LEN;
@@ -279,7 +283,7 @@ void b43_generate_txhdr(struct b43_wldev
 		phy_ctl |= B43_TXH_PHY_ENC_OFDM;
 	else
 		phy_ctl |= B43_TXH_PHY_ENC_CCK;
-	if (dev->short_preamble)
+	if (txctl->flags & IEEE80211_TXCTL_SHORT_PREAMBLE)
 		phy_ctl |= B43_TXH_PHY_SHORTPRMBL;
 
 	switch (b43_ieee80211_antenna_sanitize(dev, txctl->antenna_sel_tx)) {
@@ -324,7 +328,8 @@ void b43_generate_txhdr(struct b43_wldev
 		int rts_rate_ofdm, rts_rate_fb_ofdm;
 		struct b43_plcp_hdr6 *plcp;
 
-		rts_rate = txctl->rts_cts_rate;
+		WARN_ON(!txctl->rts_cts_rate);
+		rts_rate = txctl->rts_cts_rate ? txctl->rts_cts_rate->hw_value : B43_CCK_RATE_1MB;
 		rts_rate_ofdm = b43_is_ofdm_rate(rts_rate);
 		rts_rate_fb = b43_calc_fallback_rate(rts_rate);
 		rts_rate_fb_ofdm = b43_is_ofdm_rate(rts_rate_fb);
@@ -497,6 +502,7 @@ void b43_rx(struct b43_wldev *dev, struc
 	u16 phystat0, phystat3, chanstat, mactime;
 	u32 macstat;
 	u16 chanid;
+	u16 phytype;
 	u8 jssi;
 	int padding;
 
@@ -509,6 +515,7 @@ void b43_rx(struct b43_wldev *dev, struc
 	macstat = le32_to_cpu(rxhdr->mac_status);
 	mactime = le16_to_cpu(rxhdr->mac_time);
 	chanstat = le16_to_cpu(rxhdr->channel);
+	phytype = chanstat & B43_RX_CHAN_PHYTYPE;
 
 	if (macstat & B43_RX_MAC_FCSERR)
 		dev->wl->ieee_stats.dot11FCSErrorCount++;
@@ -566,9 +573,10 @@ void b43_rx(struct b43_wldev *dev, struc
 	/* the next line looks wrong, but is what mac80211 wants */
 	status.signal = (jssi * 100) / B43_RX_MAX_SSI;
 	if (phystat0 & B43_RX_PHYST0_OFDM)
-		status.rate = b43_plcp_get_bitrate_ofdm(plcp);
+		status.rate_idx = b43_plcp_get_bitrate_idx_ofdm(plcp,
+						phytype == B43_PHYTYPE_A);
 	else
-		status.rate = b43_plcp_get_bitrate_cck(plcp);
+		status.rate_idx = b43_plcp_get_bitrate_idx_cck(plcp);
 	status.antenna = !!(phystat0 & B43_RX_PHYST0_ANT);
 
 	/*
@@ -592,29 +600,28 @@ void b43_rx(struct b43_wldev *dev, struc
 	chanid = (chanstat & B43_RX_CHAN_ID) >> B43_RX_CHAN_ID_SHIFT;
 	switch (chanstat & B43_RX_CHAN_PHYTYPE) {
 	case B43_PHYTYPE_A:
-		status.phymode = MODE_IEEE80211A;
+		status.band = IEEE80211_BAND_5GHZ;
 		B43_WARN_ON(1);
 		/* FIXME: We don't really know which value the "chanid" contains.
 		 *        So the following assignment might be wrong. */
-		status.channel = chanid;
-		status.freq = b43_channel_to_freq_5ghz(status.channel);
+		status.freq = b43_channel_to_freq_5ghz(chanid);
 		break;
 	case B43_PHYTYPE_G:
-		status.phymode = MODE_IEEE80211G;
+		status.band = IEEE80211_BAND_2GHZ;
 		/* chanid is the radio channel cookie value as used
 		 * to tune the radio. */
 		status.freq = chanid + 2400;
-		status.channel = b43_freq_to_channel_2ghz(status.freq);
 		break;
 	case B43_PHYTYPE_N:
-		status.phymode = 0xDEAD /*FIXME MODE_IEEE80211N*/;
 		/* chanid is the SHM channel cookie. Which is the plain
 		 * channel number in b43. */
-		status.channel = chanid;
-		if (chanstat & B43_RX_CHAN_5GHZ)
-			status.freq = b43_freq_to_channel_5ghz(status.freq);
-		else
-			status.freq = b43_freq_to_channel_2ghz(status.freq);
+		if (chanstat & B43_RX_CHAN_5GHZ) {
+			status.band = IEEE80211_BAND_5GHZ;
+			status.freq = b43_freq_to_channel_5ghz(chanid);
+		} else {
+			status.band = IEEE80211_BAND_2GHZ;
+			status.freq = b43_freq_to_channel_2ghz(chanid);
+		}
 		break;
 	default:
 		B43_WARN_ON(1);
--- everything.orig/net/wireless/Makefile	2008-01-24 19:34:50.523587077 +0100
+++ everything/net/wireless/Makefile	2008-01-24 19:35:11.683587403 +0100
@@ -1,5 +1,5 @@
 obj-$(CONFIG_WIRELESS_EXT) += wext.o
 obj-$(CONFIG_CFG80211) += cfg80211.o
 
-cfg80211-y += core.o sysfs.o radiotap.o
+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
--- everything.orig/drivers/net/wireless/b43/sysfs.c	2008-01-24 19:34:50.813588759 +0100
+++ everything/drivers/net/wireless/b43/sysfs.c	2008-01-24 19:35:11.683587403 +0100
@@ -47,29 +47,6 @@ static int get_integer(const char *buf, 
 	return ret;
 }
 
-static int get_boolean(const char *buf, size_t count)
-{
-	if (count != 0) {
-		if (buf[0] == '1')
-			return 1;
-		if (buf[0] == '0')
-			return 0;
-		if (count >= 4 && memcmp(buf, "true", 4) == 0)
-			return 1;
-		if (count >= 5 && memcmp(buf, "false", 5) == 0)
-			return 0;
-		if (count >= 3 && memcmp(buf, "yes", 3) == 0)
-			return 1;
-		if (count >= 2 && memcmp(buf, "no", 2) == 0)
-			return 0;
-		if (count >= 2 && memcmp(buf, "on", 2) == 0)
-			return 1;
-		if (count >= 3 && memcmp(buf, "off", 3) == 0)
-			return 0;
-	}
-	return -EINVAL;
-}
-
 static ssize_t b43_attr_interfmode_show(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
@@ -155,82 +132,18 @@ static ssize_t b43_attr_interfmode_store
 static DEVICE_ATTR(interference, 0644,
 		   b43_attr_interfmode_show, b43_attr_interfmode_store);
 
-static ssize_t b43_attr_preamble_show(struct device *dev,
-				      struct device_attribute *attr, char *buf)
-{
-	struct b43_wldev *wldev = dev_to_b43_wldev(dev);
-	ssize_t count;
-
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
-	mutex_lock(&wldev->wl->mutex);
-
-	if (wldev->short_preamble)
-		count =
-		    snprintf(buf, PAGE_SIZE, "1 (Short Preamble enabled)\n");
-	else
-		count =
-		    snprintf(buf, PAGE_SIZE, "0 (Short Preamble disabled)\n");
-
-	mutex_unlock(&wldev->wl->mutex);
-
-	return count;
-}
-
-static ssize_t b43_attr_preamble_store(struct device *dev,
-				       struct device_attribute *attr,
-				       const char *buf, size_t count)
-{
-	struct b43_wldev *wldev = dev_to_b43_wldev(dev);
-	unsigned long flags;
-	int value;
-
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
-	value = get_boolean(buf, count);
-	if (value < 0)
-		return value;
-	mutex_lock(&wldev->wl->mutex);
-	spin_lock_irqsave(&wldev->wl->irq_lock, flags);
-
-	wldev->short_preamble = !!value;
-
-	spin_unlock_irqrestore(&wldev->wl->irq_lock, flags);
-	mutex_unlock(&wldev->wl->mutex);
-
-	return count;
-}
-
-static DEVICE_ATTR(shortpreamble, 0644,
-		   b43_attr_preamble_show, b43_attr_preamble_store);
-
 int b43_sysfs_register(struct b43_wldev *wldev)
 {
 	struct device *dev = wldev->dev->dev;
-	int err;
 
 	B43_WARN_ON(b43_status(wldev) != B43_STAT_INITIALIZED);
 
-	err = device_create_file(dev, &dev_attr_interference);
-	if (err)
-		goto out;
-	err = device_create_file(dev, &dev_attr_shortpreamble);
-	if (err)
-		goto err_remove_interfmode;
-
-      out:
-	return err;
-      err_remove_interfmode:
-	device_remove_file(dev, &dev_attr_interference);
-	goto out;
+	return device_create_file(dev, &dev_attr_interference);
 }
 
 void b43_sysfs_unregister(struct b43_wldev *wldev)
 {
 	struct device *dev = wldev->dev->dev;
 
-	device_remove_file(dev, &dev_attr_shortpreamble);
 	device_remove_file(dev, &dev_attr_interference);
 }
--- everything.orig/net/wireless/core.h	2008-01-24 19:34:50.543587891 +0100
+++ everything/net/wireless/core.h	2008-01-24 19:35:11.683587403 +0100
@@ -78,4 +78,7 @@ extern void cfg80211_dev_free(struct cfg
 extern int cfg80211_dev_rename(struct cfg80211_registered_device *drv,
 			       char *newname);
 
+void ieee80211_set_bitrate_flags(struct wiphy *wiphy);
+void wiphy_update_regulatory(struct wiphy *wiphy);
+
 #endif /* __NET_WIRELESS_CORE_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/net/wireless/util.c	2008-01-24 19:35:11.683587403 +0100
@@ -0,0 +1,98 @@
+/*
+ * Wireless utility functions
+ *
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ */
+#include <net/wireless.h>
+#include <asm/bitops.h>
+#include "core.h"
+
+int ieee80211_channel_to_frequency(int chan)
+{
+	if (chan < 14)
+		return 2407 + chan * 5;
+
+	if (chan == 14)
+		return 2484;
+
+	/* FIXME: 802.11j 17.3.8.3.2 */
+	return (chan + 1000) * 5;
+}
+EXPORT_SYMBOL(ieee80211_channel_to_frequency);
+
+int ieee80211_frequency_to_channel(int freq)
+{
+	if (freq == 2484)
+		return 14;
+
+	if (freq < 2484)
+		return (freq - 2407) / 5;
+
+	/* FIXME: 802.11j 17.3.8.3.2 */
+	return freq/5 - 1000;
+}
+EXPORT_SYMBOL(ieee80211_frequency_to_channel);
+
+static void set_mandatory_flags_band(struct ieee80211_supported_band *sband,
+				     enum ieee80211_band band)
+{
+	int i, want;
+
+	switch (band) {
+	case IEEE80211_BAND_5GHZ:
+		want = 3;
+		for (i = 0; i < sband->n_bitrates; i++) {
+			if (sband->bitrates[i].bitrate == 60 ||
+			    sband->bitrates[i].bitrate == 120 ||
+			    sband->bitrates[i].bitrate == 240) {
+				sband->bitrates[i].flags |=
+					IEEE80211_RATE_MANDATORY_A;
+				want--;
+			}
+		}
+		WARN_ON(want);
+		break;
+	case IEEE80211_BAND_2GHZ:
+		want = 7;
+		for (i = 0; i < sband->n_bitrates; i++) {
+			if (sband->bitrates[i].bitrate == 10) {
+				sband->bitrates[i].flags |=
+					IEEE80211_RATE_MANDATORY_B |
+					IEEE80211_RATE_MANDATORY_G;
+				want--;
+			}
+
+			if (sband->bitrates[i].bitrate == 20 ||
+			    sband->bitrates[i].bitrate == 55 ||
+			    sband->bitrates[i].bitrate == 110 ||
+			    sband->bitrates[i].bitrate == 60 ||
+			    sband->bitrates[i].bitrate == 120 ||
+			    sband->bitrates[i].bitrate == 240) {
+				sband->bitrates[i].flags |=
+					IEEE80211_RATE_MANDATORY_G;
+				want--;
+			}
+
+			if (sband->bitrates[i].bitrate == 10 ||
+			    sband->bitrates[i].bitrate == 20 ||
+			    sband->bitrates[i].bitrate == 55 ||
+			    sband->bitrates[i].bitrate == 110)
+				sband->bitrates[i].flags |=
+					IEEE80211_RATE_ERP_G;
+		}
+		WARN_ON(want != 0 && want != 6);
+		break;
+	case IEEE80211_NUM_BANDS:
+		WARN_ON(1);
+		break;
+	}
+}
+
+void ieee80211_set_bitrate_flags(struct wiphy *wiphy)
+{
+	enum ieee80211_band band;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+		if (wiphy->bands[band])
+			set_mandatory_flags_band(wiphy->bands[band], band);
+}
--- everything.orig/net/mac80211/cfg.c	2008-01-24 19:34:56.283586101 +0100
+++ everything/net/mac80211/cfg.c	2008-01-24 19:35:11.693585450 +0100
@@ -498,7 +498,7 @@ static void sta_apply_parameters(struct 
 {
 	u32 rates;
 	int i, j;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 
 	if (params->station_flags & STATION_FLAG_CHANGED) {
 		sta->flags &= ~WLAN_STA_AUTHORIZED;
@@ -525,15 +525,16 @@ static void sta_apply_parameters(struct 
 
 	if (params->supported_rates) {
 		rates = 0;
-		mode = local->oper_hw_mode;
+		sband = local->hw.wiphy->bands[local->oper_channel->band];
+
 		for (i = 0; i < params->supported_rates_len; i++) {
 			int rate = (params->supported_rates[i] & 0x7f) * 5;
-			for (j = 0; j < mode->num_rates; j++) {
-				if (mode->rates[j].rate == rate)
+			for (j = 0; j < sband->n_bitrates; j++) {
+				if (sband->bitrates[j].bitrate == rate)
 					rates |= BIT(j);
 			}
 		}
-		sta->supp_rates = rates;
+		sta->supp_rates[local->oper_channel->band] = rates;
 	}
 }
 
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-01-24 19:34:50.263587403 +0100
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-01-24 19:35:11.693585450 +0100
@@ -102,23 +102,23 @@ static void rate_control_pid_adjust_rate
 					 struct rc_pid_rateinfo *rinfo)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	int newidx;
 	int maxrate;
 	int back = (adj > 0) ? 1 : -1;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 
-	mode = local->oper_hw_mode;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	maxrate = sdata->bss ? sdata->bss->max_ratectrl_rateidx : -1;
 
-	newidx = rate_control_pid_shift_adjust(rinfo, adj, sta->txrate,
-					       mode->num_rates);
+	newidx = rate_control_pid_shift_adjust(rinfo, adj, sta->txrate_idx,
+					       sband->n_bitrates);
 
-	while (newidx != sta->txrate) {
-		if (rate_supported(sta, mode, newidx) &&
+	while (newidx != sta->txrate_idx) {
+		if (rate_supported(sta, sband->band, newidx) &&
 		    (maxrate < 0 || newidx <= maxrate)) {
-			sta->txrate = newidx;
+			sta->txrate_idx = newidx;
 			break;
 		}
 
@@ -128,7 +128,7 @@ static void rate_control_pid_adjust_rate
 #ifdef CONFIG_MAC80211_DEBUGFS
 	rate_control_pid_event_rate_change(
 		&((struct rc_pid_sta_info *)sta->rate_ctrl_priv)->events,
-		newidx, mode->rates[newidx].rate);
+		newidx, sband->bitrates[newidx].bitrate);
 #endif
 }
 
@@ -155,7 +155,7 @@ static void rate_control_pid_sample(stru
 {
 	struct rc_pid_sta_info *spinfo = sta->rate_ctrl_priv;
 	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	u32 pf;
 	s32 err_avg;
 	u32 err_prop;
@@ -164,7 +164,7 @@ static void rate_control_pid_sample(stru
 	int adj, i, j, tmp;
 	unsigned long period;
 
-	mode = local->oper_hw_mode;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	spinfo = sta->rate_ctrl_priv;
 
 	/* In case nothing happened during the previous control interval, turn
@@ -190,18 +190,18 @@ static void rate_control_pid_sample(stru
 	spinfo->tx_num_failed = 0;
 
 	/* If we just switched rate, update the rate behaviour info. */
-	if (pinfo->oldrate != sta->txrate) {
+	if (pinfo->oldrate != sta->txrate_idx) {
 
 		i = rinfo[pinfo->oldrate].rev_index;
-		j = rinfo[sta->txrate].rev_index;
+		j = rinfo[sta->txrate_idx].rev_index;
 
 		tmp = (pf - spinfo->last_pf);
 		tmp = RC_PID_DO_ARITH_RIGHT_SHIFT(tmp, RC_PID_ARITH_SHIFT);
 
 		rinfo[j].diff = rinfo[i].diff + tmp;
-		pinfo->oldrate = sta->txrate;
+		pinfo->oldrate = sta->txrate_idx;
 	}
-	rate_control_pid_normalize(pinfo, mode->num_rates);
+	rate_control_pid_normalize(pinfo, sband->n_bitrates);
 
 	/* Compute the proportional, integral and derivative errors. */
 	err_prop = (pinfo->target << RC_PID_ARITH_SHIFT) - pf;
@@ -242,8 +242,10 @@ static void rate_control_pid_tx_status(v
 	struct sta_info *sta;
 	struct rc_pid_sta_info *spinfo;
 	unsigned long period;
+	struct ieee80211_supported_band *sband;
 
 	sta = sta_info_get(local, hdr->addr1);
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	if (!sta)
 		return;
@@ -251,13 +253,13 @@ static void rate_control_pid_tx_status(v
 	/* Don't update the state if we're not controlling the rate. */
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
-		sta->txrate = sdata->bss->max_ratectrl_rateidx;
+		sta->txrate_idx = sdata->bss->max_ratectrl_rateidx;
 		return;
 	}
 
 	/* Ignore all frames that were sent with a different rate than the rate
 	 * we currently advise mac80211 to use. */
-	if (status->control.rate != &local->oper_hw_mode->rates[sta->txrate])
+	if (status->control.tx_rate != &sband->bitrates[sta->txrate_idx])
 		goto ignore;
 
 	spinfo = sta->rate_ctrl_priv;
@@ -304,7 +306,7 @@ ignore:
 }
 
 static void rate_control_pid_get_rate(void *priv, struct net_device *dev,
-				      struct ieee80211_hw_mode *mode,
+				      struct ieee80211_supported_band *sband,
 				      struct sk_buff *skb,
 				      struct rate_selection *sel)
 {
@@ -322,7 +324,7 @@ static void rate_control_pid_get_rate(vo
 	fc = le16_to_cpu(hdr->frame_control);
 	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
 	    is_multicast_ether_addr(hdr->addr1) || !sta) {
-		sel->rate = rate_lowest(local, mode, sta);
+		sel->rate = rate_lowest(local, sband, sta);
 		if (sta)
 			sta_info_put(sta);
 		return;
@@ -331,23 +333,23 @@ static void rate_control_pid_get_rate(vo
 	/* If a forced rate is in effect, select it. */
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
-		sta->txrate = sdata->bss->force_unicast_rateidx;
+		sta->txrate_idx = sdata->bss->force_unicast_rateidx;
 
-	rateidx = sta->txrate;
+	rateidx = sta->txrate_idx;
 
-	if (rateidx >= mode->num_rates)
-		rateidx = mode->num_rates - 1;
+	if (rateidx >= sband->n_bitrates)
+		rateidx = sband->n_bitrates - 1;
 
-	sta->last_txrate = rateidx;
+	sta->last_txrate_idx = rateidx;
 
 	sta_info_put(sta);
 
-	sel->rate = &mode->rates[rateidx];
+	sel->rate = &sband->bitrates[rateidx];
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	rate_control_pid_event_tx_rate(
 		&((struct rc_pid_sta_info *) sta->rate_ctrl_priv)->events,
-		rateidx, mode->rates[rateidx].rate);
+		rateidx, sband->bitrates[rateidx].bitrate);
 #endif
 }
 
@@ -359,28 +361,32 @@ static void rate_control_pid_rate_init(v
 	 * as we need to have IEEE 802.1X auth succeed immediately after assoc..
 	 * Until that method is implemented, we will use the lowest supported
 	 * rate as a workaround. */
-	sta->txrate = rate_lowest_index(local, local->oper_hw_mode, sta);
+	struct ieee80211_supported_band *sband;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sta->txrate_idx = rate_lowest_index(local, sband, sta);
 }
 
 static void *rate_control_pid_alloc(struct ieee80211_local *local)
 {
 	struct rc_pid_info *pinfo;
 	struct rc_pid_rateinfo *rinfo;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	int i, j, tmp;
 	bool s;
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct rc_pid_debugfs_entries *de;
 #endif
 
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
 	pinfo = kmalloc(sizeof(*pinfo), GFP_ATOMIC);
 	if (!pinfo)
 		return NULL;
 
-	/* We can safely assume that oper_hw_mode won't change unless we get
+	/* We can safely assume that sband won't change unless we get
 	 * reinitialized. */
-	mode = local->oper_hw_mode;
-	rinfo = kmalloc(sizeof(*rinfo) * mode->num_rates, GFP_ATOMIC);
+	rinfo = kmalloc(sizeof(*rinfo) * sband->n_bitrates, GFP_ATOMIC);
 	if (!rinfo) {
 		kfree(pinfo);
 		return NULL;
@@ -389,7 +395,7 @@ static void *rate_control_pid_alloc(stru
 	/* Sort the rates. This is optimized for the most common case (i.e.
 	 * almost-sorted CCK+OFDM rates). Kind of bubble-sort with reversed
 	 * mapping too. */
-	for (i = 0; i < mode->num_rates; i++) {
+	for (i = 0; i < sband->n_bitrates; i++) {
 		rinfo[i].index = i;
 		rinfo[i].rev_index = i;
 		if (pinfo->fast_start)
@@ -397,11 +403,11 @@ static void *rate_control_pid_alloc(stru
 		else
 			rinfo[i].diff = i * pinfo->norm_offset;
 	}
-	for (i = 1; i < mode->num_rates; i++) {
+	for (i = 1; i < sband->n_bitrates; i++) {
 		s = 0;
-		for (j = 0; j < mode->num_rates - i; j++)
-			if (unlikely(mode->rates[rinfo[j].index].rate >
-				     mode->rates[rinfo[j + 1].index].rate)) {
+		for (j = 0; j < sband->n_bitrates - i; j++)
+			if (unlikely(sband->bitrates[rinfo[j].index].bitrate >
+				     sband->bitrates[rinfo[j + 1].index].bitrate)) {
 				tmp = rinfo[j].index;
 				rinfo[j].index = rinfo[j + 1].index;
 				rinfo[j + 1].index = tmp;
--- everything.orig/net/mac80211/ieee80211_rate.c	2008-01-24 19:34:50.313586372 +0100
+++ everything/net/mac80211/ieee80211_rate.c	2008-01-24 19:35:11.693585450 +0100
@@ -163,7 +163,8 @@ static void rate_control_release(struct 
 }
 
 void rate_control_get_rate(struct net_device *dev,
-			   struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			   struct ieee80211_supported_band *sband,
+			   struct sk_buff *skb,
 			   struct rate_selection *sel)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -174,17 +175,17 @@ void rate_control_get_rate(struct net_de
 
 	memset(sel, 0, sizeof(struct rate_selection));
 
-	ref->ops->get_rate(ref->priv, dev, mode, skb, sel);
+	ref->ops->get_rate(ref->priv, dev, sband, skb, sel);
 
 	/* Select a non-ERP backup rate. */
 	if (!sel->nonerp) {
-		for (i = 0; i < mode->num_rates - 1; i++) {
-			struct ieee80211_rate *rate = &mode->rates[i];
-			if (sel->rate->rate < rate->rate)
+		for (i = 0; i < sband->n_bitrates; i++) {
+			struct ieee80211_rate *rate = &sband->bitrates[i];
+			if (sel->rate->bitrate < rate->bitrate)
 				break;
 
-			if (rate_supported(sta, mode, i) &&
-			    !(rate->flags & IEEE80211_RATE_ERP))
+			if (rate_supported(sta, sband->band, i) &&
+			    !(rate->flags & IEEE80211_RATE_ERP_G))
 				sel->nonerp = rate;
 		}
 	}
--- everything.orig/net/mac80211/sta_info.h	2008-01-24 19:34:50.343586697 +0100
+++ everything/net/mac80211/sta_info.h	2008-01-24 19:35:11.693585450 +0100
@@ -104,10 +104,11 @@ struct sta_info {
 	unsigned int wep_weak_iv_count; /* number of RX frames with weak IV */
 
 	unsigned long last_rx;
-	u32 supp_rates; /* bitmap of supported rates in local->curr_rates */
-	int txrate; /* index in local->curr_rates */
-	int last_txrate; /* last rate used to send a frame to this STA */
-	int last_nonerp_idx;
+	/* bitmap of supported rates per band */
+	u64 supp_rates[IEEE80211_NUM_BANDS];
+	int txrate_idx;
+	/* last rates used to send a frame to this STA */
+	int last_txrate_idx, last_nonerp_txrate_idx;
 
 	struct net_device *dev; /* which net device is this station associated
 				 * to */
@@ -191,7 +192,6 @@ static inline void __sta_info_get(struct
 }
 
 struct sta_info * sta_info_get(struct ieee80211_local *local, u8 *addr);
-int sta_info_min_txrate_get(struct ieee80211_local *local);
 void sta_info_put(struct sta_info *sta);
 struct sta_info * sta_info_add(struct ieee80211_local *local,
 			       struct net_device *dev, u8 *addr, gfp_t gfp);
--- everything.orig/net/mac80211/ieee80211_iface.c	2008-01-24 19:34:50.423585395 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2008-01-24 19:35:11.693585450 +0100
@@ -118,6 +118,8 @@ void ieee80211_if_set_type(struct net_de
 	sdata->bss = NULL;
 	sdata->vif.type = type;
 
+	sdata->basic_rates = 0;
+
 	switch (type) {
 	case IEEE80211_IF_TYPE_WDS:
 		/* nothing special */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/net/wireless/reg.c	2008-01-24 19:35:11.703606229 +0100
@@ -0,0 +1,153 @@
+/*
+ * Copyright 2002-2005, Instant802 Networks, Inc.
+ * Copyright 2005-2006, Devicescape Software, Inc.
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * This regulatory domain control implementation is highly incomplete, it
+ * only exists for the purpose of not regressing mac80211.
+ *
+ * For now, drivers can restrict the set of allowed channels by either
+ * not registering those channels or setting the IEEE80211_CHAN_DISABLED
+ * flag; that flag will only be *set* by this code, never *cleared.
+ *
+ * The usual implementation is for a driver to read a device EEPROM to
+ * determine which regulatory domain it should be operating under, then
+ * looking up the allowable channels in a driver-local table and finally
+ * registering those channels in the wiphy structure.
+ *
+ * Alternatively, drivers that trust the regulatory domain control here
+ * will register a complete set of capabilities and the control code
+ * will restrict the set by setting the IEEE80211_CHAN_* flags.
+ */
+#include <linux/kernel.h>
+#include <net/wireless.h>
+#include "core.h"
+
+static char *ieee80211_regdom = "US";
+module_param(ieee80211_regdom, charp, 0444);
+MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
+
+struct ieee80211_channel_range {
+	short start_freq;
+	short end_freq;
+	int max_power;
+	int max_antenna_gain;
+	u32 flags;
+};
+
+struct ieee80211_regdomain {
+	const char *code;
+	const struct ieee80211_channel_range *ranges;
+	int n_ranges;
+};
+
+#define RANGE_PWR(_start, _end, _pwr, _ag, _flags)	\
+	{ _start, _end, _pwr, _ag, _flags }
+
+
+/*
+ * Ideally, in the future, these definitions will be loaded from a
+ * userspace table via some daemon.
+ */
+static const struct ieee80211_channel_range ieee80211_US_channels[] = {
+	/* IEEE 802.11b/g, channels 1..11 */
+	RANGE_PWR(2412, 2462, 27, 6, 0),
+	/* IEEE 802.11a, channels 52..64 */
+	RANGE_PWR(5260, 5320, 23, 6, 0),
+	/* IEEE 802.11a, channels 149..165, outdoor */
+	RANGE_PWR(5745, 5825, 30, 6, 0),
+};
+
+static const struct ieee80211_channel_range ieee80211_JP_channels[] = {
+	/* IEEE 802.11b/g, channels 1..14 */
+	RANGE_PWR(2412, 2484, 20, 6, 0),
+	/* IEEE 802.11a, channels 34..48 */
+	RANGE_PWR(5170, 5240, 20, 6, IEEE80211_CHAN_PASSIVE_SCAN),
+	/* IEEE 802.11a, channels 52..64 */
+	RANGE_PWR(5260, 5320, 20, 6, IEEE80211_CHAN_NO_IBSS |
+				     IEEE80211_CHAN_RADAR),
+};
+
+#define REGDOM(_code)							\
+	{								\
+		.code = __stringify(_code),				\
+		.ranges = ieee80211_ ##_code## _channels,		\
+		.n_ranges = ARRAY_SIZE(ieee80211_ ##_code## _channels),	\
+	}
+
+static const struct ieee80211_regdomain ieee80211_regdoms[] = {
+	REGDOM(US),
+	REGDOM(JP),
+};
+
+
+static const struct ieee80211_regdomain *get_regdom(void)
+{
+	static const struct ieee80211_channel_range
+	ieee80211_world_channels[] = {
+		/* IEEE 802.11b/g, channels 1..11 */
+		RANGE_PWR(2412, 2462, 27, 6, 0),
+	};
+	static const struct ieee80211_regdomain regdom_world = REGDOM(world);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ieee80211_regdoms); i++)
+		if (strcmp(ieee80211_regdom, ieee80211_regdoms[i].code) == 0)
+			return &ieee80211_regdoms[i];
+
+	return &regdom_world;
+}
+
+
+static void handle_channel(struct ieee80211_channel *chan,
+			   const struct ieee80211_regdomain *rd)
+{
+	int i;
+	u32 flags = chan->orig_flags;
+	const struct ieee80211_channel_range *rg = NULL;
+
+	for (i = 0; i < rd->n_ranges; i++) {
+		if (rd->ranges[i].start_freq <= chan->center_freq &&
+		    chan->center_freq <= rd->ranges[i].end_freq) {
+			rg = &rd->ranges[i];
+			break;
+		}
+	}
+
+	if (!rg) {
+		/* not found */
+		flags |= IEEE80211_CHAN_DISABLED;
+		chan->flags = flags;
+		return;
+	}
+
+	chan->flags = flags;
+	chan->max_antenna_gain = min(chan->orig_mag,
+					 rg->max_antenna_gain);
+	chan->max_power = min(chan->orig_mpwr, rg->max_power);
+}
+
+static void handle_band(struct ieee80211_supported_band *sband,
+			const struct ieee80211_regdomain *rd)
+{
+	int i;
+
+	for (i = 0; i < sband->n_channels; i++)
+		handle_channel(&sband->channels[i], rd);
+}
+
+void wiphy_update_regulatory(struct wiphy *wiphy)
+{
+	enum ieee80211_band band;
+	const struct ieee80211_regdomain *rd = get_regdom();
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+		if (wiphy->bands[band])
+			handle_band(wiphy->bands[band], rd);
+}
--- everything.orig/drivers/net/wireless/adm8211.c	2008-01-24 19:34:50.863586697 +0100
+++ everything/drivers/net/wireless/adm8211.c	2008-01-24 19:35:11.703606229 +0100
@@ -48,6 +48,32 @@ static struct pci_device_id adm8211_pci_
 	{ 0 }
 };
 
+static struct ieee80211_rate adm8211_rates[] = {
+	{ .bitrate = 10, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 20, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 55, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 110, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 220, .flags = IEEE80211_RATE_SHORT_PREAMBLE }, /* XX ?? */
+};
+
+static const struct ieee80211_channel adm8211_channels[] = {
+	{ .center_freq = 2412},
+	{ .center_freq = 2417},
+	{ .center_freq = 2422},
+	{ .center_freq = 2427},
+	{ .center_freq = 2432},
+	{ .center_freq = 2437},
+	{ .center_freq = 2442},
+	{ .center_freq = 2447},
+	{ .center_freq = 2452},
+	{ .center_freq = 2457},
+	{ .center_freq = 2462},
+	{ .center_freq = 2467},
+	{ .center_freq = 2472},
+	{ .center_freq = 2484},
+};
+
+
 static void adm8211_eeprom_register_read(struct eeprom_93cx6 *eeprom)
 {
 	struct adm8211_priv *priv = eeprom->data;
@@ -155,17 +181,17 @@ static int adm8211_read_eeprom(struct ie
 	printk(KERN_DEBUG "%s (adm8211): Channel range: %d - %d\n",
 	       pci_name(priv->pdev), (int)chan_range.min, (int)chan_range.max);
 
-	priv->modes[0].num_channels = chan_range.max - chan_range.min + 1;
-	priv->modes[0].channels = priv->channels;
+	BUILD_BUG_ON(sizeof(priv->channels) != sizeof(adm8211_channels));
 
-	memcpy(priv->channels, adm8211_channels, sizeof(adm8211_channels));
+	memcpy(priv->channels, adm8211_channels, sizeof(priv->channels));
+	priv->band.channels = priv->channels;
+	priv->band.n_channels = ARRAY_SIZE(adm8211_channels);
+	priv->band.bitrates = adm8211_rates;
+	priv->band.n_bitrates = ARRAY_SIZE(adm8211_rates);
 
 	for (i = 1; i <= ARRAY_SIZE(adm8211_channels); i++)
-		if (i >= chan_range.min && i <= chan_range.max)
-			priv->channels[i - 1].flag =
-				IEEE80211_CHAN_W_SCAN |
-				IEEE80211_CHAN_W_ACTIVE_SCAN |
-				IEEE80211_CHAN_W_IBSS;
+		if (i < chan_range.min || i > chan_range.max)
+			priv->channels[i - 1].flags |= IEEE80211_CHAN_DISABLED;
 
 	switch (priv->eeprom->specific_bbptype) {
 	case ADM8211_BBP_RFMD3000:
@@ -347,7 +373,6 @@ static void adm8211_interrupt_rci(struct
 	unsigned int pktlen;
 	struct sk_buff *skb, *newskb;
 	unsigned int limit = priv->rx_ring_size;
-	static const u8 rate_tbl[] = {10, 20, 55, 110, 220};
 	u8 rssi, rate;
 
 	while (!(priv->rx_ring[entry].status & cpu_to_le32(RDES0_STATUS_OWN))) {
@@ -425,12 +450,10 @@ static void adm8211_interrupt_rci(struct
 			else
 				rx_status.ssi = 100 - rssi;
 
-			if (rate <= 4)
-				rx_status.rate = rate_tbl[rate];
+			rx_status.rate_idx = rate;
 
-			rx_status.channel = priv->channel;
-			rx_status.freq = adm8211_channels[priv->channel - 1].freq;
-			rx_status.phymode = MODE_IEEE80211B;
+			rx_status.freq = adm8211_channels[priv->channel - 1].center_freq;
+			rx_status.band = IEEE80211_BAND_2GHZ;
 
 			ieee80211_rx_irqsafe(dev, skb, &rx_status);
 		}
@@ -1054,7 +1077,7 @@ static int adm8211_set_rate(struct ieee8
 	if (priv->pdev->revision != ADM8211_REV_BA) {
 		rate_buf[0] = ARRAY_SIZE(adm8211_rates);
 		for (i = 0; i < ARRAY_SIZE(adm8211_rates); i++)
-			rate_buf[i + 1] = (adm8211_rates[i].rate / 5) | 0x80;
+			rate_buf[i + 1] = (adm8211_rates[i].bitrate / 5) | 0x80;
 	} else {
 		/* workaround for rev BA specific bug */
 		rate_buf[0] = 0x04;
@@ -1303,9 +1326,10 @@ static int adm8211_set_ssid(struct ieee8
 static int adm8211_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
 {
 	struct adm8211_priv *priv = dev->priv;
+	int channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
 
-	if (conf->channel != priv->channel) {
-		priv->channel = conf->channel;
+	if (channel != priv->channel) {
+		priv->channel = channel;
 		adm8211_rf_set_channel(dev, priv->channel);
 	}
 
@@ -1680,10 +1704,10 @@ static int adm8211_tx(struct ieee80211_h
 
 	if (control->tx_rate < 0) {
 		short_preamble = 1;
-		plcp_signal = -control->tx_rate;
+		plcp_signal = -control->tx_rate->bitrate;
 	} else {
 		short_preamble = 0;
-		plcp_signal = control->tx_rate;
+		plcp_signal = control->tx_rate->bitrate;
 	}
 
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -1880,18 +1904,11 @@ static int __devinit adm8211_probe(struc
 	SET_IEEE80211_PERM_ADDR(dev, perm_addr);
 
 	dev->extra_tx_headroom = sizeof(struct adm8211_tx_hdr);
-	dev->flags = IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED;
-	/* IEEE80211_HW_RX_INCLUDES_FCS in promisc mode */
+	/* dev->flags = IEEE80211_HW_RX_INCLUDES_FCS in promisc mode */
 
 	dev->channel_change_time = 1000;
 	dev->max_rssi = 100;	/* FIXME: find better value */
 
-	priv->modes[0].mode = MODE_IEEE80211B;
-	/* channel info filled in by adm8211_read_eeprom */
-	memcpy(priv->rates, adm8211_rates, sizeof(adm8211_rates));
-	priv->modes[0].num_rates = ARRAY_SIZE(adm8211_rates);
-	priv->modes[0].rates = priv->rates;
-
 	dev->queues = 1; /* ADM8211C supports more, maybe ADM8211B too */
 
 	priv->retry_limit = 3;
@@ -1917,14 +1934,7 @@ static int __devinit adm8211_probe(struc
 		goto err_free_desc;
 	}
 
-	priv->channel = priv->modes[0].channels[0].chan;
-
-	err = ieee80211_register_hwmode(dev, &priv->modes[0]);
-	if (err) {
-		printk(KERN_ERR "%s (adm8211): Can't register hwmode\n",
-		       pci_name(pdev));
-		goto err_free_desc;
-	}
+	priv->channel = 1;
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
--- everything.orig/drivers/net/wireless/adm8211.h	2008-01-24 19:34:50.893586806 +0100
+++ everything/drivers/net/wireless/adm8211.h	2008-01-24 19:35:11.713586426 +0100
@@ -534,61 +534,6 @@ struct adm8211_eeprom {
 	u8	cis_data[0];		/* 0x80, 384 bytes */
 } __attribute__ ((packed));
 
-static const struct ieee80211_rate adm8211_rates[] = {
-	{ .rate = 10,
-	  .val = 10,
-	  .val2 = -10,
-	  .flags = IEEE80211_RATE_CCK_2 },
-	{ .rate = 20,
-	  .val = 20,
-	  .val2 = -20,
-	  .flags = IEEE80211_RATE_CCK_2 },
-	{ .rate = 55,
-	  .val = 55,
-	  .val2 = -55,
-	  .flags = IEEE80211_RATE_CCK_2 },
-	{ .rate = 110,
-	  .val = 110,
-	  .val2 = -110,
-	  .flags = IEEE80211_RATE_CCK_2 }
-};
-
-struct ieee80211_chan_range {
-	u8 min;
-	u8 max;
-};
-
-static const struct ieee80211_channel adm8211_channels[] = {
-	{ .chan = 1,
-	  .freq = 2412},
-	{ .chan = 2,
-	  .freq = 2417},
-	{ .chan = 3,
-	  .freq = 2422},
-	{ .chan = 4,
-	  .freq = 2427},
-	{ .chan = 5,
-	  .freq = 2432},
-	{ .chan = 6,
-	  .freq = 2437},
-	{ .chan = 7,
-	  .freq = 2442},
-	{ .chan = 8,
-	  .freq = 2447},
-	{ .chan = 9,
-	  .freq = 2452},
-	{ .chan = 10,
-	  .freq = 2457},
-	{ .chan = 11,
-	  .freq = 2462},
-	{ .chan = 12,
-	  .freq = 2467},
-	{ .chan = 13,
-	  .freq = 2472},
-	{ .chan = 14,
-	  .freq = 2484},
-};
-
 struct adm8211_priv {
 	struct pci_dev *pdev;
 	spinlock_t lock;
@@ -603,9 +548,8 @@ struct adm8211_priv {
 	unsigned int cur_tx, dirty_tx, cur_rx;
 
 	struct ieee80211_low_level_stats stats;
-	struct ieee80211_hw_mode modes[1];
-	struct ieee80211_channel channels[ARRAY_SIZE(adm8211_channels)];
-	struct ieee80211_rate rates[ARRAY_SIZE(adm8211_rates)];
+	struct ieee80211_supported_band band;
+	struct ieee80211_channel channels[14];
 	int mode;
 
 	int channel;
@@ -643,6 +587,11 @@ struct adm8211_priv {
 	} transceiver_type;
 };
 
+struct ieee80211_chan_range {
+	u8 min;
+	u8 max;
+};
+
 static const struct ieee80211_chan_range cranges[] = {
 	{1,  11},	/* FCC */
 	{1,  11},	/* IC */
--- everything.orig/drivers/net/wireless/p54.h	2008-01-24 19:34:50.933586643 +0100
+++ everything/drivers/net/wireless/p54.h	2008-01-24 19:35:11.713586426 +0100
@@ -64,10 +64,6 @@ struct p54_common {
 	unsigned int tx_hdr_len;
 	void *cached_vdcf;
 	unsigned int fw_var;
-	/* FIXME: this channels/modes/rates stuff sucks */
-	struct ieee80211_channel channels[14];
-	struct ieee80211_rate rates[12];
-	struct ieee80211_hw_mode modes[2];
 	struct ieee80211_tx_queue_stats tx_stats;
 };
 
--- everything.orig/drivers/net/wireless/p54common.c	2008-01-24 19:34:50.983586480 +0100
+++ everything/drivers/net/wireless/p54common.c	2008-01-24 19:35:11.713586426 +0100
@@ -27,6 +27,46 @@ MODULE_DESCRIPTION("Softmac Prism54 comm
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("prism54common");
 
+static struct ieee80211_rate p54_rates[] = {
+	{ .bitrate = 10, .hw_value = 0, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 20, .hw_value = 1, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 55, .hw_value = 2, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 110, .hw_value = 3, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 60, .hw_value = 4, },
+	{ .bitrate = 90, .hw_value = 5, },
+	{ .bitrate = 120, .hw_value = 6, },
+	{ .bitrate = 180, .hw_value = 7, },
+	{ .bitrate = 240, .hw_value = 8, },
+	{ .bitrate = 360, .hw_value = 9, },
+	{ .bitrate = 480, .hw_value = 10, },
+	{ .bitrate = 540, .hw_value = 11, },
+};
+
+static struct ieee80211_channel p54_channels[] = {
+	{ .center_freq = 2412, .hw_value = 1, },
+	{ .center_freq = 2417, .hw_value = 2, },
+	{ .center_freq = 2422, .hw_value = 3, },
+	{ .center_freq = 2427, .hw_value = 4, },
+	{ .center_freq = 2432, .hw_value = 5, },
+	{ .center_freq = 2437, .hw_value = 6, },
+	{ .center_freq = 2442, .hw_value = 7, },
+	{ .center_freq = 2447, .hw_value = 8, },
+	{ .center_freq = 2452, .hw_value = 9, },
+	{ .center_freq = 2457, .hw_value = 10, },
+	{ .center_freq = 2462, .hw_value = 11, },
+	{ .center_freq = 2467, .hw_value = 12, },
+	{ .center_freq = 2472, .hw_value = 13, },
+	{ .center_freq = 2484, .hw_value = 14, },
+};
+
+struct ieee80211_supported_band band_2GHz = {
+	.channels = p54_channels,
+	.n_channels = ARRAY_SIZE(p54_channels),
+	.bitrates = p54_rates,
+	.n_bitrates = ARRAY_SIZE(p54_rates),
+};
+
+
 void p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 {
 	struct p54_common *priv = dev->priv;
@@ -308,10 +348,10 @@ static void p54_rx_data(struct ieee80211
 	u16 freq = le16_to_cpu(hdr->freq);
 
 	rx_status.ssi = hdr->rssi;
-	rx_status.rate = hdr->rate & 0x1f; /* report short preambles & CCK too */
-	rx_status.channel = freq == 2484 ? 14 : (freq - 2407)/5;
+	/* XX correct? */
+	rx_status.rate_idx = hdr->rate & 0xf;
 	rx_status.freq = freq;
-	rx_status.phymode = MODE_IEEE80211G;
+	rx_status.band = IEEE80211_BAND_2GHZ;
 	rx_status.antenna = hdr->antenna;
 	rx_status.mactime = le64_to_cpu(hdr->timestamp);
 	rx_status.flag |= RX_FLAG_TSFT;
@@ -547,7 +587,9 @@ static int p54_tx(struct ieee80211_hw *d
 	txhdr->padding2 = 0;
 
 	/* TODO: add support for alternate retry TX rates */
-	rate = control->tx_rate;
+	rate = control->tx_rate->hw_value;
+	if (control->flags & IEEE80211_TXCTL_SHORT_PREAMBLE)
+		rate |= 0x10;
 	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
 		rate |= 0x40;
 	else if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
@@ -849,7 +891,7 @@ static int p54_config(struct ieee80211_h
 {
 	int ret;
 
-	ret = p54_set_freq(dev, cpu_to_le16(conf->freq));
+	ret = p54_set_freq(dev, cpu_to_le16(conf->channel->center_freq));
 	p54_set_vdcf(dev);
 	return ret;
 }
@@ -944,7 +986,6 @@ struct ieee80211_hw *p54_init_common(siz
 {
 	struct ieee80211_hw *dev;
 	struct p54_common *priv;
-	int i;
 
 	dev = ieee80211_alloc_hw(priv_data_len, &p54_ops);
 	if (!dev)
@@ -953,18 +994,7 @@ struct ieee80211_hw *p54_init_common(siz
 	priv = dev->priv;
 	priv->mode = IEEE80211_IF_TYPE_INVALID;
 	skb_queue_head_init(&priv->tx_queue);
-	memcpy(priv->channels, p54_channels, sizeof(p54_channels));
-	memcpy(priv->rates, p54_rates, sizeof(p54_rates));
-	priv->modes[1].mode = MODE_IEEE80211B;
-	priv->modes[1].num_rates = 4;
-	priv->modes[1].rates = priv->rates;
-	priv->modes[1].num_channels = ARRAY_SIZE(p54_channels);
-	priv->modes[1].channels = priv->channels;
-	priv->modes[0].mode = MODE_IEEE80211G;
-	priv->modes[0].num_rates = ARRAY_SIZE(p54_rates);
-	priv->modes[0].rates = priv->rates;
-	priv->modes[0].num_channels = ARRAY_SIZE(p54_channels);
-	priv->modes[0].channels = priv->channels;
+	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING | /* not sure */
 		    IEEE80211_HW_RX_INCLUDES_FCS;
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
@@ -986,14 +1016,6 @@ struct ieee80211_hw *p54_init_common(siz
 
 	p54_init_vdcf(dev);
 
-	for (i = 0; i < 2; i++) {
-		if (ieee80211_register_hwmode(dev, &priv->modes[i])) {
-			kfree(priv->cached_vdcf);
-			ieee80211_free_hw(dev);
-			return NULL;
-		}
-	}
-
 	return dev;
 }
 EXPORT_SYMBOL_GPL(p54_init_common);
--- everything.orig/drivers/net/wireless/p54common.h	2008-01-24 19:34:51.013586806 +0100
+++ everything/drivers/net/wireless/p54common.h	2008-01-24 19:35:11.713586426 +0100
@@ -251,79 +251,4 @@ struct p54_tx_control_vdcf {
 	__le16 frameburst;
 } __attribute__ ((packed));
 
-static const struct ieee80211_rate p54_rates[] = {
-	{ .rate = 10,
-	  .val = 0,
-	  .val2 = 0x10,
-	  .flags = IEEE80211_RATE_CCK_2 },
-	{ .rate = 20,
-	  .val = 1,
-	  .val2 = 0x11,
-	  .flags = IEEE80211_RATE_CCK_2 },
-	{ .rate = 55,
-	  .val = 2,
-	  .val2 = 0x12,
-	  .flags = IEEE80211_RATE_CCK_2 },
-	{ .rate = 110,
-	  .val = 3,
-	  .val2 = 0x13,
-	  .flags = IEEE80211_RATE_CCK_2 },
-	{ .rate = 60,
-	  .val = 4,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 90,
-	  .val = 5,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 120,
-	  .val = 6,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 180,
-	  .val = 7,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 240,
-	  .val = 8,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 360,
-	  .val = 9,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 480,
-	  .val = 10,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 540,
-	  .val = 11,
-	  .flags = IEEE80211_RATE_OFDM },
-};
-
-// TODO: just generate this..
-static const struct ieee80211_channel p54_channels[] = {
-	{ .chan = 1,
-	  .freq = 2412},
-	{ .chan = 2,
-	  .freq = 2417},
-	{ .chan = 3,
-	  .freq = 2422},
-	{ .chan = 4,
-	  .freq = 2427},
-	{ .chan = 5,
-	  .freq = 2432},
-	{ .chan = 6,
-	  .freq = 2437},
-	{ .chan = 7,
-	  .freq = 2442},
-	{ .chan = 8,
-	  .freq = 2447},
-	{ .chan = 9,
-	  .freq = 2452},
-	{ .chan = 10,
-	  .freq = 2457},
-	{ .chan = 11,
-	  .freq = 2462},
-	{ .chan = 12,
-	  .freq = 2467},
-	{ .chan = 13,
-	  .freq = 2472},
-	{ .chan = 14,
-	  .freq = 2484}
-};
-
 #endif /* PRISM54COMMON_H */
--- everything.orig/drivers/net/wireless/b43legacy/b43legacy.h	2008-01-24 19:34:51.063586263 +0100
+++ everything/drivers/net/wireless/b43legacy/b43legacy.h	2008-01-24 19:35:11.723585667 +0100
@@ -395,10 +395,6 @@ struct b43legacy_phy {
 	u8 possible_phymodes;
 	/* GMODE bit enabled in MACCTL? */
 	bool gmode;
-	/* Possible ieee80211 subsystem hwmodes for this PHY.
-	 * Which mode is selected, depends on thr GMODE enabled bit */
-#define B43legacy_MAX_PHYHWMODES	2
-	struct ieee80211_hw_mode hwmodes[B43legacy_MAX_PHYHWMODES];
 
 	/* Analog Type */
 	u8 analog;
--- everything.orig/drivers/net/wireless/b43legacy/main.c	2008-01-24 19:34:51.083587837 +0100
+++ everything/drivers/net/wireless/b43legacy/main.c	2008-01-24 19:35:11.723585667 +0100
@@ -93,28 +93,29 @@ MODULE_DEVICE_TABLE(ssb, b43legacy_ssb_t
  * data in there. This data is the same for all devices, so we don't
  * get concurrency issues */
 #define RATETAB_ENT(_rateid, _flags) \
-	{							\
-		.rate	= B43legacy_RATE_TO_100KBPS(_rateid),	\
-		.val	= (_rateid),				\
-		.val2	= (_rateid),				\
-		.flags	= (_flags),				\
-	}
+	{								\
+		.bitrate	= B43legacy_RATE_TO_100KBPS(_rateid),	\
+		.hw_value	= (_rateid),				\
+		.flags		= (_flags),				\
+	}
+/*
+ * NOTE: When changing this, sync with xmit.c's
+ *	 b43legacy_plcp_get_bitrate_idx_* functions!
+ */
 static struct ieee80211_rate __b43legacy_ratetable[] = {
-	RATETAB_ENT(B43legacy_CCK_RATE_1MB, IEEE80211_RATE_CCK),
-	RATETAB_ENT(B43legacy_CCK_RATE_2MB, IEEE80211_RATE_CCK_2),
-	RATETAB_ENT(B43legacy_CCK_RATE_5MB, IEEE80211_RATE_CCK_2),
-	RATETAB_ENT(B43legacy_CCK_RATE_11MB, IEEE80211_RATE_CCK_2),
-	RATETAB_ENT(B43legacy_OFDM_RATE_6MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43legacy_OFDM_RATE_9MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43legacy_OFDM_RATE_12MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43legacy_OFDM_RATE_18MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43legacy_OFDM_RATE_24MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43legacy_OFDM_RATE_36MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43legacy_OFDM_RATE_48MB, IEEE80211_RATE_OFDM),
-	RATETAB_ENT(B43legacy_OFDM_RATE_54MB, IEEE80211_RATE_OFDM),
+	RATETAB_ENT(B43legacy_CCK_RATE_1MB, 0),
+	RATETAB_ENT(B43legacy_CCK_RATE_2MB, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATETAB_ENT(B43legacy_CCK_RATE_5MB, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATETAB_ENT(B43legacy_CCK_RATE_11MB, IEEE80211_RATE_SHORT_PREAMBLE),
+	RATETAB_ENT(B43legacy_OFDM_RATE_6MB, 0),
+	RATETAB_ENT(B43legacy_OFDM_RATE_9MB, 0),
+	RATETAB_ENT(B43legacy_OFDM_RATE_12MB, 0),
+	RATETAB_ENT(B43legacy_OFDM_RATE_18MB, 0),
+	RATETAB_ENT(B43legacy_OFDM_RATE_24MB, 0),
+	RATETAB_ENT(B43legacy_OFDM_RATE_36MB, 0),
+	RATETAB_ENT(B43legacy_OFDM_RATE_48MB, 0),
+	RATETAB_ENT(B43legacy_OFDM_RATE_54MB, 0),
 };
-#define b43legacy_a_ratetable		(__b43legacy_ratetable + 4)
-#define b43legacy_a_ratetable_size	8
 #define b43legacy_b_ratetable		(__b43legacy_ratetable + 0)
 #define b43legacy_b_ratetable_size	4
 #define b43legacy_g_ratetable		(__b43legacy_ratetable + 0)
@@ -122,14 +123,8 @@ static struct ieee80211_rate __b43legacy
 
 #define CHANTAB_ENT(_chanid, _freq) \
 	{							\
-		.chan	= (_chanid),				\
-		.freq	= (_freq),				\
-		.val	= (_chanid),				\
-		.flag	= IEEE80211_CHAN_W_SCAN |		\
-			  IEEE80211_CHAN_W_ACTIVE_SCAN |	\
-			  IEEE80211_CHAN_W_IBSS,		\
-		.power_level	= 0x0A,				\
-		.antenna_max	= 0xFF,				\
+		.center_freq	= (_freq),			\
+		.hw_value	= (_chanid),			\
 	}
 static struct ieee80211_channel b43legacy_bg_chantable[] = {
 	CHANTAB_ENT(1, 2412),
@@ -147,7 +142,20 @@ static struct ieee80211_channel b43legac
 	CHANTAB_ENT(13, 2472),
 	CHANTAB_ENT(14, 2484),
 };
-#define b43legacy_bg_chantable_size	ARRAY_SIZE(b43legacy_bg_chantable)
+
+static struct ieee80211_supported_band b43legacy_band_2GHz_BPHY = {
+	.channels = b43legacy_bg_chantable,
+	.n_channels = ARRAY_SIZE(b43legacy_bg_chantable),
+	.bitrates = b43legacy_b_ratetable,
+	.n_bitrates = b43legacy_b_ratetable_size,
+};
+
+static struct ieee80211_supported_band b43legacy_band_2GHz_GPHY = {
+	.channels = b43legacy_bg_chantable,
+	.n_channels = ARRAY_SIZE(b43legacy_bg_chantable),
+	.bitrates = b43legacy_g_ratetable,
+	.n_bitrates = b43legacy_g_ratetable_size,
+};
 
 static void b43legacy_wireless_core_exit(struct b43legacy_wldev *dev);
 static int b43legacy_wireless_core_init(struct b43legacy_wldev *dev);
@@ -967,18 +975,18 @@ static void b43legacy_write_beacon_templ
 
 static void b43legacy_write_probe_resp_plcp(struct b43legacy_wldev *dev,
 					    u16 shm_offset, u16 size,
-					    u8 rate)
+					    struct ieee80211_rate *rate)
 {
 	struct b43legacy_plcp_hdr4 plcp;
 	u32 tmp;
 	__le16 dur;
 
 	plcp.data = 0;
-	b43legacy_generate_plcp_hdr(&plcp, size + FCS_LEN, rate);
+	b43legacy_generate_plcp_hdr(&plcp, size + FCS_LEN, rate->bitrate);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
 					       dev->wl->vif,
 					       size,
-					       B43legacy_RATE_TO_100KBPS(rate));
+					       rate);
 	/* Write PLCP in two parts and timing for packet transfer */
 	tmp = le32_to_cpu(plcp.data);
 	b43legacy_shm_write16(dev, B43legacy_SHM_SHARED, shm_offset,
@@ -996,7 +1004,8 @@ static void b43legacy_write_probe_resp_p
  * 3) Stripping TIM
  */
 static u8 *b43legacy_generate_probe_resp(struct b43legacy_wldev *dev,
-					 u16 *dest_size, u8 rate)
+					 u16 *dest_size,
+					 struct ieee80211_rate *rate)
 {
 	const u8 *src_data;
 	u8 *dest_data;
@@ -1044,7 +1053,7 @@ static u8 *b43legacy_generate_probe_resp
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
 					       dev->wl->vif,
 					       *dest_size,
-					       B43legacy_RATE_TO_100KBPS(rate));
+					       rate);
 	hdr->duration_id = dur;
 
 	return dest_data;
@@ -1052,7 +1061,8 @@ static u8 *b43legacy_generate_probe_resp
 
 static void b43legacy_write_probe_resp_template(struct b43legacy_wldev *dev,
 						u16 ram_offset,
-						u16 shm_size_offset, u8 rate)
+						u16 shm_size_offset,
+						struct ieee80211_rate *rate)
 {
 	u8 *probe_resp_data;
 	u16 size;
@@ -1067,19 +1077,19 @@ static void b43legacy_write_probe_resp_t
 	 * all possible basic rates
 	 */
 	b43legacy_write_probe_resp_plcp(dev, 0x31A, size,
-					B43legacy_CCK_RATE_1MB);
+					&b43legacy_b_ratetable[0]);
 	b43legacy_write_probe_resp_plcp(dev, 0x32C, size,
-					B43legacy_CCK_RATE_2MB);
+					&b43legacy_b_ratetable[1]);
 	b43legacy_write_probe_resp_plcp(dev, 0x33E, size,
-					B43legacy_CCK_RATE_5MB);
+					&b43legacy_b_ratetable[2]);
 	b43legacy_write_probe_resp_plcp(dev, 0x350, size,
-					B43legacy_CCK_RATE_11MB);
+					&b43legacy_b_ratetable[3]);
 
 	size = min((size_t)size,
 		   0x200 - sizeof(struct b43legacy_plcp_hdr6));
 	b43legacy_write_template_common(dev, probe_resp_data,
 					size, ram_offset,
-					shm_size_offset, rate);
+					shm_size_offset, rate->bitrate);
 	kfree(probe_resp_data);
 }
 
@@ -1104,7 +1114,7 @@ static void b43legacy_update_templates(s
 	b43legacy_write_beacon_template(dev, 0x468, 0x1A,
 					B43legacy_CCK_RATE_1MB);
 	b43legacy_write_probe_resp_template(dev, 0x268, 0x4A,
-					    B43legacy_CCK_RATE_11MB);
+					    &b43legacy_b_ratetable[0]);
 
 	status = b43legacy_read32(dev, B43legacy_MMIO_STATUS2_BITFIELD);
 	status |= 0x03;
@@ -2518,14 +2528,16 @@ static int b43legacy_op_dev_config(struc
 	antenna_rx = b43legacy_antenna_from_ieee80211(conf->antenna_sel_rx);
 
 	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	phy = &dev->phy;
 
 	/* Switch the PHY mode (if necessary). */
-	switch (conf->phymode) {
-	case MODE_IEEE80211B:
-		new_phymode = B43legacy_PHYMODE_B;
-		break;
-	case MODE_IEEE80211G:
-		new_phymode = B43legacy_PHYMODE_G;
+	switch (conf->channel->band) {
+	case IEEE80211_BAND_2GHZ:
+		if (phy->type == B43legacy_PHYTYPE_B)
+			new_phymode = B43legacy_PHYMODE_B;
+		else
+			new_phymode = B43legacy_PHYMODE_G;
 		break;
 	default:
 		B43legacy_WARN_ON(1);
@@ -2533,8 +2545,6 @@ static int b43legacy_op_dev_config(struc
 	err = b43legacy_switch_phymode(wl, new_phymode);
 	if (err)
 		goto out_unlock_mutex;
-	dev = wl->current_dev;
-	phy = &dev->phy;
 
 	/* Disable IRQs while reconfiguring the device.
 	 * This makes it possible to drop the spinlock throughout
@@ -2550,8 +2560,8 @@ static int b43legacy_op_dev_config(struc
 
 	/* Switch to the requested channel.
 	 * The firmware takes care of races with the TX handler. */
-	if (conf->channel_val != phy->channel)
-		b43legacy_radio_selectchannel(dev, conf->channel_val, 0);
+	if (conf->channel->hw_value != phy->channel)
+		b43legacy_radio_selectchannel(dev, conf->channel->hw_value, 0);
 
 	/* Enable/Disable ShortSlot timing. */
 	if ((!!(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME))
@@ -3347,48 +3357,19 @@ static int b43legacy_setup_modes(struct 
 				 int have_gphy)
 {
 	struct ieee80211_hw *hw = dev->wl->hw;
-	struct ieee80211_hw_mode *mode;
 	struct b43legacy_phy *phy = &dev->phy;
-	int cnt = 0;
-	int err;
 
 	phy->possible_phymodes = 0;
-	for (; 1; cnt++) {
-		if (have_bphy) {
-			B43legacy_WARN_ON(cnt >= B43legacy_MAX_PHYHWMODES);
-			mode = &phy->hwmodes[cnt];
-
-			mode->mode = MODE_IEEE80211B;
-			mode->num_channels = b43legacy_bg_chantable_size;
-			mode->channels = b43legacy_bg_chantable;
-			mode->num_rates = b43legacy_b_ratetable_size;
-			mode->rates = b43legacy_b_ratetable;
-			err = ieee80211_register_hwmode(hw, mode);
-			if (err)
-				return err;
-
-			phy->possible_phymodes |= B43legacy_PHYMODE_B;
-			have_bphy = 0;
-			continue;
-		}
-		if (have_gphy) {
-			B43legacy_WARN_ON(cnt >= B43legacy_MAX_PHYHWMODES);
-			mode = &phy->hwmodes[cnt];
-
-			mode->mode = MODE_IEEE80211G;
-			mode->num_channels = b43legacy_bg_chantable_size;
-			mode->channels = b43legacy_bg_chantable;
-			mode->num_rates = b43legacy_g_ratetable_size;
-			mode->rates = b43legacy_g_ratetable;
-			err = ieee80211_register_hwmode(hw, mode);
-			if (err)
-				return err;
-
-			phy->possible_phymodes |= B43legacy_PHYMODE_G;
-			have_gphy = 0;
-			continue;
-		}
-		break;
+	if (have_bphy) {
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+			&b43legacy_band_2GHz_BPHY;
+		phy->possible_phymodes |= B43legacy_PHYMODE_B;
+	}
+
+	if (have_gphy) {
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+			&b43legacy_band_2GHz_GPHY;
+		phy->possible_phymodes |= B43legacy_PHYMODE_G;
 	}
 
 	return 0;
--- everything.orig/drivers/net/wireless/b43legacy/xmit.c	2008-01-24 19:34:51.143587945 +0100
+++ everything/drivers/net/wireless/b43legacy/xmit.c	2008-01-24 19:35:11.723585667 +0100
@@ -37,45 +37,48 @@
 
 
 /* Extract the bitrate out of a CCK PLCP header. */
-static u8 b43legacy_plcp_get_bitrate_cck(struct b43legacy_plcp_hdr6 *plcp)
+static u8 b43legacy_plcp_get_bitrate_idx_cck(struct b43legacy_plcp_hdr6 *plcp)
 {
 	switch (plcp->raw[0]) {
 	case 0x0A:
-		return B43legacy_CCK_RATE_1MB;
+		return 0;
 	case 0x14:
-		return B43legacy_CCK_RATE_2MB;
+		return 1;
 	case 0x37:
-		return B43legacy_CCK_RATE_5MB;
+		return 2;
 	case 0x6E:
-		return B43legacy_CCK_RATE_11MB;
+		return 3;
 	}
 	B43legacy_BUG_ON(1);
-	return 0;
+	return -1;
 }
 
 /* Extract the bitrate out of an OFDM PLCP header. */
-static u8 b43legacy_plcp_get_bitrate_ofdm(struct b43legacy_plcp_hdr6 *plcp)
+static u8 b43legacy_plcp_get_bitrate_idx_ofdm(struct b43legacy_plcp_hdr6 *plcp,
+					      bool aphy)
 {
+	int base = aphy ? 0 : 4;
+
 	switch (plcp->raw[0] & 0xF) {
 	case 0xB:
-		return B43legacy_OFDM_RATE_6MB;
+		return base + 0;
 	case 0xF:
-		return B43legacy_OFDM_RATE_9MB;
+		return base + 1;
 	case 0xA:
-		return B43legacy_OFDM_RATE_12MB;
+		return base + 2;
 	case 0xE:
-		return B43legacy_OFDM_RATE_18MB;
+		return base + 3;
 	case 0x9:
-		return B43legacy_OFDM_RATE_24MB;
+		return base + 4;
 	case 0xD:
-		return B43legacy_OFDM_RATE_36MB;
+		return base + 5;
 	case 0x8:
-		return B43legacy_OFDM_RATE_48MB;
+		return base + 6;
 	case 0xC:
-		return B43legacy_OFDM_RATE_54MB;
+		return base + 7;
 	}
 	B43legacy_BUG_ON(1);
-	return 0;
+	return -1;
 }
 
 u8 b43legacy_plcp_get_ratecode_cck(const u8 bitrate)
@@ -192,7 +195,7 @@ static void generate_txhdr_fw3(struct b4
 	int use_encryption = (!(txctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT));
 	u16 fctl;
 	u8 rate;
-	u8 rate_fb;
+	struct ieee80211_rate *rate_fb;
 	int rate_ofdm;
 	int rate_fb_ofdm;
 	unsigned int plcp_fragment_len;
@@ -204,16 +207,16 @@ static void generate_txhdr_fw3(struct b4
 
 	memset(txhdr, 0, sizeof(*txhdr));
 
-	rate = txctl->tx_rate;
+	rate = txctl->tx_rate->hw_value;
 	rate_ofdm = b43legacy_is_ofdm_rate(rate);
-	rate_fb = (txctl->alt_retry_rate == -1) ? rate : txctl->alt_retry_rate;
-	rate_fb_ofdm = b43legacy_is_ofdm_rate(rate_fb);
+	rate_fb = txctl->alt_retry_rate ? : txctl->tx_rate;
+	rate_fb_ofdm = b43legacy_is_ofdm_rate(rate_fb->hw_value);
 
 	txhdr->mac_frame_ctl = wlhdr->frame_control;
 	memcpy(txhdr->tx_receiver, wlhdr->addr1, 6);
 
 	/* Calculate duration for fallback rate */
-	if ((rate_fb == rate) ||
+	if ((rate_fb->hw_value == rate) ||
 	    (wlhdr->duration_id & cpu_to_le16(0x8000)) ||
 	    (wlhdr->duration_id == cpu_to_le16(0))) {
 		/* If the fallback rate equals the normal rate or the
@@ -221,11 +224,10 @@ static void generate_txhdr_fw3(struct b4
 		 * use the original dur_id field. */
 		txhdr->dur_fb = wlhdr->duration_id;
 	} else {
-		int fbrate_base100kbps = B43legacy_RATE_TO_100KBPS(rate_fb);
 		txhdr->dur_fb = ieee80211_generic_frame_duration(dev->wl->hw,
 							 txctl->vif,
 							 fragment_len,
-							 fbrate_base100kbps);
+							 rate_fb);
 	}
 
 	plcp_fragment_len = fragment_len + FCS_LEN;
@@ -259,7 +261,7 @@ static void generate_txhdr_fw3(struct b4
 				    rate);
 	b43legacy_generate_plcp_hdr((struct b43legacy_plcp_hdr4 *)
 				    (&txhdr->plcp_fb), plcp_fragment_len,
-				    rate_fb);
+				    rate_fb->hw_value);
 
 	/* PHY TX Control word */
 	if (rate_ofdm)
@@ -303,7 +305,7 @@ static void generate_txhdr_fw3(struct b4
 		int rts_rate_ofdm;
 		int rts_rate_fb_ofdm;
 
-		rts_rate = txctl->rts_cts_rate;
+		rts_rate = txctl->rts_cts_rate->hw_value;
 		rts_rate_ofdm = b43legacy_is_ofdm_rate(rts_rate);
 		rts_rate_fb = b43legacy_calc_fallback_rate(rts_rate);
 		rts_rate_fb_ofdm = b43legacy_is_ofdm_rate(rts_rate_fb);
@@ -527,10 +529,11 @@ void b43legacy_rx(struct b43legacy_wldev
 				      (phystat3 & B43legacy_RX_PHYST3_TRSTATE));
 	status.noise = dev->stats.link_noise;
 	status.signal = (jssi * 100) / B43legacy_RX_MAX_SSI;
+	/* change to support A PHY */
 	if (phystat0 & B43legacy_RX_PHYST0_OFDM)
-		status.rate = b43legacy_plcp_get_bitrate_ofdm(plcp);
+		status.rate_idx = b43legacy_plcp_get_bitrate_idx_ofdm(plcp, false);
 	else
-		status.rate = b43legacy_plcp_get_bitrate_cck(plcp);
+		status.rate_idx = b43legacy_plcp_get_bitrate_idx_cck(plcp);
 	status.antenna = !!(phystat0 & B43legacy_RX_PHYST0_ANT);
 
 	/*
@@ -555,14 +558,9 @@ void b43legacy_rx(struct b43legacy_wldev
 		  B43legacy_RX_CHAN_ID_SHIFT;
 	switch (chanstat & B43legacy_RX_CHAN_PHYTYPE) {
 	case B43legacy_PHYTYPE_B:
-		status.phymode = MODE_IEEE80211B;
-		status.freq = chanid + 2400;
-		status.channel = b43legacy_freq_to_channel_bg(chanid + 2400);
-		break;
 	case B43legacy_PHYTYPE_G:
-		status.phymode = MODE_IEEE80211G;
+		status.band = IEEE80211_BAND_2GHZ;
 		status.freq = chanid + 2400;
-		status.channel = b43legacy_freq_to_channel_bg(chanid + 2400);
 		break;
 	default:
 		b43legacywarn(dev->wl, "Unexpected value for chanstat (0x%X)\n",
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-01-24 19:34:51.163587348 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-01-24 19:35:11.733585992 +0100
@@ -129,7 +129,7 @@ static struct iwl3945_tpt_entry iwl3945_
 #define IWL_RATE_MIN_SUCCESS_TH       8
 #define IWL_RATE_DECREASE_TH       1920
 
-static u8 iwl3945_get_rate_index_by_rssi(s32 rssi, u8 mode)
+static u8 iwl3945_get_rate_index_by_rssi(s32 rssi, enum ieee80211_band band)
 {
 	u32 index = 0;
 	u32 table_size = 0;
@@ -138,21 +138,19 @@ static u8 iwl3945_get_rate_index_by_rssi
 	if ((rssi < IWL_MIN_RSSI_VAL) || (rssi > IWL_MAX_RSSI_VAL))
 		rssi = IWL_MIN_RSSI_VAL;
 
-	switch (mode) {
-	case MODE_IEEE80211G:
+	switch (band) {
+	case IEEE80211_BAND_2GHZ:
 		tpt_table = iwl3945_tpt_table_g;
 		table_size = ARRAY_SIZE(iwl3945_tpt_table_g);
 		break;
 
-	case MODE_IEEE80211A:
+	case IEEE80211_BAND_5GHZ:
 		tpt_table = iwl3945_tpt_table_a;
 		table_size = ARRAY_SIZE(iwl3945_tpt_table_a);
 		break;
 
 	default:
-	case MODE_IEEE80211B:
-		tpt_table = iwl3945_tpt_table_b;
-		table_size = ARRAY_SIZE(iwl3945_tpt_table_b);
+		BUG();
 		break;
 	}
 
@@ -340,17 +338,17 @@ static void rs_rate_init(void *priv_rate
 	 * after assoc.. */
 
 	for (i = IWL_RATE_COUNT - 1; i >= 0; i--) {
-		if (sta->supp_rates & (1 << i)) {
-			sta->txrate = i;
+		if (sta->supp_rates[local->hw.conf.channel->band] & (1 << i)) {
+			sta->txrate_idx = i;
 			break;
 		}
 	}
 
-	sta->last_txrate = sta->txrate;
+	sta->last_txrate_idx = sta->txrate_idx;
 
-	/* For MODE_IEEE80211A mode it start at IWL_FIRST_OFDM_RATE */
-        if (local->hw.conf.phymode == MODE_IEEE80211A)
-                sta->last_txrate += IWL_FIRST_OFDM_RATE;
+	/* For 5 GHz band it start at IWL_FIRST_OFDM_RATE */
+	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ)
+		sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 
 	IWL_DEBUG_RATE("leave\n");
 }
@@ -429,17 +427,19 @@ static int rs_adjust_next_rate(struct iw
 {
 	int next_rate = iwl3945_get_prev_ieee_rate(rate);
 
-	switch (priv->phymode) {
-	case MODE_IEEE80211A:
+	switch (priv->band) {
+	case IEEE80211_BAND_5GHZ:
 		if (rate == IWL_RATE_12M_INDEX)
 			next_rate = IWL_RATE_9M_INDEX;
 		else if (rate == IWL_RATE_6M_INDEX)
 			next_rate = IWL_RATE_6M_INDEX;
 		break;
+/* XXX cannot be invoked in current mac80211 so not a regression
 	case MODE_IEEE80211B:
 		if (rate == IWL_RATE_11M_INDEX_TABLE)
 			next_rate = IWL_RATE_5M_INDEX_TABLE;
 		break;
+ */
 	default:
 		break;
 	}
@@ -465,15 +465,17 @@ static void rs_tx_status(void *priv_rate
 	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_rate;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct iwl3945_rs_sta *rs_sta;
+	struct ieee80211_supported_band *sband;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	IWL_DEBUG_RATE("enter\n");
 
 	retries = tx_resp->retry_count;
 
-	first_index = tx_resp->control.tx_rate;
+	first_index = &sband->bitrates[0] - tx_resp->control.tx_rate;
 	if ((first_index < 0) || (first_index >= IWL_RATE_COUNT)) {
-		IWL_DEBUG_RATE("leave: Rate out of bounds: %0x for %d\n",
-			       tx_resp->control.tx_rate, first_index);
+		IWL_DEBUG_RATE("leave: Rate out of bounds: %d\n", first_index);
 		return;
 	}
 
@@ -561,14 +563,14 @@ static void rs_tx_status(void *priv_rate
 }
 
 static u16 iwl3945_get_adjacent_rate(struct iwl3945_rs_sta *rs_sta,
-				 u8 index, u16 rate_mask, int phymode)
+				 u8 index, u16 rate_mask, enum ieee80211_band band)
 {
 	u8 high = IWL_RATE_INVALID;
 	u8 low = IWL_RATE_INVALID;
 
 	/* 802.11A walks to the next literal adjacent rate in
 	 * the rate table */
-	if (unlikely(phymode == MODE_IEEE80211A)) {
+	if (unlikely(band == IEEE80211_BAND_5GHZ)) {
 		int i;
 		u32 mask;
 
@@ -639,7 +641,8 @@ static u16 iwl3945_get_adjacent_rate(str
  *
  */
 static void rs_get_rate(void *priv_rate, struct net_device *dev,
-			struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			struct ieee80211_supported_band *band,
+			struct sk_buff *skb,
 			struct rate_selection *sel)
 {
 	u8 low = IWL_RATE_INVALID;
@@ -672,16 +675,16 @@ static void rs_get_rate(void *priv_rate,
 	    is_multicast_ether_addr(hdr->addr1) ||
 	    !sta || !sta->rate_ctrl_priv) {
 		IWL_DEBUG_RATE("leave: No STA priv data to update!\n");
-		sel->rate = rate_lowest(local, local->oper_hw_mode, sta);
+		sel->rate = rate_lowest(local, band, sta);
 		if (sta)
 			sta_info_put(sta);
 		return;
 	}
 
-	rate_mask = sta->supp_rates;
-	index = min(sta->last_txrate & 0xffff, IWL_RATE_COUNT - 1);
+	rate_mask = sta->supp_rates[band->band];
+	index = min(sta->last_txrate_idx & 0xffff, IWL_RATE_COUNT - 1);
 
-	if (priv->phymode == (u8) MODE_IEEE80211A)
+	if (priv->band == IEEE80211_BAND_5GHZ)
 		rate_mask = rate_mask << IWL_FIRST_OFDM_RATE;
 
 	rs_sta = (void *)sta->rate_ctrl_priv;
@@ -732,7 +735,7 @@ static void rs_get_rate(void *priv_rate,
 	current_tpt = window->average_tpt;
 
 	high_low = iwl3945_get_adjacent_rate(rs_sta, index, rate_mask,
-					 local->hw.conf.phymode);
+					     band->band);
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
 
@@ -810,11 +813,11 @@ static void rs_get_rate(void *priv_rate,
 
  out:
 
-	sta->last_txrate = index;
-	if (priv->phymode == (u8) MODE_IEEE80211A)
-		sta->txrate = sta->last_txrate - IWL_FIRST_OFDM_RATE;
+	sta->last_txrate_idx = index;
+	if (priv->band == IEEE80211_BAND_5GHZ)
+		sta->txrate_idx = sta->last_txrate_idx - IWL_FIRST_OFDM_RATE;
 	else
-		sta->txrate = sta->last_txrate;
+		sta->txrate_idx = sta->last_txrate_idx;
 
 	sta_info_put(sta);
 
@@ -945,8 +948,9 @@ void iwl3945_rate_scale_init(struct ieee
 	spin_lock_irqsave(&rs_sta->lock, flags);
 
 	rs_sta->tgg = 0;
-	switch (priv->phymode) {
-	case MODE_IEEE80211G:
+	switch (priv->band) {
+	case IEEE80211_BAND_2GHZ:
+		/* TODO: this always does G, not a regression */
 		if (priv->active_rxon.flags & RXON_FLG_TGG_PROTECT_MSK) {
 			rs_sta->tgg = 1;
 			rs_sta->expected_tpt = iwl3945_expected_tpt_g_prot;
@@ -954,14 +958,11 @@ void iwl3945_rate_scale_init(struct ieee
 			rs_sta->expected_tpt = iwl3945_expected_tpt_g;
 		break;
 
-	case MODE_IEEE80211A:
+	case IEEE80211_BAND_5GHZ:
 		rs_sta->expected_tpt = iwl3945_expected_tpt_a;
 		break;
-
-	default:
-		IWL_WARNING("Invalid phymode.  Defaulting to 802.11b\n");
-	case MODE_IEEE80211B:
-		rs_sta->expected_tpt = iwl3945_expected_tpt_b;
+	case IEEE80211_NUM_BANDS:
+		BUG();
 		break;
 	}
 
@@ -974,8 +975,7 @@ void iwl3945_rate_scale_init(struct ieee
 
 	IWL_DEBUG(IWL_DL_INFO | IWL_DL_RATE, "Network RSSI: %d\n", rssi);
 
-	rs_sta->start_rate =
-			iwl3945_get_rate_index_by_rssi(rssi, priv->phymode);
+	rs_sta->start_rate = iwl3945_get_rate_index_by_rssi(rssi, priv->band);
 
 	IWL_DEBUG_RATE("leave: rssi %d assign rate index: "
 		       "%d (plcp 0x%x)\n", rssi, rs_sta->start_rate,
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2008-01-24 19:35:08.443586697 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945.c	2008-01-24 19:35:11.743586643 +0100
@@ -246,7 +246,7 @@ void iwl3945_add_radiotap(struct iwl3945
 	 * the information provided in the skb from the hardware */
 	s8 signal = stats->ssi;
 	s8 noise = 0;
-	int rate = stats->rate;
+	int rate = stats->rate_idx;
 	u64 tsf = stats->mactime;
 	__le16 phy_flags_hw = rx_hdr->phy_flags;
 
@@ -314,7 +314,6 @@ void iwl3945_add_radiotap(struct iwl3945
 					  IEEE80211_CHAN_2GHZ),
 			      &iwl3945_rt->rt_chbitmask);
 
-	rate = iwl3945_rate_index_from_plcp(rate);
 	if (rate == -1)
 		iwl3945_rt->rt_rate = 0;
 	else
@@ -386,11 +385,10 @@ static void iwl3945_rx_reply_rx(struct i
 	struct ieee80211_rx_status stats = {
 		.mactime = le64_to_cpu(rx_end->timestamp),
 		.freq = ieee80211chan2mhz(le16_to_cpu(rx_hdr->channel)),
-		.channel = le16_to_cpu(rx_hdr->channel),
-		.phymode = (rx_hdr->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
-		MODE_IEEE80211G : MODE_IEEE80211A,
+		.band = (rx_hdr->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
+		IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ,
 		.antenna = 0,
-		.rate = rx_hdr->rate,
+		.rate_idx = iwl3945_rate_index_from_plcp(rx_hdr->rate),
 		.flag = 0,
 	};
 	u8 network_packet;
@@ -449,8 +447,6 @@ static void iwl3945_rx_reply_rx(struct i
 			stats.ssi, stats.noise, stats.signal,
 			rx_stats_sig_avg, rx_stats_noise_diff);
 
-	stats.freq = ieee80211chan2mhz(stats.channel);
-
 	/* can be covered by iwl3945_report_frame() in most cases */
 /*      IWL_DEBUG_RX("RX status: 0x%08X\n", rx_end->status); */
 
@@ -463,8 +459,9 @@ static void iwl3945_rx_reply_rx(struct i
 		IWL_DEBUG_STATS
 		    ("[%c] %d RSSI: %d Signal: %u, Noise: %u, Rate: %u\n",
 		     network_packet ? '*' : ' ',
-		     stats.channel, stats.ssi, stats.ssi,
-		     stats.ssi, stats.rate);
+		     le16_to_cpu(rx_hdr->channel),
+		     stats.ssi, stats.ssi,
+		     stats.ssi, stats.rate_idx);
 
 	if (iwl3945_debug_level & (IWL_DL_RX))
 		/* Set "1" to report good data frames in groups of 100 */
@@ -688,7 +685,7 @@ void iwl3945_hw_build_tx_cmd_rate(struct
 			      struct ieee80211_hdr *hdr, int sta_id, int tx_id)
 {
 	unsigned long flags;
-	u16 rate_index = min(ctrl->tx_rate & 0xffff, IWL_RATE_COUNT - 1);
+	u16 rate_index = min(ctrl->tx_rate->hw_value & 0xffff, IWL_RATE_COUNT - 1);
 	u16 rate_mask;
 	int rate;
 	u8 rts_retry_limit;
@@ -1551,14 +1548,14 @@ int iwl3945_hw_reg_send_txpower(struct i
 		.channel = priv->active_rxon.channel,
 	};
 
-	txpower.band = (priv->phymode == MODE_IEEE80211A) ? 0 : 1;
+	txpower.band = (priv->band == IEEE80211_BAND_5GHZ) ? 0 : 1;
 	ch_info = iwl3945_get_channel_info(priv,
-				       priv->phymode,
+				       priv->band,
 				       le16_to_cpu(priv->active_rxon.channel));
 	if (!ch_info) {
 		IWL_ERROR
 		    ("Failed to get channel info for channel %d [%d]\n",
-		     le16_to_cpu(priv->active_rxon.channel), priv->phymode);
+		     le16_to_cpu(priv->active_rxon.channel), priv->band);
 		return -EINVAL;
 	}
 
@@ -2240,8 +2237,8 @@ int iwl3945_init_hw_rate_table(struct iw
 		table[index].next_rate_index = iwl3945_rates[prev_index].table_rs_index;
 	}
 
-	switch (priv->phymode) {
-	case MODE_IEEE80211A:
+	switch (priv->band) {
+	case IEEE80211_BAND_5GHZ:
 		IWL_DEBUG_RATE("Select A mode rate scale\n");
 		/* If one of the following CCK rates is used,
 		 * have it fall back to the 6M OFDM rate */
@@ -2256,8 +2253,8 @@ int iwl3945_init_hw_rate_table(struct iw
 		    iwl3945_rates[IWL_FIRST_OFDM_RATE].table_rs_index;
 		break;
 
-	case MODE_IEEE80211B:
-		IWL_DEBUG_RATE("Select B mode rate scale\n");
+	case IEEE80211_BAND_2GHZ:
+		IWL_DEBUG_RATE("Select B/G mode rate scale\n");
 		/* If an OFDM rate is used, have it fall back to the
 		 * 1M CCK rates */
 		for (i = IWL_RATE_6M_INDEX_TABLE; i <= IWL_RATE_54M_INDEX_TABLE; i++)
@@ -2268,7 +2265,7 @@ int iwl3945_init_hw_rate_table(struct iw
 		break;
 
 	default:
-		IWL_DEBUG_RATE("Select G mode rate scale\n");
+		WARN_ON(1);
 		break;
 	}
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-01-24 19:35:10.133586426 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-01-24 19:35:11.743586643 +0100
@@ -195,7 +195,7 @@ struct iwl3945_channel_info {
 
 	u8 group_index;	  /* 0-4, maps channel to group1/2/3/4/5 */
 	u8 band_index;	  /* 0-4, maps channel to band1/2/3/4/5 */
-	u8 phymode;	  /* MODE_IEEE80211{A,B,G} */
+	enum ieee80211_band band;
 
 	/* Radio/DSP gain settings for each "normal" data Tx rate.
 	 * These include, in addition to RF and DSP gain, a few fields for
@@ -699,14 +699,14 @@ struct iwl3945_priv {
 	struct list_head free_frames;
 	int frames_count;
 
-	u8 phymode;
+	enum ieee80211_band band;
 	int alloc_rxb_skb;
 	bool add_radiotap;
 
 	void (*rx_handlers[REPLY_MAX])(struct iwl3945_priv *priv,
 				       struct iwl3945_rx_mem_buffer *rxb);
 
-	const struct ieee80211_hw_mode *modes;
+	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 	/* spectrum measurement report caching */
@@ -937,13 +937,12 @@ static inline int is_channel_radar(const
 
 static inline u8 is_channel_a_band(const struct iwl3945_channel_info *ch_info)
 {
-	return ch_info->phymode == MODE_IEEE80211A;
+	return ch_info->band == IEEE80211_BAND_5GHZ;
 }
 
 static inline u8 is_channel_bg_band(const struct iwl3945_channel_info *ch_info)
 {
-	return ((ch_info->phymode == MODE_IEEE80211B) ||
-		(ch_info->phymode == MODE_IEEE80211G));
+	return ch_info->band == IEEE80211_BAND_2GHZ;
 }
 
 static inline int is_channel_passive(const struct iwl3945_channel_info *ch)
@@ -967,7 +966,7 @@ static inline int iwl3945_rate_index_fro
 }
 
 extern const struct iwl3945_channel_info *iwl3945_get_channel_info(
-	const struct iwl3945_priv *priv, int phymode, u16 channel);
+	const struct iwl3945_priv *priv, enum ieee80211_band band, u16 channel);
 
 /* Requires full declaration of iwl3945_priv before including */
 #include "iwl-3945-io.h"
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-01-24 19:35:10.143587186 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-01-24 19:35:11.773585287 +0100
@@ -116,16 +116,10 @@ static __le16 *ieee80211_get_qos_ctrl(st
 	return NULL;
 }
 
-static const struct ieee80211_hw_mode *iwl3945_get_hw_mode(
-		struct iwl3945_priv *priv, int mode)
+static const struct ieee80211_supported_band *iwl3945_get_band(
+		struct iwl3945_priv *priv, enum ieee80211_band band)
 {
-	int i;
-
-	for (i = 0; i < 3; i++)
-		if (priv->modes[i].mode == mode)
-			return &priv->modes[i];
-
-	return NULL;
+	return priv->hw->wiphy->bands[band];
 }
 
 static int iwl3945_is_empty_essid(const char *essid, int essid_len)
@@ -547,7 +541,7 @@ u8 iwl3945_add_station(struct iwl3945_pr
 	station->sta.sta.sta_id = index;
 	station->sta.station_flags = 0;
 
-	if (priv->phymode == MODE_IEEE80211A)
+	if (priv->band == IEEE80211_BAND_5GHZ)
 		rate = IWL_RATE_6M_PLCP;
 	else
 		rate =	IWL_RATE_1M_PLCP;
@@ -888,35 +882,37 @@ int iwl3945_send_statistics_request(stru
 
 /**
  * iwl3945_set_rxon_channel - Set the phymode and channel values in staging RXON
- * @phymode: MODE_IEEE80211A sets to 5.2GHz; all else set to 2.4GHz
- * @channel: Any channel valid for the requested phymode
+ * @band: 2.4 or 5 GHz band
+ * @channel: Any channel valid for the requested band
 
- * In addition to setting the staging RXON, priv->phymode is also set.
+ * In addition to setting the staging RXON, priv->band is also set.
  *
  * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
- * in the staging RXON flag structure based on the phymode
+ * in the staging RXON flag structure based on the band
  */
-static int iwl3945_set_rxon_channel(struct iwl3945_priv *priv, u8 phymode, u16 channel)
+static int iwl3945_set_rxon_channel(struct iwl3945_priv *priv,
+				    enum ieee80211_band band,
+				    u16 channel)
 {
-	if (!iwl3945_get_channel_info(priv, phymode, channel)) {
+	if (!iwl3945_get_channel_info(priv, band, channel)) {
 		IWL_DEBUG_INFO("Could not set channel to %d [%d]\n",
-			       channel, phymode);
+			       channel, band);
 		return -EINVAL;
 	}
 
 	if ((le16_to_cpu(priv->staging_rxon.channel) == channel) &&
-	    (priv->phymode == phymode))
+	    (priv->band == band))
 		return 0;
 
 	priv->staging_rxon.channel = cpu_to_le16(channel);
-	if (phymode == MODE_IEEE80211A)
+	if (band == IEEE80211_BAND_5GHZ)
 		priv->staging_rxon.flags &= ~RXON_FLG_BAND_24G_MSK;
 	else
 		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
 
-	priv->phymode = phymode;
+	priv->band = band;
 
-	IWL_DEBUG_INFO("Staging channel set to %d [%d]\n", channel, phymode);
+	IWL_DEBUG_INFO("Staging channel set to %d [%d]\n", channel, band);
 
 	return 0;
 }
@@ -1204,8 +1200,7 @@ static int iwl3945_commit_rxon(struct iw
 			return -EIO;
 		}
 
-	/* Init the hardware's rate fallback order based on the
-	 * phymode */
+	/* Init the hardware's rate fallback order based on the band */
 	rc = iwl3945_init_hw_rate_table(priv);
 	if (rc) {
 		IWL_ERROR("Error setting HW rate table: %02X\n", rc);
@@ -2455,9 +2450,10 @@ static int iwl3945_set_rxon_hwcrypto(str
 	return 0;
 }
 
-static void iwl3945_set_flags_for_phymode(struct iwl3945_priv *priv, u8 phymode)
+static void iwl3945_set_flags_for_phymode(struct iwl3945_priv *priv,
+					  enum ieee80211_band band)
 {
-	if (phymode == MODE_IEEE80211A) {
+	if (band == IEEE80211_BAND_5GHZ) {
 		priv->staging_rxon.flags &=
 		    ~(RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK
 		      | RXON_FLG_CCK_MSK);
@@ -2520,7 +2516,7 @@ static void iwl3945_connection_init_rx_c
 		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 #endif
 
-	ch_info = iwl3945_get_channel_info(priv, priv->phymode,
+	ch_info = iwl3945_get_channel_info(priv, priv->band,
 				       le16_to_cpu(priv->staging_rxon.channel));
 
 	if (!ch_info)
@@ -2536,11 +2532,11 @@ static void iwl3945_connection_init_rx_c
 
 	priv->staging_rxon.channel = cpu_to_le16(ch_info->channel);
 	if (is_channel_a_band(ch_info))
-		priv->phymode = MODE_IEEE80211A;
+		priv->band = IEEE80211_BAND_5GHZ;
 	else
-		priv->phymode = MODE_IEEE80211G;
+		priv->band = IEEE80211_BAND_2GHZ;
 
-	iwl3945_set_flags_for_phymode(priv, priv->phymode);
+	iwl3945_set_flags_for_phymode(priv, priv->band);
 
 	priv->staging_rxon.ofdm_basic_rates =
 	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
@@ -2554,7 +2550,7 @@ static int iwl3945_set_mode(struct iwl39
 		const struct iwl3945_channel_info *ch_info;
 
 		ch_info = iwl3945_get_channel_info(priv,
-			priv->phymode,
+			priv->band,
 			le16_to_cpu(priv->staging_rxon.channel));
 
 		if (!ch_info || !is_channel_ibss(ch_info)) {
@@ -2786,7 +2782,7 @@ static int iwl3945_tx_skb(struct iwl3945
 		goto drop_unlock;
 	}
 
-	if ((ctl->tx_rate & 0xFF) == IWL_INVALID_RATE) {
+	if ((ctl->tx_rate->hw_value & 0xFF) == IWL_INVALID_RATE) {
 		IWL_ERROR("ERROR: No TX rate available.\n");
 		goto drop_unlock;
 	}
@@ -2985,12 +2981,12 @@ drop:
 
 static void iwl3945_set_rate(struct iwl3945_priv *priv)
 {
-	const struct ieee80211_hw_mode *hw = NULL;
+	const struct ieee80211_supported_band *sband = NULL;
 	struct ieee80211_rate *rate;
 	int i;
 
-	hw = iwl3945_get_hw_mode(priv, priv->phymode);
-	if (!hw) {
+	sband = iwl3945_get_band(priv, priv->band);
+	if (!sband) {
 		IWL_ERROR("Failed to set rate: unable to get hw mode\n");
 		return;
 	}
@@ -2998,24 +2994,17 @@ static void iwl3945_set_rate(struct iwl3
 	priv->active_rate = 0;
 	priv->active_rate_basic = 0;
 
-	IWL_DEBUG_RATE("Setting rates for 802.11%c\n",
-		       hw->mode == MODE_IEEE80211A ?
-		       'a' : ((hw->mode == MODE_IEEE80211B) ? 'b' : 'g'));
-
-	for (i = 0; i < hw->num_rates; i++) {
-		rate = &(hw->rates[i]);
-		if ((rate->val < IWL_RATE_COUNT) &&
-		    (rate->flags & IEEE80211_RATE_SUPPORTED)) {
-			IWL_DEBUG_RATE("Adding rate index %d (plcp %d)%s\n",
-				       rate->val, iwl3945_rates[rate->val].plcp,
-				       (rate->flags & IEEE80211_RATE_BASIC) ?
-				       "*" : "");
-			priv->active_rate |= (1 << rate->val);
-			if (rate->flags & IEEE80211_RATE_BASIC)
-				priv->active_rate_basic |= (1 << rate->val);
-		} else
-			IWL_DEBUG_RATE("Not adding rate %d (plcp %d)\n",
-				       rate->val, iwl3945_rates[rate->val].plcp);
+	IWL_DEBUG_RATE("Setting rates for %s GHz\n",
+		       sband->band == IEEE80211_BAND_2GHZ ? "2.4" : "5");
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		rate = &sband->bitrates[i];
+		if ((rate->hw_value < IWL_RATE_COUNT) &&
+		    !(rate->flags & IEEE80211_CHAN_DISABLED)) {
+			IWL_DEBUG_RATE("Adding rate index %d (plcp %d)\n",
+				       rate->hw_value, iwl3945_rates[rate->hw_value].plcp);
+			priv->active_rate |= (1 << rate->hw_value);
+		}
 	}
 
 	IWL_DEBUG_RATE("Set active_rate = %0x, active_rate_basic = %0x\n",
@@ -3429,8 +3418,6 @@ static void iwl3945_rx_reply_tx(struct i
 	tx_status->flags =
 	    iwl3945_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
 
-	tx_status->control.tx_rate = iwl3945_rate_index_from_plcp(tx_resp->rate);
-
 	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) plcp rate %d retries %d\n",
 			txq_id, iwl3945_get_tx_fail_reason(status), status,
 			tx_resp->rate, tx_resp->failure_frame);
@@ -5019,24 +5006,24 @@ static void iwl3945_init_band_reference(
  * Based on band and channel number.
  */
 const struct iwl3945_channel_info *iwl3945_get_channel_info(const struct iwl3945_priv *priv,
-						    int phymode, u16 channel)
+						    enum ieee80211_band band, u16 channel)
 {
 	int i;
 
-	switch (phymode) {
-	case MODE_IEEE80211A:
+	switch (band) {
+	case IEEE80211_BAND_5GHZ:
 		for (i = 14; i < priv->channel_count; i++) {
 			if (priv->channel_info[i].channel == channel)
 				return &priv->channel_info[i];
 		}
 		break;
 
-	case MODE_IEEE80211B:
-	case MODE_IEEE80211G:
+	case IEEE80211_BAND_2GHZ:
 		if (channel >= 1 && channel <= 14)
 			return &priv->channel_info[channel - 1];
 		break;
-
+	case IEEE80211_NUM_BANDS:
+		WARN_ON(1);
 	}
 
 	return NULL;
@@ -5099,8 +5086,8 @@ static int iwl3945_init_channel_map(stru
 		/* Loop through each band adding each of the channels */
 		for (ch = 0; ch < eeprom_ch_count; ch++) {
 			ch_info->channel = eeprom_ch_index[ch];
-			ch_info->phymode = (band == 1) ? MODE_IEEE80211B :
-			    MODE_IEEE80211A;
+			ch_info->band = (band == 1) ? IEEE80211_BAND_2GHZ :
+			    IEEE80211_BAND_5GHZ;
 
 			/* permanently store EEPROM's channel regulatory flags
 			 *   and max power in channel info database. */
@@ -5196,18 +5183,20 @@ static void iwl3945_free_channel_map(str
 #define IWL_PASSIVE_DWELL_BASE      (100)
 #define IWL_CHANNEL_TUNE_TIME       5
 
-static inline u16 iwl3945_get_active_dwell_time(struct iwl3945_priv *priv, int phymode)
+static inline u16 iwl3945_get_active_dwell_time(struct iwl3945_priv *priv,
+						enum ieee80211_band band)
 {
-	if (phymode == MODE_IEEE80211A)
+	if (band == IEEE80211_BAND_5GHZ)
 		return IWL_ACTIVE_DWELL_TIME_52;
 	else
 		return IWL_ACTIVE_DWELL_TIME_24;
 }
 
-static u16 iwl3945_get_passive_dwell_time(struct iwl3945_priv *priv, int phymode)
+static u16 iwl3945_get_passive_dwell_time(struct iwl3945_priv *priv,
+					  enum ieee80211_band band)
 {
-	u16 active = iwl3945_get_active_dwell_time(priv, phymode);
-	u16 passive = (phymode != MODE_IEEE80211A) ?
+	u16 active = iwl3945_get_active_dwell_time(priv, band);
+	u16 passive = (band == IEEE80211_BAND_2GHZ) ?
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
 
@@ -5227,28 +5216,29 @@ static u16 iwl3945_get_passive_dwell_tim
 	return passive;
 }
 
-static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv, int phymode,
+static int iwl3945_get_channels_for_scan(struct iwl3945_priv *priv,
+					 enum ieee80211_band band,
 				     u8 is_active, u8 direct_mask,
 				     struct iwl3945_scan_channel *scan_ch)
 {
 	const struct ieee80211_channel *channels = NULL;
-	const struct ieee80211_hw_mode *hw_mode;
+	const struct ieee80211_supported_band *sband;
 	const struct iwl3945_channel_info *ch_info;
 	u16 passive_dwell = 0;
 	u16 active_dwell = 0;
 	int added, i;
 
-	hw_mode = iwl3945_get_hw_mode(priv, phymode);
-	if (!hw_mode)
+	sband = iwl3945_get_band(priv, band);
+	if (!sband)
 		return 0;
 
-	channels = hw_mode->channels;
+	channels = sband->channels;
 
-	active_dwell = iwl3945_get_active_dwell_time(priv, phymode);
-	passive_dwell = iwl3945_get_passive_dwell_time(priv, phymode);
+	active_dwell = iwl3945_get_active_dwell_time(priv, band);
+	passive_dwell = iwl3945_get_passive_dwell_time(priv, band);
 
-	for (i = 0, added = 0; i < hw_mode->num_channels; i++) {
-		if (channels[i].chan ==
+	for (i = 0, added = 0; i < sband->n_channels; i++) {
+		if (channels[i].hw_value ==
 		    le16_to_cpu(priv->active_rxon.channel)) {
 			if (iwl3945_is_associated(priv)) {
 				IWL_DEBUG_SCAN
@@ -5259,9 +5249,9 @@ static int iwl3945_get_channels_for_scan
 		} else if (priv->only_active_channel)
 			continue;
 
-		scan_ch->channel = channels[i].chan;
+		scan_ch->channel = channels[i].hw_value;
 
-		ch_info = iwl3945_get_channel_info(priv, phymode, scan_ch->channel);
+		ch_info = iwl3945_get_channel_info(priv, band, scan_ch->channel);
 		if (!is_channel_valid(ch_info)) {
 			IWL_DEBUG_SCAN("Channel %d is INVALID for this SKU.\n",
 				       scan_ch->channel);
@@ -5269,7 +5259,7 @@ static int iwl3945_get_channels_for_scan
 		}
 
 		if (!is_active || is_channel_passive(ch_info) ||
-		    !(channels[i].flag & IEEE80211_CHAN_W_ACTIVE_SCAN))
+		    (channels[i].flags & IEEE80211_CHAN_PASSIVE_SCAN))
 			scan_ch->type = 0;	/* passive */
 		else
 			scan_ch->type = 1;	/* active */
@@ -5288,7 +5278,7 @@ static int iwl3945_get_channels_for_scan
 		/* scan_pwr_info->tpc.dsp_atten; */
 
 		/*scan_pwr_info->tpc.tx_gain; */
-		if (phymode == MODE_IEEE80211A)
+		if (band == IEEE80211_BAND_5GHZ)
 			scan_ch->tpc.tx_gain = ((1 << 5) | (3 << 3)) | 3;
 		else {
 			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
@@ -5312,41 +5302,23 @@ static int iwl3945_get_channels_for_scan
 	return added;
 }
 
-static void iwl3945_reset_channel_flag(struct iwl3945_priv *priv)
-{
-	int i, j;
-	for (i = 0; i < 3; i++) {
-		struct ieee80211_hw_mode *hw_mode = (void *)&priv->modes[i];
-		for (j = 0; j < hw_mode->num_channels; j++)
-			hw_mode->channels[j].flag = hw_mode->channels[j].val;
-	}
-}
-
 static void iwl3945_init_hw_rates(struct iwl3945_priv *priv,
 			      struct ieee80211_rate *rates)
 {
 	int i;
 
 	for (i = 0; i < IWL_RATE_COUNT; i++) {
-		rates[i].rate = iwl3945_rates[i].ieee * 5;
-		rates[i].val = i; /* Rate scaling will work on indexes */
-		rates[i].val2 = i;
-		rates[i].flags = IEEE80211_RATE_SUPPORTED;
-		/* Only OFDM have the bits-per-symbol set */
-		if ((i <= IWL_LAST_OFDM_RATE) && (i >= IWL_FIRST_OFDM_RATE))
-			rates[i].flags |= IEEE80211_RATE_OFDM;
-		else {
+		rates[i].bitrate = iwl3945_rates[i].ieee * 5;
+		rates[i].hw_value = i; /* Rate scaling will work on indexes */
+		rates[i].hw_value_short = i;
+		rates[i].flags = 0;
+		if ((i > IWL_LAST_OFDM_RATE) || (i < IWL_FIRST_OFDM_RATE)) {
 			/*
-			 * If CCK 1M then set rate flag to CCK else CCK_2
-			 * which is CCK | PREAMBLE2
+			 * If CCK != 1M then set short preamble rate flag.
 			 */
 			rates[i].flags |= (iwl3945_rates[i].plcp == 10) ?
-				IEEE80211_RATE_CCK : IEEE80211_RATE_CCK_2;
+				0 : IEEE80211_RATE_SHORT_PREAMBLE;
 		}
-
-		/* Set up which ones are basic rates... */
-		if (IWL_BASIC_RATES_MASK & (1 << i))
-			rates[i].flags |= IEEE80211_RATE_BASIC;
 	}
 }
 
@@ -5356,67 +5328,41 @@ static void iwl3945_init_hw_rates(struct
 static int iwl3945_init_geos(struct iwl3945_priv *priv)
 {
 	struct iwl3945_channel_info *ch;
-	struct ieee80211_hw_mode *modes;
+	struct ieee80211_supported_band *band;
 	struct ieee80211_channel *channels;
 	struct ieee80211_channel *geo_ch;
 	struct ieee80211_rate *rates;
 	int i = 0;
-	enum {
-		A = 0,
-		B = 1,
-		G = 2,
-	};
-	int mode_count = 3;
 
-	if (priv->modes) {
+	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
+	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
 		IWL_DEBUG_INFO("Geography modes already initialized.\n");
 		set_bit(STATUS_GEO_CONFIGURED, &priv->status);
 		return 0;
 	}
 
-	modes = kzalloc(sizeof(struct ieee80211_hw_mode) * mode_count,
-			GFP_KERNEL);
-	if (!modes)
-		return -ENOMEM;
-
 	channels = kzalloc(sizeof(struct ieee80211_channel) *
 			   priv->channel_count, GFP_KERNEL);
-	if (!channels) {
-		kfree(modes);
+	if (!channels)
 		return -ENOMEM;
-	}
 
 	rates = kzalloc((sizeof(struct ieee80211_rate) * (IWL_MAX_RATES + 1)),
 			GFP_KERNEL);
 	if (!rates) {
-		kfree(modes);
 		kfree(channels);
 		return -ENOMEM;
 	}
 
-	/* 0 = 802.11a
-	 * 1 = 802.11b
-	 * 2 = 802.11g
-	 */
-
 	/* 5.2GHz channels start after the 2.4GHz channels */
-	modes[A].mode = MODE_IEEE80211A;
-	modes[A].channels = &channels[ARRAY_SIZE(iwl3945_eeprom_band_1)];
-	modes[A].rates = &rates[4];
-	modes[A].num_rates = 8;	/* just OFDM */
-	modes[A].num_channels = 0;
-
-	modes[B].mode = MODE_IEEE80211B;
-	modes[B].channels = channels;
-	modes[B].rates = rates;
-	modes[B].num_rates = 4;	/* just CCK */
-	modes[B].num_channels = 0;
-
-	modes[G].mode = MODE_IEEE80211G;
-	modes[G].channels = channels;
-	modes[G].rates = rates;
-	modes[G].num_rates = 12;	/* OFDM & CCK */
-	modes[G].num_channels = 0;
+	band = &priv->bands[IEEE80211_BAND_5GHZ];
+	band->channels = &channels[ARRAY_SIZE(iwl3945_eeprom_band_1)];
+	band->bitrates = &rates[4];
+	band->n_bitrates = 8;	/* just OFDM */
+
+	band = &priv->bands[IEEE80211_BAND_2GHZ];
+	band->channels = channels;
+	band->bitrates = rates;
+	band->n_bitrates = 12;	/* OFDM & CCK */
 
 	priv->ieee_channels = channels;
 	priv->ieee_rates = rates;
@@ -5435,37 +5381,32 @@ static int iwl3945_init_geos(struct iwl3
 		}
 
 		if (is_channel_a_band(ch))
-			geo_ch = &modes[A].channels[modes[A].num_channels++];
-		else {
-			geo_ch = &modes[B].channels[modes[B].num_channels++];
-			modes[G].num_channels++;
-		}
+			geo_ch = &priv->bands[IEEE80211_BAND_5GHZ].channels[priv->bands[IEEE80211_BAND_5GHZ].n_channels++];
+		else
+			geo_ch = &priv->bands[IEEE80211_BAND_2GHZ].channels[priv->bands[IEEE80211_BAND_2GHZ].n_channels++];
 
-		geo_ch->freq = ieee80211chan2mhz(ch->channel);
-		geo_ch->chan = ch->channel;
-		geo_ch->power_level = ch->max_power_avg;
-		geo_ch->antenna_max = 0xff;
+		geo_ch->center_freq = ieee80211chan2mhz(ch->channel);
+		geo_ch->max_power = ch->max_power_avg;
+		geo_ch->max_antenna_gain = 0xff;
 
 		if (is_channel_valid(ch)) {
-			geo_ch->flag = IEEE80211_CHAN_W_SCAN;
-			if (ch->flags & EEPROM_CHANNEL_IBSS)
-				geo_ch->flag |= IEEE80211_CHAN_W_IBSS;
+			if (!(ch->flags & EEPROM_CHANNEL_IBSS))
+				geo_ch->flags |= IEEE80211_CHAN_NO_IBSS;
 
-			if (ch->flags & EEPROM_CHANNEL_ACTIVE)
-				geo_ch->flag |= IEEE80211_CHAN_W_ACTIVE_SCAN;
+			if (!(ch->flags & EEPROM_CHANNEL_ACTIVE))
+				geo_ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
 
 			if (ch->flags & EEPROM_CHANNEL_RADAR)
-				geo_ch->flag |= IEEE80211_CHAN_W_RADAR_DETECT;
+				geo_ch->flags |= IEEE80211_CHAN_RADAR;
 
 			if (ch->max_power_avg > priv->max_channel_txpower_limit)
 				priv->max_channel_txpower_limit =
 				    ch->max_power_avg;
-		}
-
-		geo_ch->val = geo_ch->flag;
+		} else
+			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
 	}
 
-	if ((modes[A].num_channels == 0) && priv->is_abg) {
+	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) && priv->is_abg) {
 		printk(KERN_INFO DRV_NAME
 		       ": Incorrectly detected BG card as ABG.  Please send "
 		       "your PCI ID 0x%04X:0x%04X to maintainer.\n",
@@ -5475,24 +5416,12 @@ static int iwl3945_init_geos(struct iwl3
 
 	printk(KERN_INFO DRV_NAME
 	       ": Tunable channels: %d 802.11bg, %d 802.11a channels\n",
-	       modes[G].num_channels, modes[A].num_channels);
-
-	/*
-	 * NOTE:  We register these in preference of order -- the
-	 * stack doesn't currently (as of 7.0.6 / Apr 24 '07) pick
-	 * a phymode based on rates or AP capabilities but seems to
-	 * configure it purely on if the channel being configured
-	 * is supported by a mode -- and the first match is taken
-	 */
+	       priv->bands[IEEE80211_BAND_2GHZ].n_channels,
+	       priv->bands[IEEE80211_BAND_5GHZ].n_channels);
 
-	if (modes[G].num_channels)
-		ieee80211_register_hwmode(priv->hw, &modes[G]);
-	if (modes[B].num_channels)
-		ieee80211_register_hwmode(priv->hw, &modes[B]);
-	if (modes[A].num_channels)
-		ieee80211_register_hwmode(priv->hw, &modes[A]);
+	priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->bands[IEEE80211_BAND_2GHZ];
+	priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &priv->bands[IEEE80211_BAND_5GHZ];
 
-	priv->modes = modes;
 	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
 
 	return 0;
@@ -5503,7 +5432,6 @@ static int iwl3945_init_geos(struct iwl3
  */
 static void iwl3945_free_geos(struct iwl3945_priv *priv)
 {
-	kfree(priv->modes);
 	kfree(priv->ieee_channels);
 	kfree(priv->ieee_rates);
 	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
@@ -6508,7 +6436,7 @@ static void iwl3945_bg_request_scan(stru
 	struct iwl3945_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
 	u8 direct_mask;
-	int phymode;
+	enum ieee80211_band band;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -6640,13 +6568,13 @@ static void iwl3945_bg_request_scan(stru
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
 		scan->tx_cmd.rate = IWL_RATE_1M_PLCP;
 		scan->good_CRC_th = 0;
-		phymode = MODE_IEEE80211G;
+		band = IEEE80211_BAND_2GHZ;
 		break;
 
 	case 1:
 		scan->tx_cmd.rate = IWL_RATE_6M_PLCP;
 		scan->good_CRC_th = IWL_GOOD_CRC_TH;
-		phymode = MODE_IEEE80211A;
+		band = IEEE80211_BAND_5GHZ;
 		break;
 
 	default:
@@ -6669,7 +6597,7 @@ static void iwl3945_bg_request_scan(stru
 
 	scan->channel_count =
 		iwl3945_get_channels_for_scan(
-			priv, phymode, 1, /* active */
+			priv, band, 1, /* active */
 			direct_mask,
 			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 
@@ -6814,7 +6742,7 @@ static void iwl3945_bg_post_associate(st
 		iwl3945_add_station(priv, iwl3945_broadcast_addr, 0, 0);
 		iwl3945_add_station(priv, priv->bssid, 0, 0);
 		iwl3945_sync_sta(priv, IWL_STA_ID,
-				 (priv->phymode == MODE_IEEE80211A)?
+				 (priv->band == IEEE80211_BAND_5GHZ) ?
 				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
 				 CMD_ASYNC);
 		iwl3945_rate_scale_init(priv->hw, IWL_STA_ID);
@@ -7009,7 +6937,7 @@ static int iwl3945_mac_tx(struct ieee802
 	}
 
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
-		     ctl->tx_rate);
+		     ctl->tx_rate->bitrate);
 
 	if (iwl3945_tx_skb(priv, skb, ctl))
 		dev_kfree_skb_any(skb);
@@ -7068,7 +6996,7 @@ static int iwl3945_mac_config(struct iee
 	int ret = 0;
 
 	mutex_lock(&priv->mutex);
-	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel);
+	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel->hw_value);
 
 	priv->add_radiotap = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
 
@@ -7088,19 +7016,20 @@ static int iwl3945_mac_config(struct iee
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	ch_info = iwl3945_get_channel_info(priv, conf->phymode, conf->channel);
+	ch_info = iwl3945_get_channel_info(priv, conf->channel->band,
+					   conf->channel->hw_value);
 	if (!is_channel_valid(ch_info)) {
 		IWL_DEBUG_SCAN("Channel %d [%d] is INVALID for this SKU.\n",
-			       conf->channel, conf->phymode);
+			       conf->channel->hw_value, conf->channel->band);
 		IWL_DEBUG_MAC80211("leave - invalid channel\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
 		ret = -EINVAL;
 		goto out;
 	}
 
-	iwl3945_set_rxon_channel(priv, conf->phymode, conf->channel);
+	iwl3945_set_rxon_channel(priv, conf->channel->band, conf->channel->hw_value);
 
-	iwl3945_set_flags_for_phymode(priv, conf->phymode);
+	iwl3945_set_flags_for_phymode(priv, conf->channel->band);
 
 	/* The list of supported rates and rate mask can be different
 	 * for each phymode; since the phymode may have changed, reset
@@ -7881,65 +7810,6 @@ static ssize_t store_filter_flags(struct
 static DEVICE_ATTR(filter_flags, S_IWUSR | S_IRUGO, show_filter_flags,
 		   store_filter_flags);
 
-static ssize_t show_tune(struct device *d,
-			 struct device_attribute *attr, char *buf)
-{
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
-
-	return sprintf(buf, "0x%04X\n",
-		       (priv->phymode << 8) |
-			le16_to_cpu(priv->active_rxon.channel));
-}
-
-static void iwl3945_set_flags_for_phymode(struct iwl3945_priv *priv, u8 phymode);
-
-static ssize_t store_tune(struct device *d,
-			  struct device_attribute *attr,
-			  const char *buf, size_t count)
-{
-	struct iwl3945_priv *priv = (struct iwl3945_priv *)d->driver_data;
-	char *p = (char *)buf;
-	u16 tune = simple_strtoul(p, &p, 0);
-	u8 phymode = (tune >> 8) & 0xff;
-	u16 channel = tune & 0xff;
-
-	IWL_DEBUG_INFO("Tune request to:%d channel:%d\n", phymode, channel);
-
-	mutex_lock(&priv->mutex);
-	if ((le16_to_cpu(priv->staging_rxon.channel) != channel) ||
-	    (priv->phymode != phymode)) {
-		const struct iwl3945_channel_info *ch_info;
-
-		ch_info = iwl3945_get_channel_info(priv, phymode, channel);
-		if (!ch_info) {
-			IWL_WARNING("Requested invalid phymode/channel "
-				    "combination: %d %d\n", phymode, channel);
-			mutex_unlock(&priv->mutex);
-			return -EINVAL;
-		}
-
-		/* Cancel any currently running scans... */
-		if (iwl3945_scan_cancel_timeout(priv, 100))
-			IWL_WARNING("Could not cancel scan.\n");
-		else {
-			IWL_DEBUG_INFO("Committing phymode and "
-				       "rxon.channel = %d %d\n",
-				       phymode, channel);
-
-			iwl3945_set_rxon_channel(priv, phymode, channel);
-			iwl3945_set_flags_for_phymode(priv, phymode);
-
-			iwl3945_set_rate(priv);
-			iwl3945_commit_rxon(priv);
-		}
-	}
-	mutex_unlock(&priv->mutex);
-
-	return count;
-}
-
-static DEVICE_ATTR(tune, S_IWUSR | S_IRUGO, show_tune, store_tune);
-
 #ifdef CONFIG_IWL3945_SPECTRUM_MEASUREMENT
 
 static ssize_t show_measurement(struct device *d,
@@ -8154,73 +8024,8 @@ static DEVICE_ATTR(power_level, S_IWUSR 
 static ssize_t show_channels(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
-	struct iwl3945_priv *priv = dev_get_drvdata(d);
-	int len = 0, i;
-	struct ieee80211_channel *channels = NULL;
-	const struct ieee80211_hw_mode *hw_mode = NULL;
-	int count = 0;
-
-	if (!iwl3945_is_ready(priv))
-		return -EAGAIN;
-
-	hw_mode = iwl3945_get_hw_mode(priv, MODE_IEEE80211G);
-	if (!hw_mode)
-		hw_mode = iwl3945_get_hw_mode(priv, MODE_IEEE80211B);
-	if (hw_mode) {
-		channels = hw_mode->channels;
-		count = hw_mode->num_channels;
-	}
-
-	len +=
-	    sprintf(&buf[len],
-		    "Displaying %d channels in 2.4GHz band "
-		    "(802.11bg):\n", count);
-
-	for (i = 0; i < count; i++)
-		len += sprintf(&buf[len], "%d: %ddBm: BSS%s%s, %s.\n",
-			       channels[i].chan,
-			       channels[i].power_level,
-			       channels[i].
-			       flag & IEEE80211_CHAN_W_RADAR_DETECT ?
-			       " (IEEE 802.11h required)" : "",
-			       (!(channels[i].flag & IEEE80211_CHAN_W_IBSS)
-				|| (channels[i].
-				    flag &
-				    IEEE80211_CHAN_W_RADAR_DETECT)) ? "" :
-			       ", IBSS",
-			       channels[i].
-			       flag & IEEE80211_CHAN_W_ACTIVE_SCAN ?
-			       "active/passive" : "passive only");
-
-	hw_mode = iwl3945_get_hw_mode(priv, MODE_IEEE80211A);
-	if (hw_mode) {
-		channels = hw_mode->channels;
-		count = hw_mode->num_channels;
-	} else {
-		channels = NULL;
-		count = 0;
-	}
-
-	len += sprintf(&buf[len], "Displaying %d channels in 5.2GHz band "
-		       "(802.11a):\n", count);
-
-	for (i = 0; i < count; i++)
-		len += sprintf(&buf[len], "%d: %ddBm: BSS%s%s, %s.\n",
-			       channels[i].chan,
-			       channels[i].power_level,
-			       channels[i].
-			       flag & IEEE80211_CHAN_W_RADAR_DETECT ?
-			       " (IEEE 802.11h required)" : "",
-			       (!(channels[i].flag & IEEE80211_CHAN_W_IBSS)
-				|| (channels[i].
-				    flag &
-				    IEEE80211_CHAN_W_RADAR_DETECT)) ? "" :
-			       ", IBSS",
-			       channels[i].
-			       flag & IEEE80211_CHAN_W_ACTIVE_SCAN ?
-			       "active/passive" : "passive only");
-
-	return len;
+	/* all this shit doesn't belong into sysfs anyway */
+	return 0;
 }
 
 static DEVICE_ATTR(channels, S_IRUSR, show_channels, NULL);
@@ -8400,7 +8205,6 @@ static struct attribute *iwl3945_sysfs_e
 	&dev_attr_statistics.attr,
 	&dev_attr_status.attr,
 	&dev_attr_temperature.attr,
-	&dev_attr_tune.attr,
 	&dev_attr_tx_power.attr,
 
 	NULL
@@ -8521,7 +8325,7 @@ static int iwl3945_pci_probe(struct pci_
 	priv->data_retry_limit = -1;
 	priv->ieee_channels = NULL;
 	priv->ieee_rates = NULL;
-	priv->phymode = -1;
+	priv->band = IEEE80211_BAND_2GHZ;
 
 	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	if (!err)
@@ -8603,7 +8407,7 @@ static int iwl3945_pci_probe(struct pci_
 	priv->qos_data.qos_cap.val = 0;
 #endif /* CONFIG_IWL3945_QOS */
 
-	iwl3945_set_rxon_channel(priv, MODE_IEEE80211G, 6);
+	iwl3945_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
 	iwl3945_setup_deferred_work(priv);
 	iwl3945_setup_rx_handlers(priv);
 
@@ -8654,7 +8458,6 @@ static int iwl3945_pci_probe(struct pci_
 		IWL_ERROR("initializing geos failed: %d\n", err);
 		goto out_free_channel_map;
 	}
-	iwl3945_reset_channel_flag(priv);
 
 	iwl3945_rate_control_register(priv->hw);
 	err = ieee80211_register_hw(priv->hw);
--- everything.orig/drivers/net/wireless/rtl8180.h	2008-01-24 19:34:51.553586480 +0100
+++ everything/drivers/net/wireless/rtl8180.h	2008-01-24 19:35:11.773585287 +0100
@@ -102,7 +102,7 @@ struct rtl8180_priv {
 	struct rtl8180_tx_ring tx_ring[4];
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];
-	struct ieee80211_hw_mode modes[2];
+	struct ieee80211_supported_band band;
 	struct pci_dev *pdev;
 	u32 rx_conf;
 
--- everything.orig/drivers/net/wireless/rtl8180_dev.c	2008-01-24 19:34:51.623586914 +0100
+++ everything/drivers/net/wireless/rtl8180_dev.c	2008-01-24 19:35:11.783585884 +0100
@@ -48,6 +48,41 @@ static struct pci_device_id rtl8180_tabl
 
 MODULE_DEVICE_TABLE(pci, rtl8180_table);
 
+static const struct ieee80211_rate rtl818x_rates[] = {
+	{ .bitrate = 10, .hw_value = 0, },
+	{ .bitrate = 20, .hw_value = 1, },
+	{ .bitrate = 55, .hw_value = 2, },
+	{ .bitrate = 110, .hw_value = 3, },
+	{ .bitrate = 60, .hw_value = 4, },
+	{ .bitrate = 90, .hw_value = 5, },
+	{ .bitrate = 120, .hw_value = 6, },
+	{ .bitrate = 180, .hw_value = 7, },
+	{ .bitrate = 240, .hw_value = 8, },
+	{ .bitrate = 360, .hw_value = 9, },
+	{ .bitrate = 480, .hw_value = 10, },
+	{ .bitrate = 540, .hw_value = 11, },
+};
+
+static const struct ieee80211_channel rtl818x_channels[] = {
+	{ .center_freq = 2412 },
+	{ .center_freq = 2417 },
+	{ .center_freq = 2422 },
+	{ .center_freq = 2427 },
+	{ .center_freq = 2432 },
+	{ .center_freq = 2437 },
+	{ .center_freq = 2442 },
+	{ .center_freq = 2447 },
+	{ .center_freq = 2452 },
+	{ .center_freq = 2457 },
+	{ .center_freq = 2462 },
+	{ .center_freq = 2467 },
+	{ .center_freq = 2472 },
+	{ .center_freq = 2484 },
+};
+
+
+
+
 void rtl8180_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data)
 {
 	struct rtl8180_priv *priv = dev->priv;
@@ -98,10 +133,10 @@ static void rtl8180_handle_rx(struct iee
 			/* TODO: improve signal/rssi reporting */
 			rx_status.signal = flags2 & 0xFF;
 			rx_status.ssi = (flags2 >> 8) & 0x7F;
-			rx_status.rate = (flags >> 20) & 0xF;
-			rx_status.freq = dev->conf.freq;
-			rx_status.channel = dev->conf.channel;
-			rx_status.phymode = dev->conf.phymode;
+			/* XXX: is this correct? */
+			rx_status.rate_idx = (flags >> 20) & 0xF;
+			rx_status.freq = dev->conf.channel->center_freq;
+			rx_status.band = dev->conf.channel->band;
 			rx_status.mactime = le64_to_cpu(entry->tsft);
 			rx_status.flag |= RX_FLAG_TSFT;
 			if (flags & RTL8180_RX_DESC_FLAG_CRC32_ERR)
@@ -220,8 +255,9 @@ static int rtl8180_tx(struct ieee80211_h
 				 skb->len, PCI_DMA_TODEVICE);
 
 	tx_flags = RTL8180_TX_DESC_FLAG_OWN | RTL8180_TX_DESC_FLAG_FS |
-		   RTL8180_TX_DESC_FLAG_LS | (control->tx_rate << 24) |
-		   (control->rts_cts_rate << 19) | skb->len;
+		   RTL8180_TX_DESC_FLAG_LS |
+		   (control->tx_rate->hw_value << 24) |
+		   (control->rts_cts_rate->hw_value << 19) | skb->len;
 
 	if (priv->r8185)
 		tx_flags |= RTL8180_TX_DESC_FLAG_DMA |
@@ -243,9 +279,9 @@ static int rtl8180_tx(struct ieee80211_h
 		unsigned int remainder;
 
 		plcp_len = DIV_ROUND_UP(16 * (skb->len + 4),
-					(control->rate->rate * 2) / 10);
+					(control->tx_rate->bitrate * 2) / 10);
 		remainder = (16 * (skb->len + 4)) %
-			    ((control->rate->rate * 2) / 10);
+			    ((control->tx_rate->bitrate * 2) / 10);
 		if (remainder > 0 && remainder <= 6)
 			plcp_len |= 1 << 15;
 	}
@@ -258,8 +294,8 @@ static int rtl8180_tx(struct ieee80211_h
 	entry->plcp_len = cpu_to_le16(plcp_len);
 	entry->tx_buf = cpu_to_le32(mapping);
 	entry->frame_len = cpu_to_le32(skb->len);
-	entry->flags2 = control->alt_retry_rate != -1 ?
-			control->alt_retry_rate << 4 : 0;
+	entry->flags2 = control->alt_retry_rate != NULL ?
+			control->alt_retry_rate->bitrate << 4 : 0;
 	entry->retry_limit = control->retry_limit;
 	entry->flags = cpu_to_le32(tx_flags);
 	__skb_queue_tail(&ring->queue, skb);
@@ -835,19 +871,19 @@ static int __devinit rtl8180_probe(struc
 		goto err_free_dev;
 	}
 
+	BUILD_BUG_ON(sizeof(priv->channels) != sizeof(rtl818x_channels));
+	BUILD_BUG_ON(sizeof(priv->rates) != sizeof(rtl818x_rates));
+
 	memcpy(priv->channels, rtl818x_channels, sizeof(rtl818x_channels));
 	memcpy(priv->rates, rtl818x_rates, sizeof(rtl818x_rates));
-	priv->modes[0].mode = MODE_IEEE80211G;
-	priv->modes[0].num_rates = ARRAY_SIZE(rtl818x_rates);
-	priv->modes[0].rates = priv->rates;
-	priv->modes[0].num_channels = ARRAY_SIZE(rtl818x_channels);
-	priv->modes[0].channels = priv->channels;
-	priv->modes[1].mode = MODE_IEEE80211B;
-	priv->modes[1].num_rates = 4;
-	priv->modes[1].rates = priv->rates;
-	priv->modes[1].num_channels = ARRAY_SIZE(rtl818x_channels);
-	priv->modes[1].channels = priv->channels;
-	priv->mode = IEEE80211_IF_TYPE_INVALID;
+
+	priv->band.band = IEEE80211_BAND_2GHZ;
+	priv->band.channels = priv->channels;
+	priv->band.n_channels = ARRAY_SIZE(rtl818x_channels);
+	priv->band.bitrates = priv->rates;
+	priv->band.n_bitrates = 4;
+	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS;
 	dev->queues = 1;
@@ -876,15 +912,10 @@ static int __devinit rtl8180_probe(struc
 
 	priv->r8185 = reg & RTL818X_TX_CONF_R8185_ABC;
 	if (priv->r8185) {
-		if ((err = ieee80211_register_hwmode(dev, &priv->modes[0])))
-			goto err_iounmap;
-
+		priv->band.n_bitrates = ARRAY_SIZE(rtl818x_rates);
 		pci_try_set_mwi(pdev);
 	}
 
-	if ((err = ieee80211_register_hwmode(dev, &priv->modes[1])))
-		goto err_iounmap;
-
 	eeprom.data = dev;
 	eeprom.register_read = rtl8180_eeprom_register_read;
 	eeprom.register_write = rtl8180_eeprom_register_write;
@@ -947,8 +978,8 @@ static int __devinit rtl8180_probe(struc
 	for (i = 0; i < 14; i += 2) {
 		u16 txpwr;
 		eeprom_93cx6_read(&eeprom, 0x10 + (i >> 1), &txpwr);
-		priv->channels[i].val = txpwr & 0xFF;
-		priv->channels[i + 1].val = txpwr >> 8;
+		priv->channels[i].hw_value = txpwr & 0xFF;
+		priv->channels[i + 1].hw_value = txpwr >> 8;
 	}
 
 	/* OFDM TX power */
@@ -956,8 +987,8 @@ static int __devinit rtl8180_probe(struc
 		for (i = 0; i < 14; i += 2) {
 			u16 txpwr;
 			eeprom_93cx6_read(&eeprom, 0x20 + (i >> 1), &txpwr);
-			priv->channels[i].val |= (txpwr & 0xFF) << 8;
-			priv->channels[i + 1].val |= txpwr & 0xFF00;
+			priv->channels[i].hw_value |= (txpwr & 0xFF) << 8;
+			priv->channels[i + 1].hw_value |= txpwr & 0xFF00;
 		}
 	}
 
--- everything.orig/drivers/net/wireless/rtl818x.h	2008-01-24 19:34:51.663586643 +0100
+++ everything/drivers/net/wireless/rtl818x.h	2008-01-24 19:35:11.783585884 +0100
@@ -175,74 +175,4 @@ struct rtl818x_rf_ops {
 	void (*set_chan)(struct ieee80211_hw *, struct ieee80211_conf *);
 };
 
-static const struct ieee80211_rate rtl818x_rates[] = {
-	{ .rate = 10,
-	  .val = 0,
-	  .flags = IEEE80211_RATE_CCK },
-	{ .rate = 20,
-	  .val = 1,
-	  .flags = IEEE80211_RATE_CCK },
-	{ .rate = 55,
-	  .val = 2,
-	  .flags = IEEE80211_RATE_CCK },
-	{ .rate = 110,
-	  .val = 3,
-	  .flags = IEEE80211_RATE_CCK },
-	{ .rate = 60,
-	  .val = 4,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 90,
-	  .val = 5,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 120,
-	  .val = 6,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 180,
-	  .val = 7,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 240,
-	  .val = 8,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 360,
-	  .val = 9,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 480,
-	  .val = 10,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 540,
-	  .val = 11,
-	  .flags = IEEE80211_RATE_OFDM },
-};
-
-static const struct ieee80211_channel rtl818x_channels[] = {
-	{ .chan = 1,
-	  .freq = 2412},
-	{ .chan = 2,
-	  .freq = 2417},
-	{ .chan = 3,
-	  .freq = 2422},
-	{ .chan = 4,
-	  .freq = 2427},
-	{ .chan = 5,
-	  .freq = 2432},
-	{ .chan = 6,
-	  .freq = 2437},
-	{ .chan = 7,
-	  .freq = 2442},
-	{ .chan = 8,
-	  .freq = 2447},
-	{ .chan = 9,
-	  .freq = 2452},
-	{ .chan = 10,
-	  .freq = 2457},
-	{ .chan = 11,
-	  .freq = 2462},
-	{ .chan = 12,
-	  .freq = 2467},
-	{ .chan = 13,
-	  .freq = 2472},
-	{ .chan = 14,
-	  .freq = 2484}
-};
-
 #endif /* RTL818X_H */
--- everything.orig/drivers/net/wireless/rtl8180_grf5101.c	2008-01-24 19:34:51.733602105 +0100
+++ everything/drivers/net/wireless/rtl8180_grf5101.c	2008-01-24 19:35:11.783585884 +0100
@@ -73,8 +73,9 @@ static void grf5101_rf_set_channel(struc
 				   struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
-	u32 txpw = priv->channels[conf->channel - 1].val & 0xFF;
-	u32 chan = conf->channel - 1;
+	int channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	u32 txpw = priv->channels[channel - 1].hw_value & 0xFF;
+	u32 chan = channel - 1;
 
 	/* set TX power */
 	write_grf5101(dev, 0x15, 0x0);
--- everything.orig/drivers/net/wireless/rtl8180_max2820.c	2008-01-24 19:34:51.803589356 +0100
+++ everything/drivers/net/wireless/rtl8180_max2820.c	2008-01-24 19:35:11.783585884 +0100
@@ -78,8 +78,9 @@ static void max2820_rf_set_channel(struc
 				   struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
-	unsigned int chan_idx = conf ? conf->channel - 1 : 0;
-	u32 txpw = priv->channels[chan_idx].val & 0xFF;
+	int channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	unsigned int chan_idx = channel - 1;
+	u32 txpw = priv->channels[chan_idx].hw_value & 0xFF;
 	u32 chan = max2820_chan[chan_idx];
 
 	/* While philips SA2400 drive the PA bias from
--- everything.orig/drivers/net/wireless/rtl8180_rtl8225.c	2008-01-24 19:34:51.833586752 +0100
+++ everything/drivers/net/wireless/rtl8180_rtl8225.c	2008-01-24 19:35:11.783585884 +0100
@@ -261,8 +261,8 @@ static void rtl8225_rf_set_tx_power(stru
 	u32 reg;
 	int i;
 
-	cck_power = priv->channels[channel - 1].val & 0xFF;
-	ofdm_power = priv->channels[channel - 1].val >> 8;
+	cck_power = priv->channels[channel - 1].hw_value & 0xFF;
+	ofdm_power = priv->channels[channel - 1].hw_value >> 8;
 
 	cck_power = min(cck_power, (u8)35);
 	ofdm_power = min(ofdm_power, (u8)35);
@@ -476,8 +476,8 @@ static void rtl8225z2_rf_set_tx_power(st
 	const u8 *tmp;
 	int i;
 
-	cck_power = priv->channels[channel - 1].val & 0xFF;
-	ofdm_power = priv->channels[channel - 1].val >> 8;
+	cck_power = priv->channels[channel - 1].hw_value & 0xFF;
+	ofdm_power = priv->channels[channel - 1].hw_value >> 8;
 
 	if (channel == 14)
 		tmp = rtl8225z2_tx_power_cck_ch14;
@@ -716,13 +716,14 @@ static void rtl8225_rf_set_channel(struc
 				   struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
+	int chan = ieee80211_frequency_to_channel(conf->channel->center_freq);
 
 	if (priv->rf->init == rtl8225_rf_init)
-		rtl8225_rf_set_tx_power(dev, conf->channel);
+		rtl8225_rf_set_tx_power(dev, chan);
 	else
-		rtl8225z2_rf_set_tx_power(dev, conf->channel);
+		rtl8225z2_rf_set_tx_power(dev, chan);
 
-	rtl8225_write(dev, 0x7, rtl8225_chan[conf->channel - 1]);
+	rtl8225_write(dev, 0x7, rtl8225_chan[chan - 1]);
 	msleep(10);
 
 	if (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
--- everything.orig/drivers/net/wireless/rtl8180_sa2400.c	2008-01-24 19:34:51.883588434 +0100
+++ everything/drivers/net/wireless/rtl8180_sa2400.c	2008-01-24 19:35:11.793594347 +0100
@@ -80,8 +80,9 @@ static void sa2400_rf_set_channel(struct
 				  struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
-	u32 txpw = priv->channels[conf->channel - 1].val & 0xFF;
-	u32 chan = sa2400_chan[conf->channel - 1];
+	int channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	u32 txpw = priv->channels[channel - 1].hw_value & 0xFF;
+	u32 chan = sa2400_chan[channel - 1];
 
 	write_sa2400(dev, 7, txpw);
 
--- everything.orig/drivers/net/wireless/rtl8187.h	2008-01-24 19:34:51.923586263 +0100
+++ everything/drivers/net/wireless/rtl8187.h	2008-01-24 19:35:11.793594347 +0100
@@ -71,7 +71,7 @@ struct rtl8187_priv {
 	/* rtl8187 specific */
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];
-	struct ieee80211_hw_mode modes[2];
+	struct ieee80211_supported_band band;
 	struct usb_device *udev;
 	u32 rx_conf;
 	u16 txpwr_base;
--- everything.orig/drivers/net/wireless/rtl8187_dev.c	2008-01-24 19:34:51.973586806 +0100
+++ everything/drivers/net/wireless/rtl8187_dev.c	2008-01-24 19:35:11.793594347 +0100
@@ -45,6 +45,38 @@ static struct usb_device_id rtl8187_tabl
 
 MODULE_DEVICE_TABLE(usb, rtl8187_table);
 
+static const struct ieee80211_rate rtl818x_rates[] = {
+	{ .bitrate = 10, .hw_value = 0, },
+	{ .bitrate = 20, .hw_value = 1, },
+	{ .bitrate = 55, .hw_value = 2, },
+	{ .bitrate = 110, .hw_value = 3, },
+	{ .bitrate = 60, .hw_value = 4, },
+	{ .bitrate = 90, .hw_value = 5, },
+	{ .bitrate = 120, .hw_value = 6, },
+	{ .bitrate = 180, .hw_value = 7, },
+	{ .bitrate = 240, .hw_value = 8, },
+	{ .bitrate = 360, .hw_value = 9, },
+	{ .bitrate = 480, .hw_value = 10, },
+	{ .bitrate = 540, .hw_value = 11, },
+};
+
+static const struct ieee80211_channel rtl818x_channels[] = {
+	{ .center_freq = 2412 },
+	{ .center_freq = 2417 },
+	{ .center_freq = 2422 },
+	{ .center_freq = 2427 },
+	{ .center_freq = 2432 },
+	{ .center_freq = 2437 },
+	{ .center_freq = 2442 },
+	{ .center_freq = 2447 },
+	{ .center_freq = 2452 },
+	{ .center_freq = 2457 },
+	{ .center_freq = 2462 },
+	{ .center_freq = 2467 },
+	{ .center_freq = 2472 },
+	{ .center_freq = 2484 },
+};
+
 static void rtl8187_iowrite_async_cb(struct urb *urb)
 {
 	kfree(urb->context);
@@ -144,8 +176,8 @@ static int rtl8187_tx(struct ieee80211_h
 
 	flags = skb->len;
 	flags |= RTL8187_TX_FLAG_NO_ENCRYPT;
-	flags |= control->rts_cts_rate << 19;
-	flags |= control->tx_rate << 24;
+	flags |= control->rts_cts_rate->hw_value << 19;
+	flags |= control->tx_rate->hw_value << 24;
 	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb->data))
 		flags |= RTL8187_TX_FLAG_MORE_FRAG;
 	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
@@ -223,10 +255,9 @@ static void rtl8187_rx_cb(struct urb *ur
 	rx_status.antenna = (hdr->signal >> 7) & 1;
 	rx_status.signal = 64 - min(hdr->noise, (u8)64);
 	rx_status.ssi = signal;
-	rx_status.rate = rate;
-	rx_status.freq = dev->conf.freq;
-	rx_status.channel = dev->conf.channel;
-	rx_status.phymode = dev->conf.phymode;
+	rx_status.rate_idx = rate;
+	rx_status.freq = dev->conf.channel->center_freq;
+	rx_status.band = dev->conf.channel->band;
 	rx_status.mactime = le64_to_cpu(hdr->mac_time);
 	rx_status.flag |= RX_FLAG_TSFT;
 	if (flags & (1 << 13))
@@ -680,19 +711,22 @@ static int __devinit rtl8187_probe(struc
 	usb_get_dev(udev);
 
 	skb_queue_head_init(&priv->rx_queue);
+
+	BUILD_BUG_ON(sizeof(priv->channels) != sizeof(rtl818x_channels));
+	BUILD_BUG_ON(sizeof(priv->rates) != sizeof(rtl818x_rates));
+
 	memcpy(priv->channels, rtl818x_channels, sizeof(rtl818x_channels));
 	memcpy(priv->rates, rtl818x_rates, sizeof(rtl818x_rates));
 	priv->map = (struct rtl818x_csr *)0xFF00;
-	priv->modes[0].mode = MODE_IEEE80211G;
-	priv->modes[0].num_rates = ARRAY_SIZE(rtl818x_rates);
-	priv->modes[0].rates = priv->rates;
-	priv->modes[0].num_channels = ARRAY_SIZE(rtl818x_channels);
-	priv->modes[0].channels = priv->channels;
-	priv->modes[1].mode = MODE_IEEE80211B;
-	priv->modes[1].num_rates = 4;
-	priv->modes[1].rates = priv->rates;
-	priv->modes[1].num_channels = ARRAY_SIZE(rtl818x_channels);
-	priv->modes[1].channels = priv->channels;
+
+	priv->band.band = IEEE80211_BAND_2GHZ;
+	priv->band.channels = priv->channels;
+	priv->band.n_channels = ARRAY_SIZE(rtl818x_channels);
+	priv->band.bitrates = priv->rates;
+	priv->band.n_bitrates = ARRAY_SIZE(rtl818x_rates);
+	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+
+
 	priv->mode = IEEE80211_IF_TYPE_MNTR;
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS;
@@ -701,10 +735,6 @@ static int __devinit rtl8187_probe(struc
 	dev->max_rssi = 65;
 	dev->max_signal = 64;
 
-	for (i = 0; i < 2; i++)
-		if ((err = ieee80211_register_hwmode(dev, &priv->modes[i])))
-			goto err_free_dev;
-
 	eeprom.data = dev;
 	eeprom.register_read = rtl8187_eeprom_register_read;
 	eeprom.register_write = rtl8187_eeprom_register_write;
@@ -728,20 +758,20 @@ static int __devinit rtl8187_probe(struc
 	for (i = 0; i < 3; i++) {
 		eeprom_93cx6_read(&eeprom, RTL8187_EEPROM_TXPWR_CHAN_1 + i,
 				  &txpwr);
-		(*channel++).val = txpwr & 0xFF;
-		(*channel++).val = txpwr >> 8;
+		(*channel++).hw_value = txpwr & 0xFF;
+		(*channel++).hw_value = txpwr >> 8;
 	}
 	for (i = 0; i < 2; i++) {
 		eeprom_93cx6_read(&eeprom, RTL8187_EEPROM_TXPWR_CHAN_4 + i,
 				  &txpwr);
-		(*channel++).val = txpwr & 0xFF;
-		(*channel++).val = txpwr >> 8;
+		(*channel++).hw_value = txpwr & 0xFF;
+		(*channel++).hw_value = txpwr >> 8;
 	}
 	for (i = 0; i < 2; i++) {
 		eeprom_93cx6_read(&eeprom, RTL8187_EEPROM_TXPWR_CHAN_6 + i,
 				  &txpwr);
-		(*channel++).val = txpwr & 0xFF;
-		(*channel++).val = txpwr >> 8;
+		(*channel++).hw_value = txpwr & 0xFF;
+		(*channel++).hw_value = txpwr >> 8;
 	}
 
 	eeprom_93cx6_read(&eeprom, RTL8187_EEPROM_TXPWR_BASE,
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965.h	2008-01-24 19:35:08.453587023 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965.h	2008-01-24 19:35:11.793594347 +0100
@@ -206,7 +206,7 @@ struct iwl4965_channel_info {
 
 	u8 group_index;	  /* 0-4, maps channel to group1/2/3/4/5 */
 	u8 band_index;	  /* 0-4, maps channel to band1/2/3/4/5 */
-	u8 phymode;	  /* MODE_IEEE80211{A,B,G} */
+	enum ieee80211_band band;
 
 	/* Radio/DSP gain settings for each "normal" data Tx rate.
 	 * These include, in addition to RF and DSP gain, a few fields for
@@ -762,7 +762,8 @@ extern void iwl4965_update_rate_scaling(
 extern void iwl4965_chain_noise_reset(struct iwl4965_priv *priv);
 extern void iwl4965_init_sensitivity(struct iwl4965_priv *priv, u8 flags,
 				     u8 force);
-extern int iwl4965_set_fat_chan_info(struct iwl4965_priv *priv, int phymode,
+extern int iwl4965_set_fat_chan_info(struct iwl4965_priv *priv,
+				enum ieee80211_band band,
 				u16 channel,
 				const struct iwl4965_eeprom_channel *eeprom_ch,
 				u8 fat_extension_channel);
@@ -1025,14 +1026,14 @@ struct iwl4965_priv {
 	struct list_head free_frames;
 	int frames_count;
 
-	u8 phymode;
+	enum ieee80211_band band;
 	int alloc_rxb_skb;
 	bool add_radiotap;
 
 	void (*rx_handlers[REPLY_MAX])(struct iwl4965_priv *priv,
 				       struct iwl4965_rx_mem_buffer *rxb);
 
-	const struct ieee80211_hw_mode *modes;
+	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 
 #ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 	/* spectrum measurement report caching */
@@ -1295,13 +1296,12 @@ static inline int is_channel_radar(const
 
 static inline u8 is_channel_a_band(const struct iwl4965_channel_info *ch_info)
 {
-	return ch_info->phymode == MODE_IEEE80211A;
+	return ch_info->band == IEEE80211_BAND_5GHZ;
 }
 
 static inline u8 is_channel_bg_band(const struct iwl4965_channel_info *ch_info)
 {
-	return ((ch_info->phymode == MODE_IEEE80211B) ||
-		(ch_info->phymode == MODE_IEEE80211G));
+	return ch_info->band == IEEE80211_BAND_2GHZ;
 }
 
 static inline int is_channel_passive(const struct iwl4965_channel_info *ch)
@@ -1315,7 +1315,7 @@ static inline int is_channel_ibss(const 
 }
 
 extern const struct iwl4965_channel_info *iwl4965_get_channel_info(
-	const struct iwl4965_priv *priv, int phymode, u16 channel);
+	const struct iwl4965_priv *priv, enum ieee80211_band band, u16 channel);
 
 /* Requires full declaration of iwl4965_priv before including */
 #include "iwl-4965-io.h"
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-01-24 19:35:10.153586589 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-01-24 19:35:11.813586752 +0100
@@ -115,16 +115,10 @@ __le16 *ieee80211_get_qos_ctrl(struct ie
 	return NULL;
 }
 
-static const struct ieee80211_hw_mode *iwl4965_get_hw_mode(
-		struct iwl4965_priv *priv, int mode)
+static const struct ieee80211_supported_band *iwl4965_get_hw_mode(
+		struct iwl4965_priv *priv, enum ieee80211_band band)
 {
-	int i;
-
-	for (i = 0; i < 3; i++)
-		if (priv->modes[i].mode == mode)
-			return &priv->modes[i];
-
-	return NULL;
+	return priv->hw->wiphy->bands[band];
 }
 
 static int iwl4965_is_empty_essid(const char *essid, int essid_len)
@@ -932,28 +926,29 @@ static int iwl4965_rxon_add_station(stru
  * NOTE:  Does not commit to the hardware; it sets appropriate bit fields
  * in the staging RXON flag structure based on the phymode
  */
-static int iwl4965_set_rxon_channel(struct iwl4965_priv *priv, u8 phymode,
+static int iwl4965_set_rxon_channel(struct iwl4965_priv *priv,
+				    enum ieee80211_band band,
 				 u16 channel)
 {
-	if (!iwl4965_get_channel_info(priv, phymode, channel)) {
+	if (!iwl4965_get_channel_info(priv, band, channel)) {
 		IWL_DEBUG_INFO("Could not set channel to %d [%d]\n",
-			       channel, phymode);
+			       channel, band);
 		return -EINVAL;
 	}
 
 	if ((le16_to_cpu(priv->staging_rxon.channel) == channel) &&
-	    (priv->phymode == phymode))
+	    (priv->band == band))
 		return 0;
 
 	priv->staging_rxon.channel = cpu_to_le16(channel);
-	if (phymode == MODE_IEEE80211A)
+	if (band == IEEE80211_BAND_5GHZ)
 		priv->staging_rxon.flags &= ~RXON_FLG_BAND_24G_MSK;
 	else
 		priv->staging_rxon.flags |= RXON_FLG_BAND_24G_MSK;
 
-	priv->phymode = phymode;
+	priv->band = band;
 
-	IWL_DEBUG_INFO("Staging channel set to %d [%d]\n", channel, phymode);
+	IWL_DEBUG_INFO("Staging channel set to %d [%d]\n", channel, band);
 
 	return 0;
 }
@@ -2566,9 +2561,10 @@ static int iwl4965_set_rxon_hwcrypto(str
 	return 0;
 }
 
-static void iwl4965_set_flags_for_phymode(struct iwl4965_priv *priv, u8 phymode)
+static void iwl4965_set_flags_for_phymode(struct iwl4965_priv *priv,
+					  enum ieee80211_band band)
 {
-	if (phymode == MODE_IEEE80211A) {
+	if (band == IEEE80211_BAND_5GHZ) {
 		priv->staging_rxon.flags &=
 		    ~(RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK
 		      | RXON_FLG_CCK_MSK);
@@ -2631,7 +2627,7 @@ static void iwl4965_connection_init_rx_c
 		priv->staging_rxon.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 #endif
 
-	ch_info = iwl4965_get_channel_info(priv, priv->phymode,
+	ch_info = iwl4965_get_channel_info(priv, priv->band,
 				       le16_to_cpu(priv->staging_rxon.channel));
 
 	if (!ch_info)
@@ -2646,12 +2642,9 @@ static void iwl4965_connection_init_rx_c
 		ch_info = &priv->channel_info[0];
 
 	priv->staging_rxon.channel = cpu_to_le16(ch_info->channel);
-	if (is_channel_a_band(ch_info))
-		priv->phymode = MODE_IEEE80211A;
-	else
-		priv->phymode = MODE_IEEE80211G;
+	priv->band = ch_info->band;
 
-	iwl4965_set_flags_for_phymode(priv, priv->phymode);
+	iwl4965_set_flags_for_phymode(priv, priv->band);
 
 	priv->staging_rxon.ofdm_basic_rates =
 	    (IWL_OFDM_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
@@ -2673,7 +2666,7 @@ static int iwl4965_set_mode(struct iwl49
 		const struct iwl4965_channel_info *ch_info;
 
 		ch_info = iwl4965_get_channel_info(priv,
-			priv->phymode,
+			priv->band,
 			le16_to_cpu(priv->staging_rxon.channel));
 
 		if (!ch_info || !is_channel_ibss(ch_info)) {
@@ -2913,7 +2906,7 @@ static int iwl4965_tx_skb(struct iwl4965
 		goto drop_unlock;
 	}
 
-	if ((ctl->tx_rate & 0xFF) == IWL_INVALID_RATE) {
+	if ((ctl->tx_rate->hw_value & 0xFF) == IWL_INVALID_RATE) {
 		IWL_ERROR("ERROR: No TX rate available.\n");
 		goto drop_unlock;
 	}
@@ -3129,11 +3122,11 @@ drop:
 
 static void iwl4965_set_rate(struct iwl4965_priv *priv)
 {
-	const struct ieee80211_hw_mode *hw = NULL;
+	const struct ieee80211_supported_band *hw = NULL;
 	struct ieee80211_rate *rate;
 	int i;
 
-	hw = iwl4965_get_hw_mode(priv, priv->phymode);
+	hw = iwl4965_get_hw_mode(priv, priv->band);
 	if (!hw) {
 		IWL_ERROR("Failed to set rate: unable to get hw mode\n");
 		return;
@@ -3142,24 +3135,10 @@ static void iwl4965_set_rate(struct iwl4
 	priv->active_rate = 0;
 	priv->active_rate_basic = 0;
 
-	IWL_DEBUG_RATE("Setting rates for 802.11%c\n",
-		       hw->mode == MODE_IEEE80211A ?
-		       'a' : ((hw->mode == MODE_IEEE80211B) ? 'b' : 'g'));
-
-	for (i = 0; i < hw->num_rates; i++) {
-		rate = &(hw->rates[i]);
-		if ((rate->val < IWL_RATE_COUNT) &&
-		    (rate->flags & IEEE80211_RATE_SUPPORTED)) {
-			IWL_DEBUG_RATE("Adding rate index %d (plcp %d)%s\n",
-				       rate->val, iwl4965_rates[rate->val].plcp,
-				       (rate->flags & IEEE80211_RATE_BASIC) ?
-				       "*" : "");
-			priv->active_rate |= (1 << rate->val);
-			if (rate->flags & IEEE80211_RATE_BASIC)
-				priv->active_rate_basic |= (1 << rate->val);
-		} else
-			IWL_DEBUG_RATE("Not adding rate %d (plcp %d)\n",
-				       rate->val, iwl4965_rates[rate->val].plcp);
+	for (i = 0; i < hw->n_bitrates; i++) {
+		rate = &(hw->bitrates[i]);
+		if (rate->hw_value < IWL_RATE_COUNT)
+			priv->active_rate |= (1 << rate->hw_value);
 	}
 
 	IWL_DEBUG_RATE("Set active_rate = %0x, active_rate_basic = %0x\n",
@@ -3776,9 +3755,6 @@ static void iwl4965_rx_reply_tx(struct i
 	tx_status->flags =
 	    iwl4965_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
 
-	tx_status->control.tx_rate =
-		iwl4965_hw_get_rate_n_flags(tx_resp->rate_n_flags);
-
 	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) rate_n_flags 0x%x "
 		     "retries %d\n", txq_id, iwl4965_get_tx_fail_reason(status),
 		     status, le32_to_cpu(tx_resp->rate_n_flags),
@@ -5411,24 +5387,23 @@ static void iwl4965_init_band_reference(
  * Based on band and channel number.
  */
 const struct iwl4965_channel_info *iwl4965_get_channel_info(const struct iwl4965_priv *priv,
-						    int phymode, u16 channel)
+						    enum ieee80211_band band, u16 channel)
 {
 	int i;
 
-	switch (phymode) {
-	case MODE_IEEE80211A:
+	switch (band) {
+	case IEEE80211_BAND_5GHZ:
 		for (i = 14; i < priv->channel_count; i++) {
 			if (priv->channel_info[i].channel == channel)
 				return &priv->channel_info[i];
 		}
 		break;
-
-	case MODE_IEEE80211B:
-	case MODE_IEEE80211G:
+	case IEEE80211_BAND_2GHZ:
 		if (channel >= 1 && channel <= 14)
 			return &priv->channel_info[channel - 1];
 		break;
-
+	default:
+		BUG();
 	}
 
 	return NULL;
@@ -5491,8 +5466,8 @@ static int iwl4965_init_channel_map(stru
 		/* Loop through each band adding each of the channels */
 		for (ch = 0; ch < eeprom_ch_count; ch++) {
 			ch_info->channel = eeprom_ch_index[ch];
-			ch_info->phymode = (band == 1) ? MODE_IEEE80211B :
-			    MODE_IEEE80211A;
+			ch_info->band = (band == 1) ? IEEE80211_BAND_2GHZ :
+			    IEEE80211_BAND_5GHZ;
 
 			/* permanently store EEPROM's channel regulatory flags
 			 *   and max power in channel info database. */
@@ -5551,14 +5526,14 @@ static int iwl4965_init_channel_map(stru
 
 	/* Two additional EEPROM bands for 2.4 and 5 GHz FAT channels */
 	for (band = 6; band <= 7; band++) {
-		int phymode;
+		enum ieee80211_band ieeeband;
 		u8 fat_extension_chan;
 
 		iwl4965_init_band_reference(priv, band, &eeprom_ch_count,
 					&eeprom_ch_info, &eeprom_ch_index);
 
 		/* EEPROM band 6 is 2.4, band 7 is 5 GHz */
-		phymode = (band == 6) ? MODE_IEEE80211B : MODE_IEEE80211A;
+		ieeeband = (band == 6) ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 
 		/* Loop through each band adding each of the channels */
 		for (ch = 0; ch < eeprom_ch_count; ch++) {
@@ -5572,13 +5547,13 @@ static int iwl4965_init_channel_map(stru
 				fat_extension_chan = HT_IE_EXT_CHANNEL_ABOVE;
 
 			/* Set up driver's info for lower half */
-			iwl4965_set_fat_chan_info(priv, phymode,
+			iwl4965_set_fat_chan_info(priv, ieeeband,
 						  eeprom_ch_index[ch],
 						  &(eeprom_ch_info[ch]),
 						  fat_extension_chan);
 
 			/* Set up driver's info for upper half */
-			iwl4965_set_fat_chan_info(priv, phymode,
+			iwl4965_set_fat_chan_info(priv, ieeeband,
 						  (eeprom_ch_index[ch] + 4),
 						  &(eeprom_ch_info[ch]),
 						  HT_IE_EXT_CHANNEL_BELOW);
@@ -5620,18 +5595,20 @@ static void iwl4965_free_channel_map(str
 #define IWL_PASSIVE_DWELL_BASE      (100)
 #define IWL_CHANNEL_TUNE_TIME       5
 
-static inline u16 iwl4965_get_active_dwell_time(struct iwl4965_priv *priv, int phymode)
+static inline u16 iwl4965_get_active_dwell_time(struct iwl4965_priv *priv,
+						enum ieee80211_band band)
 {
-	if (phymode == MODE_IEEE80211A)
+	if (band == IEEE80211_BAND_5GHZ)
 		return IWL_ACTIVE_DWELL_TIME_52;
 	else
 		return IWL_ACTIVE_DWELL_TIME_24;
 }
 
-static u16 iwl4965_get_passive_dwell_time(struct iwl4965_priv *priv, int phymode)
+static u16 iwl4965_get_passive_dwell_time(struct iwl4965_priv *priv,
+					  enum ieee80211_band band)
 {
-	u16 active = iwl4965_get_active_dwell_time(priv, phymode);
-	u16 passive = (phymode != MODE_IEEE80211A) ?
+	u16 active = iwl4965_get_active_dwell_time(priv, band);
+	u16 passive = (band != IEEE80211_BAND_5GHZ) ?
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_24 :
 	    IWL_PASSIVE_DWELL_BASE + IWL_PASSIVE_DWELL_TIME_52;
 
@@ -5651,28 +5628,29 @@ static u16 iwl4965_get_passive_dwell_tim
 	return passive;
 }
 
-static int iwl4965_get_channels_for_scan(struct iwl4965_priv *priv, int phymode,
+static int iwl4965_get_channels_for_scan(struct iwl4965_priv *priv,
+					 enum ieee80211_band band,
 				     u8 is_active, u8 direct_mask,
 				     struct iwl4965_scan_channel *scan_ch)
 {
 	const struct ieee80211_channel *channels = NULL;
-	const struct ieee80211_hw_mode *hw_mode;
+	const struct ieee80211_supported_band *sband;
 	const struct iwl4965_channel_info *ch_info;
 	u16 passive_dwell = 0;
 	u16 active_dwell = 0;
 	int added, i;
 
-	hw_mode = iwl4965_get_hw_mode(priv, phymode);
-	if (!hw_mode)
+	sband = iwl4965_get_hw_mode(priv, band);
+	if (!sband)
 		return 0;
 
-	channels = hw_mode->channels;
+	channels = sband->channels;
 
-	active_dwell = iwl4965_get_active_dwell_time(priv, phymode);
-	passive_dwell = iwl4965_get_passive_dwell_time(priv, phymode);
+	active_dwell = iwl4965_get_active_dwell_time(priv, band);
+	passive_dwell = iwl4965_get_passive_dwell_time(priv, band);
 
-	for (i = 0, added = 0; i < hw_mode->num_channels; i++) {
-		if (channels[i].chan ==
+	for (i = 0, added = 0; i < sband->n_channels; i++) {
+		if (ieee80211_frequency_to_channel(channels[i].center_freq) ==
 		    le16_to_cpu(priv->active_rxon.channel)) {
 			if (iwl4965_is_associated(priv)) {
 				IWL_DEBUG_SCAN
@@ -5683,9 +5661,9 @@ static int iwl4965_get_channels_for_scan
 		} else if (priv->only_active_channel)
 			continue;
 
-		scan_ch->channel = channels[i].chan;
+		scan_ch->channel = ieee80211_frequency_to_channel(channels[i].center_freq);
 
-		ch_info = iwl4965_get_channel_info(priv, phymode,
+		ch_info = iwl4965_get_channel_info(priv, band,
 					 scan_ch->channel);
 		if (!is_channel_valid(ch_info)) {
 			IWL_DEBUG_SCAN("Channel %d is INVALID for this SKU.\n",
@@ -5694,7 +5672,7 @@ static int iwl4965_get_channels_for_scan
 		}
 
 		if (!is_active || is_channel_passive(ch_info) ||
-		    !(channels[i].flag & IEEE80211_CHAN_W_ACTIVE_SCAN))
+		    (channels[i].flags & IEEE80211_CHAN_PASSIVE_SCAN))
 			scan_ch->type = 0;	/* passive */
 		else
 			scan_ch->type = 1;	/* active */
@@ -5713,7 +5691,7 @@ static int iwl4965_get_channels_for_scan
 		/* scan_pwr_info->tpc.dsp_atten; */
 
 		/*scan_pwr_info->tpc.tx_gain; */
-		if (phymode == MODE_IEEE80211A)
+		if (band == IEEE80211_BAND_5GHZ)
 			scan_ch->tpc.tx_gain = ((1 << 5) | (3 << 3)) | 3;
 		else {
 			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
@@ -5737,41 +5715,23 @@ static int iwl4965_get_channels_for_scan
 	return added;
 }
 
-static void iwl4965_reset_channel_flag(struct iwl4965_priv *priv)
-{
-	int i, j;
-	for (i = 0; i < 3; i++) {
-		struct ieee80211_hw_mode *hw_mode = (void *)&priv->modes[i];
-		for (j = 0; j < hw_mode->num_channels; j++)
-			hw_mode->channels[j].flag = hw_mode->channels[j].val;
-	}
-}
-
 static void iwl4965_init_hw_rates(struct iwl4965_priv *priv,
 			      struct ieee80211_rate *rates)
 {
 	int i;
 
 	for (i = 0; i < IWL_RATE_COUNT; i++) {
-		rates[i].rate = iwl4965_rates[i].ieee * 5;
-		rates[i].val = i; /* Rate scaling will work on indexes */
-		rates[i].val2 = i;
-		rates[i].flags = IEEE80211_RATE_SUPPORTED;
-		/* Only OFDM have the bits-per-symbol set */
-		if ((i <= IWL_LAST_OFDM_RATE) && (i >= IWL_FIRST_OFDM_RATE))
-			rates[i].flags |= IEEE80211_RATE_OFDM;
-		else {
+		rates[i].bitrate = iwl4965_rates[i].ieee * 5;
+		rates[i].hw_value = i; /* Rate scaling will work on indexes */
+		rates[i].hw_value_short = i;
+		rates[i].flags = 0;
+		if ((i > IWL_LAST_OFDM_RATE) || (i < IWL_FIRST_OFDM_RATE)) {
 			/*
-			 * If CCK 1M then set rate flag to CCK else CCK_2
-			 * which is CCK | PREAMBLE2
+			 * If CCK != 1M then set short preamble rate flag.
 			 */
 			rates[i].flags |= (iwl4965_rates[i].plcp == 10) ?
-				IEEE80211_RATE_CCK : IEEE80211_RATE_CCK_2;
+				0 : IEEE80211_RATE_SHORT_PREAMBLE;
 		}
-
-		/* Set up which ones are basic rates... */
-		if (IWL_BASIC_RATES_MASK & (1 << i))
-			rates[i].flags |= IEEE80211_RATE_BASIC;
 	}
 }
 
@@ -5781,74 +5741,47 @@ static void iwl4965_init_hw_rates(struct
 static int iwl4965_init_geos(struct iwl4965_priv *priv)
 {
 	struct iwl4965_channel_info *ch;
-	struct ieee80211_hw_mode *modes;
+	struct ieee80211_supported_band *band;
 	struct ieee80211_channel *channels;
 	struct ieee80211_channel *geo_ch;
 	struct ieee80211_rate *rates;
 	int i = 0;
-	enum {
-		A = 0,
-		B = 1,
-		G = 2,
-	};
-	int mode_count = 3;
 
-	if (priv->modes) {
+	if (priv->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
+	    priv->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
 		IWL_DEBUG_INFO("Geography modes already initialized.\n");
 		set_bit(STATUS_GEO_CONFIGURED, &priv->status);
 		return 0;
 	}
 
-	modes = kzalloc(sizeof(struct ieee80211_hw_mode) * mode_count,
-			GFP_KERNEL);
-	if (!modes)
-		return -ENOMEM;
-
 	channels = kzalloc(sizeof(struct ieee80211_channel) *
 			   priv->channel_count, GFP_KERNEL);
-	if (!channels) {
-		kfree(modes);
+	if (!channels)
 		return -ENOMEM;
-	}
 
 	rates = kzalloc((sizeof(struct ieee80211_rate) * (IWL_MAX_RATES + 1)),
 			GFP_KERNEL);
 	if (!rates) {
-		kfree(modes);
 		kfree(channels);
 		return -ENOMEM;
 	}
 
-	/* 0 = 802.11a
-	 * 1 = 802.11b
-	 * 2 = 802.11g
-	 */
-
 	/* 5.2GHz channels start after the 2.4GHz channels */
-	modes[A].mode = MODE_IEEE80211A;
-	modes[A].channels = &channels[ARRAY_SIZE(iwl4965_eeprom_band_1)];
-	modes[A].rates = rates;
-	modes[A].num_rates = 8;	/* just OFDM */
-	modes[A].rates = &rates[4];
-	modes[A].num_channels = 0;
 #ifdef CONFIG_IWL4965_HT
 	iwl4965_init_ht_hw_capab(&modes[A].ht_info, MODE_IEEE80211A);
 #endif
-
-	modes[B].mode = MODE_IEEE80211B;
-	modes[B].channels = channels;
-	modes[B].rates = rates;
-	modes[B].num_rates = 4;	/* just CCK */
-	modes[B].num_channels = 0;
-
-	modes[G].mode = MODE_IEEE80211G;
-	modes[G].channels = channels;
-	modes[G].rates = rates;
-	modes[G].num_rates = 12;	/* OFDM & CCK */
-	modes[G].num_channels = 0;
 #ifdef CONFIG_IWL4965_HT
 	iwl4965_init_ht_hw_capab(&modes[G].ht_info, MODE_IEEE80211G);
 #endif
+	band = &priv->bands[IEEE80211_BAND_5GHZ];
+	band->channels = &channels[ARRAY_SIZE(iwl4965_eeprom_band_1)];
+	band->bitrates = &rates[4];
+	band->n_bitrates = 8;	/* just OFDM */
+
+	band = &priv->bands[IEEE80211_BAND_2GHZ];
+	band->channels = channels;
+	band->bitrates = rates;
+	band->n_bitrates = 12;	/* OFDM & CCK */
 
 	priv->ieee_channels = channels;
 	priv->ieee_rates = rates;
@@ -5867,37 +5800,32 @@ static int iwl4965_init_geos(struct iwl4
 		}
 
 		if (is_channel_a_band(ch)) {
-			geo_ch = &modes[A].channels[modes[A].num_channels++];
-		} else {
-			geo_ch = &modes[B].channels[modes[B].num_channels++];
-			modes[G].num_channels++;
-		}
+			geo_ch = &priv->bands[IEEE80211_BAND_5GHZ].channels[priv->bands[IEEE80211_BAND_5GHZ].n_channels++];
+		} else
+			geo_ch = &priv->bands[IEEE80211_BAND_2GHZ].channels[priv->bands[IEEE80211_BAND_2GHZ].n_channels++];
 
-		geo_ch->freq = ieee80211chan2mhz(ch->channel);
-		geo_ch->chan = ch->channel;
-		geo_ch->power_level = ch->max_power_avg;
-		geo_ch->antenna_max = 0xff;
+		geo_ch->center_freq = ieee80211chan2mhz(ch->channel);
+		geo_ch->max_power = ch->max_power_avg;
+		geo_ch->max_antenna_gain = 0xff;
 
 		if (is_channel_valid(ch)) {
-			geo_ch->flag = IEEE80211_CHAN_W_SCAN;
-			if (ch->flags & EEPROM_CHANNEL_IBSS)
-				geo_ch->flag |= IEEE80211_CHAN_W_IBSS;
+			if (!(ch->flags & EEPROM_CHANNEL_IBSS))
+				geo_ch->flags |= IEEE80211_CHAN_NO_IBSS;
 
-			if (ch->flags & EEPROM_CHANNEL_ACTIVE)
-				geo_ch->flag |= IEEE80211_CHAN_W_ACTIVE_SCAN;
+			if (!(ch->flags & EEPROM_CHANNEL_ACTIVE))
+				geo_ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
 
 			if (ch->flags & EEPROM_CHANNEL_RADAR)
-				geo_ch->flag |= IEEE80211_CHAN_W_RADAR_DETECT;
+				geo_ch->flags |= IEEE80211_CHAN_RADAR;
 
 			if (ch->max_power_avg > priv->max_channel_txpower_limit)
 				priv->max_channel_txpower_limit =
 				    ch->max_power_avg;
-		}
-
-		geo_ch->val = geo_ch->flag;
+		} else
+			geo_ch->flags |= IEEE80211_CHAN_DISABLED;
 	}
 
-	if ((modes[A].num_channels == 0) && priv->is_abg) {
+	if ((priv->bands[IEEE80211_BAND_5GHZ].n_channels == 0) && priv->is_abg) {
 		printk(KERN_INFO DRV_NAME
 		       ": Incorrectly detected BG card as ABG.  Please send "
 		       "your PCI ID 0x%04X:0x%04X to maintainer.\n",
@@ -5907,24 +5835,12 @@ static int iwl4965_init_geos(struct iwl4
 
 	printk(KERN_INFO DRV_NAME
 	       ": Tunable channels: %d 802.11bg, %d 802.11a channels\n",
-	       modes[G].num_channels, modes[A].num_channels);
+	       priv->bands[IEEE80211_BAND_2GHZ].n_channels,
+	       priv->bands[IEEE80211_BAND_5GHZ].n_channels);
 
-	/*
-	 * NOTE:  We register these in preference of order -- the
-	 * stack doesn't currently (as of 7.0.6 / Apr 24 '07) pick
-	 * a phymode based on rates or AP capabilities but seems to
-	 * configure it purely on if the channel being configured
-	 * is supported by a mode -- and the first match is taken
-	 */
+	priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->bands[IEEE80211_BAND_2GHZ];
+	priv->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &priv->bands[IEEE80211_BAND_5GHZ];
 
-	if (modes[G].num_channels)
-		ieee80211_register_hwmode(priv->hw, &modes[G]);
-	if (modes[B].num_channels)
-		ieee80211_register_hwmode(priv->hw, &modes[B]);
-	if (modes[A].num_channels)
-		ieee80211_register_hwmode(priv->hw, &modes[A]);
-
-	priv->modes = modes;
 	set_bit(STATUS_GEO_CONFIGURED, &priv->status);
 
 	return 0;
@@ -5935,7 +5851,6 @@ static int iwl4965_init_geos(struct iwl4
  */
 static void iwl4965_free_geos(struct iwl4965_priv *priv)
 {
-	kfree(priv->modes);
 	kfree(priv->ieee_channels);
 	kfree(priv->ieee_rates);
 	clear_bit(STATUS_GEO_CONFIGURED, &priv->status);
@@ -6933,7 +6848,7 @@ static void iwl4965_bg_request_scan(stru
 	struct iwl4965_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
 	u8 direct_mask;
-	int phymode;
+	enum ieee80211_band band;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -7063,7 +6978,7 @@ static void iwl4965_bg_request_scan(stru
 				RATE_MCS_ANT_B_MSK|RATE_MCS_CCK_MSK);
 
 		scan->good_CRC_th = 0;
-		phymode = MODE_IEEE80211G;
+		band = IEEE80211_BAND_2GHZ;
 		break;
 
 	case 1:
@@ -7071,7 +6986,7 @@ static void iwl4965_bg_request_scan(stru
 				iwl4965_hw_set_rate_n_flags(IWL_RATE_6M_PLCP,
 				RATE_MCS_ANT_B_MSK);
 		scan->good_CRC_th = IWL_GOOD_CRC_TH;
-		phymode = MODE_IEEE80211A;
+		band = IEEE80211_BAND_5GHZ;
 		break;
 
 	default:
@@ -7101,7 +7016,7 @@ static void iwl4965_bg_request_scan(stru
 
 	scan->channel_count =
 		iwl4965_get_channels_for_scan(
-			priv, phymode, 1, /* active */
+			priv, band, 1, /* active */
 			direct_mask,
 			(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 
@@ -7451,7 +7366,7 @@ static int iwl4965_mac_tx(struct ieee802
 	}
 
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
-		     ctl->tx_rate);
+		     ctl->tx_rate->bitrate);
 
 	if (iwl4965_tx_skb(priv, skb, ctl))
 		dev_kfree_skb_any(skb);
@@ -7510,7 +7425,7 @@ static int iwl4965_mac_config(struct iee
 	int ret = 0;
 
 	mutex_lock(&priv->mutex);
-	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel);
+	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel->hw_value);
 
 	priv->add_radiotap = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
 
@@ -7530,10 +7445,9 @@ static int iwl4965_mac_config(struct iee
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	ch_info = iwl4965_get_channel_info(priv, conf->phymode, conf->channel);
+	ch_info = iwl4965_get_channel_info(priv, conf->channel->band,
+			ieee80211_frequency_to_channel(conf->channel->center_freq));
 	if (!is_channel_valid(ch_info)) {
-		IWL_DEBUG_SCAN("Channel %d [%d] is INVALID for this SKU.\n",
-			       conf->channel, conf->phymode);
 		IWL_DEBUG_MAC80211("leave - invalid channel\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
 		ret = -EINVAL;
@@ -7552,12 +7466,13 @@ static int iwl4965_mac_config(struct iee
 		priv->staging_rxon.flags = 0;
 #endif /* CONFIG_IWL4965_HT */
 
-	iwl4965_set_rxon_channel(priv, conf->phymode, conf->channel);
+	iwl4965_set_rxon_channel(priv, conf->channel->band,
+		ieee80211_frequency_to_channel(conf->channel->center_freq));
 
-	iwl4965_set_flags_for_phymode(priv, conf->phymode);
+	iwl4965_set_flags_for_phymode(priv, conf->channel->band);
 
 	/* The list of supported rates and rate mask can be different
-	 * for each phymode; since the phymode may have changed, reset
+	 * for each band; since the band may have changed, reset
 	 * the rate mask to what mac80211 lists */
 	iwl4965_set_rate(priv);
 
@@ -7827,7 +7742,7 @@ static void iwl4965_bss_info_changed(str
 	}
 
 	if (changes & BSS_CHANGED_ERP_CTS_PROT) {
-		if (bss_conf->use_cts_prot && (priv->phymode != MODE_IEEE80211A))
+		if (bss_conf->use_cts_prot && (priv->band != IEEE80211_BAND_5GHZ))
 			priv->staging_rxon.flags |= RXON_FLG_TGG_PROTECT_MSK;
 		else
 			priv->staging_rxon.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
@@ -8277,7 +8192,6 @@ static void iwl4965_set_ht_capab(struct 
 			u8 use_current_config)
 {
 	struct ieee80211_conf *conf = &hw->conf;
-	struct ieee80211_hw_mode *mode = conf->mode;
 
 	if (use_current_config) {
 		ht_cap->cap_info = cpu_to_le16(conf->ht_conf.cap);
@@ -8488,65 +8402,6 @@ static ssize_t store_filter_flags(struct
 static DEVICE_ATTR(filter_flags, S_IWUSR | S_IRUGO, show_filter_flags,
 		   store_filter_flags);
 
-static ssize_t show_tune(struct device *d,
-			 struct device_attribute *attr, char *buf)
-{
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)d->driver_data;
-
-	return sprintf(buf, "0x%04X\n",
-		       (priv->phymode << 8) |
-			le16_to_cpu(priv->active_rxon.channel));
-}
-
-static void iwl4965_set_flags_for_phymode(struct iwl4965_priv *priv, u8 phymode);
-
-static ssize_t store_tune(struct device *d,
-			  struct device_attribute *attr,
-			  const char *buf, size_t count)
-{
-	struct iwl4965_priv *priv = (struct iwl4965_priv *)d->driver_data;
-	char *p = (char *)buf;
-	u16 tune = simple_strtoul(p, &p, 0);
-	u8 phymode = (tune >> 8) & 0xff;
-	u16 channel = tune & 0xff;
-
-	IWL_DEBUG_INFO("Tune request to:%d channel:%d\n", phymode, channel);
-
-	mutex_lock(&priv->mutex);
-	if ((le16_to_cpu(priv->staging_rxon.channel) != channel) ||
-	    (priv->phymode != phymode)) {
-		const struct iwl4965_channel_info *ch_info;
-
-		ch_info = iwl4965_get_channel_info(priv, phymode, channel);
-		if (!ch_info) {
-			IWL_WARNING("Requested invalid phymode/channel "
-				    "combination: %d %d\n", phymode, channel);
-			mutex_unlock(&priv->mutex);
-			return -EINVAL;
-		}
-
-		/* Cancel any currently running scans... */
-		if (iwl4965_scan_cancel_timeout(priv, 100))
-			IWL_WARNING("Could not cancel scan.\n");
-		else {
-			IWL_DEBUG_INFO("Committing phymode and "
-				       "rxon.channel = %d %d\n",
-				       phymode, channel);
-
-			iwl4965_set_rxon_channel(priv, phymode, channel);
-			iwl4965_set_flags_for_phymode(priv, phymode);
-
-			iwl4965_set_rate(priv);
-			iwl4965_commit_rxon(priv);
-		}
-	}
-	mutex_unlock(&priv->mutex);
-
-	return count;
-}
-
-static DEVICE_ATTR(tune, S_IWUSR | S_IRUGO, show_tune, store_tune);
-
 #ifdef CONFIG_IWL4965_SPECTRUM_MEASUREMENT
 
 static ssize_t show_measurement(struct device *d,
@@ -8736,73 +8591,8 @@ static DEVICE_ATTR(power_level, S_IWUSR 
 static ssize_t show_channels(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
-	struct iwl4965_priv *priv = dev_get_drvdata(d);
-	int len = 0, i;
-	struct ieee80211_channel *channels = NULL;
-	const struct ieee80211_hw_mode *hw_mode = NULL;
-	int count = 0;
-
-	if (!iwl4965_is_ready(priv))
-		return -EAGAIN;
-
-	hw_mode = iwl4965_get_hw_mode(priv, MODE_IEEE80211G);
-	if (!hw_mode)
-		hw_mode = iwl4965_get_hw_mode(priv, MODE_IEEE80211B);
-	if (hw_mode) {
-		channels = hw_mode->channels;
-		count = hw_mode->num_channels;
-	}
-
-	len +=
-	    sprintf(&buf[len],
-		    "Displaying %d channels in 2.4GHz band "
-		    "(802.11bg):\n", count);
-
-	for (i = 0; i < count; i++)
-		len += sprintf(&buf[len], "%d: %ddBm: BSS%s%s, %s.\n",
-			       channels[i].chan,
-			       channels[i].power_level,
-			       channels[i].
-			       flag & IEEE80211_CHAN_W_RADAR_DETECT ?
-			       " (IEEE 802.11h required)" : "",
-			       (!(channels[i].flag & IEEE80211_CHAN_W_IBSS)
-				|| (channels[i].
-				    flag &
-				    IEEE80211_CHAN_W_RADAR_DETECT)) ? "" :
-			       ", IBSS",
-			       channels[i].
-			       flag & IEEE80211_CHAN_W_ACTIVE_SCAN ?
-			       "active/passive" : "passive only");
-
-	hw_mode = iwl4965_get_hw_mode(priv, MODE_IEEE80211A);
-	if (hw_mode) {
-		channels = hw_mode->channels;
-		count = hw_mode->num_channels;
-	} else {
-		channels = NULL;
-		count = 0;
-	}
-
-	len += sprintf(&buf[len], "Displaying %d channels in 5.2GHz band "
-		       "(802.11a):\n", count);
-
-	for (i = 0; i < count; i++)
-		len += sprintf(&buf[len], "%d: %ddBm: BSS%s%s, %s.\n",
-			       channels[i].chan,
-			       channels[i].power_level,
-			       channels[i].
-			       flag & IEEE80211_CHAN_W_RADAR_DETECT ?
-			       " (IEEE 802.11h required)" : "",
-			       (!(channels[i].flag & IEEE80211_CHAN_W_IBSS)
-				|| (channels[i].
-				    flag &
-				    IEEE80211_CHAN_W_RADAR_DETECT)) ? "" :
-			       ", IBSS",
-			       channels[i].
-			       flag & IEEE80211_CHAN_W_ACTIVE_SCAN ?
-			       "active/passive" : "passive only");
-
-	return len;
+	/* all this shit doesn't belong into sysfs anyway */
+	return 0;
 }
 
 static DEVICE_ATTR(channels, S_IRUSR, show_channels, NULL);
@@ -8981,7 +8771,6 @@ static struct attribute *iwl4965_sysfs_e
 	&dev_attr_statistics.attr,
 	&dev_attr_status.attr,
 	&dev_attr_temperature.attr,
-	&dev_attr_tune.attr,
 	&dev_attr_tx_power.attr,
 
 	NULL
@@ -9115,7 +8904,7 @@ static int iwl4965_pci_probe(struct pci_
 	priv->data_retry_limit = -1;
 	priv->ieee_channels = NULL;
 	priv->ieee_rates = NULL;
-	priv->phymode = -1;
+	priv->band = IEEE80211_BAND_2GHZ;
 
 	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	if (!err)
@@ -9181,7 +8970,7 @@ static int iwl4965_pci_probe(struct pci_
 	priv->qos_data.qos_cap.val = 0;
 #endif /* CONFIG_IWL4965_QOS */
 
-	iwl4965_set_rxon_channel(priv, MODE_IEEE80211G, 6);
+	iwl4965_set_rxon_channel(priv, IEEE80211_BAND_2GHZ, 6);
 	iwl4965_setup_deferred_work(priv);
 	iwl4965_setup_rx_handlers(priv);
 
@@ -9232,7 +9021,6 @@ static int iwl4965_pci_probe(struct pci_
 		IWL_ERROR("initializing geos failed: %d\n", err);
 		goto out_free_channel_map;
 	}
-	iwl4965_reset_channel_flag(priv);
 
 	iwl4965_rate_control_register(priv->hw);
 	err = ieee80211_register_hw(priv->hw);
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-01-24 19:34:51.433592123 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-01-24 19:35:11.813586752 +0100
@@ -124,7 +124,7 @@ struct iwl4965_lq_sta {
 	u8 valid_antenna;
 	u8 is_green;
 	u8 is_dup;
-	u8 phymode;
+	enum ieee80211_band band;
 	u8 ibss_sta_added;
 
 	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
@@ -404,7 +404,8 @@ static void rs_mcs_from_tbl(struct iwl49
  * fill "search" or "active" tx mode table.
  */
 static int rs_get_tbl_info_from_mcs(const struct iwl4965_rate *mcs_rate,
-				    int phymode, struct iwl4965_scale_tbl_info *tbl,
+				    enum ieee80211_band band,
+				    struct iwl4965_scale_tbl_info *tbl,
 				    int *rate_idx)
 {
 	int index;
@@ -429,7 +430,7 @@ static int rs_get_tbl_info_from_mcs(cons
 			tbl->lq_type = LQ_NONE;
 		else {
 
-			if (phymode == MODE_IEEE80211A)
+			if (band == IEEE80211_BAND_5GHZ)
 				tbl->lq_type = LQ_A;
 			else
 				tbl->lq_type = LQ_G;
@@ -607,7 +608,7 @@ static void rs_get_lower_rate(struct iwl
 	if (!is_legacy(tbl->lq_type) && (!ht_possible || !scale_index)) {
 		switch_to_legacy = 1;
 		scale_index = rs_ht_to_legacy[scale_index];
-		if (lq_sta->phymode == MODE_IEEE80211A)
+		if (lq_sta->band == IEEE80211_BAND_5GHZ)
 			tbl->lq_type = LQ_A;
 		else
 			tbl->lq_type = LQ_G;
@@ -625,7 +626,7 @@ static void rs_get_lower_rate(struct iwl
 	/* Mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
 		/* supp_rates has no CCK bits in A mode */
-		if (lq_sta->phymode == (u8) MODE_IEEE80211A)
+		if (lq_sta->band == IEEE80211_BAND_5GHZ)
 			rate_mask  = (u16)(rate_mask &
 			   (lq_sta->supp_rates << IWL_FIRST_OFDM_RATE));
 		else
@@ -719,9 +720,9 @@ static void rs_tx_status(void *priv_rate
 	search_win = (struct iwl4965_rate_scale_data *)
 	    &(search_tbl->win[0]);
 
-	tx_mcs.rate_n_flags = tx_resp->control.tx_rate;
+	tx_mcs.rate_n_flags = tx_resp->control.tx_rate->hw_value;
 
-	rs_get_tbl_info_from_mcs(&tx_mcs, priv->phymode,
+	rs_get_tbl_info_from_mcs(&tx_mcs, priv->band,
 				  &tbl_type, &rs_index);
 	if ((rs_index < 0) || (rs_index >= IWL_RATE_COUNT)) {
 		IWL_DEBUG_RATE("bad rate index at: %d rate 0x%X\n",
@@ -754,7 +755,7 @@ static void rs_tx_status(void *priv_rate
 		 * Each tx attempt steps one entry deeper in the rate table. */
 		tx_mcs.rate_n_flags =
 		    le32_to_cpu(table->rs_table[index].rate_n_flags);
-		rs_get_tbl_info_from_mcs(&tx_mcs, priv->phymode,
+		rs_get_tbl_info_from_mcs(&tx_mcs, priv->band,
 					  &tbl_type, &rs_index);
 
 		/* If type matches "search" table,
@@ -795,12 +796,12 @@ static void rs_tx_status(void *priv_rate
 	 * else look up the rate that was, finally, successful.
 	 */
 	if (!tx_resp->retry_count)
-		tx_mcs.rate_n_flags = tx_resp->control.tx_rate;
+		tx_mcs.rate_n_flags = tx_resp->control.tx_rate->hw_value;
 	else
 		tx_mcs.rate_n_flags =
 			le32_to_cpu(table->rs_table[index].rate_n_flags);
 
-	rs_get_tbl_info_from_mcs(&tx_mcs, priv->phymode,
+	rs_get_tbl_info_from_mcs(&tx_mcs, priv->band,
 				  &tbl_type, &rs_index);
 
 	/* Update frame history window with "success" if Tx got ACKed ... */
@@ -1608,7 +1609,7 @@ static void rs_rate_scale_perform(struct
 	is_green = lq_sta->is_green;
 
 	/* current tx rate */
-	index = sta->last_txrate;
+	index = sta->last_txrate_idx;
 
 	IWL_DEBUG_RATE("Rate scale index %d for type %d\n", index,
 		       tbl->lq_type);
@@ -1621,7 +1622,7 @@ static void rs_rate_scale_perform(struct
 
 	/* mask with station rate restriction */
 	if (is_legacy(tbl->lq_type)) {
-		if (lq_sta->phymode == (u8) MODE_IEEE80211A)
+		if (lq_sta->band == IEEE80211_BAND_5GHZ)
 			/* supp_rates has no CCK bits in A mode */
 			rate_scale_index_msk = (u16) (rate_mask &
 				(lq_sta->supp_rates << IWL_FIRST_OFDM_RATE));
@@ -1942,15 +1943,15 @@ static void rs_rate_scale_perform(struct
 out:
 	rs_mcs_from_tbl(&tbl->current_rate, tbl, index, is_green);
 	i = index;
-	sta->last_txrate = i;
+	sta->last_txrate_idx = i;
 
-	/* sta->txrate is an index to A mode rates which start
+	/* sta->txrate_idx is an index to A mode rates which start
 	 * at IWL_FIRST_OFDM_RATE
 	 */
-	if (lq_sta->phymode == (u8) MODE_IEEE80211A)
-		sta->txrate = i - IWL_FIRST_OFDM_RATE;
+	if (lq_sta->band == IEEE80211_BAND_5GHZ)
+		sta->txrate_idx = i - IWL_FIRST_OFDM_RATE;
 	else
-		sta->txrate = i;
+		sta->txrate_idx = i;
 
 	return;
 }
@@ -1972,7 +1973,7 @@ static void rs_initialize_lq(struct iwl4
 		goto out;
 
 	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
-	i = sta->last_txrate;
+	i = sta->last_txrate_idx;
 
 	if ((lq_sta->lq.sta_id == 0xff) &&
 	    (priv->iw_mode == IEEE80211_IF_TYPE_IBSS))
@@ -1996,7 +1997,7 @@ static void rs_initialize_lq(struct iwl4
 		mcs_rate.rate_n_flags |= RATE_MCS_CCK_MSK;
 
 	tbl->antenna_type = ANT_AUX;
-	rs_get_tbl_info_from_mcs(&mcs_rate, priv->phymode, tbl, &rate_idx);
+	rs_get_tbl_info_from_mcs(&mcs_rate, priv->band, tbl, &rate_idx);
 	if (!rs_is_ant_connected(priv->valid_antenna, tbl->antenna_type))
 	    rs_toggle_antenna(&mcs_rate, tbl);
 
@@ -2010,7 +2011,8 @@ static void rs_initialize_lq(struct iwl4
 }
 
 static void rs_get_rate(void *priv_rate, struct net_device *dev,
-			struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			struct ieee80211_supported_band *sband,
+			struct sk_buff *skb,
 			struct rate_selection *sel)
 {
 
@@ -2032,14 +2034,14 @@ static void rs_get_rate(void *priv_rate,
 	fc = le16_to_cpu(hdr->frame_control);
 	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
 	    !sta || !sta->rate_ctrl_priv) {
-		sel->rate = rate_lowest(local, local->oper_hw_mode, sta);
+		sel->rate = rate_lowest(local, sband, sta);
 		if (sta)
 			sta_info_put(sta);
 		return;
 	}
 
 	lq_sta = (struct iwl4965_lq_sta *)sta->rate_ctrl_priv;
-	i = sta->last_txrate;
+	i = sta->last_txrate_idx;
 
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
 	    !lq_sta->ibss_sta_added) {
@@ -2064,7 +2066,7 @@ static void rs_get_rate(void *priv_rate,
 
  done:
 	if ((i < 0) || (i > IWL_RATE_COUNT)) {
-		sel->rate = rate_lowest(local, local->oper_hw_mode, sta);
+		sel->rate = rate_lowest(local, sband, sta);
 		return;
 	}
 	sta_info_put(sta);
@@ -2099,13 +2101,15 @@ static void rs_rate_init(void *priv_rate
 {
 	int i, j;
 	struct ieee80211_conf *conf = &local->hw.conf;
-	struct ieee80211_hw_mode *mode = local->oper_hw_mode;
+	struct ieee80211_supported_band *sband;
 	struct iwl4965_priv *priv = (struct iwl4965_priv *)priv_rate;
 	struct iwl4965_lq_sta *lq_sta = priv_sta;
 
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
 	lq_sta->flush_timer = 0;
-	lq_sta->supp_rates = sta->supp_rates;
-	sta->txrate = 3;
+	lq_sta->supp_rates = sta->supp_rates[sband->band];
+	sta->txrate_idx = 3;
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
 			rs_rate_scale_clear_window(&(lq_sta->lq_info[j].win[i]));
@@ -2140,15 +2144,15 @@ static void rs_rate_init(void *priv_rate
 	}
 
 	/* Find highest tx rate supported by hardware and destination station */
-	for (i = 0; i < mode->num_rates; i++) {
-		if ((sta->supp_rates & BIT(i)) &&
-		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED))
-			sta->txrate = i;
-	}
-	sta->last_txrate = sta->txrate;
+	for (i = 0; i < sband->n_bitrates; i++)
+		if (sta->supp_rates[sband->band] & BIT(i))
+			sta->txrate_idx = i;
+
+	sta->last_txrate_idx = sta->txrate_idx;
+	/* WTF is with this bogus comment? A doesn't have cck rates */
 	/* For MODE_IEEE80211A, cck rates are at end of rate table */
-	if (local->hw.conf.phymode == MODE_IEEE80211A)
-		sta->last_txrate += IWL_FIRST_OFDM_RATE;
+	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ)
+		sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 
 	lq_sta->is_dup = 0;
 	lq_sta->valid_antenna = priv->valid_antenna;
@@ -2157,7 +2161,7 @@ static void rs_rate_init(void *priv_rate
 	lq_sta->active_rate = priv->active_rate;
 	lq_sta->active_rate &= ~(0x1000);
 	lq_sta->active_rate_basic = priv->active_rate_basic;
-	lq_sta->phymode = priv->phymode;
+	lq_sta->band = priv->band;
 #ifdef CONFIG_IWL4965_HT
 	/*
 	 * active_siso_rate mask includes 9 MBits (bit 5), and CCK (bits 0-3),
@@ -2207,7 +2211,7 @@ static void rs_fill_link_cmd(struct iwl4
 	rs_dbgfs_set_mcs(lq_sta, tx_mcs, index);
 
 	/* Interpret rate_n_flags */
-	rs_get_tbl_info_from_mcs(tx_mcs, lq_sta->phymode,
+	rs_get_tbl_info_from_mcs(tx_mcs, lq_sta->band,
 				  &tbl_type, &rate_idx);
 
 	/* How many times should we repeat the initial rate? */
@@ -2261,7 +2265,7 @@ static void rs_fill_link_cmd(struct iwl4
 			index++;
 		}
 
-		rs_get_tbl_info_from_mcs(&new_rate, lq_sta->phymode, &tbl_type,
+		rs_get_tbl_info_from_mcs(&new_rate, lq_sta->band, &tbl_type,
 						&rate_idx);
 
 		/* Indicate to uCode which entries might be MIMO.
@@ -2354,7 +2358,7 @@ static void rs_dbgfs_set_mcs(struct iwl4
 {
 	u32 base_rate;
 
-	if (lq_sta->phymode == (u8) MODE_IEEE80211A)
+	if (lq_sta->band == IEEE80211_BAND_5GHZ)
 		base_rate = 0x800D;
 	else
 		base_rate = 0x820A;
@@ -2605,7 +2609,7 @@ int iwl4965_fill_rs_info(struct ieee8021
 
 	cnt += sprintf(&buf[cnt], "\nrate scale type %d antenna %d "
 			 "active_search %d rate index %d\n", lq_type, antenna,
-			 lq_sta->search_better_tbl, sta->last_txrate);
+			 lq_sta->search_better_tbl, sta->last_txrate_idx);
 
 	sta_info_put(sta);
 	return cnt;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965.c	2008-01-24 19:35:08.453587023 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965.c	2008-01-24 19:35:11.823585992 +0100
@@ -315,14 +315,15 @@ static int iwl4965_kw_alloc(struct iwl49
  *
  * Does not set up a command, or touch hardware.
  */
-int iwl4965_set_fat_chan_info(struct iwl4965_priv *priv, int phymode, u16 channel,
+int iwl4965_set_fat_chan_info(struct iwl4965_priv *priv,
+			      enum ieee80211_band band, u16 channel,
 			      const struct iwl4965_eeprom_channel *eeprom_ch,
 			      u8 fat_extension_channel)
 {
 	struct iwl4965_channel_info *ch_info;
 
 	ch_info = (struct iwl4965_channel_info *)
-			iwl4965_get_channel_info(priv, phymode, channel);
+			iwl4965_get_channel_info(priv, band, channel);
 
 	if (!is_channel_valid(ch_info))
 		return -1;
@@ -1915,11 +1916,12 @@ static s32 iwl4965_get_voltage_compensat
 }
 
 static const struct iwl4965_channel_info *
-iwl4965_get_channel_txpower_info(struct iwl4965_priv *priv, u8 phymode, u16 channel)
+iwl4965_get_channel_txpower_info(struct iwl4965_priv *priv,
+				 enum ieee80211_band band, u16 channel)
 {
 	const struct iwl4965_channel_info *ch_info;
 
-	ch_info = iwl4965_get_channel_info(priv, phymode, channel);
+	ch_info = iwl4965_get_channel_info(priv, band, channel);
 
 	if (!is_channel_valid(ch_info))
 		return NULL;
@@ -2368,7 +2370,7 @@ static int iwl4965_fill_txpower_tbl(stru
 
 	/* Get current (RXON) channel, band, width */
 	ch_info =
-		iwl4965_get_channel_txpower_info(priv, priv->phymode, channel);
+		iwl4965_get_channel_txpower_info(priv, priv->band, channel);
 
 	IWL_DEBUG_TXPOWER("chan %d band %d is_fat %d\n", channel, band,
 			  is_fat);
@@ -2595,8 +2597,7 @@ int iwl4965_hw_reg_send_txpower(struct i
 		return -EAGAIN;
 	}
 
-	band = ((priv->phymode == MODE_IEEE80211B) ||
-		(priv->phymode == MODE_IEEE80211G));
+	band = priv->band == IEEE80211_BAND_2GHZ;
 
 	is_fat =  is_fat_channel(priv->active_rxon.flags);
 
@@ -2626,10 +2627,9 @@ int iwl4965_hw_channel_switch(struct iwl
 	struct iwl4965_channel_switch_cmd cmd = { 0 };
 	const struct iwl4965_channel_info *ch_info;
 
-	band = ((priv->phymode == MODE_IEEE80211B) ||
-		(priv->phymode == MODE_IEEE80211G));
+	band = priv->band == IEEE80211_BAND_2GHZ;
 
-	ch_info = iwl4965_get_channel_info(priv, priv->phymode, channel);
+	ch_info = iwl4965_get_channel_info(priv, priv->band, channel);
 
 	is_fat = is_fat_channel(priv->staging_rxon.flags);
 
@@ -2674,7 +2674,7 @@ void iwl4965_hw_build_tx_cmd_rate(struct
 	u16 fc = le16_to_cpu(hdr->frame_control);
 	u8 rate_plcp;
 	u16 rate_flags = 0;
-	int rate_idx = min(ctrl->tx_rate & 0xffff, IWL_RATE_COUNT - 1);
+	int rate_idx = min(ctrl->tx_rate->hw_value & 0xffff, IWL_RATE_COUNT - 1);
 
 	rate_plcp = iwl4965_rates[rate_idx].plcp;
 
@@ -3526,7 +3526,7 @@ static void iwl4965_add_radiotap(struct 
 {
 	s8 signal = stats->ssi;
 	s8 noise = 0;
-	int rate = stats->rate;
+	int rate = stats->rate_idx;
 	u64 tsf = stats->mactime;
 	__le16 phy_flags_hw = rx_start->phy_flags;
 	struct iwl4965_rt_rx_hdr {
@@ -3594,7 +3594,6 @@ static void iwl4965_add_radiotap(struct 
 					  IEEE80211_CHAN_2GHZ),
 			      &iwl4965_rt->rt_chbitmask);
 
-	rate = iwl4965_rate_index_from_plcp(rate);
 	if (rate == -1)
 		iwl4965_rt->rt_rate = 0;
 	else
@@ -3890,12 +3889,13 @@ static void iwl4965_rx_reply_rx(struct i
 	u16 fc;
 	struct ieee80211_rx_status stats = {
 		.mactime = le64_to_cpu(rx_start->timestamp),
-		.channel = le16_to_cpu(rx_start->channel),
-		.phymode =
+		.freq = ieee80211chan2mhz(le16_to_cpu(rx_start->channel)),
+		.band =
 			(rx_start->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
-			MODE_IEEE80211G : MODE_IEEE80211A,
+			IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ,
 		.antenna = 0,
-		.rate = iwl4965_hw_get_rate(rx_start->rate_n_flags),
+		.rate_idx = iwl4965_hw_get_rate(
+				le32_to_cpu(rx_start->rate_n_flags)),
 		.flag = 0,
 	};
 	u8 network_packet;
@@ -3946,8 +3946,6 @@ static void iwl4965_rx_reply_rx(struct i
 
 	priv->ucode_beacon_time = le32_to_cpu(rx_start->beacon_time_stamp);
 
-	stats.freq = ieee80211chan2mhz(stats.channel);
-
 	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
 	stats.ssi = iwl4965_calc_rssi(rx_start);
 
@@ -4525,7 +4523,7 @@ void iwl4965_add_station(struct iwl4965_
 	 * all the way down to 1M in IEEE order, and then spin on 1M */
 	if (is_ap)
 		r = IWL_RATE_54M_INDEX;
-	else if (priv->phymode == MODE_IEEE80211A)
+	else if (priv->band == IEEE80211_BAND_5GHZ)
 		r = IWL_RATE_6M_INDEX;
 	else
 		r = IWL_RATE_1M_INDEX;
@@ -4558,12 +4556,13 @@ void iwl4965_add_station(struct iwl4965_
 
 #ifdef CONFIG_IWL4965_HT
 
-static u8 iwl4965_is_channel_extension(struct iwl4965_priv *priv, int phymode,
+static u8 iwl4965_is_channel_extension(struct iwl4965_priv *priv,
+				       enum ieee80211_band band,
 				   u16 channel, u8 extension_chan_offset)
 {
 	const struct iwl4965_channel_info *ch_info;
 
-	ch_info = iwl4965_get_channel_info(priv, phymode, channel);
+	ch_info = iwl4965_get_channel_info(priv, band, channel);
 	if (!is_channel_valid(ch_info))
 		return 0;
 
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00.h	2008-01-24 19:34:51.993587186 +0100
+++ everything/drivers/net/wireless/rt2x00/rt2x00.h	2008-01-24 19:35:11.823585992 +0100
@@ -400,6 +400,10 @@ static inline int is_interface_type(stru
 	return intf->type == type;
 }
 
+#define HWMODE_B	0
+#define HWMODE_G	1
+#define HWMODE_A	2
+
 /*
  * Details about the supported modes, rates and channels
  * of a particular chipset. This is used by rt2x00lib
@@ -609,11 +613,8 @@ struct rt2x00_dev {
 	 * IEEE80211 control structure.
 	 */
 	struct ieee80211_hw *hw;
-	struct ieee80211_hw_mode *hwmodes;
-	unsigned int curr_hwmode;
-#define HWMODE_B	0
-#define HWMODE_G	1
-#define HWMODE_A	2
+	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
+	enum ieee80211_band curr_band;
 
 	/*
 	 * rfkill structure for RF state switching support.
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-01-24 19:34:52.093587294 +0100
+++ everything/drivers/net/wireless/rt2x00/rt2x00dev.c	2008-01-24 19:35:11.823585992 +0100
@@ -580,19 +580,19 @@ void rt2x00lib_rxdone(struct data_entry 
 {
 	struct rt2x00_dev *rt2x00dev = entry->ring->rt2x00dev;
 	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *rate;
 	struct ieee80211_hdr *hdr;
 	unsigned int i;
-	int val = 0;
+	int val = 0, idx = -1;
 	u16 fc;
 
 	/*
 	 * Update RX statistics.
 	 */
-	mode = &rt2x00dev->hwmodes[rt2x00dev->curr_hwmode];
-	for (i = 0; i < mode->num_rates; i++) {
-		rate = &mode->rates[i];
+	sband = &rt2x00dev->bands[rt2x00dev->curr_band];
+	for (i = 0; i < sband->n_bitrates; i++) {
+		rate = &sband->bitrates[i];
 
 		/*
 		 * When frame was received with an OFDM bitrate,
@@ -600,12 +600,12 @@ void rt2x00lib_rxdone(struct data_entry 
 		 * a CCK bitrate the signal is the rate in 0.5kbit/s.
 		 */
 		if (!desc->ofdm)
-			val = DEVICE_GET_RATE_FIELD(rate->val, RATE);
+			val = DEVICE_GET_RATE_FIELD(rate->hw_value, RATE);
 		else
-			val = DEVICE_GET_RATE_FIELD(rate->val, PLCP);
+			val = DEVICE_GET_RATE_FIELD(rate->hw_value, PLCP);
 
 		if (val == desc->signal) {
-			val = rate->val;
+			idx = i;
 			break;
 		}
 	}
@@ -620,7 +620,7 @@ void rt2x00lib_rxdone(struct data_entry 
 
 	rt2x00dev->link.qual.rx_success++;
 
-	rx_status->rate = val;
+	rx_status->rate_idx = idx;
 	rx_status->signal =
 	    rt2x00lib_calculate_link_signal(rt2x00dev, desc->rssi);
 	rx_status->ssi = desc->rssi;
@@ -677,7 +677,7 @@ void rt2x00lib_write_tx_desc(struct rt2x
 	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
 	seq_ctrl = le16_to_cpu(ieee80211hdr->seq_ctrl);
 
-	tx_rate = control->tx_rate;
+	tx_rate = control->tx_rate->hw_value;
 
 	/*
 	 * Check whether this frame is to be acked
@@ -696,7 +696,7 @@ void rt2x00lib_write_tx_desc(struct rt2x
 		} else
 			__clear_bit(ENTRY_TXD_ACK, &desc.flags);
 		if (control->rts_cts_rate)
-			tx_rate = control->rts_cts_rate;
+			tx_rate = control->rts_cts_rate->hw_value;
 	}
 
 	/*
@@ -799,54 +799,45 @@ static void rt2x00lib_channel(struct iee
 			      const int channel, const int tx_power,
 			      const int value)
 {
-	entry->chan = channel;
 	if (channel <= 14)
-		entry->freq = 2407 + (5 * channel);
+		entry->center_freq = 2407 + (5 * channel);
 	else
-		entry->freq = 5000 + (5 * channel);
-	entry->val = value;
-	entry->flag =
-	    IEEE80211_CHAN_W_IBSS |
-	    IEEE80211_CHAN_W_ACTIVE_SCAN |
-	    IEEE80211_CHAN_W_SCAN;
-	entry->power_level = tx_power;
-	entry->antenna_max = 0xff;
+		entry->center_freq = 5000 + (5 * channel);
+	entry->hw_value = value;
+	entry->max_power = tx_power;
+	entry->max_antenna_gain = 0xff;
 }
 
 static void rt2x00lib_rate(struct ieee80211_rate *entry,
 			   const int rate, const int mask,
 			   const int plcp, const int flags)
 {
-	entry->rate = rate;
-	entry->val =
+	entry->bitrate = rate;
+	entry->hw_value =
 	    DEVICE_SET_RATE_FIELD(rate, RATE) |
 	    DEVICE_SET_RATE_FIELD(mask, RATEMASK) |
 	    DEVICE_SET_RATE_FIELD(plcp, PLCP);
 	entry->flags = flags;
-	entry->val2 = entry->val;
-	if (entry->flags & IEEE80211_RATE_PREAMBLE2)
-		entry->val2 |= DEVICE_SET_RATE_FIELD(1, PREAMBLE);
-	entry->min_rssi_ack = 0;
-	entry->min_rssi_ack_delta = 0;
+	entry->hw_value_short = entry->hw_value;
+	if (entry->flags & IEEE80211_RATE_SHORT_PREAMBLE)
+		entry->hw_value_short |= DEVICE_SET_RATE_FIELD(1, PREAMBLE);
 }
 
 static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 				    struct hw_mode_spec *spec)
 {
 	struct ieee80211_hw *hw = rt2x00dev->hw;
-	struct ieee80211_hw_mode *hwmodes;
+	struct ieee80211_supported_band *sbands;
 	struct ieee80211_channel *channels;
 	struct ieee80211_rate *rates;
 	unsigned int i;
 	unsigned char tx_power;
 
-	hwmodes = kzalloc(sizeof(*hwmodes) * spec->num_modes, GFP_KERNEL);
-	if (!hwmodes)
-		goto exit;
+	sbands = &rt2x00dev->bands[0];
 
 	channels = kzalloc(sizeof(*channels) * spec->num_channels, GFP_KERNEL);
 	if (!channels)
-		goto exit_free_modes;
+		return -ENOMEM;
 
 	rates = kzalloc(sizeof(*rates) * spec->num_rates, GFP_KERNEL);
 	if (!rates)
@@ -856,31 +847,31 @@ static int rt2x00lib_probe_hw_modes(stru
 	 * Initialize Rate list.
 	 */
 	rt2x00lib_rate(&rates[0], 10, DEV_RATEMASK_1MB,
-		       0x00, IEEE80211_RATE_CCK);
+		       0x00, 0);
 	rt2x00lib_rate(&rates[1], 20, DEV_RATEMASK_2MB,
-		       0x01, IEEE80211_RATE_CCK_2);
+		       0x01, IEEE80211_RATE_SHORT_PREAMBLE);
 	rt2x00lib_rate(&rates[2], 55, DEV_RATEMASK_5_5MB,
-		       0x02, IEEE80211_RATE_CCK_2);
+		       0x02, IEEE80211_RATE_SHORT_PREAMBLE);
 	rt2x00lib_rate(&rates[3], 110, DEV_RATEMASK_11MB,
-		       0x03, IEEE80211_RATE_CCK_2);
+		       0x03, IEEE80211_RATE_SHORT_PREAMBLE);
 
 	if (spec->num_rates > 4) {
 		rt2x00lib_rate(&rates[4], 60, DEV_RATEMASK_6MB,
-			       0x0b, IEEE80211_RATE_OFDM);
+			       0x0b, 0);
 		rt2x00lib_rate(&rates[5], 90, DEV_RATEMASK_9MB,
-			       0x0f, IEEE80211_RATE_OFDM);
+			       0x0f, 0);
 		rt2x00lib_rate(&rates[6], 120, DEV_RATEMASK_12MB,
-			       0x0a, IEEE80211_RATE_OFDM);
+			       0x0a, 0);
 		rt2x00lib_rate(&rates[7], 180, DEV_RATEMASK_18MB,
-			       0x0e, IEEE80211_RATE_OFDM);
+			       0x0e, 0);
 		rt2x00lib_rate(&rates[8], 240, DEV_RATEMASK_24MB,
-			       0x09, IEEE80211_RATE_OFDM);
+			       0x09, 0);
 		rt2x00lib_rate(&rates[9], 360, DEV_RATEMASK_36MB,
-			       0x0d, IEEE80211_RATE_OFDM);
+			       0x0d, 0);
 		rt2x00lib_rate(&rates[10], 480, DEV_RATEMASK_48MB,
-			       0x08, IEEE80211_RATE_OFDM);
+			       0x08, 0);
 		rt2x00lib_rate(&rates[11], 540, DEV_RATEMASK_54MB,
-			       0x0c, IEEE80211_RATE_OFDM);
+			       0x0c, 0);
 	}
 
 	/*
@@ -901,27 +892,27 @@ static int rt2x00lib_probe_hw_modes(stru
 	/*
 	 * Intitialize 802.11b
 	 * Rates: CCK.
-	 * Channels: OFDM.
+	 * Channels: 2.4 GHz
 	 */
 	if (spec->num_modes > HWMODE_B) {
-		hwmodes[HWMODE_B].mode = MODE_IEEE80211B;
-		hwmodes[HWMODE_B].num_channels = 14;
-		hwmodes[HWMODE_B].num_rates = 4;
-		hwmodes[HWMODE_B].channels = channels;
-		hwmodes[HWMODE_B].rates = rates;
+		sbands[IEEE80211_BAND_2GHZ].n_channels = 14;
+		sbands[IEEE80211_BAND_2GHZ].n_bitrates = 4;
+		sbands[IEEE80211_BAND_2GHZ].channels = channels;
+		sbands[IEEE80211_BAND_2GHZ].bitrates = rates;
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &rt2x00dev->bands[IEEE80211_BAND_2GHZ];
 	}
 
 	/*
 	 * Intitialize 802.11g
 	 * Rates: CCK, OFDM.
-	 * Channels: OFDM.
+	 * Channels: 2.4 GHz
 	 */
 	if (spec->num_modes > HWMODE_G) {
-		hwmodes[HWMODE_G].mode = MODE_IEEE80211G;
-		hwmodes[HWMODE_G].num_channels = 14;
-		hwmodes[HWMODE_G].num_rates = spec->num_rates;
-		hwmodes[HWMODE_G].channels = channels;
-		hwmodes[HWMODE_G].rates = rates;
+		sbands[IEEE80211_BAND_2GHZ].n_channels = 14;
+		sbands[IEEE80211_BAND_2GHZ].n_bitrates = spec->num_rates;
+		sbands[IEEE80211_BAND_2GHZ].channels = channels;
+		sbands[IEEE80211_BAND_2GHZ].bitrates = rates;
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &rt2x00dev->bands[IEEE80211_BAND_2GHZ];
 	}
 
 	/*
@@ -930,39 +921,17 @@ static int rt2x00lib_probe_hw_modes(stru
 	 * Channels: OFDM, UNII, HiperLAN2.
 	 */
 	if (spec->num_modes > HWMODE_A) {
-		hwmodes[HWMODE_A].mode = MODE_IEEE80211A;
-		hwmodes[HWMODE_A].num_channels = spec->num_channels - 14;
-		hwmodes[HWMODE_A].num_rates = spec->num_rates - 4;
-		hwmodes[HWMODE_A].channels = &channels[14];
-		hwmodes[HWMODE_A].rates = &rates[4];
-	}
-
-	if (spec->num_modes > HWMODE_G &&
-	    ieee80211_register_hwmode(hw, &hwmodes[HWMODE_G]))
-		goto exit_free_rates;
-
-	if (spec->num_modes > HWMODE_B &&
-	    ieee80211_register_hwmode(hw, &hwmodes[HWMODE_B]))
-		goto exit_free_rates;
-
-	if (spec->num_modes > HWMODE_A &&
-	    ieee80211_register_hwmode(hw, &hwmodes[HWMODE_A]))
-		goto exit_free_rates;
-
-	rt2x00dev->hwmodes = hwmodes;
+		sbands[IEEE80211_BAND_5GHZ].n_channels = spec->num_channels - 14;
+		sbands[IEEE80211_BAND_5GHZ].n_bitrates = spec->num_rates - 4;
+		sbands[IEEE80211_BAND_5GHZ].channels = &channels[14];
+		sbands[IEEE80211_BAND_5GHZ].bitrates = &rates[4];
+		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &rt2x00dev->bands[IEEE80211_BAND_5GHZ];
+	}
 
 	return 0;
 
-exit_free_rates:
-	kfree(rates);
-
-exit_free_channels:
+ exit_free_channels:
 	kfree(channels);
-
-exit_free_modes:
-	kfree(hwmodes);
-
-exit:
 	ERROR(rt2x00dev, "Allocation ieee80211 modes failed.\n");
 	return -ENOMEM;
 }
@@ -972,11 +941,11 @@ static void rt2x00lib_remove_hw(struct r
 	if (test_bit(DEVICE_REGISTERED_HW, &rt2x00dev->flags))
 		ieee80211_unregister_hw(rt2x00dev->hw);
 
-	if (likely(rt2x00dev->hwmodes)) {
-		kfree(rt2x00dev->hwmodes->channels);
-		kfree(rt2x00dev->hwmodes->rates);
-		kfree(rt2x00dev->hwmodes);
-		rt2x00dev->hwmodes = NULL;
+	if (likely(rt2x00dev->hw->wiphy->bands[IEEE80211_BAND_2GHZ])) {
+		kfree(rt2x00dev->hw->wiphy->bands[IEEE80211_BAND_2GHZ]->channels);
+		kfree(rt2x00dev->hw->wiphy->bands[IEEE80211_BAND_2GHZ]->bitrates);
+		rt2x00dev->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = NULL;
+		rt2x00dev->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 	}
 }
 
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00config.c	2008-01-24 19:34:52.153586263 +0100
+++ everything/drivers/net/wireless/rt2x00/rt2x00config.c	2008-01-24 19:35:11.833586969 +0100
@@ -123,7 +123,7 @@ void rt2x00lib_config(struct rt2x00_dev 
 		      struct ieee80211_conf *conf, const int force_config)
 {
 	struct rt2x00lib_conf libconf;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *band;
 	struct ieee80211_rate *rate;
 	struct antenna_setup *default_ant = &rt2x00dev->default_ant;
 	struct antenna_setup *active_ant = &rt2x00dev->link.ant.active;
@@ -143,9 +143,9 @@ void rt2x00lib_config(struct rt2x00_dev 
 	 * Check which configuration options have been
 	 * updated and should be send to the device.
 	 */
-	if (rt2x00dev->rx_status.phymode != conf->phymode)
+	if (rt2x00dev->rx_status.band != conf->channel->band)
 		flags |= CONFIG_UPDATE_PHYMODE;
-	if (rt2x00dev->rx_status.channel != conf->channel)
+	if (rt2x00dev->rx_status.freq != conf->channel->center_freq)
 		flags |= CONFIG_UPDATE_CHANNEL;
 	if (rt2x00dev->tx_power != conf->power_level)
 		flags |= CONFIG_UPDATE_TXPOWER;
@@ -200,33 +200,31 @@ config:
 	memset(&libconf, 0, sizeof(libconf));
 
 	if (flags & CONFIG_UPDATE_PHYMODE) {
-		switch (conf->phymode) {
-		case MODE_IEEE80211A:
+		switch (conf->channel->band) {
+		case IEEE80211_BAND_5GHZ:
 			libconf.phymode = HWMODE_A;
 			break;
-		case MODE_IEEE80211B:
-			libconf.phymode = HWMODE_B;
-			break;
-		case MODE_IEEE80211G:
+		case IEEE80211_BAND_2GHZ:
+			/* Uh oh. what about B? */
 			libconf.phymode = HWMODE_G;
 			break;
 		default:
 			ERROR(rt2x00dev,
 			      "Attempt to configure unsupported mode (%d)"
-			      "Defaulting to 802.11b", conf->phymode);
+			      "Defaulting to 802.11b", conf->channel->band);
 			libconf.phymode = HWMODE_B;
 		}
 
-		mode = &rt2x00dev->hwmodes[libconf.phymode];
-		rate = &mode->rates[mode->num_rates - 1];
+		band = &rt2x00dev->bands[conf->channel->band];
+		rate = &band->bitrates[band->n_bitrates - 1];
 
 		libconf.basic_rates =
-		    DEVICE_GET_RATE_FIELD(rate->val, RATEMASK) & DEV_BASIC_RATEMASK;
+		    DEVICE_GET_RATE_FIELD(rate->hw_value, RATEMASK) & DEV_BASIC_RATEMASK;
 	}
 
 	if (flags & CONFIG_UPDATE_CHANNEL) {
 		memcpy(&libconf.rf,
-		       &rt2x00dev->spec.channels[conf->channel_val],
+		       &rt2x00dev->spec.channels[conf->channel->hw_value],
 		       sizeof(libconf.rf));
 	}
 
@@ -272,12 +270,11 @@ config:
 		rt2x00lib_reset_link_tuner(rt2x00dev);
 
 	if (flags & CONFIG_UPDATE_PHYMODE) {
-		rt2x00dev->curr_hwmode = libconf.phymode;
-		rt2x00dev->rx_status.phymode = conf->phymode;
+		rt2x00dev->curr_band = conf->channel->band;
+		rt2x00dev->rx_status.band = conf->channel->band;
 	}
 
-	rt2x00dev->rx_status.freq = conf->freq;
-	rt2x00dev->rx_status.channel = conf->channel;
+	rt2x00dev->rx_status.freq = conf->channel->center_freq;
 	rt2x00dev->tx_power = conf->power_level;
 
 	if (flags & CONFIG_UPDATE_ANTENNA) {
--- everything.orig/drivers/net/wireless/rt2x00/rt61pci.c	2008-01-24 19:34:52.253586426 +0100
+++ everything/drivers/net/wireless/rt2x00/rt61pci.c	2008-01-24 19:35:11.843586589 +0100
@@ -427,12 +427,12 @@ static void rt61pci_config_antenna_5x(st
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 2);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-				  (rt2x00dev->curr_hwmode != HWMODE_A));
+				  (rt2x00dev->curr_band != IEEE80211_BAND_5GHZ));
 		break;
 	case ANTENNA_A:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
-		if (rt2x00dev->curr_hwmode == HWMODE_A)
+		if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ)
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
 		else
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
@@ -447,7 +447,7 @@ static void rt61pci_config_antenna_5x(st
 	case ANTENNA_B:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
-		if (rt2x00dev->curr_hwmode == HWMODE_A)
+		if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ)
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
 		else
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
@@ -603,7 +603,7 @@ static void rt61pci_config_antenna(struc
 	unsigned int i;
 	u32 reg;
 
-	if (rt2x00dev->curr_hwmode == HWMODE_A) {
+	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
 		sel = antenna_sel_a;
 		lna = test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
 	} else {
@@ -617,10 +617,9 @@ static void rt61pci_config_antenna(struc
 	rt2x00pci_register_read(rt2x00dev, PHY_CSR0, &reg);
 
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG,
-			   (rt2x00dev->curr_hwmode == HWMODE_B ||
-			    rt2x00dev->curr_hwmode == HWMODE_G));
+			   rt2x00dev->curr_band == IEEE80211_BAND_2GHZ);
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A,
-			   (rt2x00dev->curr_hwmode == HWMODE_A));
+			   rt2x00dev->curr_band == IEEE80211_BAND_5GHZ);
 
 	rt2x00pci_register_write(rt2x00dev, PHY_CSR0, reg);
 
@@ -699,9 +698,9 @@ static void rt61pci_enable_led(struct rt
 
 	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_RADIO_STATUS, 1);
 	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_LINK_A_STATUS,
-			   (rt2x00dev->rx_status.phymode == MODE_IEEE80211A));
+			   rt2x00dev->rx_status.band == IEEE80211_BAND_5GHZ);
 	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_LINK_BG_STATUS,
-			   (rt2x00dev->rx_status.phymode != MODE_IEEE80211A));
+			   rt2x00dev->rx_status.band != IEEE80211_BAND_5GHZ);
 
 	arg0 = rt2x00dev->led_reg & 0xff;
 	arg1 = (rt2x00dev->led_reg >> 8) & 0xff;
@@ -799,7 +798,7 @@ static void rt61pci_link_tuner(struct rt
 	/*
 	 * Determine r17 bounds.
 	 */
-	if (rt2x00dev->rx_status.phymode == MODE_IEEE80211A) {
+	if (rt2x00dev->rx_status.band == IEEE80211_BAND_2GHZ) {
 		low_bound = 0x28;
 		up_bound = 0x48;
 		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags)) {
@@ -1531,8 +1530,10 @@ static void rt61pci_write_tx_desc(struct
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 5, &word);
+/* XXX: removed for now
 	rt2x00_set_field32(&word, TXD_W5_TX_POWER,
 			   TXPOWER_TO_DEV(control->power_level));
+ */
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
 	rt2x00_desc_write(txd, 5, word);
 
@@ -1624,7 +1625,7 @@ static int rt61pci_agc_to_rssi(struct rt
 		return 0;
 	}
 
-	if (rt2x00dev->rx_status.phymode == MODE_IEEE80211A) {
+	if (rt2x00dev->rx_status.band == IEEE80211_BAND_5GHZ) {
 		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags))
 			offset += 14;
 
--- everything.orig/drivers/net/wireless/rt2x00/rt73usb.c	2008-01-24 19:34:52.313589085 +0100
+++ everything/drivers/net/wireless/rt2x00/rt73usb.c	2008-01-24 19:35:11.843586589 +0100
@@ -442,13 +442,13 @@ static void rt73usb_config_antenna_5x(st
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 2);
 		temp = !test_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags)
-		       && (rt2x00dev->curr_hwmode != HWMODE_A);
+		       && (rt2x00dev->curr_band != IEEE80211_BAND_5GHZ);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, temp);
 		break;
 	case ANTENNA_A:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
-		if (rt2x00dev->curr_hwmode == HWMODE_A)
+		if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ)
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
 		else
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
@@ -463,7 +463,7 @@ static void rt73usb_config_antenna_5x(st
 	case ANTENNA_B:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 1);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, 0);
-		if (rt2x00dev->curr_hwmode == HWMODE_A)
+		if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ)
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 3);
 		else
 			rt2x00_set_field8(&r77, BBP_R77_RX_ANTENNA, 0);
@@ -558,7 +558,7 @@ static void rt73usb_config_antenna(struc
 	unsigned int i;
 	u32 reg;
 
-	if (rt2x00dev->curr_hwmode == HWMODE_A) {
+	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
 		sel = antenna_sel_a;
 		lna = test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags);
 	} else {
@@ -572,10 +572,9 @@ static void rt73usb_config_antenna(struc
 	rt73usb_register_read(rt2x00dev, PHY_CSR0, &reg);
 
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_BG,
-			   (rt2x00dev->curr_hwmode == HWMODE_B ||
-			    rt2x00dev->curr_hwmode == HWMODE_G));
+			   (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ));
 	rt2x00_set_field32(&reg, PHY_CSR0_PA_PE_A,
-			   (rt2x00dev->curr_hwmode == HWMODE_A));
+			   (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ));
 
 	rt73usb_register_write(rt2x00dev, PHY_CSR0, reg);
 
@@ -647,9 +646,9 @@ static void rt73usb_enable_led(struct rt
 
 	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_RADIO_STATUS, 1);
 	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_LINK_A_STATUS,
-			   (rt2x00dev->rx_status.phymode == MODE_IEEE80211A));
+			   (rt2x00dev->rx_status.band == IEEE80211_BAND_5GHZ));
 	rt2x00_set_field16(&rt2x00dev->led_reg, MCU_LEDCS_LINK_BG_STATUS,
-			   (rt2x00dev->rx_status.phymode != MODE_IEEE80211A));
+			   (rt2x00dev->rx_status.band != IEEE80211_BAND_5GHZ));
 
 	rt2x00usb_vendor_request_sw(rt2x00dev, USB_LED_CONTROL, 0x0000,
 				    rt2x00dev->led_reg, REGISTER_TIMEOUT);
@@ -739,7 +738,7 @@ static void rt73usb_link_tuner(struct rt
 	/*
 	 * Determine r17 bounds.
 	 */
-	if (rt2x00dev->rx_status.phymode == MODE_IEEE80211A) {
+	if (rt2x00dev->rx_status.band == IEEE80211_BAND_5GHZ) {
 		low_bound = 0x28;
 		up_bound = 0x48;
 
@@ -1257,8 +1256,10 @@ static void rt73usb_write_tx_desc(struct
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 5, &word);
+/* XXX: removed for now
 	rt2x00_set_field32(&word, TXD_W5_TX_POWER,
 			   TXPOWER_TO_DEV(control->power_level));
+ */
 	rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
 	rt2x00_desc_write(txd, 5, word);
 
@@ -1349,7 +1350,7 @@ static int rt73usb_agc_to_rssi(struct rt
 		return 0;
 	}
 
-	if (rt2x00dev->rx_status.phymode == MODE_IEEE80211A) {
+	if (rt2x00dev->rx_status.band == IEEE80211_BAND_5GHZ) {
 		if (test_bit(CONFIG_EXTERNAL_LNA_A, &rt2x00dev->flags)) {
 			if (lna == 3 || lna == 2)
 				offset += 10;
--- everything.orig/drivers/net/wireless/zd1211rw/zd_chip.c	2008-01-24 19:34:52.353585504 +0100
+++ everything/drivers/net/wireless/zd1211rw/zd_chip.c	2008-01-24 19:35:11.843586589 +0100
@@ -986,7 +986,7 @@ static int print_fw_version(struct zd_ch
 	return 0;
 }
 
-static int set_mandatory_rates(struct zd_chip *chip, int mode)
+static int set_mandatory_rates(struct zd_chip *chip, int gmode)
 {
 	u32 rates;
 	ZD_ASSERT(mutex_is_locked(&chip->mutex));
@@ -994,17 +994,12 @@ static int set_mandatory_rates(struct zd
 	 * that the device is supporting. Until further notice we should try
 	 * to support 802.11g also for full speed USB.
 	 */
-	switch (mode) {
-	case MODE_IEEE80211B:
+	if (!gmode)
 		rates = CR_RATE_1M|CR_RATE_2M|CR_RATE_5_5M|CR_RATE_11M;
-		break;
-	case MODE_IEEE80211G:
+	else
 		rates = CR_RATE_1M|CR_RATE_2M|CR_RATE_5_5M|CR_RATE_11M|
 			CR_RATE_6M|CR_RATE_12M|CR_RATE_24M;
-		break;
-	default:
-		return -EINVAL;
-	}
+
 	return zd_iowrite32_locked(chip, rates, CR_MANDATORY_RATE_TBL);
 }
 
@@ -1108,7 +1103,7 @@ int zd_chip_init_hw(struct zd_chip *chip
 	 * It might be discussed, whether we should suppport pure b mode for
 	 * full speed USB.
 	 */
-	r = set_mandatory_rates(chip, MODE_IEEE80211G);
+	r = set_mandatory_rates(chip, 1);
 	if (r)
 		goto out;
 	/* Disabling interrupts is certainly a smart thing here.
--- everything.orig/drivers/net/wireless/zd1211rw/zd_ieee80211.c	2008-01-24 19:34:52.423588759 +0100
+++ everything/drivers/net/wireless/zd1211rw/zd_ieee80211.c	2008-01-24 19:35:11.873588325 +0100
@@ -65,16 +65,14 @@ static const struct channel_range *zd_ch
 
 static void unmask_bg_channels(struct ieee80211_hw *hw,
 	const struct channel_range *range,
-	struct ieee80211_hw_mode *mode)
+	struct ieee80211_supported_band *sband)
 {
 	u8 channel;
 
 	for (channel = range->start; channel < range->end; channel++) {
 		struct ieee80211_channel *chan =
-			&mode->channels[CHAN_TO_IDX(channel)];
-		chan->flag |= IEEE80211_CHAN_W_SCAN |
-			IEEE80211_CHAN_W_ACTIVE_SCAN |
-			IEEE80211_CHAN_W_IBSS;
+			&sband->channels[CHAN_TO_IDX(channel)];
+		chan->flags = 0;
 	}
 }
 
@@ -97,7 +95,6 @@ void zd_geo_init(struct ieee80211_hw *hw
 		range = zd_channel_range(ZD_REGDOMAIN_FCC);
 	}
 
-	unmask_bg_channels(hw, range, &mac->modes[0]);
-	unmask_bg_channels(hw, range, &mac->modes[1]);
+	unmask_bg_channels(hw, range, &mac->band);
 }
 
--- everything.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2008-01-24 19:34:52.473586101 +0100
+++ everything/drivers/net/wireless/zd1211rw/zd_mac.c	2008-01-24 19:35:11.873588325 +0100
@@ -34,76 +34,61 @@
 
 /* This table contains the hardware specific values for the modulation rates. */
 static const struct ieee80211_rate zd_rates[] = {
-	{ .rate = 10,
-	  .val = ZD_CCK_RATE_1M,
-	  .flags = IEEE80211_RATE_CCK },
-	{ .rate = 20,
-	  .val = ZD_CCK_RATE_2M,
-	  .val2 = ZD_CCK_RATE_2M | ZD_CCK_PREA_SHORT,
-	  .flags = IEEE80211_RATE_CCK_2 },
-	{ .rate = 55,
-	  .val = ZD_CCK_RATE_5_5M,
-	  .val2 = ZD_CCK_RATE_5_5M | ZD_CCK_PREA_SHORT,
-	  .flags = IEEE80211_RATE_CCK_2 },
-	{ .rate = 110,
-	  .val = ZD_CCK_RATE_11M,
-	  .val2 = ZD_CCK_RATE_11M | ZD_CCK_PREA_SHORT,
-	  .flags = IEEE80211_RATE_CCK_2 },
-	{ .rate = 60,
-	  .val = ZD_OFDM_RATE_6M,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 90,
-	  .val = ZD_OFDM_RATE_9M,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 120,
-	  .val = ZD_OFDM_RATE_12M,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 180,
-	  .val = ZD_OFDM_RATE_18M,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 240,
-	  .val = ZD_OFDM_RATE_24M,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 360,
-	  .val = ZD_OFDM_RATE_36M,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 480,
-	  .val = ZD_OFDM_RATE_48M,
-	  .flags = IEEE80211_RATE_OFDM },
-	{ .rate = 540,
-	  .val = ZD_OFDM_RATE_54M,
-	  .flags = IEEE80211_RATE_OFDM },
+	{ .bitrate = 10,
+	  .hw_value = ZD_CCK_RATE_1M, },
+	{ .bitrate = 20,
+	  .hw_value = ZD_CCK_RATE_2M,
+	  .hw_value_short = ZD_CCK_RATE_2M | ZD_CCK_PREA_SHORT,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 55,
+	  .hw_value = ZD_CCK_RATE_5_5M,
+	  .hw_value_short = ZD_CCK_RATE_5_5M | ZD_CCK_PREA_SHORT,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 110,
+	  .hw_value = ZD_CCK_RATE_11M,
+	  .hw_value_short = ZD_CCK_RATE_11M | ZD_CCK_PREA_SHORT,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 60,
+	  .hw_value = ZD_OFDM_RATE_6M,
+	  .flags = 0 },
+	{ .bitrate = 90,
+	  .hw_value = ZD_OFDM_RATE_9M,
+	  .flags = 0 },
+	{ .bitrate = 120,
+	  .hw_value = ZD_OFDM_RATE_12M,
+	  .flags = 0 },
+	{ .bitrate = 180,
+	  .hw_value = ZD_OFDM_RATE_18M,
+	  .flags = 0 },
+	{ .bitrate = 240,
+	  .hw_value = ZD_OFDM_RATE_24M,
+	  .flags = 0 },
+	{ .bitrate = 360,
+	  .hw_value = ZD_OFDM_RATE_36M,
+	  .flags = 0 },
+	{ .bitrate = 480,
+	  .hw_value = ZD_OFDM_RATE_48M,
+	  .flags = 0 },
+	{ .bitrate = 540,
+	  .hw_value = ZD_OFDM_RATE_54M,
+	  .flags = 0 },
 };
 
 static const struct ieee80211_channel zd_channels[] = {
-	{ .chan = 1,
-	  .freq = 2412},
-	{ .chan = 2,
-	  .freq = 2417},
-	{ .chan = 3,
-	  .freq = 2422},
-	{ .chan = 4,
-	  .freq = 2427},
-	{ .chan = 5,
-	  .freq = 2432},
-	{ .chan = 6,
-	  .freq = 2437},
-	{ .chan = 7,
-	  .freq = 2442},
-	{ .chan = 8,
-	  .freq = 2447},
-	{ .chan = 9,
-	  .freq = 2452},
-	{ .chan = 10,
-	  .freq = 2457},
-	{ .chan = 11,
-	  .freq = 2462},
-	{ .chan = 12,
-	  .freq = 2467},
-	{ .chan = 13,
-	  .freq = 2472},
-	{ .chan = 14,
-	  .freq = 2484}
+	{ .center_freq = 2412, .hw_value = 1 },
+	{ .center_freq = 2417, .hw_value = 2 },
+	{ .center_freq = 2422, .hw_value = 3 },
+	{ .center_freq = 2427, .hw_value = 4 },
+	{ .center_freq = 2432, .hw_value = 5 },
+	{ .center_freq = 2437, .hw_value = 6 },
+	{ .center_freq = 2442, .hw_value = 7 },
+	{ .center_freq = 2447, .hw_value = 8 },
+	{ .center_freq = 2452, .hw_value = 9 },
+	{ .center_freq = 2457, .hw_value = 10 },
+	{ .center_freq = 2462, .hw_value = 11 },
+	{ .center_freq = 2467, .hw_value = 12 },
+	{ .center_freq = 2472, .hw_value = 13 },
+	{ .center_freq = 2484, .hw_value = 14 },
 };
 
 static void housekeeping_init(struct zd_mac *mac);
@@ -499,7 +484,9 @@ static int fill_ctrlset(struct zd_mac *m
 
 	ZD_ASSERT(frag_len <= 0xffff);
 
-	cs->modulation = control->tx_rate;
+	cs->modulation = control->tx_rate->hw_value;
+	if (control->flags & IEEE80211_TXCTL_SHORT_PREAMBLE)
+		cs->modulation = control->tx_rate->hw_value_short;
 
 	cs->tx_length = cpu_to_le16(frag_len);
 
@@ -625,6 +612,8 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 	int bad_frame = 0;
 	u16 fc;
 	bool is_qos, is_4addr, need_padding;
+	int i;
+	u8 rate;
 
 	if (length < ZD_PLCP_HEADER_SIZE + 10 /* IEEE80211_1ADDR_LEN */ +
 	             FCS_LEN + sizeof(struct rx_status))
@@ -654,14 +643,19 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 		}
 	}
 
-	stats.channel = _zd_chip_get_channel(&mac->chip);
-	stats.freq = zd_channels[stats.channel - 1].freq;
-	stats.phymode = MODE_IEEE80211G;
+	stats.freq = zd_channels[_zd_chip_get_channel(&mac->chip) - 1].center_freq;
+	stats.band = IEEE80211_BAND_2GHZ;
 	stats.ssi = status->signal_strength;
 	stats.signal = zd_rx_qual_percent(buffer,
 		                          length - sizeof(struct rx_status),
 		                          status);
-	stats.rate = zd_rx_rate(buffer, status);
+
+	rate = zd_rx_rate(buffer, status);
+
+	/* todo: return index in the big switches in zd_rx_rate instead */
+	for (i = 0; i < mac->band.n_bitrates; i++)
+		if (rate == mac->band.bitrates[i].hw_value)
+			stats.rate_idx = i;
 
 	length -= ZD_PLCP_HEADER_SIZE + sizeof(struct rx_status);
 	buffer += ZD_PLCP_HEADER_SIZE;
@@ -730,7 +724,7 @@ static void zd_op_remove_interface(struc
 static int zd_op_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
-	return zd_chip_set_channel(&mac->chip, conf->channel);
+	return zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
 }
 
 static int zd_op_config_interface(struct ieee80211_hw *hw,
@@ -888,7 +882,6 @@ struct ieee80211_hw *zd_mac_alloc_hw(str
 {
 	struct zd_mac *mac;
 	struct ieee80211_hw *hw;
-	int i;
 
 	hw = ieee80211_alloc_hw(sizeof(struct zd_mac), &zd_ops);
 	if (!hw) {
@@ -906,19 +899,14 @@ struct ieee80211_hw *zd_mac_alloc_hw(str
 
 	memcpy(mac->channels, zd_channels, sizeof(zd_channels));
 	memcpy(mac->rates, zd_rates, sizeof(zd_rates));
-	mac->modes[0].mode = MODE_IEEE80211G;
-	mac->modes[0].num_rates = ARRAY_SIZE(zd_rates);
-	mac->modes[0].rates = mac->rates;
-	mac->modes[0].num_channels = ARRAY_SIZE(zd_channels);
-	mac->modes[0].channels = mac->channels;
-	mac->modes[1].mode = MODE_IEEE80211B;
-	mac->modes[1].num_rates = 4;
-	mac->modes[1].rates = mac->rates;
-	mac->modes[1].num_channels = ARRAY_SIZE(zd_channels);
-	mac->modes[1].channels = mac->channels;
+	mac->band.n_bitrates = ARRAY_SIZE(zd_rates);
+	mac->band.bitrates = mac->rates;
+	mac->band.n_channels = ARRAY_SIZE(zd_channels);
+	mac->band.channels = mac->channels;
 
-	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
-		     IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED;
+	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &mac->band;
+
+	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS;
 	hw->max_rssi = 100;
 	hw->max_signal = 100;
 
@@ -927,14 +915,6 @@ struct ieee80211_hw *zd_mac_alloc_hw(str
 
 	skb_queue_head_init(&mac->ack_wait_queue);
 
-	for (i = 0; i < 2; i++) {
-		if (ieee80211_register_hwmode(hw, &mac->modes[i])) {
-			dev_dbg_f(&intf->dev, "cannot register hwmode\n");
-			ieee80211_free_hw(hw);
-			return NULL;
-		}
-	}
-
 	zd_chip_init(&mac->chip, hw, intf);
 	housekeeping_init(mac);
 	INIT_WORK(&mac->set_multicast_hash_work, set_multicast_hash_handler);
--- everything.orig/drivers/net/wireless/zd1211rw/zd_mac.h	2008-01-24 19:34:52.563586209 +0100
+++ everything/drivers/net/wireless/zd1211rw/zd_mac.h	2008-01-24 19:35:11.873588325 +0100
@@ -185,7 +185,7 @@ struct zd_mac {
 	struct sk_buff_head ack_wait_queue;
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];
-	struct ieee80211_hw_mode modes[2];
+	struct ieee80211_supported_band band;
 
 	/* Short preamble (used for RTS/CTS) */
 	unsigned int short_preamble:1;
--- everything.orig/drivers/net/wireless/rtl8187_rtl8225.c	2008-01-24 19:34:52.633587728 +0100
+++ everything/drivers/net/wireless/rtl8187_rtl8225.c	2008-01-24 19:35:11.873588325 +0100
@@ -283,8 +283,8 @@ static void rtl8225_rf_set_tx_power(stru
 	u32 reg;
 	int i;
 
-	cck_power = priv->channels[channel - 1].val & 0xF;
-	ofdm_power = priv->channels[channel - 1].val >> 4;
+	cck_power = priv->channels[channel - 1].hw_value & 0xF;
+	ofdm_power = priv->channels[channel - 1].hw_value >> 4;
 
 	cck_power = min(cck_power, (u8)11);
 	ofdm_power = min(ofdm_power, (u8)35);
@@ -500,8 +500,8 @@ static void rtl8225z2_rf_set_tx_power(st
 	u32 reg;
 	int i;
 
-	cck_power = priv->channels[channel - 1].val & 0xF;
-	ofdm_power = priv->channels[channel - 1].val >> 4;
+	cck_power = priv->channels[channel - 1].hw_value & 0xF;
+	ofdm_power = priv->channels[channel - 1].hw_value >> 4;
 
 	cck_power = min(cck_power, (u8)15);
 	cck_power += priv->txpwr_base & 0xF;
@@ -735,13 +735,14 @@ static void rtl8225_rf_set_channel(struc
 				   struct ieee80211_conf *conf)
 {
 	struct rtl8187_priv *priv = dev->priv;
+	int chan = ieee80211_frequency_to_channel(conf->channel->center_freq);
 
 	if (priv->rf->init == rtl8225_rf_init)
-		rtl8225_rf_set_tx_power(dev, conf->channel);
+		rtl8225_rf_set_tx_power(dev, chan);
 	else
-		rtl8225z2_rf_set_tx_power(dev, conf->channel);
+		rtl8225z2_rf_set_tx_power(dev, chan);
 
-	rtl8225_write(dev, 0x7, rtl8225_chan[conf->channel - 1]);
+	rtl8225_write(dev, 0x7, rtl8225_chan[chan - 1]);
 	msleep(10);
 }
 

-- 

