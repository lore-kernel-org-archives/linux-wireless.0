Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58103 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbaFDNc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:32:57 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH] mwifiex: Remove custom world regulatory domain
Date: Wed,  4 Jun 2014 15:32:32 +0200
Message-Id: <1401888752-11224-1-git-send-email-mpa@pengutronix.de> (sfid-20140604_153301_128144_90B06C1C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A custom regulatory domain was introduced in this commit:
cc0ba0d mwifiex: support custom world regulatory domain

The commit description says that it was introduced because the world
regulatory domain does not include channels 52-64 and 100-140. These
channels are described in the world regulatory domain now, so we can
drop this custom regulatory domain.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 36 ---------------------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 21ee27a..2b35a97 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -42,36 +42,6 @@ static const struct ieee80211_iface_combination mwifiex_iface_comb_ap_sta = {
 	.beacon_int_infra_match = true,
 };
 
-static const struct ieee80211_regdomain mwifiex_world_regdom_custom = {
-	.n_reg_rules = 7,
-	.alpha2 =  "99",
-	.reg_rules = {
-		/* Channel 1 - 11 */
-		REG_RULE(2412-10, 2462+10, 40, 3, 20, 0),
-		/* Channel 12 - 13 */
-		REG_RULE(2467-10, 2472+10, 20, 3, 20,
-			 NL80211_RRF_NO_IR),
-		/* Channel 14 */
-		REG_RULE(2484-10, 2484+10, 20, 3, 20,
-			 NL80211_RRF_NO_IR |
-			 NL80211_RRF_NO_OFDM),
-		/* Channel 36 - 48 */
-		REG_RULE(5180-10, 5240+10, 40, 3, 20,
-			 NL80211_RRF_NO_IR),
-		/* Channel 149 - 165 */
-		REG_RULE(5745-10, 5825+10, 40, 3, 20,
-			 NL80211_RRF_NO_IR),
-		/* Channel 52 - 64 */
-		REG_RULE(5260-10, 5320+10, 40, 3, 30,
-			 NL80211_RRF_NO_IR |
-			 NL80211_RRF_DFS),
-		/* Channel 100 - 140 */
-		REG_RULE(5500-10, 5700+10, 40, 3, 30,
-			 NL80211_RRF_NO_IR |
-			 NL80211_RRF_DFS),
-	}
-};
-
 /*
  * This function maps the nl802.11 channel type into driver channel type.
  *
@@ -2917,12 +2887,6 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 		wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
 				WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
 
-	wiphy->regulatory_flags |=
-			REGULATORY_CUSTOM_REG |
-			REGULATORY_STRICT_REG;
-
-	wiphy_apply_custom_regulatory(wiphy, &mwifiex_world_regdom_custom);
-
 #ifdef CONFIG_PM
 	wiphy->wowlan = &mwifiex_wowlan_support;
 #endif
-- 
2.0.0.rc2

