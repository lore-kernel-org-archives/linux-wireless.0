Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42563 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615Ab1G1MJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 08:09:10 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/2] ath9k: use the new channel noise value for signal strength and survey info
Date: Thu, 28 Jul 2011 14:08:57 +0200
Message-Id: <1311854937-9411-2-git-send-email-nbd@openwrt.org> (sfid-20110728_140913_768007_BF8F6415)
In-Reply-To: <1311854937-9411-1-git-send-email-nbd@openwrt.org>
References: <1311854937-9411-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9098aaa..b602447 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -163,7 +163,7 @@ static void ath_update_survey_nf(struct ath_softc *sc, int channel)
 
 	if (chan->noisefloor) {
 		survey->filled |= SURVEY_INFO_NOISE_DBM;
-		survey->noise = chan->noisefloor;
+		survey->noise = ath9k_hw_getchan_noise(ah, chan);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d32e82f..bbff0ba 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -994,6 +994,8 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 				   struct ieee80211_rx_status *rx_status,
 				   bool *decrypt_error)
 {
+	struct ath_hw *ah = common->ah;
+
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
 
 	/*
@@ -1014,7 +1016,7 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 
 	rx_status->band = hw->conf.channel->band;
 	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rx_stats->rs_rssi;
+	rx_status->signal = ah->noise + rx_stats->rs_rssi;
 	rx_status->antenna = rx_stats->rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 
-- 
1.7.3.2

