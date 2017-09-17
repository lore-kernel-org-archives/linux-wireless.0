Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:37178 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdIQTkf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Sep 2017 15:40:35 -0400
Received: by mail-lf0-f68.google.com with SMTP id q132so3528966lfe.4
        for <linux-wireless@vger.kernel.org>; Sun, 17 Sep 2017 12:40:34 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v3 11/11] ath10k: remove htt pending TX count for high latency
Date: Sun, 17 Sep 2017 21:40:13 +0200
Message-Id: <20170917194013.8658-12-erik.stromdahl@gmail.com> (sfid-20170917_214038_527776_717AA1A3)
In-Reply-To: <20170917194013.8658-1-erik.stromdahl@gmail.com>
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

High latency chipsest does not seem to send any
HTT_T2H_MSG_TYPE_TX_COMPL_IND for outgoing frames.

This means that htt->num_pending_tx will never be
decremented and we will eventually hit the maximum
limit. All outgoing packets will then be discarded.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 82d01139ff92..c74fc137ac67 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -153,6 +153,9 @@ void ath10k_htt_tx_txq_update(struct ieee80211_hw *hw,
 
 void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
 {
+	if (htt->ar->is_high_latency)
+		return;
+
 	lockdep_assert_held(&htt->tx_lock);
 
 	htt->num_pending_tx--;
@@ -162,6 +165,9 @@ void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
 
 int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt)
 {
+	if (htt->ar->is_high_latency)
+		return 0;
+
 	lockdep_assert_held(&htt->tx_lock);
 
 	if (htt->num_pending_tx >= htt->max_num_pending_tx)
-- 
2.14.1
