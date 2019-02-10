Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6FDC4151A
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ADAA213F2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:06:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="MtXl0aLw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfBJVGv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 16:06:51 -0500
Received: from 7.mo173.mail-out.ovh.net ([46.105.44.159]:34858 "EHLO
        7.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfBJVGu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 16:06:50 -0500
Received: from player791.ha.ovh.net (unknown [10.109.159.222])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 075A1F25D7
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 22:06:47 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player791.ha.ovh.net (Postfix) with ESMTPSA id 9675F2740169;
        Sun, 10 Feb 2019 21:06:46 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1549832804;
        bh=CW99T50hPVv9CVGaVAvbK2VOel927zOWt9D1wLfMHHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=MtXl0aLwVqOPWKMjZf+sGmgm2L3oKMe7EN5fgnz+89HVjQWGk2KcDCUH0dgBiFIWy
         2BZRIrX+xyDbQyQYdPe8mC5ouIyd57pzIWpfcmU7zBqASDdxWqjyQ1xxV2GH6pOf+q
         lTeNqemTc1YY6cjR8EKacdoFVfJNsNSQcxo9j3Ag=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v3 05/12] mac80211: Mark A-MPDU keyid borders for drivers
Date:   Sun, 10 Feb 2019 22:06:13 +0100
Message-Id: <20190210210620.31181-6-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190210210620.31181-1-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10549400653649812679
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrleeggddvlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

IEEE 802.11-2016 "9.7.3 A-MPDU contents" forbids aggregating MPDUs with
different keyids.
Extended Key ID support breaks the assumption that all unicast MPDUs for
one station can always be aggregated.

Inform the drivers about a keyid border by dropping the
@IEEE80211_TX_CTL_AMPDU flag for the last MPDU using the current keyid.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

This patch here is totally unnecessary when we decide that IEEE 802.11 -
2016 is not meaning what is referenced in the commit message above:-)
The exact wording in the standard is:
"All protected MPDUs within an A-MPDU have the same Key ID."

The intent of the wording was probably written without considering
Extended Key IDs. At least it makes no sense for me to forbid mixing
MPDUs using keyid 0 and 1 in one A-MPDU. Nevertheless it says what it
says and there may now be cards/drivers depending on that and e.g. only
check it for the first MPDU. The lost MPDUs would then be our fault, for
aggregating together what according to the standard must not. 

But even with that view we still don't need the patch:
A-MPDU aggregation is the job for the driver. We simply can offload the
problem to the drivers.

On the other side mac80211 is in what I consider a better position to
determine and mark the MPDU keyid border, saving the driver the effort
to parse the MPDUs again and keep track of the "current" keyid. It also
allows the driver to terminate a running A-MPDU frame when it gets the
last packet for the old key instead one frame later.

To get around what looked like a nightmare of synchronisation problems
this patch puts the Tx key switch into the Tx path. Handling idle
connections when we don't want to accept that the first packet of a
rekey may still use the key-before-current makes it more complex. 

The code is assuming that the driver is not aggregating MPDUs more than
5s apart. We probably don't have wait nearly so long but I'm not sure
what is the minimum time.

The patch also brought up a interesting problem: We are out of sta_info
flags and skb CB also has no room left to add new ones. I worked around
that by redefining how IEEE80211_TX_CTL_AMPDU has to be handled for
Extended Key ID A-MPDU sessions. If you think that puts too much stain
on the API I would need a pointer what would be considered an acceptable
solution to the problem.

But I also fully understand when you think this patch goes too far and
want it thrown out and want it handled somehow else:-).


 net/mac80211/key.c      | 10 +++++--
 net/mac80211/key.h      |  1 +
 net/mac80211/sta_info.c |  1 +
 net/mac80211/sta_info.h |  2 ++
 net/mac80211/tx.c       | 64 +++++++++++++++++++++++++++++++++++------
 5 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 7f673887ec50..dee18f61fe33 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -309,6 +309,10 @@ int ieee80211_key_activate_tx(struct ieee80211_key *key)
 
 	assert_key_lock(local);
 
+	/* Two key activations must not overlap */
+	if (WARN_ON(sta->ptk_idx_next != INVALID_PTK_KEYIDX))
+		return -EOPNOTSUPP;
+
 	key->flags &= ~KEY_FLAG_RX_ONLY;
 
 	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) ||
@@ -329,8 +333,9 @@ int ieee80211_key_activate_tx(struct ieee80211_key *key)
 	}
 
 	old = key_mtx_dereference(local, sta->ptk[sta->ptk_idx]);
-	sta->ptk_idx = key->conf.keyidx;
-	ieee80211_check_fast_xmit(sta);
+
+	sta->ptk_idx_next = key->conf.keyidx;
+	key->force_use_after = jiffies + 5 * HZ;
 
 	if (!ext_native && key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
 		key->flags |= KEY_FLAG_RX_SW_CRYPTO;
@@ -577,6 +582,7 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 	 */
 	key->conf.flags = 0;
 	key->flags = 0;
+	key->force_use_after = 0;
 
 	key->conf.cipher = cipher;
 	key->conf.keyidx = idx;
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index d74c8c36491a..48975d56e792 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -65,6 +65,7 @@ struct ieee80211_key {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
+	unsigned long force_use_after;
 
 	/* for sdata list */
 	struct list_head list;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a20e05439173..6fe40844f485 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -358,6 +358,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	 */
 	BUILD_BUG_ON(ARRAY_SIZE(sta->ptk) <= INVALID_PTK_KEYIDX);
 	sta->ptk_idx = INVALID_PTK_KEYIDX;
+	sta->ptk_idx_next = INVALID_PTK_KEYIDX;
 
 	sta->local = local;
 	sta->sdata = sdata;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 1fd1a349a875..6eff946bc55a 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -450,6 +450,7 @@ struct ieee80211_sta_rx_stats {
  * @sdata: virtual interface this station belongs to
  * @ptk: peer keys negotiated with this station, if any
  * @ptk_idx: peer key index to use for transmissions
+ * @ptk_idx_next: peer key index in activation (Extended Key ID only)
  * @ext_key_compat_wk: supports PTK key installs when using EXT_KEY_ID_COMPAT
  * @gtk: group keys negotiated with this station, if any
  * @rate_ctrl: rate control algorithm reference
@@ -533,6 +534,7 @@ struct sta_info {
 	struct ieee80211_key __rcu *ptk[NUM_DEFAULT_KEYS];
 	struct delayed_work ext_key_compat_wk;
 	u8 ptk_idx;
+	u8 ptk_idx_next;
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
 	spinlock_t rate_ctrl_lock;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 111bd6c490a6..d3825eca9e64 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -586,6 +586,51 @@ ieee80211_tx_h_check_control_port_protocol(struct ieee80211_tx_data *tx)
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
+		/* First packet using new key with A-MPDU active*/
+		sta->ptk_idx_next = INVALID_PTK_KEYIDX;
+		ieee80211_check_fast_xmit(tx->sta);
+		return key;
+	}
+
+	next_key = rcu_dereference(sta->ptk[sta->ptk_idx_next]);
+	if (!key || !(info->flags & IEEE80211_TX_CTL_AMPDU) ||
+	    (next_key->force_use_after &&
+	     time_is_before_jiffies(next_key->force_use_after))) {
+		/* nothing special to do, just start using the new key */
+		sta->ptk_idx = sta->ptk_idx_next;
+		sta->ptk_idx_next = INVALID_PTK_KEYIDX;
+		next_key->force_use_after = 0;
+		ieee80211_check_fast_xmit(tx->sta);
+		return next_key;
+	}
+
+	/* Last packet with old key with A-MPDU active */
+	sta->ptk_idx = sta->ptk_idx_next;
+	next_key->force_use_after = 0;
+	info->flags &= ~IEEE80211_TX_CTL_AMPDU;
+	return key;
+}
+
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 {
@@ -595,9 +640,8 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 
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
@@ -3414,6 +3458,10 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	if (skb->sk && skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS)
 		return false;
 
+	/* ieee80211_key_activate_tx() requests to change key */
+	if (unlikely(sta->ptk_idx_next != INVALID_PTK_KEYIDX))
+		return false;
+
 	if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 		tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
@@ -3556,6 +3604,11 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
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
@@ -3566,11 +3619,6 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
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
2.20.1

