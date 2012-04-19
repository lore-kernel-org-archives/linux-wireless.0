Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21304 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab2DSWcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 18:32:55 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH 2/2] ath6kl: only restore supported HT caps
Date: Thu, 19 Apr 2012 15:31:57 -0700
Message-ID: <1334874717-7431-2-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120420_003259_087726_E3786CB0)
In-Reply-To: <1334874717-7431-1-git-send-email-c_tpeder@qca.qualcomm.com>
References: <1334874717-7431-1-git-send-email-c_tpeder@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that we know the supported PHY capabilities, only restore supported
bands / HT capabilities in firmware when stopping AP.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b848977..c8147b9 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2477,6 +2477,24 @@ static int ath6kl_set_htcap(struct ath6kl_vif *vif, enum ieee80211_band band,
 					band, htcap);
 }
 
+static int ath6kl_restore_htcap(struct ath6kl_vif *vif)
+{
+	struct wiphy *wiphy = vif->ar->wiphy;
+	int band, ret = 0;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		if (!wiphy->bands[band])
+			continue;
+
+		ret = ath6kl_set_htcap(vif, band,
+				wiphy->bands[band]->ht_cap.ht_supported);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
 static bool ath6kl_is_p2p_ie(const u8 *pos)
 {
 	return pos[0] == WLAN_EID_VENDOR_SPECIFIC && pos[1] >= 4 &&
@@ -2838,13 +2856,7 @@ static int ath6kl_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	clear_bit(CONNECTED, &vif->flags);
 
 	/* Restore ht setting in firmware */
-	if (ath6kl_set_htcap(vif, IEEE80211_BAND_2GHZ, true))
-		return -EIO;
-
-	if (ath6kl_set_htcap(vif, IEEE80211_BAND_5GHZ, true))
-		return -EIO;
-
-	return 0;
+	return ath6kl_restore_htcap(vif);
 }
 
 static const u8 bcast_addr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-- 
1.7.4.1

