Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48975 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab3LNRD6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 12:03:58 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 05/11] ath9k_hw: remove defunct ad-hoc mode ATIM window handling code
Date: Sat, 14 Dec 2013 18:03:39 +0100
Message-Id: <1387040625-38114-5-git-send-email-nbd@openwrt.org> (sfid-20131214_180413_340796_8340A037)
In-Reply-To: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hardware does not have support for ATIM processing, and the driver
does not set up ah->atim_window anywhere. Additionally, the code can
clobber the timer used by P2P powersave.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 5 -----
 drivers/net/wireless/ath/ath9k/hw.h | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 150bdce..a403cfc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -486,7 +486,6 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->hw_version.magic = AR5416_MAGIC;
 	ah->hw_version.subvendorid = 0;
 
-	ah->atim_window = 0;
 	ah->sta_id1_defaults =
 		AR_STA_ID1_CRPT_MIC_ENABLE |
 		AR_STA_ID1_MCAST_KSRCH;
@@ -2265,9 +2264,6 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 	case NL80211_IFTYPE_ADHOC:
 		REG_SET_BIT(ah, AR_TXCFG,
 			    AR_TXCFG_ADHOC_BEACON_ATIM_TX_POLICY);
-		REG_WRITE(ah, AR_NEXT_NDP_TIMER, next_beacon +
-			  TU_TO_USEC(ah->atim_window ? ah->atim_window : 1));
-		flags |= AR_NDP_TIMER_EN;
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
 		REG_WRITE(ah, AR_NEXT_TBTT_TIMER, next_beacon);
@@ -2288,7 +2284,6 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 	REG_WRITE(ah, AR_BEACON_PERIOD, beacon_period);
 	REG_WRITE(ah, AR_DMA_BEACON_PERIOD, beacon_period);
 	REG_WRITE(ah, AR_SWBA_PERIOD, beacon_period);
-	REG_WRITE(ah, AR_NDP_PERIOD, beacon_period);
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1b45920..3a70682 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -776,7 +776,6 @@ struct ath_hw {
 	u32 txurn_interrupt_mask;
 	atomic_t intr_ref_cnt;
 	bool chip_fullsleep;
-	u32 atim_window;
 	u32 modes_index;
 
 	/* Calibration */
-- 
1.8.3.4 (Apple Git-47)

