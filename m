Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55862 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbZA2TGW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 14:06:22 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/7] iwlwifi: correct API command overlap
Date: Thu, 29 Jan 2009 11:09:14 -0800
Message-Id: <1233256157-21290-5-git-send-email-reinette.chatre@intel.com> (sfid-20090129_200628_026595_C7A767FD)
In-Reply-To: <1233256157-21290-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1233256157-21290-1-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-2-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-3-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

Correct the API commands where same command id used for two different
commands. Update max api versions for affected devices.

TX_ANT_CONFIGURATION_CMD was already using id 0x98, so
REPLY_TX_POWER_DBM_CMD moved to 0x95

Older API interfaces may used original value so V1 defines provided.

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-100.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    9 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 +++-
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-100.c b/drivers/net/wireless/iwlwifi/iwl-100.c
index a5df931..11d206a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-100.c
+++ b/drivers/net/wireless/iwlwifi/iwl-100.c
@@ -46,7 +46,7 @@
 #include "iwl-5000-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL100_UCODE_API_MAX 1
+#define IWL100_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */
 #define IWL100_UCODE_API_MIN 1
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ee58ddb..5b59286 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1411,12 +1411,19 @@ static int iwl5000_send_rxon_assoc(struct iwl_priv *priv)
 static int  iwl5000_send_tx_power(struct iwl_priv *priv)
 {
 	struct iwl5000_tx_power_dbm_cmd tx_power_cmd;
+	u8 tx_ant_cfg_cmd;
 
 	/* half dBm need to multiply */
 	tx_power_cmd.global_lmt = (s8)(2 * priv->tx_power_user_lmt);
 	tx_power_cmd.flags = IWL50_TX_POWER_NO_CLOSED;
 	tx_power_cmd.srv_chan_lmt = IWL50_TX_POWER_AUTO;
-	return  iwl_send_cmd_pdu_async(priv, REPLY_TX_POWER_DBM_CMD,
+
+	if (IWL_UCODE_API(priv->ucode_ver) == 1)
+		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD_V1;
+	else
+		tx_ant_cfg_cmd = REPLY_TX_POWER_DBM_CMD;
+
+	return  iwl_send_cmd_pdu_async(priv, tx_ant_cfg_cmd,
 				       sizeof(tx_power_cmd), &tx_power_cmd,
 				       NULL);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 1672a98..af70070 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -46,8 +46,8 @@
 #include "iwl-5000-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL6000_UCODE_API_MAX 1
-#define IWL6050_UCODE_API_MAX 1
+#define IWL6000_UCODE_API_MAX 2
+#define IWL6050_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 1
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index e49415c..77f32ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -144,9 +144,11 @@ enum {
 	WHO_IS_AWAKE_NOTIFICATION = 0x94,	/* not used */
 
 	/* Miscellaneous commands */
+	REPLY_TX_POWER_DBM_CMD = 0x95,
 	QUIET_NOTIFICATION = 0x96,		/* not used */
 	REPLY_TX_PWR_TABLE_CMD = 0x97,
-	REPLY_TX_POWER_DBM_CMD = 0x98,
+	REPLY_TX_POWER_DBM_CMD_V1 = 0x98,	/* old version of API */
+	TX_ANT_CONFIGURATION_CMD = 0x98,	/* not used */
 	MEASURE_ABORT_NOTIFICATION = 0x99,	/* not used */
 
 	/* Bluetooth device coexistence config command */
-- 
1.5.4.3

