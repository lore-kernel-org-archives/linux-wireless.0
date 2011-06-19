Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54831 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab1FSDty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 23:49:54 -0400
Date: Sat, 18 Jun 2011 22:49:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192se: Handle duplicate PCI ID 0x10ec:0x8192 conflict with r8192e_pci
Message-ID: <4dfd71e1.ZoVUM+vtSzINuBtU%Larry.Finger@lwfinger.net> (sfid-20110619_054958_195930_FD0F0FD4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are two devices with PCI ID 0x10ec:0x8192, namely RTL8192E and
RTL8192SE. The method of distinguishing them is by the revision ID
at offset 0x8 of the PCI configuration space. If the value is 0x10,
then the device uses rtl8192se for a driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch is for kernel 3.0.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -1615,6 +1615,16 @@ static bool _rtl_pci_find_adapter(struct
 	pci_read_config_byte(pdev, 0x8, &revisionid);
 	pci_read_config_word(pdev, 0x3C, &irqline);
 
+	/* PCI ID 0x10ec:0x8192 occurs for both RTL8192E, which uses
+	 * r8192e_pci, and RTL8192SE, which uses this driver. If the
+	 * revision ID is RTL_PCI_REVISION_ID_8192PCIE (0x01), then
+	 * the correct driver is r8192e_pci, thus this routine should
+	 * return false.
+	 */
+	if (deviceid == RTL_PCI_8192SE_DID &&
+	    revisionid == RTL_PCI_REVISION_ID_8192PCIE)
+		return false;
+
 	if (deviceid == RTL_PCI_8192_DID ||
 	    deviceid == RTL_PCI_0044_DID ||
 	    deviceid == RTL_PCI_0047_DID ||
@@ -1847,7 +1857,8 @@ int __devinit rtl_pci_probe(struct pci_d
 	pci_write_config_byte(pdev, 0x04, 0x07);
 
 	/* find adapter */
-	_rtl_pci_find_adapter(pdev, hw);
+	if (!_rtl_pci_find_adapter(pdev, hw))
+		goto fail3;
 
 	/* Init IO handler */
 	_rtl_pci_io_handler_init(&pdev->dev, hw);
