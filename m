Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41911 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbYBYPcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 10:32:54 -0500
Message-Id: <20080225153008.370172000@sipsolutions.net> (sfid-20080225_153348_429835_BDEC6871)
References: <20080225152740.360393000@sipsolutions.net>
Date: Mon, 25 Feb 2008 16:27:48 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCH 08/10] mac80211: clean up sta_info and document locking
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans up the sta_info struct and documents how
each set of variables is locked. Notably, flags locking is
completely missing. It also adds kernel-doc for some (but
not all yet) members of the struct.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_sta.c |    2 
 net/mac80211/sta_info.h    |  135 +++++++++++++++++++++++++++------------------
 2 files changed, 83 insertions(+), 54 deletions(-)

--- everything.orig/net/mac80211/sta_info.h	2008-02-24 12:29:22.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-24 12:42:49.000000000 +0100
@@ -139,84 +139,113 @@ struct sta_ampdu_mlme {
 #define STA_INFO_PIN_STAT_PINNED	1
 #define STA_INFO_PIN_STAT_DESTROY	2
 
-
+/**
+ * struct sta_info - STA information
+ *
+ * This structure collects information about a station that
+ * mac80211 is communicating with.
+ *
+ * @list: global linked list entry
+ * @hnext: hash table linked list pointer
+ * @local: pointer to the global information
+ * @addr: MAC address of this STA
+ * @aid: STA's unique AID (1..2007, 0 = not assigned yet),
+ *	only used in AP (and IBSS?) mode
+ * @flags: STA flags, see &enum ieee80211_sta_info_flags
+ * @ps_tx_buf: buffer of frames to transmit to this station
+ *	when it leaves power saving state
+ * @tx_filtered: buffer of frames we already tried to transmit
+ *	but were filtered by hardware due to STA having entered
+ *	power saving state
+ * @rx_packets: Number of MSDUs received from this STA
+ * @rx_bytes: Number of bytes received from this STA
+ * @supp_rates: Bitmap of supported rates (per band)
+ * @ht_info: HT capabilities of this STA
+ */
 struct sta_info {
+	/* General information, mostly static */
 	struct list_head list;
-	struct sta_info *hnext; /* next entry in hash table list */
-
+	struct sta_info *hnext;
 	struct ieee80211_local *local;
-
-	u8 addr[ETH_ALEN];
-	u16 aid; /* STA's unique AID (1..2007), 0 = not yet assigned */
-	u32 flags; /* WLAN_STA_ */
-
-	struct sk_buff_head ps_tx_buf; /* buffer of TX frames for station in
-					* power saving state */
-	struct sk_buff_head tx_filtered; /* buffer of TX frames that were
-					  * already given to low-level driver,
-					  * but were filtered */
-	unsigned long rx_packets, tx_packets; /* number of RX/TX MSDUs */
-	unsigned long rx_bytes, tx_bytes;
-	unsigned long tx_retry_failed, tx_retry_count;
-	unsigned long tx_filtered_count;
-	/* moving percentage of failed MSDUs */
-	unsigned int fail_avg;
-
-	unsigned int wep_weak_iv_count; /* number of RX frames with weak IV */
-
-	unsigned long last_rx;
-	/* bitmap of supported rates per band */
-	u64 supp_rates[IEEE80211_NUM_BANDS];
-	int txrate_idx;
-	/* last rates used to send a frame to this STA */
-	int last_txrate_idx, last_nonerp_txrate_idx;
-
-	/* sub_if_data this sta belongs to */
 	struct ieee80211_sub_if_data *sdata;
-
 	struct ieee80211_key *key;
-
-	u32 tx_num_consecutive_failures;
-	u32 tx_num_mpdu_ok;
-	u32 tx_num_mpdu_fail;
-
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
+	struct ieee80211_ht_info ht_info;
+	u64 supp_rates[IEEE80211_NUM_BANDS];
+	u8 addr[ETH_ALEN];
+	u16 aid;
+	u16 listen_interval;
 
-	/* last received seq/frag number from this STA (per RX queue) */
-	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES];
+	/*
+	 * for use by the internal lifetime management,
+	 * see __sta_info_unlink
+	 */
+	u8 pin_status;
+
+	/* frequently updated information, needs locking? */
+	u32 flags;
+
+	/*
+	 * STA powersave frame queues, no more than the internal
+	 * locking required.
+	 */
+	struct sk_buff_head ps_tx_buf;
+	struct sk_buff_head tx_filtered;
+
+	/* Updated from RX path only, no locking requirements */
+	unsigned long rx_packets, rx_bytes;
+	unsigned long wep_weak_iv_count;
+	unsigned long last_rx;
 	unsigned long num_duplicates; /* number of duplicate frames received
 				       * from this STA */
-	unsigned long tx_fragments; /* number of transmitted MPDUs */
 	unsigned long rx_fragments; /* number of received MPDUs */
 	unsigned long rx_dropped; /* number of dropped MPDUs from this STA */
-
 	int last_rssi; /* RSSI of last received frame from this STA */
 	int last_signal; /* signal of last received frame from this STA */
 	int last_noise; /* noise of last received frame from this STA */
-	int channel_use;
-	int channel_use_raw;
-
+	/* last received seq/frag number from this STA (per RX queue) */
+	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES];
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	unsigned int wme_rx_queue[NUM_RX_DATA_QUEUES];
+#endif
+
+	/* Updated from TX status path only, no locking requirements */
+	unsigned long tx_filtered_count;
+	unsigned long tx_retry_failed, tx_retry_count;
+	/* TODO: update in generic code not rate control? */
+	u32 tx_num_consecutive_failures;
+	u32 tx_num_mpdu_ok;
+	u32 tx_num_mpdu_fail;
+	/* moving percentage of failed MSDUs */
+	unsigned int fail_avg;
+
+	/* Updated from TX path only, no locking requirements */
+	unsigned long tx_packets; /* number of RX/TX MSDUs */
+	unsigned long tx_bytes;
+	unsigned long tx_fragments; /* number of transmitted MPDUs */
+	int txrate_idx;
+	int last_txrate_idx;
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	unsigned int wme_tx_queue[NUM_RX_DATA_QUEUES];
-#endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
+#endif
 
-	u16 listen_interval;
+	/* Debug counters, no locking doesn't matter */
+	int channel_use;
+	int channel_use_raw;
 
 	/*
-	 * for use by the internal lifetime management,
-	 * see __sta_info_unlink
+	 * Aggregation information, comes with own locking.
 	 */
-	u8 pin_status;
-
-	struct ieee80211_ht_info ht_info; /* 802.11n HT capabilities
-					     of this STA */
 	struct sta_ampdu_mlme ampdu_mlme;
-	u8 timer_to_tid[STA_TID_NUM];	/* convert timer id to tid */
+	u8 timer_to_tid[STA_TID_NUM];	/* identity mapping to ID timers */
 	u8 tid_to_tx_q[STA_TID_NUM];	/* map tid to tx queue */
+
 #ifdef CONFIG_MAC80211_MESH
-	/* mesh peer link attributes */
+	/*
+	 * Mesh peer link attributes
+	 * TODO: move to a sub-structure that is referenced with pointer?
+	 */
 	__le16 llid;		/* Local link ID */
 	__le16 plid;		/* Peer link ID */
 	__le16 reason;		/* Buffer for cancel reason on HOLDING state */
--- everything.orig/net/mac80211/debugfs_sta.c	2008-02-24 12:22:26.000000000 +0100
+++ everything/net/mac80211/debugfs_sta.c	2008-02-24 12:41:13.000000000 +0100
@@ -67,7 +67,7 @@ STA_FILE(last_rssi, last_rssi, D);
 STA_FILE(last_signal, last_signal, D);
 STA_FILE(last_noise, last_noise, D);
 STA_FILE(channel_use, channel_use, D);
-STA_FILE(wep_weak_iv_count, wep_weak_iv_count, D);
+STA_FILE(wep_weak_iv_count, wep_weak_iv_count, LU);
 
 static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 			      size_t count, loff_t *ppos)

-- 

