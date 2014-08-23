Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35368 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaHWNmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 09:42:17 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 2/4] ath9k: Remove redundant ifdef
Date: Sat, 23 Aug 2014 19:12:14 +0530
Message-Id: <1408801336-7626-3-git-send-email-sujith@msujith.org> (sfid-20140823_154229_641965_9B5D3269)
In-Reply-To: <1408801336-7626-1-git-send-email-sujith@msujith.org>
References: <1408801336-7626-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This was introduced in an earlier patch to handle
a compilation warning, but since the channel context
code has been mostly isolated, this is not required now.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 08bb14c..7aa9535 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -257,9 +257,7 @@ static void ath_chanctx_setup_timer(struct ath_softc *sc, u32 tsf_time)
 {
 	struct ath_hw *ah = sc->sc_ah;
 
-#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 	ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer, tsf_time, 1000000);
-#endif
 	tsf_time -= ath9k_hw_gettsf32(ah);
 	tsf_time = msecs_to_jiffies(tsf_time / 1000) + 1;
 	mod_timer(&sc->sched.timer, tsf_time);
-- 
2.0.4

