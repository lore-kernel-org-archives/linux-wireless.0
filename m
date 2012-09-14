Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43397 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab2INPpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 11:45:31 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <mcgrof@do-not-panic.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] compat-drivers: Add new cherry-pick patches
Date: Fri, 14 Sep 2012 21:11:00 +0530
Message-ID: <1347637262-27782-2-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120914_174552_204284_CF5EF1DF)
In-Reply-To: <1347637262-27782-1-git-send-email-bkamatch@qca.qualcomm.com>
References: <1347637262-27782-1-git-send-email-bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 ...interrupt-storms-on-queued-hardware-reset.patch |   85 +++
 ...-ath9k-Simplify-rate-table-initialization.patch |  140 +++++
 .../0205-ath9k-Cleanup-RC-init-API.patch           |  240 ++++++++
 .../0206-ath9k-Cleanup-ath_rc_setvalid_rates.patch |   76 +++
 ...207-ath9k-Cleanup-ath_rc_setvalid_htrates.patch |   47 ++
 ...08-ath9k-Cleanup-index-retrieval-routines.patch |  137 +++++
 .../0209-ath9k-Change-rateset-calculation.patch    |   87 +++
 ...10-ath9k-Remove-ath_rc_set_valid_rate_idx.patch |   54 ++
 ...h9k-Unify-valid-rate-calculation-routines.patch |  124 ++++
 ...ot-set-IEEE80211_TX_RC_USE_SHORT_PREAMBLE.patch |   24 +
 .../0213-ath9k-Fix-RTS-CTS-rate-selection.patch    |   78 +++
 ...out-properly-before-calculating-rate-inde.patch |   56 ++
 .../0215-ath9k-Cleanup-TX-status-API.patch         |  164 ++++++
 .../0216-ath9k-Remove-MIMO-PS-specific-code.patch  |   29 +
 .../0217-ath9k-Trim-rate-table.patch               |  600 ++++++++++++++++++++
 ...tune-rc_stats-to-display-only-valid-rates.patch |   34 ++
 ...h9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch |   61 ++
 .../0226-ath9k-Fix-TX-filter-usage.patch           |   42 ++
 ...ad-and-apply-thermometer-settings-from-EE.patch |   79 +++
 ...w-Read-and-configure-thermocal-for-AR9462.patch |   65 +++
 ...-ath9k_hw-Wait-BT-calibration-to-complete.patch |   71 +++
 ...0236-ath9k_hw-use-peak-detection-for-5GHz.patch |   21 +
 ...37-ath9k_hw-add-8-points-for-5G-temp-slop.patch |  111 ++++
 23 files changed, 2425 insertions(+), 0 deletions(-)
 create mode 100644 linux-next-cherry-picks/0202-ath9k-fix-interrupt-storms-on-queued-hardware-reset.patch
 create mode 100644 linux-next-cherry-picks/0204-ath9k-Simplify-rate-table-initialization.patch
 create mode 100644 linux-next-cherry-picks/0205-ath9k-Cleanup-RC-init-API.patch
 create mode 100644 linux-next-cherry-picks/0206-ath9k-Cleanup-ath_rc_setvalid_rates.patch
 create mode 100644 linux-next-cherry-picks/0207-ath9k-Cleanup-ath_rc_setvalid_htrates.patch
 create mode 100644 linux-next-cherry-picks/0208-ath9k-Cleanup-index-retrieval-routines.patch
 create mode 100644 linux-next-cherry-picks/0209-ath9k-Change-rateset-calculation.patch
 create mode 100644 linux-next-cherry-picks/0210-ath9k-Remove-ath_rc_set_valid_rate_idx.patch
 create mode 100644 linux-next-cherry-picks/0211-ath9k-Unify-valid-rate-calculation-routines.patch
 create mode 100644 linux-next-cherry-picks/0212-ath9k-Do-not-set-IEEE80211_TX_RC_USE_SHORT_PREAMBLE.patch
 create mode 100644 linux-next-cherry-picks/0213-ath9k-Fix-RTS-CTS-rate-selection.patch
 create mode 100644 linux-next-cherry-picks/0214-ath9k-Bail-out-properly-before-calculating-rate-inde.patch
 create mode 100644 linux-next-cherry-picks/0215-ath9k-Cleanup-TX-status-API.patch
 create mode 100644 linux-next-cherry-picks/0216-ath9k-Remove-MIMO-PS-specific-code.patch
 create mode 100644 linux-next-cherry-picks/0217-ath9k-Trim-rate-table.patch
 create mode 100644 linux-next-cherry-picks/0218-ath9k-tune-rc_stats-to-display-only-valid-rates.patch
 create mode 100644 linux-next-cherry-picks/0224-ath9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch
 create mode 100644 linux-next-cherry-picks/0226-ath9k-Fix-TX-filter-usage.patch
 create mode 100644 linux-next-cherry-picks/0230-ath9k_hw-Read-and-apply-thermometer-settings-from-EE.patch
 create mode 100644 linux-next-cherry-picks/0231-ath9k_hw-Read-and-configure-thermocal-for-AR9462.patch
 create mode 100644 linux-next-cherry-picks/0235-ath9k_hw-Wait-BT-calibration-to-complete.patch
 create mode 100644 linux-next-cherry-picks/0236-ath9k_hw-use-peak-detection-for-5GHz.patch
 create mode 100644 linux-next-cherry-picks/0237-ath9k_hw-add-8-points-for-5G-temp-slop.patch

diff --git a/linux-next-cherry-picks/0202-ath9k-fix-interrupt-storms-on-queued-hardware-reset.patch b/linux-next-cherry-picks/0202-ath9k-fix-interrupt-storms-on-queued-hardware-reset.patch
new file mode 100644
index 0000000..0e80d93
--- /dev/null
+++ b/linux-next-cherry-picks/0202-ath9k-fix-interrupt-storms-on-queued-hardware-reset.patch
@@ -0,0 +1,85 @@
+From 9363cddc7e35a2ab6f662ae5f5f4efd89fb1f373 Mon Sep 17 00:00:00 2001
+From: Felix Fietkau <nbd@openwrt.org>
+Date: Wed, 8 Aug 2012 16:25:03 +0200
+Subject: [PATCH 202/226] ath9k: fix interrupt storms on queued hardware reset
+
+commit b74713d04effbacd3d126ce94cec18742187b6ce
+"ath9k: Handle fatal interrupts properly" introduced a race condition, where
+IRQs are being left enabled, however the irq handler returns IRQ_HANDLED
+while the reset is still queued without addressing the IRQ cause.
+This leads to an IRQ storm that prevents the system from even getting to
+the reset code.
+
+Fix this by disabling IRQs in the handler without touching intr_ref_cnt.
+
+Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: Felix Fietkau <nbd@openwrt.org>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/mac.c  | 18 ++++++++++++------
+ drivers/net/wireless/ath/ath9k/mac.h  |  1 +
+ drivers/net/wireless/ath/ath9k/main.c |  4 +++-
+ 3 files changed, 16 insertions(+), 7 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/mac.c
++++ b/drivers/net/wireless/ath/ath9k/mac.c
+@@ -773,15 +773,10 @@ bool ath9k_hw_intrpend(struct ath_hw *ah
+ }
+ EXPORT_SYMBOL(ath9k_hw_intrpend);
+ 
+-void ath9k_hw_disable_interrupts(struct ath_hw *ah)
++void ath9k_hw_kill_interrupts(struct ath_hw *ah)
+ {
+ 	struct ath_common *common = ath9k_hw_common(ah);
+ 
+-	if (!(ah->imask & ATH9K_INT_GLOBAL))
+-		atomic_set(&ah->intr_ref_cnt, -1);
+-	else
+-		atomic_dec(&ah->intr_ref_cnt);
+-
+ 	ath_dbg(common, INTERRUPT, "disable IER\n");
+ 	REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
+ 	(void) REG_READ(ah, AR_IER);
+@@ -793,6 +788,17 @@ void ath9k_hw_disable_interrupts(struct
+ 		(void) REG_READ(ah, AR_INTR_SYNC_ENABLE);
+ 	}
+ }
++EXPORT_SYMBOL(ath9k_hw_kill_interrupts);
++
++void ath9k_hw_disable_interrupts(struct ath_hw *ah)
++{
++	if (!(ah->imask & ATH9K_INT_GLOBAL))
++		atomic_set(&ah->intr_ref_cnt, -1);
++	else
++		atomic_dec(&ah->intr_ref_cnt);
++
++	ath9k_hw_kill_interrupts(ah);
++}
+ EXPORT_SYMBOL(ath9k_hw_disable_interrupts);
+ 
+ void ath9k_hw_enable_interrupts(struct ath_hw *ah)
+--- a/drivers/net/wireless/ath/ath9k/mac.h
++++ b/drivers/net/wireless/ath/ath9k/mac.h
+@@ -737,6 +737,7 @@ bool ath9k_hw_intrpend(struct ath_hw *ah
+ void ath9k_hw_set_interrupts(struct ath_hw *ah);
+ void ath9k_hw_enable_interrupts(struct ath_hw *ah);
+ void ath9k_hw_disable_interrupts(struct ath_hw *ah);
++void ath9k_hw_kill_interrupts(struct ath_hw *ah);
+ 
+ void ar9002_hw_attach_mac_ops(struct ath_hw *ah);
+ 
+--- a/drivers/net/wireless/ath/ath9k/main.c
++++ b/drivers/net/wireless/ath/ath9k/main.c
+@@ -461,8 +461,10 @@ irqreturn_t ath_isr(int irq, void *dev)
+ 	if (!ath9k_hw_intrpend(ah))
+ 		return IRQ_NONE;
+ 
+-	if(test_bit(SC_OP_HW_RESET, &sc->sc_flags))
++	if (test_bit(SC_OP_HW_RESET, &sc->sc_flags)) {
++		ath9k_hw_kill_interrupts(ah);
+ 		return IRQ_HANDLED;
++	}
+ 
+ 	/*
+ 	 * Figure out the reason(s) for the interrupt.  Note
diff --git a/linux-next-cherry-picks/0204-ath9k-Simplify-rate-table-initialization.patch b/linux-next-cherry-picks/0204-ath9k-Simplify-rate-table-initialization.patch
new file mode 100644
index 0000000..46af149
--- /dev/null
+++ b/linux-next-cherry-picks/0204-ath9k-Simplify-rate-table-initialization.patch
@@ -0,0 +1,140 @@
+From 18c9c7eb106e51603c85e64e02d1a0f122b49709 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:45:52 +0530
+Subject: [PATCH 204/226] ath9k: Simplify rate table initialization
+
+Remove various local variables that duplicate information
+already stored in mac80211.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 65 ++++++++++---------------------------
+ 1 file changed, 17 insertions(+), 48 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -1185,8 +1185,6 @@ struct ath_rate_table *ath_choose_rate_t
+ 					     enum ieee80211_band band,
+ 					     bool is_ht)
+ {
+-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+-
+ 	switch(band) {
+ 	case IEEE80211_BAND_2GHZ:
+ 		if (is_ht)
+@@ -1197,7 +1195,6 @@ struct ath_rate_table *ath_choose_rate_t
+ 			return &ar5416_11na_ratetable;
+ 		return &ar5416_11a_ratetable;
+ 	default:
+-		ath_dbg(common, CONFIG, "Invalid band\n");
+ 		return NULL;
+ 	}
+ }
+@@ -1278,8 +1275,7 @@ static void ath_rc_init(struct ath_softc
+ 		ath_rc_priv->ht_cap);
+ }
+ 
+-static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta,
+-			       bool is_cw40, bool is_sgi)
++static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta)
+ {
+ 	u8 caps = 0;
+ 
+@@ -1289,9 +1285,10 @@ static u8 ath_rc_build_ht_caps(struct at
+ 			caps |= WLAN_RC_TS_FLAG | WLAN_RC_DS_FLAG;
+ 		else if (sta->ht_cap.mcs.rx_mask[1])
+ 			caps |= WLAN_RC_DS_FLAG;
+-		if (is_cw40)
++		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+ 			caps |= WLAN_RC_40_FLAG;
+-		if (is_sgi)
++		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40 ||
++		    sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20)
+ 			caps |= WLAN_RC_SGI_FLAG;
+ 	}
+ 
+@@ -1393,9 +1390,9 @@ static void ath_rate_init(void *priv, st
+                           struct ieee80211_sta *sta, void *priv_sta)
+ {
+ 	struct ath_softc *sc = priv;
++	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+ 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+ 	const struct ath_rate_table *rate_table;
+-	bool is_cw40, is_sgi = false;
+ 	int i, j = 0;
+ 
+ 	for (i = 0; i < sband->n_bitrates; i++) {
+@@ -1417,19 +1414,14 @@ static void ath_rate_init(void *priv, st
+ 		ath_rc_priv->neg_ht_rates.rs_nrates = j;
+ 	}
+ 
+-	is_cw40 = !!(sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40);
+-
+-	if (is_cw40)
+-		is_sgi = !!(sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40);
+-	else if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_SGI_20)
+-		is_sgi = !!(sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20);
+-
+-	/* Choose rate table first */
+-
+ 	rate_table = ath_choose_rate_table(sc, sband->band,
+-	                      sta->ht_cap.ht_supported);
++					   sta->ht_cap.ht_supported);
++	if (!rate_table) {
++		ath_err(common, "No rate table chosen\n");
++		return;
++	}
+ 
+-	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta, is_cw40, is_sgi);
++	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta);
+ 	ath_rc_init(sc, priv_sta, sband, sta, rate_table);
+ }
+ 
+@@ -1440,39 +1432,16 @@ static void ath_rate_update(void *priv,
+ 	struct ath_softc *sc = priv;
+ 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+ 	const struct ath_rate_table *rate_table = NULL;
+-	bool oper_cw40 = false, oper_sgi;
+-	bool local_cw40 = !!(ath_rc_priv->ht_cap & WLAN_RC_40_FLAG);
+-	bool local_sgi = !!(ath_rc_priv->ht_cap & WLAN_RC_SGI_FLAG);
+-
+-	/* FIXME: Handle AP mode later when we support CWM */
+ 
+ 	if (changed & IEEE80211_RC_BW_CHANGED) {
+-		if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
+-			return;
+-
+-		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+-			oper_cw40 = true;
+-
+-		if (oper_cw40)
+-			oper_sgi = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
+-				   true : false;
+-		else if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_SGI_20)
+-			oper_sgi = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
+-				   true : false;
+-		else
+-			oper_sgi = false;
+-
+-		if ((local_cw40 != oper_cw40) || (local_sgi != oper_sgi)) {
+-			rate_table = ath_choose_rate_table(sc, sband->band,
++		rate_table = ath_choose_rate_table(sc, sband->band,
+ 						   sta->ht_cap.ht_supported);
+-			ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta,
+-						   oper_cw40, oper_sgi);
+-			ath_rc_init(sc, priv_sta, sband, sta, rate_table);
+-
+-			ath_dbg(ath9k_hw_common(sc->sc_ah), CONFIG,
+-				"Operating HT Bandwidth changed to: %d\n",
+-				sc->hw->conf.channel_type);
+-		}
++		ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta);
++		ath_rc_init(sc, priv_sta, sband, sta, rate_table);
++
++		ath_dbg(ath9k_hw_common(sc->sc_ah), CONFIG,
++			"Operating HT Bandwidth changed to: %d\n",
++			sc->hw->conf.channel_type);
+ 	}
+ }
+ 
diff --git a/linux-next-cherry-picks/0205-ath9k-Cleanup-RC-init-API.patch b/linux-next-cherry-picks/0205-ath9k-Cleanup-RC-init-API.patch
new file mode 100644
index 0000000..a9df6d4
--- /dev/null
+++ b/linux-next-cherry-picks/0205-ath9k-Cleanup-RC-init-API.patch
@@ -0,0 +1,240 @@
+From 1a797cf5f0fbeb24d4d59036cd8a765af0a86fdc Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:04 +0530
+Subject: [PATCH 205/226] ath9k: Cleanup RC init API
+
+A reference to the rate table is stored inside the
+private structure, so there is no need to pass "rate_table"
+around.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 99 +++++++++++++------------------------
+ 1 file changed, 35 insertions(+), 64 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -405,9 +405,9 @@ static int ath_rc_get_rateindex(const st
+ 	return rix;
+ }
+ 
+-static void ath_rc_sort_validrates(const struct ath_rate_table *rate_table,
+-				   struct ath_rate_priv *ath_rc_priv)
++static void ath_rc_sort_validrates(struct ath_rate_priv *ath_rc_priv)
+ {
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	u8 i, j, idx, idx_next;
+ 
+ 	for (i = ath_rc_priv->max_valid_rate - 1; i > 0; i--) {
+@@ -424,14 +424,6 @@ static void ath_rc_sort_validrates(const
+ 	}
+ }
+ 
+-static void ath_rc_init_valid_rate_idx(struct ath_rate_priv *ath_rc_priv)
+-{
+-	u8 i;
+-
+-	for (i = 0; i < ath_rc_priv->rate_table_size; i++)
+-		ath_rc_priv->valid_rate_index[i] = 0;
+-}
+-
+ static inline void ath_rc_set_valid_rate_idx(struct ath_rate_priv *ath_rc_priv,
+ 					   u8 index, int valid_tx_rate)
+ {
+@@ -495,10 +487,9 @@ ath_rc_get_lower_rix(const struct ath_ra
+ 	return 0;
+ }
+ 
+-static u8 ath_rc_init_validrates(struct ath_rate_priv *ath_rc_priv,
+-				 const struct ath_rate_table *rate_table,
+-				 u32 capflag)
++static u8 ath_rc_init_validrates(struct ath_rate_priv *ath_rc_priv)
+ {
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	u8 i, hi = 0;
+ 
+ 	for (i = 0; i < rate_table->rate_cnt; i++) {
+@@ -506,7 +497,7 @@ static u8 ath_rc_init_validrates(struct
+ 			u32 phy = rate_table->info[i].phy;
+ 			u8 valid_rate_count = 0;
+ 
+-			if (!ath_rc_valid_phyrate(phy, capflag, 0))
++			if (!ath_rc_valid_phyrate(phy, ath_rc_priv->ht_cap, 0))
+ 				continue;
+ 
+ 			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
+@@ -521,14 +512,13 @@ static u8 ath_rc_init_validrates(struct
+ 	return hi;
+ }
+ 
+-static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
+-				const struct ath_rate_table *rate_table,
+-				struct ath_rateset *rateset,
+-				u32 capflag)
++static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv)
+ {
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
++	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
++	u32 capflag = ath_rc_priv->ht_cap;
+ 	u8 i, j, hi = 0;
+ 
+-	/* Use intersection of working rates and valid rates */
+ 	for (i = 0; i < rateset->rs_nrates; i++) {
+ 		for (j = 0; j < rate_table->rate_cnt; j++) {
+ 			u32 phy = rate_table->info[j].phy;
+@@ -565,13 +555,13 @@ static u8 ath_rc_setvalid_rates(struct a
+ 	return hi;
+ }
+ 
+-static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv,
+-				  const struct ath_rate_table *rate_table,
+-				  struct ath_rateset *rateset, u32 capflag)
++static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv)
+ {
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
++	struct ath_rateset *rateset = &ath_rc_priv->neg_ht_rates;
++	u32 capflag = ath_rc_priv->ht_cap;
+ 	u8 i, j, hi = 0;
+ 
+-	/* Use intersection of working rates and valid rates */
+ 	for (i = 0; i < rateset->rs_nrates; i++) {
+ 		for (j = 0; j < rate_table->rate_cnt; j++) {
+ 			u32 phy = rate_table->info[j].phy;
+@@ -1200,28 +1190,20 @@ struct ath_rate_table *ath_choose_rate_t
+ }
+ 
+ static void ath_rc_init(struct ath_softc *sc,
+-			struct ath_rate_priv *ath_rc_priv,
+-			struct ieee80211_supported_band *sband,
+-			struct ieee80211_sta *sta,
+-			const struct ath_rate_table *rate_table)
++			struct ath_rate_priv *ath_rc_priv)
+ {
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+-	struct ath_rateset *ht_mcs = &ath_rc_priv->neg_ht_rates;
+ 	u8 i, j, k, hi = 0, hthi = 0;
+ 
+-	/* Initial rate table size. Will change depending
+-	 * on the working rate set */
+ 	ath_rc_priv->rate_table_size = RATE_TABLE_SIZE;
+ 
+-	/* Initialize thresholds according to the global rate table */
+ 	for (i = 0 ; i < ath_rc_priv->rate_table_size; i++) {
+ 		ath_rc_priv->per[i] = 0;
++		ath_rc_priv->valid_rate_index[i] = 0;
+ 	}
+ 
+-	/* Determine the valid rates */
+-	ath_rc_init_valid_rate_idx(ath_rc_priv);
+-
+ 	for (i = 0; i < WLAN_RC_PHY_MAX; i++) {
+ 		for (j = 0; j < RATE_TABLE_SIZE; j++)
+ 			ath_rc_priv->valid_phy_rateidx[i][j] = 0;
+@@ -1229,25 +1211,19 @@ static void ath_rc_init(struct ath_softc
+ 	}
+ 
+ 	if (!rateset->rs_nrates) {
+-		/* No working rate, just initialize valid rates */
+-		hi = ath_rc_init_validrates(ath_rc_priv, rate_table,
+-					    ath_rc_priv->ht_cap);
++		hi = ath_rc_init_validrates(ath_rc_priv);
+ 	} else {
+-		/* Use intersection of working rates and valid rates */
+-		hi = ath_rc_setvalid_rates(ath_rc_priv, rate_table,
+-					   rateset, ath_rc_priv->ht_cap);
+-		if (ath_rc_priv->ht_cap & WLAN_RC_HT_FLAG) {
+-			hthi = ath_rc_setvalid_htrates(ath_rc_priv,
+-						       rate_table,
+-						       ht_mcs,
+-						       ath_rc_priv->ht_cap);
+-		}
++		hi = ath_rc_setvalid_rates(ath_rc_priv);
++
++		if (ath_rc_priv->ht_cap & WLAN_RC_HT_FLAG)
++			hthi = ath_rc_setvalid_htrates(ath_rc_priv);
++
+ 		hi = max(hi, hthi);
+ 	}
+ 
+ 	ath_rc_priv->rate_table_size = hi + 1;
+ 	ath_rc_priv->rate_max_phy = 0;
+-	BUG_ON(ath_rc_priv->rate_table_size > RATE_TABLE_SIZE);
++	WARN_ON(ath_rc_priv->rate_table_size > RATE_TABLE_SIZE);
+ 
+ 	for (i = 0, k = 0; i < WLAN_RC_PHY_MAX; i++) {
+ 		for (j = 0; j < ath_rc_priv->valid_phy_ratecnt[i]; j++) {
+@@ -1255,21 +1231,20 @@ static void ath_rc_init(struct ath_softc
+ 				ath_rc_priv->valid_phy_rateidx[i][j];
+ 		}
+ 
+-		if (!ath_rc_valid_phyrate(i, rate_table->initial_ratemax, 1)
+-		    || !ath_rc_priv->valid_phy_ratecnt[i])
++		if (!ath_rc_valid_phyrate(i, rate_table->initial_ratemax, 1) ||
++		    !ath_rc_priv->valid_phy_ratecnt[i])
+ 			continue;
+ 
+ 		ath_rc_priv->rate_max_phy = ath_rc_priv->valid_phy_rateidx[i][j-1];
+ 	}
+-	BUG_ON(ath_rc_priv->rate_table_size > RATE_TABLE_SIZE);
+-	BUG_ON(k > RATE_TABLE_SIZE);
++	WARN_ON(ath_rc_priv->rate_table_size > RATE_TABLE_SIZE);
++	WARN_ON(k > RATE_TABLE_SIZE);
+ 
+ 	ath_rc_priv->max_valid_rate = k;
+-	ath_rc_sort_validrates(rate_table, ath_rc_priv);
++	ath_rc_sort_validrates(ath_rc_priv);
+ 	ath_rc_priv->rate_max_phy = (k > 4) ?
+-					ath_rc_priv->valid_rate_index[k-4] :
+-					ath_rc_priv->valid_rate_index[k-1];
+-	ath_rc_priv->rate_table = rate_table;
++		ath_rc_priv->valid_rate_index[k-4] :
++		ath_rc_priv->valid_rate_index[k-1];
+ 
+ 	ath_dbg(common, CONFIG, "RC Initialized with capabilities: 0x%x\n",
+ 		ath_rc_priv->ht_cap);
+@@ -1392,7 +1367,6 @@ static void ath_rate_init(void *priv, st
+ 	struct ath_softc *sc = priv;
+ 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+ 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+-	const struct ath_rate_table *rate_table;
+ 	int i, j = 0;
+ 
+ 	for (i = 0; i < sband->n_bitrates; i++) {
+@@ -1414,15 +1388,15 @@ static void ath_rate_init(void *priv, st
+ 		ath_rc_priv->neg_ht_rates.rs_nrates = j;
+ 	}
+ 
+-	rate_table = ath_choose_rate_table(sc, sband->band,
+-					   sta->ht_cap.ht_supported);
+-	if (!rate_table) {
++	ath_rc_priv->rate_table = ath_choose_rate_table(sc, sband->band,
++							sta->ht_cap.ht_supported);
++	if (!ath_rc_priv->rate_table) {
+ 		ath_err(common, "No rate table chosen\n");
+ 		return;
+ 	}
+ 
+ 	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta);
+-	ath_rc_init(sc, priv_sta, sband, sta, rate_table);
++	ath_rc_init(sc, priv_sta);
+ }
+ 
+ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
+@@ -1431,13 +1405,10 @@ static void ath_rate_update(void *priv,
+ {
+ 	struct ath_softc *sc = priv;
+ 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+-	const struct ath_rate_table *rate_table = NULL;
+ 
+ 	if (changed & IEEE80211_RC_BW_CHANGED) {
+-		rate_table = ath_choose_rate_table(sc, sband->band,
+-						   sta->ht_cap.ht_supported);
+ 		ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta);
+-		ath_rc_init(sc, priv_sta, sband, sta, rate_table);
++		ath_rc_init(sc, priv_sta);
+ 
+ 		ath_dbg(ath9k_hw_common(sc->sc_ah), CONFIG,
+ 			"Operating HT Bandwidth changed to: %d\n",
diff --git a/linux-next-cherry-picks/0206-ath9k-Cleanup-ath_rc_setvalid_rates.patch b/linux-next-cherry-picks/0206-ath9k-Cleanup-ath_rc_setvalid_rates.patch
new file mode 100644
index 0000000..9224ecc
--- /dev/null
+++ b/linux-next-cherry-picks/0206-ath9k-Cleanup-ath_rc_setvalid_rates.patch
@@ -0,0 +1,76 @@
+From f11af79faf0a8a2f0506af1eb6d4da9c347396f9 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:11 +0530
+Subject: [PATCH 206/226] ath9k: Cleanup ath_rc_setvalid_rates
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 49 ++++++++++++++++---------------------
+ 1 file changed, 21 insertions(+), 28 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -516,39 +516,32 @@ static u8 ath_rc_setvalid_rates(struct a
+ {
+ 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
+-	u32 capflag = ath_rc_priv->ht_cap;
+-	u8 i, j, hi = 0;
++	u32 phy, capflag = ath_rc_priv->ht_cap;
++	u16 rate_flags;
++	u8 i, j, hi = 0, rate, dot11rate, valid_rate_count;
+ 
+ 	for (i = 0; i < rateset->rs_nrates; i++) {
+ 		for (j = 0; j < rate_table->rate_cnt; j++) {
+-			u32 phy = rate_table->info[j].phy;
+-			u16 rate_flags = rate_table->info[j].rate_flags;
+-			u8 rate = rateset->rs_rates[i];
+-			u8 dot11rate = rate_table->info[j].dot11rate;
+-
+-			/* We allow a rate only if its valid and the
+-			 * capflag matches one of the validity
+-			 * (VALID/VALID_20/VALID_40) flags */
+-
+-			if ((rate == dot11rate) &&
+-			    (rate_flags & WLAN_RC_CAP_MODE(capflag)) ==
+-			    WLAN_RC_CAP_MODE(capflag) &&
+-			    (rate_flags & WLAN_RC_CAP_STREAM(capflag)) &&
+-			    !WLAN_RC_PHY_HT(phy)) {
+-				u8 valid_rate_count = 0;
+-
+-				if (!ath_rc_valid_phyrate(phy, capflag, 0))
+-					continue;
+-
+-				valid_rate_count =
+-					ath_rc_priv->valid_phy_ratecnt[phy];
+-
+-				ath_rc_priv->valid_phy_rateidx[phy]
+-					[valid_rate_count] = j;
+-				ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+-				ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
+-				hi = max(hi, j);
+-			}
++			phy = rate_table->info[j].phy;
++			rate_flags = rate_table->info[j].rate_flags;
++			rate = rateset->rs_rates[i];
++			dot11rate = rate_table->info[j].dot11rate;
++
++			if (rate != dot11rate
++			    || ((rate_flags & WLAN_RC_CAP_MODE(capflag)) !=
++				WLAN_RC_CAP_MODE(capflag))
++			    || !(rate_flags & WLAN_RC_CAP_STREAM(capflag))
++			    || WLAN_RC_PHY_HT(phy))
++				continue;
++
++			if (!ath_rc_valid_phyrate(phy, capflag, 0))
++				continue;
++
++			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
++			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
++			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
++			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
++			hi = max(hi, j);
+ 		}
+ 	}
+ 
diff --git a/linux-next-cherry-picks/0207-ath9k-Cleanup-ath_rc_setvalid_htrates.patch b/linux-next-cherry-picks/0207-ath9k-Cleanup-ath_rc_setvalid_htrates.patch
new file mode 100644
index 0000000..13e7e82
--- /dev/null
+++ b/linux-next-cherry-picks/0207-ath9k-Cleanup-ath_rc_setvalid_htrates.patch
@@ -0,0 +1,47 @@
+From a699f7f3afa8ff228e9b04c077e70249738a99a3 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:18 +0530
+Subject: [PATCH 207/226] ath9k: Cleanup ath_rc_setvalid_htrates
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 17 +++++++++--------
+ 1 file changed, 9 insertions(+), 8 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -552,15 +552,16 @@ static u8 ath_rc_setvalid_htrates(struct
+ {
+ 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	struct ath_rateset *rateset = &ath_rc_priv->neg_ht_rates;
+-	u32 capflag = ath_rc_priv->ht_cap;
+-	u8 i, j, hi = 0;
++	u32 phy, capflag = ath_rc_priv->ht_cap;
++	u16 rate_flags;
++	u8 i, j, hi = 0, rate, dot11rate, valid_rate_count;
+ 
+ 	for (i = 0; i < rateset->rs_nrates; i++) {
+ 		for (j = 0; j < rate_table->rate_cnt; j++) {
+-			u32 phy = rate_table->info[j].phy;
+-			u16 rate_flags = rate_table->info[j].rate_flags;
+-			u8 rate = rateset->rs_rates[i];
+-			u8 dot11rate = rate_table->info[j].dot11rate;
++			phy = rate_table->info[j].phy;
++			rate_flags = rate_table->info[j].rate_flags;
++			rate = rateset->rs_rates[i];
++			dot11rate = rate_table->info[j].dot11rate;
+ 
+ 			if ((rate != dot11rate) || !WLAN_RC_PHY_HT(phy) ||
+ 			    !(rate_flags & WLAN_RC_CAP_STREAM(capflag)) ||
+@@ -570,8 +571,8 @@ static u8 ath_rc_setvalid_htrates(struct
+ 			if (!ath_rc_valid_phyrate(phy, capflag, 0))
+ 				continue;
+ 
+-			ath_rc_priv->valid_phy_rateidx[phy]
+-				[ath_rc_priv->valid_phy_ratecnt[phy]] = j;
++			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
++			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
+ 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+ 			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
+ 			hi = max(hi, j);
diff --git a/linux-next-cherry-picks/0208-ath9k-Cleanup-index-retrieval-routines.patch b/linux-next-cherry-picks/0208-ath9k-Cleanup-index-retrieval-routines.patch
new file mode 100644
index 0000000..90e5c11
--- /dev/null
+++ b/linux-next-cherry-picks/0208-ath9k-Cleanup-index-retrieval-routines.patch
@@ -0,0 +1,137 @@
+From 639365d9a47b5c1524bbf23973d8ed4b0380f9fe Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:24 +0530
+Subject: [PATCH 208/226] ath9k: Cleanup index retrieval routines
+
+Trim API and remove unused variables.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 56 ++++++++++++++++++-------------------
+ 1 file changed, 27 insertions(+), 29 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -471,8 +471,7 @@ static int ath_rc_valid_phyrate(u32 phy,
+ }
+ 
+ static inline int
+-ath_rc_get_lower_rix(const struct ath_rate_table *rate_table,
+-		     struct ath_rate_priv *ath_rc_priv,
++ath_rc_get_lower_rix(struct ath_rate_priv *ath_rc_priv,
+ 		     u8 cur_valid_txrate, u8 *next_idx)
+ {
+ 	int8_t i;
+@@ -582,13 +581,11 @@ static u8 ath_rc_setvalid_htrates(struct
+ 	return hi;
+ }
+ 
+-/* Finds the highest rate index we can use */
+-static u8 ath_rc_get_highest_rix(struct ath_softc *sc,
+-			         struct ath_rate_priv *ath_rc_priv,
+-				 const struct ath_rate_table *rate_table,
++static u8 ath_rc_get_highest_rix(struct ath_rate_priv *ath_rc_priv,
+ 				 int *is_probing,
+ 				 bool legacy)
+ {
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	u32 best_thruput, this_thruput, now_msec;
+ 	u8 rate, next_rate, best_rate, maxindex, minindex;
+ 	int8_t index = 0;
+@@ -773,14 +770,8 @@ static void ath_get_rate(void *priv, str
+ 	try_per_rate = 4;
+ 
+ 	rate_table = ath_rc_priv->rate_table;
+-	rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table,
+-				     &is_probe, false);
++	rix = ath_rc_get_highest_rix(ath_rc_priv, &is_probe, false);
+ 
+-	/*
+-	 * If we're in HT mode and both us and our peer supports LDPC.
+-	 * We don't need to check our own device's capabilities as our own
+-	 * ht capabilities would have already been intersected with our peer's.
+-	 */
+ 	if (conf_is_ht(&sc->hw->conf) &&
+ 	    (sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING))
+ 		tx_info->flags |= IEEE80211_TX_CTL_LDPC;
+@@ -790,35 +781,42 @@ static void ath_get_rate(void *priv, str
+ 		tx_info->flags |= (1 << IEEE80211_TX_CTL_STBC_SHIFT);
+ 
+ 	if (is_probe) {
+-		/* set one try for probe rates. For the
+-		 * probes don't enable rts */
++		/*
++		 * Set one try for probe rates. For the
++		 * probes don't enable RTS.
++		 */
+ 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
+ 				       1, rix, 0);
+-
+-		/* Get the next tried/allowed rate. No RTS for the next series
+-		 * after the probe rate
++		/*
++		 * Get the next tried/allowed rate.
++		 * No RTS for the next series after the probe rate.
+ 		 */
+-		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &rix);
++		ath_rc_get_lower_rix(ath_rc_priv, rix, &rix);
+ 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
+ 				       try_per_rate, rix, 0);
+ 
+ 		tx_info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
+ 	} else {
+-		/* Set the chosen rate. No RTS for first series entry. */
++		/*
++		 * Set the chosen rate. No RTS for first series entry.
++		 */
+ 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
+ 				       try_per_rate, rix, 0);
+ 	}
+ 
+-	/* Fill in the other rates for multirate retry */
+ 	for ( ; i < 3; i++) {
++		ath_rc_get_lower_rix(ath_rc_priv, rix, &rix);
+ 
+-		ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &rix);
+-		/* All other rates in the series have RTS enabled */
++		/*
++		 * All other rates in the series have RTS enabled.
++		 */
+ 		ath_rc_rate_set_series(rate_table, &rates[i], txrc,
+ 				       try_per_rate, rix, 1);
+ 	}
+ 
+-	/* Use twice the number of tries for the last MRR segment. */
++	/*
++	 * Use twice the number of tries for the last MRR segment.
++	 */
+ 	try_per_rate = 8;
+ 
+ 	/*
+@@ -827,11 +825,11 @@ static void ath_get_rate(void *priv, str
+ 	 * as last retry to ensure that the frame is tried in both
+ 	 * MCS and legacy rate.
+ 	 */
+-	ath_rc_get_lower_rix(rate_table, ath_rc_priv, rix, &rix);
++	ath_rc_get_lower_rix(ath_rc_priv, rix, &rix);
++
+ 	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy) &&
+ 	    (ath_rc_priv->per[rix] > 45))
+-		rix = ath_rc_get_highest_rix(sc, ath_rc_priv, rate_table,
+-				&is_probe, true);
++		rix = ath_rc_get_highest_rix(ath_rc_priv, &is_probe, true);
+ 
+ 	/* All other rates in the series have RTS enabled */
+ 	ath_rc_rate_set_series(rate_table, &rates[i], txrc,
+@@ -1061,8 +1059,8 @@ static void ath_rc_update_ht(struct ath_
+ 	if (ath_rc_priv->per[tx_rate] >= 55 && tx_rate > 0 &&
+ 	    rate_table->info[tx_rate].ratekbps <=
+ 	    rate_table->info[ath_rc_priv->rate_max_phy].ratekbps) {
+-		ath_rc_get_lower_rix(rate_table, ath_rc_priv,
+-				     (u8)tx_rate, &ath_rc_priv->rate_max_phy);
++		ath_rc_get_lower_rix(ath_rc_priv, (u8)tx_rate,
++				     &ath_rc_priv->rate_max_phy);
+ 
+ 		/* Don't probe for a little while. */
+ 		ath_rc_priv->probe_time = now_msec;
diff --git a/linux-next-cherry-picks/0209-ath9k-Change-rateset-calculation.patch b/linux-next-cherry-picks/0209-ath9k-Change-rateset-calculation.patch
new file mode 100644
index 0000000..9edade6
--- /dev/null
+++ b/linux-next-cherry-picks/0209-ath9k-Change-rateset-calculation.patch
@@ -0,0 +1,87 @@
+From 7bb69330be8c0a53f6ced6a8f2ebf8063ec1948c Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:31 +0530
+Subject: [PATCH 209/226] ath9k: Change rateset calculation
+
+Commit "ath9k: Change rate control to use legacy rate as last MRR"
+resulted in the mixing of HT/legacy rates in a single rateset,
+which is undesirable. Revert this behavior.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 35 +++++++++--------------------------
+ 1 file changed, 9 insertions(+), 26 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -582,8 +582,7 @@ static u8 ath_rc_setvalid_htrates(struct
+ }
+ 
+ static u8 ath_rc_get_highest_rix(struct ath_rate_priv *ath_rc_priv,
+-				 int *is_probing,
+-				 bool legacy)
++				 int *is_probing)
+ {
+ 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	u32 best_thruput, this_thruput, now_msec;
+@@ -605,8 +604,6 @@ static u8 ath_rc_get_highest_rix(struct
+ 		u8 per_thres;
+ 
+ 		rate = ath_rc_priv->valid_rate_index[index];
+-		if (legacy && !(rate_table->info[rate].rate_flags & RC_LEGACY))
+-			continue;
+ 		if (rate > ath_rc_priv->rate_max_phy)
+ 			continue;
+ 
+@@ -770,7 +767,7 @@ static void ath_get_rate(void *priv, str
+ 	try_per_rate = 4;
+ 
+ 	rate_table = ath_rc_priv->rate_table;
+-	rix = ath_rc_get_highest_rix(ath_rc_priv, &is_probe, false);
++	rix = ath_rc_get_highest_rix(ath_rc_priv, &is_probe);
+ 
+ 	if (conf_is_ht(&sc->hw->conf) &&
+ 	    (sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING))
+@@ -804,7 +801,13 @@ static void ath_get_rate(void *priv, str
+ 				       try_per_rate, rix, 0);
+ 	}
+ 
+-	for ( ; i < 3; i++) {
++	for ( ; i < 4; i++) {
++		/*
++		 * Use twice the number of tries for the last MRR segment.
++		 */
++		if (i + 1 == 4)
++			try_per_rate = 8;
++
+ 		ath_rc_get_lower_rix(ath_rc_priv, rix, &rix);
+ 
+ 		/*
+@@ -815,26 +818,6 @@ static void ath_get_rate(void *priv, str
+ 	}
+ 
+ 	/*
+-	 * Use twice the number of tries for the last MRR segment.
+-	 */
+-	try_per_rate = 8;
+-
+-	/*
+-	 * If the last rate in the rate series is MCS and has
+-	 * more than 80% of per thresh, then use a legacy rate
+-	 * as last retry to ensure that the frame is tried in both
+-	 * MCS and legacy rate.
+-	 */
+-	ath_rc_get_lower_rix(ath_rc_priv, rix, &rix);
+-
+-	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy) &&
+-	    (ath_rc_priv->per[rix] > 45))
+-		rix = ath_rc_get_highest_rix(ath_rc_priv, &is_probe, true);
+-
+-	/* All other rates in the series have RTS enabled */
+-	ath_rc_rate_set_series(rate_table, &rates[i], txrc,
+-			       try_per_rate, rix, 1);
+-	/*
+ 	 * NB:Change rate series to enable aggregation when operating
+ 	 * at lower MCS rates. When first rate in series is MCS2
+ 	 * in HT40 @ 2.4GHz, series should look like:
diff --git a/linux-next-cherry-picks/0210-ath9k-Remove-ath_rc_set_valid_rate_idx.patch b/linux-next-cherry-picks/0210-ath9k-Remove-ath_rc_set_valid_rate_idx.patch
new file mode 100644
index 0000000..c0989c0
--- /dev/null
+++ b/linux-next-cherry-picks/0210-ath9k-Remove-ath_rc_set_valid_rate_idx.patch
@@ -0,0 +1,54 @@
+From dc456c455404d4ab5ad782f606b3743f913de365 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:37 +0530
+Subject: [PATCH 210/226] ath9k: Remove ath_rc_set_valid_rate_idx
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 13 +++----------
+ 1 file changed, 3 insertions(+), 10 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -424,13 +424,6 @@ static void ath_rc_sort_validrates(struc
+ 	}
+ }
+ 
+-static inline void ath_rc_set_valid_rate_idx(struct ath_rate_priv *ath_rc_priv,
+-					   u8 index, int valid_tx_rate)
+-{
+-	BUG_ON(index > ath_rc_priv->rate_table_size);
+-	ath_rc_priv->valid_rate_index[index] = !!valid_tx_rate;
+-}
+-
+ static inline
+ int ath_rc_get_nextvalid_txrate(const struct ath_rate_table *rate_table,
+ 				struct ath_rate_priv *ath_rc_priv,
+@@ -503,7 +496,7 @@ static u8 ath_rc_init_validrates(struct
+ 
+ 			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = i;
+ 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+-			ath_rc_set_valid_rate_idx(ath_rc_priv, i, 1);
++			ath_rc_priv->valid_rate_index[i] = true;
+ 			hi = i;
+ 		}
+ 	}
+@@ -539,7 +532,7 @@ static u8 ath_rc_setvalid_rates(struct a
+ 			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
+ 			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
+ 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+-			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
++			ath_rc_priv->valid_rate_index[j] = true;
+ 			hi = max(hi, j);
+ 		}
+ 	}
+@@ -573,7 +566,7 @@ static u8 ath_rc_setvalid_htrates(struct
+ 			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
+ 			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
+ 			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+-			ath_rc_set_valid_rate_idx(ath_rc_priv, j, 1);
++			ath_rc_priv->valid_rate_index[j] = true;
+ 			hi = max(hi, j);
+ 		}
+ 	}
diff --git a/linux-next-cherry-picks/0211-ath9k-Unify-valid-rate-calculation-routines.patch b/linux-next-cherry-picks/0211-ath9k-Unify-valid-rate-calculation-routines.patch
new file mode 100644
index 0000000..272a5eb
--- /dev/null
+++ b/linux-next-cherry-picks/0211-ath9k-Unify-valid-rate-calculation-routines.patch
@@ -0,0 +1,124 @@
+From 9f228fe77e6f85f06244c57d1a84a2e6ee5a9e02 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:44 +0530
+Subject: [PATCH 211/226] ath9k: Unify valid rate calculation routines
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 74 +++++++++++++++++++------------------
+ 1 file changed, 39 insertions(+), 35 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -504,50 +504,49 @@ static u8 ath_rc_init_validrates(struct
+ 	return hi;
+ }
+ 
+-static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv)
++static inline bool ath_rc_check_legacy(u8 rate, u8 dot11rate, u16 rate_flags,
++				       u32 phy, u32 capflag)
+ {
+-	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+-	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
+-	u32 phy, capflag = ath_rc_priv->ht_cap;
+-	u16 rate_flags;
+-	u8 i, j, hi = 0, rate, dot11rate, valid_rate_count;
++	if (rate != dot11rate || WLAN_RC_PHY_HT(phy))
++		return false;
+ 
+-	for (i = 0; i < rateset->rs_nrates; i++) {
+-		for (j = 0; j < rate_table->rate_cnt; j++) {
+-			phy = rate_table->info[j].phy;
+-			rate_flags = rate_table->info[j].rate_flags;
+-			rate = rateset->rs_rates[i];
+-			dot11rate = rate_table->info[j].dot11rate;
++	if ((rate_flags & WLAN_RC_CAP_MODE(capflag)) != WLAN_RC_CAP_MODE(capflag))
++		return false;
+ 
+-			if (rate != dot11rate
+-			    || ((rate_flags & WLAN_RC_CAP_MODE(capflag)) !=
+-				WLAN_RC_CAP_MODE(capflag))
+-			    || !(rate_flags & WLAN_RC_CAP_STREAM(capflag))
+-			    || WLAN_RC_PHY_HT(phy))
+-				continue;
++	if (!(rate_flags & WLAN_RC_CAP_STREAM(capflag)))
++		return false;
+ 
+-			if (!ath_rc_valid_phyrate(phy, capflag, 0))
+-				continue;
++	return true;
++}
+ 
+-			valid_rate_count = ath_rc_priv->valid_phy_ratecnt[phy];
+-			ath_rc_priv->valid_phy_rateidx[phy][valid_rate_count] = j;
+-			ath_rc_priv->valid_phy_ratecnt[phy] += 1;
+-			ath_rc_priv->valid_rate_index[j] = true;
+-			hi = max(hi, j);
+-		}
+-	}
++static inline bool ath_rc_check_ht(u8 rate, u8 dot11rate, u16 rate_flags,
++				   u32 phy, u32 capflag)
++{
++	if (rate != dot11rate || !WLAN_RC_PHY_HT(phy))
++		return false;
+ 
+-	return hi;
++	if (!WLAN_RC_PHY_HT_VALID(rate_flags, capflag))
++		return false;
++
++	if (!(rate_flags & WLAN_RC_CAP_STREAM(capflag)))
++		return false;
++
++	return true;
+ }
+ 
+-static u8 ath_rc_setvalid_htrates(struct ath_rate_priv *ath_rc_priv)
++static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv, bool legacy)
+ {
+ 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+-	struct ath_rateset *rateset = &ath_rc_priv->neg_ht_rates;
++	struct ath_rateset *rateset;
+ 	u32 phy, capflag = ath_rc_priv->ht_cap;
+ 	u16 rate_flags;
+ 	u8 i, j, hi = 0, rate, dot11rate, valid_rate_count;
+ 
++	if (legacy)
++		rateset = &ath_rc_priv->neg_rates;
++	else
++		rateset = &ath_rc_priv->neg_ht_rates;
++
+ 	for (i = 0; i < rateset->rs_nrates; i++) {
+ 		for (j = 0; j < rate_table->rate_cnt; j++) {
+ 			phy = rate_table->info[j].phy;
+@@ -555,9 +554,14 @@ static u8 ath_rc_setvalid_htrates(struct
+ 			rate = rateset->rs_rates[i];
+ 			dot11rate = rate_table->info[j].dot11rate;
+ 
+-			if ((rate != dot11rate) || !WLAN_RC_PHY_HT(phy) ||
+-			    !(rate_flags & WLAN_RC_CAP_STREAM(capflag)) ||
+-			    !WLAN_RC_PHY_HT_VALID(rate_flags, capflag))
++			if (legacy &&
++			    !ath_rc_check_legacy(rate, dot11rate,
++						 rate_flags, phy, capflag))
++				continue;
++
++			if (!legacy &&
++			    !ath_rc_check_ht(rate, dot11rate,
++					     rate_flags, phy, capflag))
+ 				continue;
+ 
+ 			if (!ath_rc_valid_phyrate(phy, capflag, 0))
+@@ -1181,10 +1185,10 @@ static void ath_rc_init(struct ath_softc
+ 	if (!rateset->rs_nrates) {
+ 		hi = ath_rc_init_validrates(ath_rc_priv);
+ 	} else {
+-		hi = ath_rc_setvalid_rates(ath_rc_priv);
++		hi = ath_rc_setvalid_rates(ath_rc_priv, true);
+ 
+ 		if (ath_rc_priv->ht_cap & WLAN_RC_HT_FLAG)
+-			hthi = ath_rc_setvalid_htrates(ath_rc_priv);
++			hthi = ath_rc_setvalid_rates(ath_rc_priv, false);
+ 
+ 		hi = max(hi, hthi);
+ 	}
diff --git a/linux-next-cherry-picks/0212-ath9k-Do-not-set-IEEE80211_TX_RC_USE_SHORT_PREAMBLE.patch b/linux-next-cherry-picks/0212-ath9k-Do-not-set-IEEE80211_TX_RC_USE_SHORT_PREAMBLE.patch
new file mode 100644
index 0000000..19c8715
--- /dev/null
+++ b/linux-next-cherry-picks/0212-ath9k-Do-not-set-IEEE80211_TX_RC_USE_SHORT_PREAMBLE.patch
@@ -0,0 +1,24 @@
+From 9af50d6c777b219da2a8acda9da6f9a29c8fe6cd Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:50 +0530
+Subject: [PATCH 212/226] ath9k: Do not set IEEE80211_TX_RC_USE_SHORT_PREAMBLE
+
+mac80211 does it for us.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 2 --
+ 1 file changed, 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -682,8 +682,6 @@ static void ath_rc_rate_set_series(const
+ 	rate->count = tries;
+ 	rate->idx = rate_table->info[rix].ratecode;
+ 
+-	if (txrc->short_preamble)
+-		rate->flags |= IEEE80211_TX_RC_USE_SHORT_PREAMBLE;
+ 	if (txrc->rts || rtsctsenable)
+ 		rate->flags |= IEEE80211_TX_RC_USE_RTS_CTS;
+ 
diff --git a/linux-next-cherry-picks/0213-ath9k-Fix-RTS-CTS-rate-selection.patch b/linux-next-cherry-picks/0213-ath9k-Fix-RTS-CTS-rate-selection.patch
new file mode 100644
index 0000000..6b8552d
--- /dev/null
+++ b/linux-next-cherry-picks/0213-ath9k-Fix-RTS-CTS-rate-selection.patch
@@ -0,0 +1,78 @@
+From b38f12697ce9e543af3261ad17d446cb7d64a04e Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:46:57 +0530
+Subject: [PATCH 213/226] ath9k: Fix RTS/CTS rate selection
+
+The current method of assigning the RTS/CTS rate is completely
+broken for HT mode and breaks P2P operation. Fix this by using
+the basic_rates provided to the driver by mac80211. For now,
+choose the lowest supported basic rate for HT frames.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 41 +++++++++++++------------------------
+ 1 file changed, 14 insertions(+), 27 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -699,37 +699,25 @@ static void ath_rc_rate_set_rtscts(struc
+ 				   const struct ath_rate_table *rate_table,
+ 				   struct ieee80211_tx_info *tx_info)
+ {
+-	struct ieee80211_tx_rate *rates = tx_info->control.rates;
+-	int i = 0, rix = 0, cix, enable_g_protection = 0;
++	struct ieee80211_bss_conf *bss_conf;
+ 
+-	/* get the cix for the lowest valid rix */
+-	for (i = 3; i >= 0; i--) {
+-		if (rates[i].count && (rates[i].idx >= 0)) {
+-			rix = ath_rc_get_rateindex(rate_table, &rates[i]);
+-			break;
+-		}
+-	}
+-	cix = rate_table->info[rix].ctrl_rate;
++	if (!tx_info->control.vif)
++		return;
++	/*
++	 * For legacy frames, mac80211 takes care of CTS protection.
++	 */
++	if (!(tx_info->control.rates[0].flags & IEEE80211_TX_RC_MCS))
++		return;
++
++	bss_conf = &tx_info->control.vif->bss_conf;
+ 
+-	/* All protection frames are transmited at 2Mb/s for 802.11g,
+-	 * otherwise we transmit them at 1Mb/s */
+-	if (sc->hw->conf.channel->band == IEEE80211_BAND_2GHZ &&
+-	    !conf_is_ht(&sc->hw->conf))
+-		enable_g_protection = 1;
++	if (!bss_conf->basic_rates)
++		return;
+ 
+ 	/*
+-	 * If 802.11g protection is enabled, determine whether to use RTS/CTS or
+-	 * just CTS.  Note that this is only done for OFDM/HT unicast frames.
++	 * For now, use the lowest allowed basic rate for HT frames.
+ 	 */
+-	if ((tx_info->control.vif &&
+-	     tx_info->control.vif->bss_conf.use_cts_prot) &&
+-	    (rate_table->info[rix].phy == WLAN_RC_PHY_OFDM ||
+-	     WLAN_RC_PHY_HT(rate_table->info[rix].phy))) {
+-		rates[0].flags |= IEEE80211_TX_RC_USE_CTS_PROTECT;
+-		cix = rate_table->info[enable_g_protection].ctrl_rate;
+-	}
+-
+-	tx_info->control.rts_cts_rate_idx = cix;
++	tx_info->control.rts_cts_rate_idx = __ffs(bss_conf->basic_rates);
+ }
+ 
+ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
+@@ -853,7 +841,6 @@ static void ath_get_rate(void *priv, str
+ 		rates[0].count = ATH_TXMAXTRY;
+ 	}
+ 
+-	/* Setup RTS/CTS */
+ 	ath_rc_rate_set_rtscts(sc, rate_table, tx_info);
+ }
+ 
diff --git a/linux-next-cherry-picks/0214-ath9k-Bail-out-properly-before-calculating-rate-inde.patch b/linux-next-cherry-picks/0214-ath9k-Bail-out-properly-before-calculating-rate-inde.patch
new file mode 100644
index 0000000..a9596e7
--- /dev/null
+++ b/linux-next-cherry-picks/0214-ath9k-Bail-out-properly-before-calculating-rate-inde.patch
@@ -0,0 +1,56 @@
+From 31a9496f57de6e14dd43c85b578e10ff32abff5b Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:47:03 +0530
+Subject: [PATCH 214/226] ath9k: Bail out properly before calculating rate
+ index
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 24 +++++++++++-------------
+ 1 file changed, 11 insertions(+), 13 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -1264,23 +1264,12 @@ static void ath_tx_status(void *priv, st
+ 	struct ath_softc *sc = priv;
+ 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+ 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+-	struct ieee80211_hdr *hdr;
++	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+ 	int final_ts_idx = 0, tx_status = 0;
+ 	int long_retry = 0;
+-	__le16 fc;
++	__le16 fc = hdr->frame_control;
+ 	int i;
+ 
+-	hdr = (struct ieee80211_hdr *)skb->data;
+-	fc = hdr->frame_control;
+-	for (i = 0; i < sc->hw->max_rates; i++) {
+-		struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
+-		if (rate->idx < 0 || !rate->count)
+-			break;
+-
+-		final_ts_idx = i;
+-		long_retry = rate->count - 1;
+-	}
+-
+ 	if (!priv_sta || !ieee80211_is_data(fc))
+ 		return;
+ 
+@@ -1292,6 +1281,15 @@ static void ath_tx_status(void *priv, st
+ 	if (tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED)
+ 		return;
+ 
++	for (i = 0; i < sc->hw->max_rates; i++) {
++		struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
++		if (rate->idx < 0 || !rate->count)
++			break;
++
++		final_ts_idx = i;
++		long_retry = rate->count - 1;
++	}
++
+ 	if (!(tx_info->flags & IEEE80211_TX_STAT_ACK))
+ 		tx_status = 1;
+ 
diff --git a/linux-next-cherry-picks/0215-ath9k-Cleanup-TX-status-API.patch b/linux-next-cherry-picks/0215-ath9k-Cleanup-TX-status-API.patch
new file mode 100644
index 0000000..2c83b5a
--- /dev/null
+++ b/linux-next-cherry-picks/0215-ath9k-Cleanup-TX-status-API.patch
@@ -0,0 +1,164 @@
+From bf6a5378bcddb00f466c13dd4970d2b3949914ab Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:47:09 +0530
+Subject: [PATCH 215/226] ath9k: Cleanup TX status API
+
+Calculate the final rate index inside ath_rc_tx_status().
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 71 +++++++++++++++----------------------
+ 1 file changed, 29 insertions(+), 42 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -993,9 +993,6 @@ static void ath_debug_stat_retries(struc
+ 	stats->per = per;
+ }
+ 
+-/* Update PER, RSSI and whatever else that the code thinks it is doing.
+-   If you can make sense of all this, you really need to go out more. */
+-
+ static void ath_rc_update_ht(struct ath_softc *sc,
+ 			     struct ath_rate_priv *ath_rc_priv,
+ 			     struct ieee80211_tx_info *tx_info,
+@@ -1069,25 +1066,43 @@ static void ath_rc_update_ht(struct ath_
+ 
+ }
+ 
++static void ath_debug_stat_rc(struct ath_rate_priv *rc, int final_rate)
++{
++	struct ath_rc_stats *stats;
++
++	stats = &rc->rcstats[final_rate];
++	stats->success++;
++}
+ 
+ static void ath_rc_tx_status(struct ath_softc *sc,
+ 			     struct ath_rate_priv *ath_rc_priv,
+-			     struct ieee80211_tx_info *tx_info,
+-			     int final_ts_idx, int xretries, int long_retry)
++			     struct sk_buff *skb)
+ {
+-	const struct ath_rate_table *rate_table;
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
++	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+ 	struct ieee80211_tx_rate *rates = tx_info->status.rates;
++	struct ieee80211_tx_rate *rate;
++	int final_ts_idx = 0, xretries = 0, long_retry = 0;
+ 	u8 flags;
+ 	u32 i = 0, rix;
+ 
+-	rate_table = ath_rc_priv->rate_table;
++	for (i = 0; i < sc->hw->max_rates; i++) {
++		rate = &tx_info->status.rates[i];
++		if (rate->idx < 0 || !rate->count)
++			break;
++
++		final_ts_idx = i;
++		long_retry = rate->count - 1;
++	}
++
++	if (!(tx_info->flags & IEEE80211_TX_STAT_ACK))
++		xretries = 1;
+ 
+ 	/*
+ 	 * If the first rate is not the final index, there
+ 	 * are intermediate rate failures to be processed.
+ 	 */
+ 	if (final_ts_idx != 0) {
+-		/* Process intermediate rates that failed.*/
+ 		for (i = 0; i < final_ts_idx ; i++) {
+ 			if (rates[i].count != 0 && (rates[i].idx >= 0)) {
+ 				flags = rates[i].flags;
+@@ -1101,8 +1116,8 @@ static void ath_rc_tx_status(struct ath_
+ 
+ 				rix = ath_rc_get_rateindex(rate_table, &rates[i]);
+ 				ath_rc_update_ht(sc, ath_rc_priv, tx_info,
+-						rix, xretries ? 1 : 2,
+-						rates[i].count);
++						 rix, xretries ? 1 : 2,
++						 rates[i].count);
+ 			}
+ 		}
+ 	} else {
+@@ -1116,15 +1131,16 @@ static void ath_rc_tx_status(struct ath_
+ 			xretries = 2;
+ 	}
+ 
+-	flags = rates[i].flags;
++	flags = rates[final_ts_idx].flags;
+ 
+ 	/* If HT40 and we have switched mode from 40 to 20 => don't update */
+ 	if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
+ 	    !(ath_rc_priv->ht_cap & WLAN_RC_40_FLAG))
+ 		return;
+ 
+-	rix = ath_rc_get_rateindex(rate_table, &rates[i]);
++	rix = ath_rc_get_rateindex(rate_table, &rates[final_ts_idx]);
+ 	ath_rc_update_ht(sc, ath_rc_priv, tx_info, rix, xretries, long_retry);
++	ath_debug_stat_rc(ath_rc_priv, rix);
+ }
+ 
+ static const
+@@ -1248,15 +1264,6 @@ static bool ath_tx_aggr_check(struct ath
+ /* mac80211 Rate Control callbacks */
+ /***********************************/
+ 
+-static void ath_debug_stat_rc(struct ath_rate_priv *rc, int final_rate)
+-{
+-	struct ath_rc_stats *stats;
+-
+-	stats = &rc->rcstats[final_rate];
+-	stats->success++;
+-}
+-
+-
+ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
+ 			  struct ieee80211_sta *sta, void *priv_sta,
+ 			  struct sk_buff *skb)
+@@ -1265,10 +1272,7 @@ static void ath_tx_status(void *priv, st
+ 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+ 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+ 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+-	int final_ts_idx = 0, tx_status = 0;
+-	int long_retry = 0;
+ 	__le16 fc = hdr->frame_control;
+-	int i;
+ 
+ 	if (!priv_sta || !ieee80211_is_data(fc))
+ 		return;
+@@ -1281,20 +1285,7 @@ static void ath_tx_status(void *priv, st
+ 	if (tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED)
+ 		return;
+ 
+-	for (i = 0; i < sc->hw->max_rates; i++) {
+-		struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
+-		if (rate->idx < 0 || !rate->count)
+-			break;
+-
+-		final_ts_idx = i;
+-		long_retry = rate->count - 1;
+-	}
+-
+-	if (!(tx_info->flags & IEEE80211_TX_STAT_ACK))
+-		tx_status = 1;
+-
+-	ath_rc_tx_status(sc, ath_rc_priv, tx_info, final_ts_idx, tx_status,
+-			 long_retry);
++	ath_rc_tx_status(sc, ath_rc_priv, skb);
+ 
+ 	/* Check if aggregation has to be enabled for this tid */
+ 	if (conf_is_ht(&sc->hw->conf) &&
+@@ -1310,10 +1301,6 @@ static void ath_tx_status(void *priv, st
+ 				ieee80211_start_tx_ba_session(sta, tid, 0);
+ 		}
+ 	}
+-
+-	ath_debug_stat_rc(ath_rc_priv,
+-		ath_rc_get_rateindex(ath_rc_priv->rate_table,
+-			&tx_info->status.rates[final_ts_idx]));
+ }
+ 
+ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
diff --git a/linux-next-cherry-picks/0216-ath9k-Remove-MIMO-PS-specific-code.patch b/linux-next-cherry-picks/0216-ath9k-Remove-MIMO-PS-specific-code.patch
new file mode 100644
index 0000000..3200f33
--- /dev/null
+++ b/linux-next-cherry-picks/0216-ath9k-Remove-MIMO-PS-specific-code.patch
@@ -0,0 +1,29 @@
+From 204f43a3ccee8932d98304aaa5dae1a2ecdf9805 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:47:16 +0530
+Subject: [PATCH 216/226] ath9k: Remove MIMO-PS specific code
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 9 ---------
+ 1 file changed, 9 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -1120,15 +1120,6 @@ static void ath_rc_tx_status(struct ath_
+ 						 rates[i].count);
+ 			}
+ 		}
+-	} else {
+-		/*
+-		 * Handle the special case of MIMO PS burst, where the second
+-		 * aggregate is sent out with only one rate and one try.
+-		 * Treating it as an excessive retry penalizes the rate
+-		 * inordinately.
+-		 */
+-		if (rates[0].count == 1 && xretries == 1)
+-			xretries = 2;
+ 	}
+ 
+ 	flags = rates[final_ts_idx].flags;
diff --git a/linux-next-cherry-picks/0217-ath9k-Trim-rate-table.patch b/linux-next-cherry-picks/0217-ath9k-Trim-rate-table.patch
new file mode 100644
index 0000000..289acd7
--- /dev/null
+++ b/linux-next-cherry-picks/0217-ath9k-Trim-rate-table.patch
@@ -0,0 +1,600 @@
+From 6421adbdc4b11cde511f37b9f32657b3e3c4469f Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:47:23 +0530
+Subject: [PATCH 217/226] ath9k: Trim rate table
+
+Remove ctrl_rate, cw40index, sgi_index, ht_index and calculate
+the rate index for TX status from the valid_rate_index that
+is populated at initialization time.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 350 ++++++++++++++++++------------------
+ drivers/net/wireless/ath/ath9k/rc.h |   4 -
+ 2 files changed, 174 insertions(+), 180 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -25,141 +25,141 @@ static const struct ath_rate_table ar541
+ 	8, /* MCS start */
+ 	{
+ 		[0] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 6000,
+-			5400, 0, 12, 0, 0, 0, 0 }, /* 6 Mb */
++			5400, 0, 12 }, /* 6 Mb */
+ 		[1] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 9000,
+-			7800,  1, 18, 0, 1, 1, 1 }, /* 9 Mb */
++			7800,  1, 18 }, /* 9 Mb */
+ 		[2] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 12000,
+-			10000, 2, 24, 2, 2, 2, 2 }, /* 12 Mb */
++			10000, 2, 24 }, /* 12 Mb */
+ 		[3] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 18000,
+-			13900, 3, 36, 2, 3, 3, 3 }, /* 18 Mb */
++			13900, 3, 36 }, /* 18 Mb */
+ 		[4] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 24000,
+-			17300, 4, 48, 4, 4, 4, 4 }, /* 24 Mb */
++			17300, 4, 48 }, /* 24 Mb */
+ 		[5] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 36000,
+-			23000, 5, 72, 4, 5, 5, 5 }, /* 36 Mb */
++			23000, 5, 72 }, /* 36 Mb */
+ 		[6] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 48000,
+-			27400, 6, 96, 4, 6, 6, 6 }, /* 48 Mb */
++			27400, 6, 96 }, /* 48 Mb */
+ 		[7] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 54000,
+-			29300, 7, 108, 4, 7, 7, 7 }, /* 54 Mb */
++			29300, 7, 108 }, /* 54 Mb */
+ 		[8] = { RC_HT_SDT_2040, WLAN_RC_PHY_HT_20_SS, 6500,
+-			6400, 0, 0, 0, 38, 8, 38 }, /* 6.5 Mb */
++			6400, 0, 0 }, /* 6.5 Mb */
+ 		[9] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 13000,
+-			12700, 1, 1, 2, 39, 9, 39 }, /* 13 Mb */
++			12700, 1, 1 }, /* 13 Mb */
+ 		[10] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 19500,
+-			18800, 2, 2, 2, 40, 10, 40 }, /* 19.5 Mb */
++			18800, 2, 2 }, /* 19.5 Mb */
+ 		[11] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 26000,
+-			25000, 3, 3, 4, 41, 11, 41 }, /* 26 Mb */
++			25000, 3, 3 }, /* 26 Mb */
+ 		[12] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 39000,
+-			36700, 4, 4, 4, 42, 12, 42 }, /* 39 Mb */
++			36700, 4, 4 }, /* 39 Mb */
+ 		[13] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 52000,
+-			48100, 5, 5, 4, 43, 13, 43 }, /* 52 Mb */
++			48100, 5, 5 }, /* 52 Mb */
+ 		[14] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 58500,
+-			53500, 6, 6, 4, 44, 14, 44 }, /* 58.5 Mb */
++			53500, 6, 6 }, /* 58.5 Mb */
+ 		[15] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 65000,
+-			59000, 7, 7, 4, 45, 16, 46 }, /* 65 Mb */
++			59000, 7, 7 }, /* 65 Mb */
+ 		[16] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS_HGI, 72200,
+-			65400, 7, 7, 4, 45, 16, 46 }, /* 75 Mb */
++			65400, 7, 7 }, /* 75 Mb */
+ 		[17] = { RC_INVALID, WLAN_RC_PHY_HT_20_DS, 13000,
+-			12700, 8, 8, 0, 47, 17, 47 }, /* 13 Mb */
++			12700, 8, 8 }, /* 13 Mb */
+ 		[18] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 26000,
+-			24800, 9, 9, 2, 48, 18, 48 }, /* 26 Mb */
++			24800, 9, 9 }, /* 26 Mb */
+ 		[19] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 39000,
+-			36600, 10, 10, 2, 49, 19, 49 }, /* 39 Mb */
++			36600, 10, 10 }, /* 39 Mb */
+ 		[20] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 52000,
+-			48100, 11, 11, 4, 50, 20, 50 }, /* 52 Mb */
++			48100, 11, 11 }, /* 52 Mb */
+ 		[21] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 78000,
+-			69500, 12, 12, 4, 51, 21, 51 }, /* 78 Mb */
++			69500, 12, 12 }, /* 78 Mb */
+ 		[22] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 104000,
+-			89500, 13, 13, 4, 52, 22, 52 }, /* 104 Mb */
++			89500, 13, 13 }, /* 104 Mb */
+ 		[23] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 117000,
+-			98900, 14, 14, 4, 53, 23, 53 }, /* 117 Mb */
++			98900, 14, 14 }, /* 117 Mb */
+ 		[24] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 130000,
+-			108300, 15, 15, 4, 54, 25, 55 }, /* 130 Mb */
++			108300, 15, 15 }, /* 130 Mb */
+ 		[25] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS_HGI, 144400,
+-			120000, 15, 15, 4, 54, 25, 55 }, /* 144.4 Mb */
++			120000, 15, 15 }, /* 144.4 Mb */
+ 		[26] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 19500,
+-			17400, 16, 16, 0, 56, 26, 56 }, /* 19.5 Mb */
++			17400, 16, 16 }, /* 19.5 Mb */
+ 		[27] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 39000,
+-			35100, 17, 17, 2, 57, 27, 57 }, /* 39 Mb */
++			35100, 17, 17 }, /* 39 Mb */
+ 		[28] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 58500,
+-			52600, 18, 18, 2, 58, 28, 58 }, /* 58.5 Mb */
++			52600, 18, 18 }, /* 58.5 Mb */
+ 		[29] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 78000,
+-			70400, 19, 19, 4, 59, 29, 59 }, /* 78 Mb */
++			70400, 19, 19 }, /* 78 Mb */
+ 		[30] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 117000,
+-			104900, 20, 20, 4, 60, 31, 61 }, /* 117 Mb */
++			104900, 20, 20 }, /* 117 Mb */
+ 		[31] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS_HGI, 130000,
+-			115800, 20, 20, 4, 60, 31, 61 }, /* 130 Mb*/
++			115800, 20, 20 }, /* 130 Mb*/
+ 		[32] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 156000,
+-			137200, 21, 21, 4, 62, 33, 63 }, /* 156 Mb */
++			137200, 21, 21 }, /* 156 Mb */
+ 		[33] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 173300,
+-			151100, 21, 21, 4, 62, 33, 63 }, /* 173.3 Mb */
++			151100, 21, 21 }, /* 173.3 Mb */
+ 		[34] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 175500,
+-			152800, 22, 22, 4, 64, 35, 65 }, /* 175.5 Mb */
++			152800, 22, 22 }, /* 175.5 Mb */
+ 		[35] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 195000,
+-			168400, 22, 22, 4, 64, 35, 65 }, /* 195 Mb*/
++			168400, 22, 22 }, /* 195 Mb*/
+ 		[36] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 195000,
+-			168400, 23, 23, 4, 66, 37, 67 }, /* 195 Mb */
++			168400, 23, 23 }, /* 195 Mb */
+ 		[37] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 216700,
+-			185000, 23, 23, 4, 66, 37, 67 }, /* 216.7 Mb */
++			185000, 23, 23 }, /* 216.7 Mb */
+ 		[38] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 13500,
+-			13200, 0, 0, 0, 38, 38, 38 }, /* 13.5 Mb*/
++			13200, 0, 0 }, /* 13.5 Mb*/
+ 		[39] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 27500,
+-			25900, 1, 1, 2, 39, 39, 39 }, /* 27.0 Mb*/
++			25900, 1, 1 }, /* 27.0 Mb*/
+ 		[40] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 40500,
+-			38600, 2, 2, 2, 40, 40, 40 }, /* 40.5 Mb*/
++			38600, 2, 2 }, /* 40.5 Mb*/
+ 		[41] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 54000,
+-			49800, 3, 3, 4, 41, 41, 41 }, /* 54 Mb */
++			49800, 3, 3 }, /* 54 Mb */
+ 		[42] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 81500,
+-			72200, 4, 4, 4, 42, 42, 42 }, /* 81 Mb */
++			72200, 4, 4 }, /* 81 Mb */
+ 		[43] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 108000,
+-			92900, 5, 5, 4, 43, 43, 43 }, /* 108 Mb */
++			92900, 5, 5 }, /* 108 Mb */
+ 		[44] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 121500,
+-			102700, 6, 6, 4, 44, 44, 44 }, /* 121.5 Mb*/
++			102700, 6, 6 }, /* 121.5 Mb*/
+ 		[45] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 135000,
+-			112000, 7, 7, 4, 45, 46, 46 }, /* 135 Mb */
++			112000, 7, 7 }, /* 135 Mb */
+ 		[46] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000,
+-			122000, 7, 7, 4, 45, 46, 46 }, /* 150 Mb */
++			122000, 7, 7 }, /* 150 Mb */
+ 		[47] = { RC_INVALID, WLAN_RC_PHY_HT_40_DS, 27000,
+-			25800, 8, 8, 0, 47, 47, 47 }, /* 27 Mb */
++			25800, 8, 8 }, /* 27 Mb */
+ 		[48] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 54000,
+-			49800, 9, 9, 2, 48, 48, 48 }, /* 54 Mb */
++			49800, 9, 9 }, /* 54 Mb */
+ 		[49] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 81000,
+-			71900, 10, 10, 2, 49, 49, 49 }, /* 81 Mb */
++			71900, 10, 10 }, /* 81 Mb */
+ 		[50] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 108000,
+-			92500, 11, 11, 4, 50, 50, 50 }, /* 108 Mb */
++			92500, 11, 11 }, /* 108 Mb */
+ 		[51] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 162000,
+-			130300, 12, 12, 4, 51, 51, 51 }, /* 162 Mb */
++			130300, 12, 12 }, /* 162 Mb */
+ 		[52] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 216000,
+-			162800, 13, 13, 4, 52, 52, 52 }, /* 216 Mb */
++			162800, 13, 13 }, /* 216 Mb */
+ 		[53] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 243000,
+-			178200, 14, 14, 4, 53, 53, 53 }, /* 243 Mb */
++			178200, 14, 14 }, /* 243 Mb */
+ 		[54] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 270000,
+-			192100, 15, 15, 4, 54, 55, 55 }, /* 270 Mb */
++			192100, 15, 15 }, /* 270 Mb */
+ 		[55] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS_HGI, 300000,
+-			207000, 15, 15, 4, 54, 55, 55 }, /* 300 Mb */
++			207000, 15, 15 }, /* 300 Mb */
+ 		[56] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 40500,
+-			36100, 16, 16, 0, 56, 56, 56 }, /* 40.5 Mb */
++			36100, 16, 16 }, /* 40.5 Mb */
+ 		[57] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 81000,
+-			72900, 17, 17, 2, 57, 57, 57 }, /* 81 Mb */
++			72900, 17, 17 }, /* 81 Mb */
+ 		[58] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 121500,
+-			108300, 18, 18, 2, 58, 58, 58 }, /* 121.5 Mb */
++			108300, 18, 18 }, /* 121.5 Mb */
+ 		[59] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 162000,
+-			142000, 19, 19, 4, 59, 59, 59 }, /*  162 Mb */
++			142000, 19, 19 }, /*  162 Mb */
+ 		[60] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 243000,
+-			205100, 20, 20, 4, 60, 61, 61 }, /*  243 Mb */
++			205100, 20, 20 }, /*  243 Mb */
+ 		[61] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS_HGI, 270000,
+-			224700, 20, 20, 4, 60, 61, 61 }, /*  270 Mb */
++			224700, 20, 20 }, /*  270 Mb */
+ 		[62] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 324000,
+-			263100, 21, 21, 4, 62, 63, 63 }, /*  324 Mb */
++			263100, 21, 21 }, /*  324 Mb */
+ 		[63] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 360000,
+-			288000, 21, 21, 4, 62, 63, 63 }, /*  360 Mb */
++			288000, 21, 21 }, /*  360 Mb */
+ 		[64] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 364500,
+-			290700, 22, 22, 4, 64, 65, 65 }, /* 364.5 Mb */
++			290700, 22, 22 }, /* 364.5 Mb */
+ 		[65] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 405000,
+-			317200, 22, 22, 4, 64, 65, 65 }, /* 405 Mb */
++			317200, 22, 22 }, /* 405 Mb */
+ 		[66] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 405000,
+-			317200, 23, 23, 4, 66, 67, 67 }, /* 405 Mb */
++			317200, 23, 23 }, /* 405 Mb */
+ 		[67] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 450000,
+-			346400, 23, 23, 4, 66, 67, 67 }, /* 450 Mb */
++			346400, 23, 23 }, /* 450 Mb */
+ 	},
+ 	50,  /* probe interval */
+ 	WLAN_RC_HT_FLAG,  /* Phy rates allowed initially */
+@@ -173,149 +173,149 @@ static const struct ath_rate_table ar541
+ 	12, /* MCS start */
+ 	{
+ 		[0] = { RC_ALL, WLAN_RC_PHY_CCK, 1000,
+-			900, 0, 2, 0, 0, 0, 0 }, /* 1 Mb */
++			900, 0, 2 }, /* 1 Mb */
+ 		[1] = { RC_ALL, WLAN_RC_PHY_CCK, 2000,
+-			1900, 1, 4, 1, 1, 1, 1 }, /* 2 Mb */
++			1900, 1, 4 }, /* 2 Mb */
+ 		[2] = { RC_ALL, WLAN_RC_PHY_CCK, 5500,
+-			4900, 2, 11, 2, 2, 2, 2 }, /* 5.5 Mb */
++			4900, 2, 11 }, /* 5.5 Mb */
+ 		[3] = { RC_ALL, WLAN_RC_PHY_CCK, 11000,
+-			8100, 3, 22, 3, 3, 3, 3 }, /* 11 Mb */
++			8100, 3, 22 }, /* 11 Mb */
+ 		[4] = { RC_INVALID, WLAN_RC_PHY_OFDM, 6000,
+-			5400, 4, 12, 4, 4, 4, 4 }, /* 6 Mb */
++			5400, 4, 12 }, /* 6 Mb */
+ 		[5] = { RC_INVALID, WLAN_RC_PHY_OFDM, 9000,
+-			7800, 5, 18, 4, 5, 5, 5 }, /* 9 Mb */
++			7800, 5, 18 }, /* 9 Mb */
+ 		[6] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 12000,
+-			10100, 6, 24, 6, 6, 6, 6 }, /* 12 Mb */
++			10100, 6, 24 }, /* 12 Mb */
+ 		[7] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 18000,
+-			14100, 7, 36, 6, 7, 7, 7 }, /* 18 Mb */
++			14100, 7, 36 }, /* 18 Mb */
+ 		[8] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 24000,
+-			17700, 8, 48, 8, 8, 8, 8 }, /* 24 Mb */
++			17700, 8, 48 }, /* 24 Mb */
+ 		[9] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 36000,
+-			23700, 9, 72, 8, 9, 9, 9 }, /* 36 Mb */
++			23700, 9, 72 }, /* 36 Mb */
+ 		[10] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 48000,
+-			27400, 10, 96, 8, 10, 10, 10 }, /* 48 Mb */
++			27400, 10, 96 }, /* 48 Mb */
+ 		[11] = { RC_L_SDT, WLAN_RC_PHY_OFDM, 54000,
+-			30900, 11, 108, 8, 11, 11, 11 }, /* 54 Mb */
++			30900, 11, 108 }, /* 54 Mb */
+ 		[12] = { RC_INVALID, WLAN_RC_PHY_HT_20_SS, 6500,
+-			6400, 0, 0, 4, 42, 12, 42 }, /* 6.5 Mb */
++			6400, 0, 0 }, /* 6.5 Mb */
+ 		[13] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 13000,
+-			12700, 1, 1, 6, 43, 13, 43 }, /* 13 Mb */
++			12700, 1, 1 }, /* 13 Mb */
+ 		[14] = { RC_HT_SDT_20, WLAN_RC_PHY_HT_20_SS, 19500,
+-			18800, 2, 2, 6, 44, 14, 44 }, /* 19.5 Mb*/
++			18800, 2, 2 }, /* 19.5 Mb*/
+ 		[15] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 26000,
+-			25000, 3, 3, 8, 45, 15, 45 }, /* 26 Mb */
++			25000, 3, 3 }, /* 26 Mb */
+ 		[16] = { RC_HT_SD_20, WLAN_RC_PHY_HT_20_SS, 39000,
+-			36700, 4, 4, 8, 46, 16, 46 }, /* 39 Mb */
++			36700, 4, 4 }, /* 39 Mb */
+ 		[17] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 52000,
+-			48100, 5, 5, 8, 47, 17, 47 }, /* 52 Mb */
++			48100, 5, 5 }, /* 52 Mb */
+ 		[18] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 58500,
+-			53500, 6, 6, 8, 48, 18, 48 }, /* 58.5 Mb */
++			53500, 6, 6 }, /* 58.5 Mb */
+ 		[19] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS, 65000,
+-			59000, 7, 7, 8, 49, 20, 50 }, /* 65 Mb */
++			59000, 7, 7 }, /* 65 Mb */
+ 		[20] = { RC_HT_S_20, WLAN_RC_PHY_HT_20_SS_HGI, 72200,
+-			65400, 7, 7, 8, 49, 20, 50 }, /* 65 Mb*/
++			65400, 7, 7 }, /* 65 Mb*/
+ 		[21] = { RC_INVALID, WLAN_RC_PHY_HT_20_DS, 13000,
+-			12700, 8, 8, 4, 51, 21, 51 }, /* 13 Mb */
++			12700, 8, 8 }, /* 13 Mb */
+ 		[22] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 26000,
+-			24800, 9, 9, 6, 52, 22, 52 }, /* 26 Mb */
++			24800, 9, 9 }, /* 26 Mb */
+ 		[23] = { RC_HT_T_20, WLAN_RC_PHY_HT_20_DS, 39000,
+-			36600, 10, 10, 6, 53, 23, 53 }, /* 39 Mb */
++			36600, 10, 10 }, /* 39 Mb */
+ 		[24] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 52000,
+-			48100, 11, 11, 8, 54, 24, 54 }, /* 52 Mb */
++			48100, 11, 11 }, /* 52 Mb */
+ 		[25] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 78000,
+-			69500, 12, 12, 8, 55, 25, 55 }, /* 78 Mb */
++			69500, 12, 12 }, /* 78 Mb */
+ 		[26] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 104000,
+-			89500, 13, 13, 8, 56, 26, 56 }, /* 104 Mb */
++			89500, 13, 13 }, /* 104 Mb */
+ 		[27] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 117000,
+-			98900, 14, 14, 8, 57, 27, 57 }, /* 117 Mb */
++			98900, 14, 14 }, /* 117 Mb */
+ 		[28] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 130000,
+-			108300, 15, 15, 8, 58, 29, 59 }, /* 130 Mb */
++			108300, 15, 15 }, /* 130 Mb */
+ 		[29] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS_HGI, 144400,
+-			120000, 15, 15, 8, 58, 29, 59 }, /* 144.4 Mb */
++			120000, 15, 15 }, /* 144.4 Mb */
+ 		[30] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 19500,
+-			17400, 16, 16, 4, 60, 30, 60 }, /* 19.5 Mb */
++			17400, 16, 16 }, /* 19.5 Mb */
+ 		[31] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 39000,
+-			35100, 17, 17, 6, 61, 31, 61 }, /* 39 Mb */
++			35100, 17, 17 }, /* 39 Mb */
+ 		[32] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 58500,
+-			52600, 18, 18, 6, 62, 32, 62 }, /* 58.5 Mb */
++			52600, 18, 18 }, /* 58.5 Mb */
+ 		[33] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 78000,
+-			70400, 19, 19, 8, 63, 33, 63 }, /* 78 Mb */
++			70400, 19, 19 }, /* 78 Mb */
+ 		[34] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 117000,
+-			104900, 20, 20, 8, 64, 35, 65 }, /* 117 Mb */
++			104900, 20, 20 }, /* 117 Mb */
+ 		[35] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS_HGI, 130000,
+-			115800, 20, 20, 8, 64, 35, 65 }, /* 130 Mb */
++			115800, 20, 20 }, /* 130 Mb */
+ 		[36] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 156000,
+-			137200, 21, 21, 8, 66, 37, 67 }, /* 156 Mb */
++			137200, 21, 21 }, /* 156 Mb */
+ 		[37] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 173300,
+-			151100, 21, 21, 8, 66, 37, 67 }, /* 173.3 Mb */
++			151100, 21, 21 }, /* 173.3 Mb */
+ 		[38] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 175500,
+-			152800, 22, 22, 8, 68, 39, 69 }, /* 175.5 Mb */
++			152800, 22, 22 }, /* 175.5 Mb */
+ 		[39] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 195000,
+-			168400, 22, 22, 8, 68, 39, 69 }, /* 195 Mb */
++			168400, 22, 22 }, /* 195 Mb */
+ 		[40] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS, 195000,
+-			168400, 23, 23, 8, 70, 41, 71 }, /* 195 Mb */
++			168400, 23, 23 }, /* 195 Mb */
+ 		[41] = {  RC_HT_T_20, WLAN_RC_PHY_HT_20_TS_HGI, 216700,
+-			185000, 23, 23, 8, 70, 41, 71 }, /* 216.7 Mb */
++			185000, 23, 23 }, /* 216.7 Mb */
+ 		[42] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 13500,
+-			13200, 0, 0, 8, 42, 42, 42 }, /* 13.5 Mb */
++			13200, 0, 0 }, /* 13.5 Mb */
+ 		[43] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 27500,
+-			25900, 1, 1, 8, 43, 43, 43 }, /* 27.0 Mb */
++			25900, 1, 1 }, /* 27.0 Mb */
+ 		[44] = { RC_HT_SDT_40, WLAN_RC_PHY_HT_40_SS, 40500,
+-			38600, 2, 2, 8, 44, 44, 44 }, /* 40.5 Mb */
++			38600, 2, 2 }, /* 40.5 Mb */
+ 		[45] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 54000,
+-			49800, 3, 3, 8, 45, 45, 45 }, /* 54 Mb */
++			49800, 3, 3 }, /* 54 Mb */
+ 		[46] = { RC_HT_SD_40, WLAN_RC_PHY_HT_40_SS, 81500,
+-			72200, 4, 4, 8, 46, 46, 46 }, /* 81 Mb */
++			72200, 4, 4 }, /* 81 Mb */
+ 		[47] = { RC_HT_S_40 , WLAN_RC_PHY_HT_40_SS, 108000,
+-			92900, 5, 5, 8, 47, 47, 47 }, /* 108 Mb */
++			92900, 5, 5 }, /* 108 Mb */
+ 		[48] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 121500,
+-			102700, 6, 6, 8, 48, 48, 48 }, /* 121.5 Mb */
++			102700, 6, 6 }, /* 121.5 Mb */
+ 		[49] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS, 135000,
+-			112000, 7, 7, 8, 49, 50, 50 }, /* 135 Mb */
++			112000, 7, 7 }, /* 135 Mb */
+ 		[50] = { RC_HT_S_40, WLAN_RC_PHY_HT_40_SS_HGI, 150000,
+-			122000, 7, 7, 8, 49, 50, 50 }, /* 150 Mb */
++			122000, 7, 7 }, /* 150 Mb */
+ 		[51] = { RC_INVALID, WLAN_RC_PHY_HT_40_DS, 27000,
+-			25800, 8, 8, 8, 51, 51, 51 }, /* 27 Mb */
++			25800, 8, 8 }, /* 27 Mb */
+ 		[52] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 54000,
+-			49800, 9, 9, 8, 52, 52, 52 }, /* 54 Mb */
++			49800, 9, 9 }, /* 54 Mb */
+ 		[53] = { RC_HT_T_40, WLAN_RC_PHY_HT_40_DS, 81000,
+-			71900, 10, 10, 8, 53, 53, 53 }, /* 81 Mb */
++			71900, 10, 10 }, /* 81 Mb */
+ 		[54] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 108000,
+-			92500, 11, 11, 8, 54, 54, 54 }, /* 108 Mb */
++			92500, 11, 11 }, /* 108 Mb */
+ 		[55] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 162000,
+-			130300, 12, 12, 8, 55, 55, 55 }, /* 162 Mb */
++			130300, 12, 12 }, /* 162 Mb */
+ 		[56] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 216000,
+-			162800, 13, 13, 8, 56, 56, 56 }, /* 216 Mb */
++			162800, 13, 13 }, /* 216 Mb */
+ 		[57] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 243000,
+-			178200, 14, 14, 8, 57, 57, 57 }, /* 243 Mb */
++			178200, 14, 14 }, /* 243 Mb */
+ 		[58] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS, 270000,
+-			192100, 15, 15, 8, 58, 59, 59 }, /* 270 Mb */
++			192100, 15, 15 }, /* 270 Mb */
+ 		[59] = { RC_HT_DT_40, WLAN_RC_PHY_HT_40_DS_HGI, 300000,
+-			207000, 15, 15, 8, 58, 59, 59 }, /* 300 Mb */
++			207000, 15, 15 }, /* 300 Mb */
+ 		[60] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 40500,
+-			36100, 16, 16, 8, 60, 60, 60 }, /* 40.5 Mb */
++			36100, 16, 16 }, /* 40.5 Mb */
+ 		[61] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 81000,
+-			72900, 17, 17, 8, 61, 61, 61 }, /* 81 Mb */
++			72900, 17, 17 }, /* 81 Mb */
+ 		[62] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 121500,
+-			108300, 18, 18, 8, 62, 62, 62 }, /* 121.5 Mb */
++			108300, 18, 18 }, /* 121.5 Mb */
+ 		[63] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 162000,
+-			142000, 19, 19, 8, 63, 63, 63 }, /* 162 Mb */
++			142000, 19, 19 }, /* 162 Mb */
+ 		[64] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS, 243000,
+-			205100, 20, 20, 8, 64, 65, 65 }, /* 243 Mb */
++			205100, 20, 20 }, /* 243 Mb */
+ 		[65] = {  RC_INVALID, WLAN_RC_PHY_HT_40_TS_HGI, 270000,
+-			224700, 20, 20, 8, 64, 65, 65 }, /* 270 Mb */
++			224700, 20, 20 }, /* 270 Mb */
+ 		[66] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 324000,
+-			263100, 21, 21, 8, 66, 67, 67 }, /* 324 Mb */
++			263100, 21, 21 }, /* 324 Mb */
+ 		[67] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 360000,
+-			288000, 21, 21, 8, 66, 67, 67 }, /* 360 Mb */
++			288000, 21, 21 }, /* 360 Mb */
+ 		[68] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 364500,
+-			290700, 22, 22, 8, 68, 69, 69 }, /* 364.5 Mb */
++			290700, 22, 22 }, /* 364.5 Mb */
+ 		[69] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 405000,
+-			317200, 22, 22, 8, 68, 69, 69 }, /* 405 Mb */
++			317200, 22, 22 }, /* 405 Mb */
+ 		[70] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS, 405000,
+-			317200, 23, 23, 8, 70, 71, 71 }, /* 405 Mb */
++			317200, 23, 23 }, /* 405 Mb */
+ 		[71] = {  RC_HT_T_40, WLAN_RC_PHY_HT_40_TS_HGI, 450000,
+-			346400, 23, 23, 8, 70, 71, 71 }, /* 450 Mb */
++			346400, 23, 23 }, /* 450 Mb */
+ 	},
+ 	50,  /* probe interval */
+ 	WLAN_RC_HT_FLAG,  /* Phy rates allowed initially */
+@@ -326,21 +326,21 @@ static const struct ath_rate_table ar541
+ 	0,
+ 	{
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
+-			5400, 0, 12, 0},
++			5400, 0, 12},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
+-			7800,  1, 18, 0},
++			7800,  1, 18},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
+-			10000, 2, 24, 2},
++			10000, 2, 24},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
+-			13900, 3, 36, 2},
++			13900, 3, 36},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
+-			17300, 4, 48, 4},
++			17300, 4, 48},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
+-			23000, 5, 72, 4},
++			23000, 5, 72},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
+-			27400, 6, 96, 4},
++			27400, 6, 96},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
+-			29300, 7, 108, 4},
++			29300, 7, 108},
+ 	},
+ 	50,  /* probe interval */
+ 	0,   /* Phy rates allowed initially */
+@@ -351,56 +351,55 @@ static const struct ath_rate_table ar541
+ 	0,
+ 	{
+ 		{ RC_L_SDT, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
+-			900, 0, 2, 0},
++			900, 0, 2},
+ 		{ RC_L_SDT, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
+-			1900, 1, 4, 1},
++			1900, 1, 4},
+ 		{ RC_L_SDT, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
+-			4900, 2, 11, 2},
++			4900, 2, 11},
+ 		{ RC_L_SDT, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
+-			8100, 3, 22, 3},
++			8100, 3, 22},
+ 		{ RC_INVALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
+-			5400, 4, 12, 4},
++			5400, 4, 12},
+ 		{ RC_INVALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
+-			7800, 5, 18, 4},
++			7800, 5, 18},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
+-			10000, 6, 24, 6},
++			10000, 6, 24},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 18000, /* 18 Mb */
+-			13900, 7, 36, 6},
++			13900, 7, 36},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 24000, /* 24 Mb */
+-			17300, 8, 48, 8},
++			17300, 8, 48},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 36000, /* 36 Mb */
+-			23000, 9, 72, 8},
++			23000, 9, 72},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 48000, /* 48 Mb */
+-			27400, 10, 96, 8},
++			27400, 10, 96},
+ 		{ RC_L_SDT, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
+-			29300, 11, 108, 8},
++			29300, 11, 108},
+ 	},
+ 	50,  /* probe interval */
+ 	0,   /* Phy rates allowed initially */
+ };
+ 
+-static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
++static int ath_rc_get_rateindex(struct ath_rate_priv *ath_rc_priv,
+ 				struct ieee80211_tx_rate *rate)
+ {
+-	int rix = 0, i = 0;
+-	static const int mcs_rix_off[] = { 7, 15, 20, 21, 22, 23 };
++	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
++	int rix, i, idx = 0;
+ 
+ 	if (!(rate->flags & IEEE80211_TX_RC_MCS))
+ 		return rate->idx;
+ 
+-	while (i < ARRAY_SIZE(mcs_rix_off) && rate->idx > mcs_rix_off[i]) {
+-		rix++; i++;
++	for (i = 0; i < ath_rc_priv->max_valid_rate; i++) {
++		idx = ath_rc_priv->valid_rate_index[i];
++
++		if (WLAN_RC_PHY_HT(rate_table->info[idx].phy) &&
++		    rate_table->info[idx].ratecode == rate->idx)
++			break;
+ 	}
+ 
+-	rix += rate->idx + rate_table->mcs_start;
++	rix = idx;
+ 
+-	if ((rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
+-	    (rate->flags & IEEE80211_TX_RC_SHORT_GI))
+-		rix = rate_table->info[rix].ht_index;
+-	else if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
+-		rix = rate_table->info[rix].sgi_index;
+-	else if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+-		rix = rate_table->info[rix].cw40index;
++	if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
++		rix++;
+ 
+ 	return rix;
+ }
+@@ -1078,7 +1077,6 @@ static void ath_rc_tx_status(struct ath_
+ 			     struct ath_rate_priv *ath_rc_priv,
+ 			     struct sk_buff *skb)
+ {
+-	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
+ 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+ 	struct ieee80211_tx_rate *rates = tx_info->status.rates;
+ 	struct ieee80211_tx_rate *rate;
+@@ -1114,7 +1112,7 @@ static void ath_rc_tx_status(struct ath_
+ 				    !(ath_rc_priv->ht_cap & WLAN_RC_40_FLAG))
+ 					return;
+ 
+-				rix = ath_rc_get_rateindex(rate_table, &rates[i]);
++				rix = ath_rc_get_rateindex(ath_rc_priv, &rates[i]);
+ 				ath_rc_update_ht(sc, ath_rc_priv, tx_info,
+ 						 rix, xretries ? 1 : 2,
+ 						 rates[i].count);
+@@ -1129,7 +1127,7 @@ static void ath_rc_tx_status(struct ath_
+ 	    !(ath_rc_priv->ht_cap & WLAN_RC_40_FLAG))
+ 		return;
+ 
+-	rix = ath_rc_get_rateindex(rate_table, &rates[final_ts_idx]);
++	rix = ath_rc_get_rateindex(ath_rc_priv, &rates[final_ts_idx]);
+ 	ath_rc_update_ht(sc, ath_rc_priv, tx_info, rix, xretries, long_retry);
+ 	ath_debug_stat_rc(ath_rc_priv, rix);
+ }
+--- a/drivers/net/wireless/ath/ath9k/rc.h
++++ b/drivers/net/wireless/ath/ath9k/rc.h
+@@ -160,10 +160,6 @@ struct ath_rate_table {
+ 		u32 user_ratekbps;
+ 		u8 ratecode;
+ 		u8 dot11rate;
+-		u8 ctrl_rate;
+-		u8 cw40index;
+-		u8 sgi_index;
+-		u8 ht_index;
+ 	} info[RATE_TABLE_SIZE];
+ 	u32 probe_interval;
+ 	u8 initial_ratemax;
diff --git a/linux-next-cherry-picks/0218-ath9k-tune-rc_stats-to-display-only-valid-rates.patch b/linux-next-cherry-picks/0218-ath9k-tune-rc_stats-to-display-only-valid-rates.patch
new file mode 100644
index 0000000..bf5d053
--- /dev/null
+++ b/linux-next-cherry-picks/0218-ath9k-tune-rc_stats-to-display-only-valid-rates.patch
@@ -0,0 +1,34 @@
+From d472d446632d6b29917c5e9dec7eb7c7e0d0ff68 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Fri, 10 Aug 2012 16:47:30 +0530
+Subject: [PATCH 218/226] ath9k: tune rc_stats to display only valid rates
+
+This could make rc_stats more simpler and ease the debugging.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/rc.c | 5 +++--
+ 1 file changed, 3 insertions(+), 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/rc.c
++++ b/drivers/net/wireless/ath/ath9k/rc.c
+@@ -1355,7 +1355,7 @@ static ssize_t read_file_rcstat(struct f
+ 	struct ath_rate_priv *rc = file->private_data;
+ 	char *buf;
+ 	unsigned int len = 0, max;
+-	int i = 0;
++	int rix;
+ 	ssize_t retval;
+ 
+ 	if (rc->rate_table == NULL)
+@@ -1371,7 +1371,8 @@ static ssize_t read_file_rcstat(struct f
+ 		       "HT", "MCS", "Rate",
+ 		       "Success", "Retries", "XRetries", "PER");
+ 
+-	for (i = 0; i < rc->rate_table_size; i++) {
++	for (rix = 0; rix < rc->max_valid_rate; rix++) {
++		u8 i = rc->valid_rate_index[rix];
+ 		u32 ratekbps = rc->rate_table->info[i].ratekbps;
+ 		struct ath_rc_stats *stats = &rc->rcstats[i];
+ 		char mcs[5];
diff --git a/linux-next-cherry-picks/0224-ath9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch b/linux-next-cherry-picks/0224-ath9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch
new file mode 100644
index 0000000..45dff9f
--- /dev/null
+++ b/linux-next-cherry-picks/0224-ath9k-Fix-a-crash-in-2-WIRE-btcoex-chipsets.patch
@@ -0,0 +1,61 @@
+From 1d69d7294ec09910c8e7d57eaa37adf1ee28288f Mon Sep 17 00:00:00 2001
+From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Date: Tue, 28 Aug 2012 12:14:48 +0530
+Subject: [PATCH 224/226] ath9k: Fix a crash in 2 WIRE btcoex chipsets
+
+Generic timers for BTCOEX functionality is applicable
+only for 3 WIRE BTCOEX (and MCI) chipsets.
+Hence btcoex->no_stomp_timer is allocated only 3 WIRE
+btcoex chipsets and in all the other cases its NULL.
+Make sure we stop the generic timer only if
+'btcoex->hw_timer_enabled' is true(only if its up and
+running)
+
+Fixes the following crash
+
+	[68757.020454] BUG: unable to handle kernel NULL pointer dereference at 0000000c
+	[68757.020916] IP: [<f9b055c3>] ath9k_hw_gen_timer_stop+0x13/0x80 [ath9k_hw]
+	[68757.021251] *pde = 00000000
+	[68757.024384] EIP: 0060:[<f9b055c3>] EFLAGS: 00010082 CPU: 0
+	[68757.024384] EIP is at ath9k_hw_gen_timer_stop+0x13/0x80 [ath9k_hw]
+	[68757.024384] EAX: d32d0000 EBX: d32d0000 ECX: 00000000 EDX: 00000000
+	[68757.024384] ESI: e67c24c0 EDI: 00000296 EBP: e137be2c ESP: e137be20
+	[68757.024384]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
+	[68757.024384] CR0: 8005003b CR2: 0000000c CR3: 00b99000 CR4: 000407d0
+	[68757.024384] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
+	[68757.024384] DR6: ffff0ff0 DR7: 00000400
+	[68757.024384] Process kworker/u:2 (pid: 8917, ti=e137a000 task=ea7a6860 task.ti=e137a000)
+	[68757.024384] Stack:
+	[68757.024384]  c06c4676 d32d0000 e67c24c0 e137be38 f81c9590 e67c1ca0 e137be40 f81c95d9
+	[68757.024384]  e137be64 f81cd1c5 00000246 00000002 d32d0000 e67c05e0 e67c1ca0 e67c05e0
+	[68757.024384]  00000000 e137beac f81cdfa0 e137be84 00000246 00000246 e67c1ca0 e67c1ca0
+	[68757.024384] Call Trace:
+	[68757.024384]  [<c06c4676>] ? _raw_spin_lock_irqsave+0x86/0xa0
+	[68757.024384]  [<f81c9590>] ath9k_gen_timer_stop+0x10/0x40 [ath9k]
+	[68757.024384]  [<f81c95d9>] ath9k_btcoex_stop_gen_timer+0x19/0x20 [ath9k]
+	[68757.024384]  [<f81cd1c5>] ath9k_ps_restore+0x85/0x110 [ath9k]
+	[68757.024384]  [<f81cdfa0>] ath9k_config+0x220/0x520 [ath9k]
+	[68757.024384]  [<f81cd47d>] ? ath9k_flush+0x15d/0x1b0 [ath9k]
+	[68757.024384]  [<f85c7ca5>] ieee80211_hw_config+0x135/0x2c0 [mac80211]
+	[68757.024384]  [<f860e3c8>] ieee80211_dynamic_ps_enable_work+0x198/0x5f0 [mac80211]
+
+Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Cc: Bala Shanmugam <bkamatch@qca.qualcomm.com>
+Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/gpio.c | 3 ++-
+ 1 file changed, 2 insertions(+), 1 deletion(-)
+
+--- a/drivers/net/wireless/ath/ath9k/gpio.c
++++ b/drivers/net/wireless/ath/ath9k/gpio.c
+@@ -341,7 +341,8 @@ void ath9k_btcoex_stop_gen_timer(struct
+ {
+ 	struct ath_btcoex *btcoex = &sc->btcoex;
+ 
+-	ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
++	if (btcoex->hw_timer_enabled)
++		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
+ }
+ 
+ u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen)
diff --git a/linux-next-cherry-picks/0226-ath9k-Fix-TX-filter-usage.patch b/linux-next-cherry-picks/0226-ath9k-Fix-TX-filter-usage.patch
new file mode 100644
index 0000000..5b532f3
--- /dev/null
+++ b/linux-next-cherry-picks/0226-ath9k-Fix-TX-filter-usage.patch
@@ -0,0 +1,42 @@
+From 8c7417efcd02badd74bae020d19592d40f30fe13 Mon Sep 17 00:00:00 2001
+From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Date: Wed, 29 Aug 2012 09:20:42 +0530
+Subject: [PATCH 226/226] ath9k: Fix TX filter usage
+
+The TX filter bit for a station would be set by the HW
+when a frame is not acked. A frame would be completed with
+ATH9K_TXERR_FILT status only when the corresponding filter bit
+for the destination station is already set.
+
+Currently, un-acknowledged  packets are added to the pending queue
+and retried, but the "clear_dest_mask" bit in the descriptor is
+set only when the TX status has been ATH9K_TXERR_FILT. This results
+in packet loss and the log shows:
+
+wlan0: dropped TX filtered frame, queue_len=0 PS=0 @4309746071
+wlan0: dropped TX filtered frame, queue_len=0 PS=0 @4309746076
+wlan0: dropped TX filtered frame, queue_len=0 PS=0 @4309746377
+...
+...
+
+This issue can be resolved by making sure that the destination
+mask is cleared when the packet is being retried and the earlier
+TX status is ATH9K_TXERR_XRETRY.
+
+Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/xmit.c | 2 +-
+ 1 file changed, 1 insertion(+), 1 deletion(-)
+
+--- a/drivers/net/wireless/ath/ath9k/xmit.c
++++ b/drivers/net/wireless/ath/ath9k/xmit.c
+@@ -593,7 +593,7 @@ static void ath_tx_complete_aggr(struct
+ 		if (!an->sleeping) {
+ 			ath_tx_queue_tid(txq, tid);
+ 
+-			if (ts->ts_status & ATH9K_TXERR_FILT)
++			if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
+ 				tid->ac->clear_ps_filter = true;
+ 		}
+ 	}
diff --git a/linux-next-cherry-picks/0230-ath9k_hw-Read-and-apply-thermometer-settings-from-EE.patch b/linux-next-cherry-picks/0230-ath9k_hw-Read-and-apply-thermometer-settings-from-EE.patch
new file mode 100644
index 0000000..b97013f
--- /dev/null
+++ b/linux-next-cherry-picks/0230-ath9k_hw-Read-and-apply-thermometer-settings-from-EE.patch
@@ -0,0 +1,79 @@
+From f58070226054fe12876b25d6662ac108e7f4f8b3 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Fri, 7 Sep 2012 12:15:15 +0530
+Subject: [PATCH 230/231] ath9k_hw: Read and apply thermometer settings from
+ EEPROM
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 39 ++++++++++++++++++++++++++
+ drivers/net/wireless/ath/ath9k/ar9003_phy.h    |  2 ++
+ 2 files changed, 41 insertions(+)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -3949,6 +3949,44 @@ static void ar9003_hw_txend_to_xpa_off_a
+ 		      AR_PHY_XPA_TIMING_CTL_TX_END_XPAA_OFF, value);
+ }
+ 
++static int ar9003_hw_get_thermometer(struct ath_hw *ah)
++{
++	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
++	struct ar9300_base_eep_hdr *pBase = &eep->baseEepHeader;
++	int thermometer =  (pBase->miscConfiguration >> 1) & 0x3;
++
++	return --thermometer;
++}
++
++static void ar9003_hw_thermometer_apply(struct ath_hw *ah)
++{
++	int thermometer = ar9003_hw_get_thermometer(ah);
++	u8 therm_on = (thermometer < 0) ? 0 : 1;
++
++	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX4,
++		      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
++	if (ah->caps.tx_chainmask & BIT(1))
++		REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX4,
++			      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
++	if (ah->caps.tx_chainmask & BIT(2))
++		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
++			      AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR, therm_on);
++
++	therm_on = (thermometer < 0) ? 0 : (thermometer == 0);
++	REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX4,
++		      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
++	if (ah->caps.tx_chainmask & BIT(1)) {
++		therm_on = (thermometer < 0) ? 0 : (thermometer == 1);
++		REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX4,
++			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
++	}
++	if (ah->caps.tx_chainmask & BIT(2)) {
++		therm_on = (thermometer < 0) ? 0 : (thermometer == 2);
++		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX4,
++			      AR_PHY_65NM_CH0_RXTX4_THERM_ON, therm_on);
++	}
++}
++
+ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
+ 					     struct ath9k_channel *chan)
+ {
+@@ -3962,6 +4000,7 @@ static void ath9k_hw_ar9300_set_board_va
+ 	if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah))
+ 		ar9003_hw_apply_tuning_caps(ah);
+ 	ar9003_hw_txend_to_xpa_off_apply(ah, chan->channel);
++	ar9003_hw_thermometer_apply(ah);
+ }
+ 
+ static void ath9k_hw_ar9300_set_addac(struct ath_hw *ah,
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+@@ -873,6 +873,8 @@
+ 
+ #define AR_PHY_65NM_CH0_RXTX4_THERM_ON          0x10000000
+ #define AR_PHY_65NM_CH0_RXTX4_THERM_ON_S        28
++#define AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR      0x20000000
++#define AR_PHY_65NM_CH0_RXTX4_THERM_ON_OVR_S    29
+ 
+ /*
+  * Channel 1 Register Map
diff --git a/linux-next-cherry-picks/0231-ath9k_hw-Read-and-configure-thermocal-for-AR9462.patch b/linux-next-cherry-picks/0231-ath9k_hw-Read-and-configure-thermocal-for-AR9462.patch
new file mode 100644
index 0000000..b9540b8
--- /dev/null
+++ b/linux-next-cherry-picks/0231-ath9k_hw-Read-and-configure-thermocal-for-AR9462.patch
@@ -0,0 +1,65 @@
+From 4cfd220e69ea9ea293c32e759a40f7a76a0a3f12 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Wed, 12 Sep 2012 14:13:45 +0530
+Subject: [PATCH 231/231] ath9k_hw: Read and configure thermocal for AR9462
+
+Read and configure thermometer calibration results read from
+OTP card.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Signed-off-by: John W. Linville <linville@tuxdriver.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 19 +++++++++++++++++++
+ drivers/net/wireless/ath/ath9k/ar9003_phy.h    |  6 ++++++
+ 2 files changed, 25 insertions(+)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -3987,6 +3987,24 @@ static void ar9003_hw_thermometer_apply(
+ 	}
+ }
+ 
++static void ar9003_hw_thermo_cal_apply(struct ath_hw *ah)
++{
++	u32 data, ko, kg;
++
++	if (!AR_SREV_9462_20(ah))
++		return;
++	ar9300_otp_read_word(ah, 1, &data);
++	ko = data & 0xff;
++	kg = (data >> 8) & 0xff;
++	if (ko || kg) {
++		REG_RMW_FIELD(ah, AR_PHY_BB_THERM_ADC_3,
++			      AR_PHY_BB_THERM_ADC_3_THERM_ADC_OFFSET, ko);
++		REG_RMW_FIELD(ah, AR_PHY_BB_THERM_ADC_3,
++			      AR_PHY_BB_THERM_ADC_3_THERM_ADC_SCALE_GAIN,
++			      kg + 256);
++	}
++}
++
+ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
+ 					     struct ath9k_channel *chan)
+ {
+@@ -4001,6 +4019,7 @@ static void ath9k_hw_ar9300_set_board_va
+ 		ar9003_hw_apply_tuning_caps(ah);
+ 	ar9003_hw_txend_to_xpa_off_apply(ah, chan->channel);
+ 	ar9003_hw_thermometer_apply(ah);
++	ar9003_hw_thermo_cal_apply(ah);
+ }
+ 
+ static void ath9k_hw_ar9300_set_addac(struct ath_hw *ah,
+--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+@@ -609,6 +609,12 @@
+ #define AR_PHY_BB_THERM_ADC_1_INIT_THERM		0x000000ff
+ #define AR_PHY_BB_THERM_ADC_1_INIT_THERM_S		0
+ 
++#define AR_PHY_BB_THERM_ADC_3				(AR_SM_BASE + 0x250)
++#define AR_PHY_BB_THERM_ADC_3_THERM_ADC_SCALE_GAIN	0x0001ff00
++#define AR_PHY_BB_THERM_ADC_3_THERM_ADC_SCALE_GAIN_S	8
++#define AR_PHY_BB_THERM_ADC_3_THERM_ADC_OFFSET		0x000000ff
++#define AR_PHY_BB_THERM_ADC_3_THERM_ADC_OFFSET_S	0
++
+ #define AR_PHY_BB_THERM_ADC_4				(AR_SM_BASE + 0x254)
+ #define AR_PHY_BB_THERM_ADC_4_LATEST_THERM_VALUE	0x000000ff
+ #define AR_PHY_BB_THERM_ADC_4_LATEST_THERM_VALUE_S	0
diff --git a/linux-next-cherry-picks/0235-ath9k_hw-Wait-BT-calibration-to-complete.patch b/linux-next-cherry-picks/0235-ath9k_hw-Wait-BT-calibration-to-complete.patch
new file mode 100644
index 0000000..08cab78
--- /dev/null
+++ b/linux-next-cherry-picks/0235-ath9k_hw-Wait-BT-calibration-to-complete.patch
@@ -0,0 +1,71 @@
+From 6a7d5004e3fefb0f50ddc1262984cae00c92e72a Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 10 Sep 2012 17:05:09 +0530
+Subject: [PATCH 235/237] ath9k_hw: Wait BT calibration to complete
+
+Whenever BT calibration requested, WLAN has to wait for the
+calibration to be completed. But right now we defer the waiting
+which might cause BT calibration to fail. Fix that.
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_mci.c |  1 +
+ drivers/net/wireless/ath/ath9k/debug.h      |  1 -
+ drivers/net/wireless/ath/ath9k/mci.c        | 19 ++++++++++++++++++-
+ 3 files changed, 19 insertions(+), 2 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+@@ -714,6 +714,7 @@ bool ar9003_mci_start_reset(struct ath_h
+ 
+ 	return true;
+ }
++EXPORT_SYMBOL(ar9003_mci_start_reset);
+ 
+ int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
+ 			 struct ath9k_hw_cal_data *caldata)
+--- a/drivers/net/wireless/ath/ath9k/debug.h
++++ b/drivers/net/wireless/ath/ath9k/debug.h
+@@ -41,7 +41,6 @@ enum ath_reset_type {
+ 	RESET_TYPE_PLL_HANG,
+ 	RESET_TYPE_MAC_HANG,
+ 	RESET_TYPE_BEACON_STUCK,
+-	RESET_TYPE_MCI,
+ 	__RESET_TYPE_MAX
+ };
+ 
+--- a/drivers/net/wireless/ath/ath9k/mci.c
++++ b/drivers/net/wireless/ath/ath9k/mci.c
+@@ -191,6 +191,23 @@ skip_tuning:
+ 	ath9k_btcoex_timer_resume(sc);
+ }
+ 
++static void ath_mci_wait_btcal_done(struct ath_softc *sc)
++{
++	struct ath_hw *ah = sc->sc_ah;
++
++	/* Stop tx & rx */
++	ieee80211_stop_queues(sc->hw);
++	ath_stoprecv(sc);
++	ath_drain_all_txq(sc, false);
++
++	/* Wait for cal done */
++	ar9003_mci_start_reset(ah, ah->curchan);
++
++	/* Resume tx & rx */
++	ath_startrecv(sc);
++	ieee80211_wake_queues(sc->hw);
++}
++
+ static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
+ {
+ 	struct ath_hw *ah = sc->sc_ah;
+@@ -202,7 +219,7 @@ static void ath_mci_cal_msg(struct ath_s
+ 	case MCI_GPM_BT_CAL_REQ:
+ 		if (mci_hw->bt_state == MCI_BT_AWAKE) {
+ 			ar9003_mci_state(ah, MCI_STATE_SET_BT_CAL_START);
+-			ath9k_queue_reset(sc, RESET_TYPE_MCI);
++			ath_mci_wait_btcal_done(sc);
+ 		}
+ 		ath_dbg(common, MCI, "MCI State : %d\n", mci_hw->bt_state);
+ 		break;
diff --git a/linux-next-cherry-picks/0236-ath9k_hw-use-peak-detection-for-5GHz.patch b/linux-next-cherry-picks/0236-ath9k_hw-use-peak-detection-for-5GHz.patch
new file mode 100644
index 0000000..9e96407
--- /dev/null
+++ b/linux-next-cherry-picks/0236-ath9k_hw-use-peak-detection-for-5GHz.patch
@@ -0,0 +1,21 @@
+From c143b8116a0257ed1b8c05e98bd7ac5f09c30b46 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 10 Sep 2012 17:05:10 +0530
+Subject: [PATCH 236/237] ath9k_hw: use peak detection for 5GHz
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h | 2 +-
+ 1 file changed, 1 insertion(+), 1 deletion(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
++++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
+@@ -58,7 +58,7 @@ static const u32 ar9462_2p0_baseband_pos
+ 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
+ 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
+ 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
+-	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c282},
++	{0x00009e3c, 0xcf946222, 0xcf946222, 0xcfd5c782, 0xcfd5c282},
+ 	{0x00009e44, 0x62321e27, 0x62321e27, 0xfe291e27, 0xfe291e27},
+ 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
+ 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
diff --git a/linux-next-cherry-picks/0237-ath9k_hw-add-8-points-for-5G-temp-slop.patch b/linux-next-cherry-picks/0237-ath9k_hw-add-8-points-for-5G-temp-slop.patch
new file mode 100644
index 0000000..dbb0d47
--- /dev/null
+++ b/linux-next-cherry-picks/0237-ath9k_hw-add-8-points-for-5G-temp-slop.patch
@@ -0,0 +1,111 @@
+From da9a78f125cf64b08db70715bf1200b9ec273114 Mon Sep 17 00:00:00 2001
+From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+Date: Mon, 10 Sep 2012 17:05:11 +0530
+Subject: [PATCH 237/237] ath9k_hw: add 8 points for 5G temp slop
+
+Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
+---
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 26 +++++++++++++++++++-------
+ drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |  3 ++-
+ drivers/net/wireless/ath/ath9k/eeprom.h        |  1 +
+ 3 files changed, 22 insertions(+), 8 deletions(-)
+
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+@@ -137,7 +137,8 @@ static const struct ar9300_eeprom ar9300
+ 	 },
+ 	.base_ext1 = {
+ 		.ant_div_control = 0,
+-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
++		.future = {0, 0, 0},
++		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
+ 	},
+ 	.calFreqPier2G = {
+ 		FREQ2FBIN(2412, 1),
+@@ -710,7 +711,8 @@ static const struct ar9300_eeprom ar9300
+ 	 },
+ 	 .base_ext1 = {
+ 		.ant_div_control = 0,
+-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
++		.future = {0, 0, 0},
++		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
+ 	 },
+ 	.calFreqPier2G = {
+ 		FREQ2FBIN(2412, 1),
+@@ -1284,7 +1286,8 @@ static const struct ar9300_eeprom ar9300
+ 	},
+ 	.base_ext1 = {
+ 		.ant_div_control = 0,
+-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
++		.future = {0, 0, 0},
++		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
+ 	},
+ 	.calFreqPier2G = {
+ 		FREQ2FBIN(2412, 1),
+@@ -1858,7 +1861,8 @@ static const struct ar9300_eeprom ar9300
+ 	},
+ 	.base_ext1 = {
+ 		.ant_div_control = 0,
+-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
++		.future = {0, 0, 0},
++		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
+ 	},
+ 	.calFreqPier2G = {
+ 		FREQ2FBIN(2412, 1),
+@@ -2431,7 +2435,8 @@ static const struct ar9300_eeprom ar9300
+ 	 },
+ 	 .base_ext1 = {
+ 		.ant_div_control = 0,
+-		.future = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
++		.future = {0, 0, 0},
++		.tempslopextension = {0, 0, 0, 0, 0, 0, 0, 0}
+ 	 },
+ 	.calFreqPier2G = {
+ 		FREQ2FBIN(2412, 1),
+@@ -4556,7 +4561,7 @@ static int ar9003_hw_power_control_overr
+ {
+ 	int tempSlope = 0;
+ 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+-	int f[3], t[3];
++	int f[8], t[8], i;
+ 
+ 	REG_RMW(ah, AR_PHY_TPC_11_B0,
+ 		(correction[0] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
+@@ -4589,7 +4594,14 @@ static int ar9003_hw_power_control_overr
+ 	 */
+ 	if (frequency < 4000)
+ 		tempSlope = eep->modalHeader2G.tempSlope;
+-	else if (eep->base_ext2.tempSlopeLow != 0) {
++	else if ((eep->baseEepHeader.miscConfiguration & 0x20) != 0) {
++		for (i = 0; i < 8; i++) {
++			t[i] = eep->base_ext1.tempslopextension[i];
++			f[i] = FBIN2FREQ(eep->calFreqPier5G[i], 0);
++		}
++		tempSlope = ar9003_hw_power_interpolate((s32) frequency,
++							f, t, 8);
++	} else if (eep->base_ext2.tempSlopeLow != 0) {
+ 		t[0] = eep->base_ext2.tempSlopeLow;
+ 		f[0] = 5180;
+ 		t[1] = eep->modalHeader5G.tempSlope;
+--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
++++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+@@ -266,7 +266,8 @@ struct cal_ctl_data_5g {
+ 
+ struct ar9300_BaseExtension_1 {
+ 	u8 ant_div_control;
+-	u8 future[11];
++	u8 future[3];
++	u8 tempslopextension[8];
+ 	int8_t quick_drop_low;
+ 	int8_t quick_drop_high;
+ } __packed;
+--- a/drivers/net/wireless/ath/ath9k/eeprom.h
++++ b/drivers/net/wireless/ath/ath9k/eeprom.h
+@@ -96,6 +96,7 @@
+ 
+ #define ATH9K_POW_SM(_r, _s)	(((_r) & 0x3f) << (_s))
+ #define FREQ2FBIN(x, y)		((y) ? ((x) - 2300) : (((x) - 4800) / 5))
++#define FBIN2FREQ(x, y)		((y) ? (2300 + x) : (4800 + 5 * x))
+ #define ath9k_hw_use_flash(_ah)	(!(_ah->ah_flags & AH_USE_EEPROM))
+ 
+ #define AR5416_VER_MASK (eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK)
-- 
1.7.4.1

