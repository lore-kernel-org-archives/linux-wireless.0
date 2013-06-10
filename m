Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:42937 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051Ab3FJWkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 18:40:14 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Paul Stewart <pstew@chromium.org>
Subject: [PATCH] mwifiex: Add module parameter for regdomain
Date: Mon, 10 Jun 2013 15:40:07 -0700
Message-ID: <1370904007-10959-1-git-send-email-bzhao@marvell.com> (sfid-20130611_004019_103790_8108B095)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Allow a regulatory domain country code to be specified at boot
using a module argument.  This overrides the firmware regulatory
mode.

This patch also enables uAP to operate in 11a mode with hostapd.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 00a8281..0d27952 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -20,6 +20,9 @@
 #include "cfg80211.h"
 #include "main.h"
 
+static char *reg_alpha2;
+module_param(reg_alpha2, charp, 0);
+
 static const struct ieee80211_iface_limit mwifiex_ap_sta_limits[] = {
 	{
 		.max = 2, .types = BIT(NL80211_IFTYPE_STATION),
@@ -2475,6 +2478,17 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 #endif
 };
 
+static bool mwifiex_is_valid_alpha2(const char *alpha2)
+{
+	if (!alpha2 || strlen(alpha2) != 2)
+		return false;
+
+	if (isalpha(alpha2[0]) && isalpha(alpha2[1]))
+		return true;
+
+	return false;
+}
+
 /*
  * This function registers the device with CFG802.11 subsystem.
  *
@@ -2527,6 +2541,7 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
 			WIPHY_FLAG_AP_UAPSD |
 			WIPHY_FLAG_CUSTOM_REGULATORY |
+			WIPHY_FLAG_STRICT_REGULATORY |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
 	wiphy_apply_custom_regulatory(wiphy, &mwifiex_world_regdom_custom);
@@ -2568,10 +2583,16 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 		wiphy_free(wiphy);
 		return ret;
 	}
-	country_code = mwifiex_11d_code_2_region(priv->adapter->region_code);
-	if (country_code)
-		dev_info(adapter->dev,
-			 "ignoring F/W country code %2.2s\n", country_code);
+
+	if (reg_alpha2 && mwifiex_is_valid_alpha2(reg_alpha2)) {
+		wiphy_info(wiphy, "driver hint alpha2: %2.2s\n", reg_alpha2);
+		regulatory_hint(wiphy, reg_alpha2);
+	} else {
+		country_code = mwifiex_11d_code_2_region(adapter->region_code);
+		if (country_code)
+			wiphy_info(wiphy, "ignoring F/W country code %2.2s\n",
+				   country_code);
+	}
 
 	adapter->wiphy = wiphy;
 	return ret;
-- 
1.8.2.3

