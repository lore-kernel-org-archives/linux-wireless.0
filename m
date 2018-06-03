Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:37986 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbeFCSWQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Jun 2018 14:22:16 -0400
Received: by mail-lf0-f68.google.com with SMTP id i83-v6so9617582lfh.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2018 11:22:15 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v5 07/12] ath10k: add HTT TX HL ops
Date: Sun,  3 Jun 2018 20:20:24 +0200
Message-Id: <20180603182029.8914-8-erik.stromdahl@gmail.com> (sfid-20180603_202238_857765_6B2B24AF)
In-Reply-To: <20180603182029.8914-1-erik.stromdahl@gmail.com>
References: <20180603182029.8914-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initial HTT TX ops for high latency devices.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 79a8eca46e88..7c7e434fcde5 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -1568,11 +1568,17 @@ static const struct ath10k_htt_tx_ops htt_tx_ops_64 = {
 	.htt_free_txbuff = ath10k_htt_tx_free_cont_txbuf_64,
 };
 
+static const struct ath10k_htt_tx_ops htt_tx_ops_hl = {
+	.htt_send_frag_desc_bank_cfg = ath10k_htt_send_frag_desc_bank_cfg_32,
+};
+
 void ath10k_htt_set_tx_ops(struct ath10k_htt *htt)
 {
 	struct ath10k *ar = htt->ar;
 
-	if (ar->hw_params.target_64bit)
+	if (ar->dev_type == ATH10K_DEV_TYPE_HL)
+		htt->tx_ops = &htt_tx_ops_hl;
+	else if (ar->hw_params.target_64bit)
 		htt->tx_ops = &htt_tx_ops_64;
 	else
 		htt->tx_ops = &htt_tx_ops_32;
-- 
2.17.0
