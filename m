Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5778 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbZGTDqa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 23:46:30 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 5/5] iwmc3200wifi: fix a use-after-free bug
Date: Mon, 20 Jul 2009 11:47:47 +0800
Message-Id: <1248061667-8614-6-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1248061667-8614-5-git-send-email-yi.zhu@intel.com>
References: <1248061667-8614-1-git-send-email-yi.zhu@intel.com>
 <1248061667-8614-2-git-send-email-yi.zhu@intel.com>
 <1248061667-8614-3-git-send-email-yi.zhu@intel.com>
 <1248061667-8614-4-git-send-email-yi.zhu@intel.com>
 <1248061667-8614-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes a use-after-free bug for cmd->seq_num;

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/hal.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/hal.c b/drivers/net/wireless/iwmc3200wifi/hal.c
index ee127fe..c430418 100644
--- a/drivers/net/wireless/iwmc3200wifi/hal.c
+++ b/drivers/net/wireless/iwmc3200wifi/hal.c
@@ -105,9 +105,9 @@
 #include "umac.h"
 #include "debug.h"
 
-static void iwm_nonwifi_cmd_init(struct iwm_priv *iwm,
-				 struct iwm_nonwifi_cmd *cmd,
-				 struct iwm_udma_nonwifi_cmd *udma_cmd)
+static int iwm_nonwifi_cmd_init(struct iwm_priv *iwm,
+				struct iwm_nonwifi_cmd *cmd,
+				struct iwm_udma_nonwifi_cmd *udma_cmd)
 {
 	INIT_LIST_HEAD(&cmd->pending);
 
@@ -118,7 +118,7 @@ static void iwm_nonwifi_cmd_init(struct iwm_priv *iwm,
 	cmd->seq_num = iwm->nonwifi_seq_num;
 	udma_cmd->seq_num = cpu_to_le16(cmd->seq_num);
 
-	cmd->seq_num = iwm->nonwifi_seq_num++;
+	iwm->nonwifi_seq_num++;
 	iwm->nonwifi_seq_num %= UMAC_NONWIFI_SEQ_NUM_MAX;
 
 	if (udma_cmd->resp)
@@ -130,6 +130,8 @@ static void iwm_nonwifi_cmd_init(struct iwm_priv *iwm,
 	cmd->buf.len = 0;
 
 	memcpy(&cmd->udma_cmd, udma_cmd, sizeof(*udma_cmd));
+
+	return cmd->seq_num;
 }
 
 u16 iwm_alloc_wifi_cmd_seq(struct iwm_priv *iwm)
@@ -369,7 +371,7 @@ int iwm_hal_send_target_cmd(struct iwm_priv *iwm,
 			    const void *payload)
 {
 	struct iwm_nonwifi_cmd *cmd;
-	int ret;
+	int ret, seq_num;
 
 	cmd = kzalloc(sizeof(struct iwm_nonwifi_cmd), GFP_KERNEL);
 	if (!cmd) {
@@ -377,7 +379,7 @@ int iwm_hal_send_target_cmd(struct iwm_priv *iwm,
 		return -ENOMEM;
 	}
 
-	iwm_nonwifi_cmd_init(iwm, cmd, udma_cmd);
+	seq_num = iwm_nonwifi_cmd_init(iwm, cmd, udma_cmd);
 
 	if (cmd->udma_cmd.opcode == UMAC_HDI_OUT_OPCODE_WRITE ||
 	    cmd->udma_cmd.opcode == UMAC_HDI_OUT_OPCODE_WRITE_PERSISTENT) {
@@ -393,7 +395,7 @@ int iwm_hal_send_target_cmd(struct iwm_priv *iwm,
 	if (ret < 0)
 		return ret;
 
-	return cmd->seq_num;
+	return seq_num;
 }
 
 static void iwm_build_lmac_hdr(struct iwm_priv *iwm, struct iwm_lmac_hdr *hdr,
-- 
1.6.0.4

