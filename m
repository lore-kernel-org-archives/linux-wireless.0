Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39647 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYIQEsK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 00:48:10 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18640.35727.109578.807445@gargle.gargle.HOWL> (sfid-20080917_064812_968307_D9BA95B8)
Date: Wed, 17 Sep 2008 10:16:07 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/3] ath9k: Fix TSF Adjust usage
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TSF adjust is needed only for AP mode when staggered beacons
are used. Since we support only a single interface in IBSS mode,
disable setting the TSF adjust register.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index c262ef2..690f7c5 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -534,7 +534,8 @@ int ath_vap_attach(struct ath_softc *sc,
 	avp->av_opmode = opmode;
 	avp->av_bslot = -1;
 
-	ath9k_hw_set_tsfadjust(sc->sc_ah, 1);
+	if (opmode == ATH9K_M_HOSTAP)
+		ath9k_hw_set_tsfadjust(sc->sc_ah, 1);
 
 	sc->sc_vaps[if_id] = avp;
 	sc->sc_nvaps++;
-- 
1.6.0.2

