Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53592 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1IBXkj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 19:40:39 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com, shafi.wireless@gmail.com,
	vthiagar@qca.qualcomm.com
Subject: [PATCH v13 2/5] ath9k: move a few functions around
Date: Sat,  3 Sep 2011 01:40:24 +0200
Message-Id: <1315006827-81443-2-git-send-email-nbd@openwrt.org> (sfid-20110903_014045_986883_04B044A4)
In-Reply-To: <1315006827-81443-1-git-send-email-nbd@openwrt.org>
References: <1315006827-81443-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helps with making ath_reset static in the next commit

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |  137 +++++++++++++++++----------------
 1 files changed, 69 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index da57b2c..9bb222c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -596,74 +596,6 @@ static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 		ath_tx_node_cleanup(sc, an);
 }
 
-void ath_hw_check(struct work_struct *work)
-{
-	struct ath_softc *sc = container_of(work, struct ath_softc, hw_check_work);
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	unsigned long flags;
-	int busy;
-
-	ath9k_ps_wakeup(sc);
-	if (ath9k_hw_check_alive(sc->sc_ah))
-		goto out;
-
-	spin_lock_irqsave(&common->cc_lock, flags);
-	busy = ath_update_survey_stats(sc);
-	spin_unlock_irqrestore(&common->cc_lock, flags);
-
-	ath_dbg(common, ATH_DBG_RESET, "Possible baseband hang, "
-		"busy=%d (try %d)\n", busy, sc->hw_busy_count + 1);
-	if (busy >= 99) {
-		if (++sc->hw_busy_count >= 3) {
-			spin_lock_bh(&sc->sc_pcu_lock);
-			ath_reset(sc, true);
-			spin_unlock_bh(&sc->sc_pcu_lock);
-		}
-	} else if (busy >= 0)
-		sc->hw_busy_count = 0;
-
-out:
-	ath9k_ps_restore(sc);
-}
-
-static void ath_hw_pll_rx_hang_check(struct ath_softc *sc, u32 pll_sqsum)
-{
-	static int count;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-
-	if (pll_sqsum >= 0x40000) {
-		count++;
-		if (count == 3) {
-			/* Rx is hung for more than 500ms. Reset it */
-			ath_dbg(common, ATH_DBG_RESET,
-				"Possible RX hang, resetting");
-			spin_lock_bh(&sc->sc_pcu_lock);
-			ath_reset(sc, true);
-			spin_unlock_bh(&sc->sc_pcu_lock);
-			count = 0;
-		}
-	} else
-		count = 0;
-}
-
-void ath_hw_pll_work(struct work_struct *work)
-{
-	struct ath_softc *sc = container_of(work, struct ath_softc,
-					    hw_pll_work.work);
-	u32 pll_sqsum;
-
-	if (AR_SREV_9485(sc->sc_ah)) {
-
-		ath9k_ps_wakeup(sc);
-		pll_sqsum = ar9003_get_pll_sqsum_dvc(sc->sc_ah);
-		ath9k_ps_restore(sc);
-
-		ath_hw_pll_rx_hang_check(sc, pll_sqsum);
-
-		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work, HZ/5);
-	}
-}
-
 
 void ath9k_tasklet(unsigned long data)
 {
@@ -1037,6 +969,75 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	return r;
 }
 
+void ath_hw_check(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc, hw_check_work);
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	unsigned long flags;
+	int busy;
+
+	ath9k_ps_wakeup(sc);
+	if (ath9k_hw_check_alive(sc->sc_ah))
+		goto out;
+
+	spin_lock_irqsave(&common->cc_lock, flags);
+	busy = ath_update_survey_stats(sc);
+	spin_unlock_irqrestore(&common->cc_lock, flags);
+
+	ath_dbg(common, ATH_DBG_RESET, "Possible baseband hang, "
+		"busy=%d (try %d)\n", busy, sc->hw_busy_count + 1);
+	if (busy >= 99) {
+		if (++sc->hw_busy_count >= 3) {
+			spin_lock_bh(&sc->sc_pcu_lock);
+			ath_reset(sc, true);
+			spin_unlock_bh(&sc->sc_pcu_lock);
+		}
+
+	} else if (busy >= 0)
+		sc->hw_busy_count = 0;
+
+out:
+	ath9k_ps_restore(sc);
+}
+
+static void ath_hw_pll_rx_hang_check(struct ath_softc *sc, u32 pll_sqsum)
+{
+	static int count;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	if (pll_sqsum >= 0x40000) {
+		count++;
+		if (count == 3) {
+			/* Rx is hung for more than 500ms. Reset it */
+			ath_dbg(common, ATH_DBG_RESET,
+				"Possible RX hang, resetting");
+			spin_lock_bh(&sc->sc_pcu_lock);
+			ath_reset(sc, true);
+			spin_unlock_bh(&sc->sc_pcu_lock);
+			count = 0;
+		}
+	} else
+		count = 0;
+}
+
+void ath_hw_pll_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+					    hw_pll_work.work);
+	u32 pll_sqsum;
+
+	if (AR_SREV_9485(sc->sc_ah)) {
+
+		ath9k_ps_wakeup(sc);
+		pll_sqsum = ar9003_get_pll_sqsum_dvc(sc->sc_ah);
+		ath9k_ps_restore(sc);
+
+		ath_hw_pll_rx_hang_check(sc, pll_sqsum);
+
+		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work, HZ/5);
+	}
+}
+
 /**********************/
 /* mac80211 callbacks */
 /**********************/
-- 
1.7.3.2

