Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50472 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755174AbeDTN5v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 09:57:51 -0400
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [PATCH] ath10k: add dynamic vlan support
Date: Fri, 20 Apr 2018 19:27:33 +0530
Message-Id: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org> (sfid-20180420_155756_635204_5F7C3ACD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mutlicast/broadcast traffic destined for a particular vlan group will
always be encrypted in software. To enable dynamic VLANs, it requires
driver support for sending software encrypted packets.

In ath10k, sending sw encrypted frames is allowed only when we insmod
the driver with cryptmode param set to 1, this configuration disables
hardware crypto and enables RAW mode implicitly. Since, enabling raw
mode has performance impact, this cannot be considered as an ideal
solution for supporting VLANs in the driver.

As an alternative take, in this approach, cryptographic keys for
unicast traffic(per peer PTKs) and keys for non-vlan group traffic
will be configured in hardware, allowing hardware encryption for unicast
and non-vlan group traffic. Only vlan group traffic will be encrypted in
software and pushed to the target with encap mode set to RAW in the TX
descriptors.

Not all firmwares can support this type of key configuration(having few
keys installed in hardware and few only in software); for this purpose a
new WMI service flag "WMI_SERVICE_PER_PACKET_SW_ENCRYPT" is introduced to
advertise this support.

Also, adding the logic required to send sw encrypted frames in raw mode.

Tested this change on QCA9984(firmware version 10.4-3.5.3-00057).

Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 26 ++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h  | 21 +++++++++++++++++++++
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index e4ac8f2..105438d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -122,6 +122,7 @@ enum ath10k_skb_flags {
 	ATH10K_SKB_F_DELIVER_CAB = BIT(2),
 	ATH10K_SKB_F_MGMT = BIT(3),
 	ATH10K_SKB_F_QOS = BIT(4),
+	ATH10K_SKB_F_RAW_TX = BIT(5),
 };
 
 struct ath10k_skb_cb {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index fc3320f..694c0aa 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3362,6 +3362,7 @@ ath10k_mac_tx_h_get_txmode(struct ath10k *ar,
 			   struct sk_buff *skb)
 {
 	const struct ieee80211_hdr *hdr = (void *)skb->data;
+	const struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 	__le16 fc = hdr->frame_control;
 
 	if (!vif || vif->type == NL80211_IFTYPE_MONITOR)
@@ -3403,7 +3404,8 @@ ath10k_mac_tx_h_get_txmode(struct ath10k *ar,
 	if (ieee80211_is_data_present(fc) && sta && sta->tdls)
 		return ATH10K_HW_TXRX_ETHERNET;
 
-	if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
+	if (test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags) ||
+	    skb_cb->flags & ATH10K_SKB_F_RAW_TX)
 		return ATH10K_HW_TXRX_RAW;
 
 	return ATH10K_HW_TXRX_NATIVE_WIFI;
@@ -3513,6 +3515,9 @@ static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
+	const struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	bool is_data = ieee80211_is_data(hdr->frame_control) ||
+			ieee80211_is_data_qos(hdr->frame_control);
 
 	cb->flags = 0;
 	if (!ath10k_tx_h_use_hwcrypto(vif, skb))
@@ -3524,6 +3529,16 @@ static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 	if (ieee80211_is_data_qos(hdr->frame_control))
 		cb->flags |= ATH10K_SKB_F_QOS;
 
+	/* Data frames encrypted in software will be posted to firmware
+	 * with tx encap mode set to RAW. One such case would be the
+	 * multicast traffic generated for a VLAN group.
+	 */
+	if (is_data && ieee80211_has_protected(hdr->frame_control) &&
+	    !info->control.hw_key) {
+		cb->flags |= ATH10K_SKB_F_NO_HWCRYPT;
+		cb->flags |= ATH10K_SKB_F_RAW_TX;
+	}
+
 	cb->vif = vif;
 	cb->txq = txq;
 }
@@ -3632,6 +3647,7 @@ static int ath10k_mac_tx(struct ath10k *ar,
 {
 	struct ieee80211_hw *hw = ar->hw;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	const struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 	int ret;
 
 	/* We should disable CCK RATE due to P2P */
@@ -3649,7 +3665,8 @@ static int ath10k_mac_tx(struct ath10k *ar,
 		ath10k_tx_h_8023(skb);
 		break;
 	case ATH10K_HW_TXRX_RAW:
-		if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags) &&
+		    !(skb_cb->flags & ATH10K_SKB_F_RAW_TX)) {
 			WARN_ON_ONCE(1);
 			ieee80211_free_txskb(hw, skb);
 			return -ENOTSUPP;
@@ -8455,6 +8472,11 @@ int ath10k_mac_register(struct ath10k *ar)
 		goto err_dfs_detector_exit;
 	}
 
+	if (test_bit(WMI_SERVICE_PER_PACKET_SW_ENCRYPT, ar->wmi.svc_map)) {
+		ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
+		ar->hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_AP_VLAN);
+	}
+
 	if (!ath_is_world_regd(&ar->ath_common.regulatory)) {
 		ret = regulatory_hint(ar->hw->wiphy,
 				      ar->ath_common.regulatory.alpha2);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 3cc129d..e359b6af 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -202,6 +202,10 @@ enum wmi_service {
 	WMI_SERVICE_HOST_DFS_CHECK_SUPPORT,
 	WMI_SERVICE_TPC_STATS_FINAL,
 	WMI_SERVICE_RESET_CHIP,
+	WMI_SERVICE_CFR_CAPTURE_SUPPORT,
+	WMI_SERVICE_TX_DATA_ACK_RSSI,
+	WMI_SERVICE_CFR_CAPTURE_IND_MSG_TYPE_1,
+	WMI_SERVICE_PER_PACKET_SW_ENCRYPT,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -349,6 +353,10 @@ enum wmi_10_4_service {
 	WMI_10_4_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS,
 	WMI_10_4_SERVICE_HOST_DFS_CHECK_SUPPORT,
 	WMI_10_4_SERVICE_TPC_STATS_FINAL,
+	WMI_10_4_SERVICE_CFR_CAPTURE_SUPPORT,
+	WMI_10_4_SERVICE_TX_DATA_ACK_RSSI,
+	WMI_10_4_SERVICE_CFR_CAPTURE_IND_MSG_TYPE_1,
+	WMI_10_4_SERVICE_PER_PACKET_SW_ENCRYPT,
 };
 
 static inline char *wmi_service_name(int service_id)
@@ -461,6 +469,11 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_HTT_MGMT_TX_COMP_VALID_FLAGS);
 	SVCSTR(WMI_SERVICE_HOST_DFS_CHECK_SUPPORT);
 	SVCSTR(WMI_SERVICE_TPC_STATS_FINAL);
+	SVCSTR(WMI_SERVICE_CFR_CAPTURE_SUPPORT);
+	SVCSTR(WMI_SERVICE_TX_DATA_ACK_RSSI);
+	SVCSTR(WMI_SERVICE_CFR_CAPTURE_IND_MSG_TYPE_1);
+	SVCSTR(WMI_SERVICE_PER_PACKET_SW_ENCRYPT);
+
 	default:
 		return NULL;
 	}
@@ -769,6 +782,14 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_HOST_DFS_CHECK_SUPPORT, len);
 	SVCMAP(WMI_10_4_SERVICE_TPC_STATS_FINAL,
 	       WMI_SERVICE_TPC_STATS_FINAL, len);
+	SVCMAP(WMI_10_4_SERVICE_CFR_CAPTURE_SUPPORT,
+	       WMI_SERVICE_CFR_CAPTURE_SUPPORT, len);
+	SVCMAP(WMI_10_4_SERVICE_TX_DATA_ACK_RSSI,
+	       WMI_SERVICE_TX_DATA_ACK_RSSI, len);
+	SVCMAP(WMI_10_4_SERVICE_CFR_CAPTURE_IND_MSG_TYPE_1,
+	       WMI_SERVICE_CFR_CAPTURE_IND_MSG_TYPE_1, len);
+	SVCMAP(WMI_10_4_SERVICE_PER_PACKET_SW_ENCRYPT,
+	       WMI_SERVICE_PER_PACKET_SW_ENCRYPT, len);
 }
 
 #undef SVCMAP
-- 
2.7.4
