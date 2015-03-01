Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35039 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbbCAGUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 01:20:21 -0500
Received: from [117.199.133.19] (port=11028 helo=sujith-pixel.localdomain)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YRxEh-002K5A-RB
	for linux-wireless@vger.kernel.org; Sun, 01 Mar 2015 01:20:20 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] ath9k: Fix wlan-active gpio for the AR9003 family
Date: Sun,  1 Mar 2015 11:53:47 +0530
Message-Id: <1425191029-13667-5-git-send-email-sujith@msujith.org> (sfid-20150301_072033_209055_8B0D0A13)
In-Reply-To: <1425191029-13667-1-git-send-email-sujith@msujith.org>
References: <1425191029-13667-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When disabling BTCOEX, clearing the wlanactive gpio line
is required only for pre-AR9003 cards.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 78e892e..5a084d9 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -361,7 +361,8 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 		return;
 	}
 
-	ath9k_hw_set_gpio(ah, btcoex_hw->wlanactive_gpio, 0);
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		ath9k_hw_set_gpio(ah, btcoex_hw->wlanactive_gpio, 0);
 
 	ath9k_hw_cfg_output(ah, btcoex_hw->wlanactive_gpio,
 			AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
-- 
2.3.0

