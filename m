Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31932 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2I0Pwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 11:52:43 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Antonio Quartulli <ordex@autistici.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 1/2] ath9k_htc: Advertize allowed vif combinations
Date: Thu, 27 Sep 2012 21:22:11 +0530
Message-ID: <1348761132-8344-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120927_175246_756802_ED65CC57)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <ordex@autistici.org>

Advertize allowed VIFs combinations to the cfg80211 sublayer.
Other than that, practical tests shown that ath9k_htc devices allow an
IBSS VIF to coexist with VIF set up on other modes, so advertize
that to. We can also further add p2p/mesh mode to be advertized
in the combinations allowed.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   35 +++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index d98255e..4d65af1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -694,6 +694,38 @@ err_hw:
 	return ret;
 }
 
+/*
+ * It is possible to have atmost ATH9K_HTC_MAX_BCN_VIF beaconing interfaces
+ * therefore either we have 1 IBSS + ATH9K_HTC_MAX_BCN_VIF - 1 AP's, or we
+ * have only ATH9K_HTC_MAX_BCN_VIF AP's
+ */
+
+static const struct ieee80211_iface_limit if_limits_ibss[] = {
+	{.max = ATH9K_HTC_MAX_VIF, .types = BIT(NL80211_IFTYPE_STATION)},
+	{.max = ATH9K_HTC_MAX_VIF - 1, .types = BIT(NL80211_IFTYPE_AP)},
+	{.max = 1, .types = BIT(NL80211_IFTYPE_ADHOC)},
+};
+
+static const struct ieee80211_iface_limit if_limits_no_ibss[] = {
+	{.max = ATH9K_HTC_MAX_VIF, .types = BIT(NL80211_IFTYPE_STATION)},
+	{.max = ATH9K_HTC_MAX_VIF, .types = BIT(NL80211_IFTYPE_AP)},
+};
+
+static const struct ieee80211_iface_combination if_comb[] = {
+	{.limits = if_limits_ibss,
+	 .n_limits = ARRAY_SIZE(if_limits_ibss),
+	 .max_interfaces = ATH9K_HTC_MAX_VIF,
+	 .num_different_channels = 1,
+	 .beacon_int_infra_match = true,
+	},
+	{.limits = if_limits_no_ibss,
+	 .n_limits = ARRAY_SIZE(if_limits_no_ibss),
+	 .max_interfaces = ATH9K_HTC_MAX_VIF,
+	 .num_different_channels = 1,
+	 .beacon_int_infra_match = true,
+	},
+};
+
 static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 			       struct ieee80211_hw *hw)
 {
@@ -716,6 +748,9 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		BIT(NL80211_IFTYPE_P2P_GO) |
 		BIT(NL80211_IFTYPE_P2P_CLIENT);
 
+	hw->wiphy->iface_combinations = if_comb;
+	hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
+
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN |
-- 
1.7.0.4

