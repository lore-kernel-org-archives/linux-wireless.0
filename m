Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab1HELLR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 07:11:17 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	<lrodriguez@atheros.com>
Subject: [PATCH -next 3/8] ath9k: do btcoex ASPM disabling at initialization time
Date: Fri,  5 Aug 2011 13:10:34 +0200
Message-Id: <1312542639-4274-4-git-send-email-sgruszka@redhat.com> (sfid-20110805_131119_565337_29F82F51)
In-Reply-To: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
References: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable ASPM in pci ->probe on upstream (device) and downstream
(PCIe port) component. According to e1000e driver authors this is
required. I did not find that requirement in PCIe spec, but it seems
to be logical for me.

This need to be fixed for CONFIG_PCIEASPM, that will be done later ...

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    8 +++---
 drivers/net/wireless/ath/ath9k/hw.h   |    4 ---
 drivers/net/wireless/ath/ath9k/main.c |    2 -
 drivers/net/wireless/ath/ath9k/pci.c  |   44 ++++++++++++++++++--------------
 4 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8dcefe7..71cfe1a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -603,10 +603,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 
 	ath9k_hw_init_mode_regs(ah);
 
-
-	if (ah->is_pciexpress)
-		ath9k_hw_aspm_init(ah);
-	else
+	if (!ah->is_pciexpress)
 		ath9k_hw_disablepcie(ah);
 
 	if (!AR_SREV_9300_20_OR_LATER(ah))
@@ -621,6 +618,9 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (r)
 		return r;
 
+	if (ah->is_pciexpress)
+		ath9k_hw_aspm_init(ah);
+
 	r = ath9k_hw_init_macaddr(ah);
 	if (r) {
 		ath_err(common, "Failed to initialize MAC address\n");
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a26a8c5..f28f339 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1029,10 +1029,6 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
 void ath9k_hw_proc_mib_event(struct ath_hw *ah);
 void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan);
 
-#define ATH_PCIE_CAP_LINK_CTRL	0x70
-#define ATH_PCIE_CAP_LINK_L0S	1
-#define ATH_PCIE_CAP_LINK_L1	2
-
 #define ATH9K_CLOCK_RATE_CCK		22
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 651f633..b0389c3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1141,8 +1141,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
 					   AR_STOMP_LOW_WLAN_WGHT);
 		ath9k_hw_btcoex_enable(ah);
 
-		if (common->bus_ops->bt_coex_prep)
-			common->bus_ops->bt_coex_prep(common);
 		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_resume(sc);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 8256e97..7d94b64 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -89,23 +89,6 @@ static bool ath_pci_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 	return true;
 }
 
-/*
- * Bluetooth coexistance requires disabling ASPM.
- */
-static void ath_pci_bt_coex_prep(struct ath_common *common)
-{
-	struct ath_softc *sc = (struct ath_softc *) common->priv;
-	struct pci_dev *pdev = to_pci_dev(sc->dev);
-	u8 aspm;
-
-	if (!pci_is_pcie(pdev))
-		return;
-
-	pci_read_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, &aspm);
-	aspm &= ~(ATH_PCIE_CAP_LINK_L0S | ATH_PCIE_CAP_LINK_L1);
-	pci_write_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, aspm);
-}
-
 static void ath_pci_extn_synch_enable(struct ath_common *common)
 {
 	struct ath_softc *sc = (struct ath_softc *) common->priv;
@@ -117,6 +100,7 @@ static void ath_pci_extn_synch_enable(struct ath_common *common)
 	pci_write_config_byte(pdev, sc->sc_ah->caps.pcie_lcr_offset, lnkctl);
 }
 
+/* Need to be called after we discover btcoex capabilities */
 static void ath_pci_aspm_init(struct ath_common *common)
 {
 	struct ath_softc *sc = (struct ath_softc *) common->priv;
@@ -126,10 +110,33 @@ static void ath_pci_aspm_init(struct ath_common *common)
 	int pos;
 	u8 aspm;
 
-	if (!pci_is_pcie(pdev))
+	pos = pci_pcie_cap(pdev);
+	if (!pos)
 		return;
 
 	parent = pdev->bus->self;
+
+	if (ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) {
+		/* Bluetooth coexistance requires disabling ASPM. */
+		pci_read_config_byte(pdev, pos + PCI_EXP_LNKCTL, &aspm);
+		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
+		pci_write_config_byte(pdev, pos + PCI_EXP_LNKCTL, aspm);
+
+		/*
+		 * Both upstream and downstream PCIe components should
+		 * have the same ASPM settings.
+		 */
+		if (WARN_ON(!parent))
+			return;
+
+		pos = pci_pcie_cap(parent);
+		pci_read_config_byte(parent, pos + PCI_EXP_LNKCTL, &aspm);
+		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
+		pci_write_config_byte(parent, pos + PCI_EXP_LNKCTL, aspm);
+
+		return;
+	}
+
 	if (WARN_ON(!parent))
 		return;
 
@@ -146,7 +153,6 @@ static const struct ath_bus_ops ath_pci_bus_ops = {
 	.ath_bus_type = ATH_PCI,
 	.read_cachesize = ath_pci_read_cachesize,
 	.eeprom_read = ath_pci_eeprom_read,
-	.bt_coex_prep = ath_pci_bt_coex_prep,
 	.extn_synch_en = ath_pci_extn_synch_enable,
 	.aspm_init = ath_pci_aspm_init,
 };
-- 
1.7.1

