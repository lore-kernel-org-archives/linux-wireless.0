Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:39803 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbdLaRbo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Dec 2017 12:31:44 -0500
Received: by mail-lf0-f67.google.com with SMTP id m20so39145406lfi.6
        for <linux-wireless@vger.kernel.org>; Sun, 31 Dec 2017 09:31:44 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 11/18] ath10k: add HTT RX HL ops
Date: Sun, 31 Dec 2017 18:29:18 +0100
Message-Id: <20171231172925.24014-12-erik.stromdahl@gmail.com> (sfid-20171231_183210_558346_FE987D34)
In-Reply-To: <20171231172925.24014-1-erik.stromdahl@gmail.com>
References: <20171231172925.24014-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initial (empty) HTT RX ops for high latency devices.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 1432d5b3e9d3..f7d071ca8b76 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2917,11 +2917,16 @@ static const struct ath10k_htt_rx_ops htt_rx_ops_64 = {
 	.htt_reset_paddrs_ring = ath10k_htt_reset_paddrs_ring_64,
 };
 
+static const struct ath10k_htt_rx_ops htt_rx_ops_hl = {
+};
+
 void ath10k_htt_set_rx_ops(struct ath10k_htt *htt)
 {
 	struct ath10k *ar = htt->ar;
 
-	if (ar->hw_params.target_64bit)
+	if (ar->is_high_latency)
+		htt->rx_ops = &htt_rx_ops_hl;
+	else if (ar->hw_params.target_64bit)
 		htt->rx_ops = &htt_rx_ops_64;
 	else
 		htt->rx_ops = &htt_rx_ops_32;
-- 
2.15.1
