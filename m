Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63560 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab1HaGkv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 02:40:51 -0400
Date: Wed, 31 Aug 2011 09:38:30 +0300
From: Dan Carpenter <error27@gmail.com>
To: emmanuel.grumbach@intel.com
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"open list:INTEL WIRELESS WI..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch -next 2/2] iwlwifi: signedness bug in
 iwl_trans_pcie_tx_agg_alloc()
Message-ID: <20110831063830.GD3705@shale.localdomain> (sfid-20110831_084055_359954_A06E38F2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

unsigned shorts and unsigned chars are never == -1.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 5dd6a6d..ea6a0bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -535,7 +535,7 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tid_data *tid_data;
 	unsigned long flags;
-	u16 txq_id;
+	int txq_id;
 	struct iwl_priv *priv = priv(trans);
 
 	txq_id = iwlagn_txq_ctx_activate_free(trans);
