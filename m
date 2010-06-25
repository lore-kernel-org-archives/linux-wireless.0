Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29064 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756830Ab0FYWnW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 18:43:22 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/2] iwlwifi: set TX_CMD_FLAG_PROT_REQUIRE_MSK in tx_flag
Date: Fri, 25 Jun 2010 15:43:19 -0700
Message-Id: <1277505799-25306-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277505799-25306-1-git-send-email-reinette.chatre@intel.com>
References: <1277505799-25306-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When building tx command, always set TX_CMD_FLAG_PROT_REQUIRE_MSK
for 5000 series and up.

Without setting this bit the firmware will not examine the RTS/CTS setting
and thus not send traffic with the appropriate protection. RTS/CTS is is
required for HT traffic in a noisy environment where, without this setting,
connections will stall on some hardware as documented in the patch that
initially attempted to address this:

    commit 1152dcc28c66a74b5b3f1a3ede0aa6729bfd48e4
    Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
    Date:   Fri Jan 15 13:42:58 2010 -0800

    iwlwifi: Fix throughput stall issue in HT mode for 5000

    Similar to 6000 and 1000 series, RTS/CTS is the recommended
    protection mechanism for 5000 series in HT mode based on the HW design.
    Using RTS/CTS will better protect the inner exchange from interference,
    especially in highly-congested environment, it also prevent uCode encounter
    TX FIFO underrun and other HT mode related performance issues.

For 3945 and 4965, different flags are used for RTS/CTS or CTS-to-Self
protection.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 44ef5d9..01658cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -212,11 +212,7 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 static void iwlagn_rts_tx_cmd_flag(struct ieee80211_tx_info *info,
 			__le32 *tx_flags)
 {
-	if ((info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) ||
-	    (info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT))
-		*tx_flags |= TX_CMD_FLG_RTS_CTS_MSK;
-	else
-		*tx_flags &= ~TX_CMD_FLG_RTS_CTS_MSK;
+	*tx_flags |= TX_CMD_FLG_RTS_CTS_MSK;
 }
 
 /* Calc max signal level (dBm) among 3 possible receivers */
-- 
1.7.0.4

