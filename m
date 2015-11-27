Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:34315 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbbK0Ih3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:37:29 -0500
Received: by lffu14 with SMTP id u14so121541100lff.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 00:37:28 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 05/13] ath9k: use u32 when calculate tsf
Date: Fri, 27 Nov 2015 09:37:10 +0100
Message-Id: <1448613438-5173-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151127_093748_014735_06BD61BE)
In-Reply-To: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use u32 while ath9k_hw_gettsf32() and
ath9k_hw_gen_timer_start() require u32.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 5640e88..28bbbef 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1405,7 +1405,7 @@ static void ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_hw *ah = sc->sc_ah;
-	s32 tsf, target_tsf;
+	u32 tsf, target_tsf;
 
 	if (!avp || !avp->noa.has_next_tsf)
 		return;
@@ -1427,7 +1427,7 @@ static void ath9k_update_p2p_ps_timer(struct ath_softc *sc, struct ath_vif *avp)
 		__func__, avp->noa.absent, tsf, target_tsf,
 		(target_tsf - tsf) / 1000);
 
-	ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, (u32) target_tsf, 1000000);
+	ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, target_tsf, 1000000);
 }
 
 static void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif)
-- 
1.9.1

