Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:61072 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaE0L1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 07:27:25 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] ath9k: Fix deadlock while updating p2p beacon timer
Date: Tue, 27 May 2014 16:58:02 +0530
Message-ID: <1401190082-10572-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140527_132732_362974_A54B13F2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pm_lock is taken twice while syncing HW TSF of p2p vif.
Fix this by taking the lock at caller side.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6965cea..40791db 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1757,7 +1757,6 @@ out:
 void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif)
 {
 	struct ath_vif *avp = (void *)vif->drv_priv;
-	unsigned long flags;
 	u32 tsf;
 
 	if (!sc->p2p_ps_timer)
@@ -1767,14 +1766,9 @@ void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif)
 		return;
 
 	sc->p2p_ps_vif = avp;
-
-	spin_lock_irqsave(&sc->sc_pm_lock, flags);
-	if (!(sc->ps_flags & PS_BEACON_SYNC)) {
-		tsf = ath9k_hw_gettsf32(sc->sc_ah);
-		ieee80211_parse_p2p_noa(&vif->bss_conf.p2p_noa_attr, &avp->noa, tsf);
-		ath9k_update_p2p_ps_timer(sc, avp);
-	}
-	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+	tsf = ath9k_hw_gettsf32(sc->sc_ah);
+	ieee80211_parse_p2p_noa(&vif->bss_conf.p2p_noa_attr, &avp->noa, tsf);
+	ath9k_update_p2p_ps_timer(sc, avp);
 }
 
 static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
@@ -1791,6 +1785,7 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
+	unsigned long flags;
 	int slottime;
 
 	ath9k_ps_wakeup(sc);
@@ -1853,7 +1848,10 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_P2P_PS) {
 		spin_lock_bh(&sc->sc_pcu_lock);
-		ath9k_update_p2p_ps(sc, vif);
+		spin_lock_irqsave(&sc->sc_pm_lock, flags);
+		if (!(sc->ps_flags & PS_BEACON_SYNC))
+			ath9k_update_p2p_ps(sc, vif);
+		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 		spin_unlock_bh(&sc->sc_pcu_lock);
 	}
 
-- 
1.9.3

