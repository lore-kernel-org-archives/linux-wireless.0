Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:35071 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2HZINL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 04:13:11 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH 2/2] ath9k_htc: advertise allowed VIFs combination
Date: Sun, 26 Aug 2012 10:12:53 +0200
Message-Id: <1345968773-17166-2-git-send-email-ordex@autistici.org> (sfid-20120826_101328_335797_12BC21BA)
In-Reply-To: <1345968773-17166-1-git-send-email-ordex@autistici.org>
References: <1345968773-17166-1-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver now advertises its allowed VIFs combination to the mac80211
sublayer.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index a035a38..59965e2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -689,6 +689,19 @@ err_hw:
 	return ret;
 }
 
+static const struct ieee80211_iface_limit if_limits[] = {
+	{ .max = ATH9K_HTC_MAX_VIF,  .types = BIT(NL80211_IFTYPE_STATION) },
+	{ .max = ATH9K_HTC_MAX_BCN_VIF,  .types = BIT(NL80211_IFTYPE_AP) },
+	{ .max = 1,  .types = BIT(NL80211_IFTYPE_ADHOC) },
+};
+
+static const struct ieee80211_iface_combination if_comb = {
+	.limits = if_limits,
+	.n_limits = ARRAY_SIZE(if_limits),
+	.max_interfaces = ATH9K_HTC_MAX_VIF,
+	.num_different_channels = 1,
+};
+
 static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 			       struct ieee80211_hw *hw)
 {
@@ -711,6 +724,9 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		BIT(NL80211_IFTYPE_P2P_GO) |
 		BIT(NL80211_IFTYPE_P2P_CLIENT);
 
+	hw->wiphy->iface_combinations = &if_comb;
+	hw->wiphy->n_iface_combinations = 1;
+
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN |
-- 
1.7.12

