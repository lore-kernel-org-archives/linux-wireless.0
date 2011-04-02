Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53528 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab1DBBjz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 21:39:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/3] ath9k: fix signal strength of received packets
Date: Sat,  2 Apr 2011 03:39:46 +0200
Message-Id: <1301708388-8416-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The reported RSSI values are relative to the calibrated noise floor, not
relative to a hardcoded value of -95.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index a9c3f46..87d96c5 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -959,6 +959,9 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 				   struct ieee80211_rx_status *rx_status,
 				   bool *decrypt_error)
 {
+	struct ath_hw *ah = common->ah;
+	int noise;
+
 	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
 
 	/*
@@ -979,7 +982,13 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 
 	rx_status->band = hw->conf.channel->band;
 	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->signal = ATH_DEFAULT_NOISE_FLOOR + rx_stats->rs_rssi;
+
+	if (ah->curchan)
+		noise = ah->curchan->noisefloor;
+	else
+		noise = ATH_DEFAULT_NOISE_FLOOR;
+
+	rx_status->signal = noise + rx_stats->rs_rssi;
 	rx_status->antenna = rx_stats->rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 
-- 
1.7.3.2

