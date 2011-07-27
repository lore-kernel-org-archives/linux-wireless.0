Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab1G0MNz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 08:13:55 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC/RFT v2 06/12] ath9k: init PCIe PM and SERDES registers if ASPM is enabled
Date: Wed, 27 Jul 2011 14:14:53 +0200
Message-Id: <1311768899-4559-7-git-send-email-sgruszka@redhat.com> (sfid-20110727_141420_333555_201480CD)
In-Reply-To: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
References: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During init, we currently skip calling ->config_pci_powersave() because
ah->aspm_enabled is not initialized. Fix that and initialize registers
after we discover if ASPM is enabled.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    5 +----
 drivers/net/wireless/ath/ath9k/pci.c |    5 ++++-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4ef7313..7084bb5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -595,10 +595,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 
 	ath9k_hw_init_mode_regs(ah);
 
-
-	if (ah->is_pciexpress)
-		ath9k_hw_configpcipowersave(ah, false);
-	else
+	if (!ah->is_pciexpress)
 		ath9k_hw_disablepcie(ah);
 
 	if (!AR_SREV_9300_20_OR_LATER(ah))
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 16ff992..494ec0f 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -148,8 +148,11 @@ static void ath_pci_aspm_init(struct ath_softc *sc)
 
 	ppos = pci_pcie_cap(parent);
 	pci_read_config_byte(parent, ppos +  PCI_EXP_LNKCTL, &aspm);
-	if (aspm & (PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1))
+	if (aspm & (PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1)) {
 		ah->aspm_enabled = true;
+		/* Initialize PCIe PM and SERDES registers. */
+		ath9k_hw_configpcipowersave(ah, false);
+	}
 }
 
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-- 
1.7.1

