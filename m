Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49061 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbZBJT7I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 14:59:08 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2.6.29] iwlwifi: fix suspend/resume and its usage of pci saved state
Date: Tue, 10 Feb 2009 12:02:49 -0800
Message-Id: <1234296169-3964-1-git-send-email-reinette.chatre@intel.com> (sfid-20090210_205914_678635_1DE88EA6)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here we do two things:

First, revert the following patch entirely:

commit c4e061ace75513aee227090486cc46dec7810c00
Author: Reinette Chatre <reinette.chatre@intel.com>
Date:   Tue Feb 3 10:20:03 2009 -0800

    iwlwifi: save PCI state before suspend, restore after resume

Next, indicate to PCI driver that the saved PCI state is valid during suspend.

We restore PCI state and enable the device when network interface is created,
similarly PCI state is saved and the device is disabled when network interface
is removed. Thus, when .suspend is called the PCI state is saved and device
is disabled. This is the case even if an interface is never created as PCI
state is saved and device disabled during .probe.

PCI driver assumes PCI state is saved in .suspend. Saving the state at this
time will save state of disabled device and thus cause problems during
resume (resuming a disabled device). We thus indicate directly to PCI
driver that current PCI saved state is valid.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Alex Riesen <fork0@users.sf.net>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   15 +++++++++++++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   15 +++++++++++++--
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c01ea48..36bafeb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4042,7 +4042,19 @@ static int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		priv->is_open = 1;
 	}
 
-	pci_save_state(pdev);
+	/* pci driver assumes state will be saved in this function.
+	 * pci state is saved and device disabled when interface is
+	 * stopped, so at this time pci device will always be disabled -
+	 * whether interface was started or not. saving pci state now will
+	 * cause saved state be that of a disabled device, which will cause
+	 * problems during resume in that we will end up with a disabled device.
+	 *
+	 * indicate that the current saved state (from when interface was
+	 * stopped) is valid. if interface was never up at time of suspend
+	 * then the saved state will still be valid as it was saved during
+	 * .probe. */
+	pdev->state_saved = true;
+
 	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
@@ -4053,7 +4065,6 @@ static int iwl_pci_resume(struct pci_dev *pdev)
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
 
 	if (priv->is_open)
 		iwl_mac_start(priv->hw);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5b44d32..93be74a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8143,7 +8143,19 @@ static int iwl3945_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		priv->is_open = 1;
 	}
 
-	pci_save_state(pdev);
+	/* pci driver assumes state will be saved in this function.
+	 * pci state is saved and device disabled when interface is
+	 * stopped, so at this time pci device will always be disabled -
+	 * whether interface was started or not. saving pci state now will
+	 * cause saved state be that of a disabled device, which will cause
+	 * problems during resume in that we will end up with a disabled device.
+	 *
+	 * indicate that the current saved state (from when interface was
+	 * stopped) is valid. if interface was never up at time of suspend
+	 * then the saved state will still be valid as it was saved during
+	 * .probe. */
+	pdev->state_saved = true;
+
 	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
@@ -8154,7 +8166,6 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
 	struct iwl3945_priv *priv = pci_get_drvdata(pdev);
 
 	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
 
 	if (priv->is_open)
 		iwl3945_mac_start(priv->hw);
-- 
1.5.4.3

