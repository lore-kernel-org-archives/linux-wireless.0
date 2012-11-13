Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:36187 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab2KMSsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 13:48:25 -0500
Received: by mail-da0-f46.google.com with SMTP id n41so3320457dak.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 10:48:25 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: ath9k-devel@lists.ath9k.org
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 1/2] ath9k: RX timestamp is reported at end of frame
Date: Tue, 13 Nov 2012 10:48:07 -0800
Message-Id: <1352832488-21516-1-git-send-email-thomas@cozybit.com> (sfid-20121113_194834_470128_522632A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Accurate RX timestamp reporting is important for proper IBSS merging,
mesh synchronization, and MCCA scheduling. Namely, knowing where the TSF
is recorded is needed to sync with the beacon timestamp field.

Tested with AR9280.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

---
v2:
	clarify commit log (Luis)

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

