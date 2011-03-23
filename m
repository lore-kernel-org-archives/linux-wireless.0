Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44612 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845Ab1CWT5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:57:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 10/10] ath9k_hw: remove pCap->tx_triglevel_max
Date: Wed, 23 Mar 2011 20:57:33 +0100
Message-Id: <1300910253-28189-10-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300910253-28189-9-git-send-email-nbd@openwrt.org>
References: <1300910253-28189-1-git-send-email-nbd@openwrt.org>
 <1300910253-28189-2-git-send-email-nbd@openwrt.org>
 <1300910253-28189-3-git-send-email-nbd@openwrt.org>
 <1300910253-28189-4-git-send-email-nbd@openwrt.org>
 <1300910253-28189-5-git-send-email-nbd@openwrt.org>
 <1300910253-28189-6-git-send-email-nbd@openwrt.org>
 <1300910253-28189-7-git-send-email-nbd@openwrt.org>
 <1300910253-28189-8-git-send-email-nbd@openwrt.org>
 <1300910253-28189-9-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It has the same purpose (and value) as ah->config.max_txtrig_level

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    5 -----
 drivers/net/wireless/ath/ath9k/hw.h   |    1 -
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 3 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a2509dc..298f4d6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1880,11 +1880,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	else
 		pCap->hw_caps &= ~ATH9K_HW_CAP_HT;
 
-	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
-		pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD >> 1;
-	else
-		pCap->tx_triglevel_max = MAX_TX_FIFO_THRESHOLD;
-
 	if (AR_SREV_9271(ah))
 		pCap->num_gpio_pins = AR9271_NUM_GPIO;
 	else if (AR_DEVID_7010(ah))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a0243b8..4cc320b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -197,7 +197,6 @@ struct ath9k_hw_capabilities {
 	u8 rx_chainmask;
 	u8 max_txchains;
 	u8 max_rxchains;
-	u16 tx_triglevel_max;
 	u8 num_gpio_pins;
 	u8 rx_hp_qdepth;
 	u8 rx_lp_qdepth;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index f916f08..5943bdc 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1980,7 +1980,7 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 		if (ieee80211_is_data(hdr->frame_control) &&
 		    (ts->ts_flags & (ATH9K_TX_DATA_UNDERRUN |
 		                     ATH9K_TX_DELIM_UNDERRUN)) &&
-		    ah->tx_trig_level >= sc->sc_ah->caps.tx_triglevel_max)
+		    ah->tx_trig_level >= sc->sc_ah->config.max_txtrig_level)
 			tx_info->status.rates[tx_rateindex].count =
 				hw->max_rate_tries;
 	}
-- 
1.7.3.2

