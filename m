Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757465AbZJ3VgO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/15] iwlwifi: remove power-wasting calls to apm_ops.init()
Date: Fri, 30 Oct 2009 14:36:06 -0700
Message-Id: <1256938578-9638-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

To save power, don't run apm_ops.init() until needed at "up" time.

EEPROM (5000 and earlier devices) may be read without running apm_ops.init(),
but OTP reads (6000 and newer devices) require a powered-up chip.
Therefore, remove apm_ops.init() from the general path in XXXX_pci_probe(),
and call it only if device uses OTP.  Once done with OTP read, call
apm_ops.stop() to reset chip and save power until "up" time comes around.

NOTE:  This patch depends on removal of priv->lock from iwl_apm_stop();
lock does not get initialized until later in flow.  See patch
"remove unneeded locks from apm_stop()".

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 ------
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 -------
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1f60d64..a6dce23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3114,12 +3114,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_iounmap;
 	}
 
-	/* amp init */
-	err = priv->cfg->ops->lib->apm_ops.init(priv);
-	if (err < 0) {
-		IWL_ERR(priv, "Failed to init APMG\n");
-		goto out_iounmap;
-	}
 	/*****************
 	 * 4. Read EEPROM
 	 *****************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 9429cb1..8a0709e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -533,6 +533,10 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 		goto err;
 	}
 	if (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP) {
+
+		/* OTP reads require powered-up chip */
+		priv->cfg->ops->lib->apm_ops.init(priv);
+
 		ret = iwl_init_otp_access(priv);
 		if (ret) {
 			IWL_ERR(priv, "Failed to initialize OTP access.\n");
@@ -563,6 +567,13 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 			e[cache_addr / 2] = eeprom_data;
 			cache_addr += sizeof(u16);
 		}
+
+		/*
+		 * Now that OTP reads are complete, reset chip to save
+		 *   power until we load uCode during "up".
+		 */
+		priv->cfg->ops->lib->apm_ops.stop(priv);
+
 	} else {
 		/* eeprom is an array of 16bit values */
 		for (addr = 0; addr < sz; addr += sizeof(u16)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d63a04d..84dce68 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4001,13 +4001,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 */
 	spin_lock_init(&priv->reg_lock);
 
-	/* amp init */
-	err = priv->cfg->ops->lib->apm_ops.init(priv);
-	if (err < 0) {
-		IWL_DEBUG_INFO(priv, "Failed to init the card\n");
-		goto out_iounmap;
-	}
-
 	/***********************
 	 * 4. Read EEPROM
 	 * ********************/
-- 
1.5.6.3

