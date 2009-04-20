Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44442 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbZDTMcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 08:32:20 -0400
Subject: [PATCH] cfg80211: clean up includes
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 14:31:42 +0200
Message-Id: <1240230702.28218.2.camel@johannes.local> (sfid-20090420_143227_191389_61CB7948)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trying to separate header files into net/wireless.h and
net/cfg80211.h has been a source of confusion. Remove
net/wireless.h (because there also is the linux/wireless.h)
and subsume everything into net/cfg80211.h -- except the
definitions for regulatory structures which get moved to
a new header net/regulatory.h.

The "new" net/cfg80211.h is now divided into sections.

There are no real changes in this patch but code shuffling
and some very minor documentation fixes.

I have also, to make things reflect reality, put in a
copyright line for Luis to net/regulatory.h since that
is probably exclusively written by him but was formerly
in a file that only had my copyright line.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ar9170/ar9170.h |    2 
 drivers/net/wireless/ath/ar9170/usb.h    |    2 
 drivers/net/wireless/ath/ath9k/eeprom.h  |    2 
 drivers/net/wireless/ath/regd.c          |    1 
 drivers/net/wireless/ath/regd.h          |    1 
 drivers/net/wireless/rndis_wlan.c        |    1 
 include/net/cfg80211.h                   |  711 +++++++++++++++++++++++++------
 include/net/mac80211.h                   |    1 
 include/net/regulatory.h                 |  101 ++++
 include/net/wireless.h                   |  492 ---------------------
 net/mac80211/ht.c                        |    1 
 net/mac80211/ieee80211_i.h               |    1 
 net/mac80211/spectmgmt.c                 |    2 
 net/wireless/core.c                      |    1 
 net/wireless/core.h                      |    1 
 net/wireless/ibss.c                      |    1 
 net/wireless/reg.c                       |    1 
 net/wireless/util.c                      |    6 
 net/wireless/wext-compat.c               |    1 
 19 files changed, 691 insertions(+), 638 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-04-20 12:38:23.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-04-20 13:44:41.000000000 +0200
@@ -1,70 +1,217 @@
 #ifndef __NET_CFG80211_H
 #define __NET_CFG80211_H
+/*
+ * 802.11 device and configuration interface
+ *
+ * Copyright 2006-2009	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
 
+#include <linux/netdevice.h>
+#include <linux/debugfs.h>
+#include <linux/list.h>
 #include <linux/netlink.h>
 #include <linux/skbuff.h>
 #include <linux/nl80211.h>
 #include <linux/if_ether.h>
 #include <linux/ieee80211.h>
-#include <linux/wireless.h>
-#include <net/iw_handler.h>
-#include <net/genetlink.h>
+#include <net/regulatory.h>
+
 /* remove once we remove the wext stuff */
+#include <net/iw_handler.h>
+#include <linux/wireless.h>
+
 
 /*
- * 802.11 configuration in-kernel interface
- *
- * Copyright 2006, 2007	Johannes Berg <johannes@sipsolutions.net>
+ * wireless hardware capability structures
  */
 
 /**
- * struct vif_params - describes virtual interface parameters
- * @mesh_id: mesh ID to use
- * @mesh_id_len: length of the mesh ID
+ * enum ieee80211_band - supported frequency bands
+ *
+ * The bands are assigned this way because the supported
+ * bitrates differ in these bands.
+ *
+ * @IEEE80211_BAND_2GHZ: 2.4GHz ISM band
+ * @IEEE80211_BAND_5GHZ: around 5GHz band (4.9-5.7)
  */
-struct vif_params {
-       u8 *mesh_id;
-       int mesh_id_len;
+enum ieee80211_band {
+	IEEE80211_BAND_2GHZ,
+	IEEE80211_BAND_5GHZ,
+
+	/* keep last */
+	IEEE80211_NUM_BANDS
 };
 
-/* Radiotap header iteration
- *   implemented in net/wireless/radiotap.c
- *   docs in Documentation/networking/radiotap-headers.txt
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
+ * @IEEE80211_CHAN_NO_FAT_ABOVE: extension channel above this channel
+ * 	is not permitted.
+ * @IEEE80211_CHAN_NO_FAT_BELOW: extension channel below this channel
+ * 	is not permitted.
  */
+enum ieee80211_channel_flags {
+	IEEE80211_CHAN_DISABLED		= 1<<0,
+	IEEE80211_CHAN_PASSIVE_SCAN	= 1<<1,
+	IEEE80211_CHAN_NO_IBSS		= 1<<2,
+	IEEE80211_CHAN_RADAR		= 1<<3,
+	IEEE80211_CHAN_NO_FAT_ABOVE	= 1<<4,
+	IEEE80211_CHAN_NO_FAT_BELOW	= 1<<5,
+};
+
 /**
- * struct ieee80211_radiotap_iterator - tracks walk thru present radiotap args
- * @rtheader: pointer to the radiotap header we are walking through
- * @max_length: length of radiotap header in cpu byte ordering
- * @this_arg_index: IEEE80211_RADIOTAP_... index of current arg
- * @this_arg: pointer to current radiotap arg
- * @arg_index: internal next argument index
- * @arg: internal next argument pointer
- * @next_bitmap: internal pointer to next present u32
- * @bitmap_shifter: internal shifter for curr u32 bitmap, b0 set == arg present
+ * struct ieee80211_channel - channel definition
+ *
+ * This structure describes a single channel for use
+ * with cfg80211.
+ *
+ * @center_freq: center frequency in MHz
+ * @max_bandwidth: maximum allowed bandwidth for this channel, in MHz
+ * @hw_value: hardware-specific value for the channel
+ * @flags: channel flags from &enum ieee80211_channel_flags.
+ * @orig_flags: channel flags at registration time, used by regulatory
+ *	code to support devices with additional restrictions
+ * @band: band this channel belongs to.
+ * @max_antenna_gain: maximum antenna gain in dBi
+ * @max_power: maximum transmission power (in dBm)
+ * @beacon_found: helper to regulatory code to indicate when a beacon
+ *	has been found on this channel. Use regulatory_hint_found_beacon()
+ *	to enable this, this is is useful only on 5 GHz band.
+ * @orig_mag: internal use
+ * @orig_mpwr: internal use
  */
+struct ieee80211_channel {
+	enum ieee80211_band band;
+	u16 center_freq;
+	u8 max_bandwidth;
+	u16 hw_value;
+	u32 flags;
+	int max_antenna_gain;
+	int max_power;
+	bool beacon_found;
+	u32 orig_flags;
+	int orig_mag, orig_mpwr;
+};
 
-struct ieee80211_radiotap_iterator {
-	struct ieee80211_radiotap_header *rtheader;
-	int max_length;
-	int this_arg_index;
-	u8 *this_arg;
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
 
-	int arg_index;
-	u8 *arg;
-	__le32 *next_bitmap;
-	u32 bitmap_shifter;
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
 };
 
-extern int ieee80211_radiotap_iterator_init(
-   struct ieee80211_radiotap_iterator *iterator,
-   struct ieee80211_radiotap_header *radiotap_header,
-   int max_length);
+/**
+ * struct ieee80211_sta_ht_cap - STA's HT capabilities
+ *
+ * This structure describes most essential parameters needed
+ * to describe 802.11n HT capabilities for an STA.
+ *
+ * @ht_supported: is HT supported by the STA
+ * @cap: HT capabilities map as described in 802.11n spec
+ * @ampdu_factor: Maximum A-MPDU length factor
+ * @ampdu_density: Minimum A-MPDU spacing
+ * @mcs: Supported MCS rates
+ */
+struct ieee80211_sta_ht_cap {
+	u16 cap; /* use IEEE80211_HT_CAP_ */
+	bool ht_supported;
+	u8 ampdu_factor;
+	u8 ampdu_density;
+	struct ieee80211_mcs_info mcs;
+};
 
-extern int ieee80211_radiotap_iterator_next(
-   struct ieee80211_radiotap_iterator *iterator);
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
+	struct ieee80211_sta_ht_cap ht_cap;
+};
 
+/*
+ * Wireless hardware/device configuration structures and methods
+ */
 
- /**
+/**
+ * struct vif_params - describes virtual interface parameters
+ * @mesh_id: mesh ID to use
+ * @mesh_id_len: length of the mesh ID
+ */
+struct vif_params {
+       u8 *mesh_id;
+       int mesh_id_len;
+};
+
+/**
  * struct key_params - key information
  *
  * Information about a key
@@ -347,92 +494,6 @@ struct bss_parameters {
 	u8 basic_rates_len;
 };
 
-/**
- * enum environment_cap - Environment parsed from country IE
- * @ENVIRON_ANY: indicates country IE applies to both indoor and
- *	outdoor operation.
- * @ENVIRON_INDOOR: indicates country IE applies only to indoor operation
- * @ENVIRON_OUTDOOR: indicates country IE applies only to outdoor operation
- */
-enum environment_cap {
-	ENVIRON_ANY,
-	ENVIRON_INDOOR,
-	ENVIRON_OUTDOOR,
-};
-
-/**
- * struct regulatory_request - used to keep track of regulatory requests
- *
- * @wiphy_idx: this is set if this request's initiator is
- * 	%REGDOM_SET_BY_COUNTRY_IE or %REGDOM_SET_BY_DRIVER. This
- * 	can be used by the wireless core to deal with conflicts
- * 	and potentially inform users of which devices specifically
- * 	cased the conflicts.
- * @initiator: indicates who sent this request, could be any of
- * 	of those set in nl80211_reg_initiator (%NL80211_REGDOM_SET_BY_*)
- * @alpha2: the ISO / IEC 3166 alpha2 country code of the requested
- * 	regulatory domain. We have a few special codes:
- * 	00 - World regulatory domain
- * 	99 - built by driver but a specific alpha2 cannot be determined
- * 	98 - result of an intersection between two regulatory domains
- * @intersect: indicates whether the wireless core should intersect
- * 	the requested regulatory domain with the presently set regulatory
- * 	domain.
- * @country_ie_checksum: checksum of the last processed and accepted
- * 	country IE
- * @country_ie_env: lets us know if the AP is telling us we are outdoor,
- * 	indoor, or if it doesn't matter
- * @list: used to insert into the reg_requests_list linked list
- */
-struct regulatory_request {
-	int wiphy_idx;
-	enum nl80211_reg_initiator initiator;
-	char alpha2[2];
-	bool intersect;
-	u32 country_ie_checksum;
-	enum environment_cap country_ie_env;
-	struct list_head list;
-};
-
-struct ieee80211_freq_range {
-	u32 start_freq_khz;
-	u32 end_freq_khz;
-	u32 max_bandwidth_khz;
-};
-
-struct ieee80211_power_rule {
-	u32 max_antenna_gain;
-	u32 max_eirp;
-};
-
-struct ieee80211_reg_rule {
-	struct ieee80211_freq_range freq_range;
-	struct ieee80211_power_rule power_rule;
-	u32 flags;
-};
-
-struct ieee80211_regdomain {
-	u32 n_reg_rules;
-	char alpha2[2];
-	struct ieee80211_reg_rule reg_rules[];
-};
-
-#define MHZ_TO_KHZ(freq) ((freq) * 1000)
-#define KHZ_TO_MHZ(freq) ((freq) / 1000)
-#define DBI_TO_MBI(gain) ((gain) * 100)
-#define MBI_TO_DBI(gain) ((gain) / 100)
-#define DBM_TO_MBM(gain) ((gain) * 100)
-#define MBM_TO_DBM(gain) ((gain) / 100)
-
-#define REG_RULE(start, end, bw, gain, eirp, reg_flags) { \
-	.freq_range.start_freq_khz = MHZ_TO_KHZ(start), \
-	.freq_range.end_freq_khz = MHZ_TO_KHZ(end), \
-	.freq_range.max_bandwidth_khz = MHZ_TO_KHZ(bw), \
-	.power_rule.max_antenna_gain = DBI_TO_MBI(gain), \
-	.power_rule.max_eirp = DBM_TO_MBM(eirp), \
-	.flags = reg_flags, \
-	}
-
 struct mesh_config {
 	/* Timeouts in ms */
 	/* Mesh plink management parameters */
@@ -853,7 +914,396 @@ struct cfg80211_ops {
 	int	(*leave_ibss)(struct wiphy *wiphy, struct net_device *dev);
 };
 
-/* temporary wext handlers */
+/*
+ * wireless hardware and networking interfaces structures
+ * and registration/helper functions
+ */
+
+/**
+ * struct wiphy - wireless hardware description
+ * @idx: the wiphy index assigned to this item
+ * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
+ * @custom_regulatory: tells us the driver for this device
+ * 	has its own custom regulatory domain and cannot identify the
+ * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
+ * 	we will disregard the first regulatory hint (when the
+ * 	initiator is %REGDOM_SET_BY_CORE).
+ * @strict_regulatory: tells us the driver for this device will ignore
+ * 	regulatory domain settings until it gets its own regulatory domain
+ * 	via its regulatory_hint(). After its gets its own regulatory domain
+ * 	it will only allow further regulatory domain settings to further
+ * 	enhance compliance. For example if channel 13 and 14 are disabled
+ * 	by this regulatory domain no user regulatory domain can enable these
+ * 	channels at a later time. This can be used for devices which do not
+ * 	have calibration information gauranteed for frequencies or settings
+ * 	outside of its regulatory domain.
+ * @reg_notifier: the driver's regulatory notification callback
+ * @regd: the driver's regulatory domain, if one was requested via
+ * 	the regulatory_hint() API. This can be used by the driver
+ *	on the reg_notifier() if it chooses to ignore future
+ *	regulatory domain changes caused by other drivers.
+ * @signal_type: signal type reported in &struct cfg80211_bss.
+ * @cipher_suites: supported cipher suites
+ * @n_cipher_suites: number of supported cipher suites
+ */
+struct wiphy {
+	/* assign these fields before you register the wiphy */
+
+	/* permanent MAC address */
+	u8 perm_addr[ETH_ALEN];
+
+	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
+	u16 interface_modes;
+
+	bool custom_regulatory;
+	bool strict_regulatory;
+
+	enum cfg80211_signal_type signal_type;
+
+	int bss_priv_size;
+	u8 max_scan_ssids;
+	u16 max_scan_ie_len;
+
+	int n_cipher_suites;
+	const u32 *cipher_suites;
+
+	/* If multiple wiphys are registered and you're handed e.g.
+	 * a regular netdev with assigned ieee80211_ptr, you won't
+	 * know whether it points to a wiphy your driver has registered
+	 * or not. Assign this to something global to your driver to
+	 * help determine whether you own this wiphy or not. */
+	void *privid;
+
+	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
+
+	/* Lets us get back the wiphy on the callback */
+	int (*reg_notifier)(struct wiphy *wiphy,
+			    struct regulatory_request *request);
+
+	/* fields below are read-only, assigned by cfg80211 */
+
+	const struct ieee80211_regdomain *regd;
+
+	/* the item in /sys/class/ieee80211/ points to this,
+	 * you need use set_wiphy_dev() (see below) */
+	struct device dev;
+
+	/* dir in debugfs: ieee80211/<wiphyname> */
+	struct dentry *debugfsdir;
+
+	char priv[0] __attribute__((__aligned__(NETDEV_ALIGN)));
+};
+
+/**
+ * wiphy_priv - return priv from wiphy
+ *
+ * @wiphy: the wiphy whose priv pointer to return
+ */
+static inline void *wiphy_priv(struct wiphy *wiphy)
+{
+	BUG_ON(!wiphy);
+	return &wiphy->priv;
+}
+
+/**
+ * set_wiphy_dev - set device pointer for wiphy
+ *
+ * @wiphy: The wiphy whose device to bind
+ * @dev: The device to parent it to
+ */
+static inline void set_wiphy_dev(struct wiphy *wiphy, struct device *dev)
+{
+	wiphy->dev.parent = dev;
+}
+
+/**
+ * wiphy_dev - get wiphy dev pointer
+ *
+ * @wiphy: The wiphy whose device struct to look up
+ */
+static inline struct device *wiphy_dev(struct wiphy *wiphy)
+{
+	return wiphy->dev.parent;
+}
+
+/**
+ * wiphy_name - get wiphy name
+ *
+ * @wiphy: The wiphy whose name to return
+ */
+static inline const char *wiphy_name(struct wiphy *wiphy)
+{
+	return dev_name(&wiphy->dev);
+}
+
+/**
+ * wiphy_new - create a new wiphy for use with cfg80211
+ *
+ * @ops: The configuration operations for this device
+ * @sizeof_priv: The size of the private area to allocate
+ *
+ * Create a new wiphy and associate the given operations with it.
+ * @sizeof_priv bytes are allocated for private use.
+ *
+ * The returned pointer must be assigned to each netdev's
+ * ieee80211_ptr for proper operation.
+ */
+struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv);
+
+/**
+ * wiphy_register - register a wiphy with cfg80211
+ *
+ * @wiphy: The wiphy to register.
+ *
+ * Returns a non-negative wiphy index or a negative error code.
+ */
+extern int wiphy_register(struct wiphy *wiphy);
+
+/**
+ * wiphy_unregister - deregister a wiphy from cfg80211
+ *
+ * @wiphy: The wiphy to unregister.
+ *
+ * After this call, no more requests can be made with this priv
+ * pointer, but the call may sleep to wait for an outstanding
+ * request that is being handled.
+ */
+extern void wiphy_unregister(struct wiphy *wiphy);
+
+/**
+ * wiphy_free - free wiphy
+ *
+ * @wiphy: The wiphy to free
+ */
+extern void wiphy_free(struct wiphy *wiphy);
+
+/**
+ * struct wireless_dev - wireless per-netdev state
+ *
+ * This structure must be allocated by the driver/stack
+ * that uses the ieee80211_ptr field in struct net_device
+ * (this is intentional so it can be allocated along with
+ * the netdev.)
+ *
+ * @wiphy: pointer to hardware description
+ * @iftype: interface type
+ * @list: (private) Used to collect the interfaces
+ * @netdev: (private) Used to reference back to the netdev
+ * @current_bss: (private) Used by the internal configuration code
+ * @bssid: (private) Used by the internal configuration code
+ * @ssid: (private) Used by the internal configuration code
+ * @ssid_len: (private) Used by the internal configuration code
+ * @wext: (private) Used by the internal wireless extensions compat code
+ * @wext_bssid: (private) Used by the internal wireless extensions compat code
+ */
+struct wireless_dev {
+	struct wiphy *wiphy;
+	enum nl80211_iftype iftype;
+
+	/* private to the generic wireless code */
+	struct list_head list;
+	struct net_device *netdev;
+
+	/* currently used for IBSS - might be rearranged in the future */
+	struct cfg80211_bss *current_bss;
+	u8 bssid[ETH_ALEN];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 ssid_len;
+
+#ifdef CONFIG_WIRELESS_EXT
+	/* wext data */
+	struct cfg80211_ibss_params wext;
+	u8 wext_bssid[ETH_ALEN];
+#endif
+};
+
+/**
+ * wdev_priv - return wiphy priv from wireless_dev
+ *
+ * @wdev: The wireless device whose wiphy's priv pointer to return
+ */
+static inline void *wdev_priv(struct wireless_dev *wdev)
+{
+	BUG_ON(!wdev);
+	return wiphy_priv(wdev->wiphy);
+}
+
+/*
+ * Utility functions
+ */
+
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
+/*
+ * Name indirection necessary because the ieee80211 code also has
+ * a function named "ieee80211_get_channel", so if you include
+ * cfg80211's header file you get cfg80211's version, if you try
+ * to include both header files you'll (rightfully!) get a symbol
+ * clash.
+ */
+extern struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
+							 int freq);
+/**
+ * ieee80211_get_channel - get channel struct from wiphy for specified frequency
+ */
+static inline struct ieee80211_channel *
+ieee80211_get_channel(struct wiphy *wiphy, int freq)
+{
+	return __ieee80211_get_channel(wiphy, freq);
+}
+
+/**
+ * ieee80211_get_response_rate - get basic rate for a given rate
+ *
+ * @sband: the band to look for rates in
+ * @basic_rates: bitmap of basic rates
+ * @bitrate: the bitrate for which to find the basic rate
+ *
+ * This function returns the basic rate corresponding to a given
+ * bitrate, that is the next lower bitrate contained in the basic
+ * rate map, which is, for this function, given as a bitmap of
+ * indices of rates in the band's bitrate table.
+ */
+struct ieee80211_rate *
+ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
+			    u32 basic_rates, int bitrate);
+
+/*
+ * Radiotap parsing functions -- for controlled injection support
+ *
+ * Implemented in net/wireless/radiotap.c
+ * Documentation in Documentation/networking/radiotap-headers.txt
+ */
+
+/**
+ * struct ieee80211_radiotap_iterator - tracks walk thru present radiotap args
+ * @rtheader: pointer to the radiotap header we are walking through
+ * @max_length: length of radiotap header in cpu byte ordering
+ * @this_arg_index: IEEE80211_RADIOTAP_... index of current arg
+ * @this_arg: pointer to current radiotap arg
+ * @arg_index: internal next argument index
+ * @arg: internal next argument pointer
+ * @next_bitmap: internal pointer to next present u32
+ * @bitmap_shifter: internal shifter for curr u32 bitmap, b0 set == arg present
+ */
+
+struct ieee80211_radiotap_iterator {
+	struct ieee80211_radiotap_header *rtheader;
+	int max_length;
+	int this_arg_index;
+	u8 *this_arg;
+
+	int arg_index;
+	u8 *arg;
+	__le32 *next_bitmap;
+	u32 bitmap_shifter;
+};
+
+extern int ieee80211_radiotap_iterator_init(
+   struct ieee80211_radiotap_iterator *iterator,
+   struct ieee80211_radiotap_header *radiotap_header,
+   int max_length);
+
+extern int ieee80211_radiotap_iterator_next(
+   struct ieee80211_radiotap_iterator *iterator);
+
+/*
+ * Regulatory helper functions for wiphys
+ */
+
+/**
+ * regulatory_hint - driver hint to the wireless core a regulatory domain
+ * @wiphy: the wireless device giving the hint (used only for reporting
+ *	conflicts)
+ * @alpha2: the ISO/IEC 3166 alpha2 the driver claims its regulatory domain
+ * 	should be in. If @rd is set this should be NULL. Note that if you
+ * 	set this to NULL you should still set rd->alpha2 to some accepted
+ * 	alpha2.
+ *
+ * Wireless drivers can use this function to hint to the wireless core
+ * what it believes should be the current regulatory domain by
+ * giving it an ISO/IEC 3166 alpha2 country code it knows its regulatory
+ * domain should be in or by providing a completely build regulatory domain.
+ * If the driver provides an ISO/IEC 3166 alpha2 userspace will be queried
+ * for a regulatory domain structure for the respective country.
+ *
+ * The wiphy must have been registered to cfg80211 prior to this call.
+ * For cfg80211 drivers this means you must first use wiphy_register(),
+ * for mac80211 drivers you must first use ieee80211_register_hw().
+ *
+ * Drivers should check the return value, its possible you can get
+ * an -ENOMEM.
+ */
+extern int regulatory_hint(struct wiphy *wiphy, const char *alpha2);
+
+/**
+ * regulatory_hint_11d - hints a country IE as a regulatory domain
+ * @wiphy: the wireless device giving the hint (used only for reporting
+ *	conflicts)
+ * @country_ie: pointer to the country IE
+ * @country_ie_len: length of the country IE
+ *
+ * We will intersect the rd with the what CRDA tells us should apply
+ * for the alpha2 this country IE belongs to, this prevents APs from
+ * sending us incorrect or outdated information against a country.
+ */
+extern void regulatory_hint_11d(struct wiphy *wiphy,
+				u8 *country_ie,
+				u8 country_ie_len);
+/**
+ * wiphy_apply_custom_regulatory - apply a custom driver regulatory domain
+ * @wiphy: the wireless device we want to process the regulatory domain on
+ * @regd: the custom regulatory domain to use for this wiphy
+ *
+ * Drivers can sometimes have custom regulatory domains which do not apply
+ * to a specific country. Drivers can use this to apply such custom regulatory
+ * domains. This routine must be called prior to wiphy registration. The
+ * custom regulatory domain will be trusted completely and as such previous
+ * default channel settings will be disregarded. If no rule is found for a
+ * channel on the regulatory domain the channel will be disabled.
+ */
+extern void wiphy_apply_custom_regulatory(
+	struct wiphy *wiphy,
+	const struct ieee80211_regdomain *regd);
+
+/**
+ * freq_reg_info - get regulatory information for the given frequency
+ * @wiphy: the wiphy for which we want to process this rule for
+ * @center_freq: Frequency in KHz for which we want regulatory information for
+ * @bandwidth: the bandwidth requirement you have in KHz, if you do not have one
+ * 	you can set this to 0. If this frequency is allowed we then set
+ * 	this value to the maximum allowed bandwidth.
+ * @reg_rule: the regulatory rule which we have for this frequency
+ *
+ * Use this function to get the regulatory rule for a specific frequency on
+ * a given wireless device. If the device has a specific regulatory domain
+ * it wants to follow we respect that unless a country IE has been received
+ * and processed already.
+ *
+ * Returns 0 if it was able to find a valid regulatory rule which does
+ * apply to the given center_freq otherwise it returns non-zero. It will
+ * also return -ERANGE if we determine the given center_freq does not even have
+ * a regulatory rule for a frequency range in the center_freq's band. See
+ * freq_in_rule_band() for our current definition of a band -- this is purely
+ * subjective and right now its 802.11 specific.
+ */
+extern int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
+			 const struct ieee80211_reg_rule **reg_rule);
+
+/*
+ * Temporary wext handlers & helper functions
+ *
+ * In the future cfg80211 will simply assign the entire wext handler
+ * structure to netdevs it manages, but we're not there yet.
+ */
 int cfg80211_wext_giwname(struct net_device *dev,
 			  struct iw_request_info *info,
 			  char *name, char *extra);
@@ -892,10 +1342,14 @@ int cfg80211_ibss_wext_giwap(struct net_
 			     struct iw_request_info *info,
 			     struct sockaddr *ap_addr, char *extra);
 
-/* wext helper for now (to be removed) */
 struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
 					     struct iw_freq *freq);
 
+/*
+ * callbacks for asynchronous cfg80211 methods, notification
+ * functions and BSS handling helpers
+ */
+
 /**
  * cfg80211_scan_done - notify that scan finished
  *
@@ -949,6 +1403,7 @@ struct cfg80211_bss *cfg80211_get_mesh(s
 				       const u8 *meshid, size_t meshidlen,
 				       const u8 *meshcfg);
 void cfg80211_put_bss(struct cfg80211_bss *bss);
+
 /**
  * cfg80211_unlink_bss - unlink BSS from internal data structures
  * @wiphy: the wiphy
--- wireless-testing.orig/include/net/wireless.h	2009-04-20 12:38:23.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,492 +0,0 @@
-#ifndef __NET_WIRELESS_H
-#define __NET_WIRELESS_H
-
-/*
- * 802.11 device management
- *
- * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
- */
-
-#include <linux/netdevice.h>
-#include <linux/debugfs.h>
-#include <linux/list.h>
-#include <linux/ieee80211.h>
-#include <net/cfg80211.h>
-
-/**
- * enum ieee80211_band - supported frequency bands
- *
- * The bands are assigned this way because the supported
- * bitrates differ in these bands.
- *
- * @IEEE80211_BAND_2GHZ: 2.4GHz ISM band
- * @IEEE80211_BAND_5GHZ: around 5GHz band (4.9-5.7)
- */
-enum ieee80211_band {
-	IEEE80211_BAND_2GHZ,
-	IEEE80211_BAND_5GHZ,
-
-	/* keep last */
-	IEEE80211_NUM_BANDS
-};
-
-/**
- * enum ieee80211_channel_flags - channel flags
- *
- * Channel flags set by the regulatory control code.
- *
- * @IEEE80211_CHAN_DISABLED: This channel is disabled.
- * @IEEE80211_CHAN_PASSIVE_SCAN: Only passive scanning is permitted
- *	on this channel.
- * @IEEE80211_CHAN_NO_IBSS: IBSS is not allowed on this channel.
- * @IEEE80211_CHAN_RADAR: Radar detection is required on this channel.
- * @IEEE80211_CHAN_NO_FAT_ABOVE: extension channel above this channel
- * 	is not permitted.
- * @IEEE80211_CHAN_NO_FAT_BELOW: extension channel below this channel
- * 	is not permitted.
- */
-enum ieee80211_channel_flags {
-	IEEE80211_CHAN_DISABLED		= 1<<0,
-	IEEE80211_CHAN_PASSIVE_SCAN	= 1<<1,
-	IEEE80211_CHAN_NO_IBSS		= 1<<2,
-	IEEE80211_CHAN_RADAR		= 1<<3,
-	IEEE80211_CHAN_NO_FAT_ABOVE	= 1<<4,
-	IEEE80211_CHAN_NO_FAT_BELOW	= 1<<5,
-};
-
-/**
- * struct ieee80211_channel - channel definition
- *
- * This structure describes a single channel for use
- * with cfg80211.
- *
- * @center_freq: center frequency in MHz
- * @max_bandwidth: maximum allowed bandwidth for this channel, in MHz
- * @hw_value: hardware-specific value for the channel
- * @flags: channel flags from &enum ieee80211_channel_flags.
- * @orig_flags: channel flags at registration time, used by regulatory
- *	code to support devices with additional restrictions
- * @band: band this channel belongs to.
- * @max_antenna_gain: maximum antenna gain in dBi
- * @max_power: maximum transmission power (in dBm)
- * @beacon_found: helper to regulatory code to indicate when a beacon
- *	has been found on this channel. Use regulatory_hint_found_beacon()
- *	to enable this, this is is useful only on 5 GHz band.
- * @orig_mag: internal use
- * @orig_mpwr: internal use
- */
-struct ieee80211_channel {
-	enum ieee80211_band band;
-	u16 center_freq;
-	u8 max_bandwidth;
-	u16 hw_value;
-	u32 flags;
-	int max_antenna_gain;
-	int max_power;
-	bool beacon_found;
-	u32 orig_flags;
-	int orig_mag, orig_mpwr;
-};
-
-/**
- * enum ieee80211_rate_flags - rate flags
- *
- * Hardware/specification flags for rates. These are structured
- * in a way that allows using the same bitrate structure for
- * different bands/PHY modes.
- *
- * @IEEE80211_RATE_SHORT_PREAMBLE: Hardware can send with short
- *	preamble on this bitrate; only relevant in 2.4GHz band and
- *	with CCK rates.
- * @IEEE80211_RATE_MANDATORY_A: This bitrate is a mandatory rate
- *	when used with 802.11a (on the 5 GHz band); filled by the
- *	core code when registering the wiphy.
- * @IEEE80211_RATE_MANDATORY_B: This bitrate is a mandatory rate
- *	when used with 802.11b (on the 2.4 GHz band); filled by the
- *	core code when registering the wiphy.
- * @IEEE80211_RATE_MANDATORY_G: This bitrate is a mandatory rate
- *	when used with 802.11g (on the 2.4 GHz band); filled by the
- *	core code when registering the wiphy.
- * @IEEE80211_RATE_ERP_G: This is an ERP rate in 802.11g mode.
- */
-enum ieee80211_rate_flags {
-	IEEE80211_RATE_SHORT_PREAMBLE	= 1<<0,
-	IEEE80211_RATE_MANDATORY_A	= 1<<1,
-	IEEE80211_RATE_MANDATORY_B	= 1<<2,
-	IEEE80211_RATE_MANDATORY_G	= 1<<3,
-	IEEE80211_RATE_ERP_G		= 1<<4,
-};
-
-/**
- * struct ieee80211_rate - bitrate definition
- *
- * This structure describes a bitrate that an 802.11 PHY can
- * operate with. The two values @hw_value and @hw_value_short
- * are only for driver use when pointers to this structure are
- * passed around.
- *
- * @flags: rate-specific flags
- * @bitrate: bitrate in units of 100 Kbps
- * @hw_value: driver/hardware value for this rate
- * @hw_value_short: driver/hardware value for this rate when
- *	short preamble is used
- */
-struct ieee80211_rate {
-	u32 flags;
-	u16 bitrate;
-	u16 hw_value, hw_value_short;
-};
-
-/**
- * struct ieee80211_sta_ht_cap - STA's HT capabilities
- *
- * This structure describes most essential parameters needed
- * to describe 802.11n HT capabilities for an STA.
- *
- * @ht_supported: is HT supported by the STA
- * @cap: HT capabilities map as described in 802.11n spec
- * @ampdu_factor: Maximum A-MPDU length factor
- * @ampdu_density: Minimum A-MPDU spacing
- * @mcs: Supported MCS rates
- */
-struct ieee80211_sta_ht_cap {
-	u16 cap; /* use IEEE80211_HT_CAP_ */
-	bool ht_supported;
-	u8 ampdu_factor;
-	u8 ampdu_density;
-	struct ieee80211_mcs_info mcs;
-};
-
-/**
- * struct ieee80211_supported_band - frequency band definition
- *
- * This structure describes a frequency band a wiphy
- * is able to operate in.
- *
- * @channels: Array of channels the hardware can operate in
- *	in this band.
- * @band: the band this structure represents
- * @n_channels: Number of channels in @channels
- * @bitrates: Array of bitrates the hardware can operate with
- *	in this band. Must be sorted to give a valid "supported
- *	rates" IE, i.e. CCK rates first, then OFDM.
- * @n_bitrates: Number of bitrates in @bitrates
- */
-struct ieee80211_supported_band {
-	struct ieee80211_channel *channels;
-	struct ieee80211_rate *bitrates;
-	enum ieee80211_band band;
-	int n_channels;
-	int n_bitrates;
-	struct ieee80211_sta_ht_cap ht_cap;
-};
-
-/**
- * struct wiphy - wireless hardware description
- * @idx: the wiphy index assigned to this item
- * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
- * @custom_regulatory: tells us the driver for this device
- * 	has its own custom regulatory domain and cannot identify the
- * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
- * 	we will disregard the first regulatory hint (when the
- * 	initiator is %REGDOM_SET_BY_CORE).
- * @strict_regulatory: tells us the driver for this device will ignore
- * 	regulatory domain settings until it gets its own regulatory domain
- * 	via its regulatory_hint(). After its gets its own regulatory domain
- * 	it will only allow further regulatory domain settings to further
- * 	enhance compliance. For example if channel 13 and 14 are disabled
- * 	by this regulatory domain no user regulatory domain can enable these
- * 	channels at a later time. This can be used for devices which do not
- * 	have calibration information gauranteed for frequencies or settings
- * 	outside of its regulatory domain.
- * @reg_notifier: the driver's regulatory notification callback
- * @regd: the driver's regulatory domain, if one was requested via
- * 	the regulatory_hint() API. This can be used by the driver
- *	on the reg_notifier() if it chooses to ignore future
- *	regulatory domain changes caused by other drivers.
- * @signal_type: signal type reported in &struct cfg80211_bss.
- * @cipher_suites: supported cipher suites
- * @n_cipher_suites: number of supported cipher suites
- */
-struct wiphy {
-	/* assign these fields before you register the wiphy */
-
-	/* permanent MAC address */
-	u8 perm_addr[ETH_ALEN];
-
-	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
-	u16 interface_modes;
-
-	bool custom_regulatory;
-	bool strict_regulatory;
-
-	enum cfg80211_signal_type signal_type;
-
-	int bss_priv_size;
-	u8 max_scan_ssids;
-	u16 max_scan_ie_len;
-
-	int n_cipher_suites;
-	const u32 *cipher_suites;
-
-	/* If multiple wiphys are registered and you're handed e.g.
-	 * a regular netdev with assigned ieee80211_ptr, you won't
-	 * know whether it points to a wiphy your driver has registered
-	 * or not. Assign this to something global to your driver to
-	 * help determine whether you own this wiphy or not. */
-	void *privid;
-
-	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
-
-	/* Lets us get back the wiphy on the callback */
-	int (*reg_notifier)(struct wiphy *wiphy,
-			    struct regulatory_request *request);
-
-	/* fields below are read-only, assigned by cfg80211 */
-
-	const struct ieee80211_regdomain *regd;
-
-	/* the item in /sys/class/ieee80211/ points to this,
-	 * you need use set_wiphy_dev() (see below) */
-	struct device dev;
-
-	/* dir in debugfs: ieee80211/<wiphyname> */
-	struct dentry *debugfsdir;
-
-	char priv[0] __attribute__((__aligned__(NETDEV_ALIGN)));
-};
-
-/** struct wireless_dev - wireless per-netdev state
- *
- * This structure must be allocated by the driver/stack
- * that uses the ieee80211_ptr field in struct net_device
- * (this is intentional so it can be allocated along with
- * the netdev.)
- *
- * @wiphy: pointer to hardware description
- * @iftype: interface type
- * @list: (private)
- * @netdev (private)
- */
-struct wireless_dev {
-	struct wiphy *wiphy;
-	enum nl80211_iftype iftype;
-
-	/* private to the generic wireless code */
-	struct list_head list;
-	struct net_device *netdev;
-
-	/* currently used for IBSS - might be rearranged in the future */
-	struct cfg80211_bss *current_bss;
-	u8 bssid[ETH_ALEN];
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
-	u8 ssid_len;
-
-#ifdef CONFIG_WIRELESS_EXT
-	/* wext data */
-	struct cfg80211_ibss_params wext;
-	u8 wext_bssid[ETH_ALEN];
-#endif
-};
-
-/**
- * wiphy_priv - return priv from wiphy
- */
-static inline void *wiphy_priv(struct wiphy *wiphy)
-{
-	BUG_ON(!wiphy);
-	return &wiphy->priv;
-}
-
-/**
- * set_wiphy_dev - set device pointer for wiphy
- */
-static inline void set_wiphy_dev(struct wiphy *wiphy, struct device *dev)
-{
-	wiphy->dev.parent = dev;
-}
-
-/**
- * wiphy_dev - get wiphy dev pointer
- */
-static inline struct device *wiphy_dev(struct wiphy *wiphy)
-{
-	return wiphy->dev.parent;
-}
-
-/**
- * wiphy_name - get wiphy name
- */
-static inline const char *wiphy_name(struct wiphy *wiphy)
-{
-	return dev_name(&wiphy->dev);
-}
-
-/**
- * wdev_priv - return wiphy priv from wireless_dev
- */
-static inline void *wdev_priv(struct wireless_dev *wdev)
-{
-	BUG_ON(!wdev);
-	return wiphy_priv(wdev->wiphy);
-}
-
-/**
- * wiphy_new - create a new wiphy for use with cfg80211
- *
- * create a new wiphy and associate the given operations with it.
- * @sizeof_priv bytes are allocated for private use.
- *
- * the returned pointer must be assigned to each netdev's
- * ieee80211_ptr for proper operation.
- */
-struct wiphy *wiphy_new(struct cfg80211_ops *ops, int sizeof_priv);
-
-/**
- * wiphy_register - register a wiphy with cfg80211
- *
- * register the given wiphy
- *
- * Returns a non-negative wiphy index or a negative error code.
- */
-extern int wiphy_register(struct wiphy *wiphy);
-
-/**
- * wiphy_unregister - deregister a wiphy from cfg80211
- *
- * unregister a device with the given priv pointer.
- * After this call, no more requests can be made with this priv
- * pointer, but the call may sleep to wait for an outstanding
- * request that is being handled.
- */
-extern void wiphy_unregister(struct wiphy *wiphy);
-
-/**
- * wiphy_free - free wiphy
- */
-extern void wiphy_free(struct wiphy *wiphy);
-
-/**
- * ieee80211_channel_to_frequency - convert channel number to frequency
- */
-extern int ieee80211_channel_to_frequency(int chan);
-
-/**
- * ieee80211_frequency_to_channel - convert frequency to channel number
- */
-extern int ieee80211_frequency_to_channel(int freq);
-
-/*
- * Name indirection necessary because the ieee80211 code also has
- * a function named "ieee80211_get_channel", so if you include
- * cfg80211's header file you get cfg80211's version, if you try
- * to include both header files you'll (rightfully!) get a symbol
- * clash.
- */
-extern struct ieee80211_channel *__ieee80211_get_channel(struct wiphy *wiphy,
-							 int freq);
-/**
- * ieee80211_get_channel - get channel struct from wiphy for specified frequency
- */
-static inline struct ieee80211_channel *
-ieee80211_get_channel(struct wiphy *wiphy, int freq)
-{
-	return __ieee80211_get_channel(wiphy, freq);
-}
-
-/**
- * ieee80211_get_response_rate - get basic rate for a given rate
- *
- * @sband: the band to look for rates in
- * @basic_rates: bitmap of basic rates
- * @bitrate: the bitrate for which to find the basic rate
- *
- * This function returns the basic rate corresponding to a given
- * bitrate, that is the next lower bitrate contained in the basic
- * rate map, which is, for this function, given as a bitmap of
- * indices of rates in the band's bitrate table.
- */
-struct ieee80211_rate *
-ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
-			    u32 basic_rates, int bitrate);
-
-/**
- * regulatory_hint - driver hint to the wireless core a regulatory domain
- * @wiphy: the wireless device giving the hint (used only for reporting
- *	conflicts)
- * @alpha2: the ISO/IEC 3166 alpha2 the driver claims its regulatory domain
- * 	should be in. If @rd is set this should be NULL. Note that if you
- * 	set this to NULL you should still set rd->alpha2 to some accepted
- * 	alpha2.
- *
- * Wireless drivers can use this function to hint to the wireless core
- * what it believes should be the current regulatory domain by
- * giving it an ISO/IEC 3166 alpha2 country code it knows its regulatory
- * domain should be in or by providing a completely build regulatory domain.
- * If the driver provides an ISO/IEC 3166 alpha2 userspace will be queried
- * for a regulatory domain structure for the respective country.
- *
- * The wiphy must have been registered to cfg80211 prior to this call.
- * For cfg80211 drivers this means you must first use wiphy_register(),
- * for mac80211 drivers you must first use ieee80211_register_hw().
- *
- * Drivers should check the return value, its possible you can get
- * an -ENOMEM.
- */
-extern int regulatory_hint(struct wiphy *wiphy, const char *alpha2);
-
-/**
- * regulatory_hint_11d - hints a country IE as a regulatory domain
- * @wiphy: the wireless device giving the hint (used only for reporting
- *	conflicts)
- * @country_ie: pointer to the country IE
- * @country_ie_len: length of the country IE
- *
- * We will intersect the rd with the what CRDA tells us should apply
- * for the alpha2 this country IE belongs to, this prevents APs from
- * sending us incorrect or outdated information against a country.
- */
-extern void regulatory_hint_11d(struct wiphy *wiphy,
-				u8 *country_ie,
-				u8 country_ie_len);
-/**
- * wiphy_apply_custom_regulatory - apply a custom driver regulatory domain
- * @wiphy: the wireless device we want to process the regulatory domain on
- * @regd: the custom regulatory domain to use for this wiphy
- *
- * Drivers can sometimes have custom regulatory domains which do not apply
- * to a specific country. Drivers can use this to apply such custom regulatory
- * domains. This routine must be called prior to wiphy registration. The
- * custom regulatory domain will be trusted completely and as such previous
- * default channel settings will be disregarded. If no rule is found for a
- * channel on the regulatory domain the channel will be disabled.
- */
-extern void wiphy_apply_custom_regulatory(
-	struct wiphy *wiphy,
-	const struct ieee80211_regdomain *regd);
-
-/**
- * freq_reg_info - get regulatory information for the given frequency
- * @wiphy: the wiphy for which we want to process this rule for
- * @center_freq: Frequency in KHz for which we want regulatory information for
- * @bandwidth: the bandwidth requirement you have in KHz, if you do not have one
- * 	you can set this to 0. If this frequency is allowed we then set
- * 	this value to the maximum allowed bandwidth.
- * @reg_rule: the regulatory rule which we have for this frequency
- *
- * Use this function to get the regulatory rule for a specific frequency on
- * a given wireless device. If the device has a specific regulatory domain
- * it wants to follow we respect that unless a country IE has been received
- * and processed already.
- *
- * Returns 0 if it was able to find a valid regulatory rule which does
- * apply to the given center_freq otherwise it returns non-zero. It will
- * also return -ERANGE if we determine the given center_freq does not even have
- * a regulatory rule for a frequency range in the center_freq's band. See
- * freq_in_rule_band() for our current definition of a band -- this is purely
- * subjective and right now its 802.11 specific.
- */
-extern int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
-			 const struct ieee80211_reg_rule **reg_rule);
-
-#endif /* __NET_WIRELESS_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/include/net/regulatory.h	2009-04-20 13:52:45.000000000 +0200
@@ -0,0 +1,101 @@
+#ifndef __NET_REGULATORY_H
+#define __NET_REGULATORY_H
+/*
+ * regulatory support structures
+ *
+ * Copyright 2008-2009	Luis R. Rodriguez <lrodriguez@atheros.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+
+/**
+ * enum environment_cap - Environment parsed from country IE
+ * @ENVIRON_ANY: indicates country IE applies to both indoor and
+ *	outdoor operation.
+ * @ENVIRON_INDOOR: indicates country IE applies only to indoor operation
+ * @ENVIRON_OUTDOOR: indicates country IE applies only to outdoor operation
+ */
+enum environment_cap {
+	ENVIRON_ANY,
+	ENVIRON_INDOOR,
+	ENVIRON_OUTDOOR,
+};
+
+/**
+ * struct regulatory_request - used to keep track of regulatory requests
+ *
+ * @wiphy_idx: this is set if this request's initiator is
+ * 	%REGDOM_SET_BY_COUNTRY_IE or %REGDOM_SET_BY_DRIVER. This
+ * 	can be used by the wireless core to deal with conflicts
+ * 	and potentially inform users of which devices specifically
+ * 	cased the conflicts.
+ * @initiator: indicates who sent this request, could be any of
+ * 	of those set in nl80211_reg_initiator (%NL80211_REGDOM_SET_BY_*)
+ * @alpha2: the ISO / IEC 3166 alpha2 country code of the requested
+ * 	regulatory domain. We have a few special codes:
+ * 	00 - World regulatory domain
+ * 	99 - built by driver but a specific alpha2 cannot be determined
+ * 	98 - result of an intersection between two regulatory domains
+ * @intersect: indicates whether the wireless core should intersect
+ * 	the requested regulatory domain with the presently set regulatory
+ * 	domain.
+ * @country_ie_checksum: checksum of the last processed and accepted
+ * 	country IE
+ * @country_ie_env: lets us know if the AP is telling us we are outdoor,
+ * 	indoor, or if it doesn't matter
+ * @list: used to insert into the reg_requests_list linked list
+ */
+struct regulatory_request {
+	int wiphy_idx;
+	enum nl80211_reg_initiator initiator;
+	char alpha2[2];
+	bool intersect;
+	u32 country_ie_checksum;
+	enum environment_cap country_ie_env;
+	struct list_head list;
+};
+
+struct ieee80211_freq_range {
+	u32 start_freq_khz;
+	u32 end_freq_khz;
+	u32 max_bandwidth_khz;
+};
+
+struct ieee80211_power_rule {
+	u32 max_antenna_gain;
+	u32 max_eirp;
+};
+
+struct ieee80211_reg_rule {
+	struct ieee80211_freq_range freq_range;
+	struct ieee80211_power_rule power_rule;
+	u32 flags;
+};
+
+struct ieee80211_regdomain {
+	u32 n_reg_rules;
+	char alpha2[2];
+	struct ieee80211_reg_rule reg_rules[];
+};
+
+#define MHZ_TO_KHZ(freq) ((freq) * 1000)
+#define KHZ_TO_MHZ(freq) ((freq) / 1000)
+#define DBI_TO_MBI(gain) ((gain) * 100)
+#define MBI_TO_DBI(gain) ((gain) / 100)
+#define DBM_TO_MBM(gain) ((gain) * 100)
+#define MBM_TO_DBM(gain) ((gain) / 100)
+
+#define REG_RULE(start, end, bw, gain, eirp, reg_flags) \
+{							\
+	.freq_range.start_freq_khz = MHZ_TO_KHZ(start),	\
+	.freq_range.end_freq_khz = MHZ_TO_KHZ(end),	\
+	.freq_range.max_bandwidth_khz = MHZ_TO_KHZ(bw),	\
+	.power_rule.max_antenna_gain = DBI_TO_MBI(gain),\
+	.power_rule.max_eirp = DBM_TO_MBM(eirp),	\
+	.flags = reg_flags,				\
+}
+
+#endif
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/ar9170.h	2009-04-20 13:41:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ar9170/ar9170.h	2009-04-20 13:42:01.000000000 +0200
@@ -40,7 +40,7 @@
 
 #include <linux/completion.h>
 #include <linux/spinlock.h>
-#include <net/wireless.h>
+#include <net/cfg80211.h>
 #include <net/mac80211.h>
 #ifdef CONFIG_AR9170_LEDS
 #include <linux/leds.h>
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/usb.h	2009-04-20 13:41:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ar9170/usb.h	2009-04-20 13:42:07.000000000 +0200
@@ -43,7 +43,7 @@
 #include <linux/completion.h>
 #include <linux/spinlock.h>
 #include <linux/leds.h>
-#include <net/wireless.h>
+#include <net/cfg80211.h>
 #include <net/mac80211.h>
 #include <linux/firmware.h>
 #include "eeprom.h"
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/eeprom.h	2009-04-20 13:41:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ath9k/eeprom.h	2009-04-20 13:47:09.000000000 +0200
@@ -17,7 +17,7 @@
 #ifndef EEPROM_H
 #define EEPROM_H
 
-#include <net/wireless.h>
+#include <net/cfg80211.h>
 
 #define AH_USE_EEPROM   0x1
 
--- wireless-testing.orig/drivers/net/wireless/ath/regd.c	2009-04-20 13:41:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/regd.c	2009-04-20 13:42:52.000000000 +0200
@@ -18,7 +18,6 @@
 #include <linux/slab.h>
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
-#include <net/wireless.h>
 #include "regd.h"
 #include "regd_common.h"
 
--- wireless-testing.orig/drivers/net/wireless/ath/regd.h	2009-04-20 13:41:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/regd.h	2009-04-20 13:42:54.000000000 +0200
@@ -20,7 +20,6 @@
 #include <linux/nl80211.h>
 
 #include <net/cfg80211.h>
-#include <net/wireless.h>
 
 #define NO_CTL 0xff
 #define SD_NO_CTL               0xE0
--- wireless-testing.orig/drivers/net/wireless/rndis_wlan.c	2009-04-20 13:41:50.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rndis_wlan.c	2009-04-20 13:42:56.000000000 +0200
@@ -42,7 +42,6 @@
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
 #include <net/iw_handler.h>
-#include <net/wireless.h>
 #include <net/cfg80211.h>
 #include <linux/usb/usbnet.h>
 #include <linux/usb/rndis_host.h>
--- wireless-testing.orig/include/net/mac80211.h	2009-04-20 13:41:50.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-04-20 13:42:58.000000000 +0200
@@ -19,7 +19,6 @@
 #include <linux/wireless.h>
 #include <linux/device.h>
 #include <linux/ieee80211.h>
-#include <net/wireless.h>
 #include <net/cfg80211.h>
 
 /**
--- wireless-testing.orig/net/mac80211/ht.c	2009-04-20 13:41:50.000000000 +0200
+++ wireless-testing/net/mac80211/ht.c	2009-04-20 13:42:59.000000000 +0200
@@ -14,7 +14,6 @@
  */
 
 #include <linux/ieee80211.h>
-#include <net/wireless.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "rate.h"
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-20 13:41:50.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-20 13:43:05.000000000 +0200
@@ -24,7 +24,6 @@
 #include <linux/spinlock.h>
 #include <linux/etherdevice.h>
 #include <net/cfg80211.h>
-#include <net/wireless.h>
 #include <net/iw_handler.h>
 #include <net/mac80211.h>
 #include "key.h"
--- wireless-testing.orig/net/mac80211/spectmgmt.c	2009-04-20 13:41:50.000000000 +0200
+++ wireless-testing/net/mac80211/spectmgmt.c	2009-04-20 13:43:12.000000000 +0200
@@ -15,7 +15,7 @@
  */
 
 #include <linux/ieee80211.h>
-#include <net/wireless.h>
+#include <net/cfg80211.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "sta_info.h"
--- wireless-testing.orig/net/wireless/core.c	2009-04-20 13:41:50.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-04-20 13:43:14.000000000 +0200
@@ -14,7 +14,6 @@
 #include <linux/device.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
-#include <net/wireless.h>
 #include "nl80211.h"
 #include "core.h"
 #include "sysfs.h"
--- wireless-testing.orig/net/wireless/core.h	2009-04-20 13:41:50.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-04-20 13:43:16.000000000 +0200
@@ -11,7 +11,6 @@
 #include <linux/kref.h>
 #include <linux/rbtree.h>
 #include <net/genetlink.h>
-#include <net/wireless.h>
 #include <net/cfg80211.h>
 #include "reg.h"
 
--- wireless-testing.orig/net/wireless/reg.c	2009-04-20 13:41:50.000000000 +0200
+++ wireless-testing/net/wireless/reg.c	2009-04-20 13:43:18.000000000 +0200
@@ -37,7 +37,6 @@
 #include <linux/random.h>
 #include <linux/nl80211.h>
 #include <linux/platform_device.h>
-#include <net/wireless.h>
 #include <net/cfg80211.h>
 #include "core.h"
 #include "reg.h"
--- wireless-testing.orig/net/wireless/util.c	2009-04-20 13:40:17.000000000 +0200
+++ wireless-testing/net/wireless/util.c	2009-04-20 13:43:24.000000000 +0200
@@ -1,10 +1,10 @@
 /*
  * Wireless utility functions
  *
- * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2007-2009	Johannes Berg <johannes@sipsolutions.net>
  */
-#include <net/wireless.h>
-#include <asm/bitops.h>
+#include <linux/bitops.h>
+#include <net/cfg80211.h>
 #include "core.h"
 
 struct ieee80211_rate *
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-04-20 13:41:50.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-04-20 13:43:26.000000000 +0200
@@ -12,7 +12,6 @@
 #include <linux/nl80211.h>
 #include <linux/if_arp.h>
 #include <net/iw_handler.h>
-#include <net/wireless.h>
 #include <net/cfg80211.h>
 #include "core.h"
 
--- wireless-testing.orig/net/wireless/ibss.c	2009-04-20 13:45:58.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-04-20 13:46:01.000000000 +0200
@@ -7,7 +7,6 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <net/cfg80211.h>
-#include <net/wireless.h>
 #include "nl80211.h"
 
 


