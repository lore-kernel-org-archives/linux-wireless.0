Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:60429 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756375Ab3DWXwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 19:52:34 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.10 1/4] mwifiex: Use pci_release_region() instead of a pci_release_regions()
Date: Tue, 23 Apr 2013 16:49:47 -0700
Message-ID: <1366760990-15748-2-git-send-email-bzhao@marvell.com> (sfid-20130424_015237_239721_579CC85E)
In-Reply-To: <1366760990-15748-1-git-send-email-bzhao@marvell.com>
References: <1366760990-15748-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

PCI regions are associated with the device using
pci_request_region() call. Hence use pci_release_region()
instead of pci_release_regions().

Cc: <stable@vger.kernel.org> # 3.2+
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 80f282c..fec2a61 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -2294,8 +2294,8 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
 	if (pdev) {
 		pci_iounmap(pdev, card->pci_mmap);
 		pci_iounmap(pdev, card->pci_mmap1);
-
-		pci_release_regions(pdev);
+		pci_release_region(pdev, 2);
+		pci_release_region(pdev, 0);
 		pci_disable_device(pdev);
 		pci_set_drvdata(pdev, NULL);
 	}
-- 
1.7.0.2

