Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab1LIBZC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:25:02 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/15] iwlwifi: set TX_CMD_FLG_STA_RATE_MSK for BAR frame
Date: Thu,  8 Dec 2011 16:26:16 -0800
Message-Id: <1323390382-1678-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022511_558915_AA5F9710)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is needed by firmware to use the correct rate for BAR frame transmission

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index cdf9efd..2fab2e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -161,7 +161,8 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 		}
 #endif
 		return;
-	}
+	} else if (ieee80211_is_back_req(fc))
+		tx_cmd->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
 
 	/**
 	 * If the current TX rate stored in mac80211 has the MCS bit set, it's
-- 
1.7.0.4

