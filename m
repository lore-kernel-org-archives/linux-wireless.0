Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:35419 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453Ab3DCNvs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 09:51:48 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: johannes@sipsolutions.net, rodrigue@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] crda: synch up nl80211.h
Date: Wed,  3 Apr 2013 15:51:16 +0200
Message-Id: <1364997076-14034-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130403_155157_971353_1F9EC819)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed to make DFS regulatory domain support work again.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 nl80211.h | 1207 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 1110 insertions(+), 97 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index 2dbb799..79da871 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -36,7 +36,21 @@
  * The station is still assumed to belong to the AP interface it was added
  * to.
  *
- * TODO: need more info?
+ * Station handling varies per interface type and depending on the driver's
+ * capabilities.
+ *
+ * For drivers supporting TDLS with external setup (WIPHY_FLAG_SUPPORTS_TDLS
+ * and WIPHY_FLAG_TDLS_EXTERNAL_SETUP), the station lifetime is as follows:
+ *  - a setup station entry is added, not yet authorized, without any rate
+ *    or capability information, this just exists to avoid race conditions
+ *  - when the TDLS setup is done, a single NL80211_CMD_SET_STATION is valid
+ *    to add rate and capability information to the station and at the same
+ *    time mark it authorized.
+ *  - %NL80211_TDLS_ENABLE_LINK is then used
+ *  - after this, the only valid operation is to remove it by tearing down
+ *    the TDLS link (%NL80211_TDLS_DISABLE_LINK)
+ *
+ * TODO: need more info for other interface types
  */
 
 /**
@@ -118,8 +132,9 @@
  *	to get a list of all present wiphys.
  * @NL80211_CMD_SET_WIPHY: set wiphy parameters, needs %NL80211_ATTR_WIPHY or
  *	%NL80211_ATTR_IFINDEX; can be used to set %NL80211_ATTR_WIPHY_NAME,
- *	%NL80211_ATTR_WIPHY_TXQ_PARAMS, %NL80211_ATTR_WIPHY_FREQ,
- *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE, %NL80211_ATTR_WIPHY_RETRY_SHORT,
+ *	%NL80211_ATTR_WIPHY_TXQ_PARAMS, %NL80211_ATTR_WIPHY_FREQ (and the
+ *	attributes determining the channel width; this is used for setting
+ *	monitor mode channel),  %NL80211_ATTR_WIPHY_RETRY_SHORT,
  *	%NL80211_ATTR_WIPHY_RETRY_LONG, %NL80211_ATTR_WIPHY_FRAG_THRESHOLD,
  *	and/or %NL80211_ATTR_WIPHY_RTS_THRESHOLD.
  *	However, for setting the channel, see %NL80211_CMD_SET_CHANNEL
@@ -156,21 +171,26 @@
  * @NL80211_CMD_DEL_KEY: delete a key identified by %NL80211_ATTR_KEY_IDX
  *	or %NL80211_ATTR_MAC.
  *
- * @NL80211_CMD_GET_BEACON: retrieve beacon information (returned in a
- *	%NL80222_CMD_NEW_BEACON message)
- * @NL80211_CMD_SET_BEACON: set the beacon on an access point interface
- *	using the %NL80211_ATTR_BEACON_INTERVAL, %NL80211_ATTR_DTIM_PERIOD,
- *	%NL80211_ATTR_BEACON_HEAD and %NL80211_ATTR_BEACON_TAIL attributes.
- *	Following attributes are provided for drivers that generate full Beacon
- *	and Probe Response frames internally: %NL80211_ATTR_SSID,
+ * @NL80211_CMD_GET_BEACON: (not used)
+ * @NL80211_CMD_SET_BEACON: change the beacon on an access point interface
+ *	using the %NL80211_ATTR_BEACON_HEAD and %NL80211_ATTR_BEACON_TAIL
+ *	attributes. For drivers that generate the beacon and probe responses
+ *	internally, the following attributes must be provided: %NL80211_ATTR_IE,
+ *	%NL80211_ATTR_IE_PROBE_RESP and %NL80211_ATTR_IE_ASSOC_RESP.
+ * @NL80211_CMD_START_AP: Start AP operation on an AP interface, parameters
+ *	are like for %NL80211_CMD_SET_BEACON, and additionally parameters that
+ *	do not change are used, these include %NL80211_ATTR_BEACON_INTERVAL,
+ *	%NL80211_ATTR_DTIM_PERIOD, %NL80211_ATTR_SSID,
  *	%NL80211_ATTR_HIDDEN_SSID, %NL80211_ATTR_CIPHERS_PAIRWISE,
  *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
  *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
- *	%NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_IE, %NL80211_ATTR_IE_PROBE_RESP,
- *	%NL80211_ATTR_IE_ASSOC_RESP.
- * @NL80211_CMD_NEW_BEACON: add a new beacon to an access point interface,
- *	parameters are like for %NL80211_CMD_SET_BEACON.
- * @NL80211_CMD_DEL_BEACON: remove the beacon, stop sending it
+ *	%NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_INACTIVITY_TIMEOUT,
+ *	%NL80211_ATTR_ACL_POLICY and %NL80211_ATTR_MAC_ADDRS.
+ *	The channel to use can be set on the interface or be given using the
+ *	%NL80211_ATTR_WIPHY_FREQ and the attributes determining channel width.
+ * @NL80211_CMD_NEW_BEACON: old alias for %NL80211_CMD_START_AP
+ * @NL80211_CMD_STOP_AP: Stop AP operation on the given interface
+ * @NL80211_CMD_DEL_BEACON: old alias for %NL80211_CMD_STOP_AP
  *
  * @NL80211_CMD_GET_STATION: Get station attributes for station identified by
  *	%NL80211_ATTR_MAC on the interface identified by %NL80211_ATTR_IFINDEX.
@@ -273,6 +293,12 @@
  * @NL80211_CMD_NEW_SURVEY_RESULTS: survey data notification (as a reply to
  *	NL80211_CMD_GET_SURVEY and on the "scan" multicast group)
  *
+ * @NL80211_CMD_SET_PMKSA: Add a PMKSA cache entry, using %NL80211_ATTR_MAC
+ *	(for the BSSID) and %NL80211_ATTR_PMKID.
+ * @NL80211_CMD_DEL_PMKSA: Delete a PMKSA cache entry, using %NL80211_ATTR_MAC
+ *	(for the BSSID) and %NL80211_ATTR_PMKID.
+ * @NL80211_CMD_FLUSH_PMKSA: Flush all PMKSA cache entries.
+ *
  * @NL80211_CMD_REG_CHANGE: indicates to userspace the regulatory domain
  * 	has been changed and provides details of the request information
  * 	that caused the change such as who initiated the regulatory request
@@ -363,10 +389,15 @@
  *	requests to connect to a specified network but without separating
  *	auth and assoc steps. For this, you need to specify the SSID in a
  *	%NL80211_ATTR_SSID attribute, and can optionally specify the association
- *	IEs in %NL80211_ATTR_IE, %NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_MAC,
- *	%NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
+ *	IEs in %NL80211_ATTR_IE, %NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_USE_MFP,
+ *	%NL80211_ATTR_MAC, %NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
  *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
  *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
+ *	Background scan period can optionally be
+ *	specified in %NL80211_ATTR_BG_SCAN_PERIOD,
+ *	if not specified default background scan configuration
+ *	in driver is used and if period value is 0, bg scan will be disabled.
+ *	This attribute is ignored if driver does not support roam scan.
  *	It is also sent as an event, with the BSSID and response IEs when the
  *	connection is established or failed to be established. This can be
  *	determined by the STATUS_CODE attribute.
@@ -386,8 +417,7 @@
  *	a response while being associated to an AP on another channel.
  *	%NL80211_ATTR_IFINDEX is used to specify which interface (and thus
  *	radio) is used. %NL80211_ATTR_WIPHY_FREQ is used to specify the
- *	frequency for the operation and %NL80211_ATTR_WIPHY_CHANNEL_TYPE may be
- *	optionally used to specify additional channel parameters.
+ *	frequency for the operation.
  *	%NL80211_ATTR_DURATION is used to specify the duration in milliseconds
  *	to remain on the channel. This command is also used as an event to
  *	notify when the requested duration starts (it may take a while for the
@@ -425,12 +455,11 @@
  *	as an event indicating reception of a frame that was not processed in
  *	kernel code, but is for us (i.e., which may need to be processed in a
  *	user space application). %NL80211_ATTR_FRAME is used to specify the
- *	frame contents (including header). %NL80211_ATTR_WIPHY_FREQ (and
- *	optionally %NL80211_ATTR_WIPHY_CHANNEL_TYPE) is used to indicate on
- *	which channel the frame is to be transmitted or was received. If this
- *	channel is not the current channel (remain-on-channel or the
- *	operational channel) the device will switch to the given channel and
- *	transmit the frame, optionally waiting for a response for the time
+ *	frame contents (including header). %NL80211_ATTR_WIPHY_FREQ is used
+ *	to indicate on which channel the frame is to be transmitted or was
+ *	received. If this channel is not the current channel (remain-on-channel
+ *	or the operational channel) the device will switch to the given channel
+ *	and transmit the frame, optionally waiting for a response for the time
  *	specified using %NL80211_ATTR_DURATION. When called, this operation
  *	returns a cookie (%NL80211_ATTR_COOKIE) that will be included with the
  *	TX status event pertaining to the TX request.
@@ -447,6 +476,10 @@
  *	the frame.
  * @NL80211_CMD_ACTION_TX_STATUS: Alias for @NL80211_CMD_FRAME_TX_STATUS for
  *	backward compatibility.
+ *
+ * @NL80211_CMD_SET_POWER_SAVE: Set powersave, using %NL80211_ATTR_PS_STATE
+ * @NL80211_CMD_GET_POWER_SAVE: Get powersave status in %NL80211_ATTR_PS_STATE
+ *
  * @NL80211_CMD_SET_CQM: Connection quality monitor configuration. This command
  *	is used to configure connection quality monitoring notification trigger
  *	levels.
@@ -454,8 +487,8 @@
  *	command is used as an event to indicate the that a trigger level was
  *	reached.
  * @NL80211_CMD_SET_CHANNEL: Set the channel (using %NL80211_ATTR_WIPHY_FREQ
- *	and %NL80211_ATTR_WIPHY_CHANNEL_TYPE) the given interface (identifed
- *	by %NL80211_ATTR_IFINDEX) shall operate on.
+ *	and the attributes determining channel width) the given interface
+ *	(identifed by %NL80211_ATTR_IFINDEX) shall operate on.
  *	In case multiple channels are supported by the device, the mechanism
  *	with which it switches channels is implementation-defined.
  *	When a monitor interface is given, it can only switch channel while
@@ -480,9 +513,11 @@
  * @NL80211_CMD_NEW_PEER_CANDIDATE: Notification on the reception of a
  *      beacon or probe response from a compatible mesh peer.  This is only
  *      sent while no station information (sta_info) exists for the new peer
- *      candidate and when @NL80211_MESH_SETUP_USERSPACE_AUTH is set.  On
- *      reception of this notification, userspace may decide to create a new
- *      station (@NL80211_CMD_NEW_STATION).  To stop this notification from
+ *      candidate and when @NL80211_MESH_SETUP_USERSPACE_AUTH,
+ *      @NL80211_MESH_SETUP_USERSPACE_AMPE, or
+ *      @NL80211_MESH_SETUP_USERSPACE_MPM is set.  On reception of this
+ *      notification, userspace may decide to create a new station
+ *      (@NL80211_CMD_NEW_STATION).  To stop this notification from
  *      reoccurring, the userspace authentication daemon may want to create the
  *      new station with the AUTHENTICATED flag unset and maybe change it later
  *      depending on the authentication result.
@@ -494,6 +529,12 @@
  *	command with the %NL80211_ATTR_WOWLAN_TRIGGERS attribute. For
  *	more background information, see
  *	http://wireless.kernel.org/en/users/Documentation/WoWLAN.
+ *	The @NL80211_CMD_SET_WOWLAN command can also be used as a notification
+ *	from the driver reporting the wakeup reason. In this case, the
+ *	@NL80211_ATTR_WOWLAN_TRIGGERS attribute will contain the reason
+ *	for the wakeup, if it was caused by wireless. If it is not present
+ *	in the wakeup notification, the wireless device didn't cause the
+ *	wakeup but reports that it was woken up.
  *
  * @NL80211_CMD_SET_REKEY_OFFLOAD: This command is used give the driver
  *	the necessary information for supporting GTK rekey offload. This
@@ -507,8 +548,97 @@
  *	of PMKSA caching dandidates.
  *
  * @NL80211_CMD_TDLS_OPER: Perform a high-level TDLS command (e.g. link setup).
+ *	In addition, this can be used as an event to request userspace to take
+ *	actions on TDLS links (set up a new link or tear down an existing one).
+ *	In such events, %NL80211_ATTR_TDLS_OPERATION indicates the requested
+ *	operation, %NL80211_ATTR_MAC contains the peer MAC address, and
+ *	%NL80211_ATTR_REASON_CODE the reason code to be used (only with
+ *	%NL80211_TDLS_TEARDOWN).
  * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame.
  *
+ * @NL80211_CMD_UNEXPECTED_FRAME: Used by an application controlling an AP
+ *	(or GO) interface (i.e. hostapd) to ask for unexpected frames to
+ *	implement sending deauth to stations that send unexpected class 3
+ *	frames. Also used as the event sent by the kernel when such a frame
+ *	is received.
+ *	For the event, the %NL80211_ATTR_MAC attribute carries the TA and
+ *	other attributes like the interface index are present.
+ *	If used as the command it must have an interface index and you can
+ *	only unsubscribe from the event by closing the socket. Subscription
+ *	is also for %NL80211_CMD_UNEXPECTED_4ADDR_FRAME events.
+ *
+ * @NL80211_CMD_UNEXPECTED_4ADDR_FRAME: Sent as an event indicating that the
+ *	associated station identified by %NL80211_ATTR_MAC sent a 4addr frame
+ *	and wasn't already in a 4-addr VLAN. The event will be sent similarly
+ *	to the %NL80211_CMD_UNEXPECTED_FRAME event, to the same listener.
+ *
+ * @NL80211_CMD_PROBE_CLIENT: Probe an associated station on an AP interface
+ *	by sending a null data frame to it and reporting when the frame is
+ *	acknowleged. This is used to allow timing out inactive clients. Uses
+ *	%NL80211_ATTR_IFINDEX and %NL80211_ATTR_MAC. The command returns a
+ *	direct reply with an %NL80211_ATTR_COOKIE that is later used to match
+ *	up the event with the request. The event includes the same data and
+ *	has %NL80211_ATTR_ACK set if the frame was ACKed.
+ *
+ * @NL80211_CMD_REGISTER_BEACONS: Register this socket to receive beacons from
+ *	other BSSes when any interfaces are in AP mode. This helps implement
+ *	OLBC handling in hostapd. Beacons are reported in %NL80211_CMD_FRAME
+ *	messages. Note that per PHY only one application may register.
+ *
+ * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap for the individual TIDs whether
+ *      No Acknowledgement Policy should be applied.
+ *
+ * @NL80211_CMD_CH_SWITCH_NOTIFY: An AP or GO may decide to switch channels
+ *	independently of the userspace SME, send this event indicating
+ *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ and the
+ *	attributes determining channel width.
+ *
+ * @NL80211_CMD_START_P2P_DEVICE: Start the given P2P Device, identified by
+ *	its %NL80211_ATTR_WDEV identifier. It must have been created with
+ *	%NL80211_CMD_NEW_INTERFACE previously. After it has been started, the
+ *	P2P Device can be used for P2P operations, e.g. remain-on-channel and
+ *	public action frame TX.
+ * @NL80211_CMD_STOP_P2P_DEVICE: Stop the given P2P Device, identified by
+ *	its %NL80211_ATTR_WDEV identifier.
+ *
+ * @NL80211_CMD_CONN_FAILED: connection request to an AP failed; used to
+ *	notify userspace that AP has rejected the connection request from a
+ *	station, due to particular reason. %NL80211_ATTR_CONN_FAILED_REASON
+ *	is used for this.
+ *
+ * @NL80211_CMD_SET_MCAST_RATE: Change the rate used to send multicast frames
+ *	for IBSS or MESH vif.
+ *
+ * @NL80211_CMD_SET_MAC_ACL: sets ACL for MAC address based access control.
+ *	This is to be used with the drivers advertising the support of MAC
+ *	address based access control. List of MAC addresses is passed in
+ *	%NL80211_ATTR_MAC_ADDRS and ACL policy is passed in
+ *	%NL80211_ATTR_ACL_POLICY. Driver will enable ACL with this list, if it
+ *	is not already done. The new list will replace any existing list. Driver
+ *	will clear its ACL when the list of MAC addresses passed is empty. This
+ *	command is used in AP/P2P GO mode. Driver has to make sure to clear its
+ *	ACL list during %NL80211_CMD_STOP_AP.
+ *
+ * @NL80211_CMD_RADAR_DETECT: Start a Channel availability check (CAC). Once
+ *	a radar is detected or the channel availability scan (CAC) has finished
+ *	or was aborted, or a radar was detected, usermode will be notified with
+ *	this event. This command is also used to notify userspace about radars
+ *	while operating on this channel.
+ *	%NL80211_ATTR_RADAR_EVENT is used to inform about the type of the
+ *	event.
+ *
+ * @NL80211_CMD_GET_PROTOCOL_FEATURES: Get global nl80211 protocol features,
+ *	i.e. features for the nl80211 protocol rather than device features.
+ *	Returns the features in the %NL80211_ATTR_PROTOCOL_FEATURES bitmap.
+ *
+ * @NL80211_CMD_UPDATE_FT_IES: Pass down the most up-to-date Fast Transition
+ *	Information Element to the WLAN driver
+ *
+ * @NL80211_CMD_FT_EVENT: Send a Fast transition event from the WLAN driver
+ *	to the supplicant. This will carry the target AP's MAC address along
+ *	with the relevant Information Elements. This event is used to report
+ *	received FT IEs (MDIE, FTIE, RSN IE, TIE, RICIE).
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -533,8 +663,10 @@ enum nl80211_commands {
 
 	NL80211_CMD_GET_BEACON,
 	NL80211_CMD_SET_BEACON,
-	NL80211_CMD_NEW_BEACON,
-	NL80211_CMD_DEL_BEACON,
+	NL80211_CMD_START_AP,
+	NL80211_CMD_NEW_BEACON = NL80211_CMD_START_AP,
+	NL80211_CMD_STOP_AP,
+	NL80211_CMD_DEL_BEACON = NL80211_CMD_STOP_AP,
 
 	NL80211_CMD_GET_STATION,
 	NL80211_CMD_SET_STATION,
@@ -638,6 +770,34 @@ enum nl80211_commands {
 	NL80211_CMD_TDLS_OPER,
 	NL80211_CMD_TDLS_MGMT,
 
+	NL80211_CMD_UNEXPECTED_FRAME,
+
+	NL80211_CMD_PROBE_CLIENT,
+
+	NL80211_CMD_REGISTER_BEACONS,
+
+	NL80211_CMD_UNEXPECTED_4ADDR_FRAME,
+
+	NL80211_CMD_SET_NOACK_MAP,
+
+	NL80211_CMD_CH_SWITCH_NOTIFY,
+
+	NL80211_CMD_START_P2P_DEVICE,
+	NL80211_CMD_STOP_P2P_DEVICE,
+
+	NL80211_CMD_CONN_FAILED,
+
+	NL80211_CMD_SET_MCAST_RATE,
+
+	NL80211_CMD_SET_MAC_ACL,
+
+	NL80211_CMD_RADAR_DETECT,
+
+	NL80211_CMD_GET_PROTOCOL_FEATURES,
+
+	NL80211_CMD_UPDATE_FT_IES,
+	NL80211_CMD_FT_EVENT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -658,6 +818,8 @@ enum nl80211_commands {
 #define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
 #define NL80211_CMD_REG_BEACON_HINT NL80211_CMD_REG_BEACON_HINT
 
+#define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
+
 /* source-level API compatibility */
 #define NL80211_CMD_GET_MESH_PARAMS NL80211_CMD_GET_MESH_CONFIG
 #define NL80211_CMD_SET_MESH_PARAMS NL80211_CMD_SET_MESH_CONFIG
@@ -672,14 +834,26 @@ enum nl80211_commands {
  *	/sys/class/ieee80211/<phyname>/index
  * @NL80211_ATTR_WIPHY_NAME: wiphy name (used for renaming)
  * @NL80211_ATTR_WIPHY_TXQ_PARAMS: a nested array of TX queue parameters
- * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz
+ * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz,
+ *	defines the channel together with the (deprecated)
+ *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE attribute or the attributes
+ *	%NL80211_ATTR_CHANNEL_WIDTH and if needed %NL80211_ATTR_CENTER_FREQ1
+ *	and %NL80211_ATTR_CENTER_FREQ2
+ * @NL80211_ATTR_CHANNEL_WIDTH: u32 attribute containing one of the values
+ *	of &enum nl80211_chan_width, describing the channel width. See the
+ *	documentation of the enum for more information.
+ * @NL80211_ATTR_CENTER_FREQ1: Center frequency of the first part of the
+ *	channel, used for anything but 20 MHz bandwidth
+ * @NL80211_ATTR_CENTER_FREQ2: Center frequency of the second part of the
+ *	channel, used only for 80+80 MHz bandwidth
  * @NL80211_ATTR_WIPHY_CHANNEL_TYPE: included with NL80211_ATTR_WIPHY_FREQ
- *	if HT20 or HT40 are allowed (i.e., 802.11n disabled if not included):
+ *	if HT20 or HT40 are to be used (i.e., HT disabled if not included):
  *	NL80211_CHAN_NO_HT = HT not allowed (i.e., same as not including
  *		this attribute)
  *	NL80211_CHAN_HT20 = HT20 only
  *	NL80211_CHAN_HT40MINUS = secondary channel is below the primary channel
  *	NL80211_CHAN_HT40PLUS = secondary channel is above the primary channel
+ *	This attribute is now deprecated.
  * @NL80211_ATTR_WIPHY_RETRY_SHORT: TX retry limit for frames whose length is
  *	less than or equal to the RTS threshold; allowed range: 1..255;
  *	dot11ShortRetryLimit; u8
@@ -699,6 +873,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_IFNAME: network interface name
  * @NL80211_ATTR_IFTYPE: type of virtual interface, see &enum nl80211_iftype
  *
+ * @NL80211_ATTR_WDEV: wireless device identifier, used for pseudo-devices
+ *	that don't have a netdev (u64)
+ *
  * @NL80211_ATTR_MAC: MAC address (various uses)
  *
  * @NL80211_ATTR_KEY_DATA: (temporal) key data; for TKIP this consists of
@@ -709,6 +886,13 @@ enum nl80211_commands {
  *	section 7.3.2.25.1, e.g. 0x000FAC04)
  * @NL80211_ATTR_KEY_SEQ: transmit key sequence number (IV/PN) for TKIP and
  *	CCMP keys, each six bytes in little endian
+ * @NL80211_ATTR_KEY_DEFAULT: Flag attribute indicating the key is default key
+ * @NL80211_ATTR_KEY_DEFAULT_MGMT: Flag attribute indicating the key is the
+ *	default management key
+ * @NL80211_ATTR_CIPHER_SUITES_PAIRWISE: For crypto settings for connect or
+ *	other commands, indicates which pairwise cipher suites are used
+ * @NL80211_ATTR_CIPHER_SUITE_GROUP: For crypto settings for connect or
+ *	other commands, indicates which group cipher suite is used
  *
  * @NL80211_ATTR_BEACON_INTERVAL: beacon interval in TU
  * @NL80211_ATTR_DTIM_PERIOD: DTIM period for beaconing
@@ -733,7 +917,8 @@ enum nl80211_commands {
  *	consisting of a nested array.
  *
  * @NL80211_ATTR_MESH_ID: mesh id (1-32 bytes).
- * @NL80211_ATTR_STA_PLINK_ACTION: action to perform on the mesh peer link.
+ * @NL80211_ATTR_STA_PLINK_ACTION: action to perform on the mesh peer link
+ *	(see &enum nl80211_plink_action).
  * @NL80211_ATTR_MPATH_NEXT_HOP: MAC address of the next hop for a mesh path.
  * @NL80211_ATTR_MPATH_INFO: information about a mesh_path, part of mesh path
  * 	info given for %NL80211_CMD_GET_MPATH, nested attribute described at
@@ -836,7 +1021,7 @@ enum nl80211_commands {
  * @NL80211_ATTR_USE_MFP: Whether management frame protection (IEEE 802.11w) is
  *	used for the association (&enum nl80211_mfp, represented as a u32);
  *	this attribute can be used
- *	with %NL80211_CMD_ASSOCIATE request
+ *	with %NL80211_CMD_ASSOCIATE and %NL80211_CMD_CONNECT requests
  *
  * @NL80211_ATTR_STA_FLAGS2: Attribute containing a
  *	&struct nl80211_sta_flag_update.
@@ -944,6 +1129,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_ACK: Flag attribute indicating that the frame was
  *	acknowledged by the recipient.
  *
+ * @NL80211_ATTR_PS_STATE: powersave state, using &enum nl80211_ps_state values.
+ *
  * @NL80211_ATTR_CQM: connection quality monitor configuration in a
  *	nested attribute with %NL80211_ATTR_CQM_* sub-attributes.
  *
@@ -1001,7 +1188,7 @@ enum nl80211_commands {
  *	flag isn't set, the frame will be rejected. This is also used as an
  *	nl80211 capability flag.
  *
- * @NL80211_ATTR_BSS_HTOPMODE: HT operation mode (u16)
+ * @NL80211_ATTR_BSS_HT_OPMODE: HT operation mode (u16)
  *
  * @NL80211_ATTR_KEY_DEFAULT_TYPES: A nested attribute containing flags
  *	attributes, specifying what a key should be set as default as.
@@ -1014,10 +1201,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_SUPPORT_MESH_AUTH: Currently, this means the underlying driver
  *	allows auth frames in a mesh to be passed to userspace for processing via
  *	the @NL80211_MESH_SETUP_USERSPACE_AUTH flag.
- * @NL80211_ATTR_STA_PLINK_STATE: The state of a mesh peer link as
- *	defined in &enum nl80211_plink_state. Used when userspace is
- *	driving the peer link management state machine.
- *	@NL80211_MESH_SETUP_USERSPACE_AMPE must be enabled.
+ * @NL80211_ATTR_STA_PLINK_STATE: The state of a mesh peer link as defined in
+ *	&enum nl80211_plink_state. Used when userspace is driving the peer link
+ *	management state machine.  @NL80211_MESH_SETUP_USERSPACE_AMPE or
+ *	@NL80211_MESH_SETUP_USERSPACE_MPM must be enabled.
  *
  * @NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED: indicates, as part of the wiphy
  *	capabilities, the supported WoWLAN triggers
@@ -1025,10 +1212,10 @@ enum nl80211_commands {
  *	indicate which WoW triggers should be enabled. This is also
  *	used by %NL80211_CMD_GET_WOWLAN to get the currently enabled WoWLAN
  *	triggers.
-
+ *
  * @NL80211_ATTR_SCHED_SCAN_INTERVAL: Interval between scheduled scan
  *	cycles, in msecs.
-
+ *
  * @NL80211_ATTR_SCHED_SCAN_MATCH: Nested attribute with one or more
  *	sets of attributes to match during scheduled scans.  Only BSSs
  *	that match any of the sets will be reported.  These are
@@ -1055,7 +1242,7 @@ enum nl80211_commands {
  *	are managed in software: interfaces of these types aren't subject to
  *	any restrictions in their number or combinations.
  *
- * @%NL80211_ATTR_REKEY_DATA: nested attribute containing the information
+ * @NL80211_ATTR_REKEY_DATA: nested attribute containing the information
  *	necessary for GTK rekeying in the device, see &enum nl80211_rekey_data.
  *
  * @NL80211_ATTR_SCAN_SUPP_RATES: rates per to be advertised as supported in scan,
@@ -1109,10 +1296,124 @@ enum nl80211_commands {
  *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver to perform a TDLS operation.
  *
+ * @NL80211_ATTR_DEVICE_AP_SME: This u32 attribute may be listed for devices
+ *	that have AP support to indicate that they have the AP SME integrated
+ *	with support for the features listed in this attribute, see
+ *	&enum nl80211_ap_sme_features.
+ *
+ * @NL80211_ATTR_DONT_WAIT_FOR_ACK: Used with %NL80211_CMD_FRAME, this tells
+ *	the driver to not wait for an acknowledgement. Note that due to this,
+ *	it will also not give a status callback nor return a cookie. This is
+ *	mostly useful for probe responses to save airtime.
+ *
+ * @NL80211_ATTR_FEATURE_FLAGS: This u32 attribute contains flags from
+ *	&enum nl80211_feature_flags and is advertised in wiphy information.
+ * @NL80211_ATTR_PROBE_RESP_OFFLOAD: Indicates that the HW responds to probe
+ *	requests while operating in AP-mode.
+ *	This attribute holds a bitmap of the supported protocols for
+ *	offloading (see &enum nl80211_probe_resp_offload_support_attr).
+ *
+ * @NL80211_ATTR_PROBE_RESP: Probe Response template data. Contains the entire
+ *	probe-response frame. The DA field in the 802.11 header is zero-ed out,
+ *	to be filled by the FW.
+ * @NL80211_ATTR_DISABLE_HT:  Force HT capable interfaces to disable
+ *      this feature.  Currently, only supported in mac80211 drivers.
+ * @NL80211_ATTR_HT_CAPABILITY_MASK: Specify which bits of the
+ *      ATTR_HT_CAPABILITY to which attention should be paid.
+ *      Currently, only mac80211 NICs support this feature.
+ *      The values that may be configured are:
+ *       MCS rates, MAX-AMSDU, HT-20-40 and HT_CAP_SGI_40
+ *       AMPDU density and AMPDU factor.
+ *      All values are treated as suggestions and may be ignored
+ *      by the driver as required.  The actual values may be seen in
+ *      the station debugfs ht_caps file.
+ *
  * @NL80211_ATTR_DFS_REGION: region for regulatory rules which this country
  *    abides to when initiating radiation on DFS channels. A country maps
  *    to one DFS region.
  *
+ * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
+ *      up to 16 TIDs.
+ *
+ * @NL80211_ATTR_INACTIVITY_TIMEOUT: timeout value in seconds, this can be
+ *	used by the drivers which has MLME in firmware and does not have support
+ *	to report per station tx/rx activity to free up the staion entry from
+ *	the list. This needs to be used when the driver advertises the
+ *	capability to timeout the stations.
+ *
+ * @NL80211_ATTR_RX_SIGNAL_DBM: signal strength in dBm (as a 32-bit int);
+ *	this attribute is (depending on the driver capabilities) added to
+ *	received frames indicated with %NL80211_CMD_FRAME.
+ *
+ * @NL80211_ATTR_BG_SCAN_PERIOD: Background scan period in seconds
+ *      or 0 to disable background scan.
+ *
+ * @NL80211_ATTR_USER_REG_HINT_TYPE: type of regulatory hint passed from
+ *	userspace. If unset it is assumed the hint comes directly from
+ *	a user. If set code could specify exactly what type of source
+ *	was used to provide the hint. For the different types of
+ *	allowed user regulatory hints see nl80211_user_reg_hint_type.
+ *
+ * @NL80211_ATTR_CONN_FAILED_REASON: The reason for which AP has rejected
+ *	the connection request from a station. nl80211_connect_failed_reason
+ *	enum has different reasons of connection failure.
+ *
+ * @NL80211_ATTR_SAE_DATA: SAE elements in Authentication frames. This starts
+ *	with the Authentication transaction sequence number field.
+ *
+ * @NL80211_ATTR_VHT_CAPABILITY: VHT Capability information element (from
+ *	association request when used with NL80211_CMD_NEW_STATION)
+ *
+ * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
+ *
+ * @NL80211_ATTR_P2P_CTWINDOW: P2P GO Client Traffic Window (u8), used with
+ *	the START_AP and SET_BSS commands
+ * @NL80211_ATTR_P2P_OPPPS: P2P GO opportunistic PS (u8), used with the
+ *	START_AP and SET_BSS commands. This can have the values 0 or 1;
+ *	if not given in START_AP 0 is assumed, if not given in SET_BSS
+ *	no change is made.
+ *
+ * @NL80211_ATTR_LOCAL_MESH_POWER_MODE: local mesh STA link-specific power mode
+ *	defined in &enum nl80211_mesh_power_mode.
+ *
+ * @NL80211_ATTR_ACL_POLICY: ACL policy, see &enum nl80211_acl_policy,
+ *	carried in a u32 attribute
+ *
+ * @NL80211_ATTR_MAC_ADDRS: Array of nested MAC addresses, used for
+ *	MAC ACL.
+ *
+ * @NL80211_ATTR_MAC_ACL_MAX: u32 attribute to advertise the maximum
+ *	number of MAC addresses that a device can support for MAC
+ *	ACL.
+ *
+ * @NL80211_ATTR_RADAR_EVENT: Type of radar event for notification to userspace,
+ *	contains a value of enum nl80211_radar_event (u32).
+ *
+ * @NL80211_ATTR_EXT_CAPA: 802.11 extended capabilities that the kernel driver
+ *	has and handles. The format is the same as the IE contents. See
+ *	802.11-2012 8.4.2.29 for more information.
+ * @NL80211_ATTR_EXT_CAPA_MASK: Extended capabilities that the kernel driver
+ *	has set in the %NL80211_ATTR_EXT_CAPA value, for multibit fields.
+ *
+ * @NL80211_ATTR_STA_CAPABILITY: Station capabilities (u16) are advertised to
+ *	the driver, e.g., to enable TDLS power save (PU-APSD).
+ *
+ * @NL80211_ATTR_STA_EXT_CAPABILITY: Station extended capabilities are
+ *	advertised to the driver, e.g., to enable TDLS off channel operations
+ *	and PU-APSD.
+ *
+ * @NL80211_ATTR_PROTOCOL_FEATURES: global nl80211 feature flags, see
+ *	&enum nl80211_protocol_features, the attribute is a u32.
+ *
+ * @NL80211_ATTR_SPLIT_WIPHY_DUMP: flag attribute, userspace supports
+ *	receiving the data for a single wiphy split across multiple
+ *	messages, given with wiphy dump message
+ *
+ * @NL80211_ATTR_MDID: Mobility Domain Identifier
+ *
+ * @NL80211_ATTR_IE_RIC: Resource Information Container Information
+ *	Element
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1341,8 +1642,73 @@ enum nl80211_attrs {
 	NL80211_ATTR_TDLS_SUPPORT,
 	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
 
+	NL80211_ATTR_DEVICE_AP_SME,
+
+	NL80211_ATTR_DONT_WAIT_FOR_ACK,
+
+	NL80211_ATTR_FEATURE_FLAGS,
+
+	NL80211_ATTR_PROBE_RESP_OFFLOAD,
+
+	NL80211_ATTR_PROBE_RESP,
+
 	NL80211_ATTR_DFS_REGION,
 
+	NL80211_ATTR_DISABLE_HT,
+	NL80211_ATTR_HT_CAPABILITY_MASK,
+
+	NL80211_ATTR_NOACK_MAP,
+
+	NL80211_ATTR_INACTIVITY_TIMEOUT,
+
+	NL80211_ATTR_RX_SIGNAL_DBM,
+
+	NL80211_ATTR_BG_SCAN_PERIOD,
+
+	NL80211_ATTR_WDEV,
+
+	NL80211_ATTR_USER_REG_HINT_TYPE,
+
+	NL80211_ATTR_CONN_FAILED_REASON,
+
+	NL80211_ATTR_SAE_DATA,
+
+	NL80211_ATTR_VHT_CAPABILITY,
+
+	NL80211_ATTR_SCAN_FLAGS,
+
+	NL80211_ATTR_CHANNEL_WIDTH,
+	NL80211_ATTR_CENTER_FREQ1,
+	NL80211_ATTR_CENTER_FREQ2,
+
+	NL80211_ATTR_P2P_CTWINDOW,
+	NL80211_ATTR_P2P_OPPPS,
+
+	NL80211_ATTR_LOCAL_MESH_POWER_MODE,
+
+	NL80211_ATTR_ACL_POLICY,
+
+	NL80211_ATTR_MAC_ADDRS,
+
+	NL80211_ATTR_MAC_ACL_MAX,
+
+	NL80211_ATTR_RADAR_EVENT,
+
+	NL80211_ATTR_EXT_CAPA,
+	NL80211_ATTR_EXT_CAPA_MASK,
+
+	NL80211_ATTR_STA_CAPABILITY,
+	NL80211_ATTR_STA_EXT_CAPABILITY,
+
+	NL80211_ATTR_PROTOCOL_FEATURES,
+	NL80211_ATTR_SPLIT_WIPHY_DUMP,
+
+	NL80211_ATTR_DISABLE_VHT,
+	NL80211_ATTR_VHT_CAPABILITY_MASK,
+
+	NL80211_ATTR_MDID,
+	NL80211_ATTR_IE_RIC,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1377,17 +1743,27 @@ enum nl80211_attrs {
 #define NL80211_ATTR_AKM_SUITES NL80211_ATTR_AKM_SUITES
 #define NL80211_ATTR_KEY NL80211_ATTR_KEY
 #define NL80211_ATTR_KEYS NL80211_ATTR_KEYS
+#define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
 
 #define NL80211_MAX_SUPP_RATES			32
+#define NL80211_MAX_SUPP_HT_RATES		77
 #define NL80211_MAX_SUPP_REG_RULES		32
 #define NL80211_TKIP_DATA_OFFSET_ENCR_KEY	0
 #define NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY	16
 #define NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY	24
 #define NL80211_HT_CAPABILITY_LEN		26
+#define NL80211_VHT_CAPABILITY_LEN		12
 
 #define NL80211_MAX_NR_CIPHER_SUITES		5
 #define NL80211_MAX_NR_AKM_SUITES		2
 
+#define NL80211_MIN_REMAIN_ON_CHANNEL_TIME	10
+
+/* default RSSI threshold for scan results if none specified. */
+#define NL80211_SCAN_RSSI_THOLD_OFF		-300
+
+#define NL80211_CQM_TXE_MAX_INTVL		1800
+
 /**
  * enum nl80211_iftype - (virtual) interface types
  *
@@ -1403,6 +1779,10 @@ enum nl80211_attrs {
  * @NL80211_IFTYPE_MESH_POINT: mesh point
  * @NL80211_IFTYPE_P2P_CLIENT: P2P client
  * @NL80211_IFTYPE_P2P_GO: P2P group owner
+ * @NL80211_IFTYPE_P2P_DEVICE: P2P device interface type, this is not a netdev
+ *	and therefore can't be created in the normal ways, use the
+ *	%NL80211_CMD_START_P2P_DEVICE and %NL80211_CMD_STOP_P2P_DEVICE
+ *	commands to create and destroy one
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @NUM_NL80211_IFTYPES: number of defined interface types
  *
@@ -1421,6 +1801,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_MESH_POINT,
 	NL80211_IFTYPE_P2P_CLIENT,
 	NL80211_IFTYPE_P2P_GO,
+	NL80211_IFTYPE_P2P_DEVICE,
 
 	/* keep last */
 	NUM_NL80211_IFTYPES,
@@ -1440,7 +1821,14 @@ enum nl80211_iftype {
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
  * @NL80211_STA_FLAG_MFP: station uses management frame protection
  * @NL80211_STA_FLAG_AUTHENTICATED: station is authenticated
- * @NL80211_STA_FLAG_TDLS_PEER: station is a TDLS peer
+ * @NL80211_STA_FLAG_TDLS_PEER: station is a TDLS peer -- this flag should
+ *	only be used in managed mode (even in the flags mask). Note that the
+ *	flag can't be changed, it is only valid while adding a station, and
+ *	attempts to change it will silently be ignored (rather than rejected
+ *	as errors.)
+ * @NL80211_STA_FLAG_ASSOCIATED: station is associated; used with drivers
+ *	that support %NL80211_FEATURE_FULL_AP_CLIENT_STATE to transition a
+ *	previously added station into associated state
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1452,12 +1840,15 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_MFP,
 	NL80211_STA_FLAG_AUTHENTICATED,
 	NL80211_STA_FLAG_TDLS_PEER,
+	NL80211_STA_FLAG_ASSOCIATED,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
 	NL80211_STA_FLAG_MAX = __NL80211_STA_FLAG_AFTER_LAST - 1
 };
 
+#define NL80211_STA_FLAG_MAX_OLD_API	NL80211_STA_FLAG_TDLS_PEER
+
 /**
  * struct nl80211_sta_flag_update - station flags mask/set
  * @mask: mask of station flags to set
@@ -1475,13 +1866,26 @@ struct nl80211_sta_flag_update {
  *
  * These attribute types are used with %NL80211_STA_INFO_TXRATE
  * when getting information about the bitrate of a station.
+ * There are 2 attributes for bitrate, a legacy one that represents
+ * a 16-bit value, and new one that represents a 32-bit value.
+ * If the rate value fits into 16 bit, both attributes are reported
+ * with the same value. If the rate is too high to fit into 16 bits
+ * (>6.5535Gbps) only 32-bit attribute is included.
+ * User space tools encouraged to use the 32-bit attribute and fall
+ * back to the 16-bit one for compatibility with older kernels.
  *
  * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
  * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
  * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
- * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
+ * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 MHz dualchannel bitrate
  * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
+ * @NL80211_RATE_INFO_BITRATE32: total bitrate (u32, 100kbit/s)
  * @NL80211_RATE_INFO_MAX: highest rate_info number currently defined
+ * @NL80211_RATE_INFO_VHT_MCS: MCS index for VHT (u8)
+ * @NL80211_RATE_INFO_VHT_NSS: number of streams in VHT (u8)
+ * @NL80211_RATE_INFO_80_MHZ_WIDTH: 80 MHz VHT rate
+ * @NL80211_RATE_INFO_80P80_MHZ_WIDTH: 80+80 MHz VHT rate
+ * @NL80211_RATE_INFO_160_MHZ_WIDTH: 160 MHz VHT rate
  * @__NL80211_RATE_INFO_AFTER_LAST: internal use
  */
 enum nl80211_rate_info {
@@ -1490,6 +1894,12 @@ enum nl80211_rate_info {
 	NL80211_RATE_INFO_MCS,
 	NL80211_RATE_INFO_40_MHZ_WIDTH,
 	NL80211_RATE_INFO_SHORT_GI,
+	NL80211_RATE_INFO_BITRATE32,
+	NL80211_RATE_INFO_VHT_MCS,
+	NL80211_RATE_INFO_VHT_NSS,
+	NL80211_RATE_INFO_80_MHZ_WIDTH,
+	NL80211_RATE_INFO_80P80_MHZ_WIDTH,
+	NL80211_RATE_INFO_160_MHZ_WIDTH,
 
 	/* keep last */
 	__NL80211_RATE_INFO_AFTER_LAST,
@@ -1536,6 +1946,8 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_INACTIVE_TIME: time since last activity (u32, msecs)
  * @NL80211_STA_INFO_RX_BYTES: total received bytes (u32, from this station)
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this station)
+ * @NL80211_STA_INFO_RX_BYTES64: total received bytes (u64, from this station)
+ * @NL80211_STA_INFO_TX_BYTES64: total transmitted bytes (u64, to this station)
  * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dBm)
  * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
  * 	containing info as possible, see &enum nl80211_rate_info
@@ -1554,6 +1966,13 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_BSS_PARAM: current station's view of BSS, nested attribute
  *     containing info as possible, see &enum nl80211_sta_bss_param
  * @NL80211_STA_INFO_CONNECTED_TIME: time since the station is last connected
+ * @NL80211_STA_INFO_STA_FLAGS: Contains a struct nl80211_sta_flag_update.
+ * @NL80211_STA_INFO_BEACON_LOSS: count of times beacon loss was detected (u32)
+ * @NL80211_STA_INFO_T_OFFSET: timing offset with respect to this STA (s64)
+ * @NL80211_STA_INFO_LOCAL_PM: local mesh STA link-specific power mode
+ * @NL80211_STA_INFO_PEER_PM: peer mesh STA link-specific power mode
+ * @NL80211_STA_INFO_NONPEER_PM: neighbor mesh STA power save mode towards
+ *	non-peer STA
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -1575,6 +1994,14 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_RX_BITRATE,
 	NL80211_STA_INFO_BSS_PARAM,
 	NL80211_STA_INFO_CONNECTED_TIME,
+	NL80211_STA_INFO_STA_FLAGS,
+	NL80211_STA_INFO_BEACON_LOSS,
+	NL80211_STA_INFO_T_OFFSET,
+	NL80211_STA_INFO_LOCAL_PM,
+	NL80211_STA_INFO_PEER_PM,
+	NL80211_STA_INFO_NONPEER_PM,
+	NL80211_STA_INFO_RX_BYTES64,
+	NL80211_STA_INFO_TX_BYTES64,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -1644,6 +2071,9 @@ enum nl80211_mpath_info {
  * @NL80211_BAND_ATTR_HT_CAPA: HT capabilities, as in the HT information IE
  * @NL80211_BAND_ATTR_HT_AMPDU_FACTOR: A-MPDU factor, as in 11n
  * @NL80211_BAND_ATTR_HT_AMPDU_DENSITY: A-MPDU density, as in 11n
+ * @NL80211_BAND_ATTR_VHT_MCS_SET: 32-byte attribute containing the MCS set as
+ *	defined in 802.11ac
+ * @NL80211_BAND_ATTR_VHT_CAPA: VHT capabilities, as in the HT information IE
  * @NL80211_BAND_ATTR_MAX: highest band attribute currently defined
  * @__NL80211_BAND_ATTR_AFTER_LAST: internal use
  */
@@ -1657,6 +2087,9 @@ enum nl80211_band_attr {
 	NL80211_BAND_ATTR_HT_AMPDU_FACTOR,
 	NL80211_BAND_ATTR_HT_AMPDU_DENSITY,
 
+	NL80211_BAND_ATTR_VHT_MCS_SET,
+	NL80211_BAND_ATTR_VHT_CAPA,
+
 	/* keep last */
 	__NL80211_BAND_ATTR_AFTER_LAST,
 	NL80211_BAND_ATTR_MAX = __NL80211_BAND_ATTR_AFTER_LAST - 1
@@ -1678,6 +2111,20 @@ enum nl80211_band_attr {
  *	on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in mBm
  *	(100 * dBm).
+ * @NL80211_FREQUENCY_ATTR_DFS_STATE: current state for DFS
+ *	(enum nl80211_dfs_state)
+ * @NL80211_FREQUENCY_ATTR_DFS_TIME: time in miliseconds for how long
+ *	this channel is in this DFS state.
+ * @NL80211_FREQUENCY_ATTR_NO_HT40_MINUS: HT40- isn't possible with this
+ *	channel as the control channel
+ * @NL80211_FREQUENCY_ATTR_NO_HT40_PLUS: HT40+ isn't possible with this
+ *	channel as the control channel
+ * @NL80211_FREQUENCY_ATTR_NO_80MHZ: any 80 MHz channel using this channel
+ *	as the primary or any of the secondary channels isn't possible,
+ *	this includes 80+80 channels
+ * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not 80+80) channel
+ *	using this channel as the primary or any of the secondary channels
+ *	isn't possible
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -1690,6 +2137,12 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_IBSS,
 	NL80211_FREQUENCY_ATTR_RADAR,
 	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
+	NL80211_FREQUENCY_ATTR_DFS_STATE,
+	NL80211_FREQUENCY_ATTR_DFS_TIME,
+	NL80211_FREQUENCY_ATTR_NO_HT40_MINUS,
+	NL80211_FREQUENCY_ATTR_NO_HT40_PLUS,
+	NL80211_FREQUENCY_ATTR_NO_80MHZ,
+	NL80211_FREQUENCY_ATTR_NO_160MHZ,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
@@ -1808,6 +2261,8 @@ enum nl80211_reg_rule_attr {
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID: attribute number 0 is reserved
  * @NL80211_SCHED_SCAN_MATCH_ATTR_SSID: SSID to be used for matching,
  * only report BSS with matching SSID.
+ * @NL80211_SCHED_SCAN_MATCH_ATTR_RSSI: RSSI threshold (in dBm) for reporting a
+ *	BSS in scan results. Filtering is turned off if not specified.
  * @NL80211_SCHED_SCAN_MATCH_ATTR_MAX: highest scheduled scan filter
  *	attribute number currently defined
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST: internal use
@@ -1815,7 +2270,8 @@ enum nl80211_reg_rule_attr {
 enum nl80211_sched_scan_match_attr {
 	__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID,
 
-	NL80211_ATTR_SCHED_SCAN_MATCH_SSID,
+	NL80211_SCHED_SCAN_MATCH_ATTR_SSID,
+	NL80211_SCHED_SCAN_MATCH_ATTR_RSSI,
 
 	/* keep last */
 	__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST,
@@ -1823,6 +2279,9 @@ enum nl80211_sched_scan_match_attr {
 		__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST - 1
 };
 
+/* only for backward compatibility */
+#define NL80211_ATTR_SCHED_SCAN_MATCH_SSID NL80211_SCHED_SCAN_MATCH_ATTR_SSID
+
 /**
  * enum nl80211_reg_rule_flags - regulatory rule flags
  *
@@ -1852,9 +2311,9 @@ enum nl80211_reg_rule_flags {
  * enum nl80211_dfs_regions - regulatory DFS regions
  *
  * @NL80211_DFS_UNSET: Country has no DFS master region specified
- * @NL80211_DFS_FCC_: Country follows DFS master rules from FCC
- * @NL80211_DFS_FCC_: Country follows DFS master rules from ETSI
- * @NL80211_DFS_JP_: Country follows DFS master rules from JP/MKK/Telec
+ * @NL80211_DFS_FCC: Country follows DFS master rules from FCC
+ * @NL80211_DFS_ETSI: Country follows DFS master rules from ETSI
+ * @NL80211_DFS_JP: Country follows DFS master rules from JP/MKK/Telec
  */
 enum nl80211_dfs_regions {
 	NL80211_DFS_UNSET	= 0,
@@ -1864,6 +2323,26 @@ enum nl80211_dfs_regions {
 };
 
 /**
+ * enum nl80211_user_reg_hint_type - type of user regulatory hint
+ *
+ * @NL80211_USER_REG_HINT_USER: a user sent the hint. This is always
+ *	assumed if the attribute is not set.
+ * @NL80211_USER_REG_HINT_CELL_BASE: the hint comes from a cellular
+ *	base station. Device drivers that have been tested to work
+ *	properly to support this type of hint can enable these hints
+ *	by setting the NL80211_FEATURE_CELL_BASE_REG_HINTS feature
+ *	capability on the struct wiphy. The wireless core will
+ *	ignore all cell base station hints until at least one device
+ *	present has been registered with the wireless core that
+ *	has listed NL80211_FEATURE_CELL_BASE_REG_HINTS as a
+ *	supported feature.
+ */
+enum nl80211_user_reg_hint_type {
+	NL80211_USER_REG_HINT_USER	= 0,
+	NL80211_USER_REG_HINT_CELL_BASE = 1,
+};
+
+/**
  * enum nl80211_survey_info - survey information
  *
  * These attribute types are used with %NL80211_ATTR_SURVEY_INFO
@@ -1934,6 +2413,34 @@ enum nl80211_mntr_flags {
 };
 
 /**
+ * enum nl80211_mesh_power_mode - mesh power save modes
+ *
+ * @NL80211_MESH_POWER_UNKNOWN: The mesh power mode of the mesh STA is
+ *	not known or has not been set yet.
+ * @NL80211_MESH_POWER_ACTIVE: Active mesh power mode. The mesh STA is
+ *	in Awake state all the time.
+ * @NL80211_MESH_POWER_LIGHT_SLEEP: Light sleep mode. The mesh STA will
+ *	alternate between Active and Doze states, but will wake up for
+ *	neighbor's beacons.
+ * @NL80211_MESH_POWER_DEEP_SLEEP: Deep sleep mode. The mesh STA will
+ *	alternate between Active and Doze states, but may not wake up
+ *	for neighbor's beacons.
+ *
+ * @__NL80211_MESH_POWER_AFTER_LAST - internal use
+ * @NL80211_MESH_POWER_MAX - highest possible power save level
+ */
+
+enum nl80211_mesh_power_mode {
+	NL80211_MESH_POWER_UNKNOWN,
+	NL80211_MESH_POWER_ACTIVE,
+	NL80211_MESH_POWER_LIGHT_SLEEP,
+	NL80211_MESH_POWER_DEEP_SLEEP,
+
+	__NL80211_MESH_POWER_AFTER_LAST,
+	NL80211_MESH_POWER_MAX = __NL80211_MESH_POWER_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_meshconf_params - mesh configuration parameters
  *
  * Mesh configuration parameters. These can be changed while the mesh is
@@ -1942,62 +2449,98 @@ enum nl80211_mntr_flags {
  * @__NL80211_MESHCONF_INVALID: internal use
  *
  * @NL80211_MESHCONF_RETRY_TIMEOUT: specifies the initial retry timeout in
- * millisecond units, used by the Peer Link Open message
+ *	millisecond units, used by the Peer Link Open message
  *
  * @NL80211_MESHCONF_CONFIRM_TIMEOUT: specifies the initial confirm timeout, in
- * millisecond units, used by the peer link management to close a peer link
+ *	millisecond units, used by the peer link management to close a peer link
  *
  * @NL80211_MESHCONF_HOLDING_TIMEOUT: specifies the holding timeout, in
- * millisecond units
+ *	millisecond units
  *
  * @NL80211_MESHCONF_MAX_PEER_LINKS: maximum number of peer links allowed
- * on this mesh interface
+ *	on this mesh interface
  *
  * @NL80211_MESHCONF_MAX_RETRIES: specifies the maximum number of peer link
- * open retries that can be sent to establish a new peer link instance in a
- * mesh
+ *	open retries that can be sent to establish a new peer link instance in a
+ *	mesh
  *
  * @NL80211_MESHCONF_TTL: specifies the value of TTL field set at a source mesh
- * point.
+ *	point.
  *
- * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically
- * open peer links when we detect compatible mesh peers.
+ * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically open
+ *	peer links when we detect compatible mesh peers. Disabled if
+ *	@NL80211_MESH_SETUP_USERSPACE_MPM or @NL80211_MESH_SETUP_USERSPACE_AMPE are
+ *	set.
  *
  * @NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES: the number of action frames
- * containing a PREQ that an MP can send to a particular destination (path
- * target)
+ *	containing a PREQ that an MP can send to a particular destination (path
+ *	target)
  *
  * @NL80211_MESHCONF_PATH_REFRESH_TIME: how frequently to refresh mesh paths
- * (in milliseconds)
+ *	(in milliseconds)
  *
  * @NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT: minimum length of time to wait
- * until giving up on a path discovery (in milliseconds)
+ *	until giving up on a path discovery (in milliseconds)
  *
  * @NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT: The time (in TUs) for which mesh
- * points receiving a PREQ shall consider the forwarding information from the
- * root to be valid. (TU = time unit)
+ *	points receiving a PREQ shall consider the forwarding information from
+ *	the root to be valid. (TU = time unit)
  *
  * @NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL: The minimum interval of time (in
- * TUs) during which an MP can send only one action frame containing a PREQ
- * reference element
+ *	TUs) during which an MP can send only one action frame containing a PREQ
+ *	reference element
  *
  * @NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME: The interval of time (in TUs)
- * that it takes for an HWMP information element to propagate across the mesh
+ *	that it takes for an HWMP information element to propagate across the
+ *	mesh
  *
  * @NL80211_MESHCONF_HWMP_ROOTMODE: whether root mode is enabled or not
  *
  * @NL80211_MESHCONF_ELEMENT_TTL: specifies the value of TTL field set at a
- * source mesh point for path selection elements.
+ *	source mesh point for path selection elements.
  *
  * @NL80211_MESHCONF_HWMP_RANN_INTERVAL:  The interval of time (in TUs) between
- * root announcements are transmitted.
+ *	root announcements are transmitted.
  *
  * @NL80211_MESHCONF_GATE_ANNOUNCEMENTS: Advertise that this mesh station has
- * access to a broader network beyond the MBSS.  This is done via Root
- * Announcement frames.
+ *	access to a broader network beyond the MBSS.  This is done via Root
+ *	Announcement frames.
+ *
+ * @NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL: The minimum interval of time (in
+ *	TUs) during which a mesh STA can send only one Action frame containing a
+ *	PERR element.
+ *
+ * @NL80211_MESHCONF_FORWARDING: set Mesh STA as forwarding or non-forwarding
+ *	or forwarding entity (default is TRUE - forwarding entity)
+ *
+ * @NL80211_MESHCONF_RSSI_THRESHOLD: RSSI threshold in dBm. This specifies the
+ *	threshold for average signal strength of candidate station to establish
+ *	a peer link.
+ *
+ * @NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR: maximum number of neighbors
+ *	to synchronize to for 11s default synchronization method
+ *	(see 11C.12.2.2)
+ *
+ * @NL80211_MESHCONF_HT_OPMODE: set mesh HT protection mode.
  *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
+ * @NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT: The time (in TUs) for
+ *	which mesh STAs receiving a proactive PREQ shall consider the forwarding
+ *	information to the root mesh STA to be valid.
+ *
+ * @NL80211_MESHCONF_HWMP_ROOT_INTERVAL: The interval of time (in TUs) between
+ *	proactive PREQs are transmitted.
+ *
+ * @NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL: The minimum interval of time
+ *	(in TUs) during which a mesh STA can send only one Action frame
+ *	containing a PREQ element for root path confirmation.
+ *
+ * @NL80211_MESHCONF_POWER_MODE: Default mesh power mode for new peer links.
+ *	type &enum nl80211_mesh_power_mode (u32)
+ *
+ * @NL80211_MESHCONF_AWAKE_WINDOW: awake window duration (in TUs)
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2019,6 +2562,16 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_ELEMENT_TTL,
 	NL80211_MESHCONF_HWMP_RANN_INTERVAL,
 	NL80211_MESHCONF_GATE_ANNOUNCEMENTS,
+	NL80211_MESHCONF_HWMP_PERR_MIN_INTERVAL,
+	NL80211_MESHCONF_FORWARDING,
+	NL80211_MESHCONF_RSSI_THRESHOLD,
+	NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR,
+	NL80211_MESHCONF_HT_OPMODE,
+	NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
+	NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
+	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
+	NL80211_MESHCONF_POWER_MODE,
+	NL80211_MESHCONF_AWAKE_WINDOW,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
@@ -2034,30 +2587,40 @@ enum nl80211_meshconf_params {
  * @__NL80211_MESH_SETUP_INVALID: Internal use
  *
  * @NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL: Enable this option to use a
- * vendor specific path selection algorithm or disable it to use the default
- * HWMP.
+ *	vendor specific path selection algorithm or disable it to use the
+ *	default HWMP.
  *
  * @NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC: Enable this option to use a
- * vendor specific path metric or disable it to use the default Airtime
- * metric.
+ *	vendor specific path metric or disable it to use the default Airtime
+ *	metric.
  *
  * @NL80211_MESH_SETUP_IE: Information elements for this mesh, for instance, a
- * robust security network ie, or a vendor specific information element that
- * vendors will use to identify the path selection methods and metrics in use.
+ *	robust security network ie, or a vendor specific information element
+ *	that vendors will use to identify the path selection methods and
+ *	metrics in use.
  *
  * @NL80211_MESH_SETUP_USERSPACE_AUTH: Enable this option if an authentication
- * daemon will be authenticating mesh candidates.
+ *	daemon will be authenticating mesh candidates.
  *
  * @NL80211_MESH_SETUP_USERSPACE_AMPE: Enable this option if an authentication
- * daemon will be securing peer link frames.  AMPE is a secured version of Mesh
- * Peering Management (MPM) and is implemented with the assistance of a
- * userspace daemon.  When this flag is set, the kernel will send peer
- * management frames to a userspace daemon that will implement AMPE
- * functionality (security capabilities selection, key confirmation, and key
- * management).  When the flag is unset (default), the kernel can autonomously
- * complete (unsecured) mesh peering without the need of a userspace daemon.
+ *	daemon will be securing peer link frames.  AMPE is a secured version of
+ *	Mesh Peering Management (MPM) and is implemented with the assistance of
+ *	a userspace daemon.  When this flag is set, the kernel will send peer
+ *	management frames to a userspace daemon that will implement AMPE
+ *	functionality (security capabilities selection, key confirmation, and
+ *	key management).  When the flag is unset (default), the kernel can
+ *	autonomously complete (unsecured) mesh peering without the need of a
+ *	userspace daemon.
+ *
+ * @NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC: Enable this option to use a
+ *	vendor specific synchronization method or disable it to use the default
+ *	neighbor offset synchronization
+ *
+ * @NL80211_MESH_SETUP_USERSPACE_MPM: Enable this option if userspace will
+ *	implement an MPM which handles peer allocation and state.
  *
  * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
+ *
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
  */
 enum nl80211_mesh_setup_params {
@@ -2067,6 +2630,8 @@ enum nl80211_mesh_setup_params {
 	NL80211_MESH_SETUP_IE,
 	NL80211_MESH_SETUP_USERSPACE_AUTH,
 	NL80211_MESH_SETUP_USERSPACE_AMPE,
+	NL80211_MESH_SETUP_ENABLE_VENDOR_SYNC,
+	NL80211_MESH_SETUP_USERSPACE_MPM,
 
 	/* keep last */
 	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
@@ -2076,7 +2641,7 @@ enum nl80211_mesh_setup_params {
 /**
  * enum nl80211_txq_attr - TX queue parameter attributes
  * @__NL80211_TXQ_ATTR_INVALID: Attribute number 0 is reserved
- * @NL80211_TXQ_ATTR_QUEUE: TX queue identifier (NL80211_TXQ_Q_*)
+ * @NL80211_TXQ_ATTR_AC: AC identifier (NL80211_AC_*)
  * @NL80211_TXQ_ATTR_TXOP: Maximum burst time in units of 32 usecs, 0 meaning
  *	disabled
  * @NL80211_TXQ_ATTR_CWMIN: Minimum contention window [a value of the form
@@ -2089,7 +2654,7 @@ enum nl80211_mesh_setup_params {
  */
 enum nl80211_txq_attr {
 	__NL80211_TXQ_ATTR_INVALID,
-	NL80211_TXQ_ATTR_QUEUE,
+	NL80211_TXQ_ATTR_AC,
 	NL80211_TXQ_ATTR_TXOP,
 	NL80211_TXQ_ATTR_CWMIN,
 	NL80211_TXQ_ATTR_CWMAX,
@@ -2100,13 +2665,30 @@ enum nl80211_txq_attr {
 	NL80211_TXQ_ATTR_MAX = __NL80211_TXQ_ATTR_AFTER_LAST - 1
 };
 
-enum nl80211_txq_q {
-	NL80211_TXQ_Q_VO,
-	NL80211_TXQ_Q_VI,
-	NL80211_TXQ_Q_BE,
-	NL80211_TXQ_Q_BK
+enum nl80211_ac {
+	NL80211_AC_VO,
+	NL80211_AC_VI,
+	NL80211_AC_BE,
+	NL80211_AC_BK,
+	NL80211_NUM_ACS
 };
 
+/* backward compat */
+#define NL80211_TXQ_ATTR_QUEUE	NL80211_TXQ_ATTR_AC
+#define NL80211_TXQ_Q_VO	NL80211_AC_VO
+#define NL80211_TXQ_Q_VI	NL80211_AC_VI
+#define NL80211_TXQ_Q_BE	NL80211_AC_BE
+#define NL80211_TXQ_Q_BK	NL80211_AC_BK
+
+/**
+ * enum nl80211_channel_type - channel type
+ * @NL80211_CHAN_NO_HT: 20 MHz, non-HT channel
+ * @NL80211_CHAN_HT20: 20 MHz HT channel
+ * @NL80211_CHAN_HT40MINUS: HT40 channel, secondary channel
+ *	below the control channel
+ * @NL80211_CHAN_HT40PLUS: HT40 channel, secondary channel
+ *	above the control channel
+ */
 enum nl80211_channel_type {
 	NL80211_CHAN_NO_HT,
 	NL80211_CHAN_HT20,
@@ -2115,6 +2697,32 @@ enum nl80211_channel_type {
 };
 
 /**
+ * enum nl80211_chan_width - channel width definitions
+ *
+ * These values are used with the %NL80211_ATTR_CHANNEL_WIDTH
+ * attribute.
+ *
+ * @NL80211_CHAN_WIDTH_20_NOHT: 20 MHz, non-HT channel
+ * @NL80211_CHAN_WIDTH_20: 20 MHz HT channel
+ * @NL80211_CHAN_WIDTH_40: 40 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
+ *	attribute must be provided as well
+ * @NL80211_CHAN_WIDTH_80: 80 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
+ *	attribute must be provided as well
+ * @NL80211_CHAN_WIDTH_80P80: 80+80 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
+ *	and %NL80211_ATTR_CENTER_FREQ2 attributes must be provided as well
+ * @NL80211_CHAN_WIDTH_160: 160 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
+ *	attribute must be provided as well
+ */
+enum nl80211_chan_width {
+	NL80211_CHAN_WIDTH_20_NOHT,
+	NL80211_CHAN_WIDTH_20,
+	NL80211_CHAN_WIDTH_40,
+	NL80211_CHAN_WIDTH_80,
+	NL80211_CHAN_WIDTH_80P80,
+	NL80211_CHAN_WIDTH_160,
+};
+
+/**
  * enum nl80211_bss - netlink attributes for a BSS
  *
  * @__NL80211_BSS_INVALID: invalid
@@ -2182,6 +2790,7 @@ enum nl80211_bss_status {
  * @NL80211_AUTHTYPE_SHARED_KEY: Shared Key authentication (WEP only)
  * @NL80211_AUTHTYPE_FT: Fast BSS Transition (IEEE 802.11r)
  * @NL80211_AUTHTYPE_NETWORK_EAP: Network EAP (some Cisco APs and mainly LEAP)
+ * @NL80211_AUTHTYPE_SAE: Simultaneous authentication of equals
  * @__NL80211_AUTHTYPE_NUM: internal
  * @NL80211_AUTHTYPE_MAX: maximum valid auth algorithm
  * @NL80211_AUTHTYPE_AUTOMATIC: determine automatically (if necessary by
@@ -2193,6 +2802,7 @@ enum nl80211_auth_type {
 	NL80211_AUTHTYPE_SHARED_KEY,
 	NL80211_AUTHTYPE_FT,
 	NL80211_AUTHTYPE_NETWORK_EAP,
+	NL80211_AUTHTYPE_SAE,
 
 	/* keep last */
 	__NL80211_AUTHTYPE_NUM,
@@ -2292,12 +2902,15 @@ enum nl80211_key_attributes {
  *	in an array of rates as defined in IEEE 802.11 7.3.2.2 (u8 values with
  *	1 = 500 kbps) but without the IE length restriction (at most
  *	%NL80211_MAX_SUPP_RATES in a single array).
+ * @NL80211_TXRATE_MCS: HT (MCS) rates allowed for TX rate selection
+ *	in an array of MCS numbers.
  * @__NL80211_TXRATE_AFTER_LAST: internal
  * @NL80211_TXRATE_MAX: highest TX rate attribute
  */
 enum nl80211_tx_rate_attributes {
 	__NL80211_TXRATE_INVALID,
 	NL80211_TXRATE_LEGACY,
+	NL80211_TXRATE_MCS,
 
 	/* keep last */
 	__NL80211_TXRATE_AFTER_LAST,
@@ -2308,12 +2921,19 @@ enum nl80211_tx_rate_attributes {
  * enum nl80211_band - Frequency band
  * @NL80211_BAND_2GHZ: 2.4 GHz ISM band
  * @NL80211_BAND_5GHZ: around 5 GHz band (4.9 - 5.7 GHz)
+ * @NL80211_BAND_60GHZ: around 60 GHz band (58.32 - 64.80 GHz)
  */
 enum nl80211_band {
 	NL80211_BAND_2GHZ,
 	NL80211_BAND_5GHZ,
+	NL80211_BAND_60GHZ,
 };
 
+/**
+ * enum nl80211_ps_state - powersave state
+ * @NL80211_PS_DISABLED: powersave is disabled
+ * @NL80211_PS_ENABLED: powersave is enabled
+ */
 enum nl80211_ps_state {
 	NL80211_PS_DISABLED,
 	NL80211_PS_ENABLED,
@@ -2331,6 +2951,17 @@ enum nl80211_ps_state {
  * @NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT: RSSI threshold event
  * @NL80211_ATTR_CQM_PKT_LOSS_EVENT: a u32 value indicating that this many
  *	consecutive packets were not acknowledged by the peer
+ * @NL80211_ATTR_CQM_TXE_RATE: TX error rate in %. Minimum % of TX failures
+ *	during the given %NL80211_ATTR_CQM_TXE_INTVL before an
+ *	%NL80211_CMD_NOTIFY_CQM with reported %NL80211_ATTR_CQM_TXE_RATE and
+ *	%NL80211_ATTR_CQM_TXE_PKTS is generated.
+ * @NL80211_ATTR_CQM_TXE_PKTS: number of attempted packets in a given
+ *	%NL80211_ATTR_CQM_TXE_INTVL before %NL80211_ATTR_CQM_TXE_RATE is
+ *	checked.
+ * @NL80211_ATTR_CQM_TXE_INTVL: interval in seconds. Specifies the periodic
+ *	interval in which %NL80211_ATTR_CQM_TXE_PKTS and
+ *	%NL80211_ATTR_CQM_TXE_RATE must be satisfied before generating an
+ *	%NL80211_CMD_NOTIFY_CQM. Set to 0 to turn off TX error reporting.
  * @__NL80211_ATTR_CQM_AFTER_LAST: internal
  * @NL80211_ATTR_CQM_MAX: highest key attribute
  */
@@ -2340,6 +2971,9 @@ enum nl80211_attr_cqm {
 	NL80211_ATTR_CQM_RSSI_HYST,
 	NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT,
 	NL80211_ATTR_CQM_PKT_LOSS_EVENT,
+	NL80211_ATTR_CQM_TXE_RATE,
+	NL80211_ATTR_CQM_TXE_PKTS,
+	NL80211_ATTR_CQM_TXE_INTVL,
 
 	/* keep last */
 	__NL80211_ATTR_CQM_AFTER_LAST,
@@ -2352,10 +2986,14 @@ enum nl80211_attr_cqm {
  *      configured threshold
  * @NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH: The RSSI is higher than the
  *      configured threshold
+ * @NL80211_CQM_RSSI_BEACON_LOSS_EVENT: The device experienced beacon loss.
+ *	(Note that deauth/disassoc will still follow if the AP is not
+ *	available. This event might get used as roaming event, etc.)
  */
 enum nl80211_cqm_rssi_threshold_event {
 	NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
 	NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+	NL80211_CQM_RSSI_BEACON_LOSS_EVENT,
 };
 
 
@@ -2383,10 +3021,12 @@ enum nl80211_tx_power_setting {
  *	corresponds to the lowest-order bit in the second byte of the mask.
  *	For example: The match 00:xx:00:00:xx:00:00:00:00:xx:xx:xx (where
  *	xx indicates "don't care") would be represented by a pattern of
- *	twelve zero bytes, and a mask of "0xed,0x07".
+ *	twelve zero bytes, and a mask of "0xed,0x01".
  *	Note that the pattern matching is done as though frames were not
  *	802.11 frames but 802.3 frames, i.e. the frame is fully unpacked
  *	first (including SNAP header unpacking) and then matched.
+ * @NL80211_WOWLAN_PKTPAT_OFFSET: packet offset, pattern is matched after
+ *	these fixed number of bytes of received packet
  * @NUM_NL80211_WOWLAN_PKTPAT: number of attributes
  * @MAX_NL80211_WOWLAN_PKTPAT: max attribute number
  */
@@ -2394,6 +3034,7 @@ enum nl80211_wowlan_packet_pattern_attr {
 	__NL80211_WOWLAN_PKTPAT_INVALID,
 	NL80211_WOWLAN_PKTPAT_MASK,
 	NL80211_WOWLAN_PKTPAT_PATTERN,
+	NL80211_WOWLAN_PKTPAT_OFFSET,
 
 	NUM_NL80211_WOWLAN_PKTPAT,
 	MAX_NL80211_WOWLAN_PKTPAT = NUM_NL80211_WOWLAN_PKTPAT - 1,
@@ -2404,6 +3045,7 @@ enum nl80211_wowlan_packet_pattern_attr {
  * @max_patterns: maximum number of patterns supported
  * @min_pattern_len: minimum length of each pattern
  * @max_pattern_len: maximum length of each pattern
+ * @max_pkt_offset: maximum Rx packet offset
  *
  * This struct is carried in %NL80211_WOWLAN_TRIG_PKT_PATTERN when
  * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED in the
@@ -2413,6 +3055,7 @@ struct nl80211_wowlan_pattern_support {
 	__u32 max_patterns;
 	__u32 min_pattern_len;
 	__u32 max_pattern_len;
+	__u32 max_pkt_offset;
 } __attribute__((packed));
 
 /**
@@ -2428,12 +3071,17 @@ struct nl80211_wowlan_pattern_support {
  * @NL80211_WOWLAN_TRIG_PKT_PATTERN: wake up on the specified packet patterns
  *	which are passed in an array of nested attributes, each nested attribute
  *	defining a with attributes from &struct nl80211_wowlan_trig_pkt_pattern.
- *	Each pattern defines a wakeup packet. The matching is done on the MSDU,
- *	i.e. as though the packet was an 802.3 packet, so the pattern matching
- *	is done after the packet is converted to the MSDU.
+ *	Each pattern defines a wakeup packet. Packet offset is associated with
+ *	each pattern which is used while matching the pattern. The matching is
+ *	done on the MSDU, i.e. as though the packet was an 802.3 packet, so the
+ *	pattern matching is done after the packet is converted to the MSDU.
  *
  *	In %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED, it is a binary attribute
  *	carrying a &struct nl80211_wowlan_pattern_support.
+ *
+ *	When reporting wakeup. it is a u32 attribute containing the 0-based
+ *	index of the pattern that caused the wakeup, in the patterns passed
+ *	to the kernel when configuring.
  * @NL80211_WOWLAN_TRIG_GTK_REKEY_SUPPORTED: Not a real trigger, and cannot be
  *	used when setting, used only to indicate that GTK rekeying is supported
  *	by the device (flag)
@@ -2444,8 +3092,36 @@ struct nl80211_wowlan_pattern_support {
  * @NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE: wake up on 4-way handshake (flag)
  * @NL80211_WOWLAN_TRIG_RFKILL_RELEASE: wake up when rfkill is released
  *	(on devices that have rfkill in the device) (flag)
+ * @NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211: For wakeup reporting only, contains
+ *	the 802.11 packet that caused the wakeup, e.g. a deauth frame. The frame
+ *	may be truncated, the @NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211_LEN
+ *	attribute contains the original length.
+ * @NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211_LEN: Original length of the 802.11
+ *	packet, may be bigger than the @NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211
+ *	attribute if the packet was truncated somewhere.
+ * @NL80211_WOWLAN_TRIG_WAKEUP_PKT_8023: For wakeup reporting only, contains the
+ *	802.11 packet that caused the wakeup, e.g. a magic packet. The frame may
+ *	be truncated, the @NL80211_WOWLAN_TRIG_WAKEUP_PKT_8023_LEN attribute
+ *	contains the original length.
+ * @NL80211_WOWLAN_TRIG_WAKEUP_PKT_8023_LEN: Original length of the 802.3
+ *	packet, may be bigger than the @NL80211_WOWLAN_TRIG_WAKEUP_PKT_8023
+ *	attribute if the packet was truncated somewhere.
+ * @NL80211_WOWLAN_TRIG_TCP_CONNECTION: TCP connection wake, see DOC section
+ *	"TCP connection wakeup" for more details. This is a nested attribute
+ *	containing the exact information for establishing and keeping alive
+ *	the TCP connection.
+ * @NL80211_WOWLAN_TRIG_TCP_WAKEUP_MATCH: For wakeup reporting only, the
+ *	wakeup packet was received on the TCP connection
+ * @NL80211_WOWLAN_TRIG_WAKEUP_TCP_CONNLOST: For wakeup reporting only, the
+ *	TCP connection was lost or failed to be established
+ * @NL80211_WOWLAN_TRIG_WAKEUP_TCP_NOMORETOKENS: For wakeup reporting only,
+ *	the TCP connection ran out of tokens to use for data to send to the
+ *	service
  * @NUM_NL80211_WOWLAN_TRIG: number of wake on wireless triggers
  * @MAX_NL80211_WOWLAN_TRIG: highest wowlan trigger attribute number
+ *
+ * These nested attributes are used to configure the wakeup triggers and
+ * to report the wakeup reason(s).
  */
 enum nl80211_wowlan_triggers {
 	__NL80211_WOWLAN_TRIG_INVALID,
@@ -2458,6 +3134,14 @@ enum nl80211_wowlan_triggers {
 	NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST,
 	NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE,
 	NL80211_WOWLAN_TRIG_RFKILL_RELEASE,
+	NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211,
+	NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211_LEN,
+	NL80211_WOWLAN_TRIG_WAKEUP_PKT_8023,
+	NL80211_WOWLAN_TRIG_WAKEUP_PKT_8023_LEN,
+	NL80211_WOWLAN_TRIG_TCP_CONNECTION,
+	NL80211_WOWLAN_TRIG_WAKEUP_TCP_MATCH,
+	NL80211_WOWLAN_TRIG_WAKEUP_TCP_CONNLOST,
+	NL80211_WOWLAN_TRIG_WAKEUP_TCP_NOMORETOKENS,
 
 	/* keep last */
 	NUM_NL80211_WOWLAN_TRIG,
@@ -2465,6 +3149,116 @@ enum nl80211_wowlan_triggers {
 };
 
 /**
+ * DOC: TCP connection wakeup
+ *
+ * Some devices can establish a TCP connection in order to be woken up by a
+ * packet coming in from outside their network segment, or behind NAT. If
+ * configured, the device will establish a TCP connection to the given
+ * service, and periodically send data to that service. The first data
+ * packet is usually transmitted after SYN/ACK, also ACKing the SYN/ACK.
+ * The data packets can optionally include a (little endian) sequence
+ * number (in the TCP payload!) that is generated by the device, and, also
+ * optionally, a token from a list of tokens. This serves as a keep-alive
+ * with the service, and for NATed connections, etc.
+ *
+ * During this keep-alive period, the server doesn't send any data to the
+ * client. When receiving data, it is compared against the wakeup pattern
+ * (and mask) and if it matches, the host is woken up. Similarly, if the
+ * connection breaks or cannot be established to start with, the host is
+ * also woken up.
+ *
+ * Developer's note: ARP offload is required for this, otherwise TCP
+ * response packets might not go through correctly.
+ */
+
+/**
+ * struct nl80211_wowlan_tcp_data_seq - WoWLAN TCP data sequence
+ * @start: starting value
+ * @offset: offset of sequence number in packet
+ * @len: length of the sequence value to write, 1 through 4
+ *
+ * Note: don't confuse with the TCP sequence number(s), this is for the
+ * keepalive packet payload. The actual value is written into the packet
+ * in little endian.
+ */
+struct nl80211_wowlan_tcp_data_seq {
+	__u32 start, offset, len;
+};
+
+/**
+ * struct nl80211_wowlan_tcp_data_token - WoWLAN TCP data token config
+ * @offset: offset of token in packet
+ * @len: length of each token
+ * @token_stream: stream of data to be used for the tokens, the length must
+ *	be a multiple of @len for this to make sense
+ */
+struct nl80211_wowlan_tcp_data_token {
+	__u32 offset, len;
+	__u8 token_stream[];
+};
+
+/**
+ * struct nl80211_wowlan_tcp_data_token_feature - data token features
+ * @min_len: minimum token length
+ * @max_len: maximum token length
+ * @bufsize: total available token buffer size (max size of @token_stream)
+ */
+struct nl80211_wowlan_tcp_data_token_feature {
+	__u32 min_len, max_len, bufsize;
+};
+
+/**
+ * enum nl80211_wowlan_tcp_attrs - WoWLAN TCP connection parameters
+ * @__NL80211_WOWLAN_TCP_INVALID: invalid number for nested attributes
+ * @NL80211_WOWLAN_TCP_SRC_IPV4: source IPv4 address (in network byte order)
+ * @NL80211_WOWLAN_TCP_DST_IPV4: destination IPv4 address
+ *	(in network byte order)
+ * @NL80211_WOWLAN_TCP_DST_MAC: destination MAC address, this is given because
+ *	route lookup when configured might be invalid by the time we suspend,
+ *	and doing a route lookup when suspending is no longer possible as it
+ *	might require ARP querying.
+ * @NL80211_WOWLAN_TCP_SRC_PORT: source port (u16); optional, if not given a
+ *	socket and port will be allocated
+ * @NL80211_WOWLAN_TCP_DST_PORT: destination port (u16)
+ * @NL80211_WOWLAN_TCP_DATA_PAYLOAD: data packet payload, at least one byte.
+ *	For feature advertising, a u32 attribute holding the maximum length
+ *	of the data payload.
+ * @NL80211_WOWLAN_TCP_DATA_PAYLOAD_SEQ: data packet sequence configuration
+ *	(if desired), a &struct nl80211_wowlan_tcp_data_seq. For feature
+ *	advertising it is just a flag
+ * @NL80211_WOWLAN_TCP_DATA_PAYLOAD_TOKEN: data packet token configuration,
+ *	see &struct nl80211_wowlan_tcp_data_token and for advertising see
+ *	&struct nl80211_wowlan_tcp_data_token_feature.
+ * @NL80211_WOWLAN_TCP_DATA_INTERVAL: data interval in seconds, maximum
+ *	interval in feature advertising (u32)
+ * @NL80211_WOWLAN_TCP_WAKE_PAYLOAD: wake packet payload, for advertising a
+ *	u32 attribute holding the maximum length
+ * @NL80211_WOWLAN_TCP_WAKE_MASK: Wake packet payload mask, not used for
+ *	feature advertising. The mask works like @NL80211_WOWLAN_PKTPAT_MASK
+ *	but on the TCP payload only.
+ * @NUM_NL80211_WOWLAN_TCP: number of TCP attributes
+ * @MAX_NL80211_WOWLAN_TCP: highest attribute number
+ */
+enum nl80211_wowlan_tcp_attrs {
+	__NL80211_WOWLAN_TCP_INVALID,
+	NL80211_WOWLAN_TCP_SRC_IPV4,
+	NL80211_WOWLAN_TCP_DST_IPV4,
+	NL80211_WOWLAN_TCP_DST_MAC,
+	NL80211_WOWLAN_TCP_SRC_PORT,
+	NL80211_WOWLAN_TCP_DST_PORT,
+	NL80211_WOWLAN_TCP_DATA_PAYLOAD,
+	NL80211_WOWLAN_TCP_DATA_PAYLOAD_SEQ,
+	NL80211_WOWLAN_TCP_DATA_PAYLOAD_TOKEN,
+	NL80211_WOWLAN_TCP_DATA_INTERVAL,
+	NL80211_WOWLAN_TCP_WAKE_PAYLOAD,
+	NL80211_WOWLAN_TCP_WAKE_MASK,
+
+	/* keep last */
+	NUM_NL80211_WOWLAN_TCP,
+	MAX_NL80211_WOWLAN_TCP = NUM_NL80211_WOWLAN_TCP - 1
+};
+
+/**
  * enum nl80211_iface_limit_attrs - limit attributes
  * @NL80211_IFACE_LIMIT_UNSPEC: (reserved)
  * @NL80211_IFACE_LIMIT_MAX: maximum number of interfaces that
@@ -2500,6 +3294,8 @@ enum nl80211_iface_limit_attrs {
  *	the infrastructure network's beacon interval.
  * @NL80211_IFACE_COMB_NUM_CHANNELS: u32 attribute specifying how many
  *	different channels may be used within this group.
+ * @NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS: u32 attribute containing the bitmap
+ *	of supported channel widths for radar detection.
  * @NUM_NL80211_IFACE_COMB: number of attributes
  * @MAX_NL80211_IFACE_COMB: highest attribute number
  *
@@ -2532,6 +3328,7 @@ enum nl80211_if_combination_attrs {
 	NL80211_IFACE_COMB_MAXNUM,
 	NL80211_IFACE_COMB_STA_AP_BI_MATCH,
 	NL80211_IFACE_COMB_NUM_CHANNELS,
+	NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
 
 	/* keep last */
 	NUM_NL80211_IFACE_COMB,
@@ -2571,6 +3368,23 @@ enum nl80211_plink_state {
 	MAX_NL80211_PLINK_STATES = NUM_NL80211_PLINK_STATES - 1
 };
 
+/**
+ * enum nl80211_plink_action - actions to perform in mesh peers
+ *
+ * @NL80211_PLINK_ACTION_NO_ACTION: perform no action
+ * @NL80211_PLINK_ACTION_OPEN: start mesh peer link establishment
+ * @NL80211_PLINK_ACTION_BLOCK: block traffic from this mesh peer
+ * @NUM_NL80211_PLINK_ACTIONS: number of possible actions
+ */
+enum plink_actions {
+	NL80211_PLINK_ACTION_NO_ACTION,
+	NL80211_PLINK_ACTION_OPEN,
+	NL80211_PLINK_ACTION_BLOCK,
+
+	NUM_NL80211_PLINK_ACTIONS,
+};
+
+
 #define NL80211_KCK_LEN			16
 #define NL80211_KEK_LEN			16
 #define NL80211_REPLAY_CTR_LEN		8
@@ -2669,4 +3483,203 @@ enum nl80211_tdls_operation {
 	NL80211_TDLS_DISABLE_LINK,
 };
 
+/*
+ * enum nl80211_ap_sme_features - device-integrated AP features
+ * Reserved for future use, no bits are defined in
+ * NL80211_ATTR_DEVICE_AP_SME yet.
+enum nl80211_ap_sme_features {
+};
+ */
+
+/**
+ * enum nl80211_feature_flags - device/driver features
+ * @NL80211_FEATURE_SK_TX_STATUS: This driver supports reflecting back
+ *	TX status to the socket error queue when requested with the
+ *	socket option.
+ * @NL80211_FEATURE_HT_IBSS: This driver supports IBSS with HT datarates.
+ * @NL80211_FEATURE_INACTIVITY_TIMER: This driver takes care of freeing up
+ *	the connected inactive stations in AP mode.
+ * @NL80211_FEATURE_CELL_BASE_REG_HINTS: This driver has been tested
+ *	to work properly to suppport receiving regulatory hints from
+ *	cellular base stations.
+ * @NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL: If this is set, an active
+ *	P2P Device (%NL80211_IFTYPE_P2P_DEVICE) requires its own channel
+ *	in the interface combinations, even when it's only used for scan
+ *	and remain-on-channel. This could be due to, for example, the
+ *	remain-on-channel implementation requiring a channel context.
+ * @NL80211_FEATURE_SAE: This driver supports simultaneous authentication of
+ *	equals (SAE) with user space SME (NL80211_CMD_AUTHENTICATE) in station
+ *	mode
+ * @NL80211_FEATURE_LOW_PRIORITY_SCAN: This driver supports low priority scan
+ * @NL80211_FEATURE_SCAN_FLUSH: Scan flush is supported
+ * @NL80211_FEATURE_AP_SCAN: Support scanning using an AP vif
+ * @NL80211_FEATURE_VIF_TXPOWER: The driver supports per-vif TX power setting
+ * @NL80211_FEATURE_NEED_OBSS_SCAN: The driver expects userspace to perform
+ *	OBSS scans and generate 20/40 BSS coex reports. This flag is used only
+ *	for drivers implementing the CONNECT API, for AUTH/ASSOC it is implied.
+ * @NL80211_FEATURE_P2P_GO_CTWIN: P2P GO implementation supports CT Window
+ *	setting
+ * @NL80211_FEATURE_P2P_GO_OPPPS: P2P GO implementation supports opportunistic
+ *	powersave
+ * @NL80211_FEATURE_FULL_AP_CLIENT_STATE: The driver supports full state
+ *	transitions for AP clients. Without this flag (and if the driver
+ *	doesn't have the AP SME in the device) the driver supports adding
+ *	stations only when they're associated and adds them in associated
+ *	state (to later be transitioned into authorized), with this flag
+ *	they should be added before even sending the authentication reply
+ *	and then transitioned into authenticated, associated and authorized
+ *	states using station flags.
+ *	Note that even for drivers that support this, the default is to add
+ *	stations in authenticated/associated state, so to add unauthenticated
+ *	stations the authenticated/associated bits have to be set in the mask.
+ * @NL80211_FEATURE_ADVERTISE_CHAN_LIMITS: cfg80211 advertises channel limits
+ *	(HT40, VHT 80/160 MHz) if this flag is set
+ * @NL80211_FEATURE_USERSPACE_MPM: This driver supports a userspace Mesh
+ *	Peering Management entity which may be implemented by registering for
+ *	beacons or NL80211_CMD_NEW_PEER_CANDIDATE events. The mesh beacon is
+ *	still generated by the driver.
+ */
+enum nl80211_feature_flags {
+	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
+	NL80211_FEATURE_HT_IBSS				= 1 << 1,
+	NL80211_FEATURE_INACTIVITY_TIMER		= 1 << 2,
+	NL80211_FEATURE_CELL_BASE_REG_HINTS		= 1 << 3,
+	NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL	= 1 << 4,
+	NL80211_FEATURE_SAE				= 1 << 5,
+	NL80211_FEATURE_LOW_PRIORITY_SCAN		= 1 << 6,
+	NL80211_FEATURE_SCAN_FLUSH			= 1 << 7,
+	NL80211_FEATURE_AP_SCAN				= 1 << 8,
+	NL80211_FEATURE_VIF_TXPOWER			= 1 << 9,
+	NL80211_FEATURE_NEED_OBSS_SCAN			= 1 << 10,
+	NL80211_FEATURE_P2P_GO_CTWIN			= 1 << 11,
+	NL80211_FEATURE_P2P_GO_OPPPS			= 1 << 12,
+	/* bit 13 is reserved */
+	NL80211_FEATURE_ADVERTISE_CHAN_LIMITS		= 1 << 14,
+	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 15,
+	NL80211_FEATURE_USERSPACE_MPM			= 1 << 16,
+};
+
+/**
+ * enum nl80211_probe_resp_offload_support_attr - optional supported
+ *	protocols for probe-response offloading by the driver/FW.
+ *	To be used with the %NL80211_ATTR_PROBE_RESP_OFFLOAD attribute.
+ *	Each enum value represents a bit in the bitmap of supported
+ *	protocols. Typically a subset of probe-requests belonging to a
+ *	supported protocol will be excluded from offload and uploaded
+ *	to the host.
+ *
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS: Support for WPS ver. 1
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2: Support for WPS ver. 2
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P: Support for P2P
+ * @NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U: Support for 802.11u
+ */
+enum nl80211_probe_resp_offload_support_attr {
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS =	1<<0,
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 =	1<<1,
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P =	1<<2,
+	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U =	1<<3,
+};
+
+/**
+ * enum nl80211_connect_failed_reason - connection request failed reasons
+ * @NL80211_CONN_FAIL_MAX_CLIENTS: Maximum number of clients that can be
+ *	handled by the AP is reached.
+ * @NL80211_CONN_FAIL_BLOCKED_CLIENT: Connection request is rejected due to ACL.
+ */
+enum nl80211_connect_failed_reason {
+	NL80211_CONN_FAIL_MAX_CLIENTS,
+	NL80211_CONN_FAIL_BLOCKED_CLIENT,
+};
+
+/**
+ * enum nl80211_scan_flags -  scan request control flags
+ *
+ * Scan request control flags are used to control the handling
+ * of NL80211_CMD_TRIGGER_SCAN and NL80211_CMD_START_SCHED_SCAN
+ * requests.
+ *
+ * @NL80211_SCAN_FLAG_LOW_PRIORITY: scan request has low priority
+ * @NL80211_SCAN_FLAG_FLUSH: flush cache before scanning
+ * @NL80211_SCAN_FLAG_AP: force a scan even if the interface is configured
+ *	as AP and the beaconing has already been configured. This attribute is
+ *	dangerous because will destroy stations performance as a lot of frames
+ *	will be lost while scanning off-channel, therefore it must be used only
+ *	when really needed
+ */
+enum nl80211_scan_flags {
+	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
+	NL80211_SCAN_FLAG_FLUSH				= 1<<1,
+	NL80211_SCAN_FLAG_AP				= 1<<2,
+};
+
+/**
+ * enum nl80211_acl_policy - access control policy
+ *
+ * Access control policy is applied on a MAC list set by
+ * %NL80211_CMD_START_AP and %NL80211_CMD_SET_MAC_ACL, to
+ * be used with %NL80211_ATTR_ACL_POLICY.
+ *
+ * @NL80211_ACL_POLICY_ACCEPT_UNLESS_LISTED: Deny stations which are
+ *	listed in ACL, i.e. allow all the stations which are not listed
+ *	in ACL to authenticate.
+ * @NL80211_ACL_POLICY_DENY_UNLESS_LISTED: Allow the stations which are listed
+ *	in ACL, i.e. deny all the stations which are not listed in ACL.
+ */
+enum nl80211_acl_policy {
+	NL80211_ACL_POLICY_ACCEPT_UNLESS_LISTED,
+	NL80211_ACL_POLICY_DENY_UNLESS_LISTED,
+};
+
+/**
+ * enum nl80211_radar_event - type of radar event for DFS operation
+ *
+ * Type of event to be used with NL80211_ATTR_RADAR_EVENT to inform userspace
+ * about detected radars or success of the channel available check (CAC)
+ *
+ * @NL80211_RADAR_DETECTED: A radar pattern has been detected. The channel is
+ *	now unusable.
+ * @NL80211_RADAR_CAC_FINISHED: Channel Availability Check has been finished,
+ *	the channel is now available.
+ * @NL80211_RADAR_CAC_ABORTED: Channel Availability Check has been aborted, no
+ *	change to the channel status.
+ * @NL80211_RADAR_NOP_FINISHED: The Non-Occupancy Period for this channel is
+ *	over, channel becomes usable.
+ */
+enum nl80211_radar_event {
+	NL80211_RADAR_DETECTED,
+	NL80211_RADAR_CAC_FINISHED,
+	NL80211_RADAR_CAC_ABORTED,
+	NL80211_RADAR_NOP_FINISHED,
+};
+
+/**
+ * enum nl80211_dfs_state - DFS states for channels
+ *
+ * Channel states used by the DFS code.
+ *
+ * @IEEE80211_DFS_USABLE: The channel can be used, but channel availability
+ *	check (CAC) must be performed before using it for AP or IBSS.
+ * @IEEE80211_DFS_UNAVAILABLE: A radar has been detected on this channel, it
+ *	is therefore marked as not available.
+ * @IEEE80211_DFS_AVAILABLE: The channel has been CAC checked and is available.
+ */
+
+enum nl80211_dfs_state {
+	NL80211_DFS_USABLE,
+	NL80211_DFS_UNAVAILABLE,
+	NL80211_DFS_AVAILABLE,
+};
+
+/**
+ * enum enum nl80211_protocol_features - nl80211 protocol features
+ * @NL80211_PROTOCOL_FEATURE_SPLIT_WIPHY_DUMP: nl80211 supports splitting
+ *	wiphy dumps (if requested by the application with the attribute
+ *	%NL80211_ATTR_SPLIT_WIPHY_DUMP. Also supported is filtering the
+ *	wiphy dump by %NL80211_ATTR_WIPHY, %NL80211_ATTR_IFINDEX or
+ *	%NL80211_ATTR_WDEV.
+ */
+enum nl80211_protocol_features {
+	NL80211_PROTOCOL_FEATURE_SPLIT_WIPHY_DUMP =	1 << 0,
+};
+
 #endif /* __LINUX_NL80211_H */
-- 
1.7.4.1

