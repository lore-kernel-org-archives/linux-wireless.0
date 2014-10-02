Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46136 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaJBBDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 21:03:13 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 10/10] ath9k: Fix flushing in MCC mode
Date: Thu,  2 Oct 2014 06:33:20 +0530
Message-Id: <1412211800-24344-11-git-send-email-sujith@msujith.org> (sfid-20141002_030317_293169_E6FEA1CF)
In-Reply-To: <1412211800-24344-1-git-send-email-sujith@msujith.org>
References: <1412211800-24344-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When we are attempting to switch to a new
channel context, the TX queues are flushed, but
the mac80211 queues are not stopped and traffic
can still come down to the driver.

This patch fixes it by stopping the queues
assigned to the current context/vif before
trying to flush.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index bf5ecd8..945c898 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1044,9 +1044,11 @@ static void ath_offchannel_channel_change(struct ath_softc *sc)
 void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_chanctx *old_ctx;
 	struct timespec ts;
 	bool measure_time = false;
 	bool send_ps = false;
+	bool queues_stopped = false;
 
 	spin_lock_bh(&sc->chan_lock);
 	if (!sc->next_chan) {
@@ -1076,6 +1078,10 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 			getrawmonotonic(&ts);
 			measure_time = true;
 		}
+
+		ath9k_chanctx_stop_queues(sc, sc->cur_chan);
+		queues_stopped = true;
+
 		__ath9k_flush(sc->hw, ~0, true);
 
 		if (ath_chanctx_send_ps_frame(sc, true))
@@ -1089,6 +1095,7 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 			sc->cur_chan->tsf_val = ath9k_hw_gettsf64(sc->sc_ah);
 		}
 	}
+	old_ctx = sc->cur_chan;
 	sc->cur_chan = sc->next_chan;
 	sc->cur_chan->stopped = false;
 	sc->next_chan = NULL;
@@ -1111,7 +1118,16 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 		if (measure_time)
 			sc->sched.channel_switch_time =
 				ath9k_hw_get_tsf_offset(&ts, NULL);
+		/*
+		 * A reset will ensure that all queues are woken up,
+		 * so there is no need to awaken them again.
+		 */
+		goto out;
 	}
+
+	if (queues_stopped)
+		ath9k_chanctx_wake_queues(sc, old_ctx);
+out:
 	if (send_ps)
 		ath_chanctx_send_ps_frame(sc, false);
 
-- 
2.1.1

