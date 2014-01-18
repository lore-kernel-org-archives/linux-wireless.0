Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64474 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbaARMyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jan 2014 07:54:43 -0500
Received: from ultralex.lan ([93.218.86.193]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0MWgND-1VohjO3WTD-00XtCG for
 <linux-wireless@vger.kernel.org>; Sat, 18 Jan 2014 13:54:42 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 4/5] ath5k: use ath_is_mybeacon
Date: Sat, 18 Jan 2014 13:54:18 +0100
Message-Id: <1390049659-27021-5-git-send-email-linux@rempel-privat.de> (sfid-20140118_135456_463155_92F54CF5)
In-Reply-To: <1390049659-27021-1-git-send-email-linux@rempel-privat.de>
References: <1390049659-27021-1-git-send-email-linux@rempel-privat.de>
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

