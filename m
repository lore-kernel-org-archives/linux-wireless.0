Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19735 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab0ERB54 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 21:57:56 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 May 2010 18:57:56 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k_hw: Enable auto sleep for ar9003
Date: Mon, 17 May 2010 18:57:56 -0700
Message-ID: <1274147876-9228-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1274147876-9228-1-git-send-email-vasanth@atheros.com>
References: <1274147876-9228-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1985d19..7997d0f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2165,7 +2165,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->hw_caps |= ATH9K_HW_CAP_RFSILENT;
 	}
 #endif
-	if (AR_SREV_9271(ah))
+	if (AR_SREV_9271(ah) || AR_SREV_9300_20_OR_LATER(ah))
 		pCap->hw_caps |= ATH9K_HW_CAP_AUTOSLEEP;
 	else
 		pCap->hw_caps &= ~ATH9K_HW_CAP_AUTOSLEEP;
-- 
1.7.0.4

