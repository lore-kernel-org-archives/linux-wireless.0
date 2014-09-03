Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58754 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbaICDJY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 23:09:24 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 5/6] ath9k: Fix offchannel duration calculation
Date: Wed,  3 Sep 2014 08:39:24 +0530
Message-Id: <1409713765-9358-6-git-send-email-sujith@msujith.org> (sfid-20140903_050950_579541_76AEC232)
In-Reply-To: <1409713765-9358-1-git-send-email-sujith@msujith.org>
References: <1409713765-9358-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Currently, different units are used for handling
sc->offchannel.duration. In scan mode, it contains jiffies and in RoC
mode, milliseconds is used. This causes confusion since in
ath_chanctx_switch(), TU_TO_USEC is used to determine the offchannel
duration, resulting in incorrect values. Fix this by using jiffies in
both modes.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 047a76f..7a6ca44 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -601,7 +601,7 @@ static void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 
 	if (sc->next_chan == &sc->offchannel.chan) {
 		sc->sched.offchannel_duration =
-			TU_TO_USEC(sc->offchannel.duration) +
+			jiffies_to_usecs(sc->offchannel.duration) +
 			sc->sched.channel_switch_time;
 
 		if (chandef) {
@@ -688,7 +688,8 @@ void ath_offchannel_next(struct ath_softc *sc)
 	} else if (sc->offchannel.roc_vif) {
 		vif = sc->offchannel.roc_vif;
 		sc->offchannel.chan.txpower = vif->bss_conf.txpower;
-		sc->offchannel.duration = sc->offchannel.roc_duration;
+		sc->offchannel.duration =
+			msecs_to_jiffies(sc->offchannel.roc_duration);
 		sc->offchannel.state = ATH_OFFCHANNEL_ROC_START;
 		ath_chanctx_offchan_switch(sc, sc->offchannel.roc_chan);
 	} else {
@@ -959,8 +960,8 @@ static void ath_offchannel_channel_change(struct ath_softc *sc)
 			break;
 
 		sc->offchannel.state = ATH_OFFCHANNEL_ROC_WAIT;
-		mod_timer(&sc->offchannel.timer, jiffies +
-			  msecs_to_jiffies(sc->offchannel.duration));
+		mod_timer(&sc->offchannel.timer,
+			  jiffies + sc->offchannel.duration);
 		ieee80211_ready_on_channel(sc->hw);
 		break;
 	case ATH_OFFCHANNEL_ROC_DONE:
-- 
2.1.0

