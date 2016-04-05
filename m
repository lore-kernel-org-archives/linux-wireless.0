Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53704 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757532AbcDEKIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 06:08:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] ath10k: remove VHT capabilities from 2.4GHz
Date: Tue,  5 Apr 2016 12:08:46 +0200
Message-Id: <1459850926-32264-1-git-send-email-johannes@sipsolutions.net> (sfid-20160405_120853_908384_3FF55449)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

According to the spec, VHT doesn't exist in 2.4GHz.

There are vendor extensions to allow a subset of VHT to work
(notably 256-QAM), but since mac80211 doesn't support those
advertising VHT capability on 2.4GHz leads to the behaviour
of reporting VHT capabilities but not being able to use any
of them due to mac80211's code requiring 80 MHz support.

Remove the VHT capabilities from 2.4GHz for now. If mac80211
gets extended to use the (likely Broadcom) vendor IEs for it
and handles the lack of 80 MHz support, it can be added back.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 78999c9de23b..b9d654ed0f80 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3921,9 +3921,6 @@ static void ath10k_mac_setup_ht_vht_cap(struct ath10k *ar)
 	if (ar->phy_capability & WHAL_WLAN_11G_CAPABILITY) {
 		band = &ar->mac.sbands[IEEE80211_BAND_2GHZ];
 		band->ht_cap = ht_cap;
-
-		/* Enable the VHT support at 2.4 GHz */
-		band->vht_cap = vht_cap;
 	}
 	if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY) {
 		band = &ar->mac.sbands[IEEE80211_BAND_5GHZ];
-- 
2.7.0

