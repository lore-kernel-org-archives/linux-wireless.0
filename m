Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9028 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389266AbeG0WHO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 18:07:14 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2] PCI: Add PCI_DEVICE_DATA() macro to fully describe device ID entry
Date: Fri, 27 Jul 2018 23:43:37 +0300
Message-Id: <20180727204337.60767-1-andriy.shevchenko@linux.intel.com> (sfid-20180727_224343_455680_F8A46AC9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are a lot of examples in the kernel where PCI_VDEVICE() is used and still
looks not so convenient due to additional driver_data field attached.

Introduce PCI_DEVICE_DATA() macro to fully describe device ID entry in shortest
possible form. For example,

  before:

    { PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MRFLD),
      (kernel_ulong_t) &dwc3_pci_mrfld_properties, },

  after:

    { PCI_VDEVICE(INTEL, INTEL_MRFLD, &dwc3_pci_mrfld_properties },

Drivers can be converted later on in independent way.

While here, remove the unused macro with the same name
from Ralink wireless driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00pci.h |  6 ------
 include/linux/pci.h                            | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.h b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.h
index bc0ca5f58f38..283e2e607bba 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00pci.h
@@ -27,12 +27,6 @@
 #include <linux/io.h>
 #include <linux/pci.h>
 
-/*
- * This variable should be used with the
- * pci_driver structure initialization.
- */
-#define PCI_DEVICE_DATA(__ops)	.driver_data = (kernel_ulong_t)(__ops)
-
 /*
  * PCI driver handlers.
  */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d0961aefdbae..754da6f9adb3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -825,6 +825,21 @@ struct pci_driver {
 	.vendor = PCI_VENDOR_ID_##vend, .device = (dev), \
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID, 0, 0
 
+/**
+ * PCI_DEVICE_DATA - macro used to describe a specific PCI device in very short form
+ * @vend: the vendor name (without PCI_VENDOR_ID_ prefix)
+ * @dev: the device name (without PCI_DEVICE_ID_ prefix)
+ * @data: the driver data to be filled
+ *
+ * This macro is used to create a struct pci_device_id that matches a
+ * specific PCI device.  The subvendor, and subdevice fields will be set
+ * to PCI_ANY_ID.
+ */
+#define PCI_DEVICE_DATA(vend, dev, data) \
+	.vendor = PCI_VENDOR_ID_##vend, .device = PCI_DEVICE_ID_##dev, \
+	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID, 0, 0, \
+	.driver_data = (kernel_ulong_t)(data)
+
 enum {
 	PCI_REASSIGN_ALL_RSRC	= 0x00000001,	/* Ignore firmware setup */
 	PCI_REASSIGN_ALL_BUS	= 0x00000002,	/* Reassign all bus numbers */
-- 
2.18.0
