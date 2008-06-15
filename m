Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:65412 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYFOGdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 02:33:35 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3882106waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2008 23:33:35 -0700 (PDT)
Subject: [PATCH 1/4] ath5k: use frame control helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Jun 2008 23:33:38 -0700
Message-Id: <1213511618.11544.30.camel@brick> (sfid-20080615_083341_141479_805D182F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 85045af..010c665 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1691,9 +1691,9 @@ ath5k_rx_decrypted(struct ath5k_softc *sc, struct ath5k_desc *ds,
 	/* Apparently when a default key is used to decrypt the packet
 	   the hw does not set the index used to decrypt.  In such cases
 	   get the index from the packet. */
-	if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_PROTECTED) &&
-			!(rs->rs_status & AR5K_RXERR_DECRYPT) &&
-			skb->len >= hlen + 4) {
+	if (ieee80211_has_protected(hdr->frame_control) &&
+	    !(rs->rs_status & AR5K_RXERR_DECRYPT) &&
+	    skb->len >= hlen + 4) {
 		keyix = skb->data[hlen + 3] >> 6;
 
 		if (test_bit(keyix, sc->keymap))
@@ -1712,10 +1712,7 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 	u32 hw_tu;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
 
-	if ((le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_FTYPE) ==
-		IEEE80211_FTYPE_MGMT &&
-	    (le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE) ==
-		IEEE80211_STYPE_BEACON &&
+	if (ieee80211_is_beacon(mgmt->frame_control) &&
 	    le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS &&
 	    memcmp(mgmt->bssid, sc->ah->ah_bssid, ETH_ALEN) == 0) {
 		/*
-- 
1.5.6.rc3.283.g198e


