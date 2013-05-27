Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42516 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab3E0JbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 05:31:23 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] ath10k: Fix bug in max. VHT A-MPDU size
Date: Mon, 27 May 2013 14:58:41 +0530
Message-Id: <1369646921-22278-3-git-send-email-sujith@msujith.org> (sfid-20130527_113126_713074_15C991BC)
In-Reply-To: <1369646921-22278-1-git-send-email-sujith@msujith.org>
References: <20899.9846.857204.903600@gargle.gargle.HOWL>
 <1369646921-22278-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

For VHT peers, the maximum A-MPDU size has to be calculated
from the VHT capabilities element and not the HT-cap. The formula
is the same, but a higher value is used in VHT, allowing larger
aggregates to be transmitted.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 377e329..08d79ef 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -965,14 +965,19 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 				    struct wmi_peer_assoc_complete_arg *arg)
 {
 	const struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
+	u8 ampdu_factor;
 
 	if (!vht_cap->vht_supported)
 		return;
 
 	arg->peer_flags |= WMI_PEER_VHT;
-
 	arg->peer_vht_caps = vht_cap->cap;
 
+	ampdu_factor =
+		(vht_cap->cap & IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK) >>
+		IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
+	arg->peer_max_mpdu = (1 << (IEEE80211_HT_MAX_AMPDU_FACTOR + ampdu_factor)) - 1;
+
 	if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
 		arg->peer_flags |= WMI_PEER_80MHZ;
 
@@ -985,7 +990,8 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
 	arg->peer_vht_rates.tx_mcs_set =
 		__le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map);
 
-	ath10k_dbg(ATH10K_DBG_MAC, "mac vht peer\n");
+	ath10k_dbg(ATH10K_DBG_MAC, "VHT peer %pM, max mpdu: %d\n",
+		   sta->addr, arg->peer_max_mpdu);
 }
 
 static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
-- 
1.8.3

