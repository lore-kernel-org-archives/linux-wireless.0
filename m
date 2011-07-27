Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab1G0MNw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 08:13:52 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC/RFT v2 04/12] ath9k: use common PCIe ASPM definces instead of custom ones
Date: Wed, 27 Jul 2011 14:14:51 +0200
Message-Id: <1311768899-4559-5-git-send-email-sgruszka@redhat.com> (sfid-20110727_141402_446637_8EAADDC7)
In-Reply-To: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
References: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/hw.h  |    4 ----
 drivers/net/wireless/ath/ath9k/pci.c |   17 +++++++++++------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 2f25577..3f941f0 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1028,10 +1028,6 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning);
 void ath9k_hw_proc_mib_event(struct ath_hw *ah);
 void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan);
 
-#define ATH_PCIE_CAP_LINK_CTRL	0x70
-#define ATH_PCIE_CAP_LINK_L0S	1
-#define ATH_PCIE_CAP_LINK_L1	2
-
 #define ATH9K_CLOCK_RATE_CCK		22
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 480e25b..edf7052 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -16,6 +16,7 @@
 
 #include <linux/nl80211.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/ath9k_platform.h>
 #include "ath9k.h"
 
@@ -94,14 +95,16 @@ static void ath_pci_bt_coex_prep(struct ath_common *common)
 {
 	struct ath_softc *sc = (struct ath_softc *) common->priv;
 	struct pci_dev *pdev = to_pci_dev(sc->dev);
+	int pos;
 	u8 aspm;
 
-	if (!pci_is_pcie(pdev))
+	pos = pci_pcie_cap(pdev);
+	if (!pos)
 		return;
 
-	pci_read_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, &aspm);
-	aspm &= ~(ATH_PCIE_CAP_LINK_L0S | ATH_PCIE_CAP_LINK_L1);
-	pci_write_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, aspm);
+	pci_read_config_byte(pdev, pos + PCI_EXP_LNKCTL, &aspm);
+	aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
+	pci_write_config_byte(pdev, pos +  PCI_EXP_LNKCTL, aspm);
 }
 
 static void ath_pci_extn_synch_enable(struct ath_common *common)
@@ -128,6 +131,7 @@ static void ath_pci_check_aspm(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	struct pci_dev *pdev = to_pci_dev(sc->dev);
 	struct pci_dev *parent;
+	int ppos;
 	u8 aspm;
 
 	ah->aspm_enabled = false;
@@ -139,8 +143,9 @@ static void ath_pci_check_aspm(struct ath_softc *sc)
 	if (WARN_ON(!parent))
 		return;
 
-	pci_read_config_byte(parent, ATH_PCIE_CAP_LINK_CTRL, &aspm);
-	if (aspm & (ATH_PCIE_CAP_LINK_L0S | ATH_PCIE_CAP_LINK_L1))
+	ppos = pci_pcie_cap(parent);
+	pci_read_config_byte(parent, ppos +  PCI_EXP_LNKCTL, &aspm);
+	if (aspm & (PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1))
 		ah->aspm_enabled = true;
 }
 
-- 
1.7.1

