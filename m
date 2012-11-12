Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:59243 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2KLSrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 13:47:47 -0500
Received: by mail-da0-f46.google.com with SMTP id n41so2853879dak.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 10:47:46 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: ath9k-devel@lists.ath9k.org
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/2] ath9k: RX timestamp is reported at end of frame
Date: Mon, 12 Nov 2012 10:47:31 -0800
Message-Id: <1352746052-1828-2-git-send-email-thomas@cozybit.com> (sfid-20121112_194803_682287_B3FC3427)
In-Reply-To: <1352746052-1828-1-git-send-email-thomas@cozybit.com>
References: <1352746052-1828-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested with AR9280.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a04028b..d4df98a 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -976,7 +976,7 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->signal = ah->noise + rx_stats->rs_rssi;
 	rx_status->antenna = rx_stats->rs_antenna;
-	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
+	rx_status->flag |= RX_FLAG_MACTIME_END;
 	if (rx_stats->rs_moreaggr)
 		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
-- 
1.7.10.4

