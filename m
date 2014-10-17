Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58806 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaJQCKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 22:10:49 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 19/23] ath9k: Fix RoC expiration
Date: Fri, 17 Oct 2014 07:40:26 +0530
Message-Id: <1413511830-5536-20-git-send-email-sujith@msujith.org> (sfid-20141017_041320_706315_D5A7A171)
In-Reply-To: <1413511830-5536-1-git-send-email-sujith@msujith.org>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

mac80211 has to be notified when a RoC period
expires in the driver. In MCC mode, since the
offchannel/RoC timer is set with the requested
duration, ieee80211_remain_on_channel_expired() needs
to be called when the timer expires.

But, currently it is done after we move back to
the operating channel. This is incorrect - fix this
by calling ieee80211_remain_on_channel_expired() when
the RoC timer expires and in ath_roc_complete() when
the RoC request is aborted.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 7fe35a5..447b397 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -894,7 +894,7 @@ void ath_roc_complete(struct ath_softc *sc, bool abort)
 
 	sc->offchannel.roc_vif = NULL;
 	sc->offchannel.roc_chan = NULL;
-	if (!abort)
+	if (abort)
 		ieee80211_remain_on_channel_expired(sc->hw);
 	ath_offchannel_next(sc);
 	ath9k_ps_restore(sc);
@@ -1028,6 +1028,7 @@ static void ath_offchannel_timer(unsigned long data)
 	case ATH_OFFCHANNEL_ROC_WAIT:
 		ctx = ath_chanctx_get_oper_chan(sc, false);
 		sc->offchannel.state = ATH_OFFCHANNEL_ROC_DONE;
+		ieee80211_remain_on_channel_expired(sc->hw);
 		ath_chanctx_switch(sc, ctx, NULL);
 		break;
 	default:
-- 
2.1.2

