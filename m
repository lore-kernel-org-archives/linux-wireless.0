Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33588 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753917AbcGFKqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:46:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>, Ido Yariv <idox.yariv@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:28 +0300
Message-Id: <1467801651-1816-33-git-send-email-luca@coelho.fi> (sfid-20160706_125023_930414_3DF590C3)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 33/56] iwlwifi: pcie: Enable MSI mode when using MSI interrupts
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

On some of the chipsets MSI & INTA interrupts are disabled by default in
the HW registers, and need to be explicitly enabled to be used.

In case MSI-X isn't used, make sure MSI mode is enabled by setting
the relevant HW register.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h   | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 6c1d20d..459bf73 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -417,5 +417,6 @@ enum {
 };
 
 #define UREG_CHICK		(0xA05C00)
+#define UREG_CHICK_MSI_ENABLE	BIT(24)
 #define UREG_CHICK_MSIX_ENABLE	BIT(25)
 #endif				/* __iwl_prph_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index ac623c3..f5ace92 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1396,8 +1396,12 @@ static void iwl_pcie_init_msix(struct iwl_trans_pcie *trans_pcie)
 
 	max_rx_vector = trans_pcie->allocated_vector - 1;
 
-	if (!trans_pcie->msix_enabled)
+	if (!trans_pcie->msix_enabled) {
+		if (trans->cfg->mq_rx_supported)
+			iwl_write_prph(trans, UREG_CHICK,
+				       UREG_CHICK_MSI_ENABLE);
 		return;
+	}
 
 	iwl_write_prph(trans, UREG_CHICK, UREG_CHICK_MSIX_ENABLE);
 
-- 
2.8.1

