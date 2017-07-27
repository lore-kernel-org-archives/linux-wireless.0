Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0082.outbound.protection.outlook.com ([104.47.41.82]:14763
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751673AbdG0XHz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 19:07:55 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 12/12] qtnfmac: prepare for AP_VLAN interface type support
Date: Fri, 28 Jul 2017 02:06:54 +0300
Message-Id: <20170727230654.30850-13-sergey.matyukevich.os@quantenna.com> (sfid-20170728_013043_217628_F23A6CED)
In-Reply-To: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
References: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modify qlink command structures and interface types handling
to prepare adding AP_VLAN support to qtnfmac driver.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 27 ++++++++++++++++++----
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 13 ++++++++---
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    |  3 +++
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 94656106b496..4206886b110c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1047,6 +1047,7 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 
 			/* supported modes: STA, AP */
 			limits[rec].types &= BIT(NL80211_IFTYPE_AP) |
+					     BIT(NL80211_IFTYPE_AP_VLAN) |
 					     BIT(NL80211_IFTYPE_STATION);
 
 			pr_debug("MAC%u: MAX: %u; TYPES: %.4X\n", mac->macid,
@@ -1058,6 +1059,7 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 		default:
 			break;
 		}
+
 		tlv_buf_size -= tlv_full_len;
 		tlv = (struct qlink_tlv_hdr *)(tlv->val + tlv_value_len);
 	}
@@ -1859,10 +1861,27 @@ int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
 
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
index ec5126362494..a8242f678496 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -19,7 +19,7 @@
 
 #include <linux/ieee80211.h>
 
-#define QLINK_PROTO_VER		4
+#define QLINK_PROTO_VER		5
 
 #define QLINK_MACID_RSVD		0xFF
 #define QLINK_VIFID_RSVD		0xFF
@@ -77,6 +77,7 @@ enum qlink_iface_type {
 	QLINK_IFTYPE_ADHOC	= 3,
 	QLINK_IFTYPE_MONITOR	= 4,
 	QLINK_IFTYPE_WDS	= 5,
+	QLINK_IFTYPE_AP_VLAN	= 6,
 };
 
 /**
@@ -85,12 +86,12 @@ enum qlink_iface_type {
  * Data describing a single virtual interface.
  *
  * @if_type: Mode of interface operation, one of &enum qlink_iface_type
- * @flags: interface flagsmap.
+ * @vlanid: VLAN ID for AP_VLAN interface type
  * @mac_addr: MAC address of virtual interface.
  */
 struct qlink_intf_info {
 	__le16 if_type;
-	__le16 flags;
+	__le16 vlanid;
 	u8 mac_addr[ETH_ALEN];
 	u8 rsvd[2];
 } __packed;
@@ -292,6 +293,7 @@ struct qlink_cmd_get_sta_info {
  * @pairwise: whether to use pairwise key.
  * @addr: MAC address of a STA key is being installed to.
  * @cipher: cipher suite.
+ * @vlanid: VLAN ID for AP_VLAN interface type
  * @key_data: key data itself.
  */
 struct qlink_cmd_add_key {
@@ -300,6 +302,7 @@ struct qlink_cmd_add_key {
 	u8 pairwise;
 	u8 addr[ETH_ALEN];
 	__le32 cipher;
+	__le16 vlanid;
 	u8 key_data[0];
 } __packed;
 
@@ -346,12 +349,16 @@ struct qlink_cmd_set_def_mgmt_key {
  *
  * @sta_flags_mask: STA flags mask, bitmap of &enum qlink_sta_flags
  * @sta_flags_set: STA flags values, bitmap of &enum qlink_sta_flags
+ * @if_type: Mode of interface operation, one of &enum qlink_iface_type
+ * @vlanid: VLAN ID to assign to specific STA
  * @sta_addr: address of the STA for which parameters are set.
  */
 struct qlink_cmd_change_sta {
 	struct qlink_cmd chdr;
 	__le32 sta_flags_mask;
 	__le32 sta_flags_set;
+	__le16 if_type;
+	__le16 vlanid;
 	u8 sta_addr[ETH_ALEN];
 } __packed;
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
index 22fa631d692d..cf024c995fd6 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -37,6 +37,9 @@ u16 qlink_iface_type_to_nl_mask(u16 qlink_type)
 	case QLINK_IFTYPE_WDS:
 		result |= BIT(NL80211_IFTYPE_WDS);
 		break;
+	case QLINK_IFTYPE_AP_VLAN:
+		result |= BIT(NL80211_IFTYPE_AP_VLAN);
+		break;
 	}
 
 	return result;
-- 
2.11.0
