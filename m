Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11617 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbYKMGMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 01:12:25 -0500
From: "Xu, Martin" <martin.xu@intel.com>
To: Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"yang.y.yi@gmail.com" <yang.y.yi@gmail.com>,
	Vikram Kandukuri <Vikram.Kandukuri@atheros.com>,
	Jothikumar Mothilal <Jothikumar.Mothilal@atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"Liu, Bing Wei" <bing.wei.liu@intel.com>,
	"Selbak, Rolla N" <rolla.n.selbak@intel.com>,
	"Wang, Yong Y" <yong.y.wang@intel.com>
Date: Thu, 13 Nov 2008 14:12:17 +0800
Subject: RE: [ath5k-devel] [Bug 11749] Ath5k driver has too many interrupts
 per second at idle
Message-ID: <9F0C1DB20AFA954FA1DA05309350433D41083496@pdsmsx503.ccr.corp.intel.com> (sfid-20081113_071243_328645_0695E42B)
References: <bug-11749-13098@http.bugzilla.kernel.org/>
 <20081013150525.884BC108058@picon.linux-foundation.org>
 <43e72e890810131206u75fd68e8p5416d7456ff44097@mail.gmail.com>
 <40f31dec0810131214j1709534fl2a95bb844d08513b@mail.gmail.com>
In-Reply-To: <40f31dec0810131214j1709534fl2a95bb844d08513b@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all:
I have a patch that can be used to fix the bug.
The patch resolved the issue by disabling the beacon filter when disassociated with AP and enabling beacon when associate with AP.
See http://bugzilla.kernel.org/show_bug.cgi?id=11749
Please review it. Thanks!

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 34cd1a4..d774a6a 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -241,6 +241,10 @@ static int ath5k_get_tx_stats(struct ieee80211_hw *hw,
 static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
 static void ath5k_reset_tsf(struct ieee80211_hw *hw);
 static int ath5k_beacon_update(struct ath5k_softc *sc, struct sk_buff *skb);
+static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
+                                struct ieee80211_vif *vif,
+                                struct ieee80211_bss_conf *bss_conf,
+                                u32 changes);
 
 static struct ieee80211_ops ath5k_hw_ops = {
 	.tx 		= ath5k_tx,
@@ -257,6 +261,7 @@ static struct ieee80211_ops ath5k_hw_ops = {
 	.get_tx_stats 	= ath5k_get_tx_stats,
 	.get_tsf 	= ath5k_get_tsf,
 	.reset_tsf 	= ath5k_reset_tsf,
+	.bss_info_changed = ath5k_bss_info_changed, 
 };
 
 /*
@@ -2952,7 +2957,7 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		sc->opmode != NL80211_IFTYPE_MESH_POINT &&
 		test_bit(ATH_STAT_PROMISC, sc->status))
 		rfilt |= AR5K_RX_FILTER_PROM;
-	if (sc->opmode == NL80211_IFTYPE_STATION ||
+	if ( (sc->opmode == NL80211_IFTYPE_STATION && sc->assoc) ||
 		sc->opmode == NL80211_IFTYPE_ADHOC ||
 		sc->opmode == NL80211_IFTYPE_AP)
 		rfilt |= AR5K_RX_FILTER_BEACON;
@@ -3093,3 +3098,54 @@ ath5k_beacon_update(struct ath5k_softc *sc, struct sk_buff *skb)
 	return ret;
 }
 
+static void
+enable_beacon_filter(struct ieee80211_hw *hw)
+{
+        struct ath5k_softc *sc = hw->priv;
+        struct ath5k_hw *ah = sc->ah;
+        u32 rfilt;
+        rfilt = ath5k_hw_get_rx_filter(ah);
+        if ( !(rfilt & AR5K_RX_FILTER_BEACON) ){
+                rfilt |= AR5K_RX_FILTER_BEACON;
+                ath5k_hw_set_rx_filter(ah,rfilt);
+                sc->filter_flags = rfilt;
+        }
+        rfilt = ath5k_hw_get_rx_filter(ah);
+        return;
+}
+
+static void
+disable_beacon_filter(struct ieee80211_hw *hw)
+{
+        struct ath5k_softc *sc = hw->priv;
+        struct ath5k_hw *ah = sc->ah;
+        u32 rfilt;
+        rfilt = ath5k_hw_get_rx_filter(ah);
+        if ( rfilt & AR5K_RX_FILTER_BEACON ){
+                rfilt &= ~AR5K_RX_FILTER_BEACON;
+                ath5k_hw_set_rx_filter(ah,rfilt);
+                sc->filter_flags = rfilt;
+        }
+
+        return;
+}
+
+static void ath5k_bss_info_changed(struct ieee80211_hw *hw, 
+                                struct ieee80211_vif *vif,
+                                struct ieee80211_bss_conf *bss_conf,
+                                u32 changes)
+{
+        struct ath5k_softc *sc = hw->priv;
+        if (changes & BSS_CHANGED_ASSOC){
+		mutex_lock(&sc->lock);
+                sc->assoc = bss_conf->assoc;
+                if ( sc->opmode == NL80211_IFTYPE_STATION && sc-> assoc){
+                        enable_beacon_filter(hw);
+                }
+                if ( sc->opmode == NL80211_IFTYPE_STATION && !sc-> assoc ){
+                        disable_beacon_filter(hw);
+                }
+		mutex_unlock(&sc->lock);
+        }
+        return;
+}
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 06d1054..facc60d 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -179,6 +179,7 @@ struct ath5k_softc {
 
 	struct timer_list	calib_tim;	/* calibration timer */
 	int 			power_level;	/* Requested tx power in dbm */
+	bool			assoc;		/* assocate state */
 };
 
 #define ath5k_hw_hasbssidmask(_ah) \
