Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57141 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1F0RuU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 13:50:20 -0400
Received: by pvg12 with SMTP id 12so2995075pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 10:50:20 -0700 (PDT)
From: Jon Mason <jdmason@kudzu.us>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 19/19] rtlwifi: remove unnecessary read of PCI_CAP_ID_EXP
Date: Mon, 27 Jun 2011 12:50:14 -0500
Message-Id: <1309197014-16391-1-git-send-email-jdmason@kudzu.us> (sfid-20110627_195027_208499_DAFCA287)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCIE capability offset is saved during PCI bus walking.  It will
remove an unnecessary search in the PCI configuration space if this
value is referenced instead of reacquiring it.

Also, remove unnecessary and unused #defines for PCI.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
---
 drivers/net/wireless/rtlwifi/pci.c |    2 +-
 drivers/net/wireless/rtlwifi/pci.h |    5 -----
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index ad39af4..63501a1 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -390,7 +390,7 @@ static void rtl_pci_parse_configuration(struct pci_dev *pdev,
 	u8 linkctrl_reg;
 
 	/*Link Control Register */
-	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
+	pos = pci_pcie_cap(pdev);
 	pci_read_config_byte(pdev, pos + PCI_EXP_LNKCTL, &linkctrl_reg);
 	pcipriv->ndis_adapter.linkctrl_reg = linkctrl_reg;
 
diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
index 671b1f5..76f4200 100644
--- a/drivers/net/wireless/rtlwifi/pci.h
+++ b/drivers/net/wireless/rtlwifi/pci.h
@@ -75,11 +75,6 @@
 #define PCI_CONF_ADDRESS	0x0CF8	/*PCI Configuration Space Address */
 #define PCI_CONF_DATA		0x0CFC	/*PCI Configuration Space Data */
 
-#define PCI_CLASS_BRIDGE_DEV		0x06
-#define PCI_SUBCLASS_BR_PCI_TO_PCI	0x04
-#define PCI_CAPABILITY_ID_PCI_EXPRESS	0x10
-#define PCI_CAP_ID_EXP			0x10
-
 #define U1DONTCARE			0xFF
 #define U2DONTCARE			0xFFFF
 #define U4DONTCARE			0xFFFFFFFF
-- 
1.7.5.4

