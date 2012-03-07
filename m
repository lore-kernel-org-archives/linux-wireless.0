Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51937 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759710Ab2CGTGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:34 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 18/35] iwlwifi: print DMA stop timeout error only if it happened
Date: Wed,  7 Mar 2012 09:52:27 -0800
Message-Id: <1331142764-5750-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200723_487226_22789FDE)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

iwl_poll_direct_bit() return negative error value on timeout,
positive values do not indicate an error.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index ef7418d..75bb95e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1219,7 +1219,7 @@ static void iwl_trans_pcie_fw_alive(struct iwl_trans *trans)
  */
 static int iwl_trans_tx_stop(struct iwl_trans *trans)
 {
-	int ch, txq_id;
+	int ch, txq_id, ret;
 	unsigned long flags;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -1232,9 +1232,10 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 	for (ch = 0; ch < FH_TCSR_CHNL_NUM; ch++) {
 		iwl_write_direct32(trans,
 				   FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
-		if (iwl_poll_direct_bit(trans, FH_TSSR_TX_STATUS_REG,
+		ret = iwl_poll_direct_bit(trans, FH_TSSR_TX_STATUS_REG,
 				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
-				    1000))
+				    1000);
+		if (ret < 0)
 			IWL_ERR(trans, "Failing on timeout while stopping"
 			    " DMA channel %d [0x%08x]", ch,
 			    iwl_read_direct32(trans,
-- 
1.7.0.4

