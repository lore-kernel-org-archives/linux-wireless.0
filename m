Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46099 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab0I0KqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 06:46:01 -0400
Subject: [RFC] cfg80211: add p2p listen API
From: Johannes Berg <johannes@sipsolutions.net>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 12:45:58 +0200
Message-ID: <1285584358.4043.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To offload P2P find and P2P extended listen to the
device, new API is necessary. This defines the API,
please let me know if you think this is sufficient
and correct.

Sanity checks that I think I will add to the code:

 * the commands can only be called and will only be
   advertised if WIPHY_FLAG_SUPPORTS_P2P_LISTEN is
   also set, this is to allow mac80211 to properly
   pass this through to drivers that support it

 * the netdev must be in p2p-client or p2p-go modes

 * The listen period must be specified unless a scan
   is also specified (otherwise you'd expect to get
   back-to-back off-channel operation which is like
   just one long off-channel)

 * You cannot do remain-on-channel while a p2p-listen
   is active.

 * GO negotiation will still use remain-on-channel

 * need to figure out what you can do while this is
   active -- an you try to associate? I think not.

 * need to figure out when this is allowed to be
   activated -- all the time? just at certain times
   (in terms of the state the device is in)? For
   example, should a p2p-find be allowed while a GO
   is active? That'd require some timing/scheduling
   from the driver...

Other thoughts?

johannes
---
 include/linux/nl80211.h |   30 ++++++++++++++++++++++++++++++
 include/net/cfg80211.h  |   28 ++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

--- wireless-testing.orig/include/linux/nl80211.h	2010-09-24 18:50:14.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2010-09-27 12:27:44.000000000 +0200
@@ -387,6 +387,21 @@
  *	of any other interfaces, and other interfaces will again take
  *	precedence when they are used.
  *
+ * @NL80211_CMD_START_P2P_LISTEN: Start P2P listen state, with device offload;
+ *	if not implemented but p2p is supported, @NL80211_CMD_REMAIN_ON_CHANNEL
+ *	will be used. Timing is specified via the attributes
+ *	%NL80211_ATTR_P2P_LISTEN_PERIOD, %NL80211_ATTR_P2P_LISTEN_INT_MIN and
+ *	%NL80211_ATTR_P2P_LISTEN_INT_MAX, where the period is optional if a
+ *	scan is also configured.
+ *	Additionally, scanning may be specified by passing the attributes
+ *	%NL80211_ATTR_SCAN_FREQUENCIES and %NL80211_ATTR_SCAN_SSIDS (and
+ *	optionally %NL80211_ATTR_IE.) If so, the driver will do the scan
+ *	(approximately) every listen period. If no listen period is specified,
+ *	it should be as quick as possible (essentially back-to-back as defined
+ *	in "3.1.2.1.3 Find Phase.")
+ *
+ * @NL80211_CMD_STOP_P2P_LISTEN: Stop a P2P listen/find phase.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -490,6 +505,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_CHANNEL,
 
+	NL80211_CMD_START_P2P_LISTEN,
+	NL80211_CMD_STOP_P2P_LISTEN,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -801,6 +819,14 @@ enum nl80211_commands {
  * @NL80211_ATTR_SUPPORT_IBSS_RSN: The device supports IBSS RSN, which mostly
  *	means support for per-station GTKs.
  *
+ * @NL80211_ATTR_P2P_LISTEN_PERIOD: The p2p listen period, specified in units
+ *	of 100 TU.
+ * @NL80211_ATTR_P2P_LISTEN_INT_MIN: The p2p listen discoverable interval min,
+ *	specified in units of 100 TU. Use the same as the max for extended
+ *	listen.
+ * @NL80211_ATTR_P2P_LISTEN_INT_MAX: The p2p listen discoverable interval max,
+ *	specified in utils of 100 TU.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -970,6 +996,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SUPPORT_IBSS_RSN,
 
+	NL80211_ATTR_P2P_LISTEN_PERIOD,
+	NL80211_ATTR_P2P_LISTEN_INT_MIN,
+	NL80211_ATTR_P2P_LISTEN_INT_MAX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- wireless-testing.orig/include/net/cfg80211.h	2010-09-27 12:28:11.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-09-27 12:34:41.000000000 +0200
@@ -978,6 +978,25 @@ struct cfg80211_pmksa {
 };
 
 /**
+ * struct p2p_listen_cfg - P2P listen configuration
+ * @listen_chan: The listen channel
+ * @scan_req: additional scan request
+ * @listen_period: The periodicity of this listen request, may be zero
+ *	if there should be no pause (only if scan_req is also specified.)
+ *	Given in units of 100 TU.
+ * @listen_int_max: The time spent on the listen channel should be
+ *	randomized in each round between @listen_int_min and this,
+ *	both values are given in units of 100 TU.
+ * @listen_int_min: See @listen_int_max.
+ */
+struct p2p_listen_cfg {
+	struct ieee80211_channel *listen_chan;
+	struct cfg80211_scan_request *scan_req;
+	u32 listen_period;
+	u8 listen_int_max, listen_int_min;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -1112,6 +1131,8 @@ struct cfg80211_pmksa {
  * @set_power_mgmt: Configure WLAN power management. A timeout value of -1
  *	allows the driver to adjust the dynamic ps timeout value.
  * @set_cqm_rssi_config: Configure connection quality monitor RSSI threshold.
+ * @start_p2p_listen: start P2P listen operation
+ * @stop_p2p_listen: stop P2P listen operation
  *
  */
 struct cfg80211_ops {
@@ -1263,6 +1284,10 @@ struct cfg80211_ops {
 	int	(*set_cqm_rssi_config)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       s32 rssi_thold, u32 rssi_hyst);
+
+	int	(*start_p2p_listen)(struct wiphy *wiphy, struct net_device *dev,
+				    struct p2p_listen_cfg *cfg);
+	int	(*stop_p2p_listen)(struct wiphy *wiphy, struct net_device *dev);
 };
 
 /*
@@ -1304,6 +1329,8 @@ struct cfg80211_ops {
  *	control port protocol ethertype. The device also honours the
  *	control_port_no_encrypt flag.
  * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
+ * @WIPHY_FLAG_SUPPORTS_P2P_LISTEN: The device supports the P2P listen
+ *	command (it must also support p2p device types.)
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1315,6 +1342,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(7),
+	WIPHY_FLAG_SUPPORTS_P2P_LISTEN		= BIT(8),
 };
 
 struct mac_address {


