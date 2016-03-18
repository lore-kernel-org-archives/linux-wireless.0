Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34898 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcCRCY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:24:58 -0400
Received: by mail-pf0-f180.google.com with SMTP id n5so145969685pfn.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:24:58 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Jia-Ju Bai <baijiaju1990@163.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 11/19] rtl818x_pci: Disable pci device in error handling code
Date: Fri, 18 Mar 2016 13:24:51 +1100
Message-Id: <f8e04ad398fbbfea403459aa1c1cd6515eeff297.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032502_102552_CF5846F0)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jia-Ju Bai <baijiaju1990@163.com>

When pci_request_regions in rtl8180_probe fails, pci_disable_device is not
called to disable the device which is enabled by pci_enbale_device.

This patch fixes the problem by adding a new lable in error handling code.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
Acked-by: Andrea Merello <andrea.merello@gmail.com>
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index a43a16f..c76af5d 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -1736,7 +1736,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	if (err) {
 		printk(KERN_ERR "%s (rtl8180): Cannot obtain PCI resources\n",
 		       pci_name(pdev));
-		return err;
+		goto err_disable_dev;
 	}
 
 	io_addr = pci_resource_start(pdev, 0);
@@ -1938,6 +1938,8 @@ static int rtl8180_probe(struct pci_dev *pdev,
 
  err_free_reg:
 	pci_release_regions(pdev);
+
+ err_disable_dev:
 	pci_disable_device(pdev);
 	return err;
 }
-- 
2.7.0

