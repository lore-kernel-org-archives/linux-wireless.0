Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chaos.universe-factory.net ([37.72.148.22]:40796 "EHLO
        chaos.universe-factory.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751736AbcKORyc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 12:54:32 -0500
From: Matthias Schiffer <mschiffer@universe-factory.net>
To: kvalo@codeaurora.org
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath9k-devel@lists.ath9k.org, miaoqing@codeaurora.org
Subject: [PATCH] ath9k: fix ath9k_hw_gpio_get() to return 0 or 1 on success
Date: Tue, 15 Nov 2016 18:47:21 +0100
Message-Id: <44116a7bca8524a187083916bdea535145e7a23a.1479232041.git.mschiffer@universe-factory.net> (sfid-20161115_185435_416633_AB04835C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit b2d70d4944c1 ("ath9k: make GPIO API to support both of WMAC and
SOC") refactored ath9k_hw_gpio_get() to support both WMAC and SOC GPIOs,
changing the return on success from 1 to BIT(gpio). This broke some callers
like ath_is_rfkill_set().

Instead of fixing all callers, change ath9k_hw_gpio_get() back to only
return 0 or 1.

Fixes: b2d70d4944c1 ("ath9k: make GPIO API to support both of WMAC and SOC")
Cc: <stable@vger.kernel.org> # v4.7+
Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
---
 drivers/net/wireless/ath/ath9k/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 14b13f0..a35f78b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2792,7 +2792,7 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
 		WARN_ON(1);
 	}
 
-	return val;
+	return !!val;
 }
 EXPORT_SYMBOL(ath9k_hw_gpio_get);
 
-- 
2.10.2
