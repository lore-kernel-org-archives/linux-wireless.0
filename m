Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60466 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbeIRMCe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 08:02:34 -0400
From: Maharaja Kennadyrajan <mkenna@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>
Subject: [PATCH] ath10k: Advertize beacon_int_min_gcd as 100 while bring up  multi vaps
Date: Tue, 18 Sep 2018 12:03:49 +0530
Message-Id: <1537252429-8655-1-git-send-email-mkenna@codeaurora.org> (sfid-20180918_083130_449260_F0B993FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the latest firmware design, the beacon interval should be
greater than 100 to bring the multiple vaps.

Set beacon_int_min_gcd to 100, when the wmi service
WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT is enabled
in the firmware. If not, beacon_int_min_gcd will be set
to the default value 1.

Tested in QCA4019 with firmware ver 10.4-3.2.1.1-00015
Tested in QCA9888 with firmware ver 10.4-3.5.1-0005

Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 25 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h |  9 +++++++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 97548f9..532fc5d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8163,6 +8163,24 @@ void ath10k_mac_destroy(struct ath10k *ar)
 	},
 };
 
+static const struct
+ieee80211_iface_combination ath10k_10_4_bcn_int_if_comb[] = {
+	{
+		.limits = ath10k_10_4_if_limits,
+		.n_limits = ARRAY_SIZE(ath10k_10_4_if_limits),
+		.max_interfaces = 16,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+		.beacon_int_min_gcd = 100,
+#ifdef CONFIG_ATH10K_DFS_CERTIFIED
+		.radar_detect_widths =  BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+					BIT(NL80211_CHAN_WIDTH_20) |
+					BIT(NL80211_CHAN_WIDTH_40) |
+					BIT(NL80211_CHAN_WIDTH_80),
+#endif
+	},
+};
+
 static void ath10k_get_arvif_iter(void *data, u8 *mac,
 				  struct ieee80211_vif *vif)
 {
@@ -8526,6 +8544,13 @@ int ath10k_mac_register(struct ath10k *ar)
 		ar->hw->wiphy->iface_combinations = ath10k_10_4_if_comb;
 		ar->hw->wiphy->n_iface_combinations =
 			ARRAY_SIZE(ath10k_10_4_if_comb);
+		if (test_bit(WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
+			     ar->wmi.svc_map)) {
+			ar->hw->wiphy->iface_combinations =
+				ath10k_10_4_bcn_int_if_comb;
+			ar->hw->wiphy->n_iface_combinations =
+				ARRAY_SIZE(ath10k_10_4_bcn_int_if_comb);
+		}
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1562294..126eb17 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -204,6 +204,7 @@ enum wmi_service {
 	WMI_SERVICE_RESET_CHIP,
 	WMI_SERVICE_SPOOF_MAC_SUPPORT,
 	WMI_SERVICE_TX_DATA_ACK_RSSI,
+	WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -353,6 +354,11 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_TPC_STATS_FINAL,
 	WMI_10_4_SERVICE_CFR_CAPTURE_SUPPORT,
 	WMI_10_4_SERVICE_TX_DATA_ACK_RSSI,
+	WMI_10_4_SERVICE_CFR_CAPTURE_IND_MSG_TYPE_LAGACY,
+	WMI_10_4_SERVICE_PER_PACKET_SW_ENCRYPT,
+	WMI_10_4_SERVICE_PEER_TID_CONFIGS_SUPPORT,
+	WMI_10_4_SERVICE_VDEV_BCN_RATE_CONTROL,
+	WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
 };
 
 static inline char *wmi_service_name(int service_id)
@@ -467,6 +473,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_TPC_STATS_FINAL);
 	SVCSTR(WMI_SERVICE_RESET_CHIP);
 	SVCSTR(WMI_SERVICE_TX_DATA_ACK_RSSI);
+	SVCSTR(WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT);
 	default:
 		return NULL;
 	}
@@ -777,6 +784,8 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_TPC_STATS_FINAL, len);
 	SVCMAP(WMI_10_4_SERVICE_TX_DATA_ACK_RSSI,
 	       WMI_SERVICE_TX_DATA_ACK_RSSI, len);
+	SVCMAP(WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
+	       WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT, len);
 }
 
 #undef SVCMAP
-- 
1.9.1
