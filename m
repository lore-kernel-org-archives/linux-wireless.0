Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39511 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab0FYWnI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 18:43:08 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/8] iwlwifi: name change from signal protection flag
Date: Fri, 25 Jun 2010 15:42:54 -0700
Message-Id: <1277505781-25268-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
References: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

This bit need to be set for both RTS/CTS or CTS-to-self protection, if
CTS-to-self is used, then uCode will  check the RXON_FLG_SELF_CTS_EN
status. Change the name from TX_CMD_FLG_RTS_CTS_MSK to TX_CMD_FLAG_PROT_REQUIRE_MSK
to match the behavior of the bit setting.

Also update comments to reflect which hardware uses which of the TX command
flags.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |   30 ++++++++++++++++++--------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index d89a11c..f06d1fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -214,7 +214,7 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 static void iwlagn_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
 			__le32 *tx_flags)
 {
-	*tx_flags |= TX_CMD_FLG_RTS_CTS_MSK;
+	*tx_flags |= TX_CMD_FLG_PROT_REQUIRE_MSK;
 }
 
 /* Calc max signal level (dBm) among 3 possible receivers */
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 4984925..a304f77 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1399,18 +1399,27 @@ struct iwl_rx_mpdu_res_start {
 
 /* REPLY_TX Tx flags field */
 
-/* 1: Use RTS/CTS protocol or CTS-to-self if spec allows it
+/*
+ * 1: Use RTS/CTS protocol or CTS-to-self if spec allows it
  * before this frame. if CTS-to-self required check
- * RXON_FLG_SELF_CTS_EN status. */
-#define TX_CMD_FLG_RTS_CTS_MSK cpu_to_le32(1 << 0)
+ * RXON_FLG_SELF_CTS_EN status.
+ * unused in 3945/4965, used in 5000 series and after
+ */
+#define TX_CMD_FLG_PROT_REQUIRE_MSK cpu_to_le32(1 << 0)
 
-/* 1: Use Request-To-Send protocol before this frame.
- * Mutually exclusive vs. TX_CMD_FLG_CTS_MSK. */
+/*
+ * 1: Use Request-To-Send protocol before this frame.
+ * Mutually exclusive vs. TX_CMD_FLG_CTS_MSK.
+ * used in 3945/4965, unused in 5000 series and after
+ */
 #define TX_CMD_FLG_RTS_MSK cpu_to_le32(1 << 1)
 
-/* 1: Transmit Clear-To-Send to self before this frame.
+/*
+ * 1: Transmit Clear-To-Send to self before this frame.
  * Driver should set this for AUTH/DEAUTH/ASSOC-REQ/REASSOC mgmnt frames.
- * Mutually exclusive vs. TX_CMD_FLG_RTS_MSK. */
+ * Mutually exclusive vs. TX_CMD_FLG_RTS_MSK.
+ * used in 3945/4965, unused in 5000 series and after
+ */
 #define TX_CMD_FLG_CTS_MSK cpu_to_le32(1 << 2)
 
 /* 1: Expect ACK from receiving station
@@ -1430,8 +1439,11 @@ struct iwl_rx_mpdu_res_start {
  * Set when Txing a block-ack request frame.  Also set TX_CMD_FLG_ACK_MSK. */
 #define TX_CMD_FLG_IMM_BA_RSP_MASK  cpu_to_le32(1 << 6)
 
-/* 1: Frame requires full Tx-Op protection.
- * Set this if either RTS or CTS Tx Flag gets set. */
+/*
+ * 1: Frame requires full Tx-Op protection.
+ * Set this if either RTS or CTS Tx Flag gets set.
+ * used in 3945/4965, unused in 5000 series and after
+ */
 #define TX_CMD_FLG_FULL_TXOP_PROT_MSK cpu_to_le32(1 << 7)
 
 /* Tx antenna selection field; used only for 3945, reserved (0) for 4965.
-- 
1.7.0.4

