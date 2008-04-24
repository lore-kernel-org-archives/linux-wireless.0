Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbYDXAPM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/16] iwlwifi: reorganize TX RX constatns
Date: Wed, 23 Apr 2008 17:15:00 -0700
Message-Id: <1208996108-15326-9-git-send-email-reinette.chatre@intel.com> (sfid-20080424_021610_354911_06D9E6AB)
In-Reply-To: <1208996108-15326-8-git-send-email-reinette.chatre@intel.com>
References: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-2-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-3-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-4-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-5-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-6-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-7-git-send-email-reinette.chatre@intel.com>
 <1208996108-15326-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves TX/RX constants in 4969 headers

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl-4965.c          |    3 ---
 drivers/net/wireless/iwlwifi/iwl-4965.h          |    7 +++++--
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 7ffae05..6b2d6bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -1101,6 +1101,14 @@ struct iwl4965_rx_mpdu_res_start {
 #define TX_CMD_SEC_KEY128	0x08
 
 /*
+ * security overhead sizes
+ */
+#define WEP_IV_LEN 4
+#define WEP_ICV_LEN 4
+#define CCMP_MIC_LEN 8
+#define TKIP_ICV_LEN 4
+
+/*
  * 4965 uCode updates these Tx attempt count values in host DRAM.
  * Used for managing Tx retries when expecting block-acks.
  * Driver should set these fields to 0.
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e80f602..f5796b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2502,9 +2502,6 @@ static void iwl4965_free_shared_mem(struct iwl_priv *priv)
 				    priv->shared_phys);
 }
 
-#define IWL_TX_CRC_SIZE		4
-#define IWL_TX_DELIMITER_SIZE	4
-
 /**
  * iwl4965_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 1ab4e2e..e357263 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -803,8 +803,8 @@ struct iwl4965_kw {
 #define IWL_EXT_CHANNEL_OFFSET_RESERVE1  2
 #define IWL_EXT_CHANNEL_OFFSET_BELOW     3
 
-#define NRG_NUM_PREV_STAT_L     20
-#define NUM_RX_CHAINS           (3)
+#define IWL_TX_CRC_SIZE 4
+#define IWL_TX_DELIMITER_SIZE 4
 
 #define TX_POWER_IWL_ILLEGAL_VOLTAGE -10000
 
@@ -854,6 +854,9 @@ struct iwl4965_lq_mngr {
 #define IN_BAND_FILTER			0xFF
 #define MIN_AVERAGE_NOISE_MAX_VALUE	0xFFFFFFFF
 
+#define NRG_NUM_PREV_STAT_L     20
+#define NUM_RX_CHAINS           3
+
 enum iwl4965_false_alarm_state {
 	IWL_FA_TOO_MANY = 0,
 	IWL_FA_TOO_FEW = 1,
-- 
1.5.3.4

