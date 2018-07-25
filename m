Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54158 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729213AbeGYUGQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 16:06:16 -0400
From: Varsha Rao <rvarsha016@gmail.com>
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH] net: wireless: ath9k: Remove unnecessary parentheses
Date: Wed, 25 Jul 2018 20:53:03 +0200
Message-Id: <20180725185305.4118-1-rvarsha016@gmail.com> (sfid-20180725_205329_750352_70454E0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove extra parentheses to fix the clang warning of extraneous
parentheses.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 drivers/net/wireless/ath/ath9k/debug_sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index a6f45f1bb5bb..ed8b77a74630 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -116,7 +116,7 @@ void ath_debug_rate_stats(struct ath_softc *sc,
 		if (rxs->rate_idx >= ARRAY_SIZE(rstats->ht_stats))
 			goto exit;
 
-		if ((rxs->bw == RATE_INFO_BW_40))
+		if (rxs->bw == RATE_INFO_BW_40)
 			rstats->ht_stats[rxs->rate_idx].ht40_cnt++;
 		else
 			rstats->ht_stats[rxs->rate_idx].ht20_cnt++;
-- 
2.17.0
