Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbZINIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:37:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 01/11] atheros: add ieee80211_hw to ath_common
Date: Mon, 14 Sep 2009 04:37:18 -0400
Message-Id: <1252917448-10744-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
References: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make use of it on hw code in ath9k to avoid
using the ath9k ath_softc.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath.h         |    2 ++
 drivers/net/wireless/ath/ath5k/base.c  |    1 +
 drivers/net/wireless/ath/ath9k/ani.c   |    4 ++--
 drivers/net/wireless/ath/ath9k/calib.c |    4 ++--
 drivers/net/wireless/ath/ath9k/hw.c    |    8 ++++----
 drivers/net/wireless/ath/ath9k/hw.h    |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    1 +
 7 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 0582ee4..8865413 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -19,6 +19,7 @@
 
 #include <linux/skbuff.h>
 #include <linux/if_ether.h>
+#include <net/mac80211.h>
 
 static const u8 ath_bcast_mac[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
@@ -46,6 +47,7 @@ struct ath_ops {
 
 struct ath_common {
 	void *ah;
+	struct ieee80211_hw *hw;
 	u16 cachelsz;
 	u16 curaid;
 	u8 macaddr[ETH_ALEN];
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 25a0a73..d88010b 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -594,6 +594,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	common = ath5k_hw_common(sc->ah);
 	common->ops = &ath5k_common_ops;
 	common->ah = sc->ah;
+	common->hw = hw;
 	common->cachelsz = csz << 2; /* convert to bytes */
 
 	/* Initialize device */
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index e4f9559..9682c49 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -271,7 +271,7 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 
 static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
 {
-	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 	struct ar5416AniState *aniState;
 	int32_t rssi;
 
@@ -343,7 +343,7 @@ static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
 
 static void ath9k_hw_ani_cck_err_trigger(struct ath_hw *ah)
 {
-	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 	struct ar5416AniState *aniState;
 	int32_t rssi;
 
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index dfd9565..edf1fdd 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -278,7 +278,7 @@ static bool ath9k_hw_per_calibration(struct ath_hw *ah,
 static bool ath9k_hw_iscal_supported(struct ath_hw *ah,
 				     enum ath9k_cal_types calType)
 {
-	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 
 	switch (calType & ah->supp_cals) {
 	case IQ_MISMATCH_CAL: /* Both 2 GHz and 5 GHz support OFDM */
@@ -555,7 +555,7 @@ static void ath9k_hw_adc_dccal_calibrate(struct ath_hw *ah, u8 numChains)
 /* This is done for the currently configured channel */
 bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 {
-	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 	struct ath9k_cal_list *currCal = ah->cal_list_curr;
 
 	if (!ah->curchan)
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 80bfa18..1f4e747 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -40,7 +40,7 @@ static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan
 
 static u32 ath9k_hw_mac_usec(struct ath_hw *ah, u32 clks)
 {
-	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 
 	if (!ah->curchan) /* should really check for CCK instead */
 		return clks / ATH9K_CLOCK_RATE_CCK;
@@ -52,7 +52,7 @@ static u32 ath9k_hw_mac_usec(struct ath_hw *ah, u32 clks)
 
 static u32 ath9k_hw_mac_to_usec(struct ath_hw *ah, u32 clks)
 {
-	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 
 	if (conf_is_ht40(conf))
 		return ath9k_hw_mac_usec(ah, clks) / 2;
@@ -62,7 +62,7 @@ static u32 ath9k_hw_mac_to_usec(struct ath_hw *ah, u32 clks)
 
 static u32 ath9k_hw_mac_clks(struct ath_hw *ah, u32 usecs)
 {
-	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 
 	if (!ah->curchan) /* should really check for CCK instead */
 		return usecs *ATH9K_CLOCK_RATE_CCK;
@@ -73,7 +73,7 @@ static u32 ath9k_hw_mac_clks(struct ath_hw *ah, u32 usecs)
 
 static u32 ath9k_hw_mac_to_clks(struct ath_hw *ah, u32 usecs)
 {
-	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 
 	if (conf_is_ht40(conf))
 		return ath9k_hw_mac_clks(ah, usecs) * 2;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0271680..eeb55e9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -437,6 +437,7 @@ struct ath_gen_timer_table {
 };
 
 struct ath_hw {
+	struct ieee80211_hw *hw;
 	struct ath_softc *ah_sc;
 	struct ath_common common;
 	struct ath9k_hw_version hw_version;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3d5d597..0884c3e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1575,6 +1575,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	common = ath9k_hw_common(ah);
 	common->ops = &ath9k_common_ops;
 	common->ah = ah;
+	common->hw = sc->hw;
 
 	/*
 	 * Cache line size is used to size and align various
-- 
1.6.3.3

