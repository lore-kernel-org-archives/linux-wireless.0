Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54474 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaJNEAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 00:00:12 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 9/9] ath9k: Improve flush() in mcc mode
Date: Tue, 14 Oct 2014 09:30:56 +0530
Message-Id: <1413259256-4808-10-git-send-email-sujith@msujith.org> (sfid-20141014_060034_742729_07928160)
In-Reply-To: <1413259256-4808-1-git-send-email-sujith@msujith.org>
References: <1413259256-4808-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The flush timeout in MCC mode is very small, since
we are constrained by the time slice for each
channel context, but since only the HW queues are
flushed when switching contexts, it is acceptable.

Since the SW queues are also emptied in the mac80211 flush()
callback, a larger duration is needed. Add an override
argument to __ath9k_flush() and set it when flush()
is called in MCC mode. This allows the driver to
drain both the SW and HW queues.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  2 +-
 drivers/net/wireless/ath/ath9k/channel.c |  4 ++--
 drivers/net/wireless/ath/ath9k/main.c    | 28 +++++++++++++++++++++++++---
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7ac1b06..85d74ff 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -719,7 +719,7 @@ void ath_update_survey_nf(struct ath_softc *sc, int channel);
 void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type);
 void ath_ps_full_sleep(unsigned long data);
 void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop,
-		   bool sw_pending);
+		   bool sw_pending, bool timeout_override);
 
 /**********/
 /* BTCOEX */
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 25b898e..c7234d5 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1232,11 +1232,11 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 		ath9k_chanctx_stop_queues(sc, sc->cur_chan);
 		queues_stopped = true;
 
-		__ath9k_flush(sc->hw, ~0, true, false);
+		__ath9k_flush(sc->hw, ~0, true, false, false);
 
 		if (ath_chanctx_send_ps_frame(sc, true))
 			__ath9k_flush(sc->hw, BIT(IEEE80211_AC_VO),
-				      false, false);
+				      false, false, false);
 
 		send_ps = true;
 		spin_lock_bh(&sc->chan_lock);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a524eeb..961a388 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2031,14 +2031,33 @@ static void ath9k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			u32 queues, bool drop)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	if (ath9k_is_chanctx_enabled()) {
+		if (!test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags))
+			goto flush;
 
+		/*
+		 * If MCC is active, extend the flush timeout
+		 * and wait for the HW/SW queues to become
+		 * empty. This needs to be done outside the
+		 * sc->mutex lock to allow the channel scheduler
+		 * to switch channel contexts.
+		 *
+		 * The vif queues have been stopped in mac80211,
+		 * so there won't be any incoming frames.
+		 */
+		__ath9k_flush(hw, queues, drop, true, true);
+		return;
+	}
+flush:
 	mutex_lock(&sc->mutex);
-	__ath9k_flush(hw, queues, drop, true);
+	__ath9k_flush(hw, queues, drop, true, false);
 	mutex_unlock(&sc->mutex);
 }
 
 void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop,
-		   bool sw_pending)
+		   bool sw_pending, bool timeout_override)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
@@ -2059,7 +2078,10 @@ void __ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop,
 	}
 
 	spin_lock_bh(&sc->chan_lock);
-	timeout = sc->cur_chan->flush_timeout;
+	if (timeout_override)
+		timeout = HZ / 5;
+	else
+		timeout = sc->cur_chan->flush_timeout;
 	spin_unlock_bh(&sc->chan_lock);
 
 	ath_dbg(common, CHAN_CTX,
-- 
2.1.2

