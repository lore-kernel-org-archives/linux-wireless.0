Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:43645 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaJQCJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 22:09:44 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 03/23] ath9k: Process beacons properly
Date: Fri, 17 Oct 2014 07:40:10 +0530
Message-Id: <1413511830-5536-4-git-send-email-sujith@msujith.org> (sfid-20141017_040952_593343_B1082569)
In-Reply-To: <1413511830-5536-1-git-send-email-sujith@msujith.org>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When the current operating channel context has
been marked as ATH_CHANCTX_STATE_FORCE_ACTIVE,
do not process beacons that might be received,
since we have to wait for the station to become
authorized.

Also, since the cached TSF value will be zero
initially do not rearm the timer in this
case when a beacon is received, since it results
in spurious values.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 16bed6a..135f74c 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -495,10 +495,15 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		    sc->cur_chan == &sc->offchannel.chan)
 			break;
 
-		ath_chanctx_adjust_tbtt_delta(sc);
 		sc->sched.beacon_pending = false;
 		sc->sched.beacon_miss = 0;
 
+		if (sc->sched.state == ATH_CHANCTX_STATE_FORCE_ACTIVE ||
+		    !sc->cur_chan->tsf_val)
+			break;
+
+		ath_chanctx_adjust_tbtt_delta(sc);
+
 		/* TSF time might have been updated by the incoming beacon,
 		 * need update the channel switch timer to reflect the change.
 		 */
-- 
2.1.2

