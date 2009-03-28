Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:54072 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759480AbZC1Twx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 15:52:53 -0400
Received: by ey-out-2122.google.com with SMTP id 4so441057eyf.37
        for <linux-wireless@vger.kernel.org>; Sat, 28 Mar 2009 12:52:49 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/4] rt2x00: Don't free register information on suspend
Date: Sat, 28 Mar 2009 20:51:58 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <200903282051.25112.IvDoorn@gmail.com> <200903282051.41343.IvDoorn@gmail.com>
In-Reply-To: <200903282051.41343.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903282051.58660.IvDoorn@gmail.com> (sfid-20090328_205311_671293_47B2B0EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After suspend & resume the rt2x00 devices won't wakeup
anymore due to a broken register information setup.
The most important problem is the release of the EEPROM
buffer which is completely cleared and never read again
after the suspend.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00pci.c |   18 +-----------------
 drivers/net/wireless/rt2x00/rt2x00usb.c |   18 +-----------------
 2 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index eef2761..01a3c49 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -377,8 +377,6 @@ int rt2x00pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	if (retval)
 		return retval;
 
-	rt2x00pci_free_reg(rt2x00dev);
-
 	pci_save_state(pci_dev);
 	pci_disable_device(pci_dev);
 	return pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state));
@@ -389,7 +387,6 @@ int rt2x00pci_resume(struct pci_dev *pci_dev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pci_dev);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	int retval;
 
 	if (pci_set_power_state(pci_dev, PCI_D0) ||
 	    pci_enable_device(pci_dev) ||
@@ -398,20 +395,7 @@ int rt2x00pci_resume(struct pci_dev *pci_dev)
 		return -EIO;
 	}
 
-	retval = rt2x00pci_alloc_reg(rt2x00dev);
-	if (retval)
-		return retval;
-
-	retval = rt2x00lib_resume(rt2x00dev);
-	if (retval)
-		goto exit_free_reg;
-
-	return 0;
-
-exit_free_reg:
-	rt2x00pci_free_reg(rt2x00dev);
-
-	return retval;
+	return rt2x00lib_resume(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00pci_resume);
 #endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 7d50ca8..5015448 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -702,8 +702,6 @@ int rt2x00usb_suspend(struct usb_interface *usb_intf, pm_message_t state)
 	if (retval)
 		return retval;
 
-	rt2x00usb_free_reg(rt2x00dev);
-
 	/*
 	 * Decrease usbdev refcount.
 	 */
@@ -717,24 +715,10 @@ int rt2x00usb_resume(struct usb_interface *usb_intf)
 {
 	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	int retval;
 
 	usb_get_dev(interface_to_usbdev(usb_intf));
 
-	retval = rt2x00usb_alloc_reg(rt2x00dev);
-	if (retval)
-		return retval;
-
-	retval = rt2x00lib_resume(rt2x00dev);
-	if (retval)
-		goto exit_free_reg;
-
-	return 0;
-
-exit_free_reg:
-	rt2x00usb_free_reg(rt2x00dev);
-
-	return retval;
+	return rt2x00lib_resume(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2x00usb_resume);
 #endif /* CONFIG_PM */
-- 
1.5.6.1

