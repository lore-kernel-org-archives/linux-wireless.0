Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:65133 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab0BSGDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 01:03:12 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/6] iwlwifi: enable serialization of synchronous commands
Date: Thu, 18 Feb 2010 22:03:04 -0800
Message-Id: <1266559387-19637-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
References: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Until now it was only possible to have one synchronous command running at
any time. If a synchronous command is in progress when a second request
arrives then the second command will fail. Create a new mutex specific for
this purpose to only allow one synchronous command at a time, but enable
other commands to wait instead of fail if a synchronous command is in
progress.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 --
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 ++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 7 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4157c6c..52b6beb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3364,6 +3364,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	INIT_LIST_HEAD(&priv->free_frames);
 
 	mutex_init(&priv->mutex);
+	mutex_init(&priv->sync_cmd_mutex);
 
 	/* Clear the driver's (not device's) station table */
 	iwl_clear_stations_table(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 530fae8..6347d4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -603,7 +603,7 @@ void iwlcore_free_geos(struct iwl_priv *priv);
 /*************** DRIVER STATUS FUNCTIONS   *****/
 
 #define STATUS_HCMD_ACTIVE	0	/* host command in progress */
-#define STATUS_HCMD_SYNC_ACTIVE	1	/* sync host command in progress */
+/* 1 is unused (used to be STATUS_HCMD_SYNC_ACTIVE) */
 #define STATUS_INT_ENABLED	2
 #define STATUS_RF_KILL_HW	3
 #define STATUS_CT_KILL		4
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 78298be..7241fda 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -530,8 +530,6 @@ static ssize_t iwl_dbgfs_status_read(struct file *file,
 
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_HCMD_ACTIVE:\t %d\n",
 		test_bit(STATUS_HCMD_ACTIVE, &priv->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_HCMD_SYNC_ACTIVE: %d\n",
-		test_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_INT_ENABLED:\t %d\n",
 		test_bit(STATUS_INT_ENABLED, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_RF_KILL_HW:\t %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f81317d..021c686 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1111,6 +1111,7 @@ struct iwl_priv {
 	spinlock_t hcmd_lock;	/* protect hcmd */
 	spinlock_t reg_lock;	/* protect hw register access */
 	struct mutex mutex;
+	struct mutex sync_cmd_mutex; /* enable serialization of sync commands */
 
 	/* basic pci-network driver stuff */
 	struct pci_dev *pci_dev;
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 86783c2..73681c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -164,15 +164,13 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	 /* A synchronous command can not have a callback set. */
 	BUG_ON(cmd->callback);
 
-	if (test_and_set_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status)) {
-		IWL_ERR(priv,
-			"Error sending %s: Already sending a host command\n",
+	IWL_DEBUG_INFO(priv, "Attempting to send sync command %s\n",
 			get_cmd_string(cmd->id));
-		ret = -EBUSY;
-		goto out;
-	}
+	mutex_lock(&priv->sync_cmd_mutex);
 
 	set_bit(STATUS_HCMD_ACTIVE, &priv->status);
+	IWL_DEBUG_INFO(priv, "Setting HCMD_ACTIVE for command %s \n",
+			get_cmd_string(cmd->id));
 
 	cmd_idx = iwl_enqueue_hcmd(priv, cmd);
 	if (cmd_idx < 0) {
@@ -193,6 +191,8 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
 			clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
+			IWL_DEBUG_INFO(priv, "Clearing HCMD_ACTIVE for command %s \n",
+				       get_cmd_string(cmd->id));
 			ret = -ETIMEDOUT;
 			goto cancel;
 		}
@@ -237,7 +237,7 @@ fail:
 		cmd->reply_page = 0;
 	}
 out:
-	clear_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status);
+	mutex_unlock(&priv->sync_cmd_mutex);
 	return ret;
 }
 EXPORT_SYMBOL(iwl_send_cmd_sync);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index d8c11f9..38655ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1238,6 +1238,8 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 
 	if (!(meta->flags & CMD_ASYNC)) {
 		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
+		IWL_DEBUG_INFO(priv, "Clearing HCMD_ACTIVE for command %s \n",
+			       get_cmd_string(cmd->hdr.cmd));
 		wake_up_interruptible(&priv->wait_command_queue);
 	}
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0e5a1ca..54daa38 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3847,6 +3847,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	INIT_LIST_HEAD(&priv->free_frames);
 
 	mutex_init(&priv->mutex);
+	mutex_init(&priv->sync_cmd_mutex);
 
 	/* Clear the driver's (not device's) station table */
 	iwl_clear_stations_table(priv);
-- 
1.6.3.3

