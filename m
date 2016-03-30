Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbcC3OGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:03 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/43] iwlwifi: pcie: write to legacy register also in MQ
Date: Wed, 30 Mar 2016 17:04:52 +0300
Message-Id: <1459346715-7954-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160617_744097_3EB71B43)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Due to hardware bug, upon any shadow free-queue register write
access, a legacy RBD shadow register must be written as well.
This is required in order to trigger a copy of the shadow registers
values after MAC exits sleep state.
Specifically, the driver has to write (any value) to the legacy RBD
register each time FRBDCB is accessed.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index e379dba..59a7e45 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -210,8 +210,12 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
 	if (trans->cfg->mq_rx_supported)
 		iwl_write_prph(trans, RFH_Q_FRBDCB_WIDX(rxq->id),
 			       rxq->write_actual);
-	else
-		iwl_write32(trans, FH_RSCSR_CHNL0_WPTR, rxq->write_actual);
+	/*
+	 * write to FH_RSCSR_CHNL0_WPTR register even in MQ as a W/A to
+	 * hardware shadow registers bug - writing to RFH_Q_FRBDCB_WIDX will
+	 * not wake the NIC.
+	 */
+	iwl_write32(trans, FH_RSCSR_CHNL0_WPTR, rxq->write_actual);
 }
 
 static void iwl_pcie_rxq_check_wrptr(struct iwl_trans *trans)
-- 
2.5.0

