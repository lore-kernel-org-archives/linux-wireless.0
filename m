Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54657 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab2JCTIF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 15:08:05 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.7 1/3] ath9k: fix ASPM initialization on resume
Date: Wed,  3 Oct 2012 21:07:50 +0200
Message-Id: <1349291272-93080-1-git-send-email-nbd@openwrt.org> (sfid-20121003_210811_996155_1BA7E200)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_pci_aspm_init is only called on card init, so PCI registers get reset
after a suspend/resume cycle.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index c0c5996..ea1d59e 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -333,6 +333,9 @@ static int ath_pci_suspend(struct device *device)
 static int ath_pci_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	u32 val;
 
 	/*
@@ -344,6 +347,8 @@ static int ath_pci_resume(struct device *device)
 	if ((val & 0x0000ff00) != 0)
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
+	ath_pci_aspm_init(common);
+
 	return 0;
 }
 
-- 
1.7.9.6 (Apple Git-31.1)

