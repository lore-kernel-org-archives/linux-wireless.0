Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58878 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600AbZLNWMU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 17:12:20 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/6] iwlwifi: initialize spinlock before use
Date: Mon, 14 Dec 2009 14:12:11 -0800
Message-Id: <1260828733-22726-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260828733-22726-1-git-send-email-reinette.chatre@intel.com>
References: <1260828733-22726-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Recent powersaving work resulted in power management ops being called
during EEPROM initialization. The lock used by these functions is not
initialized at this time. Ensure lock is initialized before it is used.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 715db21..1c9866d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3173,7 +3173,6 @@ static int iwl_init_drv(struct iwl_priv *priv)
 
 	priv->ibss_beacon = NULL;
 
-	spin_lock_init(&priv->lock);
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
 
@@ -3361,10 +3360,11 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		(unsigned long long) pci_resource_len(pdev, 0));
 	IWL_DEBUG_INFO(priv, "pci_resource_base = %p\n", priv->hw_base);
 
-	/* this spin lock will be used in apm_ops.init and EEPROM access
+	/* these spin locks will be used in apm_ops.init and EEPROM access
 	 * we should init now
 	 */
 	spin_lock_init(&priv->reg_lock);
+	spin_lock_init(&priv->lock);
 	iwl_hw_detect(priv);
 	IWL_INFO(priv, "Detected Intel Wireless WiFi Link %s REV=0x%X\n",
 		priv->cfg->name, priv->hw_rev);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c322d6c..96b23f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3863,7 +3863,6 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->retry_rate = 1;
 	priv->ibss_beacon = NULL;
 
-	spin_lock_init(&priv->lock);
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
 
@@ -4055,10 +4054,11 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	 * PCI Tx retries from interfering with C3 CPU state */
 	pci_write_config_byte(pdev, 0x41, 0x00);
 
-	/* this spin lock will be used in apm_ops.init and EEPROM access
+	/* these spin locks will be used in apm_ops.init and EEPROM access
 	 * we should init now
 	 */
 	spin_lock_init(&priv->reg_lock);
+	spin_lock_init(&priv->lock);
 
 	/***********************
 	 * 4. Read EEPROM
-- 
1.5.6.3

