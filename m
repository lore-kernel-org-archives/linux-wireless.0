Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab1G2N56 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 09:57:58 -0400
Date: Fri, 29 Jul 2011 15:59:08 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	camilo@mesias.co.uk, Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>
Subject: [PATCH] ath9k: skip ->config_pci_powersave() if PCIe port has ASPM
 disabled
Message-ID: <20110729135908.GC2280@redhat.com> (sfid-20110729_155802_250909_C1D7C28D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We receive many bug reports about system hang during suspend/resume
when ath9k driver is in use. Adrian Chadd remarked that this problem
happens on systems that have ASPM disabled.

To do not hit the bug, skip doing ->config_pci_powersave magic if PCIe
downstream port device, which ath9k device is connected to, has ASPM
disabled.

Bug was introduced by:

commit 53bc7aa08b48e5cd745f986731cc7dc24eef2a9f
Author: Vivek Natarajan <vnatarajan@atheros.com>
Date:   Mon Apr 5 14:48:04 2010 +0530

    ath9k: Add support for newer AR9285 chipsets.

Patch should address:
https://bugzilla.kernel.org/show_bug.cgi?id=37462
https://bugzilla.kernel.org/show_bug.cgi?id=37082
https://bugzilla.redhat.com/show_bug.cgi?id=697157

however I did not receive confirmation about that, except from Camilo
Mesias, whose system stops hang regularly with this patch (but still
hangs from time to time, but this is probably some other bug).

Tested-by: Camilo Mesias <camilo@mesias.co.uk>
Cc: stable@kernel.org # 2.6.35+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |    6 +-----
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    6 +-----
 drivers/net/wireless/ath/ath9k/hw.c        |   11 +++++++++--
 drivers/net/wireless/ath/ath9k/hw.h        |    3 ++-
 drivers/net/wireless/ath/ath9k/pci.c       |   27 +++++++++++++++++++++++++++
 5 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 9ff7c30..44d9d8d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -309,11 +309,7 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 	u8 i;
 	u32 val;
 
-	if (ah->is_pciexpress != true)
-		return;
-
-	/* Do not touch SerDes registers */
-	if (ah->config.pcie_powersave_enable == 2)
+	if (ah->is_pciexpress != true || ah->aspm_enabled != true)
 		return;
 
 	/* Nothing to do on restore for 11N */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 8efdec2..ad2bb2b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -519,11 +519,7 @@ static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
 					 int restore,
 					 int power_off)
 {
-	if (ah->is_pciexpress != true)
-		return;
-
-	/* Do not touch SerDes registers */
-	if (ah->config.pcie_powersave_enable == 2)
+	if (ah->is_pciexpress != true || ah->aspm_enabled != true)
 		return;
 
 	/* Nothing to do on restore for 11N */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8006ce0..8dcefe7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -318,6 +318,14 @@ static void ath9k_hw_disablepcie(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PCIE_SERDES2, 0x00000000);
 }
 
+static void ath9k_hw_aspm_init(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (common->bus_ops->aspm_init)
+		common->bus_ops->aspm_init(common);
+}
+
 /* This should work for all families including legacy */
 static bool ath9k_hw_chip_test(struct ath_hw *ah)
 {
@@ -378,7 +386,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.additional_swba_backoff = 0;
 	ah->config.ack_6mb = 0x0;
 	ah->config.cwm_ignore_extcca = 0;
-	ah->config.pcie_powersave_enable = 0;
 	ah->config.pcie_clock_req = 0;
 	ah->config.pcie_waen = 0;
 	ah->config.analog_shiftreg = 1;
@@ -598,7 +605,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 
 
 	if (ah->is_pciexpress)
-		ath9k_hw_configpcipowersave(ah, 0, 0);
+		ath9k_hw_aspm_init(ah);
 	else
 		ath9k_hw_disablepcie(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6acd0f9..c798890 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -219,7 +219,6 @@ struct ath9k_ops_config {
 	int additional_swba_backoff;
 	int ack_6mb;
 	u32 cwm_ignore_extcca;
-	u8 pcie_powersave_enable;
 	bool pcieSerDesWrite;
 	u8 pcie_clock_req;
 	u32 pcie_waen;
@@ -673,6 +672,7 @@ struct ath_hw {
 
 	bool sw_mgmt_crypto;
 	bool is_pciexpress;
+	bool aspm_enabled;
 	bool is_monitoring;
 	bool need_an_top2_fixup;
 	u16 tx_trig_level;
@@ -874,6 +874,7 @@ struct ath_bus_ops {
 	bool (*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
 	void (*bt_coex_prep)(struct ath_common *common);
 	void (*extn_synch_en)(struct ath_common *common);
+	void (*aspm_init)(struct ath_common *common);
 };
 
 static inline struct ath_common *ath9k_hw_common(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 3bad0b2..be4ea13 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -16,6 +16,7 @@
 
 #include <linux/nl80211.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/ath9k_platform.h>
 #include "ath9k.h"
 
@@ -115,12 +116,38 @@ static void ath_pci_extn_synch_enable(struct ath_common *common)
 	pci_write_config_byte(pdev, sc->sc_ah->caps.pcie_lcr_offset, lnkctl);
 }
 
+static void ath_pci_aspm_init(struct ath_common *common)
+{
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
+	struct ath_hw *ah = sc->sc_ah;
+	struct pci_dev *pdev = to_pci_dev(sc->dev);
+	struct pci_dev *parent;
+	int pos;
+	u8 aspm;
+
+	if (!pci_is_pcie(pdev))
+		return;
+
+	parent = pdev->bus->self;
+	if (WARN_ON(!parent))
+		return;
+
+	pos = pci_pcie_cap(parent);
+	pci_read_config_byte(parent, pos +  PCI_EXP_LNKCTL, &aspm);
+	if (aspm & (PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1)) {
+		ah->aspm_enabled = true;
+		/* Initialize PCIe PM and SERDES registers. */
+		ath9k_hw_configpcipowersave(ah, 0, 0);
+	}
+}
+
 static const struct ath_bus_ops ath_pci_bus_ops = {
 	.ath_bus_type = ATH_PCI,
 	.read_cachesize = ath_pci_read_cachesize,
 	.eeprom_read = ath_pci_eeprom_read,
 	.bt_coex_prep = ath_pci_bt_coex_prep,
 	.extn_synch_en = ath_pci_extn_synch_enable,
+	.aspm_init = ath_pci_aspm_init,
 };
 
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-- 
1.7.1
