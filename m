Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26456 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab1C1U5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 16:57:43 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 13:57:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	<stable@kernel.org>, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 7/9] ath9k: add missing ps wakeup/restore calls
Date: Mon, 28 Mar 2011 13:57:13 -0700
Message-ID: <1301345835-11401-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
References: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

commit 783cd01e140d9db5c2d2279a96b81e16f9d81fef upstream

There are several places where ath_reset() was called without proper
calls to ath9k_ps_wakeup/ath9k_ps_restore. To fix this, add those calls
directly to ath_reset and drop them from callers where it makes sense.

Also add them to the config callback around ath_update_txpow to fix a
crash that happens when the tx power changed before any vif is brought up.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    8 +++++---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 --
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 20cdf3d..1049313 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -602,14 +602,12 @@ void ath9k_tasklet(unsigned long data)
 	u32 status = sc->intrstatus;
 	u32 rxmask;
 
-	ath9k_ps_wakeup(sc);
-
 	if (status & ATH9K_INT_FATAL) {
 		ath_reset(sc, true);
-		ath9k_ps_restore(sc);
 		return;
 	}
 
+	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&sc->sc_pcu_lock);
 
 	if (!ath9k_hw_check_alive(ah))
@@ -977,6 +975,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	/* Stop ANI */
 	del_timer_sync(&common->ani.timer);
 
+	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&sc->sc_pcu_lock);
 
 	ieee80211_stop_queues(hw);
@@ -1024,6 +1023,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 
 	/* Start ANI */
 	ath_start_ani(common);
+	ath9k_ps_restore(sc);
 
 	return r;
 }
@@ -1731,7 +1731,9 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 skip_chan_change:
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		sc->config.txpowlimit = 2 * conf->power_level;
+		ath9k_ps_wakeup(sc);
 		ath_update_txpow(sc);
+		ath9k_ps_restore(sc);
 	}
 
 	spin_lock_bh(&sc->wiphy_lock);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index aff0478..19ff656 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2152,9 +2152,7 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 	if (needreset) {
 		ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_RESET,
 			  "tx hung, resetting the chip\n");
-		ath9k_ps_wakeup(sc);
 		ath_reset(sc, true);
-		ath9k_ps_restore(sc);
 	}
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
-- 
1.7.4.15.g7811d

