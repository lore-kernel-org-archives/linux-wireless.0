Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:42760 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaICHzT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 03:55:19 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 1/5] ath9k: Fix RX filter calculation
Date: Wed,  3 Sep 2014 13:25:25 +0530
Message-Id: <1409730929-30208-2-git-send-email-sujith@msujith.org> (sfid-20140903_095534_235351_9388B8B9)
In-Reply-To: <1409730929-30208-1-git-send-email-sujith@msujith.org>
References: <1409730929-30208-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

If multiple channel contexts are active, then the opmode
can be different in each context. Since the RX filter is
calculated in ath_startrecv() before switching to the
new opmode, the wrong filters are chosen.

Fix this by calling ath9k_calculate_summary_state() before
the RX module is started.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2333776..5d9f4d7 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -224,6 +224,8 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	struct ath_common *common = ath9k_hw_common(ah);
 	unsigned long flags;
 
+	ath9k_calculate_summary_state(sc, sc->cur_chan);
+
 	if (ath_startrecv(sc) != 0) {
 		ath_err(common, "Unable to restart recv logic\n");
 		return false;
@@ -233,7 +235,6 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 			       sc->cur_chan->txpower, &sc->curtxpow);
 
 	clear_bit(ATH_OP_HW_RESET, &common->op_flags);
-	ath9k_calculate_summary_state(sc, sc->cur_chan);
 
 	if (!sc->cur_chan->offchannel && start) {
 		/* restore per chanctx TSF timer */
-- 
2.1.0

