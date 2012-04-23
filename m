Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34267 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2DWIw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 04:52:57 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Don't advertise HT capability for incapable firmware
Date: Mon, 23 Apr 2012 14:23:53 +0530
Message-ID: <1335171233-23814-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120423_105259_920239_B8C5D38B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With firmwares which do not support rsn capability override
(ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE) from host would
cause 4-way handshake failure when HT cap is advertised.
To fix this, do not advertise HT cap with cfg80211 for
those fw.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a8a7570..e3f30c8 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -122,8 +122,6 @@ static struct ieee80211_supported_band ath6kl_band_2ghz = {
 	.channels = ath6kl_2ghz_channels,
 	.n_bitrates = ath6kl_g_rates_size,
 	.bitrates = ath6kl_g_rates,
-	.ht_cap.cap = ath6kl_g_htcap,
-	.ht_cap.ht_supported = true,
 };
 
 static struct ieee80211_supported_band ath6kl_band_5ghz = {
@@ -131,8 +129,6 @@ static struct ieee80211_supported_band ath6kl_band_5ghz = {
 	.channels = ath6kl_5ghz_a_channels,
 	.n_bitrates = ath6kl_a_rates_size,
 	.bitrates = ath6kl_a_rates,
-	.ht_cap.cap = ath6kl_a_htcap,
-	.ht_cap.ht_supported = true,
 };
 
 #define CCKM_KRK_CIPHER_SUITE 0x004096ff /* use for KRK */
@@ -3441,6 +3437,19 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	wiphy->max_scan_ie_len = 1000; /* FIX: what is correct limit? */
 	wiphy->bands[IEEE80211_BAND_2GHZ] = &ath6kl_band_2ghz;
 	wiphy->bands[IEEE80211_BAND_5GHZ] = &ath6kl_band_5ghz;
+
+	/*
+	 * Advertise HT cap only when the firmware has support to override
+	 * RSN capability, otherwise 4-way handshake would fail.
+	 */
+	if (test_bit(ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE,
+		     ar->fw_capabilities)) {
+		wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.ht_supported = true;
+		wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap.cap = ath6kl_g_htcap;
+		wiphy->bands[IEEE80211_BAND_5GHZ]->ht_cap.ht_supported = true;
+		wiphy->bands[IEEE80211_BAND_5GHZ]->ht_cap.cap = ath6kl_a_htcap;
+	}
+
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 
 	wiphy->cipher_suites = cipher_suites;
-- 
1.7.0.4

