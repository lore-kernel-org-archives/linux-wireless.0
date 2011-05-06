Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37810 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428Ab1EFS2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 14:28:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/7] iwlagn: remove unused variable
Date: Fri,  6 May 2011 11:04:37 -0700
Message-Id: <1304705080-29349-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110506_202855_819598_6E8ADF12)
In-Reply-To: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The variable 'len' here is set but never used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 608d7a1..517d104 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -442,7 +442,6 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	struct iwl_cmd_meta *out_meta;
 	dma_addr_t phys_addr;
 	unsigned long flags;
-	int len;
 	u32 idx;
 	u16 fix_size;
 	bool is_ct_kill = false;
@@ -518,9 +517,6 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 			INDEX_TO_SEQ(q->write_ptr));
 	if (cmd->flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
-	len = sizeof(struct iwl_device_cmd);
-	if (idx == TFD_CMD_SLOTS)
-		len = IWL_MAX_CMD_SIZE;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	switch (out_cmd->hdr.cmd) {
-- 
1.7.0.4

