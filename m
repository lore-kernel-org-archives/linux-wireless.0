Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from AShevkov.infinet.ru ([91.191.225.92]:37169 "EHLO
	AShevkov.infinet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1HPLkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 07:40:01 -0400
From: Alex Hacker <hacker@epn.ru>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	Alex Hacker <hacker@epn.ru>
Subject: [PATCH] ath9k_hw: fix EIFS value to microseconds
Date: Tue, 16 Aug 2011 16:41:40 +0600
Message-Id: <1313491300-11386-1-git-send-email-hacker@epn.ru> (sfid-20110816_134006_492845_E919FB0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The EIFS value read from AR_D_GBL_IFS_EIFS register in core clocks and then
written back as microsecond value.


Signed-off-by: Alex Hacker <hacker@epn.ru>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index db44e5b..2343431 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -996,7 +996,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		slottime = 21;
 		sifstime = 64;
 	} else {
-		eifs = REG_READ(ah, AR_D_GBL_IFS_EIFS);
+		eifs = REG_READ(ah, AR_D_GBL_IFS_EIFS)/common->clockrate;
 		reg = REG_READ(ah, AR_USEC);
 		rx_lat = MS(reg, AR_USEC_RX_LAT);
 		tx_lat = MS(reg, AR_USEC_TX_LAT);
-- 
1.7.4

