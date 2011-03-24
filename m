Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:15774 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415Ab1CXNgr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 09:36:47 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 06:36:23 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k_hw: remove ath9k_get_channel_edges
Date: Thu, 24 Mar 2011 19:06:40 +0530
Message-ID: <1300973800-10415-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

This function is nowhere used.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   25 -------------------------
 drivers/net/wireless/ath/ath9k/hw.h |    3 ---
 2 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8b86568..21e72f6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -142,25 +142,6 @@ u32 ath9k_hw_reverse_bits(u32 val, u32 n)
 	return retval;
 }
 
-bool ath9k_get_channel_edges(struct ath_hw *ah,
-			     u16 flags, u16 *low,
-			     u16 *high)
-{
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
-
-	if (flags & CHANNEL_5GHZ) {
-		*low = pCap->low_5ghz_chan;
-		*high = pCap->high_5ghz_chan;
-		return true;
-	}
-	if ((flags & CHANNEL_2GHZ)) {
-		*low = pCap->low_2ghz_chan;
-		*high = pCap->high_2ghz_chan;
-		return true;
-	}
-	return false;
-}
-
 u16 ath9k_hw_computetxtime(struct ath_hw *ah,
 			   u8 phy, int kbps,
 			   u32 frameLen, u16 rateix,
@@ -1881,12 +1862,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		ah->misc_mode |= AR_PCU_ALWAYS_PERFORM_KEYSEARCH;
 
-	pCap->low_2ghz_chan = 2312;
-	pCap->high_2ghz_chan = 2732;
-
-	pCap->low_5ghz_chan = 4920;
-	pCap->high_5ghz_chan = 6100;
-
 	common->crypt_caps |= ATH_CRYPT_CAP_CIPHER_AESCCM;
 
 	if (ah->config.ht_enable)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3d9fc6e..690b3a6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -201,8 +201,6 @@ struct ath9k_hw_capabilities {
 	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */
 	u16 total_queues;
 	u16 keycache_size;
-	u16 low_5ghz_chan, high_5ghz_chan;
-	u16 low_2ghz_chan, high_2ghz_chan;
 	u16 rts_aggr_limit;
 	u8 tx_chainmask;
 	u8 rx_chainmask;
@@ -914,7 +912,6 @@ void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 /* General Operation */
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout);
 u32 ath9k_hw_reverse_bits(u32 val, u32 n);
-bool ath9k_get_channel_edges(struct ath_hw *ah, u16 flags, u16 *low, u16 *high);
 u16 ath9k_hw_computetxtime(struct ath_hw *ah,
 			   u8 phy, int kbps,
 			   u32 frameLen, u16 rateix, bool shortPreamble);
-- 
1.7.0.4

