Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36040 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810Ab2B0S6v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 13:58:51 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com
Subject: [PATCH 3.3 3/4] ath9k_hw: enable interrupts for beacon tx completion events
Date: Mon, 27 Feb 2012 19:58:41 +0100
Message-Id: <1330369122-60220-3-git-send-email-nbd@openwrt.org> (sfid-20120227_195858_945382_655C0342)
In-Reply-To: <1330369122-60220-2-git-send-email-nbd@openwrt.org>
References: <1330369122-60220-1-git-send-email-nbd@openwrt.org>
 <1330369122-60220-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not doing so could cause the tx status queue to overflow during longer
periods of time without non-beacon tx. These events are also required
for proper drv_tx_last_beacon handling.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/mac.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index e196aba..5f4ae6c 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -745,7 +745,11 @@ int ath9k_hw_beaconq_setup(struct ath_hw *ah)
 	qi.tqi_aifs = 1;
 	qi.tqi_cwmin = 0;
 	qi.tqi_cwmax = 0;
-	/* NB: don't enable any interrupts */
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
+		qi.tqi_qflags = TXQ_FLAG_TXOKINT_ENABLE |
+				TXQ_FLAG_TXERRINT_ENABLE;
+
 	return ath9k_hw_setuptxqueue(ah, ATH9K_TX_QUEUE_BEACON, &qi);
 }
 EXPORT_SYMBOL(ath9k_hw_beaconq_setup);
-- 
1.7.3.2

