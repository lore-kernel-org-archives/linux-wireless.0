Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40228 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbeCNM3o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 08:29:44 -0400
From: Ramon Fried <rfried@codeaurora.org>
To: k.eugene.e@gmail.com, kvalo@codeaurora.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: Ramon Fried <rfried@codeaurora.org>
Subject: [PATCH] wcn36xx: turn off probe response offloading
Date: Wed, 14 Mar 2018 14:29:37 +0200
Message-Id: <20180314122937.14119-1-rfried@codeaurora.org> (sfid-20180314_132948_207520_6A3DFD95)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It appears that the WCN36xx firmware doesn't actually respond to
probe requests. Until it's resolved, switch the probe response
responsibility to the 802.11 layer to allow creation of
hidden SSID AP's.

Signed-off-by: Ramon Fried <rfried@codeaurora.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index ab5be6d2c691..9d8c177ac7e1 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1155,8 +1155,6 @@ static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
 	wcn->hw->wiphy->cipher_suites = cipher_suites;
 	wcn->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
-	wcn->hw->wiphy->flags |= WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
-
 #ifdef CONFIG_PM
 	wcn->hw->wiphy->wowlan = &wowlan_support;
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
