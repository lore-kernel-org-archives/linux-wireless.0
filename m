Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38218 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762572Ab2DLTou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 15:44:50 -0400
Received: by qcro28 with SMTP id o28so1461208qcr.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 12:44:49 -0700 (PDT)
Message-ID: <4F8730AF.1080007@gmail.com> (sfid-20120412_214453_795804_D36B9A02)
Date: Thu, 12 Apr 2012 15:44:47 -0400
From: Jonathan Bither <jonbither@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: use compare_ether_addr on MAC addresses instead of
 memcmp
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following Felix's recent patchset as an example I have replaced memcmp with
compare_ether_addr.

"Because of the constant size and guaranteed 16 bit alignment, the inline
compare_ether_addr function is much cheaper than calling memcmp."

Signed-off-by: Jonathan Bither <jonbither@gmail.com>

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3007bba..49e3b19 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1170,7 +1170,7 @@ ath5k_check_ibss_tsf(struct ath5k_hw *ah, struct sk_buff *skb,
 
 	if (ieee80211_is_beacon(mgmt->frame_control) &&
 	    le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS &&
-	    memcmp(mgmt->bssid, common->curbssid, ETH_ALEN) == 0) {
+	    compare_ether_addr(mgmt->bssid, common->curbssid) == 0) {
 		/*
 		 * Received an IBSS beacon with the same BSSID. Hardware *must*
 		 * have updated the local TSF. We have to work around various
@@ -1234,7 +1234,7 @@ ath5k_update_beacon_rssi(struct ath5k_hw *ah, struct sk_buff *skb, int rssi)
 
 	/* only beacons from our BSSID */
 	if (!ieee80211_is_beacon(mgmt->frame_control) ||
-	    memcmp(mgmt->bssid, common->curbssid, ETH_ALEN) != 0)
+	    compare_ether_addr(mgmt->bssid, common->curbssid) != 0)
 		return;
 
 	ewma_add(&ah->ah_beacon_rssi_avg, rssi);
