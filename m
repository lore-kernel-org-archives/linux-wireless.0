Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45725 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbXLWWPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 17:15:22 -0500
Received: from [91.5.99.18] (helo=[10.0.0.4])
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.68)
	(envelope-from <johannes@sipsolutions.net>)
	id 1J6Z6J-0006xJ-FG
	for linux-wireless@vger.kernel.org; Sun, 23 Dec 2007 22:15:19 +0000
Subject: [RFC] cfg80211 API for channels/bitrates, mac80211 and driver
	conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 23 Dec 2007 23:15:08 +0100
Message-Id: <1198448108.4103.6.camel@johannes.berg> (sfid-20071223_221531_360180_6224DF89)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch creates new cfg80211 wiphy API for channel and bitrate
registration and converts mac80211 and drivers to the new API. The
old mac80211 API is completely ripped out.

Along with the regulatory code I've also ripped out the
IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED flag, I believe it to be
unnecessary if the hardware simply gives us whatever channels it wants
to support and we then enable/disable them as required, which is pretty
much required for travelling.

Additionally, the patch adds proper "basic" rate handling for STA
mode interface, AP mode interface will have to have new API added
to allow userspace to set the basic rate set, currently it'll be
empty...

Here are a few more TODOs:
 * reimplement channel use calculations... they looked too broken to
   worry about right now
 * convert drivers other than b43
---
 drivers/net/wireless/b43/b43.h   |    5 
 drivers/net/wireless/b43/main.c  |  161 +++++++---------
 drivers/net/wireless/b43/sysfs.c |   89 ---------
 drivers/net/wireless/b43/xmit.c  |   25 +-
 include/net/mac80211.h           |  195 +++-----------------
 include/net/wireless.h           |  168 +++++++++++++++++
 net/mac80211/Makefile            |    1 
 net/mac80211/cfg.c               |   11 -
 net/mac80211/debugfs.c           |   47 ----
 net/mac80211/debugfs_sta.c       |   18 -
 net/mac80211/ieee80211.c         |  112 ++++-------
 net/mac80211/ieee80211_i.h       |   69 +------
 net/mac80211/ieee80211_iface.c   |    2 
 net/mac80211/ieee80211_ioctl.c   |  131 ++++++-------
 net/mac80211/ieee80211_rate.c    |   20 +-
 net/mac80211/ieee80211_rate.h    |   36 ++-
 net/mac80211/ieee80211_sta.c     |  380 +++++++++++++++++++++------------------
 net/mac80211/rc80211_pid_algo.c  |   70 +++----
 net/mac80211/rc80211_simple.c    |   62 ++----
 net/mac80211/regdomain.c         |  152 ---------------
 net/mac80211/rx.c                |   10 -
 net/mac80211/sta_info.c          |   24 --
 net/mac80211/sta_info.h          |   10 -
 net/mac80211/tx.c                |  151 +++++++++------
 net/mac80211/util.c              |  146 ++------------
 net/wireless/Makefile            |    2 
 net/wireless/core.c              |   41 ++++
 net/wireless/core.h              |    3 
 net/wireless/reg.c               |  153 +++++++++++++++
 net/wireless/util.c              |   98 ++++++++++
 30 files changed, 1141 insertions(+), 1251 deletions(-)

--- everything.orig/include/net/mac80211.h	2007-12-23 22:02:18.229082031 +0100
+++ everything/include/net/mac80211.h	2007-12-23 22:05:39.469079318 +0100
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
+	struct ieee80211_bitrate *tx_rate;
+
+	/* Transmit rate for RTS/CTS frame */
+	struct ieee80211_bitrate *rts_cts_rate;
+
+	/* retry rate for the last retries */
+	struct ieee80211_bitrate *alt_retry_rate;
 
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
 
@@ -411,21 +292,19 @@ enum mac80211_rx_flags {
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
+ * @rate: data rate (in 100kpbs units)
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
+ * @power_dBm: requested transmit power
+ * @max_antenna_gain_dBi: maximum antenna gain
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
+	int power_dBm;
+	int max_antenna_gain_dBi;
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
@@ -1039,7 +912,9 @@ enum ieee80211_filter_flags {
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
@@ -1222,10 +1097,6 @@ static inline char *ieee80211_get_assoc_
 }
 
 
-/* Register a new hardware PHYMODE capability to the stack. */
-int ieee80211_register_hwmode(struct ieee80211_hw *hw,
-			      struct ieee80211_hw_mode *mode);
-
 /**
  * ieee80211_unregister_hw - Unregister a hardware device
  *
@@ -1399,7 +1270,7 @@ __le16 ieee80211_ctstoself_duration(stru
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @frame_len: the length of the frame.
- * @rate: the rate (in 100kbps) at which the frame is going to be transmitted.
+ * @rate: the rate at which the frame is going to be transmitted.
  *
  * Calculate the duration field of some generic frame, given its
  * length and transmission rate (in 100kbps).
@@ -1407,7 +1278,7 @@ __le16 ieee80211_ctstoself_duration(stru
 __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 					size_t frame_len,
-					int rate);
+					struct ieee80211_bitrate *rate);
 
 /**
  * ieee80211_get_buffered_bc - accessing buffered broadcast and multicast frames
--- everything.orig/include/net/wireless.h	2007-12-23 22:02:18.299083659 +0100
+++ everything/include/net/wireless.h	2007-12-23 22:05:39.469079318 +0100
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
+ * @max_antenna_gain_dBi: maximum antenna gain in dBi
+ * @max_power_dBm: maximum transmission power
+ * @orig_mag: internal use
+ * @orig_mpwr: internal use
+ */
+struct ieee80211_channel {
+	enum ieee80211_band band;
+	u16 center_freq;
+	u16 hw_value;
+	u32 flags;
+	int max_antenna_gain_dBi;
+	int max_power_dBm;
+	u32 orig_flags;
+	int orig_mag, orig_mpwr;
+};
+
+/**
+ * enum ieee80211_bitrate_flags - rate flags
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
+enum ieee80211_bitrate_flags {
+	IEEE80211_RATE_SHORT_PREAMBLE	= 1<<0,
+	IEEE80211_RATE_MANDATORY_A	= 1<<1,
+	IEEE80211_RATE_MANDATORY_B	= 1<<2,
+	IEEE80211_RATE_MANDATORY_G	= 1<<3,
+	IEEE80211_RATE_ERP_G		= 1<<4,
+};
+
+/**
+ * struct ieee80211_bitrate - bitrate definition
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
+struct ieee80211_bitrate {
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
+	struct ieee80211_bitrate *bitrates;
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
+extern int ieee80211_frequency_to_channel(int freqMhz);
+
 #endif /* __NET_WIRELESS_H */
--- everything.orig/net/mac80211/ieee80211_i.h	2007-12-23 22:02:18.329081651 +0100
+++ everything/net/mac80211/ieee80211_i.h	2007-12-23 22:05:39.489081868 +0100
@@ -79,9 +79,8 @@ struct ieee80211_sta_bss {
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
 	u16 capability; /* host byte order */
-	int hw_mode;
-	int channel;
-	int freq;
+	enum ieee80211_band band;
+	int freqMhz;
 	int rssi, signal, noise;
 	u8 *wpa_ie;
 	size_t wpa_ie_len;
@@ -136,13 +135,11 @@ struct ieee80211_txrx_data {
 	union {
 		struct {
 			struct ieee80211_tx_control *control;
-			struct ieee80211_hw_mode *mode;
-			struct ieee80211_rate *rate;
+			struct ieee80211_bitrate *rate;
 			/* use this rate (if set) for last fragment; rate can
 			 * be set to lower rate for the first fragments, e.g.,
 			 * when using CTS protection with IEEE 802.11g. */
-			struct ieee80211_rate *last_frag_rate;
-			int last_frag_hwrate;
+			struct ieee80211_bitrate *last_frag_rate;
 
 			/* Extra fragments (in addition to the first fragment
 			 * in skb) */
@@ -178,9 +175,7 @@ struct ieee80211_tx_stored_packet {
 	struct sk_buff *skb;
 	int num_extra_frag;
 	struct sk_buff **extra_frag;
-	int last_frag_rateidx;
-	int last_frag_hwrate;
-	struct ieee80211_rate *last_frag_rate;
+	struct ieee80211_bitrate *last_frag_rate;
 	unsigned int last_frag_rate_ctrl_probe;
 };
 
@@ -282,7 +277,7 @@ struct ieee80211_if_sta {
 
 	unsigned long ibss_join_req;
 	struct sk_buff *probe_resp; /* ProbeResp template for IBSS */
-	u32 supp_rates_bits;
+	u32 supp_rates_bits[IEEE80211_NUM_BANDS];
 
 	int wmm_last_param_set;
 };
@@ -292,6 +287,7 @@ struct ieee80211_if_sta {
 #define IEEE80211_SDATA_ALLMULTI	BIT(0)
 #define IEEE80211_SDATA_PROMISC		BIT(1)
 #define IEEE80211_SDATA_USERSPACE_MLME	BIT(2)
+#define IEEE80211_SDATA_OPERATING_GMODE	BIT(3)
 struct ieee80211_sub_if_data {
 	struct list_head list;
 
@@ -312,6 +308,11 @@ struct ieee80211_sub_if_data {
 	 */
 	int ieee802_1x_pac;
 
+	/*
+	 * basic rates of this AP or the AP we're associated to
+	 */
+	u64 basic_rates;
+
 	u16 sequence;
 
 	/* Fragment table for host-based reassembly */
@@ -417,9 +418,6 @@ struct ieee80211_local {
 
 	const struct ieee80211_ops *ops;
 
-	/* List of registered struct ieee80211_hw_mode */
-	struct list_head modes_list;
-
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
 	int open_count;
 	int monitors;
@@ -459,11 +457,6 @@ struct ieee80211_local {
 
 	struct rate_control_ref *rate_ctrl;
 
-	/* Supported and basic rate filters for different modes. These are
-	 * pointers to -1 terminated lists and rates in 100 kbps units. */
-	int *supp_rates[NUM_IEEE80211_MODES];
-	int *basic_rates[NUM_IEEE80211_MODES];
-
 	int rts_threshold;
 	int fragmentation_threshold;
 	int short_retry_limit; /* dot11ShortRetryLimit */
@@ -486,12 +479,13 @@ struct ieee80211_local {
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
@@ -559,14 +553,8 @@ struct ieee80211_local {
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
@@ -576,9 +564,7 @@ struct ieee80211_local {
 		struct dentry *short_retry_limit;
 		struct dentry *long_retry_limit;
 		struct dentry *total_ps_buffered;
-		struct dentry *mode;
 		struct dentry *wep_iv;
-		struct dentry *modes;
 		struct dentry *statistics;
 		struct local_debugfsdentries_statsdentries {
 			struct dentry *transmitted_fragment_count;
@@ -683,23 +669,6 @@ static inline void bss_tim_clear(struct 
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
@@ -711,13 +680,9 @@ static inline int ieee80211_bssid_match(
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
@@ -748,7 +713,7 @@ extern const struct iw_handler_def ieee8
 /* ieee80211_ioctl.c */
 int ieee80211_set_compression(struct ieee80211_local *local,
 			      struct net_device *dev, struct sta_info *sta);
-int ieee80211_set_channel(struct ieee80211_local *local, int channel, int freq);
+int ieee80211_set_freq(struct ieee80211_local *local, int freq);
 /* ieee80211_sta.c */
 void ieee80211_sta_timer(unsigned long data);
 void ieee80211_sta_work(struct work_struct *work);
@@ -792,10 +757,6 @@ int ieee80211_if_remove(struct net_devic
 void ieee80211_if_free(struct net_device *dev);
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata);
 
-/* regdomain.c */
-void ieee80211_regdomain_init(void);
-void ieee80211_set_default_regdomain(struct ieee80211_hw_mode *mode);
-
 /* rx handling */
 extern ieee80211_rx_handler ieee80211_rx_pre_handlers[];
 extern ieee80211_rx_handler ieee80211_rx_handlers[];
--- everything.orig/net/mac80211/util.c	2007-12-23 22:02:18.409082411 +0100
+++ everything/net/mac80211/util.c	2007-12-23 22:05:39.499081760 +0100
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
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
 {
 	u16 fc;
@@ -249,7 +163,7 @@ int ieee80211_frame_duration(struct ieee
 	 * DIV_ROUND_UP() operations.
 	 */
 
-	if (local->hw.conf.phymode == MODE_IEEE80211A || erp) {
+	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ || erp) {
 		/*
 		 * OFDM:
 		 *
@@ -291,15 +205,19 @@ int ieee80211_frame_duration(struct ieee
 /* Exported duration function for driver use */
 __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
-					size_t frame_len, int rate)
+					size_t frame_len,
+					struct ieee80211_bitrate *rate)
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
@@ -311,7 +229,7 @@ __le16 ieee80211_rts_duration(struct iee
 			      const struct ieee80211_tx_control *frame_txctl)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_rate *rate;
+	struct ieee80211_bitrate *rate;
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	bool short_preamble;
 	int erp;
@@ -319,17 +237,20 @@ __le16 ieee80211_rts_duration(struct iee
 
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
@@ -342,7 +263,7 @@ __le16 ieee80211_ctstoself_duration(stru
 				    const struct ieee80211_tx_control *frame_txctl)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_rate *rate;
+	struct ieee80211_bitrate *rate;
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	bool short_preamble;
 	int erp;
@@ -350,15 +271,17 @@ __le16 ieee80211_ctstoself_duration(stru
 
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
 
@@ -366,27 +289,6 @@ __le16 ieee80211_ctstoself_duration(stru
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
--- everything.orig/net/mac80211/ieee80211.c	2007-12-23 22:02:18.449082194 +0100
+++ everything/net/mac80211/ieee80211.c	2007-12-23 22:21:06.885863824 +0100
@@ -536,37 +536,28 @@ int ieee80211_if_config_beacon(struct ne
 
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
+	if (!local->hw.conf.power_dBm)
+		local->hw.conf.power_dBm = chan->max_power_dBm;
+	else
+		local->hw.conf.power_dBm = min(chan->max_power_dBm,
+					       local->hw.conf.power_dBm);
+
+	local->hw.conf.max_antenna_gain_dBi = chan->max_antenna_gain_dBi;
 
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
@@ -584,11 +575,13 @@ int ieee80211_hw_config_ht(struct ieee80
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
@@ -598,17 +591,17 @@ int ieee80211_hw_config_ht(struct ieee80
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
@@ -1066,10 +1059,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->long_retry_limit = 4;
 	local->hw.conf.radio_enabled = 1;
 
-	local->enabled_modes = ~0;
-
-	INIT_LIST_HEAD(&local->modes_list);
-
 	INIT_LIST_HEAD(&local->interfaces);
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
@@ -1114,6 +1103,25 @@ int ieee80211_register_hw(struct ieee802
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
@@ -1215,44 +1223,10 @@ fail_workqueue:
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
@@ -1293,11 +1267,6 @@ void ieee80211_unregister_hw(struct ieee
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
@@ -1344,7 +1313,6 @@ static int __init ieee80211_init(void)
 	}
 
 	ieee80211_debugfs_netdev_init();
-	ieee80211_regdomain_init();
 
 	return 0;
 
--- everything.orig/net/mac80211/ieee80211_ioctl.c	2007-12-23 22:02:18.509098090 +0100
+++ everything/net/mac80211/ieee80211_ioctl.c	2007-12-23 22:05:39.509081760 +0100
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
+	strcpy(name, "mac80211");
 
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
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band ++) {
+		sband = local->hw.wiphy->bands[band];
 
-	list_for_each_entry(mode, &local->modes_list, list) {
-		if (!(local->enabled_modes & (1 << mode->mode)))
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
-	for (i=0; i< mode->num_rates; i++) {
-		struct ieee80211_rate *rates = &mode->rates[i];
-		int this_rate = rates->rate;
+
+	for (i=0; i< sband->n_bitrates; i++) {
+		struct ieee80211_bitrate *brate = &sband->bitrates[i];
+		int this_rate = brate->bitrate;
 
 		if (target_rate == this_rate) {
 			sdata->bss->max_ratectrl_rateidx = i;
 			if (rate->fixed)
 				sdata->bss->force_unicast_rateidx = i;
+			err = 0;
 			break;
 		}
 	}
-	return 0;
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
@@ -635,17 +638,19 @@ static int ieee80211_ioctl_siwtxpower(st
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
+		new_power_level = chan->max_power_dBm;
 	}
 
-	if (local->hw.conf.power_level != new_power_level) {
-		local->hw.conf.power_level = new_power_level;
+	if (local->hw.conf.power_dBm != new_power_level) {
+		local->hw.conf.power_dBm = new_power_level;
 		need_reconfig = 1;
 	}
 
@@ -672,7 +677,7 @@ static int ieee80211_ioctl_giwtxpower(st
 
 	data->txpower.fixed = 1;
 	data->txpower.disabled = !(local->hw.conf.radio_enabled);
-	data->txpower.value = local->hw.conf.power_level;
+	data->txpower.value = local->hw.conf.power_dBm;
 	data->txpower.flags = IW_TXPOW_DBM;
 
 	return 0;
--- everything.orig/net/mac80211/ieee80211_rate.h	2007-12-23 22:02:18.529082085 +0100
+++ everything/net/mac80211/ieee80211_rate.h	2007-12-23 22:05:39.509081760 +0100
@@ -18,13 +18,14 @@
 #include "ieee80211_i.h"
 #include "sta_info.h"
 
+/* TODO: kdoc */
 struct rate_selection {
 	/* Selected transmission rate */
-	struct ieee80211_rate *rate;
+	struct ieee80211_bitrate *rate;
 	/* Non-ERP rate to use if mac80211 decides it cannot use an ERP rate */
-	struct ieee80211_rate *nonerp;
+	struct ieee80211_bitrate *nonerp;
 	/* probe with this rate, or NULL for no probing */
-	struct ieee80211_rate *probe;
+	struct ieee80211_bitrate *probe;
 };
 
 struct rate_control_ops {
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
@@ -151,11 +154,12 @@ rate_lowest_index(struct ieee80211_local
 	return 0;
 }
 
-static inline struct ieee80211_rate *
-rate_lowest(struct ieee80211_local *local, struct ieee80211_hw_mode *mode,
+static inline struct ieee80211_bitrate *
+rate_lowest(struct ieee80211_local *local,
+	    struct ieee80211_supported_band *sband,
 	    struct sta_info *sta)
 {
-	return &mode->rates[rate_lowest_index(local, mode, sta)];
+	return &sband->bitrates[rate_lowest_index(local, sband, sta)];
 }
 
 
--- everything.orig/net/mac80211/ieee80211_sta.c	2007-12-23 22:02:18.579083279 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2007-12-23 22:05:39.529082140 +0100
@@ -67,7 +67,7 @@
 static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
 				     u8 *ssid, size_t ssid_len);
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel,
+ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len);
 static void ieee80211_rx_bss_put(struct net_device *dev,
 				 struct ieee80211_sta_bss *bss);
@@ -459,7 +459,7 @@ static void ieee80211_set_associated(str
 			return;
 
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
-					   local->hw.conf.channel,
+					   local->hw.conf.channel->center_freq,
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
 			if (bss->has_erp_value)
@@ -585,7 +585,6 @@ static void ieee80211_send_assoc(struct 
 				 struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hw_mode *mode;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, *ies;
@@ -593,6 +592,7 @@ static void ieee80211_send_assoc(struct 
 	u16 capab;
 	struct ieee80211_sta_bss *bss;
 	int wmm = 0;
+	struct ieee80211_supported_band *sband;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
 			    sizeof(*mgmt) + 200 + ifsta->extra_ie_len +
@@ -604,13 +604,19 @@ static void ieee80211_send_assoc(struct 
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
@@ -649,23 +655,23 @@ static void ieee80211_send_assoc(struct 
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
@@ -688,17 +694,18 @@ static void ieee80211_send_assoc(struct 
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
@@ -781,7 +788,8 @@ static int ieee80211_privacy_mismatch(st
 	if (!ifsta || (ifsta->flags & IEEE80211_STA_MIXED_CELL))
 		return 0;
 
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel,
+	bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+				   local->hw.conf.channel->center_freq,
 				   ifsta->ssid, ifsta->ssid_len);
 	if (!bss)
 		return 0;
@@ -891,7 +899,7 @@ static void ieee80211_send_probe_req(str
 				     u8 *ssid, size_t ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, *supp_rates, *esupp_rates = NULL;
@@ -925,11 +933,10 @@ static void ieee80211_send_probe_req(str
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
+		struct ieee80211_bitrate *rate = &sband->bitrates[i];
 		if (esupp_rates) {
 			pos = skb_put(skb, 1);
 			esupp_rates[1]++;
@@ -942,7 +949,7 @@ static void ieee80211_send_probe_req(str
 			pos = skb_put(skb, 1);
 			supp_rates[1]++;
 		}
-		*pos = rate->rate / 5;
+		*pos = rate->bitrate / 5;
 	}
 
 	ieee80211_sta_tx(dev, skb, 0);
@@ -1299,15 +1306,16 @@ static void ieee80211_rx_mgmt_assoc_resp
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
@@ -1377,10 +1385,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 	if (ifsta->assocresp_ies)
 		memcpy(ifsta->assocresp_ies, pos, ifsta->assocresp_ies_len);
 
-	/* set AID, ieee80211_set_associated() will tell the driver */
-	bss_conf->aid = aid;
-	ieee80211_set_associated(dev, ifsta, 1);
-
 	/* Add STA entry for the AP */
 	sta = sta_info_get(local, ifsta->bssid);
 	if (!sta) {
@@ -1392,7 +1396,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 			return;
 		}
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
-					   local->hw.conf.channel,
+					   local->hw.conf.channel->center_freq,
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
 			sta->last_rssi = bss->rssi;
@@ -1406,20 +1410,46 @@ static void ieee80211_rx_mgmt_assoc_resp
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
@@ -1442,6 +1472,9 @@ static void ieee80211_rx_mgmt_assoc_resp
 					 elems.wmm_param_len);
 	}
 
+	/* set AID, ieee80211_set_associated() will tell the driver */
+	bss_conf->aid = aid;
+	ieee80211_set_associated(dev, ifsta, 1);
 
 	sta_info_put(sta);
 
@@ -1482,7 +1515,7 @@ static void __ieee80211_rx_bss_hash_del(
 
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid, int channel,
+ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -1494,7 +1527,7 @@ ieee80211_rx_bss_add(struct net_device *
 	atomic_inc(&bss->users);
 	atomic_inc(&bss->users);
 	memcpy(bss->bssid, bssid, ETH_ALEN);
-	bss->channel = channel;
+	bss->freqMhz = freq;
 	if (ssid && ssid_len <= IEEE80211_MAX_SSID_LEN) {
 		memcpy(bss->ssid, ssid, ssid_len);
 		bss->ssid_len = ssid_len;
@@ -1510,7 +1543,7 @@ ieee80211_rx_bss_add(struct net_device *
 
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel,
+ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -1520,7 +1553,7 @@ ieee80211_rx_bss_get(struct net_device *
 	bss = local->sta_bss_hash[STA_HASH(bssid)];
 	while (bss) {
 		if (!memcmp(bss->bssid, bssid, ETH_ALEN) &&
-		    bss->channel == channel &&
+		    bss->freqMhz == freq &&
 		    bss->ssid_len == ssid_len &&
 		    (ssid_len == 0 || !memcmp(bss->ssid, ssid, ssid_len))) {
 			atomic_inc(&bss->users);
@@ -1585,7 +1618,7 @@ static void ieee80211_rx_bss_info(struct
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee802_11_elems elems;
 	size_t baselen;
-	int channel, clen;
+	int freq, clen;
 	struct ieee80211_sta_bss *bss;
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1636,26 +1669,22 @@ static void ieee80211_rx_bss_info(struct
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0 &&
 	    (sta = sta_info_get(local, mgmt->sa))) {
-		struct ieee80211_hw_mode *mode;
-		struct ieee80211_rate *rates;
+		struct ieee80211_supported_band *sband;
+		struct ieee80211_bitrate *bitrates;
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
@@ -1669,24 +1698,27 @@ static void ieee80211_rx_bss_info(struct
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
@@ -1695,14 +1727,14 @@ static void ieee80211_rx_bss_info(struct
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
@@ -1715,6 +1747,8 @@ static void ieee80211_rx_bss_info(struct
 #endif
 	}
 
+	bss->band = rx_status->band;
+
 	if (bss->probe_resp && beacon) {
 		/* Do not allow beacon to override data from Probe Response. */
 		ieee80211_rx_bss_put(dev, bss);
@@ -1813,20 +1847,6 @@ static void ieee80211_rx_bss_info(struct
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
@@ -2386,7 +2406,7 @@ static int ieee80211_sta_config_auth(str
 	}
 
 	spin_lock_bh(&local->sta_bss_lock);
-	freq = local->oper_channel->freq;
+	freq = local->oper_channel->center_freq;
 	list_for_each_entry(bss, &local->sta_bss_list, list) {
 		if (!(bss->capability & WLAN_CAPABILITY_ESS))
 			continue;
@@ -2396,7 +2416,7 @@ static int ieee80211_sta_config_auth(str
 			continue;
 
 		if (!(ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL) &&
-		    bss->freq != freq)
+		    bss->freqMhz != freq)
 			continue;
 
 		if (!(ifsta->flags & IEEE80211_STA_AUTO_BSSID_SEL) &&
@@ -2417,7 +2437,7 @@ static int ieee80211_sta_config_auth(str
 	spin_unlock_bh(&local->sta_bss_lock);
 
 	if (selected) {
-		ieee80211_set_channel(local, -1, selected->freq);
+		ieee80211_set_freq(local, selected->freqMhz);
 		if (!(ifsta->flags & IEEE80211_STA_SSID_SET))
 			ieee80211_sta_set_ssid(dev, selected->ssid,
 					       selected->ssid_len);
@@ -2450,10 +2470,12 @@ static int ieee80211_sta_join_ibss(struc
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
@@ -2473,12 +2495,11 @@ static int ieee80211_sta_join_ibss(struc
 	sdata->drop_unencrypted = bss->capability &
 		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	res = ieee80211_set_channel(local, -1, bss->freq);
+	res = ieee80211_set_freq(local, bss->freqMhz);
 
-	if (!(local->oper_channel->flag & IEEE80211_CHAN_W_IBSS)) {
-		printk(KERN_DEBUG "%s: IBSS not allowed on channel %d "
-		       "(%d MHz)\n", dev->name, local->hw.conf.channel,
-		       local->hw.conf.freq);
+	if (local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS) {
+		printk(KERN_DEBUG "%s: IBSS not allowed on frequency "
+		       "%d MHz\n", dev->name, local->oper_channel->center_freq);
 		return -1;
 	}
 
@@ -2515,10 +2536,12 @@ static int ieee80211_sta_join_ibss(struc
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
+			*pos++ = ieee80211_frequency_to_channel(bss->freqMhz);
+		}
 
 		pos = skb_put(skb, 2 + 2);
 		*pos++ = WLAN_EID_IBSS_PARAMS;
@@ -2536,18 +2559,17 @@ static int ieee80211_sta_join_ibss(struc
 		}
 
 		memset(&control, 0, sizeof(control));
-		rate_control_get_rate(dev, local->oper_hw_mode, skb, &ratesel);
+		rate_control_get_rate(dev, sband, skb, &ratesel);
 		if (!ratesel.rate) {
 			printk(KERN_DEBUG "%s: Failed to determine TX rate "
 			       "for IBSS beacon\n", dev->name);
 			break;
 		}
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
 
@@ -2572,14 +2594,14 @@ static int ieee80211_sta_join_ibss(struc
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
@@ -2603,7 +2625,7 @@ static int ieee80211_sta_create_ibss(str
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	u8 bssid[ETH_ALEN], *pos;
 	int i;
 	DECLARE_MAC_BUF(mac);
@@ -2625,28 +2647,28 @@ static int ieee80211_sta_create_ibss(str
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
 
@@ -2695,7 +2717,8 @@ static int ieee80211_sta_find_ibss(struc
 	       "%s\n", print_mac(mac, bssid), print_mac(mac2, ifsta->bssid));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0 &&
-	    (bss = ieee80211_rx_bss_get(dev, bssid, local->hw.conf.channel,
+	    (bss = ieee80211_rx_bss_get(dev, bssid,
+	    				local->hw.conf.channel->center_freq,
 					ifsta->ssid, ifsta->ssid_len))) {
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID %s"
 		       " based on configured SSID\n",
@@ -2723,13 +2746,13 @@ static int ieee80211_sta_find_ibss(struc
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
@@ -2748,7 +2771,7 @@ static int ieee80211_sta_find_ibss(struc
 
 int ieee80211_sta_set_ssid(struct net_device *dev, char *ssid, size_t len)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
@@ -2762,18 +2785,23 @@ int ieee80211_sta_set_ssid(struct net_de
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
@@ -2782,7 +2810,6 @@ int ieee80211_sta_set_ssid(struct net_de
 				   IEEE80211_TX_QUEUE_BEACON, &qparam);
 	}
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	ifsta = &sdata->u.sta;
 
 	if (ifsta->ssid_len != len || memcmp(ifsta->ssid, ssid, len) != 0)
@@ -2941,7 +2968,7 @@ void ieee80211_sta_scan_work(struct work
 		container_of(work, struct ieee80211_local, scan_work.work);
 	struct net_device *dev = local->scan_dev;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 	int skip;
 	unsigned long next_delay = 0;
@@ -2951,44 +2978,47 @@ void ieee80211_sta_scan_work(struct work
 
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
@@ -2999,13 +3029,14 @@ void ieee80211_sta_scan_work(struct work
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
 
@@ -3080,10 +3111,8 @@ static int ieee80211_sta_start_scan(stru
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
@@ -3138,9 +3167,6 @@ ieee80211_sta_scan_result(struct net_dev
 		       bss->last_update + IEEE80211_SCAN_RESULT_EXPIRE))
 		return current_ev;
 
-	if (!(local->enabled_modes & (1 << bss->hw_mode)))
-		return current_ev;
-
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWAP;
 	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
@@ -3168,12 +3194,15 @@ ieee80211_sta_scan_result(struct net_dev
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWFREQ;
-	iwe.u.freq.m = bss->channel;
-	iwe.u.freq.e = 0;
+	iwe.u.freq.m = bss->freqMhz;
+	iwe.u.freq.e = 6;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
-	iwe.u.freq.m = bss->freq * 100000;
-	iwe.u.freq.e = 1;
+
+	memset(&iwe, 0, sizeof(iwe));
+	iwe.cmd = SIOCGIWFREQ;
+	iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freqMhz);
+	iwe.u.freq.e = 0;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
 					  IW_EV_FREQ_LEN);
 
@@ -3316,7 +3345,8 @@ struct sta_info * ieee80211_ibss_add_sta
 	if (!sta)
 		return NULL;
 
-	sta->supp_rates = sdata->u.sta.supp_rates_bits;
+	sta->supp_rates[local->hw.conf.channel->band] =
+		sdata->u.sta.supp_rates_bits[local->hw.conf.channel->band];
 
 	rate_control_rate_init(sta, local);
 
--- everything.orig/net/mac80211/sta_info.c	2007-12-23 22:02:18.619081217 +0100
+++ everything/net/mac80211/sta_info.c	2007-12-23 22:05:39.529082140 +0100
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
--- everything.orig/net/mac80211/Makefile	2007-12-23 22:02:18.689082736 +0100
+++ everything/net/mac80211/Makefile	2007-12-23 22:05:39.549079861 +0100
@@ -50,7 +50,6 @@ mac80211-objs := \
 	ieee80211_iface.o \
 	ieee80211_rate.o \
 	michael.o \
-	regdomain.o \
 	tkip.o \
 	aes_ccm.o \
 	cfg.o \
--- everything.orig/net/mac80211/regdomain.c	2007-12-23 22:02:18.729082194 +0100
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
--- everything.orig/net/mac80211/rx.c	2007-12-23 22:02:18.779083116 +0100
+++ everything/net/mac80211/rx.c	2007-12-23 22:05:39.569082791 +0100
@@ -79,7 +79,6 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		     struct ieee80211_rx_status *status)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_rate *rate;
 	int needed_headroom = 0;
 	struct ieee80211_radiotap_header *rthdr;
 	__le64 *rttsft = NULL;
@@ -188,14 +187,11 @@ ieee80211_rx_monitor(struct ieee80211_lo
 			rtfixed->rx_flags |=
 				cpu_to_le16(IEEE80211_RADIOTAP_F_RX_BADFCS);
 
-		rate = ieee80211_get_rate(local, status->phymode,
-					  status->rate);
-		if (rate)
-			rtfixed->rate = rate->rate / 5;
+		rtfixed->rate = status->rate / 5;
 
 		rtfixed->chan_freq = cpu_to_le16(status->freq);
 
-		if (status->phymode == MODE_IEEE80211A)
+		if (status->band == IEEE80211_BAND_5GHZ)
 			rtfixed->chan_flags =
 				cpu_to_le16(IEEE80211_CHAN_OFDM |
 					    IEEE80211_CHAN_5GHZ);
@@ -291,6 +287,7 @@ ieee80211_rx_h_parse_qos(struct ieee8021
 static ieee80211_txrx_result
 ieee80211_rx_h_load_stats(struct ieee80211_txrx_data *rx)
 {
+#if TODO
 	struct ieee80211_local *local = rx->local;
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -332,6 +329,7 @@ ieee80211_rx_h_load_stats(struct ieee802
 	load >>= CHAN_UTIL_SHIFT;
 	local->channel_use_raw += load;
 	rx->u.rx.load = load;
+#endif
 
 	return TXRX_CONTINUE;
 }
--- everything.orig/net/mac80211/tx.c	2007-12-23 22:02:18.809087511 +0100
+++ everything/net/mac80211/tx.c	2007-12-23 22:05:39.579081923 +0100
@@ -90,11 +90,15 @@ static u16 ieee80211_duration(struct iee
 			      int next_frag_len)
 {
 	int rate, mrate, erp, dur, i;
-	struct ieee80211_rate *txrate = tx->u.tx.rate;
+	struct ieee80211_bitrate *txrate = tx->u.tx.rate;
 	struct ieee80211_local *local = tx->local;
-	struct ieee80211_hw_mode *mode = tx->u.tx.mode;
+	struct ieee80211_supported_band *sband;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-	erp = txrate->flags & IEEE80211_RATE_ERP;
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
+		struct ieee80211_bitrate *r = &sband->bitrates[i];
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
+		struct ieee80211_bitrate *rate, *baserate;
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
+
+		for (idx = 0; idx < sband->n_bitrates; idx++) {
+			if (sband->bitrates[idx].bitrate > rate->bitrate)
+				continue;
+			if (tx->sdata->basic_rates & BIT(idx) &&
+			    (!baserate ||
+			     (baserate->bitrate < sband->bitrates[idx].bitrate)))
+				baserate = &sband->bitrates[idx];
+		}
 
-		control->rts_cts_rate = rate->val;
-		control->rts_rate = rate;
+		if (baserate)
+			control->rts_cts_rate = baserate;
+		else
+			control->rts_cts_rate = &sband->bitrates[0];
 	}
 
 	if (tx->sta) {
@@ -725,6 +760,7 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 static ieee80211_txrx_result
 ieee80211_tx_h_load_stats(struct ieee80211_txrx_data *tx)
 {
+#if TODO
 	struct ieee80211_local *local = tx->local;
 	struct ieee80211_hw_mode *mode = tx->u.tx.mode;
 	struct sk_buff *skb = tx->skb;
@@ -773,6 +809,7 @@ ieee80211_tx_h_load_stats(struct ieee802
 	if (tx->sta)
 		tx->sta->channel_use_raw += load;
 	tx->sdata->channel_use_raw += load;
+#endif
 
 	return TXRX_CONTINUE;
 }
@@ -816,10 +853,12 @@ __ieee80211_parse_tx_radiotap(struct iee
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
@@ -852,10 +891,12 @@ __ieee80211_parse_tx_radiotap(struct iee
 			 * ieee80211 rate int is in 100kbps units eg, 0x0a=1Mbps
 			 */
 			target_rate = (*iterator.this_arg) * 5;
-			for (i = 0; i < mode->num_rates; i++) {
-				struct ieee80211_rate *r = &mode->rates[i];
+			for (i = 0; i < sband->n_bitrates; i++) {
+				struct ieee80211_bitrate *r;
+
+				r = &sband->bitrates[i];
 
-				if (r->rate == target_rate) {
+				if (r->bitrate == target_rate) {
 					tx->u.tx.rate = r;
 					break;
 				}
@@ -870,9 +911,11 @@ __ieee80211_parse_tx_radiotap(struct iee
 			control->antenna_sel_tx = (*iterator.this_arg) + 1;
 			break;
 
+#if 0
 		case IEEE80211_RADIOTAP_DBM_TX_POWER:
 			control->power_level = *iterator.this_arg;
 			break;
+#endif
 
 		case IEEE80211_RADIOTAP_FLAGS:
 			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FCS) {
@@ -1054,8 +1097,8 @@ static int __ieee80211_tx(struct ieee802
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
@@ -1114,7 +1157,6 @@ static int ieee80211_tx(struct net_devic
 	rcu_read_lock();
 
 	sta = tx.sta;
-	tx.u.tx.mode = local->hw.conf.mode;
 
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
@@ -1752,12 +1793,11 @@ struct sk_buff *ieee80211_beacon_get(str
 			goto out;
 		}
 
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
@@ -1862,7 +1902,6 @@ ieee80211_get_buffered_bc(struct ieee802
 	}
 	sta = tx.sta;
 	tx.flags |= IEEE80211_TXRXD_TXPS_BUFFERED;
-	tx.u.tx.mode = local->hw.conf.mode;
 
 	for (handler = local->tx_handlers; *handler != NULL; handler++) {
 		res = (*handler)(&tx);
--- everything.orig/net/mac80211/debugfs.c	2007-12-23 22:02:18.889081163 +0100
+++ everything/net/mac80211/debugfs.c	2007-12-23 22:05:39.579081923 +0100
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
--- everything.orig/net/mac80211/debugfs_sta.c	2007-12-23 22:02:18.939082248 +0100
+++ everything/net/mac80211/debugfs_sta.c	2007-12-23 22:05:39.579081923 +0100
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
--- everything.orig/net/mac80211/rc80211_simple.c	2007-12-23 22:02:18.969081434 +0100
+++ everything/net/mac80211/rc80211_simple.c	2007-12-23 22:05:39.599081434 +0100
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
@@ -213,18 +211,18 @@ rate_control_simple_get_rate(void *priv,
 	sta = sta_info_get(local, hdr->addr1);
 
 	if (!sta) {
-		sel->rate = rate_lowest(local, mode, NULL);
+		sel->rate = rate_lowest(local, sband, NULL);
 		return;
 	}
 
-	rateidx = sta->txrate;
+	rateidx = sta->txrate_idx;
 
-	if (rateidx >= mode->num_rates)
-		rateidx = mode->num_rates - 1;
+	if (rateidx >= sband->n_bitrates)
+		rateidx = sband->n_bitrates - 1;
 
 	sta_info_put(sta);
 
-	sel->rate = &mode->rates[rateidx];
+	sel->rate = &sband->bitrates[rateidx];
 }
 
 
@@ -232,21 +230,15 @@ static void rate_control_simple_rate_ini
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
 
 
--- everything.orig/net/wireless/core.c	2007-12-23 22:02:19.289081434 +0100
+++ everything/net/wireless/core.c	2007-12-23 22:05:39.609084364 +0100
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
+				sband->channels[i].max_antenna_gain_dBi;
+			sband->channels[i].orig_mpwr =
+				sband->channels[i].max_power_dBm;
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
 
--- everything.orig/drivers/net/wireless/b43/b43.h	2007-12-23 22:02:19.619082411 +0100
+++ everything/drivers/net/wireless/b43/b43.h	2007-12-23 22:05:39.659081434 +0100
@@ -448,10 +448,6 @@ struct b43_phy {
 	u8 possible_phymodes;
 	/* GMODE bit enabled? */
 	bool gmode;
-	/* Possible ieee80211 subsystem hwmodes for this PHY.
-	 * Which mode is selected, depends on thr GMODE enabled bit */
-#define B43_MAX_PHYHWMODES	2
-	struct ieee80211_hw_mode hwmodes[B43_MAX_PHYHWMODES];
 
 	/* Analog Type */
 	u8 analog;
@@ -704,7 +700,6 @@ struct b43_wldev {
 	bool __using_pio;	/* Internal, use b43_using_pio(). */
 	bool bad_frames_preempt;	/* Use "Bad Frames Preemption" (default off) */
 	bool reg124_set_0x4;	/* Some variable to keep track of IRQ stuff. */
-	bool short_preamble;	/* TRUE, if short preamble is enabled. */
 	bool short_slot;	/* TRUE, if short slot timing is enabled. */
 	bool radio_hw_enable;	/* saved state of radio hardware enabled state */
 
--- everything.orig/drivers/net/wireless/b43/main.c	2007-12-23 22:02:19.669093316 +0100
+++ everything/drivers/net/wireless/b43/main.c	2007-12-23 22:06:15.249079156 +0100
@@ -104,25 +104,24 @@ MODULE_DEVICE_TABLE(ssb, b43_ssb_tbl);
  * data in there. This data is the same for all devices, so we don't
  * get concurrency issues */
 #define RATETAB_ENT(_rateid, _flags) \
-	{							\
-		.rate	= B43_RATE_TO_BASE100KBPS(_rateid),	\
-		.val	= (_rateid),				\
-		.val2	= (_rateid),				\
-		.flags	= (_flags),				\
-	}
-static struct ieee80211_rate __b43_ratetable[] = {
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
+	{								\
+		.bitrate	= B43_RATE_TO_BASE100KBPS(_rateid),	\
+		.hw_value	= (_rateid),				\
+		.flags		= (_flags),				\
+	}
+static struct ieee80211_bitrate __b43_ratetable[] = {
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
@@ -134,14 +133,8 @@ static struct ieee80211_rate __b43_ratet
 
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
 static struct ieee80211_channel b43_bg_chantable[] = {
 	CHANTAB_ENT(1, 2412),
@@ -160,7 +153,6 @@ static struct ieee80211_channel b43_bg_c
 	CHANTAB_ENT(14, 2484),
 };
 
-#define b43_bg_chantable_size	ARRAY_SIZE(b43_bg_chantable)
 static struct ieee80211_channel b43_a_chantable[] = {
 	CHANTAB_ENT(36, 5180),
 	CHANTAB_ENT(40, 5200),
@@ -177,7 +169,26 @@ static struct ieee80211_channel b43_a_ch
 	CHANTAB_ENT(165, 5825),
 };
 
-#define b43_a_chantable_size	ARRAY_SIZE(b43_a_chantable)
+static struct ieee80211_supported_band b43_band_5GHz = {
+	.channels = b43_a_chantable,
+	.n_channels = ARRAY_SIZE(b43_a_chantable),
+	.bitrates = b43_a_ratetable,
+	.n_bitrates = b43_a_ratetable_size,
+};
+
+static struct ieee80211_supported_band b43_band_2GHz_BPHY = {
+	.channels = b43_bg_chantable,
+	.n_channels = ARRAY_SIZE(b43_bg_chantable),
+	.bitrates = b43_b_ratetable,
+	.n_bitrates = b43_b_ratetable_size,
+};
+
+static struct ieee80211_supported_band b43_band_2GHz_GPHY = {
+	.channels = b43_bg_chantable,
+	.n_channels = ARRAY_SIZE(b43_bg_chantable),
+	.bitrates = b43_g_ratetable,
+	.n_bitrates = b43_g_ratetable_size,
+};
 
 static void b43_wireless_core_exit(struct b43_wldev *dev);
 static int b43_wireless_core_init(struct b43_wldev *dev);
@@ -1225,17 +1236,18 @@ static void b43_write_beacon_template(st
 }
 
 static void b43_write_probe_resp_plcp(struct b43_wldev *dev,
-				      u16 shm_offset, u16 size, u8 rate)
+				      u16 shm_offset, u16 size,
+				      struct ieee80211_bitrate *rate)
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
@@ -1250,7 +1262,8 @@ static void b43_write_probe_resp_plcp(st
  * 3) Stripping TIM
  */
 static const u8 * b43_generate_probe_resp(struct b43_wldev *dev,
-					  u16 *dest_size, u8 rate)
+					  u16 *dest_size,
+					  struct ieee80211_bitrate *rate)
 {
 	const u8 *src_data;
 	u8 *dest_data;
@@ -1295,7 +1308,7 @@ static const u8 * b43_generate_probe_res
 					 IEEE80211_STYPE_PROBE_RESP);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
 					       dev->wl->vif, *dest_size,
-					       B43_RATE_TO_BASE100KBPS(rate));
+					       rate);
 	hdr->duration_id = dur;
 
 	return dest_data;
@@ -1303,7 +1316,8 @@ static const u8 * b43_generate_probe_res
 
 static void b43_write_probe_resp_template(struct b43_wldev *dev,
 					  u16 ram_offset,
-					  u16 shm_size_offset, u8 rate)
+					  u16 shm_size_offset,
+					  struct ieee80211_bitrate *rate)
 {
 	const u8 *probe_resp_data;
 	u16 size;
@@ -1316,14 +1330,15 @@ static void b43_write_probe_resp_templat
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
 
@@ -1336,7 +1351,7 @@ static void b43_update_templates(struct 
 
 	b43_write_beacon_template(dev, 0x68, 0x18, B43_CCK_RATE_1MB);
 	b43_write_beacon_template(dev, 0x468, 0x1A, B43_CCK_RATE_1MB);
-	b43_write_probe_resp_template(dev, 0x268, 0x4A, B43_CCK_RATE_11MB);
+	b43_write_probe_resp_template(dev, 0x268, 0x4A, &b43_b_ratetable[3]);
 
 	status = b43_read32(dev, B43_MMIO_STATUS2_BITFIELD);
 	status |= 0x03;
@@ -2760,14 +2775,12 @@ static int b43_op_config(struct ieee8021
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
+		/* FIXME: select B43_PHYMODE_B for B devices */
 		new_phymode = B43_PHYMODE_G;
 		break;
 	default:
@@ -2793,8 +2806,8 @@ static int b43_op_config(struct ieee8021
 
 	/* Switch to the requested channel.
 	 * The firmware takes care of races with the TX handler. */
-	if (conf->channel_val != phy->channel)
-		b43_radio_selectchannel(dev, conf->channel_val, 0);
+	if (conf->channel->hw_value != phy->channel)
+		b43_radio_selectchannel(dev, conf->channel->hw_value, 0);
 
 	/* Enable/Disable ShortSlot timing. */
 	if ((!!(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME)) !=
@@ -2809,9 +2822,9 @@ static int b43_op_config(struct ieee8021
 	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
 
 	/* Adjust the desired TX power level. */
-	if (conf->power_level != 0) {
-		if (conf->power_level != phy->power_level) {
-			phy->power_level = conf->power_level;
+	if (conf->power_dBm != 0) {
+		if (conf->power_dBm != phy->power_level) {
+			phy->power_level = conf->power_dBm;
 			b43_phy_xmitpower(dev);
 		}
 	}
@@ -3737,10 +3750,8 @@ static int b43_setup_modes(struct b43_wl
 			   int have_aphy, int have_bphy, int have_gphy)
 {
 	struct ieee80211_hw *hw = dev->wl->hw;
-	struct ieee80211_hw_mode *mode;
 	struct b43_phy *phy = &dev->phy;
 	int cnt = 0;
-	int err;
 
 /*FIXME: Don't tell ieee80211 about an A-PHY, because we currently don't support A-PHY. */
 	have_aphy = 0;
@@ -3748,52 +3759,22 @@ static int b43_setup_modes(struct b43_wl
 	phy->possible_phymodes = 0;
 	for (; 1; cnt++) {
 		if (have_aphy) {
-			B43_WARN_ON(cnt >= B43_MAX_PHYHWMODES);
-			mode = &phy->hwmodes[cnt];
-
-			mode->mode = MODE_IEEE80211A;
-			mode->num_channels = b43_a_chantable_size;
-			mode->channels = b43_a_chantable;
-			mode->num_rates = b43_a_ratetable_size;
-			mode->rates = b43_a_ratetable;
-			err = ieee80211_register_hwmode(hw, mode);
-			if (err)
-				return err;
-
+			hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+				&b43_band_5GHz;
 			phy->possible_phymodes |= B43_PHYMODE_A;
 			have_aphy = 0;
 			continue;
 		}
 		if (have_bphy) {
-			B43_WARN_ON(cnt >= B43_MAX_PHYHWMODES);
-			mode = &phy->hwmodes[cnt];
-
-			mode->mode = MODE_IEEE80211B;
-			mode->num_channels = b43_bg_chantable_size;
-			mode->channels = b43_bg_chantable;
-			mode->num_rates = b43_b_ratetable_size;
-			mode->rates = b43_b_ratetable;
-			err = ieee80211_register_hwmode(hw, mode);
-			if (err)
-				return err;
-
+			hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+				&b43_band_2GHz_BPHY;
 			phy->possible_phymodes |= B43_PHYMODE_B;
 			have_bphy = 0;
 			continue;
 		}
 		if (have_gphy) {
-			B43_WARN_ON(cnt >= B43_MAX_PHYHWMODES);
-			mode = &phy->hwmodes[cnt];
-
-			mode->mode = MODE_IEEE80211G;
-			mode->num_channels = b43_bg_chantable_size;
-			mode->channels = b43_bg_chantable;
-			mode->num_rates = b43_g_ratetable_size;
-			mode->rates = b43_g_ratetable;
-			err = ieee80211_register_hwmode(hw, mode);
-			if (err)
-				return err;
-
+			hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+				&b43_band_2GHz_GPHY;
 			phy->possible_phymodes |= B43_PHYMODE_G;
 			have_gphy = 0;
 			continue;
--- everything.orig/drivers/net/wireless/b43/xmit.c	2007-12-23 22:02:19.699083713 +0100
+++ everything/drivers/net/wireless/b43/xmit.c	2007-12-23 22:05:39.679140842 +0100
@@ -189,6 +189,7 @@ static void generate_txhdr_fw4(struct b4
 	    (const struct ieee80211_hdr *)fragment_data;
 	int use_encryption = (!(txctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT));
 	u16 fctl = le16_to_cpu(wlhdr->frame_control);
+	struct ieee80211_bitrate *fbrate;
 	u8 rate, rate_fb;
 	int rate_ofdm, rate_fb_ofdm;
 	unsigned int plcp_fragment_len;
@@ -198,9 +199,11 @@ static void generate_txhdr_fw4(struct b4
 
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
@@ -219,11 +222,10 @@ static void generate_txhdr_fw4(struct b4
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
@@ -268,7 +270,7 @@ static void generate_txhdr_fw4(struct b4
 	/* PHY TX Control word */
 	if (rate_ofdm)
 		phy_ctl |= B43_TX4_PHY_OFDM;
-	if (dev->short_preamble)
+	if (txctl->flags & IEEE80211_TXCTL_SHORT_PREAMBLE)
 		phy_ctl |= B43_TX4_PHY_SHORTPRMBL;
 	switch (txctl->antenna_sel_tx) {
 	case 0:
@@ -305,7 +307,8 @@ static void generate_txhdr_fw4(struct b4
 		int rts_rate, rts_rate_fb;
 		int rts_rate_ofdm, rts_rate_fb_ofdm;
 
-		rts_rate = txctl->rts_cts_rate;
+		WARN_ON(!txctl->rts_cts_rate);
+		rts_rate = txctl->rts_cts_rate ? txctl->rts_cts_rate->hw_value : B43_CCK_RATE_1MB;
 		rts_rate_ofdm = b43_is_ofdm_rate(rts_rate);
 		rts_rate_fb = b43_calc_fallback_rate(rts_rate);
 		rts_rate_fb_ofdm = b43_is_ofdm_rate(rts_rate_fb);
@@ -547,19 +550,13 @@ void b43_rx(struct b43_wldev *dev, struc
 	chanid = (chanstat & B43_RX_CHAN_ID) >> B43_RX_CHAN_ID_SHIFT;
 	switch (chanstat & B43_RX_CHAN_PHYTYPE) {
 	case B43_PHYTYPE_A:
-		status.phymode = MODE_IEEE80211A;
 		status.freq = chanid;
-		status.channel = b43_freq_to_channel_a(chanid);
+		status.band = IEEE80211_BAND_5GHZ;
 		break;
 	case B43_PHYTYPE_B:
-		status.phymode = MODE_IEEE80211B;
-		status.freq = chanid + 2400;
-		status.channel = b43_freq_to_channel_bg(chanid + 2400);
-		break;
 	case B43_PHYTYPE_G:
-		status.phymode = MODE_IEEE80211G;
 		status.freq = chanid + 2400;
-		status.channel = b43_freq_to_channel_bg(chanid + 2400);
+		status.band = IEEE80211_BAND_2GHZ;
 		break;
 	default:
 		B43_WARN_ON(1);
--- everything.orig/net/wireless/Makefile	2007-12-23 22:02:19.349082302 +0100
+++ everything/net/wireless/Makefile	2007-12-23 22:05:39.679140842 +0100
@@ -1,5 +1,5 @@
 obj-$(CONFIG_WIRELESS_EXT) += wext.o
 obj-$(CONFIG_CFG80211) += cfg80211.o
 
-cfg80211-y += core.o sysfs.o radiotap.o
+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
--- everything.orig/drivers/net/wireless/b43/sysfs.c	2007-12-23 22:02:19.909081760 +0100
+++ everything/drivers/net/wireless/b43/sysfs.c	2007-12-23 22:05:39.679140842 +0100
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
--- everything.orig/net/wireless/core.h	2007-12-23 22:02:19.399082140 +0100
+++ everything/net/wireless/core.h	2007-12-23 22:05:39.689082085 +0100
@@ -78,4 +78,7 @@ extern void cfg80211_dev_free(struct cfg
 extern int cfg80211_dev_rename(struct cfg80211_registered_device *drv,
 			       char *newname);
 
+void ieee80211_set_bitrate_flags(struct wiphy *wiphy);
+void wiphy_update_regulatory(struct wiphy *wiphy);
+
 #endif /* __NET_WIRELESS_CORE_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/net/wireless/util.c	2007-12-23 22:05:39.689082085 +0100
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
+int ieee80211_frequency_to_channel(int freqMhz)
+{
+	if (freqMhz == 2484)
+		return 14;
+
+	if (freqMhz < 2484)
+		return (freqMhz - 2407) / 5;
+
+	/* FIXME: 802.11j 17.3.8.3.2 */
+	return freqMhz/5 - 1000;
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
--- everything.orig/net/mac80211/cfg.c	2007-12-23 22:02:19.029093913 +0100
+++ everything/net/mac80211/cfg.c	2007-12-23 22:05:39.689082085 +0100
@@ -504,7 +504,7 @@ static void sta_apply_parameters(struct 
 {
 	u32 rates;
 	int i, j;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 
 	if (params->station_flags & STATION_FLAG_CHANGED) {
 		sta->flags &= ~WLAN_STA_AUTHORIZED;
@@ -531,15 +531,16 @@ static void sta_apply_parameters(struct 
 
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
 
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2007-12-23 22:02:19.079081000 +0100
+++ everything/net/mac80211/rc80211_pid_algo.c	2007-12-23 22:05:39.699081760 +0100
@@ -104,7 +104,7 @@ static void rate_control_pid_adjust_rate
 					 struct rc_pid_rateinfo *rinfo)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	int newidx;
 	int maxrate;
 	int back = (adj > 0) ? 1 : -1;
@@ -115,16 +115,16 @@ static void rate_control_pid_adjust_rate
 		return;
 	}
 
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
 
@@ -134,7 +134,7 @@ static void rate_control_pid_adjust_rate
 #ifdef CONFIG_MAC80211_DEBUGFS
 	rate_control_pid_event_rate_change(
 		&((struct rc_pid_sta_info *)sta->rate_ctrl_priv)->events,
-		newidx, mode->rates[newidx].rate);
+		newidx, sband->bitrates[newidx].bitrate);
 #endif
 }
 
@@ -161,7 +161,7 @@ static void rate_control_pid_sample(stru
 {
 	struct rc_pid_sta_info *spinfo = sta->rate_ctrl_priv;
 	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	u32 pf;
 	s32 err_avg;
 	u32 err_prop;
@@ -170,7 +170,7 @@ static void rate_control_pid_sample(stru
 	int adj, i, j, tmp;
 	unsigned long period;
 
-	mode = local->oper_hw_mode;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	spinfo = sta->rate_ctrl_priv;
 
 	/* In case nothing happened during the previous control interval, turn
@@ -196,18 +196,18 @@ static void rate_control_pid_sample(stru
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
 	err_prop = pinfo->target - pf;
@@ -247,15 +247,17 @@ static void rate_control_pid_tx_status(v
 	struct sta_info *sta;
 	struct rc_pid_sta_info *spinfo;
 	unsigned long period;
+	struct ieee80211_supported_band *sband;
 
 	sta = sta_info_get(local, hdr->addr1);
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	if (!sta)
 		return;
 
 	/* Ignore all frames that were sent with a different rate than the rate
 	 * we currently advise mac80211 to use. */
-	if (status->control.rate != &local->oper_hw_mode->rates[sta->txrate])
+	if (status->control.tx_rate != &sband->bitrates[sta->txrate_idx])
 		goto ignore;
 
 	spinfo = sta->rate_ctrl_priv;
@@ -302,7 +304,7 @@ ignore:
 }
 
 static void rate_control_pid_get_rate(void *priv, struct net_device *dev,
-				      struct ieee80211_hw_mode *mode,
+				      struct ieee80211_supported_band *sband,
 				      struct sk_buff *skb,
 				      struct rate_selection *sel)
 {
@@ -314,24 +316,24 @@ static void rate_control_pid_get_rate(vo
 	sta = sta_info_get(local, hdr->addr1);
 
 	if (!sta) {
-		sel->rate = rate_lowest(local, mode, NULL);
+		sel->rate = rate_lowest(local, sband, NULL);
 		sta_info_put(sta);
 		return;
 	}
 
-	rateidx = sta->txrate;
+	rateidx = sta->txrate_idx;
 
-	if (rateidx >= mode->num_rates)
-		rateidx = mode->num_rates - 1;
+	if (rateidx >= sband->n_bitrates)
+		rateidx = sband->n_bitrates - 1;
 
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
 
@@ -343,28 +345,32 @@ static void rate_control_pid_rate_init(v
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
@@ -373,7 +379,7 @@ static void *rate_control_pid_alloc(stru
 	/* Sort the rates. This is optimized for the most common case (i.e.
 	 * almost-sorted CCK+OFDM rates). Kind of bubble-sort with reversed
 	 * mapping too. */
-	for (i = 0; i < mode->num_rates; i++) {
+	for (i = 0; i < sband->n_bitrates; i++) {
 		rinfo[i].index = i;
 		rinfo[i].rev_index = i;
 		if (pinfo->fast_start)
@@ -381,11 +387,11 @@ static void *rate_control_pid_alloc(stru
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
--- everything.orig/net/mac80211/ieee80211_rate.c	2007-12-23 22:02:19.159082791 +0100
+++ everything/net/mac80211/ieee80211_rate.c	2007-12-23 22:05:39.699081760 +0100
@@ -163,7 +163,8 @@ static void rate_control_release(struct 
 }
 
 void rate_control_get_rate(struct net_device *dev,
-			   struct ieee80211_hw_mode *mode, struct sk_buff *skb,
+			   struct ieee80211_supported_band *sband,
+			   struct sk_buff *skb,
 			   struct rate_selection *sel)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -181,26 +182,27 @@ void rate_control_get_rate(struct net_de
 	fc = le16_to_cpu(hdr->frame_control);
 	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
 	    is_multicast_ether_addr(hdr->addr1))
-		sel->rate = rate_lowest(local, mode, sta);
+		sel->rate = rate_lowest(local, sband, sta);
 
 	/* If a forced rate is in effect, select it. */
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
-		sel->rate = &mode->rates[sdata->bss->force_unicast_rateidx];
+		sel->rate = &sband->bitrates[
+					sdata->bss->force_unicast_rateidx];
 
 	/* If we haven't found the rate yet, ask the rate control algo. */
 	if (!sel->rate)
-		ref->ops->get_rate(ref->priv, dev, mode, skb, sel);
+		ref->ops->get_rate(ref->priv, dev, sband, skb, sel);
 
 	/* Select a non-ERP backup rate. */
 	if (!sel->nonerp) {
-		for (i = 0; i < mode->num_rates - 1; i++) {
-			struct ieee80211_rate *rate = &mode->rates[i];
-			if (sel->rate->rate < rate->rate)
+		for (i = 0; i < sband->n_bitrates; i++) {
+			struct ieee80211_bitrate *rate = &sband->bitrates[i];
+			if (sel->rate->bitrate < rate->bitrate)
 				break;
 
-			if (rate_supported(sta, mode, i) &&
-			    !(rate->flags & IEEE80211_RATE_ERP))
+			if (rate_supported(sta, sband->band, i) &&
+			    !(rate->flags & IEEE80211_RATE_ERP_G))
 				sel->nonerp = rate;
 		}
 	}
--- everything.orig/net/mac80211/sta_info.h	2007-12-23 22:02:19.189081651 +0100
+++ everything/net/mac80211/sta_info.h	2007-12-23 22:05:39.699081760 +0100
@@ -59,10 +59,11 @@ struct sta_info {
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
@@ -144,7 +145,6 @@ static inline void __sta_info_get(struct
 }
 
 struct sta_info * sta_info_get(struct ieee80211_local *local, u8 *addr);
-int sta_info_min_txrate_get(struct ieee80211_local *local);
 void sta_info_put(struct sta_info *sta);
 struct sta_info * sta_info_add(struct ieee80211_local *local,
 			       struct net_device *dev, u8 *addr, gfp_t gfp);
--- everything.orig/net/mac80211/ieee80211_iface.c	2007-12-23 22:02:19.259081163 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2007-12-23 22:05:39.709083659 +0100
@@ -118,6 +118,8 @@ void ieee80211_if_set_type(struct net_de
 	sdata->bss = NULL;
 	sdata->vif.type = type;
 
+	sdata->basic_rates = 0;
+
 	switch (type) {
 	case IEEE80211_IF_TYPE_WDS:
 		/* nothing special */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/net/wireless/reg.c	2007-12-23 22:46:00.346833767 +0100
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
+	int max_power_dBm;
+	int max_antenna_gain_dBi;
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
+	chan->max_antenna_gain_dBi = min(chan->orig_mag,
+					 rg->max_antenna_gain_dBi);
+	chan->max_power_dBm = min(chan->orig_mpwr, rg->max_power_dBm);
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


