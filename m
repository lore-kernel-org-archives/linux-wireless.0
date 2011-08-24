Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57988 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1HXSPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 14:15:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: remove replicated null check in ath_pci_aspm_init
Date: Wed, 24 Aug 2011 14:08:41 -0400
Message-Id: <1314209321-23784-1-git-send-email-linville@tuxdriver.com> (sfid-20110824_201516_484174_E549E29A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index d704c8d..91c2e64 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -115,6 +115,8 @@ static void ath_pci_aspm_init(struct ath_common *common)
 		return;
 
 	parent = pdev->bus->self;
+	if (!parent)
+		return;
 
 	if (ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE) {
 		/* Bluetooth coexistance requires disabling ASPM. */
@@ -126,9 +128,6 @@ static void ath_pci_aspm_init(struct ath_common *common)
 		 * Both upstream and downstream PCIe components should
 		 * have the same ASPM settings.
 		 */
-		if (!parent)
-			return;
-
 		pos = pci_pcie_cap(parent);
 		pci_read_config_byte(parent, pos + PCI_EXP_LNKCTL, &aspm);
 		aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
@@ -137,9 +136,6 @@ static void ath_pci_aspm_init(struct ath_common *common)
 		return;
 	}
 
-	if (!parent)
-		return;
-
 	pos = pci_pcie_cap(parent);
 	pci_read_config_byte(parent, pos +  PCI_EXP_LNKCTL, &aspm);
 	if (aspm & (PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1)) {
-- 
1.7.4.4

