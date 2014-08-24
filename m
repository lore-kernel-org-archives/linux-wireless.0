Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59176 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaHXPqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2014 11:46:18 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 4/4] ath9k: Fix channel context creation
Date: Sun, 24 Aug 2014 21:16:13 +0530
Message-Id: <1408895173-3732-5-git-send-email-sujith@msujith.org> (sfid-20140824_174620_704589_947AC398)
In-Reply-To: <1408895173-3732-1-git-send-email-sujith@msujith.org>
References: <1408895173-3732-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

If a new context is being added in addition to the current one,
then send the ASSIGN event to abort a running scan since
the addition of a context is usually followed by VIF
assignment and further operations.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 22 +++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/main.c    |  2 ++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 9be92d8..b369c48 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -127,6 +127,7 @@ void ath_chanctx_init(struct ath_softc *sc)
 void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 			     struct cfg80211_chan_def *chandef)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	bool cur_chan;
 
 	spin_lock_bh(&sc->chan_lock);
@@ -135,8 +136,11 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 	cur_chan = sc->cur_chan == ctx;
 	spin_unlock_bh(&sc->chan_lock);
 
-	if (!cur_chan)
+	if (!cur_chan) {
+		ath_dbg(common, CHAN_CTX,
+			"Current context differs from the new context\n");
 		return;
+	}
 
 	ath_set_channel(sc);
 }
@@ -486,6 +490,22 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		ieee80211_queue_work(sc->hw, &sc->chanctx_work);
 		break;
 	case ATH_CHANCTX_EVENT_ASSIGN:
+		/*
+		 * When adding a new channel context, check if a scan
+		 * is in progress and abort it since the addition of
+		 * a new channel context is usually followed by VIF
+		 * assignment, in which case we have to start multi-channel
+		 * operation.
+		 */
+		if (test_bit(ATH_OP_SCANNING, &common->op_flags)) {
+			ath_dbg(common, CHAN_CTX,
+				"Aborting HW scan to add new context\n");
+
+			spin_unlock_bh(&sc->chan_lock);
+			del_timer_sync(&sc->offchannel.timer);
+			ath_scan_complete(sc, true);
+			spin_lock_bh(&sc->chan_lock);
+		}
 		break;
 	case ATH_CHANCTX_EVENT_CHANGE:
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index da63487..2fcafa6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2236,6 +2236,8 @@ static int ath9k_add_chanctx(struct ieee80211_hw *hw,
 			conf->def.chan->center_freq);
 
 		ath_chanctx_set_channel(sc, ctx, &conf->def);
+		ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_ASSIGN);
+
 		mutex_unlock(&sc->mutex);
 		return 0;
 	}
-- 
2.0.4

