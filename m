Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58398 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1AFViG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 16:38:06 -0500
Message-Id: <20110106213715.303217480@sipsolutions.net>
Date: Thu, 06 Jan 2011 22:36:46 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] nl80211: add/fix mesh docs
References: <20110106213643.454994320@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some mesh attribute/command docs are missing or
have errors in the name so they don't match, fix
all of them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2011-01-06 22:21:07.000000000 +0100
+++ wireless-testing/include/linux/nl80211.h	2011-01-06 22:28:07.000000000 +0100
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
@@ -612,7 +616,7 @@ enum nl80211_commands {
  *	consisting of a nested array.
  *
  * @NL80211_ATTR_MESH_ID: mesh id (1-32 bytes).
- * @NL80211_ATTR_PLINK_ACTION: action to perform on the mesh peer link.
+ * @NL80211_ATTR_STA_PLINK_ACTION: action to perform on the mesh peer link.
  * @NL80211_ATTR_MPATH_NEXT_HOP: MAC address of the next hop for a mesh path.
  * @NL80211_ATTR_MPATH_INFO: information about a mesh_path, part of mesh path
  * 	info given for %NL80211_CMD_GET_MPATH, nested attribute described at
@@ -879,7 +883,9 @@ enum nl80211_commands {
  *	See &enum nl80211_key_default_types.
  *
  * @NL80211_ATTR_MESH_SETUP: Optional mesh setup parameters.  These cannot be
- * changed once the mesh is active.
+ *	changed once the mesh is active.
+ * @NL80211_ATTR_MESH_CONFIG: Mesh configuration parameters, a nested attribute
+ *	containing attributes from &enum nl80211_meshconf_params.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1225,8 +1231,6 @@ enum nl80211_rate_info {
  * @NL80211_STA_INFO_INACTIVE_TIME: time since last activity (u32, msecs)
  * @NL80211_STA_INFO_RX_BYTES: total received bytes (u32, from this station)
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this station)
- * @__NL80211_STA_INFO_AFTER_LAST: internal
- * @NL80211_STA_INFO_MAX: highest possible station info attribute
  * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dBm)
  * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
  * 	containing info as possible, see &enum nl80211_sta_info_txrate.
@@ -1236,6 +1240,11 @@ enum nl80211_rate_info {
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
@@ -1626,7 +1635,7 @@ enum nl80211_mntr_flags {
  * @NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME: The interval of time (in TUs)
  * that it takes for an HWMP information element to propagate across the mesh
  *
- * @NL80211_MESHCONF_ROOTMODE: whether root mode is enabled or not
+ * @NL80211_MESHCONF_HWMP_ROOTMODE: whether root mode is enabled or not
  *
  * @NL80211_MESHCONF_ELEMENT_TTL: specifies the value of TTL field set at a
  * source mesh point for path selection elements.
@@ -1678,6 +1687,7 @@ enum nl80211_meshconf_params {
  * element that vendors will use to identify the path selection methods and
  * metrics in use.
  *
+ * @NL80211_MESH_SETUP_ATTR_MAX: highest possible mesh setup attribute number
  * @__NL80211_MESH_SETUP_ATTR_AFTER_LAST: Internal use
  */
 enum nl80211_mesh_setup_params {


