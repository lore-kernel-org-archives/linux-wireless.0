Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51760 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2ILJaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 05:30:55 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20560.22038.518027.522745@gargle.gargle.HOWL> (sfid-20120912_113058_594219_BEF2E243)
Date: Wed, 12 Sep 2012 14:59:58 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Enable SGI correctly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the driver specific SGI flag based on the station's
HT capabilities, otherwise rate control uses the wrong rate.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 4b12c34..27ed80b 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1222,11 +1222,14 @@ static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta)
 			caps |= WLAN_RC_TS_FLAG | WLAN_RC_DS_FLAG;
 		else if (sta->ht_cap.mcs.rx_mask[1])
 			caps |= WLAN_RC_DS_FLAG;
-		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
 			caps |= WLAN_RC_40_FLAG;
-		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40 ||
-		    sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20)
-			caps |= WLAN_RC_SGI_FLAG;
+			if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)
+				caps |= WLAN_RC_SGI_FLAG;
+		} else {
+			if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20)
+				caps |= WLAN_RC_SGI_FLAG;
+		}
 	}
 
 	return caps;
-- 
1.7.12

