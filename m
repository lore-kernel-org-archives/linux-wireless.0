Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53947 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbcEKRCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:02:43 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 04/21] ath10k: rate-limit packet tx errors
Date: Wed, 11 May 2016 10:02:16 -0700
Message-Id: <1462986153-16318-5-git-send-email-greearb@candelatech.com> (sfid-20160511_190248_923610_3BBDA4ED)
In-Reply-To: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When firmware crashes, stack can continue to send packets
for a bit, and existing code was spamming logs.

So, rate-limit the error message for tx failures.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index cd3016d..42cac32 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3432,8 +3432,9 @@ static int ath10k_mac_tx_submit(struct ath10k *ar,
 	}
 
 	if (ret) {
-		ath10k_warn(ar, "failed to transmit packet, dropping: %d\n",
-			    ret);
+		if (net_ratelimit())
+			ath10k_warn(ar, "failed to transmit packet, dropping: %d\n",
+				    ret);
 		ieee80211_free_txskb(ar->hw, skb);
 	}
 
-- 
2.4.3

