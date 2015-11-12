Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:33994 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbbKLNQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 08:16:21 -0500
Received: by lffu14 with SMTP id u14so33762952lff.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 05:16:19 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 08/12] ath9k: P2P_CLIENT, get/set NOA correctly
Date: Thu, 12 Nov 2015 14:15:45 +0100
Message-Id: <1447334149-15507-8-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151112_144409_217809_3E0BE16E)
In-Reply-To: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case we get BSS_CHANGED_P2P_PS early, from
mac80211, we didn't set NOA timer correctly,
while p2p_ps_vif was NULL.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 2615392..db49bc5 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1443,6 +1443,10 @@ static void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif)
 		return;
 
 	sc->p2p_ps_vif = avp;
+
+	if (sc->ps_flags & PS_BEACON_SYNC)
+		return;
+
 	tsf = ath9k_hw_gettsf32(sc->sc_ah);
 	ieee80211_parse_p2p_noa(&vif->bss_conf.p2p_noa_attr, &avp->noa, tsf);
 	ath9k_update_p2p_ps_timer(sc, avp);
@@ -1585,8 +1589,7 @@ void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
 
 	spin_lock_bh(&sc->sc_pcu_lock);
 	spin_lock_irqsave(&sc->sc_pm_lock, flags);
-	if (!(sc->ps_flags & PS_BEACON_SYNC))
-		ath9k_update_p2p_ps(sc, vif);
+	ath9k_update_p2p_ps(sc, vif);
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 	spin_unlock_bh(&sc->sc_pcu_lock);
 }
-- 
1.9.1

