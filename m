Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41462 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbZIKDAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 23:00:39 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 20:00:42 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19113.48435.208806.221217@gargle.gargle.HOWL>
Date: Fri, 11 Sep 2009 08:30:03 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix bug in ANI channel handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When processing MIB interrupts, OFDM and CCK error
handling routines for low RSSI values have to be invoked
only when the channel mode is 11G/11B. Since HT channels
will also fall under the bands 2Ghz/5Ghz, check appropriately.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---

This patch would apply over Luis' pending patches.

 drivers/net/wireless/ath/ath9k/ani.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index f5cd7da..e4f9559 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -327,7 +327,8 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
 					     aniState->firstepLevel + 1);
 		return;
 	} else {
-		if (conf->channel->band == IEEE80211_BAND_2GHZ) {
+		if ((conf->channel->band == IEEE80211_BAND_2GHZ) &&
+		    !conf_is_ht(conf)) {
 			if (!aniState->ofdmWeakSigDetectOff)
 				ath9k_hw_ani_control(ah,
 				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
@@ -369,7 +370,8 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hw *ah)
 			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
 	} else {
-		if (conf->channel->band == IEEE80211_BAND_2GHZ) {
+		if ((conf->channel->band == IEEE80211_BAND_2GHZ) &&
+		    !conf_is_ht(conf)) {
 			if (aniState->firstepLevel > 0)
 				ath9k_hw_ani_control(ah,
 					     ATH9K_ANI_FIRSTEP_LEVEL, 0);
-- 
1.6.4.2

