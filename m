Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45388 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab2DINdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 09:33:18 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V2 1/2] ath6kl: Don't advertise HT40 support in 2.4 Ghz
Date: Mon, 9 Apr 2012 19:03:57 +0530
Message-ID: <1333978438-29596-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120409_153322_138928_B8B10849)
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
index f95ba73..295ad3c 100644
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

