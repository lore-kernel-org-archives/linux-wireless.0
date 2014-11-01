Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37245 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaKAHEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2014 03:04:21 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH] ath9k: Clear offchannel state properly
Date: Sat,  1 Nov 2014 12:35:40 +0530
Message-Id: <1414825540-9064-1-git-send-email-sujith@msujith.org> (sfid-20141101_080429_856856_4868987E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When a pending roc or scan operation is cancelled,
the offchannel operation is cleared, but the offchannel
state in the main scheduler is not cleared. This causes
problems since an active GO will try to process a stale
offchannel request that was deferred earlier. Fix this
by clearing the state when there is no pending offchannel
(roc/scan) operation.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index c7234d5..89ef61a 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -900,6 +900,11 @@ void ath_offchannel_next(struct ath_softc *sc)
 		sc->offchannel.state = ATH_OFFCHANNEL_ROC_START;
 		ath_chanctx_offchan_switch(sc, sc->offchannel.roc_chan);
 	} else {
+		spin_lock_bh(&sc->chan_lock);
+		sc->sched.offchannel_pending = false;
+		sc->sched.wait_switch = false;
+		spin_unlock_bh(&sc->chan_lock);
+
 		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc, false),
 				   NULL);
 		sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
-- 
2.1.3

