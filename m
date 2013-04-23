Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:51339 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584Ab3DWXv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 19:51:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.10 2/4] mwifiex: Call pci_release_region after calling pci_disable_device
Date: Tue, 23 Apr 2013 16:49:48 -0700
Message-ID: <1366760990-15748-3-git-send-email-bzhao@marvell.com> (sfid-20130424_015200_902557_E3B1E400)
In-Reply-To: <1366760990-15748-1-git-send-email-bzhao@marvell.com>
References: <1366760990-15748-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

"drivers should call pci_release_region() AFTER
calling pci_disable_device()"

Please refer section 3.2 Request MMIO/IOP resources
in Documentation/PCI/pci.txt

Cc: <stable@vger.kernel.org> # 3.2+
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index fec2a61..b924e1d 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -2294,9 +2294,9 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
 	if (pdev) {
 		pci_iounmap(pdev, card->pci_mmap);
 		pci_iounmap(pdev, card->pci_mmap1);
+		pci_disable_device(pdev);
 		pci_release_region(pdev, 2);
 		pci_release_region(pdev, 0);
-		pci_disable_device(pdev);
 		pci_set_drvdata(pdev, NULL);
 	}
 }
-- 
1.7.0.2

