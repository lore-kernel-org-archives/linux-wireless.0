Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab0FGJMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 05:12:30 -0400
Subject: [PATCH] wireless: fix kernel-doc
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 11:12:27 +0200
Message-ID: <1275901947.3639.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a whole bunch of kernel-doc warnings
and errors that crop up when running it on
mac80211 and cfg80211; the latter isn't
normally done so lots of bit-rot happened.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |  117 ++++++++++++++++++++++++++++++++++++-------------
 include/net/mac80211.h |    4 -
 2 files changed, 90 insertions(+), 31 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-06-07 11:10:04.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-06-07 11:10:11.000000000 +0200
@@ -313,9 +313,10 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
 	IEEE80211_TX_CTL_LDPC			= BIT(22),
 	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
-#define IEEE80211_TX_CTL_STBC_SHIFT		23
 };
 
+#define IEEE80211_TX_CTL_STBC_SHIFT		23
+
 /**
  * enum mac80211_rate_control_flags - per-rate flags set by the
  *	Rate Control algorithm.
@@ -813,7 +814,6 @@ enum ieee80211_key_flags {
  *	encrypted in hardware.
  * @alg: The key algorithm.
  * @flags: key flags, see &enum ieee80211_key_flags.
- * @ap_addr: AP's MAC address
  * @keyidx: the key index (0-3)
  * @keylen: key material length
  * @key: key material. For ALG_TKIP the key is encoded as a 256-bit (32 byte)
--- wireless-testing.orig/include/net/cfg80211.h	2010-06-07 11:10:00.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-06-07 11:10:11.000000000 +0200
@@ -37,6 +37,7 @@
  *
  * @IEEE80211_BAND_2GHZ: 2.4GHz ISM band
  * @IEEE80211_BAND_5GHZ: around 5GHz band (4.9-5.7)
+ * @IEEE80211_NUM_BANDS: number of defined bands
  */
 enum ieee80211_band {
 	IEEE80211_BAND_2GHZ = NL80211_BAND_2GHZ,
@@ -188,6 +189,7 @@ struct ieee80211_sta_ht_cap {
  *	in this band. Must be sorted to give a valid "supported
  *	rates" IE, i.e. CCK rates first, then OFDM.
  * @n_bitrates: Number of bitrates in @bitrates
+ * @ht_cap: HT capabilities in this band
  */
 struct ieee80211_supported_band {
 	struct ieee80211_channel *channels;
@@ -225,6 +227,7 @@ struct vif_params {
  * @seq: sequence counter (IV/PN) for TKIP and CCMP keys, only used
  *	with the get_key() callback, must be in little endian,
  *	length given by @seq_len.
+ * @seq_len: length of @seq.
  */
 struct key_params {
 	u8 *key;
@@ -237,6 +240,8 @@ struct key_params {
 /**
  * enum survey_info_flags - survey information flags
  *
+ * @SURVEY_INFO_NOISE_DBM: noise (in dBm) was filled in
+ *
  * Used by the driver to indicate which info in &struct survey_info
  * it has filled in during the get_survey().
  */
@@ -247,13 +252,13 @@ enum survey_info_flags {
 /**
  * struct survey_info - channel survey response
  *
- * Used by dump_survey() to report back per-channel survey information.
- *
  * @channel: the channel this survey record reports, mandatory
  * @filled: bitflag of flags from &enum survey_info_flags
  * @noise: channel noise in dBm. This and all following fields are
  *     optional
  *
+ * Used by dump_survey() to report back per-channel survey information.
+ *
  * This structure can later be expanded with things like
  * channel duty cycle etc.
  */
@@ -288,7 +293,7 @@ struct beacon_parameters {
  *
  * @PLINK_ACTION_INVALID: action 0 is reserved
  * @PLINK_ACTION_OPEN: start mesh peer link establishment
- * @PLINK_ACTION_BLOCL: block traffic from this mesh peer
+ * @PLINK_ACTION_BLOCK: block traffic from this mesh peer
  */
 enum plink_actions {
 	PLINK_ACTION_INVALID,
@@ -311,6 +316,8 @@ enum plink_actions {
  *	(bitmask of BIT(NL80211_STA_FLAG_...))
  * @listen_interval: listen interval or -1 for no change
  * @aid: AID or zero for no change
+ * @plink_action: plink action to take
+ * @ht_capa: HT capabilities of station
  */
 struct station_parameters {
 	u8 *supported_rates;
@@ -448,13 +455,13 @@ enum monitor_flags {
  * Used by the driver to indicate which info in &struct mpath_info it has filled
  * in during get_station() or dump_station().
  *
- * MPATH_INFO_FRAME_QLEN: @frame_qlen filled
- * MPATH_INFO_SN: @sn filled
- * MPATH_INFO_METRIC: @metric filled
- * MPATH_INFO_EXPTIME: @exptime filled
- * MPATH_INFO_DISCOVERY_TIMEOUT: @discovery_timeout filled
- * MPATH_INFO_DISCOVERY_RETRIES: @discovery_retries filled
- * MPATH_INFO_FLAGS: @flags filled
+ * @MPATH_INFO_FRAME_QLEN: @frame_qlen filled
+ * @MPATH_INFO_SN: @sn filled
+ * @MPATH_INFO_METRIC: @metric filled
+ * @MPATH_INFO_EXPTIME: @exptime filled
+ * @MPATH_INFO_DISCOVERY_TIMEOUT: @discovery_timeout filled
+ * @MPATH_INFO_DISCOVERY_RETRIES: @discovery_retries filled
+ * @MPATH_INFO_FLAGS: @flags filled
  */
 enum mpath_info_flags {
 	MPATH_INFO_FRAME_QLEN		= BIT(0),
@@ -587,6 +594,7 @@ struct cfg80211_ssid {
  * @ie_len: length of ie in octets
  * @wiphy: the wiphy this was for
  * @dev: the interface
+ * @aborted: (internal) scan request was notified as aborted
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -623,6 +631,7 @@ enum cfg80211_signal_type {
  * This structure describes a BSS (which may also be a mesh network)
  * for use in scan results and similar.
  *
+ * @channel: channel this BSS is on
  * @bssid: BSSID of the BSS
  * @tsf: timestamp of last received update
  * @beacon_interval: the beacon interval as from the frame
@@ -826,8 +835,8 @@ struct cfg80211_ibss_params {
  * @ssid: SSID
  * @ssid_len: Length of ssid in octets
  * @auth_type: Authentication type (algorithm)
- * @assoc_ie: IEs for association request
- * @assoc_ie_len: Length of assoc_ie in octets
+ * @ie: IEs for association request
+ * @ie_len: Length of assoc_ie in octets
  * @privacy: indicates whether privacy-enabled APs should be used
  * @crypto: crypto settings
  * @key_len: length of WEP key for shared key authentication
@@ -850,10 +859,11 @@ struct cfg80211_connect_params {
 
 /**
  * enum wiphy_params_flags - set_wiphy_params bitfield values
- * WIPHY_PARAM_RETRY_SHORT: wiphy->retry_short has changed
- * WIPHY_PARAM_RETRY_LONG: wiphy->retry_long has changed
- * WIPHY_PARAM_FRAG_THRESHOLD: wiphy->frag_threshold has changed
- * WIPHY_PARAM_RTS_THRESHOLD: wiphy->rts_threshold has changed
+ * @WIPHY_PARAM_RETRY_SHORT: wiphy->retry_short has changed
+ * @WIPHY_PARAM_RETRY_LONG: wiphy->retry_long has changed
+ * @WIPHY_PARAM_FRAG_THRESHOLD: wiphy->frag_threshold has changed
+ * @WIPHY_PARAM_RTS_THRESHOLD: wiphy->rts_threshold has changed
+ * @WIPHY_PARAM_COVERAGE_CLASS: coverage class changed
  */
 enum wiphy_params_flags {
 	WIPHY_PARAM_RETRY_SHORT		= 1 << 0,
@@ -949,10 +959,16 @@ struct cfg80211_pmksa {
  * @del_beacon: Remove beacon configuration and stop sending the beacon.
  *
  * @add_station: Add a new station.
- *
  * @del_station: Remove a station; @mac may be NULL to remove all stations.
- *
  * @change_station: Modify a given station.
+ * @get_station: get station information for the station identified by @mac
+ * @dump_station: dump station callback -- resume dump at index @idx
+ *
+ * @add_mpath: add a fixed mesh path
+ * @del_mpath: delete a given mesh path
+ * @change_mpath: change a given mesh path
+ * @get_mpath: get a mesh path for the given parameters
+ * @dump_mpath: dump mesh path callback -- resume dump at index @idx
  *
  * @get_mesh_params: Put the current mesh parameters into *params
  *
@@ -960,8 +976,6 @@ struct cfg80211_pmksa {
  *	The mask is a bitfield which tells us which parameters to
  *	set, and which to leave alone.
  *
- * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
- *
  * @change_bss: Modify parameters for a given BSS.
  *
  * @set_txq_params: Set TX queue parameters
@@ -1002,6 +1016,8 @@ struct cfg80211_pmksa {
  * @get_tx_power: store the current TX power into the dbm variable;
  *	return 0 if successful
  *
+ * @set_wds_peer: set the WDS peer for a WDS interface
+ *
  * @rfkill_poll: polls the hw rfkill line, use cfg80211 reporting
  *	functions to adjust rfkill hw state
  *
@@ -1019,6 +1035,8 @@ struct cfg80211_pmksa {
  *
  * @testmode_cmd: run a test mode command
  *
+ * @set_bitrate_mask: set the bitrate mask configuration
+ *
  * @set_pmksa: Cache a PMKID for a BSSID. This is mostly useful for fullmac
  *	devices running firmwares capable of generating the (re) association
  *	RSN IE. It allows for faster roaming between WPA2 BSSIDs.
@@ -1231,8 +1249,6 @@ struct mac_address {
 
 /**
  * struct wiphy - wireless hardware description
- * @idx: the wiphy index assigned to this item
- * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
  * @reg_notifier: the driver's regulatory notification callback
  * @regd: the driver's regulatory domain, if one was requested via
  * 	the regulatory_hint() API. This can be used by the driver
@@ -1246,7 +1262,7 @@ struct mac_address {
  * @frag_threshold: Fragmentation threshold (dot11FragmentationThreshold);
  *	-1 = fragmentation disabled, only odd values >= 256 used
  * @rts_threshold: RTS threshold (dot11RTSThreshold); -1 = RTS/CTS disabled
- * @net: the network namespace this wiphy currently lives in
+ * @_net: the network namespace this wiphy currently lives in
  * @perm_addr: permanent MAC address of this device
  * @addr_mask: If the device supports multiple MAC addresses by masking,
  *	set this to a mask with variable bits set to 1, e.g. if the last
@@ -1259,6 +1275,28 @@ struct mac_address {
  *	by default for perm_addr. In this case, the mask should be set to
  *	all-zeroes. In this case it is assumed that the device can handle
  *	the same number of arbitrary MAC addresses.
+ * @debugfsdir: debugfs directory used for this wiphy, will be renamed
+ *	automatically on wiphy renames
+ * @dev: (virtual) struct device for this wiphy
+ * @wext: wireless extension handlers
+ * @priv: driver private data (sized according to wiphy_new() parameter)
+ * @interface_modes: bitmask of interfaces types valid for this wiphy,
+ *	must be set by driver
+ * @flags: wiphy flags, see &enum wiphy_flags
+ * @bss_priv_size: each BSS struct has private data allocated with it,
+ *	this variable determines its size
+ * @max_scan_ssids: maximum number of SSIDs the device can scan for in
+ *	any given scan
+ * @max_scan_ie_len: maximum length of user-controlled IEs device can
+ *	add to probe request frames transmitted during a scan, must not
+ *	include fixed IEs like supported rates
+ * @coverage_class: current coverage class
+ * @fw_version: firmware version for ethtool reporting
+ * @hw_version: hardware version for ethtool reporting
+ * @max_num_pmkids: maximum number of PMKIDs supported by device
+ * @privid: a pointer that drivers can use to identify if an arbitrary
+ *	wiphy is theirs, e.g. in global notifiers
+ * @bands: information about bands/channels supported by this device
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -1472,13 +1510,14 @@ struct cfg80211_cached_keys;
  * @ssid: (private) Used by the internal configuration code
  * @ssid_len: (private) Used by the internal configuration code
  * @wext: (private) Used by the internal wireless extensions compat code
- * @wext_bssid: (private) Used by the internal wireless extensions compat code
  * @use_4addr: indicates 4addr mode is used on this interface, must be
  *	set by driver (if supported) on add_interface BEFORE registering the
  *	netdev and may otherwise be used by driver read-only, will be update
  *	by cfg80211 on change_interface
  * @action_registrations: list of registrations for action frames
  * @action_registrations_lock: lock for the list
+ * @mtx: mutex used to lock data in this struct
+ * @cleanup_work: work struct used for cleanup that can't be done directly
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -1552,11 +1591,13 @@ static inline void *wdev_priv(struct wir
 
 /**
  * ieee80211_channel_to_frequency - convert channel number to frequency
+ * @chan: channel number
  */
 extern int ieee80211_channel_to_frequency(int chan);
 
 /**
  * ieee80211_frequency_to_channel - convert frequency to channel number
+ * @freq: center frequency
  */
 extern int ieee80211_frequency_to_channel(int freq);
 
@@ -1571,6 +1612,8 @@ extern struct ieee80211_channel *__ieee8
 							 int freq);
 /**
  * ieee80211_get_channel - get channel struct from wiphy for specified frequency
+ * @wiphy: the struct wiphy to get the channel for
+ * @freq: the center frequency of the channel
  */
 static inline struct ieee80211_channel *
 ieee80211_get_channel(struct wiphy *wiphy, int freq)
@@ -1631,9 +1674,6 @@ struct ieee80211_radiotap_vendor_namespa
  * @is_radiotap_ns: indicates whether the current namespace is the default
  *	radiotap namespace or not
  *
- * @overrides: override standard radiotap fields
- * @n_overrides: number of overrides
- *
  * @_rtheader: pointer to the radiotap header we are walking through
  * @_max_length: length of radiotap header in cpu byte ordering
  * @_arg_index: next argument index
@@ -1949,10 +1989,12 @@ int cfg80211_wext_giwap(struct net_devic
 void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted);
 
 /**
- * cfg80211_inform_bss - inform cfg80211 of a new BSS
+ * cfg80211_inform_bss_frame - inform cfg80211 of a received BSS frame
  *
  * @wiphy: the wiphy reporting the BSS
- * @bss: the found BSS
+ * @channel: The channel the frame was received on
+ * @mgmt: the management frame (probe response or beacon)
+ * @len: length of the management frame
  * @signal: the signal strength, type depends on the wiphy's signal_type
  * @gfp: context flags
  *
@@ -1965,6 +2007,23 @@ cfg80211_inform_bss_frame(struct wiphy *
 			  struct ieee80211_mgmt *mgmt, size_t len,
 			  s32 signal, gfp_t gfp);
 
+/**
+ * cfg80211_inform_bss - inform cfg80211 of a new BSS
+ *
+ * @wiphy: the wiphy reporting the BSS
+ * @channel: The channel the frame was received on
+ * @bssid: the BSSID of the BSS
+ * @timestamp: the TSF timestamp sent by the peer
+ * @capability: the capability field sent by the peer
+ * @beacon_interval: the beacon interval announced by the peer
+ * @ie: additional IEs sent by the peer
+ * @ielen: length of the additional IEs
+ * @signal: the signal strength, type depends on the wiphy's signal_type
+ * @gfp: context flags
+ *
+ * This informs cfg80211 that BSS information was found and
+ * the BSS should be updated/added.
+ */
 struct cfg80211_bss*
 cfg80211_inform_bss(struct wiphy *wiphy,
 		    struct ieee80211_channel *channel,


