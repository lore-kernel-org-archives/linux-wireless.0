Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:33200 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbYBZW7Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 17:59:16 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] ath5k: fix all endian issues reported by sparse
To: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Date: Tue, 26 Feb 2008 17:59:14 -0500
Message-ID: <20080226225914.28153.48243.stgit@dv.roinet.com> (sfid-20080226_225922_252961_0C79CC2D)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes-licensed-under: ISC
Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/ath5k/base.c |    8 ++++----
 drivers/net/wireless/ath5k/hw.c   |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 0b743f7..393b5f3 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1717,11 +1717,11 @@ ath5k_check_ibss_hw_merge(struct ath5k_softc *sc, struct sk_buff *skb)
 	u32 hw_tu;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
 
-	if ((mgmt->frame_control & IEEE80211_FCTL_FTYPE) ==
+	if ((le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_FTYPE) ==
 		IEEE80211_FTYPE_MGMT &&
-	    (mgmt->frame_control & IEEE80211_FCTL_STYPE) ==
+	    (le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE) ==
 		IEEE80211_STYPE_BEACON &&
-	    mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
+	    le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS &&
 	    memcmp(mgmt->bssid, sc->ah->ah_bssid, ETH_ALEN) == 0) {
 		/*
 		 * Received an IBSS beacon with the same BSSID. Hardware might
@@ -1730,7 +1730,7 @@ ath5k_check_ibss_hw_merge(struct ath5k_softc *sc, struct sk_buff *skb)
 		hw_tu = TSF_TO_TU(ath5k_hw_get_tsf64(sc->ah));
 		if (hw_tu >= sc->nexttbtt) {
 			ath5k_beacon_update_timers(sc,
-				mgmt->u.beacon.timestamp);
+				le64_to_cpu(mgmt->u.beacon.timestamp));
 			ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
 				"detected HW merge from received beacon\n");
 		}
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 998da6b..eec2b80 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -531,8 +531,8 @@ static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
 		 * actual rate for this rate. See mac80211 tx.c
 		 * ieee80211_duration() for a brief description of
 		 * what rate we should choose to TX ACKs. */
-		tx_time = ieee80211_generic_frame_duration(sc->hw,
-			sc->vif, 10, &srate);
+		tx_time = le16_to_cpu(ieee80211_generic_frame_duration(sc->hw,
+							sc->vif, 10, &srate));
 
 		ath5k_hw_reg_write(ah, tx_time, reg);
 
