Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:48558 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbaJFFtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 01:49:00 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 6/6] ath9k: Process beacons properly
Date: Mon,  6 Oct 2014 11:19:39 +0530
Message-Id: <1412574579-22532-7-git-send-email-sujith@msujith.org> (sfid-20141006_074909_267707_6B055576)
In-Reply-To: <1412574579-22532-1-git-send-email-sujith@msujith.org>
References: <1412574579-22532-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When the current operating channel context has
been marked as ATH_CHANCTX_STATE_FORCE_ACTIVE,
do not process beacons that might be received,
since we have to wait for the station to become
authorized.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 16bed6a..55f2369 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -492,7 +492,8 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		break;
 	case ATH_CHANCTX_EVENT_BEACON_RECEIVED:
 		if (!test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags) ||
-		    sc->cur_chan == &sc->offchannel.chan)
+		    sc->cur_chan == &sc->offchannel.chan ||
+		    sc->sched.state == ATH_CHANCTX_STATE_FORCE_ACTIVE)
 			break;
 
 		ath_chanctx_adjust_tbtt_delta(sc);
-- 
2.1.2

