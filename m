Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0067.outbound.protection.outlook.com ([104.47.34.67]:6496
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751002AbdFTTzy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 15:55:54 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 2/8] qtnfmac: cleanup and fixes preparing AP_VLAN support
Date: Tue, 20 Jun 2017 22:55:11 +0300
Message-Id: <20170620195517.18373-3-sergey.matyukevich.os@quantenna.com> (sfid-20170620_215558_755006_08F28893)
In-Reply-To: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements various cleanups and fixes aimed to
simplify adding AP_VLAN support to qtnfmac driver:

- Remove unused flag field from qlink_intf_info
- Add interface type to qlink_cmd_change_sta
- Modify qtnf_cmd_send_change_sta: add interface type to command
- Fix handling of iftype mask reported by firmware:
  Firmware sends supported interface type rather than mask. As a result,
  types field of ieee80211_iface_limit structure may end up having
  multiple iftype bits set. This leads to WARN_ON from
  wiphy_verify_combinations.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 35 +++++++++++++++++-----
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  4 +--
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 23 +++++++-------
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |  2 +-
 4 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 2ee007ecb236..5a6caf5b685b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -995,7 +995,7 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 	struct ieee80211_iface_limit *limits = NULL;
 	const struct qlink_iface_limit *limit_record;
 	size_t record_count = 0, rec = 0;
-	u16 tlv_type, tlv_value_len, mask;
+	u16 tlv_type, tlv_value_len;
 	struct qlink_iface_comb_num *comb;
 	size_t tlv_full_len;
 	const struct qlink_tlv_hdr *tlv;
@@ -1048,9 +1048,10 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 
 			limit_record = (void *)tlv->val;
 			limits[rec].max = le16_to_cpu(limit_record->max_num);
-			mask = le16_to_cpu(limit_record->type_mask);
-			limits[rec].types = qlink_iface_type_mask_to_nl(mask);
-			/* only AP and STA modes are supported */
+			limits[rec].types = qlink_iface_type_to_nl_mask(
+				le16_to_cpu(limit_record->type));
+
+			/* supported modes: STA, AP */
 			limits[rec].types &= BIT(NL80211_IFTYPE_AP) |
 					     BIT(NL80211_IFTYPE_STATION);
 
@@ -1063,6 +1064,7 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 		default:
 			break;
 		}
+
 		tlv_buf_size -= tlv_full_len;
 		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
 	}
@@ -1808,10 +1810,27 @@ int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
 
 	cmd = (struct qlink_cmd_change_sta *)cmd_skb->data;
 	ether_addr_copy(cmd->sta_addr, mac);
-	cmd->sta_flags_mask = cpu_to_le32(qtnf_encode_sta_flags(
-					  params->sta_flags_mask));
-	cmd->sta_flags_set = cpu_to_le32(qtnf_encode_sta_flags(
-					 params->sta_flags_set));
+
+	switch (vif->wdev.iftype) {
+	case NL80211_IFTYPE_AP:
+		cmd->if_type = cpu_to_le16(QLINK_IFTYPE_AP);
+		cmd->sta_flags_mask = cpu_to_le32(qtnf_encode_sta_flags(
+						  params->sta_flags_mask));
+		cmd->sta_flags_set = cpu_to_le32(qtnf_encode_sta_flags(
+						 params->sta_flags_set));
+		break;
+	case NL80211_IFTYPE_STATION:
+		cmd->if_type = cpu_to_le16(QLINK_IFTYPE_STATION);
+		cmd->sta_flags_mask = cpu_to_le32(qtnf_encode_sta_flags(
+						  params->sta_flags_mask));
+		cmd->sta_flags_set = cpu_to_le32(qtnf_encode_sta_flags(
+						 params->sta_flags_set));
+		break;
+	default:
+		pr_err("unsupported iftype %d\n", vif->wdev.iftype);
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
 	if (unlikely(ret))
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index e27833b78940..8bcd8a55ad11 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -90,7 +90,6 @@ enum qlink_iface_type {
  */
 struct qlink_intf_info {
 	__le16 if_type;
-	__le16 flags;
 	u8 mac_addr[ETH_ALEN];
 	u8 rsvd[2];
 } __packed;
@@ -350,6 +349,7 @@ struct qlink_cmd_change_sta {
 	struct qlink_cmd chdr;
 	__le32 sta_flags_mask;
 	__le32 sta_flags_set;
+	__le16 if_type;
 	u8 sta_addr[ETH_ALEN];
 } __packed;
 
@@ -823,7 +823,7 @@ struct qlink_tlv_hdr {
 
 struct qlink_iface_limit {
 	__le16 max_num;
-	__le16 type_mask;
+	__le16 type;
 } __packed;
 
 struct qlink_iface_comb_num {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
index 49ae652ad9a3..22fa631d692d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -17,24 +17,27 @@
 
 #include "qlink_util.h"
 
-u16 qlink_iface_type_mask_to_nl(u16 qlink_mask)
+u16 qlink_iface_type_to_nl_mask(u16 qlink_type)
 {
 	u16 result = 0;
 
-	if (qlink_mask & QLINK_IFTYPE_AP)
+	switch (qlink_type) {
+	case QLINK_IFTYPE_AP:
 		result |= BIT(NL80211_IFTYPE_AP);
-
-	if (qlink_mask & QLINK_IFTYPE_STATION)
+		break;
+	case QLINK_IFTYPE_STATION:
 		result |= BIT(NL80211_IFTYPE_STATION);
-
-	if (qlink_mask & QLINK_IFTYPE_ADHOC)
+		break;
+	case QLINK_IFTYPE_ADHOC:
 		result |= BIT(NL80211_IFTYPE_ADHOC);
-
-	if (qlink_mask & QLINK_IFTYPE_MONITOR)
+		break;
+	case QLINK_IFTYPE_MONITOR:
 		result |= BIT(NL80211_IFTYPE_MONITOR);
-
-	if (qlink_mask & QLINK_IFTYPE_WDS)
+		break;
+	case QLINK_IFTYPE_WDS:
 		result |= BIT(NL80211_IFTYPE_WDS);
+		break;
+	}
 
 	return result;
 }
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
index d8de484b5995..18d0d679a649 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -74,7 +74,7 @@ static inline void qtnf_cmd_skb_put_tlv_u16(struct sk_buff *skb,
 	memcpy(hdr->val, &tmp, sizeof(tmp));
 }
 
-u16 qlink_iface_type_mask_to_nl(u16 qlink_mask);
+u16 qlink_iface_type_to_nl_mask(u16 qlink_type);
 u8 qlink_chan_width_mask_to_nl(u16 qlink_mask);
 
 #endif /* _QTN_FMAC_QLINK_UTIL_H_ */
-- 
2.11.0
