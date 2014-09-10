Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:52922 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaIJNpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:45:44 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 1/5] ath9k: Assign offchannel duration properly
Date: Wed, 10 Sep 2014 19:15:56 +0530
Message-Id: <1410356760-10901-2-git-send-email-sujith@msujith.org> (sfid-20140910_154549_819621_4DA819FB)
In-Reply-To: <1410356760-10901-1-git-send-email-sujith@msujith.org>
References: <1410356760-10901-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

In multi-channel mode, an offchannel request will
be deferred if both contexts are active. The duration
of the offchannel operation is calculated but is
not stored in the scheduler state. Fix this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 522894b..ae575cb 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -588,10 +588,15 @@ static void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 
 	if (test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags) &&
 	    (sc->cur_chan != ctx) && (ctx == &sc->offchannel.chan)) {
-		sc->sched.offchannel_pending = true;
-		sc->sched.wait_switch = true;
 		if (chandef)
 			ctx->chandef = *chandef;
+
+		sc->sched.offchannel_pending = true;
+		sc->sched.wait_switch = true;
+		sc->sched.offchannel_duration =
+			jiffies_to_usecs(sc->offchannel.duration) +
+			sc->sched.channel_switch_time;
+
 		spin_unlock_bh(&sc->chan_lock);
 		ath_dbg(common, CHAN_CTX,
 			"Set offchannel_pending to true\n");
-- 
2.1.0

