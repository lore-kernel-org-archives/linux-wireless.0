Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48878 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758246Ab2HHN47 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 09:56:59 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.6 4/4] ath9k_hw: enable PA linearization
Date: Tue,  7 Aug 2012 15:06:12 +0200
Message-Id: <1344344772-49459-4-git-send-email-nbd@openwrt.org> (sfid-20120808_155708_643915_FCD8CA15)
In-Reply-To: <1344344772-49459-3-git-send-email-nbd@openwrt.org>
References: <1344344772-49459-1-git-send-email-nbd@openwrt.org>
 <1344344772-49459-2-git-send-email-nbd@openwrt.org>
 <1344344772-49459-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This feature had been disabled in ath9k because the code to support
it was incomplete, but now the code is in sync with the internal QCA
codebase, so it's time to enable it.

On many newer devices, the calibration is assumed to be done with PA
linearization enabled.

Tests with a particular AR933x device showed that the signal emitted
at full power was highly distorted and unreliable with PA linearization
disabled. With this patch, the signal becomes clear and stability
is improved.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d95474e..bea864f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -463,9 +463,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 		ah->config.spurchans[i][1] = AR_NO_SPUR;
 	}
 
-	/* PAPRD needs some more work to be enabled */
-	ah->config.paprd_disable = 1;
-
 	ah->config.rx_intr_mitigation = true;
 	ah->config.pcieSerDesWrite = true;
 
-- 
1.7.9.6 (Apple Git-31.1)

