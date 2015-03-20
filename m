Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35556 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbbCTN4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:56:51 -0400
Received: by lbcgn8 with SMTP id gn8so75782416lbc.2
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 06:56:50 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/9] ath10k: derive rate from bitrate
Date: Fri, 20 Mar 2015 13:54:08 +0000
Message-Id: <1426859655-11797-3-git-send-email-michal.kazior@tieto.com> (sfid-20150320_145705_564700_3B6A513B)
In-Reply-To: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
References: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no need to store rate values in hw_value.
This frees up the hw_value for better future use.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 47 +++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 456d671..5721196 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -42,19 +42,19 @@
 
 static struct ieee80211_rate ath10k_rates[] = {
 	/* CCK */
-	RATETAB_ENT(10,  0x82, 0),
-	RATETAB_ENT(20,  0x84, 0),
-	RATETAB_ENT(55,  0x8b, 0),
-	RATETAB_ENT(110, 0x96, 0),
+	RATETAB_ENT(10,  0, 0),
+	RATETAB_ENT(20,  0, 0),
+	RATETAB_ENT(55,  0, 0),
+	RATETAB_ENT(110, 0, 0),
 	/* OFDM */
-	RATETAB_ENT(60,  0x0c, 0),
-	RATETAB_ENT(90,  0x12, 0),
-	RATETAB_ENT(120, 0x18, 0),
-	RATETAB_ENT(180, 0x24, 0),
-	RATETAB_ENT(240, 0x30, 0),
-	RATETAB_ENT(360, 0x48, 0),
-	RATETAB_ENT(480, 0x60, 0),
-	RATETAB_ENT(540, 0x6c, 0),
+	RATETAB_ENT(60,  0, 0),
+	RATETAB_ENT(90,  0, 0),
+	RATETAB_ENT(120, 0, 0),
+	RATETAB_ENT(180, 0, 0),
+	RATETAB_ENT(240, 0, 0),
+	RATETAB_ENT(360, 0, 0),
+	RATETAB_ENT(480, 0, 0),
+	RATETAB_ENT(540, 0, 0),
 };
 
 #define ath10k_a_rates (ath10k_rates + 4)
@@ -62,6 +62,25 @@ static struct ieee80211_rate ath10k_rates[] = {
 #define ath10k_g_rates (ath10k_rates + 0)
 #define ath10k_g_rates_size (ARRAY_SIZE(ath10k_rates))
 
+static bool ath10k_mac_bitrate_is_cck(int bitrate)
+{
+	switch (bitrate) {
+	case 10:
+	case 20:
+	case 55:
+	case 110:
+		return true;
+	}
+
+	return false;
+}
+
+static u8 ath10k_mac_bitrate_to_rate(int bitrate)
+{
+	return DIV_ROUND_UP(bitrate, 5) |
+	       (ath10k_mac_bitrate_is_cck(bitrate) ? BIT(7) : 0);
+}
+
 /**********/
 /* Crypto */
 /**********/
@@ -1699,6 +1718,7 @@ static void ath10k_peer_assoc_h_rates(struct ath10k *ar,
 	const struct ieee80211_supported_band *sband;
 	const struct ieee80211_rate *rates;
 	u32 ratemask;
+	u8 rate;
 	int i;
 
 	lockdep_assert_held(&ar->conf_mutex);
@@ -1713,7 +1733,8 @@ static void ath10k_peer_assoc_h_rates(struct ath10k *ar,
 		if (!(ratemask & 1))
 			continue;
 
-		rateset->rates[rateset->num_rates] = rates->hw_value;
+		rate = ath10k_mac_bitrate_to_rate(rates->bitrate);
+		rateset->rates[rateset->num_rates] = rate;
 		rateset->num_rates++;
 	}
 }
-- 
2.1.4

