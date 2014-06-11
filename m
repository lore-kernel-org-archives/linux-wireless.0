Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11779 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaFKKub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:50:31 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 25/28] ath9k: Update channel switch timer
Date: Wed, 11 Jun 2014 16:18:13 +0530
Message-ID: <1402483696-2498-26-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_130456_611316_C04EA73B)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

TSF time might have been updated by the incoming beacon,
need update the channel switch timer to reflect the change.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 55165d5..0a38eea 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -589,6 +589,17 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		ath_chanctx_adjust_tbtt_delta(sc);
 		sc->sched.beacon_pending = false;
 		sc->sched.beacon_miss = 0;
+
+		/* TSF time might have been updated by the incoming beacon,
+		 * need update the channel switch timer to reflect the change.
+		 */
+		tsf_time = sc->sched.switch_start_time;
+		tsf_time -= (u32) sc->cur_chan->tsf_val +
+			ath9k_hw_get_tsf_offset(&sc->cur_chan->tsf_ts, NULL);
+		tsf_time += ath9k_hw_gettsf32(ah);
+
+		ath9k_hw_gen_timer_start(ah, sc->p2p_ps_timer,
+					 tsf_time, 1000000);
 		break;
 	case ATH_CHANCTX_EVENT_ASSOC:
 		if (sc->sched.state != ATH_CHANCTX_STATE_FORCE_ACTIVE ||
-- 
2.0.0

