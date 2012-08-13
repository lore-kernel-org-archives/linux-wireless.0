Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21397 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2HMPXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 11:23:24 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC 2/3] ath9k_htc: Advertise interface combinations supported
Date: Mon, 13 Aug 2012 20:52:19 +0530
Message-ID: <1344871339-6575-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120813_172339_351594_E855A14B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

This will allow us to create the multivif the driver supports.
Also this ensures the multivif support and limitation advertized
by the driver is taken care in cfg80211 itself.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index a035a38..5022141 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -689,6 +689,21 @@ err_hw:
 	return ret;
 }
 
+static const struct ieee80211_iface_limit if_limits[] = {
+	{ .max = 2,	.types = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_P2P_CLIENT) },
+	{ .max = 2,	.types =
+			BIT(NL80211_IFTYPE_AP) |
+			BIT(NL80211_IFTYPE_P2P_GO) },
+};
+
+static const struct ieee80211_iface_combination if_comb = {
+	.limits = if_limits,
+	.n_limits = ARRAY_SIZE(if_limits),
+	.max_interfaces = 2,
+	.num_different_channels = 1,
+};
+
 static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 			       struct ieee80211_hw *hw)
 {
@@ -711,6 +726,9 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		BIT(NL80211_IFTYPE_P2P_GO) |
 		BIT(NL80211_IFTYPE_P2P_CLIENT);
 
+	hw->wiphy->iface_combinations = &if_comb;
+	hw->wiphy->n_iface_combinations = 1;
+
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN |
-- 
1.7.0.4

