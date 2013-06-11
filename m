Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:47302
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752657Ab3FKNtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 09:49:50 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH -next 3/3] cw1200:  Fix an assorted pile of checkpatch warnings.
Date: Tue, 11 Jun 2013 09:49:40 -0400
Message-Id: <1370958580-6463-3-git-send-email-pizza@shaftnet.org> (sfid-20130611_154955_127277_171B8442)
In-Reply-To: <1370958580-6463-1-git-send-email-pizza@shaftnet.org>
References: <1370958580-6463-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/bh.c          |  9 +++--
 drivers/net/wireless/cw1200/cw1200.h      |  3 +-
 drivers/net/wireless/cw1200/cw1200_sdio.c |  3 +-
 drivers/net/wireless/cw1200/cw1200_spi.c  |  4 +--
 drivers/net/wireless/cw1200/hwio.h        |  5 ++-
 drivers/net/wireless/cw1200/sta.c         | 30 ++++++++---------
 drivers/net/wireless/cw1200/txrx.c        | 43 ++++++++++++++----------
 drivers/net/wireless/cw1200/wsm.c         |  3 +-
 drivers/net/wireless/cw1200/wsm.h         | 55 +++++++++++++++----------------
 9 files changed, 80 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/cw1200/bh.c b/drivers/net/wireless/cw1200/bh.c
index 324b570..c1ec2a4 100644
--- a/drivers/net/wireless/cw1200/bh.c
+++ b/drivers/net/wireless/cw1200/bh.c
@@ -31,7 +31,8 @@ static int cw1200_bh(void *arg);
 
 #define DOWNLOAD_BLOCK_SIZE_WR	(0x1000 - 4)
 /* an SPI message cannot be bigger than (2"12-1)*2 bytes
- * "*2" to cvt to bytes */
+ * "*2" to cvt to bytes
+ */
 #define MAX_SZ_RD_WR_BUFFERS	(DOWNLOAD_BLOCK_SIZE_WR*2)
 #define PIGGYBACK_CTRL_REG	(2)
 #define EFFECTIVE_BUF_SIZE	(MAX_SZ_RD_WR_BUFFERS - PIGGYBACK_CTRL_REG)
@@ -217,7 +218,8 @@ static int cw1200_device_wakeup(struct cw1200_common *priv)
 		return ret;
 
 	/* If the device returns WLAN_RDY as 1, the device is active and will
-	 * remain active. */
+	 * remain active.
+	 */
 	if (ctrl_reg & ST90TDS_CONT_RDY_BIT) {
 		pr_debug("[BH] Device awake.\n");
 		return 1;
@@ -262,7 +264,8 @@ static int cw1200_bh_rx_helper(struct cw1200_common *priv,
 	}
 
 	/* Add SIZE of PIGGYBACK reg (CONTROL Reg)
-	 * to the NEXT Message length + 2 Bytes for SKB */
+	 * to the NEXT Message length + 2 Bytes for SKB
+	 */
 	read_len = read_len + 2;
 
 	alloc_len = priv->hwbus_ops->align_size(
diff --git a/drivers/net/wireless/cw1200/cw1200.h b/drivers/net/wireless/cw1200/cw1200.h
index 91ff7f1..243e963 100644
--- a/drivers/net/wireless/cw1200/cw1200.h
+++ b/drivers/net/wireless/cw1200/cw1200.h
@@ -207,7 +207,8 @@ struct cw1200_common {
 	/* Scan status */
 	struct cw1200_scan scan;
 	/* Keep cw1200 awake (WUP = 1) 1 second after each scan to avoid
-	 * FW issue with sleeping/waking up. */
+	 * FW issue with sleeping/waking up.
+	 */
 	atomic_t			recent_scan;
 	struct delayed_work		clear_recent_scan_work;
 
diff --git a/drivers/net/wireless/cw1200/cw1200_sdio.c b/drivers/net/wireless/cw1200/cw1200_sdio.c
index bb1f405..ebdcdf4 100644
--- a/drivers/net/wireless/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/cw1200/cw1200_sdio.c
@@ -323,7 +323,8 @@ static int cw1200_sdio_probe(struct sdio_func *func,
 }
 
 /* Disconnect Function to be called by SDIO stack when
- * device is disconnected */
+ * device is disconnected
+ */
 static void cw1200_sdio_disconnect(struct sdio_func *func)
 {
 	struct hwbus_priv *self = sdio_get_drvdata(func);
diff --git a/drivers/net/wireless/cw1200/cw1200_spi.c b/drivers/net/wireless/cw1200/cw1200_spi.c
index e58f0a5..953bd19 100644
--- a/drivers/net/wireless/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/cw1200/cw1200_spi.c
@@ -47,15 +47,13 @@ struct hwbus_priv {
 #define SET_WRITE 0x7FFF /* usage: and operation */
 #define SET_READ 0x8000  /* usage: or operation */
 
-/*
-   Notes on byte ordering:
+/* Notes on byte ordering:
    LE:  B0 B1 B2 B3
    BE:  B3 B2 B1 B0
 
    Hardware expects 32-bit data to be written as 16-bit BE words:
 
    B1 B0 B3 B2
-
 */
 
 static int cw1200_spi_memcpy_fromio(struct hwbus_priv *self,
diff --git a/drivers/net/wireless/cw1200/hwio.h b/drivers/net/wireless/cw1200/hwio.h
index 7ee73fe..563329c 100644
--- a/drivers/net/wireless/cw1200/hwio.h
+++ b/drivers/net/wireless/cw1200/hwio.h
@@ -97,9 +97,8 @@ struct download_cntl_t {
 
 #define CW1200_APB(addr)		(PAC_SHARED_MEMORY_SILICON + (addr))
 
-/* ***************************************************************
-*Device register definitions
-*************************************************************** */
+/* Device register definitions */
+
 /* WBF - SPI Register Addresses */
 #define ST90TDS_ADDR_ID_BASE		(0x0000)
 /* 16/32 bits */
diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index 679c55f..4cd0352 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -483,15 +483,14 @@ void cw1200_update_filtering(struct cw1200_common *priv)
 		bf_tbl.num = __cpu_to_le32(3);
 	}
 
-	/*
-	* When acting as p2p client being connected to p2p GO, in order to
-	* receive frames from a different p2p device, turn off bssid filter.
-	*
-	* WARNING: FW dependency!
-	* This can only be used with FW WSM371 and its successors.
-	* In that FW version even with bssid filter turned off,
-	* device will block most of the unwanted frames.
-	*/
+	/* When acting as p2p client being connected to p2p GO, in order to
+	 * receive frames from a different p2p device, turn off bssid filter.
+	 *
+	 * WARNING: FW dependency!
+	 * This can only be used with FW WSM371 and its successors.
+	 * In that FW version even with bssid filter turned off,
+	 * device will block most of the unwanted frames.
+	 */
 	if (is_p2p)
 		bssid_filtering = false;
 
@@ -1015,17 +1014,17 @@ void cw1200_event_handler(struct work_struct *work)
 			/* RSSI: signed Q8.0, RCPI: unsigned Q7.1
 			 * RSSI = RCPI / 2 - 110
 			 */
-			int rcpiRssi = (int)(event->evt.data & 0xFF);
+			int rcpi_rssi = (int)(event->evt.data & 0xFF);
 			int cqm_evt;
 			if (priv->cqm_use_rssi)
-				rcpiRssi = (s8)rcpiRssi;
+				rcpi_rssi = (s8)rcpi_rssi;
 			else
-				rcpiRssi =  rcpiRssi / 2 - 110;
+				rcpi_rssi =  rcpi_rssi / 2 - 110;
 
-			cqm_evt = (rcpiRssi <= priv->cqm_rssi_thold) ?
+			cqm_evt = (rcpi_rssi <= priv->cqm_rssi_thold) ?
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW :
 				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH;
-			pr_debug("[CQM] RSSI event: %d.\n", rcpiRssi);
+			pr_debug("[CQM] RSSI event: %d.\n", rcpi_rssi);
 			ieee80211_cqm_rssi_notify(priv->vif, cqm_evt,
 						  GFP_KERNEL);
 			break;
@@ -1068,8 +1067,7 @@ void cw1200_bss_params_work(struct work_struct *work)
 /* ******************************************************************** */
 /* Internal API								*/
 
-/*
- * This function is called to Parse the SDD file
+/* This function is called to Parse the SDD file
  * to extract listen_interval and PTA related information
  * sdd is a TLV: u8 id, u8 len, u8 data[]
  */
diff --git a/drivers/net/wireless/cw1200/txrx.c b/drivers/net/wireless/cw1200/txrx.c
index 451d746..44ca10c 100644
--- a/drivers/net/wireless/cw1200/txrx.c
+++ b/drivers/net/wireless/cw1200/txrx.c
@@ -75,9 +75,6 @@ static void tx_policy_build(const struct cw1200_common *priv,
 	BUG_ON(rates[0].idx < 0);
 	memset(policy, 0, sizeof(*policy));
 
-	/* minstrel is buggy a little bit, so distille
-	 * incoming rates first. */
-
 	/* Sort rates in descending order. */
 	for (i = 1; i < count; ++i) {
 		if (rates[i].idx < 0) {
@@ -108,7 +105,8 @@ static void tx_policy_build(const struct cw1200_common *priv,
 	count = i + 1;
 
 	/* Re-fill policy trying to keep every requested rate and with
-	 * respect to the global max tx retransmission count. */
+	 * respect to the global max tx retransmission count.
+	 */
 	if (limit < count)
 		limit = count;
 	if (total > limit) {
@@ -129,7 +127,6 @@ static void tx_policy_build(const struct cw1200_common *priv,
 	if (count == 2 && !(rates[0].flags & IEEE80211_TX_RC_MCS) &&
 	    rates[0].idx > 4 && rates[0].count > 2 &&
 	    rates[1].idx < 2) {
-		/* ">> 1" is an equivalent of "/ 2", but faster */
 		int mid_rate = (rates[0].idx + 4) >> 1;
 
 		/* Decrease number of retries for the initial rate */
@@ -151,7 +148,8 @@ static void tx_policy_build(const struct cw1200_common *priv,
 			/* Fallback to 1 Mbps is a really bad thing,
 			 * so let's try to increase probability of
 			 * successful transmission on the lowest g rate
-			 * even more */
+			 * even more
+			 */
 			if (rates[0].count >= 3) {
 				--rates[0].count;
 				++rates[2].count;
@@ -220,7 +218,8 @@ static int tx_policy_find(struct tx_policy_cache *cache,
 {
 	/* O(n) complexity. Not so good, but there's only 8 entries in
 	 * the cache.
-	 * Also lru helps to reduce search time. */
+	 * Also lru helps to reduce search time.
+	 */
 	struct tx_policy_cache_entry *it;
 	/* First search for policy in "used" list */
 	list_for_each_entry(it, &cache->used, link) {
@@ -264,7 +263,8 @@ void tx_policy_clean(struct cw1200_common *priv)
 	for (idx = 0; idx < TX_POLICY_CACHE_SIZE; idx++) {
 		entry = &cache->cache[idx];
 		/* Policy usage count should be 0 at this time as all queues
-		   should be empty */
+		   should be empty
+		 */
 		if (WARN_ON(entry->policy.usage_count)) {
 			entry->policy.usage_count = 0;
 			list_move(&entry->link, &cache->free);
@@ -319,7 +319,8 @@ static int tx_policy_get(struct cw1200_common *priv,
 		struct tx_policy_cache_entry *entry;
 		*renew = true;
 		/* If policy is not found create a new one
-		 * using the oldest entry in "free" list */
+		 * using the oldest entry in "free" list
+		 */
 		entry = list_entry(cache->free.prev,
 			struct tx_policy_cache_entry, link);
 		entry->policy = wanted;
@@ -612,7 +613,8 @@ cw1200_tx_h_bt(struct cw1200_common *priv,
 				 priv->listen_interval,
 				 mgt_frame->u.assoc_req.listen_interval);
 			/* Replace listen interval derieved from
-			 * the one read from SDD */
+			 * the one read from SDD
+			 */
 			mgt_frame->u.assoc_req.listen_interval =
 				priv->listen_interval;
 		}
@@ -667,7 +669,8 @@ cw1200_tx_h_rate_policy(struct cw1200_common *priv,
 		pr_debug("[TX] TX policy renew.\n");
 		/* It's not so optimal to stop TX queues every now and then.
 		 * Better to reimplement task scheduling with
-		 * a counter. TODO. */
+		 * a counter. TODO.
+		 */
 		wsm_lock_tx_async(priv);
 		cw1200_tx_queues_lock(priv);
 		if (queue_work(priv->workqueue,
@@ -832,8 +835,7 @@ static int cw1200_handle_pspoll(struct cw1200_common *priv,
 	priv->pspoll_mask |= pspoll_mask;
 	drop = 0;
 
-	/* Do not report pspols if data for given link id is
-	 * queued already. */
+	/* Do not report pspols if data for given link id is queued already. */
 	for (i = 0; i < 4; ++i) {
 		if (cw1200_queue_get_num_queued(&priv->tx_queue[i],
 						pspoll_mask)) {
@@ -924,7 +926,8 @@ void cw1200_tx_confirm_cb(struct cw1200_common *priv,
 			cw1200_debug_txed(priv);
 			if (arg->flags & WSM_TX_STATUS_AGGREGATION) {
 				/* Do not report aggregation to mac80211:
-				 * it confuses minstrel a lot. */
+				 * it confuses minstrel a lot.
+				 */
 				/* tx->flags |= IEEE80211_TX_STAT_AMPDU; */
 				cw1200_debug_txed_agg(priv);
 			}
@@ -1044,7 +1047,8 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 	    ieee80211_is_action(frame->frame_control) &&
 	    (mgmt->u.action.category == WLAN_CATEGORY_PUBLIC)) {
 		/* Link ID already exists for the ACTION frame.
-		 * Reset and Remap */
+		 * Reset and Remap
+		 */
 		WARN_ON(work_pending(&priv->linkid_reset_work));
 		memcpy(&priv->action_frame_sa[0],
 		       ieee80211_get_SA(frame), ETH_ALEN);
@@ -1074,7 +1078,6 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 		if (cw1200_handle_pspoll(priv, skb))
 			goto drop;
 
-	hdr->mactime = 0; /* Not supported by WSM */
 	hdr->band = ((arg->channel_number & 0xff00) ||
 		     (arg->channel_number > 14)) ?
 			IEEE80211_BAND_5GHZ : IEEE80211_BAND_2GHZ;
@@ -1102,7 +1105,8 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 		hdr->flag |= RX_FLAG_DECRYPTED | RX_FLAG_IV_STRIPPED;
 
 		/* Oops... There is no fast way to ask mac80211 about
-		 * IV/ICV lengths. Even defineas are not exposed.*/
+		 * IV/ICV lengths. Even defineas are not exposed.
+		 */
 		switch (WSM_RX_STATUS_ENCRYPTION(arg->flags)) {
 		case WSM_RX_STATUS_WEP:
 			iv_len = 4 /* WEP_IV_LEN */;
@@ -1149,6 +1153,8 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 		hdr->mactime = le64_to_cpu(hdr->mactime);
 		if (skb->len >= 8)
 			skb_trim(skb, skb->len - 8);
+	} else {
+		hdr->mactime = 0;
 	}
 
 	cw1200_debug_rxed(priv);
@@ -1192,7 +1198,8 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 
 	/* Stay awake after frame is received to give
 	 * userspace chance to react and acquire appropriate
-	 * wakelock. */
+	 * wakelock.
+	 */
 	if (ieee80211_is_auth(frame->frame_control))
 		grace_period = 5 * HZ;
 	else if (ieee80211_is_deauth(frame->frame_control))
diff --git a/drivers/net/wireless/cw1200/wsm.c b/drivers/net/wireless/cw1200/wsm.c
index d185f29..d95094f 100644
--- a/drivers/net/wireless/cw1200/wsm.c
+++ b/drivers/net/wireless/cw1200/wsm.c
@@ -1106,8 +1106,7 @@ static int wsm_cmd_send(struct cw1200_common *priv,
 	else
 		pr_debug("[WSM] >>> 0x%.4X (%zu)\n", cmd, buf_len);
 
-	/*
-	 * Due to buggy SPI on CW1200, we need to
+	/* Due to buggy SPI on CW1200, we need to
 	 * pad the message by a few bytes to ensure
 	 * that it's completely received.
 	 */
diff --git a/drivers/net/wireless/cw1200/wsm.h b/drivers/net/wireless/cw1200/wsm.h
index 4689dff..2816171 100644
--- a/drivers/net/wireless/cw1200/wsm.h
+++ b/drivers/net/wireless/cw1200/wsm.h
@@ -314,13 +314,16 @@ struct cw1200_common;
 #define WSM_JOIN_FLAGS_P2P_GO		BIT(1)
 /* Force to join BSS with the BSSID and the
  * SSID specified without waiting for beacons. The
- * ProbeForJoin parameter is ignored. */
+ * ProbeForJoin parameter is ignored.
+ */
 #define WSM_JOIN_FLAGS_FORCE		BIT(2)
 /* Give probe request/response higher
- * priority over the BT traffic */
+ * priority over the BT traffic
+ */
 #define WSM_JOIN_FLAGS_PRIO		BIT(3)
 /* Issue immediate join confirmation and use
- * join complete to notify about completion */
+ * join complete to notify about completion
+ */
 #define WSM_JOIN_FLAGS_FORCE_WITH_COMPLETE_IND BIT(5)
 
 /* Key types */
@@ -1015,22 +1018,19 @@ struct wsm_add_key {
 	u16 reserved;
 	union {
 		struct {
-			u8 peer[6];	/* MAC address of the
-						 * peer station */
+			u8 peer[6];	/* MAC address of the peer station */
 			u8 reserved;
 			u8 keylen;		/* Key length in bytes */
 			u8 keydata[16];		/* Key data */
 		} __packed wep_pairwise;
 		struct {
-			u8 keyid;		/* Unique per key identifier
-						 * (0..3) */
+			u8 keyid;	/* Unique per key identifier (0..3) */
 			u8 keylen;		/* Key length in bytes */
 			u16 reserved;
 			u8 keydata[16];		/* Key data */
 		} __packed wep_group;
 		struct {
-			u8 peer[6];	/* MAC address of the
-						 * peer station */
+			u8 peer[6];	/* MAC address of the peer station */
 			u16 reserved;
 			u8 keydata[16];	/* TKIP key data */
 			u8 rx_mic_key[8];		/* Rx MIC key */
@@ -1044,8 +1044,7 @@ struct wsm_add_key {
 			u8 rx_seqnum[8];	/* Receive Sequence Counter */
 		} __packed tkip_group;
 		struct {
-			u8 peer[6];	/* MAC address of the
-						 * peer station */
+			u8 peer[6];	/* MAC address of the peer station */
 			u16 reserved;
 			u8 keydata[16];	/* AES key data */
 		} __packed aes_pairwise;
@@ -1056,8 +1055,7 @@ struct wsm_add_key {
 			u8 rx_seqnum[8];	/* Receive Sequence Counter */
 		} __packed aes_group;
 		struct {
-			u8 peer[6];	/* MAC address of the
-						 * peer station */
+			u8 peer[6];	/* MAC address of the peer station */
 			u8 keyid;		/* Key ID */
 			u8 reserved;
 			u8 keydata[16];	/* WAPI key data */
@@ -1550,7 +1548,8 @@ struct wsm_tx_rate_retry_policy {
 	 *          finishes.
 	 * BIT(3) - Count initial frame transmission as part of
 	 *          rate retry counting but not as a retry
-	 *          attempt */
+	 *          attempt
+	 */
 	u8 flags;
 	u8 rate_recoveries;
 	u8 reserved[3];
@@ -1618,24 +1617,24 @@ static inline int wsm_set_udp_port_filter(struct cw1200_common *priv,
 #define D11_MAX_SSID_LEN		(32)
 
 struct wsm_p2p_device_type {
-	__le16 categoryId;
+	__le16 category_id;
 	u8 oui[4];
-	__le16 subCategoryId;
+	__le16 subcategory_id;
 } __packed;
 
 struct wsm_p2p_device_info {
 	struct wsm_p2p_device_type primaryDevice;
 	u8 reserved1[3];
-	u8 devNameSize;
-	u8 localDevName[D11_MAX_SSID_LEN];
+	u8 devname_size;
+	u8 local_devname[D11_MAX_SSID_LEN];
 	u8 reserved2[3];
-	u8 numSecDevSupported;
-	struct wsm_p2p_device_type secondaryDevices[0];
+	u8 num_secdev_supported;
+	struct wsm_p2p_device_type secdevs[0];
 } __packed;
 
 /* 4.36 SetWCDMABand - WO */
 struct wsm_cdma_band {
-	u8 WCDMA_Band;
+	u8 wcdma_band;
 	u8 reserved[3];
 } __packed;
 
@@ -1668,19 +1667,19 @@ struct wsm_ht_protection {
 #define WSM_GPIO_ALL_PINS	0xFF
 
 struct wsm_gpio_command {
-	u8 GPIO_Command;
+	u8 command;
 	u8 pin;
 	__le16 config;
 } __packed;
 
 /* 4.41 TSFCounter - RO */
 struct wsm_tsf_counter {
-	__le64 TSF_Counter;
+	__le64 tsf_counter;
 } __packed;
 
 /* 4.43 Keep alive period */
 struct wsm_keep_alive_period {
-	__le16 keepAlivePeriod;
+	__le16 period;
 	u8 reserved[2];
 } __packed;
 
@@ -1688,7 +1687,7 @@ static inline int wsm_keep_alive_period(struct cw1200_common *priv,
 					int period)
 {
 	struct wsm_keep_alive_period arg = {
-		.keepAlivePeriod = __cpu_to_le16(period),
+		.period = __cpu_to_le16(period),
 	};
 	return wsm_write_mib(priv, WSM_MIB_ID_KEEP_ALIVE_PERIOD,
 			&arg, sizeof(arg));
@@ -1739,13 +1738,13 @@ static inline int wsm_set_arp_ipv4_filter(struct cw1200_common *priv,
 
 /* P2P Power Save Mode Info - 4.31 */
 struct wsm_p2p_ps_modeinfo {
-	u8	oppPsCTWindow;
+	u8	opp_ps_ct_window;
 	u8	count;
 	u8	reserved;
-	u8	dtimCount;
+	u8	dtim_count;
 	__le32	duration;
 	__le32	interval;
-	__le32	startTime;
+	__le32	start_time;
 } __packed;
 
 static inline int wsm_set_p2p_ps_modeinfo(struct cw1200_common *priv,
-- 
1.8.2.1

