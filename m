Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab1G0MOD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 08:14:03 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC/RFT v2 11/12] ath9k: be prepare for dynamic ASPM settings change
Date: Wed, 27 Jul 2011 14:14:58 +0200
Message-Id: <1311768899-4559-12-git-send-email-sgruszka@redhat.com> (sfid-20110727_141413_783386_71A77F1A)
In-Reply-To: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
References: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kernel offer possibility to change ASPM settings using
/sys/module/pcie_aspm/parameters/policy interface. As settings can be
changed, we also need to change ath9k hw registers. Patch implement
this by monitoring power_off state, and based on that state setup
register when pci core inform us about ASPM change.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/hw-ops.h |    1 +
 drivers/net/wireless/ath/ath9k/hw.h     |    1 +
 drivers/net/wireless/ath/ath9k/pci.c    |   31 +++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index dd9003e..0743e82 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -24,6 +24,7 @@
 static inline void ath9k_hw_configpcipowersave(struct ath_hw *ah,
 					       bool power_off)
 {
+	ah->power_off = power_off;
 	if (ah->aspm_enabled != true)
 		return;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6abf26d..eb736ca 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -672,6 +672,7 @@ struct ath_hw {
 	bool sw_mgmt_crypto;
 	bool is_pciexpress;
 	bool aspm_enabled;
+	bool power_off;
 	bool is_monitoring;
 	bool need_an_top2_fixup;
 	u16 tx_trig_level;
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index a92e55f..c46920b 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -286,6 +286,34 @@ static void ath_pci_remove(struct pci_dev *pdev)
 	pci_release_region(pdev, 0);
 }
 
+#ifdef CONFIG_PCIEASPM
+
+static void ath_pci_aspm_changed(struct pci_dev *pdev, u32 state)
+{
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->sc_ah;
+
+	spin_lock_irq(&sc->sc_pcu_lock);
+
+	/*
+	 * ASPM settings were changed, we have to configure PCIe PM and SERDES
+	 * registers based on current state of device and new ASPM settings.
+	 */
+	if (state & (PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1)) {
+		ah->aspm_enabled = true;
+		ath9k_hw_configpcipowersave(ah, ah->power_off);
+	} else {
+		if (!ah->power_off)
+			ath9k_hw_configpcipowersave(ah, true);
+		ah->aspm_enabled = false;
+	}
+
+	spin_unlock_irq(&sc->sc_pcu_lock);
+}
+
+#endif
+
 #ifdef CONFIG_PM
 
 static int ath_pci_suspend(struct device *device)
@@ -365,6 +393,9 @@ static struct pci_driver ath_pci_driver = {
 	.id_table   = ath_pci_id_table,
 	.probe      = ath_pci_probe,
 	.remove     = ath_pci_remove,
+#ifdef CONFIG_PCIEASPM
+	.aspm_changed = ath_pci_aspm_changed,
+#endif
 	.driver.pm  = ATH9K_PM_OPS,
 };
 
-- 
1.7.1

