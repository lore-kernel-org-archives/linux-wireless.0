Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12393 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932567AbdAJPwu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jan 2017 10:52:50 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix Tx legacy rate reporting
Date: Tue, 10 Jan 2017 21:23:23 +0530
Message-ID: <1484063603-13652-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20170110_165253_651536_2708CEE3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Tx legacy rate is reported 10 fold, as below

iw dev wlan#N station dump | grep "tx bitrate"
        tx bitrate:     240.0 MBit/s

This is because by mistake we muliply by the hardware reported
rate twice by 10, fix this.

Fixes: cec17c382140 ("ath10k: add per peer htt tx stats support for 10.4")
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index cb86530..ae10fe1 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2247,7 +2247,7 @@ static inline bool is_valid_legacy_rate(u8 rate)
 		rate *= 10;
 		if (rate == 60 && txrate.flags == WMI_RATE_PREAMBLE_CCK)
 			rate = rate - 5;
-		arsta->txrate.legacy = rate * 10;
+		arsta->txrate.legacy = rate;
 	} else if (txrate.flags == WMI_RATE_PREAMBLE_HT) {
 		arsta->txrate.flags = RATE_INFO_FLAGS_MCS;
 		arsta->txrate.mcs = txrate.mcs;
-- 
1.9.1
