Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbbHDU6z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:58:55 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/37] iwlwifi: mvm: handle RX MPDUs separately
Date: Tue,  4 Aug 2015 23:42:52 +0300
Message-Id: <1438721007-23283-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230053_494078_74237834)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to forward RX MPDUs to notification wait tests, nor
do we need to check them for firmware dump triggers, nor could they
be asynchronous. It's thus more efficient to handle them separately,
before going into the regular RX handlers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index e4fa500..8f896cd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -221,7 +221,6 @@ struct iwl_rx_handlers {
  * called from a worker with mvm->mutex held.
  */
 static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
-	RX_HANDLER(REPLY_RX_MPDU_CMD, iwl_mvm_rx_rx_mpdu, false),
 	RX_HANDLER(REPLY_RX_PHY_CMD, iwl_mvm_rx_rx_phy_cmd, false),
 	RX_HANDLER(TX_CMD, iwl_mvm_rx_tx_cmd, false),
 	RX_HANDLER(BA_NOTIF, iwl_mvm_rx_ba_notif, false),
@@ -716,6 +715,9 @@ static int iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	u8 i;
 
+	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD))
+		return iwl_mvm_rx_rx_mpdu(mvm, rxb, cmd);
+
 	iwl_mvm_rx_check_trigger(mvm, pkt);
 
 	/*
-- 
2.1.4

