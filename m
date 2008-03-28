Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbYC1XZe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:25:34 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Yi Zhu <yi.zhu@intel.com>
Subject: [PATCH 8/8] iwlwifi: Fix synchronous host command
Date: Fri, 28 Mar 2008 16:21:12 -0700
Message-Id: <1206746472-10443-9-git-send-email-reinette.chatre@intel.com> (sfid-20080328_232540_258278_312DA99F)
In-Reply-To: <1206746472-10443-8-git-send-email-reinette.chatre@intel.com>
References: <1206746472-10443-1-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-2-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-3-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-4-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-5-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-6-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-7-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch replaces static variable from send_cmd_sync
with flag in priv->status. It was used for reentrance protection
but clearly made it impossible to stuck more cards into the same machine

In addition it force check of return values of synchronous commands
commands that doesn't requires return value async commands have to be used

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Yi Zhu <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   35 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    8 +++---
 drivers/net/wireless/iwlwifi/iwl-4965.h     |   35 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    6 +++-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    8 +++---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 +++---
 6 files changed, 52 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index d7ccf13..ac12269 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -401,23 +401,24 @@ struct iwl3945_rx_queue {
 #define MIN_B_CHANNELS  1
 
 #define STATUS_HCMD_ACTIVE	0	/* host command in progress */
-#define STATUS_INT_ENABLED	1
-#define STATUS_RF_KILL_HW	2
-#define STATUS_RF_KILL_SW	3
-#define STATUS_INIT		4
-#define STATUS_ALIVE		5
-#define STATUS_READY		6
-#define STATUS_TEMPERATURE	7
-#define STATUS_GEO_CONFIGURED	8
-#define STATUS_EXIT_PENDING	9
-#define STATUS_IN_SUSPEND	10
-#define STATUS_STATISTICS	11
-#define STATUS_SCANNING		12
-#define STATUS_SCAN_ABORTING	13
-#define STATUS_SCAN_HW		14
-#define STATUS_POWER_PMI	15
-#define STATUS_FW_ERROR		16
-#define STATUS_CONF_PENDING	17
+#define STATUS_HCMD_SYNC_ACTIVE	1	/* sync host command in progress */
+#define STATUS_INT_ENABLED	2
+#define STATUS_RF_KILL_HW	3
+#define STATUS_RF_KILL_SW	4
+#define STATUS_INIT		5
+#define STATUS_ALIVE		6
+#define STATUS_READY		7
+#define STATUS_TEMPERATURE	8
+#define STATUS_GEO_CONFIGURED	9
+#define STATUS_EXIT_PENDING	10
+#define STATUS_IN_SUSPEND	11
+#define STATUS_STATISTICS	12
+#define STATUS_SCANNING		13
+#define STATUS_SCAN_ABORTING	14
+#define STATUS_SCAN_HW		15
+#define STATUS_POWER_PMI	16
+#define STATUS_FW_ERROR		17
+#define STATUS_CONF_PENDING	18
 
 #define MAX_TID_COUNT        9
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index add6311..51a1449 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1314,8 +1314,8 @@ void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 		cmd.diff_gain_a = 0;
 		cmd.diff_gain_b = 0;
 		cmd.diff_gain_c = 0;
-		iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
-				 sizeof(cmd), &cmd);
+		iwl_send_cmd_pdu_async(priv, REPLY_PHY_CALIBRATION_CMD,
+				 sizeof(cmd), &cmd, NULL);
 		msleep(4);
 		data->state = IWL_CHAIN_NOISE_ACCUMULATE;
 		IWL_DEBUG_CALIB("Run chain_noise_calibrate\n");
@@ -4563,8 +4563,8 @@ void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 	/* Update the rate scaling for control frame Tx to AP */
 	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_setting.bcast_sta_id;
 
-	iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD, sizeof(link_cmd),
-			 &link_cmd);
+	iwl_send_cmd_pdu_async(priv, REPLY_TX_LINK_QUALITY_CMD,
+			       sizeof(link_cmd), &link_cmd, NULL);
 }
 
 #ifdef CONFIG_IWL4965_HT
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index ca864fa..8c14e9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -415,23 +415,24 @@ struct iwl4965_rx_queue {
 #define MIN_B_CHANNELS  1
 
 #define STATUS_HCMD_ACTIVE	0	/* host command in progress */
-#define STATUS_INT_ENABLED	1
-#define STATUS_RF_KILL_HW	2
-#define STATUS_RF_KILL_SW	3
-#define STATUS_INIT		4
-#define STATUS_ALIVE		5
-#define STATUS_READY		6
-#define STATUS_TEMPERATURE	7
-#define STATUS_GEO_CONFIGURED	8
-#define STATUS_EXIT_PENDING	9
-#define STATUS_IN_SUSPEND	10
-#define STATUS_STATISTICS	11
-#define STATUS_SCANNING		12
-#define STATUS_SCAN_ABORTING	13
-#define STATUS_SCAN_HW		14
-#define STATUS_POWER_PMI	15
-#define STATUS_FW_ERROR		16
-#define STATUS_CONF_PENDING	17
+#define STATUS_HCMD_SYNC_ACTIVE	1	/* sync host command in progress */
+#define STATUS_INT_ENABLED	2
+#define STATUS_RF_KILL_HW	3
+#define STATUS_RF_KILL_SW	4
+#define STATUS_INIT		5
+#define STATUS_ALIVE		6
+#define STATUS_READY		7
+#define STATUS_TEMPERATURE	8
+#define STATUS_GEO_CONFIGURED	9
+#define STATUS_EXIT_PENDING	10
+#define STATUS_IN_SUSPEND	11
+#define STATUS_STATISTICS	12
+#define STATUS_SCANNING		13
+#define STATUS_SCAN_ABORTING	14
+#define STATUS_SCAN_HW		15
+#define STATUS_POWER_PMI	16
+#define STATUS_FW_ERROR		17
+#define STATUS_CONF_PENDING	18
 
 #define MAX_TID_COUNT        9
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 5efafe1..64f4df5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -138,9 +138,11 @@ int iwl_setup(struct iwl_priv *priv);
  *****************************************************/
 
 const char *get_cmd_string(u8 cmd);
-int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
+int __must_check iwl_send_cmd_sync(struct iwl_priv *priv,
+				   struct iwl_host_cmd *cmd);
 int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
-int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data);
+int __must_check iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id,
+				  u16 len, const void *data);
 int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
 			   const void *data,
 			   int (*callback)(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 51c9949..1f8c299 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -151,17 +151,17 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	int cmd_idx;
 	int ret;
-	static atomic_t entry = ATOMIC_INIT(0); /* reentrance protection */
 
 	BUG_ON(cmd->meta.flags & CMD_ASYNC);
 
 	 /* A synchronous command can not have a callback set. */
 	BUG_ON(cmd->meta.u.callback != NULL);
 
-	if (atomic_xchg(&entry, 1)) {
+	if (test_and_set_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status)) {
 		IWL_ERROR("Error sending %s: Already sending a host command\n",
 			  get_cmd_string(cmd->id));
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	set_bit(STATUS_HCMD_ACTIVE, &priv->status);
@@ -231,7 +231,7 @@ fail:
 		cmd->meta.u.skb = NULL;
 	}
 out:
-	atomic_set(&entry, 0);
+	clear_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status);
 	return ret;
 }
 EXPORT_SYMBOL(iwl_send_cmd_sync);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index af7233e..dc9ff50 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -733,17 +733,17 @@ static int iwl3945_send_cmd_sync(struct iwl3945_priv *priv, struct iwl3945_host_
 {
 	int cmd_idx;
 	int ret;
-	static atomic_t entry = ATOMIC_INIT(0); /* reentrance protection */
 
 	BUG_ON(cmd->meta.flags & CMD_ASYNC);
 
 	 /* A synchronous command can not have a callback set. */
 	BUG_ON(cmd->meta.u.callback != NULL);
 
-	if (atomic_xchg(&entry, 1)) {
+	if (test_and_set_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status)) {
 		IWL_ERROR("Error sending %s: Already sending a host command\n",
 			  get_cmd_string(cmd->id));
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	set_bit(STATUS_HCMD_ACTIVE, &priv->status);
@@ -813,7 +813,7 @@ fail:
 		cmd->meta.u.skb = NULL;
 	}
 out:
-	atomic_set(&entry, 0);
+	clear_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status);
 	return ret;
 }
 
-- 
1.5.3.4

