Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30166 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbYLTFzz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:55:55 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 21:55:55 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 11/16] ath9k: Make ANI CCK and OFDM error triggers band specific
Date: Fri, 19 Dec 2008 21:55:17 -0800
Message-ID: <1229752522-1917-12-git-send-email-lrodriguez@atheros.com> (sfid-20081220_065610_264186_4C36231C)
In-Reply-To: <1229752522-1917-11-git-send-email-lrodriguez@atheros.com>
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-3-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-4-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-5-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-6-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-7-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-8-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-9-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-10-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-11-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CCK and OFDM ANI error triggers are not mode specific but rather
band specific so just make use of the already available band from
ieee80211_conf.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ani.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ani.c b/drivers/net/wireless/ath9k/ani.c
index 251e2d9..4dd0860 100644
--- a/drivers/net/wireless/ath9k/ani.c
+++ b/drivers/net/wireless/ath9k/ani.c
@@ -279,9 +279,8 @@ static void ath9k_ani_restart(struct ath_hal *ah)
 static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ath9k_channel *chan = ah->ah_curchan;
+	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
 	struct ar5416AniState *aniState;
-	enum wireless_mode mode;
 	int32_t rssi;
 
 	if (!DO_ANI(ah))
@@ -336,8 +335,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 					     aniState->firstepLevel + 1);
 		return;
 	} else {
-		mode = ath9k_hw_chan2wmode(ah, chan);
-		if (mode == ATH9K_MODE_11G || mode == ATH9K_MODE_11B) {
+		if (conf->channel->band == IEEE80211_BAND_2GHZ) {
 			if (!aniState->ofdmWeakSigDetectOff)
 				ath9k_hw_ani_control(ah,
 				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
@@ -353,9 +351,8 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hal *ah)
 static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ath9k_channel *chan = ah->ah_curchan;
+	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
 	struct ar5416AniState *aniState;
-	enum wireless_mode mode;
 	int32_t rssi;
 
 	if (!DO_ANI(ah))
@@ -381,8 +378,7 @@ static void ath9k_hw_ani_cck_err_trigger(struct ath_hal *ah)
 			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
 	} else {
-		mode = ath9k_hw_chan2wmode(ah, chan);
-		if (mode == ATH9K_MODE_11G || mode == ATH9K_MODE_11B) {
+		if (conf->channel->band == IEEE80211_BAND_2GHZ) {
 			if (aniState->firstepLevel > 0)
 				ath9k_hw_ani_control(ah,
 					     ATH9K_ANI_FIRSTEP_LEVEL, 0);
-- 
1.5.6.rc2.15.g457bb.dirty

