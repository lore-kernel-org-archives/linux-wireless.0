Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:30165 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135AbYC1XZe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:25:34 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5/8] iwlwifi: move rate registration to module load
Date: Fri, 28 Mar 2008 16:21:09 -0700
Message-Id: <1206746472-10443-6-git-send-email-reinette.chatre@intel.com> (sfid-20080328_232539_338183_C17EAD5D)
In-Reply-To: <1206746472-10443-5-git-send-email-reinette.chatre@intel.com>
References: <1206746472-10443-1-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-2-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-3-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-4-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having rate registration during module load enables the use of
error checking as well as reliable registration/unregistration
pairing. Previously this was not possible as rate registration
was done during _probe where _probe could be run for more than
one device on the system.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.h  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   23 ++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   22 ++++++++++++++++++----
 7 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 157e572..8559f25 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -976,12 +976,12 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 		       iwl3945_rates[rs_sta->start_rate].plcp);
 }
 
-void iwl3945_rate_control_register(struct ieee80211_hw *hw)
+int iwl3945_rate_control_register(void)
 {
-	ieee80211_rate_control_register(&rs_ops);
+	return ieee80211_rate_control_register(&rs_ops);
 }
 
-void iwl3945_rate_control_unregister(struct ieee80211_hw *hw)
+void iwl3945_rate_control_unregister(void)
 {
 	ieee80211_rate_control_unregister(&rs_ops);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
index e88b1d3..f085d33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
@@ -202,7 +202,7 @@ extern void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
  * ieee80211_register_hw
  *
  */
-extern void iwl3945_rate_control_register(struct ieee80211_hw *hw);
+extern int iwl3945_rate_control_register(void);
 
 /**
  * iwl3945_rate_control_unregister - Unregister the rate control callbacks
@@ -210,6 +210,6 @@ extern void iwl3945_rate_control_register(struct ieee80211_hw *hw);
  * This should be called after calling ieee80211_unregister_hw, but before
  * the driver is unloaded.
  */
-extern void iwl3945_rate_control_unregister(struct ieee80211_hw *hw);
+extern void iwl3945_rate_control_unregister(void);
 
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 735eadd..90ecf26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -2822,12 +2822,12 @@ void iwl4965_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	priv->lq_mngr.lq_ready = 1;
 }
 
-void iwl4965_rate_control_register(struct ieee80211_hw *hw)
+int iwl4965_rate_control_register(void)
 {
-	ieee80211_rate_control_register(&rs_ops);
+	return ieee80211_rate_control_register(&rs_ops);
 }
 
-void iwl4965_rate_control_unregister(struct ieee80211_hw *hw)
+void iwl4965_rate_control_unregister(void)
 {
 	ieee80211_rate_control_unregister(&rs_ops);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
index ae827e1..866e378 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
@@ -288,7 +288,7 @@ extern void iwl4965_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id);
  * ieee80211_register_hw
  *
  */
-extern void iwl4965_rate_control_register(struct ieee80211_hw *hw);
+extern int iwl4965_rate_control_register(void);
 
 /**
  * iwl4965_rate_control_unregister - Unregister the rate control callbacks
@@ -296,6 +296,6 @@ extern void iwl4965_rate_control_register(struct ieee80211_hw *hw);
  * This should be called after calling ieee80211_unregister_hw, but before
  * the driver is unloaded.
  */
-extern void iwl4965_rate_control_unregister(struct ieee80211_hw *hw);
+extern void iwl4965_rate_control_unregister(void);
 
 #endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3ab5d82..add6311 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -177,7 +177,6 @@ static int iwl4965_init_drv(struct iwl_priv *priv)
 		goto err_free_channel_map;
 	}
 
-	iwl4965_rate_control_register(priv->hw);
 	ret = ieee80211_register_hw(priv->hw);
 	if (ret) {
 		IWL_ERROR("Failed to register network device (error %d)\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ed85db7..af7233e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8157,7 +8157,6 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		goto out_free_channel_map;
 	}
 
-	iwl3945_rate_control_register(priv->hw);
 	err = ieee80211_register_hw(priv->hw);
 	if (err) {
 		IWL_ERROR("Failed to register network device (error %d)\n", err);
@@ -8242,7 +8241,6 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 
 	if (priv->mac80211_registered) {
 		ieee80211_unregister_hw(priv->hw);
-		iwl3945_rate_control_unregister(priv->hw);
 	}
 
 	/*netif_stop_queue(dev); */
@@ -8323,21 +8321,35 @@ static int __init iwl3945_init(void)
 	int ret;
 	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION ", " DRV_VERSION "\n");
 	printk(KERN_INFO DRV_NAME ": " DRV_COPYRIGHT "\n");
+
+	ret = iwl3945_rate_control_register();
+	if (ret) {
+		IWL_ERROR("Unable to register rate control algorithm: %d\n", ret);
+		return ret;
+	}
+
 	ret = pci_register_driver(&iwl3945_driver);
 	if (ret) {
 		IWL_ERROR("Unable to initialize PCI module\n");
-		return ret;
+		goto error_register;
 	}
 #ifdef CONFIG_IWL3945_DEBUG
 	ret = driver_create_file(&iwl3945_driver.driver, &driver_attr_debug_level);
 	if (ret) {
 		IWL_ERROR("Unable to create driver sysfs file\n");
-		pci_unregister_driver(&iwl3945_driver);
-		return ret;
+		goto error_debug;
 	}
 #endif
 
 	return ret;
+
+#ifdef CONFIG_IWL3945_DEBUG
+error_debug:
+	pci_unregister_driver(&iwl3945_driver);
+#endif
+error_register:
+	iwl3945_rate_control_unregister();
+	return ret;
 }
 
 static void __exit iwl3945_exit(void)
@@ -8346,6 +8358,7 @@ static void __exit iwl3945_exit(void)
 	driver_remove_file(&iwl3945_driver.driver, &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&iwl3945_driver);
+	iwl3945_rate_control_unregister();
 }
 
 module_param_named(antenna, iwl3945_param_antenna, int, 0444);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7f2dca3..3ea8c7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -8244,7 +8244,6 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 
 	if (priv->mac80211_registered) {
 		ieee80211_unregister_hw(priv->hw);
-		iwl4965_rate_control_unregister(priv->hw);
 	}
 
 	/*netif_stop_queue(dev); */
@@ -8325,21 +8324,35 @@ static int __init iwl4965_init(void)
 	int ret;
 	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION ", " DRV_VERSION "\n");
 	printk(KERN_INFO DRV_NAME ": " DRV_COPYRIGHT "\n");
+
+	ret = iwl4965_rate_control_register();
+	if (ret) {
+		IWL_ERROR("Unable to register rate control algorithm: %d\n", ret);
+		return ret;
+	}
+
 	ret = pci_register_driver(&iwl4965_driver);
 	if (ret) {
 		IWL_ERROR("Unable to initialize PCI module\n");
-		return ret;
+		goto error_register;
 	}
 #ifdef CONFIG_IWLWIFI_DEBUG
 	ret = driver_create_file(&iwl4965_driver.driver, &driver_attr_debug_level);
 	if (ret) {
 		IWL_ERROR("Unable to create driver sysfs file\n");
-		pci_unregister_driver(&iwl4965_driver);
-		return ret;
+		goto error_debug;
 	}
 #endif
 
 	return ret;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+error_debug:
+	pci_unregister_driver(&iwl4965_driver);
+#endif
+error_register:
+	iwl4965_rate_control_unregister();
+	return ret;
 }
 
 static void __exit iwl4965_exit(void)
@@ -8348,6 +8361,7 @@ static void __exit iwl4965_exit(void)
 	driver_remove_file(&iwl4965_driver.driver, &driver_attr_debug_level);
 #endif
 	pci_unregister_driver(&iwl4965_driver);
+	iwl4965_rate_control_unregister();
 }
 
 module_exit(iwl4965_exit);
-- 
1.5.3.4

