Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37179 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYJNTek (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 15:34:40 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/3] iwlwifi: remove host commands structures from iwl_cmd
Date: Tue, 14 Oct 2008 12:32:43 -0700
Message-Id: <1224012769-8920-4-git-send-email-reinette.chatre@intel.com> (sfid-20081014_213445_018531_742D6C5B)
In-Reply-To: <1224012769-8920-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1224012769-8920-1-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-2-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes host commands structures from iwl_cmd
to make more HW oblivious
tx cmd was left it needs special treatment.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    9 +--------
 drivers/net/wireless/iwlwifi/iwl-sta.c |    8 ++++++--
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 34306b6..d86d8a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -268,23 +268,16 @@ struct iwl_cmd {
 	struct iwl_cmd_meta meta;	/* driver data */
 	struct iwl_cmd_header hdr;	/* uCode API */
 	union {
-		struct iwl_addsta_cmd addsta;
-		struct iwl_led_cmd led;
 		u32 flags;
 		u8 val8;
 		u16 val16;
 		u32 val32;
-		struct iwl4965_bt_cmd bt;
-		struct iwl_powertable_cmd powertable;
-		struct iwl_qosparam_cmd qosparam;
 		struct iwl_tx_cmd tx;
-		struct iwl4965_rxon_assoc_cmd rxon_assoc;
-		struct iwl_rem_sta_cmd rm_sta;
-		u8 *indirect;
 		u8 payload[IWL_CMD_MAX_PAYLOAD];
 	} __attribute__ ((packed)) cmd;
 } __attribute__ ((packed));
 
+
 struct iwl_host_cmd {
 	u8 id;
 	u16 len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 5fc4150..7b326f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -104,7 +104,9 @@ static int iwl_add_sta_callback(struct iwl_priv *priv,
 				   struct iwl_cmd *cmd, struct sk_buff *skb)
 {
 	struct iwl_rx_packet *res = NULL;
-	u8 sta_id = cmd->cmd.addsta.sta.sta_id;
+	struct iwl_addsta_cmd *addsta =
+		(struct iwl_addsta_cmd *)cmd->cmd.payload;
+	u8 sta_id = addsta->sta.sta_id;
 
 	if (!skb) {
 		IWL_ERROR("Error: Response NULL in REPLY_ADD_STA.\n");
@@ -326,7 +328,9 @@ static int iwl_remove_sta_callback(struct iwl_priv *priv,
 				   struct iwl_cmd *cmd, struct sk_buff *skb)
 {
 	struct iwl_rx_packet *res = NULL;
-	const char *addr = cmd->cmd.rm_sta.addr;
+	struct iwl_rem_sta_cmd *rm_sta =
+		 (struct iwl_rem_sta_cmd *)cmd->cmd.payload;
+	const char *addr = rm_sta->addr;
 
 	if (!skb) {
 		IWL_ERROR("Error: Response NULL in REPLY_REMOVE_STA.\n");
-- 
1.5.4.3

