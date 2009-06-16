Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:36187 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754488AbZFPJDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 05:03:03 -0400
Date: Tue, 16 Jun 2009 11:59:23 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Subject: [PATCH] ath9k: Fix PCI FATAL interrupts by restoring RETRY_TIMEOUT
	disabling
Message-ID: <20090616085922.GA10176@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An earlier commit, b572b24c578ab1be9d1fcb11d2d8244878757a66, removed
code that was documented to disable RETRY_TIMEOUT register (PCI reg
0x41) since it was claimed to be a no-op. However, it turns out that
there are some combinations of hosts and ath9k-supported cards for
which this is not a no-op (reg 0x41 has value 0x80, not 0) and this
code (or something similar) is needed. In such cases, the driver may
be next to unusable due to very frequent PCI FATAL interrupts from the
card.

Reverting the earlier commit, i.e., restoring the RETRY_TIMEOUT
disabling, seems to resolve the issue. Since the removal of this code
was not based on any known issue and was purely a cleanup change, the
safest option here is to just revert that commit. Should there be
desire to clean this up in the future, the change will need to be
tested with a more complete coverage of cards and host systems.

Cc: stable@kernel.org
Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/pci.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

This issue was a regression in 2.6.30 and this patch should be applied
to wireless-testing.git and 2.6.31 as-is and to a 2.6.30.x stable
release as-is but without the "ath/" subdirectory on the path.

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/pci.c	2009-06-16 11:38:16.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/pci.c	2009-06-16 11:38:29.000000000 +0300
@@ -87,6 +87,7 @@ static int ath_pci_probe(struct pci_dev 
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
 	u8 csz;
+	u32 val;
 	int ret = 0;
 	struct ath_hw *ah;
 
@@ -133,6 +134,14 @@ static int ath_pci_probe(struct pci_dev 
 
 	pci_set_master(pdev);
 
+	/*
+	 * Disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state.
+	 */
+	pci_read_config_dword(pdev, 0x40, &val);
+	if ((val & 0x0000ff00) != 0)
+		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
+
 	ret = pci_request_region(pdev, 0, "ath9k");
 	if (ret) {
 		dev_err(&pdev->dev, "PCI memory region reserve error\n");
@@ -239,12 +248,21 @@ static int ath_pci_resume(struct pci_dev
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	u32 val;
 	int err;
 
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
 	pci_restore_state(pdev);
+	/*
+	 * Suspend/Resume resets the PCI configuration space, so we have to
+	 * re-disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state
+	 */
+	pci_read_config_dword(pdev, 0x40, &val);
+	if ((val & 0x0000ff00) != 0)
+		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
 	/* Enable LED */
 	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,

-- 
Jouni Malinen                                            PGP id EFC895FA
