Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1584 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2B0GOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 01:14:17 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Register driver ht capabilities in wiphy
Date: Mon, 27 Feb 2012 11:44:19 +0530
Message-ID: <1330323259-13399-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120227_071421_261796_F9A6D0DD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register driver's ht capabilities in wiphy to avoid failures
in setting ht channels from hostapd.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index af3d0ab..c73f2ac 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -69,6 +69,10 @@ static struct ieee80211_rate ath6kl_rates[] = {
 #define ath6kl_g_rates     (ath6kl_rates + 0)
 #define ath6kl_g_rates_size    12
 
+#define ath6kl_g_htcap (IEEE80211_HT_CAP_SUP_WIDTH_20_40 | \
+			IEEE80211_HT_CAP_SGI_20		 | \
+			IEEE80211_HT_CAP_SGI_40)
+
 static struct ieee80211_channel ath6kl_2ghz_channels[] = {
 	CHAN2G(1, 2412, 0),
 	CHAN2G(2, 2417, 0),
@@ -113,6 +117,8 @@ static struct ieee80211_supported_band ath6kl_band_2ghz = {
 	.channels = ath6kl_2ghz_channels,
 	.n_bitrates = ath6kl_g_rates_size,
 	.bitrates = ath6kl_g_rates,
+	.ht_cap.cap = ath6kl_g_htcap,
+	.ht_cap.ht_supported = true,
 };
 
 static struct ieee80211_supported_band ath6kl_band_5ghz = {
@@ -120,6 +126,8 @@ static struct ieee80211_supported_band ath6kl_band_5ghz = {
 	.channels = ath6kl_5ghz_a_channels,
 	.n_bitrates = ath6kl_a_rates_size,
 	.bitrates = ath6kl_a_rates,
+	.ht_cap.cap = ath6kl_g_htcap,
+	.ht_cap.ht_supported = true,
 };
 
 #define CCKM_KRK_CIPHER_SUITE 0x004096ff /* use for KRK */
-- 
1.7.0.4

