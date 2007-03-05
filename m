Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934111AbXCFNKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 08:10:16 -0500
Subject: [PATCH] remove dead header junk
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 17:37:53 +0100
Message-Id: <1173112674.6131.93.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes a bunch of things from various header files that
aren't used within the stack (any more)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h       |   53 ++++++++++------------
 net/mac80211/hostapd_ioctl.h |  101 ++-----------------------------------------
 2 files changed, 31 insertions(+), 123 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-03-05 17:23:58.204711876 +0100
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-03-05 17:24:05.554711876 +0100
@@ -22,51 +22,29 @@
 #define PRISM2_IOCTL_HOSTAPD (SIOCIWFIRSTPRIV + 3)
 #define PRISM2_IOCTL_TEST_PARAM (SIOCIWFIRSTPRIV + 4)
 
-/* PRISM2_IOCTL_PRISM2_PARAM ioctl() subtypes: */
+/* PRISM2_IOCTL_PRISM2_PARAM ioctl() subtypes:
+ * This table is no longer added to, the whole sub-ioctl
+ * mess shall be deleted completely. */
 enum {
-	PRISM2_PARAM_PTYPE = 1,
-	PRISM2_PARAM_TXRATECTRL = 2,
 	PRISM2_PARAM_BEACON_INT = 3,
-	PRISM2_PARAM_PSEUDO_IBSS = 4,
-	PRISM2_PARAM_ALC = 5,
-	PRISM2_PARAM_TXPOWER = 6,
-	PRISM2_PARAM_DUMP = 7,
-	PRISM2_PARAM_OTHER_AP_POLICY = 8,
-	PRISM2_PARAM_AP_MAX_INACTIVITY = 9,
 	PRISM2_PARAM_AP_BRIDGE_PACKETS = 10,
 	PRISM2_PARAM_DTIM_PERIOD = 11,
-	PRISM2_PARAM_AP_NULLFUNC_ACK = 12,
-	PRISM2_PARAM_MAX_WDS = 13,
-	PRISM2_PARAM_AP_AUTOM_AP_WDS = 14,
 	PRISM2_PARAM_AP_AUTH_ALGS = 15,
-	PRISM2_PARAM_MONITOR_ALLOW_FCSERR = 16,
 	PRISM2_PARAM_HOST_ENCRYPT = 17,
 	PRISM2_PARAM_HOST_DECRYPT = 18,
-	PRISM2_PARAM_BUS_MASTER_THRESHOLD_RX = 19,
-	PRISM2_PARAM_BUS_MASTER_THRESHOLD_TX = 20,
-	PRISM2_PARAM_HOST_ROAMING = 21,
-	PRISM2_PARAM_BCRX_STA_KEY = 22,
 	PRISM2_PARAM_IEEE_802_1X = 23,
 	PRISM2_PARAM_ANTSEL_TX = 24,
 	PRISM2_PARAM_ANTSEL_RX = 25,
-	PRISM2_PARAM_MONITOR_TYPE = 26,
-	PRISM2_PARAM_WDS_TYPE = 27,
-	PRISM2_PARAM_HOSTSCAN = 28,
-	PRISM2_PARAM_AP_SCAN = 29,
 
 	/* Instant802 additions */
 	PRISM2_PARAM_CTS_PROTECT_ERP_FRAMES = 1001,
 	PRISM2_PARAM_DROP_UNENCRYPTED = 1002,
 	PRISM2_PARAM_PREAMBLE = 1003,
-	PRISM2_PARAM_RATE_LIMIT = 1004, /* no longer used */
-	PRISM2_PARAM_RATE_LIMIT_BURST = 1005,  /* no longer used */
 	PRISM2_PARAM_SHORT_SLOT_TIME = 1006,
 	PRISM2_PARAM_TEST_MODE = 1007,
 	PRISM2_PARAM_NEXT_MODE = 1008,
 	PRISM2_PARAM_CLEAR_KEYS = 1009,
 	PRISM2_PARAM_RADIO_ENABLED = 1010,
-	PRISM2_PARAM_ANTENNA_SEL = 1011,
-	PRISM2_PARAM_CALIB_INT = 1012,
 	PRISM2_PARAM_ANTENNA_MODE = 1013,
 	PRISM2_PARAM_PRIVACY_INVOKED = 1014,
 	PRISM2_PARAM_BROADCAST_SSID = 1015,
@@ -93,27 +71,19 @@ enum {
 	PRISM2_PARAM_SPECTRUM_MGMT = 1044,
 	PRISM2_PARAM_USER_SPACE_MLME = 1045,
 	PRISM2_PARAM_MGMT_IF = 1046,
-	/* NOTE: Please try to coordinate with other active development
-	 * branches before allocating new param numbers so that each new param
-	 * will be unique within all branches and the allocated number will not
-	 * need to be changed when merging new features. Existing numbers in
-	 * the mainline (or main devel branch) must not be changed when merging
-	 * in new features. */
 };
 
-/* PRISM2_IOCTL_HOSTAPD ioctl() cmd: */
+/* PRISM2_IOCTL_HOSTAPD ioctl() cmd:
+ * This table is no longer added to, the hostapd ioctl
+ * shall be deleted completely. */
 enum {
 	PRISM2_HOSTAPD_FLUSH = 1,
 	PRISM2_HOSTAPD_ADD_STA = 2,
 	PRISM2_HOSTAPD_REMOVE_STA = 3,
 	PRISM2_HOSTAPD_GET_INFO_STA = 4,
-	/* REMOVED: PRISM2_HOSTAPD_RESET_TXEXC_STA = 5, */
 	PRISM2_SET_ENCRYPTION = 6,
 	PRISM2_GET_ENCRYPTION = 7,
 	PRISM2_HOSTAPD_SET_FLAGS_STA = 8,
-	PRISM2_HOSTAPD_GET_RID = 9,
-	PRISM2_HOSTAPD_SET_RID = 10,
-	PRISM2_HOSTAPD_SET_ASSOC_AP_ADDR = 11,
 	PRISM2_HOSTAPD_MLME = 13,
 
 	/* Instant802 additions */
@@ -138,39 +108,13 @@ enum {
 	PRISM2_HOSTAPD_FLUSH_IFS = 1021,
 	PRISM2_HOSTAPD_SET_RADAR_PARAMS = 1023,
 	PRISM2_HOSTAPD_SET_QUIET_PARAMS = 1024,
-	PRISM2_HOSTAPD_GET_TX_POWER = 1025,
-	/* NOTE: Please try to coordinate with other active development
-	 * branches before allocating new param numbers so that each new param
-	 * will be unique within all branches and the allocated number will not
-	 * need to be changed when merging new features. Existing numbers in
-	 * the mainline (or main devel branch) must not be changed when merging
-	 * in new features. */
-};
-
-	/* these definitions mirror the ieee80211_i.h
-	 * IEEE80211_DISABLED, ... IEEE80211_ASSOCIATED enumeration */
-enum {
-	PRISM2_PARAM_STA_DISABLED,
-	PRISM2_PARAM_STA_AUTHENTICATE,
-	PRISM2_PARAM_STA_ASSOCIATE,
-	PRISM2_PARAM_STA_ASSOCIATED,
 };
 
 #define PRISM2_HOSTAPD_MAX_BUF_SIZE 2048
 #define HOSTAP_CRYPT_ALG_NAME_LEN 16
 
-/* Use this to make sure that structure elements are correctly aligned
- * for access as other types. Most commonly, this affects the placeholder
- * types used for data at the end of a structure in this union.
- */
-#ifdef __GNUC__
-#undef	ALIGNED
-#define ALIGNED __attribute__ ((aligned))
-#else
-/* Check if it has been defined elsewhere */
 #ifndef ALIGNED
-#error "Must define ALIGNED to generate aligned structure elements"
-#endif
+#define ALIGNED __attribute__ ((aligned))
 #endif
 
 struct prism2_hostapd_param {
@@ -217,11 +161,6 @@ struct prism2_hostapd_param {
 			u32 flags_or;
 		} set_flags_sta;
 		struct {
-			u16 rid;
-			u16 len;
-			u8 data[0] ALIGNED;
-		} rid;
-		struct {
 			u16 head_len;
 			u16 tail_len;
 			u8 data[0] ALIGNED; /* head_len + tail_len bytes */
@@ -305,10 +244,6 @@ struct prism2_hostapd_param {
 			u32 burst_time; /* maximum burst time in 0.1 ms, i.e.,
 					 * 10 = 1 ms */
 		} tx_queue_params;
-		struct {
-			u32 bss_count;
-			u8 bssid_mask[ETH_ALEN];
-		} set_bss;
 		struct ieee80211_tx_stats {
 			struct {
 				unsigned int len; /* num packets in queue */
@@ -343,34 +278,12 @@ struct prism2_hostapd_param {
 			unsigned int duration;
 		} quiet;
 		struct {
-			unsigned int tx_power_min;
-			unsigned int tx_power_max;
-		} tx_power;
-		struct {
 			u8 dummy[80]; /* Make sizeof() this struct large enough
 				       * with some compiler versions. */
 		} dummy;
 	} u;
 };
 
-
-#ifndef IEEE80211_TX_QUEUE_NUMS
-#define IEEE80211_TX_QUEUE_NUMS
-/* TODO: these need to be synchronized with ieee80211.h; make a shared header
- * file that can be included into low-level drivers, 80211.o, and hostapd */
-/* tx_queue_params - queue */
-enum {
-	IEEE80211_TX_QUEUE_DATA0 = 0, /* used for EDCA AC_VO data */
-	IEEE80211_TX_QUEUE_DATA1 = 1, /* used for EDCA AC_VI data */
-	IEEE80211_TX_QUEUE_DATA2 = 2, /* used for EDCA AC_BE data */
-	IEEE80211_TX_QUEUE_DATA3 = 3, /* used for EDCA AC_BK data */
-	IEEE80211_TX_QUEUE_DATA4 = 4,
-	IEEE80211_TX_QUEUE_AFTER_BEACON = 6,
-	IEEE80211_TX_QUEUE_BEACON = 7
-};
-#endif /* IEEE80211_TX_QUEUE_NUMS */
-
-
 #define HOSTAP_CRYPT_FLAG_SET_TX_KEY BIT(0)
 #define HOSTAP_CRYPT_FLAG_PERMANENT BIT(1)
 
--- wireless-dev.orig/include/net/mac80211.h	2007-03-05 17:24:02.554711876 +0100
+++ wireless-dev/include/net/mac80211.h	2007-03-05 17:35:26.484711876 +0100
@@ -44,10 +44,6 @@
  * copying of the data.
  */
 
-/* Interface version (used for compatibility verification) */
-#define IEEE80211_VERSION 2
-
-
 #define IEEE80211_CHAN_W_SCAN 0x00000001
 #define IEEE80211_CHAN_W_ACTIVE_SCAN 0x00000002
 #define IEEE80211_CHAN_W_IBSS 0x00000004
@@ -77,7 +73,7 @@ struct ieee80211_channel {
 
 #define IEEE80211_RATE_CCK_2 (IEEE80211_RATE_CCK | IEEE80211_RATE_PREAMBLE2)
 #define IEEE80211_RATE_MODULATION(f) \
-(f & (IEEE80211_RATE_CCK | IEEE80211_RATE_OFDM))
+	(f & (IEEE80211_RATE_CCK | IEEE80211_RATE_OFDM))
 
 /* Low-level driver should set PREAMBLE2, OFDM, CCK, and TURBO flags.
  * BASIC, SUPPORTED, ERP, and MANDATORY flags are set in 80211.o based on the
@@ -101,12 +97,14 @@ struct ieee80211_rate {
 /* 802.11g is backwards-compatible with 802.11b, so a wlan card can
  * actually be both in 11b and 11g modes at the same time. */
 enum {
-	MODE_IEEE80211A = 0 /* IEEE 802.11a */,
-	MODE_IEEE80211B = 1 /* IEEE 802.11b only */,
-	MODE_ATHEROS_TURBO = 2 /* Atheros Turbo mode (2x.11a at 5 GHz) */,
-	MODE_IEEE80211G = 3 /* IEEE 802.11g (and 802.11b compatibility) */,
-	MODE_ATHEROS_TURBOG = 4 /* Atheros Turbo mode (2x.11g at 2.4 GHz) */,
-	NUM_IEEE80211_MODES = 5
+	MODE_IEEE80211A, /* IEEE 802.11a */
+	MODE_IEEE80211B, /* IEEE 802.11b only */
+	MODE_ATHEROS_TURBO, /* Atheros Turbo mode (2x.11a at 5 GHz) */
+	MODE_IEEE80211G, /* IEEE 802.11g (and 802.11b compatibility) */
+	MODE_ATHEROS_TURBOG, /* Atheros Turbo mode (2x.11g at 2.4 GHz) */
+
+	/* keep last */
+	NUM_IEEE80211_MODES
 };
 
 struct ieee80211_hw_mode {
@@ -127,35 +125,32 @@ struct ieee80211_tx_queue_params {
 			 * 0 = disabled */
 };
 
-#define NUM_TX_DATA_QUEUES 6
-
 struct ieee80211_tx_queue_stats_data {
 	unsigned int len; /* num packets in queue */
 	unsigned int limit; /* queue len (soft) limit */
 	unsigned int count; /* total num frames sent */
 };
 
-struct ieee80211_tx_queue_stats {
-	struct ieee80211_tx_queue_stats_data data[NUM_TX_DATA_QUEUES];
-};
-
-#ifndef IEEE80211_TX_QUEUE_NUMS
-#define IEEE80211_TX_QUEUE_NUMS
-/* TODO: these need to be synchronized with hostapd_ioctl.h; make a shared
- * header file that can be included into low-level drivers, 80211.o, and
- * hostapd */
 enum {
-	IEEE80211_TX_QUEUE_DATA0 = 0,
-	IEEE80211_TX_QUEUE_DATA1 = 1,
-	IEEE80211_TX_QUEUE_DATA2 = 2,
-	IEEE80211_TX_QUEUE_DATA3 = 3,
-	IEEE80211_TX_QUEUE_DATA4 = 4,
-	IEEE80211_TX_QUEUE_SVP = 5,
+	IEEE80211_TX_QUEUE_DATA0,
+	IEEE80211_TX_QUEUE_DATA1,
+	IEEE80211_TX_QUEUE_DATA2,
+	IEEE80211_TX_QUEUE_DATA3,
+	IEEE80211_TX_QUEUE_DATA4,
+	IEEE80211_TX_QUEUE_SVP,
+
+	NUM_TX_DATA_QUEUES,
+
+/* due to stupidity in the sub-ioctl userspace interface, the items in
+ * this struct need to have fixed values. As soon as it is removed, we can
+ * fix these entries. */
 	IEEE80211_TX_QUEUE_AFTER_BEACON = 6,
 	IEEE80211_TX_QUEUE_BEACON = 7
 };
-#endif /* IEEE80211_TX_QUEUE_NUMS */
 
+struct ieee80211_tx_queue_stats {
+	struct ieee80211_tx_queue_stats_data data[NUM_TX_DATA_QUEUES];
+};
 
 struct ieee80211_low_level_stats {
 	unsigned int dot11ACKFailureCount;


