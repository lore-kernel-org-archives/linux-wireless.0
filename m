Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58397 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424688Ab2LGWOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 17:14:40 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so648555pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 14:14:40 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Subject: [RFCv3 2/5] cfg80211: mesh power mode primitives
Date: Fri,  7 Dec 2012 14:14:00 -0800
Message-Id: <1354918443-3076-3-git-send-email-marco@cozybit.com> (sfid-20121207_231455_262179_53C8D0D6)
In-Reply-To: <1354918443-3076-1-git-send-email-marco@cozybit.com>
References: <1354918443-3076-1-git-send-email-marco@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the nl80211_mesh_power_mode enumeration which holds possible values for
the mesh power mode. These modes are unknown, active, light sleep and
deep sleep.

Add power_mode entry to the mesh config structure to hold the user-configured
default mesh power mode. This value will be used for new peer links.

Add the dot11MeshAwakeWindowDuration value to the mesh config. The awake window
is a duration in TU describing how long the STA will stay awake after
transmitting its beacon in PS mode.

Add the station parameters and flags for future userspace access.

Signed-off-by: Marco Porsch <marco@cozybit.com>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
---
 include/net/cfg80211.h       |   21 +++++++++++++++++++++
 include/uapi/linux/nl80211.h |   35 +++++++++++++++++++++++++++++++++++
 net/wireless/mesh.c          |    3 +++
 3 files changed, 59 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a31e893..d6e5c0a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -586,6 +586,8 @@ enum station_parameters_apply_mask {
  * @sta_modify_mask: bitmap indicating which parameters changed
  *	(for those that don't have a natural "no change" value),
  *	see &enum station_parameters_apply_mask
+ * @local_pm: local link-specific mesh power save mode (no change when set
+ *	to unknown)
  */
 struct station_parameters {
 	u8 *supported_rates;
@@ -601,6 +603,7 @@ struct station_parameters {
 	struct ieee80211_vht_cap *vht_capa;
 	u8 uapsd_queues;
 	u8 max_sp;
+	enum nl80211_mesh_power_mode local_pm;
 };
 
 /**
@@ -631,6 +634,9 @@ struct station_parameters {
  * @STATION_INFO_STA_FLAGS: @sta_flags filled
  * @STATION_INFO_BEACON_LOSS_COUNT: @beacon_loss_count filled
  * @STATION_INFO_T_OFFSET: @t_offset filled
+ * @STATION_INFO_LOCAL_PM: @local_pm filled
+ * @STATION_INFO_PEER_PM: @peer_pm filled
+ * @STATION_INFO_NONPEER_PM: @nonpeer_pm filled
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -654,6 +660,9 @@ enum station_info_flags {
 	STATION_INFO_STA_FLAGS		= 1<<18,
 	STATION_INFO_BEACON_LOSS_COUNT	= 1<<19,
 	STATION_INFO_T_OFFSET		= 1<<20,
+	STATION_INFO_LOCAL_PM		= 1<<21,
+	STATION_INFO_PEER_PM		= 1<<22,
+	STATION_INFO_NONPEER_PM		= 1<<23,
 };
 
 /**
@@ -767,6 +776,9 @@ struct sta_bss_parameters {
  * @sta_flags: station flags mask & values
  * @beacon_loss_count: Number of times beacon loss event has triggered.
  * @t_offset: Time offset of the station relative to this host.
+ * @local_pm: local mesh STA power save mode
+ * @peer_pm: peer mesh STA power save mode
+ * @nonpeer_pm: non-peer mesh STA power save mode
  */
 struct station_info {
 	u32 filled;
@@ -796,6 +808,9 @@ struct station_info {
 
 	u32 beacon_loss_count;
 	s64 t_offset;
+	enum nl80211_mesh_power_mode local_pm;
+	enum nl80211_mesh_power_mode peer_pm;
+	enum nl80211_mesh_power_mode nonpeer_pm;
 
 	/*
 	 * Note: Add a new enum station_info_flags value for each new field and
@@ -968,6 +983,10 @@ struct bss_parameters {
  * @dot11MeshHWMPconfirmationInterval: The minimum interval of time (in TUs)
  *	during which a mesh STA can send only one Action frame containing
  *	a PREQ element for root path confirmation.
+ * @power_mode: The default mesh power save mode which will be the initial
+ *	setting for new peer links.
+ * @dot11MeshAwakeWindowDuration: The duration in TUs the STA will remain awake
+ *	after transmitting its beacon.
  */
 struct mesh_config {
 	u16 dot11MeshRetryTimeout;
@@ -995,6 +1014,8 @@ struct mesh_config {
 	u32 dot11MeshHWMPactivePathToRootTimeout;
 	u16 dot11MeshHWMProotInterval;
 	u16 dot11MeshHWMPconfirmationInterval;
+	enum nl80211_mesh_power_mode power_mode;
+	u16 dot11MeshAwakeWindowDuration;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 33a4174..78e37ad 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2239,6 +2239,34 @@ enum nl80211_mntr_flags {
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
@@ -2332,6 +2360,11 @@ enum nl80211_mntr_flags {
  *	(in TUs) during which a mesh STA can send only one Action frame
  *	containing a PREQ element for root path confirmation.
  *
+ * @NL80211_MESHCONF_POWER_MODE: Default mesh power mode for new peer links.
+ *	type &enum nl80211_mesh_power_mode (u8)
+ *
+ * @NL80211_MESHCONF_AWAKE_WINDOW: awake window duration (in TUs)
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -2361,6 +2394,8 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_HWMP_PATH_TO_ROOT_TIMEOUT,
 	NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
 	NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL,
+	NL80211_MESHCONF_POWER_MODE,
+	NL80211_MESHCONF_AWAKE_WINDOW,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 6d8ce90..8e27534 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -46,6 +46,7 @@
 
 #define MESH_DEFAULT_BEACON_INTERVAL	1000 	/* in 1024 us units (=TUs) */
 #define MESH_DEFAULT_DTIM_PERIOD	1
+#define MESH_DEFAULT_AWAKE_WINDOW	10	/* in 1024 us units (=TUs) */
 
 const struct mesh_config default_mesh_config = {
 	.dot11MeshRetryTimeout = MESH_RET_T,
@@ -72,6 +73,8 @@ const struct mesh_config default_mesh_config = {
 	.dot11MeshHWMPactivePathToRootTimeout = MESH_PATH_TO_ROOT_TIMEOUT,
 	.dot11MeshHWMProotInterval = MESH_ROOT_INTERVAL,
 	.dot11MeshHWMPconfirmationInterval = MESH_ROOT_CONFIRMATION_INTERVAL,
+	.power_mode = NL80211_MESH_POWER_ACTIVE,
+	.dot11MeshAwakeWindowDuration = MESH_DEFAULT_AWAKE_WINDOW,
 };
 
 const struct mesh_setup default_mesh_setup = {
-- 
1.7.9.5

