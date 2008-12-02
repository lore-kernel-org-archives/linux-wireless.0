Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbYLBUNO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:13:14 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/11] iwlwifi: move channels sysfs to debugfs
Date: Tue,  2 Dec 2008 12:14:01 -0800
Message-Id: <1228248847-10424-6-git-send-email-reinette.chatre@intel.com> (sfid-20081202_211324_256278_DB37A750)
In-Reply-To: <1228248847-10424-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-3-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-4-git-send-email-reinette.chatre@intel.com>
 <1228248847-10424-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch moves channels info display from sysfs to debugfs.
This shows channel information as stored in NIC EEPROM. This
is useful in debugging CRDA or iwl goes setting so it belongs
rather to debugfs then to sysfs.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   63 -----------------------
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   76 ++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9e1d57f..4bdd33b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3591,68 +3591,6 @@ static ssize_t show_power_level(struct device *d,
 static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR, show_power_level,
 		   store_power_level);
 
-static ssize_t show_channels(struct device *d,
-			     struct device_attribute *attr, char *buf)
-{
-
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	struct ieee80211_channel *channels = NULL;
-	const struct ieee80211_supported_band *supp_band = NULL;
-	int len = 0, i;
-	int count = 0;
-
-	if (!test_bit(STATUS_GEO_CONFIGURED, &priv->status))
-		return -EAGAIN;
-
-	supp_band = iwl_get_hw_mode(priv, IEEE80211_BAND_2GHZ);
-	channels = supp_band->channels;
-	count = supp_band->n_channels;
-
-	len += sprintf(&buf[len],
-			"Displaying %d channels in 2.4GHz band "
-			"(802.11bg):\n", count);
-
-	for (i = 0; i < count; i++)
-		len += sprintf(&buf[len], "%d: %ddBm: BSS%s%s, %s.\n",
-				ieee80211_frequency_to_channel(
-				channels[i].center_freq),
-				channels[i].max_power,
-				channels[i].flags & IEEE80211_CHAN_RADAR ?
-				" (IEEE 802.11h required)" : "",
-				(!(channels[i].flags & IEEE80211_CHAN_NO_IBSS)
-				|| (channels[i].flags &
-				IEEE80211_CHAN_RADAR)) ? "" :
-				", IBSS",
-				channels[i].flags &
-				IEEE80211_CHAN_PASSIVE_SCAN ?
-				"passive only" : "active/passive");
-
-	supp_band = iwl_get_hw_mode(priv, IEEE80211_BAND_5GHZ);
-	channels = supp_band->channels;
-	count = supp_band->n_channels;
-
-	len += sprintf(&buf[len], "Displaying %d channels in 5.2GHz band "
-			"(802.11a):\n", count);
-
-	for (i = 0; i < count; i++)
-		len += sprintf(&buf[len], "%d: %ddBm: BSS%s%s, %s.\n",
-				ieee80211_frequency_to_channel(
-				channels[i].center_freq),
-				channels[i].max_power,
-				channels[i].flags & IEEE80211_CHAN_RADAR ?
-				" (IEEE 802.11h required)" : "",
-				((channels[i].flags & IEEE80211_CHAN_NO_IBSS)
-				|| (channels[i].flags &
-				IEEE80211_CHAN_RADAR)) ? "" :
-				", IBSS",
-				channels[i].flags &
-				IEEE80211_CHAN_PASSIVE_SCAN ?
-				"passive only" : "active/passive");
-
-	return len;
-}
-
-static DEVICE_ATTR(channels, S_IRUSR, show_channels, NULL);
 
 static ssize_t show_statistics(struct device *d,
 			       struct device_attribute *attr, char *buf)
@@ -3752,7 +3690,6 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 }
 
 static struct attribute *iwl_sysfs_entries[] = {
-	&dev_attr_channels.attr,
 	&dev_attr_flags.attr,
 	&dev_attr_filter_flags.attr,
 	&dev_attr_power_level.attr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 0e79a6a..a115dc6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -60,6 +60,7 @@ struct iwl_debugfs {
 		struct dentry *file_rx_statistics;
 		struct dentry *file_tx_statistics;
 		struct dentry *file_log_event;
+		struct dentry *file_channels;
 	} dbgfs_data_files;
 	struct dir_rf_files {
 		struct dentry *file_disable_sensitivity;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 5346ed5..84053d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -350,12 +350,86 @@ static ssize_t iwl_dbgfs_log_event_write(struct file *file,
 	return count;
 }
 
+
+
+static ssize_t iwl_dbgfs_channels_read(struct file *file, char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	struct ieee80211_channel *channels = NULL;
+	const struct ieee80211_supported_band *supp_band = NULL;
+	int pos = 0, i, bufsz = PAGE_SIZE;
+	char *buf;
+	ssize_t ret;
+
+	if (!test_bit(STATUS_GEO_CONFIGURED, &priv->status))
+		return -EAGAIN;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERROR("Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	supp_band = iwl_get_hw_mode(priv, IEEE80211_BAND_2GHZ);
+	channels = supp_band->channels;
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"Displaying %d channels in 2.4GHz band 802.11bg):\n",
+			 supp_band->n_channels);
+
+	for (i = 0; i < supp_band->n_channels; i++)
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"%d: %ddBm: BSS%s%s, %s.\n",
+				ieee80211_frequency_to_channel(
+				channels[i].center_freq),
+				channels[i].max_power,
+				channels[i].flags & IEEE80211_CHAN_RADAR ?
+				" (IEEE 802.11h required)" : "",
+				(!(channels[i].flags & IEEE80211_CHAN_NO_IBSS)
+				|| (channels[i].flags &
+				IEEE80211_CHAN_RADAR)) ? "" :
+				", IBSS",
+				channels[i].flags &
+				IEEE80211_CHAN_PASSIVE_SCAN ?
+				"passive only" : "active/passive");
+
+	supp_band = iwl_get_hw_mode(priv, IEEE80211_BAND_5GHZ);
+	channels = supp_band->channels;
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"Displaying %d channels in 5.2GHz band (802.11a)\n",
+			supp_band->n_channels);
+
+	for (i = 0; i < supp_band->n_channels; i++)
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"%d: %ddBm: BSS%s%s, %s.\n",
+				ieee80211_frequency_to_channel(
+				channels[i].center_freq),
+				channels[i].max_power,
+				channels[i].flags & IEEE80211_CHAN_RADAR ?
+				" (IEEE 802.11h required)" : "",
+				((channels[i].flags & IEEE80211_CHAN_NO_IBSS)
+				|| (channels[i].flags &
+				IEEE80211_CHAN_RADAR)) ? "" :
+				", IBSS",
+				channels[i].flags &
+				IEEE80211_CHAN_PASSIVE_SCAN ?
+				"passive only" : "active/passive");
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
 DEBUGFS_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(eeprom);
 DEBUGFS_READ_FILE_OPS(stations);
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
+DEBUGFS_READ_FILE_OPS(channels);
 
 /*
  * Create the debugfs files and directories
@@ -389,6 +463,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(stations, data);
 	DEBUGFS_ADD_FILE(rx_statistics, data);
 	DEBUGFS_ADD_FILE(tx_statistics, data);
+	DEBUGFS_ADD_FILE(channels, data);
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
@@ -417,6 +492,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_sram);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_log_event);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_stations);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_channels);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
-- 
1.5.4.3

