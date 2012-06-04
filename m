Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60075 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2FDK6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 06:58:22 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20428.38026.380186.485805@gargle.gargle.HOWL> (sfid-20120604_125825_812162_E40D5C9D)
Date: Mon, 4 Jun 2012 16:27:14 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 02/20] ath9k: Handle ASPM properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ASPM has to be disabled when BTCOEX is in use, do this properly
by calling the bus-specific ASPM init routine after the
BTCOEX scheme has been determined.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |   11 -----------
 drivers/net/wireless/ath/ath9k/init.c |    3 +++
 drivers/net/wireless/ath/ath9k/pci.c  |    5 +++++
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7db1890..febf697 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -390,14 +390,6 @@ static void ath9k_hw_disablepcie(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 }
 
-static void ath9k_hw_aspm_init(struct ath_hw *ah)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if (common->bus_ops->aspm_init)
-		common->bus_ops->aspm_init(common);
-}
-
 /* This should work for all families including legacy */
 static bool ath9k_hw_chip_test(struct ath_hw *ah)
 {
@@ -693,9 +685,6 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (r)
 		return r;
 
-	if (ah->is_pciexpress)
-		ath9k_hw_aspm_init(ah);
-
 	r = ath9k_hw_init_macaddr(ah);
 	if (r) {
 		ath_err(common, "Failed to initialize MAC address\n");
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 3e22839..9dfce1a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -597,6 +597,9 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ath9k_cmn_init_crypto(sc->sc_ah);
 	ath9k_init_misc(sc);
 
+	if (common->bus_ops->aspm_init)
+		common->bus_ops->aspm_init(common);
+
 	return 0;
 
 err_btcoex:
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index a856b51..6ec9f88 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -115,6 +115,9 @@ static void ath_pci_aspm_init(struct ath_common *common)
 	int pos;
 	u8 aspm;
 
+	if (!ah->is_pciexpress)
+		return;
+
 	pos = pci_pcie_cap(pdev);
 	if (!pos)
 		return;
@@ -138,6 +141,7 @@ static void ath_pci_aspm_init(struct ath_common *common)
 		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 		pci_write_config_byte(parent, pos + PCI_EXP_LNKCTL, aspm);
 
+		ath_info(common, "Disabling ASPM since BTCOEX is enabled\n");
 		return;
 	}
 
@@ -147,6 +151,7 @@ static void ath_pci_aspm_init(struct ath_common *common)
 		ah->aspm_enabled = true;
 		/* Initialize PCIe PM and SERDES registers. */
 		ath9k_hw_configpcipowersave(ah, false);
+		ath_info(common, "ASPM enabled: 0x%x\n", aspm);
 	}
 }
 
-- 
1.7.10.3

