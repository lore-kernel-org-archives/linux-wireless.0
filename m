Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbXLNMQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 07:16:15 -0500
Subject: [WIP] cfg80211 infrastructure for channels/bitrates, mac80211 and
	b43 conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 12:16:44 +0100
Message-Id: <1197631004.16079.25.camel@johannes.berg> (sfid-20071214_121625_222791_4100D354)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patch creates new cfg80211 wiphy API for channel and bitrate
registration and converts mac80211 (and, as an example and for testing,
b43) to the new API. The old mac80211 API is completely ripped out.

So far, it has survived all my testing: only active scanning :)

Note that this has one major regression: with this patch you will have
all hardware channels available because I completely ripped out the
regulatory "enforcement" code. I believe that is for the better because
then we can cleanly add new regulatory enforcement code to cfg80211.

I've also ripped out all power adjustment and antenna gain fields/code,
this too will have to be added back, again I believe part of new
regulatory enforcement code.

Along with the regulatory code I've also ripped out the
IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED flag, I believe it to be
unnecessary if the hardware simply gives us whatever channels it wants
to support and we then enable/disable them as required, which is pretty
much required for travelling. Those with varying EEPROMs will obviously
have to allocate the array dynamically for each wiphy.

Here are a few more TODOs:
 * do ERP stuff again, this is currently pretty broken (even before the
   patch)
 * do basic rate handling again, this is probably broken before the
   patch
 * do mandatory rate handling again (probably broken as well, partially
   done)
 * reimplement channel use calculations... they looked too broken to
   worry about right now

Luis, please see the API in include/net/wireless.h. You'll have to add
to that for the regulatory stuff.

johannes

---
 drivers/net/wireless/b43/b43.h   |    5 
 drivers/net/wireless/b43/main.c  |  132 ++++++----------
 drivers/net/wireless/b43/sysfs.c |   89 -----------
 drivers/net/wireless/b43/xmit.c  |   25 +--
 include/net/mac80211.h           |  187 +++--------------------
 include/net/wireless.h           |  155 +++++++++++++++++++
 net/mac80211/Makefile            |    1 
 net/mac80211/cfg.c               |    9 -
 net/mac80211/debugfs.c           |   47 -----
 net/mac80211/debugfs_sta.c       |   18 --
 net/mac80211/ieee80211.c         |   96 +++--------
 net/mac80211/ieee80211_i.h       |   61 +------
 net/mac80211/ieee80211_ioctl.c   |  203 +++++++------------------
 net/mac80211/ieee80211_rate.h    |   18 +-
 net/mac80211/ieee80211_sta.c     |  314 +++++++++++++++++++--------------------
 net/mac80211/rc80211_simple.c    |   76 ++++-----
 net/mac80211/regdomain.c         |  152 ------------------
 net/mac80211/rx.c                |   48 -----
 net/mac80211/sta_info.c          |    8 
 net/mac80211/tx.c                |  165 +++++++-------------
 net/mac80211/util.c              |  150 +++---------------
 net/wireless/Makefile            |    2 
 net/wireless/core.c              |   29 +++
 net/wireless/core.h              |    2 
 net/wireless/util.c              |   97 ++++++++++++
 25 files changed, 787 insertions(+), 1302 deletions(-)

--- everything.orig/include/net/mac80211.h	2007-12-14 01:57:48.019845432 +0100
+++ everything/include/net/mac80211.h	2007-12-14 11:54:58.508408692 +0100
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
@@ -281,11 +168,13 @@ struct ieee80211_low_level_stats {
 
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
@@ -304,6 +193,7 @@ struct ieee80211_tx_control {
 #define IEEE80211_TXCTL_REQUEUE		(1<<7)
 #define IEEE80211_TXCTL_FIRST_FRAGMENT	(1<<8) /* this is a first fragment of
 						* the frame */
+#define IEEE80211_TXCTL_SHORT_PREAMBLE	(1<<9)
 #define IEEE80211_TXCTL_LONG_RETRY_LIMIT (1<<10) /* this frame should be send
 						  * using the through
 						  * set_retry_limit configured
@@ -315,20 +205,11 @@ struct ieee80211_tx_control {
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
 
@@ -371,21 +252,19 @@ enum mac80211_rx_flags {
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
@@ -462,41 +341,26 @@ enum ieee80211_conf_flags {
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
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
 
+	struct ieee80211_channel *channel;
+
 	struct ieee80211_ht_info ht_conf;
 	struct ieee80211_ht_bss_info ht_bss_conf;
 };
@@ -715,15 +579,19 @@ enum sta_notify_cmd {
  *	%IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE is also not set because
  *	otherwise the stack will not know when the DTIM beacon was sent.
  *
- * @IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED:
- *	Channels are already configured to the default regulatory domain
- *	specified in the device's EEPROM
+ * @IEEE80211_HW_2GHZ_SHORT_SLOT_CAPABLE:
+ *	Hardware is capable of short slot operation on the 2.4 GHz band.
+ *
+ * @IEEE80211_HW_2GHZ_SHORT_PREAMBLE_CAPABLE:
+ *	Hardware is capable of receiving frames with short preamble on
+ *	the 2.4 GHz band.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE		= 1<<0,
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
 	IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING	= 1<<2,
-	IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED	= 1<<3,
+	IEEE80211_HW_2GHZ_SHORT_SLOT_CAPABLE		= 1<<3,
+	IEEE80211_HW_2GHZ_SHORT_PREAMBLE_CAPABLE	= 1<<4,
 };
 
 /**
@@ -735,7 +603,8 @@ enum ieee80211_hw_flags {
  * @wiphy: This points to the &struct wiphy allocated for this
  *	802.11 PHY. You must fill in the @perm_addr and @dev
  *	members of this structure using SET_IEEE80211_DEV()
- *	and SET_IEEE80211_PERM_ADDR().
+ *	and SET_IEEE80211_PERM_ADDR(). Additionally, all supported
+ *	bands (with channels, bitrates) are registered here.
  *
  * @conf: &struct ieee80211_conf, device configuration, don't use.
  *
@@ -1185,10 +1054,6 @@ static inline char *ieee80211_get_assoc_
 }
 
 
-/* Register a new hardware PHYMODE capability to the stack. */
-int ieee80211_register_hwmode(struct ieee80211_hw *hw,
-			      struct ieee80211_hw_mode *mode);
-
 /**
  * ieee80211_unregister_hw - Unregister a hardware device
  *
@@ -1362,7 +1227,7 @@ __le16 ieee80211_ctstoself_duration(stru
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @frame_len: the length of the frame.
- * @rate: the rate (in 100kbps) at which the frame is going to be transmitted.
+ * @rate: the rate at which the frame is going to be transmitted.
  *
  * Calculate the duration field of some generic frame, given its
  * length and transmission rate (in 100kbps).
@@ -1370,7 +1235,7 @@ __le16 ieee80211_ctstoself_duration(stru
 __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 					size_t frame_len,
-					int rate);
+					struct ieee80211_bitrate *rate);
 
 /**
  * ieee80211_get_buffered_bc - accessing buffered broadcast and multicast frames
--- everything.orig/include/net/wireless.h	2007-12-14 01:55:58.319835830 +0100
+++ everything/include/net/wireless.h	2007-12-14 12:10:33.918406250 +0100
@@ -13,6 +13,149 @@
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
+ * @IEEE80211_CHANFL_DISABLED: This channel is disabled.
+ * @IEEE80211_CHANFL_PASSIVE_SCAN: Only passive scanning is permitted
+ *	on this channel.
+ * @IEEE80211_CHANFL_NO_IBSS: IBSS is not allowed on this channel.
+ */
+enum ieee80211_channel_flags {
+	IEEE80211_CHANFL_DISABLED	= 1<<0,
+	IEEE80211_CHANFL_PASSIVE_SCAN	= 1<<1,
+	IEEE80211_CHANFL_NO_IBSS	= 1<<2,
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
+ * @band: band this channel belongs to.
+ */
+struct ieee80211_channel {
+	enum ieee80211_band band;
+	u16 center_freq;
+	u16 hw_value;
+	u32 flags;
+	/* TBD: power, ..., will be part of regulatory control */
+};
+
+/**
+ * enum ieee80211_bitrate_flags - rate flags
+ *
+ * Hardware/specification flags for rates. These are structured
+ * in a way that allows using the same bitrate structure for
+ * different bands/PHY modes.
+ *
+ * @IEEE80211_RATEFL_SHORT_PREAMBLE: Hardware can send with short
+ *	preamble on this bitrate; only relevant in 2.4GHz band and
+ *	with CCK rates.
+ * @IEEE80211_RATEFL_MANDATORY_A: This bitrate is a mandatory rate
+ *	when used with 802.11a (on the 5 GHz band); filled by the
+ *	core code when registering the wiphy.
+ * @IEEE80211_RATEFL_MANDATORY_B: This bitrate is a mandatory rate
+ *	when used with 802.11b (on the 2.4 GHz band); filled by the
+ *	core code when registering the wiphy.
+ * @IEEE80211_RATEFL_MANDATORY_G: This bitrate is a mandatory rate
+ *	when used with 802.11g (on the 2.4 GHz band); filled by the
+ *	core code when registering the wiphy.
+ * @IEEE80211_RATEFL_ERP_G: This is an ERP rate in 802.11g mode.
+ */
+enum ieee80211_bitrate_flags {
+	IEEE80211_RATEFL_SHORT_PREAMBLE	= 1<<0,
+	IEEE80211_RATEFL_MANDATORY_A	= 1<<1,
+	IEEE80211_RATEFL_MANDATORY_B	= 1<<2,
+	IEEE80211_RATEFL_MANDATORY_G	= 1<<3,
+	IEEE80211_RATEFL_ERP_G		= 1<<4,
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
+ * @n_channels: Number of channels in @channels
+ * @bitrates: Array of bitrates the hardware can operate with
+ *	in this band. Must be sorted to give a valid "supported
+ *	rates" IE, i.e. CCK rates first, then OFDM.
+ * @n_bitrates: Number of bitrates in @bitrates
+ */
+struct ieee80211_supported_band {
+	struct ieee80211_channel *channels;
+	struct ieee80211_bitrate *bitrates;
+	int n_channels;
+	int n_bitrates;
+	struct ieee80211_ht_info ht_info;
+};
+
+/**
  * struct wiphy - wireless hardware description
  * @idx: the wiphy index assigned to this item
  * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
@@ -30,6 +173,8 @@ struct wiphy {
 	 * help determine whether you own this wiphy or not. */
 	void *privid;
 
+	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
+
 	/* fields below are read-only, assigned by cfg80211 */
 
 	/* the item in /sys/class/ieee80211/ points to this,
@@ -136,4 +281,14 @@ extern void wiphy_unregister(struct wiph
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
--- everything.orig/net/mac80211/ieee80211_i.h	2007-12-14 01:57:48.109834961 +0100
+++ everything/net/mac80211/ieee80211_i.h	2007-12-14 12:01:42.908407878 +0100
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
@@ -177,9 +174,7 @@ struct ieee80211_tx_stored_packet {
 	struct sk_buff *skb;
 	int num_extra_frag;
 	struct sk_buff **extra_frag;
-	int last_frag_rateidx;
-	int last_frag_hwrate;
-	struct ieee80211_rate *last_frag_rate;
+	struct ieee80211_bitrate *last_frag_rate;
 	unsigned int last_frag_rate_ctrl_probe;
 };
 
@@ -413,9 +408,6 @@ struct ieee80211_local {
 
 	const struct ieee80211_ops *ops;
 
-	/* List of registered struct ieee80211_hw_mode */
-	struct list_head modes_list;
-
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
 	int open_count;
 	int monitors;
@@ -455,11 +447,6 @@ struct ieee80211_local {
 
 	struct rate_control_ref *rate_ctrl;
 
-	/* Supported and basic rate filters for different modes. These are
-	 * pointers to -1 terminated lists and rates in 100 kbps units. */
-	int *supp_rates[NUM_IEEE80211_MODES];
-	int *basic_rates[NUM_IEEE80211_MODES];
-
 	int rts_threshold;
 	int fragmentation_threshold;
 	int short_retry_limit; /* dot11ShortRetryLimit */
@@ -482,12 +469,13 @@ struct ieee80211_local {
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
@@ -555,14 +543,8 @@ struct ieee80211_local {
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
@@ -572,9 +554,7 @@ struct ieee80211_local {
 		struct dentry *short_retry_limit;
 		struct dentry *long_retry_limit;
 		struct dentry *total_ps_buffered;
-		struct dentry *mode;
 		struct dentry *wep_iv;
-		struct dentry *modes;
 		struct dentry *statistics;
 		struct local_debugfsdentries_statsdentries {
 			struct dentry *transmitted_fragment_count;
@@ -679,23 +659,6 @@ static inline void bss_tim_clear(struct 
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
@@ -708,12 +671,10 @@ int ieee80211_hw_config(struct ieee80211
 int ieee80211_if_config(struct net_device *dev);
 int ieee80211_if_config_beacon(struct net_device *dev);
 void ieee80211_prepare_rates(struct ieee80211_local *local,
-			     struct ieee80211_hw_mode *mode);
+			     struct ieee80211_supported_band *band);
 void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx);
 int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr);
 void ieee80211_if_setup(struct net_device *dev);
-struct ieee80211_rate *ieee80211_get_rate(struct ieee80211_local *local,
-					  int phymode, int hwrate);
 int ieee80211_hw_config_ht(struct ieee80211_local *local, int enable_ht,
 			   struct ieee80211_ht_info *req_ht_cap,
 			   struct ieee80211_ht_bss_info *req_bss_cap);
@@ -744,7 +705,7 @@ extern const struct iw_handler_def ieee8
 /* ieee80211_ioctl.c */
 int ieee80211_set_compression(struct ieee80211_local *local,
 			      struct net_device *dev, struct sta_info *sta);
-int ieee80211_set_channel(struct ieee80211_local *local, int channel, int freq);
+int ieee80211_set_freq(struct ieee80211_local *local, int freq);
 /* ieee80211_sta.c */
 void ieee80211_sta_timer(unsigned long data);
 void ieee80211_sta_work(struct work_struct *work);
@@ -787,10 +748,6 @@ int ieee80211_if_remove(struct net_devic
 void ieee80211_if_free(struct net_device *dev);
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata);
 
-/* regdomain.c */
-void ieee80211_regdomain_init(void);
-void ieee80211_set_default_regdomain(struct ieee80211_hw_mode *mode);
-
 /* rx handling */
 extern ieee80211_rx_handler ieee80211_rx_pre_handlers[];
 extern ieee80211_rx_handler ieee80211_rx_handlers[];
--- everything.orig/net/mac80211/util.c	2007-12-14 01:57:47.309839410 +0100
+++ everything/net/mac80211/util.c	2007-12-14 12:12:21.208408746 +0100
@@ -45,92 +45,6 @@ static const unsigned char eapol_header[
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00, 0x88, 0x8e };
 
 
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
@@ -261,7 +175,7 @@ int ieee80211_frame_duration(struct ieee
 	 * DIV_ROUND_UP() operations.
 	 */
 
-	if (local->hw.conf.phymode == MODE_IEEE80211A || erp) {
+	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ || erp) {
 		/*
 		 * OFDM:
 		 *
@@ -303,15 +217,20 @@ int ieee80211_frame_duration(struct ieee
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
-	dur = ieee80211_frame_duration(local, frame_len, rate,
+	erp = 0;
+#if TODO
+	if (sdata->flags & OPERATING_IN_GMODE)
+		erp = rate->flags & ERP_RATE_IN_GMODE;
+#endif
+	dur = ieee80211_frame_duration(local, frame_len, rate->bitrate,
 		       erp, sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE);
 
 	return cpu_to_le16(dur);
@@ -323,7 +242,7 @@ __le16 ieee80211_rts_duration(struct iee
 			      const struct ieee80211_tx_control *frame_txctl)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_rate *rate;
+	int rate;
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	int short_preamble;
 	int erp;
@@ -331,17 +250,21 @@ __le16 ieee80211_rts_duration(struct iee
 
 	short_preamble = sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE;
 
-	rate = frame_txctl->rts_rate;
-	erp = !!(rate->flags & IEEE80211_RATE_ERP);
+	rate = frame_txctl->rts_cts_rate->bitrate;
+	erp = 0;
+#if TODO
+	if (sdata->flags & OPERATING_IN_GMODE)
+		erp = rate->flags & ERP_RATE_IN_GMODE;
+#endif
 
 	/* CTS duration */
-	dur = ieee80211_frame_duration(local, 10, rate->rate,
+	dur = ieee80211_frame_duration(local, 10, rate,
 				       erp, short_preamble);
 	/* Data frame duration */
-	dur += ieee80211_frame_duration(local, frame_len, rate->rate,
+	dur += ieee80211_frame_duration(local, frame_len, rate,
 					erp, short_preamble);
 	/* ACK duration */
-	dur += ieee80211_frame_duration(local, 10, rate->rate,
+	dur += ieee80211_frame_duration(local, 10, rate,
 					erp, short_preamble);
 
 	return cpu_to_le16(dur);
@@ -354,7 +277,7 @@ __le16 ieee80211_ctstoself_duration(stru
 				    const struct ieee80211_tx_control *frame_txctl)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_rate *rate;
+	int rate;
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	int short_preamble;
 	int erp;
@@ -362,15 +285,19 @@ __le16 ieee80211_ctstoself_duration(stru
 
 	short_preamble = sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE;
 
-	rate = frame_txctl->rts_rate;
-	erp = !!(rate->flags & IEEE80211_RATE_ERP);
+	rate = frame_txctl->rts_cts_rate->bitrate;
+	erp = 0;
+#if TODO
+	if (sdata->flags & OPERATING_IN_GMODE)
+		erp = rate->flags & ERP_RATE_IN_GMODE;
+#endif
 
 	/* Data frame duration */
-	dur = ieee80211_frame_duration(local, frame_len, rate->rate,
+	dur = ieee80211_frame_duration(local, frame_len, rate,
 				       erp, short_preamble);
 	if (!(frame_txctl->flags & IEEE80211_TXCTL_NO_ACK)) {
 		/* ACK duration */
-		dur += ieee80211_frame_duration(local, 10, rate->rate,
+		dur += ieee80211_frame_duration(local, 10, rate,
 						erp, short_preamble);
 	}
 
@@ -378,27 +305,6 @@ __le16 ieee80211_ctstoself_duration(stru
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
--- everything.orig/net/mac80211/ieee80211.c	2007-12-14 01:57:48.639834473 +0100
+++ everything/net/mac80211/ieee80211.c	2007-12-14 12:02:11.098408692 +0100
@@ -558,37 +558,30 @@ int ieee80211_if_config_beacon(struct ne
 
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
+	local->hw.conf.channel = chan;
+
+	/* TBD power level/antenna gain, old code:
 	if (!local->hw.conf.power_level) {
 		local->hw.conf.power_level = chan->power_level;
 	} else {
 		local->hw.conf.power_level = min(chan->power_level,
 						 local->hw.conf.power_level);
 	}
-	local->hw.conf.freq = chan->freq;
-	local->hw.conf.phymode = mode->mode;
+
 	local->hw.conf.antenna_max = chan->antenna_max;
-	local->hw.conf.chan = chan;
-	local->hw.conf.mode = mode;
+	*/
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "HW CONFIG: channel=%d freq=%d "
-	       "phymode=%d\n", local->hw.conf.channel, local->hw.conf.freq,
-	       local->hw.conf.phymode);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+	printk(KERN_DEBUG "HW CONFIG: freq=%d\n", chan->center_freq);
+#endif
 
 	if (local->open_count)
 		ret = local->ops->config(local_to_hw(local), &local->hw.conf);
@@ -606,11 +599,13 @@ int ieee80211_hw_config_ht(struct ieee80
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
@@ -620,17 +615,17 @@ int ieee80211_hw_config_ht(struct ieee80
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
@@ -1083,10 +1078,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->long_retry_limit = 4;
 	local->hw.conf.radio_enabled = 1;
 
-	local->enabled_modes = ~0;
-
-	INIT_LIST_HEAD(&local->modes_list);
-
 	INIT_LIST_HEAD(&local->interfaces);
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
@@ -1131,6 +1122,7 @@ int ieee80211_register_hw(struct ieee802
 	struct ieee80211_local *local = hw_to_local(hw);
 	const char *name;
 	int result;
+	enum ieee80211_band band;
 
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
@@ -1215,6 +1207,20 @@ int ieee80211_register_hw(struct ieee802
 
 	ieee80211_led_init(local);
 
+	/* generic code guarantees at least one band */
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
+
 	return 0;
 
 fail_wep:
@@ -1234,44 +1240,10 @@ fail_workqueue:
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
@@ -1312,11 +1284,6 @@ void ieee80211_unregister_hw(struct ieee
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
@@ -1364,7 +1331,6 @@ static int __init ieee80211_init(void)
 	}
 
 	ieee80211_debugfs_netdev_init();
-	ieee80211_regdomain_init();
 
 	return 0;
 }
--- everything.orig/net/mac80211/ieee80211_ioctl.c	2007-12-14 01:57:47.819835612 +0100
+++ everything/net/mac80211/ieee80211_ioctl.c	2007-12-14 11:04:30.918407769 +0100
@@ -125,41 +125,6 @@ static int ieee80211_ioctl_siwgenie(stru
 	return -EOPNOTSUPP;
 }
 
-/*
- * Wow. This ioctl interface is such crap, it's tied
- * to internal definitions. I hope it dies soon.
- */
-static int mode_to_hostapd_mode(enum ieee80211_phymode mode)
-{
-	switch (mode) {
-	case MODE_IEEE80211A:
-		return 0;
-	case MODE_IEEE80211B:
-		return 1;
-	case MODE_IEEE80211G:
-		return 3;
-	case NUM_IEEE80211_MODES:
-		WARN_ON(1);
-		break;
-	}
-	WARN_ON(1);
-	return -1;
-}
-
-static int channel_flags_to_hostapd_flags(int flags)
-{
-	int res = 0;
-
-	if (flags & IEEE80211_CHAN_W_SCAN)
-		res |= 1;
-	if (flags & IEEE80211_CHAN_W_ACTIVE_SCAN)
-		res |= 2;
-	if (flags & IEEE80211_CHAN_W_IBSS)
-		res |= 4;
-
-	return res;
-}
-
 struct ieee80211_channel_data {
 	short chan; /* channel number (IEEE 802.11) */
 	short freq; /* frequency in MHz */
@@ -175,51 +140,10 @@ static int ieee80211_ioctl_get_hw_featur
 					   struct prism2_hostapd_param *param,
 					   int param_len)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	u8 *pos = param->u.hw_features.data;
-	int left = param_len - (pos - (u8 *) param);
-	int i;
-	struct hostapd_ioctl_hw_modes_hdr *hdr;
-	struct ieee80211_rate_data *rate;
-	struct ieee80211_channel_data *chan;
-	struct ieee80211_hw_mode *mode;
-
 	param->u.hw_features.flags = 0;
-
 	param->u.hw_features.num_modes = 0;
-	list_for_each_entry(mode, &local->modes_list, list) {
-		int clen, rlen;
 
-		param->u.hw_features.num_modes++;
-		clen =
-		    mode->num_channels * sizeof(struct ieee80211_channel_data);
-		rlen = mode->num_rates * sizeof(struct ieee80211_rate_data);
-		if (left < sizeof(*hdr) + clen + rlen)
-			return -E2BIG;
-		left -= sizeof(*hdr) + clen + rlen;
-
-		hdr = (struct hostapd_ioctl_hw_modes_hdr *)pos;
-		hdr->mode = mode_to_hostapd_mode(mode->mode);
-		hdr->num_channels = mode->num_channels;
-		hdr->num_rates = mode->num_rates;
-
-		pos = (u8 *) (hdr + 1);
-		chan = (struct ieee80211_channel_data *)pos;
-		for (i = 0; i < mode->num_channels; i++) {
-			chan[i].chan = mode->channels[i].chan;
-			chan[i].freq = mode->channels[i].freq;
-			chan[i].flag = channel_flags_to_hostapd_flags(
-						mode->channels[i].flag);
-		}
-		pos += clen;
-
-		rate = (struct ieee80211_rate_data *)pos;
-		for (i = 0; i < mode->num_rates; i++) {
-			rate[i].rate = mode->rates[i].rate;
-			rate[i].flags = mode->rates[i].flags;
-		}
-		pos += rlen;
-	}
+	/* TODO. bah. better fix hostapd */
 
 	return 0;
 }
@@ -272,22 +196,7 @@ static int ieee80211_ioctl_giwname(struc
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
@@ -299,7 +208,7 @@ static int ieee80211_ioctl_giwrange(stru
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct iw_range *range = (struct iw_range *) extra;
-	struct ieee80211_hw_mode *mode = NULL;
+	enum ieee80211_band band;
 	int c = 0;
 
 	data->length = sizeof(struct iw_range);
@@ -334,24 +243,27 @@ static int ieee80211_ioctl_giwrange(stru
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
+			if (!(chan->flags & IEEE80211_CHANFL_DISABLED)) {
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
@@ -438,22 +350,29 @@ static int ieee80211_ioctl_giwmode(struc
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
+			if (chan->flags & IEEE80211_CHANFL_DISABLED)
+				continue;
+
+			if (chan->center_freq == freqMHz) {
 				set = 1;
+				local->oper_channel = chan;
 				break;
 			}
 		}
@@ -491,13 +410,14 @@ static int ieee80211_ioctl_siwfreq(struc
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
@@ -510,10 +430,7 @@ static int ieee80211_ioctl_giwfreq(struc
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
-	/* TODO: in station mode (Managed/Ad-hoc) might need to poll low-level
-	 * driver for the current channel with firmware-based management */
-
-	freq->m = local->hw.conf.freq;
+	freq->m = local->hw.conf.channel->center_freq;
 	freq->e = 6;
 
 	return 0;
@@ -711,15 +628,17 @@ static int ieee80211_ioctl_siwrate(struc
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
@@ -727,18 +646,20 @@ static int ieee80211_ioctl_siwrate(struc
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
@@ -748,16 +669,21 @@ static int ieee80211_ioctl_giwrate(struc
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_supported_band *sband;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->type == IEEE80211_IF_TYPE_STA)
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
+	if (sta->txrate < sband->n_bitrates)
+		rate->value = sband->bitrates[sta->txrate].bitrate * 100000;
 	else
 		rate->value = 0;
 	sta_info_put(sta);
@@ -780,20 +706,15 @@ static int ieee80211_ioctl_siwtxpower(st
 	if (data->txpower.fixed) {
 		new_power_level = data->txpower.value;
 	} else {
-		/* Automatic power level. Get the px power from the current
-		 * channel. */
-		struct ieee80211_channel* chan = local->oper_channel;
-		if (!chan)
-			return -EINVAL;
-
-		new_power_level = chan->power_level;
+		/* TODO */
 	}
 
+/* TODO
 	if (local->hw.conf.power_level != new_power_level) {
 		local->hw.conf.power_level = new_power_level;
 		need_reconfig = 1;
 	}
-
+*/
 	if (local->hw.conf.radio_enabled != !(data->txpower.disabled)) {
 		local->hw.conf.radio_enabled = !(data->txpower.disabled);
 		need_reconfig = 1;
@@ -817,7 +738,7 @@ static int ieee80211_ioctl_giwtxpower(st
 
 	data->txpower.fixed = 1;
 	data->txpower.disabled = !(local->hw.conf.radio_enabled);
-	data->txpower.value = local->hw.conf.power_level;
+/* TODO	data->txpower.value = local->hw.conf.power_level; */
 	data->txpower.flags = IW_TXPOW_DBM;
 
 	return 0;
--- everything.orig/net/mac80211/ieee80211_rate.h	2007-12-14 01:55:58.929834582 +0100
+++ everything/net/mac80211/ieee80211_rate.h	2007-12-14 01:57:48.889834256 +0100
@@ -22,14 +22,15 @@
 #define RATE_CONTROL_NUM_UP   15
 
 
+/* TODO: kdoc */
 struct rate_control_extra {
 	/* values from rate_control_get_rate() to the caller: */
-	struct ieee80211_rate *probe; /* probe with this rate, or NULL for no
-				       * probing */
-	struct ieee80211_rate *nonerp;
+	struct ieee80211_bitrate *probe; /* probe with this rate, or NULL for
+					    no probing */
+	struct ieee80211_bitrate *nonerp;
 
 	/* parameters from the caller to rate_control_get_rate(): */
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *band;
 	u16 ethertype;
 };
 
@@ -40,9 +41,10 @@ struct rate_control_ops {
 	void (*tx_status)(void *priv, struct net_device *dev,
 			  struct sk_buff *skb,
 			  struct ieee80211_tx_status *status);
-	struct ieee80211_rate *(*get_rate)(void *priv, struct net_device *dev,
-					   struct sk_buff *skb,
-					   struct rate_control_extra *extra);
+	struct ieee80211_bitrate *(*get_rate)(void *priv,
+					      struct net_device *dev,
+					      struct sk_buff *skb,
+					      struct rate_control_extra *extra);
 	void (*rate_init)(void *priv, void *priv_sta,
 			  struct ieee80211_local *local, struct sta_info *sta);
 	void (*clear)(void *priv);
@@ -88,7 +90,7 @@ static inline void rate_control_tx_statu
 }
 
 
-static inline struct ieee80211_rate *
+static inline struct ieee80211_bitrate *
 rate_control_get_rate(struct ieee80211_local *local, struct net_device *dev,
 		      struct sk_buff *skb, struct rate_control_extra *extra)
 {
--- everything.orig/net/mac80211/ieee80211_sta.c	2007-12-14 01:55:58.889836264 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2007-12-14 10:55:06.928408203 +0100
@@ -67,7 +67,7 @@
 static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
 				     u8 *ssid, size_t ssid_len);
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel,
+ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len);
 static void ieee80211_rx_bss_put(struct net_device *dev,
 				 struct ieee80211_sta_bss *bss);
@@ -468,7 +468,7 @@ static void ieee80211_set_associated(str
 			return;
 
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
-					   local->hw.conf.channel,
+					   local->hw.conf.channel->center_freq,
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
 			if (bss->has_erp_value)
@@ -591,7 +591,6 @@ static void ieee80211_send_assoc(struct 
 				 struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hw_mode *mode;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, *ies;
@@ -599,6 +598,7 @@ static void ieee80211_send_assoc(struct 
 	u16 capab;
 	struct ieee80211_sta_bss *bss;
 	int wmm = 0;
+	struct ieee80211_supported_band *sband;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
 			    sizeof(*mgmt) + 200 + ifsta->extra_ie_len +
@@ -610,13 +610,19 @@ static void ieee80211_send_assoc(struct 
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
+		if (local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_CAPABLE)
+			capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
+		if (local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_CAPABLE)
+			capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
 	}
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel,
+
+	bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+				   local->hw.conf.channel->center_freq,
 				   ifsta->ssid, ifsta->ssid_len);
 	if (bss) {
 		if (bss->capability & WLAN_CAPABILITY_PRIVACY)
@@ -655,23 +661,23 @@ static void ieee80211_send_assoc(struct 
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
@@ -694,17 +700,18 @@ static void ieee80211_send_assoc(struct 
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
@@ -787,7 +794,8 @@ static int ieee80211_privacy_mismatch(st
 	if (!ifsta || (ifsta->flags & IEEE80211_STA_MIXED_CELL))
 		return 0;
 
-	bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel,
+	bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
+				   local->hw.conf.channel->center_freq,
 				   ifsta->ssid, ifsta->ssid_len);
 	if (!bss)
 		return 0;
@@ -901,11 +909,11 @@ static void ieee80211_send_probe_req(str
 				     u8 *ssid, size_t ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hw_mode *mode;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, *supp_rates, *esupp_rates = NULL;
 	int i;
+	struct ieee80211_supported_band *sband;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt) + 200);
 	if (!skb) {
@@ -935,11 +943,10 @@ static void ieee80211_send_probe_req(str
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
@@ -952,7 +959,7 @@ static void ieee80211_send_probe_req(str
 			pos = skb_put(skb, 1);
 			supp_rates[1]++;
 		}
-		*pos = rate->rate / 5;
+		*pos = rate->bitrate / 5;
 	}
 
 	ieee80211_sta_tx(dev, skb, 0);
@@ -1308,7 +1315,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 					 int reassoc)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 	u32 rates;
 	u16 capab_info, status_code, aid;
@@ -1380,7 +1387,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	if (elems.erp_info && elems.erp_info_len >= 1) {
 		struct ieee80211_sta_bss *bss
 			= ieee80211_rx_bss_get(dev, ifsta->bssid,
-					       local->hw.conf.channel,
+					       local->hw.conf.channel->center_freq,
 					       ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
 			bss->erp_value = elems.erp_info[0];
@@ -1412,7 +1419,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 			return;
 		}
 		bss = ieee80211_rx_bss_get(dev, ifsta->bssid,
-					   local->hw.conf.channel,
+					   local->hw.conf.channel->center_freq,
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
 			sta->last_rssi = bss->rssi;
@@ -1426,17 +1433,18 @@ static void ieee80211_rx_mgmt_assoc_resp
 	sta->flags |= WLAN_STA_AUTH | WLAN_STA_ASSOC | WLAN_STA_ASSOC_AP;
 
 	rates = 0;
-	mode = local->oper_hw_mode;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
 	for (i = 0; i < elems.supp_rates_len; i++) {
 		int rate = (elems.supp_rates[i] & 0x7f) * 5;
-		for (j = 0; j < mode->num_rates; j++)
-			if (mode->rates[j].rate == rate)
+		for (j = 0; j < sband->n_bitrates; j++)
+			if (sband->bitrates[j].bitrate == rate)
 				rates |= BIT(j);
 	}
 	for (i = 0; i < elems.ext_supp_rates_len; i++) {
 		int rate = (elems.ext_supp_rates[i] & 0x7f) * 5;
-		for (j = 0; j < mode->num_rates; j++)
-			if (mode->rates[j].rate == rate)
+		for (j = 0; j < sband->n_bitrates; j++)
+			if (sband->bitrates[j].bitrate == rate)
 				rates |= BIT(j);
 	}
 	sta->supp_rates = rates;
@@ -1502,7 +1510,7 @@ static void __ieee80211_rx_bss_hash_del(
 
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid, int channel,
+ieee80211_rx_bss_add(struct net_device *dev, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -1514,7 +1522,7 @@ ieee80211_rx_bss_add(struct net_device *
 	atomic_inc(&bss->users);
 	atomic_inc(&bss->users);
 	memcpy(bss->bssid, bssid, ETH_ALEN);
-	bss->channel = channel;
+	bss->freqMhz = freq;
 	if (ssid && ssid_len <= IEEE80211_MAX_SSID_LEN) {
 		memcpy(bss->ssid, ssid, ssid_len);
 		bss->ssid_len = ssid_len;
@@ -1530,7 +1538,7 @@ ieee80211_rx_bss_add(struct net_device *
 
 
 static struct ieee80211_sta_bss *
-ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int channel,
+ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -1540,7 +1548,7 @@ ieee80211_rx_bss_get(struct net_device *
 	bss = local->sta_bss_hash[STA_HASH(bssid)];
 	while (bss) {
 		if (!memcmp(bss->bssid, bssid, ETH_ALEN) &&
-		    bss->channel == channel &&
+		    bss->freqMhz == freq &&
 		    bss->ssid_len == ssid_len &&
 		    (ssid_len == 0 || !memcmp(bss->ssid, ssid, ssid_len))) {
 			atomic_inc(&bss->users);
@@ -1605,7 +1613,7 @@ static void ieee80211_rx_bss_info(struct
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee802_11_elems elems;
 	size_t baselen;
-	int channel, clen;
+	int freq, clen;
 	struct ieee80211_sta_bss *bss;
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1656,26 +1664,22 @@ static void ieee80211_rx_bss_info(struct
 	if (sdata->type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0 &&
 	    (sta = sta_info_get(local, mgmt->sa))) {
-		struct ieee80211_hw_mode *mode;
-		struct ieee80211_rate *rates;
+		struct ieee80211_supported_band *sband;
+		struct ieee80211_bitrate *bitrates;
 		size_t num_rates;
 		u32 supp_rates, prev_rates;
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
@@ -1689,7 +1693,7 @@ static void ieee80211_rx_bss_info(struct
 					[i - elems.supp_rates_len];
 			own_rate = 5 * (rate & 0x7f);
 			for (j = 0; j < num_rates; j++)
-				if (rates[j].rate == own_rate)
+				if (bitrates[j].bitrate == own_rate)
 					supp_rates |= BIT(j);
 		}
 
@@ -1715,14 +1719,14 @@ static void ieee80211_rx_bss_info(struct
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
@@ -1735,6 +1739,8 @@ static void ieee80211_rx_bss_info(struct
 #endif
 	}
 
+	bss->band = rx_status->band;
+
 	if (bss->probe_resp && beacon) {
 		/* Do not allow beacon to override data from Probe Response. */
 		ieee80211_rx_bss_put(dev, bss);
@@ -1833,20 +1839,6 @@ static void ieee80211_rx_bss_info(struct
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
@@ -2403,7 +2395,7 @@ static int ieee80211_sta_config_auth(str
 	}
 
 	spin_lock_bh(&local->sta_bss_lock);
-	freq = local->oper_channel->freq;
+	freq = local->oper_channel->center_freq;
 	list_for_each_entry(bss, &local->sta_bss_list, list) {
 		if (!(bss->capability & WLAN_CAPABILITY_ESS))
 			continue;
@@ -2413,7 +2405,7 @@ static int ieee80211_sta_config_auth(str
 			continue;
 
 		if (!(ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL) &&
-		    bss->freq != freq)
+		    bss->freqMhz != freq)
 			continue;
 
 		if (!(ifsta->flags & IEEE80211_STA_AUTO_BSSID_SEL) &&
@@ -2434,7 +2426,7 @@ static int ieee80211_sta_config_auth(str
 	spin_unlock_bh(&local->sta_bss_lock);
 
 	if (selected) {
-		ieee80211_set_channel(local, -1, selected->freq);
+		ieee80211_set_freq(local, selected->freqMhz);
 		if (!(ifsta->flags & IEEE80211_STA_SSID_SET))
 			ieee80211_sta_set_ssid(dev, selected->ssid,
 					       selected->ssid_len);
@@ -2467,8 +2459,8 @@ static int ieee80211_sta_join_ibss(struc
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_tx_control control;
-	struct ieee80211_rate *rate;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_bitrate *rate;
+	struct ieee80211_supported_band *sband;
 	struct rate_control_extra extra;
 	u8 *pos;
 	struct ieee80211_sub_if_data *sdata;
@@ -2491,12 +2483,11 @@ static int ieee80211_sta_join_ibss(struc
 	sdata->drop_unencrypted = bss->capability &
 		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	res = ieee80211_set_channel(local, -1, bss->freq);
+	res = ieee80211_set_freq(local, bss->freqMhz);
 
-	if (!(local->oper_channel->flag & IEEE80211_CHAN_W_IBSS)) {
-		printk(KERN_DEBUG "%s: IBSS not allowed on channel %d "
-		       "(%d MHz)\n", dev->name, local->hw.conf.channel,
-		       local->hw.conf.freq);
+	if (local->oper_channel->flags & IEEE80211_CHANFL_NO_IBSS) {
+		printk(KERN_DEBUG "%s: IBSS not allowed on frequency "
+		       "%d MHz\n", dev->name, local->oper_channel->center_freq);
 		return -1;
 	}
 
@@ -2533,10 +2524,12 @@ static int ieee80211_sta_join_ibss(struc
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
@@ -2555,19 +2548,19 @@ static int ieee80211_sta_join_ibss(struc
 
 		memset(&control, 0, sizeof(control));
 		memset(&extra, 0, sizeof(extra));
-		extra.mode = local->oper_hw_mode;
+		extra.band =
+			local->hw.wiphy->bands[local->hw.conf.channel->band];
 		rate = rate_control_get_rate(local, dev, skb, &extra);
 		if (!rate) {
 			printk(KERN_DEBUG "%s: Failed to determine TX rate "
 			       "for IBSS beacon\n", dev->name);
 			break;
 		}
-		control.tx_rate =
-			((sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE) &&
-			(rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
-			rate->val2 : rate->val;
+		control.tx_rate = rate;
+		if (sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE &&
+		    rate->flags & IEEE80211_RATEFL_SHORT_PREAMBLE)
+			control.flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
 		control.antenna_sel_tx = local->hw.conf.antenna_sel_tx;
-		control.power_level = local->hw.conf.power_level;
 		control.flags |= IEEE80211_TXCTL_NO_ACK;
 		control.retry_limit = 1;
 
@@ -2592,11 +2585,11 @@ static int ieee80211_sta_join_ibss(struc
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
 		ifsta->supp_rates_bits = rates;
@@ -2623,7 +2616,7 @@ static int ieee80211_sta_create_ibss(str
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sta_bss *bss;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	u8 bssid[ETH_ALEN], *pos;
 	int i;
 	DECLARE_MAC_BUF(mac);
@@ -2645,28 +2638,28 @@ static int ieee80211_sta_create_ibss(str
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
 
@@ -2715,7 +2708,8 @@ static int ieee80211_sta_find_ibss(struc
 	       "%s\n", print_mac(mac, bssid), print_mac(mac2, ifsta->bssid));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0 &&
-	    (bss = ieee80211_rx_bss_get(dev, bssid, local->hw.conf.channel,
+	    (bss = ieee80211_rx_bss_get(dev, bssid,
+	    				local->hw.conf.channel->center_freq,
 					ifsta->ssid, ifsta->ssid_len))) {
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID %s"
 		       " based on configured SSID\n",
@@ -2743,13 +2737,13 @@ static int ieee80211_sta_find_ibss(struc
 		if (time_after(jiffies, ifsta->ibss_join_req +
 			       IEEE80211_IBSS_JOIN_TIMEOUT)) {
 			if ((ifsta->flags & IEEE80211_STA_CREATE_IBSS) &&
-			    local->oper_channel->flag & IEEE80211_CHAN_W_IBSS)
+			    (!(local->oper_channel->flags &
+			    		IEEE80211_CHANFL_NO_IBSS)))
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
@@ -2782,18 +2776,24 @@ int ieee80211_sta_set_ssid(struct net_de
 		int i;
 
 		memset(&qparam, 0, sizeof(qparam));
+
 		/* TODO: are these ok defaults for all hw_modes? */
 		qparam.aifs = 2;
-		qparam.cw_min =
-			local->hw.conf.phymode == MODE_IEEE80211B ? 31 : 15;
+
+		/* TODO: should be B mode dependent?? */
+		if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ)
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
@@ -2961,7 +2961,7 @@ void ieee80211_sta_scan_work(struct work
 		container_of(work, struct ieee80211_local, scan_work.work);
 	struct net_device *dev = local->scan_dev;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 	int skip;
 	unsigned long next_delay = 0;
@@ -2971,44 +2971,47 @@ void ieee80211_sta_scan_work(struct work
 
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
+		if (chan->flags & IEEE80211_CHANFL_DISABLED ||
 		    (sdata->type == IEEE80211_IF_TYPE_IBSS &&
-		     !(chan->flag & IEEE80211_CHAN_W_IBSS)) ||
-		    (local->hw_modes & local->enabled_modes &
-		     (1 << MODE_IEEE80211G) && mode->mode == MODE_IEEE80211B))
+		     chan->flags & IEEE80211_CHANFL_NO_IBSS))
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
@@ -3019,13 +3022,14 @@ void ieee80211_sta_scan_work(struct work
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
+		if (local->scan_channel->flags & IEEE80211_CHANFL_PASSIVE_SCAN)
+			break;
+		ieee80211_send_probe_req(dev, NULL, local->scan_ssid,
+					 local->scan_ssid_len);
+		next_delay = IEEE80211_CHANNEL_TIME;
 		break;
 	}
 
@@ -3100,10 +3104,8 @@ static int ieee80211_sta_start_scan(stru
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
@@ -3158,9 +3160,6 @@ ieee80211_sta_scan_result(struct net_dev
 		       bss->last_update + IEEE80211_SCAN_RESULT_EXPIRE))
 		return current_ev;
 
-	if (!(local->enabled_modes & (1 << bss->hw_mode)))
-		return current_ev;
-
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = SIOCGIWAP;
 	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
@@ -3188,12 +3187,15 @@ ieee80211_sta_scan_result(struct net_dev
 
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
 
--- everything.orig/net/mac80211/sta_info.c	2007-12-14 01:57:47.449835016 +0100
+++ everything/net/mac80211/sta_info.c	2007-12-14 01:57:48.909834093 +0100
@@ -76,12 +76,13 @@ EXPORT_SYMBOL(sta_info_get);
 int sta_info_min_txrate_get(struct ieee80211_local *local)
 {
 	struct sta_info *sta;
-	struct ieee80211_hw_mode *mode;
 	int min_txrate = 9999999;
 	int i;
+	struct ieee80211_supported_band *sband;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	read_lock_bh(&local->sta_lock);
-	mode = local->oper_hw_mode;
 	for (i = 0; i < STA_HASH_SIZE; i++) {
 		sta = local->sta_hash[i];
 		while (sta) {
@@ -91,10 +92,11 @@ int sta_info_min_txrate_get(struct ieee8
 		}
 	}
 	read_unlock_bh(&local->sta_lock);
+
 	if (min_txrate == 9999999)
 		min_txrate = 0;
 
-	return mode->rates[min_txrate].rate;
+	return sband->bitrates[min_txrate].bitrate;
 }
 
 
--- everything.orig/net/mac80211/Makefile	2007-12-14 01:55:59.049868436 +0100
+++ everything/net/mac80211/Makefile	2007-12-14 01:57:48.929838705 +0100
@@ -15,7 +15,6 @@ mac80211-objs := \
 	ieee80211_iface.o \
 	ieee80211_rate.o \
 	michael.o \
-	regdomain.o \
 	tkip.o \
 	aes_ccm.o \
 	cfg.o \
--- everything.orig/net/mac80211/regdomain.c	2007-12-14 01:55:59.019834527 +0100
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
--- everything.orig/net/mac80211/cfg.c	2007-12-14 01:57:48.339834907 +0100
+++ everything/net/mac80211/cfg.c	2007-12-14 01:57:48.959834853 +0100
@@ -479,7 +479,7 @@ static void sta_apply_parameters(struct 
 {
 	u32 rates;
 	int i, j;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 
 	if (params->station_flags & STATION_FLAG_CHANGED) {
 		sta->flags &= ~WLAN_STA_AUTHORIZED;
@@ -506,11 +506,12 @@ static void sta_apply_parameters(struct 
 
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
--- everything.orig/net/mac80211/rx.c	2007-12-14 01:57:47.159834636 +0100
+++ everything/net/mac80211/rx.c	2007-12-14 02:55:52.029514159 +0100
@@ -77,7 +77,6 @@ ieee80211_rx_monitor(struct ieee80211_lo
 		     struct ieee80211_rx_status *status)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_rate *rate;
 	int needed_headroom = 0;
 	struct ieee80211_radiotap_header *rthdr;
 	__le64 *rttsft = NULL;
@@ -186,14 +185,11 @@ ieee80211_rx_monitor(struct ieee80211_lo
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
@@ -289,47 +285,9 @@ ieee80211_rx_h_parse_qos(struct ieee8021
 static ieee80211_txrx_result
 ieee80211_rx_h_load_stats(struct ieee80211_txrx_data *rx)
 {
-	struct ieee80211_local *local = rx->local;
-	struct sk_buff *skb = rx->skb;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u32 load = 0, hdrtime;
-	struct ieee80211_rate *rate;
-	struct ieee80211_hw_mode *mode = local->hw.conf.mode;
-	int i;
-
 	/* Estimate total channel use caused by this frame */
 
-	if (unlikely(mode->num_rates < 0))
-		return TXRX_CONTINUE;
-
-	rate = &mode->rates[0];
-	for (i = 0; i < mode->num_rates; i++) {
-		if (mode->rates[i].val == rx->u.rx.status->rate) {
-			rate = &mode->rates[i];
-			break;
-		}
-	}
-
-	/* 1 bit at 1 Mbit/s takes 1 usec; in channel_use values,
-	 * 1 usec = 1/8 * (1080 / 10) = 13.5 */
-
-	if (mode->mode == MODE_IEEE80211A ||
-	    (mode->mode == MODE_IEEE80211G &&
-	     rate->flags & IEEE80211_RATE_ERP))
-		hdrtime = CHAN_UTIL_HDR_SHORT;
-	else
-		hdrtime = CHAN_UTIL_HDR_LONG;
-
-	load = hdrtime;
-	if (!is_multicast_ether_addr(hdr->addr1))
-		load += hdrtime;
-
-	load += skb->len * rate->rate_inv;
-
-	/* Divide channel_use by 8 to avoid wrapping around the counter */
-	load >>= CHAN_UTIL_SHIFT;
-	local->channel_use_raw += load;
-	rx->u.rx.load = load;
+	/* TODO. This was completely broken anyway... */
 
 	return TXRX_CONTINUE;
 }
--- everything.orig/net/mac80211/tx.c	2007-12-14 01:57:48.119834853 +0100
+++ everything/net/mac80211/tx.c	2007-12-14 12:13:15.168407931 +0100
@@ -90,11 +90,17 @@ static u16 ieee80211_duration(struct iee
 			      int next_frag_len)
 {
 	int rate, mrate, erp, dur, i;
-	struct ieee80211_rate *txrate = tx->u.tx.rate;
+	struct ieee80211_bitrate *txrate = tx->u.tx.rate;
 	struct ieee80211_local *local = tx->local;
-	struct ieee80211_hw_mode *mode = tx->u.tx.mode;
+	struct ieee80211_supported_band *sband;
 
-	erp = txrate->flags & IEEE80211_RATE_ERP;
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	erp = 0;
+#if TODO
+	if (tx->sdata->flags & OPERATING_IN_GMODE)
+		erp = txrate->flags & IEEE80211_RATEFL_ERP_G;
+#endif
 
 	/*
 	 * data and mgmt (except PS Poll):
@@ -150,20 +156,26 @@ static u16 ieee80211_duration(struct iee
 	 * Mandatory rates for IEEE 802.11g PHY: 1, 2, 5.5, 11, 6, 12, 24 Mbps
 	 */
 	rate = -1;
-	mrate = 10; /* use 1 Mbps if everything fails */
-	for (i = 0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *r = &mode->rates[i];
-		if (r->rate > txrate->rate)
-			break;
+	 /* use lowest available if everything fails */
+	mrate = sband->bitrates[0].bitrate;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		struct ieee80211_bitrate *r = &sband->bitrates[i];
 
-		if (IEEE80211_RATE_MODULATION(txrate->flags) !=
-		    IEEE80211_RATE_MODULATION(r->flags))
-			continue;
+		if (r->bitrate > txrate->bitrate)
+			break;
 
+#if TODO
+/*
+ * This needs to be fixed, it has to work like this:
+ *   * check the basic_rates set, if available
+ *   * check the mandatory rate flag depending on the configured
+ *     mode (either ours, or the BSS we're associated to)
+ */
 		if (r->flags & IEEE80211_RATE_BASIC)
 			rate = r->rate;
 		else if (r->flags & IEEE80211_RATE_MANDATORY)
 			mrate = r->rate;
+#endif
 	}
 	if (rate == -1) {
 		/* No matching basic rate found; use highest suitable mandatory
@@ -184,7 +196,7 @@ static u16 ieee80211_duration(struct iee
 		dur *= 2; /* ACK + SIFS */
 		/* next fragment */
 		dur += ieee80211_frame_duration(local, next_frag_len,
-				txrate->rate, erp,
+				txrate->bitrate, erp,
 				tx->sdata->flags &
 					IEEE80211_SDATA_SHORT_PREAMBLE);
 	}
@@ -589,27 +601,27 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 
 	if (likely(!tx->u.tx.rate)) {
 		memset(&extra, 0, sizeof(extra));
-		extra.mode = tx->u.tx.mode;
+		extra.band =
+			tx->local->hw.wiphy->bands[tx->local->hw.conf.channel->band];
 		extra.ethertype = tx->ethertype;
 
 		tx->u.tx.rate = rate_control_get_rate(tx->local, tx->dev,
 						      tx->skb, &extra);
-		if (unlikely(extra.probe != NULL)) {
+		if (unlikely(extra.probe)) {
 			tx->u.tx.control->flags |=
 				IEEE80211_TXCTL_RATE_CTRL_PROBE;
 			tx->flags |= IEEE80211_TXRXD_TXPROBE_LAST_FRAG;
-			tx->u.tx.control->alt_retry_rate = tx->u.tx.rate->val;
+			tx->u.tx.control->alt_retry_rate = tx->u.tx.rate;
 			tx->u.tx.rate = extra.probe;
 		} else
-			tx->u.tx.control->alt_retry_rate = -1;
+			tx->u.tx.control->alt_retry_rate = NULL;
 
 		if (!tx->u.tx.rate)
 			return TXRX_DROP;
 	} else
-		tx->u.tx.control->alt_retry_rate = -1;
+		tx->u.tx.control->alt_retry_rate = NULL;
 
-	if (tx->u.tx.mode->mode == MODE_IEEE80211G &&
-	    (tx->sdata->flags & IEEE80211_SDATA_USE_PROTECTION) &&
+	if ((tx->sdata->flags & IEEE80211_SDATA_USE_PROTECTION) &&
 	    (tx->flags & IEEE80211_TXRXD_FRAGMENTED) && extra.nonerp) {
 		tx->u.tx.last_frag_rate = tx->u.tx.rate;
 		if (extra.probe)
@@ -617,13 +629,11 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 		else
 			tx->flags |= IEEE80211_TXRXD_TXPROBE_LAST_FRAG;
 		tx->u.tx.rate = extra.nonerp;
-		tx->u.tx.control->rate = extra.nonerp;
 		tx->u.tx.control->flags &= ~IEEE80211_TXCTL_RATE_CTRL_PROBE;
-	} else {
+	} else
 		tx->u.tx.last_frag_rate = tx->u.tx.rate;
-		tx->u.tx.control->rate = tx->u.tx.rate;
-	}
-	tx->u.tx.control->tx_rate = tx->u.tx.rate->val;
+
+	tx->u.tx.control->tx_rate = tx->u.tx.rate;
 
 	return TXRX_CONTINUE;
 }
@@ -635,7 +645,6 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 	u16 fc = le16_to_cpu(hdr->frame_control);
 	u16 dur;
 	struct ieee80211_tx_control *control = tx->u.tx.control;
-	struct ieee80211_hw_mode *mode = tx->u.tx.mode;
 
 	if (!control->retry_limit) {
 		if (!is_multicast_ether_addr(hdr->addr1)) {
@@ -662,27 +671,29 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 		 * frames.
 		 * TODO: The last fragment could still use multiple retry
 		 * rates. */
-		control->alt_retry_rate = -1;
+		control->alt_retry_rate = NULL;
 	}
 
+#if TODO
 	/* Use CTS protection for unicast frames sent using extended rates if
 	 * there are associated non-ERP stations and RTS/CTS is not configured
 	 * for the frame. */
-	if (mode->mode == MODE_IEEE80211G &&
-	    (tx->u.tx.rate->flags & IEEE80211_RATE_ERP) &&
+	if ((tx->sdata->flags & OPERATING_IN_GMODE) &&
+	    (tx->u.tx.rate->flags & IEEE80211_RATEFL_ERP_G) &&
 	    (tx->flags & IEEE80211_TXRXD_TXUNICAST) &&
 	    (tx->sdata->flags & IEEE80211_SDATA_USE_PROTECTION) &&
 	    !(control->flags & IEEE80211_TXCTL_USE_RTS_CTS))
 		control->flags |= IEEE80211_TXCTL_USE_CTS_PROTECT;
+#endif
 
 	/* Transmit data frames using short preambles if the driver supports
 	 * short preambles at the selected rate and short preambles are
 	 * available on the network at the current point in time. */
 	if (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
-	    (tx->u.tx.rate->flags & IEEE80211_RATE_PREAMBLE2) &&
+	    (tx->u.tx.rate->flags & IEEE80211_RATEFL_SHORT_PREAMBLE) &&
 	    (tx->sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE) &&
 	    (!tx->sta || (tx->sta->flags & WLAN_STA_SHORT_PREAMBLE))) {
-		tx->u.tx.control->tx_rate = tx->u.tx.rate->val2;
+		tx->u.tx.control->flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
 	}
 
 	/* Setup duration field for the first fragment of the frame. Duration
@@ -695,19 +706,19 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 
 	if ((control->flags & IEEE80211_TXCTL_USE_RTS_CTS) ||
 	    (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)) {
-		struct ieee80211_rate *rate;
+		struct ieee80211_bitrate *rate;
 
 		/* Do not use multiple retry rates when using RTS/CTS */
-		control->alt_retry_rate = -1;
+		control->alt_retry_rate = NULL;
 
 		/* Use min(data rate, max base rate) as CTS/RTS rate */
 		rate = tx->u.tx.rate;
-		while (rate > mode->rates &&
+/* TODO		while (rate > mode->rates &&
 		       !(rate->flags & IEEE80211_RATE_BASIC))
 			rate--;
+ */
 
-		control->rts_cts_rate = rate->val;
-		control->rts_rate = rate;
+		control->rts_cts_rate = rate;
 	}
 
 	if (tx->sta) {
@@ -730,54 +741,7 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 static ieee80211_txrx_result
 ieee80211_tx_h_load_stats(struct ieee80211_txrx_data *tx)
 {
-	struct ieee80211_local *local = tx->local;
-	struct ieee80211_hw_mode *mode = tx->u.tx.mode;
-	struct sk_buff *skb = tx->skb;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u32 load = 0, hdrtime;
-
-	/* TODO: this could be part of tx_status handling, so that the number
-	 * of retries would be known; TX rate should in that case be stored
-	 * somewhere with the packet */
-
-	/* Estimate total channel use caused by this frame */
-
-	/* 1 bit at 1 Mbit/s takes 1 usec; in channel_use values,
-	 * 1 usec = 1/8 * (1080 / 10) = 13.5 */
-
-	if (mode->mode == MODE_IEEE80211A ||
-	    (mode->mode == MODE_IEEE80211G &&
-	     tx->u.tx.rate->flags & IEEE80211_RATE_ERP))
-		hdrtime = CHAN_UTIL_HDR_SHORT;
-	else
-		hdrtime = CHAN_UTIL_HDR_LONG;
-
-	load = hdrtime;
-	if (!is_multicast_ether_addr(hdr->addr1))
-		load += hdrtime;
-
-	if (tx->u.tx.control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
-		load += 2 * hdrtime;
-	else if (tx->u.tx.control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
-		load += hdrtime;
-
-	load += skb->len * tx->u.tx.rate->rate_inv;
-
-	if (tx->u.tx.extra_frag) {
-		int i;
-		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
-			load += 2 * hdrtime;
-			load += tx->u.tx.extra_frag[i]->len *
-				tx->u.tx.rate->rate;
-		}
-	}
-
-	/* Divide channel_use by 8 to avoid wrapping around the counter */
-	load >>= CHAN_UTIL_SHIFT;
-	local->channel_use_raw += load;
-	if (tx->sta)
-		tx->sta->channel_use_raw += load;
-	tx->sdata->channel_use_raw += load;
+	/* TODO: rewrite */
 
 	return TXRX_CONTINUE;
 }
@@ -821,10 +785,12 @@ __ieee80211_parse_tx_radiotap(struct iee
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
@@ -857,10 +823,12 @@ __ieee80211_parse_tx_radiotap(struct iee
 			 * ieee80211 rate int is in 100kbps units eg, 0x0a=1Mbps
 			 */
 			target_rate = (*iterator.this_arg) * 5;
-			for (i = 0; i < mode->num_rates; i++) {
-				struct ieee80211_rate *r = &mode->rates[i];
+			for (i = 0; i < sband->n_bitrates; i++) {
+				struct ieee80211_bitrate *r;
 
-				if (r->rate == target_rate) {
+				r = &sband->bitrates[i];
+
+				if (r->bitrate == target_rate) {
 					tx->u.tx.rate = r;
 					break;
 				}
@@ -876,7 +844,7 @@ __ieee80211_parse_tx_radiotap(struct iee
 			break;
 
 		case IEEE80211_RADIOTAP_DBM_TX_POWER:
-			control->power_level = *iterator.this_arg;
+			/* TODO control->power_level = *iterator.this_arg; */
 			break;
 
 		case IEEE80211_RADIOTAP_FLAGS:
@@ -1060,8 +1028,8 @@ static int __ieee80211_tx(struct ieee802
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
@@ -1120,7 +1088,6 @@ static int ieee80211_tx(struct net_devic
 	rcu_read_lock();
 
 	sta = tx.sta;
-	tx.u.tx.mode = local->hw.conf.mode;
 
 	for (handler = local->tx_handlers; *handler != NULL;
 	     handler++) {
@@ -1157,7 +1124,6 @@ static int ieee80211_tx(struct net_devic
 			} else {
 				next_len = 0;
 				tx.u.tx.rate = tx.u.tx.last_frag_rate;
-				tx.u.tx.last_frag_hwrate = tx.u.tx.rate->val;
 			}
 			dur = ieee80211_duration(&tx, 0, next_len);
 			hdr->duration_id = cpu_to_le16(dur);
@@ -1194,7 +1160,6 @@ retry:
 		store->skb = skb;
 		store->extra_frag = tx.u.tx.extra_frag;
 		store->num_extra_frag = tx.u.tx.num_extra_frag;
-		store->last_frag_hwrate = tx.u.tx.last_frag_hwrate;
 		store->last_frag_rate = tx.u.tx.last_frag_rate;
 		store->last_frag_rate_ctrl_probe =
 			!!(tx.flags & IEEE80211_TXRXD_TXPROBE_LAST_FRAG);
@@ -1574,7 +1539,6 @@ void ieee80211_tx_pending(unsigned long 
 		tx.u.tx.control = &store->control;
 		tx.u.tx.extra_frag = store->extra_frag;
 		tx.u.tx.num_extra_frag = store->num_extra_frag;
-		tx.u.tx.last_frag_hwrate = store->last_frag_hwrate;
 		tx.u.tx.last_frag_rate = store->last_frag_rate;
 		tx.flags = 0;
 		if (store->last_frag_rate_ctrl_probe)
@@ -1675,7 +1639,7 @@ struct sk_buff *ieee80211_beacon_get(str
 	struct net_device *bdev;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct ieee80211_if_ap *ap = NULL;
-	struct ieee80211_rate *rate;
+	struct ieee80211_bitrate *rate;
 	struct rate_control_extra extra;
 	struct beacon_data *beacon;
 
@@ -1717,7 +1681,6 @@ struct sk_buff *ieee80211_beacon_get(str
 
 	if (control) {
 		memset(&extra, 0, sizeof(extra));
-		extra.mode = local->oper_hw_mode;
 
 		rate = rate_control_get_rate(local, local->mdev, skb, &extra);
 		if (!rate) {
@@ -1730,12 +1693,11 @@ struct sk_buff *ieee80211_beacon_get(str
 			goto out;
 		}
 
-		control->tx_rate =
-			((sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE) &&
-			(rate->flags & IEEE80211_RATE_PREAMBLE2)) ?
-			rate->val2 : rate->val;
+		control->tx_rate = rate;
+		if (sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE &&
+		    rate->flags & IEEE80211_RATEFL_SHORT_PREAMBLE)
+			control->flags |= IEEE80211_TXCTL_SHORT_PREAMBLE;
 		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
-		control->power_level = local->hw.conf.power_level;
 		control->flags |= IEEE80211_TXCTL_NO_ACK;
 		control->retry_limit = 1;
 		control->flags |= IEEE80211_TXCTL_CLEAR_DST_MASK;
@@ -1839,7 +1801,6 @@ ieee80211_get_buffered_bc(struct ieee802
 	}
 	sta = tx.sta;
 	tx.flags |= IEEE80211_TXRXD_TXPS_BUFFERED;
-	tx.u.tx.mode = local->hw.conf.mode;
 
 	for (handler = local->tx_handlers; *handler != NULL; handler++) {
 		res = (*handler)(&tx);
--- everything.orig/net/mac80211/debugfs.c	2007-12-14 01:55:59.329835016 +0100
+++ everything/net/mac80211/debugfs.c	2007-12-14 01:57:48.979834636 +0100
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
--- everything.orig/net/mac80211/debugfs_sta.c	2007-12-14 01:55:59.409835450 +0100
+++ everything/net/mac80211/debugfs_sta.c	2007-12-14 01:57:48.979834636 +0100
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
--- everything.orig/net/mac80211/rc80211_simple.c	2007-12-14 01:55:59.549835070 +0100
+++ everything/net/mac80211/rc80211_simple.c	2007-12-14 01:57:48.999835070 +0100
@@ -32,7 +32,7 @@ static void rate_control_rate_inc(struct
 				  struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	int i = sta->txrate;
 	int maxrate;
 
@@ -42,16 +42,15 @@ static void rate_control_rate_inc(struct
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
 		if (sta->supp_rates & BIT(i) &&
-		    mode->rates[i].flags & IEEE80211_RATE_SUPPORTED &&
 		    (maxrate < 0 || i <= maxrate)) {
 			sta->txrate = i;
 			break;
@@ -64,7 +63,7 @@ static void rate_control_rate_dec(struct
 				  struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_hw_mode *mode;
+	struct ieee80211_supported_band *sband;
 	int i = sta->txrate;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
@@ -73,14 +72,13 @@ static void rate_control_rate_dec(struct
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
+		if (sta->supp_rates & BIT(i)) {
 			sta->txrate = i;
 			break;
 		}
@@ -88,22 +86,13 @@ static void rate_control_rate_dec(struct
 }
 
 
-static struct ieee80211_rate *
-rate_control_lowest_rate(struct ieee80211_local *local,
-			 struct ieee80211_hw_mode *mode)
+static struct ieee80211_bitrate *
+rate_control_lowest_rate(struct ieee80211_local *local)
 {
-	int i;
-
-	for (i = 0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *rate = &mode->rates[i];
-
-		if (rate->flags & IEEE80211_RATE_SUPPORTED)
-			return rate;
-	}
+	struct ieee80211_supported_band *sband;
 
-	printk(KERN_DEBUG "rate_control_lowest_rate - no supported rates "
-	       "found\n");
-	return &mode->rates[0];
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	return &sband->bitrates[0];
 }
 
 
@@ -185,7 +174,7 @@ static void rate_control_simple_tx_statu
 		} else if (per_failed < RATE_CONTROL_NUM_UP) {
 			rate_control_rate_inc(local, sta);
 		}
-		srctrl->tx_avg_rate_sum += status->control.rate->rate;
+		srctrl->tx_avg_rate_sum += status->control.tx_rate->bitrate;
 		srctrl->tx_avg_rate_num++;
 		srctrl->tx_num_failures = 0;
 		srctrl->tx_num_xmit = 0;
@@ -216,7 +205,7 @@ static void rate_control_simple_tx_statu
 }
 
 
-static struct ieee80211_rate *
+static struct ieee80211_bitrate *
 rate_control_simple_get_rate(void *priv, struct net_device *dev,
 			     struct sk_buff *skb,
 			     struct rate_control_extra *extra)
@@ -224,10 +213,12 @@ rate_control_simple_get_rate(void *priv,
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_hw_mode *mode = extra->mode;
 	struct sta_info *sta;
-	int rateidx, nonerp_idx;
+	int rateidx;
 	u16 fc;
+	struct ieee80211_supported_band *sband;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	memset(extra, 0, sizeof(*extra));
 
@@ -237,13 +228,13 @@ rate_control_simple_get_rate(void *priv,
 		/* Send management frames and broadcast/multicast data using
 		 * lowest rate. */
 		/* TODO: this could probably be improved.. */
-		return rate_control_lowest_rate(local, mode);
+		return rate_control_lowest_rate(local);
 	}
 
 	sta = sta_info_get(local, hdr->addr1);
 
 	if (!sta)
-		return rate_control_lowest_rate(local, mode);
+		return rate_control_lowest_rate(local);
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
@@ -251,9 +242,10 @@ rate_control_simple_get_rate(void *priv,
 
 	rateidx = sta->txrate;
 
-	if (rateidx >= mode->num_rates)
-		rateidx = mode->num_rates - 1;
+	if (rateidx >= sband->n_bitrates)
+		rateidx = sband->n_bitrates - 1;
 
+/* TODO
 	sta->last_txrate = rateidx;
 	nonerp_idx = rateidx;
 	while (nonerp_idx > 0 &&
@@ -262,10 +254,10 @@ rate_control_simple_get_rate(void *priv,
 		!(sta->supp_rates & BIT(nonerp_idx))))
 		nonerp_idx--;
 	extra->nonerp = &mode->rates[nonerp_idx];
-
+*/
 	sta_info_put(sta);
 
-	return &mode->rates[rateidx];
+	return &sband->bitrates[rateidx];
 }
 
 
@@ -273,17 +265,19 @@ static void rate_control_simple_rate_ini
 					  struct ieee80211_local *local,
 					  struct sta_info *sta)
 {
-	struct ieee80211_hw_mode *mode;
 	int i;
+	struct ieee80211_supported_band *sband;
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
 	sta->txrate = 0;
-	mode = local->oper_hw_mode;
+
 	/* TODO: This routine should consider using RSSI from previous packets
 	 * as we need to have IEEE 802.1X auth succeed immediately after assoc..
 	 * Until that method is implemented, we will use the lowest supported rate
 	 * as a workaround, */
-	for (i = 0; i < mode->num_rates; i++) {
-		if ((sta->supp_rates & BIT(i)) &&
-		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED)) {
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if (sta->supp_rates & BIT(i)) {
 			sta->txrate = i;
 			break;
 		}
--- everything.orig/net/wireless/core.c	2007-12-14 01:57:47.919834961 +0100
+++ everything/net/wireless/core.c	2007-12-14 12:08:12.748408257 +0100
@@ -232,6 +232,35 @@ int wiphy_register(struct wiphy *wiphy)
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
+		if (!sband->n_channels || !sband->n_bitrates) {
+			WARN_ON(1);
+			return -EINVAL;
+		}
+
+		for (i = 0; i < sband->n_channels; i++)
+			sband->channels[i].band = band;
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
 
 	mutex_lock(&cfg80211_drv_mutex);
 
--- everything.orig/drivers/net/wireless/b43/b43.h	2007-12-14 01:57:48.749835395 +0100
+++ everything/drivers/net/wireless/b43/b43.h	2007-12-14 10:43:35.578418186 +0100
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
@@ -700,7 +696,6 @@ struct b43_wldev {
 	bool __using_pio;	/* Internal, use b43_using_pio(). */
 	bool bad_frames_preempt;	/* Use "Bad Frames Preemption" (default off) */
 	bool reg124_set_0x4;	/* Some variable to keep track of IRQ stuff. */
-	bool short_preamble;	/* TRUE, if short preamble is enabled. */
 	bool short_slot;	/* TRUE, if short slot timing is enabled. */
 	bool radio_hw_enable;	/* saved state of radio hardware enabled state */
 
--- everything.orig/drivers/net/wireless/b43/main.c	2007-12-14 01:57:48.749835395 +0100
+++ everything/drivers/net/wireless/b43/main.c	2007-12-14 10:59:11.168407553 +0100
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
+	RATETAB_ENT(B43_CCK_RATE_2MB, IEEE80211_RATEFL_SHORT_PREAMBLE),
+	RATETAB_ENT(B43_CCK_RATE_5MB, IEEE80211_RATEFL_SHORT_PREAMBLE),
+	RATETAB_ENT(B43_CCK_RATE_11MB, IEEE80211_RATEFL_SHORT_PREAMBLE),
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
@@ -1155,8 +1166,7 @@ static void queue_beacon(void *data, u8 
 	memset(&control, 0, sizeof(control));
 	control.flags = IEEE80211_TXCTL_DO_NOT_ENCRYPT |
 			IEEE80211_TXCTL_NO_ACK;
-	control.tx_rate = B43_CCK_RATE_1MB;;
-	control.alt_retry_rate = -1;
+	control.tx_rate = &b43_b_ratetable[0];
 
 	skb = ieee80211_beacon_get(wl->hw, vif, NULL);
 	if (!skb)
@@ -2928,14 +2938,12 @@ static int b43_op_config(struct ieee8021
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
@@ -2961,8 +2969,8 @@ static int b43_op_config(struct ieee8021
 
 	/* Switch to the requested channel.
 	 * The firmware takes care of races with the TX handler. */
-	if (conf->channel_val != phy->channel)
-		b43_radio_selectchannel(dev, conf->channel_val, 0);
+	if (conf->channel->hw_value != phy->channel)
+		b43_radio_selectchannel(dev, conf->channel->hw_value, 0);
 
 	/* Enable/Disable ShortSlot timing. */
 	if ((!!(conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME)) !=
@@ -2976,6 +2984,7 @@ static int b43_op_config(struct ieee8021
 
 	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_RADIOTAP);
 
+#if TODO
 	/* Adjust the desired TX power level. */
 	if (conf->power_level != 0) {
 		if (conf->power_level != phy->power_level) {
@@ -2983,6 +2992,7 @@ static int b43_op_config(struct ieee8021
 			b43_phy_xmitpower(dev);
 		}
 	}
+#endif
 
 	/* Antennas for RX and management frame TX. */
 	b43_mgmtframe_txantenna(dev, antenna_tx);
@@ -4090,10 +4100,8 @@ static int b43_setup_modes(struct b43_wl
 			   int have_aphy, int have_bphy, int have_gphy)
 {
 	struct ieee80211_hw *hw = dev->wl->hw;
-	struct ieee80211_hw_mode *mode;
 	struct b43_phy *phy = &dev->phy;
 	int cnt = 0;
-	int err;
 
 /*FIXME: Don't tell ieee80211 about an A-PHY, because we currently don't support A-PHY. */
 	have_aphy = 0;
@@ -4101,52 +4109,22 @@ static int b43_setup_modes(struct b43_wl
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
--- everything.orig/drivers/net/wireless/b43/xmit.c	2007-12-14 01:57:47.319833931 +0100
+++ everything/drivers/net/wireless/b43/xmit.c	2007-12-14 11:54:26.078408148 +0100
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
--- everything.orig/net/wireless/Makefile	2007-12-14 01:59:26.499866537 +0100
+++ everything/net/wireless/Makefile	2007-12-14 12:07:30.478407823 +0100
@@ -1,5 +1,5 @@
 obj-$(CONFIG_WIRELESS_EXT) += wext.o
 obj-$(CONFIG_CFG80211) += cfg80211.o
 
-cfg80211-y += core.o sysfs.o radiotap.o
+cfg80211-y += core.o sysfs.o radiotap.o util.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
--- everything.orig/drivers/net/wireless/b43/sysfs.c	2007-12-14 10:43:22.148410699 +0100
+++ everything/drivers/net/wireless/b43/sysfs.c	2007-12-14 11:02:58.848413085 +0100
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
--- everything.orig/net/wireless/core.h	2007-12-14 11:42:00.088408637 +0100
+++ everything/net/wireless/core.h	2007-12-14 12:07:08.068406846 +0100
@@ -78,4 +78,6 @@ extern void cfg80211_dev_free(struct cfg
 extern int cfg80211_dev_rename(struct cfg80211_registered_device *drv,
 			       char *newname);
 
+void ieee80211_set_bitrate_flags(struct wiphy *wiphy);
+
 #endif /* __NET_WIRELESS_CORE_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/net/wireless/util.c	2007-12-14 12:09:56.178404786 +0100
@@ -0,0 +1,97 @@
+/*
+ * Wireless utility functions
+ *
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ */
+#include <net/wireless.h>
+#include <asm/bitops.h>
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
+					IEEE80211_RATEFL_MANDATORY_A;
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
+					IEEE80211_RATEFL_MANDATORY_B |
+					IEEE80211_RATEFL_MANDATORY_G;
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
+					IEEE80211_RATEFL_MANDATORY_G;
+				want--;
+			}
+
+			if (sband->bitrates[i].bitrate == 10 ||
+			    sband->bitrates[i].bitrate == 20 ||
+			    sband->bitrates[i].bitrate == 55 ||
+			    sband->bitrates[i].bitrate == 110)
+				sband->bitrates[i].flags |=
+					IEEE80211_RATEFL_ERP_G;
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


