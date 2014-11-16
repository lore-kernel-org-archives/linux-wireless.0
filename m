Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51462 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbaKPAj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 19:39:57 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 11/11] ath9k: Move roc completion to the offchannel timer
Date: Sun, 16 Nov 2014 06:11:10 +0530
Message-Id: <1416098470-14122-12-git-send-email-sujith@msujith.org> (sfid-20141116_014346_323247_C0AF947A)
In-Reply-To: <1416098470-14122-1-git-send-email-sujith@msujith.org>
References: <1416098470-14122-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Currently, when a roc period expires, the offchannel
timer calls ieee80211_remain_on_channel_expired(), but
the roc state is cleared only when the queued work
to switch to the operating channel gets a chance to run.

This race is a problem because mac80211 can issue a
new roc request in this window. To avoid this, handle
roc completion in the offchannel timer itself.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 99425fe..794d520 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -926,8 +926,7 @@ void ath_roc_complete(struct ath_softc *sc, bool abort)
 
 	sc->offchannel.roc_vif = NULL;
 	sc->offchannel.roc_chan = NULL;
-	if (abort)
-		ieee80211_remain_on_channel_expired(sc->hw);
+	ieee80211_remain_on_channel_expired(sc->hw);
 	ath_offchannel_next(sc);
 	ath9k_ps_restore(sc);
 }
@@ -1058,10 +1057,8 @@ static void ath_offchannel_timer(unsigned long data)
 		break;
 	case ATH_OFFCHANNEL_ROC_START:
 	case ATH_OFFCHANNEL_ROC_WAIT:
-		ctx = ath_chanctx_get_oper_chan(sc, false);
 		sc->offchannel.state = ATH_OFFCHANNEL_ROC_DONE;
-		ieee80211_remain_on_channel_expired(sc->hw);
-		ath_chanctx_switch(sc, ctx, NULL);
+		ath_roc_complete(sc, false);
 		break;
 	default:
 		break;
@@ -1191,7 +1188,6 @@ static void ath_offchannel_channel_change(struct ath_softc *sc)
 		ieee80211_ready_on_channel(sc->hw);
 		break;
 	case ATH_OFFCHANNEL_ROC_DONE:
-		ath_roc_complete(sc, false);
 		break;
 	default:
 		break;
-- 
2.1.3

