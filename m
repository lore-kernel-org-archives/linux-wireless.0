Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35957 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbbCXMp7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 08:45:59 -0400
Received: by lbbug6 with SMTP id ug6so45499669lbb.3
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2015 05:45:57 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v5 6/7] ath10k: enable multi-channel on supported devices
Date: Tue, 24 Mar 2015 12:43:12 +0000
Message-Id: <1427200993-7550-7-git-send-email-michal.kazior@tieto.com> (sfid-20150324_134605_899798_8692A6C0)
In-Reply-To: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com>
References: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This effectively enables multi-channel operation
on qca6174 WLAN.RM.2.0-00073 (and possibly any
newer firmware release for qca6174).

This adds appopriate interface combinations and
initializes firmware channel scheduler.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v5:
     * fix combination definition: increase vif limit from 2 to 3

 drivers/net/wireless/ath/ath10k/mac.c | 81 ++++++++++++++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1d6191d89586..47f0c77b9271 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3721,6 +3721,15 @@ static int ath10k_start(struct ieee80211_hw *hw)
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
@@ -6474,6 +6483,64 @@ static const struct ieee80211_iface_combination ath10k_10x_if_comb[] = {
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
+		.max_interfaces = 3,
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
+		.max_interfaces = 3,
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
@@ -6766,12 +6833,24 @@ int ath10k_mac_register(struct ath10k *ar)
 
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
2.1.4

