Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15703 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933377AbbLPMYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 07:24:16 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBGCMtuH029731
	for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 04:24:16 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yu7wpr03s-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 04:24:16 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/4] mwifiex: enable MSI interrupt support in pcie
Date: Wed, 16 Dec 2015 04:21:45 -0800
Message-ID: <1450268505-2682-4-git-send-email-akarwar@marvell.com> (sfid-20151216_132420_146667_FE33DE2B)
In-Reply-To: <1450268505-2682-1-git-send-email-akarwar@marvell.com>
References: <1450268505-2682-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Newer pcie devices (8897 onwards) support MSI. This
patch enables it.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 33 ++++++++++++++++++++++-------
 drivers/net/wireless/marvell/mwifiex/pcie.h |  1 +
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 21192b6..9703848 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2599,6 +2599,30 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
 	kfree(card);
 }
 
+static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
+{
+	int ret;
+	struct pcie_service_card *card = adapter->card;
+	struct pci_dev *pdev = card->dev;
+
+	if (pci_enable_msi(pdev) != 0)
+		pci_disable_msi(pdev);
+	else
+		card->msi_enable = 1;
+
+	mwifiex_dbg(adapter, INFO, "msi_enable = %d\n", card->msi_enable);
+
+	ret = request_irq(pdev->irq, mwifiex_pcie_interrupt, IRQF_SHARED,
+			  "MRVL_PCIE", pdev);
+	if (ret) {
+		pr_err("request_irq failed: ret=%d\n", ret);
+		adapter->card = NULL;
+		return -1;
+	}
+
+	return 0;
+}
+
 /*
  * This function registers the PCIE device.
  *
@@ -2606,21 +2630,14 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
  */
 static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 {
-	int ret;
 	struct pcie_service_card *card = adapter->card;
 	struct pci_dev *pdev = card->dev;
 
 	/* save adapter pointer in card */
 	card->adapter = adapter;
 
-	ret = request_irq(pdev->irq, mwifiex_pcie_interrupt, IRQF_SHARED,
-			  "MRVL_PCIE", pdev);
-	if (ret) {
-		mwifiex_dbg(adapter, ERROR,
-			    "request_irq failed: ret=%d\n", ret);
-		adapter->card = NULL;
+	if (mwifiex_pcie_request_irq(adapter))
 		return -1;
-	}
 
 	adapter->dev = &pdev->dev;
 	adapter->tx_buf_size = card->pcie.tx_buf_size;
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 347ba45..6fc2873 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -326,6 +326,7 @@ struct pcie_service_card {
 	dma_addr_t sleep_cookie_pbase;
 	void __iomem *pci_mmap;
 	void __iomem *pci_mmap1;
+	int msi_enable;
 };
 
 static inline int
-- 
1.8.1.4

