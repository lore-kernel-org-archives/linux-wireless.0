Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:40198 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3FJIWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 04:22:35 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/3] ath9k: Fix noisefloor calibration
Date: Mon, 10 Jun 2013 13:49:39 +0530
Message-Id: <1370852380-8335-2-git-send-email-sujith@msujith.org> (sfid-20130610_102240_232289_C3A05C4D)
In-Reply-To: <1370852380-8335-1-git-send-email-sujith@msujith.org>
References: <1370852380-8335-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The commits,

"ath9k: Fix regression in channelwidth switch at the same channel"
"ath9k: Fix invalid noisefloor reading due to channel update"

attempted to fix noisefloor calibration when a channel switch
happens due to HT20/HT40 bandwidth change. This is causing invalid
readings resulting in messages like:

"ath: phy16: NF[0] (-45) > MAX (-95), correcting to MAX".

This results in an incorrect noise being used initially for reporting
the signal level of received packets, until NF calibration is done
and the history buffer is updated via the ANI timer, which happens
much later.

When a bandwidth change happens, it is appropriate to reset
the internal history data for the channel. Do this correctly in the
reset() routine by checking the "chanmode" variable.

Cc: stable@vger.kernel.org
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   | 3 ++-
 drivers/net/wireless/ath/ath9k/main.c | 7 -------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d813ab8..ca9d9cd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1870,7 +1870,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ah->caldata = caldata;
 	if (caldata && (chan->channel != caldata->channel ||
-			chan->channelFlags != caldata->channelFlags)) {
+			chan->channelFlags != caldata->channelFlags ||
+			chan->chanmode != caldata->chanmode)) {
 		/* Operating channel changed, reset channel calibration data */
 		memset(caldata, 0, sizeof(*caldata));
 		ath9k_init_nfcal_hist_buffer(ah, chan);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e5b186b..e2861a7e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1210,13 +1210,6 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		ath_update_survey_stats(sc);
 		spin_unlock_irqrestore(&common->cc_lock, flags);
 
-		/*
-		 * Preserve the current channel values, before updating
-		 * the same channel
-		 */
-		if (ah->curchan && (old_pos == pos))
-			ath9k_hw_getnf(ah, ah->curchan);
-
 		ath9k_cmn_update_ichannel(&sc->sc_ah->channels[pos],
 					  curchan, channel_type);
 
-- 
1.8.3

