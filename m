Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42548 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbcB2VdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 16:33:03 -0500
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>,
	Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 04/15] wil6210: replay attack detection
Date: Mon, 29 Feb 2016 23:32:39 +0200
Message-Id: <1456781570-16552-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160229_223309_409542_4BF98A26)
In-Reply-To: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Check PN for encrypted frames.
Maintain PN data for Rx keys, pairwise per TID and group.
Print PN's in the debugfs "stations" entry, like:

[0] 04:ce:14:0a:3c:3d connected
  [ 0] ([32]   0 TU) 0x0fe [____________________________|___] total 252 drop 0 (dup 0 + old 0) last 0x000
  [ 0] PN [0+]000000000000 [1-]000000000000 [2-]000000000000 [3-]000000000000
  [GR] PN [0-]000000000000 [1+]000000000000 [2+]000000000000 [3-]000000000000
Rx invalid frame: non-data 0, short 0, large 0, replay 0
Rx/MCS: 0 110 65 65 65 0 12 0 0 0 0 0 0
[1] 00:00:00:00:00:00 unused
[2] 00:00:00:00:00:00 unused
[3] 00:00:00:00:00:00 unused
[4] 00:00:00:00:00:00 unused
[5] 00:00:00:00:00:00 unused
[6] 00:00:00:00:00:00 unused
[7] 00:00:00:00:00:00 unused

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 100 +++++++++++++++++++++++++---
 drivers/net/wireless/ath/wil6210/debugfs.c  |  41 +++++++++++-
 drivers/net/wireless/ath/wil6210/main.c     |   9 ++-
 drivers/net/wireless/ath/wil6210/txrx.c     |  63 ++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.h     |  12 +++-
 drivers/net/wireless/ath/wil6210/wil6210.h  |  18 +++++
 6 files changed, 226 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 11f1bb8..ddadda9 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -82,6 +82,12 @@ static const u32 wil_cipher_suites[] = {
 	WLAN_CIPHER_SUITE_GCMP,
 };
 
+static const char * const key_usage_str[] = {
+	[WMI_KEY_USE_PAIRWISE]	= "PTK",
+	[WMI_KEY_USE_RX_GROUP]	= "RX_GTK",
+	[WMI_KEY_USE_TX_GROUP]	= "TX_GTK",
+};
+
 int wil_iftype_nl2wmi(enum nl80211_iftype type)
 {
 	static const struct {
@@ -610,11 +616,6 @@ static enum wmi_key_usage wil_detect_key_usage(struct wil6210_priv *wil,
 {
 	struct wireless_dev *wdev = wil->wdev;
 	enum wmi_key_usage rc;
-	static const char * const key_usage_str[] = {
-		[WMI_KEY_USE_PAIRWISE]	= "WMI_KEY_USE_PAIRWISE",
-		[WMI_KEY_USE_RX_GROUP]	= "WMI_KEY_USE_RX_GROUP",
-		[WMI_KEY_USE_TX_GROUP]	= "WMI_KEY_USE_TX_GROUP",
-	};
 
 	if (pairwise) {
 		rc = WMI_KEY_USE_PAIRWISE;
@@ -638,20 +639,86 @@ static enum wmi_key_usage wil_detect_key_usage(struct wil6210_priv *wil,
 	return rc;
 }
 
+static struct wil_tid_crypto_rx_single *
+wil_find_crypto_ctx(struct wil6210_priv *wil, u8 key_index,
+		    enum wmi_key_usage key_usage, const u8 *mac_addr)
+{
+	int cid = -EINVAL;
+	int tid = 0;
+	struct wil_sta_info *s;
+	struct wil_tid_crypto_rx *c;
+
+	if (key_usage == WMI_KEY_USE_TX_GROUP)
+		return NULL; /* not needed */
+
+	/* supplicant provides Rx group key in STA mode with NULL MAC address */
+	if (mac_addr)
+		cid = wil_find_cid(wil, mac_addr);
+	else if (key_usage == WMI_KEY_USE_RX_GROUP)
+		cid = wil_find_cid_by_idx(wil, 0);
+	if (cid < 0) {
+		wil_err(wil, "No CID for %pM %s[%d]\n", mac_addr,
+			key_usage_str[key_usage], key_index);
+		return ERR_PTR(cid);
+	}
+
+	s = &wil->sta[cid];
+	if (key_usage == WMI_KEY_USE_PAIRWISE)
+		c = &s->tid_crypto_rx[tid];
+	else
+		c = &s->group_crypto_rx;
+
+	return &c->key_id[key_index];
+}
+
 static int wil_cfg80211_add_key(struct wiphy *wiphy,
 				struct net_device *ndev,
 				u8 key_index, bool pairwise,
 				const u8 *mac_addr,
 				struct key_params *params)
 {
+	int rc;
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	enum wmi_key_usage key_usage = wil_detect_key_usage(wil, pairwise);
+	struct wil_tid_crypto_rx_single *cc = wil_find_crypto_ctx(wil,
+								  key_index,
+								  key_usage,
+								  mac_addr);
+
+	wil_dbg_misc(wil, "%s(%pM %s[%d] PN %*phN)\n", __func__,
+		     mac_addr, key_usage_str[key_usage], key_index,
+		     params->seq_len, params->seq);
+
+	if (IS_ERR(cc)) {
+		wil_err(wil, "Not connected, %s(%pM %s[%d] PN %*phN)\n",
+			__func__, mac_addr, key_usage_str[key_usage], key_index,
+			params->seq_len, params->seq);
+		return -EINVAL;
+	}
+
+	if (cc)
+		cc->key_set = false;
 
-	wil_dbg_misc(wil, "%s(%pM[%d] %s)\n", __func__, mac_addr, key_index,
-		     pairwise ? "PTK" : "GTK");
+	if (params->seq && params->seq_len != IEEE80211_GCMP_PN_LEN) {
+		wil_err(wil,
+			"Wrong PN len %d, %s(%pM %s[%d] PN %*phN)\n",
+			params->seq_len, __func__, mac_addr,
+			key_usage_str[key_usage], key_index,
+			params->seq_len, params->seq);
+		return -EINVAL;
+	}
 
-	return wmi_add_cipher_key(wil, key_index, mac_addr, params->key_len,
-				  params->key, key_usage);
+	rc = wmi_add_cipher_key(wil, key_index, mac_addr, params->key_len,
+				params->key, key_usage);
+	if ((rc == 0) && cc) {
+		if (params->seq)
+			memcpy(cc->pn, params->seq, IEEE80211_GCMP_PN_LEN);
+		else
+			memset(cc->pn, 0, IEEE80211_GCMP_PN_LEN);
+		cc->key_set = true;
+	}
+
+	return rc;
 }
 
 static int wil_cfg80211_del_key(struct wiphy *wiphy,
@@ -661,9 +728,20 @@ static int wil_cfg80211_del_key(struct wiphy *wiphy,
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	enum wmi_key_usage key_usage = wil_detect_key_usage(wil, pairwise);
+	struct wil_tid_crypto_rx_single *cc = wil_find_crypto_ctx(wil,
+								  key_index,
+								  key_usage,
+								  mac_addr);
+
+	wil_dbg_misc(wil, "%s(%pM %s[%d])\n", __func__, mac_addr,
+		     key_usage_str[key_usage], key_index);
+
+	if (IS_ERR(cc))
+		wil_info(wil, "Not connected, %s(%pM %s[%d])\n", __func__,
+			 mac_addr, key_usage_str[key_usage], key_index);
 
-	wil_dbg_misc(wil, "%s(%pM[%d] %s)\n", __func__, mac_addr, key_index,
-		     pairwise ? "PTK" : "GTK");
+	if (!IS_ERR_OR_NULL(cc))
+		cc->key_set = false;
 
 	return wmi_del_cipher_key(wil, key_index, mac_addr, key_usage);
 }
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 3bbe73b..d80bb75 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1333,6 +1333,34 @@ static void wil_print_rxtid(struct seq_file *s, struct wil_tid_ampdu_rx *r)
 		   r->ssn_last_drop);
 }
 
+static void wil_print_rxtid_crypto(struct seq_file *s, int tid,
+				   struct wil_tid_crypto_rx *c)
+{
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		struct wil_tid_crypto_rx_single *cc = &c->key_id[i];
+
+		if (cc->key_set)
+			goto has_keys;
+	}
+	return;
+
+has_keys:
+	if (tid < WIL_STA_TID_NUM)
+		seq_printf(s, "  [%2d] PN", tid);
+	else
+		seq_puts(s, "  [GR] PN");
+
+	for (i = 0; i < 4; i++) {
+		struct wil_tid_crypto_rx_single *cc = &c->key_id[i];
+
+		seq_printf(s, " [%i%s]%6phN", i, cc->key_set ? "+" : "-",
+			   cc->pn);
+	}
+	seq_puts(s, "\n");
+}
+
 static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 __acquires(&p->tid_rx_lock) __releases(&p->tid_rx_lock)
 {
@@ -1360,18 +1388,25 @@ __acquires(&p->tid_rx_lock) __releases(&p->tid_rx_lock)
 			spin_lock_bh(&p->tid_rx_lock);
 			for (tid = 0; tid < WIL_STA_TID_NUM; tid++) {
 				struct wil_tid_ampdu_rx *r = p->tid_rx[tid];
+				struct wil_tid_crypto_rx *c =
+						&p->tid_crypto_rx[tid];
 
 				if (r) {
-					seq_printf(s, "[%2d] ", tid);
+					seq_printf(s, "  [%2d] ", tid);
 					wil_print_rxtid(s, r);
 				}
+
+				wil_print_rxtid_crypto(s, tid, c);
 			}
+			wil_print_rxtid_crypto(s, WIL_STA_TID_NUM,
+					       &p->group_crypto_rx);
 			spin_unlock_bh(&p->tid_rx_lock);
 			seq_printf(s,
-				   "Rx invalid frame: non-data %lu, short %lu, large %lu\n",
+				   "Rx invalid frame: non-data %lu, short %lu, large %lu, replay %lu\n",
 				   p->stats.rx_non_data_frame,
 				   p->stats.rx_short_frame,
-				   p->stats.rx_large_frame);
+				   p->stats.rx_large_frame,
+				   p->stats.rx_replay);
 
 			seq_puts(s, "Rx/MCS:");
 			for (mcs = 0; mcs < ARRAY_SIZE(p->stats.rx_per_mcs);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 997a740..1fa215d 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -149,7 +149,7 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 	might_sleep();
 	wil_dbg_misc(wil, "%s(CID %d, status %d)\n", __func__, cid,
 		     sta->status);
-
+	/* inform upper/lower layers */
 	if (sta->status != wil_sta_unused) {
 		if (!from_event)
 			wmi_disconnect_sta(wil, sta->addr, reason_code, true);
@@ -165,7 +165,7 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 		}
 		sta->status = wil_sta_unused;
 	}
-
+	/* reorder buffers */
 	for (i = 0; i < WIL_STA_TID_NUM; i++) {
 		struct wil_tid_ampdu_rx *r;
 
@@ -177,10 +177,15 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 
 		spin_unlock_bh(&sta->tid_rx_lock);
 	}
+	/* crypto context */
+	memset(sta->tid_crypto_rx, 0, sizeof(sta->tid_crypto_rx));
+	memset(&sta->group_crypto_rx, 0, sizeof(sta->group_crypto_rx));
+	/* release vrings */
 	for (i = 0; i < ARRAY_SIZE(wil->vring_tx); i++) {
 		if (wil->vring2cid_tid[i][0] == cid)
 			wil_vring_fini_tx(wil, i);
 	}
+	/* statistics */
 	memset(&sta->stats, 0, sizeof(sta->stats));
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 6af2090..f383001 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -549,6 +549,60 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
 	return rc;
 }
 
+/**
+ * reverse_memcmp - Compare two areas of memory, in reverse order
+ * @cs: One area of memory
+ * @ct: Another area of memory
+ * @count: The size of the area.
+ *
+ * Cut'n'paste from original memcmp (see lib/string.c)
+ * with minimal modifications
+ */
+static int reverse_memcmp(const void *cs, const void *ct, size_t count)
+{
+	const unsigned char *su1, *su2;
+	int res = 0;
+
+	for (su1 = cs + count - 1, su2 = ct + count - 1; count > 0;
+	     --su1, --su2, count--) {
+		res = *su1 - *su2;
+		if (res)
+			break;
+	}
+	return res;
+}
+
+static int wil_rx_crypto_check(struct wil6210_priv *wil, struct sk_buff *skb)
+{
+	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
+	int cid = wil_rxdesc_cid(d);
+	int tid = wil_rxdesc_tid(d);
+	int key_id = wil_rxdesc_key_id(d);
+	int mc = wil_rxdesc_mcast(d);
+	struct wil_sta_info *s = &wil->sta[cid];
+	struct wil_tid_crypto_rx *c = mc ? &s->group_crypto_rx :
+				      &s->tid_crypto_rx[tid];
+	struct wil_tid_crypto_rx_single *cc = &c->key_id[key_id];
+	const u8 *pn = (u8 *)&d->mac.pn_15_0;
+
+	if (!cc->key_set) {
+		wil_err_ratelimited(wil,
+				    "Key missing. CID %d TID %d MCast %d KEY_ID %d\n",
+				    cid, tid, mc, key_id);
+		return -EINVAL;
+	}
+
+	if (reverse_memcmp(pn, cc->pn, IEEE80211_GCMP_PN_LEN) <= 0) {
+		wil_err_ratelimited(wil,
+				    "Replay attack. CID %d TID %d MCast %d KEY_ID %d PN %6phN last %6phN\n",
+				    cid, tid, mc, key_id, pn, cc->pn);
+		return -EINVAL;
+	}
+	memcpy(cc->pn, pn, IEEE80211_GCMP_PN_LEN);
+
+	return 0;
+}
+
 /*
  * Pass Rx packet to the netif. Update statistics.
  * Called in softirq context (NAPI poll).
@@ -561,6 +615,7 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 	unsigned int len = skb->len;
 	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
 	int cid = wil_rxdesc_cid(d); /* always 0..7, no need to check */
+	int security = wil_rxdesc_security(d);
 	struct ethhdr *eth = (void *)skb->data;
 	/* here looking for DA, not A1, thus Rxdesc's 'mcast' indication
 	 * is not suitable, need to look at data
@@ -586,6 +641,13 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 
 	skb_orphan(skb);
 
+	if (security && (wil_rx_crypto_check(wil, skb) != 0)) {
+		rc = GRO_DROP;
+		dev_kfree_skb(skb);
+		stats->rx_replay++;
+		goto stats;
+	}
+
 	if (wdev->iftype == NL80211_IFTYPE_AP && !wil->ap_isolate) {
 		if (mcast) {
 			/* send multicast frames both to higher layers in
@@ -627,6 +689,7 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 		wil_dbg_txrx(wil, "Rx complete %d bytes => %s\n",
 			     len, gro_res_str[rc]);
 	}
+stats:
 	/* statistics. rc set to GRO_NORMAL for AP bridging */
 	if (unlikely(rc == GRO_DROP)) {
 		ndev->stats.rx_dropped++;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index ee7c7b4..fcdffaa 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2014 Qualcomm Atheros, Inc.
+ * Copyright (c) 2012-2016 Qualcomm Atheros, Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -480,6 +480,16 @@ static inline int wil_rxdesc_ext_subtype(struct vring_rx_desc *d)
 	return WIL_GET_BITS(d->mac.d0, 28, 31);
 }
 
+static inline int wil_rxdesc_key_id(struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->mac.d1, 4, 5);
+}
+
+static inline int wil_rxdesc_security(struct vring_rx_desc *d)
+{
+	return WIL_GET_BITS(d->mac.d1, 7, 7);
+}
+
 static inline int wil_rxdesc_ds_bits(struct vring_rx_desc *d)
 {
 	return WIL_GET_BITS(d->mac.d1, 8, 9);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index d59c3f2..44ff040 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -455,6 +455,21 @@ struct wil_tid_ampdu_rx {
 	bool first_time; /* is it 1-st time this buffer used? */
 };
 
+/**
+ * struct wil_tid_crypto_rx_single - TID crypto information (Rx).
+ *
+ * @pn: GCMP PN for the session
+ * @key_set: valid key present
+ */
+struct wil_tid_crypto_rx_single {
+	u8 pn[IEEE80211_GCMP_PN_LEN];
+	bool key_set;
+};
+
+struct wil_tid_crypto_rx {
+	struct wil_tid_crypto_rx_single key_id[4];
+};
+
 enum wil_sta_status {
 	wil_sta_unused = 0,
 	wil_sta_conn_pending = 1,
@@ -474,6 +489,7 @@ struct wil_net_stats {
 	unsigned long	rx_non_data_frame;
 	unsigned long	rx_short_frame;
 	unsigned long	rx_large_frame;
+	unsigned long	rx_replay;
 	u16 last_mcs_rx;
 	u64 rx_per_mcs[WIL_MCS_MAX + 1];
 };
@@ -495,6 +511,8 @@ struct wil_sta_info {
 	spinlock_t tid_rx_lock; /* guarding tid_rx array */
 	unsigned long tid_rx_timer_expired[BITS_TO_LONGS(WIL_STA_TID_NUM)];
 	unsigned long tid_rx_stop_requested[BITS_TO_LONGS(WIL_STA_TID_NUM)];
+	struct wil_tid_crypto_rx tid_crypto_rx[WIL_STA_TID_NUM];
+	struct wil_tid_crypto_rx group_crypto_rx;
 };
 
 enum {
-- 
1.8.5.2

