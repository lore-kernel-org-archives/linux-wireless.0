Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:60950 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758391Ab0LNARL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 19:17:11 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/14] iwlwifi: keep track of bt coex enable/disable stage
Date: Mon, 13 Dec 2010 16:09:31 -0800
Message-Id: <1292285372-11373-14-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For debugging purpose, keep track of the bt coex enable/disable state.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |    3 +++
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h         |    1 +
 5 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index a358d43..a6dbd89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -856,6 +856,9 @@ ssize_t iwl_ucode_bt_stats_read(struct file *file,
 	if (!iwl_is_alive(priv))
 		return -EAGAIN;
 
+	if (!priv->bt_enable_flag)
+		return -EINVAL;
+
 	/* make request to uCode to retrieve statistics information */
 	mutex_lock(&priv->mutex);
 	ret = iwl_send_statistics_request(priv, CMD_SYNC, false);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 7c8010f..4bc82fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1845,6 +1845,7 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 			bt_cmd.flags |= IWLAGN_BT_FLAG_CHANNEL_INHIBITION;
 		IWL_DEBUG_INFO(priv, "BT coex flag: 0X%x\n", bt_cmd.flags);
 	}
+	priv->bt_enable_flag = bt_cmd.flags;
 	if (priv->bt_full_concurrent)
 		memcpy(bt_cmd.bt3_lookup_table, iwlagn_concurrent_lookup,
 			sizeof(iwlagn_concurrent_lookup));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 06cdc60..efbde1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1223,6 +1223,7 @@ void iwl_send_bt_config(struct iwl_priv *priv)
 	else
 		bt_cmd.flags = BT_COEX_ENABLE;
 
+	priv->bt_enable_flag = bt_cmd.flags;
 	IWL_DEBUG_INFO(priv, "BT coex %s\n",
 		(bt_cmd.flags == BT_COEX_DISABLE) ? "disable" : "active");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index d368363..6fe80b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1567,6 +1567,13 @@ static ssize_t iwl_dbgfs_bt_traffic_read(struct file *file,
 	const size_t bufsz = sizeof(buf);
 	ssize_t ret;
 
+	if (!priv->bt_enable_flag) {
+		pos += scnprintf(buf + pos, bufsz - pos, "BT coex disabled\n");
+		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+		return ret;
+	}
+	pos += scnprintf(buf + pos, bufsz - pos, "BT enable flag: 0x%x\n",
+		priv->bt_enable_flag);
 	pos += scnprintf(buf + pos, bufsz - pos, "BT in %s mode\n",
 		priv->bt_full_concurrent ? "full concurrency" : "3-wire");
 	pos += scnprintf(buf + pos, bufsz - pos, "BT status: %s, "
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 836f181..8dda678 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1468,6 +1468,7 @@ struct iwl_priv {
 	};
 
 	/* bt coex */
+	u8 bt_enable_flag;
 	u8 bt_status;
 	u8 bt_traffic_load, last_bt_traffic_load;
 	bool bt_ch_announce;
-- 
1.7.0.4

