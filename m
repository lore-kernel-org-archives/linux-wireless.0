Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13520 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab1F2TkH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 15:40:07 -0400
Subject: [PATCH 2/2] ath5k: fix incorrect use of drvdata in PCI
 suspend/resume code
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 29 Jun 2011 15:39:43 -0400
Message-ID: <20110629193943.4948.64235.stgit@mj.roinet.com> (sfid-20110629_214012_746640_EEC2D0A1)
In-Reply-To: <20110629193937.4948.39075.stgit@mj.roinet.com>
References: <20110629193937.4948.39075.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
Cc: <stable@kernel.org>
---
 drivers/net/wireless/ath/ath5k/pci.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index 296c316..f2c0c23 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -297,7 +297,9 @@ ath5k_pci_remove(struct pci_dev *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int ath5k_pci_suspend(struct device *dev)
 {
-	struct ath5k_softc *sc = pci_get_drvdata(to_pci_dev(dev));
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ath5k_softc *sc = hw->priv;
 
 	ath5k_led_off(sc);
 	return 0;
@@ -306,7 +308,8 @@ static int ath5k_pci_suspend(struct device *dev)
 static int ath5k_pci_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct ath5k_softc *sc = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ath5k_softc *sc = hw->priv;
 
 	/*
 	 * Suspend/Resume resets the PCI configuration space, so we have to
