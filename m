Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51286 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752605AbdAZQVk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 11:21:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: define cipher/AKM suites using a macro
Date: Thu, 26 Jan 2017 17:20:03 +0100
Message-Id: <20170126162003.31531-1-johannes@sipsolutions.net> (sfid-20170126_172143_636222_E3667CB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The spec writes cipher/AKM suites as something like 00-0F-AC:9,
but the part after the colon isn't hex, it's decimal, so that
we've already had a few mistakes (in other code, or unmerged
patches) to e.g. write 0x000FAC10 instead of 0x000FAC0A.

Use a macro to avoid that problem.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 87d1937e4671..02768de209d6 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2324,31 +2324,33 @@ enum ieee80211_sa_query_action {
 };
 
 
+#define SUITE(oui, id)	(((oui) << 8) | (id))
+
 /* cipher suite selectors */
-#define WLAN_CIPHER_SUITE_USE_GROUP	0x000FAC00
-#define WLAN_CIPHER_SUITE_WEP40		0x000FAC01
-#define WLAN_CIPHER_SUITE_TKIP		0x000FAC02
-/* reserved: 				0x000FAC03 */
-#define WLAN_CIPHER_SUITE_CCMP		0x000FAC04
-#define WLAN_CIPHER_SUITE_WEP104	0x000FAC05
-#define WLAN_CIPHER_SUITE_AES_CMAC	0x000FAC06
-#define WLAN_CIPHER_SUITE_GCMP		0x000FAC08
-#define WLAN_CIPHER_SUITE_GCMP_256	0x000FAC09
-#define WLAN_CIPHER_SUITE_CCMP_256	0x000FAC0A
-#define WLAN_CIPHER_SUITE_BIP_GMAC_128	0x000FAC0B
-#define WLAN_CIPHER_SUITE_BIP_GMAC_256	0x000FAC0C
-#define WLAN_CIPHER_SUITE_BIP_CMAC_256	0x000FAC0D
-
-#define WLAN_CIPHER_SUITE_SMS4		0x00147201
+#define WLAN_CIPHER_SUITE_USE_GROUP	SUITE(0x000FAC, 0)
+#define WLAN_CIPHER_SUITE_WEP40		SUITE(0x000FAC, 1)
+#define WLAN_CIPHER_SUITE_TKIP		SUITE(0x000FAC, 2)
+/* reserved: 				SUITE(0x000FAC, 3) */
+#define WLAN_CIPHER_SUITE_CCMP		SUITE(0x000FAC, 4)
+#define WLAN_CIPHER_SUITE_WEP104	SUITE(0x000FAC, 5)
+#define WLAN_CIPHER_SUITE_AES_CMAC	SUITE(0x000FAC, 6)
+#define WLAN_CIPHER_SUITE_GCMP		SUITE(0x000FAC, 8)
+#define WLAN_CIPHER_SUITE_GCMP_256	SUITE(0x000FAC, 9)
+#define WLAN_CIPHER_SUITE_CCMP_256	SUITE(0x000FAC, 10)
+#define WLAN_CIPHER_SUITE_BIP_GMAC_128	SUITE(0x000FAC, 11)
+#define WLAN_CIPHER_SUITE_BIP_GMAC_256	SUITE(0x000FAC, 12)
+#define WLAN_CIPHER_SUITE_BIP_CMAC_256	SUITE(0x000FAC, 13)
+
+#define WLAN_CIPHER_SUITE_SMS4		SUITE(0x001472, 1)
 
 /* AKM suite selectors */
-#define WLAN_AKM_SUITE_8021X		0x000FAC01
-#define WLAN_AKM_SUITE_PSK		0x000FAC02
-#define WLAN_AKM_SUITE_8021X_SHA256	0x000FAC05
-#define WLAN_AKM_SUITE_PSK_SHA256	0x000FAC06
-#define WLAN_AKM_SUITE_TDLS		0x000FAC07
-#define WLAN_AKM_SUITE_SAE		0x000FAC08
-#define WLAN_AKM_SUITE_FT_OVER_SAE	0x000FAC09
+#define WLAN_AKM_SUITE_8021X		SUITE(0x000FAC, 1)
+#define WLAN_AKM_SUITE_PSK		SUITE(0x000FAC, 2)
+#define WLAN_AKM_SUITE_8021X_SHA256	SUITE(0x000FAC, 5)
+#define WLAN_AKM_SUITE_PSK_SHA256	SUITE(0x000FAC, 6)
+#define WLAN_AKM_SUITE_TDLS		SUITE(0x000FAC, 7)
+#define WLAN_AKM_SUITE_SAE		SUITE(0x000FAC, 8)
+#define WLAN_AKM_SUITE_FT_OVER_SAE	SUITE(0x000FAC, 9)
 
 #define WLAN_MAX_KEY_LEN		32
 
-- 
2.9.3
