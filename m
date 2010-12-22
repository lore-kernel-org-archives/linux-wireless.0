Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab0LVNBt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 08:01:49 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlagn: only enable rfkill interrupt when device is down
Date: Wed, 22 Dec 2010 14:01:53 +0100
Message-Id: <1293022913-4692-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit 6cd0b1cb872b3bf9fc5de4536404206ab74bafdd "iwlagn: fix
hw-rfkill while the interface is down", we enable interrupts when
device is not ready to receive them. However hardware, when it is in
some inconsistent state, can generate other than rfkill interrupts
and crash the system. I can reproduce crash with "kernel BUG at
drivers/net/wireless/iwlwifi/iwl-agn.c:1010!" message, when forcing
firmware restarts.

To fix only enable rfkill interrupt when down device and after probe.
I checked patch on laptop with 5100 device, rfkill change is still
passed to user space when device is down.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: stable@kernel.org
---
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    9 +++++----
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    6 ++++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d407547..f5bd584 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3280,9 +3280,10 @@ void iwlagn_mac_stop(struct ieee80211_hw *hw)
 
 	flush_workqueue(priv->workqueue);
 
-	/* enable interrupts again in order to receive rfkill changes */
+	/* User space software may expect getting rfkill changes
+	 * even if interface is down */
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl_enable_interrupts(priv);
+	iwl_enable_rfkill_int(priv);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
@@ -4190,14 +4191,14 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * 8. Enable interrupts and read RFKILL state
 	 *********************************************/
 
-	/* enable interrupts if needed: hw bug w/a */
+	/* enable rfkill interrupt: hw bug w/a */
 	pci_read_config_word(priv->pci_dev, PCI_COMMAND, &pci_cmd);
 	if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
 		pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
 		pci_write_config_word(priv->pci_dev, PCI_COMMAND, pci_cmd);
 	}
 
-	iwl_enable_interrupts(priv);
+	iwl_enable_rfkill_int(priv);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 3f5bedd..8821f08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -148,6 +148,12 @@ static inline void iwl_disable_interrupts(struct iwl_priv *priv)
 	IWL_DEBUG_ISR(priv, "Disabled interrupts\n");
 }
 
+static inline void iwl_enable_rfkill_int(struct iwl_priv *priv)
+{
+	IWL_DEBUG_ISR(priv, "Enabling rfkill interrupt\n");
+	iwl_write32(priv, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+}
+
 static inline void iwl_enable_interrupts(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR(priv, "Enabling interrupts\n");
-- 
1.7.1

