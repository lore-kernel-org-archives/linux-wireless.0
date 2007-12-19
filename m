Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51450 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXLSGIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 01:08:44 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH wireless-2.6] iwlwifi: fix possible priv->mutex deadlock during suspend
Date: Wed, 19 Dec 2007 14:03:55 +0800
Message-Id: <1198044235-23889-1-git-send-email-yi.zhu@intel.com> (sfid-20071219_060853_540476_55C23F85)
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
index 88cf035..f0303e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6355,8 +6355,6 @@ static void __iwl3945_down(struct iwl3945_priv *priv)
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
 
-	iwl3945_cancel_deferred_work(priv);
-
 	/* Wipe out the EXIT_PENDING status bit if we are not actually
 	 * exiting the module */
 	if (!exit_pending)
@@ -6431,6 +6429,8 @@ static void iwl3945_down(struct iwl3945_priv *priv)
 	mutex_lock(&priv->mutex);
 	__iwl3945_down(priv);
 	mutex_unlock(&priv->mutex);
+
+	iwl3945_cancel_deferred_work(priv);
 }
 
 #define MAX_HW_RESTARTS 5
@@ -8739,10 +8739,9 @@ static void iwl3945_pci_remove(struct pci_dev *pdev)
 
 	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
 
-	mutex_lock(&priv->mutex);
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
-	__iwl3945_down(priv);
-	mutex_unlock(&priv->mutex);
+
+	iwl3945_down(priv);
 
 	/* Free MAC hash list for ADHOC */
 	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++) {
@@ -8801,12 +8800,10 @@ static int iwl3945_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
 
-	mutex_lock(&priv->mutex);
-
 	set_bit(STATUS_IN_SUSPEND, &priv->status);
 
 	/* Take down the device; powers it off, etc. */
-	__iwl3945_down(priv);
+	iwl3945_down(priv);
 
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
@@ -8815,8 +8812,6 @@ static int iwl3945_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
-	mutex_unlock(&priv->mutex);
-
 	return 0;
 }
 
@@ -8874,8 +8869,6 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
 
 	printk(KERN_INFO "Coming out of suspend...\n");
 
-	mutex_lock(&priv->mutex);
-
 	pci_set_power_state(pdev, PCI_D0);
 	err = pci_enable_device(pdev);
 	pci_restore_state(pdev);
@@ -8889,7 +8882,6 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
 	pci_write_config_byte(pdev, 0x41, 0x00);
 
 	iwl3945_resume(priv);
-	mutex_unlock(&priv->mutex);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index df6f3b1..87cc281 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -6767,8 +6767,6 @@ static void __iwl4965_down(struct iwl4965_priv *priv)
 	/* Unblock any waiting calls */
 	wake_up_interruptible_all(&priv->wait_command_queue);
 
-	iwl4965_cancel_deferred_work(priv);
-
 	/* Wipe out the EXIT_PENDING status bit if we are not actually
 	 * exiting the module */
 	if (!exit_pending)
@@ -6844,6 +6842,8 @@ static void iwl4965_down(struct iwl4965_priv *priv)
 	mutex_lock(&priv->mutex);
 	__iwl4965_down(priv);
 	mutex_unlock(&priv->mutex);
+
+	iwl4965_cancel_deferred_work(priv);
 }
 
 #define MAX_HW_RESTARTS 5
@@ -9308,10 +9308,9 @@ static void iwl4965_pci_remove(struct pci_dev *pdev)
 
 	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
 
-	mutex_lock(&priv->mutex);
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
-	__iwl4965_down(priv);
-	mutex_unlock(&priv->mutex);
+
+	iwl4965_down(priv);
 
 	/* Free MAC hash list for ADHOC */
 	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++) {
@@ -9370,12 +9369,10 @@ static int iwl4965_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct iwl4965_priv *priv = pci_get_drvdata(pdev);
 
-	mutex_lock(&priv->mutex);
-
 	set_bit(STATUS_IN_SUSPEND, &priv->status);
 
 	/* Take down the device; powers it off, etc. */
-	__iwl4965_down(priv);
+	iwl4965_down(priv);
 
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
@@ -9384,8 +9381,6 @@ static int iwl4965_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	pci_disable_device(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 
-	mutex_unlock(&priv->mutex);
-
 	return 0;
 }
 
@@ -9443,8 +9438,6 @@ static int iwl4965_pci_resume(struct pci_dev *pdev)
 
 	printk(KERN_INFO "Coming out of suspend...\n");
 
-	mutex_lock(&priv->mutex);
-
 	pci_set_power_state(pdev, PCI_D0);
 	err = pci_enable_device(pdev);
 	pci_restore_state(pdev);
@@ -9458,7 +9451,6 @@ static int iwl4965_pci_resume(struct pci_dev *pdev)
 	pci_write_config_byte(pdev, 0x41, 0x00);
 
 	iwl4965_resume(priv);
-	mutex_unlock(&priv->mutex);
 
 	return 0;
 }
-- 
1.5.3.6

