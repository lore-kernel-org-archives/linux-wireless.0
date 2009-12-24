Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60827 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZLXBDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 20:03:30 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH 5/5] ath9k: wake hardware during AMPDU TX actions
Date: Wed, 23 Dec 2009 20:03:29 -0500
Message-Id: <1261616609-518-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1261616609-518-1-git-send-email-lrodriguez@atheros.com>
References: <1261616609-518-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AMDPDU actions poke hardware for TX operation, as such
we want to turn hardware on for these actions. AMDPU RX operations
do not require hardware on as nothing is done in hardware for
those actions. Without this we cannot guarantee hardware has
been programmed correctly for each AMPDU TX action.

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9a4d9b9..c1c96ea 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -3095,15 +3095,21 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_RX_STOP:
 		break;
 	case IEEE80211_AMPDU_TX_START:
+		ath9k_ps_wakeup(sc);
 		ath_tx_aggr_start(sc, sta, tid, ssn);
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		ath9k_ps_restore(sc);
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
+		ath9k_ps_wakeup(sc);
 		ath_tx_aggr_stop(sc, sta, tid);
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		ath9k_ps_restore(sc);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		ath9k_ps_wakeup(sc);
 		ath_tx_aggr_resume(sc, sta, tid);
+		ath9k_ps_restore(sc);
 		break;
 	default:
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
-- 
1.6.3.3

