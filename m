Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30435 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab1HWIRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 04:17:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 1/7] ath6kl: Release ar->lock right afer updating net_stats in ath6kl_rx()
Date: Tue, 23 Aug 2011 11:16:40 +0300
Message-ID: <1314087406-29188-2-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110823_101713_215337_DA18FE45)
In-Reply-To: <1314087406-29188-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1314087406-29188-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

This lock is intended to protect stats there, not neccessary to
hold it beyond that.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 167bdb9..d546051 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1044,13 +1044,13 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	ar->net_stats.rx_packets++;
 	ar->net_stats.rx_bytes += packet->act_len;
 
+	spin_unlock_bh(&ar->lock);
+
 	skb_put(skb, packet->act_len + HTC_HDR_LENGTH);
 	skb_pull(skb, HTC_HDR_LENGTH);
 
 	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, __func__, skb->data, skb->len);
 
-	spin_unlock_bh(&ar->lock);
-
 	skb->dev = ar->net_dev;
 
 	if (!test_bit(WMI_ENABLED, &ar->flag)) {
-- 
1.7.1

