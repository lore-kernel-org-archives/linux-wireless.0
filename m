Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55661 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbYBSWTY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 17:19:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] iwlwifi: remove twice defined CSR register
Date: Tue, 19 Feb 2008 14:05:33 -0800
Message-Id: <1203458733-9177-1-git-send-email-reinette.chatre@intel.com> (sfid-20080219_221929_754126_FE1886C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes twice defined CSR register. It was confusing

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    7 ++++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 571815d..6693767 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -324,7 +324,6 @@ struct iwl3945_eeprom {
 /*=== CSR (control and status registers) ===*/
 #define CSR_BASE    (0x000)
 
-#define CSR_SW_VER              (CSR_BASE+0x000)
 #define CSR_HW_IF_CONFIG_REG    (CSR_BASE+0x000) /* hardware interface config */
 #define CSR_INT_COALESCING      (CSR_BASE+0x004) /* accum ints, 32-usec units */
 #define CSR_INT                 (CSR_BASE+0x008) /* host interrupt status/ack */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index ffe1e9d..cc72621 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -413,7 +413,6 @@ struct iwl4965_eeprom {
 /*=== CSR (control and status registers) ===*/
 #define CSR_BASE    (0x000)
 
-#define CSR_SW_VER              (CSR_BASE+0x000)
 #define CSR_HW_IF_CONFIG_REG    (CSR_BASE+0x000) /* hardware interface config */
 #define CSR_INT_COALESCING      (CSR_BASE+0x004) /* accum ints, 32-usec units */
 #define CSR_INT                 (CSR_BASE+0x008) /* host interrupt status/ack */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 237d3b2..a9c30bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -545,9 +545,10 @@ int iwl4965_hw_nic_init(struct iwl4965_priv *priv)
 
 	/* set CSR_HW_CONFIG_REG for uCode use */
 
-	iwl4965_set_bit(priv, CSR_SW_VER, CSR_HW_IF_CONFIG_REG_BIT_KEDRON_R |
-		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
+	iwl4965_set_bit(priv, CSR_HW_IF_CONFIG_REG,
+			CSR_HW_IF_CONFIG_REG_BIT_KEDRON_R |
+			CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
+			CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
 
 	rc = iwl4965_grab_nic_access(priv);
 	if (rc < 0) {
-- 
1.5.3.4

