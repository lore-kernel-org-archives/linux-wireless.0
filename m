Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDA2C43444
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 01:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC83021852
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 01:02:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E4JOGz8+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cP150XmB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727596AbeLSBC3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 20:02:29 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39608 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbeLSBC3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 20:02:29 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5613260C55; Wed, 19 Dec 2018 01:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545181348;
        bh=riScRqMdpJiEAfoastrZwGWD6DyZ9Ea/1TrAZLUbEhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4JOGz8+2AZ57CUkxcrck/VEmwdaOanEigVc8aN9f2p8B4QdzMYlS8DbV85egbFOo
         BdmGHWInwVEviD0QlpHVV+tf8HpYNKXJZCzy6H9RbijuTSw7wJDY1DMu6cS8Ju+WlV
         6Ue0r78Ih6xJyo6bKQ2ZBH7g53+xo9jtdLpsrDKY=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BA9EC60B79;
        Wed, 19 Dec 2018 01:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545181347;
        bh=riScRqMdpJiEAfoastrZwGWD6DyZ9Ea/1TrAZLUbEhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cP150XmB++lMZADqkb++P2yRgv+n/s9y8g2Va2RYWTozQknELdazP9DtaAW9qQLMu
         ilG0K2F//y3t6LXBf2YrA7L6WDRuA9fo0tSjyY1Hln3nbS/8H2+ca6vjGwFEa0DKE+
         Z4MfYHGXy0Rhjk0sQYbl6HNLSOzkwAiPa03L4lCk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BA9EC60B79
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Tue, 18 Dec 2018 17:02:25 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH v5 5/6] ath10k: migrate to mac80211 txq scheduling
Date:   Tue, 18 Dec 2018 17:02:10 -0800
Message-Id: <1545181331-5288-6-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1545181331-5288-1-git-send-email-rmanohar@codeaurora.org>
References: <1545181331-5288-1-git-send-email-rmanohar@codeaurora.org>
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

Tested-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
Co-developed-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c   |  2 -
 drivers/net/wireless/ath/ath10k/core.h   |  6 +-
 drivers/net/wireless/ath/ath10k/htc.h    |  1 -
 drivers/net/wireless/ath/ath10k/htt_rx.c |  8 +++
 drivers/net/wireless/ath/ath10k/mac.c    | 98 ++++++++++++++------------------
 5 files changed, 54 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index da607febfd82..c8dbbfa901af 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -3065,9 +3065,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 
 	mutex_init(&ar->conf_mutex);
 	spin_lock_init(&ar->data_lock);
-	spin_lock_init(&ar->txqs_lock);
 
-	INIT_LIST_HEAD(&ar->txqs);
 	INIT_LIST_HEAD(&ar->peers);
 	init_waitqueue_head(&ar->peer_mapping_wq);
 	init_waitqueue_head(&ar->htt.empty_tx_wq);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 042418097cf9..45afa813555c 100644
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
@@ -1062,10 +1065,7 @@ struct ath10k {
 
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
@@ -51,7 +51,6 @@
  */
 
 #define HTC_HOST_MAX_MSG_PER_RX_BUNDLE        8
-#define HTC_HOST_MAX_MSG_PER_TX_BUNDLE        16
 
 enum ath10k_htc_tx_flags {
 	ATH10K_HTC_FLAG_NEED_CREDIT_UPDATE = 0x01,
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index ffec98f7be50..35738fc84271 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2379,6 +2379,7 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10k *ar, struct sk_buff *skb)
 	u8 tid;
 	int ret;
 	int i;
+	bool may_tx;
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt rx tx fetch ind\n");
 
@@ -2451,8 +2452,13 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10k *ar, struct sk_buff *skb)
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
@@ -2460,6 +2466,8 @@ static void ath10k_htt_rx_tx_fetch_ind(struct ath10k *ar, struct sk_buff *skb)
 			num_msdus++;
 			num_bytes += ret;
 		}
+		ieee80211_return_txq(hw, txq);
+		ieee80211_txq_schedule_end(hw, txq->ac);
 
 		record->num_msdus = cpu_to_le16(num_msdus);
 		record->num_bytes = cpu_to_le32(num_bytes);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7e49342bae38..f8a2a4b15982 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3889,7 +3889,6 @@ static void ath10k_mac_txq_init(struct ieee80211_txq *txq)
 
 static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
 {
-	struct ath10k_txq *artxq;
 	struct ath10k_skb_cb *cb;
 	struct sk_buff *msdu;
 	int msdu_id;
@@ -3897,12 +3896,6 @@ static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
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
@@ -3942,7 +3935,6 @@ static bool ath10k_mac_tx_can_push(struct ieee80211_hw *hw,
 	struct ath10k_txq *artxq = (void *)txq->drv_priv;
 
 	/* No need to get locks */
-
 	if (ar->htt.tx_q_state.mode == HTT_TX_MODE_SWITCH_PUSH)
 		return true;
 
@@ -4029,48 +4021,45 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
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
 
@@ -4309,31 +4298,28 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
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
@@ -8687,6 +8673,8 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 
+	ar->hw->weight_multiplier = ATH10K_AIRTIME_WEIGHT_MULTIPLIER;
+
 	ret = ieee80211_register_hw(ar->hw);
 	if (ret) {
 		ath10k_err(ar, "failed to register ieee80211: %d\n", ret);
-- 
1.9.1

