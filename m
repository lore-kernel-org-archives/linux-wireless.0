Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54608 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbaAOQL0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 11:11:26 -0500
Received: from ultralex.lan ([93.218.75.192]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0MAgvb-1WEAA33A0R-00BsQ4 for
 <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 17:11:25 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 4/5] ath5k: use ath_is_mybeacon
Date: Wed, 15 Jan 2014 17:11:15 +0100
Message-Id: <1389802275-7000-1-git-send-email-linux@rempel-privat.de> (sfid-20140115_171128_992779_62B30208)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath5k/base.c | 33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index d85c312..ef35da8 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1238,14 +1238,11 @@ static void
 ath5k_check_ibss_tsf(struct ath5k_hw *ah, struct sk_buff *skb,
 		     struct ieee80211_rx_status *rxs)
 {
-	struct ath_common *common = ath5k_hw_common(ah);
 	u64 tsf, bc_tstamp;
 	u32 hw_tu;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
 
-	if (ieee80211_is_beacon(mgmt->frame_control) &&
-	    le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS &&
-	    ether_addr_equal_64bits(mgmt->bssid, common->curbssid)) {
+	if (le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS) {
 		/*
 		 * Received an IBSS beacon with the same BSSID. Hardware *must*
 		 * have updated the local TSF. We have to work around various
@@ -1301,23 +1298,6 @@ ath5k_check_ibss_tsf(struct ath5k_hw *ah, struct sk_buff *skb,
 	}
 }
 
-static void
-ath5k_update_beacon_rssi(struct ath5k_hw *ah, struct sk_buff *skb, int rssi)
-{
-	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
-	struct ath_common *common = ath5k_hw_common(ah);
-
-	/* only beacons from our BSSID */
-	if (!ieee80211_is_beacon(mgmt->frame_control) ||
-	    !ether_addr_equal_64bits(mgmt->bssid, common->curbssid))
-		return;
-
-	ewma_add(&ah->ah_beacon_rssi_avg, rssi);
-
-	/* in IBSS mode we should keep RSSI statistics per neighbour */
-	/* le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS */
-}
-
 /*
  * Compute padding position. skb must contain an IEEE 802.11 frame
  */
@@ -1390,6 +1370,7 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 		    struct ath5k_rx_status *rs)
 {
 	struct ieee80211_rx_status *rxs;
+	struct ath_common *common = ath5k_hw_common(ah);
 
 	ath5k_remove_padding(skb);
 
@@ -1442,11 +1423,13 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 
 	trace_ath5k_rx(ah, skb);
 
-	ath5k_update_beacon_rssi(ah, skb, rs->rs_rssi);
+	if (ath_is_mybeacon(common, (struct ieee80211_hdr *)skb->data)) {
+		ewma_add(&ah->ah_beacon_rssi_avg, rs->rs_rssi);
 
-	/* check beacons in IBSS mode */
-	if (ah->opmode == NL80211_IFTYPE_ADHOC)
-		ath5k_check_ibss_tsf(ah, skb, rxs);
+		/* check beacons in IBSS mode */
+		if (ah->opmode == NL80211_IFTYPE_ADHOC)
+			ath5k_check_ibss_tsf(ah, skb, rxs);
+	}
 
 	ieee80211_rx(ah->hw, skb);
 }
-- 
1.8.5.2

