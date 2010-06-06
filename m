Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1226 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab0FFG4U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/4] iwlwifi: move sysfs_create_group to post request firmware
Date: Sat,  5 Jun 2010 23:56:03 -0700
Message-Id: <1275807363-18150-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807363-18150-1-git-send-email-reinette.chatre@intel.com>
References: <1275807363-18150-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Move the sysfs_create_group to iwl_ucode_callback after we
have safely got the firmware.

The motivation to do this comes from a warning from lockdep which detected
that we request priv->mutex while holding s_active during a sysfs request
(show_statistics in the example copy pasted). The reverse order exists upon
request_firmware: request_firmware which is a sysfs operation
that requires s_active is run under priv->mutex.

This ensures that we don't get sysfs request before we finish to request
the firmware, avoiding this deadlock.

=======================================================
[ INFO: possible circular locking dependency detected ]
-------------------------------------------------------
cat/2595 is trying to acquire lock:
 (&priv->mutex){+.+.+.}, at: [<facfa598>] show_statistics+0x48/0x100 [iwlagn]

but task is already holding lock:
 (s_active){++++.+}, at: [<c0580ebd>] sysfs_get_active_two+0x1d/0x50

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (s_active){++++.+}:
       [<c0489b74>] __lock_acquire+0xc44/0x1230
       [<c048a1ed>] lock_acquire+0x8d/0x110
       [<c0581499>] sysfs_addrm_finish+0xe9/0x180
       [<c057f64a>] sysfs_hash_and_remove+0x4a/0x80
       [<c05829d4>] sysfs_remove_group+0x44/0xd0
       [<c0714b75>] dpm_sysfs_remove+0x15/0x20
       [<c070dac8>] device_del+0x38/0x170
       [<c070dc1e>] device_unregister+0x1e/0x60
       [<c071838d>] _request_firmware+0x29d/0x550
       [<c07186c7>] request_firmware+0x17/0x20
       [<fad01bf1>] iwl_mac_start+0xb1/0x1230 [iwlagn]
       [<fa46ba06>] ieee80211_open+0x436/0x6f0 [mac80211]
       [<c0808cd2>] dev_open+0x92/0xf0
       [<c0808b2b>] dev_change_flags+0x7b/0x190
       [<c08148e8>] do_setlink+0x178/0x3b0
       [<c0815169>] rtnl_setlink+0xf9/0x130
       [<c081453b>] rtnetlink_rcv_msg+0x1bb/0x1f0
       [<c0827ce6>] netlink_rcv_skb+0x86/0xa0
       [<c081436c>] rtnetlink_rcv+0x1c/0x30
       [<c08279c3>] netlink_unicast+0x263/0x290
       [<c0828768>] netlink_sendmsg+0x1c8/0x2a0
       [<c07f85fd>] sock_sendmsg+0xcd/0x100
       [<c07f964d>] sys_sendmsg+0x15d/0x290
       [<c07f9e6b>] sys_socketcall+0xeb/0x2a0
       [<c040ad9f>] sysenter_do_call+0x12/0x38

-> #0 (&priv->mutex){+.+.+.}:
       [<c0489f84>] __lock_acquire+0x1054/0x1230
       [<c048a1ed>] lock_acquire+0x8d/0x110
       [<c08bb358>] __mutex_lock_common+0x58/0x470
       [<c08bb84a>] mutex_lock_nested+0x3a/0x50
       [<facfa598>] show_statistics+0x48/0x100 [iwlagn]
       [<c070d219>] dev_attr_show+0x29/0x50
       [<c057fecd>] sysfs_read_file+0xdd/0x190
       [<c052880f>] vfs_read+0x9f/0x190
       [<c0528d22>] sys_read+0x42/0x70
       [<c040ad9f>] sysenter_do_call+0x12/0x38

other info that might help us debug this:

3 locks held by cat/2595:
 #0:  (&buffer->mutex){+.+.+.}, at: [<c057fe25>] sysfs_read_file+0x35/0x190
 #1:  (s_active){++++.+}, at: [<c0580ecd>] sysfs_get_active_two+0x2d/0x50
 #2:  (s_active){++++.+}, at: [<c0580ebd>] sysfs_get_active_two+0x1d/0x50

stack backtrace:
Pid: 2595, comm: cat Not tainted 2.6.33-tp-rc4 #2
Call Trace:
 [<c08b99ab>] ? printk+0x1d/0x22
 [<c0487752>] print_circular_bug+0xc2/0xd0
 [<c0489f84>] __lock_acquire+0x1054/0x1230
 [<c0478d81>] ? sched_clock_cpu+0x121/0x180
 [<c048a1ed>] lock_acquire+0x8d/0x110
 [<facfa598>] ? show_statistics+0x48/0x100 [iwlagn]
 [<c08bb358>] __mutex_lock_common+0x58/0x470
 [<facfa598>] ? show_statistics+0x48/0x100 [iwlagn]
 [<c08bb84a>] mutex_lock_nested+0x3a/0x50
 [<facfa598>] ? show_statistics+0x48/0x100 [iwlagn]
 [<facfa598>] show_statistics+0x48/0x100 [iwlagn]
 [<c0580cf9>] ? sysfs_get_active+0x69/0xb0
 [<facfa550>] ? show_statistics+0x0/0x100 [iwlagn]
 [<c070d219>] dev_attr_show+0x29/0x50
 [<c057fecd>] sysfs_read_file+0xdd/0x190
 [<c05ff314>] ? security_file_permission+0x14/0x20
 [<c0528242>] ? rw_verify_area+0x62/0xd0
 [<c052880f>] vfs_read+0x9f/0x190
 [<c047745b>] ? up_read+0x1b/0x30
 [<c057fdf0>] ? sysfs_read_file+0x0/0x190
 [<c04af3b4>] ? audit_syscall_entry+0x1f4/0x220
 [<c0528d22>] sys_read+0x42/0x70
 [<c040ad9f>] sysenter_do_call+0x12/0x38

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |  318 ++++++++++++++++----------------
 1 files changed, 159 insertions(+), 159 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index aef4f71..7726e67 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1484,6 +1484,156 @@ bool iwl_good_ack_health(struct iwl_priv *priv,
 }
 
 
+/*****************************************************************************
+ *
+ * sysfs attributes
+ *
+ *****************************************************************************/
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+
+/*
+ * The following adds a new attribute to the sysfs representation
+ * of this device driver (i.e. a new file in /sys/class/net/wlan0/device/)
+ * used for controlling the debug level.
+ *
+ * See the level definitions in iwl for details.
+ *
+ * The debug_level being managed using sysfs below is a per device debug
+ * level that is used instead of the global debug level if it (the per
+ * device debug level) is set.
+ */
+static ssize_t show_debug_level(struct device *d,
+				struct device_attribute *attr, char *buf)
+{
+	struct iwl_priv *priv = dev_get_drvdata(d);
+	return sprintf(buf, "0x%08X\n", iwl_get_debug_level(priv));
+}
+static ssize_t store_debug_level(struct device *d,
+				struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct iwl_priv *priv = dev_get_drvdata(d);
+	unsigned long val;
+	int ret;
+
+	ret = strict_strtoul(buf, 0, &val);
+	if (ret)
+		IWL_ERR(priv, "%s is not in hex or decimal form.\n", buf);
+	else {
+		priv->debug_level = val;
+		if (iwl_alloc_traffic_mem(priv))
+			IWL_ERR(priv,
+				"Not enough memory to generate traffic log\n");
+	}
+	return strnlen(buf, count);
+}
+
+static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
+			show_debug_level, store_debug_level);
+
+
+#endif /* CONFIG_IWLWIFI_DEBUG */
+
+
+static ssize_t show_temperature(struct device *d,
+				struct device_attribute *attr, char *buf)
+{
+	struct iwl_priv *priv = dev_get_drvdata(d);
+
+	if (!iwl_is_alive(priv))
+		return -EAGAIN;
+
+	return sprintf(buf, "%d\n", priv->temperature);
+}
+
+static DEVICE_ATTR(temperature, S_IRUGO, show_temperature, NULL);
+
+static ssize_t show_tx_power(struct device *d,
+			     struct device_attribute *attr, char *buf)
+{
+	struct iwl_priv *priv = dev_get_drvdata(d);
+
+	if (!iwl_is_ready_rf(priv))
+		return sprintf(buf, "off\n");
+	else
+		return sprintf(buf, "%d\n", priv->tx_power_user_lmt);
+}
+
+static ssize_t store_tx_power(struct device *d,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct iwl_priv *priv = dev_get_drvdata(d);
+	unsigned long val;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret)
+		IWL_INFO(priv, "%s is not in decimal form.\n", buf);
+	else {
+		ret = iwl_set_tx_power(priv, val, false);
+		if (ret)
+			IWL_ERR(priv, "failed setting tx power (0x%d).\n",
+				ret);
+		else
+			ret = count;
+	}
+	return ret;
+}
+
+static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO, show_tx_power, store_tx_power);
+
+static ssize_t show_rts_ht_protection(struct device *d,
+			     struct device_attribute *attr, char *buf)
+{
+	struct iwl_priv *priv = dev_get_drvdata(d);
+
+	return sprintf(buf, "%s\n",
+		priv->cfg->use_rts_for_ht ? "RTS/CTS" : "CTS-to-self");
+}
+
+static ssize_t store_rts_ht_protection(struct device *d,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct iwl_priv *priv = dev_get_drvdata(d);
+	unsigned long val;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret)
+		IWL_INFO(priv, "Input is not in decimal form.\n");
+	else {
+		if (!iwl_is_associated(priv))
+			priv->cfg->use_rts_for_ht = val ? true : false;
+		else
+			IWL_ERR(priv, "Sta associated with AP - "
+				"Change protection mechanism is not allowed\n");
+		ret = count;
+	}
+	return ret;
+}
+
+static DEVICE_ATTR(rts_ht_protection, S_IWUSR | S_IRUGO,
+			show_rts_ht_protection, store_rts_ht_protection);
+
+
+static struct attribute *iwl_sysfs_entries[] = {
+	&dev_attr_temperature.attr,
+	&dev_attr_tx_power.attr,
+	&dev_attr_rts_ht_protection.attr,
+#ifdef CONFIG_IWLWIFI_DEBUG
+	&dev_attr_debug_level.attr,
+#endif
+	NULL
+};
+
+static struct attribute_group iwl_attribute_group = {
+	.name = NULL,		/* put in device directory */
+	.attrs = iwl_sysfs_entries,
+};
+
 /******************************************************************************
  *
  * uCode download functions
@@ -1965,6 +2115,13 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	if (err)
 		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
 
+	err = sysfs_create_group(&priv->pci_dev->dev.kobj,
+					&iwl_attribute_group);
+	if (err) {
+		IWL_ERR(priv, "failed to create sysfs device attributes\n");
+		goto out_unbind;
+	}
+
 	/* We have our copies now, allow OS release its copies */
 	release_firmware(ucode_raw);
 	complete(&priv->_agn.firmware_loading_complete);
@@ -3264,141 +3421,6 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 
 /*****************************************************************************
  *
- * sysfs attributes
- *
- *****************************************************************************/
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-
-/*
- * The following adds a new attribute to the sysfs representation
- * of this device driver (i.e. a new file in /sys/class/net/wlan0/device/)
- * used for controlling the debug level.
- *
- * See the level definitions in iwl for details.
- *
- * The debug_level being managed using sysfs below is a per device debug
- * level that is used instead of the global debug level if it (the per
- * device debug level) is set.
- */
-static ssize_t show_debug_level(struct device *d,
-				struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	return sprintf(buf, "0x%08X\n", iwl_get_debug_level(priv));
-}
-static ssize_t store_debug_level(struct device *d,
-				struct device_attribute *attr,
-				 const char *buf, size_t count)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	unsigned long val;
-	int ret;
-
-	ret = strict_strtoul(buf, 0, &val);
-	if (ret)
-		IWL_ERR(priv, "%s is not in hex or decimal form.\n", buf);
-	else {
-		priv->debug_level = val;
-		if (iwl_alloc_traffic_mem(priv))
-			IWL_ERR(priv,
-				"Not enough memory to generate traffic log\n");
-	}
-	return strnlen(buf, count);
-}
-
-static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
-			show_debug_level, store_debug_level);
-
-
-#endif /* CONFIG_IWLWIFI_DEBUG */
-
-
-static ssize_t show_temperature(struct device *d,
-				struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-
-	if (!iwl_is_alive(priv))
-		return -EAGAIN;
-
-	return sprintf(buf, "%d\n", priv->temperature);
-}
-
-static DEVICE_ATTR(temperature, S_IRUGO, show_temperature, NULL);
-
-static ssize_t show_tx_power(struct device *d,
-			     struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-
-	if (!iwl_is_ready_rf(priv))
-		return sprintf(buf, "off\n");
-	else
-		return sprintf(buf, "%d\n", priv->tx_power_user_lmt);
-}
-
-static ssize_t store_tx_power(struct device *d,
-			      struct device_attribute *attr,
-			      const char *buf, size_t count)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	unsigned long val;
-	int ret;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret)
-		IWL_INFO(priv, "%s is not in decimal form.\n", buf);
-	else {
-		ret = iwl_set_tx_power(priv, val, false);
-		if (ret)
-			IWL_ERR(priv, "failed setting tx power (0x%d).\n",
-				ret);
-		else
-			ret = count;
-	}
-	return ret;
-}
-
-static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO, show_tx_power, store_tx_power);
-
-static ssize_t show_rts_ht_protection(struct device *d,
-			     struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-
-	return sprintf(buf, "%s\n",
-		priv->cfg->use_rts_for_ht ? "RTS/CTS" : "CTS-to-self");
-}
-
-static ssize_t store_rts_ht_protection(struct device *d,
-			      struct device_attribute *attr,
-			      const char *buf, size_t count)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	unsigned long val;
-	int ret;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret)
-		IWL_INFO(priv, "Input is not in decimal form.\n");
-	else {
-		if (!iwl_is_associated(priv))
-			priv->cfg->use_rts_for_ht = val ? true : false;
-		else
-			IWL_ERR(priv, "Sta associated with AP - "
-				"Change protection mechanism is not allowed\n");
-		ret = count;
-	}
-	return ret;
-}
-
-static DEVICE_ATTR(rts_ht_protection, S_IWUSR | S_IRUGO,
-			show_rts_ht_protection, store_rts_ht_protection);
-
-
-/*****************************************************************************
- *
  * driver setup and teardown
  *
  *****************************************************************************/
@@ -3550,21 +3572,6 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 	kfree(priv->scan_cmd);
 }
 
-static struct attribute *iwl_sysfs_entries[] = {
-	&dev_attr_temperature.attr,
-	&dev_attr_tx_power.attr,
-	&dev_attr_rts_ht_protection.attr,
-#ifdef CONFIG_IWLWIFI_DEBUG
-	&dev_attr_debug_level.attr,
-#endif
-	NULL
-};
-
-static struct attribute_group iwl_attribute_group = {
-	.name = NULL,		/* put in device directory */
-	.attrs = iwl_sysfs_entries,
-};
-
 static struct ieee80211_ops iwl_hw_ops = {
 	.tx = iwl_mac_tx,
 	.start = iwl_mac_start,
@@ -3750,11 +3757,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		IWL_ERR(priv, "Error allocating IRQ %d\n", priv->pci_dev->irq);
 		goto out_disable_msi;
 	}
-	err = sysfs_create_group(&pdev->dev.kobj, &iwl_attribute_group);
-	if (err) {
-		IWL_ERR(priv, "failed to create sysfs device attributes\n");
-		goto out_free_irq;
-	}
 
 	iwl_setup_deferred_work(priv);
 	iwl_setup_rx_handlers(priv);
@@ -3788,15 +3790,13 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = iwl_request_firmware(priv, true);
 	if (err)
-		goto out_remove_sysfs;
+		goto out_destroy_workqueue;
 
 	return 0;
 
- out_remove_sysfs:
+ out_destroy_workqueue:
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
-	sysfs_remove_group(&pdev->dev.kobj, &iwl_attribute_group);
- out_free_irq:
 	free_irq(priv->pci_dev->irq, priv);
 	iwl_free_isr_ict(priv);
  out_disable_msi:
-- 
1.7.0.4

