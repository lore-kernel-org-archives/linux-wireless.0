Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58778 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbZCLWSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 18:18:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Ben Cahill <ben.m.cahill@intel.com>,
	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v6 3/3] ath9k: remove dummy PCI "retry timeout" fix
Date: Thu, 12 Mar 2009 18:18:51 -0400
Message-Id: <1236896331-5026-4-git-send-email-lrodriguez@atheros.com> (sfid-20090312_231901_076743_A79EFAEF)
In-Reply-To: <1236896331-5026-1-git-send-email-lrodriguez@atheros.com>
References: <1236896331-5026-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the PCI retry timeout code as that was just taken from ipw2100
due to historical reasons but in reality its a no-op, additionally its
simply incorrect as each PCI devices has its own custom PCI configuration
space on PCI config space >= 0x40. Not to mention we were trying to write
0 to a place that already has 0 on it.

Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ben Cahill <ben.m.cahill@intel.com>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Tested-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath9k/pci.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath9k/pci.c b/drivers/net/wireless/ath9k/pci.c
index 9a58baa..53572d9 100644
--- a/drivers/net/wireless/ath9k/pci.c
+++ b/drivers/net/wireless/ath9k/pci.c
@@ -87,7 +87,6 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
 	u8 csz;
-	u32 val;
 	int ret = 0;
 	struct ath_hw *ah;
 
@@ -134,14 +133,6 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_master(pdev);
 
-	/*
-	 * Disable the RETRY_TIMEOUT register (0x41) to keep
-	 * PCI Tx retries from interfering with C3 CPU state.
-	 */
-	pci_read_config_dword(pdev, 0x40, &val);
-	if ((val & 0x0000ff00) != 0)
-		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
-
 	ret = pci_request_region(pdev, 0, "ath9k");
 	if (ret) {
 		dev_err(&pdev->dev, "PCI memory region reserve error\n");
@@ -253,21 +244,12 @@ static int ath_pci_resume(struct pci_dev *pdev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-	u32 val;
 	int err;
 
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
 	pci_restore_state(pdev);
-	/*
-	 * Suspend/Resume resets the PCI configuration space, so we have to
-	 * re-disable the RETRY_TIMEOUT register (0x41) to keep
-	 * PCI Tx retries from interfering with C3 CPU state
-	 */
-	pci_read_config_dword(pdev, 0x40, &val);
-	if ((val & 0x0000ff00) != 0)
-		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
 	/* Enable LED */
 	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,
-- 
1.6.0.6

