Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077AbbHDU7P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:15 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/37] iwlwifi: pcie: reset write pointer on ict reset
Date: Tue,  4 Aug 2015 23:43:21 +0300
Message-Id: <1438721007-23283-31-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230717_348199_8170716D)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Since the CSR_DRAM_INIT_TBL_WRITE_POINTER bit wasn't set
on ict reset, in some flows (like disable ict followed by
immediate reset ict) the driver and hardware went out
of sync (the driver cleared the ict_index, while the hw
kept it intact).

Fix it by setting the flag when resetting ict.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h | 1 +
 drivers/net/wireless/iwlwifi/pcie/rx.c | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index faa17f2..fa71661 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -422,6 +422,7 @@ enum {
 
 /* DRAM INT TABLE */
 #define CSR_DRAM_INT_TBL_ENABLE		(1 << 31)
+#define CSR_DRAM_INIT_TBL_WRITE_POINTER	(1 << 28)
 #define CSR_DRAM_INIT_TBL_WRAP_CHECK	(1 << 27)
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 5561dee..454ef1d 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1443,8 +1443,9 @@ void iwl_pcie_reset_ict(struct iwl_trans *trans)
 
 	val = trans_pcie->ict_tbl_dma >> ICT_SHIFT;
 
-	val |= CSR_DRAM_INT_TBL_ENABLE;
-	val |= CSR_DRAM_INIT_TBL_WRAP_CHECK;
+	val |= CSR_DRAM_INT_TBL_ENABLE |
+	       CSR_DRAM_INIT_TBL_WRAP_CHECK |
+	       CSR_DRAM_INIT_TBL_WRITE_POINTER;
 
 	IWL_DEBUG_ISR(trans, "CSR_DRAM_INT_TBL_REG =0x%x\n", val);
 
-- 
2.1.4

