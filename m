Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:55116 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaKPAjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 19:39:52 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 08/11] ath9k: Cancel pending offchannel operations
Date: Sun, 16 Nov 2014 06:11:07 +0530
Message-Id: <1416098470-14122-9-git-send-email-sujith@msujith.org> (sfid-20141116_013956_288615_7B68E123)
In-Reply-To: <1416098470-14122-1-git-send-email-sujith@msujith.org>
References: <1416098470-14122-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch makes sure that pending roc/scan
operations are cancelled properly when a new
context is assigned/unassigned.

The flush_work() call to flush out any scheduled
channel context work is removed, instead, sc->mutex
is dropped to allow any pending work to get a chance
to complete by the channel scheduler. Also, increase
the timeout to allow a switch to an active GO.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 43 ++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5d5d8b4..e86189f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2198,6 +2198,28 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 
+static void ath9k_cancel_pending_offchannel(struct ath_softc *sc)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	if (sc->offchannel.roc_vif) {
+		ath_dbg(common, CHAN_CTX,
+			"%s: Aborting RoC\n", __func__);
+
+		del_timer_sync(&sc->offchannel.timer);
+		if (sc->offchannel.state >= ATH_OFFCHANNEL_ROC_START)
+			ath_roc_complete(sc, true);
+	}
+
+	if (test_bit(ATH_OP_SCANNING, &common->op_flags)) {
+		ath_dbg(common, CHAN_CTX,
+			"%s: Aborting HW scan\n", __func__);
+
+		del_timer_sync(&sc->offchannel.timer);
+		ath_scan_complete(sc, true);
+	}
+}
+
 static int ath9k_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 struct ieee80211_scan_request *hw_req)
 {
@@ -2384,6 +2406,8 @@ static int ath9k_assign_vif_chanctx(struct ieee80211_hw *hw,
 	struct ath_chanctx *ctx = ath_chanctx_get(conf);
 	int i;
 
+	ath9k_cancel_pending_offchannel(sc);
+
 	mutex_lock(&sc->mutex);
 
 	ath_dbg(common, CHAN_CTX,
@@ -2413,6 +2437,8 @@ static void ath9k_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	struct ath_chanctx *ctx = ath_chanctx_get(conf);
 	int ac;
 
+	ath9k_cancel_pending_offchannel(sc);
+
 	mutex_lock(&sc->mutex);
 
 	ath_dbg(common, CHAN_CTX,
@@ -2458,18 +2484,7 @@ static void ath9k_mgd_prepare_tx(struct ieee80211_hw *hw,
 	if (!changed)
 		goto out;
 
-	if (test_bit(ATH_OP_SCANNING, &common->op_flags)) {
-		ath_dbg(common, CHAN_CTX,
-			"%s: Aborting HW scan\n", __func__);
-
-		mutex_unlock(&sc->mutex);
-
-		del_timer_sync(&sc->offchannel.timer);
-		ath_scan_complete(sc, true);
-		flush_work(&sc->chanctx_work);
-
-		mutex_lock(&sc->mutex);
-	}
+	ath9k_cancel_pending_offchannel(sc);
 
 	go_ctx = ath_is_go_chanctx_present(sc);
 
@@ -2484,13 +2499,15 @@ static void ath9k_mgd_prepare_tx(struct ieee80211_hw *hw,
 		beacon_int = TU_TO_USEC(cur_conf->beacon_interval);
 		spin_unlock_bh(&sc->chan_lock);
 
-		timeout = usecs_to_jiffies(beacon_int);
+		timeout = usecs_to_jiffies(beacon_int * 2);
 		init_completion(&sc->go_beacon);
 
+		mutex_unlock(&sc->mutex);
 		if (wait_for_completion_timeout(&sc->go_beacon,
 						timeout) == 0)
 			ath_dbg(common, CHAN_CTX,
 				"Failed to send new NoA\n");
+		mutex_lock(&sc->mutex);
 	}
 
 	ath_dbg(common, CHAN_CTX,
-- 
2.1.3

