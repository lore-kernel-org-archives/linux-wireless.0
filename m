Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761890AbZLJWhV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 17:37:21 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/7 w-t and 2.6.33] iwlwifi: power up all devices for EEPROM read
Date: Thu, 10 Dec 2009 14:37:22 -0800
Message-Id: <1260484647-5114-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
References: <1260484647-5114-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Recent commits "iwlwifi: remove power-wasting calls to apm_ops.init()" and
"iwlagn: power up device before initializing EEPROM" had the goal of
reducing device power consumption from the time the module is loaded until
the interface is brought up and the device's power saving mechanisms kick
in. The idea is that once the module is loaded there is no need for the
device to consume power until the interface is brought up.

With the current solution the device is only powered up during EEPROM read,
and then so also only if the EEPROM type is OTP. We have found that on
certain platforms even non-OTP devices require power to be up during EEPROM
read. On these platforms the driver never loads and the system log contains
the following:

iwlagn 0000:03:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0x080403D8

We thus now power up all devices during EEPROM read.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h    |    8 +++-----
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   14 +++-----------
 2 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index a7bfae0..1ec8cb4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -77,8 +77,7 @@
  * The MAC (uCode processor, etc.) does not need to be powered up for accessing
  * the CSR registers.
  *
- * NOTE:  Newer devices using one-time-programmable (OTP) memory
- *        require device to be awake in order to read this memory
+ * NOTE:  Device does need to be awake in order to read this memory
  *        via CSR_EEPROM and CSR_OTP registers
  */
 #define CSR_BASE    (0x000)
@@ -111,9 +110,8 @@
 /*
  * EEPROM and OTP (one-time-programmable) memory reads
  *
- * NOTE:  For (newer) devices using OTP, device must be awake, initialized via
- *        apm_ops.init() in order to read.  Older devices (3945/4965/5000)
- *        use EEPROM and do not require this.
+ * NOTE:  Device must be awake, initialized via apm_ops.init(),
+ *        in order to read.
  */
 #define CSR_EEPROM_REG          (CSR_BASE+0x02c)
 #define CSR_EEPROM_GP           (CSR_BASE+0x030)
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 3946e5c..72f0d77 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -518,10 +518,7 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 	}
 	e = (u16 *)priv->eeprom;
 
-	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
-		/* OTP reads require powered-up chip */
-		priv->cfg->ops->lib->apm_ops.init(priv);
-	}
+	priv->cfg->ops->lib->apm_ops.init(priv);
 
 	ret = priv->cfg->ops->lib->eeprom_ops.verify_signature(priv);
 	if (ret < 0) {
@@ -570,13 +567,6 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 			e[cache_addr / 2] = eeprom_data;
 			cache_addr += sizeof(u16);
 		}
-
-		/*
-		 * Now that OTP reads are complete, reset chip to save
-		 *   power until we load uCode during "up".
-		 */
-		priv->cfg->ops->lib->apm_ops.stop(priv);
-
 	} else {
 		/* eeprom is an array of 16bit values */
 		for (addr = 0; addr < sz; addr += sizeof(u16)) {
@@ -603,6 +593,8 @@ done:
 err:
 	if (ret)
 		iwl_eeprom_free(priv);
+	/* Reset chip to save power until we load uCode during "up". */
+	priv->cfg->ops->lib->apm_ops.stop(priv);
 alloc_err:
 	return ret;
 }
-- 
1.5.6.3

