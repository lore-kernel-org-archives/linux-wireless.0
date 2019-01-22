Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB4EC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 14:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77D5A20870
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 14:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbfAVOVr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 09:21:47 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34598 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728700AbfAVOVr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 09:21:47 -0500
Received: by mail-ed1-f65.google.com with SMTP id b3so19533610ede.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2019 06:21:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9R3PaquB9Qt50JGBV1TVFQDcbyAxdTHfOAtR5/CPZH4=;
        b=JCb3XVxzXTjfFQ59WOjQ/2BMlRoBi/mRM1iofdfYfz72Oc114AlruP7iLDtm+ILc/0
         4PGFD/f9J8ArNI4GHeWLbpEQFjrctwLM5mskT7cQO48BVITKTZ0KocQaM44bluSx1z0M
         mNwQKHIFVtZcM4bx95ZlIhIEqnuVKIVDETmEb93NtDow+1fOZTBtMrWfLJOwZ7yjp4jk
         aR5ob0v6MLLv22MQf7V8TX2zP9VaL2S7x1C0awx27CPN2/H5UeWd2wgfSPOxCkfo7P/y
         dhysvhKDv9KXIHK3DHND4FOsvoX96led/XmtfeJzKMr1qQea5h8yui5C4IgO49XVKvO2
         JFSw==
X-Gm-Message-State: AJcUukcvdHRmSScWqPnz9wZ5ECvnn5ZgHEazSGr/exi2hBLecND+vMrN
        uAF7Gki67ZZ0yOOUqi9m0n59VQ==
X-Google-Smtp-Source: ALg8bN63j8+eMW1Hi2vZd98GLsLO+w5knX5CFVsTQda1v336dxt00QOxae0A8u9H4eAoSgnFEbbduw==
X-Received: by 2002:a50:a246:: with SMTP id 64mr31490100edl.43.1548166904994;
        Tue, 22 Jan 2019 06:21:44 -0800 (PST)
Received: from tohojo-x1-rh.localdomain (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id f35sm10069885edd.80.2019.01.22.06.21.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jan 2019 06:21:44 -0800 (PST)
Received: by tohojo-x1-rh.localdomain (Postfix, from userid 1000)
        id 694861833DF; Tue, 22 Jan 2019 15:21:43 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        ath10k@lists.infradead.org, make-wifi-fast@lists.bufferbloat.net,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Subject: [PATCH v6 3/4] ath10k: migrate to mac80211 txq scheduling
Date:   Tue, 22 Jan 2019 15:20:18 +0100
Message-Id: <20190122142019.21417-4-toke@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190122142019.21417-1-toke@redhat.com>
References: <20190122142019.21417-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@toke.dk>

ath10k maintains common txqs list for all stations. This txq
management can be removed by migrating to mac80211 txq APIs
and let mac80211 handle txqs reordering based on reported airtime.
By doing this, txq fairness maintained in ath10k i.e processing
N frames per txq is removed. By adapting to mac80211 APIs,
ath10k will support mac80211 based airtime fairness algorithm.

Tested on QCA4019 with firmware version 10.4-3.2.1.1-00015
Tested on QCA9984 with firmware version 10.4-3.9.0.1-00005

Tested-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Co-developed-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath10k/core.c   |  2 -
 drivers/net/wireless/ath/ath10k/core.h   |  6 +-
 drivers/net/wireless/ath/ath10k/htc.h    |  1 -
 drivers/net/wireless/ath/ath10k/htt_rx.c |  8 ++
 drivers/net/wireless/ath/ath10k/mac.c    | 98 +++++++++++-------------
 5 files changed, 54 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 399b501f3c3c..c7327900316e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -3098,9 +3098,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 
 	mutex_init(&ar->conf_mutex);
 	spin_lock_init(&ar->data_lock);
-	spin_lock_init(&ar->txqs_lock);
 
-	INIT_LIST_HEAD(&ar->txqs);
 	INIT_LIST_HEAD(&ar->peers);
 	init_waitqueue_head(&ar->peer_mapping_wq);
 	init_waitqueue_head(&ar->htt.empty_tx_wq);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 46e9c8c97a4d..28cecf7375f8 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -90,6 +90,9 @@
 /* The magic used by QCA spec */
 #define ATH10K_SMBIOS_BDF_EXT_MAGIC "BDF_"
 
+/* Default Airtime weight multipler (Tuned for multiclient performance) */
+#define ATH10K_AIRTIME_WEIGHT_MULTIPLIER  4
+
 struct ath10k;
 
 static inline const char *ath10k_bus_str(enum ath10k_bus bus)
@@ -1068,10 +1071,7 @@ struct ath10k {
 
 	/* protects shared structure data */
 	spinlock_t data_lock;
-	/* protects: ar->txqs, artxq->list */
-	spinlock_t txqs_lock;
 
-	struct list_head txqs;
 	struct list_head arvifs;
 	struct list_head peers;
 	struct ath10k_peer *peer_map[ATH10K_MAX_NUM_PEER_IDS];
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index 51fda6c23f69..cb30add7dd33 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -51,7 +51,6 @@ struct ath10k;
  */
 
 #define HTC_HOST_MAX_MSG_PER_RX_BUNDLE        8
-#define HTC_HOST_MAX_MSG_PER_TX_BUNDLE        16
 
 enum ath10k_htc_tx_flags {
 	ATH10K_HTC_FLAG_NEED_CREDIT_UPDATE = 0x01,
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f42bac204ef8..dc9895f2eb9d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2596,6 +2596,7 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10k *ar, struct sk_buff *skb)
 	u8 tid;
 	int ret;
 	int i;
+	bool may_tx;
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx tx fetch ind\n");
 
@@ -2668,8 +2669,13 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10k *ar, struct sk_buff *skb)
 		num_msdus = 0;
 		num_bytes = 0;
 
+		ieee80211_txq_schedule_start(hw, txq->ac);
+		may_tx = ieee80211_txq_may_transmit(hw, txq);
 		while (num_msdus < max_num_msdus &&
 		       num_bytes < max_num_bytes) {
+			if (!may_tx)
+				break;
+
 			ret = ath10k_mac_tx_push_txq(hw, txq);
 			if (ret < 0)
 				break;
@@ -2677,6 +2683,8 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10k *ar, struct sk_buff *skb)
 			num_msdus++;
 			num_bytes += ret;
 		}
+		ieee80211_return_txq(hw, txq);
+		ieee80211_txq_schedule_end(hw, txq->ac);
 
 		record->num_msdus = cpu_to_le16(num_msdus);
 		record->num_bytes = cpu_to_le32(num_bytes);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 49758490eaba..cf7fdf72e990 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3890,7 +3890,6 @@ static void ath10k_mac_txq_init(struct ieee80211_txq *txq)
 
 static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
 {
-	struct ath10k_txq *artxq;
 	struct ath10k_skb_cb *cb;
 	struct sk_buff *msdu;
 	int msdu_id;
@@ -3898,12 +3897,6 @@ static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
 	if (!txq)
 		return;
 
-	artxq = (void *)txq->drv_priv;
-	spin_lock_bh(&ar->txqs_lock);
-	if (!list_empty(&artxq->list))
-		list_del_init(&artxq->list);
-	spin_unlock_bh(&ar->txqs_lock);
-
 	spin_lock_bh(&ar->htt.tx_lock);
 	idr_for_each_entry(&ar->htt.pending_tx, msdu, msdu_id) {
 		cb = ATH10K_SKB_CB(msdu);
@@ -3943,7 +3936,6 @@ static bool ath10k_mac_tx_can_push(struct ieee80211_hw *hw,
 	struct ath10k_txq *artxq = (void *)txq->drv_priv;
 
 	/* No need to get locks */
-
 	if (ar->htt.tx_q_state.mode == HTT_TX_MODE_SWITCH_PUSH)
 		return true;
 
@@ -4030,48 +4022,45 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 	return skb_len;
 }
 
-void ath10k_mac_tx_push_pending(struct ath10k *ar)
+static int ath10k_mac_schedule_txq(struct ieee80211_hw *hw, u32 ac)
 {
-	struct ieee80211_hw *hw = ar->hw;
 	struct ieee80211_txq *txq;
-	struct ath10k_txq *artxq;
-	struct ath10k_txq *last;
-	int ret;
-	int max;
-
-	if (ar->htt.num_pending_tx >= (ar->htt.max_num_pending_tx / 2))
-		return;
-
-	spin_lock_bh(&ar->txqs_lock);
-	rcu_read_lock();
-
-	last = list_last_entry(&ar->txqs, struct ath10k_txq, list);
-	while (!list_empty(&ar->txqs)) {
-		artxq = list_first_entry(&ar->txqs, struct ath10k_txq, list);
-		txq = container_of((void *)artxq, struct ieee80211_txq,
-				   drv_priv);
+	int ret = 0;
 
-		/* Prevent aggressive sta/tid taking over tx queue */
-		max = HTC_HOST_MAX_MSG_PER_TX_BUNDLE;
-		ret = 0;
-		while (ath10k_mac_tx_can_push(hw, txq) && max--) {
+	ieee80211_txq_schedule_start(hw, ac);
+	while ((txq = ieee80211_next_txq(hw, ac))) {
+		while (ath10k_mac_tx_can_push(hw, txq)) {
 			ret = ath10k_mac_tx_push_txq(hw, txq);
 			if (ret < 0)
 				break;
 		}
+		ieee80211_return_txq(hw, txq);
+		ath10k_htt_tx_txq_update(hw, txq);
+		if (ret == -EBUSY)
+			break;
+	}
+	ieee80211_txq_schedule_end(hw, ac);
+
+	return ret;
+}
 
-		list_del_init(&artxq->list);
-		if (ret != -ENOENT)
-			list_add_tail(&artxq->list, &ar->txqs);
+void ath10k_mac_tx_push_pending(struct ath10k *ar)
+{
+	struct ieee80211_hw *hw = ar->hw;
+	u32 ac;
 
-		ath10k_htt_tx_txq_update(hw, txq);
+	if (ar->htt.tx_q_state.mode != HTT_TX_MODE_SWITCH_PUSH)
+		return;
 
-		if (artxq == last || (ret < 0 && ret != -ENOENT))
+	if (ar->htt.num_pending_tx >= (ar->htt.max_num_pending_tx / 2))
+		return;
+
+	rcu_read_lock();
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		if (ath10k_mac_schedule_txq(hw, ac) == -EBUSY)
 			break;
 	}
-
 	rcu_read_unlock();
-	spin_unlock_bh(&ar->txqs_lock);
 }
 EXPORT_SYMBOL(ath10k_mac_tx_push_pending);
 
@@ -4310,31 +4299,28 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 					struct ieee80211_txq *txq)
 {
 	struct ath10k *ar = hw->priv;
-	struct ath10k_txq *artxq = (void *)txq->drv_priv;
-	struct ieee80211_txq *f_txq;
-	struct ath10k_txq *f_artxq;
-	int ret = 0;
-	int max = HTC_HOST_MAX_MSG_PER_TX_BUNDLE;
+	int ret;
+	u8 ac;
 
-	spin_lock_bh(&ar->txqs_lock);
-	if (list_empty(&artxq->list))
-		list_add_tail(&artxq->list, &ar->txqs);
+	ath10k_htt_tx_txq_update(hw, txq);
+	if (ar->htt.tx_q_state.mode != HTT_TX_MODE_SWITCH_PUSH)
+		return;
 
-	f_artxq = list_first_entry(&ar->txqs, struct ath10k_txq, list);
-	f_txq = container_of((void *)f_artxq, struct ieee80211_txq, drv_priv);
-	list_del_init(&f_artxq->list);
+	ac = txq->ac;
+	ieee80211_txq_schedule_start(hw, ac);
+	txq = ieee80211_next_txq(hw, ac);
+	if (!txq)
+		goto out;
 
-	while (ath10k_mac_tx_can_push(hw, f_txq) && max--) {
-		ret = ath10k_mac_tx_push_txq(hw, f_txq);
+	while (ath10k_mac_tx_can_push(hw, txq)) {
+		ret = ath10k_mac_tx_push_txq(hw, txq);
 		if (ret < 0)
 			break;
 	}
-	if (ret != -ENOENT)
-		list_add_tail(&f_artxq->list, &ar->txqs);
-	spin_unlock_bh(&ar->txqs_lock);
-
-	ath10k_htt_tx_txq_update(hw, f_txq);
+	ieee80211_return_txq(hw, txq);
 	ath10k_htt_tx_txq_update(hw, txq);
+out:
+	ieee80211_txq_schedule_end(hw, ac);
 }
 
 /* Must not be called with conf_mutex held as workers can use that also. */
@@ -8726,6 +8712,8 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 
+	ar->hw->weight_multiplier = ATH10K_AIRTIME_WEIGHT_MULTIPLIER;
+
 	ret = ieee80211_register_hw(ar->hw);
 	if (ret) {
 		ath10k_err(ar, "failed to register ieee80211: %d\n", ret);
-- 
2.20.1

