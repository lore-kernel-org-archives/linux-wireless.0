Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:39325 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751254AbeFCSWR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Jun 2018 14:22:17 -0400
Received: by mail-lf0-f68.google.com with SMTP id t134-v6so21772592lff.6
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jun 2018 11:22:16 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v5 08/12] ath10k: add HTT RX HL ops
Date: Sun,  3 Jun 2018 20:20:25 +0200
Message-Id: <20180603182029.8914-9-erik.stromdahl@gmail.com> (sfid-20180603_202226_896952_D5FB7718)
In-Reply-To: <20180603182029.8914-1-erik.stromdahl@gmail.com>
References: <20180603182029.8914-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initial (empty) HTT RX ops for high latency devices.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index bd23f6940488..ae90ddfdb466 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2983,11 +2983,16 @@ static const struct ath10k_htt_rx_ops htt_rx_ops_64 = {
 	.htt_reset_paddrs_ring = ath10k_htt_reset_paddrs_ring_64,
 };
 
+static const struct ath10k_htt_rx_ops htt_rx_ops_hl = {
+};
+
 void ath10k_htt_set_rx_ops(struct ath10k_htt *htt)
 {
 	struct ath10k *ar = htt->ar;
 
-	if (ar->hw_params.target_64bit)
+	if (ar->dev_type == ATH10K_DEV_TYPE_HL)
+		htt->rx_ops = &htt_rx_ops_hl;
+	else if (ar->hw_params.target_64bit)
 		htt->rx_ops = &htt_rx_ops_64;
 	else
 		htt->rx_ops = &htt_rx_ops_32;
-- 
2.17.0
