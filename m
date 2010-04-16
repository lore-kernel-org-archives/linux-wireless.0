Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932589Ab0DPVwn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/21] iwlwifi: remove duplicated debug functions
Date: Fri, 16 Apr 2010 14:52:27 -0700
Message-Id: <1271454758-14351-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Use the show uCode statistics function for uCode debugging purposes only; it
is being duplicated in both debugfs and sysfs. remove the one from sysfs.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   39 ---------------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   39 ---------------------------
 2 files changed, 0 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e788722..8ac1546 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3177,44 +3177,6 @@ static ssize_t store_tx_power(struct device *d,
 
 static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO, show_tx_power, store_tx_power);
 
-static ssize_t show_statistics(struct device *d,
-			       struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	u32 size = sizeof(struct iwl_notif_statistics);
-	u32 len = 0, ofs = 0;
-	u8 *data = (u8 *)&priv->statistics;
-	int rc = 0;
-
-	if (!iwl_is_alive(priv))
-		return -EAGAIN;
-
-	mutex_lock(&priv->mutex);
-	rc = iwl_send_statistics_request(priv, CMD_SYNC, false);
-	mutex_unlock(&priv->mutex);
-
-	if (rc) {
-		len = sprintf(buf,
-			      "Error sending statistics request: 0x%08X\n", rc);
-		return len;
-	}
-
-	while (size && (PAGE_SIZE - len)) {
-		hex_dump_to_buffer(data + ofs, size, 16, 1, buf + len,
-				   PAGE_SIZE - len, 1);
-		len = strlen(buf);
-		if (PAGE_SIZE - len)
-			buf[len++] = '\n';
-
-		ofs += 16;
-		size -= min(size, 16U);
-	}
-
-	return len;
-}
-
-static DEVICE_ATTR(statistics, S_IRUGO, show_statistics, NULL);
-
 static ssize_t show_rts_ht_protection(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
@@ -3404,7 +3366,6 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 }
 
 static struct attribute *iwl_sysfs_entries[] = {
-	&dev_attr_statistics.attr,
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
 	&dev_attr_rts_ht_protection.attr,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 06004d0..8da3375 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3657,44 +3657,6 @@ static ssize_t show_channels(struct device *d,
 
 static DEVICE_ATTR(channels, S_IRUSR, show_channels, NULL);
 
-static ssize_t show_statistics(struct device *d,
-			       struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	u32 size = sizeof(struct iwl3945_notif_statistics);
-	u32 len = 0, ofs = 0;
-	u8 *data = (u8 *)&priv->_3945.statistics;
-	int rc = 0;
-
-	if (!iwl_is_alive(priv))
-		return -EAGAIN;
-
-	mutex_lock(&priv->mutex);
-	rc = iwl_send_statistics_request(priv, CMD_SYNC, false);
-	mutex_unlock(&priv->mutex);
-
-	if (rc) {
-		len = sprintf(buf,
-			      "Error sending statistics request: 0x%08X\n", rc);
-		return len;
-	}
-
-	while (size && (PAGE_SIZE - len)) {
-		hex_dump_to_buffer(data + ofs, size, 16, 1, buf + len,
-				   PAGE_SIZE - len, 1);
-		len = strlen(buf);
-		if (PAGE_SIZE - len)
-			buf[len++] = '\n';
-
-		ofs += 16;
-		size -= min(size, 16U);
-	}
-
-	return len;
-}
-
-static DEVICE_ATTR(statistics, S_IRUGO, show_statistics, NULL);
-
 static ssize_t show_antenna(struct device *d,
 			    struct device_attribute *attr, char *buf)
 {
@@ -3814,7 +3776,6 @@ static struct attribute *iwl3945_sysfs_entries[] = {
 	&dev_attr_filter_flags.attr,
 	&dev_attr_measurement.attr,
 	&dev_attr_retry_rate.attr,
-	&dev_attr_statistics.attr,
 	&dev_attr_status.attr,
 	&dev_attr_temperature.attr,
 	&dev_attr_tx_power.attr,
-- 
1.6.3.3

