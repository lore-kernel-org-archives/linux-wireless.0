Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:42788 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbcAPNDl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2016 08:03:41 -0500
From: Jia-Ju Bai <baijiaju1990@163.com>
To: andrea.merello@gmail.com, Larry.Finger@lwfinger.net,
	flamingice@sourmilk.net, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] rtl818x_pci: Disable pci device in error handling code
Date: Sat, 16 Jan 2016 21:02:58 +0800
Message-Id: <1452949379-16052-1-git-send-email-baijiaju1990@163.com> (sfid-20160116_140349_391686_2ACF1C28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When pci_request_regions in rtl8180_probe fails, pci_disable_device is not
called to disable the device which is enabled by pci_enbale_device.

This patch fixes the problem by adding a new lable in error handling code.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |    4 +++-
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
1.7.9.5


