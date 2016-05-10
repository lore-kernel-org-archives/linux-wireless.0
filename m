Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40816 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbcEJUag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:36 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:34 +0300
Message-Id: <1462910797-20303-38-git-send-email-luca@coelho.fi> (sfid-20160510_223041_076163_65D7F1D1)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 38/41] iwlwifi: pcie: use shadow registers for updating write pointer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The RX queues have a shadow register for the write pointer
that enables updates without grabbing NIC access. Use them
instead of the periphery registers because accessing those
is much more expensive.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h  | 3 +++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index 582008a..270f39e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -321,6 +321,9 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
 /* Write index table */
 #define RFH_Q0_FRBDCB_WIDX 0xA08080
 #define RFH_Q_FRBDCB_WIDX(q) (RFH_Q0_FRBDCB_WIDX + (q) * 4)
+/* Write index table - shadow registers */
+#define RFH_Q0_FRBDCB_WIDX_TRG 0x1C80
+#define RFH_Q_FRBDCB_WIDX_TRG(q) (RFH_Q0_FRBDCB_WIDX_TRG + (q) * 4)
 /* Read index table */
 #define RFH_Q0_FRBDCB_RIDX 0xA080C0
 #define RFH_Q_FRBDCB_RIDX(q) (RFH_Q0_FRBDCB_RIDX + (q) * 4)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 89f87f7..3477821 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -208,8 +208,8 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
 
 	rxq->write_actual = round_down(rxq->write, 8);
 	if (trans->cfg->mq_rx_supported)
-		iwl_write_prph(trans, RFH_Q_FRBDCB_WIDX(rxq->id),
-			       rxq->write_actual);
+		iwl_write32(trans, RFH_Q_FRBDCB_WIDX_TRG(rxq->id),
+			    rxq->write_actual);
 	/*
 	 * write to FH_RSCSR_CHNL0_WPTR register even in MQ as a W/A to
 	 * hardware shadow registers bug - writing to RFH_Q_FRBDCB_WIDX will
-- 
2.8.1

