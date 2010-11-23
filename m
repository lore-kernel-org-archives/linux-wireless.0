Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25744 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab0KWPMh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 10:12:37 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 07:12:23 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Paul.Shaw@atheros.com>,
	<lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Paul Shaw <paul.shaw@atheros.com>
Subject: [PATCH] ath9k: Add support for Adaptive Power Management
Date: Tue, 23 Nov 2010 20:42:27 +0530
Message-ID: <1290525147-6927-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

This feature is to mitigate the problem of certain 3
stream chips that exceed the PCIe power requirements.An EEPROM flag
controls which chips have APM enabled which is basically read from
miscellaneous configuration element of the EEPROM header.

This workaround will reduce power consumption by using 2 Tx chains for
Single and Double stream rates (5 GHz only).All self generated frames
(regardless of rate) are sent on 2 chains when this feature is
enabled(Chip Limitation).

Cc: Paul Shaw <paul.shaw@atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Tested-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 ++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    |    6 +++++-
 drivers/net/wireless/ath/ath9k/ath9k.h         |    3 +++
 drivers/net/wireless/ath/ath9k/beacon.c        |    3 ++-
 drivers/net/wireless/ath/ath9k/eeprom.h        |    1 +
 drivers/net/wireless/ath/ath9k/hw.c            |    6 ++++++
 drivers/net/wireless/ath/ath9k/hw.h            |    1 +
 drivers/net/wireless/ath/ath9k/main.c          |    5 ++++-
 drivers/net/wireless/ath/ath9k/xmit.c          |   23 +++++++++++++++++++++--
 9 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 9a7e151..882384c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3029,6 +3029,8 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 		return le32_to_cpu(pBase->swreg);
 	case EEP_PAPRD:
 		return !!(pBase->featureEnable & BIT(5));
+	case EEP_CHAIN_MASK_REDUCE:
+		return (pBase->miscConfiguration >> 0x3) & 0x1;
 	default:
 		return 0;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index e8d6455..9b187fe 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -487,7 +487,11 @@ void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
 		break;
 	}
 
-	REG_WRITE(ah, AR_SELFGEN_MASK, tx);
+	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && (tx == 0x7))
+		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
+	else
+		REG_WRITE(ah, AR_SELFGEN_MASK, tx);
+
 	if (tx == 0x5) {
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
 			    AR_PHY_SWAP_ALT_CHAIN);
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 6f90acc..efba413 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -544,6 +544,7 @@ struct ath_ant_comb {
 #define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
 #define SC_OP_BT_SCAN		     BIT(13)
 #define SC_OP_ANI_RUN		     BIT(14)
+#define SC_OP_ENABLE_APM	     BIT(15)
 
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
@@ -695,6 +696,8 @@ static inline void ath_ahb_exit(void) {};
 void ath9k_ps_wakeup(struct ath_softc *sc);
 void ath9k_ps_restore(struct ath_softc *sc);
 
+u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate);
+
 void ath9k_set_bssid_mask(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 int ath9k_wiphy_add(struct ath_softc *sc);
 int ath9k_wiphy_del(struct ath_wiphy *aphy);
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 30724a4..47bedd8 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -103,7 +103,8 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 	series[0].Tries = 1;
 	series[0].Rate = rate;
-	series[0].ChSel = common->tx_chainmask;
+	series[0].ChSel = ath_txchainmask_reduction(sc,
+			common->tx_chainmask, series[0].Rate);
 	series[0].RateFlags = (ctsrate) ? ATH9K_RATESERIES_RTS_CTS : 0;
 	ath9k_hw_set11n_ratescenario(ah, ds, ds, 0, ctsrate, ctsduration,
 				     series, 4, 0);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 3c99830..7755fb9 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -268,6 +268,7 @@ enum eeprom_param {
 	EEP_PAPRD,
 	EEP_MODAL_VER,
 	EEP_ANT_DIV_CTL1,
+	EEP_CHAIN_MASK_REDUCE
 };
 
 enum ar5416_rates {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1dbe53b..3b9bd0c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1972,6 +1972,12 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 			if ((ant_div_ctl1 & 0x1) && ((ant_div_ctl1 >> 3) & 0x1))
 				pCap->hw_caps |= ATH9K_HW_CAP_ANT_DIV_COMB;
 		}
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		if (ah->eep_ops->get_eeprom(ah, EEP_CHAIN_MASK_REDUCE))
+			pCap->hw_caps |= ATH9K_HW_CAP_APM;
+	}
+
+
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index cc8f3b9..5fcfa48 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -187,6 +187,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_ANT_DIV_COMB		= BIT(12),
 	ATH9K_HW_CAP_2GHZ			= BIT(13),
 	ATH9K_HW_CAP_5GHZ			= BIT(14),
+	ATH9K_HW_CAP_APM			= BIT(15),
 };
 
 struct ath9k_hw_capabilities {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 50bdb5d..df1bfcf 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -554,9 +554,12 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 {
 	struct ath_node *an;
-
+	struct ath_hw *ah = sc->sc_ah;
 	an = (struct ath_node *)sta->drv_priv;
 
+	if ((ah->caps.hw_caps) & ATH9K_HW_CAP_APM)
+		sc->sc_flags |= SC_OP_ENABLE_APM;
+
 	if (sc->sc_flags & SC_OP_TXAGGR) {
 		ath_tx_node_init(sc, an);
 		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c63e283..a01b86e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1504,6 +1504,18 @@ static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, int pktlen,
 	return duration;
 }
 
+u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_channel *curchan = ah->curchan;
+	if ((sc->sc_flags & SC_OP_ENABLE_APM) &&
+			(curchan->channelFlags & CHANNEL_5GHZ) &&
+			(chainmask == 0x7) && (rate < 0x90))
+		return 0x3;
+	else
+		return chainmask;
+}
+
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -1544,7 +1556,6 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 
 		rix = rates[i].idx;
 		series[i].Tries = rates[i].count;
-		series[i].ChSel = common->tx_chainmask;
 
 		if ((sc->config.ath_aggr_prot && bf_isaggr(bf)) ||
 		    (rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS)) {
@@ -1567,6 +1578,8 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 		if (rates[i].flags & IEEE80211_TX_RC_MCS) {
 			/* MCS rates */
 			series[i].Rate = rix | 0x80;
+			series[i].ChSel = ath_txchainmask_reduction(sc,
+					common->tx_chainmask, series[i].Rate);
 			series[i].PktDuration = ath_pkt_duration(sc, rix, len,
 				 is_40, is_sgi, is_sp);
 			if (rix < 8 && (tx_info->flags & IEEE80211_TX_CTL_STBC))
@@ -1574,7 +1587,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 			continue;
 		}
 
-		/* legcay rates */
+		/* legacy rates */
 		if ((tx_info->band == IEEE80211_BAND_2GHZ) &&
 		    !(rate->flags & IEEE80211_RATE_ERP_G))
 			phy = WLAN_RC_PHY_CCK;
@@ -1590,6 +1603,12 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 			is_sp = false;
 		}
 
+		if (bf->bf_state.bfs_paprd)
+			series[i].ChSel = common->tx_chainmask;
+		else
+			series[i].ChSel = ath_txchainmask_reduction(sc,
+					common->tx_chainmask, series[i].Rate);
+
 		series[i].PktDuration = ath9k_hw_computetxtime(sc->sc_ah,
 			phy, rate->bitrate * 100, len, rix, is_sp);
 	}
-- 
1.7.0.4

