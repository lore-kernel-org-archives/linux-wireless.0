Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52351 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1HNLiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 07:38:25 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] ath6kl: Release ar->lock right afer updating net_stats in ath6kl_rx()
Date: Sun, 14 Aug 2011 17:08:33 +0530
Message-ID: <1313321916-29685-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110814_133834_791573_8CBC3068)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This lock is intended to protect stats there, not neccessary to
hold it beyond that.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
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
1.7.0.4

