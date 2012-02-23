Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab2BWKQV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 05:16:21 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 5/6] iwlwifi: print DMA stop timeout message only if that error happened
Date: Thu, 23 Feb 2012 11:16:07 +0100
Message-Id: <1329992168-19990-5-git-send-email-sgruszka@redhat.com> (sfid-20120223_111626_401628_A994E846)
In-Reply-To: <1329992168-19990-1-git-send-email-sgruszka@redhat.com>
References: <1329992168-19990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl_poll_direct_bit() return negative error value on timeout, positive
values does not indicate an error.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index b6909b4..a0e716f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1209,7 +1209,7 @@ static void iwl_trans_pcie_fw_alive(struct iwl_trans *trans)
  */
 static int iwl_trans_tx_stop(struct iwl_trans *trans)
 {
-	int ch, txq_id;
+	int ch, txq_id, ret;
 	unsigned long flags;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -1222,9 +1222,10 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
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
1.7.1

