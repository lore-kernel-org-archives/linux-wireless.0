Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:35191 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbbCTN4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:56:49 -0400
Received: by labjg1 with SMTP id jg1so87648890lab.2
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 06:56:48 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/9] ath10k: move rate definitions to file start
Date: Fri, 20 Mar 2015 13:54:07 +0000
Message-Id: <1426859655-11797-2-git-send-email-michal.kazior@tieto.com> (sfid-20150320_145754_956348_DAFE7E70)
In-Reply-To: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
References: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prepare the code for future changes so that new
code can refer to rate-related stuff without
forward declarations.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 63 ++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1214a3b..456d671 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -30,6 +30,38 @@
 #include "wmi.h"
 #include "wmi-ops.h"
 
+/*********/
+/* Rates */
+/*********/
+
+#define RATETAB_ENT(_rate, _rateid, _flags) { \
+	.bitrate		= (_rate), \
+	.flags			= (_flags), \
+	.hw_value		= (_rateid), \
+}
+
+static struct ieee80211_rate ath10k_rates[] = {
+	/* CCK */
+	RATETAB_ENT(10,  0x82, 0),
+	RATETAB_ENT(20,  0x84, 0),
+	RATETAB_ENT(55,  0x8b, 0),
+	RATETAB_ENT(110, 0x96, 0),
+	/* OFDM */
+	RATETAB_ENT(60,  0x0c, 0),
+	RATETAB_ENT(90,  0x12, 0),
+	RATETAB_ENT(120, 0x18, 0),
+	RATETAB_ENT(180, 0x24, 0),
+	RATETAB_ENT(240, 0x30, 0),
+	RATETAB_ENT(360, 0x48, 0),
+	RATETAB_ENT(480, 0x60, 0),
+	RATETAB_ENT(540, 0x6c, 0),
+};
+
+#define ath10k_a_rates (ath10k_rates + 4)
+#define ath10k_a_rates_size (ARRAY_SIZE(ath10k_rates) - 4)
+#define ath10k_g_rates (ath10k_rates + 0)
+#define ath10k_g_rates_size (ARRAY_SIZE(ath10k_rates))
+
 /**********/
 /* Crypto */
 /**********/
@@ -5420,12 +5452,6 @@ static const struct ieee80211_ops ath10k_ops = {
 #endif
 };
 
-#define RATETAB_ENT(_rate, _rateid, _flags) { \
-	.bitrate		= (_rate), \
-	.flags			= (_flags), \
-	.hw_value		= (_rateid), \
-}
-
 #define CHAN2G(_channel, _freq, _flags) { \
 	.band			= IEEE80211_BAND_2GHZ, \
 	.hw_value		= (_channel), \
@@ -5488,31 +5514,6 @@ static const struct ieee80211_channel ath10k_5ghz_channels[] = {
 	CHAN5G(165, 5825, 0),
 };
 
-/* Note: Be careful if you re-order these. There is code which depends on this
- * ordering.
- */
-static struct ieee80211_rate ath10k_rates[] = {
-	/* CCK */
-	RATETAB_ENT(10,  0x82, 0),
-	RATETAB_ENT(20,  0x84, 0),
-	RATETAB_ENT(55,  0x8b, 0),
-	RATETAB_ENT(110, 0x96, 0),
-	/* OFDM */
-	RATETAB_ENT(60,  0x0c, 0),
-	RATETAB_ENT(90,  0x12, 0),
-	RATETAB_ENT(120, 0x18, 0),
-	RATETAB_ENT(180, 0x24, 0),
-	RATETAB_ENT(240, 0x30, 0),
-	RATETAB_ENT(360, 0x48, 0),
-	RATETAB_ENT(480, 0x60, 0),
-	RATETAB_ENT(540, 0x6c, 0),
-};
-
-#define ath10k_a_rates (ath10k_rates + 4)
-#define ath10k_a_rates_size (ARRAY_SIZE(ath10k_rates) - 4)
-#define ath10k_g_rates (ath10k_rates + 0)
-#define ath10k_g_rates_size (ARRAY_SIZE(ath10k_rates))
-
 struct ath10k *ath10k_mac_create(size_t priv_size)
 {
 	struct ieee80211_hw *hw;
-- 
2.1.4

