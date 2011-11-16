Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44528 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452Ab1KPMIy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 07:08:54 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3/4] ath9k: only drop packets in drv_flush when asked to
Date: Wed, 16 Nov 2011 13:08:42 +0100
Message-Id: <1321445323-71774-3-git-send-email-nbd@openwrt.org> (sfid-20111116_130901_609352_E5A8F83D)
In-Reply-To: <1321445323-71774-2-git-send-email-nbd@openwrt.org>
References: <1321445323-71774-1-git-send-email-nbd@openwrt.org>
 <1321445323-71774-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently more places in mac80211 call drv_flush to ensure proper order
for state changes wrt. powersave, channel changes, etc. On some systems
such calls lead to spurious logspam about failing to stop tx dma, as well
as hardware resets that go along with that.
Instead of dropping packets in a place where it's completely unnecessary,
only do it when drop == true.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 81e1368..a7f7926 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2268,9 +2268,6 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 		return;
 	}
 
-	if (drop)
-		timeout = 1;
-
 	for (j = 0; j < timeout; j++) {
 		bool npend = false;
 
@@ -2288,21 +2285,22 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 		}
 
 		if (!npend)
-		    goto out;
+		    break;
 	}
 
-	ath9k_ps_wakeup(sc);
-	spin_lock_bh(&sc->sc_pcu_lock);
-	drain_txq = ath_drain_all_txq(sc, false);
-	spin_unlock_bh(&sc->sc_pcu_lock);
+	if (drop) {
+		ath9k_ps_wakeup(sc);
+		spin_lock_bh(&sc->sc_pcu_lock);
+		drain_txq = ath_drain_all_txq(sc, false);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 
-	if (!drain_txq)
-		ath_reset(sc, false);
+		if (!drain_txq)
+			ath_reset(sc, false);
 
-	ath9k_ps_restore(sc);
-	ieee80211_wake_queues(hw);
+		ath9k_ps_restore(sc);
+		ieee80211_wake_queues(hw);
+	}
 
-out:
 	ieee80211_queue_delayed_work(hw, &sc->tx_complete_work, 0);
 	mutex_unlock(&sc->mutex);
 }
-- 
1.7.3.2

