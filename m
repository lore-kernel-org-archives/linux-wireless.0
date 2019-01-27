Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF82FC282C9
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88BA52146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfA0KTX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:19:23 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51280 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726516AbfA0KTX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:19:23 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhX7-0001vC-IC; Sun, 27 Jan 2019 12:19:22 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:18:49 +0200
Message-Id: <20190127101908.6428-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/21] iwlwifi: mvm: get rid of tx_path_lock
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

TX path lock was introduced in order to prevent out of order
invocations of TX.

This can happen in the following flow:

TX path invoked from net dev
Packet dequeued
	TX path invoked from RX path
	Packet dequeued
	Packet TXed
Packet TXed

However, we don't really need a lock. If TX path is already
invoked from some location, other paths can simply abort their
execution, instead of waiting to the first path to finish, and
then discover queue is (likely) empty or stopped.

Replace the lock with an atomic variable to track TX ownership.
This simplifies the locking dependencies between RX and TX paths,
and should improve performance.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 48 +++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c  |  4 +-
 3 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index e3da6992f244..dd0761e5cf6a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -878,25 +878,45 @@ void iwl_mvm_mac_itxq_xmit(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 	struct iwl_mvm_txq *mvmtxq = iwl_mvm_txq_from_mac80211(txq);
 	struct sk_buff *skb = NULL;
 
-	spin_lock(&mvmtxq->tx_path_lock);
+	/*
+	 * No need for threads to be pending here, they can leave the first
+	 * taker all the work.
+	 *
+	 * mvmtxq->tx_request logic:
+	 *
+	 * If 0, no one is currently TXing, set to 1 to indicate current thread
+	 * will now start TX and other threads should quit.
+	 *
+	 * If 1, another thread is currently TXing, set to 2 to indicate to
+	 * that thread that there was another request. Since that request may
+	 * have raced with the check whether the queue is empty, the TXing
+	 * thread should check the queue's status one more time before leaving.
+	 * This check is done in order to not leave any TX hanging in the queue
+	 * until the next TX invocation (which may not even happen).
+	 *
+	 * If 2, another thread is currently TXing, and it will already double
+	 * check the queue, so do nothing.
+	 */
+	if (atomic_fetch_add_unless(&mvmtxq->tx_request, 1, 2))
+		return;
 
 	rcu_read_lock();
-	while (likely(!mvmtxq->stopped &&
-		      (mvm->trans->system_pm_mode ==
-		       IWL_PLAT_PM_MODE_DISABLED))) {
-		skb = ieee80211_tx_dequeue(hw, txq);
+	do {
+		while (likely(!mvmtxq->stopped &&
+			      (mvm->trans->system_pm_mode ==
+			       IWL_PLAT_PM_MODE_DISABLED))) {
+			skb = ieee80211_tx_dequeue(hw, txq);
 
-		if (!skb)
-			break;
+			if (!skb)
+				break;
 
-		if (!txq->sta)
-			iwl_mvm_tx_skb_non_sta(mvm, skb);
-		else
-			iwl_mvm_tx_skb(mvm, skb, txq->sta);
-	}
+			if (!txq->sta)
+				iwl_mvm_tx_skb_non_sta(mvm, skb);
+			else
+				iwl_mvm_tx_skb(mvm, skb, txq->sta);
+		}
+	} while (atomic_dec_return(&mvmtxq->tx_request));
 	rcu_read_unlock();
-
-	spin_unlock(&mvmtxq->tx_path_lock);
 }
 
 static void iwl_mvm_mac_wake_tx_queue(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index d326843636cb..a289b9488c03 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -781,8 +781,7 @@ struct iwl_mvm_geo_profile {
 struct iwl_mvm_txq {
 	struct list_head list;
 	u16 txq_id;
-	/* Protects TX path invocation from two places */
-	spinlock_t tx_path_lock;
+	atomic_t tx_request;
 	bool stopped;
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 5f42897dcd55..c5a01470a3bc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1403,9 +1403,7 @@ void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 
 		iwl_mvm_sta_alloc_queue(mvm, txq->sta, txq->ac, tid);
 		list_del_init(&mvmtxq->list);
-		local_bh_disable();
 		iwl_mvm_mac_itxq_xmit(mvm->hw, txq);
-		local_bh_enable();
 	}
 
 	mutex_unlock(&mvm->mutex);
@@ -1646,7 +1644,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 
 		mvmtxq->txq_id = IWL_MVM_INVALID_QUEUE;
 		INIT_LIST_HEAD(&mvmtxq->list);
-		spin_lock_init(&mvmtxq->tx_path_lock);
+		atomic_set(&mvmtxq->tx_request, 0);
 	}
 
 	mvm_sta->agg_tids = 0;
-- 
2.20.1

