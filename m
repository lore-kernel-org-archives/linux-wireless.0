Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:57765 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaIEEUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 00:20:41 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 2/3] ath9k: Fix offchannel operation
Date: Fri,  5 Sep 2014 09:50:56 +0530
Message-Id: <1409890857-6276-3-git-send-email-sujith@msujith.org> (sfid-20140905_062046_953269_18826F57)
In-Reply-To: <1409890857-6276-1-git-send-email-sujith@msujith.org>
References: <1409890857-6276-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When multiple channel contexts are active, an offchannel
request will not be handled immediately, but will be
queued to be handled later. But, currently, the channel definition
is not copied to the local offchannel state. This
breaks operation like scanning when MCC is active.

Fix this by storing the offchannel parameters properly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index e73d305..a31f526 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -588,7 +588,11 @@ static void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 	if (test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags) &&
 	    (sc->cur_chan != ctx) && (ctx == &sc->offchannel.chan)) {
 		sc->sched.offchannel_pending = true;
+		if (chandef)
+			ctx->chandef = *chandef;
 		spin_unlock_bh(&sc->chan_lock);
+		ath_dbg(common, CHAN_CTX,
+			"Set offchannel_pending to true\n");
 		return;
 	}
 
-- 
2.1.0

