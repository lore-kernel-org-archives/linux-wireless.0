Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:35426 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbbK0Ihd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:37:33 -0500
Received: by lfdl133 with SMTP id l133so120690314lfd.2
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 00:37:31 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 08/13] ath9k: P2P_CLIENT, get/set NOA correctly
Date: Fri, 27 Nov 2015 09:37:13 +0100
Message-Id: <1448613438-5173-8-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151127_093742_108146_1CA32DC1)
In-Reply-To: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
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
index 31b4d0e..5a1ede6 100644
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

