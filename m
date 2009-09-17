Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21666 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760146AbZIQD7D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:59:03 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 20:59:07 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19121.46091.712058.725272@gargle.gargle.HOWL>
Date: Thu, 17 Sep 2009 09:29:07 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/12] ath9k: Disable autosleep feature by default.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vivek Natarajan <vnatarajan@atheros.com>

Autosleep needs to be disabled for AR9287 chipsets also.
Since autosleep is not used for any of the currently supported
chipsets, disable it by default and can be enabled if needed
for any of the future chipsets.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8146826..84abf30 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3700,15 +3700,7 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	}
 #endif
 
-	if ((ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) ||
-	    (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE) ||
-	    (ah->hw_version.macVersion == AR_SREV_VERSION_9160) ||
-	    (ah->hw_version.macVersion == AR_SREV_VERSION_9100) ||
-	    (ah->hw_version.macVersion == AR_SREV_VERSION_9280) ||
-	    (ah->hw_version.macVersion == AR_SREV_VERSION_9285))
-		pCap->hw_caps &= ~ATH9K_HW_CAP_AUTOSLEEP;
-	else
-		pCap->hw_caps |= ATH9K_HW_CAP_AUTOSLEEP;
+	pCap->hw_caps &= ~ATH9K_HW_CAP_AUTOSLEEP;
 
 	if (AR_SREV_9280(ah) || AR_SREV_9285(ah))
 		pCap->hw_caps &= ~ATH9K_HW_CAP_4KB_SPLITTRANS;
-- 
1.6.4.3

