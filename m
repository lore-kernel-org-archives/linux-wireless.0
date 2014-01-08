Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45773 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbaAHQTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 11:19:20 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] ath9k: Use correct channel for RX packets
Date: Wed,  8 Jan 2014 21:44:10 +0530
Message-Id: <1389197650-12496-1-git-send-email-sujith@msujith.org> (sfid-20140108_171925_159014_FC3288A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Accessing the current channel definition in mac80211
when processing RX packets is problematic because it
could have been updated when a scan is issued. Since a
channel change involves flushing the existing packets
in the RX queue before a chip-reset is done, they would
be processed using the wrong band/channel information.

To avoid this, use the current channel information
maintained in the driver.

Cc: stable@vger.kernel.org
Reported-by: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6d643ca..9a96517 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -850,20 +850,15 @@ static int ath9k_process_rate(struct ath_common *common,
 	enum ieee80211_band band;
 	unsigned int i = 0;
 	struct ath_softc __maybe_unused *sc = common->priv;
+	struct ath_hw *ah = common->ah;
 
-	band = hw->conf.chandef.chan->band;
+	band = ah->curchan->chan->band;
 	sband = hw->wiphy->bands[band];
 
-	switch (hw->conf.chandef.width) {
-	case NL80211_CHAN_WIDTH_5:
+	if (IS_CHAN_QUARTER_RATE(ah->curchan))
 		rxs->flag |= RX_FLAG_5MHZ;
-		break;
-	case NL80211_CHAN_WIDTH_10:
+	else if (IS_CHAN_HALF_RATE(ah->curchan))
 		rxs->flag |= RX_FLAG_10MHZ;
-		break;
-	default:
-		break;
-	}
 
 	if (rx_stats->rs_rate & 0x80) {
 		/* HT rate */
@@ -1085,8 +1080,8 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 
 	ath9k_process_rssi(common, hw, rx_stats, rx_status);
 
-	rx_status->band = hw->conf.chandef.chan->band;
-	rx_status->freq = hw->conf.chandef.chan->center_freq;
+	rx_status->band = ah->curchan->chan->band;
+	rx_status->freq = ah->curchan->chan->center_freq;
 	rx_status->antenna = rx_stats->rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_END;
 
-- 
1.8.5.2

