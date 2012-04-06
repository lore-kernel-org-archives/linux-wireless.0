Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10576 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2DFOGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 10:06:38 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 1/2] ath6kl: Don't advertise HT40 support in 2.4 Ghz
Date: Fri, 6 Apr 2012 19:37:14 +0530
Message-ID: <1333721235-16025-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120406_160642_317017_EF9E6953)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HT40 is not supported in 2.4Ghz.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 097be01..47dbb14 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -71,7 +71,8 @@ static struct ieee80211_rate ath6kl_rates[] = {
 #define ath6kl_g_rates     (ath6kl_rates + 0)
 #define ath6kl_g_rates_size    12
 
-#define ath6kl_g_htcap (IEEE80211_HT_CAP_SUP_WIDTH_20_40 | \
+#define ath6kl_g_htcap IEEE80211_HT_CAP_SGI_20
+#define ath6kl_a_htcap (IEEE80211_HT_CAP_SUP_WIDTH_20_40 | \
 			IEEE80211_HT_CAP_SGI_20		 | \
 			IEEE80211_HT_CAP_SGI_40)
 
@@ -128,7 +129,7 @@ static struct ieee80211_supported_band ath6kl_band_5ghz = {
 	.channels = ath6kl_5ghz_a_channels,
 	.n_bitrates = ath6kl_a_rates_size,
 	.bitrates = ath6kl_a_rates,
-	.ht_cap.cap = ath6kl_g_htcap,
+	.ht_cap.cap = ath6kl_a_htcap,
 	.ht_cap.ht_supported = true,
 };
 
-- 
1.7.0.4

