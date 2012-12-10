Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52704 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2LJWsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 17:48:23 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so2372855pad.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 14:48:23 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/3] ath9k: RX timestamp is reported at end of frame
Date: Mon, 10 Dec 2012 14:48:01 -0800
Message-Id: <1355179683-24846-1-git-send-email-thomas@cozybit.com> (sfid-20121210_234827_651314_B60CBB17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Accurate RX timestamp reporting is important for proper IBSS merging,
mesh synchronization, and MCCA scheduling. Namely, knowing where the TSF
is recorded is needed to sync with the beacon timestamp field.

Tested with AR9280.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6aafbb7..d4df98a 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -976,7 +976,7 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 	rx_status->freq = hw->conf.channel->center_freq;
 	rx_status->signal = ah->noise + rx_stats->rs_rssi;
 	rx_status->antenna = rx_stats->rs_antenna;
-	rx_status->flag |= RX_FLAG_MACTIME_START;
+	rx_status->flag |= RX_FLAG_MACTIME_END;
 	if (rx_stats->rs_moreaggr)
 		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
-- 
1.7.10.4

