Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57170 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750826AbbJEPB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:43 +0300
Message-Id: <1444055820-27506-12-git-send-email-luca@coelho.fi> (sfid-20151005_170131_573292_6AACC93F)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 12/29] iwlwifi: mvm: remove PHY RX from handlers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Treat PHY RX specially, since it's actually pretty frequent,
doesn't need all the notication etc. code, and will have a
different handler in future hardware.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 23825ff..1c38e45 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -222,7 +222,6 @@ struct iwl_rx_handlers {
  * called from a worker with mvm->mutex held.
  */
 static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
-	RX_HANDLER(REPLY_RX_PHY_CMD, iwl_mvm_rx_rx_phy_cmd, false),
 	RX_HANDLER(TX_CMD, iwl_mvm_rx_tx_cmd, false),
 	RX_HANDLER(BA_NOTIF, iwl_mvm_rx_ba_notif, false),
 
@@ -730,6 +729,9 @@ static void iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD)) {
 		iwl_mvm_rx_rx_mpdu(mvm, napi, rxb);
 		return;
+	} else if (pkt->hdr.cmd == REPLY_RX_PHY_CMD) {
+		iwl_mvm_rx_rx_phy_cmd(mvm, rxb);
+		return;
 	}
 
 	iwl_mvm_rx_check_trigger(mvm, pkt);
-- 
2.5.3

