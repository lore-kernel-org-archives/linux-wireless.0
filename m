Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:55758 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbaJQCK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 22:10:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 21/23] ath9k: Fix HW scan abort
Date: Fri, 17 Oct 2014 07:40:28 +0530
Message-Id: <1413511830-5536-22-git-send-email-sujith@msujith.org> (sfid-20141017_041325_081617_899BA56D)
In-Reply-To: <1413511830-5536-1-git-send-email-sujith@msujith.org>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Instead of using ATH_CHANCTX_EVENT_ASSIGN to abort
a HW scan when a new interface becomes active, use the
mgd_prepare_tx() callback. This allows us to make
sure that the GO's channel becomes operational by
using flush_work().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 16 ----------------
 drivers/net/wireless/ath/ath9k/main.c    | 14 +++++++++++++-
 2 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 366a4d9..25b898e 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -743,22 +743,6 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		ieee80211_queue_work(sc->hw, &sc->chanctx_work);
 		break;
 	case ATH_CHANCTX_EVENT_ASSIGN:
-		/*
-		 * When adding a new channel context, check if a scan
-		 * is in progress and abort it since the addition of
-		 * a new channel context is usually followed by VIF
-		 * assignment, in which case we have to start multi-channel
-		 * operation.
-		 */
-		if (test_bit(ATH_OP_SCANNING, &common->op_flags)) {
-			ath_dbg(common, CHAN_CTX,
-				"Aborting HW scan to add new context\n");
-
-			spin_unlock_bh(&sc->chan_lock);
-			del_timer_sync(&sc->offchannel.timer);
-			ath_scan_complete(sc, true);
-			spin_lock_bh(&sc->chan_lock);
-		}
 		break;
 	case ATH_CHANCTX_EVENT_CHANGE:
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f58781a..a524eeb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2365,7 +2365,6 @@ static int ath9k_add_chanctx(struct ieee80211_hw *hw,
 			conf->def.chan->center_freq);
 
 		ath_chanctx_set_channel(sc, ctx, &conf->def);
-		ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_ASSIGN);
 
 		mutex_unlock(&sc->mutex);
 		return 0;
@@ -2496,6 +2495,19 @@ static void ath9k_mgd_prepare_tx(struct ieee80211_hw *hw,
 	if (!changed)
 		goto out;
 
+	if (test_bit(ATH_OP_SCANNING, &common->op_flags)) {
+		ath_dbg(common, CHAN_CTX,
+			"%s: Aborting HW scan\n", __func__);
+
+		mutex_unlock(&sc->mutex);
+
+		del_timer_sync(&sc->offchannel.timer);
+		ath_scan_complete(sc, true);
+		flush_work(&sc->chanctx_work);
+
+		mutex_lock(&sc->mutex);
+	}
+
 	go_ctx = ath_is_go_chanctx_present(sc);
 
 	if (go_ctx) {
-- 
2.1.2

