Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42270 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750915AbdJ2M23 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 08:28:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 14:28:00 +0200
Message-Id: <20171029122816.8802-2-luca@coelho.fi> (sfid-20171029_132848_749124_82301DFF)
In-Reply-To: <20171029122816.8802-1-luca@coelho.fi>
References: <20171029122816.8802-1-luca@coelho.fi>
Subject: [PATCH 01/17] iwlwifi: mvm: use RS macro instead of duplicating the code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

There is a macro for converting TX response rate to a
rate scale value, use it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 00a0efab20e3..d88c3685a6dd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1594,8 +1594,7 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 		mvmsta->tid_data[tid].tx_time =
 			le16_to_cpu(tx_resp->wireless_media_time);
 		mvmsta->tid_data[tid].lq_color =
-			(tx_resp->tlc_info & TX_RES_RATE_TABLE_COLOR_MSK) >>
-			TX_RES_RATE_TABLE_COLOR_POS;
+			TX_RES_RATE_TABLE_COL_GET(tx_resp->tlc_info);
 	}
 
 	rcu_read_unlock();
-- 
2.14.2
