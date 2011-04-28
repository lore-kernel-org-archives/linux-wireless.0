Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758344Ab1D1Jwl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 05:52:41 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 02/10] iwlegacy: enable only rfkill interrupt when device is down
Date: Thu, 28 Apr 2011 11:51:25 +0200
Message-Id: <1303984293-6601-2-git-send-email-sgruszka@redhat.com> (sfid-20110428_115258_541546_A3E89F83)
In-Reply-To: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
References: <1303984293-6601-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add two below iwlwifi commits to iwlegacy:

commit 554d1d027b19265c4aa3f718b3126d2b86e09a08
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Thu Dec 23 12:38:21 2010 +0100

    iwlagn: enable only rfkill interrupt when device is down

commit 3dd823e6b86407aed1a025041d8f1df77e43a9c8
Author: Don Fry <donald.h.fry@intel.com>
Date:   Sun Feb 6 09:29:45 2011 -0800

    iwlagn: Re-enable RF_KILL interrupt when down

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-helpers.h  |    6 ++++++
 drivers/net/wireless/iwlegacy/iwl4965-base.c |   12 ++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-helpers.h b/drivers/net/wireless/iwlegacy/iwl-helpers.h
index 02132e7..a6effda 100644
--- a/drivers/net/wireless/iwlegacy/iwl-helpers.h
+++ b/drivers/net/wireless/iwlegacy/iwl-helpers.h
@@ -149,6 +149,12 @@ static inline void iwl_legacy_disable_interrupts(struct iwl_priv *priv)
 	IWL_DEBUG_ISR(priv, "Disabled interrupts\n");
 }
 
+static inline void iwl_legacy_enable_rfkill_int(struct iwl_priv *priv)
+{
+	IWL_DEBUG_ISR(priv, "Enabling rfkill interrupt\n");
+	iwl_write32(priv, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+}
+
 static inline void iwl_legacy_enable_interrupts(struct iwl_priv *priv)
 {
 	IWL_DEBUG_ISR(priv, "Enabling interrupts\n");
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 644bf31..46966e9 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -1072,6 +1072,9 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 	/* only Re-enable if diabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_legacy_enable_interrupts(priv);
+	/* Re-enable RF_KILL if it occurred */
+	else if (handled & CSR_INT_BIT_RF_KILL)
+		iwl_legacy_enable_rfkill_int(priv);
 
 #ifdef CONFIG_IWLWIFI_LEGACY_DEBUG
 	if (iwl_legacy_get_debug_level(priv) & (IWL_DL_ISR)) {
@@ -2624,9 +2627,10 @@ void iwl4965_mac_stop(struct ieee80211_hw *hw)
 
 	flush_workqueue(priv->workqueue);
 
-	/* enable interrupts again in order to receive rfkill changes */
+	/* User space software may expect getting rfkill changes
+	 * even if interface is down */
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl_legacy_enable_interrupts(priv);
+	iwl_legacy_enable_rfkill_int(priv);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
@@ -3406,14 +3410,14 @@ iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * 8. Enable interrupts and read RFKILL state
 	 *********************************************/
 
-	/* enable interrupts if needed: hw bug w/a */
+	/* enable rfkill interrupt: hw bug w/a */
 	pci_read_config_word(priv->pci_dev, PCI_COMMAND, &pci_cmd);
 	if (pci_cmd & PCI_COMMAND_INTX_DISABLE) {
 		pci_cmd &= ~PCI_COMMAND_INTX_DISABLE;
 		pci_write_config_word(priv->pci_dev, PCI_COMMAND, pci_cmd);
 	}
 
-	iwl_legacy_enable_interrupts(priv);
+	iwl_legacy_enable_rfkill_int(priv);
 
 	/* If platform's RF_KILL switch is NOT set to KILL */
 	if (iwl_read32(priv, CSR_GP_CNTRL) &
-- 
1.7.1

