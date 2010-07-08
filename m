Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:48129 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab0GHGoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 02:44:18 -0400
Subject: [PATCH] Added support for host sleep feature
From: Amitkumar Karwar <akarwar@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
Content-Type: text/plain
Date: Thu, 08 Jul 2010 06:43:48 +0530
Message-Id: <1278551628.3339.7.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Existing "ethtool -s ethX wol X" command configures hostsleep
parameters, but those are activated only during suspend/resume,
there is no way to configure host sleep without actual suspend.

This patch adds debugfs command to enable/disable host sleep based on
already configured host sleep parameters using wol command.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/libertas/README    |   12 ++++++
 drivers/net/wireless/libertas/cmd.c     |   61 ++++++++++++++++++++++++++++-
 drivers/net/wireless/libertas/cmd.h     |    2 +
 drivers/net/wireless/libertas/debugfs.c |   66 +++++++++++++++++++++++++++++++
 drivers/net/wireless/libertas/main.c    |   34 +---------------
 5 files changed, 142 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/libertas/README b/drivers/net/wireless/libertas/README
index 2726c04..60fd1af 100644
--- a/drivers/net/wireless/libertas/README
+++ b/drivers/net/wireless/libertas/README
@@ -226,6 +226,18 @@ setuserscan
     All entries in the scan table (not just the new scan data when keep=1)
     will be displayed upon completion by use of the getscantable ioctl.
 
+hostsleep
+	This command is used to enable/disable host sleep.
+	Note: Host sleep parameters should be configured using
+	"ethtool -s ethX wol X" command before enabling host sleep.
+
+	Path: /sys/kernel/debug/libertas_wireless/ethX/
+
+	Usage:
+		cat hostsleep: reads the current hostsleep state
+		echo "1" > hostsleep : enable host sleep.
+		echo "0" > hostsleep : disable host sleep
+
 ========================
 IWCONFIG COMMANDS
 ========================
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 6c8a9d9..749fbde 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -181,7 +181,7 @@ static int lbs_ret_host_sleep_cfg(struct lbs_private *priv, unsigned long dummy,
 			struct cmd_header *resp)
 {
 	lbs_deb_enter(LBS_DEB_CMD);
-	if (priv->wol_criteria == EHS_REMOVE_WAKEUP) {
+	if (priv->is_host_sleep_activated) {
 		priv->is_host_sleep_configured = 0;
 		if (priv->psstate == PS_STATE_FULL_POWER) {
 			priv->is_host_sleep_activated = 0;
@@ -361,6 +361,65 @@ int lbs_set_deep_sleep(struct lbs_private *priv, int deep_sleep)
 	return ret;
 }
 
+static int lbs_ret_host_sleep_activate(struct lbs_private *priv,
+		unsigned long dummy,
+		struct cmd_header *cmd)
+{
+	lbs_deb_enter(LBS_DEB_FW);
+	priv->is_host_sleep_activated = 1;
+	wake_up_interruptible(&priv->host_sleep_q);
+	lbs_deb_leave(LBS_DEB_FW);
+	return 0;
+}
+
+int lbs_set_host_sleep(struct lbs_private *priv, int host_sleep)
+{
+	struct cmd_header cmd;
+	int ret = 0;
+	uint32_t criteria = EHS_REMOVE_WAKEUP;
+
+	lbs_deb_enter(LBS_DEB_CMD);
+
+	if (host_sleep) {
+		if (priv->is_host_sleep_activated != 1) {
+			memset(&cmd, 0, sizeof(cmd));
+			ret = lbs_host_sleep_cfg(priv, priv->wol_criteria,
+					(struct wol_config *)NULL);
+			if (ret) {
+				lbs_pr_info("Host sleep configuration failed: "
+						"%d\n", ret);
+				return ret;
+			}
+			if (priv->psstate == PS_STATE_FULL_POWER) {
+				ret = __lbs_cmd(priv,
+						CMD_802_11_HOST_SLEEP_ACTIVATE,
+						&cmd,
+						sizeof(cmd),
+						lbs_ret_host_sleep_activate, 0);
+				if (ret)
+					lbs_pr_info("HOST_SLEEP_ACTIVATE "
+							"failed: %d\n", ret);
+			}
+
+			if (!wait_event_interruptible_timeout(
+						priv->host_sleep_q,
+						priv->is_host_sleep_activated,
+						(10 * HZ))) {
+				lbs_pr_err("host_sleep_q: timer expired\n");
+				ret = -1;
+			}
+		} else {
+			lbs_pr_err("host sleep: already enabled\n");
+		}
+	} else {
+		if (priv->is_host_sleep_activated)
+			ret = lbs_host_sleep_cfg(priv, criteria,
+					(struct wol_config *)NULL);
+	}
+
+	return ret;
+}
+
 /**
  *  @brief Set an SNMP MIB value
  *
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index cb4138a..386e565 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -127,4 +127,6 @@ int lbs_set_tx_power(struct lbs_private *priv, s16 dbm);
 
 int lbs_set_deep_sleep(struct lbs_private *priv, int deep_sleep);
 
+int lbs_set_host_sleep(struct lbs_private *priv, int host_sleep);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 1736746..acaf811 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -124,6 +124,70 @@ out_unlock:
 	return ret;
 }
 
+static ssize_t lbs_host_sleep_write(struct file *file,
+				const char __user *user_buf, size_t count,
+				loff_t *ppos)
+{
+	struct lbs_private *priv = file->private_data;
+	ssize_t buf_size, ret;
+	int host_sleep;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *)addr;
+	if (!buf)
+		return -ENOMEM;
+
+	buf_size = min(count, len - 1);
+	if (copy_from_user(buf, user_buf, buf_size)) {
+		ret = -EFAULT;
+		goto out_unlock;
+	}
+	ret = sscanf(buf, "%d", &host_sleep);
+	if (ret != 1) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (host_sleep == 0)
+		ret = lbs_set_host_sleep(priv, 0);
+	else if (host_sleep == 1) {
+		if (priv->wol_criteria == EHS_REMOVE_WAKEUP) {
+			lbs_pr_info("wake parameters not configured");
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+		ret = lbs_set_host_sleep(priv, 1);
+	} else {
+		lbs_pr_err("invalid option\n");
+		ret = -EINVAL;
+	}
+
+	if (!ret)
+		ret = count;
+
+out_unlock:
+	free_page(addr);
+	return ret;
+}
+
+static ssize_t lbs_host_sleep_read(struct file *file, char __user *userbuf,
+				  size_t count, loff_t *ppos)
+{
+	struct lbs_private *priv = file->private_data;
+	ssize_t ret;
+	size_t pos = 0;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *)addr;
+	if (!buf)
+		return -ENOMEM;
+
+	pos += snprintf(buf, len, "%d\n", priv->is_host_sleep_activated);
+
+	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+
+	free_page(addr);
+	return ret;
+}
+
 /*
  * When calling CMD_802_11_SUBSCRIBE_EVENT with CMD_ACT_GET, me might
  * get a bunch of vendor-specific TLVs (a.k.a. IEs) back from the
@@ -675,6 +739,8 @@ static const struct lbs_debugfs_files debugfs_files[] = {
 	{ "info", 0444, FOPS(lbs_dev_info, write_file_dummy), },
 	{ "sleepparams", 0644, FOPS(lbs_sleepparams_read,
 				lbs_sleepparams_write), },
+	{ "hostsleep", 0644, FOPS(lbs_host_sleep_read,
+				lbs_host_sleep_write), },
 };
 
 static const struct lbs_debugfs_files debugfs_events_files[] = {
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index b519fc7..2a0b590 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -544,20 +544,8 @@ static int lbs_thread(void *data)
 	return 0;
 }
 
-static int lbs_ret_host_sleep_activate(struct lbs_private *priv,
-		unsigned long dummy,
-		struct cmd_header *cmd)
-{
-	lbs_deb_enter(LBS_DEB_FW);
-	priv->is_host_sleep_activated = 1;
-	wake_up_interruptible(&priv->host_sleep_q);
-	lbs_deb_leave(LBS_DEB_FW);
-	return 0;
-}
-
 int lbs_suspend(struct lbs_private *priv)
 {
-	struct cmd_header cmd;
 	int ret;
 
 	lbs_deb_enter(LBS_DEB_FW);
@@ -571,25 +559,8 @@ int lbs_suspend(struct lbs_private *priv)
 		priv->deep_sleep_required = 1;
 	}
 
-	memset(&cmd, 0, sizeof(cmd));
-	ret = lbs_host_sleep_cfg(priv, priv->wol_criteria,
-						(struct wol_config *)NULL);
-	if (ret) {
-		lbs_pr_info("Host sleep configuration failed: %d\n", ret);
-		return ret;
-	}
-	if (priv->psstate == PS_STATE_FULL_POWER) {
-		ret = __lbs_cmd(priv, CMD_802_11_HOST_SLEEP_ACTIVATE, &cmd,
-				sizeof(cmd), lbs_ret_host_sleep_activate, 0);
-		if (ret)
-			lbs_pr_info("HOST_SLEEP_ACTIVATE failed: %d\n", ret);
-	}
+	ret = lbs_set_host_sleep(priv, 1);
 
-	if (!wait_event_interruptible_timeout(priv->host_sleep_q,
-				priv->is_host_sleep_activated, (10 * HZ))) {
-		lbs_pr_err("host_sleep_q: timer expired\n");
-		ret = -1;
-	}
 	netif_device_detach(priv->dev);
 	if (priv->mesh_dev)
 		netif_device_detach(priv->mesh_dev);
@@ -602,11 +573,10 @@ EXPORT_SYMBOL_GPL(lbs_suspend);
 int lbs_resume(struct lbs_private *priv)
 {
 	int ret;
-	uint32_t criteria = EHS_REMOVE_WAKEUP;
 
 	lbs_deb_enter(LBS_DEB_FW);
 
-	ret = lbs_host_sleep_cfg(priv, criteria, (struct wol_config *)NULL);
+	ret = lbs_set_host_sleep(priv, 0);
 
 	netif_device_attach(priv->dev);
 	if (priv->mesh_dev)
-- 
1.5.3.4



