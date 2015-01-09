Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:62782 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbbAILOx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 06:14:53 -0500
Received: by mail-we0-f172.google.com with SMTP id k11so7331769wes.3
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2015 03:14:52 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 8/8] ath10k: add proper wmi-tlv combinations
Date: Fri,  9 Jan 2015 12:14:09 +0100
Message-Id: <1420802049-11962-9-git-send-email-michal.kazior@tieto.com> (sfid-20150109_121500_139117_AC5820EE)
In-Reply-To: <1420802049-11962-1-git-send-email-michal.kazior@tieto.com>
References: <1420802049-11962-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds proper wmi-tlv combinations for both
single- and multi-channel operation.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 81 ++++++++++++++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 6e069a8..8297c19 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2913,6 +2913,15 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err_core_stop;
 	}
 
+	if (test_bit(WMI_SERVICE_ADAPTIVE_OCS, ar->wmi.svc_map)) {
+		ret = ath10k_wmi_adaptive_qcs(ar, true);
+		if (ret) {
+			ath10k_warn(ar, "failed to enable adaptive qcs: %d\n",
+				    ret);
+			goto err_core_stop;
+		}
+	}
+
 	if (ar->cfg_tx_chainmask)
 		__ath10k_set_antenna(ar, ar->cfg_tx_chainmask,
 				     ar->cfg_rx_chainmask);
@@ -5523,6 +5532,64 @@ static const struct ieee80211_iface_combination ath10k_10x_if_comb[] = {
 	},
 };
 
+static const struct ieee80211_iface_limit ath10k_tlv_if_limit[] = {
+	{
+		.max = 2,
+		.types = BIT(NL80211_IFTYPE_STATION) |
+			 BIT(NL80211_IFTYPE_AP) |
+			 BIT(NL80211_IFTYPE_P2P_CLIENT) |
+			 BIT(NL80211_IFTYPE_P2P_GO),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_DEVICE),
+	},
+};
+
+static const struct ieee80211_iface_limit ath10k_tlv_if_limit_ibss[] = {
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_ADHOC),
+	},
+};
+
+/* FIXME: This is not thouroughly tested. These combinations may over- or
+ * underestimate hw/fw capabilities.
+ */
+static struct ieee80211_iface_combination ath10k_tlv_if_comb[] = {
+	{
+		.limits = ath10k_tlv_if_limit,
+		.num_different_channels = 1,
+		.max_interfaces = 2,
+		.n_limits = ARRAY_SIZE(ath10k_tlv_if_limit),
+	},
+	{
+		.limits = ath10k_tlv_if_limit_ibss,
+		.num_different_channels = 1,
+		.max_interfaces = 2,
+		.n_limits = ARRAY_SIZE(ath10k_tlv_if_limit_ibss),
+	},
+};
+
+static struct ieee80211_iface_combination ath10k_tlv_qcs_if_comb[] = {
+	{
+		.limits = ath10k_tlv_if_limit,
+		.num_different_channels = 2,
+		.max_interfaces = 2,
+		.n_limits = ARRAY_SIZE(ath10k_tlv_if_limit),
+	},
+	{
+		.limits = ath10k_tlv_if_limit_ibss,
+		.num_different_channels = 1,
+		.max_interfaces = 2,
+		.n_limits = ARRAY_SIZE(ath10k_tlv_if_limit_ibss),
+	},
+};
+
 static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 {
 	struct ieee80211_sta_vht_cap vht_cap = {0};
@@ -5773,12 +5840,24 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	switch (ar->wmi.op_version) {
 	case ATH10K_FW_WMI_OP_VERSION_MAIN:
-	case ATH10K_FW_WMI_OP_VERSION_TLV:
 		ar->hw->wiphy->iface_combinations = ath10k_if_comb;
 		ar->hw->wiphy->n_iface_combinations =
 			ARRAY_SIZE(ath10k_if_comb);
 		ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
 		break;
+	case ATH10K_FW_WMI_OP_VERSION_TLV:
+		if (test_bit(WMI_SERVICE_ADAPTIVE_OCS, ar->wmi.svc_map)) {
+			ar->hw->wiphy->iface_combinations =
+				ath10k_tlv_qcs_if_comb;
+			ar->hw->wiphy->n_iface_combinations =
+				ARRAY_SIZE(ath10k_tlv_qcs_if_comb);
+		} else {
+			ar->hw->wiphy->iface_combinations = ath10k_tlv_if_comb;
+			ar->hw->wiphy->n_iface_combinations =
+				ARRAY_SIZE(ath10k_tlv_if_comb);
+		}
+		ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
+		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_1:
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
-- 
1.8.5.3

