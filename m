Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:50446 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaHSJTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 05:19:47 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 2/3] ath9k: Handle failure to allocate HW timer
Date: Tue, 19 Aug 2014 14:03:32 +0530
Message-Id: <1408437213-3363-2-git-send-email-sujith@msujith.org> (sfid-20140819_111950_235176_CA0EF8B8)
In-Reply-To: <1408437213-3363-1-git-send-email-sujith@msujith.org>
References: <1408437213-3363-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 76771f3..4219e7b 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -601,7 +601,9 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 		goto err_btcoex;
 
 	sc->p2p_ps_timer = ath_gen_timer_alloc(sc->sc_ah, ath9k_p2p_ps_timer,
-		NULL, sc, AR_FIRST_NDP_TIMER);
+					       NULL, sc, AR_FIRST_NDP_TIMER);
+	if (!sc->p2p_ps_timer)
+		goto err_btcoex;
 
 	ath9k_cmn_init_crypto(sc->sc_ah);
 	ath9k_init_misc(sc);
-- 
2.0.4

