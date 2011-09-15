Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934429Ab1IOTcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 27/27] iwlagn: signedness bug
Date: Thu, 15 Sep 2011 11:46:54 -0700
Message-Id: <1316112414-6341-28-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213227_307513_0BB1523F)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

re-apply the unsigned shorts bug fixed by Dan Carpenter but get lost
after the file move.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index d299cd9..f5bc81a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -544,7 +544,7 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tid_data *tid_data;
 	unsigned long flags;
-	u16 txq_id;
+	int txq_id;
 
 	txq_id = iwlagn_txq_ctx_activate_free(trans);
 	if (txq_id == -1) {
-- 
1.7.0.4

