Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24410 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751753AbdALNPX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 08:15:23 -0500
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 12/13] wil6210: set dma mask to reflect device capability
Date: Thu, 12 Jan 2017 15:06:04 +0200
Message-Id: <1484226365-10433-13-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170112_141541_642698_57FBA11D)
In-Reply-To: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484226365-10433-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

11ad device supports 48 bit addresses, reflect that
by setting the dma mask accordingly.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index e891068..3a63e98 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -205,6 +205,19 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENODEV;
 	}
 
+	/* device supports 48bit addresses */
+	rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
+	if (rc) {
+		dev_err(dev, "dma_set_mask_and_coherent(48) failed: %d\n", rc);
+		rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+		if (rc) {
+			dev_err(dev,
+				"dma_set_mask_and_coherent(32) failed: %d\n",
+				rc);
+			return rc;
+		}
+	}
+
 	wil = wil_if_alloc(dev);
 	if (IS_ERR(wil)) {
 		rc = (int)PTR_ERR(wil);
-- 
1.9.1
