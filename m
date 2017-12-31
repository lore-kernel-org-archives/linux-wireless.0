Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:40387 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751063AbdLaRbt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Dec 2017 12:31:49 -0500
Received: by mail-lf0-f65.google.com with SMTP id u84so32315054lff.7
        for <linux-wireless@vger.kernel.org>; Sun, 31 Dec 2017 09:31:48 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 16/18] ath10k: remove htt pending TX count for high latency
Date: Sun, 31 Dec 2017 18:29:23 +0100
Message-Id: <20171231172925.24014-17-erik.stromdahl@gmail.com> (sfid-20171231_183159_487179_0D4810A9)
In-Reply-To: <20171231172925.24014-1-erik.stromdahl@gmail.com>
References: <20171231172925.24014-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

High latency chipsets does not seem to send any
HTT_T2H_MSG_TYPE_TX_COMPL_IND for outgoing frames.

This means that htt->num_pending_tx will never be
decremented and we will eventually hit the maximum
limit. All outgoing packets will then be discarded.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 7ea27454ef3f..0c14fb3b7181 100644
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
2.15.1
