Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3678 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450Ab2CNJLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 05:11:34 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20320.24745.258144.136367@gargle.gargle.HOWL> (sfid-20120314_101138_890966_C719F077)
Date: Wed, 14 Mar 2012 14:41:05 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 6/6] ath9k: Fix multi-VIF BSS handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 provides short preamble information and ERP protection
information on a per-BSS basis, which can be used. Remove flags
stored in the driver, which was incorrect since they were being used
in a global manner.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |   16 ++++++----------
 drivers/net/wireless/ath/ath9k/beacon.c |    6 +++---
 drivers/net/wireless/ath/ath9k/main.c   |   19 -------------------
 drivers/net/wireless/ath/ath9k/rc.c     |    3 ++-
 drivers/net/wireless/ath/ath9k/xmit.c   |    4 +++-
 5 files changed, 14 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5ecec83..8c84049 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -584,16 +584,12 @@ struct ath_ant_comb {
 #define SC_OP_INVALID                BIT(0)
 #define SC_OP_BEACONS                BIT(1)
 #define SC_OP_OFFCHANNEL             BIT(2)
-#define SC_OP_PREAMBLE_SHORT         BIT(3)
-#define SC_OP_PROTECT_ENABLE         BIT(4)
-#define SC_OP_RXFLUSH                BIT(5)
-#define SC_OP_LED_ASSOCIATED         BIT(6)
-#define SC_OP_LED_ON                 BIT(7)
-#define SC_OP_TSF_RESET              BIT(8)
-#define SC_OP_BT_PRIORITY_DETECTED   BIT(9)
-#define SC_OP_BT_SCAN                BIT(10)
-#define SC_OP_ANI_RUN                BIT(11)
-#define SC_OP_PRIM_STA_VIF           BIT(12)
+#define SC_OP_RXFLUSH                BIT(3)
+#define SC_OP_TSF_RESET              BIT(4)
+#define SC_OP_BT_PRIORITY_DETECTED   BIT(5)
+#define SC_OP_BT_SCAN                BIT(6)
+#define SC_OP_ANI_RUN                BIT(7)
+#define SC_OP_PRIM_STA_VIF           BIT(8)
 
 /* Powersave flags */
 #define PS_WAIT_FOR_BEACON        BIT(0)
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 43882f9..6264182 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -67,7 +67,7 @@ int ath_beaconq_config(struct ath_softc *sc)
  *  up rate codes, and channel flags. Beacons are always sent out at the
  *  lowest rate, and are not retried.
 */
-static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
+static void ath_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 			     struct ath_buf *bf, int rateidx)
 {
 	struct sk_buff *skb = bf->bf_mpdu;
@@ -82,7 +82,7 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ath_vif *avp,
 
 	sband = &sc->sbands[common->hw->conf.channel->band];
 	rate = sband->bitrates[rateidx].hw_value;
-	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
+	if (vif->bss_conf.use_short_preamble)
 		rate |= sband->bitrates[rateidx].hw_value_short;
 
 	memset(&info, 0, sizeof(info));
@@ -209,7 +209,7 @@ static struct ath_buf *ath_beacon_generate(struct ieee80211_hw *hw,
 		}
 	}
 
-	ath_beacon_setup(sc, avp, bf, info->control.rates[0].idx);
+	ath_beacon_setup(sc, vif, bf, info->control.rates[0].idx);
 
 	while (skb) {
 		ath_tx_cabq(hw, skb);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3f00daa..3879485 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2044,25 +2044,6 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			ath_beacon_config(sc, vif);
 	}
 
-	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
-		ath_dbg(common, CONFIG, "BSS Changed PREAMBLE %d\n",
-			bss_conf->use_short_preamble);
-		if (bss_conf->use_short_preamble)
-			sc->sc_flags |= SC_OP_PREAMBLE_SHORT;
-		else
-			sc->sc_flags &= ~SC_OP_PREAMBLE_SHORT;
-	}
-
-	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
-		ath_dbg(common, CONFIG, "BSS Changed CTS PROT %d\n",
-			bss_conf->use_cts_prot);
-		if (bss_conf->use_cts_prot &&
-		    hw->conf.channel->band != IEEE80211_BAND_5GHZ)
-			sc->sc_flags |= SC_OP_PROTECT_ENABLE;
-		else
-			sc->sc_flags &= ~SC_OP_PROTECT_ENABLE;
-	}
-
 	mutex_unlock(&sc->mutex);
 	ath9k_ps_restore(sc);
 }
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index f26e984..4f84849 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -748,7 +748,8 @@ static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
 	 * If 802.11g protection is enabled, determine whether to use RTS/CTS or
 	 * just CTS.  Note that this is only done for OFDM/HT unicast frames.
 	 */
-	if ((sc->sc_flags & SC_OP_PROTECT_ENABLE) &&
+	if ((tx_info->control.vif &&
+	     tx_info->control.vif->bss_conf.use_cts_prot) &&
 	    (rate_table->info[rix].phy == WLAN_RC_PHY_OFDM ||
 	     WLAN_RC_PHY_HT(rate_table->info[rix].phy))) {
 		rates[0].flags |= IEEE80211_TX_RC_USE_CTS_PROTECT;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d2c635d..5faec1e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -955,7 +955,9 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf,
 	 */
 	rate = ieee80211_get_rts_cts_rate(sc->hw, tx_info);
 	info->rtscts_rate = rate->hw_value;
-	if (sc->sc_flags & SC_OP_PREAMBLE_SHORT)
+
+	if (tx_info->control.vif &&
+	    tx_info->control.vif->bss_conf.use_short_preamble)
 		info->rtscts_rate |= rate->hw_value_short;
 
 	for (i = 0; i < 4; i++) {
-- 
1.7.9.4

