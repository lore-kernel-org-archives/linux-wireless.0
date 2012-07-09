Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43445 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2GIJQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 05:16:59 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20474.41276.454658.440465@gargle.gargle.HOWL> (sfid-20120709_111703_614765_3A45496C)
Date: Mon, 9 Jul 2012 14:45:40 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 10/11] ath9k: Fix ANI management
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, there are problems with how ANI is handled in
multi-VIF scenarios. This patch addresses them by unifying
the start/stop logic.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  4 ++-
 drivers/net/wireless/ath/ath9k/debug.c |  5 ++-
 drivers/net/wireless/ath/ath9k/link.c  | 57 +++++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/main.c  | 29 +++++++----------
 4 files changed, 67 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 42883e9..7323c3f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -444,7 +444,9 @@ void ath_rx_poll(unsigned long data);
 void ath_start_rx_poll(struct ath_softc *sc, u8 nbeacon);
 void ath_paprd_calibrate(struct work_struct *work);
 void ath_ani_calibrate(unsigned long data);
-void ath_start_ani(struct ath_common *common);
+void ath_start_ani(struct ath_softc *sc);
+void ath_stop_ani(struct ath_softc *sc);
+void ath_check_ani(struct ath_softc *sc);
 int ath_update_survey_stats(struct ath_softc *sc);
 void ath_update_survey_nf(struct ath_softc *sc, int channel);
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 5c3192f..33b0689 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -206,10 +206,9 @@ static ssize_t write_file_disable_ani(struct file *file,
 
 	if (disable_ani) {
 		clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
-		del_timer_sync(&common->ani.timer);
+		ath_stop_ani(sc);
 	} else {
-		set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
-		ath_start_ani(common);
+		ath_check_ani(sc);
 	}
 
 	return count;
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 91650fe..7af32b1 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -432,26 +432,69 @@ set_timer:
 	}
 }
 
-void ath_start_ani(struct ath_common *common)
+void ath_start_ani(struct ath_softc *sc)
 {
-	struct ath_hw *ah = common->ah;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	unsigned long timestamp = jiffies_to_msecs(jiffies);
-	struct ath_softc *sc = (struct ath_softc *) common->priv;
 
-	if (!test_bit(SC_OP_ANI_RUN, &sc->sc_flags))
-		return;
-
-	if (sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
+	if (common->disable_ani ||
+	    !test_bit(SC_OP_ANI_RUN, &sc->sc_flags) ||
+	    (sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
 		return;
 
 	common->ani.longcal_timer = timestamp;
 	common->ani.shortcal_timer = timestamp;
 	common->ani.checkani_timer = timestamp;
 
+	ath_dbg(common, ANI, "Starting ANI\n");
 	mod_timer(&common->ani.timer,
 		  jiffies + msecs_to_jiffies((u32)ah->config.ani_poll_interval));
 }
 
+void ath_stop_ani(struct ath_softc *sc)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	ath_dbg(common, ANI, "Stopping ANI\n");
+	del_timer_sync(&common->ani.timer);
+}
+
+void ath_check_ani(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+
+	/*
+	 * Check for the various conditions in which ANI has to
+	 * be stopped.
+	 */
+	if (ah->opmode == NL80211_IFTYPE_ADHOC) {
+		if (!cur_conf->enable_beacon)
+			goto stop_ani;
+	} else if (ah->opmode == NL80211_IFTYPE_AP) {
+		if (!cur_conf->enable_beacon) {
+			/*
+			 * Disable ANI only when there are no
+			 * associated stations.
+			 */
+			if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
+				goto stop_ani;
+		}
+	} else if (ah->opmode == NL80211_IFTYPE_STATION) {
+		if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags))
+			goto stop_ani;
+	}
+
+	set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+	ath_start_ani(sc);
+	return;
+
+stop_ani:
+	clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
+	ath_stop_ani(sc);
+}
+
 void ath_update_survey_nf(struct ath_softc *sc, int channel)
 {
 	struct ath_hw *ah = sc->sc_ah;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 263f4e3..512d719 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -167,8 +167,6 @@ static void ath_cancel_work(struct ath_softc *sc)
 
 static void ath_restart_work(struct ath_softc *sc)
 {
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
 	if (AR_SREV_9340(sc->sc_ah) || AR_SREV_9485(sc->sc_ah) ||
@@ -177,21 +175,18 @@ static void ath_restart_work(struct ath_softc *sc)
 				     msecs_to_jiffies(ATH_PLL_WORK_INTERVAL));
 
 	ath_start_rx_poll(sc, 3);
-
-	if (!common->disable_ani)
-		ath_start_ani(common);
+	ath_start_ani(sc);
 }
 
 static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
 	bool ret = true;
 
 	ieee80211_stop_queues(sc->hw);
 
 	sc->hw_busy_count = 0;
-	del_timer_sync(&common->ani.timer);
+	ath_stop_ani(sc);
 	del_timer_sync(&sc->rx_poll_timer);
 
 	ath9k_debug_samp_bb_mac(sc);
@@ -1453,6 +1448,11 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 				   struct ieee80211_bss_conf *bss_conf,
 				   u32 changed)
 {
+#define CHECK_ANI				\
+	(BSS_CHANGED_ASSOC |			\
+	 BSS_CHANGED_IBSS |			\
+	 BSS_CHANGED_BEACON_ENABLED)
+
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1491,16 +1491,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		memcpy(common->curbssid, bss_conf->bssid, ETH_ALEN);
 		common->curaid = bss_conf->aid;
 		ath9k_hw_write_associd(sc->sc_ah);
-
-		if (bss_conf->ibss_joined) {
-			if (!common->disable_ani) {
-				set_bit(SC_OP_ANI_RUN, &sc->sc_flags);
-				ath_start_ani(common);
-			}
-		} else {
-			clear_bit(SC_OP_ANI_RUN, &sc->sc_flags);
-			del_timer_sync(&common->ani.timer);
-		}
 	}
 
 	if ((changed & BSS_CHANGED_BEACON) ||
@@ -1531,8 +1521,13 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (changed & CHECK_ANI)
+		ath_check_ani(sc);
+
 	mutex_unlock(&sc->mutex);
 	ath9k_ps_restore(sc);
+
+#undef CHECK_ANI
 }
 
 static u64 ath9k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
-- 
1.7.11.1

