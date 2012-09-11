Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:55989 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757260Ab2IKBcV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 21:32:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 08/10] mwifiex: support custom world regulatory domain
Date: Mon, 10 Sep 2012 18:30:47 -0700
Message-Id: <1347327049-13665-9-git-send-email-bzhao@marvell.com> (sfid-20120911_033231_090321_CD5E0299)
In-Reply-To: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
References: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

country 00 (world regulatory domain) doesn't define channels
52 - 64 and 100 - 140. Add these channels to our custom world
regulatory domain.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   35 ++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 797f978..b9f7b3e 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -37,6 +37,36 @@ static const struct ieee80211_iface_combination mwifiex_iface_comb_ap_sta = {
 	.beacon_int_infra_match = true,
 };
 
+static const struct ieee80211_regdomain mwifiex_world_regdom_custom = {
+	.n_reg_rules = 7,
+	.alpha2 =  "99",
+	.reg_rules = {
+		/* Channel 1 - 11 */
+		REG_RULE(2412-10, 2462+10, 40, 3, 20, 0),
+		/* Channel 12 - 13 */
+		REG_RULE(2467-10, 2472+10, 20, 3, 20,
+			 NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS),
+		/* Channel 14 */
+		REG_RULE(2484-10, 2484+10, 20, 3, 20,
+			 NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS |
+			 NL80211_RRF_NO_OFDM),
+		/* Channel 36 - 48 */
+		REG_RULE(5180-10, 5240+10, 40, 3, 20,
+			 NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS),
+		/* Channel 149 - 165 */
+		REG_RULE(5745-10, 5825+10, 40, 3, 20,
+			 NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS),
+		/* Channel 52 - 64 */
+		REG_RULE(5260-10, 5320+10, 40, 3, 30,
+			 NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS |
+			 NL80211_RRF_DFS),
+		/* Channel 100 - 140 */
+		REG_RULE(5500-10, 5700+10, 40, 3, 30,
+			 NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS |
+			 NL80211_RRF_DFS),
+	}
+};
+
 /*
  * This function maps the nl802.11 channel type into driver channel type.
  *
@@ -1833,7 +1863,10 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	memcpy(wiphy->perm_addr, priv->curr_addr, ETH_ALEN);
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
-			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
+			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
+			WIPHY_FLAG_CUSTOM_REGULATORY;
+
+	wiphy_apply_custom_regulatory(wiphy, &mwifiex_world_regdom_custom);
 
 	wiphy->probe_resp_offload = NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2;
-- 
1.7.0.2

