Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54318 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954311AbdDYU35 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:29:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:42 +0300
Message-Id: <20170425202243.7844-25-luca@coelho.fi> (sfid-20170425_223010_834260_72646A19)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 24/25] iwlwifi: pcie: apply no-reclaim logic only to group 0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When applying no-reclaim logic to commands other than the group
zero for legacy commands, commands such as 0x1c (TX_CMD in group
0) can't be used in any other group. Fix that by applying this
logic only for group 0 - it's not and should never be needed for
any other groups.

Reported-by: Sharon Dvir <sharon.dvir@intel.com>
Reported-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index f98f2d2b8a1b..1da2de205cdf 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1147,7 +1147,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
 		 *   but apparently a few don't get set; catch them here. */
 		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME);
-		if (reclaim) {
+		if (reclaim && !pkt->hdr.group_id) {
 			int i;
 
 			for (i = 0; i < trans_pcie->n_no_reclaim_cmds; i++) {
-- 
2.11.0
