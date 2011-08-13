Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32084 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1HME67 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 00:58:59 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 10/11] ath9k: Fix invalid noisefloor reading due to channel update
Date: Sat, 13 Aug 2011 10:28:17 +0530
Message-ID: <1313211498-14442-10-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110813_065901_489457_3DB22A25)
In-Reply-To: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While switching b/w HT20/40, the current channel's nf values
are updated into history buffer. Since the current channel's
channel type, channel flag got updated before reading
nf value from hw. This channel type mismatch is causing invalid
readings when hw is on ht20 but getnf tries to read on extn chains.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e828799..1af183f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1674,6 +1674,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
+		struct ath9k_channel old_chan;
 		int pos = curchan->hw_value;
 		int old_pos = -1;
 		unsigned long flags;
@@ -1690,15 +1691,25 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			"Set channel: %d MHz type: %d\n",
 			curchan->center_freq, conf->channel_type);
 
-		ath9k_cmn_update_ichannel(&sc->sc_ah->channels[pos],
-					  curchan, conf->channel_type);
-
 		/* update survey stats for the old channel before switching */
 		spin_lock_irqsave(&common->cc_lock, flags);
 		ath_update_survey_stats(sc);
 		spin_unlock_irqrestore(&common->cc_lock, flags);
 
 		/*
+		 * Preserve the current channel values, before updating
+		 * the same channel
+		 */
+		if (old_pos == pos) {
+			memcpy(&old_chan, &sc->sc_ah->channels[pos],
+				sizeof(struct ath9k_channel));
+			ah->curchan = &old_chan;
+		}
+
+		ath9k_cmn_update_ichannel(&sc->sc_ah->channels[pos],
+					  curchan, conf->channel_type);
+
+		/*
 		 * If the operating channel changes, change the survey in-use flags
 		 * along with it.
 		 * Reset the survey data for the new channel, unless we're switching
-- 
1.7.6

