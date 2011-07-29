Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61631 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1G2PxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 11:53:14 -0400
Date: Fri, 29 Jul 2011 10:53:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: liao.hubertt@gmail.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix kernel oops on ARM SOC
Message-ID: <4e32d768.rwWPDWLrMCef6f5m%Larry.Finger@lwfinger.net> (sfid-20110729_175317_308437_AD67C7DF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver uses information from the self member of the pci_bus struct to
get information regarding the bridge to which the PCIe device is attached.
Unfortunately, this member is not established on all architectures, which
leads to a kernel oops.

Skipping the entire block that uses the self member to determine the bridge
vendor will only affect RTL8192DE devices as that driver sets the ASPM support
flag differently when the bridge vendor is Intel. If the self member is
available, there is no functional change.

This patch fixes Bugzilla No. 40212.

Reported-by: Hubert Liao <liao.hubertt@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org> [back to 2.6.38]
---


Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -1696,15 +1696,17 @@ static bool _rtl_pci_find_adapter(struct
 	pcipriv->ndis_adapter.devnumber = PCI_SLOT(pdev->devfn);
 	pcipriv->ndis_adapter.funcnumber = PCI_FUNC(pdev->devfn);
 
-	/*find bridge info */
-	pcipriv->ndis_adapter.pcibridge_vendorid = bridge_pdev->vendor;
-	for (tmp = 0; tmp < PCI_BRIDGE_VENDOR_MAX; tmp++) {
-		if (bridge_pdev->vendor == pcibridge_vendors[tmp]) {
-			pcipriv->ndis_adapter.pcibridge_vendor = tmp;
-			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				 ("Pci Bridge Vendor is found index: %d\n",
-				  tmp));
-			break;
+	if (bridge_pdev) {
+		/*find bridge info if available */
+		pcipriv->ndis_adapter.pcibridge_vendorid = bridge_pdev->vendor;
+		for (tmp = 0; tmp < PCI_BRIDGE_VENDOR_MAX; tmp++) {
+			if (bridge_pdev->vendor == pcibridge_vendors[tmp]) {
+				pcipriv->ndis_adapter.pcibridge_vendor = tmp;
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+					 ("Pci Bridge Vendor is found index:"
+					 " %d\n", tmp));
+				break;
+			}
 		}
 	}
 
