Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62457 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab0IOOWT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 10:22:19 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 07:22:12 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k: Paprd calibration should be per channel
Date: Wed, 15 Sep 2010 07:22:07 -0700
Message-ID: <1284560528-8934-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1284560528-8934-1-git-send-email-vasanth@atheros.com>
References: <1284560528-8934-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |    5 ++-
 drivers/net/wireless/ath/ath9k/hw.h           |   12 +++++++---
 drivers/net/wireless/ath/ath9k/main.c         |   28 +++++++++++-------------
 3 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 7c38229..fc283d2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -577,7 +577,7 @@ static bool create_pa_curve(u32 *data_L, u32 *data_U, u32 *pa_table, u16 *gain)
 }
 
 void ar9003_paprd_populate_single_table(struct ath_hw *ah,
-					struct ath9k_hw_cal_data *caldata,
+					struct ath9k_hw_paprd_caldata *caldata,
 					int chain)
 {
 	u32 *paprd_table_val = caldata->pa_table[chain];
@@ -656,7 +656,8 @@ int ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain)
 EXPORT_SYMBOL(ar9003_paprd_setup_gain_table);
 
 int ar9003_paprd_create_curve(struct ath_hw *ah,
-			      struct ath9k_hw_cal_data *caldata, int chain)
+			      struct ath9k_hw_paprd_caldata *caldata,
+			      int chain)
 {
 	u16 *small_signal_gain = &caldata->small_signal_gain[chain];
 	u32 *pa_table = caldata->pa_table[chain];
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a3c2ce2..daad373 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -343,16 +343,20 @@ struct ath9k_hw_cal_data {
 	int8_t iCoff;
 	int8_t qCoff;
 	int16_t rawNoiseFloor;
-	bool paprd_done;
 	bool nfcal_pending;
 	bool nfcal_interference;
+	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
+};
+
+struct ath9k_hw_paprd_caldata {
+	u8 paprd_done_txchainmask;
 	u16 small_signal_gain[AR9300_MAX_CHAINS];
 	u32 pa_table[AR9300_MAX_CHAINS][PAPRD_TABLE_SZ];
-	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
 };
 
 struct ath9k_channel {
 	struct ieee80211_channel *chan;
+	struct ath9k_hw_paprd_caldata paprd_caldata;
 	u16 channel;
 	u32 channelFlags;
 	u32 chanmode;
@@ -965,10 +969,10 @@ void ar9003_hw_bb_watchdog_read(struct ath_hw *ah);
 void ar9003_hw_bb_watchdog_dbg_info(struct ath_hw *ah);
 void ar9003_paprd_enable(struct ath_hw *ah, bool val);
 void ar9003_paprd_populate_single_table(struct ath_hw *ah,
-					struct ath9k_hw_cal_data *caldata,
+					struct ath9k_hw_paprd_caldata *caldata,
 					int chain);
 int ar9003_paprd_create_curve(struct ath_hw *ah,
-			      struct ath9k_hw_cal_data *caldata, int chain);
+		struct ath9k_hw_paprd_caldata *caldata, int chain);
 int ar9003_paprd_setup_gain_table(struct ath_hw *ah, int chain);
 int ar9003_paprd_init_table(struct ath_hw *ah);
 bool ar9003_paprd_is_done(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b529c3e..f316061 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -269,16 +269,14 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 static void ath_paprd_activate(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath9k_hw_cal_data *caldata = ah->caldata;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_paprd_caldata *caldata = &ah->curchan->paprd_caldata;
 	int chain;
 
-	if (!caldata || !caldata->paprd_done)
-		return;
-
 	ath9k_ps_wakeup(sc);
 	ar9003_paprd_enable(ah, false);
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
-		if (!(ah->caps.tx_chainmask & BIT(chain)))
+		if (!(common->tx_chainmask & BIT(chain)))
 			continue;
 
 		ar9003_paprd_populate_single_table(ah, caldata, chain);
@@ -299,7 +297,8 @@ void ath_paprd_calibrate(struct work_struct *work)
 	int band = hw->conf.channel->band;
 	struct ieee80211_supported_band *sband = &sc->sbands[band];
 	struct ath_tx_control txctl;
-	struct ath9k_hw_cal_data *caldata = ah->caldata;
+	struct ath9k_hw_paprd_caldata *caldata = &ah->curchan->paprd_caldata;
+	struct ath_common *common = ath9k_hw_common(ah);
 	int qnum, ftype;
 	int chain_ok = 0;
 	int chain;
@@ -307,9 +306,6 @@ void ath_paprd_calibrate(struct work_struct *work)
 	int time_left;
 	int i;
 
-	if (!caldata)
-		return;
-
 	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb)
 		return;
@@ -333,7 +329,8 @@ void ath_paprd_calibrate(struct work_struct *work)
 	ath9k_ps_wakeup(sc);
 	ar9003_paprd_init_table(ah);
 	for (chain = 0; chain < AR9300_MAX_CHAINS; chain++) {
-		if (!(ah->caps.tx_chainmask & BIT(chain)))
+		if (!(common->tx_chainmask & BIT(chain)) ||
+		    (caldata->paprd_done_txchainmask & BIT(chain)))
 			continue;
 
 		chain_ok = 0;
@@ -367,14 +364,13 @@ void ath_paprd_calibrate(struct work_struct *work)
 		if (ar9003_paprd_create_curve(ah, caldata, chain) != 0)
 			break;
 
+		caldata->paprd_done_txchainmask |= BIT(chain);
 		chain_ok = 1;
 	}
 	kfree_skb(skb);
 
-	if (chain_ok) {
-		caldata->paprd_done = true;
+	if (chain_ok)
 		ath_paprd_activate(sc);
-	}
 
 fail_paprd:
 	ath9k_ps_restore(sc);
@@ -392,6 +388,7 @@ void ath_ani_calibrate(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *)data;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_hw_paprd_caldata *caldata = &ah->curchan->paprd_caldata;
 	bool longcal = false;
 	bool shortcal = false;
 	bool aniflag = false;
@@ -486,8 +483,9 @@ set_timer:
 		cal_interval = min(cal_interval, (u32)short_cal_interval);
 
 	mod_timer(&common->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
-	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_PAPRD) && ah->caldata) {
-		if (!ah->caldata->paprd_done)
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_PAPRD) {
+		if ((caldata->paprd_done_txchainmask & common->tx_chainmask)
+		    != common->tx_chainmask)
 			ieee80211_queue_work(sc->hw, &sc->paprd_work);
 		else
 			ath_paprd_activate(sc);
-- 
1.7.0.4

