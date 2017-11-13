Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0085.outbound.protection.outlook.com ([104.47.32.85]:59533
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752313AbdKMK2m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 05:28:42 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH 10/10] qtnfmac: support MAC address based access control
Date: Mon, 13 Nov 2017 13:28:15 +0300
Message-Id: <20171113102815.11254-11-sergey.matyukevich.os@quantenna.com> (sfid-20171113_112929_538609_88E0A296)
In-Reply-To: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasily Ulyanov <vulyanov@quantenna.com>

This allows a running AP to blacklist STAs by their MAC addresses
respecting the configured policy (either accept or deny unless listed).
It can be setup on .start_ap or with .set_mac_acl commands.

Signed-off-by: Vasily Ulyanov <vulyanov@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  | 19 +++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 62 ++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |  2 +
 drivers/net/wireless/quantenna/qtnfmac/core.h      |  1 +
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 37 ++++++++++++-
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 18 +++++++
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |  2 +
 7 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 452def343ad3..89dc9cab647d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -778,6 +778,20 @@ static int qtnf_start_radar_detection(struct wiphy *wiphy,
 	return ret;
 }
 
+static int qtnf_set_mac_acl(struct wiphy *wiphy,
+			    struct net_device *dev,
+			    const struct cfg80211_acl_data *params)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	int ret;
+
+	ret = qtnf_cmd_set_mac_acl(vif, params);
+	if (ret)
+		pr_err("%s: failed to set mac ACL ret=%d\n", dev->name, ret);
+
+	return ret;
+}
+
 static struct cfg80211_ops qtn_cfg80211_ops = {
 	.add_virtual_intf	= qtnf_add_virtual_intf,
 	.change_virtual_intf	= qtnf_change_virtual_intf,
@@ -803,6 +817,7 @@ static struct cfg80211_ops qtn_cfg80211_ops = {
 	.get_channel		= qtnf_get_channel,
 	.channel_switch		= qtnf_channel_switch,
 	.start_radar_detection	= qtnf_start_radar_detection,
+	.set_mac_acl		= qtnf_set_mac_acl,
 };
 
 static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
@@ -918,6 +933,7 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	wiphy->max_scan_ie_len = QTNF_MAX_VSIE_LEN;
 	wiphy->mgmt_stypes = qtnf_mgmt_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
+	wiphy->max_acl_mac_addrs = mac->macinfo.max_acl_mac_addrs;
 
 	wiphy->iface_combinations = iface_comb;
 	wiphy->n_iface_combinations = 1;
@@ -932,6 +948,9 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 			WIPHY_FLAG_AP_UAPSD |
 			WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
+	if (wiphy->max_acl_mac_addrs > 0)
+		wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME;
+
 	wiphy->probe_resp_offload = NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2;
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 38b9c1078058..6ffe4837bbdb 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -162,6 +162,14 @@ static void qtnf_cmd_tlv_ie_set_add(struct sk_buff *cmd_skb, u8 frame_type,
 		memcpy(tlv->ie_data, buf, len);
 }
 
+static inline size_t qtnf_cmd_acl_data_size(const struct cfg80211_acl_data *acl)
+{
+	size_t size = sizeof(struct qlink_acl_data) +
+		      acl->n_acl_entries * sizeof(struct qlink_mac_address);
+
+	return size;
+}
+
 static bool qtnf_cmd_start_ap_can_fit(const struct qtnf_vif *vif,
 				      const struct cfg80211_ap_settings *s)
 {
@@ -178,6 +186,9 @@ static bool qtnf_cmd_start_ap_can_fit(const struct qtnf_vif *vif,
 	if (cfg80211_chandef_valid(&s->chandef))
 		len += sizeof(struct qlink_tlv_chandef);
 
+	if (s->acl)
+		len += qtnf_cmd_acl_data_size(s->acl);
+
 	if (len > (sizeof(struct qlink_cmd) + QTNF_MAX_CMD_BUF_SIZE)) {
 		pr_err("VIF%u.%u: can not fit AP settings: %u\n",
 		       vif->mac->macid, vif->vifid, len);
@@ -283,6 +294,16 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif,
 		memcpy(tlv->val, s->vht_cap, sizeof(*s->vht_cap));
 	}
 
+	if (s->acl) {
+		size_t acl_size = qtnf_cmd_acl_data_size(s->acl);
+		struct qlink_tlv_hdr *tlv =
+			skb_put(cmd_skb, sizeof(*tlv) + acl_size);
+
+		tlv->type = cpu_to_le16(QTN_TLV_ID_ACL_DATA);
+		tlv->len = cpu_to_le16(acl_size);
+		qlink_acl_data_cfg2q(s->acl, (struct qlink_acl_data *)tlv->val);
+	}
+
 	qtnf_bus_lock(vif->mac->bus);
 
 	ret = qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
@@ -1206,6 +1227,7 @@ qtnf_cmd_resp_proc_mac_info(struct qtnf_wmac *mac,
 	mac_info->radar_detect_widths =
 			qlink_chan_width_mask_to_nl(le16_to_cpu(
 					resp_info->radar_detect_widths));
+	mac_info->max_acl_mac_addrs = le32_to_cpu(resp_info->max_acl_mac_addrs);
 
 	memcpy(&mac_info->ht_cap_mod_mask, &resp_info->ht_cap_mod_mask,
 	       sizeof(mac_info->ht_cap_mod_mask));
@@ -2609,3 +2631,43 @@ int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
 
 	return ret;
 }
+
+int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
+			 const struct cfg80211_acl_data *params)
+{
+	struct qtnf_bus *bus = vif->mac->bus;
+	struct sk_buff *cmd_skb;
+	struct qlink_cmd_set_mac_acl *cmd;
+	u16 res_code;
+	int ret;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_SET_MAC_ACL,
+					    sizeof(*cmd) +
+					    qtnf_cmd_acl_data_size(params));
+	if (unlikely(!cmd_skb))
+		return -ENOMEM;
+
+	cmd = (struct qlink_cmd_set_mac_acl *)cmd_skb->data;
+	qlink_acl_data_cfg2q(params, &cmd->acl);
+
+	qtnf_bus_lock(bus);
+	ret = qtnf_cmd_send(bus, cmd_skb, &res_code);
+	qtnf_bus_unlock(bus);
+
+	if (unlikely(ret))
+		return ret;
+
+	switch (res_code) {
+	case QLINK_CMD_RESULT_OK:
+		break;
+	case QLINK_CMD_RESULT_INVALID:
+		ret = -EINVAL;
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
index 07a957af9a58..69a7d56f7e58 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -79,5 +79,7 @@ int qtnf_cmd_get_channel(struct qtnf_vif *vif, struct cfg80211_chan_def *chdef);
 int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
 		       const struct cfg80211_chan_def *chdef,
 		       u32 cac_time_ms);
+int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
+			 const struct cfg80211_acl_data *params);
 
 #endif /* QLINK_COMMANDS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index e7bd21ed371b..c10900162297 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -103,6 +103,7 @@ struct qtnf_mac_info {
 	u8 sretry_limit;
 	u8 coverage_class;
 	u8 radar_detect_widths;
+	u32 max_acl_mac_addrs;
 	struct ieee80211_ht_cap ht_cap_mod_mask;
 	struct ieee80211_vht_cap vht_cap_mod_mask;
 	struct ieee80211_iface_limit *limits;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 5d98000b0f5b..6a1f960228a1 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -19,7 +19,7 @@
 
 #include <linux/ieee80211.h>
 
-#define QLINK_PROTO_VER		9
+#define QLINK_PROTO_VER		10
 
 #define QLINK_MACID_RSVD		0xFF
 #define QLINK_VIFID_RSVD		0xFF
@@ -239,6 +239,7 @@ enum qlink_cmd_type {
 	QLINK_CMD_START_CAC		= 0x001D,
 	QLINK_CMD_START_AP		= 0x0021,
 	QLINK_CMD_STOP_AP		= 0x0022,
+	QLINK_CMD_SET_MAC_ACL		= 0x0023,
 	QLINK_CMD_GET_STA_INFO		= 0x0030,
 	QLINK_CMD_ADD_KEY		= 0x0040,
 	QLINK_CMD_DEL_KEY		= 0x0041,
@@ -640,6 +641,38 @@ struct qlink_cmd_start_cac {
 	__le32 cac_time_ms;
 } __packed;
 
+enum qlink_acl_policy {
+	QLINK_ACL_POLICY_ACCEPT_UNLESS_LISTED,
+	QLINK_ACL_POLICY_DENY_UNLESS_LISTED,
+};
+
+struct qlink_mac_address {
+	u8 addr[ETH_ALEN];
+} __packed;
+
+/**
+ * struct qlink_acl_data - ACL data
+ *
+ * @policy: filter policy, one of &enum qlink_acl_policy.
+ * @num_entries: number of MAC addresses in array.
+ * @mac_address: MAC addresses array.
+ */
+struct qlink_acl_data {
+	__le32 policy;
+	__le32 num_entries;
+	struct qlink_mac_address mac_addrs[0];
+} __packed;
+
+/**
+ * struct qlink_cmd_set_mac_acl - data for QLINK_CMD_SET_MAC_ACL command
+ *
+ * @acl: ACL data.
+ */
+struct qlink_cmd_set_mac_acl {
+	struct qlink_cmd chdr;
+	struct qlink_acl_data acl;
+} __packed;
+
 /* QLINK Command Responses messages related definitions
  */
 
@@ -701,6 +734,7 @@ struct qlink_resp_get_mac_info {
 	struct ieee80211_ht_cap ht_cap_mod_mask;
 	__le16 max_ap_assoc_sta;
 	__le16 radar_detect_widths;
+	__le32 max_acl_mac_addrs;
 	u8 bands_cap;
 	u8 rsvd[1];
 	u8 var_info[0];
@@ -1049,6 +1083,7 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_SEQ			= 0x0303,
 	QTN_TLV_ID_IE_SET		= 0x0305,
 	QTN_TLV_ID_EXT_CAPABILITY_MASK	= 0x0306,
+	QTN_TLV_ID_ACL_DATA		= 0x0307,
 };
 
 struct qlink_tlv_hdr {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
index 19981d6440b6..aeeda81b09ea 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.c
@@ -176,3 +176,21 @@ bool qtnf_utils_is_bit_set(const u8 *arr, unsigned int bit,
 
 	return arr[idx] & mask;
 }
+
+void qlink_acl_data_cfg2q(const struct cfg80211_acl_data *acl,
+			  struct qlink_acl_data *qacl)
+{
+	switch (acl->acl_policy) {
+	case NL80211_ACL_POLICY_ACCEPT_UNLESS_LISTED:
+		qacl->policy =
+			cpu_to_le32(QLINK_ACL_POLICY_ACCEPT_UNLESS_LISTED);
+		break;
+	case NL80211_ACL_POLICY_DENY_UNLESS_LISTED:
+		qacl->policy = cpu_to_le32(QLINK_ACL_POLICY_DENY_UNLESS_LISTED);
+		break;
+	}
+
+	qacl->num_entries = cpu_to_le32(acl->n_acl_entries);
+	memcpy(qacl->mac_addrs, acl->mac_addrs,
+	       acl->n_acl_entries * sizeof(*qacl->mac_addrs));
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
index 6c24561eb41f..54caeb38917c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink_util.h
@@ -71,5 +71,7 @@ void qlink_chandef_cfg2q(const struct cfg80211_chan_def *chdef,
 enum qlink_hidden_ssid qlink_hidden_ssid_nl2q(enum nl80211_hidden_ssid nl_val);
 bool qtnf_utils_is_bit_set(const u8 *arr, unsigned int bit,
 			   unsigned int arr_max_len);
+void qlink_acl_data_cfg2q(const struct cfg80211_acl_data *acl,
+			  struct qlink_acl_data *qacl);
 
 #endif /* _QTN_FMAC_QLINK_UTIL_H_ */
-- 
2.11.0
