Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:43909 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbaIECdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 22:33:17 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v3 06/11] ath9k: Add CTWindow support
Date: Fri,  5 Sep 2014 08:03:14 +0530
Message-Id: <1409884399-32289-7-git-send-email-sujith@msujith.org> (sfid-20140905_043324_558303_1551AC30)
In-Reply-To: <1409884399-32289-1-git-send-email-sujith@msujith.org>
References: <1409884399-32289-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since CTWindow can be used for improving discoverability,
fill this field in the NoA Attribute properly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  2 ++
 drivers/net/wireless/ath/ath9k/channel.c | 26 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/init.c    |  5 +++--
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index c690601..b4ac51e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -572,6 +572,8 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 /* VIFs */
 /********/
 
+#define P2P_DEFAULT_CTWIN 10
+
 struct ath_vif {
 	struct list_head list;
 
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 7a6ca44..e73d305 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1166,6 +1166,30 @@ static void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif)
 	ath9k_update_p2p_ps_timer(sc, avp);
 }
 
+static u8 ath9k_get_ctwin(struct ath_softc *sc, struct ath_vif *avp)
+{
+	struct ath_beacon_config *cur_conf = &sc->cur_chan->beacon;
+	u8 switch_time, ctwin;
+
+	/*
+	 * Channel switch in multi-channel mode is deferred
+	 * by a quarter beacon interval when handling
+	 * ATH_CHANCTX_EVENT_BEACON_PREPARE, so the P2P-GO
+	 * interface is guaranteed to be discoverable
+	 * for that duration after a TBTT.
+	 */
+	switch_time = cur_conf->beacon_interval / 4;
+
+	ctwin = avp->vif->bss_conf.p2p_noa_attr.oppps_ctwindow;
+	if (ctwin && (ctwin < switch_time))
+		return ctwin;
+
+	if (switch_time < P2P_DEFAULT_CTWIN)
+		return 0;
+
+	return P2P_DEFAULT_CTWIN;
+}
+
 void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
 			  struct sk_buff *skb)
 {
@@ -1198,6 +1222,8 @@ void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
 	memset(noa, 0, noa_len);
 
 	noa->index = avp->noa_index;
+	noa->oppps_ctwindow = ath9k_get_ctwin(sc, avp);
+
 	if (avp->periodic_noa_duration) {
 		u32 interval = TU_TO_USEC(sc->cur_chan->beacon.beacon_interval);
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index ca10a8b..1950c04 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -763,8 +763,9 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || ath9k_modparam_nohwcrypt)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
-	hw->wiphy->features |= (NL80211_FEATURE_ACTIVE_MONITOR |
-				NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE);
+	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR |
+			       NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE |
+			       NL80211_FEATURE_P2P_GO_CTWIN;
 
 	if (!config_enabled(CONFIG_ATH9K_TX99)) {
 		hw->wiphy->interface_modes =
-- 
2.1.0

