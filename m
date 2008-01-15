Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:60992 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbYAOC0z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 21:26:55 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 01/12] iwl4965: Remove redundant code in iwl4965_tx_cmd
Date: Mon, 14 Jan 2008 17:46:14 -0800
Message-Id: <1200361585-31801-2-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022701_718505_AB653D21)
In-Reply-To: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This function removes redundant code in iwl4965_tx_cmd
function, leftovers of previous design.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |   23 +----------------------
 1 files changed, 1 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index ed3f119..b913c6b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3267,8 +3267,7 @@ int iwl4965_tx_cmd(struct iwl4965_priv *priv, struct iwl4965_cmd *out_cmd,
 		   struct ieee80211_hdr *hdr, u8 hdr_len,
 		   struct ieee80211_tx_control *ctrl, void *sta_in)
 {
-	struct iwl4965_tx_cmd cmd;
-	struct iwl4965_tx_cmd *tx = (struct iwl4965_tx_cmd *)&out_cmd->cmd.payload[0];
+	struct iwl4965_tx_cmd *tx = &out_cmd->cmd.tx;
 	dma_addr_t scratch_phys;
 	u8 unicast = 0;
 	u8 is_data = 1;
@@ -3287,26 +3286,6 @@ int iwl4965_tx_cmd(struct iwl4965_priv *priv, struct iwl4965_cmd *out_cmd,
 	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)
 		is_data = 0;
 
-	memcpy(&cmd, &(out_cmd->cmd.tx), sizeof(struct iwl4965_tx_cmd));
-	memset(tx, 0, sizeof(struct iwl4965_tx_cmd));
-	memcpy(tx->hdr, hdr, hdr_len);
-
-	tx->len = cmd.len;
-	tx->driver_txop = cmd.driver_txop;
-	tx->stop_time.life_time = cmd.stop_time.life_time;
-	tx->tx_flags = cmd.tx_flags;
-	tx->sta_id = cmd.sta_id;
-	tx->tid_tspec = cmd.tid_tspec;
-	tx->timeout.pm_frame_timeout = cmd.timeout.pm_frame_timeout;
-	tx->next_frame_len = cmd.next_frame_len;
-
-	tx->sec_ctl = cmd.sec_ctl;
-	memcpy(&(tx->key[0]), &(cmd.key[0]), 16);
-	tx->tx_flags = cmd.tx_flags;
-
-	tx->rts_retry_limit = cmd.rts_retry_limit;
-	tx->data_retry_limit = cmd.data_retry_limit;
-
 	scratch_phys = txcmd_phys + sizeof(struct iwl4965_cmd_header) +
 	    offsetof(struct iwl4965_tx_cmd, scratch);
 	tx->dram_lsb_ptr = cpu_to_le32(scratch_phys);
-- 
1.5.3.4

