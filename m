Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:52973 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbXIPMI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:08:29 -0400
Received: by an-out-0708.google.com with SMTP id d31so189208and
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:08:28 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 18/24] rt2x00: Merge allocation/free register components
Date: Sun, 16 Sep 2007 14:19:18 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161419.19810.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The csr, eeprom and rf register components are always
allocated and freed at the same locations.
It will be easier if the 3 allocation and the 3 free functions
are merged into a single allocation and single free function
which can be used everywhere.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00pci.c |  105 +++++++++----------------------
 drivers/net/wireless/rt2x00/rt2x00usb.c |   97 ++++++++--------------------
 2 files changed, 59 insertions(+), 143 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index f61cc7f..85629f1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -286,56 +286,45 @@ EXPORT_SYMBOL_GPL(rt2x00pci_uninitialize);
 /*
  * PCI driver handlers.
  */
-static int rt2x00pci_alloc_csr(struct rt2x00_dev *rt2x00dev)
+static void rt2x00pci_free_reg(struct rt2x00_dev *rt2x00dev)
 {
-	struct pci_dev *pci_dev = rt2x00dev_pci(rt2x00dev);
-
-	rt2x00dev->csr_addr = ioremap(pci_resource_start(pci_dev, 0),
-				      pci_resource_len(pci_dev, 0));
-	if (!rt2x00dev->csr_addr) {
-		ERROR(rt2x00dev, "Ioremap failed.\n");
-		return -ENOMEM;
-	}
+	kfree(rt2x00dev->rf);
+	rt2x00dev->rf = NULL;
 
-	return 0;
-}
+	kfree(rt2x00dev->eeprom);
+	rt2x00dev->eeprom = NULL;
 
-static void rt2x00pci_free_csr(struct rt2x00_dev *rt2x00dev)
-{
 	if (rt2x00dev->csr_addr) {
 		iounmap(rt2x00dev->csr_addr);
 		rt2x00dev->csr_addr = NULL;
 	}
 }
 
-static int rt2x00pci_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
+static int rt2x00pci_alloc_reg(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00dev->eeprom = kzalloc(rt2x00dev->ops->eeprom_size, GFP_KERNEL);
-	if (!rt2x00dev->eeprom)
-		return -ENOMEM;
+	struct pci_dev *pci_dev = rt2x00dev_pci(rt2x00dev);
 
-	return 0;
-}
+	rt2x00dev->csr_addr = ioremap(pci_resource_start(pci_dev, 0),
+				      pci_resource_len(pci_dev, 0));
+	if (!rt2x00dev->csr_addr)
+		goto exit;
 
-static void rt2x00pci_free_eeprom(struct rt2x00_dev *rt2x00dev)
-{
-	kfree(rt2x00dev->eeprom);
-	rt2x00dev->eeprom = NULL;
-}
+	rt2x00dev->eeprom = kzalloc(rt2x00dev->ops->eeprom_size, GFP_KERNEL);
+	if (!rt2x00dev->eeprom)
+		goto exit;
 
-static int rt2x00pci_alloc_rf(struct rt2x00_dev *rt2x00dev)
-{
 	rt2x00dev->rf = kzalloc(rt2x00dev->ops->rf_size, GFP_KERNEL);
 	if (!rt2x00dev->rf)
-		return -ENOMEM;
+		goto exit;
 
 	return 0;
-}
 
-static void rt2x00pci_free_rf(struct rt2x00_dev *rt2x00dev)
-{
-	kfree(rt2x00dev->rf);
-	rt2x00dev->rf = NULL;
+exit:
+	ERROR_PROBE("Failed to allocate registers.\n");
+
+	rt2x00pci_free_reg(rt2x00dev);
+
+	return -ENOMEM;
 }
 
 int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
@@ -383,32 +372,18 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
 
-	retval = rt2x00pci_alloc_csr(rt2x00dev);
+	retval = rt2x00pci_alloc_reg(rt2x00dev);
 	if (retval)
 		goto exit_free_device;
 
-	retval = rt2x00pci_alloc_eeprom(rt2x00dev);
-	if (retval)
-		goto exit_free_csr;
-
-	retval = rt2x00pci_alloc_rf(rt2x00dev);
-	if (retval)
-		goto exit_free_eeprom;
-
 	retval = rt2x00lib_probe_dev(rt2x00dev);
 	if (retval)
-		goto exit_free_rf;
+		goto exit_free_reg;
 
 	return 0;
 
-exit_free_rf:
-	rt2x00pci_free_rf(rt2x00dev);
-
-exit_free_eeprom:
-	rt2x00pci_free_eeprom(rt2x00dev);
-
-exit_free_csr:
-	rt2x00pci_free_csr(rt2x00dev);
+exit_free_reg:
+	rt2x00pci_free_reg(rt2x00dev);
 
 exit_free_device:
 	ieee80211_free_hw(hw);
@@ -435,9 +410,7 @@ void rt2x00pci_remove(struct pci_dev *pci_dev)
 	 * Free all allocated data.
 	 */
 	rt2x00lib_remove_dev(rt2x00dev);
-	rt2x00pci_free_rf(rt2x00dev);
-	rt2x00pci_free_eeprom(rt2x00dev);
-	rt2x00pci_free_csr(rt2x00dev);
+	rt2x00pci_free_reg(rt2x00dev);
 	ieee80211_free_hw(hw);
 
 	/*
@@ -460,9 +433,7 @@ int rt2x00pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	if (retval)
 		return retval;
 
-	rt2x00pci_free_rf(rt2x00dev);
-	rt2x00pci_free_eeprom(rt2x00dev);
-	rt2x00pci_free_csr(rt2x00dev);
+	rt2x00pci_free_reg(rt2x00dev);
 
 	pci_save_state(pci_dev);
 	pci_disable_device(pci_dev);
@@ -483,32 +454,18 @@ int rt2x00pci_resume(struct pci_dev *pci_dev)
 		return -EIO;
 	}
 
-	retval = rt2x00pci_alloc_csr(rt2x00dev);
+	retval = rt2x00pci_alloc_reg(rt2x00dev);
 	if (retval)
 		return retval;
 
-	retval = rt2x00pci_alloc_eeprom(rt2x00dev);
-	if (retval)
-		goto exit_free_csr;
-
-	retval = rt2x00pci_alloc_rf(rt2x00dev);
-	if (retval)
-		goto exit_free_eeprom;
-
 	retval = rt2x00lib_resume(rt2x00dev);
 	if (retval)
-		goto exit_free_rf;
+		goto exit_free_reg;
 
 	return 0;
 
-exit_free_rf:
-	rt2x00pci_free_rf(rt2x00dev);
-
-exit_free_eeprom:
-	rt2x00pci_free_eeprom(rt2x00dev);
-
-exit_free_csr:
-	rt2x00pci_free_csr(rt2x00dev);
+exit_free_reg:
+	rt2x00pci_free_reg(rt2x00dev);
 
 	return retval;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index ede3766..a0f05ca 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -432,49 +432,40 @@ EXPORT_SYMBOL_GPL(rt2x00usb_uninitialize);
 /*
  * USB driver handlers.
  */
-static int rt2x00usb_alloc_csr(struct rt2x00_dev *rt2x00dev)
+static void rt2x00usb_free_reg(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00dev->csr_cache = kzalloc(CSR_CACHE_SIZE, GFP_KERNEL);
-	if (!rt2x00dev->csr_cache)
-		return -ENOMEM;
+	kfree(rt2x00dev->rf);
+	rt2x00dev->rf = NULL;
 
-	return 0;
-}
+	kfree(rt2x00dev->eeprom);
+	rt2x00dev->eeprom = NULL;
 
-static void rt2x00usb_free_csr(struct rt2x00_dev *rt2x00dev)
-{
 	kfree(rt2x00dev->csr_cache);
 	rt2x00dev->csr_cache = NULL;
 }
 
-static int rt2x00usb_alloc_eeprom(struct rt2x00_dev *rt2x00dev)
+static int rt2x00usb_alloc_reg(struct rt2x00_dev *rt2x00dev)
 {
+	rt2x00dev->csr_cache = kzalloc(CSR_CACHE_SIZE, GFP_KERNEL);
+	if (!rt2x00dev->csr_cache)
+		goto exit;
+
 	rt2x00dev->eeprom = kzalloc(rt2x00dev->ops->eeprom_size, GFP_KERNEL);
 	if (!rt2x00dev->eeprom)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void rt2x00usb_free_eeprom(struct rt2x00_dev *rt2x00dev)
-{
-	kfree(rt2x00dev->eeprom);
-	rt2x00dev->eeprom = NULL;
-}
+		goto exit;
 
-static int rt2x00usb_alloc_rf(struct rt2x00_dev *rt2x00dev)
-{
 	rt2x00dev->rf = kzalloc(rt2x00dev->ops->rf_size, GFP_KERNEL);
 	if (!rt2x00dev->rf)
-		return -ENOMEM;
+		goto exit;
 
 	return 0;
-}
 
-static void rt2x00usb_free_rf(struct rt2x00_dev *rt2x00dev)
-{
-	kfree(rt2x00dev->rf);
-	rt2x00dev->rf = NULL;
+exit:
+	ERROR_PROBE("Failed to allocate registers.\n");
+
+	rt2x00usb_free_reg(rt2x00dev);
+
+	return -ENOMEM;
 }
 
 int rt2x00usb_probe(struct usb_interface *usb_intf,
@@ -502,32 +493,18 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
 
-	retval = rt2x00usb_alloc_csr(rt2x00dev);
+	retval = rt2x00usb_alloc_reg(rt2x00dev);
 	if (retval)
 		goto exit_free_device;
 
-	retval = rt2x00usb_alloc_eeprom(rt2x00dev);
-	if (retval)
-		goto exit_free_cr;
-
-	retval = rt2x00usb_alloc_rf(rt2x00dev);
-	if (retval)
-		goto exit_free_eeprom;
-
 	retval = rt2x00lib_probe_dev(rt2x00dev);
 	if (retval)
-		goto exit_free_rf;
+		goto exit_free_reg;
 
 	return 0;
 
-exit_free_rf:
-	rt2x00usb_free_rf(rt2x00dev);
-
-exit_free_eeprom:
-	rt2x00usb_free_eeprom(rt2x00dev);
-
-exit_free_cr:
-	rt2x00usb_free_csr(rt2x00dev);
+exit_free_reg:
+	rt2x00usb_free_reg(rt2x00dev);
 
 exit_free_device:
 	ieee80211_free_hw(hw);
@@ -550,9 +527,7 @@ void rt2x00usb_disconnect(struct usb_interface *usb_intf)
 	 * Free all allocated data.
 	 */
 	rt2x00lib_remove_dev(rt2x00dev);
-	rt2x00usb_free_rf(rt2x00dev);
-	rt2x00usb_free_eeprom(rt2x00dev);
-	rt2x00usb_free_csr(rt2x00dev);
+	rt2x00usb_free_reg(rt2x00dev);
 	ieee80211_free_hw(hw);
 
 	/*
@@ -574,9 +549,7 @@ int rt2x00usb_suspend(struct usb_interface *usb_intf, pm_message_t state)
 	if (retval)
 		return retval;
 
-	rt2x00usb_free_rf(rt2x00dev);
-	rt2x00usb_free_eeprom(rt2x00dev);
-	rt2x00usb_free_csr(rt2x00dev);
+	rt2x00usb_free_reg(rt2x00dev);
 
 	/*
 	 * Decrease usbdev refcount.
@@ -595,32 +568,18 @@ int rt2x00usb_resume(struct usb_interface *usb_intf)
 
 	usb_get_dev(interface_to_usbdev(usb_intf));
 
-	retval = rt2x00usb_alloc_csr(rt2x00dev);
+	retval = rt2x00usb_alloc_reg(rt2x00dev);
 	if (retval)
 		return retval;
 
-	retval = rt2x00usb_alloc_eeprom(rt2x00dev);
-	if (retval)
-		goto exit_free_csr;
-
-	retval = rt2x00usb_alloc_rf(rt2x00dev);
-	if (retval)
-		goto exit_free_eeprom;
-
 	retval = rt2x00lib_resume(rt2x00dev);
 	if (retval)
-		goto exit_free_rf;
+		goto exit_free_reg;
 
 	return 0;
 
-exit_free_rf:
-	rt2x00usb_free_rf(rt2x00dev);
-
-exit_free_eeprom:
-	rt2x00usb_free_eeprom(rt2x00dev);
-
-exit_free_csr:
-	rt2x00usb_free_csr(rt2x00dev);
+exit_free_reg:
+	rt2x00usb_free_reg(rt2x00dev);
 
 	return retval;
 }
-- 
1.5.3

