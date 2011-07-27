Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab1G0MOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 08:14:06 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC/RFT v2 12/12] ath9k: fix initialization ordering issues
Date: Wed, 27 Jul 2011 14:14:59 +0200
Message-Id: <1311768899-4559-13-git-send-email-sgruszka@redhat.com> (sfid-20110727_141419_102482_837CDE12)
In-Reply-To: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
References: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should initialize registers before ieee80211_register_hw(). For
non RFC posting, this patch will be merged with previous patch
"ath9k: do btcoex ASPM disabling at initialization time"

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   11 +++++++++++
 drivers/net/wireless/ath/ath9k/hw.h  |    1 +
 drivers/net/wireless/ath/ath9k/pci.c |   23 ++++++++++-------------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7084bb5..71cfe1a 100644
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
@@ -610,6 +618,9 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	if (r)
 		return r;
 
+	if (ah->is_pciexpress)
+		ath9k_hw_aspm_init(ah);
+
 	r = ath9k_hw_init_macaddr(ah);
 	if (r) {
 		ath_err(common, "Failed to initialize MAC address\n");
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index eb736ca..ffa907a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -873,6 +873,7 @@ struct ath_bus_ops {
 	void (*read_cachesize)(struct ath_common *common, int *csz);
 	bool (*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
 	void (*extn_synch_en)(struct ath_common *common);
+	void (*aspm_init)(struct ath_common *common);
 };
 
 static inline struct ath_common *ath9k_hw_common(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index c46920b..df18f52 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -99,23 +99,15 @@ static void ath_pci_extn_synch_enable(struct ath_common *common)
 	pci_write_config_byte(pdev, sc->sc_ah->caps.pcie_lcr_offset, lnkctl);
 }
 
-static const struct ath_bus_ops ath_pci_bus_ops = {
-	.ath_bus_type = ATH_PCI,
-	.read_cachesize = ath_pci_read_cachesize,
-	.eeprom_read = ath_pci_eeprom_read,
-	.extn_synch_en = ath_pci_extn_synch_enable,
-};
-
-static void ath_pci_aspm_init(struct ath_softc *sc)
+static void ath_pci_aspm_init(struct ath_common *common)
 {
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct pci_dev *pdev = to_pci_dev(sc->dev);
 	struct pci_dev *parent;
 	int pos;
 	u8 aspm;
 
-	ah->aspm_enabled = false;
-
 	if (!pci_is_pcie(pdev))
 		return;
 
@@ -138,6 +130,14 @@ static void ath_pci_aspm_init(struct ath_softc *sc)
 	}
 }
 
+static const struct ath_bus_ops ath_pci_bus_ops = {
+	.ath_bus_type	= ATH_PCI,
+	.read_cachesize	= ath_pci_read_cachesize,
+	.eeprom_read	= ath_pci_eeprom_read,
+	.extn_synch_en	= ath_pci_extn_synch_enable,
+	.aspm_init	= ath_pci_aspm_init
+};
+
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	void __iomem *mem;
@@ -245,9 +245,6 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_init;
 	}
 
-	/* Need to be called after we discover hw capabilities */
-	ath_pci_aspm_init(sc);
-
 	ath9k_hw_name(sc->sc_ah, hw_name, sizeof(hw_name));
 	wiphy_info(hw->wiphy, "%s mem=0x%lx, irq=%d\n",
 		   hw_name, (unsigned long)mem, pdev->irq);
-- 
1.7.1

