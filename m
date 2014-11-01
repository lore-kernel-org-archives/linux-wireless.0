Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:43945 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaKAHDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2014 03:03:05 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH] ath9k: Cancel pending offchannel operations
Date: Sat,  1 Nov 2014 12:34:19 +0530
Message-Id: <1414825459-8974-1-git-send-email-sujith@msujith.org> (sfid-20141101_080315_525319_EA156957)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

In mgd_prepare_tx(), any pending HW scan is cancelled,
but pending RoC operations are not cancelled. This
results in a RoC request that never completes. For example,
in a GO/STA setup, if p2p-find is initiated on an active GO
interface wpa_s issues a RoC on the listen channel at the
end of each scan run.

Enabling the station interface will force the station context
and the earlier RoC is not cleared. Fix this by clearing all
pending offchannel operations in mgd_prepare_tx().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 40 ++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a91ee92..cedc056 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2498,6 +2498,31 @@ static void ath9k_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	mutex_unlock(&sc->mutex);
 }
 
+static void ath9k_cancel_pending_offchannel(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
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
+
+	flush_work(&sc->chanctx_work);
+}
+
 static void ath9k_mgd_prepare_tx(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif)
 {
@@ -2526,18 +2551,9 @@ static void ath9k_mgd_prepare_tx(struct ieee80211_hw *hw,
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
+	mutex_unlock(&sc->mutex);
+	ath9k_cancel_pending_offchannel(hw);
+	mutex_lock(&sc->mutex);
 
 	go_ctx = ath_is_go_chanctx_present(sc);
 
-- 
2.1.3

