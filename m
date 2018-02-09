Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:58234 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750942AbeBINMo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 08:12:44 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  9 Feb 2018 15:12:32 +0200
Message-Id: <20180209131234.8504-4-luca@coelho.fi> (sfid-20180209_141250_014337_FF25A3DB)
In-Reply-To: <20180209131234.8504-1-luca@coelho.fi>
References: <20180209131234.8504-1-luca@coelho.fi>
Subject: [PATCH 3/5] iwlwifi: pcie: don't warn if we use all the transmit pointers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Our Transmit Frame Descriptor (TFD) is a DMA descriptor that
includes several pointers to be able to transmit a packet
which is not physically contiguous.

Depending on the hardware being use, we can have 20 or 25
pointers in a single TFD. In both cases, it is more than
enough and it is quite hard to hit this limit.
It has been reported that when using specific applications
(Ktorrent), we can actually use all the pointers and then
a long standing bug showed up.

When we free the TFD, we check its number of valid pointers
and make sure it doesn't exceed the number of pointers the
hardware support.
This check had an off by one bug: it is perfectly valid to
free the 20 pointers if the TFD has 20 pointers.

Fix that.

https://bugzilla.kernel.org/show_bug.cgi?id=197981

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 6d0a907d5ba5..fabae0f60683 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -147,7 +147,7 @@ static void iwl_pcie_gen2_tfd_unmap(struct iwl_trans *trans,
 	/* Sanity check on number of chunks */
 	num_tbs = iwl_pcie_gen2_get_num_tbs(trans, tfd);
 
-	if (num_tbs >= trans_pcie->max_tbs) {
+	if (num_tbs > trans_pcie->max_tbs) {
 		IWL_ERR(trans, "Too many chunks: %i\n", num_tbs);
 		return;
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 3f85713c41dc..1a566287993d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -378,7 +378,7 @@ static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
 	/* Sanity check on number of chunks */
 	num_tbs = iwl_pcie_tfd_get_num_tbs(trans, tfd);
 
-	if (num_tbs >= trans_pcie->max_tbs) {
+	if (num_tbs > trans_pcie->max_tbs) {
 		IWL_ERR(trans, "Too many chunks: %i\n", num_tbs);
 		/* @todo issue fatal error, it is quite serious situation */
 		return;
-- 
2.15.1
