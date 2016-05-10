Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40730 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750922AbcEJU32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:29:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:31 +0300
Message-Id: <1462910797-20303-35-git-send-email-luca@coelho.fi> (sfid-20160510_222930_874495_44765E50)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 35/41] iwlwifi: pcie: extend device reset delay
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Newer hardware generations will take longer to be accessible again
after reset, so we need to wait longer before continuing any flow
that did a reset.

Rather than make the wait time configurable, simply extend it for
all.

Since all of these code paths can sleep, use usleep_range() rather
than mdelay().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index edf9e23..59fd17a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -360,8 +360,7 @@ static void iwl_pcie_apm_lp_xtal_enable(struct iwl_trans *trans)
 
 	/* Reset entire device - do controller reset (results in SHRD_HW_RST) */
 	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-
-	udelay(10);
+	usleep_range(1000, 2000);
 
 	/*
 	 * Set "initialization complete" bit to move adapter from
@@ -407,8 +406,7 @@ static void iwl_pcie_apm_lp_xtal_enable(struct iwl_trans *trans)
 	 * SHRD_HW_RST). Turn MAC off before proceeding.
 	 */
 	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-
-	udelay(10);
+	usleep_range(1000, 2000);
 
 	/* Enable LP XTAL by indirect access through CSR */
 	apmg_gp1_reg = iwl_trans_pcie_read_shr(trans, SHR_APMG_GP1_REG);
@@ -505,8 +503,7 @@ static void iwl_pcie_apm_stop(struct iwl_trans *trans, bool op_mode_leave)
 
 	/* Reset the entire device */
 	iwl_set_bit(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-
-	udelay(10);
+	usleep_range(1000, 2000);
 
 	/*
 	 * Clear "initialization complete" bit to move adapter from
@@ -1073,7 +1070,7 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans, bool low_power)
 
 	/* stop and reset the on-board processor */
 	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-	udelay(20);
+	usleep_range(1000, 2000);
 
 	/*
 	 * Upon stop, the APM issues an interrupt if HW RF kill is set.
@@ -1525,8 +1522,7 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 
 	/* Reset the entire device */
 	iwl_write32(trans, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
-
-	usleep_range(10, 15);
+	usleep_range(1000, 2000);
 
 	iwl_pcie_apm_init(trans);
 
-- 
2.8.1

