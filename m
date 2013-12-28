Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48716 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab3L1EWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Dec 2013 23:22:24 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/7] ath9k: Remove unused config option ack_6mb
Date: Sat, 28 Dec 2013 09:47:14 +0530
Message-Id: <1388204235-14682-6-git-send-email-sujith@msujith.org> (sfid-20131228_052249_870034_548EC90F)
In-Reply-To: <1388204235-14682-1-git-send-email-sujith@msujith.org>
References: <1388204235-14682-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 2 --
 drivers/net/wireless/ath/ath9k/hw.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c70ea28..579b669 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -350,7 +350,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 
 	ah->config.dma_beacon_response_time = 1;
 	ah->config.sw_beacon_response_time = 6;
-	ah->config.ack_6mb = 0x0;
 	ah->config.cwm_ignore_extcca = 0;
 	ah->config.analog_shiftreg = 1;
 
@@ -1552,7 +1551,6 @@ static void ath9k_hw_reset_opmode(struct ath_hw *ah,
 
 	REG_RMW(ah, AR_STA_ID1, macStaId1
 		  | AR_STA_ID1_RTS_USE_DEF
-		  | (ah->config.ack_6mb ? AR_STA_ID1_ACKCTS_6MB : 0)
 		  | ah->sta_id1_defaults,
 		  ~AR_STA_ID1_SADH_MASK);
 	ath_hw_setbssidmask(common);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7632509..5e10ad9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -295,7 +295,6 @@ enum ath9k_hw_hang_checks {
 struct ath9k_ops_config {
 	int dma_beacon_response_time;
 	int sw_beacon_response_time;
-	int ack_6mb;
 	u32 cwm_ignore_extcca;
 	u32 pcie_waen;
 	u8 analog_shiftreg;
-- 
1.8.5.2

