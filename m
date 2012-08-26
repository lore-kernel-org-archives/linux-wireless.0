Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:62240 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab2HZUzZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 16:55:25 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCHv2 2/2] ath9k_htc: advertise allowed VIFs combination
Date: Sun, 26 Aug 2012 22:55:05 +0200
Message-Id: <1346014505-7554-2-git-send-email-ordex@autistici.org> (sfid-20120826_225529_699045_B5BAE44C)
In-Reply-To: <1346014505-7554-1-git-send-email-ordex@autistici.org>
References: <1346014505-7554-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver now advertises its allowed VIFs combinations to the mac80211
sublayer.

Other than that, practical tests shown that ath9k_htc devices allow an IBSS VIF
to coexist with VIF set up on other modes. This patch removes the check which
block the creation of any other VIF whenever an IBSS one is already present.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 30 +++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index a035a38..6aa2af4 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -689,6 +689,33 @@ err_hw:
 	return ret;
 }
 
+/* it is possible to have at most ATH9K_HTC_MAX_BCN_VIF beaconing interfaces,
+ * therefore either we have 1 IBSS + ATH9K_HTC_MAX_BCN_VIF - 1 APs, or we have
+ * only ATH9K_HTC_MAX_BCN_VIF APs */
+static const struct ieee80211_iface_limit if_limits_ibss[] = {
+	{ .max = ATH9K_HTC_MAX_VIF,  .types = BIT(NL80211_IFTYPE_STATION) },
+	{ .max = ATH9K_HTC_MAX_BCN_VIF - 1,  .types = BIT(NL80211_IFTYPE_AP) },
+	{ .max = 1,  .types = BIT(NL80211_IFTYPE_ADHOC) },
+};
+
+static const struct ieee80211_iface_limit if_limits_noibss[] = {
+	{ .max = ATH9K_HTC_MAX_VIF,  .types = BIT(NL80211_IFTYPE_STATION) },
+	{ .max = ATH9K_HTC_MAX_BCN_VIF,  .types = BIT(NL80211_IFTYPE_AP) },
+};
+
+static const struct ieee80211_iface_combination if_comb[] = {
+	{ .limits = if_limits_ibss,
+	  .n_limits = ARRAY_SIZE(if_limits_ibss),
+	  .max_interfaces = ATH9K_HTC_MAX_VIF,
+	  .num_different_channels = 1,
+	},
+	{ .limits = if_limits_noibss,
+	  .n_limits = ARRAY_SIZE(if_limits_noibss),
+	  .max_interfaces = ATH9K_HTC_MAX_VIF,
+	  .num_different_channels = 1,
+	},
+};
+
 static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 			       struct ieee80211_hw *hw)
 {
@@ -711,6 +738,9 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		BIT(NL80211_IFTYPE_P2P_GO) |
 		BIT(NL80211_IFTYPE_P2P_CLIENT);
 
+	hw->wiphy->iface_combinations = if_comb;
+	hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
+
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN |
-- 
1.7.12

