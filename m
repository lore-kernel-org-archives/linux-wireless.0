Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr680082.outbound.protection.outlook.com ([40.107.68.82]:18793
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726739AbeHBMbf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 08:31:35 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2] qtnfmac: implement basic WoWLAN support
Date: Thu,  2 Aug 2018 13:40:43 +0300
Message-Id: <20180802104043.32068-1-sergey.matyukevich.os@quantenna.com> (sfid-20180802_124105_011513_BAACFDCB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements basic WoWLAN support in qtnfmac driver, including
processing of WoWLAN features reported by firmware and implementation
of cfg80211 suspend/resume/wakeup callbacks. Currently the following
WoWLAN triggers are supported: disconnect, magic packet,
custom pattern packet.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---

Hello Kalle and all,

The first four patches from the original patch set has been accepted.
So the changes for v2 are as follows:
- drop patch with vendor speicific commands for PTA
  -- to be clarified and resend separately
- rebase WoWLAN patch on top of wireless-drivers-next

Regards,
Sergey

 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  76 +++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 112 ++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.h |   2 +
 drivers/net/wireless/quantenna/qtnfmac/core.c     |   1 +
 drivers/net/wireless/quantenna/qtnfmac/core.h     |   1 +
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  56 +++++++++++
 6 files changed, 248 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 0032fa9fdddd..4aa332f4646b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -859,6 +859,72 @@ static int qtnf_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+#ifdef CONFIG_PM
+static int qtnf_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wowlan)
+{
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
+	struct qtnf_vif *vif;
+	int ret = 0;
+
+	vif = qtnf_mac_get_base_vif(mac);
+	if (!vif) {
+		pr_err("MAC%u: primary VIF is not configured\n", mac->macid);
+		ret = -EFAULT;
+		goto exit;
+	}
+
+	if (!wowlan) {
+		pr_debug("WoWLAN triggers are not enabled\n");
+		qtnf_virtual_intf_cleanup(vif->netdev);
+		goto exit;
+	}
+
+	qtnf_scan_done(vif->mac, true);
+
+	ret = qtnf_cmd_send_wowlan_set(vif, wowlan);
+	if (ret) {
+		pr_err("MAC%u: failed to set WoWLAN triggers\n",
+		       mac->macid);
+		goto exit;
+	}
+
+exit:
+	return ret;
+}
+
+static int qtnf_resume(struct wiphy *wiphy)
+{
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
+	struct qtnf_vif *vif;
+	int ret = 0;
+
+	vif = qtnf_mac_get_base_vif(mac);
+	if (!vif) {
+		pr_err("MAC%u: primary VIF is not configured\n", mac->macid);
+		ret = -EFAULT;
+		goto exit;
+	}
+
+	ret = qtnf_cmd_send_wowlan_set(vif, NULL);
+	if (ret) {
+		pr_err("MAC%u: failed to reset WoWLAN triggers\n",
+		       mac->macid);
+		goto exit;
+	}
+
+exit:
+	return ret;
+}
+
+static void qtnf_set_wakeup(struct wiphy *wiphy, bool enabled)
+{
+	struct qtnf_wmac *mac = wiphy_priv(wiphy);
+	struct qtnf_bus *bus = mac->bus;
+
+	device_set_wakeup_enable(bus->dev, enabled);
+}
+#endif
+
 static struct cfg80211_ops qtn_cfg80211_ops = {
 	.add_virtual_intf	= qtnf_add_virtual_intf,
 	.change_virtual_intf	= qtnf_change_virtual_intf,
@@ -886,6 +952,11 @@ static struct cfg80211_ops qtn_cfg80211_ops = {
 	.start_radar_detection	= qtnf_start_radar_detection,
 	.set_mac_acl		= qtnf_set_mac_acl,
 	.set_power_mgmt		= qtnf_set_power_mgmt,
+#ifdef CONFIG_PM
+	.suspend		= qtnf_suspend,
+	.resume			= qtnf_resume,
+	.set_wakeup		= qtnf_set_wakeup,
+#endif
 };
 
 static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
@@ -1038,6 +1109,11 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR)
 		wiphy->features |= NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
 
+#ifdef CONFIG_PM
+	if (macinfo->wowlan)
+		wiphy->wowlan = macinfo->wowlan;
+#endif
+
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_REG_UPDATE) {
 		wiphy->regulatory_flags |= REGULATORY_STRICT_REG |
 			REGULATORY_CUSTOM_REG;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 7942261961d6..ae9e77300533 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1138,6 +1138,37 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 	return 0;
 }
 
+static void
+qtnf_parse_wowlan_info(struct qtnf_wmac *mac,
+		       const struct qlink_wowlan_capab_data *wowlan)
+{
+	struct qtnf_mac_info *mac_info = &mac->macinfo;
+	const struct qlink_wowlan_support *data1;
+	struct wiphy_wowlan_support *supp;
+
+	supp = kzalloc(sizeof(*supp), GFP_KERNEL);
+	if (!supp)
+		return;
+
+	switch (le16_to_cpu(wowlan->version)) {
+	case 0x1:
+		data1 = (struct qlink_wowlan_support *)wowlan->data;
+
+		supp->flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT;
+		supp->n_patterns = le32_to_cpu(data1->n_patterns);
+		supp->pattern_max_len = le32_to_cpu(data1->pattern_max_len);
+		supp->pattern_min_len = le32_to_cpu(data1->pattern_min_len);
+
+		mac_info->wowlan = supp;
+		break;
+	default:
+		pr_warn("MAC%u: unsupported WoWLAN version 0x%x\n",
+			mac->macid, le16_to_cpu(wowlan->version));
+		kfree(supp);
+		break;
+	}
+}
+
 static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 					const u8 *tlv_buf, size_t tlv_buf_size)
 {
@@ -1147,6 +1178,7 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 	const struct qlink_iface_comb_num *comb_num;
 	const struct qlink_iface_limit_record *rec;
 	const struct qlink_iface_limit *lim;
+	const struct qlink_wowlan_capab_data *wowlan;
 	u16 rec_len;
 	u16 tlv_type;
 	u16 tlv_value_len;
@@ -1255,7 +1287,31 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 			ext_capa_mask = (u8 *)tlv->val;
 			ext_capa_mask_len = tlv_value_len;
 			break;
+		case QTN_TLV_ID_WOWLAN_CAPAB:
+			if (tlv_value_len < sizeof(*wowlan))
+				return -EINVAL;
+
+			wowlan = (void *)tlv->val;
+			if (!le16_to_cpu(wowlan->len)) {
+				pr_warn("MAC%u: skip empty WoWLAN data\n",
+					mac->macid);
+				break;
+			}
+
+			rec_len = sizeof(*wowlan) + le16_to_cpu(wowlan->len);
+			if (unlikely(tlv_value_len != rec_len)) {
+				pr_warn("MAC%u: WoWLAN data size mismatch\n",
+					mac->macid);
+				return -EINVAL;
+			}
+
+			kfree(mac->macinfo.wowlan);
+			mac->macinfo.wowlan = NULL;
+			qtnf_parse_wowlan_info(mac, wowlan);
+			break;
 		default:
+			pr_warn("MAC%u: unknown TLV type %u\n",
+				mac->macid, tlv_type);
 			break;
 		}
 
@@ -2831,3 +2887,59 @@ int qtnf_cmd_send_pm_set(const struct qtnf_vif *vif, u8 pm_mode, int timeout)
 	qtnf_bus_unlock(bus);
 	return ret;
 }
+
+int qtnf_cmd_send_wowlan_set(const struct qtnf_vif *vif,
+			     const struct cfg80211_wowlan *wowl)
+{
+	struct qtnf_bus *bus = vif->mac->bus;
+	struct sk_buff *cmd_skb;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	struct qlink_cmd_wowlan_set *cmd;
+	u32 triggers = 0;
+	int count = 0;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_WOWLAN_SET, sizeof(*cmd));
+	if (!cmd_skb)
+		return -ENOMEM;
+
+	qtnf_bus_lock(bus);
+
+	cmd = (struct qlink_cmd_wowlan_set *)cmd_skb->data;
+
+	if (wowl) {
+		if (wowl->disconnect)
+			triggers |=  QLINK_WOWLAN_TRIG_DISCONNECT;
+
+		if (wowl->magic_pkt)
+			triggers |= QLINK_WOWLAN_TRIG_MAGIC_PKT;
+
+		if (wowl->n_patterns && wowl->patterns) {
+			triggers |= QLINK_WOWLAN_TRIG_PATTERN_PKT;
+			while (count < wowl->n_patterns) {
+				qtnf_cmd_skb_put_tlv_arr(cmd_skb,
+					QTN_TLV_ID_WOWLAN_PATTERN,
+					wowl->patterns[count].pattern,
+					wowl->patterns[count].pattern_len);
+				count++;
+			}
+		}
+	}
+
+	cmd->triggers = cpu_to_le32(triggers);
+
+	ret = qtnf_cmd_send(bus, cmd_skb, &res_code);
+
+	if (unlikely(ret))
+		goto out;
+
+	if (unlikely(res_code != QLINK_CMD_RESULT_OK)) {
+		pr_err("cmd exec failed: 0x%.4X\n", res_code);
+		ret = -EFAULT;
+	}
+
+out:
+	qtnf_bus_unlock(bus);
+	return ret;
+}
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/net/wireless/quantenna/qtnfmac/commands.h
index 03a57e37a665..1ac41156c192 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -77,5 +77,7 @@ int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
 int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
 			 const struct cfg80211_acl_data *params);
 int qtnf_cmd_send_pm_set(const struct qtnf_vif *vif, u8 pm_mode, int timeout);
+int qtnf_cmd_send_wowlan_set(const struct qtnf_vif *vif,
+			     const struct cfg80211_wowlan *wowl);
 
 #endif /* QLINK_COMMANDS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index c318340e1bd5..19abbc4e23e0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -495,6 +495,7 @@ static void qtnf_core_mac_detach(struct qtnf_bus *bus, unsigned int macid)
 	qtnf_mac_iface_comb_free(mac);
 	kfree(mac->macinfo.extended_capabilities);
 	kfree(mac->macinfo.extended_capabilities_mask);
+	kfree(mac->macinfo.wowlan);
 	wiphy_free(wiphy);
 	bus->mac[macid] = NULL;
 }
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index c4808f1ba8b0..a1e338a1f055 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -110,6 +110,7 @@ struct qtnf_mac_info {
 	u8 *extended_capabilities;
 	u8 *extended_capabilities_mask;
 	u8 extended_capabilities_len;
+	struct wiphy_wowlan_support *wowlan;
 };
 
 struct qtnf_chan_stats {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 8fbef67fbbb8..99d37e3efba6 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -258,6 +258,7 @@ enum qlink_cmd_type {
 	QLINK_CMD_CONNECT		= 0x0060,
 	QLINK_CMD_DISCONNECT		= 0x0061,
 	QLINK_CMD_PM_SET		= 0x0062,
+	QLINK_CMD_WOWLAN_SET		= 0x0063,
 };
 
 /**
@@ -694,6 +695,30 @@ struct qlink_cmd_pm_set {
 	u8 pm_mode;
 } __packed;
 
+/**
+ * enum qlink_wowlan_trigger
+ *
+ * @QLINK_WOWLAN_TRIG_DISCONNECT: wakeup on disconnect
+ * @QLINK_WOWLAN_TRIG_MAGIC_PKT: wakeup on magic packet
+ * @QLINK_WOWLAN_TRIG_PATTERN_PKT: wakeup on user-defined packet
+ */
+enum qlink_wowlan_trigger {
+	QLINK_WOWLAN_TRIG_DISCONNECT	= BIT(0),
+	QLINK_WOWLAN_TRIG_MAGIC_PKT	= BIT(1),
+	QLINK_WOWLAN_TRIG_PATTERN_PKT	= BIT(2),
+};
+
+/**
+ * struct qlink_cmd_wowlan_set - data for QLINK_CMD_WOWLAN_SET command
+ *
+ * @triggers: requested bitmask of WoWLAN triggers
+ */
+struct qlink_cmd_wowlan_set {
+	struct qlink_cmd chdr;
+	__le32 triggers;
+	u8 data[0];
+} __packed;
+
 /* QLINK Command Responses messages related definitions
  */
 
@@ -1122,6 +1147,8 @@ enum qlink_tlv_id {
 	QTN_TLV_ID_UBOOT_VER		= 0x0407,
 	QTN_TLV_ID_RANDOM_MAC_ADDR	= 0x0408,
 	QTN_TLV_ID_MAX_SCAN_SSIDS	= 0x0409,
+	QTN_TLV_ID_WOWLAN_CAPAB		= 0x0410,
+	QTN_TLV_ID_WOWLAN_PATTERN	= 0x0411,
 };
 
 struct qlink_tlv_hdr {
@@ -1409,4 +1436,33 @@ struct qlink_random_mac_addr {
 	u8 mac_addr_mask[ETH_ALEN];
 } __packed;
 
+/**
+ * struct qlink_wowlan_capab_data - data for QTN_TLV_ID_WOWLAN_CAPAB TLV
+ *
+ * WoWLAN capabilities supported by cards.
+ *
+ * @version: version of WoWLAN data structure, to ensure backward
+ *	compatibility for firmwares with limited WoWLAN support
+ * @len: Total length of WoWLAN data
+ * @data: supported WoWLAN features
+ */
+struct qlink_wowlan_capab_data {
+	__le16 version;
+	__le16 len;
+	u8 data[0];
+} __packed;
+
+/**
+ * struct qlink_wowlan_support - supported WoWLAN capabilities
+ *
+ * @n_patterns: number of supported wakeup patterns
+ * @pattern_max_len: maximum length of each pattern
+ * @pattern_min_len: minimum length of each pattern
+ */
+struct qlink_wowlan_support {
+	__le32 n_patterns;
+	__le32 pattern_max_len;
+	__le32 pattern_min_len;
+} __packed;
+
 #endif /* _QTN_QLINK_H_ */
-- 
2.11.0
