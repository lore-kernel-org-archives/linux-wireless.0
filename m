Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44955 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab3E0JbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 05:31:21 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ath10k: Calculate correct peer PHY mode for VHT
Date: Mon, 27 May 2013 14:58:40 +0530
Message-Id: <1369646921-22278-2-git-send-email-sujith@msujith.org> (sfid-20130527_113124_847750_0E7FB014)
In-Reply-To: <1369646921-22278-1-git-send-email-sujith@msujith.org>
References: <20899.9846.857204.903600@gargle.gargle.HOWL>
 <1369646921-22278-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The peer PHY mode for 11ac operation needs to be determined
properly based on the channel bandwidth being used. Fix
this so that the proper mode is given to the firmware.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 74dc3f9..377e329 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1013,8 +1013,6 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 {
 	enum wmi_phy_mode phymode = MODE_UNKNOWN;
 
-	/* FIXME: add VHT */
-
 	switch (ar->hw->conf.chandef.chan->band) {
 	case IEEE80211_BAND_2GHZ:
 		if (sta->ht_cap.ht_supported) {
@@ -1028,7 +1026,17 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 
 		break;
 	case IEEE80211_BAND_5GHZ:
-		if (sta->ht_cap.ht_supported) {
+		/*
+		 * Check VHT first.
+		 */
+		if (sta->vht_cap.vht_supported) {
+			if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
+				phymode = MODE_11AC_VHT80;
+			else if (sta->bandwidth == IEEE80211_STA_RX_BW_40)
+				phymode = MODE_11AC_VHT40;
+			else if (sta->bandwidth == IEEE80211_STA_RX_BW_20)
+				phymode = MODE_11AC_VHT20;
+		} else if (sta->ht_cap.ht_supported) {
 			if (sta->bandwidth == IEEE80211_STA_RX_BW_40)
 				phymode = MODE_11NA_HT40;
 			else
@@ -1042,6 +1050,9 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 		break;
 	}
 
+	ath10k_dbg(ATH10K_DBG_MAC, "Peer %pM phymode: %d\n",
+		   sta->addr, phymode);
+
 	arg->peer_phymode = phymode;
 	WARN_ON(phymode == MODE_UNKNOWN);
 }
-- 
1.8.3

