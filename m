Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A0DC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97FBD218D0
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="D80lH4M1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfCPUtK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 16:49:10 -0400
Received: from 3.mo3.mail-out.ovh.net ([46.105.44.175]:36134 "EHLO
        3.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbfCPUtJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 16:49:09 -0400
Received: from player799.ha.ovh.net (unknown [10.109.159.157])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id 525B72038ED
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2019 21:42:23 +0100 (CET)
Received: from awhome.eu (p4FF91B93.dip0.t-ipconnect.de [79.249.27.147])
        (Authenticated sender: postmaster@awhome.eu)
        by player799.ha.ovh.net (Postfix) with ESMTPSA id 1677A3BED76C;
        Sat, 16 Mar 2019 20:42:22 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1552768941;
        bh=SmD9mpw6P2ITAQBLUBkyrK4DrSttCAU9lypGIBQTVl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=D80lH4M1r0Fyz1eJUtNrDfeBeE7iPhDKZbS6ywSAHzuduWu2IMgsxEU4ZCgU4sU8T
         AH4gWsffwYg/ndSGTSgdCt0E/CHKvqFIlxC5Bf/tv9sqPtaSqXFZwL4hNhflAqlPzS
         z6+Qg2oEOnD+UP5xALAdyttB48pRIOy5NxFjs+w8=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH 4/5] mac80211: Mark A-MPDU keyid borders for drivers
Date:   Sat, 16 Mar 2019 21:42:07 +0100
Message-Id: <20190316204208.16497-5-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190316204208.16497-1-alexander@wetzel-home.de>
References: <20190316204208.16497-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6894729555529440455
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrheejgddugeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

IEEE 802.11-2016 "9.7.3 A-MPDU contents" forbids aggregating MPDUs with
different keyids. Without Extended Key ID support this can't happen,
since we only aggregate unicast frames using either no key or key ID 0.
Extended Key ID support can also use key ID 1 for unicast frames and a
rekey with A-MPDU active will therefore need special handling to not
violate the above requirement.

To support drivers handling the key ID borders in A-MPDUs mac80211 will
set the new @IEEE80211_TX_CTRL_AMPDU_FLUSH flag for the last MPDU using
the current keyid. Drivers should then aggregate the MPDU and send out
all A-MPDUs with one or more MPDUs aggregated for all affected TIDs
immediately.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

Bugs fixed compared to last RFC patch:
 - Initial key install is directly used for Tx (last RFC patch hung for
   10s).
 - Always activating Rx accel for correct key in COMPAT mode.

 include/net/mac80211.h  |  4 +++
 net/mac80211/key.c      | 21 ++++++++++++---
 net/mac80211/sta_info.c |  1 +
 net/mac80211/sta_info.h |  4 ++-
 net/mac80211/tx.c       | 60 +++++++++++++++++++++++++++++++++++------
 5 files changed, 78 insertions(+), 12 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 63bd3d5aa707..922239a451c0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -807,6 +807,9 @@ enum mac80211_tx_info_flags {
  * @IEEE80211_TX_CTRL_RATE_INJECT: This frame is injected with rate information
  * @IEEE80211_TX_CTRL_AMSDU: This frame is an A-MSDU frame
  * @IEEE80211_TX_CTRL_FAST_XMIT: This frame is going through the fast_xmit path
+ * @IEEE80211_TX_CTRL_AMPDU_FLUSH: This frame is the last one allowed to be
+ *	aggregated with previous frames to an A-MPDU. Driver has to flush all
+ *	running A-MPDU aggreagations (TIDs) for sta.
  *
  * These flags are used in tx_info->control.flags.
  */
@@ -816,6 +819,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_RATE_INJECT		= BIT(2),
 	IEEE80211_TX_CTRL_AMSDU			= BIT(3),
 	IEEE80211_TX_CTRL_FAST_XMIT		= BIT(4),
+	IEEE80211_TX_CTRL_AMPDU_FLUSH		= BIT(5),
 };
 
 /*
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index bd38167916ad..c174f102f72b 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -294,9 +294,17 @@ int ieee80211_set_tx_key(struct ieee80211_key *key)
 
 	assert_key_lock(local);
 
+	/* Two key activations must not overlap */
+	if (WARN_ON(sta->ptk_idx_next != INVALID_PTK_KEYIDX))
+		return -EOPNOTSUPP;
+
 	old = key_mtx_dereference(local, sta->ptk[sta->ptk_idx]);
-	sta->ptk_idx = key->conf.keyidx;
-	ieee80211_check_fast_xmit(sta);
+
+	/* The initial key still must be used immediately */
+	if (sta->ptk_idx == INVALID_PTK_KEYIDX)
+		sta->ptk_idx = key->conf.keyidx;
+	else
+		sta->ptk_idx_next = key->conf.keyidx;
 
 	if (ieee80211_hw_check(&local->hw, EXT_KEY_ID_COMPAT) &&
 	    key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
@@ -1102,13 +1110,20 @@ void delayed_rx_accel_work(struct work_struct *wk)
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key *key;
+	int keyid;
 
 	sta = container_of(wk, struct sta_info, delayed_rx_accel_wk);
 	local = sta->local;
 	sdata = sta->sdata;
 
+	/* sta->ptk_idx_next is the new key if not set to INVALID_PTK_KEYIDX */
+	if (sta->ptk_idx_next != INVALID_PTK_KEYIDX)
+		keyid = sta->ptk_idx_next;
+	else
+		keyid = sta->ptk_idx;
+
 	mutex_lock(&local->key_mtx);
-	key = key_mtx_dereference(local, sta->ptk[sta->ptk_idx]);
+	key = key_mtx_dereference(local, sta->ptk[keyid]);
 	drv_set_key(local, ENABLE_KEY_RX, sdata, &sta->sta, &key->conf);
 
 	mutex_unlock(&local->key_mtx);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 41ea1d05a946..7aa85cc7a667 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -357,6 +357,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	 */
 	BUILD_BUG_ON(ARRAY_SIZE(sta->ptk) <= INVALID_PTK_KEYIDX);
 	sta->ptk_idx = INVALID_PTK_KEYIDX;
+	sta->ptk_idx_next = INVALID_PTK_KEYIDX;
 
 	sta->local = local;
 	sta->sdata = sdata;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 45f7cbfe9698..271c0075f4e2 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -449,7 +449,8 @@ struct ieee80211_sta_rx_stats {
  * @local: pointer to the global information
  * @sdata: virtual interface this station belongs to
  * @ptk: peer keys negotiated with this station, if any
- * @ptk_idx: last installed peer key index
+ * @ptk_idx: activated peer key index
+ * @ptk_idx_next: peer key index in activation (Extended Key ID only)
  * @delayed_rx_accel_wk: Used to activate Rx crypto offload only after
  *	we have	seen one MPDU encrypted with the key.
  * @gtk: group keys negotiated with this station, if any
@@ -534,6 +535,7 @@ struct sta_info {
 	struct ieee80211_key __rcu *ptk[NUM_DEFAULT_KEYS];
 	struct work_struct delayed_rx_accel_wk;
 	u8 ptk_idx;
+	u8 ptk_idx_next;
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
 	spinlock_t rate_ctrl_lock;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 111bd6c490a6..c3ea5107d8f9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -586,6 +586,47 @@ ieee80211_tx_h_check_control_port_protocol(struct ieee80211_tx_data *tx)
 	return TX_CONTINUE;
 }
 
+static struct ieee80211_key debug_noinline
+*ieee80211_select_sta_key(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct sta_info *sta = tx->sta;
+	struct ieee80211_key *key;
+	struct ieee80211_key *next_key;
+
+	key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx]);
+
+	if (likely(sta->ptk_idx_next == INVALID_PTK_KEYIDX))
+		return key;
+
+	/* Only when using Extended Key ID the code below can be executed */
+
+	if (!ieee80211_is_data_present(hdr->frame_control))
+		return key;
+
+	if (sta->ptk_idx_next == sta->ptk_idx) {
+		/* First packet using new key with A-MPDU active */
+		sta->ptk_idx_next = INVALID_PTK_KEYIDX;
+		ieee80211_check_fast_xmit(tx->sta);
+		return key;
+	}
+
+	next_key = rcu_dereference(sta->ptk[sta->ptk_idx_next]);
+	sta->ptk_idx = sta->ptk_idx_next;
+
+	if (key && info->flags & IEEE80211_TX_CTL_AMPDU) {
+		/* Last packet with old key with A-MPDU active */
+		info->control.flags |= IEEE80211_TX_CTRL_AMPDU_FLUSH;
+		return key;
+	}
+
+	/* No A-MPDU active or no encryption, just use the new key */
+	sta->ptk_idx_next = INVALID_PTK_KEYIDX;
+	ieee80211_check_fast_xmit(tx->sta);
+	return next_key;
+}
+
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
@@ -595,9 +636,8 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT))
 		tx->key = NULL;
-	else if (tx->sta &&
-		 (key = rcu_dereference(tx->sta->ptk[tx->sta->ptk_idx])))
-		tx->key = key;
+	else if (tx->sta)
+		tx->key = ieee80211_select_sta_key(tx);
 	else if (ieee80211_is_group_privacy_action(tx->skb) &&
 		(key = rcu_dereference(tx->sdata->default_multicast_key)))
 		tx->key = key;
@@ -3414,6 +3454,10 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	if (skb->sk && skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS)
 		return false;
 
+	/* ieee80211_key_activate() requests to change key */
+	if (unlikely(sta->ptk_idx_next != INVALID_PTK_KEYIDX))
+		return false;
+
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 		tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
@@ -3556,6 +3600,11 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	if (txq->sta)
 		tx.sta = container_of(txq->sta, struct sta_info, sta);
 
+	if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
+		info->flags |= IEEE80211_TX_CTL_AMPDU;
+	else
+		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
+
 	/*
 	 * The key can be removed while the packet was queued, so need to call
 	 * this here to get the current key.
@@ -3566,11 +3615,6 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		goto begin;
 	}
 
-	if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
-		info->flags |= IEEE80211_TX_CTL_AMPDU;
-	else
-		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-
 	if (info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) {
 		struct sta_info *sta = container_of(txq->sta, struct sta_info,
 						    sta);
-- 
2.21.0

