Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34180 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbbCTN47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:56:59 -0400
Received: by lbbsy1 with SMTP id sy1so75919834lbb.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 06:56:58 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 9/9] ath10k: document ofdm/5ghz rate offset with a macro
Date: Fri, 20 Mar 2015 13:54:15 +0000
Message-Id: <1426859655-11797-10-git-send-email-michal.kazior@tieto.com> (sfid-20150320_145710_412395_A2D7F6B2)
In-Reply-To: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
References: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't use literal values for offsets. While at it
rename a function so it is more clear what it
checks for.

This finally takes care of the last magic
5GHz/OFDM offset.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c39a300..bdd9baa 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -60,8 +60,11 @@ static struct ieee80211_rate ath10k_rates[] = {
 	{ .bitrate = 540, .hw_value = ATH10K_HW_RATE_OFDM_54M },
 };
 
-#define ath10k_a_rates (ath10k_rates + 4)
-#define ath10k_a_rates_size (ARRAY_SIZE(ath10k_rates) - 4)
+#define ATH10K_MAC_FIRST_OFDM_RATE_IDX 4
+
+#define ath10k_a_rates (ath10k_rates + ATH10K_MAC_FIRST_OFDM_RATE_IDX)
+#define ath10k_a_rates_size (ARRAY_SIZE(ath10k_rates) - \
+			     ATH10K_MAC_FIRST_OFDM_RATE_IDX)
 #define ath10k_g_rates (ath10k_rates + 0)
 #define ath10k_g_rates_size (ARRAY_SIZE(ath10k_rates))
 
@@ -2001,10 +2004,10 @@ static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
 		   sta->addr, !!(arg->peer_flags & WMI_PEER_QOS));
 }
 
-static bool ath10k_mac_sta_has_11g_rates(struct ieee80211_sta *sta)
+static bool ath10k_mac_sta_has_ofdm_only(struct ieee80211_sta *sta)
 {
-	/* First 4 rates in ath10k_rates are CCK (11b) rates. */
-	return sta->supp_rates[IEEE80211_BAND_2GHZ] >> 4;
+	return sta->supp_rates[IEEE80211_BAND_2GHZ] >>
+	       ATH10K_MAC_FIRST_OFDM_RATE_IDX;
 }
 
 static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
@@ -2026,7 +2029,7 @@ static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
 				phymode = MODE_11NG_HT40;
 			else
 				phymode = MODE_11NG_HT20;
-		} else if (ath10k_mac_sta_has_11g_rates(sta)) {
+		} else if (ath10k_mac_sta_has_ofdm_only(sta)) {
 			phymode = MODE_11G;
 		} else {
 			phymode = MODE_11B;
-- 
2.1.4

