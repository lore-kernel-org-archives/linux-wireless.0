Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:37765 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbdLaRbo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Dec 2017 12:31:44 -0500
Received: by mail-lf0-f67.google.com with SMTP id f3so16110733lfe.4
        for <linux-wireless@vger.kernel.org>; Sun, 31 Dec 2017 09:31:43 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 10/18] ath10k: add HTT TX HL ops
Date: Sun, 31 Dec 2017 18:29:17 +0100
Message-Id: <20171231172925.24014-11-erik.stromdahl@gmail.com> (sfid-20171231_183208_312662_B6D5BBE0)
In-Reply-To: <20171231172925.24014-1-erik.stromdahl@gmail.com>
References: <20171231172925.24014-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initial HTT TX ops for high latency devices.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 4d0bfb47d162..321f131e417d 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -1565,11 +1565,17 @@ static const struct ath10k_htt_tx_ops htt_tx_ops_64 = {
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
+	if (ar->is_high_latency)
+		htt->tx_ops = &htt_tx_ops_hl;
+	else if (ar->hw_params.target_64bit)
 		htt->tx_ops = &htt_tx_ops_64;
 	else
 		htt->tx_ops = &htt_tx_ops_32;
-- 
2.15.1
