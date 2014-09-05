Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39510 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaIEEUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 00:20:43 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 3/3] ath9k: Fix MCC scanning
Date: Fri,  5 Sep 2014 09:50:57 +0530
Message-Id: <1409890857-6276-4-git-send-email-sujith@msujith.org> (sfid-20140905_062048_680920_6D3B3D72)
In-Reply-To: <1409890857-6276-1-git-send-email-sujith@msujith.org>
References: <1409890857-6276-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Scanning is curently broken when two channel contexts
are active. For example in a P2P-GO/STA setup, the
offchannel timer allows HZ / 10 to elapse before initiating
a switch to the next scan channel from the current operating
channel, which in this case would be the P2P-GO context.

But, the channel context timer might decide to switch
to the STA context when an SWBA comes early and a beacon
is sent out. Since pending offchannel requests are processed
in EVENT_BEACON_PREPARE, this causes inconsistent scanning.

Fix this by making sure that a context switch happens
before processing the pending offchannel request. This
also makes sure that active channel contexts will always
have higher priority than offchannel operations and the
scan sequence looks like this:

p2p-go, sta, p2p-go, offchannel, p2p-go, sta, p2p-go, offchannel,.....

The oper-channel is p2p-go, so the STA context has to
switch to p2p-go again before switching offchannel.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   | 1 +
 drivers/net/wireless/ath/ath9k/channel.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 46a1d2e..0c071b0 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -378,6 +378,7 @@ enum ath_chanctx_state {
 struct ath_chanctx_sched {
 	bool beacon_pending;
 	bool offchannel_pending;
+	bool wait_switch;
 	enum ath_chanctx_state state;
 	u8 beacon_miss;
 
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index a31f526..522894b 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -333,7 +333,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			break;
 		}
 
-		if (sc->sched.offchannel_pending) {
+		if (sc->sched.offchannel_pending && !sc->sched.wait_switch) {
 			sc->sched.offchannel_pending = false;
 			sc->next_chan = &sc->offchannel.chan;
 			sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_BEACON;
@@ -490,6 +490,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			"Move chanctx state to WAIT_FOR_TIMER (event SWITCH)\n");
 
 		sc->sched.state = ATH_CHANCTX_STATE_WAIT_FOR_TIMER;
+		sc->sched.wait_switch = false;
 
 		tsf_time = TU_TO_USEC(cur_conf->beacon_interval) / 2;
 		if (sc->sched.beacon_miss >= 2) {
@@ -588,6 +589,7 @@ static void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 	if (test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags) &&
 	    (sc->cur_chan != ctx) && (ctx == &sc->offchannel.chan)) {
 		sc->sched.offchannel_pending = true;
+		sc->sched.wait_switch = true;
 		if (chandef)
 			ctx->chandef = *chandef;
 		spin_unlock_bh(&sc->chan_lock);
-- 
2.1.0

