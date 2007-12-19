Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48759 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbXLSF7t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 00:59:49 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] iwlwifi: fix possible priv->mutex deadlock during suspend
Date: Wed, 19 Dec 2007 13:59:52 +0800
Message-Id: <1198043992-23821-1-git-send-email-yi.zhu@intel.com> (sfid-20071219_055952_961461_0F4CDEE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves _cancel_deferred_work out of mutex protection and removes
unnecessary mutex in pci_suspend and pci_resume.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   18 +++++-------------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   18 +++++-------------
 2 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3d1da07..1a6b0e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6246,8 +6246,6 @@ static void __iwl_down(struct iwl_priv *priv)
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
 
-	iwl_cancel_deferred_work(priv);
-
 	/* Wipe out the EXIT_PENDING status bit if we are not actually
 	 * exiting the module */
 	if (!exit_pending)
@@ -6322,6 +6320,8 @@ static void iwl_down(struct iwl_priv *priv)
 	mutex_lock(&priv->mutex);
 	__iwl_down(priv);
 	mutex_unlock(&priv->mutex);
+
+	iwl_cancel_deferred_work(priv);
 }
 
 #define MAX_HW_RESTARTS 5
@@ -8580,10 +8580,9 @@ static void iwl_pci_remove(struct pci_dev *pdev)
 
 	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
 
-	mutex_lock(&priv->mutex);
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
-	__iwl_down(priv);
-	mutex_unlock(&priv->mutex);
+
+	iwl_down(priv);
 
 	/* Free MAC hash list for ADHOC */
 	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++) {
@@ -8642,12 +8641,10 @@ static int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
-	mutex_lock(&priv->mutex);
-
 	set_bit(STATUS_IN_SUSPEND, &priv->status);
 
 	/* Take down the device; powers it off, etc. */
-	__iwl_down(priv);
+	iwl_down(priv);
 
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
@@ -8656,8 +8653,6 @@ static int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
-	mutex_unlock(&priv->mutex);
-
 	return 0;
 }
 
@@ -8715,8 +8710,6 @@ static int iwl_pci_resume(struct pci_dev *pdev)
 
 	printk(KERN_INFO "Coming out of suspend...\n");
 
-	mutex_lock(&priv->mutex);
-
 	pci_set_power_state(pdev, PCI_D0);
 	err = pci_enable_device(pdev);
 	pci_restore_state(pdev);
@@ -8730,7 +8723,6 @@ static int iwl_pci_resume(struct pci_dev *pdev)
 	pci_write_config_byte(pdev, 0x41, 0x00);
 
 	iwl_resume(priv);
-	mutex_unlock(&priv->mutex);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index b54fe5e..6cd57c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6601,8 +6601,6 @@ static void __iwl_down(struct iwl_priv *priv)
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
 
-	iwl_cancel_deferred_work(priv);
-
 	/* Wipe out the EXIT_PENDING status bit if we are not actually
 	 * exiting the module */
 	if (!exit_pending)
@@ -6677,6 +6675,8 @@ static void iwl_down(struct iwl_priv *priv)
 	mutex_lock(&priv->mutex);
 	__iwl_down(priv);
 	mutex_unlock(&priv->mutex);
+
+	iwl_cancel_deferred_work(priv);
 }
 
 #define MAX_HW_RESTARTS 5
@@ -9174,10 +9174,9 @@ static void iwl_pci_remove(struct pci_dev *pdev)
 
 	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
 
-	mutex_lock(&priv->mutex);
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
-	__iwl_down(priv);
-	mutex_unlock(&priv->mutex);
+
+	iwl_down(priv);
 
 	/* Free MAC hash list for ADHOC */
 	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++) {
@@ -9236,12 +9235,10 @@ static int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
-	mutex_lock(&priv->mutex);
-
 	set_bit(STATUS_IN_SUSPEND, &priv->status);
 
 	/* Take down the device; powers it off, etc. */
-	__iwl_down(priv);
+	iwl_down(priv);
 
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
@@ -9250,8 +9247,6 @@ static int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
-	mutex_unlock(&priv->mutex);
-
 	return 0;
 }
 
@@ -9309,8 +9304,6 @@ static int iwl_pci_resume(struct pci_dev *pdev)
 
 	printk(KERN_INFO "Coming out of suspend...\n");
 
-	mutex_lock(&priv->mutex);
-
 	pci_set_power_state(pdev, PCI_D0);
 	err = pci_enable_device(pdev);
 	pci_restore_state(pdev);
@@ -9324,7 +9317,6 @@ static int iwl_pci_resume(struct pci_dev *pdev)
 	pci_write_config_byte(pdev, 0x41, 0x00);
 
 	iwl_resume(priv);
-	mutex_unlock(&priv->mutex);
 
 	return 0;
 }
-- 
1.5.3.6

