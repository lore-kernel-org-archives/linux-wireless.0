Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33283 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbBZKMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 05:12:34 -0500
Received: by lbvp9 with SMTP id p9so9799199lbv.0
        for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2015 02:12:32 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix TxBF VHT capabilities for 2+ RF-chain devices
Date: Thu, 26 Feb 2015 11:11:22 +0100
Message-Id: <1424945482-9765-1-git-send-email-michal.kazior@tieto.com> (sfid-20150226_111237_997668_6BD6E6FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware doesn't report a complete and
ready-to-use vht cap. Instead the driver is
supposed to fill in the missing bits related to
number of chains.

This effectively increases Compressed Steering
Number and Number of Sounding Dimensions in
AssocReq frames for devices with more than one RF
chain and should improve TxBF performance.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0f39af7..383250e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5263,11 +5263,30 @@ static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 {
 	struct ieee80211_sta_vht_cap vht_cap = {0};
 	u16 mcs_map;
+	u32 val;
 	int i;
 
 	vht_cap.vht_supported = 1;
 	vht_cap.cap = ar->vht_cap_info;
 
+	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
+				IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE)) {
+		val = ar->num_rf_chains - 1;
+		val <<= IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
+		val &= IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
+
+		vht_cap.cap |= val;
+	}
+
+	if (ar->vht_cap_info & (IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE |
+				IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)) {
+		val = ar->num_rf_chains - 1;
+		val <<= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT;
+		val &= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_MASK;
+
+		vht_cap.cap |= val;
+	}
+
 	mcs_map = 0;
 	for (i = 0; i < 8; i++) {
 		if (i < ar->num_rf_chains)
-- 
1.8.5.3

