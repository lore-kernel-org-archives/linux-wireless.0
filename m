Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52707 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab1EFTCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 15:02:49 -0400
Date: Fri, 06 May 2011 14:02:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192se: Remove need to disable ASPM
Message-ID: <4dc445d8.qNuBQj9x5elLlNec%Larry.Finger@lwfinger.net> (sfid-20110506_210258_965537_13E1F01A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming Li <chaoming_li@realsil.com.cn>

When this driver was initially submitted, the system would crash unless
ASPM was disabled. This problem has been fixed.

This patch also adds a printk that outputs the name of the firmware
file that is used.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.40 material.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -1611,6 +1611,7 @@ static bool _rtl_pci_find_adapter(struct
 	u16 irqline;
 	u8 tmp;
 
+	pcipriv->ndis_adapter.pcibridge_vendor = PCI_BRIDGE_VENDOR_UNKNOWN;
 	venderid = pdev->vendor;
 	deviceid = pdev->device;
 	pci_read_config_byte(pdev, 0x8, &revisionid);
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -58,7 +58,7 @@ static void rtl92s_init_aspm_vars(struct
 	 * 4 - Always Enable ASPM without Clock Req.
 	 * set defult to RTL8192CE:3 RTL8192E:2
 	 * */
-	rtlpci->const_pci_aspm = 0; /* changed from 2 due to crashes */
+	rtlpci->const_pci_aspm = 2; /* changed from 2 due to crashes */
 
 	/*Setting for PCI-E device */
 	rtlpci->const_devicepci_aspm_setting = 0x03;
@@ -183,6 +183,8 @@ static int rtl92s_init_sw_vars(struct ie
 		return 1;
 	}
 
+	printk(KERN_INFO "rtl8192se: Driver for Realtek RTL8192SE/RTL8191SE\n"
+	       "           Loading firmware %s\n", rtlpriv->cfg->fw_name);
 	/* request fw */
 	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
 			rtlpriv->io.dev);

