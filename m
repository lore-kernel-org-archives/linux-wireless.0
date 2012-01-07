Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63238 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2AGPuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 10:50:54 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>, Gary Morain <gmorain@google.com>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH] ath9k: Fix regression in bandwidth switch at the same channel
Date: Sat, 7 Jan 2012 21:20:57 +0530
Message-ID: <1325951457-9218-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120107_165113_566524_74D44ABC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k: Fix invalid noisefloor reading due to channel update"
preserves the current channel noisefloor readings before updating
channel type at the same channel index. It also updates the curchan.
As survey updation refers curchan to get index for updation, that might
leads to invalid memory access. This patch partially reverts the change
and stores the noise floor history buffer before updating channel type
w/o updating curchan.

Cc: stable@kernel.org
Cc: Gary Morain <gmorain@google.com>
Cc: Paul Stewart <pstew@google.com>
Reported-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    8 ++------
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 172e33d..2f4b48e 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -400,6 +400,7 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	ah->noise = ath9k_hw_getchan_noise(ah, chan);
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_getnf);
 
 void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 				  struct ath9k_channel *chan)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e267c92..4a00806 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1629,7 +1629,6 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
-		struct ath9k_channel old_chan;
 		int pos = curchan->hw_value;
 		int old_pos = -1;
 		unsigned long flags;
@@ -1654,11 +1653,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		 * Preserve the current channel values, before updating
 		 * the same channel
 		 */
-		if (old_pos == pos) {
-			memcpy(&old_chan, &sc->sc_ah->channels[pos],
-				sizeof(struct ath9k_channel));
-			ah->curchan = &old_chan;
-		}
+		if (ah->curchan && (old_pos == pos))
+			ath9k_hw_getnf(ah, ah->curchan);
 
 		ath9k_cmn_update_ichannel(&sc->sc_ah->channels[pos],
 					  curchan, conf->channel_type);
-- 
1.7.8.1

