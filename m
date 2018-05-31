Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0082.outbound.protection.outlook.com ([104.47.34.82]:40832
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754093AbeEaJLV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 05:11:21 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: [PATCH 3/6] qtnfmac: implement cfg80211 power management callback
Date: Thu, 31 May 2018 12:10:59 +0300
Message-Id: <20180531091102.28666-4-sergey.matyukevich.os@quantenna.com> (sfid-20180531_111132_397735_A8D74716)
In-Reply-To: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sergei Maksimenko <smaksimenko@quantenna.com>

Implement set_power_mgmt() callback that forwards power saving
settings to the device firmware.

Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 21 ++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 34 +++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.h |  1 +
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 26 +++++++++++++++++
 4 files changed, 82 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 23366be9e394..15bc26c9933f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -844,6 +844,22 @@ static int qtnf_set_mac_acl(struct wiphy *wiphy,
 	return ret;
 }
 
+static int qtnf_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
+			       bool enabled, int timeout)
+{
+	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
+	int ret;
+
+	ret = qtnf_cmd_send_pm_set(vif, enabled ? QLINK_PM_AUTO_STANDBY :
+				   QLINK_PM_OFF, timeout);
+	if (ret) {
+		pr_err("%s: failed to set PM mode ret=%d\n", dev->name, ret);
+		return ret;
+	}
+
+	return ret;
+}
+
 static struct cfg80211_ops qtn_cfg80211_ops = {
 	.add_virtual_intf	= qtnf_add_virtual_intf,
 	.change_virtual_intf	= qtnf_change_virtual_intf,
@@ -870,6 +886,7 @@ static struct cfg80211_ops qtn_cfg80211_ops = {
 	.channel_switch		= qtnf_channel_switch,
 	.start_radar_detection	= qtnf_start_radar_detection,
 	.set_mac_acl		= qtnf_set_mac_acl,
+	.set_power_mgmt		= qtnf_set_power_mgmt,
 };
 
 static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
@@ -922,6 +939,9 @@ struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus)
 	if (bus->hw_info.hw_capab & QLINK_HW_CAPAB_DFS_OFFLOAD)
 		qtn_cfg80211_ops.start_radar_detection = NULL;
 
+	if (!(bus->hw_info.hw_capab & QLINK_HW_CAPAB_PWR_MGMT))
+		qtn_cfg80211_ops.set_power_mgmt	= NULL;
+
 	wiphy = wiphy_new(&qtn_cfg80211_ops, sizeof(struct qtnf_wmac));
 	if (!wiphy)
 		return NULL;
@@ -995,6 +1015,7 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
 			WIPHY_FLAG_AP_UAPSD |
 			WIPHY_FLAG_HAS_CHANNEL_SWITCH;
+	wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	if (hw_info->hw_capab & QLINK_HW_CAPAB_DFS_OFFLOAD)
 		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_DFS_OFFLOAD);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 710806466bd9..a96d58f72c07 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2799,3 +2799,37 @@ int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
 
 	return ret;
 }
+
+int qtnf_cmd_send_pm_set(const struct qtnf_vif *vif, u8 pm_mode, int timeout)
+{
+	struct qtnf_bus *bus = vif->mac->bus;
+	struct sk_buff *cmd_skb;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	struct qlink_cmd_pm_set *cmd;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
+					    QLINK_CMD_PM_SET, sizeof(*cmd));
+	if (!cmd_skb)
+		return -ENOMEM;
+
+	cmd = (struct qlink_cmd_pm_set *)cmd_skb->data;
+	cmd->pm_mode = pm_mode;
+	cmd->pm_standby_timer = cpu_to_le32(timeout);
+
+	qtnf_bus_lock(bus);
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
index cf9274add26d..03a57e37a665 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -76,5 +76,6 @@ int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
 		       u32 cac_time_ms);
 int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
 			 const struct cfg80211_acl_data *params);
+int qtnf_cmd_send_pm_set(const struct qtnf_vif *vif, u8 pm_mode, int timeout);
 
 #endif /* QLINK_COMMANDS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 4a32967d0479..cbdebf0410df 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -77,6 +77,7 @@ enum qlink_hw_capab {
 	QLINK_HW_CAPAB_STA_INACT_TIMEOUT	= BIT(1),
 	QLINK_HW_CAPAB_DFS_OFFLOAD		= BIT(2),
 	QLINK_HW_CAPAB_SCAN_RANDOM_MAC_ADDR	= BIT(3),
+	QLINK_HW_CAPAB_PWR_MGMT			= BIT(4),
 };
 
 enum qlink_iface_type {
@@ -256,6 +257,7 @@ enum qlink_cmd_type {
 	QLINK_CMD_CHAN_STATS		= 0x0054,
 	QLINK_CMD_CONNECT		= 0x0060,
 	QLINK_CMD_DISCONNECT		= 0x0061,
+	QLINK_CMD_PM_SET		= 0x0062,
 };
 
 /**
@@ -668,6 +670,30 @@ struct qlink_acl_data {
 	struct qlink_mac_address mac_addrs[0];
 } __packed;
 
+/**
+ * enum qlink_pm_mode - Power Management mode
+ *
+ * @QLINK_PM_OFF: normal mode, no power saving enabled
+ * @QLINK_PM_AUTO_STANDBY: enable auto power save mode
+ */
+enum qlink_pm_mode {
+	QLINK_PM_OFF		= 0,
+	QLINK_PM_AUTO_STANDBY	= 1,
+};
+
+/**
+ * struct qlink_cmd_pm_set - data for QLINK_CMD_PM_SET command
+ *
+ * @pm_standby timer: period of network inactivity in seconds before
+ *	putting a radio in power save mode
+ * @pm_mode: power management mode
+ */
+struct qlink_cmd_pm_set {
+	struct qlink_cmd chdr;
+	__le32 pm_standby_timer;
+	u8 pm_mode;
+} __packed;
+
 /* QLINK Command Responses messages related definitions
  */
 
-- 
2.11.0
