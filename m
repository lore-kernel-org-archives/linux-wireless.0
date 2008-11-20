Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38148 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbYKTDNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 22:13:24 -0500
From: "Xu, Martin" <martin.xu@intel.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"yang.y.yi@gmail.com" <yang.y.yi@gmail.com>,
	Vikram Kandukuri <Vikram.Kandukuri@atheros.com>,
	Jothikumar Mothilal <Jothikumar.Mothilal@atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"Liu, Bing Wei" <bing.wei.liu@intel.com>,
	"Selbak, Rolla N" <rolla.n.selbak@intel.com>,
	"Wang, Yong Y" <yong.y.wang@intel.com>
Date: Thu, 20 Nov 2008 11:13:18 +0800
Subject: RE: [ath5k-devel] [Bug 11749] Ath5k driver has too many interrupts
 per second at idle
Message-ID: <9F0C1DB20AFA954FA1DA05309350433D41183AB4@pdsmsx503.ccr.corp.intel.com> (sfid-20081120_041329_367656_256AC071)
References: <bug-11749-13098@http.bugzilla.kernel.org/>
 <20081013150525.884BC108058@picon.linux-foundation.org>
 <43e72e890810131206u75fd68e8p5416d7456ff44097@mail.gmail.com>
 <40f31dec0810131214j1709534fl2a95bb844d08513b@mail.gmail.com>
 <9F0C1DB20AFA954FA1DA05309350433D41083496@pdsmsx503.ccr.corp.intel.com>
 <b6c5339f0811130826p138ceae1hc6fc55bf7cf5c595@mail.gmail.com>
 <9F0C1DB20AFA954FA1DA05309350433D410CD777@pdsmsx503.ccr.corp.intel.com>
 <20081117133737.GA16412@hash.localnet>
In-Reply-To: <20081117133737.GA16412@hash.localnet>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob:
Please review below patch thanks.

From: Martin Xu <martin.xu@intel.com>
Subject: disable beacon filter when station is not associated with any AP.

Ath5k driver has too many interrupts per second at idle
http://bugzilla.kernel.org/show_bug.cgi?id=11749

Signed-off-by: Martin Xu <martin.xu@intel.com>

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 34cd1a4..37da7cc 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -241,6 +241,10 @@ static int ath5k_get_tx_stats(struct ieee80211_hw *hw,
 static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
 static void ath5k_reset_tsf(struct ieee80211_hw *hw);
 static int ath5k_beacon_update(struct ath5k_softc *sc, struct sk_buff *skb);
+static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_bss_conf *bss_conf,
+				u32 changes);
 
 static struct ieee80211_ops ath5k_hw_ops = {
 	.tx 		= ath5k_tx,
@@ -2952,7 +2956,7 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		sc->opmode != NL80211_IFTYPE_MESH_POINT &&
 		test_bit(ATH_STAT_PROMISC, sc->status))
 		rfilt |= AR5K_RX_FILTER_PROM;
-	if (sc->opmode == NL80211_IFTYPE_STATION ||
+	if ((sc->opmode == NL80211_IFTYPE_STATION && sc->assoc) ||
 		sc->opmode == NL80211_IFTYPE_ADHOC ||
 		sc->opmode == NL80211_IFTYPE_AP)
 		rfilt |= AR5K_RX_FILTER_BEACON;
@@ -3092,4 +3096,32 @@ ath5k_beacon_update(struct ath5k_softc *sc, struct sk_buff *skb)
 
 	return ret;
 }
+static void
+set_beacon_filter(struct ieee80211_hw *hw, bool enable)
+{
+	struct ath5k_softc *sc = hw->priv;
+	struct ath5k_hw *ah = sc->ah;
+	u32 rfilt;
+	rfilt = ath5k_hw_get_rx_filter(ah);
+	if (enable)
+		rfilt |= AR5K_RX_FILTER_BEACON;
+	else
+		rfilt &= ~AR5K_RX_FILTER_BEACON;
+	ath5k_hw_set_rx_filter(ah, rfilt);
+	sc->filter_flags = rfilt;
+}
 
+static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_bss_conf *bss_conf,
+				    u32 changes)
+{
+	struct ath5k_softc *sc = hw->priv;
+	if (changes & BSS_CHANGED_ASSOC) {
+		mutex_lock(&sc->lock);
+		sc->assoc = bss_conf->assoc;
+		if (sc->opmode == NL80211_IFTYPE_STATION)
+			set_beacon_filter(hw, sc->assoc);
+		mutex_unlock(&sc->lock);
+	}
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
