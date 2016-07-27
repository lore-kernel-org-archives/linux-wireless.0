Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47755 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbcG0PE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 11:04:56 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Remove driver log suggesting QCA9887 support is experimental
Date: Wed, 27 Jul 2016 20:34:56 +0530
Message-ID: <1469631896-9852-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160727_170459_661244_73B1009C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Support for QCA9887 is no longer experimental and if there are any issues
we need to address them

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index f06dd39..f3d943c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3144,7 +3144,6 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		pci_hard_reset = ath10k_pci_qca988x_chip_reset;
 		break;
 	case QCA9887_1_0_DEVICE_ID:
-		dev_warn(&pdev->dev, "QCA9887 support is still experimental, there are likely bugs. You have been warned.\n");
 		hw_rev = ATH10K_HW_QCA9887;
 		pci_ps = false;
 		pci_soft_reset = ath10k_pci_warm_reset;
-- 
1.9.1

