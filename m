Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40447 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab2DLSgo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 14:36:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.4] ath9k: wake up the hardware from full sleep when idle is turned off
Date: Thu, 12 Apr 2012 20:36:31 +0200
Message-Id: <1334255791-55353-1-git-send-email-nbd@openwrt.org> (sfid-20120412_203648_063310_BD3E74B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hardware needs a reset to recover from full sleep. Issue this reset
directly in the ath9k_config call that turns off idle, otherwise tx
remains dead until the first channel change after the idle state change

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ba5af8e..fcb13e3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1584,6 +1584,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &hw->conf;
+	bool reset_channel = false;
 
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
@@ -1592,6 +1593,12 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		sc->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
 		if (sc->ps_idle)
 			ath_cancel_work(sc);
+		else
+			/*
+			 * The chip needs a reset to properly wake up from
+			 * full sleep
+			 */
+			reset_channel = ah->chip_fullsleep;
 	}
 
 	/*
@@ -1620,7 +1627,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) || reset_channel) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos = curchan->hw_value;
 		int old_pos = -1;
-- 
1.7.3.2

