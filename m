Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2830 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab2CJU70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 15:59:26 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/10] iwlwifi: remove TX hex debug
Date: Sat, 10 Mar 2012 13:00:06 -0800
Message-Id: <1331413215-10027-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120310_215959_422473_D066E6DB)
In-Reply-To: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331413215-10027-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Tracing is much better for this, so
remove the hex printk debug for the
TX command.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 9162856..14b0361 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1466,8 +1466,6 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	IWL_DEBUG_TX(trans, "sequence nr = 0X%x\n",
 		     le16_to_cpu(dev_cmd->hdr.sequence));
 	IWL_DEBUG_TX(trans, "tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
-	iwl_print_hex_dump(trans, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
-	iwl_print_hex_dump(trans, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
 	/* Set up entry for this TFD in Tx byte-count array */
 	iwl_trans_txq_update_byte_cnt_tbl(trans, txq, le16_to_cpu(tx_cmd->len));
-- 
1.7.0.4

