Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab1HELLb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 07:11:31 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	<lrodriguez@atheros.com>
Subject: [PATCH -next 8/8] ath9k: be prepare for dynamic ASPM settings change
Date: Fri,  5 Aug 2011 13:10:39 +0200
Message-Id: <1312542639-4274-9-git-send-email-sgruszka@redhat.com> (sfid-20110805_131134_292523_FEBFA88A)
In-Reply-To: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
References: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
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
 drivers/net/wireless/ath/ath9k/main.c   |    3 +-
 drivers/net/wireless/ath/ath9k/pci.c    |   38 +++++++++++++++++++++++++++++++
 4 files changed, 42 insertions(+), 1 deletions(-)

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
index f28f339..cb388ff 100644
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
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b0389c3..a7e3c5c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1065,6 +1065,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	init_channel = ath9k_cmn_get_curchannel(hw, ah);
 
+	spin_lock_bh(&sc->sc_pcu_lock);
+
 	/* Reset SERDES registers */
 	ath9k_hw_configpcipowersave(ah, false);
 
@@ -1075,7 +1077,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * be followed by initialization of the appropriate bits
 	 * and then setup of the interrupt mask.
 	 */
-	spin_lock_bh(&sc->sc_pcu_lock);
 	r = ath9k_hw_reset(ah, init_channel, ah->caldata, false);
 	if (r) {
 		ath_err(common,
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 67a2c96..c585180 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -285,6 +285,41 @@ static void ath_pci_remove(struct pci_dev *pdev)
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
+		if (ah->power_off == false) {
+			/*
+			 * Device is enabled, but since we disable ASPM we also
+			 * setup PCIe PM registers in off state.
+			 */
+			ath9k_hw_configpcipowersave(ah, true);
+			/* But track real power_off value. */
+			ah->power_off = false;
+		}
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
@@ -364,6 +399,9 @@ static struct pci_driver ath_pci_driver = {
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

