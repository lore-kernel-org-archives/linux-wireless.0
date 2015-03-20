Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34138 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbbCTN44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:56:56 -0400
Received: by lbbsy1 with SMTP id sy1so75918703lbb.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 06:56:55 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 6/9] ath10k: simplify fixed rate selection
Date: Fri, 20 Mar 2015 13:54:12 +0000
Message-Id: <1426859655-11797-7-git-send-email-michal.kazior@tieto.com> (sfid-20150320_145706_184422_E294900F)
In-Reply-To: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
References: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the existing ieee80211_rate array instead of
definining separate one. This gets rid of the ugly
4-index offset when dealing with 5GHz band.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 56 +++++++++++------------------------
 1 file changed, 17 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 72fbdc2..877afde 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -35,21 +35,19 @@
 /*********/
 
 static struct ieee80211_rate ath10k_rates[] = {
-	/* CCK */
-	{ .bitrate = 10 },
-	{ .bitrate = 20 },
-	{ .bitrate = 55 },
-	{ .bitrate = 110 },
-
-	/* OFDM */
-	{ .bitrate = 60 },
-	{ .bitrate = 90 },
-	{ .bitrate = 120 },
-	{ .bitrate = 180 },
-	{ .bitrate = 240 },
-	{ .bitrate = 360 },
-	{ .bitrate = 480 },
-	{ .bitrate = 540 },
+	{ .bitrate = 10, .hw_value = ATH10K_HW_RATE_CCK_LP_1M },
+	{ .bitrate = 20, .hw_value = ATH10K_HW_RATE_CCK_LP_2M },
+	{ .bitrate = 55, .hw_value = ATH10K_HW_RATE_CCK_LP_5_5M },
+	{ .bitrate = 110, .hw_value = ATH10K_HW_RATE_CCK_LP_11M },
+
+	{ .bitrate = 60, .hw_value = ATH10K_HW_RATE_OFDM_6M },
+	{ .bitrate = 90, .hw_value = ATH10K_HW_RATE_OFDM_9M },
+	{ .bitrate = 120, .hw_value = ATH10K_HW_RATE_OFDM_12M },
+	{ .bitrate = 180, .hw_value = ATH10K_HW_RATE_OFDM_18M },
+	{ .bitrate = 240, .hw_value = ATH10K_HW_RATE_OFDM_24M },
+	{ .bitrate = 360, .hw_value = ATH10K_HW_RATE_OFDM_36M },
+	{ .bitrate = 480, .hw_value = ATH10K_HW_RATE_OFDM_48M },
+	{ .bitrate = 540, .hw_value = ATH10K_HW_RATE_OFDM_54M },
 };
 
 #define ath10k_a_rates (ath10k_rates + 4)
@@ -4970,22 +4968,6 @@ exit:
 	return ret;
 }
 
-/* Helper table for legacy fixed_rate/bitrate_mask */
-static const u8 cck_ofdm_rate[] = {
-	ATH10K_HW_RATE_CCK_LP_1M,
-	ATH10K_HW_RATE_CCK_LP_2M,
-	ATH10K_HW_RATE_CCK_LP_5_5M,
-	ATH10K_HW_RATE_CCK_LP_11M,
-	ATH10K_HW_RATE_OFDM_6M,
-	ATH10K_HW_RATE_OFDM_9M,
-	ATH10K_HW_RATE_OFDM_12M,
-	ATH10K_HW_RATE_OFDM_18M,
-	ATH10K_HW_RATE_OFDM_24M,
-	ATH10K_HW_RATE_OFDM_36M,
-	ATH10K_HW_RATE_OFDM_48M,
-	ATH10K_HW_RATE_OFDM_54M,
-};
-
 /* Check if only one bit set */
 static int ath10k_check_single_mask(u32 mask)
 {
@@ -5133,6 +5115,7 @@ ath10k_bitrate_mask_rate(struct ath10k *ar,
 			 u8 *fixed_rate,
 			 u8 *fixed_nss)
 {
+	struct ieee80211_supported_band *sband;
 	u8 rate = 0, pream = 0, nss = 0, i;
 	enum wmi_rate_preamble preamble;
 
@@ -5146,17 +5129,12 @@ ath10k_bitrate_mask_rate(struct ath10k *ar,
 	case WMI_RATE_PREAMBLE_CCK:
 	case WMI_RATE_PREAMBLE_OFDM:
 		i = ffs(mask->control[band].legacy) - 1;
+		sband = &ar->mac.sbands[band];
 
-		if (band == IEEE80211_BAND_2GHZ && i < 4)
-			pream = WMI_RATE_PREAMBLE_CCK;
-
-		if (band == IEEE80211_BAND_5GHZ)
-			i += 4;
-
-		if (i >= ARRAY_SIZE(cck_ofdm_rate))
+		if (WARN_ON(i >= sband->n_bitrates))
 			return false;
 
-		rate = cck_ofdm_rate[i];
+		rate = sband->bitrates[i].hw_value;
 		break;
 	case WMI_RATE_PREAMBLE_HT:
 		for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
-- 
2.1.4

