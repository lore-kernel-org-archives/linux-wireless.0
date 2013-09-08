Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:52663 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab3IHPT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 11:19:58 -0400
Subject: [PATCH] ath10k: Calculate correct peer PHY mode for VHT
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Sep 2013 18:19:55 +0300
Message-ID: <20130908151955.9228.15022.stgit@localhost6.localdomain6> (sfid-20130908_172003_860935_BC0CC76C)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The peer PHY mode for 11ac operation needs to be determined
properly based on the channel bandwidth being used. Fix
this so that the proper mode is given to the firmware.

kvalo: earlier we used 11na-ht20 in STA mode for 11ac AP peer, this
patch changes that to 11ac-vht80. I didn't notice any change in
throughput in my tests, but nevertheless it's the right thing
to do.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 2b11856..8b9fb66 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1080,8 +1080,6 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 {
 	enum wmi_phy_mode phymode = MODE_UNKNOWN;
 
-	/* FIXME: add VHT */
-
 	switch (ar->hw->conf.chandef.chan->band) {
 	case IEEE80211_BAND_2GHZ:
 		if (sta->ht_cap.ht_supported) {
@@ -1095,7 +1093,17 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 
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

