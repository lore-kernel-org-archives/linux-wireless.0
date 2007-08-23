Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbXHWQtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 12:49:43 -0400
Received: from [131.234.79.133]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1IOFsJ-00010L-IN
	for linux-wireless@vger.kernel.org; Thu, 23 Aug 2007 17:49:41 +0100
Message-Id: <20070823164522.621870000@sipsolutions.net>
References: <20070823164500.998912000@sipsolutions.net>
Date: Thu, 23 Aug 2007 18:45:05 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 04/11] mac80211: yet more documentation
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h |  209 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 156 insertions(+), 53 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-08-23 18:38:39.231897709 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-23 18:38:41.511897709 +0200
@@ -121,44 +121,100 @@ struct ieee80211_rate {
 		       * optimizing channel utilization estimates */
 };
 
-/* 802.11g is backwards-compatible with 802.11b, so a wlan card can
- * actually be both in 11b and 11g modes at the same time. */
-enum {
-	MODE_IEEE80211A, /* IEEE 802.11a */
-	MODE_IEEE80211B, /* IEEE 802.11b only */
-	MODE_ATHEROS_TURBO, /* Atheros Turbo mode (2x.11a at 5 GHz) */
-	MODE_IEEE80211G, /* IEEE 802.11g (and 802.11b compatibility) */
-	MODE_ATHEROS_TURBOG, /* Atheros Turbo mode (2x.11g at 2.4 GHz) */
+/**
+ * enum ieee80211_phymode - PHY modes
+ *
+ * @MODE_IEEE80211A: 5GHz as defined by 802.11a/802.11h
+ * @MODE_IEEE80211B: 2.4 GHz as defined by 802.11b
+ * @MODE_IEEE80211G: 2.4 GHz as defined by 802.11g (with OFDM),
+ *	backwards compatible with 11b mode
+ * @MODE_ATHEROS_TURBO: Atheros Turbo mode in 5 GHz
+ * @MODE_ATHEROS_TURBOG: Atheros Turbo mode in 2.4 GHz
+ * @NUM_IEEE80211_MODES: internal
+ */
+enum ieee80211_phymode {
+	MODE_IEEE80211A,
+	MODE_IEEE80211B,
+	MODE_ATHEROS_TURBO,
+	MODE_IEEE80211G,
+	MODE_ATHEROS_TURBOG,
 
 	/* keep last */
 	NUM_IEEE80211_MODES
 };
 
+/**
+ * struct ieee80211_hw_mode - PHY mode definition
+ *
+ * This structure describes the capabilities supported by the device
+ * in a single PHY mode.
+ *
+ * @mode: the PHY mode for this definition
+ * @num_channels: number of supported channels
+ * @channels: pointer to array of supported channels
+ * @num_rates: number of supported bitrates
+ * @rates: pointer to array of supported bitrates
+ * @list: internal
+ */
 struct ieee80211_hw_mode {
-	int mode; /* MODE_IEEE80211... */
-	int num_channels; /* Number of channels (below) */
-	struct ieee80211_channel *channels; /* Array of supported channels */
-	int num_rates; /* Number of rates (below) */
-	struct ieee80211_rate *rates; /* Array of supported rates */
-
-	struct list_head list; /* Internal, don't touch */
+	struct list_head list;
+	struct ieee80211_channel *channels;
+	struct ieee80211_rate *rates;
+	enum ieee80211_phymode mode;
+	int num_channels;
+	int num_rates;
 };
 
+/**
+ * struct ieee80211_tx_queue_params - transmit queue configuration
+ *
+ * The information provided in this structure is required for QoS
+ * transmit queue configuration.
+ *
+ * @aifs: arbitration interface space [0..255, -1: use default]
+ * @cw_min: minimum contention window [will be a value of the form
+ *	2^n-1 in the range 1..1023; 0: use default]
+ * @cw_max: maximum contention window [like @cw_min]
+ * @burst_time: maximum burst time in units of 0.1ms, 0 meaning disabled
+ */
 struct ieee80211_tx_queue_params {
-	int aifs; /* 0 .. 255; -1 = use default */
-	int cw_min; /* 2^n-1: 1, 3, 7, .. , 1023; 0 = use default */
-	int cw_max; /* 2^n-1: 1, 3, 7, .. , 1023; 0 = use default */
-	int burst_time; /* maximum burst time in 0.1 ms (i.e., 10 = 1 ms);
-			 * 0 = disabled */
+	int aifs;
+	int cw_min;
+	int cw_max;
+	int burst_time;
 };
 
+/**
+ * struct ieee80211_tx_queue_stats_data - transmit queue statistics
+ *
+ * @len: number of packets in queue
+ * @limit: queue length limit
+ * @count: number of frames sent
+ */
 struct ieee80211_tx_queue_stats_data {
-	unsigned int len; /* num packets in queue */
-	unsigned int limit; /* queue len (soft) limit */
-	unsigned int count; /* total num frames sent */
+	unsigned int len;
+	unsigned int limit;
+	unsigned int count;
 };
 
-enum {
+/**
+ * enum ieee80211_tx_queue - transmit queue number
+ *
+ * These constants are used with some callbacks that take a
+ * queue number to set parameters for a queue.
+ *
+ * @IEEE80211_TX_QUEUE_DATA0: data queue 0
+ * @IEEE80211_TX_QUEUE_DATA1: data queue 1
+ * @IEEE80211_TX_QUEUE_DATA2: data queue 2
+ * @IEEE80211_TX_QUEUE_DATA3: data queue 3
+ * @IEEE80211_TX_QUEUE_DATA4: data queue 4
+ * @IEEE80211_TX_QUEUE_SVP: ??
+ * @NUM_TX_DATA_QUEUES: number of data queues
+ * @IEEE80211_TX_QUEUE_AFTER_BEACON: transmit queue for frames to be
+ *	sent after a beacon
+ * @IEEE80211_TX_QUEUE_BEACON: transmit queue for beacon frames
+ */
+enum ieee80211_tx_queue {
 	IEEE80211_TX_QUEUE_DATA0,
 	IEEE80211_TX_QUEUE_DATA1,
 	IEEE80211_TX_QUEUE_DATA2,
@@ -295,7 +351,7 @@ struct ieee80211_rx_status {
 	u64 mactime;
 	int freq;
 	int channel;
-	int phymode;
+	enum ieee80211_phymode phymode;
 	int ssi;
 	int signal;
 	int noise;
@@ -304,25 +360,67 @@ struct ieee80211_rx_status {
 	int flag;
 };
 
-/* Transmit status. The low-level driver should provide this information
- * (the subset supported by hardware) to the 802.11 code for each transmit
- * frame. */
+/**
+ * enum ieee80211_tx_status_flags - transmit status flags
+ *
+ * Status flags to indicate various transmit conditions.
+ *
+ * @IEEE80211_TX_STATUS_TX_FILTERED: The frame was not transmitted
+ *	because the destination STA was in powersave mode.
+ *
+ * @IEEE80211_TX_STATUS_ACK: Frame was acknowledged
+ */
+enum ieee80211_tx_status_flags {
+	IEEE80211_TX_STATUS_TX_FILTERED	= 1<<0,
+	IEEE80211_TX_STATUS_ACK		= 1<<1,
+};
+
+/**
+ * struct ieee80211_tx_status - transmit status
+ *
+ * As much information as possible should be provided for each transmitted
+ * frame with ieee80211_tx_status().
+ *
+ * @control: a copy of the &struct ieee80211_tx_control passed to the driver
+ *	in the tx() callback.
+ *
+ * @flags: transmit status flags, defined above
+ *
+ * @ack_signal: signal strength of the ACK frame
+ *
+ * @excessive_retries: set to 1 if the frame was retried many times
+ *	but not acknowledged
+ *
+ * @retry_count: number of retries
+ *
+ * @queue_length: ?? REMOVE
+ * @queue_number: ?? REMOVE
+ */
 struct ieee80211_tx_status {
-	/* copied ieee80211_tx_control structure */
 	struct ieee80211_tx_control control;
-
-#define IEEE80211_TX_STATUS_TX_FILTERED	(1<<0)
-#define IEEE80211_TX_STATUS_ACK		(1<<1) /* whether the TX frame was ACKed */
-	u32 flags;		/* tx staus flags defined above */
-
-	int ack_signal; /* measured signal strength of the ACK frame */
-	int excessive_retries;
-	int retry_count;
-
-	int queue_length;      /* information about TX queue */
+	u8 flags;
+	bool excessive_retries;
+	u8 retry_count;
+	int ack_signal;
+	int queue_length;
 	int queue_number;
 };
 
+/**
+ * enum ieee80211_conf_flags - configuration flags
+ *
+ * Flags to define PHY configuration options
+ *
+ * @IEEE80211_CONF_SHORT_SLOT_TIME: use 802.11g short slot time
+ * @IEEE80211_CONF_SSID_HIDDEN: do not broadcast the SSID [make per-if option]
+ * @IEEE80211_CONF_RADIOTAP: add radiotap header at receive time (if supported)
+ *
+ */
+enum ieee80211_conf_flags {
+	IEEE80211_CONF_SHORT_SLOT_TIME	= 1<<0,
+	IEEE80211_CONF_SSID_HIDDEN	= 1<<1,
+	IEEE80211_CONF_RADIOTAP		= 1<<2,
+};
 
 /**
  * struct ieee80211_conf - configuration of the device
@@ -330,32 +428,37 @@ struct ieee80211_tx_status {
  * This struct indicates how the driver shall configure the hardware.
  *
  * @radio_enabled: when zero, driver is required to switch off the radio.
+ *	TODO make a flag
+ * @channel: IEEE 802.11 channel number
+ * @freq: frequency in MHz
+ * @channel_val: hardware specific channel value for the channel
+ * @phymode: PHY mode to activate (REMOVE)
+ * @chan: channel to switch to, pointer to the channel information
+ * @mode: pointer to mode definition
+ * @regulatory_domain: ??
+ * @beacon_int: beacon interval (TODO make interface config)
+ * @flags: configuration flags defined above
+ * @power_level: transmit power limit for current regulatory domain in dBm
+ * @antenna_max: maximum antenna gain
+ * @antenna_sel_tx: transmit antenna selection, 0: default/diversity,
+ *	1/2: antenna 0/1
+ * @antenna_sel_rx: receive antenna selection, like @antenna_sel_tx
  */
 struct ieee80211_conf {
 	int channel;			/* IEEE 802.11 channel number */
 	int freq;			/* MHz */
 	int channel_val;		/* hw specific value for the channel */
 
-	int phymode;			/* MODE_IEEE80211A, .. */
+	enum ieee80211_phymode phymode;
 	struct ieee80211_channel *chan;
 	struct ieee80211_hw_mode *mode;
 	unsigned int regulatory_domain;
 	int radio_enabled;
 
 	int beacon_int;
-
-#define IEEE80211_CONF_SHORT_SLOT_TIME	(1<<0) /* use IEEE 802.11g Short Slot
-						* Time */
-#define IEEE80211_CONF_SSID_HIDDEN	(1<<1) /* do not broadcast the ssid */
-#define IEEE80211_CONF_RADIOTAP		(1<<2) /* use radiotap if supported
-						  check this bit at RX time */
-	u32 flags;			/* configuration flags defined above */
-
-	u8 power_level;			/* transmit power limit for current
-					 * regulatory domain; in dBm */
-	u8 antenna_max;			/* maximum antenna gain */
-
-	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
+	u32 flags;
+	u8 power_level;
+	u8 antenna_max;
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
 };

-- 

