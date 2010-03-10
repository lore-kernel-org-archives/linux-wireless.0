Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1472 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab0CJFWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 17/24] iwlwifi: remove un-necessary parameters
Date: Tue,  9 Mar 2010 21:21:45 -0800
Message-Id: <1268198512-6572-18-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

small code cleanup to remove un-necessary parameters

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   28 +++++++---------------------
 1 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 50d0ee9..d9255b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -658,7 +658,6 @@ static ssize_t iwl_dbgfs_qos_read(struct file *file, char __user *user_buf,
 	int pos = 0, i;
 	char buf[256];
 	const size_t bufsz = sizeof(buf);
-	ssize_t ret;
 
 	for (i = 0; i < AC_NUM; i++) {
 		pos += scnprintf(buf + pos, bufsz - pos,
@@ -670,8 +669,7 @@ static ssize_t iwl_dbgfs_qos_read(struct file *file, char __user *user_buf,
 				priv->qos_data.def_qos_parm.ac[i].aifsn,
 				priv->qos_data.def_qos_parm.ac[i].edca_txop);
 	}
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	return ret;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
 static ssize_t iwl_dbgfs_led_read(struct file *file, char __user *user_buf,
@@ -681,7 +679,6 @@ static ssize_t iwl_dbgfs_led_read(struct file *file, char __user *user_buf,
 	int pos = 0;
 	char buf[256];
 	const size_t bufsz = sizeof(buf);
-	ssize_t ret;
 
 	pos += scnprintf(buf + pos, bufsz - pos,
 			 "allow blinking: %s\n",
@@ -695,8 +692,7 @@ static ssize_t iwl_dbgfs_led_read(struct file *file, char __user *user_buf,
 				 priv->last_blink_time);
 	}
 
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	return ret;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
 static ssize_t iwl_dbgfs_thermal_throttling_read(struct file *file,
@@ -709,7 +705,6 @@ static ssize_t iwl_dbgfs_thermal_throttling_read(struct file *file,
 	char buf[100];
 	int pos = 0;
 	const size_t bufsz = sizeof(buf);
-	ssize_t ret;
 
 	pos += scnprintf(buf + pos, bufsz - pos,
 			"Thermal Throttling Mode: %s\n",
@@ -729,8 +724,7 @@ static ssize_t iwl_dbgfs_thermal_throttling_read(struct file *file,
 				"HT mode: %d\n",
 				restriction->is_ht);
 	}
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	return ret;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
 static ssize_t iwl_dbgfs_disable_ht40_write(struct file *file,
@@ -767,13 +761,11 @@ static ssize_t iwl_dbgfs_disable_ht40_read(struct file *file,
 	char buf[100];
 	int pos = 0;
 	const size_t bufsz = sizeof(buf);
-	ssize_t ret;
 
 	pos += scnprintf(buf + pos, bufsz - pos,
 			"11n 40MHz Mode: %s\n",
 			priv->disable_ht40 ? "Disabled" : "Enabled");
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	return ret;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
 static ssize_t iwl_dbgfs_sleep_level_override_write(struct file *file,
@@ -2049,7 +2041,6 @@ static ssize_t iwl_dbgfs_ucode_tracing_read(struct file *file,
 	int pos = 0;
 	char buf[128];
 	const size_t bufsz = sizeof(buf);
-	ssize_t ret;
 
 	pos += scnprintf(buf + pos, bufsz - pos, "ucode trace timer is %s\n",
 			priv->event_log.ucode_trace ? "On" : "Off");
@@ -2060,8 +2051,7 @@ static ssize_t iwl_dbgfs_ucode_tracing_read(struct file *file,
 	pos += scnprintf(buf + pos, bufsz - pos, "wraps_more_count:\t\t %u\n",
 			priv->event_log.wraps_more_count);
 
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	return ret;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
 static ssize_t iwl_dbgfs_ucode_tracing_write(struct file *file,
@@ -2147,13 +2137,11 @@ static ssize_t iwl_dbgfs_missed_beacon_read(struct file *file,
 	int pos = 0;
 	char buf[12];
 	const size_t bufsz = sizeof(buf);
-	ssize_t ret;
 
 	pos += scnprintf(buf + pos, bufsz - pos, "%d\n",
 			priv->missed_beacon_threshold);
 
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	return ret;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
 static ssize_t iwl_dbgfs_missed_beacon_write(struct file *file,
@@ -2211,13 +2199,11 @@ static ssize_t iwl_dbgfs_plcp_delta_read(struct file *file,
 	int pos = 0;
 	char buf[12];
 	const size_t bufsz = sizeof(buf);
-	ssize_t ret;
 
 	pos += scnprintf(buf + pos, bufsz - pos, "%u\n",
 			priv->cfg->plcp_delta_threshold);
 
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	return ret;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
 static ssize_t iwl_dbgfs_plcp_delta_write(struct file *file,
-- 
1.6.3.3

