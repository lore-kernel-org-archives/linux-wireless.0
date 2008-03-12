Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51341 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYCMAED (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 20:04:03 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Max Stepanov <max.stepanov@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/5] iwlwifi: Bug fix, CCMP with HW encryption with AGG
Date: Wed, 12 Mar 2008 16:58:48 -0700
Message-Id: <1205366332-12652-2-git-send-email-reinette.chatre@intel.com> (sfid-20080313_000411_584000_A38F6037)
In-Reply-To: <1205366332-12652-1-git-send-email-reinette.chatre@intel.com>
References: <1205366332-12652-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Max Stepanov <max.stepanov@intel.com>

This patch fixes a bug in security. Enables CCMP HW encryption with
aggregations.

Signed-off-by: Max Stepanov <max.stepanov@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |    4 ++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c      |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 35f592d..1025ffe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -1045,6 +1045,10 @@ struct iwl4965_rx_mpdu_res_start {
  * MAC header) to DWORD boundary. */
 #define TX_CMD_FLG_MH_PAD_MSK __constant_cpu_to_le32(1 << 20)
 
+/* accelerate aggregation support
+ * 0 - no CCMP encryption; 1 - CCMP encryption */
+#define TX_CMD_FLG_AGG_CCMP_MSK __constant_cpu_to_le32(1 << 22)
+
 /* HCCA-AP - disable duration overwriting. */
 #define TX_CMD_FLG_DUR_MSK __constant_cpu_to_le32(1 << 25)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 0b73351..d0cb36b 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2427,6 +2427,8 @@ static void iwl4965_build_tx_cmd_hwcrypto(struct iwl4965_priv *priv,
 	case ALG_CCMP:
 		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_CCM;
 		memcpy(cmd->cmd.tx.key, keyinfo->key, keyinfo->keylen);
+		if (ctl->flags & IEEE80211_TXCTL_AMPDU)
+			cmd->cmd.tx.tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
 		IWL_DEBUG_TX("tx_cmd with aes hwcrypto\n");
 		break;
 
-- 
1.5.3.4

