Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:56175 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab0E1KJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 06:09:03 -0400
Subject: [PATCH] ath5k: disable ASPM
To: ath5k-devel@lists.ath5k.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 May 2010 13:09:01 +0300
Message-ID: <20100528100901.14580.1322.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Atheros card on Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well with ASPM
enabled. With ASPM ath5k will eventually stall on heavy traffic with often
'unsupported jumbo' warnings appearing. Disabling ASPM L0s/L1 in ath5k fixes
these problems.

Reproduced with pcie_aspm=force and by using 'nc < /dev/zero > /dev/null' at
both ends (usually stalls within seconds).

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/ath/ath5k/base.c |   48 +++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index cc6d41d..ce9c983 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -48,6 +48,7 @@
 #include <linux/netdevice.h>
 #include <linux/cache.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/ethtool.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
@@ -195,6 +196,8 @@ static const struct ieee80211_rate ath5k_rates[] = {
 static int __devinit	ath5k_pci_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id);
 static void __devexit	ath5k_pci_remove(struct pci_dev *pdev);
+static void		__ath5k_disable_aspm(struct pci_dev *pdev, u16 state);
+static void		ath5k_disable_aspm(struct pci_dev *pdev, u16 state);
 #ifdef CONFIG_PM
 static int		ath5k_pci_suspend(struct device *dev);
 static int		ath5k_pci_resume(struct device *dev);
@@ -424,6 +427,47 @@ module_exit(exit_ath5k_pci);
 * PCI Initialization *
 \********************/
 
+#ifdef CONFIG_PCIEASPM
+static void __ath5k_disable_aspm(struct pci_dev *pdev, u16 state)
+{
+	pci_disable_link_state(pdev, state);
+}
+#else
+static void __ath5k_disable_aspm(struct pci_dev *pdev, u16 state)
+{
+	int pos;
+	u16 reg16;
+
+	/*
+	 * Both device and parent should have the same ASPM setting.
+	 * Disable ASPM in downstream component first and then upstream.
+	 */
+	pos = pci_pcie_cap(pdev);
+	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
+	reg16 &= ~state;
+	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
+
+	if (!pdev->bus->self)
+		return;
+
+	pos = pci_pcie_cap(pdev->bus->self);
+	pci_read_config_word(pdev->bus->self, pos + PCI_EXP_LNKCTL, &reg16);
+	reg16 &= ~state;
+	pci_write_config_word(pdev->bus->self, pos + PCI_EXP_LNKCTL, reg16);
+}
+#endif
+static void ath5k_disable_aspm(struct pci_dev *pdev, u16 state)
+{
+	if (!pdev->is_pcie)
+		return;
+
+	dev_info(&pdev->dev, "Disabling ASPM %s%s\n",
+		 (state & PCIE_LINK_STATE_L0S) ? "L0s " : "",
+		 (state & PCIE_LINK_STATE_L1) ? "L1" : "");
+
+	__ath5k_disable_aspm(pdev, state);
+}
+
 static const char *
 ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val)
 {
@@ -473,6 +517,8 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	int ret;
 	u8 csz;
 
+	ath5k_disable_aspm(pdev, PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_L0S);
+
 	ret = pci_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "can't enable device\n");
@@ -725,6 +771,8 @@ static int ath5k_pci_resume(struct device *dev)
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath5k_softc *sc = hw->priv;
 
+	ath5k_disable_aspm(pdev, PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_L0S);
+
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to
 	 * re-disable the RETRY_TIMEOUT register (0x41) to keep

