Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24090 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbYF3J0Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:26:16 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 01/33] iwlwifi: configure uCode to use open loop tx power algorithm
Date: Mon, 30 Jun 2008 17:23:01 +0800
Message-Id: <1214817813-17639-2-git-send-email-yi.zhu@intel.com> (sfid-20080630_112620_173821_01D5BE02)
In-Reply-To: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

This patch configures uCode to use open loop tx power algorithm
via TX_POWER_DBM (0x98) host command.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 438c381..2b48f1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1426,7 +1426,7 @@ static int  iwl5000_send_tx_power(struct iwl_priv *priv)
 
 	/* half dBm need to multiply */
 	tx_power_cmd.global_lmt = (s8)(2 * priv->tx_power_user_lmt);
-	tx_power_cmd.flags = 0;
+	tx_power_cmd.flags = IWL50_TX_POWER_NO_CLOSED;
 	tx_power_cmd.srv_chan_lmt = IWL50_TX_POWER_AUTO;
 	return  iwl_send_cmd_pdu_async(priv, REPLY_TX_POWER_DBM_CMD,
 				       sizeof(tx_power_cmd), &tx_power_cmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 920dfc1..6957b22 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -336,6 +336,8 @@ struct iwl4965_tx_power_db {
  * struct iwl5000_tx_power_dbm_cmd
  */
 #define IWL50_TX_POWER_AUTO 0x7f
+#define IWL50_TX_POWER_NO_CLOSED (0x1 << 6)
+
 struct iwl5000_tx_power_dbm_cmd {
 	s8 global_lmt; /*in half-dBm (e.g. 30 = 15 dBm) */
 	u8 flags;
-- 
1.5.3.6

