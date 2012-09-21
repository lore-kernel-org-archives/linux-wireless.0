Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2969 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab2IUSpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 14:45:32 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20572.46476.617076.695309@gargle.gargle.HOWL> (sfid-20120921_204537_193235_F824EB74)
Date: Sat, 22 Sep 2012 00:14:28 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <rodrigue@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: Disable ASPM only for AR9285
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, ASPM is disabled for all WLAN+BT combo chipsets
when BTCOEX is enabled. This is incorrect since the workaround
is required only for WB195, which is a AR9285+AR3011 combo
solution. Fix this by checking for the HW version when enabling
the workaround.

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index a8f6126..c0c5996 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -128,8 +128,9 @@ static void ath_pci_aspm_init(struct ath_common *common)
 	if (!parent)
 		return;
 
-	if (ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
-		/* Bluetooth coexistance requires disabling ASPM. */
+	if ((ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) &&
+	    (AR_SREV_9285(ah))) {
+		/* Bluetooth coexistance requires disabling ASPM for AR9285. */
 		pci_read_config_byte(pdev, pos + PCI_EXP_LNKCTL, &aspm);
 		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
 		pci_write_config_byte(pdev, pos + PCI_EXP_LNKCTL, aspm);
-- 
1.7.12

