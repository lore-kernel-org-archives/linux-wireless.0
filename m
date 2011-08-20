Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11882 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab1HTLvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Aug 2011 07:51:50 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k: Add support for get_stats callback
Date: Sat, 20 Aug 2011 17:21:42 +0530
Message-ID: <1313841102-8334-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110820_135200_602377_833B7C94)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

this useful for debugging and to keep track of success/failure of
frames such as ACK, RTS and FCS error count in a noisy environment

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1e7fe8c..250e3b8 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2400,6 +2400,20 @@ skip:
 	return sc->beacon.tx_last;
 }
 
+static int ath9k_get_stats(struct ieee80211_hw *hw,
+			   struct ieee80211_low_level_stats *stats)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_mib_stats *mib_stats = &ah->ah_mibStats;
+
+	stats->dot11ACKFailureCount = mib_stats->ackrcv_bad;
+	stats->dot11RTSFailureCount = mib_stats->rts_bad;
+	stats->dot11FCSErrorCount = mib_stats->fcs_bad;
+	stats->dot11RTSSuccessCount = mib_stats->rts_good;
+	return 0;
+}
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -2424,5 +2438,6 @@ struct ieee80211_ops ath9k_ops = {
 	.set_coverage_class = ath9k_set_coverage_class,
 	.flush		    = ath9k_flush,
 	.tx_frames_pending  = ath9k_tx_frames_pending,
-	.tx_last_beacon = ath9k_tx_last_beacon,
+	.tx_last_beacon     = ath9k_tx_last_beacon,
+	.get_stats	    = ath9k_get_stats,
 };
-- 
1.7.0.4

