Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:55180 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113Ab3GWCTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:19:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 10/21] mwifiex: add PCIe shutdown handler to avoid system hang on reboot
Date: Mon, 22 Jul 2013 19:17:47 -0700
Message-ID: <1374545878-15683-11-git-send-email-bzhao@marvell.com> (sfid-20130723_041921_023060_5E87355D)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

If reboot command is issued when device is in connected state,
system hangs while booting. This issue is fixed by doing cleanup
in shutdown handler.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 4a57eb4..dce6486 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -235,6 +235,14 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	kfree(card);
 }
 
+static void mwifiex_pcie_shutdown(struct pci_dev *pdev)
+{
+	user_rmmod = 1;
+	mwifiex_pcie_remove(pdev);
+
+	return;
+}
+
 static DEFINE_PCI_DEVICE_TABLE(mwifiex_ids) = {
 	{
 		PCIE_VENDOR_ID_MARVELL, PCIE_DEVICE_ID_MARVELL_88W8766P,
@@ -268,6 +276,7 @@ static struct pci_driver __refdata mwifiex_pcie = {
 		.pm = &mwifiex_pcie_pm_ops,
 	},
 #endif
+	.shutdown = mwifiex_pcie_shutdown,
 };
 
 /*
-- 
1.8.2.3

