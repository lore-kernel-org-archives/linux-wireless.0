Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48961 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab3LNRD5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 12:03:57 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 08/11] ath9k_hw: remove additional_swba_backoff
Date: Sat, 14 Dec 2013 18:03:42 +0100
Message-Id: <1387040625-38114-8-git-send-email-nbd@openwrt.org> (sfid-20131214_180401_296398_A9741C1A)
In-Reply-To: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is unused

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  | 1 -
 drivers/net/wireless/ath/ath9k/hw.h  | 1 -
 drivers/net/wireless/ath/ath9k/mac.c | 3 +--
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a4f3d2b..dd10fee 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -441,7 +441,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 {
 	ah->config.dma_beacon_response_time = 1;
 	ah->config.sw_beacon_response_time = 6;
-	ah->config.additional_swba_backoff = 0;
 	ah->config.ack_6mb = 0x0;
 	ah->config.cwm_ignore_extcca = 0;
 	ah->config.analog_shiftreg = 1;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 57d3d0c..2ef9d24 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -280,7 +280,6 @@ struct ath9k_hw_capabilities {
 struct ath9k_ops_config {
 	int dma_beacon_response_time;
 	int sw_beacon_response_time;
-	int additional_swba_backoff;
 	int ack_6mb;
 	u32 cwm_ignore_extcca;
 	u32 pcie_waen;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index a850482..89d7e20 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -481,8 +481,7 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 			    | AR_Q_MISC_CBR_INCR_DIS0);
 		value = (qi->tqi_readyTime -
 			 (ah->config.sw_beacon_response_time -
-			  ah->config.dma_beacon_response_time) -
-			 ah->config.additional_swba_backoff) * 1024;
+			  ah->config.dma_beacon_response_time)) * 1024;
 		REG_WRITE(ah, AR_QRDYTIMECFG(q),
 			  value | AR_Q_RDYTIMECFG_EN);
 		REG_SET_BIT(ah, AR_DMISC(q),
-- 
1.8.3.4 (Apple Git-47)

