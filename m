Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9167 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbbFPFz0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:55:26 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 6/8] ath10k: advertise 10.4 fw ap and sta iface combination to mac80211
Date: Tue, 16 Jun 2015 11:23:13 +0530
Message-ID: <1434433995-8451-7-git-send-email-rmani@qti.qualcomm.com> (sfid-20150616_075530_373936_3962F2EA)
In-Reply-To: <1434433995-8451-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434433995-8451-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.4 fw supports upto 16 interface in ap mode and 1 interface
in station mode, overall total interfaces supported are 16
interfaces. Populate this limit in wiphy->iface_combinations.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 187e524..3c5d2b0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6620,6 +6620,33 @@ static struct ieee80211_iface_combination ath10k_tlv_qcs_if_comb[] = {
 	},
 };
 
+static const struct ieee80211_iface_limit ath10k_10_4_if_limits[] = {
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.max	= 16,
+		.types	= BIT(NL80211_IFTYPE_AP)
+	},
+};
+
+static const struct ieee80211_iface_combination ath10k_10_4_if_comb[] = {
+	{
+		.limits = ath10k_10_4_if_limits,
+		.n_limits = ARRAY_SIZE(ath10k_10_4_if_limits),
+		.max_interfaces = 16,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+#ifdef CONFIG_ATH10K_DFS_CERTIFIED
+		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+					BIT(NL80211_CHAN_WIDTH_20) |
+					BIT(NL80211_CHAN_WIDTH_40) |
+					BIT(NL80211_CHAN_WIDTH_80),
+#endif
+	},
+};
+
 static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 {
 	struct ieee80211_sta_vht_cap vht_cap = {0};
@@ -6942,6 +6969,9 @@ int ath10k_mac_register(struct ath10k *ar)
 			ARRAY_SIZE(ath10k_10x_if_comb);
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_4:
+		ar->hw->wiphy->iface_combinations = ath10k_10_4_if_comb;
+		ar->hw->wiphy->n_iface_combinations =
+			ARRAY_SIZE(ath10k_10_4_if_comb);
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
-- 
1.8.1.2

