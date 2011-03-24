Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:65482 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1CXJG0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 05:06:26 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 02:06:03 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: cleanup few redundant macros
Date: Thu, 24 Mar 2011 14:36:16 +0530
Message-ID: <1300957576-2734-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    4 ----
 drivers/net/wireless/ath/ath9k/common.c |    2 +-
 drivers/net/wireless/ath/ath9k/mac.c    |    2 --
 3 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 099bd41..24b747c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -120,13 +120,11 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 /* RX / TX */
 /***********/
 
-#define ATH_MAX_ANTENNA         3
 #define ATH_RXBUF               512
 #define ATH_TXBUF               512
 #define ATH_TXBUF_RESERVE       5
 #define ATH_MAX_QDEPTH          (ATH_TXBUF / 4 - ATH_TXBUF_RESERVE)
 #define ATH_TXMAXTRY            13
-#define ATH_MGT_TXMAXTRY        4
 
 #define TID_TO_WME_AC(_tid)				\
 	((((_tid) == 0) || ((_tid) == 3)) ? WME_AC_BE :	\
@@ -688,8 +686,6 @@ void ath9k_ps_restore(struct ath_softc *sc);
 
 u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate);
 
-void ath9k_set_bssid_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
-
 void ath_start_rfkill_poll(struct ath_softc *sc);
 extern void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
 void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 615e682..16ba8c6 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -116,7 +116,7 @@ void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
 
 	if (chan->band == IEEE80211_BAND_2GHZ) {
 		ichan->chanmode = CHANNEL_G;
-		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM | CHANNEL_G;
+		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM;
 	} else {
 		ichan->chanmode = CHANNEL_A;
 		ichan->channelFlags = CHANNEL_5GHZ | CHANNEL_OFDM;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 562257a..ffefaf1 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -754,7 +754,6 @@ EXPORT_SYMBOL(ath9k_hw_abortpcurecv);
 bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 {
 #define AH_RX_STOP_DMA_TIMEOUT 10000   /* usec */
-#define AH_RX_TIME_QUANTUM     100     /* usec */
 	struct ath_common *common = ath9k_hw_common(ah);
 	int i;
 
@@ -778,7 +777,6 @@ bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 		return true;
 	}
 
-#undef AH_RX_TIME_QUANTUM
 #undef AH_RX_STOP_DMA_TIMEOUT
 }
 EXPORT_SYMBOL(ath9k_hw_stopdmarecv);
-- 
1.7.0.4

