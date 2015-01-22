Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618AbbAVUe4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:56 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 38/38] iwlwifi: mvm: fix rx chains configuration in phy ctxt cmd
Date: Thu, 22 Jan 2015 22:33:29 +0200
Message-Id: <1421958809-3371-38-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214448_317562_1FE8402D)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In the PHY_CTXT command sent to the FW the TX chains were
indeed configured by the values of both FW TLVs and of NVM,
but the RX chains were left out and configured only by FW
TLV.

This causes problems in 4165 HW, where there are 1x1
antennas, and the wrong configuration denies the driver
from connecting to the AP.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index 540c36b..5b43616 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -170,7 +170,7 @@ static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
 		active_cnt = 2;
 	}
 
-	cmd->rxchain_info = cpu_to_le32(mvm->fw->valid_rx_ant <<
+	cmd->rxchain_info = cpu_to_le32(iwl_mvm_get_valid_rx_ant(mvm) <<
 					PHY_RX_CHAIN_VALID_POS);
 	cmd->rxchain_info |= cpu_to_le32(idle_cnt << PHY_RX_CHAIN_CNT_POS);
 	cmd->rxchain_info |= cpu_to_le32(active_cnt <<
-- 
1.9.1

