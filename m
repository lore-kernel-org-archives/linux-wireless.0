Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:41798 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab1BIMCG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 07:02:06 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.neratec.ch (Postfix) with ESMTP id B43FD664005
	for <linux-wireless@vger.kernel.org>; Wed,  9 Feb 2011 13:02:03 +0100 (CET)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 2/3] hostapd: nl80211 interface
Date: Wed,  9 Feb 2011 13:01:44 +0100
Message-Id: <1297252905-29739-5-git-send-email-zefir.kurtisi@neratec.com>
In-Reply-To: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interface implementation to process DFS pulse events passed through nl80211.

Includes
 * update nl80211_copy.h
 * parsing of NL80211_CMD_SET_DFS_EVENT messages and forwarding it to detector
---
 src/drivers/driver_nl80211.c |   55 ++++++++++++++++++++++++
 src/drivers/nl80211_copy.h   |   95 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 137 insertions(+), 13 deletions(-)

diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index afb72a6..3707673 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -41,6 +41,12 @@
 #include "rfkill.h"
 #include "driver.h"
 
+#ifdef CONFIG_DFS_DETECTOR
+#include "dfs/dfs.h"
+#endif
+
+
+
 #ifdef CONFIG_LIBNL20
 /* libnl 2.0 compatibility code */
 #define nl_handle nl_sock
@@ -1298,6 +1304,52 @@ static void nl80211_new_station_event(struct wpa_driver_nl80211_data *drv,
 	wpa_supplicant_event(drv->ctx, EVENT_IBSS_RSN_START, &data);
 }
 
+#ifdef CONFIG_DFS_DETECTOR
+static void nl80211_dfs_event(struct wpa_driver_nl80211_data *drv,
+			      struct nlattr *tb[])
+{
+	unsigned int if_index = 0;
+	struct nlattr *tp;
+	struct pulse_event event;
+
+	if (global_dfs_handler == NULL)
+		return;
+
+	memset(&event, 0, sizeof(event));
+
+	tp = tb[NL80211_ATTR_IFINDEX];
+	if (tp)
+		if_index = nla_get_u32(tp);
+	tp = tb[NL80211_DFSEVENT_ATTR_FREQ];
+	if (tp)
+		event.freq = nla_get_u16(tp);
+	tp = tb[NL80211_DFSEVENT_ATTR_TS];
+	if (tp)
+		event.ts = nla_get_u64(tp);
+	tp = tb[NL80211_DFSEVENT_ATTR_WIDTH];
+	if (tp)
+		event.width = nla_get_u8(tp);
+
+	wpa_printf(MSG_ERROR, "nl80211_dfs_event: if_index=%d, freq=%d, "
+			"ts=%llu, width=%d)\n", if_index,
+			event.freq, event.ts, event.width);
+
+	/* TBD: handle pulse per device based on if_index */
+	if (global_dfs_handler->add_pulse(global_dfs_handler, &event)) {
+		wpa_printf(MSG_ERROR, "******** radar detected on freq %d\n",
+				event.freq);
+	}
+
+}
+#else
+static void nl80211_dfs_event(struct wpa_driver_nl80211_data *drv,
+			      struct nlattr *tb[])
+{
+	return;
+}
+#endif
+
+
 
 static int process_event(struct nl_msg *msg, void *arg)
 {
@@ -1414,6 +1466,9 @@ static int process_event(struct nl_msg *msg, void *arg)
 	case NL80211_CMD_NEW_STATION:
 		nl80211_new_station_event(drv, tb);
 		break;
+	case NL80211_CMD_SET_DFS_EVENT:
+		nl80211_dfs_event(drv, tb);
+		break;
 	default:
 		wpa_printf(MSG_DEBUG, "nl80211: Ignored unknown event "
 			   "(cmd=%d)", gnlh->cmd);
diff --git a/src/drivers/nl80211_copy.h b/src/drivers/nl80211_copy.h
index 7483a89..ae3f6ae 100644
--- a/src/drivers/nl80211_copy.h
+++ b/src/drivers/nl80211_copy.h
@@ -148,6 +148,10 @@
  * @NL80211_CMD_SET_MPATH:  Set mesh path attributes for mesh path to
  * 	destination %NL80211_ATTR_MAC on the interface identified by
  * 	%NL80211_ATTR_IFINDEX.
+ * @NL80211_CMD_NEW_MPATH: Create a new mesh path for the destination given by
+ *	%NL80211_ATTR_MAC via %NL80211_ATTR_MPATH_NEXT_HOP.
+ * @NL80211_CMD_DEL_MPATH: Delete a mesh path to the destination given by
+ *	%NL80211_ATTR_MAC.
  * @NL80211_CMD_NEW_PATH: Add a mesh path with given attributes to the
  *	the interface identified by %NL80211_ATTR_IFINDEX.
  * @NL80211_CMD_DEL_PATH: Remove a mesh path identified by %NL80211_ATTR_MAC
@@ -172,10 +176,10 @@
  * 	to the specified ISO/IEC 3166-1 alpha2 country code. The core will
  * 	store this as a valid request and then query userspace for it.
  *
- * @NL80211_CMD_GET_MESH_PARAMS: Get mesh networking properties for the
+ * @NL80211_CMD_GET_MESH_CONFIG: Get mesh networking properties for the
  *	interface identified by %NL80211_ATTR_IFINDEX
  *
- * @NL80211_CMD_SET_MESH_PARAMS: Set mesh networking properties for the
+ * @NL80211_CMD_SET_MESH_CONFIG: Set mesh networking properties for the
  *      interface identified by %NL80211_ATTR_IFINDEX
  *
  * @NL80211_CMD_SET_MGMT_EXTRA_IE: Set extra IEs for management frames. The
@@ -448,8 +452,8 @@ enum nl80211_commands {
 	NL80211_CMD_SET_REG,
 	NL80211_CMD_REQ_SET_REG,
 
-	NL80211_CMD_GET_MESH_PARAMS,
-	NL80211_CMD_SET_MESH_PARAMS,
+	NL80211_CMD_GET_MESH_CONFIG,
+	NL80211_CMD_SET_MESH_CONFIG,
 
 	NL80211_CMD_SET_MGMT_EXTRA_IE /* reserved; not used */,
 
@@ -520,6 +524,8 @@ enum nl80211_commands {
 
 	/* add new commands above here */
 
+	NL80211_CMD_SET_DFS_EVENT,
+
 	/* used to define NL80211_CMD_MAX below */
 	__NL80211_CMD_AFTER_LAST,
 	NL80211_CMD_MAX = __NL80211_CMD_AFTER_LAST - 1
@@ -538,6 +544,10 @@ enum nl80211_commands {
 #define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
 #define NL80211_CMD_REG_BEACON_HINT NL80211_CMD_REG_BEACON_HINT
 
+/* source-level API compatibility */
+#define NL80211_CMD_GET_MESH_PARAMS NL80211_CMD_GET_MESH_CONFIG
+#define NL80211_CMD_SET_MESH_PARAMS NL80211_CMD_SET_MESH_CONFIG
+
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
  *
@@ -608,7 +618,7 @@ enum nl80211_commands {
  *	consisting of a nested array.
  *
  * @NL80211_ATTR_MESH_ID: mesh id (1-32 bytes).
- * @NL80211_ATTR_PLINK_ACTION: action to perform on the mesh peer link.
+ * @NL80211_ATTR_STA_PLINK_ACTION: action to perform on the mesh peer link.
  * @NL80211_ATTR_MPATH_NEXT_HOP: MAC address of the next hop for a mesh path.
  * @NL80211_ATTR_MPATH_INFO: information about a mesh_path, part of mesh path
  * 	info given for %NL80211_CMD_GET_MPATH, nested attribute described at
@@ -854,6 +864,12 @@ enum nl80211_commands {
  *	the hardware should not be configured to receive on this antenna.
  *	For a more detailed descripton see @NL80211_ATTR_WIPHY_ANTENNA_TX.
  *
+ * @NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX: Bitmap of antennas which are available
+ *	for configuration as TX antennas via the above parameters.
+ *
+ * @NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX: Bitmap of antennas which are available
+ *	for configuration as RX antennas via the above parameters.
+ *
  * @NL80211_ATTR_MCAST_RATE: Multicast tx rate (in 100 kbps) for IBSS
  *
  * @NL80211_ATTR_OFFCHANNEL_TX_OK: For management frame TX, the frame may be
@@ -868,6 +884,11 @@ enum nl80211_commands {
  *	attributes, specifying what a key should be set as default as.
  *	See &enum nl80211_key_default_types.
  *
+ * @NL80211_ATTR_MESH_SETUP: Optional mesh setup parameters.  These cannot be
+ *	changed once the mesh is active.
+ * @NL80211_ATTR_MESH_CONFIG: Mesh configuration parameters, a nested attribute
+ *	containing attributes from &enum nl80211_meshconf_params.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -922,7 +943,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_REG_ALPHA2,
 	NL80211_ATTR_REG_RULES,
 
-	NL80211_ATTR_MESH_PARAMS,
+	NL80211_ATTR_MESH_CONFIG,
 
 	NL80211_ATTR_BSS_BASIC_RATES,
 
@@ -1050,14 +1071,24 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAX_REMAIN_ON_CHANNEL_DURATION,
 
+	NL80211_ATTR_MESH_SETUP,
+
+	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX,
+	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
+	NL80211_DFSEVENT_ATTR_FREQ,
+	NL80211_DFSEVENT_ATTR_TS,
+	NL80211_DFSEVENT_ATTR_WIDTH,
+
 	__NL80211_ATTR_AFTER_LAST,
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
 
 /* source-level API compatibility */
 #define NL80211_ATTR_SCAN_GENERATION NL80211_ATTR_GENERATION
+#define	NL80211_ATTR_MESH_PARAMS NL80211_ATTR_MESH_CONFIG
 
 /*
  * Allow user space programs to use #ifdef on new attributes by defining them
@@ -1206,8 +1237,6 @@ enum nl80211_rate_info {
  * @NL80211_STA_INFO_INACTIVE_TIME: time since last activity (u32, msecs)
  * @NL80211_STA_INFO_RX_BYTES: total received bytes (u32, from this station)
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this station)
- * @__NL80211_STA_INFO_AFTER_LAST: internal
- * @NL80211_STA_INFO_MAX: highest possible station info attribute
  * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dBm)
  * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
  * 	containing info as possible, see &enum nl80211_sta_info_txrate.
@@ -1217,6 +1246,11 @@ enum nl80211_rate_info {
  * @NL80211_STA_INFO_TX_RETRIES: total retries (u32, to this station)
  * @NL80211_STA_INFO_TX_FAILED: total failed packets (u32, to this station)
  * @NL80211_STA_INFO_SIGNAL_AVG: signal strength average (u8, dBm)
+ * @NL80211_STA_INFO_LLID: the station's mesh LLID
+ * @NL80211_STA_INFO_PLID: the station's mesh PLID
+ * @NL80211_STA_INFO_PLINK_STATE: peer link state for the station
+ * @__NL80211_STA_INFO_AFTER_LAST: internal
+ * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
 enum nl80211_sta_info {
 	__NL80211_STA_INFO_INVALID,
@@ -1559,7 +1593,8 @@ enum nl80211_mntr_flags {
 /**
  * enum nl80211_meshconf_params - mesh configuration parameters
  *
- * Mesh configuration parameters
+ * Mesh configuration parameters. These can be changed while the mesh is
+ * active.
  *
  * @__NL80211_MESHCONF_INVALID: internal use
  *
@@ -1582,9 +1617,6 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_TTL: specifies the value of TTL field set at a source mesh
  * point.
  *
- * @NL80211_MESHCONF_ELEMENT_TTL: specifies the value of TTL field set at a
- * source mesh point for path selection elements.
- *
  * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically
  * open peer links when we detect compatible mesh peers.
  *
@@ -1609,7 +1641,10 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME: The interval of time (in TUs)
  * that it takes for an HWMP information element to propagate across the mesh
  *
- * @NL80211_MESHCONF_ROOTMODE: whether root mode is enabled or not
+ * @NL80211_MESHCONF_HWMP_ROOTMODE: whether root mode is enabled or not
+ *
+ * @NL80211_MESHCONF_ELEMENT_TTL: specifies the value of TTL field set at a
+ * source mesh point for path selection elements.
  *
  * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
  *
@@ -1639,6 +1674,40 @@ enum nl80211_meshconf_params {
 };
 
 /**
+ * enum nl80211_mesh_setup_params - mesh setup parameters
+ *
+ * Mesh setup parameters.  These are used to start/join a mesh and cannot be
+ * changed while the mesh is active.
+ *
+ * @__NL80211_MESH_SETUP_INVALID: Internal use
+ *
+ * @NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL: Enable this option to use a
+ * vendor specific path selection algorithm or disable it to use the default
+ * HWMP.
+ *
+ * @NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC: Enable this option to use a
+ * vendor specific path metric or disable it to use the default Airtime
+ * metric.
+ *
+ * @NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE: A vendor specific information
+ * element that vendors will use to identify the path selection methods and
+ * metrics in use.
+ *
+ * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
+ * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
+ */
+enum nl80211_mesh_setup_params {
+	__NL80211_MESH_SETUP_INVALID,
+	NL80211_MESH_SETUP_ENABLE_VENDOR_PATH_SEL,
+	NL80211_MESH_SETUP_ENABLE_VENDOR_METRIC,
+	NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE,
+
+	/* keep last */
+	__NL80211_MESH_SETUP_ATTR_AFTER_LAST,
+	NL80211_MESH_SETUP_ATTR_MAX = __NL80211_MESH_SETUP_ATTR_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_txq_attr - TX queue parameter attributes
  * @__NL80211_TXQ_ATTR_INVALID: Attribute number 0 is reserved
  * @NL80211_TXQ_ATTR_QUEUE: TX queue identifier (NL80211_TXQ_Q_*)
-- 
1.7.1

