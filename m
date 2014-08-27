Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:49677 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762AbaH0GhW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 02:37:22 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 4/4] ath9k: Fix channel context timer
Date: Wed, 27 Aug 2014 12:07:25 +0530
Message-Id: <1409121445-11484-5-git-send-email-sujith@msujith.org> (sfid-20140827_083729_789916_44D6418B)
In-Reply-To: <1409121445-11484-1-git-send-email-sujith@msujith.org>
References: <1409121445-11484-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Setup the channel context correctly. Not doing this was
causing beacon loss in a P2P-GO/STA concurrent setup.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 8a70915..a8082df 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -294,7 +294,7 @@ static void ath_chanctx_setup_timer(struct ath_softc *sc, u32 tsf_time)
 	ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, tsf_time, 1000000);
 	tsf_time -= ath9k_hw_gettsf32(ah);
 	tsf_time = msecs_to_jiffies(tsf_time / 1000) + 1;
-	mod_timer(&sc->sched.timer, tsf_time);
+	mod_timer(&sc->sched.timer, jiffies + tsf_time);
 
 	ath_dbg(common, CHAN_CTX,
 		"Setup chanctx timer with timeout: %d ms\n", jiffies_to_msecs(tsf_time));
-- 
2.1.0

