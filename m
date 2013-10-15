Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55556 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933496Ab3JORcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 13:32:39 -0400
Received: by mail-pb0-f42.google.com with SMTP id un15so9132717pbc.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 10:32:39 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 7/7] ath10k: fix FW crashes on heavy TX on 10.1.389 AP FW
Date: Tue, 15 Oct 2013 10:29:56 -0700
Message-Id: <1381858196-17000-8-git-send-email-michal.kazior@tieto.com> (sfid-20131015_193243_900888_AE5A98E3)
In-Reply-To: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
References: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.1.389 firmware has some differences in
calculation of number of outstanding HTT TX
completions. This led to FW crashes of 10.1.389
while main firmware branch was unnaffected.

The patch makes sure ath10k doesn't queue up more
MSDUs than it should.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c     | 11 +++++++++++
 drivers/net/wireless/ath/ath10k/htt_tx.c | 11 ++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index e46951b..d243f28 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1050,6 +1050,17 @@ struct ath10k_ce_pipe *ath10k_ce_init(struct ath10k *ar,
 	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
 	int ret;
 
+	/*
+	 * Make sure there's enough CE ringbuffer entries for HTT TX to avoid
+	 * additional TX locking checks.
+	 *
+	 * For the lack of a better place do the check here.
+	 */
+	BUILD_BUG_ON(TARGET_NUM_MSDU_DESC >
+		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
+	BUILD_BUG_ON(TARGET_10X_NUM_MSDU_DESC >
+		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
+
 	ret = ath10k_pci_wake(ar);
 	if (ret)
 		return NULL;
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index d9335e9..f1d36d2 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -85,16 +85,13 @@ void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id)
 
 int ath10k_htt_tx_attach(struct ath10k_htt *htt)
 {
-	u8 pipe;
-
 	spin_lock_init(&htt->tx_lock);
 	init_waitqueue_head(&htt->empty_tx_wq);
 
-	/* At the beginning free queue number should hint us the maximum
-	 * queue length */
-	pipe = htt->ar->htc.endpoint[htt->eid].ul_pipe_id;
-	htt->max_num_pending_tx = ath10k_hif_get_free_queue_number(htt->ar,
-								   pipe);
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, htt->ar->fw_features))
+		htt->max_num_pending_tx = TARGET_10X_NUM_MSDU_DESC;
+	else
+		htt->max_num_pending_tx = TARGET_NUM_MSDU_DESC;
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "htt tx max num pending tx %d\n",
 		   htt->max_num_pending_tx);
-- 
1.8.4.rc3

