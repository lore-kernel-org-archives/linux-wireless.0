Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0069.outbound.protection.outlook.com ([104.47.36.69]:44244
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753202AbeBEPGH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Feb 2018 10:06:07 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: [PATCH 6/6] qtnfmac: enable networked standby mode on device inactivity
Date: Mon,  5 Feb 2018 18:05:16 +0300
Message-Id: <20180205150516.16030-7-sergey.matyukevich.os@quantenna.com> (sfid-20180205_160633_450597_8D1DF27D)
In-Reply-To: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
References: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sergei Maksimenko <smaksimenko@quantenna.com>

Enable support of networked standby mode (NSM) on qsr10g devices.
Networked standby is a power saving mode when the device keeps
all existing network connections and returns to full power mode
on a network activity. When enabled, device enters standby mode
after 15 min of inactivity (no associated stations or no trattic).
This period can be changed by setting sysfs attribute standby_timeout
(0 disables NSM support). A module parameter auto_standby
(defaults to 1) controls enabling NSM support on module loading.

Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h      |  1 +
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 33 ++++++++++
 drivers/net/wireless/quantenna/qtnfmac/commands.h |  1 +
 drivers/net/wireless/quantenna/qtnfmac/core.c     | 77 +++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  2 +
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 30 +++++++++
 6 files changed, 144 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wireless/quantenna/qtnfmac/bus.h
index 0a1604683bab..7a27ffc6c7a7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -65,6 +65,7 @@ struct qtnf_bus {
 	struct work_struct event_work;
 	struct mutex bus_lock; /* lock during command/event processing */
 	struct dentry *dbg_dir;
+	u32 standby_timeout;
 	/* bus private data */
 	char bus_priv[0] __aligned(sizeof(void *));
 };
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index deca0060eb27..1e730c9fa371 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2753,3 +2753,36 @@ int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
 
 	return ret;
 }
+
+int qtnf_cmd_send_pm_set(struct qtnf_bus *bus, u8 pm_mode, u32 timeout)
+{
+	struct sk_buff *cmd_skb;
+	u16 res_code = QLINK_CMD_RESULT_OK;
+	struct qlink_cmd_pm_set *cmd;
+	int ret = 0;
+
+	cmd_skb = qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
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
index 69a7d56f7e58..a06e6a96c35d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -81,5 +81,6 @@ int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
 		       u32 cac_time_ms);
 int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
 			 const struct cfg80211_acl_data *params);
+int qtnf_cmd_send_pm_set(struct qtnf_bus *bus, u8 pm_mode, u32 timeout);
 
 #endif /* QLINK_COMMANDS_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index cf26c15a84f8..10c4e3ea2404 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -26,6 +26,10 @@
 #include "event.h"
 #include "util.h"
 
+static bool auto_standby = true;
+module_param(auto_standby, bool, 0644);
+MODULE_PARM_DESC(auto_standby, "set to 0 to disable auto standby mode");
+
 #define QTNF_DMP_MAX_LEN 48
 #define QTNF_PRIMARY_VIF_IDX	0
 
@@ -552,6 +556,53 @@ static int qtnf_core_mac_attach(struct qtnf_bus *bus, unsigned int macid)
 	return ret;
 }
 
+static ssize_t qtnf_pm_standby_timeout_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct qtnf_bus *bus = dev_get_drvdata(dev);
+
+	sprintf(buf, "%u\n", bus->standby_timeout);
+	return strlen(buf);
+}
+
+static ssize_t qtnf_pm_standby_timeout_store(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t count)
+{
+	struct qtnf_bus *bus = dev_get_drvdata(dev);
+	int timeout;
+
+	if (count < 1)
+		goto out;
+
+	if (kstrtoint(buf, 0, &timeout))
+		goto out;
+
+	if (timeout < 0)
+		timeout = 0;
+	else if (timeout > S32_MAX)
+		timeout = S32_MAX;
+
+	if (timeout == bus->standby_timeout)
+		goto out;
+
+	if (timeout) {
+		if (!qtnf_cmd_send_pm_set(bus, QLINK_PM_AUTO_STANDBY,
+					  timeout))
+			bus->standby_timeout = timeout;
+	} else {
+		if (!qtnf_cmd_send_pm_set(bus, QLINK_PM_OFF, 0))
+			bus->standby_timeout = 0;
+	}
+
+out:
+	return (ssize_t)count;
+}
+
+static DEVICE_ATTR(standby_timeout, 0644, qtnf_pm_standby_timeout_show,
+		   qtnf_pm_standby_timeout_store);
+
 int qtnf_core_attach(struct qtnf_bus *bus)
 {
 	unsigned int i;
@@ -608,6 +659,25 @@ int qtnf_core_attach(struct qtnf_bus *bus)
 		}
 	}
 
+	if (auto_standby) {
+		bus->standby_timeout = QTNF_DEFAULT_STANDBY_TIMER;
+		ret = qtnf_cmd_send_pm_set(bus, QLINK_PM_AUTO_STANDBY,
+					   bus->standby_timeout);
+		if (ret)
+			bus->standby_timeout = 0;
+	} else {
+		bus->standby_timeout = 0;
+		ret = qtnf_cmd_send_pm_set(bus, QLINK_PM_OFF, 0);
+	}
+
+	if (ret) {
+		pr_err("failed to init PM auto standby: %d\n", ret);
+		/* Do not cancel init when PM mode not configured */
+	}
+
+	if (device_create_file(bus->dev, &dev_attr_standby_timeout))
+		pr_err("failed to init sysfs standby control file: %d\n", ret);
+
 	return 0;
 
 error:
@@ -620,6 +690,13 @@ EXPORT_SYMBOL_GPL(qtnf_core_attach);
 void qtnf_core_detach(struct qtnf_bus *bus)
 {
 	unsigned int macid;
+	int ret;
+
+	device_remove_file(bus->dev, &dev_attr_standby_timeout);
+
+	ret = qtnf_cmd_send_pm_set(bus, QLINK_PM_OFF, 0);
+	if (ret)
+		pr_err("failed to deinit NSM: %d\n", ret);
 
 	qtnf_bus_data_rx_stop(bus);
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 3b884c80b6ab..9386f09e1fab 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -52,6 +52,8 @@
 #define QTNF_DEF_WDOG_TIMEOUT		5
 #define QTNF_TX_TIMEOUT_TRSHLD		100
 
+#define QTNF_DEFAULT_STANDBY_TIMER	(15 * 60)
+
 extern const struct net_device_ops qtnf_netdev_ops;
 
 struct qtnf_bus;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 9bf3ae4d1b3b..ee3c65ca7148 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -251,6 +251,7 @@ enum qlink_cmd_type {
 	QLINK_CMD_CHAN_STATS		= 0x0054,
 	QLINK_CMD_CONNECT		= 0x0060,
 	QLINK_CMD_DISCONNECT		= 0x0061,
+	QLINK_CMD_PM_SET		= 0x0062,
 };
 
 /**
@@ -663,6 +664,35 @@ struct qlink_acl_data {
 	struct qlink_mac_address mac_addrs[0];
 } __packed;
 
+/**
+ * enum qlink_pm_mode - Power Management mode
+ *
+ * @QLINK_PM_OFF: normal mode, no power saving enabled
+ * @QLINK_PM_AUTO_STANDBY: Automatic Network Standby Mode - when there is no
+ *	traffic for the certain period, device enters power saving mode without
+ *	disconnecting peers. Device will wake up automatically on a new
+ *	association or data frames to TX/RX. Standby mode is activated on each
+ *	radio interface individually, based on traffic on it. When all the
+ *	radios enter standby mode, device informs RC via MSI.
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
+ *	putting a radio in standby mode
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
