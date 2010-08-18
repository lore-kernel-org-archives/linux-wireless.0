Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab0HRPoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 11:44:39 -0400
Subject: [PATCH v2] nl80211: some documentation fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1282138230.5249.0.camel@jlt3.sipsolutions.net>
References: <1282138230.5249.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 17:44:36 +0200
Message-ID: <1282146276.5249.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The nl80211 documentation is currently never
generated, so problems have accumulated. Fix
most of the trivial ones.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Forgotten quilt refresh? Not sure what the change even was...

 include/linux/nl80211.h |   57 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 11 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2010-08-18 17:37:48.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2010-08-18 17:43:51.000000000 +0200
@@ -347,6 +347,8 @@
  *	four bytes for vendor frames including the OUI. The registration
  *	cannot be dropped, but is removed automatically when the netlink
  *	socket is closed. Multiple registrations can be made.
+ * @NL80211_CMD_REGISTER_ACTION: Alias for @NL80211_CMD_REGISTER_FRAME for
+ *	backward compatibility
  * @NL80211_CMD_FRAME: Management frame TX request and RX notification. This
  *	command is used both as a request to transmit a management frame and
  *	as an event indicating reception of a frame that was not processed in
@@ -359,11 +361,14 @@
  *	operational channel). When called, this operation returns a cookie
  *	(%NL80211_ATTR_COOKIE) that will be included with the TX status event
  *	pertaining to the TX request.
+ * @NL80211_CMD_ACTION: Alias for @NL80211_CMD_FRAME for backward compatibility.
  * @NL80211_CMD_FRAME_TX_STATUS: Report TX status of a management frame
  *	transmitted with %NL80211_CMD_FRAME. %NL80211_ATTR_COOKIE identifies
  *	the TX command and %NL80211_ATTR_FRAME includes the contents of the
  *	frame. %NL80211_ATTR_ACK flag is included if the recipient acknowledged
  *	the frame.
+ * @NL80211_CMD_ACTION_TX_STATUS: Alias for @NL80211_CMD_FRAME_TX_STATUS for
+ *	backward compatibility.
  * @NL80211_CMD_SET_CQM: Connection quality monitor configuration. This command
  *	is used to configure connection quality monitoring notification trigger
  *	levels.
@@ -1034,11 +1039,14 @@ enum nl80211_iftype {
  * Station flags. When a station is added to an AP interface, it is
  * assumed to be already associated (and hence authenticated.)
  *
+ * @__NL80211_STA_FLAG_INVALID: attribute number 0 is reserved
  * @NL80211_STA_FLAG_AUTHORIZED: station is authorized (802.1X)
  * @NL80211_STA_FLAG_SHORT_PREAMBLE: station is capable of receiving frames
  *	with short barker preamble
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
  * @NL80211_STA_FLAG_MFP: station uses management frame protection
+ * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
+ * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
 enum nl80211_sta_flags {
 	__NL80211_STA_FLAG_INVALID,
@@ -1151,14 +1159,17 @@ enum nl80211_mpath_flags {
  * information about a mesh path.
  *
  * @__NL80211_MPATH_INFO_INVALID: attribute number 0 is reserved
- * @NL80211_ATTR_MPATH_FRAME_QLEN: number of queued frames for this destination
- * @NL80211_ATTR_MPATH_SN: destination sequence number
- * @NL80211_ATTR_MPATH_METRIC: metric (cost) of this mesh path
- * @NL80211_ATTR_MPATH_EXPTIME: expiration time for the path, in msec from now
- * @NL80211_ATTR_MPATH_FLAGS: mesh path flags, enumerated in
+ * @NL80211_MPATH_INFO_FRAME_QLEN: number of queued frames for this destination
+ * @NL80211_MPATH_INFO_SN: destination sequence number
+ * @NL80211_MPATH_INFO_METRIC: metric (cost) of this mesh path
+ * @NL80211_MPATH_INFO_EXPTIME: expiration time for the path, in msec from now
+ * @NL80211_MPATH_INFO_FLAGS: mesh path flags, enumerated in
  * 	&enum nl80211_mpath_flags;
- * @NL80211_ATTR_MPATH_DISCOVERY_TIMEOUT: total path discovery timeout, in msec
- * @NL80211_ATTR_MPATH_DISCOVERY_RETRIES: mesh path discovery retries
+ * @NL80211_MPATH_INFO_DISCOVERY_TIMEOUT: total path discovery timeout, in msec
+ * @NL80211_MPATH_INFO_DISCOVERY_RETRIES: mesh path discovery retries
+ * @NL80211_MPATH_INFO_MAX: highest mesh path information attribute number
+ *	currently defind
+ * @__NL80211_MPATH_INFO_AFTER_LAST: internal use
  */
 enum nl80211_mpath_info {
 	__NL80211_MPATH_INFO_INVALID,
@@ -1187,6 +1198,8 @@ enum nl80211_mpath_info {
  * @NL80211_BAND_ATTR_HT_CAPA: HT capabilities, as in the HT information IE
  * @NL80211_BAND_ATTR_HT_AMPDU_FACTOR: A-MPDU factor, as in 11n
  * @NL80211_BAND_ATTR_HT_AMPDU_DENSITY: A-MPDU density, as in 11n
+ * @NL80211_BAND_ATTR_MAX: highest band attribute currently defined
+ * @__NL80211_BAND_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_band_attr {
 	__NL80211_BAND_ATTR_INVALID,
@@ -1207,6 +1220,7 @@ enum nl80211_band_attr {
 
 /**
  * enum nl80211_frequency_attr - frequency attributes
+ * @__NL80211_FREQUENCY_ATTR_INVALID: attribute number 0 is reserved
  * @NL80211_FREQUENCY_ATTR_FREQ: Frequency in MHz
  * @NL80211_FREQUENCY_ATTR_DISABLED: Channel is disabled in current
  *	regulatory domain.
@@ -1218,6 +1232,9 @@ enum nl80211_band_attr {
  *	on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in mBm
  *	(100 * dBm).
+ * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
+ *	currently defined
+ * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_frequency_attr {
 	__NL80211_FREQUENCY_ATTR_INVALID,
@@ -1237,9 +1254,13 @@ enum nl80211_frequency_attr {
 
 /**
  * enum nl80211_bitrate_attr - bitrate attributes
+ * @__NL80211_BITRATE_ATTR_INVALID: attribute number 0 is reserved
  * @NL80211_BITRATE_ATTR_RATE: Bitrate in units of 100 kbps
  * @NL80211_BITRATE_ATTR_2GHZ_SHORTPREAMBLE: Short preamble supported
  *	in 2.4 GHz band.
+ * @NL80211_BITRATE_ATTR_MAX: highest bitrate attribute number
+ *	currently defined
+ * @__NL80211_BITRATE_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_bitrate_attr {
 	__NL80211_BITRATE_ATTR_INVALID,
@@ -1295,6 +1316,7 @@ enum nl80211_reg_type {
 
 /**
  * enum nl80211_reg_rule_attr - regulatory rule attributes
+ * @__NL80211_REG_RULE_ATTR_INVALID: attribute number 0 is reserved
  * @NL80211_ATTR_REG_RULE_FLAGS: a set of flags which specify additional
  * 	considerations for a given frequency range. These are the
  * 	&enum nl80211_reg_rule_flags.
@@ -1311,6 +1333,9 @@ enum nl80211_reg_type {
  * 	If you don't have one then don't send this.
  * @NL80211_ATTR_POWER_RULE_MAX_EIRP: the maximum allowed EIRP for
  * 	a given frequency range. The value is in mBm (100 * dBm).
+ * @NL80211_REG_RULE_ATTR_MAX: highest regulatory rule attribute number
+ *	currently defined
+ * @__NL80211_REG_RULE_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_reg_rule_attr {
 	__NL80211_REG_RULE_ATTR_INVALID,
@@ -1362,6 +1387,9 @@ enum nl80211_reg_rule_flags {
  * @__NL80211_SURVEY_INFO_INVALID: attribute number 0 is reserved
  * @NL80211_SURVEY_INFO_FREQUENCY: center frequency of channel
  * @NL80211_SURVEY_INFO_NOISE: noise level of channel (u8, dBm)
+ * @NL80211_SURVEY_INFO_MAX: highest survey info attribute number
+ *	currently defined
+ * @__NL80211_SURVEY_INFO_AFTER_LAST: internal use
  */
 enum nl80211_survey_info {
 	__NL80211_SURVEY_INFO_INVALID,
@@ -1526,6 +1554,7 @@ enum nl80211_channel_type {
  * enum nl80211_bss - netlink attributes for a BSS
  *
  * @__NL80211_BSS_INVALID: invalid
+ * @NL80211_BSS_BSSID: BSSID of the BSS (6 octets)
  * @NL80211_BSS_FREQUENCY: frequency in MHz (u32)
  * @NL80211_BSS_TSF: TSF of the received probe response/beacon (u64)
  * @NL80211_BSS_BEACON_INTERVAL: beacon interval of the (I)BSS (u16)
@@ -1569,6 +1598,12 @@ enum nl80211_bss {
 
 /**
  * enum nl80211_bss_status - BSS "status"
+ * @NL80211_BSS_STATUS_AUTHENTICATED: Authenticated with this BSS.
+ * @NL80211_BSS_STATUS_ASSOCIATED: Associated with this BSS.
+ * @NL80211_BSS_STATUS_IBSS_JOINED: Joined to this IBSS.
+ *
+ * The BSS status is a BSS attribute in scan dumps, which
+ * indicates the status the interface has wrt. this BSS.
  */
 enum nl80211_bss_status {
 	NL80211_BSS_STATUS_AUTHENTICATED,
@@ -1686,8 +1721,8 @@ enum nl80211_tx_rate_attributes {
 
 /**
  * enum nl80211_band - Frequency band
- * @NL80211_BAND_2GHZ - 2.4 GHz ISM band
- * @NL80211_BAND_5GHZ - around 5 GHz band (4.9 - 5.7 GHz)
+ * @NL80211_BAND_2GHZ: 2.4 GHz ISM band
+ * @NL80211_BAND_5GHZ: around 5 GHz band (4.9 - 5.7 GHz)
  */
 enum nl80211_band {
 	NL80211_BAND_2GHZ,
@@ -1725,9 +1760,9 @@ enum nl80211_attr_cqm {
 
 /**
  * enum nl80211_cqm_rssi_threshold_event - RSSI threshold event
- * @NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW - The RSSI level is lower than the
+ * @NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW: The RSSI level is lower than the
  *      configured threshold
- * @NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH - The RSSI is higher than the
+ * @NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH: The RSSI is higher than the
  *      configured threshold
  */
 enum nl80211_cqm_rssi_threshold_event {


