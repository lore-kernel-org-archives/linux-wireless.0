Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36260 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdH3Jna (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 05:43:30 -0400
Received: by mail-pg0-f67.google.com with SMTP id 83so4713536pgb.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 02:43:30 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 1/8] rsi: add p2p support parameters to mac80211
Date: Wed, 30 Aug 2017 15:08:21 +0530
Message-Id: <1504085908-2163-2-git-send-email-amitkarwar@gmail.com> (sfid-20170830_114411_219812_E8680FF8)
In-Reply-To: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
References: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

This patch adds p2p supported parameters to mac80211 hw and
wiphy structures during mac80211 registration.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 37 ++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index fa12c05..992ac6c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -139,6 +139,32 @@ static const u32 rsi_max_ap_stas[16] = {
 	4,	/* 14 - AP + BT Dual */
 };
 
+static const struct ieee80211_iface_limit rsi_iface_limits[] = {
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_AP) |
+			BIT(NL80211_IFTYPE_P2P_CLIENT) |
+			BIT(NL80211_IFTYPE_P2P_GO),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_DEVICE),
+	},
+};
+
+static const struct ieee80211_iface_combination rsi_iface_combinations[] = {
+	{
+		.num_different_channels = 1,
+		.max_interfaces = 3,
+		.limits = rsi_iface_limits,
+		.n_limits = ARRAY_SIZE(rsi_iface_limits),
+	},
+};
+
 /**
  * rsi_is_cipher_wep() -  This function determines if the cipher is WEP or not.
  * @common: Pointer to the driver private structure.
@@ -1581,7 +1607,11 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	ether_addr_copy(hw->wiphy->addr_mask, addr_mask);
 
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-				 BIT(NL80211_IFTYPE_AP);
+				 BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_P2P_DEVICE) |
+				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				 BIT(NL80211_IFTYPE_P2P_GO);
+
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->retry_short = RETRY_SHORT;
 	wiphy->retry_long  = RETRY_LONG;
@@ -1608,6 +1638,11 @@ int rsi_mac80211_attach(struct rsi_common *common)
 
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 
+	/* Wi-Fi direct parameters */
+	hw->max_listen_interval = 10;
+	wiphy->iface_combinations = rsi_iface_combinations;
+	wiphy->n_iface_combinations = ARRAY_SIZE(rsi_iface_combinations);
+
 	status = ieee80211_register_hw(hw);
 	if (status)
 		return status;
-- 
2.7.4
