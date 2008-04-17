Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbYDQXDm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 19:03:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/5] iwlwifi: define ANA_PLL values in iwl-csr.h
Date: Thu, 17 Apr 2008 16:03:38 -0700
Message-Id: <1208473420-16550-4-git-send-email-reinette.chatre@intel.com> (sfid-20080418_000352_473067_7842B814)
In-Reply-To: <1208473420-16550-3-git-send-email-reinette.chatre@intel.com>
References: <1208473420-16550-1-git-send-email-reinette.chatre@intel.com>
 <1208473420-16550-2-git-send-email-reinette.chatre@intel.com>
 <1208473420-16550-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch defines ANA_PLL values in iwl-csr.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h  |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 598e4ee..2869533 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1233,7 +1233,7 @@ int iwl3945_hw_nic_init(struct iwl3945_priv *priv)
 	iwl3945_power_init_handle(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
-	iwl3945_set_bit(priv, CSR_ANA_PLL_CFG, (1 << 24));
+	iwl3945_set_bit(priv, CSR_ANA_PLL_CFG, CSR39_ANA_PLL_CFG_VAL);
 	iwl3945_set_bit(priv, CSR_GIO_CHICKEN_BITS,
 		    CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index a59f48b..82c7445 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -95,8 +95,7 @@
 #define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
 #define CSR_LED_REG             (CSR_BASE+0x094)
 
-/* Analog phase-lock-loop configuration (3945 only)
- * Set bit 24. */
+/* Analog phase-lock-loop configuration  */
 #define CSR_ANA_PLL_CFG         (CSR_BASE+0x20c)
 /*
  * Indicates hardware rev, to determine CCK backoff for txpower calculation.
@@ -219,6 +218,10 @@
 #define CSR_LED_REG_TRUN_ON (0x78)
 #define CSR_LED_REG_TRUN_OFF (0x38)
 
+/* ANA_PLL */
+#define CSR39_ANA_PLL_CFG_VAL        (0x01000000)
+#define CSR50_ANA_PLL_CFG_VAL        (0x00880300)
+
 /*=== HBUS (Host-side Bus) ===*/
 #define HBUS_BASE	(0x400)
 /*
-- 
1.5.3.4

