Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993197Ab2KOL3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 06:29:13 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: introduce IEEE80211_NUM_TIDS and use it
Date: Thu, 15 Nov 2012 12:29:44 +0100
Message-Id: <1352978984-15876-1-git-send-email-johannes@sipsolutions.net> (sfid-20121115_122917_415702_1452D5AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Introduce IEEE80211_NUM_TIDS in the generic 802.11
header file and use it in place of STA_TID_NUM and
NUM_RX_DATA_QUEUES which are both really the number
of TIDs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h  |  2 ++
 net/mac80211/agg-rx.c      |  2 +-
 net/mac80211/agg-tx.c      | 12 ++++++------
 net/mac80211/debugfs_key.c |  6 +++---
 net/mac80211/debugfs_sta.c | 10 +++++-----
 net/mac80211/ht.c          |  4 ++--
 net/mac80211/key.c         | 10 +++++-----
 net/mac80211/key.h         |  8 +++-----
 net/mac80211/rx.c          |  4 ++--
 net/mac80211/sta_info.c    | 10 +++++-----
 net/mac80211/sta_info.h    | 19 +++++++++----------
 11 files changed, 43 insertions(+), 44 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 8bf9ccb..8156761 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -131,6 +131,8 @@
 
 #define IEEE80211_MAX_MESH_ID_LEN	32
 
+#define IEEE80211_NUM_TIDS		16
+
 #define IEEE80211_QOS_CTL_LEN		2
 /* 1d tag mask */
 #define IEEE80211_QOS_CTL_TAG1D_MASK		0x0007
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 186d991..808338a 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -118,7 +118,7 @@ void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
 		return;
 	}
 
-	for (i = 0; i < STA_TID_NUM; i++)
+	for (i = 0; i < IEEE80211_NUM_TIDS; i++)
 		if (ba_rx_bitmap & BIT(i))
 			set_bit(i, sta->ampdu_mlme.tid_rx_stop_requested);
 
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 3195a63..4152ed1 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -448,7 +448,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	if (WARN_ON(!local->ops->ampdu_action))
 		return -EINVAL;
 
-	if ((tid >= STA_TID_NUM) ||
+	if ((tid >= IEEE80211_NUM_TIDS) ||
 	    !(local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) ||
 	    (local->hw.flags & IEEE80211_HW_TX_AMPDU_SETUP_IN_HW))
 		return -EINVAL;
@@ -605,9 +605,9 @@ void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid)
 
 	trace_api_start_tx_ba_cb(sdata, ra, tid);
 
-	if (tid >= STA_TID_NUM) {
+	if (tid >= IEEE80211_NUM_TIDS) {
 		ht_dbg(sdata, "Bad TID value: tid = %d (>= %d)\n",
-		       tid, STA_TID_NUM);
+		       tid, IEEE80211_NUM_TIDS);
 		return;
 	}
 
@@ -687,7 +687,7 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 	if (!local->ops->ampdu_action)
 		return -EINVAL;
 
-	if (tid >= STA_TID_NUM)
+	if (tid >= IEEE80211_NUM_TIDS)
 		return -EINVAL;
 
 	spin_lock_bh(&sta->lock);
@@ -722,9 +722,9 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 
 	trace_api_stop_tx_ba_cb(sdata, ra, tid);
 
-	if (tid >= STA_TID_NUM) {
+	if (tid >= IEEE80211_NUM_TIDS) {
 		ht_dbg(sdata, "Bad TID value: tid = %d (>= %d)\n",
-		       tid, STA_TID_NUM);
+		       tid, IEEE80211_NUM_TIDS);
 		return;
 	}
 
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 090d08f..2d42354 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -116,7 +116,7 @@ static ssize_t key_rx_spec_read(struct file *file, char __user *userbuf,
 				size_t count, loff_t *ppos)
 {
 	struct ieee80211_key *key = file->private_data;
-	char buf[14*NUM_RX_DATA_QUEUES+1], *p = buf;
+	char buf[14*IEEE80211_NUM_TIDS+1], *p = buf;
 	int i, len;
 	const u8 *rpn;
 
@@ -126,7 +126,7 @@ static ssize_t key_rx_spec_read(struct file *file, char __user *userbuf,
 		len = scnprintf(buf, sizeof(buf), "\n");
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-		for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
+		for (i = 0; i < IEEE80211_NUM_TIDS; i++)
 			p += scnprintf(p, sizeof(buf)+buf-p,
 				       "%08x %04x\n",
 				       key->u.tkip.rx[i].iv32,
@@ -134,7 +134,7 @@ static ssize_t key_rx_spec_read(struct file *file, char __user *userbuf,
 		len = p - buf;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-		for (i = 0; i < NUM_RX_DATA_QUEUES + 1; i++) {
+		for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++) {
 			rpn = key->u.ccmp.rx_pn[i];
 			p += scnprintf(p, sizeof(buf)+buf-p,
 				       "%02x%02x%02x%02x%02x%02x\n",
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 5ccec2c..3d10392 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -131,10 +131,10 @@ STA_OPS(connected_time);
 static ssize_t sta_last_seq_ctrl_read(struct file *file, char __user *userbuf,
 				      size_t count, loff_t *ppos)
 {
-	char buf[15*NUM_RX_DATA_QUEUES], *p = buf;
+	char buf[15*IEEE80211_NUM_TIDS], *p = buf;
 	int i;
 	struct sta_info *sta = file->private_data;
-	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
+	for (i = 0; i < IEEE80211_NUM_TIDS; i++)
 		p += scnprintf(p, sizeof(buf)+buf-p, "%x ",
 			       le16_to_cpu(sta->last_seq_ctrl[i]));
 	p += scnprintf(p, sizeof(buf)+buf-p, "\n");
@@ -145,7 +145,7 @@ STA_OPS(last_seq_ctrl);
 static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 					size_t count, loff_t *ppos)
 {
-	char buf[71 + STA_TID_NUM * 40], *p = buf;
+	char buf[71 + IEEE80211_NUM_TIDS * 40], *p = buf;
 	int i;
 	struct sta_info *sta = file->private_data;
 	struct tid_ampdu_rx *tid_rx;
@@ -158,7 +158,7 @@ static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 	p += scnprintf(p, sizeof(buf) + buf - p,
 		       "TID\t\tRX active\tDTKN\tSSN\t\tTX\tDTKN\tpending\n");
 
-	for (i = 0; i < STA_TID_NUM; i++) {
+	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 		tid_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[i]);
 		tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[i]);
 
@@ -220,7 +220,7 @@ static ssize_t sta_agg_status_write(struct file *file, const char __user *userbu
 
 	tid = simple_strtoul(buf, NULL, 0);
 
-	if (tid >= STA_TID_NUM)
+	if (tid >= IEEE80211_NUM_TIDS)
 		return -EINVAL;
 
 	if (tx) {
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 4b4538d..a71d891 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -185,7 +185,7 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx)
 
 	cancel_work_sync(&sta->ampdu_mlme.work);
 
-	for (i = 0; i <  STA_TID_NUM; i++) {
+	for (i = 0; i <  IEEE80211_NUM_TIDS; i++) {
 		__ieee80211_stop_tx_ba_session(sta, i, WLAN_BACK_INITIATOR, tx);
 		__ieee80211_stop_rx_ba_session(sta, i, WLAN_BACK_RECIPIENT,
 					       WLAN_REASON_QSTA_LEAVE_QBSS, tx);
@@ -209,7 +209,7 @@ void ieee80211_ba_session_work(struct work_struct *work)
 		return;
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
-	for (tid = 0; tid < STA_TID_NUM; tid++) {
+	for (tid = 0; tid < IEEE80211_NUM_TIDS; tid++) {
 		if (test_and_clear_bit(tid, sta->ampdu_mlme.tid_rx_timer_expired))
 			___ieee80211_stop_rx_ba_session(
 				sta, tid, WLAN_BACK_RECIPIENT,
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 0f18ef5..619c5d6 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -339,7 +339,7 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		key->conf.iv_len = TKIP_IV_LEN;
 		key->conf.icv_len = TKIP_ICV_LEN;
 		if (seq) {
-			for (i = 0; i < NUM_RX_DATA_QUEUES; i++) {
+			for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 				key->u.tkip.rx[i].iv32 =
 					get_unaligned_le32(&seq[2]);
 				key->u.tkip.rx[i].iv16 =
@@ -352,7 +352,7 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		key->conf.iv_len = CCMP_HDR_LEN;
 		key->conf.icv_len = CCMP_MIC_LEN;
 		if (seq) {
-			for (i = 0; i < NUM_RX_DATA_QUEUES + 1; i++)
+			for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++)
 				for (j = 0; j < CCMP_PN_LEN; j++)
 					key->u.ccmp.rx_pn[i][j] =
 						seq[CCMP_PN_LEN - j - 1];
@@ -655,16 +655,16 @@ void ieee80211_get_key_rx_seq(struct ieee80211_key_conf *keyconf,
 
 	switch (key->conf.cipher) {
 	case WLAN_CIPHER_SUITE_TKIP:
-		if (WARN_ON(tid < 0 || tid >= NUM_RX_DATA_QUEUES))
+		if (WARN_ON(tid < 0 || tid >= IEEE80211_NUM_TIDS))
 			return;
 		seq->tkip.iv32 = key->u.tkip.rx[tid].iv32;
 		seq->tkip.iv16 = key->u.tkip.rx[tid].iv16;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-		if (WARN_ON(tid < -1 || tid >= NUM_RX_DATA_QUEUES))
+		if (WARN_ON(tid < -1 || tid >= IEEE80211_NUM_TIDS))
 			return;
 		if (tid < 0)
-			pn = key->u.ccmp.rx_pn[NUM_RX_DATA_QUEUES];
+			pn = key->u.ccmp.rx_pn[IEEE80211_NUM_TIDS];
 		else
 			pn = key->u.ccmp.rx_pn[tid];
 		memcpy(seq->ccmp.pn, pn, CCMP_PN_LEN);
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 7d4e31f..7cff0d3 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -30,8 +30,6 @@
 #define TKIP_ICV_LEN		4
 #define CMAC_PN_LEN		6
 
-#define NUM_RX_DATA_QUEUES	16
-
 struct ieee80211_local;
 struct ieee80211_sub_if_data;
 struct sta_info;
@@ -82,17 +80,17 @@ struct ieee80211_key {
 			struct tkip_ctx tx;
 
 			/* last received RSC */
-			struct tkip_ctx rx[NUM_RX_DATA_QUEUES];
+			struct tkip_ctx rx[IEEE80211_NUM_TIDS];
 		} tkip;
 		struct {
 			atomic64_t tx_pn;
 			/*
 			 * Last received packet number. The first
-			 * NUM_RX_DATA_QUEUES counters are used with Data
+			 * IEEE80211_NUM_TIDS counters are used with Data
 			 * frames and the last counter is used with Robust
 			 * Management frames.
 			 */
-			u8 rx_pn[NUM_RX_DATA_QUEUES + 1][CCMP_PN_LEN];
+			u8 rx_pn[IEEE80211_NUM_TIDS + 1][CCMP_PN_LEN];
 			struct crypto_cipher *tfm;
 			u32 replays; /* dot11RSNAStatsCCMPReplays */
 		} ccmp;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 87e123b..51c9a9f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -408,10 +408,10 @@ static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
 		 *
 		 * We also use that counter for non-QoS STAs.
 		 */
-		seqno_idx = NUM_RX_DATA_QUEUES;
+		seqno_idx = IEEE80211_NUM_TIDS;
 		security_idx = 0;
 		if (ieee80211_is_mgmt(hdr->frame_control))
-			security_idx = NUM_RX_DATA_QUEUES;
+			security_idx = IEEE80211_NUM_TIDS;
 		tid = 0;
 	}
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0b4a77f..dadcfcf 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -142,7 +142,7 @@ static void free_sta_work(struct work_struct *wk)
 	 * drivers have to handle aggregation stop being requested, followed
 	 * directly by station destruction.
 	 */
-	for (i = 0; i < STA_TID_NUM; i++) {
+	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 		tid_tx = rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]);
 		if (!tid_tx)
 			continue;
@@ -330,7 +330,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		return NULL;
 	}
 
-	for (i = 0; i < STA_TID_NUM; i++) {
+	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
 		/*
 		 * timer_to_tid must be initialized with identity mapping
 		 * to enable session_timer's data differentiation. See
@@ -343,7 +343,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		skb_queue_head_init(&sta->tx_filtered[i]);
 	}
 
-	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
+	for (i = 0; i < IEEE80211_NUM_TIDS; i++)
 		sta->last_seq_ctrl[i] = cpu_to_le16(USHRT_MAX);
 
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
@@ -985,7 +985,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 
 	clear_sta_flag(sta, WLAN_STA_SP);
 
-	BUILD_BUG_ON(BITS_TO_LONGS(STA_TID_NUM) > 1);
+	BUILD_BUG_ON(BITS_TO_LONGS(IEEE80211_NUM_TIDS) > 1);
 	sta->driver_buffered_tids = 0;
 
 	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
@@ -1369,7 +1369,7 @@ void ieee80211_sta_set_buffered(struct ieee80211_sta *pubsta,
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 
-	if (WARN_ON(tid >= STA_TID_NUM))
+	if (WARN_ON(tid >= IEEE80211_NUM_TIDS))
 		return;
 
 	if (buffered)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index dcc0ffc..6835cea 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -80,7 +80,6 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_TOFFSET_KNOWN,
 };
 
-#define STA_TID_NUM 16
 #define ADDBA_RESP_INTERVAL HZ
 #define HT_AGG_MAX_RETRIES		15
 #define HT_AGG_BURST_RETRIES		3
@@ -197,15 +196,15 @@ struct tid_ampdu_rx {
 struct sta_ampdu_mlme {
 	struct mutex mtx;
 	/* rx */
-	struct tid_ampdu_rx __rcu *tid_rx[STA_TID_NUM];
-	unsigned long tid_rx_timer_expired[BITS_TO_LONGS(STA_TID_NUM)];
-	unsigned long tid_rx_stop_requested[BITS_TO_LONGS(STA_TID_NUM)];
+	struct tid_ampdu_rx __rcu *tid_rx[IEEE80211_NUM_TIDS];
+	unsigned long tid_rx_timer_expired[BITS_TO_LONGS(IEEE80211_NUM_TIDS)];
+	unsigned long tid_rx_stop_requested[BITS_TO_LONGS(IEEE80211_NUM_TIDS)];
 	/* tx */
 	struct work_struct work;
-	struct tid_ampdu_tx __rcu *tid_tx[STA_TID_NUM];
-	struct tid_ampdu_tx *tid_start_tx[STA_TID_NUM];
-	unsigned long last_addba_req_time[STA_TID_NUM];
-	u8 addba_req_num[STA_TID_NUM];
+	struct tid_ampdu_tx __rcu *tid_tx[IEEE80211_NUM_TIDS];
+	struct tid_ampdu_tx *tid_start_tx[IEEE80211_NUM_TIDS];
+	unsigned long last_addba_req_time[IEEE80211_NUM_TIDS];
+	u8 addba_req_num[IEEE80211_NUM_TIDS];
 	u8 dialog_token_allocator;
 };
 
@@ -331,7 +330,7 @@ struct sta_info {
 	int last_signal;
 	struct ewma avg_signal;
 	/* Plus 1 for non-QoS frames */
-	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES + 1];
+	__le16 last_seq_ctrl[IEEE80211_NUM_TIDS + 1];
 
 	/* Updated from TX status path only, no locking requirements */
 	unsigned long tx_filtered_count;
@@ -353,7 +352,7 @@ struct sta_info {
 	 * Aggregation information, locked with lock.
 	 */
 	struct sta_ampdu_mlme ampdu_mlme;
-	u8 timer_to_tid[STA_TID_NUM];
+	u8 timer_to_tid[IEEE80211_NUM_TIDS];
 
 #ifdef CONFIG_MAC80211_MESH
 	/*
-- 
1.8.0

